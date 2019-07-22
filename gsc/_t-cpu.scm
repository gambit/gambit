;;============================================================================

;;; File: "_t-cpu.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.
;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")
(include-adt "_cpuadt.scm")

;;----------------------------------------------------------------------------

(define cpu-frame-reserve   3) ; XXX
(define cpu-frame-alignment 4) ; XXX

(define cpu-default-nb-gvm-regs 5) ;; total of available registers
(define cpu-default-nb-arg-regs 3) ;; max args passed in registers

;;----------------------------------------------------------------------------

(define cpu-prim-proc-table
  (let ((t (make-prim-proc-table)))
    (for-each
      (lambda (x) (prim-proc-add! t x))
      '()) ; XXX
    t))

(define (cpu-prim-info name)
  (prim-proc-info cpu-prim-proc-table name))

;;----------------------------------------------------------------------------

;; Initialization/finalization of back-end.

(define (make-cpu-target
          target-arch
          file-extensions
          abstract-machine-info) ; FIXME

  (define (cpu-inlinable name) ; FIXME
    (let ((prim (cpu-prim-info (string->canonical-symbol name))))
      (proc-obj-inlinable?-set! prim (lambda (env) #t))))

  (define (cpu-testable name) ; FIXME
    (let ((prim (cpu-prim-info (string->canonical-symbol name))))
      (proc-obj-testable?-set! prim (lambda (env) #t))))

  (define (cpu-jump-inlinable name) ; FIXME
    (let ((prim (cpu-prim-info (string->canonical-symbol name))))
      (proc-obj-jump-inlinable?-set! prim (lambda (env) #t))))

  (let ((targ (make-target
                12
                target-arch
                file-extensions
                '() ; FIXME
                '() ; FIXME
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

      ;; Linking
      (target-link-info-set!
        targ
        (lambda (file) #f)) ; XXX

      (target-link-set!
        targ
        (lambda (extension? inputs output linker-name warnings?) #f)) ; XXX

      ;; Primitives
      (target-prim-info-set! targ cpu-prim-info)

      ;; Frame
      (target-frame-constraints-set!
        targ
        (make-frame-constraints cpu-frame-reserve cpu-frame-alignment))

      ;; XXX
      (target-proc-result-set! targ (make-reg 1))
      (target-task-return-set! targ (make-reg 0))

      ;; XXX
      (target-switch-testable?-set! targ (lambda (obj) #f))
      (target-eq-testable?-set! targ (lambda (obj) #f))
      (target-object-type-set! targ (lambda (obj) 'bignum))

      ;; Registers
      (let ((nb-gvm-regs (get-option sem-changing-opts
                                     'nb-gvm-regs
                                     cpu-default-nb-gvm-regs))
            (nb-arg-regs (get-option sem-changing-opts
                                     'nb-arg-regs
                                     cpu-default-nb-arg-regs)))
        (target-nb-regs-set! targ nb-gvm-regs)
        (target-nb-arg-regs-set! targ nb-arg-regs))

      ;; FIXME
      (table-for-each
        (lambda (name proc-obj)
          (if (get-primitive-inlinable proc-obj)
              (cpu-inlinable (symbol->string name)))
          (if (get-primitive-testable proc-obj)
              (cpu-testable (symbol->string name))))
        (get-primitive-table-target targ))

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-extra-set! targ 0 abstract-machine-info)

    targ))

;;----------------------------------------------------------------------------

; FIXME
(define (cpu-dump targ
                  procs
                  output
                  c-intf
                  module-descr
                  linker-name
                  sem-changing-options
                  sem-preserving-options
                  info-port)

  (if (output-port? info-port)
      (virtual.dump-gvm procs info-port))

  (let ((cgc ((get-make-cgc-fun targ))))
    (codegen-context-target-set! cgc targ)
    (encode-procs cgc procs)
    (lambda ()
      (create-target-file output linker-name cgc info-port)
      output)))

;;----------------------------------------------------------------------------

; FIXME
(define (create-target-file filename module-name cgc info-port)
  (let* ((code (asm-assemble-to-u8vector cgc))
         (fixup-locs (codegen-context-fixup-locs->vector cgc))
         (fixup-objs (codegen-context-fixup-objs->vector cgc)))

    (if (output-port? info-port)
        (begin
          (asm-display-listing cgc info-port #t)

          (display ";; code = " info-port)
          (display code info-port)
          (newline info-port)

          (display ";; fixup-locs = " info-port)
          (display fixup-locs info-port)
          (newline info-port)

          (display ";; fixup-objs = " info-port)
          (display fixup-objs info-port)
          (newline info-port)))

    ;; Calls compiler to create objfile.o1 using the C backend.
    ;; When the file is loaded, it will execute the x86 code.
    (compile-file-to-target "dummy.scm"
                            output: filename
                            module-name: module-name
                            options: `((linker-name ,module-name) (target C))
                            expression: `((##machine-code-fixup
                                           ',code
                                           ',fixup-locs
                                           ',fixup-objs)))))

;;----------------------------------------------------------------------------

; FIXME
(target-add (x86-32-target))
(target-add (x86-64-target))
(target-add (arm-target))
(target-add (riscv-32-target))
(target-add (riscv-64-target))
