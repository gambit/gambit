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

  (let ((port (current-output-port)))
      (virtual.dump-gvm procs port)
      (dispatch-target targ procs output c-intf module-descr unique-name sem-changing-options sem-preserving-options)
  #f))

;;;----------------------------------------------------------------------------

;; ***** Dispatching

(define primitive-table   #f)
(define put-init-routine  #f)
(define put-end-routine   #f)
(define put-error-routine #f)
(define put-data-routine  #f)
(define setup-function    #f)
(define cleanup-function  #f)

(define (get-prim-obj prim-name)
  (debug "get-prim-obj: " prim-name "\n")
  (let* ((prim-sym (string->symbol prim-name))
         (prim (table-ref primitive-table prim-sym #f)))
    (if prim
        prim
        (compiler-internal-error "get-prim-obj - Unknown primitive: " prim-sym))))

(define (dispatch-target targ
                         procs
                         output
                         c-intf
                         module-descr
                         unique-name
                         sem-changing-options
                         sem-preserving-options)

  (let ((cgc (make-codegen-context)))

    (codegen-context-listing-format-set! cgc 'gnu)

    (case (target-name targ)
      ('x86-64
        (debug "Abstract machine setup \n")
        (x64-setup-abstract-machine)
        (set! primitive-table   (x64-primitive-table))
        (set! put-init-routine  x64-init-routine)
        (set! put-end-routine   x64-end-routine)
        (set! put-error-routine x64-error-routine)
        (set! put-data-routine  x64-place-data)
        (set! setup-function    x64-setup)
        (set! cleanup-function x64-cleanup)
        (debug "x64 setup \n"))
      ; ('x86-32  x86-backend)
      ; ('arm     armv8-backend)
      (else (compiler-internal-error "dispatch-target, unsupported target: " arch)))

      (encode-procs cgc procs)

      (time-cgc cgc #t)))

      ; (test-values (iota 0 64) 1 procs)
      ; (print-results-csv)))

(define (encode-procs cgc procs)

  (define (encode-proc proc)
    (debug "Encoding proc \n")
    (map-proc-instrs
      (lambda (code)
        (encode-gvm-instr cgc proc code))
      proc))

  (debug "Encode procs \n")

  ;; Finishes initialization of CGC and instruction encoder
  ;; Call setup-function only if set
  (if setup-function
    (setup-function cgc))

  (debug "put-init-routine \n")
  (put-init-routine cgc)

  (am-lbl cgc TEST_CODE_LBL)
  ;;  ###########################################################################
  ;;                                 Test code here
  ;;  ###########################################################################


  ;; Important, because main expects 0 arguments.
  ;; The narg check could be removed, but this is simpler.
  (am-set-narg cgc 0)

  (map-on-procs encode-proc procs)

  (debug "put-end-routine \n")
  (put-end-routine cgc)

  (debug "put-error-routine \n")
  (put-error-routine cgc)

  ;; Placing data after the code (end and error routines)
  ;; reduces execution code to 300 from 330 ms in (fib 40)
  (debug "put-data-routine\n")
  (put-data-routine cgc)
  (am-place-data-routine cgc)

  (debug "Adding primitives\n")
  (table-for-each
    (lambda (key val) (put-primitive-if-needed cgc key val))
    proc-labels)

  (debug "Adding objects\n")
  (table-for-each
    (lambda (key val) (put-objects cgc key val))
    obj-labels)

  (am-lbl cgc TEST_DATA_LBL)

  ;; Call cleanup-function only if set
  (if cleanup-function
    (cleanup-function)))

;; Value is Pair (Label, optional Proc-obj)
(define (put-primitive-if-needed cgc key pair)
  (let* ((label (car pair))
          (proc (cadr pair))
          (defined? (or (vector-ref label 1) (not proc)))) ;; See asm-label-pos (Same but without error if undefined)
    (if (not defined?)
      (let ((prim (get-prim-obj (proc-obj-name proc)))
            (then (then-return))
            (args (list (get-register 1) (get-register 2) (get-register 3)))) ;; todo : Find way to get arity

          (debug "Putting primitive: " (proc-obj-name proc) "\n")
          (am-lbl cgc label)
          (prim cgc then args)))))

(define (put-objects cgc obj label)
  (debug "put-objects\n")
  (debug "label: " label "\n")
  (debug "Obj: " obj "\n")

  (am-lbl cgc label)

  (let* ((obj-desc (get-object-description obj))
         (words (format-object obj-desc obj)))
    (apply (am-data-width word-width) (cons cgc words))))

;;;----------------------------------------------------------------------------

;; ***** GVM Instruction encoding

(define (encode-gvm-instr cgc proc code)
  ; (debug "encode-gvm-instr\n")
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

(define (encode-label-instr cgc proc code)
  (debug "encode-label-instr: ")
  (let* ((gvm-instr (code-gvm-instr code))
         (label-num (label-lbl-num gvm-instr))
         (label (get-proc-label cgc proc label-num))
         (narg (label-entry-nb-parms gvm-instr)))

  (debug label "\n")

  ;; Todo: Check if alignment is necessary for task-entry/return
  (if (not (eqv? 'simple (label-type gvm-instr)))
    (asm-align cgc 4 1 144))

    (am-lbl cgc label)

    (if (eqv? 'entry (label-type gvm-instr))
      (am-check-narg cgc narg))))

;; ***** (if)Jump instruction encoding

(define (encode-jump-instr cgc proc code)
  (debug "encode-jump-instr\n")
  (let* ((gvm-instr (code-gvm-instr code))
         (jmp-opnd (jump-opnd gvm-instr)))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (am-poll cgc code)

    ;; Save return address if necessary
    (if (jump-ret gvm-instr)
      (let* ((label-ret-num (jump-ret gvm-instr))
              (label-ret (get-proc-label cgc proc label-ret-num))
              (label-ret-opnd (lbl-opnd label-ret)))
        (am-mov cgc (get-register 0) label-ret-opnd)))

    ;; How to use am-jumplink (Branch with link like in ARM)
    ;; Problem: add-narg-set may change flag register
    ;; If isa support deactivating effects to register (Use global variable to toggle ex: (enable-flag-effects) (disable-flag-effects))
    ;;    Invert save-return-address and set-arg-count
    ;; Else, keep order

    ;; Set arg count
    (if (jump-nb-args gvm-instr)
      (am-set-narg cgc (jump-nb-args gvm-instr)))

    ;; Jump to location. Checks if jump is NOP.
    (let* ((label-num (label-lbl-num (bb-label-instr (code-bb code)))))
      (if (not (and (lbl? jmp-opnd) (= (lbl-num jmp-opnd) (+ 1 label-num))))
        (am-jmp cgc (make-opnd cgc proc code jmp-opnd 'jump))))))

(define (encode-ifjump-instr cgc proc code)
  (debug "encode-ifjump-instr\n")
  (let* ((gvm-instr (code-gvm-instr code))
          (true-label (get-proc-label cgc proc (ifjump-true gvm-instr)))
          (false-label (get-proc-label cgc proc (ifjump-false gvm-instr))))

    ;; Pop stack if necessary
    (alloc-frame cgc (proc-frame-slots-gained code))

    (am-poll cgc code)

    (let* ((prim (get-prim-obj (proc-obj-name (ifjump-test gvm-instr))))
           (then (then-jump true-label false-label))
           (args (map (lambda (opnd) (make-opnd cgc proc code opnd #f)) (ifjump-opnds gvm-instr))))
      (prim cgc then args))))

;; ***** Apply instruction encoding

(define (encode-apply-instr cgc proc code)
  (debug "encode-apply-instr\n")
  (let ((gvm-instr (code-gvm-instr code)))

    (let* ((prim (get-prim-obj (proc-obj-name (apply-prim gvm-instr))))
           (then (then-move (make-opnd cgc proc code (apply-loc gvm-instr) #f)))
           (args (map (lambda (opnd) (make-opnd cgc proc code opnd #f)) (apply-opnds gvm-instr))))
      (prim cgc then args))))

;; ***** Copy instruction encoding

(define (encode-copy-instr cgc proc code)
  (debug "encode-copy-instr\n")
  (let* ((gvm-instr (code-gvm-instr code))
        (src (make-opnd cgc proc code (copy-opnd gvm-instr) #f))
        (dst (make-opnd cgc proc code (copy-loc gvm-instr) #f)))
    (am-mov cgc dst src word-width)))

;; ***** Close instruction encoding

(define (encode-close-instr cgc proc gvm-instr)
  (debug "encode-close-instr\n")
  (compiler-internal-error
    "encode-close-instr: close instruction not implemented"))

;; ***** Switch instruction encoding

(define (encode-switch-instr cgc proc gvm-instr)
  (debug "encode-switch-instr\n")
  (compiler-internal-error
    "encode-switch-instr: switch instruction not implemented"))

;;;----------------------------------------------------------------------------

;; ***** GVM helper methods

(define (map-on-procs fn procs)
  (map fn (reachable-procs procs)))

(define (map-proc-instrs fn proc)
  (let ((p (proc-obj-code proc)))
        (if (bbs? p)
          (map fn (bbs->code-list p)))))

(define (proc-lbl-frame-size code)
  (bb-entry-frame-size (code-bb code)))

(define (proc-jmp-frame-size code)
  (bb-exit-frame-size (code-bb code)))

(define (proc-frame-slots-gained code)
  (bb-slots-gained (code-bb code)))

;;;============================================================================

;; ***** Utils

(define _debug #t)
(define (debug . str)
  (if _debug (for-each display str)))

;; ***** Utils - Lists

(define (find pred elems #!optional (index 0))
  (if (null? elems)
    -1
    (if (pred (car elems))
      index
      (find pred (cdr elems) (+ 1 index)))))

(define (index-of elem elems)
  (find (lambda (var) (equal? var elem)) elems))

(define (iota start end)
  (if (> start end)
    '()
    (cons start (iota (+ start 1) end))))

(define (filter pred elems)
  (if (null? elems)
    '()
    (if (pred (car elems))
      (cons (car elems) (filter pred (cdr elems)))
      (filter pred (cdr elems)))))

(define (map-nth list nth fun)
  (if (= 0 nth)
    (cons (fun (car list)) (cdr list))
    (cons (car list) (map-nth (cdr list) (- nth 1) fun))))

(define (reorder-list elems indexes)
  (if (null? indexes)
    '()
    (cons
      (list-ref elems (car indexes))
      (reorder-list elems (cdr indexes)))))

(define (swap-index index1 index2 elems)
  (define (build-list elems index elem1 elem2)
    (cond ((null? elems)
           '())
          ((= index index1)
           (cons elem2 (build-list (cdr elems) (+ 1 index) elem1 elem2)))
          ((= index index2)
           (cons elem1 (build-list (cdr elems) (+ 1 index) elem1 elem2)))
          (else
           (cons (car elems) (build-list (cdr elems) (+ 1 index) elem1 elem2)))))
  (build-list elems 0 (list-ref elems index1) (list-ref elems index2)))