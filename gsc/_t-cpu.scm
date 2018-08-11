;;============================================================================

;;; File: "_t-cpu.scm"

;;; Copyright (c) 2011-2017 by Laurent Huberdeau, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_x86#.scm")
(include-adt "_asm#.scm")
(include-adt "_codegen#.scm")

;;;----------------------------------------------------------------------------
;; "CPU" back-end that targets hardware processors.

;; Initialization/finalization of back-end.

(define cpu-frame-reserve   3) ;; CPU frame reserve
(define cpu-frame-alignment 4) ;; CPU frame alignment

(define (make-cpu-target
          abstract-machine-info
          target-arch
          file-extensions
          nb-gvm-regs
          nb-arg-regs)

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

  (define (cpu-inlinable name)
    (let ((prim (cpu-get-prim-info name)))
      (proc-obj-inlinable?-set! prim (lambda (env) #t))))

  (define (cpu-testable name)
    (let ((prim (cpu-get-prim-info name)))
      (proc-obj-testable?-set! prim (lambda (env) #t))))

  (define (cpu-jump-inlinable name)
    (let ((prim (cpu-get-prim-info name)))
      (proc-obj-jump-inlinable?-set! prim (lambda (env) #t))))

  (let ((targ (make-target 12 target-arch file-extensions '() '((asm symbol)) 1)))

    (define (begin! sem-changing-opts
                    sem-preserving-opts
                    info-port)

      (target-dump-set! targ
        (lambda (procs output c-intf module-descr unique-name)
          (cpu-dump targ procs
                    output c-intf
                    module-descr unique-name
                    sem-changing-opts sem-preserving-opts
                    info-port)))

      ;; Linking
      (target-link-info-set! targ (lambda (file) #f))
      (target-link-set! targ (lambda (extension? inputs output warnings?) #f))

      ;; Frame
      (target-frame-constraints-set! targ
        (make-frame-constraints
          cpu-frame-reserve   ;; CPU frame reserve
          cpu-frame-alignment)) ;; CPU frame alignment

      ;; GVM registers
      (target-nb-regs-set!     targ nb-gvm-regs)
      (target-nb-arg-regs-set! targ nb-arg-regs)
      (target-task-return-set! targ (make-reg 0))
      (target-proc-result-set! targ (make-reg 1))

      ;; Object properties
      (target-switch-testable?-set! targ (lambda (obj) #f))
      (target-eq-testable?-set! targ (lambda (obj) #f))
      (target-object-type-set! targ (lambda (obj) 'bignum))

      ;; Primitives
      (target-prim-info-set! targ cpu-prim-info)
      (table-for-each
        (lambda (name proc-obj)
          (if (get-primitive-inlinable proc-obj)
            (cpu-inlinable (symbol->string name)))
          (if (get-primitive-testable proc-obj)
            (cpu-testable (symbol->string name)))
          )
        (get-primitive-table-target targ))

      #f)

    (define (end!) #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-extra-set! targ 0 abstract-machine-info)

    targ))

(target-add (x86-32-target))
(target-add (x86-64-target))

;;;-----------------------------------------------------------------------------
;; ***** GVM Encoding

(define cpu-debug-port #f)

(define (cpu-dump targ
                  procs
                  output
                  c-intf
                  module-descr
                  unique-name
                  sem-changing-options
                  sem-preserving-options
                  info-port)

  (set! cpu-debug-port info-port)
  (if (output-port? cpu-debug-port)
    (virtual.dump-gvm procs cpu-debug-port))

  (let ((cgc ((get-make-cgc-fun targ))))
    (codegen-context-target-set! cgc targ)
    (encode-procs cgc procs)
    (lambda ()
      (create-target-file output unique-name cgc)
      output)))

;;;----------------------------------------------------------------------------
;; ***** BACKEND OUTPUT

(define (create-target-file filename module-name cgc)
  (let* ((code (asm-assemble-to-u8vector cgc))
         (fixup-locs (codegen-context-fixup-locs->vector cgc))
         (fixup-objs (codegen-context-fixup-objs->vector cgc)))

    (if (output-port? cpu-debug-port)
      (asm-display-listing cgc cpu-debug-port #t))

    (debug ";; code = " code)
    (debug ";; fixup-locs = " fixup-locs)
    (debug ";; fixup-objs = " fixup-objs)

    ;; Calls compiler to create objfile.o1 using the C backend.
    ;; When the file is loaded, it will execute the x86 code.
    (debug "Compiling")
    (compile-file-to-target "dummy.scm"
                            output: filename
                            module-name: module-name
                            options: '((target C))
                            expression: `((##machine-code-fixup
                                  ',code
                                  ',fixup-locs
                                  ',fixup-objs)))

    (debug "Output file: " filename)))

;;;-----------------------------------------------------------------------------
;; Configuration constants

(define USE_BRIDGE #t)
(define FORCE_LOAD_STORE_ARCH #f)