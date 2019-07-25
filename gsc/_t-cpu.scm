;;=============================================================================

;;; File: "_t-cpu.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.
;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

(include "fixnum.scm")

(include-adt "_cpuadt.scm")

;;-----------------------------------------------------------------------------

(define cpu-frame-reserve   3) ; XXX
(define cpu-frame-alignment 4) ; XXX

(define cpu-default-nb-gvm-regs 5) ;; total of available registers
(define cpu-default-nb-arg-regs 3) ;; max args passed in registers

;;-----------------------------------------------------------------------------

(define cpu-prim-proc-table
  (let ((t (make-prim-proc-table)))
    (for-each
      (lambda (x) (prim-proc-add! t x))
      '()) ; XXX
    t))

(define (cpu-prim-info name)
  (prim-proc-info cpu-prim-proc-table name))

;;-----------------------------------------------------------------------------

(define (cpu-set-nb-regs targ sem-changing-opts)
  (let ((nb-gvm-regs (get-option sem-changing-opts
                                 'nb-gvm-regs
                                 cpu-default-nb-gvm-regs))
        (nb-arg-regs (get-option sem-changing-opts
                                 'nb-arg-regs
                                 cpu-default-nb-arg-regs)))

    (if (or (< nb-gvm-regs 3) (> nb-gvm-regs 25))
        (compiler-error "nb-gvm-regs option must be between 3 and 25"))

    (if (or (< nb-arg-regs 1) (> nb-arg-regs (- nb-gvm-regs 2)))
        (compiler-error
          (string-append "nb-arg-regs option must be between 1 and "
                         (number->string (- nb-gvm-regs 2)))))

    (target-nb-regs-set! targ nb-gvm-regs)
    (target-nb-arg-regs-set! targ nb-arg-regs)))

;;-----------------------------------------------------------------------------

;; Initialization/finalization of back-end.

(define (cpu-make-target target-arch file-extensions backend-info)

  (let ((targ (make-target
                12
                target-arch
                file-extensions
                '() ; XXX
                '() ; XXX
                1)))

    (define (begin! sem-changing-opts
                    sem-preserving-opts
                    info-port)

      (target-dump-set!
        targ
        (lambda (procs output c-intf module-descr linker-name)
          (cpu-dump targ
                    procs
                    output
                    c-intf
                    module-descr
                    linker-name
                    sem-changing-opts
                    sem-preserving-opts
                    info-port)))

      (target-link-info-set!  targ (lambda (file) #f)) ; XXX

      (target-link-set!
        targ
        (lambda (extension? inputs output linker-name warnings?) #f)) ; XXX

      (target-prim-info-set! targ cpu-prim-info)

      (target-frame-constraints-set!
        targ
        (make-frame-constraints cpu-frame-reserve cpu-frame-alignment))

      (target-proc-result-set! targ (make-reg 1)) ; XXX

      (target-task-return-set! targ (make-reg 0)) ; XXX

      (target-switch-testable?-set! targ (lambda (obj) #f)) ; XXX

      (target-eq-testable?-set! targ (lambda (obj) #f)) ; XXX

      (target-object-type-set! targ (lambda (obj) 'bignum)) ; XXX

      (cpu-set-nb-regs targ sem-changing-opts)

      #f)

    (define (end!)

      (table-for-each
        (lambda (name proc-obj)
          (let ((prim (cpu-prim-info name)))
            (proc-obj-inlinable?-set!
              prim
              (lambda (env) (get-primitive-inlinable? proc-obj)))

            (proc-obj-testable?-set!
              prim
              (lambda (env) (get-primitive-testable? proc-obj)))

            (proc-obj-jump-inlinable?-set!
              prim
              (lambda (env) (get-primitive-jump-inlinable? proc-obj))))) ; XXX
        (get-primitive-table targ))

      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-extra-set! targ 0 backend-info)

    targ))

;;-----------------------------------------------------------------------------

(define (cpu-dump targ
                  procs
                  output
                  c-intf
                  module-descr
                  linker-name
                  sem-changing-options
                  sem-preserving-options
                  info-port)

  (if info-port
      (virtual.dump-gvm procs info-port))

  (let ((cgc ((get-make-cgc-fun targ)))) ; XXX
    (codegen-context-target-set! cgc targ) ; XXX
    (encode-procs cgc procs) ; XXX
    (cpu-compile output linker-name info-port cgc)
    (lambda () output)))

;;-----------------------------------------------------------------------------

(define (cpu-compile output linker-name info-port cgc)
  (let ((code (asm-assemble-to-u8vector cgc))
        (fixup-locs (codegen-context-fixup-locs->vector cgc))
        (fixup-objs (codegen-context-fixup-objs->vector cgc)))

    (if info-port
        (asm-display-listing cgc info-port #t))

    ;; The compiler creates an object file using the C backend.
    ;; When loaded, it will execute the assembly code.
    (compile-file-to-target "cpu.scm"
                            options: `((linker-name ,linker-name))
                            output: output
                            expression: `((##machine-code-fixup
                                           ,code
                                           ,fixup-locs
                                           ,fixup-objs)))))

;;-----------------------------------------------------------------------------

(target-add (x86-32-target))
(target-add (x86-64-target))
(target-add (arm-target))
(target-add (riscv-32-target))
(target-add (riscv-64-target))

;;=============================================================================
