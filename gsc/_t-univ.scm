;;;============================================================================

;;; File: "_t-univ.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.

(include "fixnum.scm")
(include "_t-maps.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

;;;----------------------------------------------------------------------------
;;
;; "Universal" back-end.

;; Initialization/finalization of back-end.

(define (univ-setup target-language file-extension)
  (let ((targ (make-target 7 target-language)))

    (define (begin! info-port)

      (target-dump-set!
       targ
       (lambda (procs output c-intf script-line options)
         (univ-dump targ procs output c-intf script-line options)))

      (target-nb-regs-set! targ univ-nb-gvm-regs)

      (target-prim-info-set!
       targ
       (lambda (name)
         (univ-prim-info targ name)))

      (target-label-info-set!
       targ
       (lambda (nb-parms closed?)
         (univ-label-info targ nb-parms closed?)))

      (target-jump-info-set!
       targ
       (lambda (nb-args)
         (univ-jump-info targ nb-args)))

      (target-frame-constraints-set!
       targ
       (make-frame-constraints univ-frame-reserve univ-frame-alignment))

      (target-proc-result-set!
       targ
       (make-reg 1))

      (target-task-return-set!
       targ
       (make-reg 0))

      (target-switch-testable?-set!
       targ
       (lambda (obj)
         (univ-switch-testable? targ obj)))

      (target-file-extension-set!
       targ
       file-extension)

      #f)

    (define (end!)
      #f)

    (target-begin!-set! targ begin!)
    (target-end!-set! targ end!)
    (target-add targ)))

(univ-setup 'js     ".js")
(univ-setup 'python ".py")
(univ-setup 'php    ".php")

;;;----------------------------------------------------------------------------

;; ***** PROCEDURE CALLING CONVENTION

(define univ-nb-gvm-regs 5)
(define univ-nb-arg-regs 3)

(define (univ-label-info targ nb-parms closed?)

;; After a GVM "entry-point" or "closure-entry-point" label, the following
;; is true:
;;
;;  * return address is in GVM register 0
;;
;;  * if nb-parms <= nb-arg-regs
;;
;;      then parameter N is in GVM register N
;;
;;      else parameter N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-parms - nb-arg-regs
;;
;;  * for a "closure-entry-point" GVM register nb-arg-regs+1 contains
;;    a pointer to the closure object
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-parms univ-nb-arg-regs))))

    (define (location-of-parms i)
      (if (> i nb-parms)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-parms (+ i 1)))))

    (let ((x (cons (cons 'return 0) (location-of-parms 1))))
      (make-pcontext nb-stacked
                     (if closed?
                         (cons (cons 'closure-env
                                     (make-reg (+ univ-nb-arg-regs 1)))
                               x)
                         x)))))

(define (univ-jump-info targ nb-args)

;; After a GVM "jump" instruction with argument count, the following
;; is true:
;;
;;  * the return address is in GVM register 0
;;
;;  * if nb-args <= nb-arg-regs
;;
;;      then argument N is in GVM register N
;;
;;      else argument N is in
;;               GVM register N-F, if N > F
;;               GVM stack slot N, if N <= F
;;           where F = nb-args - nb-arg-regs
;;
;;  * GVM register nb-arg-regs+1 contains a pointer to the closure object
;;    if a closure is being jumped to
;;
;;  * other GVM registers contain an unspecified value

  (let ((nb-stacked (max 0 (- nb-args univ-nb-arg-regs))))

    (define (location-of-args i)
      (if (> i nb-args)
          '()
          (cons (cons i
                      (if (> i nb-stacked)
                          (make-reg (- i nb-stacked))
                          (make-stk i)))
                (location-of-args (+ i 1)))))

    (make-pcontext nb-stacked
                   (cons (cons 'return (make-reg 0))
                         (location-of-args 1)))))

;; The frame constraints are defined by the parameters
;; univ-frame-reserve and univ-frame-alignment.

(define univ-frame-reserve 3) ;; when the stack frame is transformed to a
                              ;; heap frame, 3 extra slots are needed to
                              ;; store the subtype object header, the link
                              ;; to the next frame and the return address.

(define univ-frame-alignment 4) ;; align frame to multiple of 4 slots

;; ***** PRIMITIVE PROCEDURE DATABASE

(define (univ-prim-info targ name)
  (table-ref univ-prim-proc-table name #f))

(define univ-prim-proc-table (make-table))

(define (univ-prim-proc-add! x)
  (let ((sym (string->canonical-symbol (car x))))
    (table-set! univ-prim-proc-table
                sym
                (apply make-proc-obj (car x) #f #t #f (cdr x)))))

(for-each univ-prim-proc-add! prim-procs)

(define (univ-switch-testable? targ obj)
  (pretty-print (list 'univ-switch-testable? 'targ obj))
  #f)

;; ***** DUMPING OF A COMPILATION MODULE

(define (univ-dump targ procs output c-intf script-line options)

  (call-with-output-file
      output
    (lambda (port)

      (print
       port: port
       (univ-runtime-system (target-name targ)))

      (univ-dump-procs targ procs port)

      (print
       port: port
       (univ-entry-point (target-name targ) (make-ctx targ #f) (list-ref procs 0)))))

  #f)

(define (univ-dump-procs targ procs port)

  (let ((proc-seen (queue-empty))
        (proc-left (queue-empty)))

    (define (scan-obj obj)
      (if (and (proc-obj? obj)
               (proc-obj-code obj)
               (not (memq obj (queue->list proc-seen))))
          (begin
            (queue-put! proc-seen obj)
            (queue-put! proc-left obj))))

    (define (scan-opnd gvm-opnd)
      (cond ((not gvm-opnd))
            ((obj? gvm-opnd)
             (scan-obj (obj-val gvm-opnd)))
            ((clo? gvm-opnd)
             (scan-opnd (clo-base gvm-opnd)))))

    (define (dump-proc p)

      (define (scan-code ctx code)
        (let ((gvm-instr (code-gvm-instr code)))

          (print
           port: port
           (translate-gvm-instr ctx gvm-instr))

          (case (gvm-instr-type gvm-instr)

            ((apply)
             (for-each scan-opnd (apply-opnds gvm-instr))
             (if (apply-loc gvm-instr)
                 (scan-opnd (apply-loc gvm-instr))))

            ((copy)
             (scan-opnd (copy-opnd gvm-instr))
             (scan-opnd (copy-loc gvm-instr)))

            ((close)
             (for-each (lambda (parms)
                         (scan-opnd (closure-parms-loc parms))
                         (for-each scan-opnd (closure-parms-opnds parms)))
                       (close-parms gvm-instr)))

            ((ifjump)
             (for-each scan-opnd (ifjump-opnds gvm-instr)))

            ((switch)
             (scan-opnd (switch-opnd gvm-instr))
             (for-each (lambda (c) (scan-obj (switch-case-obj c)))
                       (switch-cases gvm-instr)))

            ((jump)
             (scan-opnd (jump-opnd gvm-instr))))))

      (let ((tgt (target-name targ)))
        (print
         port: port
         (univ-gen-nl tgt)
         (univ-open-comment tgt)
         (univ-gen-string tgt "*** #<")
         (if (proc-obj-primitive? p)
              (univ-gen-string tgt "primitive")
              (univ-gen-string tgt "procedure"))
          (univ-gen-string tgt " ")
          (univ-gen-string tgt (object->string (string->canonical-symbol (proc-obj-name p))))
          (univ-gen-string tgt "> =")
          (univ-end-comment tgt)
          (univ-gen-nl tgt)))

      (let ((x (proc-obj-code p)))
        (if (bbs? x)

            (let ((ctx (make-ctx targ (proc-obj-name p))))
              (let loop ((lst (bbs->code-list x)))
                (if (pair? lst)
                    (let* ((code (car lst)))
                      (scan-code ctx code)
                      (loop (cdr lst)))))))))

    (for-each (lambda (proc) (scan-opnd (make-obj proc))) procs)

    (let loop ()
      (if (not (queue-empty? proc-left))
          (begin
            (dump-proc (queue-get! proc-left))
            (loop))))))


(define (make-ctx target ns)
  (vector target ns))

(define (ctx-target ctx)        (vector-ref ctx 0))
(define (ctx-target-set! ctx x) (vector-set! ctx 0 x))

(define (ctx-ns ctx)            (vector-ref ctx 1))
(define (ctx-ns-set! ctx x)     (vector-set! ctx 1 x))

(define (translate-gvm-instr ctx gvm-instr)
  
  (let ((targ (target-name (ctx-target ctx))))
    (case (gvm-instr-type gvm-instr)
      ((label)
       (univ-gen-label-instr targ ctx gvm-instr))

      ((apply)
       (univ-gen-apply-instr targ ctx gvm-instr))

      ((copy)
       (univ-gen-copy-instr targ ctx gvm-instr))

      ((close)
       (univ-gen-close-instr targ ctx gvm-instr))

      ((ifjump)
       (univ-gen-ifjump-instr targ ctx gvm-instr))

      ((switch)
       (univ-gen-switch-instr targ ctx gvm-instr))

      ((jump)
       (univ-gen-jump-instr targ ctx gvm-instr))

      (else
       (compiler-internal-error
        "translate-gvm-instr, unknown 'gvm-instr':"
        gvm-instr)))))

(define (translate-gvm-opnd ctx gvm-opnd)

  (let ((targ (target-name (ctx-target ctx))))
    (cond ((not gvm-opnd)
           (univ-gen-string targ "NO_OPERAND"))

          ((reg? gvm-opnd)
           (univ-gen-reg-opnd targ ctx gvm-opnd))

          ((stk? gvm-opnd)
           (univ-gen-stk-opnd targ ctx gvm-opnd))

          ((glo? gvm-opnd)
           (univ-gen-glo-opnd targ ctx gvm-opnd))

          ((clo? gvm-opnd)
           (univ-gen-clo-opnd targ ctx gvm-opnd))

          ((lbl? gvm-opnd)
           (univ-translate-lbl targ ctx gvm-opnd))

          ((obj? gvm-opnd)
           (univ-gen-obj-opnd targ ctx gvm-opnd))

          (else
           (compiler-internal-error
            "translate-gvm-opnd, unknown 'gvm-opnd':"
            gvm-opnd)))))

;;;============================================================================
