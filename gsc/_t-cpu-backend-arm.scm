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

(define arm-word-width 4)

(define (arm-info)
  (make-cpu-info
    'arm                   ;; Arch name
    arm-word-width         ;; Word width
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
                (arm-sub cgc dst opnd1 (make-arm-opnd (int-opnd-negative opnd2)))
                (compiler-internal-error
                  "Can't add/sub from sp constants not multiples of 4 or larger than 508"))))

          ;; add rd, #imm8
          ((and (equal? dst opnd1)
                (int-opnd? opnd2)
                (in-range-aligned? 0 255 1 opnd2))
            (arm-add cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; add rd, #imm8 (neg)
          ((and (equal? dst opnd1)
                (int-opnd? opnd2)
                (in-range-aligned? 0 255 1 (int-opnd-negative opnd2)))
            (arm-sub cgc dst opnd1 (make-arm-opnd (int-opnd-negative opnd2))))

          ;; add rd, rn, #imm3
          ((and (int-opnd? opnd2)
                (in-range? 0 7 (int-opnd-value opnd2)))
            (arm-add cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; add rd, rn, #imm3 (neg)
          ((and (int-opnd? opnd2)
                (in-range? 0 7 (int-opnd-value (int-opnd-negative opnd2))))
            (arm-sub cgc dst opnd1 (make-arm-opnd (int-opnd-negative opnd2))))

          ;; add rd, rn, #imm
          ;; add rd, rn, rm
          (else
            (let ((use-reg
              (lambda (reg)
                (am-mov cgc reg opnd2)
                (arm-add cgc dst opnd1 reg))))

            (if (int-opnd? opnd2)
              (if (equal? dst opnd1)
                (get-free-register cgc (list dest opnd1 opnd2) use-reg)
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
                (int-opnd? opnd2)
                (in-range-aligned? 0 255 1 opnd2))
            (arm-sub cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; sub rd, #imm8 (neg)
          ((and (equal? dst opnd1)
                (int-opnd? opnd2)
                (in-range-aligned? 0 255 1 (int-opnd-negative opnd2)))
            (arm-add cgc dst opnd1 (make-arm-opnd (int-opnd-negative opnd2))))

          ;; sub rd, rn, #imm3
          ((and (int-opnd? opnd2)
                (in-range-aligned? 0 7 1 opnd2))
            (arm-sub cgc dst opnd1 (make-arm-opnd opnd2)))

          ;; sub rd, rn, #imm3 (neg)
          ((and (int-opnd? opnd2)
                (in-range-aligned? 0 7 1 (int-opnd-negative opnd2)))
            (arm-add cgc dst opnd1 (make-arm-opnd (int-opnd-negative opnd2))))

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
              (get-free-register cgc (list dst opnd1 opnd2) use-reg)
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
    ;; Todo: Use cmn is necessary
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
  (let ((label (lbl-opnd-label label-opnd)))
    (arm-load-data cgc rd
      (asm-label-id label)
      (lambda (cgc)
        (debug "label-opnd: " label-opnd)
        (codegen-fixup-lbl! cgc label object-tag #f 32 1 #f)))))

:; Todo: Deduplicate objects
(define (arm-load-obj cgc rd obj-value)
  (arm-load-data cgc rd (string-append "'" (object->string obj-value))
    (lambda (cgc)
      (debug "obj-value: " obj-value)
      (codegen-fixup-obj! cgc obj-value 32 1 #f))))

:; Todo: Deduplicate immediates
(define (arm-load-imm cgc rd val)
  (arm-load-data-old cgc rd (number->string val)
    (lambda (cgc)
      (debug "imm value: " val)
      (am-data cgc 32 val))))

:; Todo: Deduplicate references to global variables
(define (arm-load-glo cgc rd glo-name)
  (arm-load-data cgc rd (string-append "&global[" (symbol->string glo-name) "]")
    (lambda (cgc)
      (codegen-fixup-glo! cgc glo-name 32 1 #f))))

(define (arm-load-data cgc rd ref-name place-data)

  (asm-16-le cgc #xf240) ;; movw
  (asm-16-le cgc (fxarithmetic-shift-left (arm-reg-field rd) 8))

  (if (codegen-context-listing-format cgc)
      (let ((thing
             (if ref-name
                 (if (symbol? ref-name) (symbol->string ref-name) ref-name)
                 "???")))
        (arm-listing cgc (list "movw") rd (string-append "lo16(" thing ")"))
        (arm-listing cgc (list "movt") rd (string-append "hi16(" thing ")"))))

  (place-data cgc))

(define (arm-load-data-old cgc rd ref-name place-data)
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
    am-default-poll
    am-default-set-nargs
    am-default-check-nargs
    arm-check-nargs-simple
    (am-default-allocate-memory
      (lambda (cgc dest-reg base-reg offset)
        (am-add cgc dest-reg base-reg (int-opnd offset))))
    am-default-place-extra-data))

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

(define arm-prim-##fx+
  (foldl-prim
    (lambda (cgc accum opnd) (am-add cgc accum accum opnd))
    allowed-opnds: '(reg mem int)
    allowed-opnds-accum: '(reg mem)
    start-value: 0
    start-value-null?: #t
    reduce-1: am-mov
    commutative: #t))

(define arm-prim-##fx+?
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
      (lambda (result-reg result-opnd-in-args)
        (am-add cgc result-reg (car args) (cadr args))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-vc)))
          (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-vs)))
          true-opnd: result-reg
          false-opnd: (int-opnd (format-imm-object #f)))))))

(define arm-prim-##fx-
  (foldl-prim
    (lambda (cgc accum opnd) (am-sub cgc accum accum opnd))
    allowed-opnds: '(reg mem int)
    allowed-opnds-accum: '(reg mem)
    ; start-value: 0 ;; Start the fold on the first operand
    reduce-1: (lambda (cgc dst opnd) (am-sub cgc dst (int-opnd 0) opnd))
    commutative: #f))

(define arm-prim-##fx-?
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
      (lambda (result-reg result-opnd-in-args)
        (let* ((1-opnd? (null? (cdr args)))
               (opnd1 (if 1-opnd? (int-opnd 0) (car args)))
               (opnd2 (if 1-opnd? (car args) (cadr args))))
          (am-sub cgc result-reg opnd1 opnd2)
          (am-cond-return cgc result-action
            (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-vc)))
            (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-vs)))
            true-opnd: result-reg
            false-opnd: (int-opnd (format-imm-object #f))))))))

(define (arm-compare-prim condition)
  (foldl-compare-prim
    (lambda (cgc opnd1 opnd2 true-label false-label)
      (am-compare-jump cgc
        condition
        opnd1 opnd2
        false-label true-label
        (get-word-width-bits cgc)))
    allowed-opnds1: '(reg)
    allowed-opnds2: '(reg int)))

(define arm-prim-##fx<  (x86-compare-prim (condition-greater #t #t)))
(define arm-prim-##fx<= (x86-compare-prim (condition-greater #f #t)))
(define arm-prim-##fx>  (x86-compare-prim (condition-lesser #t #t)))
(define arm-prim-##fx>= (x86-compare-prim (condition-lesser #f #t)))
(define arm-prim-##fx=  (x86-compare-prim condition-not-equal))

(define arm-prim-##cons
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
        (lambda (result-reg result-opnd-in-args)
          (let* ((width (get-word-width cgc))
                 (size (* width 3))
                 (tag (get-desc-pointer-tag pair-obj-desc))
                 (subtype (reference-header-tag pair-obj-desc))
                 (offset (+ tag (* 2 width))))

            (am-allocate-memory cgc result-reg size offset
              (codegen-context-frame cgc))

            (am-mov cgc
              (mem-opnd result-reg (- offset))
              (int-opnd (+ (* header-tag-mult subtype) (* header-length-mult width 3)))
              (get-word-width-bits cgc))

            (am-mov cgc
              (mem-opnd result-reg (- width offset))
              (cadr args)
              (get-word-width-bits cgc))

            (am-mov cgc
              (mem-opnd result-reg (- (* 2 width) offset))
              (car args)
              (get-word-width-bits cgc))

            (am-return-opnd cgc result-action result-reg))))))

(define arm-prim-##null?
  (const-nargs-prim 1 0 (list (lambda (_) #t))
    (lambda (cgc result-action args arg1)
      (am-if-eq cgc arg1 (make-obj-opnd '())
        (lambda (cgc) (am-return-const cgc result-action #t))
        (lambda (cgc) (am-return-const cgc result-action #f))
        #f
        (get-word-width-bits cgc)))))

;; Doesn't support width not equal to (get-word-width cgc)
;; as am-return-opnd uses the default width
(define (arm-object-dyn-read-prim desc #!optional (width #f))
  (if (immediate-desc? desc)
    (compiler-internal-error "Object isn't a reference"))

  (const-nargs-prim 2 0 '((reg) (reg int))
    (lambda (cgc result-action args obj-reg index-opnd)
      (let* ((width (if width width (get-word-width cgc)))
             (index-shift (- (integer-length width) 1 tag-width))
             (obj-tag (get-desc-pointer-tag desc))
             (0-offset (+ (* width (- pointer-header-offset 1)) obj-tag)))

        (if (int-opnd? index-opnd)
          (am-return-opnd cgc result-action
            (mem-opnd obj-reg
              (- (arithmetic-shift (int-opnd-value index-opnd) index-shift) 0-offset)))
          (with-result-opnd cgc result-action args
            allowed-opnds: '(reg)
            fun:
            (lambda (result-reg result-opnd-in-args)
              (cond
                ((<= 1 index-shift) ;; Multiply
                  (arm-lsl cgc result-reg index-opnd (arm-imm-int index-shift))
                  (arm-add cgc result-reg obj-reg result-reg))
                ((>= -1 index-shift) ;; Divides
                  (arm-lsr cgc result-reg index-opnd (arm-imm-int (- index-shift)))
                  (arm-add cgc result-reg obj-reg result-reg))
                (else
                  (arm-add cgc result-reg obj-reg index-opnd)))
              (am-return-opnd cgc result-action (mem-opnd result-reg (- 0-offset))))))))))

;; Doesn't support width not equal to (get-word-width cgc)
;; as am-mov uses the default width
(define (arm-object-dyn-set-prim desc #!optional (width #f))
  (if (immediate-desc? desc)
    (compiler-internal-error "Object isn't a reference"))

  (const-nargs-prim 3 0 '((reg) (reg int))
    (lambda (cgc result-action args obj-reg index-opnd new-val-opnd)
      (let* ((width (if width width (get-word-width cgc)))
             (index-shift (- (integer-length width) 1 tag-width))
             (obj-tag (get-desc-pointer-tag desc))
             (0-offset (+ (* width (- pointer-header-offset 1)) obj-tag)))
        (if (int-opnd? index-opnd)
          (am-mov cgc
            (mem-opnd obj-reg
              (- (arithmetic-shift (int-opnd-value index-opnd) index-shift) 0-offset))
            new-val-opnd)
          (with-result-opnd cgc result-action args
            allowed-opnds: '(reg)
            fun:
            (lambda (result-reg result-opnd-in-args)
              (cond
                ((<= 1 index-shift) ;; Multiply
                  (arm-lsl cgc result-reg index-opnd (arm-imm-int index-shift))
                  (arm-add cgc result-reg obj-reg result-reg))
                ((>= -1 index-shift) ;; Divides
                  (arm-lsr cgc result-reg index-opnd (arm-imm-int (- index-shift)))
                  (arm-add cgc result-reg obj-reg result-reg))
                (else
                  (arm-add cgc result-reg obj-reg index-opnd)))
              (am-mov cgc (mem-opnd result-reg (- 0-offset)) new-val-opnd))))
        (am-return-const cgc result-action (void))))))

(define (arm-prim-##vector-length #!optional (width #f))
  (const-nargs-prim 1 0 '((reg))
    (lambda (cgc result-action args obj-reg)
      (let* ((width (if width width (get-word-width cgc)))
              (log2-width (- (integer-length width) 1))
              (header-offset (+ (* width pointer-header-offset) object-tag))
              (shift-count (- (+ header-length-offset log2-width) tag-width)))
        ;; Load header
        (am-mov cgc obj-reg (mem-opnd obj-reg (- header-offset)))
        ;; Shift header in order to ony keep length in bytes
        ;; Divides that value by the number of bytes per word
        ;; Multiply by the tag width
        (arm-lsr cgc obj-reg (arm-imm-int shift-count))
        (am-return-opnd cgc result-action obj-reg)))))

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

    (table-set! table '##fx+      (make-prim-obj arm-prim-##fx+  2 #t #f))
    (table-set! table '##fx+?     (make-prim-obj arm-prim-##fx+? 2 #t #t #t))
    (table-set! table '##fx-      (make-prim-obj arm-prim-##fx-  2 #t #f))
    (table-set! table '##fx-?     (make-prim-obj arm-prim-##fx-? 2 #t #t #t))
    (table-set! table '##fx<      (make-prim-obj arm-prim-##fx<  2 #t #t))
    (table-set! table '##fx<=     (make-prim-obj arm-prim-##fx<= 2 #t #t))
    (table-set! table '##fx>      (make-prim-obj arm-prim-##fx>  2 #t #t))
    (table-set! table '##fx>=     (make-prim-obj arm-prim-##fx>= 2 #t #t))
    (table-set! table '##fx=      (make-prim-obj arm-prim-##fx=  2 #t #t))

    (table-set! table '##car      (make-prim-obj (object-read-prim pair-obj-desc 2) 1 #t #f))
    (table-set! table '##cdr      (make-prim-obj (object-read-prim pair-obj-desc 1) 1 #t #f))
    (table-set! table '##set-car! (make-prim-obj (object-set-prim pair-obj-desc 2) 2 #t #f))
    (table-set! table '##set-cdr! (make-prim-obj (object-set-prim pair-obj-desc 1) 2 #t #f))

    (table-set! table '##cons     (make-prim-obj arm-prim-##cons 2 #t #f))
    (table-set! table '##null?    (make-prim-obj arm-prim-##null? 2 #t #f))

    (table-set! table '##vector-ref  (make-prim-obj (arm-object-dyn-read-prim vector-obj-desc) 2 #t #t))
    (table-set! table '##vector-set! (make-prim-obj (arm-object-dyn-set-prim vector-obj-desc) 3 #t #f))
    (table-set! table '##vector-length (make-prim-obj (arm-prim-##vector-length #f) 1 #t #t))

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
