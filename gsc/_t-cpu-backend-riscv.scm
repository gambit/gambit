;;==============================================================================

;;; File: "_t-cpu-backend-riscv.scm"

;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

(include "generic.scm")

(include-adt "_riscv#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

(define riscv-nb-gvm-regs 5)
(define riscv-nb-arg-regs 3)

(define (make-cgc-riscv arch)
  (let ((cgc (make-codegen-context)))
    (codegen-context-listing-format-set! cgc 'gnu)
    (asm-init-code-block cgc 0 'le)
    (riscv-arch-set! cgc arch)
    cgc))

;;------------------------------------------------------------------------------
;;--------------------------- RISC-V 32-bit backend ----------------------------
;;------------------------------------------------------------------------------

(define (riscv-32-target)
  (make-cpu-target
    (make-backend make-cgc-riscv-32 (riscv-32-info) (riscv-instructions) (riscv-routines))
    'riscv-32 '((".c" . RISCV-32)) riscv-nb-gvm-regs riscv-nb-arg-regs)) ; XXX

(define (make-cgc-riscv-32)
  (make-cgc-riscv 'RV32I))

(define (riscv-32-info)
  (riscv-info 'RV32I 4))

;;------------------------------------------------------------------------------
;;--------------------------- RISC-V 64-bit backend ----------------------------
;;------------------------------------------------------------------------------

(define (riscv-64-target)
  (make-cpu-target
    (make-backend make-cgc-riscv-64 (riscv-64-info) (riscv-instructions) (riscv-routines))
    'riscv-64 '((".c" . RISCV-64)) riscv-nb-gvm-regs riscv-nb-arg-regs)) ; XXX

(define (make-cgc-riscv-64)
  (make-cgc-riscv 'RV64I))

(define (riscv-64-info)
  (riscv-info 'RV64I 8))

;;------------------------------------------------------------------------------

;; RISC-V backend info

(define (riscv-info arch width)
  (make-cpu-info
    arch                  ;; Arch name
    width                 ;; Word width
    'le                   ;; Endianness
    #t                    ;; Load-store architecture?
    0                     ;; Frame offset
    riscv-primitive-table ;; Primitive table
    riscv-nb-gvm-regs     ;; GVM register count
    riscv-nb-arg-regs     ;; GVM register count for passing arguments
    riscv-registers       ;; Main registers
    (riscv-s10)           ;; Processor state pointer (PS)
    (riscv-sp)            ;; Stack pointer (SP)
    (riscv-s11)))         ;; Heap pointer (HP)

(define riscv-registers
  (vector
    (riscv-s2)   ;; R0
    (riscv-s3)   ;; R1
    (riscv-s4)   ;; R2
    (riscv-s5)   ;; R3
    (riscv-s6)   ;; R4
    (riscv-s7)   ;; TMP0
    (riscv-s8))) ;; TMP1

;;------------------------------------------------------------------------------

;; RISC-V Abstract machine instructions

(define (riscv-instructions)
  (make-instruction-dictionnary
    riscv-label-align           ;; am-lbl
    riscv-data-instr            ;; am-data
    riscv-mov-instr             ;; am-mov
    riscv-add-instr             ;; am-add
    riscv-sub-instr             ;; am-sub
    riscv-jmp-instr             ;; am-jmp
    riscv-cmp-jump-instr        ;; am-compare-jump
    riscv-cmp-move-instr))      ;; am-compare-move

(define (make-riscv-opnd opnd)
  (cond
    ((reg-opnd? opnd) opnd)
    ((int-opnd? opnd) (riscv-imm-int (int-opnd-value opnd)))
    ((lbl-opnd? opnd) (riscv-imm-lbl (lbl-opnd-label opnd) (lbl-opnd-offset opnd)))
    (else (compiler-internal-error "make-riscv-opnd - Unknown opnd: " opnd))))

(define (riscv-label-align cgc label-opnd #!optional (align #f))
  (if align ; XXX NOP in RV32I is 4 bytes with value 0x13
      (asm-align cgc (car align) (cdr align))
      (asm-align cgc (get-word-width cgc) 0))
  (riscv-label cgc (lbl-opnd-label label-opnd)))

(define riscv-data-instr
  (make-am-data riscv-db riscv-dh riscv-dw riscv-dd))

; TODO Deduplicate labels
(define (riscv-load-lbl cgc rd lbl-opnd)
  (let ((label (lbl-opnd-label lbl-opnd)))
    (riscv-load-data cgc rd
      (asm-label-id label) ; XXX
      (lambda (cgc)
        (codegen-fixup-lbl! cgc label object-tag #f (get-word-width-bits cgc) 2)))))

; TODO Deduplicate objects
(define (riscv-load-obj cgc rd obj-value)
  (riscv-load-data cgc rd
    (string-append "'" (object->string obj-value)) ; XXX
    (lambda (cgc)
      (codegen-fixup-obj! cgc obj-value (get-word-width-bits cgc) 2 #f))))

; TODO Deduplicate references to global variables
(define (riscv-load-glo cgc rd glo-name)
  (riscv-load-data cgc rd
    (string-append "&global[" (symbol->string glo-name) "]") ; XXX
    (lambda (cgc)
      (codegen-fixup-glo! cgc glo-name (get-word-width-bits cgc) 2 #f))))

(define (riscv-load-data cgc rd ref-name place-data)
  (define cgc-format? (codegen-context-listing-format cgc))

  (codegen-context-listing-format-set! cgc #f)
  (if (= (get-word-width cgc) 8)
      (begin
        ; Hack to load value
        (riscv-jal cgc (riscv-s7) (riscv-imm-int 12 'J))
        (riscv-ld cgc rd (riscv-s7) (riscv-imm-int 0))

        ; Worst case of load immediate
        ; (riscv-lui cgc rd (riscv-imm-int 0 'U))
        ; (riscv-addiw cgc rd rd (riscv-imm-int 0))
        ; (riscv-slli cgc rd rd 0)
        ; (riscv-addi cgc rd rd (riscv-imm-int 0))
        ; (riscv-slli cgc rd rd 0)
        ; (riscv-addi cgc rd rd (riscv-imm-int 0))
        ;; (riscv-slli cgc rd rd 0)
        ;; (riscv-addi cgc rd rd (riscv-imm-int 0))
        )
      (begin
        (riscv-lui cgc rd (riscv-imm-int 0 'U))
        ; (riscv-addi cgc rd rd (riscv-imm-int 0))
        ))

  (if cgc-format?
      (let ((sym (if ref-name
                     (if (symbol? ref-name)
                         (symbol->string ref-name)
                         ref-name)
                     "???")))
        (riscv-listing cgc "li" rd sym)
        (codegen-context-listing-format-set! cgc cgc-format?)))

  (place-data cgc))

(define (riscv-mov-instr cgc dst src #!optional (width #f))
  (define (with-reg func)
    (if (reg-opnd? dst)
        (func (make-riscv-opnd dst))
        (get-free-register cgc (list dst src)
          (lambda (reg)
            (func (make-riscv-opnd reg))))))

  (define (unaligned-mem-opnd? mem-opnd)
    (not (= 0 (modulo (mem-opnd-offset mem-opnd) (get-word-width cgc))))) ; XXX

  (define (regular-move src)
    (if (not (equal? dst src))
        (let ((64-bit? (= (get-word-width cgc) 8)))
          (cond
            ((reg-opnd? dst)
             (riscv-mv cgc (make-riscv-opnd dst) src))
            ((glo-opnd? dst)
             (get-free-register cgc
               (list dst src src) ; XXX
               (lambda (reg)
                 (riscv-load-glo cgc reg (glo-opnd-name dst))
                 ((if 64-bit? riscv-sd riscv-sw) cgc reg src (riscv-imm-int 0 'S))))) ; XXX
            ((mem-opnd? dst)
             (if (unaligned-mem-opnd? dst)
                 (get-free-register cgc
                   (list dst src src) ; XXX
                   (lambda (reg)
                     (am-add cgc reg (mem-opnd-base dst) (int-opnd (mem-opnd-offset dst)))
                     ((if 64-bit? riscv-sd riscv-sw) cgc reg src (riscv-imm-int 0 'S)))) ; XXX
                 ((if 64-bit? riscv-sd riscv-sw) cgc (mem-opnd-base dst) src (riscv-imm-int (mem-opnd-offset dst) 'S)))) ; XXX
            (else
              (compiler-internal-error
                "riscv-mov-instr - Unknown or incompatible destination: " dst))))))

  (if (not (equal? dst src))
      (let ((64-bit? (= (get-word-width cgc) 8)))
        (cond
          ((reg-opnd? src)
           (regular-move (make-riscv-opnd src)))
          ((int-opnd? src)
           (with-reg
             (lambda (reg)
               (riscv-li cgc reg (make-riscv-opnd src))
               (regular-move reg))))
          ((lbl-opnd? src)
           (with-reg
             (lambda (reg)
               (riscv-load-lbl cgc reg src)
               (regular-move reg))))
          ((glo-opnd? src)
           (with-reg
             (lambda (reg)
               (riscv-load-glo cgc reg (glo-opnd-name src))
               ((if 64-bit? riscv-ld riscv-lw) cgc reg reg (riscv-imm-int 0)) ; XXX
               (regular-move reg))))
          ((obj-opnd? src)
           (with-reg
             (lambda (reg)
               (riscv-load-obj cgc reg (obj-opnd-value src))
               (regular-move reg))))
          ((mem-opnd? src)
           (with-reg
             (lambda (reg)
               (if (unaligned-mem-opnd? src)
                   (begin
                     (am-add cgc reg (mem-opnd-base src) (int-opnd (mem-opnd-offset src)))
                     ((if 64-bit? riscv-ld riscv-lw) cgc reg reg (riscv-imm-int 0))) ; XXX
                   ((if 64-bit? riscv-ld riscv-lw) cgc reg (mem-opnd-base src) (riscv-imm-int (mem-opnd-offset src)))) ; XXX
               (regular-move reg))))
          (else
            (compiler-internal-error "Cannot move : " dst " <- " src))))))

(define (riscv-arith-instr instr cgc dest opnd1 opnd2)
  (define (with-dest-reg dst)
    (load-multiple-if-necessary
      cgc
      '((reg) (reg int))
      (list opnd1 opnd2)
      (lambda (opnd1 opnd2) ; XXX addw, subw, addiw
        (cond ((reg-opnd? opnd2)
               (instr cgc dst opnd1 opnd2))
              ((in-range? -2048 2047 (int-opnd-value opnd2))
               (riscv-addi cgc dst opnd1 (make-riscv-opnd opnd2)))
              (else
                (let ((use-reg
                        (lambda (reg)
                          (am-mov cgc reg opnd2)
                          (instr cgc dst opnd1 reg))))
                  (if (equal? dst opnd1)
                      (get-free-register cgc (list dest opnd1 opnd2) use-reg)
                      (use-reg dst)))))
        (am-mov cgc dest dst))))

  (if (reg-opnd? dest)
      (with-dest-reg dest)
      (get-free-register cgc (list dest opnd1 opnd2) with-dest-reg)))

(define (riscv-add-instr cgc dest opnd1 opnd2)
  (riscv-arith-instr riscv-add cgc dest opnd1 opnd2))

(define (riscv-sub-instr cgc dest opnd1 opnd2)
  (riscv-arith-instr riscv-sub cgc dest opnd1
                     (if (int-opnd? opnd2)
                         (int-opnd-negative opnd2)
                         opnd2)))

(define (riscv-jmp-instr cgc opnd)
  (if (lbl-opnd? opnd)
      (riscv-j cgc (make-riscv-opnd opnd))
      (load-if-necessary cgc '(reg int lbl) opnd
        (lambda (opnd)
          (if (reg-opnd? opnd)
              (riscv-jr cgc (make-riscv-opnd opnd))
              (riscv-j cgc (make-riscv-opnd opnd)))))))

(define (riscv-branch-instrs condition)
  (case (get-condition condition)
    ((equal)
     (cons riscv-beq riscv-bne))
    ((greater)
     (cond
       ((and (cond-is-equal condition) (cond-is-signed condition))
        (cons riscv-bge riscv-blt))
       ((and (cond-is-equal condition) (not (cond-is-signed condition)))
        (cons riscv-bgeu riscv-bltu))
       ((and (not (cond-is-equal condition)) (cond-is-signed condition))
        (cons riscv-bgt riscv-ble))
       ((and (not (cond-is-equal condition)) (not (cond-is-signed condition)))
        (cons riscv-bgtu riscv-bleu))))
    ((not-equal lesser)
     (flip (riscv-branch-instrs (invert-condition condition))))
    (else
      (compiler-internal-error
        "riscv-branch-instrs - Unknown condition: " condition))))

(define (riscv-cmp-jump-instr cgc test loc-true loc-false #!optional (opnds-width #f))
  (let ((opnd1 (test-operand1 test))
        (opnd2 (test-operand2 test))
        (condition (test-condition test)))
    (let ((instrs (riscv-branch-instrs condition)))
      (load-multiple-if-necessary
        cgc
        '((reg) (reg))
        (list opnd1 opnd2)
        (lambda (reg1 reg2)
          (cond ((and loc-true loc-false)
                 ((car instrs) cgc reg1 reg2 (make-riscv-opnd loc-true))
                 (riscv-j cgc (make-riscv-opnd loc-false)))
                ((and loc-true (not loc-false))
                 ((car instrs) cgc reg1 reg2 (make-riscv-opnd loc-true)))
                ((and (not loc-true) loc-false)
                 ((cdr instrs) cgc reg1 reg2 (make-riscv-opnd loc-false)))))))))

(define (riscv-cmp-move-instr cgc condition dest opnd1 opnd2 true-opnd false-opnd #!optional (opnds-width #f))
  (compiler-internal-error "TODO riscv-cmp-move-instr"))

;;------------------------------------------------------------------------------

;; Backend routines

(define (riscv-routines)
  (make-routine-dictionnary
    am-default-poll
    am-default-set-nargs
    am-default-check-nargs
    riscv-check-nargs-simple ; XXX
    (am-default-allocate-memory
      (lambda (cgc dest-reg base-reg offset)
        (am-add cgc dest-reg base-reg (int-opnd offset))))
    am-default-place-extra-data))

;;------------------------------------------------------------------------------

;; Primitives

(define riscv-prim-##fixnum?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd tag-mask))
      (riscv-and cgc temp2 arg1 temp1) ; XXX
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (riscv-beq cgc temp1 temp2 (make-riscv-opnd lbl)))
        (lambda (cgc lbl) (riscv-bne cgc temp1 temp2 (make-riscv-opnd lbl)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define riscv-prim-##pair?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd tag-mask))
      (riscv-not cgc temp2 arg1)
      (riscv-and cgc temp2 temp1 temp2) ; XXX
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (riscv-beq cgc temp1 temp2 (make-riscv-opnd lbl)))
        (lambda (cgc lbl) (riscv-bne cgc temp1 temp2 (make-riscv-opnd lbl)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define riscv-prim-##special?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd special-int-tag))
      (riscv-andi cgc temp2 arg1 (riscv-imm-int tag-mask)) ; XXX
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (riscv-beq cgc temp1 temp2 (make-riscv-opnd lbl)))
        (lambda (cgc lbl) (riscv-bne cgc temp1 temp2 (make-riscv-opnd lbl)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define riscv-prim-##mem-allocated?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd (bitwise-and object-tag pair-tag)))
      (riscv-and cgc temp2 arg1 temp1) ; XXX
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (riscv-beq cgc temp1 temp2 (make-riscv-opnd lbl)))
        (lambda (cgc lbl) (riscv-bne cgc temp1 temp2 (make-riscv-opnd lbl)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define riscv-prim-##char?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (let ((test-int
              (- special-int-tag (expt 2 (- (get-word-width-bits cgc) 1)))))
        (am-mov cgc temp1 (int-opnd test-int))
        (riscv-and cgc temp1 arg1 temp1)
        (am-mov cgc temp2 (int-opnd special-int-tag))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (riscv-beq cgc temp1 temp2 (make-riscv-opnd lbl)))
          (lambda (cgc lbl) (riscv-bne cgc temp1 temp2 (make-riscv-opnd lbl)))
          true-opnd:  (int-opnd (format-imm-object #t))
          false-opnd: (int-opnd (format-imm-object #f)))))))

(define riscv-prim-##boolean?
  (const-nargs-prim 1 1 any-opnds
    (lambda (cgc result-action args arg1 tmp1)
      (let ((test-int (+ (* tag-mult true-object-val) tag-mask)))
        (riscv-andi cgc tmp1 arg1 (riscv-imm-int test-int))
        (am-if-eq cgc tmp1 (make-obj-opnd #t)
          (lambda (cgc) (am-return-const cgc result-action #t))
          (lambda (cgc) (am-return-const cgc result-action #f))
          #f
          (get-word-width-bits cgc))))))

(define riscv-prim-##subtyped?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1 tmp2)
      (am-mov cgc tmp1 (int-opnd object-tag))
      (riscv-andi cgc tmp2 arg1 (riscv-imm-int tag-mask))
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (riscv-beq cgc tmp1 tmp2 (make-riscv-opnd lbl)))
        (lambda (cgc lbl) (riscv-bne cgc tmp1 tmp2 (make-riscv-opnd lbl)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define (riscv-prim-##subtype? subtype-desc) ; XXX
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1 tmp2)
      (let ((width (get-word-width-bits cgc)))
        (am-mov cgc tmp1 (int-opnd object-tag))
        (riscv-andi cgc tmp2 arg1 (riscv-imm-int tag-mask))
        (am-cond-return cgc result-action
          (lambda (cgc lbl)
            (riscv-bne cgc tmp1 tmp2 (make-riscv-opnd lbl))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 (- 0 object-tag width width)))
            (riscv-andi cgc tmp1 tmp1 (riscv-imm-int subtype-mask))
            (am-mov cgc tmp2 (int-opnd (subtype-tag subtype-desc)))
            (riscv-bne cgc tmp1 tmp2 (make-riscv-opnd lbl)))
          (lambda (cgc lbl)
            (riscv-bne cgc tmp1 tmp2 (make-riscv-opnd lbl))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 (- 0 object-tag width width)))
            (riscv-andi cgc tmp1 tmp1 (riscv-imm-int subtype-mask))
            (am-mov cgc tmp2 (int-opnd (subtype-tag subtype-desc)))
            (riscv-bne cgc tmp1 tmp2 (make-riscv-opnd lbl)))
          true-opnd:  (int-opnd (format-imm-object #f))
          false-opnd: (int-opnd (format-imm-object #t)))))))

(define riscv-prim-##fx+
  (foldl-prim
    (lambda (cgc accum opnd) (am-add cgc accum accum opnd))
    allowed-opnds: '(reg mem int)
    allowed-opnds-accum: '(reg mem)
    start-value: 0
    start-value-null?: #t
    reduce-1: am-mov
    commutative: #t))

(define riscv-prim-##fx+?
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
      (lambda (result-reg result-opnd-in-args)
        (am-add cgc result-reg (car args) (cadr args))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) ; XXX
            (riscv-slt cgc (car args) result-reg (car args))
            (riscv-sltz cgc (cadr args) (cadr args))
            (riscv-beq cgc (car args) (cadr args) (make-riscv-opnd lbl)))
          (lambda (cgc lbl) ; XXX Overflow
            (riscv-slt cgc (car args) result-reg (car args))
            (riscv-sltz cgc (cadr args) (cadr args))
            (riscv-bne cgc (car args) (cadr args) (make-riscv-opnd lbl)))
          true-opnd: result-reg
          false-opnd: (int-opnd (format-imm-object #f)))))))

(define riscv-prim-##fx-
  (foldl-prim
    (lambda (cgc accum opnd) (am-sub cgc accum accum opnd))
    allowed-opnds: '(reg mem int)
    allowed-opnds-accum: '(reg mem)
    ; start-value: 0 ;; Start the fold on the first operand
    reduce-1: (lambda (cgc dst opnd) (am-sub cgc dst (riscv-zero) opnd))
    commutative: #f))

(define riscv-prim-##fx-?
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
      (lambda (result-reg result-opnd-in-args)
        (let* ((1-opnd? (null? (cdr args)))
               (opnd1 (if 1-opnd? (riscv-zero) (car args)))
               (opnd2 (if 1-opnd? (car args) (cadr args))))
          (am-sub cgc result-reg opnd1 opnd2)
          (am-cond-return cgc result-action
            (lambda (cgc lbl) ; XXX
              (riscv-slt cgc opnd1 result-reg opnd1)
              (riscv-sltz cgc opnd2 opnd2)
              (riscv-bne cgc opnd1 opnd2 (make-riscv-opnd lbl)))
            (lambda (cgc lbl) ; XXX Overflow
              (riscv-slt cgc opnd1 result-reg opnd1)
              (riscv-sltz cgc opnd2 opnd2)
              (riscv-beq cgc opnd1 opnd2 (make-riscv-opnd lbl)))
            true-opnd: result-reg
            false-opnd: (int-opnd (format-imm-object #f))))))))

(define (riscv-compare-prim condition)
  (foldl-compare-prim
    (lambda (cgc opnd1 opnd2 true-label false-label)
      (am-compare-jump cgc
        (mk-test condition opnd1 opnd2)
        false-label true-label
        (get-word-width-bits cgc)))
    allowed-opnds1: '(reg mem)
    allowed-opnds2: '(reg int)))

(define riscv-prim-##fx<  (riscv-compare-prim (condition-greater #t #t)))
(define riscv-prim-##fx<= (riscv-compare-prim (condition-greater #f #t)))
(define riscv-prim-##fx>  (riscv-compare-prim (condition-lesser #t #t)))
(define riscv-prim-##fx>= (riscv-compare-prim (condition-lesser #f #t)))
(define riscv-prim-##fx=  (riscv-compare-prim condition-not-equal))

(define (riscv-prim-##fxparity? parity)
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1)
      (riscv-andi cgc tmp1 arg1 (riscv-imm-int (format-imm-object 1)))
      (am-cond-return cgc result-action
        (lambda (cgc lbl) ((if (eq? parity 'even) riscv-beqz riscv-bnez) cgc tmp1 (make-riscv-opnd lbl)))
        (lambda (cgc lbl) ((if (eq? parity 'even) riscv-bnez riscv-beqz) cgc tmp1 (make-riscv-opnd lbl)))
        true-opnd:  (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define riscv-prim-##cons
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
(define (riscv-object-dyn-read-prim desc #!optional (width #f))
  (if (immediate-desc? desc)
    (compiler-internal-error "Object isn't a reference"))

  (const-nargs-prim 2 0 '((reg) (reg int))
    (lambda (cgc result-action args obj-reg index-opnd)
      (let* ((width (if width width (get-word-width cgc)))
             (index-shift (- (integer-length width) 1 tag-width))
             (obj-tag (get-desc-pointer-tag desc))
             (0-offset (+ (* width (- pointer-header-offset 1)) obj-tag)))

        (if (> 0 index-shift)
          (compiler-internal-error "riscv-object-dyn-read-prim - Invalid index-shift"))

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
                 (riscv-slli cgc result-reg index-opnd index-shift)
                 (riscv-add cgc result-reg obj-reg result-reg))
                ((>= -1 index-shift) ;; Divides
                 (riscv-srli cgc result-reg index-opnd (- index-shift))
                 (riscv-add cgc result-reg obj-reg result-reg))
                (else
                  (riscv-add cgc result-reg obj-reg index-opnd)))
              (am-return-opnd cgc result-action (mem-opnd result-reg (- 0-offset))))))))))

;; Doesn't support width not equal to (get-word-width cgc)
;; as am-mov uses the default width
(define (riscv-object-dyn-set-prim desc #!optional (width #f))
  (if (immediate-desc? desc)
    (compiler-internal-error "Object isn't a reference"))

  (const-nargs-prim 3 0 '((reg) (reg int))
    (lambda (cgc result-action args obj-reg index-opnd new-val-opnd)
      (let* ((width (if width width (get-word-width cgc)))
             (index-shift (- (integer-length width) 1 tag-width))
             (obj-tag (get-desc-pointer-tag desc))
             (0-offset (+ (* width (- pointer-header-offset 1)) obj-tag)))

        (if (> 0 index-shift)
          (compiler-internal-error "riscv-object-dyn-set-prim - Invalid index-shift"))

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
                 (riscv-slli cgc result-reg index-opnd index-shift)
                 (riscv-add cgc result-reg obj-reg result-reg))
                ((>= -1 index-shift) ;; Divides
                 (riscv-srli cgc result-reg index-opnd (- index-shift))
                 (riscv-add cgc result-reg obj-reg result-reg))
                (else
                  (riscv-add cgc result-reg obj-reg index-opnd)))
              (am-mov cgc (mem-opnd result-reg (- 0-offset)) new-val-opnd))))
        (am-return-const cgc result-action (void))))))

(define (riscv-prim-##vector-length #!optional (width #f))
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
        (riscv-srli cgc obj-reg obj-reg shift-count)
        (am-return-opnd cgc result-action obj-reg)))))

(define (riscv-stub-prim cgc result-action . args)
  (if (then-return? result-action)
    (put-entry-point-label cgc
      (then-return-label result-action)
      (then-return-prim-name result-action)
      #f 1234 #f) ; XXX
    #f))

(define riscv-primitive-table
  (let ((table (make-table test: equal?)))
    (table-set! table '##identity       (make-prim-obj ##identity-primitive 1 #t #t))
    (table-set! table '##not            (make-prim-obj ##not-primitive      1 #t #t))
    (table-set! table '##void           (make-prim-obj ##void-primitive     0 #t #t))
    (table-set! table '##eq?            (make-prim-obj ##eq?-primitive      2 #t #t))
    (table-set! table '##null?          (make-prim-obj ##null?-primitive    1 #t #f))

    (table-set! table '##fixnum?        (make-prim-obj riscv-prim-##fixnum?        1 #t #t))
    (table-set! table '##pair?          (make-prim-obj riscv-prim-##pair?          1 #t #t))
    (table-set! table '##special?       (make-prim-obj riscv-prim-##special?       1 #t #t))
    (table-set! table '##mem-allocated? (make-prim-obj riscv-prim-##mem-allocated? 1 #t #t))
    (table-set! table '##char?          (make-prim-obj riscv-prim-##char?          1 #t #t))
    (table-set! table '##boolean?       (make-prim-obj riscv-prim-##boolean?       1 #t #t))

    (table-set! table '##subtyped?     (make-prim-obj riscv-prim-##subtyped? 1 #t #t))
    (table-set! table '##vector?       (make-prim-obj (riscv-prim-##subtype? vector-obj-desc)       1 #t #t))
    (table-set! table '##ratnum?       (make-prim-obj (riscv-prim-##subtype? ratnum-obj-desc)       1 #t #t))
    (table-set! table '##cpxnum?       (make-prim-obj (riscv-prim-##subtype? cpxnum-obj-desc)       1 #t #t))
    (table-set! table '##structure?    (make-prim-obj (riscv-prim-##subtype? structure-obj-desc)    1 #t #t))
    (table-set! table '##meroon?       (make-prim-obj (riscv-prim-##subtype? meroon-obj-desc)       1 #t #t))
    (table-set! table '##jazz?         (make-prim-obj (riscv-prim-##subtype? jazz-obj-desc)         1 #t #t))
    (table-set! table '##symbol?       (make-prim-obj (riscv-prim-##subtype? symbol-obj-desc)       1 #t #t))
    (table-set! table '##keyword?      (make-prim-obj (riscv-prim-##subtype? keyword-obj-desc)      1 #t #t))
    (table-set! table '##frame?        (make-prim-obj (riscv-prim-##subtype? frame-obj-desc)        1 #t #t))
    (table-set! table '##continuation? (make-prim-obj (riscv-prim-##subtype? continuation-obj-desc) 1 #t #t))
    (table-set! table '##promise?      (make-prim-obj (riscv-prim-##subtype? promise-obj-desc)      1 #t #t))
    (table-set! table '##procedure?    (make-prim-obj (riscv-prim-##subtype? procedure-obj-desc)    1 #t #t))
    (table-set! table '##return?       (make-prim-obj (riscv-prim-##subtype? return-obj-desc)       1 #t #t))
    (table-set! table '##foreign?      (make-prim-obj (riscv-prim-##subtype? foreign-obj-desc)      1 #t #t))
    (table-set! table '##string?       (make-prim-obj (riscv-prim-##subtype? string-obj-desc)       1 #t #t))
    (table-set! table '##s8vector?     (make-prim-obj (riscv-prim-##subtype? s8vector-obj-desc)     1 #t #t))
    (table-set! table '##u8vector?     (make-prim-obj (riscv-prim-##subtype? u8vector-obj-desc)     1 #t #t))
    (table-set! table '##s16vector?    (make-prim-obj (riscv-prim-##subtype? s16vector-obj-desc)    1 #t #t))
    (table-set! table '##u16vector?    (make-prim-obj (riscv-prim-##subtype? u16vector-obj-desc)    1 #t #t))
    (table-set! table '##s32vector?    (make-prim-obj (riscv-prim-##subtype? s32vector-obj-desc)    1 #t #t))
    (table-set! table '##u32vector?    (make-prim-obj (riscv-prim-##subtype? u32vector-obj-desc)    1 #t #t))
    (table-set! table '##f32vector?    (make-prim-obj (riscv-prim-##subtype? f32vector-obj-desc)    1 #t #t))
    (table-set! table '##s64vector?    (make-prim-obj (riscv-prim-##subtype? s64vector-obj-desc)    1 #t #t))
    (table-set! table '##u64vector?    (make-prim-obj (riscv-prim-##subtype? u64vector-obj-desc)    1 #t #t))
    (table-set! table '##f64vector?    (make-prim-obj (riscv-prim-##subtype? f64vector-obj-desc)    1 #t #t))
    (table-set! table '##flonum?       (make-prim-obj (riscv-prim-##subtype? flonum-obj-desc)       1 #t #t))
    (table-set! table '##bignum?       (make-prim-obj (riscv-prim-##subtype? bignum-obj-desc)       1 #t #t))

    ; (table-set! table '##flonum?      (make-prim-obj riscv-stub-prim 1 #t #f))
    ; (table-set! table '##fl+          (make-prim-obj riscv-stub-prim 2 #t #f))
    ; (table-set! table '+              (make-prim-obj riscv-stub-prim 2 #f #f))
    ; (table-set! table '-              (make-prim-obj riscv-stub-prim 2 #f #f))
    ; (table-set! table '<              (make-prim-obj riscv-stub-prim 2 #f #f))

    (table-set! table '##fx+            (make-prim-obj riscv-prim-##fx+  2 #t #f))
    (table-set! table '##fx+?           (make-prim-obj riscv-prim-##fx+? 2 #t #t #t))
    (table-set! table '##fx-            (make-prim-obj riscv-prim-##fx-  2 #t #f))
    (table-set! table '##fx-?           (make-prim-obj riscv-prim-##fx-? 2 #t #t #t))
    (table-set! table '##fx<            (make-prim-obj riscv-prim-##fx<  2 #t #t))
    (table-set! table '##fx<=           (make-prim-obj riscv-prim-##fx<= 2 #t #t))
    (table-set! table '##fx>            (make-prim-obj riscv-prim-##fx>  2 #t #t))
    (table-set! table '##fx>=           (make-prim-obj riscv-prim-##fx>= 2 #t #t))
    (table-set! table '##fx=            (make-prim-obj riscv-prim-##fx=  2 #t #t))

    (table-set! table '##fxeven?        (make-prim-obj (riscv-prim-##fxparity? 'even) 1 #t #t))
    (table-set! table '##fxodd?         (make-prim-obj (riscv-prim-##fxparity? 'odd)  1 #t #t))

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

    (table-set! table '##cons           (make-prim-obj riscv-prim-##cons 2 #t #f))

    (table-set! table '##vector-ref     (make-prim-obj (riscv-object-dyn-read-prim vector-obj-desc) 2 #t #t))
    (table-set! table '##vector-set!    (make-prim-obj (riscv-object-dyn-set-prim vector-obj-desc) 3 #t #f))
    (table-set! table '##vector-length  (make-prim-obj (riscv-prim-##vector-length #f) 1 #t #t))

    table))

;;==============================================================================
