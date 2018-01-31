;;============================================================================

;;; File: "_t-cpu.scm"

;;; Copyright (c) 2011-2017 by Marc Feeley, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;;----------------------------------------------------------------------------
;;
;; "CPU" back-end that targets hardware processors.

;; Initialization/finalization of back-end.

(define (cpu-setup
         target-arch
         file-extensions
         max-nb-gvm-regs
         default-nb-gvm-regs
         default-nb-arg-regs
         semantics-changing-options
         semantics-preserving-options)

  (define common-semantics-changing-options
    '())

  (define common-semantics-preserving-options
    '((asm symbol)))

  (let ((targ
         (make-target 12
                      target-arch
                      file-extensions
                      (append semantics-changing-options
                              common-semantics-changing-options)
                      (append semantics-preserving-options
                              common-semantics-preserving-options)
                      0)))

    (define (begin! sem-changing-opts
                    sem-preserving-opts
                    info-port)

      (target-dump-set!
       targ
       (lambda (procs output c-intf module-descr unique-name)
         (cpu-dump targ
                   procs
                   output
                   c-intf
                   module-descr
                   unique-name
                   sem-changing-opts
                   sem-preserving-opts)))

      (target-link-info-set!
       targ
       (lambda (file)
         (cpu-link-info targ file)))

      (target-link-set!
       targ
       (lambda (extension? inputs output warnings?)
         (cpu-link targ extension? inputs output warnings?)))

      (target-prim-info-set! targ cpu-prim-info)

      (target-frame-constraints-set!
       targ
       (make-frame-constraints
        cpu-frame-reserve
        cpu-frame-alignment))

      (target-proc-result-set!
       targ
       (make-reg 1))

      (target-task-return-set!
       targ
       (make-reg 0))

      (target-switch-testable?-set!
       targ
       (lambda (obj)
         (cpu-switch-testable? targ obj)))

      (target-eq-testable?-set!
       targ
       (lambda (obj)
         (cpu-eq-testable? targ obj)))

      (target-object-type-set!
       targ
       (lambda (obj)
         (cpu-object-type targ obj)))

      (cpu-set-nb-regs targ sem-changing-opts max-nb-gvm-regs)

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

(cpu-setup 'x86-32 '((".s" . X86-32))  5 5 3 '() '())
(cpu-setup 'x86-64 '((".s" . X86-64)) 13 5 3 '() '())
(cpu-setup 'arm    '((".s" . ARM))    13 5 3 '() '())

;;;----------------------------------------------------------------------------

;; ***** REGISTERS AVAILABLE

;; The registers available in the virtual machine default to
;; cpu-default-nb-gvm-regs and cpu-default-nb-arg-regs but can be
;; changed with the gsc options -nb-gvm-regs and -nb-arg-regs.
;;
;; nb-gvm-regs = total number of registers available
;; nb-arg-regs = maximum number of arguments passed in registers

(define cpu-default-nb-gvm-regs 5)
(define cpu-default-nb-arg-regs 3)

(define (cpu-set-nb-regs targ sem-changing-opts max-nb-gvm-regs)
  (let ((nb-gvm-regs
         (get-option sem-changing-opts
                     'nb-gvm-regs
                     cpu-default-nb-gvm-regs))
        (nb-arg-regs
         (get-option sem-changing-opts
                     'nb-arg-regs
                     cpu-default-nb-arg-regs)))

    (if (not (and (<= 3 nb-gvm-regs)
                  (<= nb-gvm-regs max-nb-gvm-regs)))
        (compiler-error
         (string-append "-nb-gvm-regs option must be between 3 and "
                        (number->string max-nb-gvm-regs))))

    (if (not (and (<= 1 nb-arg-regs)
                  (<= nb-arg-regs (- nb-gvm-regs 2))))
        (compiler-error
         (string-append "-nb-arg-regs option must be between 1 and "
                        (number->string (- nb-gvm-regs 2)))))

    (target-nb-regs-set! targ nb-gvm-regs)
    (target-nb-arg-regs-set! targ nb-arg-regs)))

;;;----------------------------------------------------------------------------

;; The frame constraints are defined by the parameters
;; cpu-frame-reserve and cpu-frame-alignment.

(define cpu-frame-reserve 0) ;; no extra slots reserved
(define cpu-frame-alignment 1) ;; no alignment constraint

;;;----------------------------------------------------------------------------

;; ***** PROCEDURE CALLING CONVENTION

(define (cpu-label-info targ nb-params closed?)
  ((target-label-info targ) nb-params closed?))

(define (cpu-jump-info targ nb-args)
  ((target-jump-info targ) nb-args))

;;;----------------------------------------------------------------------------

;; ***** PRIMITIVE PROCEDURE DATABASE

(define cpu-prim-proc-table
  (let ((t (make-prim-proc-table)))
    (for-each
     (lambda (x) (prim-proc-add! t x))
     '())
    t))

(define (cpu-prim-info name)
  (prim-proc-info cpu-prim-proc-table name))

(define (cpu-get-prim-info name)
  (let ((proc (cpu-prim-info (string->canonical-symbol name))))
    (if proc
        proc
        (compiler-internal-error
         "cpu-get-prim-info, unknown primitive:" name))))

;;;----------------------------------------------------------------------------

;; ***** OBJECT PROPERTIES

(define (cpu-switch-testable? targ obj)
  ;;(pretty-print (list 'cpu-switch-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (cpu-eq-testable? targ obj)
  ;;(pretty-print (list 'cpu-eq-testable? 'targ obj))
  #f);;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (cpu-object-type targ obj)
  ;;(pretty-print (list 'cpu-object-type 'targ obj))
  'bignum);;;;;;;;;;;;;;;;;;;;;;;;;

;;;----------------------------------------------------------------------------

;; ***** LINKING

(define (cpu-link-info file)
  (pretty-print (list 'cpu-link-info file))
  #f)

(define (cpu-link extension? inputs output warnings?)
  (pretty-print (list 'cpu-link extension? inputs output warnings?))
  #f)

;;;----------------------------------------------------------------------------

;; ***** INLINING OF PRIMITIVES

(define (cpu-inlinable name)
  (let ((prim (cpu-get-prim-info name)))
    (proc-obj-inlinable?-set! prim (lambda (env) #t))))

(define (cpu-testable name)
  (let ((prim (cpu-get-prim-info name)))
    (proc-obj-testable?-set! prim (lambda (env) #t))))

(define (cpu-jump-inlinable name)
  (let ((prim (cpu-get-prim-info name)))
    (proc-obj-jump-inlinable?-set! prim (lambda (env) #t))))

(cpu-inlinable "##fx+")
(cpu-inlinable "##fx-")

(cpu-testable "##fx<")

;;;----------------------------------------------------------------------------

;; ***** DUMPING OF A COMPILATION MODULE

(define (cpu-dump targ
                  procs
                  output
                  c-intf
                  module-descr
                  unique-name
                  sem-changing-options
                  sem-preserving-options)

  (pretty-print (list 'cpu-dump
                      (target-name targ)
                      (map proc-obj-name procs)
                      output
                      unique-name))
  
  (let ((port (current-output-port)))
      (virtual.dump-gvm procs port)
      (dispatch-target targ procs output c-intf module-descr unique-name sem-changing-options sem-preserving-options)
  #f))

;;;----------------------------------------------------------------------------

;; ***** Dispatching

(define (dispatch-target targ
                         procs
                         output
                         c-intf
                         module-descr
                         unique-name
                         sem-changing-options
                         sem-preserving-options)
        (let* ((arch (target-name targ))
               (handler (case arch
                        ('x86     x86-backend)
                        ('x86-64  x86-64-backend)
                        ('arm     armv8-backend)
                        (else (compiler-internal-error "dispatch-target, unsupported target: " arch))))
               (cgc (make-codegen-context)))

          (codegen-context-listing-format-set! cgc 'gnu)

          (handler
            targ procs output c-intf
            module-descr unique-name
            sem-changing-options sem-preserving-options
            cgc)))

;;;----------------------------------------------------------------------------

;; ***** Label table

(define nat-labels (make-table test: eq?))

(define (get-label cgc proc-name gvm-lbl)
  (define (nat-label-ref label-id)
    (let ((x (table-ref nat-labels label-id #f)))
      (if x
          x
          (let ((l (asm-make-label cgc label-id)))
            (table-set! nat-labels label-id l)
            l))))

  (let ((id (lbl->id gvm-lbl (replace_whitespace proc-name))))
    (nat-label-ref id)))

(define (lbl->id num proc_name)
  (string->symbol (string-append "_"
                                 (number->string num)
                                 "_"
                                 proc_name)))

;;;----------------------------------------------------------------------------

;; ***** x64 code generation

(define (x86-64-backend targ
                        procs
                        output
                        c-intf
                        module-descr
                        unique-name
                        sem-changing-options
                        sem-preserving-options
                        cgc)
                        
  (define (encode-proc proc)
    (map-proc-instrs
      (lambda (code)
        (x64-encode-gvm-instr cgc proc code))
      proc))

  (debug "x86-64-backend\n")
  (asm-init-code-block cgc 0 'le)
  (x86-arch-set! cgc 'x86-64)

  (add-start-routine cgc)
  (map-on-procs encode-proc procs)
  (add-end-routine cgc)
  (show-listing cgc))

;; ***** Constants and helper functions

  (define WRONG_NARGS_LBL (asm-make-label cgc 'WRONG_NARGS_LBL))

  (define r0 (x86-r15)) ;; GVM r0 = x86 r15
  (define r1 (x86-r14)) ;; GVM r1 = x86 r14
  (define r2 (x86-r13)) ;; GVM r2 = x86 r13
  (define r3 (x86-r12)) ;; GVM r3 = x86 r12
  (define r4 (x86-r11)) ;; GVM r4 = x86 r11
  (define r5 (x86-r10)) ;; GVM r4 = x86 r10
  (define na (x86-cl))  ;; number of arguments register
  (define sp (x86-rsp))
  (define fp (x86-rdx))
  (define stack-size 10000) ;; Scheme stack size
  (define offs 1) ;; stack offset so that frame[1] is at null offset from fp

  (define (get-register n) 
    (vector-ref (vector r0 r1 r2 r3 r4 r5) n))

  (define (alloc-frame cgc n)
    (if (< 0 n)
      (x86-add cgc fp (x86-imm-int (* n -8)))))

  (define (frame cgc fs n)
    (x86-mem (* (+ fs (- n) offs) 8) fp))

  (define (x64-gvm-opnd->x86-opnd cgc proc code opnd)
    (debug opnd)
    (debug "\n")
    (cond 
      ((reg? opnd)
        (debug "reg\n")
        (get-register (reg-num opnd)))
      ((stk? opnd)
        (debug "stk\n")
        (frame cgc (proc-lbl-frame-size proc) (stk-num opnd)))
      ((lbl? opnd)
        (debug "lbl\n")
        (x86-imm-lbl (get-label cgc (proc-obj-name proc) (lbl-num opnd))))
      ((obj? opnd)
        (debug "obj\n")
        (x86-imm-int (obj-val opnd) 64))
      ((glo? opnd)
        (compiler-internal-error "Opnd not implementeted global"))
      ((clo? opnd)
        (compiler-internal-error "Opnd not implementeted closure"))
      (else
        (compiler-internal-error "x64-gvm-opnd->x86-opnd: Unknown opnd: " opnd))))

  ;; Provides unique ids
  ;; No need for randomness or UUID
  (define id 0)
  (define (get-unique-id)
    (set! id (+ id 1))
    id)

;; ***** Environment code and primitive functions

  (define (add-start-routine cgc)
    (x86-mov cgc na (x86-imm-int -64 64))
    (x86-lea  cgc fp (x86-mem (* offs -8) sp)) ;; Align frame with offset
  )

  (define (add-end-routine cgc)
    (x86-label cgc WRONG_NARGS_LBL)
    (x86-jmp  cgc WRONG_NARGS_LBL) ;; infinite loop if wrong number of arguments)
  )

;; ***** x64 : GVM Instruction encoding

  (define (x64-encode-gvm-instr cgc proc code)
    ; (debug "x64-encode-gvm-instr\n")
    (case (gvm-instr-type (code-gvm-instr code))
      ((label)  (x64-encode-label-instr   cgc proc code))
      ((apply)  (x64-encode-apply-instr   cgc proc code))
      ((copy)   (x64-encode-copy-instr    cgc proc code))
      ((close)  (x64-encode-close-instr   cgc proc code))
      ((ifjump) (x64-encode-ifjump-instr  cgc proc code))
      ((switch) (x64-encode-switch-instr  cgc proc code))
      ((jump)   (x64-encode-jump-instr    cgc proc code))
      (else
        (compiler-error
          "format-gvm-instr, unknown 'gvm-instr-type':" (gvm-instr-type gvm-instr)))))

;; ***** Label instruction encoding

  (define (x64-encode-label-instr cgc proc code)
    (debug "x64-encode-label-instr: ")
    (let* ((gvm-instr (code-gvm-instr code))
          (proc-name (proc-obj-name proc))
          (label-num (label-lbl-num gvm-instr))
          (label (get-label cgc proc-name label-num))
          (narg (label-entry-nb-parms gvm-instr)))

      (if (not (eqv? 'simple (label-type gvm-instr)))
          (asm-align cgc 4 1))

      (x86-label cgc label)

      (debug label)
      (debug "\n")

      (if (eqv? 'entry (label-type gvm-instr))
        (add-narg-check cgc narg))))

  (define (add-narg-check cgc narg)
    (debug "add-narg-check\n")
    (debug narg)
    (cond
      ((= narg 0)
        (x86-jne cgc WRONG_NARGS_LBL))
      ((= narg 1)
        (x86-jp cgc WRONG_NARGS_LBL))
      ((= narg 2)
        (x86-jno cgc WRONG_NARGS_LBL))
      ((= narg 3)
        (x86-jns cgc WRONG_NARGS_LBL))
      ((<= narg 34)
          (x86-sub cgc na (x86-imm-int (make-parity-adjusted-valued narg)))
          (x86-jne cgc WRONG_NARGS_LBL))
      (else
        (compiler-internal-error "Number of argument not supported: " narg))))

  (define (make-parity-adjusted-valued n)
    (define (bit-count n)
      (if (= n 0)
        0
        (+ (modulo n 2) (bit-count (quotient n 2)))))
    (let* ((narg2 (* 2 (- n 3)))
          (bits (bit-count narg2))
          (parity (modulo bits 2)))
      (+ 64 parity narg2)))

;; ***** (if)Jump instruction encoding

  (define (x64-encode-jump-instr cgc proc code)
    (debug "x64-encode-jump-instr\n")
    (let* ((gvm-instr (code-gvm-instr code))
          (proc-name (proc-obj-name proc))
          (fs-lbl (proc-lbl-frame-size proc))
          (fs-jmp (proc-jmp-frame-size proc))
          (jmp-opnd (jump-opnd gvm-instr)))

      ;; Pop stack if necessary
      (alloc-frame cgc (- fs-jmp fs-lbl))

      ;; TODO
      ;; Poll/safe is specified (jump-poll?/jump-safe? gvm-instr)

      ;; Save return address if necessary 
      (if (jump-ret gvm-instr)
        (let* ((label-ret-num (jump-ret gvm-instr))
                (label-ret (get-label cgc proc-name label-ret-num))
                (label-ret-opnd (x86-imm-lbl label-ret)))
          (x86-mov cgc r0 label-ret-opnd)))

      ;; Set arg count 
      (if (jump-nb-args gvm-instr)
        (add-narg-set cgc (jump-nb-args gvm-instr)))

      ; Jump to location 
      (x86-jmp cgc (x64-jmp-opnd->x86-opnd cgc proc jmp-opnd))))


  (define (x64-encode-ifjump-instr cgc proc code)
    (debug "x64-encode-ifjump-instr\n")
    (let* ((gvm-instr (code-gvm-instr code))
          (proc-name (proc-obj-name proc))
          (fs-lbl (proc-lbl-frame-size proc))
          (fs-jmp (proc-jmp-frame-size proc))
          (true-label (get-label cgc proc-name (ifjump-true gvm-instr)))
          (false-label (get-label cgc proc-name (ifjump-false gvm-instr))))

      ;; Pop stack if necessary 
      (alloc-frame cgc (- fs-jmp fs-lbl))

      ;; TODO
      ;; Poll/safe is specified (jump-poll?/jump-safe? gvm-instr)

      (x64-encode-prim-ifjump 
        cgc
        proc
        code
        (get-prim-obj (proc-obj-name (apply-prim gvm-instr)))
        (ifjump-opnds gvm-instr)
        true-label
        false-label)))
        
  (define (add-narg-set cgc narg)
    (cond
      ((= narg 0)
        (x86-cmp cgc na na))
      ((= narg 1)
        (x86-cmp cgc na (x86-imm-int -65)))
      ((= narg 2)
        (x86-cmp cgc na (x86-imm-int 66)))
      ((= narg 3)
        (x86-cmp cgc na (x86-imm-int 0)))
      ((<= narg 34)
          (x86-add cgc na (x86-imm-int (make-parity-adjusted-valued narg))))
      (else
        (compiler-internal-error "Number of argument not supported: " narg))))

  (define (x64-jmp-opnd->x86-opnd cgc proc jmp-opnd)
    (cond
      ((reg? jmp-opnd)
          (debug "register")
        (get-register (reg-num jmp-opnd)))
      ((stk? jmp-opnd)
          (debug "stack")
        (frame cgc (proc-lbl-frame-size proc) (stk-num jmp-opnd)))
      ((lbl? jmp-opnd)
          (debug "label")
        (get-label cgc (proc-obj-name proc) (lbl-num jmp-opnd)))
      ((obj? jmp-opnd)
        (get-label cgc (proc-obj-name (obj-val jmp-opnd)) 1))
      ((glo? jmp-opnd)
        (compiler-internal-error "x64-encode-jump-instr: global object as jump location"))
      ((clo? jmp-opnd)
        (compiler-internal-error "x64-encode-jump-instr: closure object as jump location"))))

;; ***** Apply instruction encoding

  (define (x64-encode-apply-instr cgc proc code)
    (debug "x64-encode-apply-instr\n")
    (let ((gvm-instr (code-gvm-instr code)))
      (x64-encode-prim-affectation
        cgc 
        proc 
        code
        (get-prim-obj (proc-obj-name (apply-prim gvm-instr)))
        (apply-opnds gvm-instr)
        (apply-loc gvm-instr))))

;; ***** Copy instruction encoding

  (define (x64-encode-copy-instr cgc proc code)
    (debug "x64-encode-copy-instr\n")
    (let* ((gvm-instr (code-gvm-instr code))
          (src (x64-gvm-opnd->x86-opnd cgc proc gvm-instr (copy-opnd gvm-instr)))
          (dst (x64-gvm-opnd->x86-opnd cgc proc gvm-instr (copy-loc gvm-instr))))
      (x86-mov cgc dst src 64)))

;; ***** Close instruction encoding

  (define (x64-encode-close-instr cgc proc gvm-instr)
    (debug "x64-encode-close-instr\n")
    (compiler-internal-error
      "x64-encode-close-instr: close instruction not implemented"))
    
;; ***** Switch instruction encoding

  (define (x64-encode-switch-instr cgc proc gvm-instr)
    (debug "x64-encode-switch-instr\n")
    (compiler-internal-error
      "x64-encode-switch-instr: switch instruction not implemented"))

;; ***** x64 primitives

  ;; (vector (boolean|number) encoder-fun narg narg_need_reg)
  ;; (vector (boolean|number) encoder-fun narg narg_need_reg true-jmp)

  (define (make-number-prim-info symbol encoder narg args-need-reg)
    (if (not (= (length args-need-reg) narg))
      (compiler-internal-error "make-number-prim-info" symbol " narg /= (length args-need-reg)"))
    (vector 'number symbol encoder narg args-need-reg))

  (define (make-boolean-prim-info symbol encoder narg args-need-reg true-jmp)
    (if (not (= (length args-need-reg) narg))
      (compiler-internal-error "make-boolean-prim-info" symbol " narg /= (length args-need-reg)"))
    (vector 'boolean symbol encoder narg args-need-reg true-jmp))

  (define (prim-info-type vect) (vector-ref vect 0))
  (define (prim-info-symbol vect) (vector-ref vect 1))
  (define (prim-info-encoder vect) (vector-ref vect 2))
  (define (prim-info-narg vect) (vector-ref vect 3))
  (define (prim-info-args-need-reg vect) (vector-ref vect 4))
  (define (prim-info-true-jump vect) (vector-ref vect 5))

  (define (get-prim-obj prim-name)
    (case (string->symbol prim-name)
        ('##fx+ prim-info-fx+)
        ('##fx- prim-info-fx-)
        ('##fx< prim-info-fx<)
        (else 
          (compiler-internal-error "Primitive not implemented: " prim-name))))

  (define prim-info-fx+
    (make-number-prim-info '##fx+ x86-add 2 '(#t #f)))
  (define prim-info-fx-
    (make-number-prim-info '##fx- x86-sub 2 '(#t #f)))

  (define prim-info-fx<
    (make-boolean-prim-info '##fx< x86-cmp 2 '(#t #f) x86-jle))

  (define (prim-guard prim-obj args)
    (define (reg-check opnd need-reg)
      (if (and (need-reg) (not (reg? opnd)))
        (compiler-internal-error "prim-guard " (prim-info-symbol prim-obj) " one of it's argument isn't reg but is specified as one")))

    (if (= (length args) (prim-info-narg prim-obj))
      (compiler-internal-error "##fx+ primitive doesn't have 2 operands"))

    (for-each reg-check args (prim-info-args-need-reg prim-obj)))

  ;; Add mov necessary if operation only operates on register but args are not registers
  ;; arg1 is destination
  ;; arg2 is source
  ;; result-loc can be used to mov return after (False to disable)
  (define (x64-encode-prim-affectation cgc proc code prim args result-loc)
    (debug "  x64-apply-binary-op\n")
    (let* ((opnds
            (map
              (lambda (opnd) (x64-gvm-opnd->x86-opnd cgc proc code opnd))
              args))
          (opnd1 (car opnds)))

      (apply (prim-info-encoder prim) cgc (append opnds '(64)))

      (if (and result-loc (not (equal? (car args) result-loc))) 
        (let ((x86-result-loc (x64-gvm-opnd->x86-opnd cgc proc code result-loc)))
        (if (eqv? (prim-info-symbol prim) 'boolean)
          (let* ((proc-name (proc-obj-name proc))
                (id-str (number->string (get-unique-id)))
                (label-name (string-append proc-name "_jump"))
                (label (get-label cgc label-name id-str)))
              (x86-mov cgc x86-result-loc (x86-imm-int 1))
              ((prim-info-true-jump prim) cgc label)
              (x86-mov cgc x86-result-loc (x86-imm-int 0))
              (x86-label label))
          (x86-mov cgc x86-result-loc opnd1))))))

  ;; Add mov necessary if operation only operates on register but args are not registers
  ;; arg1 is destination
  ;; arg2 is source
  ;; result-loc can be used to mov return after (False to disable)
  (define (x64-encode-prim-ifjump cgc proc code prim args true-loc-label false-loc-label)
    (debug "  x64-apply-binary-op\n")
    (let* ((opnds
            (map
              (lambda (opnd) (x64-gvm-opnd->x86-opnd cgc proc code opnd))
              args))
          (opnd1 (car opnds)))

      (apply (prim-info-encoder prim) cgc (append opnds '(64)))

      ((prim-info-true-jump prim) cgc true-loc-label)
      (x86-jmp cgc false-loc-label)))

  ;; Add mov necessary if operation only operates on register but args are not registers
  ;; arg1 is destination
  ;; arg2 is source
  ;; result-loc can be used to mov return after (False to disable)
  (define (x64-encode-prim-jump cgc proc code prim args result-loc)
    (debug "  x64-apply-binary-op\n"))

;;;----------------------------------------------------------------------------

;; ***** GVM helper methods

  (define (map-on-procs fn procs)
    (map fn (reachable-procs procs)))

  (define (map-proc-instrs fn proc)
    (let ((p (proc-obj-code proc)))
          (if (bbs? p)
            (map fn (bbs->code-list p)))))

  (define (proc-lbl proc)
    (let ((codes (bbs->code-list (proc-obj-code proc))))
      (car codes)))

  (define (proc-jmp proc)
    (let ((codes (bbs->code-list (proc-obj-code proc))))
      (list-ref codes (- (length codes) 1))))

  (define (proc-lbl-frame-size proc)
    (frame-size (gvm-instr-frame (code-gvm-instr (proc-lbl proc)))))

  (define (proc-jmp-frame-size proc)
    (frame-size (gvm-instr-frame (code-gvm-instr (proc-jmp proc)))))

;;;============================================================================

;; ***** Utils

(define _debug #f)
(define (debug . str)
  (if _debug (apply display str)))

(define (show-listing cgc)
  (asm-assemble-to-u8vector cgc)
  (asm-display-listing cgc (current-error-port) #t))

(define (replace_whitespace str)
  (let ((f (lambda (c) (if (equal? #\space c) #\_ c)))
        (str-list (string->list str)))
    (list->string (map f str-list))))
