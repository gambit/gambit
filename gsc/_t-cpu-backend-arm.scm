;;==============================================================================

;;; File: "_t-cpu-backend-arm.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_arm#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

;; Constants

(define arm-nb-gvm-regs 5)
(define arm-nb-arg-regs 3)

;;------------------------------------------------------------------------------
;;-------------------------------- ARM backend  --------------------------------
;;------------------------------------------------------------------------------

(define (arm-target)
  (make-cpu-target
    (arm-abstract-machine-info)
    'arm '((".c" . ARM)) arm-nb-gvm-regs arm-nb-arg-regs))

(define (arm-abstract-machine-info)
  (make-backend make-cgc-arm (arm-info) (arm-instructions) (arm-routines)))

(define (make-cgc-arm)
  (let ((cgc (make-codegen-context)))
    (codegen-context-listing-format-set! cgc 'gnu)
    (asm-init-code-block cgc 0 'le)
    (arm-arch-set! cgc 'thumb)
    cgc))

;;------------------------------------------------------------------------------

;; ARM backend info

(define (arm-info)
  (make-cpu-info
    'arm                   ;; Arch name
    4                      ;; Word width
    'le                    ;; Endianness
    #t                     ;; Load store architecture?
    0                      ;; Frame offset
    arm-primitive-table    ;; Primitive table
    arm-nb-gvm-regs        ;; GVM register count
    arm-nb-arg-regs        ;; GVM register count for passing arguments
    arm-registers          ;; Main registers
    (arm-r5)               ;; Processor state pointer
    (arm-r13)              ;; Stack pointer
    (arm-r6)               ;; Heap pointer
  ))

(define arm-registers
  (vector
    (arm-r0)  ;; R0
    (arm-r1)  ;; R1
    (arm-r2)  ;; R2
    (arm-r3)  ;; R3
    (arm-r4)  ;; R4
    ; (arm-r5)  ;; Processor state pointer
    ; (arm-r6)  ;; Heap pointer
    (arm-r7)  ;; Free register
    ; (arm-r8)
    ; (arm-r9)
    ; (arm-r10)
    ; (arm-r11)
    ; (arm-r12)
    ; (arm-r13) ;; Stack pointer
    ; (arm-r14) ;; Link register
    ; (arm-r15) ;; Program counter
  ))

;;------------------------------------------------------------------------------

;; ARM Abstract machine instructions

(define (arm-instructions)
  (make-instruction-dictionnary
    arm-label-align             ;; am-lbl
    arm-data-instr              ;; am-data
    arm-mov-instr               ;; am-mov
    arm-add-instr               ;; am-add
    arm-sub-instr               ;; am-sub
    arm-jmp-instr               ;; am-jmp
    arm-cmp-jump-instr          ;; am-compare-jump
    am-compare-move))           ;; am-compare-move

(define (make-arm-opnd opnd)
  (cond
    ((reg-opnd? opnd) opnd)
    ((int-opnd? opnd) (arm-imm-int (int-opnd-value opnd)))
    (else (compiler-internal-error "make-arm-opnd - Unknown opnd: " opnd))))

(define (arm-label-align cgc label-opnd #!optional (align #f))
  (if align
    (asm-align cgc (car align) (cdr align) 0)
    (asm-align cgc 4 0))
  (arm-label cgc (lbl-opnd-label label-opnd)))

(define arm-data-instr
  (make-am-data arm-db arm-dw arm-dd arm-dq))

;; Args : CGC, reg/mem/label, reg/mem/imm/label/glo
(define (arm-mov-instr cgc dst src #!optional (width #f))
  (define (with-reg fun)
    (if (reg-opnd? dst)
      (fun (make-arm-opnd dst))
      (get-free-register cgc (list dst src)
        (lambda (reg) (fun (make-arm-opnd reg))))))

  (define (unaligned-mem-opnd? mem-opnd)
    (not (= 0 (modulo (mem-opnd-offset mem-opnd) 4))))

  ;; new-src is either a register or a int-opnd of small value
  (define (regular-move new-src)
    (if (not (equal? dst new-src))
      (cond
        ((reg-opnd? dst)
          (arm-mov cgc (make-arm-opnd dst) new-src))
        ((mem-opnd? dst)
          (if (unaligned-mem-opnd? dst)
            (get-free-register cgc (list dst src new-src)
              (lambda (reg)
                (am-add cgc reg (mem-opnd-base dst) (int-opnd (mem-opnd-offset dst)))
                (arm-str cgc new-src reg 0)))
            (arm-str cgc new-src (mem-opnd-base dst) (mem-opnd-offset dst))))
        ((glo-opnd? dst)
          (get-free-register cgc (list dst src new-src)
            (lambda (reg)
              (arm-load-glo cgc reg (glo-opnd-name dst))
                (arm-str cgc new-src reg 0))))
        (else
          (compiler-internal-error
            "arm-mov-instr - Unknown or incompatible destination: " dst)))))

  (debug "arm-mov-instr: " dst " <= " src)

  (if (not (equal? dst src))
    (cond
      ((reg-opnd? src)
        (regular-move (make-arm-opnd src)))
      ((int-opnd? src)
        (with-reg
          (lambda (reg)
            (cond
              ((and (reg-opnd? reg) (in-range? 0 255 (int-opnd-value src)))
                (arm-mov cgc reg (make-arm-opnd src))
                (regular-move reg))
              ((and (reg-opnd? reg) (in-range? -255 0 (int-opnd-value src)))
                ;; Todo: Replace with movn
                (arm-mov cgc reg (make-arm-opnd (int-opnd-negative src)))
                (arm-neg cgc reg reg)
                (regular-move reg))
              (else
            (arm-load-imm cgc reg (int-opnd-value src))
                (regular-move reg))))))
      ((mem-opnd? src)
        (with-reg
          (lambda (reg)
            (if (unaligned-mem-opnd? src)
              (begin
                (am-add cgc reg (mem-opnd-base src) (int-opnd (mem-opnd-offset src)))
                (arm-ldr cgc reg reg 0)
                (regular-move reg))
              (begin
                (arm-ldr cgc reg (mem-opnd-base src) (mem-opnd-offset src))
                (regular-move reg))))))
      ((lbl-opnd? src)
        (with-reg
          (lambda (reg)
            (arm-load-label cgc reg src)
            (regular-move reg))))
      ((obj-opnd? src)
        (with-reg
          (lambda (reg)
            (arm-load-obj cgc reg (obj-opnd-value src))
            (regular-move reg))))
      ((glo-opnd? src)
        (with-reg
          (lambda (reg)
            (arm-load-glo cgc reg (glo-opnd-name src))
            (arm-ldr cgc dst dst 0)
            (regular-move reg))))
      (else
        (compiler-internal-error "Cannot move : " dst " <- " src)))))

(define (arm-add-instr cgc dest opnd1 opnd2)
  (define (with-dest-reg dst)
    (load-multiple-if-necessary cgc '((reg) (reg int)) (list opnd1 opnd2)
      (lambda (opnd1 opnd2)
        (cond
          ;; add sp, #imm9
          ((and (equal? dst opnd1) (arm-sp? dst) (int-opnd? opnd2))
            (if (in-range-aligned? 0 508 4 opnd2)
              (arm-add cgc dst opnd1 (make-arm-opnd opnd2))
              (if (in-range-aligned? 0 508 4 (int-opnd-negative opnd2))
                (arm-add cgc dst opnd1 (make-arm-opnd (int-opnd-negative opnd2)))
                (compiler-internal-error
                  "Can't add/sub from sp constants not multiples of 4 or larger than 508"))))

          ;; add rd, #imm8
          ((and (equal? dst opnd1)
                (in-range-aligned? 0 255 1 opnd2))
            (arm-add cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; add rd, rn, #imm3
          ((and (int-opnd? opnd2)
                (in-range? 0 7 (int-opnd-value opnd2)))
            (arm-add cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; add rd, rn, #imm
          ;; add rd, rn, rm
          (else
            (let ((use-reg
              (lambda (reg)
                (am-mov cgc reg opnd2)
                (arm-add cgc dst opnd1 reg))))

            (if (int-opnd? opnd2)
              (if (equal? dst opnd1)
                (get-free-register cgc (list) use-reg)
                (use-reg dst))
              (arm-add cgc dst opnd1 opnd2)))))
        (am-mov cgc dest dst))))

  (if (and (or (arm-sp? dest) (arm-sp? opnd1) (arm-sp? opnd2))
           (not (int-opnd? opnd2)))
    (compiler-internal-error "arm-sub-instr -- Can't substract register from sp"))

  (if (reg-opnd? dest)
    (with-dest-reg dest)
    (get-free-register cgc (list dest opnd1 opnd2) with-dest-reg)))

(define (arm-sub-instr cgc dest opnd1 opnd2)
  (define (with-dest-reg dst)
    (load-multiple-if-necessary cgc '((reg) (reg int)) (list opnd1 opnd2)
      (lambda (opnd1 opnd2)
        (cond
          ;; sub sp, #imm9
          ((and (equal? dst opnd1) (arm-sp? dst) (int-opnd? opnd2))
            (if (in-range-aligned? 0 508 4 opnd2)
              (arm-sub cgc dst opnd1 (make-arm-opnd opnd2))
              (if (in-range-aligned? 0 508 4 (int-opnd-negative opnd2))
                (arm-add cgc dst opnd1 (make-arm-opnd (int-opnd-negative opnd2)))
                (compiler-internal-error
                  "Can't add/sub from sp constants not multiples of 4 or larger than 508"))))

          ;; sub rd, #imm8
          ((and (equal? dst opnd1)
                (in-range-aligned? 0 255 1 opnd2))
            (arm-sub cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; sub rd, rn, #imm3
          ((and (int-opnd? opnd2)
                (in-range-aligned? 0 7 1 opnd2))
            (arm-sub cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; sub rd, rn, #imm
          ;; sub rd, rn, rm
          (else
            (let ((use-reg
              (lambda (reg)
                (if (int-opnd? opnd2)
                  (am-mov cgc reg (int-opnd-negative opnd2))
                  (arm-neg cgc reg opnd2))
                (arm-add cgc dst opnd1 reg))))

            (if (equal? dst opnd1)
              (get-free-register cgc (list) use-reg)
              (use-reg dst)))))
        (am-mov cgc dest dst))))

  (if (and (or (arm-sp? dest) (arm-sp? opnd1) (arm-sp? opnd2))
           (not (int-opnd? opnd2)))
    (compiler-internal-error "arm-sub-instr -- Can't substract register from sp"))

  (if (reg-opnd? dest)
    (with-dest-reg dest)
    (get-free-register cgc (list dest opnd1 opnd2) with-dest-reg)))

(define (arm-jmp-instr cgc opnd)
  (debug "arm-jmp-instr: " opnd)
  (if (lbl-opnd? opnd)
    (arm-b cgc (lbl-opnd-label opnd))
    (load-if-necessary cgc '(reg) opnd
      (lambda (opnd)
        (arm-bx cgc (make-arm-opnd opnd))))))

(define (arm-get-branch-conditions condition)
  (define (flip pair) (cons (cdr pair) (car pair)))
  (case (get-condition condition)
    ((equal)
      (cons (arm-cond-eq)  (arm-cond-ne)))
    ((greater)
      (cond
        ((and (cond-is-equal condition) (cond-is-signed condition))
          (cons (arm-cond-ge) (arm-cond-lt)))
        ((and (not (cond-is-equal condition)) (cond-is-signed condition))
          (cons (arm-cond-gt) (arm-cond-le)))
        ((and (cond-is-equal condition) (not (cond-is-signed condition)))
          (cons (arm-cond-hs) (arm-cond-lo)))
        ((and (not (cond-is-equal condition)) (not (cond-is-signed condition)))
          (cons (arm-cond-hi) (arm-cond-ls)))))
    ((not-equal) (flip (arm-get-branch-conditions (inverse-condition condition))))
    ((lesser) (flip (arm-get-branch-conditions (inverse-condition condition))))
    (else
      (compiler-internal-error "arm-get-branch-conditions - Unknown condition: " condition))))

(define (arm-cmp-jump-instr cgc condition opnd1 opnd2 loc-true loc-false #!optional (opnds-width #f))
    ;; In case both jump locations are false, the cmp is unnecessary.
    (if (or loc-true loc-false)
    (load-multiple-if-necessary cgc
      (list '(reg) reg-or-8imm-opnd?)
      (list opnd1 opnd2)
        (lambda (reg1 opnd2) (arm-cmp cgc reg1 (make-arm-opnd opnd2)))))

  (let* ((conds (arm-get-branch-conditions condition)))
    (cond
      ((and loc-false loc-true)
        (arm-b cgc (lbl-opnd-label loc-true) (car conds))
        (arm-b cgc (lbl-opnd-label loc-false)))
      ((and (not loc-true) loc-false)
        (arm-b cgc (lbl-opnd-label loc-false) (cdr conds)))
      ((and loc-true (not loc-false))
        (arm-b cgc (lbl-opnd-label loc-true) (car conds)))
      (else
        (debug "am-compare-jump: No jump encoded")))))

(define (arm-cmp-move-instr cgc condition dest opnd1 opnd2 true-opnd false-opnd #!optional (opnds-width #f))
  (compiler-internal-error "TODO: arm-cmp-move-instr"))

:; Todo: Deduplicate labels
(define (arm-load-label cgc rd label-opnd)
  (arm-load-data cgc rd
    (asm-label-id (lbl-opnd-label label-opnd))
    (lambda (cgc)
      (debug "label-opnd: " label-opnd)
      (let ((label (lbl-opnd-label label-opnd)))
        (codegen-fixup-lbl! cgc label object-tag #f 32 0 (asm-label-id label))))))

:; Todo: Deduplicate objects
(define (arm-load-obj cgc rd obj-value)
  (arm-load-data cgc rd #f
    (lambda (cgc)
      (debug "obj-value: " obj-value)
      (codegen-fixup-obj! cgc obj-value 32 0 'obj))))

:; Todo: Deduplicate immediates
(define (arm-load-imm cgc rd val)
  (arm-load-data cgc rd (number->string val)
    (lambda (cgc)
      (debug "imm value: " val)
      (am-data cgc 32 val))))

:; Todo: Deduplicate references to global variables
(define (arm-load-glo cgc rd glo-name)
  (arm-load-data cgc rd glo-name
    (lambda (cgc)
      (codegen-fixup-glo! cgc glo-name 32 0 (symbol-append 'glo_ glo-name)))))

(define (arm-load-data cgc rd ref-name place-data)
  (define (label-dist label self offset)
    (fx- (asm-label-pos label) (fx+ self offset)))

  (define label-data-opnd (make-unique-label cgc "label-data" #t))
  (define label-data (lbl-opnd-label label-data-opnd))
  (define label-data-sym (asm-label-id label-data))

  (add-delayed-action cgc (symbol-append 'arm-load-data__ label-data-sym) delayed-execute-never
    (lambda ()
      (asm-align cgc 4 0)
      (am-lbl cgc label-data-opnd)
      (place-data cgc)))

  (asm-at-assembly
    cgc
    (lambda (cgc self) 2)
    (lambda (cgc self)
      (let* ((dist (label-dist label-data self 4))
             (offset (fxarithmetic-shift-right dist 1)))

        (debug "offset: " offset)
        (debug "dist: " dist)
        (debug "(fx= 0 (fxmodulo offset 4)): " (fx= 0 (fxmodulo offset 4)))
        (debug "(fx<= offset 1023): " (fx<= offset 1023))
        (debug "label-data: " label-data)
        ; (if (or (not (fx= 0 (fxmodulo offset 2))) (fx> offset 1023))
        ;   (compiler-internal-error "Offset too big"))

        (asm-16-le cgc
          (fx+ (fxquotient offset 4)
                (fxarithmetic-shift-left (arm-reg-field rd) 8)
                #x0800
                #x4000))

        (arm-listing cgc "ldr.w" rd
          (string-append
            "[pc, #" (symbol->string label-data-sym)
            (if ref-name (string-append
              " (" (if (symbol? ref-name) (symbol->string ref-name) ref-name) ")")
              "")
            "]"))))))

;;------------------------------------------------------------------------------

;; Backend routines

(define (arm-routines)
  (make-routine-dictionnary
    arm-poll
    arm-set-nargs
    arm-check-nargs
    arm-check-nargs-simple
    arm-allocate-memory
    arm-place-extra-data))

(define (arm-poll cgc frame)
  (debug "arm-poll")
  (let* ((stack-trip (car (get-processor-state-field cgc 'stack-trip)))
         (temp1 (get-processor-state-field cgc 'temp1))
         (return-loc (make-unique-label cgc "return-from-overflow")))

    (am-compare-jump cgc
      (condition-lesser #f #f)
      (get-frame-pointer cgc) stack-trip
      #f return-loc)

    ;; Jump to handler
    (am-mov cgc (car temp1) return-loc (cdr temp1))
    (call-handler cgc 'handler_stack_limit frame return-loc)))

;; Nargs passing
(define (arm-set-nargs cgc arg-count)
  (debug "arm-set-narg: " arg-count)
  (let ((narg-field (get-processor-state-field cgc 'nargs)))
    (am-mov cgc (car narg-field) (int-opnd arg-count) (cdr narg-field))))

(define (arm-check-nargs cgc fun-label fs arg-count optional-args-values rest? place-label-fun)
  (define error-label (make-unique-label cgc "narg-error" #f))
  (debug "arm-check-narg: " arg-count)
  ;; Error handler
  (let ((temp1-field (get-processor-state-field cgc 'temp1))
        (narg-field (get-processor-state-field cgc 'nargs))
        (error-handler (get-processor-state-field cgc 'handler_wrong_nargs)))
    (am-lbl cgc error-label)
    (am-mov cgc (car temp1-field) fun-label (cdr temp1-field))
    (am-jmp cgc (car error-handler))

    (place-label-fun fun-label)

    (am-compare-jump cgc
      condition-not-equal
      (car narg-field) (int-opnd arg-count)
      error-label #f
      (cdr narg-field))))

(define bump-allocator-fudge-size 128)
(define (arm-allocate-memory cgc dest-reg bytes offset frame)
  (define (check-heap-limit)
    (let* ((heap-limit (car (get-processor-state-field cgc 'heap-limit)))
           (temp1 (get-processor-state-field cgc 'temp1))
           (return-lbl1 (make-unique-label cgc "call-gc"))
           (return-lbl2 (make-unique-label cgc "return-from-gc"))
           (return-lbl3 (make-unique-label cgc "resume-execution")))
      ;; Reset bytes allocated count
      (codegen-context-memory-allocated-set! cgc 0)

      (am-compare-jump cgc
        (condition-greater #f #f) ;; Not equal, because we can't exceed the fudge
        (get-heap-pointer cgc) heap-limit
        return-lbl1 #f)

      (am-lbl cgc return-lbl3)

      ;; Add internal return point after unconditional jump
      (add-delayed-action cgc 'heap-limit-check delayed-execute-never
        (lambda ()
          ;; Jump to handler
          (am-lbl cgc return-lbl1)
          (am-mov cgc (car temp1) return-lbl2 (cdr temp1))
          (call-handler cgc 'handler_heap_limit frame return-lbl2)
          (am-jmp cgc return-lbl3)))))

  (let* ((bytes-allocated (+ (codegen-context-memory-allocated cgc) bytes)))

    (codegen-context-memory-allocated-set! cgc bytes-allocated)

    (am-add cgc dest-reg (get-heap-pointer cgc) (int-opnd offset))
    (am-add cgc (get-heap-pointer cgc) (get-heap-pointer cgc) (int-opnd bytes))

    (if (>= bytes-allocated bump-allocator-fudge-size)
      (check-heap-limit)
      ;; Add delayed action to make sure the heap limit is tested before an
      ;; unconditional jump.
      (add-delayed-action-unique cgc 'heap-limit-check delayed-execute-always
        (lambda ()
          (if (> (codegen-context-memory-allocated cgc) 0)
            (check-heap-limit)))))))

(define (arm-place-extra-data cgc)
  (debug "arm-place-extra-data"))

;;------------------------------------------------------------------------------

;; Primitives

(define arm-prim-##fixnum?
  (const-nargs-prim 1 1 '((reg))
    (lambda (cgc result-action args arg1 temp1)
      (am-mov cgc temp1 (int-opnd (- tag-mult 1)))
      (arm-tst cgc arg1 temp1)
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-eq)))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define arm-prim-##pair?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd (- tag-mult 1)))
      (am-mov cgc temp2 arg1)       ;; Save arg1
      (arm-mvn cgc temp2 temp2)     ;; Invert bits
      (arm-tst cgc temp2 temp1)
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-eq)))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define arm-prim-##special?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd (- tag-mult 1)))
      (am-mov cgc temp2 arg1) ;; Save arg1
      (arm-and cgc temp2 temp1)
      (am-mov cgc temp1 (int-opnd special-int-tag))
      (arm-cmp cgc temp2 temp1)
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-eq)))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define arm-prim-##mem-allocated?
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 temp1)
      (am-mov cgc temp1 (int-opnd (bitwise-and object-tag pair-tag)))
      (arm-tst cgc arg1 temp1)
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-eq)))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define arm-prim-##cons
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
        (lambda (result-reg result-opnd-in-args)
          (let* ((word (get-word-width cgc))
                 (size (* word 3))
                 (tag 3)
                 (offset (+ tag (* 2 word))))

            (am-allocate-memory cgc result-reg size offset
              (codegen-context-frame cgc))

            (am-mov cgc
              (mem-opnd result-reg (- offset))
              (int-opnd (* (get-word-width cgc) 3))
              (get-word-width-bits cgc))

            (am-mov cgc
              (mem-opnd result-reg (- word offset))
              (cadr args)
              (get-word-width-bits cgc))

            (am-mov cgc
              (mem-opnd result-reg (- (* 2 word) offset))
              (car args)
              (get-word-width-bits cgc))

            (am-return-opnd cgc result-action result-reg))))))

(define arm-prim-##null?
  (lambda (cgc result-action args)
    (check-nargs-if-necessary cgc result-action 1)
    (call-with-nargs args
      (lambda (arg1)
        (am-if-eq cgc arg1 (make-obj-opnd '())
          (lambda (cgc) (am-return-const cgc result-action #t))
          (lambda (cgc) (am-return-const cgc result-action #f))
          #f
          (get-word-width-bits cgc))))))

(define (arm-stub-prim cgc . args) #f)

(define arm-primitive-table
  (let ((table (make-table test: equal?)))
    (table-set! table '##identity (make-prim-obj ##identity-primitive 1 #t #t))
    (table-set! table '##not      (make-prim-obj ##not-primitive 1 #t #t))

    (table-set! table '##fixnum?        (make-prim-obj arm-prim-##fixnum?        1 #t #t))
    (table-set! table '##special?       (make-prim-obj arm-prim-##special?       1 #t #t))
    (table-set! table '##pair?          (make-prim-obj arm-prim-##pair?          1 #t #t))
    (table-set! table '##mem-allocated? (make-prim-obj arm-prim-##mem-allocated? 1 #t #t))

    (table-set! table '##flonum?  (make-prim-obj arm-stub-prim 1 #t #f))
    (table-set! table '##fl+      (make-prim-obj arm-stub-prim 2 #t #f))
    (table-set! table '+          (make-prim-obj arm-stub-prim 2 #f #f))
    (table-set! table '-          (make-prim-obj arm-stub-prim 2 #f #f))
    (table-set! table '<          (make-prim-obj arm-stub-prim 2 #f #f))

    (table-set! table '##car      (make-prim-obj (object-read-prim pair-obj-desc 2) 1 #t #f))
    (table-set! table '##cdr      (make-prim-obj (object-read-prim pair-obj-desc 1) 1 #t #f))
    (table-set! table '##set-car! (make-prim-obj (object-set-prim pair-obj-desc 2) 2 #t #f))
    (table-set! table '##set-cdr! (make-prim-obj (object-set-prim pair-obj-desc 1) 2 #t #f))

    (table-set! table '##cons     (make-prim-obj arm-prim-##cons 2 #t #f))
    (table-set! table '##null?    (make-prim-obj arm-prim-##null? 2 #t #f))

    (table-set! table '##vector-ref  (make-prim-obj (object-dyn-read-prim vector-obj-desc) 2 #t #t))
    (table-set! table '##vector-set! (make-prim-obj (object-dyn-set-prim vector-obj-desc) 3 #t #f))
    ; (table-set! table '##vector-length (make-prim-obj x86-prim-##vector-length 1 #t #t))

    table))

;; Int opnd utils

(define (arm-sp? opnd)
  (equal? opnd (arm-sp)))

(define (arm-pc? opnd)
  (equal? opnd (arm-pc)))

(define (reg-or-8imm-opnd? opnd)
  (or (reg-opnd? opnd)
      (and
        (int-opnd? opnd)
        (in-range? 0 255 (int-opnd-value opnd)))))

(define (in-range-aligned? min max align opnd)
  (and (int-opnd? opnd)
       (in-range? min max (int-opnd-value opnd))
       (= 0 (fxand (- align 1) (int-opnd-value opnd)))))
