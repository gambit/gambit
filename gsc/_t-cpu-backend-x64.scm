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
          (cons accum width)
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
      (mov-in-dst src))))

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
    x64-set-narg
    x64-check-narg
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
    (am-mov cgc (car temp1) (lbl-opnd cgc return-loc))
    (call-handler cgc 'handler_stack_limit frame return-loc)))

(define (x64-poll cgc frame)
  (check-overflow-and-interrupt cgc frame))

(define min-nargs-passed-in-ps-na 5) ;; must be in range 0 .. 5

(define (x64-set-narg cgc nargs)
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

  (define (set-ps-na)
    (let ((na-opnd (get-processor-state-field cgc 'nargs)))
      (x86-mov cgc (car na-opnd) (x86-imm-int nargs) (cdr na-opnd))))

  (define all-tests (list flags-a flags-b flags-c flags-d flags-e))
  (define tests
    (if (<= min-nargs-passed-in-ps-na 4)
      (cdr all-tests)
      all-tests))

  (debug "x64-set-narg: " nargs)

      (if (<= min-nargs-passed-in-ps-na nargs)
    ;; Use processor state to pass narg
          (begin
            (set-ps-na)
      (cond
        ((> min-nargs-passed-in-ps-na 4)
            (flags-f))
        ((> min-nargs-passed-in-ps-na 0)
          (flags-a))))
    ;; Use flag register
    ((list-ref tests nargs))))

(define (x64-check-narg cgc fs-start nargs optional-parameters rest?)
  (define (check-not-a label)           (x86-jae cgc label))
  (define (check-not-b label)           (x86-jne cgc label))
  (define (check-not-c label)           (x86-jle cgc label))
  (define (check-not-d label)           (x86-jno cgc label))
  (define (check-not-e label)           (x86-jp  cgc label))
  (define (check-not-a-or-b label)      (x86-ja  cgc label))
  (define (check-not-b-or-c label)      (x86-jl  cgc label))
  (define (check-not-b-or-c-or-d label) (x86-js  cgc label))

  (define (check-ps-na n label)
    (let ((na-opnd (get-processor-state-field cgc 'nargs)))
      (x86-cmp cgc (car na-opnd) (x86-imm-int n) (cdr na-opnd))
      (x86-jne cgc label)))

  (define all-tests (list check-not-a check-not-b check-not-c check-not-d check-not-e))
  (define tests
    (if (<= min-nargs-passed-in-ps-na 4)
      (cdr all-tests)
      all-tests))

  (define (check-n n label)
      (if (<= min-nargs-passed-in-ps-na nargs)
      ;; Use processor state to pass narg
          (begin
        (check-ps-na n label)
        ;; Check if narg was passed in flag instead of ps
        (cond
          ((> min-nargs-passed-in-ps-na 4)
            (check-not-a label)
            (check-not-b-or-c-or-d label)
            (check-not-e label))
          ((> min-nargs-passed-in-ps-na 0)
            (flags-not-a))))
      ;; Use flag register
      ((list-ref tests nargs) label)))

  (debug "x64-check-narg: " nargs)
  ; (x86-int3 cgc)
  (if (and (null? optional-parameters) (not rest?))
    ;; Basic case
    (check-n nargs (WRONG_NARGS_LBL cgc))
    ;; Optional and rest arguments case
    ;; Todo
    #f))

;; Start routine
;; Gets executed before main
(define (x64-init-routine cgc)
  (debug "put-init-routine"))

;; End routine
;; Gets executed after main if no error happened during execution
(define (x64-end-routine cgc)
  (debug "put-end-routine"))

;; Error routine
;; Gets executed if an error occurs
(define (x64-error-routine cgc)
  (debug "put-error-routine")

  (am-lbl cgc (ALLOCATION_ERROR_LBL cgc))    ;; Overflow handling
  (am-mov cgc (x86-rax) (int-opnd cgc -24))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (OVERFLOW_LBL cgc))    ;; Overflow handling
  (am-mov cgc (x86-rax) (int-opnd cgc -20))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (UNDERFLOW_LBL cgc))   ;; Underflow handling
  (am-mov cgc (x86-rax) (int-opnd cgc -16))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (WRONG_NARGS_LBL cgc)) ;; Incorrect narg handling
  (am-mov cgc (x86-rax) (int-opnd cgc -12))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (INTERRUPT_LBL cgc))   ;; Interrupts handling
  (am-mov cgc (x86-rax) (int-opnd cgc -8))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (TYPE_ERROR_LBL cgc))  ;; Type error handling
  (am-mov cgc (x86-rax) (int-opnd cgc -4))
  (am-jmp cgc (C_ERROR_LBL cgc))

  (am-lbl cgc (C_ERROR_LBL cgc))

  (get-extra-register cgc
    (lambda (reg)
      (am-mov cgc reg (x86-imm-obj 'display))
      (am-mov cgc reg (mem-opnd cgc (+ (* 8 3) -9) reg))
      (am-mov cgc reg (mem-opnd cgc 0 reg))
       ;; set r0 to saved return address in init routine
      (am-mov cgc (get-register cgc 0) (get-register cgc 4))
      (am-mov cgc (get-register cgc 1) (int-opnd cgc (* 4 45)))
      (am-set-narg cgc 1)
      (am-jmp cgc reg)))
  )

(define (x64-place-extra-data cgc)
  (debug "place-extra-data"))
