;;============================================================================

;;; File: "_t-cpu.scm"

;;; Copyright (c) 2011-2017 by Laurent Huberdeau, All Rights Reserved.

;; Todo: Check if all includes are necessary
;; Todo: Check if my utils can be refactored in _utils.scm or somewhere else

(include "_t-cpu-abstract-machine.scm")
(include "_t-cpu-function-sub.scm")
(include "_t-cpu-objects-desc.scm")
(include "_t-cpu-primitives.scm")
(include "_t-cpu-bench.scm")
(include "_t-cpu-backend-x64.scm")
(include "_t-cpu-utils.scm")

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
                      1)))

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
    (target-extra-set! targ 0 (x86-64-abstract-machine-info))

    (target-add targ)))

; (cpu-setup 'x86-32 '((".s" . X86-32))  5 5 3 '() '())
(cpu-setup 'x86-64 '((".s" . X86-64)) 13 5 3 '() '())
; (cpu-setup 'arm    '((".s" . ARM))    13 5 3 '() '())

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

(define cpu-frame-reserve 3) ;; no extra slots reserved
(define cpu-frame-alignment 4) ;; no alignment constraint

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

  (let ((cgc ((get-make-cgc-fun targ))))

    (codegen-context-target-set! cgc targ)

    (virtual.dump-gvm procs (current-output-port))
    (encode-procs cgc procs)
    (create-object-file "fib.o1" cgc)
    ; (create-object-file unique-name cgc)
  #f))

;;;----------------------------------------------------------------------------

;; ***** Procedures encoding

(define (encode-procs cgc procs)

  (define C_START_LBL (get-label cgc 'C_START_LBL))

  (define procs2 (reachable-procs procs))

  (define (get-main-label)
    (let* ((main-proc (car procs))
           (bb1 (car (get-code-list main-proc)))
           (instr (code-gvm-instr bb1)))
      (label-instr-label cgc main-proc instr)))

  (define (encode-proc proc)
    (debug "Encoding proc")
    (for-each
      (lambda (code) (encode-gvm-instr cgc proc code))
      (get-code-list proc)))

  (asm-align cgc 8)
  (put-function-vector-metadata cgc)

  ;; Label description structure
  (codegen-fixup-handler! cgc '___lowlevel_exec 64)
  (am-data-word cgc (+ 6 (* 8 14))) ;; PERM PROCEDURE
  (codegen-fixup-lbl! cgc C_START_LBL 0 #f 64)
  (am-data cgc 8 0) ;; so that label reference has tag ___tSUBTYPED

  (debug "Prologue")
  (am-lbl cgc C_START_LBL)

  (am-init cgc)
  (am-set-narg cgc 0)
  (let ((main-lbl (get-main-label)))
    (debug "Placing jump into main. Label: " main-lbl)
    (am-jmp cgc main-lbl))

  (debug "Encode procs")
  (for-each encode-proc procs2)

  (am-end cgc)
  (am-error cgc)
  (am-place-extra-data cgc)

  (debug "Adding primitives")
  (table-for-each
    (lambda (key val) (put-primitive-if-needed cgc key val))
    (get-proc-label-table cgc))

  (debug "Adding global variables")
  (table-for-each
    (lambda (name label) (put-global-variable cgc name label))
    (get-global-var-table cgc))

  (debug "Finished!")

  ;; specify value returned by create-procedure (i.e. procedure reference)
  (codegen-fixup-lbl! cgc C_START_LBL 0 #f 64))

;; Value is Pair (Label, optional Proc-obj)
(define (put-primitive-if-needed cgc key pair)
  (let* ((label (car pair))
         (proc (cadr pair))
         (prim-obj (get-primitive-object cgc (proc-obj-name proc)))
         (defined? (or (vector-ref label 1) (not proc)))) ;; See asm-label-pos (Same but without error if undefined)

    (if (not defined?)
      (if prim-obj
        ;; Prim is defined in native backend
        (let* ((prim-fun (get-primitive-function prim-obj))
               (then (then-return))
               (args (list (get-register cgc 1) (get-register cgc 2) (get-register cgc 3)))) ;; todo : Find way to get arity

          (debug "Putting primitive: " (proc-obj-name proc))
          (am-lbl cgc label)
          (prim-fun cgc then args))

        ;; Prim is defined in C
        ;; We simply passthrough to C. Has some overhead, but calling C has lots of overhead anyway
        (let* ((proc-name (proc-obj-name proc))
               (proc-sym (string->symbol proc-name)))
          (get-extra-register cgc
            (lambda (reg)
              (am-lbl cgc label)
              (am-mov cgc reg (x86-imm-obj proc-sym))
              (am-mov cgc reg (mem-opnd cgc (+ (* 8 3) -9) reg))
              (am-mov cgc reg (mem-opnd cgc 0 reg))
              (am-jmp cgc reg))))))))

(define (put-global-variable cgc name label)
  (debug "put-global-variable")
  (debug "name: " name)
  (debug "label: " label)

  (am-lbl cgc label)
  (am-data-word cgc 0))

;;;----------------------------------------------------------------------------

;; ***** GVM Instruction encoding

(define (encode-gvm-instr cgc proc code)
  (case (gvm-instr-type (code-gvm-instr code))
    ((label)  (encode-label-instr   cgc proc code))
    ((jump)   (encode-jump-instr    cgc proc code))
    ((ifjump) (encode-ifjump-instr  cgc proc code))
    ((apply)  (encode-apply-instr   cgc proc code))
    ((copy)   (encode-copy-instr    cgc proc code))
    ((close)  (encode-close-instr   cgc proc code))
    ((switch) (encode-switch-instr  cgc proc code))
    (else
      (compiler-error
        "encode-gvm-instr, unknown 'gvm-instr-type':" (gvm-instr-type (code-gvm-instr code))))))

;; ***** Label instruction encoding

; Todo: Check if constant
(define (put-function-vector-metadata cgc)
  (am-data-word cgc 0) ;; null cproc
  (am-data-word cgc (+ 6 (* 8 0) (* 1 8 256))) ;; PERM VECTOR of length 1
  (am-data-word cgc -2) ;; info = #f
  (am-data-word cgc 0)) ;; null name

(define (put-entry-point-label cgc label)
  (asm-align cgc 8)
  (put-function-vector-metadata cgc)
  ;; Label description structure
  (codegen-fixup-handler! cgc '___lowlevel_exec 64)
  (am-data-word cgc (+ 6 (* 8 14))) ;; PERM PROCEDURE
  (codegen-fixup-lbl! cgc label 0 #f 64)
  (am-data cgc 8 0) ;; so that label reference has tag ___tSUBTYPED
  (am-lbl cgc label))

(define (put-return-point-label cgc label frame-size ret-pos gcmap)
  (asm-align cgc 8)
  (put-function-vector-metadata cgc)

  (codegen-fixup-handler! cgc '___lowlevel_exec 64)
  (am-data-word cgc (+ 6 (* 8 14))) ;; PERM RETURN
  ;; Check if gcmap can be too large
  (am-data-word cgc (+ 1 ;; RETN (normal return). Todo: Check if correct
    (* 4 frame-size) ;; frame size
    (* 128 ret-pos) ; location of return addr
    (* 4096 gcmap))) ; gcmap
  (am-data cgc 8 0) ;; so that label reference has tag ___tSUBTYPED
  (am-lbl cgc label))

(define (encode-label-instr cgc proc code)

  (let* ((gvm-instr (code-gvm-instr code))
         (label (label-instr-label cgc proc gvm-instr))
         (type (label-type gvm-instr))
         (frame (gvm-instr-frame gvm-instr))
         (frame-size (frame-size frame)))

    (debug "encode-label-instr: " label)

      (case (label-type gvm-instr)
        ((entry)
          (let ((narg (label-entry-nb-parms gvm-instr))
                (opts (label-entry-opts gvm-instr))
                (rest? (label-entry-rest? gvm-instr)))
                ;; Todo: Ask Marc what this is
                ; (keys (label-entry-keys gvm-instr))
                ; (closed? (label-entry-closed? gvm-instr))

                (put-entry-point-label cgc label)

                ;; Todo: Complete narg. Support optional and varargs
                (am-check-narg cgc narg)))

        ((return)
          (put-return-point-label cgc
            label
            frame-size
            (get-frame-ret-pos frame)
            (get-frame-gcmap frame)))
        (else
          (am-lbl cgc label)))))

;; ***** (if)Jump instruction encoding

(define (encode-jump-instr cgc proc code)
  (define (make-jump-opnd opnd)
    (define (make-obj val)
      (cond
        ((proc-obj? val)
          (get-proc-label cgc (obj-val opnd) 1))
        ((immediate-object? val)
          (int-opnd cgc
            (format-imm-object val)
            (get-word-width-bits cgc)))
        ((reference-object? val)
          (x86-imm-obj val))
        (else
          (compiler-internal-error "make-jump-opnd: Unknown object type"))))
    (cond
      ((reg? opnd)
        (get-register cgc (reg-num opnd)))
      ((stk? opnd)
        (frame cgc (proc-jmp-frame-size code) (stk-num opnd)))
      ((lbl? opnd)
        (get-proc-label cgc proc (lbl-num opnd)))
      ((obj? opnd)
        (make-obj (obj-val opnd)))
      ((clo? opnd)
        ;; Todo: Refactor with _t-cpu.scm::encode-close-instr
        (let ((base (get-register cgc (reg-num (clo-base opnd))))
              (index (* 8 (- (clo-index opnd) 1))))
          (mem-opnd cgc index base)))
      ((glo? opnd)
        (x86-imm-glo (glo-name opnd)))
      (else
        (compiler-internal-error "make-jump-opnd: Unknown opnd: " opnd))))

  (debug "encode-jump-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (jmp-opnd (make-jump-opnd (jump-opnd gvm-instr)))
         (label-num (label-lbl-num (bb-label-instr (code-bb code)))))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (am-poll cgc proc code)

    ;; Save return address if necessary
    (if (jump-ret gvm-instr)
      (let* ((label-ret-num (jump-ret gvm-instr))
             (label-ret (get-proc-label cgc proc label-ret-num))
             (label-ret-opnd (lbl-opnd cgc label-ret)))
        (am-mov cgc (get-register cgc 0) label-ret-opnd)))

    ;; Set arg count
    (if (jump-nb-args gvm-instr)
      (am-set-narg cgc (jump-nb-args gvm-instr)))

    ;; Todo: Make sure that jmp-opnd is a label or check type of object
    ;; Todo: Check if next label is simple and jump location. If true, NOP
    ; (if (not (and (lbl? jmp-opnd) (= (lbl-num jmp-opnd) (+ 1 label-num))))
    ;   (am-jmp cgc (make-opnd cgc proc code jmp-opnd 'jump)))))

    (cond
      ((x86-imm-glo? jmp-opnd)
        (get-extra-register cgc
          (lambda (reg)
            (am-mov cgc reg jmp-opnd)
            (am-jmp cgc reg))))
      (else
        (am-jmp cgc jmp-opnd)))))

(define (encode-ifjump-instr cgc proc code)
  (debug "encode-ifjump-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (true-label (get-proc-label cgc proc (ifjump-true gvm-instr)))
         (false-label (get-proc-label cgc proc (ifjump-false gvm-instr)))
         (prim-sym (proc-obj-name (ifjump-test gvm-instr)))
         (prim-obj (get-primitive-object cgc prim-sym)))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (if (not prim-obj)
      (compiler-internal-error "encode-ifjump-instr - Primitive not implemented: " prim-sym))

    (let* ((prim-fun (get-primitive-function prim-obj))
           (then (then-jump true-label false-label))
           (opnds (ifjump-opnds gvm-instr))
           (args (map (lambda (opnd) (make-opnd cgc proc code opnd)) opnds)))
      (prim-fun cgc then args))))

;; ***** Apply instruction encoding

(define (encode-apply-instr cgc proc code)
  (debug "encode-apply-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (prim-sym (proc-obj-name (apply-prim gvm-instr)))
         (prim-obj (get-primitive-object cgc prim-sym))
         (prim-fun (get-primitive-function prim-obj))
         (then (then-move (make-opnd cgc proc code (apply-loc gvm-instr))))
         (args (map (lambda (opnd) (make-opnd cgc proc code opnd)) (apply-opnds gvm-instr))))
    (prim-fun cgc then args)))

;; ***** Copy instruction encoding

(define (encode-copy-instr cgc proc code)
  (define empty-frame-val #f); (int-opnd cgc 0))
  (debug "encode-copy-instr")
  (let* ((gvm-instr (code-gvm-instr code))
         (src (copy-opnd gvm-instr))
         (dst (copy-loc gvm-instr))
         (src-opnd (if src (make-opnd cgc proc code src) empty-frame-val))
         (dst-opnd (make-opnd cgc proc code (copy-loc gvm-instr))))
    (if src-opnd
      (am-mov cgc dst-opnd src-opnd (get-word-width-bits cgc)))))

;; ***** Close instruction encoding

(define (encode-close-instr cgc proc code)
  (debug "encode-close-instr")
  (compiler-internal-error "encode-close-instr: Not implemented"))
  ; (debug (car (close-parms (code-gvm-instr code))))
  ; (let* ((gvm-instr (code-gvm-instr code))
  ;        (mk-opnd (lambda (opnd) (make-opnd cgc proc code opnd)))
  ;        (parms (car (close-parms gvm-instr))) ;; Todo: Find why close-parms returns list
  ;        (loc (mk-opnd (closure-parms-loc parms)))
  ;       ;  (lbl (mk-opnd (closure-parms-lbl parms))) ;; WTF: Why not in opnd-table?
  ;        (lbl (lbl-opnd cgc (get-proc-label cgc proc (closure-parms-lbl parms))))
  ;        (opnds (map mk-opnd (closure-parms-opnds parms)))
  ;       ;  (opnds (closure-parms-opnds parms))
  ;        (size (* (get-word-width cgc) (+ 1 (length opnds)))))

  ;   (get-extra-register cgc
  ;     (lambda (reg)
  ;       (am-allocate-mem cgc size reg)
  ;       (let ((n 0))
  ;         (for-each
  ;           (lambda (opnd)
  ;             (am-mov cgc (mem-opnd cgc (* (get-word-width cgc) n) reg) opnd (get-word-width-bits cgc))
  ;             (set! n (+ n 1)))
  ;           (cons lbl opnds)))

  ;       ;; Todo: Remove mov if unecessary (Next GVM Instruction is often reg = loc)
  ;       (am-mov cgc loc reg)))))

;; ***** Switch instruction encoding

(define (encode-switch-instr cgc proc gvm-instr)
  (debug "encode-switch-instr")
  (compiler-internal-error
    "encode-switch-instr: switch instruction not implemented"))

;;;----------------------------------------------------------------------------

;; ***** GVM helper methods

(define (get-code-list proc)
  (let ((p (proc-obj-code proc)))
        (if (bbs? p)
      (bbs->code-list p)
      #f)))


(define (proc-lbl-frame-size code)
  (bb-entry-frame-size (code-bb code)))

(define (proc-jmp-frame-size code)
  (bb-exit-frame-size (code-bb code)))

(define (proc-frame-slots-gained code)
  (bb-slots-gained (code-bb code)))

(define (label-instr-label cgc proc lbl-instr)
  (let* ((label-num (label-lbl-num lbl-instr)))
    (get-proc-label cgc proc label-num)))

(define (get-frame-gcmap frame)
  (define (live? var)
    (let ((live (frame-live frame)))
      (or (varset-member? var live)
          (and (eq? var closure-env-var)
                (varset-intersects?
                  live
                  (list->varset (frame-closed frame)))))))
  (make-bitmap
    (map
      (lambda (slot) (live? slot))
      (frame-slots frame))))

(define (get-frame-ret-pos frame)
  (index-of 'ret (map var-name (frame-slots frame))))

;;;=============================================================================

;; Config object

;; --enable-multiple-threaded-vms
;; use C backend
;; Use C interface
;; Fast pair test
;; Global variable table register
;; ...

(define config-object
  (let ((table (make-table test: equal?)))
    (table-set! table 'use-c-backend         #t)
    (table-set! table 'use-c-interface       #t)
    (table-set! table 'fast-pair-type-check  #t)
    (table-set! table 'glovar-table-register #t)

    table))

(define (get-opt-val sym)
  (let* ((val (table-ref config-object sym 1243431)))
    (if (eq? val 1243431)
      (compiler-internal-error "(get-opt-val " sym ") Unknown option name")
      val)))
