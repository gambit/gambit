;;==============================================================================

;;; File: "_t-cpu-backend-arm.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_arm#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------
;;-------------------------------- ARM backend  --------------------------------
;;------------------------------------------------------------------------------

(define (arm-target)
  (cpu-make-target
    'arm '((".c" . ARM))
    (make-backend make-cgc-arm (arm-info) (arm-instructions) (arm-routines))))

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
  (cpu-make-info
    'arm                    ;; Arch name
    arm-word-width          ;; Word width
    'le                     ;; Endianness
    #t                      ;; Load store architecture?
    0                       ;; Frame offset
    arm-primitive-table     ;; Primitive table
    cpu-default-nb-gvm-regs ;; GVM register count
    cpu-default-nb-arg-regs ;; GVM register count for passing arguments
    arm-registers           ;; Main registers
    (arm-r5)                ;; Processor state pointer
    (arm-r13)               ;; Stack pointer
    (arm-r6)                ;; Heap pointer
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
    arm-cmp-move-instr))        ;; am-compare-move

(define (make-arm-opnd opnd)
  (cond
    ((reg-opnd? opnd) opnd)
    ((int-opnd? opnd) (arm-imm-int (int-opnd-value opnd)))
    (else (compiler-internal-error "make-arm-opnd - Unknown opnd: " opnd))))

(define (arm-label-align cgc label-opnd #!optional (align '(4 . 0)))
  (asm-align cgc (car align) (cdr align))
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

  (if (not (equal? dst src))
    (cond
      ((reg-opnd? src)
        (regular-move (make-arm-opnd src)))
      ((int-opnd? src)
        (with-reg
          (lambda (reg)
            (let ((imm (int-opnd-value src)))
              (cond
                ((and (reg-opnd? reg) (in-range? 0 255 imm))
                  (arm-mov cgc reg (make-arm-opnd src))
                  (regular-move reg))
                ((and (reg-opnd? reg) (in-range? -255 0 imm))
                  ;; Todo: Replace with movn
                  (arm-mov cgc reg (make-arm-opnd (int-opnd-negative src)))
                  (arm-neg cgc reg reg)
                  (regular-move reg))
                (else
                  (let ((low (asm-unsigned-lo16 imm))
                        (high (fxarithmetic-shift-right imm 16)))
                    (arm-movw cgc reg low)
                    (if (not (= 0 high))
                      (arm-movt cgc reg high))
                    (regular-move reg))))))))
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
            (arm-ldr cgc reg reg 0)
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
  (if (lbl-opnd? opnd)
    (arm-b cgc (lbl-opnd-label opnd))
    (load-if-necessary cgc '(reg) opnd
      (lambda (opnd)
        (arm-bx cgc (make-arm-opnd opnd))))))

(define (arm-get-branch-conditions condition)
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
    ((not-equal) (flip (arm-get-branch-conditions (invert-condition condition))))
    ((lesser) (flip (arm-get-branch-conditions (invert-condition condition))))
    (else
      (compiler-internal-error "arm-get-branch-conditions - Unknown condition: " condition))))

(define (arm-cmp-jump-instr cgc test loc-true loc-false #!optional (opnds-width #f))
  (let* ((condition (test-condition test))
         (opnd1 (test-operand1 test))
         (opnd2 (test-operand2 test))
         (conds (arm-get-branch-conditions condition)))

    ;; In case both jump locations are false, the cmp is unnecessary.
    ;; Todo: Use cmn is necessary
    (if (or loc-true loc-false)
      (load-multiple-if-necessary cgc
        (list '(reg) reg-or-8imm-opnd?)
        (list opnd1 opnd2)
          (lambda (reg1 opnd2) (arm-cmp cgc reg1 (make-arm-opnd opnd2)))))

    (cond
      ((and loc-false loc-true)
        (arm-b cgc (lbl-opnd-label loc-true) (car conds))
        (arm-b cgc (lbl-opnd-label loc-false)))
      ((and (not loc-true) loc-false)
        (arm-b cgc (lbl-opnd-label loc-false) (cdr conds)))
      ((and loc-true (not loc-false))
        (arm-b cgc (lbl-opnd-label loc-true) (car conds))))))

(define (arm-cmp-move-instr cgc condition dest opnd1 opnd2 true-opnd false-opnd #!optional (opnds-width #f))
  (compiler-internal-error "TODO: arm-cmp-move-instr"))

;; TODO Deduplicate labels
(define (arm-load-label cgc rd label-opnd)
  (let ((label (lbl-opnd-label label-opnd)))
    (arm-load-data cgc rd
      (asm-label-id label)
      (lambda (cgc)
        (codegen-fixup-lbl! cgc label object-tag #f (get-word-width-bits cgc) 1)))))

;; TODO Deduplicate objects
(define (arm-load-obj cgc rd obj-value)
  (arm-load-data cgc rd (string-append "'" (object->string obj-value))
    (lambda (cgc)
      (codegen-fixup-obj! cgc obj-value (get-word-width-bits cgc) 1 #f))))

;; TODO Deduplicate references to global variables
(define (arm-load-glo cgc rd glo-name)
  (arm-load-data cgc rd (string-append "&global[" (symbol->string glo-name) "]")
    (lambda (cgc)
      (codegen-fixup-glo! cgc glo-name (get-word-width-bits cgc) 1 #f))))

(define (arm-load-data cgc rd ref-name place-data)
  (asm-16-le cgc #xf240) ;; movw
  (asm-16-le cgc (fxarithmetic-shift-left (arm-reg-field rd) 8))

  (if (codegen-context-listing-format cgc)
      (let ((thing
             (if ref-name
                 (if (symbol? ref-name) (symbol->string ref-name) ref-name)
                 "???")))
        (arm-listing cgc "movw" rd (string-append "lo16(" thing ")"))
        (arm-listing cgc "movt" rd (string-append "hi16(" thing ")"))))

  ; Refer to machine_code_block_fixup in lib/setup.c
  (place-data cgc))

;;------------------------------------------------------------------------------

;; Backend routines

(define (arm-routines)
  (make-routine-dictionnary
    am-default-poll
    am-default-set-nargs
    am-default-check-nargs
    (am-default-allocate-memory
      (lambda (cgc dest-reg base-reg offset)
        (am-add cgc dest-reg base-reg (int-opnd offset))))
    am-default-place-extra-data))

;;------------------------------------------------------------------------------

;; Primitives

(define arm-prim-##fixnum?
  (const-nargs-prim 1 1 '((reg))
    (lambda (cgc result-action args arg1 temp1)
      (am-mov cgc temp1 (int-opnd tag-mask))
      (arm-tst cgc arg1 temp1)
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-eq)))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define arm-prim-##pair?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd tag-mask))
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
      (am-mov cgc temp1 (int-opnd tag-mask))
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

(define arm-prim-##char?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (let ((test-int
              (- special-int-tag (expt 2 (- (get-word-width-bits cgc) 1)))))
        (am-mov cgc temp1 arg1) ;; Save arg1
        (am-mov cgc temp2 (int-opnd test-int))
        (arm-and cgc temp1 temp2)
        (am-mov cgc temp2 (int-opnd special-int-tag))
        (arm-cmp cgc temp1 temp2)
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-eq)))
          (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
          true-opnd:  (int-opnd (format-imm-object #t))
          false-opnd: (int-opnd (format-imm-object #f)))))))

(define (arm-prim-##boolean-or? val)
  (const-nargs-prim 1 2 any-opnds
    (lambda (cgc result-action args arg1 tmp1 tmp2)
      (let ((test-int (+ (* tag-mult val) tag-mask)))
        (am-mov cgc tmp1 arg1)
        (am-mov cgc tmp2 (int-opnd test-int))
        (arm-and cgc tmp1 tmp2)
        (am-if-eq cgc tmp1 (int-opnd (tag-number val special-int-tag))
          (lambda (cgc) (am-return-const cgc result-action #t))
          (lambda (cgc) (am-return-const cgc result-action #f))
          #f
          (get-word-width-bits cgc))))))

(define arm-prim-##subtyped?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1 tmp2)
      (am-mov cgc tmp1 (int-opnd tag-mask))
      (am-mov cgc tmp2 (int-opnd object-tag))
      (arm-and cgc tmp1 arg1)
      (arm-cmp cgc tmp1 tmp2)
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-eq)))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define (arm-prim-##subtype? subtype-desc) ; XXX
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1 tmp2)
      (let ((width (get-word-width-bits cgc)))
        (am-mov cgc tmp1 (int-opnd tag-mask))
        (am-mov cgc tmp2 (int-opnd object-tag))
        (arm-and cgc tmp1 arg1)
        (arm-cmp cgc tmp1 tmp2)
        (am-cond-return cgc result-action
          (lambda (cgc lbl)
            (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 (- 0 object-tag width width)))
            (am-mov cgc tmp2 (int-opnd subtype-mask))
            (arm-and cgc tmp1 tmp2)
            (am-mov cgc tmp2 (int-opnd (subtype-tag subtype-desc)))
            (arm-cmp cgc tmp1 tmp2)
            (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
          (lambda (cgc lbl)
            (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 (- 0 object-tag width width)))
            (am-mov cgc tmp2 (int-opnd subtype-mask))
            (arm-and cgc tmp1 tmp2)
            (am-mov cgc tmp2 (int-opnd (subtype-tag subtype-desc)))
            (arm-cmp cgc tmp1 tmp2)
            (arm-b cgc (lbl-opnd-label lbl) (arm-cond-ne)))
          true-opnd:  (int-opnd (format-imm-object #f))
          false-opnd: (int-opnd (format-imm-object #t)))))))

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
        (mk-test condition opnd1 opnd2)
        false-label true-label
        (get-word-width-bits cgc)))
    allowed-opnds1: '(reg)
    allowed-opnds2: '(reg int)))

(define arm-prim-##fx<  (arm-compare-prim (condition-greater #t #t)))
(define arm-prim-##fx<= (arm-compare-prim (condition-greater #f #t)))
(define arm-prim-##fx>  (arm-compare-prim (condition-lesser #t #t)))
(define arm-prim-##fx>= (arm-compare-prim (condition-lesser #f #t)))
(define arm-prim-##fx=  (arm-compare-prim condition-not-equal))

(define (arm-prim-##fxparity? parity)
  (const-nargs-prim 1 1 '((reg))
    (lambda (cgc result-action args arg1 temp1)
      (am-mov cgc temp1 (int-opnd (format-imm-object 1)))
      (arm-tst cgc arg1 temp1)
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (if (eq? parity 'even) (arm-cond-eq) (arm-cond-ne))))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (if (eq? parity 'even) (arm-cond-ne) (arm-cond-eq))))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define (arm-prim-##fxsign? sign)
  (const-nargs-prim 1 1 '((reg))
    (lambda (cgc result-action args arg1 tmp1)
      (am-mov cgc tmp1 (int-opnd 0))
      (arm-cmp cgc arg1 tmp1) ; XXX
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (if (eq? sign 'positive) (arm-cond-gt) (arm-cond-lt))))
        (lambda (cgc lbl) (arm-b cgc (lbl-opnd-label lbl) (if (eq? sign 'positive) (arm-cond-le) (arm-cond-ge))))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

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
              (int-opnd (+ (* header-tag-mult subtype) (* header-length-mult width 2)))
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

(define arm-primitive-table
  (let ((table (make-table test: equal?)))
    (table-set! table '##identity       (make-prim-obj ##identity-primitive    1 #t #t))
    (table-set! table '##not            (make-prim-obj ##not-primitive         1 #t #t))
    (table-set! table '##void           (make-prim-obj ##void-primitive        0 #t #t))
    (table-set! table '##eof-object     (make-prim-obj ##eof-object-primitive  0 #t #t))
    (table-set! table '##eof-object?    (make-prim-obj ##eof-object?-primitive 1 #t #t))
    (table-set! table '##eq?            (make-prim-obj ##eq?-primitive         2 #t #t))
    (table-set! table '##null?          (make-prim-obj ##null?-primitive       1 #t #f))
    (table-set! table '##fxzero?        (make-prim-obj ##fxzero?-primitive     1 #t #t))

    (table-set! table '##fixnum?        (make-prim-obj arm-prim-##fixnum?        1 #t #t))
    (table-set! table '##special?       (make-prim-obj arm-prim-##special?       1 #t #t))
    (table-set! table '##pair?          (make-prim-obj arm-prim-##pair?          1 #t #t))
    (table-set! table '##mem-allocated? (make-prim-obj arm-prim-##mem-allocated? 1 #t #t))
    (table-set! table '##char?          (make-prim-obj arm-prim-##char?          1 #t #t))

    (table-set! table '##boolean?       (make-prim-obj (arm-prim-##boolean-or? true-object-val) 1 #t #t))
    (table-set! table '##false-or-null? (make-prim-obj (arm-prim-##boolean-or? nil-object-val)  1 #t #t))
    (table-set! table '##false-or-void? (make-prim-obj (arm-prim-##boolean-or? void-object-val) 1 #t #t))

    (table-set! table '##subtyped?     (make-prim-obj arm-prim-##subtyped? 1 #t #t))
    (table-set! table '##vector?       (make-prim-obj (arm-prim-##subtype? vector-obj-desc)       1 #t #t))
    (table-set! table '##ratnum?       (make-prim-obj (arm-prim-##subtype? ratnum-obj-desc)       1 #t #t))
    (table-set! table '##cpxnum?       (make-prim-obj (arm-prim-##subtype? cpxnum-obj-desc)       1 #t #t))
    (table-set! table '##structure?    (make-prim-obj (arm-prim-##subtype? structure-obj-desc)    1 #t #t))
    (table-set! table '##meroon?       (make-prim-obj (arm-prim-##subtype? meroon-obj-desc)       1 #t #t))
    (table-set! table '##jazz?         (make-prim-obj (arm-prim-##subtype? jazz-obj-desc)         1 #t #t))
    (table-set! table '##symbol?       (make-prim-obj (arm-prim-##subtype? symbol-obj-desc)       1 #t #t))
    (table-set! table '##keyword?      (make-prim-obj (arm-prim-##subtype? keyword-obj-desc)      1 #t #t))
    (table-set! table '##frame?        (make-prim-obj (arm-prim-##subtype? frame-obj-desc)        1 #t #t))
    (table-set! table '##continuation? (make-prim-obj (arm-prim-##subtype? continuation-obj-desc) 1 #t #t))
    (table-set! table '##promise?      (make-prim-obj (arm-prim-##subtype? promise-obj-desc)      1 #t #t))
    (table-set! table '##procedure?    (make-prim-obj (arm-prim-##subtype? procedure-obj-desc)    1 #t #t))
    (table-set! table '##return?       (make-prim-obj (arm-prim-##subtype? return-obj-desc)       1 #t #t))
    (table-set! table '##foreign?      (make-prim-obj (arm-prim-##subtype? foreign-obj-desc)      1 #t #t))
    (table-set! table '##string?       (make-prim-obj (arm-prim-##subtype? string-obj-desc)       1 #t #t))
    (table-set! table '##s8vector?     (make-prim-obj (arm-prim-##subtype? s8vector-obj-desc)     1 #t #t))
    (table-set! table '##u8vector?     (make-prim-obj (arm-prim-##subtype? u8vector-obj-desc)     1 #t #t))
    (table-set! table '##s16vector?    (make-prim-obj (arm-prim-##subtype? s16vector-obj-desc)    1 #t #t))
    (table-set! table '##u16vector?    (make-prim-obj (arm-prim-##subtype? u16vector-obj-desc)    1 #t #t))
    (table-set! table '##s32vector?    (make-prim-obj (arm-prim-##subtype? s32vector-obj-desc)    1 #t #t))
    (table-set! table '##u32vector?    (make-prim-obj (arm-prim-##subtype? u32vector-obj-desc)    1 #t #t))
    (table-set! table '##f32vector?    (make-prim-obj (arm-prim-##subtype? f32vector-obj-desc)    1 #t #t))
    (table-set! table '##s64vector?    (make-prim-obj (arm-prim-##subtype? s64vector-obj-desc)    1 #t #t))
    (table-set! table '##u64vector?    (make-prim-obj (arm-prim-##subtype? u64vector-obj-desc)    1 #t #t))
    (table-set! table '##f64vector?    (make-prim-obj (arm-prim-##subtype? f64vector-obj-desc)    1 #t #t))
    (table-set! table '##flonum?       (make-prim-obj (arm-prim-##subtype? flonum-obj-desc)       1 #t #t))
    (table-set! table '##bignum?       (make-prim-obj (arm-prim-##subtype? bignum-obj-desc)       1 #t #t))

    (table-set! table '##fx+            (make-prim-obj arm-prim-##fx+  2 #t #f))
    (table-set! table '##fx+?           (make-prim-obj arm-prim-##fx+? 2 #t #t #t))
    (table-set! table '##fx-            (make-prim-obj arm-prim-##fx-  2 #t #f))
    (table-set! table '##fx-?           (make-prim-obj arm-prim-##fx-? 2 #t #t #t))
    (table-set! table '##fx<            (make-prim-obj arm-prim-##fx<  2 #t #t))
    (table-set! table '##fx<=           (make-prim-obj arm-prim-##fx<= 2 #t #t))
    (table-set! table '##fx>            (make-prim-obj arm-prim-##fx>  2 #t #t))
    (table-set! table '##fx>=           (make-prim-obj arm-prim-##fx>= 2 #t #t))
    (table-set! table '##fx=            (make-prim-obj arm-prim-##fx=  2 #t #t))

    (table-set! table '##fxeven?        (make-prim-obj (arm-prim-##fxparity? 'even)    1 #t #t))
    (table-set! table '##fxodd?         (make-prim-obj (arm-prim-##fxparity? 'odd)     1 #t #t))
    (table-set! table '##fxnegative?    (make-prim-obj (arm-prim-##fxsign? 'negative)  1 #t #t))
    (table-set! table '##fxpositive?    (make-prim-obj (arm-prim-##fxsign? 'positive)  1 #t #t))

    (table-set! table '##car            (make-prim-obj (object-read-prim pair-obj-desc '(a)) 1 #t #f))
    (table-set! table '##cdr            (make-prim-obj (object-read-prim pair-obj-desc '(d)) 1 #t #f))

    (table-set! table '##caar           (make-prim-obj (object-read-prim pair-obj-desc '(a a)) 1 #t #f))
    (table-set! table '##cadr           (make-prim-obj (object-read-prim pair-obj-desc '(a d)) 1 #t #f))
    (table-set! table '##cddr           (make-prim-obj (object-read-prim pair-obj-desc '(d d)) 1 #t #f))
    (table-set! table '##cdar           (make-prim-obj (object-read-prim pair-obj-desc '(d a)) 1 #t #f))

    (table-set! table '##caaar          (make-prim-obj (object-read-prim pair-obj-desc '(a a a)) 1 #t #f))
    (table-set! table '##caadr          (make-prim-obj (object-read-prim pair-obj-desc '(a a d)) 1 #t #f))
    (table-set! table '##cadar          (make-prim-obj (object-read-prim pair-obj-desc '(a d a)) 1 #t #f))
    (table-set! table '##caddr          (make-prim-obj (object-read-prim pair-obj-desc '(a d d)) 1 #t #f))
    (table-set! table '##cdaar          (make-prim-obj (object-read-prim pair-obj-desc '(d a a)) 1 #t #f))
    (table-set! table '##cdadr          (make-prim-obj (object-read-prim pair-obj-desc '(d a d)) 1 #t #f))
    (table-set! table '##cddar          (make-prim-obj (object-read-prim pair-obj-desc '(d d a)) 1 #t #f))
    (table-set! table '##cdddr          (make-prim-obj (object-read-prim pair-obj-desc '(d d d)) 1 #t #f))

    (table-set! table '##caaaar         (make-prim-obj (object-read-prim pair-obj-desc '(a a a a)) 1 #t #f))
    (table-set! table '##cdaaar         (make-prim-obj (object-read-prim pair-obj-desc '(d a a a)) 1 #t #f))
    (table-set! table '##cadaar         (make-prim-obj (object-read-prim pair-obj-desc '(a d a a)) 1 #t #f))
    (table-set! table '##cddaar         (make-prim-obj (object-read-prim pair-obj-desc '(d d a a)) 1 #t #f))
    (table-set! table '##caadar         (make-prim-obj (object-read-prim pair-obj-desc '(a a d a)) 1 #t #f))
    (table-set! table '##cdadar         (make-prim-obj (object-read-prim pair-obj-desc '(d a d a)) 1 #t #f))
    (table-set! table '##caddar         (make-prim-obj (object-read-prim pair-obj-desc '(a d d a)) 1 #t #f))
    (table-set! table '##cdddar         (make-prim-obj (object-read-prim pair-obj-desc '(d d d a)) 1 #t #f))
    (table-set! table '##caaadr         (make-prim-obj (object-read-prim pair-obj-desc '(a a a d)) 1 #t #f))
    (table-set! table '##cdaadr         (make-prim-obj (object-read-prim pair-obj-desc '(d a a d)) 1 #t #f))
    (table-set! table '##cadadr         (make-prim-obj (object-read-prim pair-obj-desc '(a d a d)) 1 #t #f))
    (table-set! table '##cddadr         (make-prim-obj (object-read-prim pair-obj-desc '(d d a d)) 1 #t #f))
    (table-set! table '##caaddr         (make-prim-obj (object-read-prim pair-obj-desc '(a a d d)) 1 #t #f))
    (table-set! table '##cdaddr         (make-prim-obj (object-read-prim pair-obj-desc '(d a d d)) 1 #t #f))
    (table-set! table '##cadddr         (make-prim-obj (object-read-prim pair-obj-desc '(a d d d)) 1 #t #f))
    (table-set! table '##cddddr         (make-prim-obj (object-read-prim pair-obj-desc '(d d d d)) 1 #t #f))

    (table-set! table '##set-car!       (make-prim-obj (object-set-prim pair-obj-desc 2) 2 #t #f))
    (table-set! table '##set-cdr!       (make-prim-obj (object-set-prim pair-obj-desc 1) 2 #t #f))

    (table-set! table '##cons           (make-prim-obj arm-prim-##cons 2 #t #f))

    (table-set! table '##vector-ref     (make-prim-obj (arm-object-dyn-read-prim vector-obj-desc) 2 #t #t))
    (table-set! table '##vector-set!    (make-prim-obj (arm-object-dyn-set-prim vector-obj-desc) 3 #t #f))
    (table-set! table '##vector-length  (make-prim-obj (arm-prim-##vector-length #f) 1 #t #t))

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
