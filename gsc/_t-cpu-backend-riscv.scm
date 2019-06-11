;;==============================================================================

;;; File: "_t-cpu-backend-riscv.scm"

;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

(include "generic.scm")

(include-adt "_riscv#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

;; Constants

(define riscv-nb-gvm-regs 5)
(define riscv-nb-arg-regs 3)

;;------------------------------------------------------------------------------
;;------------------------------- RISC-V backend -------------------------------
;;------------------------------------------------------------------------------

(define (riscv-target)
  (make-cpu-target
    (riscv-abstract-machine-info)
    'riscv '((".c" . RISCV)) riscv-nb-gvm-regs riscv-nb-arg-regs)) ; XXX

(define (riscv-abstract-machine-info)
  (make-backend make-cgc-riscv (riscv-info) (riscv-instructions) (riscv-routines)))

(define (make-cgc-riscv)
  (let ((cgc (make-codegen-context)))
    (codegen-context-listing-format-set! cgc 'gnu)
    (asm-init-code-block cgc 0 'le)
    (riscv-arch-set! cgc 'RV32I)
    cgc))

;;------------------------------------------------------------------------------

;; RISC-V backend info

(define (riscv-info)
  (make-cpu-info
    'RV32I                ;; Arch name
    4                     ;; Word width
    'le                   ;; Endianness
    #t                    ;; Load-store architecture?
    0                     ;; Frame offset
    riscv-primitive-table ;; Primitive table
    riscv-nb-gvm-regs     ;; GVM register count
    riscv-nb-arg-regs     ;; GVM register count for passing arguments
    riscv-registers       ;; Main registers
    (riscv-s0)            ;; Processor state pointer
    (riscv-sp)            ;; Stack pointer
    (riscv-s1)))          ;; Heap pointer

(define riscv-registers
  (vector
    (riscv-s2)
    (riscv-s3)
    (riscv-s4)
    (riscv-s5)
    (riscv-s6)))

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

(define (riscv-label-align cgc label-opnd #!optional (align '(4 . 0)))
  (asm-align cgc (car align) (cdr align)) ; XXX NOP in RV32I is 4 bytes with value 0x13
  (riscv-label cgc (lbl-opnd-label label-opnd)))

(define riscv-data-instr
  (make-am-data riscv-db riscv-dh riscv-dw riscv-dd))

; TODO Deduplicate labels
(define (riscv-load-lbl cgc rd lbl-opnd)
  (let ((label (lbl-opnd-label lbl-opnd)))
    (riscv-load-data cgc rd
      (asm-label-id label) ; XXX
      (lambda (cgc)
        (codegen-fixup-lbl! cgc label object-tag #f 32 2 #f)))))

; TODO Deduplicate objects
(define (riscv-load-obj cgc rd obj-value)
  (riscv-load-data cgc rd
    (string-append "'" (object->string obj-value)) ; XXX
    (lambda (cgc)
      (codegen-fixup-obj! cgc obj-value 32 2 #f))))

; TODO Deduplicate references to global variables
(define (riscv-load-glo cgc rd glo-name)
  (riscv-load-data cgc rd
    (string-append "&global[" (symbol->string glo-name) "]") ; XXX
    (lambda (cgc)
      (codegen-fixup-glo! cgc glo-name 32 2 #f))))

(define (riscv-load-data cgc rd ref-name place-data)
  (define cgc-format? (codegen-context-listing-format cgc))

  (codegen-context-listing-format-set! cgc #f)
  (riscv-lui cgc rd (riscv-imm-int 0 'U))
  (riscv-addi cgc rd (riscv-zero) (riscv-imm-int 0))

  (if cgc-format?
      (let ((sym (if ref-name
                     (if (symbol? ref-name)
                         (symbol->string ref-name)
                         ref-name)
                     "???")))
        (riscv-listing cgc "lui" rd (string-append "%hi(" sym ")"))
        (riscv-listing cgc "addi" rd (riscv-zero) (string-append "%lo(" sym ")"))
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
    (not (= 0 (modulo (mem-opnd-offset mem-opnd) 4))))

  (define (regular-move src)
    (if (not (equal? dst src))
        (cond
          ((reg-opnd? dst)
           (riscv-mv cgc (make-riscv-opnd dst) src))
          ((glo-opnd? dst)
           (get-free-register cgc
             (list dst src src) ; XXX
             (lambda (reg)
               (riscv-load-glo cgc reg (glo-opnd-name dst))
               (riscv-sd cgc reg src (riscv-imm-int 0 'S))))) ; XXX
          ((mem-opnd? dst)
           (if (unaligned-mem-opnd? dst)
               (get-free-register cgc
                 (list dst src src) ; XXX
                 (lambda (reg)
                   (am-add cgc reg (mem-opnd-base dst) (int-opnd (mem-opnd-offset dst)))
                   (riscv-sd cgc reg src (riscv-imm-int 0 'S)))) ; XXX
               (riscv-sd cgc (mem-opnd-base dst) src (riscv-imm-int (mem-opnd-offset dst) 'S)))) ; XXX
          (else
            (compiler-internal-error
              "riscv-mov-instr - Unknown or incompatible destination: " dst)))))

  (if (not (equal? dst src))
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
             (riscv-ld cgc reg reg (riscv-imm-int 0)) ; XXX
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
                   (riscv-ld cgc reg reg (riscv-imm-int 0))) ; XXX
                 (riscv-ld cgc reg (mem-opnd-base src) (riscv-imm-int (mem-opnd-offset src)))) ; XXX
             (regular-move reg))))
        (else
          (compiler-internal-error "Cannot move : " dst " <- " src)))))

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
      (riscv-j cgc (lbl-opnd-label opnd))
      (load-if-necessary cgc '(reg int lbl) opnd
        (lambda (opnd)
          (if (reg-opnd? opnd)
              (riscv-jr cgc (make-riscv-opnd opnd))
              (riscv-j cgc (make-riscv-opnd opnd)))))))

(define (riscv-branch-instrs condition)
  (define (flip pair)
    (cons (cdr pair) (car pair)))

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
                 ((car instrs) cgc reg1 reg2 (lbl-opnd-label loc-true))
                 (riscv-j cgc (lbl-opnd-label loc-false)))
                ((and loc-true (not loc-false))
                 ((car instrs) cgc reg1 reg2 (lbl-opnd-label loc-true)))
                ((and (not loc-true) loc-false)
                 ((cdr instrs) cgc reg1 reg2 (lbl-opnd-label loc-false)))))))))

; TODO riscv-cmp-move-instr

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
      (am-mov cgc temp1 (int-opnd (- tag-mult 1)))
      (riscv-and cgc temp2 arg1 temp1) ; XXX
      (am-cond-return cgc result-action
        (lambda (cgc lbl) (riscv-beq cgc temp1 temp2 (make-riscv-opnd lbl)))
        (lambda (cgc lbl) (riscv-bne cgc temp1 temp2 (make-riscv-opnd lbl)))
        true-opnd: (int-opnd (format-imm-object #t))
        false-opnd: (int-opnd (format-imm-object #f))))))

(define riscv-prim-##pair?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (am-mov cgc temp1 (int-opnd (- tag-mult 1)))
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
      (riscv-andi cgc temp2 arg1 (riscv-imm-int (- tag-mult 1))) ; XXX
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
            (riscv-beq cgc (car args) (cadr args) (lbl-opnd-label lbl)))
          (lambda (cgc lbl) ; XXX Overflow
            (riscv-slt cgc (car args) result-reg (car args))
            (riscv-sltz cgc (cadr args) (cadr args))
            (riscv-bne cgc (car args) (cadr args) (lbl-opnd-label lbl)))
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
              (riscv-bne cgc opnd1 opnd2 (lbl-opnd-label lbl)))
            (lambda (cgc lbl) ; XXX Overflow
              (riscv-slt cgc opnd1 result-reg opnd1)
              (riscv-sltz cgc opnd2 opnd2)
              (riscv-beq cgc opnd1 opnd2 (lbl-opnd-label lbl)))
            true-opnd: result-reg
            false-opnd: (int-opnd (format-imm-object #f))))))))

(define (riscv-compare-prim condition)
  (foldl-compare-prim
    (lambda (cgc opnd1 opnd2 true-label false-label)
      (am-compare-jump cgc
        condition
        opnd1 opnd2
        false-label true-label
        (get-word-width-bits cgc)))
    allowed-opnds1: '(reg mem)
    allowed-opnds2: '(reg int)))

(define riscv-prim-##fx<  (riscv-compare-prim (condition-greater #t #t)))
(define riscv-prim-##fx<= (riscv-compare-prim (condition-greater #f #t)))
(define riscv-prim-##fx>  (riscv-compare-prim (condition-lesser #t #t)))
(define riscv-prim-##fx>= (riscv-compare-prim (condition-lesser #f #t)))
(define riscv-prim-##fx=  (riscv-compare-prim condition-not-equal))

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

(define riscv-prim-##null?
  (const-nargs-prim 1 0 (list (lambda (_) #t))
    (lambda (cgc result-action args arg1)
      (am-if-eq cgc arg1 (make-obj-opnd '())
        (lambda (cgc) (am-return-const cgc result-action #t))
        (lambda (cgc) (am-return-const cgc result-action #f))
        #f
        (get-word-width-bits cgc)))))

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
      #f 1234 #f)
    #f))

(define riscv-primitive-table
  (let ((table (make-table test: equal?)))
    (table-set! table '##identity       (make-prim-obj ##identity-primitive 1 #t #t))
    (table-set! table '##not            (make-prim-obj ##not-primitive 1 #t #t))

    (table-set! table '##fixnum?        (make-prim-obj riscv-prim-##fixnum?        1 #t #t))
    (table-set! table '##pair?          (make-prim-obj riscv-prim-##pair?          1 #t #t))
    (table-set! table '##special?       (make-prim-obj riscv-prim-##special?       1 #t #t))
    (table-set! table '##mem-allocated? (make-prim-obj riscv-prim-##mem-allocated? 1 #t #t))

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

    (table-set! table '##cons           (make-prim-obj riscv-prim-##cons 2 #t #f))
    (table-set! table '##null?          (make-prim-obj riscv-prim-##null? 2 #t #f))

    (table-set! table '##car            (make-prim-obj (object-read-prim pair-obj-desc 2) 1 #t #f))
    (table-set! table '##cdr            (make-prim-obj (object-read-prim pair-obj-desc 1) 1 #t #f))
    (table-set! table '##set-car!       (make-prim-obj (object-set-prim pair-obj-desc 2) 2 #t #f))
    (table-set! table '##set-cdr!       (make-prim-obj (object-set-prim pair-obj-desc 1) 2 #t #f))

    (table-set! table '##vector-ref     (make-prim-obj (riscv-object-dyn-read-prim vector-obj-desc) 2 #t #t))
    (table-set! table '##vector-set!    (make-prim-obj (riscv-object-dyn-set-prim vector-obj-desc) 3 #t #f))
    (table-set! table '##vector-length  (make-prim-obj (riscv-prim-##vector-length #f) 1 #t #t))

    table))

;;==============================================================================
