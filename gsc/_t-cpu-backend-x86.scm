;;==============================================================================

;;; File: "_t-cpu-backend-x86.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

;; Constants

; (define x86-narg-register  (x86-cl))  ;; number of arguments register

;;------------------------------------------------------------------------------
;;----------------------------  x86 32-bit backend  ----------------------------
;;------------------------------------------------------------------------------

(define (x86-32-target)
  (cpu-make-target
    'x86 '((".c" . X86))
    (make-backend make-cgc-x86-32 (x86-32-info) (x86-instructions) (x86-routines))))

(define (make-cgc-x86-32)
  (let ((cgc (make-codegen-context)))
    (codegen-context-listing-format-set! cgc 'gnu)
    (asm-init-code-block cgc 0 'le)
    (x86-arch-set! cgc 'x86-32)
    cgc))

;;------------------------------------------------------------------------------
;;----------------------------  x86 64-bit backend  ----------------------------
;;------------------------------------------------------------------------------

(define (x86-64-target)
  (cpu-make-target
    'x86-64 '((".c" . X86-64))
    (make-backend make-cgc-x86-64 (x86-64-info) (x86-instructions) (x86-routines))))

(define (make-cgc-x86-64)
  (let ((cgc (make-codegen-context)))
    (codegen-context-listing-format-set! cgc 'gnu)
    (asm-init-code-block cgc 0 'le)
    (x86-arch-set! cgc 'x86-64)
    cgc))

;;------------------------------------------------------------------------------

;; x86 backend info

(define (x86-32-info)
  (cpu-make-info
    'x86-32                 ;; Arch name
    4                       ;; Word width
    'le                     ;; Endianness
    #f                      ;; Load store architecture?
    0                       ;; Frame offset
    2                       ;; Closure trampoline size
    x86-primitive-table     ;; Primitive table
    cpu-default-nb-gvm-regs ;; GVM register count
    cpu-default-nb-arg-regs ;; GVM register count for passing arguments
    x86-32-registers        ;; Main registers
    (x86-ecx)               ;; Processor state pointer
    (x86-esp)               ;; Stack pointer
    (x86-ebp)               ;; Heap pointer
  ))

(define x86-32-registers
  (vector
    (x86-edi)   ;; R0
    (x86-eax)   ;; R1
    (x86-ebx)   ;; R2
    (x86-edx)   ;; R3
    (x86-esi))) ;; R4

;;------------------------------------------------------------------------------

;; x86 64-bit backend info

(define (x86-64-info)
  (cpu-make-info
    'x86-64                 ;; Arch name
    8                       ;; Word width
    'le                     ;; Endianness
    #f                      ;; Load store architecture?
    0                       ;; Frame offset
    1                       ;; Closure trampoline size
    x86-primitive-table     ;; Primitive table
    cpu-default-nb-gvm-regs ;; GVM register count
    cpu-default-nb-arg-regs ;; GVM register count for passing arguments
    x86-64-registers        ;; Main registers
    (x86-rcx)               ;; Processor state pointer
    (x86-rsp)               ;; Stack pointer
    (x86-rbp)               ;; Heap pointer
  ))

;; Registers
(define x86-64-registers
  (vector
    (x86-rdi) ;; R0
    (x86-rax) ;; R1
    (x86-rbx) ;; R2
    (x86-rdx) ;; R3
    (x86-rsi) ;; R4
    (x86-r8)
    (x86-r9)
    (x86-r10)
    (x86-r11)
    (x86-r12)
    (x86-r13)
    (x86-r14)
    (x86-r15)))

;;------------------------------------------------------------------------------

;; x86 Abstract machine instructions

(define (x86-instructions)
  (make-instruction-dictionnary
    x86-label-align            ;; am-lbl
    x86-data-instr             ;; am-data
    x86-mov-instr              ;; am-mov
    (x86-arith-instr x86-add)  ;; am-add
    (x86-arith-instr x86-sub)  ;; am-sub
    (x86-arith-instr x86-imul) ;; am-mul
    (x86-arith-instr x86-idiv) ;; am-div
    x86-jmp-instr              ;; am-jmp
    x86-cmp-jump-instr         ;; am-compare-jump
    x86-cmp-move-instr))       ;; am-compare-move

(define (make-x86-opnd opnd)
  (cond
    ((reg-opnd? opnd) opnd)
    ((int-opnd? opnd) (x86-imm-int (int-opnd-value opnd)))
    ((mem-opnd? opnd)
      (x86-mem
        (mem-opnd-offset opnd) (mem-opnd-base opnd)
        (mem-opnd-reg-offset opnd) (mem-opnd-scale opnd)))
    ((lbl-opnd? opnd) (x86-imm-lbl (lbl-opnd-label opnd) (lbl-opnd-offset opnd)))
    ((obj-opnd? opnd) (x86-imm-obj (obj-opnd-value opnd)))
    ((glo-opnd? opnd) (x86-imm-glo (glo-opnd-name opnd)))
    (else (compiler-internal-error "make-x86-opnd - Unknown opnd: " opnd))))

(define (shrink-x86-opnd opnd opnd-width width)
  ;; Todo: use vector
  (define regs (list
    (x86-al)   (x86-ax)   (x86-eax)  (x86-rax)
    (x86-cl)   (x86-cx)   (x86-ecx)  (x86-rcx)
    (x86-dl)   (x86-dx)   (x86-edx)  (x86-rdx)
    (x86-bl)   (x86-bx)   (x86-ebx)  (x86-rbx)
    (x86-spl)  (x86-sp)   (x86-esp)  (x86-rsp)
    (x86-bpl)  (x86-bp)   (x86-ebp)  (x86-rbp)
    (x86-sil)  (x86-si)   (x86-esi)  (x86-rsi)
    (x86-dil)  (x86-di)   (x86-edi)  (x86-rdi)
    (x86-r8b)  (x86-r8w)  (x86-r8d)  (x86-r8)
    (x86-r9b)  (x86-r9w)  (x86-r9d)  (x86-r9)
    (x86-r10b) (x86-r10w) (x86-r10d) (x86-r10)
    (x86-r11b) (x86-r11w) (x86-r11d) (x86-r11)
    (x86-r12b) (x86-r12w) (x86-r12d) (x86-r12)
    (x86-r13b) (x86-r13w) (x86-r13d) (x86-r13)
    (x86-r14b) (x86-r14w) (x86-r14d) (x86-r14)
    (x86-r15b) (x86-r15w) (x86-r15d) (x86-r15)))

  (cond
    ((x86-reg? opnd)
      (let* ((index (pos-in-list opnd regs))
             (row (quotient index 4))
             (new-col (- (integer-length (/ width 8)) 1))
             (new-index (+ new-col (* 4 row))))
        (cons (list-ref regs new-index) width)))
    ((x86-mem? opnd) (cons opnd width))
    (else (cons opnd opnd-width))))

; (define (apply-and-mov fun)
;   (lambda (cgc result-reg opnd1 opnd2)
;     (if (equal? result-reg opnd1)
;         (fun cgc result-reg opnd2)
;         (begin
;           (x86-mov cgc result-reg opnd1)
;           (fun cgc result-reg opnd2)))))

(define (x86-arith-instr instr)
  (lambda (cgc result-loc opnd1 opnd2)
    (let ((x86-result-loc (make-x86-opnd result-loc))
          (x86-opnd1 (make-x86-opnd opnd1))
          (x86-opnd2 (make-x86-opnd opnd2)))
      ; TODO Optimize mul/div using shifts if possible
      ; TODO 0 - something should use NEG
      (if (equal? result-loc opnd1)
          (instr cgc x86-result-loc x86-opnd2)
          (begin
            (x86-mov cgc x86-result-loc x86-opnd1)
            (instr cgc x86-result-loc x86-opnd2))))))

(define (x86-label-align cgc label-opnd #!optional (align #f))
  (if align (asm-align cgc (car align) (cdr align) #x90))
  (x86-label cgc (lbl-opnd-label label-opnd)))

(define x86-data-instr
  (make-am-data x86-db x86-dw x86-dd x86-dq))

;; Args : CGC, reg/mem/label, reg/mem/imm/label/glo
(define (x86-mov-instr cgc dst src #!optional (width #f))
  (define dst-type (opnd-type dst))
  (define src-type (opnd-type src))

  (define x86-src (make-x86-opnd src))
  (define x86-dst (make-x86-opnd dst))

  ;; new-src can be directly used as an operand to mov
  (define (mov-in-dst new-src)
    (define x86-new-src (make-x86-opnd new-src))
    (if (not (equal? dst new-src))
      (if (equal? dst-type 'ind)
        (get-free-register cgc (list dst src new-src)
          (lambda (reg-dst)
            (x86-mov cgc reg-dst x86-dst)
            (x86-mov cgc (x86-mem 0 reg-dst) x86-new-src width)))
        (x86-mov cgc x86-dst x86-new-src width))))

  (if (not (equal? dst src))
    (cond
      ((or
        (and
          (equal? src-type 'int) (not (asm-signed32? (int-opnd-value src))))
        (and
          (or (equal? dst-type 'mem) (equal? dst-type 'ind))
          (or (equal? src-type 'mem) (equal? src-type 'lbl))))
          (get-free-register cgc (list src)
            (lambda (reg-src)
              (x86-mov cgc reg-src x86-src)
              (mov-in-dst reg-src))))

      ((equal? src-type 'ind)
        (let ((action
                (lambda (reg-src)
                  (x86-mov cgc reg-src x86-src)
                  (x86-mov cgc reg-src (x86-mem 0 reg-src))
                  (mov-in-dst reg-src))))
          (if (equal? dst-type 'reg)
            (action dst)
            (get-free-register cgc (list src) action))))

      (else
        (mov-in-dst src)))))

(define (x86-jmp-instr cgc opnd)
  (if (lbl-opnd? opnd)
    (x86-jmp cgc (lbl-opnd-label opnd))
    (load-if-necessary cgc '(reg int mem lbl) opnd
      (lambda (opnd)
        (x86-jmp cgc (make-x86-opnd opnd))))))

(define (get-jumps condition)
  (case (get-condition condition)
    ((equal)
      (cons x86-je x86-jne))
    ((greater)
      (cond
        ((and (cond-is-equal condition) (cond-is-signed condition))
          (cons x86-jge x86-jl))
        ((and (not (cond-is-equal condition)) (cond-is-signed condition))
          (cons x86-jg x86-jle))
        ((and (cond-is-equal condition) (not (cond-is-signed condition)))
          (cons x86-jae x86-jb))
        ((and (not (cond-is-equal condition)) (not (cond-is-signed condition)))
          (cons x86-ja x86-jbe))))
    ((not-equal) (flip (get-jumps (invert-condition condition))))
    ((lesser) (flip (get-jumps (invert-condition condition))))
    (else
      (compiler-internal-error "get-jumps - Unknown condition: " condition))))

(define (x86-cmp-jump-instr cgc test loc-true loc-false #!optional (opnds-width #f))
  (let ((condition (test-condition test))
        (opnd1 (test-operand1 test))
        (opnd2 (test-operand2 test))
        (jumps (get-jumps (test-condition test))))

    ;; In case both jump locations are false, the cmp is unnecessary.
    (if (or loc-true loc-false)
      (load-multiple-if-necessary cgc '((reg mem) (reg mem int)) (list opnd1 opnd2)
        (lambda (opnd1 opnd2)
          (x86-cmp cgc
            (make-x86-opnd opnd1)
            (make-x86-opnd opnd2)
            opnds-width))))

    (cond
      ((and loc-false loc-true)
        ((car jumps) cgc (lbl-opnd-label loc-true))
        (x86-jmp cgc (lbl-opnd-label loc-false)))
      ((and (not loc-true) loc-false)
        ((cdr jumps) cgc (lbl-opnd-label loc-false)))
      ((and loc-true (not loc-false))
        ((car jumps) cgc (lbl-opnd-label loc-true))))))

(define (get-moves condition) ; XXX
  (case (get-condition condition)
    ((equal)
      (cons x86-cmove x86-cmovne))
    ((greater)
      (cond
        ((and (cond-is-equal condition) (cond-is-signed condition))
          (cons x86-cmovge x86-cmovl))
        ((and (not (cond-is-equal condition)) (cond-is-signed condition))
          (cons x86-cmovg x86-cmovle))
        ((and (cond-is-equal condition) (not (cond-is-signed condition)))
          (cons x86-cmovae x86-cmovb))
        ((and (not (cond-is-equal condition)) (not (cond-is-signed condition)))
          (cons x86-cmova x86-cmovbe))))
    ((not-equal) (flip (get-moves (invert-condition condition))))
    ((lesser) (flip (get-moves (invert-condition condition))))
    (else
      (compiler-internal-error "get-moves - Unknown condition: " condition))))

(define (x86-cmp-move-instr cgc test dest true-opnd false-opnd #!optional (opnds-width #f))
  (let ((condition (test-condition test))
        (opnd1 (test-operand1 test))
        (opnd2 (test-operand2 test))
        (moves (get-moves (test-condition test))))

    ;; In case both operands are false, the cmp is unnecessary.
    (if (or true-opnd false-opnd)
      (load-multiple-if-necessary cgc '((reg mem) (reg mem int)) (list opnd1 opnd2)
        (lambda (opnd1 opnd2)
          (x86-cmp cgc
            (make-x86-opnd opnd1)
            (make-x86-opnd opnd2)
            opnds-width))))

    (cond
      ((and true-opnd false-opnd)
        (am-mov cgc dest true-opnd)
        ((cdr moves) cgc
          (make-x86-opnd dest)
          (make-x86-opnd false-opnd)
          opnds-width))
      ((and true-opnd (not false-opnd))
        ((car moves) cgc
          (make-x86-opnd dest)
          (make-x86-opnd true-opnd)
          opnds-width))
      ((and (not true-opnd) false-opnd)
        ((cdr moves) cgc
          (make-x86-opnd dest)
          (make-x86-opnd false-opnd)
          opnds-width)))))

;;------------------------------------------------------------------------------

;; Backend routines

(define (x86-routines)
  (make-routine-dictionnary
    am-default-poll
    am-default-set-nargs
    am-default-check-nargs
    (am-default-allocate-memory
      (lambda (cgc dest-reg base-reg offset)
        (x86-lea cgc dest-reg (x86-mem offset base-reg))))
    am-default-place-extra-data))

; (define (x86-check-nargs-simple cgc arg-count jmp-loc error-label if-equal?)
;   (let ((narg-field (get-processor-state-field cgc 'nargs)))

;     (x86-cmp cgc (car narg-field) (int-opnd arg-count) (cdr narg-field))
;     (if if-equal?
;       (x86-je cgc jmp-loc)
;       (x86-jne cgc jmp-loc))
;     (x86-jmp cgc error-label)))

; (define use-f-flag #t)
; ;; Must be ordered and can't be longer than 5
; (define nargs-passed-in-flags '(0 1 2 3 4))

; (define (narg-index nargs) (index-of nargs nargs-passed-in-flags))
; (define (passed-in-ps nargs) (= -1 (narg-index nargs)))
; (define (passed-in-flags nargs) (not (passed-in-ps nargs)))

; (define (x86-set-nargs cgc nargs)
;   ;; set flags = jb  jne jle jno jp  jbe jl  js   wrong_na = jae
;   (define (flags-a) (x86-cmp cgc x86-narg-register (x86-imm-int -3)))
;   ;; set flags = jae je  jle jno jp  jbe jge jns  wrong_na = jne
;   (define (flags-b) (x86-cmp cgc x86-narg-register x86-narg-register))
;   ;; set flags = jae jne jg  jno jp  ja  jge jns  wrong_na = jle
;   (define (flags-c) (x86-cmp cgc x86-narg-register (x86-imm-int -123)))
;   ;; set flags = jae jne jle jo  jp  ja  jl  jns  wrong_na = jno
;   (define (flags-d) (x86-cmp cgc x86-narg-register (x86-imm-int 10)))
;   ;; set flags = jae jne jle jno jnp ja  jl  js   wrong_na = jp
;   (define (flags-e) (x86-cmp cgc x86-narg-register (x86-imm-int 2)))
;   ;; set flags = jae jne jle jno jp  ja  jl  js
;   (define (flags-f) (x86-cmp cgc x86-narg-register (x86-imm-int 0)))

;   (define (set-ps-na arg-count)
;     (let ((na-opnd (get-processor-state-field cgc 'nargs)))
;       (x86-mov cgc (car na-opnd) (x86-imm-int arg-count) (cdr na-opnd))))

;   (define all-tests
;     (list flags-a flags-b flags-c flags-d flags-e))
;   (define tests
;     (if use-f-flag all-tests (cdr all-tests)))

;   (if (passed-in-ps nargs)
;     ;; Use processor state to pass narg
;     (begin
;       (set-ps-na nargs)
;       (if use-f-flag
;         (flags-f)
;         (flags-a)))
;     ;; Use flag register
;     ((list-ref tests (narg-index nargs)))))

; ;; The function returns if it checked the flags
; (define (x86-check-nargs-simple cgc arg-count jmp-loc error-label if-equal?
;           #!optional (check-flags #t))
;   ;; a flags = jb  jne jle jno jp  jbe jl  js   wrong_na = jae
;   ;; b flags = jae je  jle jno jp  jbe jge jns  wrong_na = jne
;   ;; c flags = jae jne jg  jno jp  ja  jge jns  wrong_na = jle
;   ;; d flags = jae jne jle jo  jp  ja  jl  jns  wrong_na = jno
;   ;; e flags = jae jne jle jno jnp ja  jl  js   wrong_na = jp
;   ;; f flags = jae jne jle jno jp  ja  jl  js   no jump
;   (define (check-a label)               (x86-jb  cgc label))
;   (define (check-not-a label)           (x86-jae cgc label))
;   (define (check-b label)               (x86-je  cgc label))
;   (define (check-not-b label)           (x86-jne cgc label))
;   (define (check-c label)               (x86-jg  cgc label))
;   (define (check-not-c label)           (x86-jle cgc label))
;   (define (check-d label)               (x86-jo  cgc label))
;   (define (check-not-d label)           (x86-jno cgc label))
;   (define (check-e label)               (x86-jnp cgc label))
;   (define (check-not-e label)           (x86-jp  cgc label))
;   (define (check-ab label)              (x86-jbe cgc label))
;   (define (check-not-a-or-b label)      (x86-ja  cgc label))
;   (define (check-bc label)              (x86-jge cgc label))
;   (define (check-not-b-or-c label)      (x86-jl  cgc label))
;   (define (check-bcd label)             (x86-jns cgc label))
;   (define (check-not-b-or-c-or-d label) (x86-js  cgc label))

;   (define (check-ps-na arg-count label)
;     (let ((na-opnd (get-processor-state-field cgc 'nargs)))
;       (x86-cmp cgc (car na-opnd) (x86-imm-int arg-count) (cdr na-opnd))
;       (if if-equal?
;         (x86-je cgc label)
;         (x86-jne cgc label))))

;   (define all-negative-tests
;     (list check-not-a check-not-b check-not-c check-not-d check-not-e))
;   (define negative-tests
;     (if use-f-flag all-negative-tests (cdr all-negative-tests)))

;   (define all-positive-tests
;     (list check-a check-b check-c check-d check-e))
;   (define positive-tests
;     (if use-f-flag all-positive-tests (cdr all-positive-tests)))

;   (if (passed-in-ps arg-count)
;     ;; Use processor state to pass narg
;     (begin
;       (if check-flags
;         (if use-f-flag
;           (begin
;             (check-a   error-label)
;             (check-bcd error-label)
;             (check-e   error-label))
;           (check-not-a jmp-loc)))
;       (check-ps-na arg-count jmp-loc)
;       #f)
;     ;; Use flag register
;     (begin
;       ((list-ref
;         (if if-equal? positive-tests negative-tests)
;         (narg-index arg-count))
;         jmp-loc)
;       #t)))

; (define (x86-check-nargs cgc fun-label fs nargs optional-args-values rest? place-label-fun)
;   ;; Constants
;   (define target (codegen-context-target cgc))
;   (define nargs-in-regs (target-nb-arg-regs target))

;   (define nargs-in-flags? (elem? nargs nargs-passed-in-flags))

;   (define opts-count (length optional-args-values))
;   (define nargs-no-rest (- nargs (if rest? 1 0)))
;   (define nargs-no-opts (- nargs-no-rest opts-count))

;   (define continue-label (make-unique-label cgc "continue" #f))
;   (define pop-label      (make-unique-label cgc "restore-flags" #f))
;   (define error-label    (make-unique-label cgc "narg-error" #f))
;   (define rest-label     (make-unique-label cgc "get-rest" #f))

;   (define (make-label-curried prefix)
;     (lambda (i) (make-unique-label cgc
;       (string-append prefix (number->string i)) #f)))

;   (define check-flags #t)
;   ;; Places switch for optional parameters
;   ;; Moves the parameters to the right position if necessary
;   ;; Moves the default values if necessary
;   (define (place-optional-arguments-switch)
;     ;; Places the arguments in their correct place
;     (define (mov-arguments-in-correct-position arg-count)
;       (let ((min-frame-to-move (max 1 (+ 1 (- arg-count nargs-in-regs)))))
;         (for-each
;           (lambda (n)
;             (let ((dst (get-nth-arg cgc fs nargs n))
;                   (src (get-nth-arg cgc fs arg-count n)))
;               (am-mov cgc dst src (get-word-width-bits cgc))))
;           (iota arg-count min-frame-to-move))))

;     (define (place-case arg-count case-label next-case-label)
;       (am-lbl cgc case-label)
;       (if (not (x86-check-nargs-simple cgc arg-count next-case-label error-label #f check-flags))
;         (set! check-flags #f))

;       ;; Merge with x86-frame-pointer adjustement
;       (if (and rest? (not nargs-in-flags?)) (x86-popf cgc))

;       ;; When called with not all arguments, the frame size needs to be adjusted.
;       (let* ((nargs-in-frames (max 0 (- arg-count nargs-in-regs)))
;              (offset (- fs nargs-in-frames)))
;         (if (not (= 0 offset))
;           (am-sub cgc
;             (get-frame-pointer cgc)
;             (get-frame-pointer cgc)
;             (int-opnd (* (get-word-width cgc) offset)))))

;       (mov-arguments-in-correct-position arg-count)

;       ;; Places the default values
;       (let* ((optional-opnds
;               (map (lambda (val) (make-opnd cgc val)) optional-args-values))
;             (default-values-to-move
;               (drop-n optional-opnds (- arg-count nargs-no-opts))))

;         (for-each
;           (lambda (default-value i)
;             (am-mov cgc
;               (get-nth-arg cgc fs nargs (+ arg-count i 1))
;               default-value
;               (get-word-width-bits cgc)))

;           default-values-to-move
;           (iota (length default-values-to-move)))

;         ;; Place empty list
;         (if rest?
;           (am-mov cgc
;             (get-nth-arg cgc fs nargs nargs)
;             (obj-opnd '())
;             (get-word-width-bits cgc))))

;       (am-jmp cgc continue-label))

;     (let* ((nargs-to-test (iota nargs-no-rest nargs-no-opts))
;            (last-label (if rest? rest-label error-label)))

;       ;; Because testing ps->nargs changes the flags register,
;       ;; we need to test the flags first. We then test ps->na.
;       (let* ((nargs-to-test-flags (filter
;                 (lambda (n) (elem? n nargs-passed-in-flags))
;                 nargs-to-test))
;              (nargs-to-test-ps (filter
;                 (lambda (n) (not (elem? n nargs-passed-in-flags)))
;                 nargs-to-test))
;              (cases (append nargs-to-test-flags nargs-to-test-ps))
;              (case-labels (map (make-label-curried "opt-case_") cases)))
;         (if (not (null? case-labels))
;           (for-each place-case
;             cases
;             case-labels
;             (append (cdr case-labels) (list last-label)))))))

;   (define (place-get-rest-code)
;     (let* ((invalid-flags-to-test
;              (filter
;                 (lambda (n) (< n nargs-no-rest))
;                 nargs-passed-in-flags))
;            (call-rest-handler (make-unique-label cgc "call-rest-handler" #f))
;            (return-from-get-rest (make-unique-label cgc "return-from-get-rest" #f))
;            (narg-field (get-processor-state-field cgc 'nargs))
;            (temp1-field (get-processor-state-field cgc 'temp1))
;            (rest-handler (get-processor-state-field cgc 'handler_get_rest)))

;       ;; Optimize case with 0 elem
;       ;; Todo: Fix case where nargs-passed-in-flags doesn't contain 0.
;       ;; Maybe replace check-flags by #f. Check if doesn't break everything...
;       (x86-check-nargs-simple cgc nargs-no-rest call-rest-handler error-label #f check-flags)
;       (if (not nargs-in-flags?) (x86-popf cgc))   ;; Replace with pop? Maybe faster
;       (am-mov cgc
;         (get-nth-arg cgc fs nargs nargs)
;         (obj-opnd '())
;         (get-word-width-bits cgc))
;       (am-sub cgc                           ;; Adjusts the frame pointer
;         (get-frame-pointer cgc)
;         (get-frame-pointer cgc)
;         (int-opnd (* (get-word-width cgc) 1)))
;       (am-jmp cgc continue-label)

;       (am-lbl cgc call-rest-handler)
;       (if nargs-in-flags? (x86-pushf cgc)) ;; Save flags if not saved before
;       (x86-cmp cgc (car narg-field) (int-opnd 0) (cdr narg-field))
;       (x86-js cgc return-from-get-rest)
;       (x86-popf cgc)

;       ;; Jump to rest handler here
;       (am-mov cgc (car temp1-field) fun-label (cdr temp1-field))
;       (am-jmp cgc (car rest-handler))

;       ;; Jump to continue after restoring flags
;       (am-lbl cgc return-from-get-rest)
;       (x86-popf cgc)
;       (am-mov cgc
;         (car narg-field)
;         (int-opnd 0)
;         (cdr narg-field))
;       (am-jmp cgc continue-label)))

;   ;; Error handler
;   (let ((temp1-field (get-processor-state-field cgc 'temp1))
;         (narg-field (get-processor-state-field cgc 'nargs))
;         (error-handler (get-processor-state-field cgc 'handler_wrong_nargs)))
;     (am-lbl cgc error-label)
;     (if (not nargs-in-flags?) (x86-popf cgc))
;     (am-mov cgc (car temp1-field) fun-label (cdr temp1-field))
;     (am-jmp cgc (car error-handler)))

;   (place-label-fun fun-label)

;   (if (and (null? optional-args-values) (not rest?))
;     ;; Basic case
;     (if nargs-in-flags?
;         (x86-check-nargs-simple cgc nargs error-label error-label #f)
;         (begin
;           (x86-pushf cgc)
;           (x86-check-nargs-simple cgc nargs error-label error-label #f)))
;           ;; Then continues to pop-label

;     ;; Optional and rest arguments case
;     (if rest?
;       ;; If rest
;       (begin
;         ;; Save flags register if necessary
;         (if (not nargs-in-flags?) (x86-pushf cgc))
;         (if (not (= 0 opts-count))
;           (place-optional-arguments-switch))
;         (am-lbl cgc rest-label)
;         (place-get-rest-code))

;       ;; If not rest
;       (place-optional-arguments-switch)))

;   (if (not nargs-in-flags?)
;     (begin
;       (am-lbl cgc pop-label)
;       (x86-popf cgc)))
;   (am-lbl cgc continue-label))

;;------------------------------------------------------------------------------

;; Primitives

(define (make-function-x86-opnds func)
  (lambda (cgc . args) (apply func (cons cgc (map make-x86-opnd args)))))

(define x86-prim-##fixnum?
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let* ((width (get-word-width-bits cgc))
             (x86-opnd (make-x86-opnd arg1))
             (shrinked-opnd (shrink-x86-opnd x86-opnd width 8)))
        (x86-test cgc
          (car shrinked-opnd)
          (x86-imm-int type-tag-mask)
          (cdr shrinked-opnd))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-je cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jne  cgc (lbl-opnd-label lbl)))
          true-opnd: (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

;; Todo: Use cx as and bit-test instruction
(define x86-prim-##pair?
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 temp1)
      (let* ((width (get-word-width-bits cgc))
             (x86-arg1 (make-x86-opnd arg1))
             (x86-temp1 (make-x86-opnd temp1))
             (shrinked-temp1 (shrink-x86-opnd x86-temp1 width 8)))
        (am-mov cgc temp1 arg1) ;; Save arg1
        (x86-not cgc temp1)
        (x86-test cgc
          (car shrinked-temp1)
          (x86-imm-int type-tag-mask)
          (cdr shrinked-temp1))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-je  cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jne cgc (lbl-opnd-label lbl)))
          true-opnd: (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define x86-prim-##special?
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 temp1)
      (let* ((width (get-word-width-bits cgc))
             (x86-arg1 (make-x86-opnd arg1))
             (x86-temp1 (make-x86-opnd temp1))
             (shrinked-temp1 (shrink-x86-opnd x86-temp1 width 8)))
        (am-mov cgc temp1 arg1) ;; Save arg1
        (x86-and cgc
          (car shrinked-temp1)
          (x86-imm-int type-tag-mask)
          (cdr shrinked-temp1))
        (x86-cmp cgc
          (car shrinked-temp1)
          (x86-imm-int (type-tag 'special))
          (cdr shrinked-temp1))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-je  cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jne cgc (lbl-opnd-label lbl)))
          true-opnd: (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define x86-prim-##mem-allocated?
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let* ((width (get-word-width-bits cgc))
             (x86-arg1 (make-x86-opnd arg1))
             (shrinked-temp1 (shrink-x86-opnd x86-arg1 width 8)))
        (x86-test cgc
          (car shrinked-temp1)
          (x86-imm-int (fxand (type-tag 'mem1) (type-tag 'mem2)))
          (cdr shrinked-temp1))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-jne cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-je  cgc (lbl-opnd-label lbl)))
          true-opnd: (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define x86-prim-##char?
  (const-nargs-prim 1 2 '((reg mem))
    (lambda (cgc result-action args arg1 temp1 temp2)
      (let* ((width (get-word-width-bits cgc))
             (x86-temp1 (make-x86-opnd temp1))
             (x86-temp2 (make-x86-opnd temp2))
             (test-int (- (desc-type-tag char-desc) (arithmetic-shift 1 (- width 1)))))
        (am-mov cgc temp1 arg1) ;; Save arg1
        (am-mov cgc temp2 (int-opnd test-int) width)
        (x86-and cgc x86-temp1 x86-temp2 width)
        (x86-cmp cgc x86-temp1 (x86-imm-int (desc-type-tag char-desc)) width)
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-je cgc  (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jne cgc (lbl-opnd-label lbl)))
          true-opnd: (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define (x86-prim-##boolean-or? desc)
  (const-nargs-prim 1 1 any-opnds
    (lambda (cgc result-action args arg1 tmp1)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (x86-tmp1 (make-x86-opnd tmp1))
            (test-int (+ ((imm-encoder desc)) (- type-tag-mask (desc-type-tag desc)))))
        (am-mov cgc tmp1 arg1)
        (x86-and cgc x86-tmp1 (x86-imm-int test-int))
        (am-if-eq cgc tmp1 (int-opnd ((imm-encoder desc)))
          (lambda (cgc) (am-return-const cgc result-action #t))
          (lambda (cgc) (am-return-const cgc result-action #f))
          #f
          (get-word-width-bits cgc))))))

(define x86-prim-##type
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let ((x86-arg1 (make-x86-opnd arg1)))
        (x86-and cgc x86-arg1 (x86-imm-int type-tag-mask))
        (x86-shl cgc x86-arg1 (x86-imm-int type-tag-bits))
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##type-cast
  (const-nargs-prim 2 0 '((reg mem))
    (lambda (cgc result-action args arg1 arg2)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (x86-arg2 (make-x86-opnd arg2)))
        (x86-and cgc x86-arg1 (x86-imm-int (fxnot type-tag-mask)))
        (x86-sar cgc x86-arg2 (x86-imm-int type-tag-bits))
        (am-add cgc arg1 arg1 arg2)
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##subtype
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (offset (header-offset 'subtyped (get-word-width cgc))))
        (am-mov cgc arg1 (mem-opnd arg1 offset))
        (x86-and cgc x86-arg1 (x86-imm-int subtype-tag-mask))
        (x86-sar cgc x86-arg1 (x86-imm-int (fx- head-type-tag-bits type-tag-bits)))
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##subtype-set!
  (const-nargs-prim 2 1 '((reg mem))
    (lambda (cgc result-action args arg1 arg2 tmp1)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (x86-arg2 (make-x86-opnd arg2))
            (x86-tmp1 (make-x86-opnd tmp1))
            (offset (header-offset 'subtyped (get-word-width cgc))))
        (am-mov cgc tmp1 (mem-opnd arg1 offset)) ; header
        (x86-and cgc x86-tmp1 (x86-imm-int (fxnot subtype-tag-mask)))
        (x86-shl cgc x86-arg2 (x86-imm-int (fx- head-type-tag-bits type-tag-bits)))
        (am-add cgc tmp1 tmp1 arg2)
        (am-mov cgc (mem-opnd arg1 offset) tmp1)
        (am-return-opnd cgc result-action arg1)))))

(define (x86-prim-##type-ref index)
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let* ((x86-arg1 (make-x86-opnd arg1))
             (width (get-word-width cgc))
             (offset (+ (body-offset 'subtyped width)
                        (fxarithmetic-shift index (fx- (fxlength width) 1)))))
        (am-return-opnd cgc result-action (opnd-with-offset arg1 offset))))))

(define x86-prim-##subtyped?
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1)
      (let ((x86-tmp1 (make-x86-opnd tmp1)))
        (am-mov cgc tmp1 arg1)
        (x86-and cgc x86-tmp1 (x86-imm-int type-tag-mask))
        (x86-cmp cgc x86-tmp1 (x86-imm-int (type-tag 'subtyped)))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-je cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jne cgc (lbl-opnd-label lbl)))
          true-opnd:  (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define (x86-prim-##subtype? subtype-desc) ; XXX
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1)
      (let ((width (get-word-width cgc))
            (x86-tmp1 (make-x86-opnd tmp1)))
        (am-mov cgc tmp1 arg1)
        (x86-and cgc x86-tmp1 (x86-imm-int type-tag-mask))
        (x86-cmp cgc x86-tmp1 (x86-imm-int (type-tag 'subtyped)))
        (am-cond-return cgc result-action
          (lambda (cgc lbl)
            (x86-jne cgc (lbl-opnd-label lbl))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 (header-offset 'subtyped width))) ; XXX
            (x86-and cgc x86-tmp1 (x86-imm-int subtype-tag-mask))
            (x86-cmp cgc x86-tmp1 (x86-imm-int (ref-subtype-tag subtype-desc)))
            (x86-jne cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl)
            (x86-jne cgc (lbl-opnd-label lbl))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 (header-offset 'subtyped width))) ; XXX
            (x86-and cgc x86-tmp1 (x86-imm-int subtype-tag-mask))
            (x86-cmp cgc x86-tmp1 (x86-imm-int (ref-subtype-tag subtype-desc)))
            (x86-jne cgc (lbl-opnd-label lbl)))
          true-opnd:  (int-opnd (imm-encode #f))
          false-opnd: (int-opnd (imm-encode #t)))))))

(define (x86-prim-##subtyped.subtype? subtype-desc) ; XXX
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (offset (header-offset 'subtyped (get-word-width cgc))))
        (am-mov cgc arg1 (mem-opnd arg1 offset))
        (x86-and cgc x86-arg1 (x86-imm-int subtype-tag-mask))
        (am-if-eq cgc arg1 (int-opnd (ref-subtype-tag subtype-desc))
          (lambda (cgc) (am-return-const cgc result-action #t))
          (lambda (cgc) (am-return-const cgc result-action #f))
          #f
          (get-word-width-bits cgc))))))

(define (x86-prim-##cpx-part imag?)
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1)
      (let* ((width (get-word-width cgc))
             (body-offset (+ (body-offset 'subtyped width) (if imag? width 0)))
             (header-offset (header-offset 'subtyped width))
             (x86-tmp1 (make-x86-opnd tmp1)))
        (am-mov cgc tmp1 arg1)
        (x86-and cgc x86-tmp1 (x86-imm-int type-tag-mask))
        (x86-cmp cgc x86-tmp1 (x86-imm-int (type-tag 'subtyped)))
        (am-cond-return cgc result-action
          (lambda (cgc lbl)
            (x86-jne cgc (lbl-opnd-label lbl))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 header-offset))
            (x86-and cgc x86-tmp1 (x86-imm-int subtype-tag-mask))
            (x86-cmp cgc x86-tmp1 (x86-imm-int (subtype-tag 'cpxnum)))
            (x86-jne cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl)
            (x86-jne cgc (lbl-opnd-label lbl))
            (am-mov cgc tmp1 arg1)
            (am-mov cgc tmp1 (opnd-with-offset tmp1 header-offset))
            (x86-and cgc x86-tmp1 (x86-imm-int subtype-tag-mask))
            (x86-cmp cgc x86-tmp1 (x86-imm-int (subtype-tag 'cpxnum)))
            (x86-jne cgc (lbl-opnd-label lbl)))
          true-opnd:  (if imag? (int-opnd (imm-encode 0)) arg1)
          false-opnd: (mem-opnd arg1 body-offset))))))

(define (x86-prim-##fx+ wrap?)
  (foldl-prim
    (make-function-x86-opnds x86-add)
    allowed-opnds: (if wrap? '(reg mem) '(reg mem int))
    allowed-opnds-accum: '(reg mem)
    start-value: 0
    start-value-null?: #t
    reduce-1: am-mov
    commutative: #t))

(define x86-prim-##fx+?
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
      (lambda (result-reg result-opnd-in-args)
        (am-add cgc result-reg (car args) (cadr args))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-jno cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jo  cgc (lbl-opnd-label lbl)))
          true-opnd: result-reg
          false-opnd: (int-opnd (imm-encode #f)))))))

(define (x86-prim-##fx- wrap?)
  (foldl-prim
    (make-function-x86-opnds x86-sub)
    allowed-opnds: (if wrap? '(reg mem) '(reg mem int))
    allowed-opnds-accum: '(reg mem)
    reduce-1: (lambda (cgc dst opnd)
                (am-mov cgc dst opnd)
                (x86-neg cgc (make-x86-opnd dst)))
    commutative: #f))

(define x86-prim-##fx-?
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
            (lambda (cgc lbl) (x86-jno cgc (lbl-opnd-label lbl)))
            (lambda (cgc lbl) (x86-jo  cgc (lbl-opnd-label lbl)))
            true-opnd: result-reg
            false-opnd: (int-opnd (imm-encode #f))))))))

(define (x86-prim-##fx* wrap?)
  (foldl-prim
    (lambda (cgc . args)
      ((if wrap? x86-shr x86-sar) cgc (make-x86-opnd (car args)) (x86-imm-int type-tag-bits))
      (apply am-mul (cons cgc (cons (car args) args))))
    allowed-opnds: (if wrap? '(reg mem) '(reg mem imm))
    allowed-opnds-accum: '(reg mem)
    start-value: 1
    start-value-null?: #t
    reduce-1: am-mov
    commutative: #t))

(define x86-prim-##fx*?
  (const-nargs-prim 2 0 '((reg mem))
    (lambda (cgc result-action args arg1 arg2)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (x86-arg2 (make-x86-opnd arg2)))
        (x86-sar cgc x86-arg1 (x86-imm-int type-tag-bits))
        (am-mul cgc arg1 arg1 arg2)
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-jno cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jo  cgc (lbl-opnd-label lbl)))
          true-opnd: arg1
          false-opnd: (int-opnd (imm-encode #f)))))))

(define x86-prim-##fxnot
  (const-nargs-prim 1 0 '((reg))
    (lambda (cgc result-action args arg1)
      (let ((x86-arg1 (make-x86-opnd arg1)))
        (x86-not cgc x86-arg1)
        (x86-and cgc x86-arg1 (x86-imm-int (imm-encode -1)))
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##fxand
  (foldl-prim
    (make-function-x86-opnds x86-and)
    allowed-opnds: '(reg mem int)
    allowed-opnds-accum: '(reg mem)
    start-value: -1
    start-value-null?: #t
    reduce-1: am-mov
    commutative: #t))

(define x86-prim-##fxior
  (foldl-prim
    (make-function-x86-opnds x86-or)
    allowed-opnds: '(reg mem int)
    allowed-opnds-accum: '(reg mem)
    start-value: 0
    start-value-null?: #t
    reduce-1: am-mov
    commutative: #t))

(define x86-prim-##fxxor
  (foldl-prim
    (make-function-x86-opnds x86-xor)
    allowed-opnds: '(reg mem int)
    allowed-opnds-accum: '(reg mem)
    start-value: 0
    start-value-null?: #t
    reduce-1: am-mov
    commutative: #t))

(define x86-prim-##fxif
  (const-nargs-prim 3 0 '((reg mem))
    (lambda (cgc result-action args arg1 arg2 arg3)
      (let ((width (get-word-width-bits cgc))
            (x86-arg1 (make-x86-opnd arg1))
            (x86-arg2 (make-x86-opnd arg2))
            (x86-arg3 (make-x86-opnd arg3)))
        (x86-and cgc x86-arg2 x86-arg1)
        (x86-not cgc x86-arg1)
        (x86-and cgc x86-arg1 x86-arg3)
        (x86-or  cgc x86-arg1 x86-arg2)
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##fxmin
  (foldl-prim
    (lambda (cgc . args)
      (am-compare-move cgc
        (mk-test (condition-lesser #f #t) (car args) (cadr args))
        (make-x86-opnd (car args))
        (make-x86-opnd (car args))
        (make-x86-opnd (cadr args))
        (get-word-width-bits cgc)))
    allowed-opnds: '(reg mem)
    allowed-opnds-accum: '(reg mem)
    start-value: 'none
    start-value-null?: #f
    reduce-1: am-mov
    commutative: #t))

(define x86-prim-##fxmax
  (foldl-prim
    (lambda (cgc . args)
      (am-compare-move cgc
        (mk-test (condition-greater #f #t) (car args) (cadr args))
        (make-x86-opnd (car args))
        (make-x86-opnd (car args))
        (make-x86-opnd (cadr args))
        (get-word-width-bits cgc)))
    allowed-opnds: '(reg mem)
    allowed-opnds-accum: '(reg mem)
    start-value: 'none
    start-value-null?: #f
    reduce-1: am-mov
    commutative: #t))

(define x86-prim-##fxabs
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1)
      (let ((width (get-word-width-bits cgc))
            (x86-arg1 (make-x86-opnd arg1))
            (x86-tmp1 (make-x86-opnd tmp1)))
        (am-mov cgc tmp1 arg1)
        (x86-sar cgc x86-tmp1 (x86-imm-int (- width 1)))
        (x86-xor cgc x86-arg1 x86-tmp1)
        (am-sub cgc arg1 arg1 tmp1)
        (am-return-opnd cgc result-action arg1)))))

(define (x86-prim-##fxsquare wrap?)
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (odd-tag? (fxodd? type-tag-bits)))
        ((if wrap? x86-shr x86-sar) cgc
          x86-arg1
          (x86-imm-int (if odd-tag? type-tag-bits (/ type-tag-bits 2))))
        (am-mul cgc arg1 arg1 arg1)
        (if odd-tag?
            (x86-shl cgc x86-arg1 (x86-imm-int type-tag-bits)))
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##fxsquare?
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (odd-tag? (fxodd? type-tag-bits)))
        (x86-sar cgc x86-arg1 (x86-imm-int (if odd-tag? type-tag-bits (/ type-tag-bits 2))))
        (am-mul cgc arg1 arg1 arg1)
        (am-cond-return cgc result-action
          (lambda (cgc lbl)
            (x86-jo cgc (lbl-opnd-label lbl))
            (if odd-tag?
                (x86-shl cgc x86-arg1 (x86-imm-int type-tag-bits))))
          (lambda (cgc lbl)
            (x86-jo cgc (lbl-opnd-label lbl))
            (if odd-tag?
                (x86-shl cgc x86-arg1 (x86-imm-int type-tag-bits))))
          true-opnd: (int-opnd (imm-encode #f))
          false-opnd: arg1)))))

(define x86-prim-##fxabs?
  (const-nargs-prim 1 1 '((reg mem))
    (lambda (cgc result-action args arg1 tmp1)
      (let ((width (get-word-width-bits cgc))
            (x86-arg1 (make-x86-opnd arg1))
            (x86-tmp1 (make-x86-opnd tmp1)))
        (am-mov cgc tmp1 (int-opnd (- (arithmetic-shift 1 (- width 1)))))
        (am-if-eq cgc arg1 tmp1
          (lambda (cgc) (am-return-const cgc result-action #f))
          (lambda (cgc)
            (am-mov cgc tmp1 arg1)
            (x86-sar cgc x86-tmp1 (x86-imm-int (- width 1)))
            (x86-xor cgc x86-arg1 x86-tmp1)
            (am-sub cgc arg1 arg1 tmp1)
            (am-return-opnd cgc result-action arg1)))))))

(define x86-prim-##fxbit-count ; XXX
  (const-nargs-prim 1 1 '((reg))
    (lambda (cgc result-action args arg1 tmp1)
      (let ((width (get-word-width-bits cgc))
            (x86-arg1 (make-x86-opnd arg1))
            (x86-tmp1 (make-x86-opnd tmp1)))
        (am-mov cgc tmp1 arg1)
        (x86-sar cgc x86-tmp1 (x86-imm-int (- width 1)))
        (x86-xor cgc x86-arg1 x86-tmp1)
        (x86-and cgc x86-arg1 (x86-imm-int (imm-encode -1))) ; XXX x86 sar at beginning instead?
        (x86-popcnt cgc x86-arg1 x86-arg1)
        (x86-shl cgc x86-arg1 (x86-imm-int type-tag-bits))))))

(define x86-prim-##fxfirst-bit-set
  (const-nargs-prim 1 1 '((reg))
    (lambda (cgc result-action args arg1 tmp1)
      (let ((width (get-word-width-bits cgc))
            (x86-arg1 (make-x86-opnd arg1))
            (x86-tmp1 (make-x86-opnd tmp1)))
        (am-if-eq cgc arg1 (int-opnd (imm-encode 0))
          (lambda (cgc)
            (am-return-const cgc result-action -1))
          (lambda (cgc)
            (x86-sar cgc x86-arg1 (x86-imm-int type-tag-bits))
            (am-mov cgc tmp1 arg1)
            (x86-neg cgc x86-tmp1)
            (x86-and cgc x86-arg1 x86-tmp1)
            (x86-lzcnt cgc x86-arg1 x86-arg1)
            (x86-shl cgc x86-arg1 (x86-imm-int type-tag-bits)))
          #f width)))))

(define (x86-prim-##fxlength) ; XXX
  (define (rounding cgc arg tmp shamt) ; XXX
    (x86-mov cgc tmp arg)
    (x86-sar cgc tmp (x86-imm-int shamt))
    (x86-or cgc arg tmp))

  (const-nargs-prim 1 1 '((reg))
    (lambda (cgc result-action args arg1 tmp1)
      (let ((width (get-word-width-bits cgc))
            (x86-arg1 (make-x86-opnd arg1))
            (x86-tmp1 (make-x86-opnd tmp1)))
        (x86-sar cgc x86-arg1 (x86-imm-int type-tag-bits)) ; Remove tag
        ; Negate if negative
        (am-mov cgc tmp1 arg1)
        (x86-sar cgc x86-tmp1 (x86-imm-int (- width 1)))
        (x86-xor cgc x86-arg1 x86-tmp1)
        ; Round down to power of two
        (for-each
          (lambda (shamt) (rounding cgc x86-arg1 x86-tmp1 shamt))
          '(1 2 4 8 16))
        (if (> width 32)
          (rounding cgc x86-arg1 x86-tmp1 32))
        ; Count number of bits
        (x86-popcnt cgc x86-arg1 x86-arg1)
        (x86-shl cgc x86-arg1 (x86-imm-int type-tag-bits))))))

(define x86-prim-##fxbit-set?
  (const-nargs-prim 2 0 '((reg))
    (lambda (cgc result-action args arg1 arg2)
      (let ((x86-arg1 (make-x86-opnd arg1))
            (x86-arg2 (make-x86-opnd arg2)))
        (x86-sar cgc x86-arg1 (x86-imm-int type-tag-bits))
        (x86-sar cgc x86-arg2 (x86-imm-int type-tag-bits))
        (x86-bt cgc x86-arg2 x86-arg1)
        (am-cond-return cgc result-action
          (lambda (cgc lbl) (x86-jb cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) (x86-jb cgc (lbl-opnd-label lbl)))
          true-opnd:  (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define (x86-compare-prim condition)
  (foldl-compare-prim
    (lambda (cgc opnd1 opnd2 true-label false-label)
      (if (and true-label
               (or (eq? (vector-ref (lbl-opnd-label true-label) 2) 'if-true)
                   (eq? (vector-ref (lbl-opnd-label true-label) 2) 'continue-label)))
          (set! true-label #f))

      (am-compare-jump cgc
        (mk-test condition opnd1 opnd2)
        false-label true-label
        (get-word-width-bits cgc)))
    allowed-opnds1: '(reg mem)
    allowed-opnds2: '(reg int)))

(define x86-prim-##<  (x86-compare-prim (condition-greater #t #t)))
(define x86-prim-##<= (x86-compare-prim (condition-greater #f #t)))
(define x86-prim-##>  (x86-compare-prim (condition-lesser #t #t)))
(define x86-prim-##>= (x86-compare-prim (condition-lesser #f #t)))
(define x86-prim-##=  (x86-compare-prim condition-not-equal))

(define (x86-prim-##integer-char to?)
  (const-nargs-prim 1 0 '((reg mem))
    (lambda (cgc result-action args arg1)
      (let ((x86-arg1 (make-x86-opnd arg1)))
        (x86-and cgc x86-arg1 (x86-imm-int (fxnot type-tag-mask)))
        (if to? (am-add cgc arg1 arg1 (int-opnd (type-tag 'special))))
        (am-return-opnd cgc result-action arg1)))))

(define (x86-prim-##fxparity? parity)
  (const-nargs-prim 1 0 '((reg))
    (lambda (cgc result-action args arg1)
      (let ((width (get-word-width-bits cgc))
            (x86-opnd (make-x86-opnd arg1)))
        (x86-test cgc x86-opnd (x86-imm-int (imm-encode 1)))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) ((if (eq? parity 'even) x86-je x86-jne) cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) ((if (eq? parity 'even) x86-jne x86-je) cgc (lbl-opnd-label lbl)))
          true-opnd:  (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define (x86-prim-##fxsign? sign)
  (const-nargs-prim 1 0 '((reg))
    (lambda (cgc result-action args arg1)
      (let ((x86-opnd (make-x86-opnd arg1)))
        (x86-cmp cgc x86-opnd (x86-imm-int (imm-encode 0)))
        (am-cond-return cgc result-action
          (lambda (cgc lbl) ((if (eq? sign 'positive) x86-jg x86-jl) cgc (lbl-opnd-label lbl)))
          (lambda (cgc lbl) ((if (eq? sign 'positive) x86-jle x86-jge) cgc (lbl-opnd-label lbl)))
          true-opnd:  (int-opnd (imm-encode #t))
          false-opnd: (int-opnd (imm-encode #f)))))))

(define (x86-prim-##fxshift dir wrap?)
  (const-nargs-prim 2 0 '((reg) (int))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width-bits cgc))
             (x86-arg1 (make-x86-opnd arg1))
             (x86-shamt (x86-imm-int
               (modulo (fxarithmetic-shift-right (int-opnd-value arg2) type-tag-bits) 256))))
        (if (eq? dir 'left)
            (x86-shl cgc x86-arg1 x86-shamt width)
            (begin
              ((if wrap? x86-shr x86-sar) cgc x86-arg1 x86-shamt width)
              (x86-and cgc x86-arg1 (x86-imm-int (fxnot type-tag-mask)) width)))
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##fxshift-left? ; XXX
  (const-nargs-prim 2 1 '((reg) (int) (reg mem))
    (lambda (cgc result-action args arg1 arg2 tmp1)
      (let* ((width (get-word-width-bits cgc))
             (fxwidth (fx- width type-tag-bits))
             (shamt (fxarithmetic-shift-right (int-opnd-value arg2) type-tag-bits)))
        (if (or (fx< shamt 0) (fx> shamt fxwidth))
            (am-return-const cgc result-action #f)
            (let ((x86-arg1 (make-x86-opnd arg1))
                  (x86-tmp1 (make-x86-opnd tmp1))
                  (x86-shamt (x86-imm-int shamt)))
              (am-mov cgc tmp1 arg1)
              (x86-shl cgc x86-arg1 x86-shamt width)
              (x86-sar cgc x86-arg1 x86-shamt width)
              (am-if-eq cgc arg1 tmp1
                (lambda (cgc)
                  (x86-shl cgc x86-arg1 x86-shamt width)
                  (am-return-opnd cgc result-action arg1))
                (lambda (cgc) (am-return-const cgc result-action #f))
                #f width)))))))

(define x86-prim-##fxshift-right?
  (const-nargs-prim 2 0 '((reg) (int))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width-bits cgc))
             (fxwidth (fx- width type-tag-bits))
             (shamt (fxarithmetic-shift-right (int-opnd-value arg2) type-tag-bits)))
        (if (fx< shamt 0)
            (am-return-const cgc result-action #f)
            (let ((x86-arg1 (make-x86-opnd arg1))
                  (x86-shamt (x86-imm-int (fxmin shamt fxwidth))))
              (x86-sar cgc x86-arg1 x86-shamt width)
              (x86-and cgc x86-arg1 (x86-imm-int (fxnot type-tag-mask)) width)
              (am-return-opnd cgc result-action arg1)))))))

(define x86-prim-##fxwrapshift-left? ; XXX
  (const-nargs-prim 2 0 '((reg) (int))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width-bits cgc))
             (fxwidth (fx- width type-tag-bits))
             (shamt (fxarithmetic-shift-right (int-opnd-value arg2) type-tag-bits)))
        (if (or (fx< shamt 0) (fx> shamt fxwidth))
            (am-return-const cgc result-action #f)
            (let ((x86-arg1 (make-x86-opnd arg1))
                  (x86-shamt (x86-imm-int shamt)))
              (x86-shl cgc x86-arg1 x86-shamt width)
              (am-return-opnd cgc result-action arg1)))))))

(define x86-prim-##fxwrapshift-right? ; XXX
  (const-nargs-prim 2 0 '((reg) (int))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width-bits cgc))
             (fxwidth (fx- width type-tag-bits))
             (shamt (fxarithmetic-shift-right (int-opnd-value arg2) type-tag-bits)))
        (if (fx< shamt 0)
            (am-return-const cgc result-action #f)
            (let ((x86-arg1 (make-x86-opnd arg1))
                  (x86-shamt (x86-imm-int (fxmin shamt fxwidth))))
              (x86-shr cgc x86-arg1 x86-shamt width)
              (x86-and cgc x86-arg1 (x86-imm-int (fxnot type-tag-mask)) width)
              (am-return-opnd cgc result-action arg1)))))))

(define x86-prim-##cons
  (lambda (cgc result-action args)
    (with-result-opnd cgc result-action args
      allowed-opnds: '(reg)
      fun:
        (lambda (result-reg result-opnd-in-args)
          (let* ((width (get-word-width cgc))
                 (size (* width 3))
                 (offset (+ (desc-type-tag pair-desc) (* 2 width))))

            (am-allocate-memory cgc result-reg size offset
              (codegen-context-frame cgc))

            (am-mov cgc
              (mem-opnd result-reg (- offset))
              (int-opnd (+ (ref-subtype-tag pair-desc)
                           (arithmetic-shift (* width 2) (fx+ head-type-tag-bits subtype-tag-bits)))) ; XXX
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
(define (x86-object-dyn-read-prim desc) ; XXX
  (if (imm-desc? desc)
      (compiler-internal-error "Object isn't a reference"))

  (const-nargs-prim 2 0 '((reg) (reg int))
    (lambda (cgc result-action args obj-reg index-opnd)
      (let* ((width (get-word-width cgc))
             (index-shift (- (integer-length width) 1 type-tag-bits))
             (0-offset (body-offset (desc-type desc) width)))

        (if (> 0 index-shift)
            (compiler-internal-error "x86-object-dyn-read-prim - Invalid index-shift"))

        (if (int-opnd? index-opnd)
            (am-return-opnd cgc result-action
              (mem-opnd obj-reg
                (+ (arithmetic-shift (int-opnd-value index-opnd) index-shift) 0-offset)))
            (am-return-opnd cgc result-action
              (mem-opnd obj-reg 0-offset index-opnd index-shift)))))))

;; Doesn't support width not equal to (get-word-width cgc)
(define (x86-object-dyn-set-prim desc) ; XXX
  (if (imm-desc? desc)
      (compiler-internal-error "Object isn't a reference"))

  (const-nargs-prim 3 0 '((reg) (reg int))
    (lambda (cgc result-action args obj-reg index-opnd new-val-opnd)
      (let* ((width (get-word-width cgc))
             (index-shift (- (integer-length width) 1 type-tag-bits))
             (0-offset (body-offset (desc-type desc) width)))

        (if (> 0 index-shift)
            (compiler-internal-error "x86-object-dyn-set-prim - Invalid index-shift"))

        (am-mov cgc
          (if (int-opnd? index-opnd)
              (mem-opnd obj-reg
                (+ (arithmetic-shift (int-opnd-value index-opnd) index-shift) 0-offset))
              (mem-opnd obj-reg 0-offset index-opnd index-shift))
          new-val-opnd
          (* 8 width))
        (am-return-opnd cgc result-action obj-reg)))))

(define x86-prim-##unchecked-structure-ref
  (const-nargs-prim 4 0 '((reg) (reg int))
    (lambda (cgc result-action args arg1 arg2 arg3 arg4)
      (let* ((width (get-word-width cgc))
             (offset (body-offset 'subtyped width))
             (shamt (fx- (fxlength width) 1 type-tag-bits)))
        (am-return-opnd cgc result-action
          (if (int-opnd? arg2)
              (mem-opnd arg1 (fx+ offset (fxarithmetic-shift (int-opnd-value arg2) shamt)))
              (mem-opnd arg1 offset arg2 shamt)))))))

(define x86-prim-##unchecked-structure-set!
  (const-nargs-prim 5 0 '((reg) (reg int))
    (lambda (cgc result-action args arg1 arg2 arg3 arg4 arg5)
      (let* ((width (get-word-width cgc))
             (offset (body-offset 'subtyped width))
             (shamt (fx- (fxlength width) 1 type-tag-bits)))
        (am-mov cgc
          (if (int-opnd? arg3)
              (mem-opnd arg1 (fx+ offset (fxarithmetic-shift (int-opnd-value arg3) shamt)))
              (mem-opnd arg1 offset arg3 shamt))
          arg2
          (get-word-width-bits cgc))
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##structure-type-set!
  (const-nargs-prim 2 0 '((reg) (reg int))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width cgc))
             (offset (body-offset 'subtyped width)))
        (am-mov cgc (mem-opnd arg1 offset) arg2)
        (am-return-opnd cgc result-action arg1)))))

(define (x86-prim-length #!optional (size #f) (clo? #f))
  (const-nargs-prim 1 0 '((reg))
    (lambda (cgc result-action args arg1)
      (let* ((width (get-word-width cgc))
             (log2-width (fx- (fxlength width) 1))
             (offset (header-offset 'subtyped width))
             (shamt (fx+ head-type-tag-bits subtype-tag-bits (or size log2-width))))
        (am-mov cgc arg1 (mem-opnd arg1 offset))
        (x86-shr cgc arg1 (x86-imm-int shamt))
        (if clo?
          (am-sub cgc arg1 arg1 (int-opnd (get-clo-trampoline-size cgc))))
        (x86-shl cgc arg1 (x86-imm-int type-tag-bits))
        (am-return-opnd cgc result-action arg1)))))

(define (x86-prim-##vector-shrink! size) ; XXX
  (const-nargs-prim 2 0 '((reg))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width cgc))
             (log2-width (fx- (fxlength width) 1))
             (offset (header-offset 'subtyped width))
             (shamt (fx- (fx+ head-type-tag-bits subtype-tag-bits (or size log2-width)) type-tag-bits))
             (x86-arg2 (make-x86-opnd arg2)))
        (x86-and cgc (make-x86-opnd (mem-opnd arg1 offset)) (x86-imm-int (fxnot length-mask)) (* 8 width))
        (x86-shl cgc x86-arg2 (x86-imm-int shamt))
        (am-add cgc (mem-opnd arg1 offset) (mem-opnd arg1 offset) arg2)
        (am-return-opnd cgc result-action arg1)))))

(define x86-prim-##closure-ref
  (const-nargs-prim 2 0 '((reg))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width cgc))
             (log2-width (fx- (fxlength width) 1))
             (offset (body-offset 'subtyped width))
             (shamt (fx- log2-width type-tag-bits))) ; XXX
        (am-add cgc arg2 arg2 (int-opnd (imm-encode (get-clo-trampoline-size cgc))))
        (am-return-opnd cgc result-action (mem-opnd arg1 offset arg2 shamt))))))

(define x86-prim-##closure-set!
  (const-nargs-prim 3 0 '((reg))
    (lambda (cgc result-action args arg1 arg2 arg3)
      (let* ((width (get-word-width cgc))
             (log2-width (fx- (fxlength width) 1))
             (offset (body-offset 'subtyped width))
             (shamt (fx- log2-width type-tag-bits))) ; XXX
        (am-add cgc arg2 arg2 (int-opnd (imm-encode (get-clo-trampoline-size cgc))))
        (am-mov cgc (mem-opnd arg1 offset arg2 shamt) arg3)
        (am-return-opnd cgc result-action arg1)))))

(define (x86-prim-field-ref index)
  (const-nargs-prim 1 0 '((reg))
    (lambda (cgc result-action args arg1)
      (let* ((width (get-word-width cgc))
             (offset (+ (body-offset 'subtyped width) (* index width))))
        (am-return-opnd cgc result-action (mem-opnd arg1 offset))))))

(define (x86-prim-field-set index)
  (const-nargs-prim 2 0 '((reg))
    (lambda (cgc result-action args arg1 arg2)
      (let* ((width (get-word-width cgc))
             (offset (+ (body-offset 'subtyped width) (* index width))))
        (am-mov cgc (mem-opnd arg1 offset) arg2)
        (am-return-opnd cgc result-action arg1)))))

(define x86-primitive-table
  (let ((table (make-table test: equal?)))
    (table-set! table '##identity       (make-prim-obj ##identity-primitive    1 #t #t))
    (table-set! table '##not            (make-prim-obj ##not-primitive         1 #t #t #t))
    (table-set! table '##void           (make-prim-obj ##void-primitive        0 #t #t))
    (table-set! table '##eof-object     (make-prim-obj ##eof-object-primitive  0 #t #t))
    (table-set! table '##eof-object?    (make-prim-obj ##eof-object?-primitive 1 #t #t #t))
    (table-set! table '##eq?            (make-prim-obj ##eq?-primitive         2 #t #t #t))
    (table-set! table '##null?          (make-prim-obj ##null?-primitive       1 #t #f #t))
    (table-set! table '##fxzero?        (make-prim-obj ##fxzero?-primitive     1 #t #t #t))

    (table-set! table '##fixnum?        (make-prim-obj x86-prim-##fixnum?        1 #t #t #t))
    (table-set! table '##special?       (make-prim-obj x86-prim-##special?       1 #t #t #t))
    (table-set! table '##pair?          (make-prim-obj x86-prim-##pair?          1 #t #t #t))
    (table-set! table '##mem-allocated? (make-prim-obj x86-prim-##mem-allocated? 1 #t #t #t))
    (table-set! table '##char?          (make-prim-obj x86-prim-##char?          1 #t #t #t))

    (table-set! table '##boolean?       (make-prim-obj (x86-prim-##boolean-or? tru-desc)  1 #t #t))
    (table-set! table '##false-or-null? (make-prim-obj (x86-prim-##boolean-or? nul-desc)  1 #t #t))
    (table-set! table '##false-or-void? (make-prim-obj (x86-prim-##boolean-or? void-desc) 1 #t #t))

    (table-set! table '##type           (make-prim-obj x86-prim-##type         1 #t #t))
    (table-set! table '##type-cast      (make-prim-obj x86-prim-##type-cast    2 #t #t))
    (table-set! table '##subtype        (make-prim-obj x86-prim-##subtype      1 #t #t))
    (table-set! table '##subtype-set!   (make-prim-obj x86-prim-##subtype-set! 2 #t #t))

    (table-set! table '##type-id        (make-prim-obj (x86-prim-##type-ref 1) 1 #t #t))
    (table-set! table '##type-name      (make-prim-obj (x86-prim-##type-ref 2) 1 #t #t))
    (table-set! table '##type-flags     (make-prim-obj (x86-prim-##type-ref 3) 1 #t #t))
    (table-set! table '##type-super     (make-prim-obj (x86-prim-##type-ref 4) 1 #t #t))
    (table-set! table '##type-fields    (make-prim-obj (x86-prim-##type-ref 5) 1 #t #t))
    (table-set! table '##structure-type (make-prim-obj (x86-prim-##type-ref 0) 1 #t #t))

    (table-set! table '##subtyped?      (make-prim-obj x86-prim-##subtyped? 1 #t #t #t))
    (table-set! table '##vector?        (make-prim-obj (x86-prim-##subtype? vector-desc)       1 #t #t #t))
    (table-set! table '##ratnum?        (make-prim-obj (x86-prim-##subtype? ratnum-desc)       1 #t #t #t))
    (table-set! table '##cpxnum?        (make-prim-obj (x86-prim-##subtype? cpxnum-desc)       1 #t #t #t))
    (table-set! table '##structure?     (make-prim-obj (x86-prim-##subtype? structure-desc)    1 #t #t #t))
    (table-set! table '##meroon?        (make-prim-obj (x86-prim-##subtype? meroon-desc)       1 #t #t #t))
    (table-set! table '##jazz?          (make-prim-obj (x86-prim-##subtype? jazz-desc)         1 #t #t #t))
    (table-set! table '##symbol?        (make-prim-obj (x86-prim-##subtype? symbol-desc)       1 #t #t #t))
    (table-set! table '##keyword?       (make-prim-obj (x86-prim-##subtype? keyword-desc)      1 #t #t #t))
    (table-set! table '##frame?         (make-prim-obj (x86-prim-##subtype? frame-desc)        1 #t #t #t))
    (table-set! table '##continuation?  (make-prim-obj (x86-prim-##subtype? continuation-desc) 1 #t #t #t))
    (table-set! table '##promise?       (make-prim-obj (x86-prim-##subtype? promise-desc)      1 #t #t #t))
    (table-set! table '##procedure?     (make-prim-obj (x86-prim-##subtype? procedure-desc)    1 #t #t #t))
    (table-set! table '##return?        (make-prim-obj (x86-prim-##subtype? return-desc)       1 #t #t #t))
    (table-set! table '##foreign?       (make-prim-obj (x86-prim-##subtype? foreign-desc)      1 #t #t #t))
    (table-set! table '##string?        (make-prim-obj (x86-prim-##subtype? string-desc)       1 #t #t #t))
    (table-set! table '##s8vector?      (make-prim-obj (x86-prim-##subtype? s8vector-desc)     1 #t #t #t))
    (table-set! table '##u8vector?      (make-prim-obj (x86-prim-##subtype? u8vector-desc)     1 #t #t #t))
    (table-set! table '##s16vector?     (make-prim-obj (x86-prim-##subtype? s16vector-desc)    1 #t #t #t))
    (table-set! table '##u16vector?     (make-prim-obj (x86-prim-##subtype? u16vector-desc)    1 #t #t #t))
    (table-set! table '##s32vector?     (make-prim-obj (x86-prim-##subtype? s32vector-desc)    1 #t #t #t))
    (table-set! table '##u32vector?     (make-prim-obj (x86-prim-##subtype? u32vector-desc)    1 #t #t #t))
    (table-set! table '##f32vector?     (make-prim-obj (x86-prim-##subtype? f32vector-desc)    1 #t #t #t))
    (table-set! table '##s64vector?     (make-prim-obj (x86-prim-##subtype? s64vector-desc)    1 #t #t #t))
    (table-set! table '##u64vector?     (make-prim-obj (x86-prim-##subtype? u64vector-desc)    1 #t #t #t))
    (table-set! table '##f64vector?     (make-prim-obj (x86-prim-##subtype? f64vector-desc)    1 #t #t #t))
    (table-set! table '##flonum?        (make-prim-obj (x86-prim-##subtype? flonum-desc)       1 #t #t #t))
    (table-set! table '##bignum?        (make-prim-obj (x86-prim-##subtype? bignum-desc)       1 #t #t #t))

    (table-set! table '##subtyped.bignum? (make-prim-obj (x86-prim-##subtyped.subtype? bignum-desc) 1 #t #t #t))
    (table-set! table '##subtyped.flonum? (make-prim-obj (x86-prim-##subtyped.subtype? flonum-desc) 1 #t #t #t))
    (table-set! table '##subtyped.symbol? (make-prim-obj (x86-prim-##subtyped.subtype? symbol-desc) 1 #t #t #t))
    (table-set! table '##subtyped.vector? (make-prim-obj (x86-prim-##subtyped.subtype? vector-desc) 1 #t #t #t))

    (table-set! table '##fx+            (make-prim-obj (x86-prim-##fx+ #f) 2 #t #f))
    (table-set! table '##fx-            (make-prim-obj (x86-prim-##fx- #f) 2 #t #f))
    (table-set! table '##fx*            (make-prim-obj (x86-prim-##fx* #f) 2 #t #f))

    (table-set! table '##fx+?           (make-prim-obj x86-prim-##fx+? 2 #t #t #t))
    (table-set! table '##fx-?           (make-prim-obj x86-prim-##fx-? 2 #t #t #t))
    (table-set! table '##fx*?           (make-prim-obj x86-prim-##fx*? 2 #t #t #t))

    (table-set! table '##fxwrap+        (make-prim-obj (x86-prim-##fx+ #t) 2 #t #f))
    (table-set! table '##fxwrap-        (make-prim-obj (x86-prim-##fx- #t) 2 #t #f))
    (table-set! table '##fxwrap*        (make-prim-obj (x86-prim-##fx* #t) 2 #t #f))

    (table-set! table '##fx<            (make-prim-obj x86-prim-##<  2 #t #t #t))
    (table-set! table '##fx<=           (make-prim-obj x86-prim-##<= 2 #t #t #t))
    (table-set! table '##fx>            (make-prim-obj x86-prim-##>  2 #t #t #t))
    (table-set! table '##fx>=           (make-prim-obj x86-prim-##>= 2 #t #t #t))
    (table-set! table '##fx=            (make-prim-obj x86-prim-##=  2 #t #t #t))

    (table-set! table '##char<?         (make-prim-obj x86-prim-##<  2 #t #t #t))
    (table-set! table '##char<=?        (make-prim-obj x86-prim-##<= 2 #t #t #t))
    (table-set! table '##char>?         (make-prim-obj x86-prim-##>  2 #t #t #t))
    (table-set! table '##char>=?        (make-prim-obj x86-prim-##>= 2 #t #t #t))
    (table-set! table '##char=?         (make-prim-obj x86-prim-##=  2 #t #t #t))

    (table-set! table '##object-before? (make-prim-obj x86-prim-##<  2 #t #t #t))

    (table-set! table '##char->integer (make-prim-obj (x86-prim-##integer-char #f) 1 #t #t))
    (table-set! table '##integer->char (make-prim-obj (x86-prim-##integer-char #t) 1 #t #t))

    (table-set! table '##fxnot          (make-prim-obj x86-prim-##fxnot 1 #t #t))
    (table-set! table '##fxand          (make-prim-obj x86-prim-##fxand 2 #t #t))
    (table-set! table '##fxior          (make-prim-obj x86-prim-##fxior 2 #t #t))
    (table-set! table '##fxxor          (make-prim-obj x86-prim-##fxxor 2 #t #t))
    (table-set! table '##fxif           (make-prim-obj x86-prim-##fxif  3 #t #t))
    (table-set! table '##fxmin          (make-prim-obj x86-prim-##fxmin 2 #t #t))
    (table-set! table '##fxmax          (make-prim-obj x86-prim-##fxmax 2 #t #t))

    (table-set! table '##fxabs          (make-prim-obj x86-prim-##fxabs         1 #t #t))
    (table-set! table '##fxabs?         (make-prim-obj x86-prim-##fxabs?        1 #t #t #t))
    (table-set! table '##fxwrapabs      (make-prim-obj x86-prim-##fxabs         1 #t #t)) ; XXX
    (table-set! table '##fxsquare       (make-prim-obj (x86-prim-##fxsquare #f) 1 #t #t))
    (table-set! table '##fxwrapsquare   (make-prim-obj (x86-prim-##fxsquare #t) 1 #t #t))
    (table-set! table '##fxsquare?      (make-prim-obj x86-prim-##fxsquare?     1 #t #t #t))

    (table-set! table '##fxbit-count     (make-prim-obj x86-prim-##fxbit-count     1 #t #t))
    (table-set! table '##fxfirst-bit-set (make-prim-obj x86-prim-##fxfirst-bit-set 1 #t #t))
    (table-set! table '##fxlength        (make-prim-obj (x86-prim-##fxlength)      1 #t #t))
    (table-set! table '##fxbit-set?      (make-prim-obj x86-prim-##fxbit-set?      2 #t #t #t))

    (table-set! table '##fxeven?        (make-prim-obj (x86-prim-##fxparity? 'even)    1 #t #t #t))
    (table-set! table '##fxodd?         (make-prim-obj (x86-prim-##fxparity? 'odd)     1 #t #t #t))
    (table-set! table '##fxnegative?    (make-prim-obj (x86-prim-##fxsign? 'negative)  1 #t #t #t))
    (table-set! table '##fxpositive?    (make-prim-obj (x86-prim-##fxsign? 'positive)  1 #t #t #t))

    (table-set! table '##fxarithmetic-shift-left      (make-prim-obj (x86-prim-##fxshift 'left  #f)  2 #t #t))
    (table-set! table '##fxwraparithmetic-shift-left  (make-prim-obj (x86-prim-##fxshift 'left  #t)  2 #t #t))
    (table-set! table '##fxarithmetic-shift-right     (make-prim-obj (x86-prim-##fxshift 'right #f)  2 #t #t))
    (table-set! table '##fxwraplogical-shift-right    (make-prim-obj (x86-prim-##fxshift 'right #t)  2 #t #t))
    (table-set! table '##fxarithmetic-shift-left?     (make-prim-obj x86-prim-##fxshift-left?        2 #t #t #t))
    (table-set! table '##fxarithmetic-shift-right?    (make-prim-obj x86-prim-##fxshift-right?       2 #t #t #t))
    (table-set! table '##fxwraparithmetic-shift-left? (make-prim-obj x86-prim-##fxwrapshift-left?    2 #t #t #t))
    (table-set! table '##fxwraplogical-shift-right?   (make-prim-obj x86-prim-##fxwrapshift-right?   2 #t #t #t))

    (table-set! table '##real-part      (make-prim-obj (x86-prim-##cpx-part #f) 1 #t #t))
    (table-set! table '##imag-part      (make-prim-obj (x86-prim-##cpx-part #t) 1 #t #t))

    (table-set! table '##car            (make-prim-obj (object-read-prim pair-desc '(a)) 1 #t #f))
    (table-set! table '##cdr            (make-prim-obj (object-read-prim pair-desc '(d)) 1 #t #f))

    (table-set! table '##caar           (make-prim-obj (object-read-prim pair-desc '(a a)) 1 #t #f))
    (table-set! table '##cadr           (make-prim-obj (object-read-prim pair-desc '(a d)) 1 #t #f))
    (table-set! table '##cddr           (make-prim-obj (object-read-prim pair-desc '(d d)) 1 #t #f))
    (table-set! table '##cdar           (make-prim-obj (object-read-prim pair-desc '(d a)) 1 #t #f))

    (table-set! table '##caaar          (make-prim-obj (object-read-prim pair-desc '(a a a)) 1 #t #f))
    (table-set! table '##caadr          (make-prim-obj (object-read-prim pair-desc '(a a d)) 1 #t #f))
    (table-set! table '##cadar          (make-prim-obj (object-read-prim pair-desc '(a d a)) 1 #t #f))
    (table-set! table '##caddr          (make-prim-obj (object-read-prim pair-desc '(a d d)) 1 #t #f))
    (table-set! table '##cdaar          (make-prim-obj (object-read-prim pair-desc '(d a a)) 1 #t #f))
    (table-set! table '##cdadr          (make-prim-obj (object-read-prim pair-desc '(d a d)) 1 #t #f))
    (table-set! table '##cddar          (make-prim-obj (object-read-prim pair-desc '(d d a)) 1 #t #f))
    (table-set! table '##cdddr          (make-prim-obj (object-read-prim pair-desc '(d d d)) 1 #t #f))

    (table-set! table '##caaaar         (make-prim-obj (object-read-prim pair-desc '(a a a a)) 1 #t #f))
    (table-set! table '##cdaaar         (make-prim-obj (object-read-prim pair-desc '(d a a a)) 1 #t #f))
    (table-set! table '##cadaar         (make-prim-obj (object-read-prim pair-desc '(a d a a)) 1 #t #f))
    (table-set! table '##cddaar         (make-prim-obj (object-read-prim pair-desc '(d d a a)) 1 #t #f))
    (table-set! table '##caadar         (make-prim-obj (object-read-prim pair-desc '(a a d a)) 1 #t #f))
    (table-set! table '##cdadar         (make-prim-obj (object-read-prim pair-desc '(d a d a)) 1 #t #f))
    (table-set! table '##caddar         (make-prim-obj (object-read-prim pair-desc '(a d d a)) 1 #t #f))
    (table-set! table '##cdddar         (make-prim-obj (object-read-prim pair-desc '(d d d a)) 1 #t #f))
    (table-set! table '##caaadr         (make-prim-obj (object-read-prim pair-desc '(a a a d)) 1 #t #f))
    (table-set! table '##cdaadr         (make-prim-obj (object-read-prim pair-desc '(d a a d)) 1 #t #f))
    (table-set! table '##cadadr         (make-prim-obj (object-read-prim pair-desc '(a d a d)) 1 #t #f))
    (table-set! table '##cddadr         (make-prim-obj (object-read-prim pair-desc '(d d a d)) 1 #t #f))
    (table-set! table '##caaddr         (make-prim-obj (object-read-prim pair-desc '(a a d d)) 1 #t #f))
    (table-set! table '##cdaddr         (make-prim-obj (object-read-prim pair-desc '(d a d d)) 1 #t #f))
    (table-set! table '##cadddr         (make-prim-obj (object-read-prim pair-desc '(a d d d)) 1 #t #f))
    (table-set! table '##cddddr         (make-prim-obj (object-read-prim pair-desc '(d d d d)) 1 #t #f))

    (table-set! table '##set-car!       (make-prim-obj (object-set-prim pair-desc 2) 2 #t #f))
    (table-set! table '##set-cdr!       (make-prim-obj (object-set-prim pair-desc 1) 2 #t #f))

    (table-set! table '##cons           (make-prim-obj x86-prim-##cons 2 #t #f))

    (table-set! table '##vector-ref     (make-prim-obj (x86-object-dyn-read-prim vector-desc) 2 #t #t))
    (table-set! table '##vector-set!    (make-prim-obj (x86-object-dyn-set-prim vector-desc)  3 #t #f))

    (table-set! table '##values-ref     (make-prim-obj (x86-object-dyn-read-prim boxvalues-desc) 2 #t #t))
    (table-set! table '##values-set!    (make-prim-obj (x86-object-dyn-set-prim boxvalues-desc)  3 #t #f))

    (table-set! table '##closure-ref    (make-prim-obj x86-prim-##closure-ref  2 #t #t))
    (table-set! table '##closure-set!   (make-prim-obj x86-prim-##closure-set! 3 #t #f))

    (table-set! table '##structure-type-set!      (make-prim-obj x86-prim-##structure-type-set!      2 #t #f))
    (table-set! table '##unchecked-structure-ref  (make-prim-obj x86-prim-##unchecked-structure-ref  4 #t #t))
    (table-set! table '##unchecked-structure-set! (make-prim-obj x86-prim-##unchecked-structure-set! 5 #t #f))

    (table-set! table '##vector-length    (make-prim-obj (x86-prim-length) 1 #t #t))
    (table-set! table '##values-length    (make-prim-obj (x86-prim-length) 1 #t #t))
    (table-set! table '##closure-length   (make-prim-obj (x86-prim-length #f #t) 1 #t #t))

    (table-set! table '##u8vector-length  (make-prim-obj (x86-prim-length 0) 1 #t #t))
    (table-set! table '##s8vector-length  (make-prim-obj (x86-prim-length 0) 1 #t #t))
    (table-set! table '##u16vector-length (make-prim-obj (x86-prim-length 1) 1 #t #t))
    (table-set! table '##s16vector-length (make-prim-obj (x86-prim-length 1) 1 #t #t))
    (table-set! table '##u32vector-length (make-prim-obj (x86-prim-length 2) 1 #t #t))
    (table-set! table '##s32vector-length (make-prim-obj (x86-prim-length 2) 1 #t #t))
    (table-set! table '##f32vector-length (make-prim-obj (x86-prim-length 2) 1 #t #t))
    (table-set! table '##u64vector-length (make-prim-obj (x86-prim-length 3) 1 #t #t))
    (table-set! table '##s64vector-length (make-prim-obj (x86-prim-length 3) 1 #t #t))
    (table-set! table '##f64vector-length (make-prim-obj (x86-prim-length 3) 1 #t #t))

    (table-set! table '##vector-shrink!    (make-prim-obj (x86-prim-##vector-shrink! #f) 2 #t #f))

    (table-set! table '##u8vector-shrink!  (make-prim-obj (x86-prim-##vector-shrink! 0)  2 #t #f))
    (table-set! table '##s8vector-shrink!  (make-prim-obj (x86-prim-##vector-shrink! 0)  2 #t #f))
    (table-set! table '##u16vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 1)  2 #t #f))
    (table-set! table '##s16vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 1)  2 #t #f))
    (table-set! table '##u32vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 2)  2 #t #f))
    (table-set! table '##s32vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 2)  2 #t #f))
    (table-set! table '##f32vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 2)  2 #t #f))
    (table-set! table '##u64vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 3)  2 #t #f))
    (table-set! table '##s64vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 3)  2 #t #f))
    (table-set! table '##f64vector-shrink! (make-prim-obj (x86-prim-##vector-shrink! 3)  2 #t #f))

    (table-set! table '##symbol-name        (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))
    (table-set! table '##will-testator      (make-prim-obj (x86-prim-field-ref 1) 1 #t #t))
    (table-set! table '##will-action        (make-prim-obj (x86-prim-field-ref 2) 1 #t #t))
    (table-set! table '##ratnum-numerator   (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))
    (table-set! table '##ratnum-denominator (make-prim-obj (x86-prim-field-ref 1) 1 #t #t))
    (table-set! table '##cpxnum-real        (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))
    (table-set! table '##cpxnum-imag        (make-prim-obj (x86-prim-field-ref 1) 1 #t #t))
    (table-set! table '##continuation-denv  (make-prim-obj (x86-prim-field-ref 1) 1 #t #t))
    (table-set! table '##symbol-hash        (make-prim-obj (x86-prim-field-ref 1) 1 #t #t))
    (table-set! table '##keyword-name       (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))
    (table-set! table '##keyword-hash       (make-prim-obj (x86-prim-field-ref 1) 1 #t #t))
    (table-set! table '##promise-state      (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))
    (table-set! table '##foreign-tags       (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))
    (table-set! table '##closure-code       (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))
    (table-set! table '##keyword-interned?  (make-prim-obj (x86-prim-field-ref 2) 1 #t #t #t))
    (table-set! table '##symbol-interned?   (make-prim-obj (x86-prim-field-ref 2) 1 #t #t #t))
    (table-set! table '##unbox              (make-prim-obj (x86-prim-field-ref 0) 1 #t #t))

    (table-set! table '##symbol-name-set!        (make-prim-obj (x86-prim-field-set 0) 2 #t #t))
    (table-set! table '##will-testator-set!      (make-prim-obj (x86-prim-field-set 1) 2 #t #t))
    (table-set! table '##will-action-set!        (make-prim-obj (x86-prim-field-set 2) 2 #t #t))
    (table-set! table '##continuation-denv-set!  (make-prim-obj (x86-prim-field-set 1) 2 #t #t))
    (table-set! table '##symbol-hash-set!        (make-prim-obj (x86-prim-field-set 1) 2 #t #t))
    (table-set! table '##keyword-name-set!       (make-prim-obj (x86-prim-field-set 0) 2 #t #t))
    (table-set! table '##keyword-hash-set!       (make-prim-obj (x86-prim-field-set 1) 2 #t #t))
    (table-set! table '##promise-state-set!      (make-prim-obj (x86-prim-field-set 0) 2 #t #t))
    (table-set! table '##continuation-frame-set! (make-prim-obj (x86-prim-field-set 0) 2 #t #t))
    (table-set! table '##set-box!                (make-prim-obj (x86-prim-field-set 0) 2 #t #t))

    table))
