;;==============================================================================

;;; File: "_t-cpu-primitives.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;------------------------------------------------------------------------------

;; Constants

;; Todo: Respect config-object value
(define is-load-store-arch #f)

(define narg-pointer            (x86-cl))  ;; number of arguments register
(define stack-pointer           (x86-rsp)) ;; Real stack limit
(define processor-state-pointer (x86-rcx)) ;; Processor state pointer

(define frame-offset 0) ;; stack offset so that frame[1] is at null offset from stack-pointer

(define (THREAD_DESCRIPTOR_LBL cgc) (get-label cgc 'THREAD_DESCRIPTOR_LBL))
(define (C_ERROR_LBL cgc)           (get-label cgc 'C_ERROR_LBL))
(define (WRONG_NARGS_LBL cgc)       (get-label cgc 'WRONG_NARGS_LBL))
(define (OVERFLOW_LBL cgc)          (get-label cgc 'OVERFLOW_LBL))
(define (UNDERFLOW_LBL cgc)         (get-label cgc 'UNDERFLOW_LBL))
(define (INTERRUPT_LBL cgc)         (get-label cgc 'INTERRUPT_LBL))
(define (TYPE_ERROR_LBL cgc)        (get-label cgc 'TYPE_ERROR_LBL))
(define (ALLOCATION_ERROR_LBL cgc)  (get-label cgc 'ALLOCATION_ERROR_LBL))

;;------------------------------------------------------------------------------

;; Primitives

(define x86-prim-fx+
  (arithmetic-prim x86-add '(number) (default-arithmetic-allowed-opnds is-load-store-arch) #t))

(define x86-prim-fx-
  (arithmetic-prim x86-sub '(number) (default-arithmetic-allowed-opnds is-load-store-arch) #f))

(define x86-prim-fx<
  (arithmetic-prim x86-cmp (list 'boolean x86-jle x86-jg) (default-arithmetic-allowed-opnds is-load-store-arch) #f))

(define primitive-object-table
  (let ((table (make-table test: equal?)))
    (table-set! table '##fx+ (make-prim-obj x86-prim-fx+ 2 #t #f))
    (table-set! table '##fx- (make-prim-obj x86-prim-fx- 2 #t #f))
    (table-set! table '##fx< (make-prim-obj x86-prim-fx< 2 #t #t))
    (table-set! table '##car (make-prim-obj (get-object-field pair-obj-desc 1) 1 #t #f))
    (table-set! table '##cdr (make-prim-obj (get-object-field pair-obj-desc 0) 1 #t #f))

    table))

;;------------------------------------------------------------------------------

;; Processor state table

;; The ps register points at the start of processor state structure.
;;
;;  Start: Low level exec processor state structure
;;  End: Low level exec processor state structure
;;  Start: Regular processor state structure <-- ps register
;;  End: Regular processor state structure

;; Low level exec processor state structure:
;; typedef struct ___lowlevel_processor_state_struct
;;   {
;;     ___WORD *return_sp;
;;     ___WORD *return_handler;
;;   } ___lowlevel_processor_state_struct;

;; Processor state structure:
;; typedef struct ___processor_state_struct
;;   {
;;     ___WORD * ___VOLATILE stack_trip;
;;     ___WORD *stack_limit;
;;     ___WORD *fp;
;;     ___WORD *stack_start;
;;     ___WORD *stack_break;
;;     ___WORD *heap_limit;
;;     ___WORD *hp;
;;     ___WORD r[___NB_GVM_REGS];
;;     ___WORD pc;
;;     ___WORD na;
;;
;;     /* these handlers are duplicated from the global state for quick access */
;;     ___WORD handler_sfun_conv_error;
;;     ___WORD handler_cfun_conv_error;
;;     ___WORD handler_stack_limit;
;;     ___WORD handler_heap_limit;
;;     ___WORD handler_not_proc;
;;     ___WORD handler_not_proc_glo;
;;     ___WORD handler_wrong_nargs;
;;     ___WORD handler_get_rest;
;;     ___WORD handler_get_key;
;;     ___WORD handler_get_key_rest;
;;     ___WORD handler_force;
;;     ___WORD handler_return_to_c;
;;     ___WORD handler_break;
;;     ___WORD internal_return;
;;     ___WORD dynamic_env_bind_return;
;;
;;     ___WORD temp1;
;;     ___WORD temp2;
;;     ___WORD temp3;
;;     ___WORD temp4;

(define (get-processor-state-field cgc sym)
  (define lowlevelexec (get-opt-val 'use-c-backend))

  (define word-width (get-word-width cgc))

  (define (fields-lowlevelexec) `(
    (return-stack-pointer    ,word-width)
    (return-handler          ,word-width)
    ))

  (define (fields-regular) `(
    (stack-trip              ,word-width)
    (stack-limit             ,word-width)
    (frame-pointer           ,word-width)
    (stack-start             ,word-width)
    (stack-break             ,word-width)
    (heap-limit              ,word-width)
    (heap-pointer            ,word-width)
    (gvm-reg0                ,word-width)
    (gvm-reg1                ,word-width)
    (gvm-reg2                ,word-width)
    (gvm-reg3                ,word-width)
    (gvm-reg4                ,word-width)
    (program-counter         ,word-width)
    (nargs                   ,word-width)
    (handler_sfun_conv_error ,word-width)
    (handler_cfun_conv_error ,word-width)
    (handler_stack_limit     ,word-width)
    (handler_heap_limit      ,word-width)
    (handler_not_proc        ,word-width)
    (handler_not_proc_glo    ,word-width)
    (handler_wrong_nargs     ,word-width)
    (handler_get_rest        ,word-width)
    (handler_get_key         ,word-width)
    (handler_get_key_rest    ,word-width)
    (handler_force           ,word-width)
    (handler_return_to_c     ,word-width)
    (handler_break           ,word-width)
    (internal_return         ,word-width)
    (dynamic_env_bind_return ,word-width)
    (temp1                   ,word-width)
    (temp2                   ,word-width)
    (temp3                   ,word-width)
    (temp4                   ,word-width)
    ))

  ;; Returns a pair of the offset from start of lst and the width of the field
  (define (find-field lst accum)
    (if (null? lst)
      -1 ;; Error value
      (let* ((field (car lst))
             (field-sym (car field))
             (width (cadr field)))
        (if (equal? sym field-sym)
          (cons accum (* 8 width))
          (find-field (cdr lst) (+ width accum))))))

  (let* ((fields (if lowlevelexec
          (append (fields-lowlevelexec) (fields-regular))
          (fields-regular)))
         (offset (if lowlevelexec
          (- (apply + (map cadr (fields-lowlevelexec))))
          0))
         (field (find-field fields 0)))

    (if (eq? -1 field)
      (compiler-internal-error "Unknown processor state field: " sym)
      (cons
        (mem-opnd cgc (+ offset (car field)) processor-state-pointer) ;; Opnd
        (cdr field))))) ;; Width

;;                             x86 64 bits backend

(define (x64-target)
  (make-backend-target
    (x86-64-abstract-machine-info)
    'x86-64 '((".s" . X86-64)) 13 5 3 '() '()))

(define (x86-64-abstract-machine-info)
  (make-backend (info) (operands) (instructions) (routines)))

;;------------------------------------------------------------------------------

;; Backend info

(define (info)
  (make-backend-info
    8                         ;; Word width
    'le                       ;; Endianness
    is-load-store-arch        ;; Load store architecture?
    stack-pointer             ;; Stack pointer register
    frame-offset              ;; Frame offset
    primitive-object-table    ;; Primitive table
    (vector                   ;; Main registers
      (x86-rdi) (x86-rax) (x86-rbx) (x86-rdx) (x86-rsi))
    (vector                   ;; Extra registers
      (x86-r8) (x86-r9) (x86-r10) (x86-r11) (x86-r12) (x86-r13) (x86-r14) (x86-r15))
    make-cgc                  ;; CGC constructor
    ))

(define (make-cgc)
  (let ((cgc (make-codegen-context)))
    (codegen-context-listing-format-set! cgc 'gnu)
    (asm-init-code-block cgc 0 'le)
    (x86-arch-set! cgc 'x86-64)

    (codegen-context-extra-registers-allocation-set! cgc
      (make-vector 16 0)) ;; Can be longer than register count

    cgc))

;;------------------------------------------------------------------------------

;; Backend operands

(define (operands)
  (make-operand-dictionnary
    x86-imm-int
    x86-imm-int?
    x86-imm-lbl
    x86-imm-lbl?
    x86-mem
    x86-mem?
    fixnum?                     ;; reg?
    x86-imm-int-value           ;; int-opnd-value
    x86-imm-lbl-offset          ;; lbl-opnd-offset
    x86-imm-lbl-label           ;; lbl-opnd-label
    x86-mem-offset              ;; mem-opnd-offset
    x86-mem-reg1                ;; mem-opnd-reg
    ))

;;------------------------------------------------------------------------------

(define (instructions)
  (make-instruction-dictionnary
    x86-label-align         ;; am-lbl
    data-instr              ;; am-data
    mov-instr               ;; am-mov
    x86-lea                 ;; am-load-mem-address
    x86-push                ;; am-push
    x86-pop                 ;; am-pop
    (apply-and-mov x86-add) ;; am-add
    (apply-and-mov x86-sub) ;; am-sub
    (apply-and-mov x86-shr) ;; am-bit-shift-right
    (apply-and-mov x86-shl) ;; am-bit-shift-left
    (apply-and-mov x86-not) ;; am-not
    (apply-and-mov x86-and) ;; am-and
    (apply-and-mov x86-or)  ;; am-or
    (apply-and-mov x86-xor) ;; am-xor
    x86-jmp                 ;; am-jmp
    cmp-jump-instr          ;; am-compare-jump
    ))

(define (x86-label-align cgc label #!optional (align #f))
  (if align
    (asm-align cgc (car align) (cdr align) #x90))
    (x86-label cgc label))

(define data-instr
  (make-am-data x86-db x86-dw x86-dd x86-dq))

;; Args : CGC, reg/mem/label, reg/mem/imm/label
;; Todo: Check if some cases can be eliminated
(define (mov-instr cgc dst src #!optional (width #f))
  (define dst-type (opnd-type cgc dst))
  (define src-type (opnd-type cgc src))

  ;; new-src can be directly used as an operand to mov
  (define (mov-in-dst new-src)
    (if (equal? dst-type 'ind)
      (get-extra-register cgc
        (lambda (reg-dst)
          (x86-mov cgc reg-dst dst)
          (x86-mov cgc (x86-mem 0 reg-dst) new-src width)))
      (x86-mov cgc dst new-src width)))

  (if (not (equal? dst src))
  (cond
    ((and
      (or (equal? dst-type 'mem) (equal? dst-type 'ind))
      (or (equal? src-type 'mem) (equal? src-type 'lbl)))
          (get-extra-register cgc
            (lambda (reg-src)
              (x86-mov cgc reg-src src)
          (mov-in-dst reg-src))))

    ((equal? src-type 'ind)
      (get-extra-register cgc
        (lambda (reg-src)
          (x86-mov cgc reg-src src)
          (x86-mov cgc reg-src (x86-mem 0 reg-src))
          (mov-in-dst reg-src))))

    (else
        (mov-in-dst src)))))

(define (apply-and-mov fun)
  (lambda (cgc result-reg opnd1 opnd2)
    (if (equal? result-reg opnd1)
        (fun cgc result-reg opnd2)
        (begin
          (x86-mov cgc result-reg opnd1)
          (fun cgc result-reg opnd2)))))

(define (cmp-jump-instr cgc opnd1 opnd2 condition loc-true loc-false #!optional (opnds-width #f))
  (define (flip pair)
      (cons (cdr pair) (car pair)))

  (define (get-jumps condition)
    (case (get-condition condition)
            ((equal)
              (cons x86-je  x86-jne))
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
            ((not-equal) (flip (get-jumps (inverse-condition condition))))
            ((lesser) (flip (get-jumps (inverse-condition condition))))
            (else
              (compiler-internal-error "cmp-jump-instr - Unknown condition: " condition))))

  (let* ((jumps (get-jumps condition)))

    ;; In case both jump locations are false, the cmp is unnecessary.
    (if (or loc-true loc-false)
      (x86-cmp cgc opnd1 opnd2 opnds-width))

    (cond
      ((and loc-false loc-true)
        ((car jumps) cgc loc-true)
        (x86-jmp cgc loc-false))
      ((and (not loc-true) loc-false)
        ((cdr jumps) cgc loc-false))
      ((and loc-true (not loc-false))
        ((car jumps) cgc loc-true))
      (else
        (debug "am-compare-jump: No jump encoded")))))

;;------------------------------------------------------------------------------

;; Backend routines

(define (routines)
  (make-routine-dictionnary
    x64-poll
    x64-set-nargs
    x64-check-nargs
    x64-init-routine
    x64-end-routine
    x64-error-routine
    x64-place-extra-data
    ))

(define (check-overflow-and-interrupt cgc frame)
  (debug "check-overflow-and-interrupt")
  (let* ((stack-trip (car (get-processor-state-field cgc 'stack-trip)))
         (temp1 (get-processor-state-field cgc 'temp1))
         (return-loc (make-unique-label cgc "return-from-overflow")))

        (am-compare-jump cgc
      stack-pointer stack-trip
      (condition-lesser #f #f)
      #f return-loc)

    ;; Jump to handler
    (am-mov cgc (car temp1) (lbl-opnd cgc return-loc) (cdr temp1))
    (call-handler cgc 'handler_stack_limit frame return-loc)))

(define (x64-poll cgc frame)
  (check-overflow-and-interrupt cgc frame))

(define use-f-flag #t)
;; Must be ordered and can't be longer than 5
(define nargs-passed-in-flags '(0 1 2 3 4))

(define (narg-index nargs) (index-of nargs nargs-passed-in-flags))
(define (passed-in-ps nargs) (= -1 (narg-index nargs)))
(define (passed-in-flags nargs) (not (passed-in-ps nargs)))

(define (x64-set-nargs cgc nargs)
  ;; set flags = jb  jne jle jno jp  jbe jl  js   wrong_na = jae
  (define (flags-a) (x86-cmp cgc narg-pointer (x86-imm-int -3)))
  ;; set flags = jae je  jle jno jp  jbe jge jns  wrong_na = jne
  (define (flags-b) (x86-cmp cgc narg-pointer narg-pointer))
  ;; set flags = jae jne jg  jno jp  ja  jge jns  wrong_na = jle
  (define (flags-c) (x86-cmp cgc narg-pointer (x86-imm-int -123)))
  ;; set flags = jae jne jle jo  jp  ja  jl  jns  wrong_na = jno
  (define (flags-d) (x86-cmp cgc narg-pointer (x86-imm-int 10)))
  ;; set flags = jae jne jle jno jnp ja  jl  js   wrong_na = jp
  (define (flags-e) (x86-cmp cgc narg-pointer (x86-imm-int 2)))
  ;; set flags = jae jne jle jno jp  ja  jl  js
  (define (flags-f) (x86-cmp cgc narg-pointer (x86-imm-int 0)))

  (define (set-ps-na arg-count)
    (let ((na-opnd (get-processor-state-field cgc 'nargs)))
      (x86-mov cgc (car na-opnd) (x86-imm-int arg-count) (cdr na-opnd))))

  (define all-tests
    (list flags-a flags-b flags-c flags-d flags-e))
  (define tests
    (if use-f-flag all-tests (cdr all-tests)))

  (debug "x64-set-narg: " nargs)

  (if (passed-in-ps nargs)
    ;; Use processor state to pass narg
          (begin
      (set-ps-na nargs)
      (if use-f-flag
        (flags-f)
        (flags-a)))
    ;; Use flag register
    ((list-ref tests (narg-index nargs)))))

(define (x64-check-nargs cgc frame nargs optional-args-values rest?)
  ;; Constants

  (define target (codegen-context-target cgc))
  (define nargs-in-regs (target-nb-arg-regs target))

  (define opts-count (length optional-args-values))
  (define nargs-no-opts (- nargs opts-count (if rest? 1 0)))
  (define nargs-no-rest (- nargs (if rest? 1 0)))
  (define nargs-to-test (iota nargs-no-opts nargs-no-rest))

  (define continue-label (make-unique-label cgc "continue" #f))
  (define error-label    (make-unique-label cgc "narg-error" #f))
  (define rest-label     (make-unique-label cgc "get-rest" #f))

  (define (make-label-curried prefix)
    (lambda (i) (make-unique-label cgc
      (string-append prefix (number->string i)) #f)))

  ;; a flags = jb  jne jle jno jp  jbe jl  js   wrong_na = jae
  ;; b flags = jae je  jle jno jp  jbe jge jns  wrong_na = jne
  ;; c flags = jae jne jg  jno jp  ja  jge jns  wrong_na = jle
  ;; d flags = jae jne jle jo  jp  ja  jl  jns  wrong_na = jno
  ;; e flags = jae jne jle jno jnp ja  jl  js   wrong_na = jp
  ;; f flags = jae jne jle jno jp  ja  jl  js   no jump

  (define (check-not-a label)           (x86-jae cgc label))
  (define (check-not-b label)           (x86-jne cgc label))
  (define (check-not-c label)           (x86-jle cgc label))
  (define (check-not-d label)           (x86-jno cgc label))
  (define (check-not-e label)           (x86-jp  cgc label))
  (define (check-not-a-or-b label)      (x86-ja  cgc label))
  (define (check-not-b-or-c label)      (x86-jl  cgc label))
  (define (check-not-b-or-c-or-d label) (x86-js  cgc label))

  (define (check-a label)               (x86-jb  cgc label))
  (define (check-b label)               (x86-je  cgc label))
  (define (check-c label)               (x86-jg  cgc label))
  (define (check-d label)               (x86-jo  cgc label))
  (define (check-e label)               (x86-jnp cgc label))
  (define (check-ab label)              (x86-jbe cgc label))
  (define (check-bc label)              (x86-jge cgc label))
  (define (check-bcd label)             (x86-jns cgc label))

  (define (check-ps-na arg-count label)
    (let ((na-opnd (get-processor-state-field cgc 'nargs)))
      (x86-cmp cgc (car na-opnd) (x86-imm-int arg-count) (cdr na-opnd))
      (x86-jne cgc label)))

  (define all-negative-tests
    (list check-not-a check-not-b check-not-c check-not-d check-not-e))
  (define negative-tests
    (if use-f-flag all-negative-tests (cdr all-negative-tests)))

  (define all-positive-tests
    (list check-not-a check-not-b check-not-c check-not-d check-not-e))
  (define positive-tests
    (if use-f-flag all-positive-tests (cdr all-positive-tests)))

  (define (check-nargs arg-count jmp-loc use-positive)
    (if (passed-in-ps arg-count)
      ;; Use processor state to pass narg
          (begin
        (if use-f-flag
          ;; Test what is faster.
          ;; 1:
          ;;  (check-[abcde] label)
          ;; 2:
          ;;  (check-a error)
          ;;  (check-bcd error)
          ;;  (check-e error)
          ;; 3:
          ;;  (check-not-a lbl1)
          ;;  lbl1: (check-bcd lbl2)
          ;;  lbl2: (check-e lbl3)
          ;;  lbl3:
          (let ((not-a-lbl   (make-unique-label cgc "not-a" #f))
                (not-bcd-lbl (make-unique-label cgc "not-bcd" #f))
                (not-e-lbl   (make-unique-label cgc "not-e" #f)))
            ;; Checks if nargs was passed in flag instead of ps
            (check-not-a not-a-lbl)
            (am-lbl cgc not-a-lbl)
            (check-not-b-or-c-or-d not-bcd-lbl)
            (am-lbl cgc not-bcd-lbl)
            (check-e jmp-loc)
            ) ;; Continue execution

          (check-not-a jmp-loc))
        (check-ps-na arg-count jmp-loc))
      ;; Use flag register
      ((list-ref
        (if use-positive positive-tests negative-tests)
        (narg-index arg-count))
        jmp-loc)))

  ;; Places the arguments in their correct place
  ;; Todo: Make sure arguments can't overwrite
  (define (mov-arguments-in-correct-position call-nargs)
    (for-each
      (lambda (n)
        (am-mov cgc
          (get-nth-arg cgc (frame-size frame) nargs n)
          (get-nth-arg cgc (frame-size frame) call-nargs n)
          (get-word-width-bits cgc)))
      (iota 0 (- call-nargs 1))))

  ;; Places switch
  ;; Captures the number of argument (If narg-reg)
  ;; Moves the parameters to the right position if necessary
  ;; Moves the default values if necessary
  (define (place-optional-arguments-switch narg-reg)
    (debug "place-optional-arguments-switch")
    (let* ((case-labels
              (map (make-label-curried "opt-case_") nargs-to-test))
           (last-label (if rest? rest-label error-label))
           (next-case-labels (append (cdr case-labels) (list last-label)))
           (rest-opnds (if rest? (list (x86-imm-obj '())) '()))
           (optional-opnds
              (append
                (map (lambda (val) (make-opnd cgc val)) optional-args-values)
                rest-opnds)))

    (for-each
      (lambda (arg-count case-label next-case-label i)
        (am-lbl cgc case-label)
          (check-nargs arg-count next-case-label #f)

          (if narg-reg
            (am-mov cgc narg-reg (int-opnd cgc arg-count)))

        (mov-arguments-in-correct-position arg-count)

        ;; Here, nargs == arg-count
          ;; Places the default values (Including empty list if rest?)
          (let ((default-values-to-move (append (drop-n optional-opnds i))))
    (for-each
            (lambda (default-value j)
          (am-mov cgc
                (get-nth-arg cgc (frame-size frame) nargs (+ i j))
                default-value
                (get-word-width-bits cgc)))

            default-values-to-move
            (iota 0 (length default-values-to-move))))

          (am-jmp cgc error-label))

      nargs-to-test
      case-labels
        next-case-labels
        (iota 0 (length nargs-to-test)))))

  (define (place-rest-switch narg-reg)
    (let* ((rest-nargs-to-test
              (filter
                (lambda (n) (>= n nargs-no-opts))
                nargs-passed-in-flags))
           (get-rest-lbl
             (get-label cgc
               (string->symbol
                 (string-append "FUN-GET-REST-"
                   (number->string (min nargs-no-opts nargs-in-regs))))))
           (case-labels
              (map (make-label-curried "rest-case_") rest-nargs-to-test))
           (check-ps-label (make-unique-label cgc "check-nargs-in-ps" #f))
           (next-case-labels (append (cdr case-labels) (list check-ps-label))))

    ;; Maybe optimise by checking ps-na case before checking flags?
    (for-each
      (lambda (arg-count case-label next-case-label)
        (debug "case-lbl: " case-label)
        (am-lbl cgc case-label)
        (check-nargs arg-count next-case-label #f)
        (if (eq? arg-count nargs-no-opts)
          (begin
            (am-mov cgc
              (get-nth-arg cgc (frame-size frame) arg-count arg-count)
              (x86-imm-obj '()))
            (am-jmp cgc continue-label))
          (begin
            (am-push cgc (lbl-opnd cgc continue-label))
            (am-push cgc (int-opnd cgc arg-count))
            (am-jmp cgc get-rest-lbl))))
      rest-nargs-to-test
      case-labels
      next-case-labels)

      (am-lbl cgc check-ps-label)
      ;; Because nargs-passed-in-flags is a set, we need to compare to nargs-no-opts.
      ;; Example: if 0 is not passed in flags, we would not catch the error
      ;; in the for-each above.
      (let ((narg-field (get-processor-state-field cgc 'nargs)))
        (am-mov cgc narg-reg (car narg-field))
      (x86-cmp cgc narg-reg (int-opnd cgc nargs-no-opts))
      (x86-jl cgc error-label)

      ;; Here, we know it's in ps.
      (am-push cgc (lbl-opnd cgc continue-label))
        (am-push cgc (car narg-field))
        (am-jmp cgc get-rest-lbl))))

  (debug "x64-check-narg: " nargs)
  (x86-int3 cgc)

  (if (and (null? optional-args-values) (not rest?))
    ;; Basic case
    (check-nargs nargs (WRONG_NARGS_LBL cgc) #f)

    ;; Optional and rest arguments case
    (begin
      (if rest?
        ;; If rest
      (get-extra-register cgc
        (lambda (real-nargs-reg)
            (if (not (= 0 opts-count))
              (place-optional-arguments-switch real-nargs-reg))
            (am-lbl cgc rest-label)
            (place-rest-switch real-nargs-reg)))

      ;; If not rest
        (place-optional-arguments-switch #f))

      ;; Error handler
      ;; Note: call-handler places continue-label as return-point
      (am-lbl cgc error-label)
      (call-handler cgc 'handler_wrong_nargs frame continue-label))))

(define (make-get-rest-procedure cgc nargs)
  (let ((registers-to-push
          (map (lambda (i) (get-register cgc i)) (iota 0 (- nargs 1))))
        (repeat-label (make-unique-label cgc "REPEAT: " #f)))

    (get-multiple-extra-register cgc 3
      (lambda (nargs-register ret-reg accum-reg)
        (am-pop cgc nargs-register)
        (am-pop cgc ret-reg)
        (am-mov cgc accum-reg (x86-imm-obj '()))

        (for-each
          (lambda (opnd)
            (am-push cgc opnd))
          registers-to-push)

        ;; Loop
        ;; It will always loop at least once, because we optimise the empty case
        (am-lbl cgc repeat-label)

        ;; Todo: Construct list here

        ; (x86-sub cgc nargs-register (int-opnd cgc 1))
        (x86-dec cgc nargs-register)
        (x86-cmp cgc nargs-register (int-opnd cgc nargs))
        (x86-jg cgc repeat-label)

        (for-each
          (lambda (opnd)
            (am-pop cgc opnd))
          (reverse registers-to-push))

        (am-jmp cgc ret-reg)))))

;; Start routine
;; Gets executed before main
(define (x64-init-routine cgc)
  (debug "put-init-routine"))

;; End routine
;; Gets executed after main if no error happened during execution
(define (x64-end-routine cgc)
  (let* ((target (codegen-context-target cgc))
         (nargs-in-regs (target-nb-arg-regs target)))
    (for-each
      (lambda (nargs)
        (am-lbl cgc
          (get-label cgc
            (string->symbol
              (string-append "FUN-GET-REST-"
                (number->string nargs)))))
        (make-get-rest-procedure cgc nargs)
      )
      (iota 0 nargs-in-regs)))

  (x86-int3 cgc)
  (x86-ret cgc)

  (asm-listing cgc "END ROUTINE")
  (debug "put-end-routine"))

;; Error routine
;; Gets executed if an error occurs
(define (x64-error-routine cgc)
  (debug "put-error-routine")
  (asm-listing cgc "ERROR ROUTINE")

  (am-lbl cgc (ALLOCATION_ERROR_LBL cgc))    ;; Overflow handling
  (am-mov cgc (get-register cgc 1) (x86-imm-obj "Allocation"))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (OVERFLOW_LBL cgc))    ;; Overflow handling
  (am-mov cgc (get-register cgc 1) (x86-imm-obj "Overflow"))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (UNDERFLOW_LBL cgc))   ;; Underflow handling
  (am-mov cgc (get-register cgc 1) (x86-imm-obj "Underflow"))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (WRONG_NARGS_LBL cgc)) ;; Incorrect nargs handling
  (am-mov cgc (get-register cgc 1) (x86-imm-obj "Narg"))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (TYPE_ERROR_LBL cgc))  ;; Type error handling
  (am-mov cgc (get-register cgc 1) (x86-imm-obj "Type"))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (C_ERROR_LBL cgc))

  (am-call-c-function cgc
    'display
    (map
      (lambda (arg) (make-obj-opnd cgc arg))
      (list " error\n")))

  (x86-int3 cgc)
  (x86-ret cgc)
  )

(define (x64-place-extra-data cgc)
  (debug "place-extra-data"))

;; Utils

(define (call-handler cgc sym frame return-loc)
  (let* ((handler-loc (car (get-processor-state-field cgc sym))))
    (debug "handler-loc: " handler-loc)
    (jump-with-return-point cgc handler-loc return-loc frame #t)))