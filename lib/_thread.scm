;;;============================================================================

;;; File: "_thread.scm"

;;; Copyright (c) 1994-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Implementation of exceptions.

(implement-library-type-deadlock-exception)
(implement-library-type-abandoned-mutex-exception)
(implement-library-type-scheduler-exception)
(implement-library-type-noncontinuable-exception)

(implement-library-type-initialized-thread-exception)

(define-prim (##raise-initialized-thread-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-initialized-thread-exception procedure arguments)))))

(implement-library-type-uninitialized-thread-exception)

(define-prim (##raise-uninitialized-thread-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-uninitialized-thread-exception procedure arguments)))))

(implement-library-type-inactive-thread-exception)

(define-prim (##raise-inactive-thread-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-inactive-thread-exception procedure arguments)))))

(implement-library-type-started-thread-exception)

(define-prim (##raise-started-thread-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-started-thread-exception procedure arguments)))))

(implement-library-type-terminated-thread-exception)

(define-prim (##raise-terminated-thread-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-terminated-thread-exception procedure arguments)))))

(implement-library-type-uncaught-exception)

(define-prim (##raise-uncaught-exception reason proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   reason
   #f
   #f
   (lambda (procedure arguments reason dummy1 dummy2)
     (macro-raise
      (macro-make-uncaught-exception procedure arguments reason)))))

(implement-library-type-join-timeout-exception)

(define-prim (##raise-join-timeout-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-join-timeout-exception procedure arguments)))))

(implement-library-type-mailbox-receive-timeout-exception)

(define-prim (##raise-mailbox-receive-timeout-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-mailbox-receive-timeout-exception procedure arguments)))))

(implement-library-type-rpc-remote-error-exception)

(define-prim (##raise-rpc-remote-error-exception msg proc args)
  (##extract-procedure-and-arguments
   proc
   args
   msg
   #f
   #f
   (lambda (procedure arguments message dummy2 dummy3)
     (macro-raise
      (macro-make-rpc-remote-error-exception procedure arguments message)))))

;;;----------------------------------------------------------------------------

;;; Define type checking procedures.

(implement-check-type-continuation)
(implement-check-type-time)
(implement-check-type-absrel-time)
(implement-check-type-absrel-time-or-false)
(implement-check-type-thread)
(implement-check-type-mutex)
(implement-check-type-condvar)
(implement-check-type-tgroup)

;;;----------------------------------------------------------------------------

(implement-type-thread)
(implement-type-mutex)
(implement-type-condvar)
(implement-type-tgroup)

(implement-library-type-thread-state-uninitialized)
(implement-library-type-thread-state-initialized)
(implement-library-type-thread-state-normally-terminated)
(implement-library-type-thread-state-abnormally-terminated)
(implement-library-type-thread-state-active)

(##declare (not interrupts-enabled));;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;============================================================================

;;; File: "thread.scm"

;;; Copyright (c) 2003 by Marc Feeley, All Rights Reserved.

;;; Version 1.3 (august 14, 2000)

(##define-macro (macro-if-gambit-3.0 yes no)
  no)

(##define-macro (macro-not-yet-implemented)
  `(##void));;;;;;;;;;;*************

;;;----------------------------------------------------------------------------

;;; Implementation of dynamic environments.

(define ##parameter-counter 0)

(define-prim (##make-parameter
              init
              #!optional
              (f (macro-absent-obj)))
  (let ((filter
         (if (##eq? f (macro-absent-obj))
           (lambda (x) x)
           f)))
    (macro-check-procedure filter 2 (make-parameter init f)
      (let* ((val
              (filter init))
             (new-count
              (##fx+ ##parameter-counter 1)))
        ;; Note: it is unimportant if the increment of
        ;; ##parameter-counter is not atomic; it simply means a
        ;; possible close repetition of the same hash code
        (set! ##parameter-counter new-count)
        (let ((descr
               (macro-make-parameter-descr
                val
                (##partial-bit-reverse new-count)
                filter)))
          (letrec ((param
                    (lambda (#!optional (new-val (macro-absent-obj)))
                      (if (##eq? new-val (macro-absent-obj))
                        (##dynamic-ref param)
                        (##dynamic-set!
                         param
                         ((macro-parameter-descr-filter descr) new-val))))))
            param))))))

(define-prim (make-parameter init #!optional (f (macro-absent-obj)))
  (macro-force-vars (f)
    (##make-parameter init f)))

(define ##current-exception-handler
  (##make-parameter
   (lambda (exc)
     (##thread-end-with-uncaught-exception! exc))
   (lambda (val)
     (macro-check-procedure val 1 (##current-exception-handler val)
       val))))

(define current-exception-handler
  ##current-exception-handler)

(define ##current-readtable
  (##make-parameter
   ##main-readtable
   (lambda (val)
     (macro-check-readtable val 1 (##current-readtable val)
       val))))

(define current-readtable
  ##current-readtable)

(##open-all-predefined)

(define ##current-input-port
  (##make-parameter
   ##stdin-port
   (lambda (val)
     (macro-check-input-port val 1 (##current-input-port val)
       val))))

(define current-input-port
  ##current-input-port)

(define ##current-output-port
  (##make-parameter
   ##stdout-port
   (lambda (val)
     (macro-check-output-port val 1 (##current-output-port val)
       val))))

(define current-output-port
  ##current-output-port)

(define ##current-error-port
  (##make-parameter
   ##stderr-port
   (lambda (val)
     (macro-check-output-port val 1 (##current-error-port val)
       val))))

(define current-error-port
  ##current-error-port)

(define-prim (##current-directory-filter val)
  (if (##eq? val (macro-absent-obj))
    (let ((current-dir
           (##os-path-normalize-directory #f)))
      (if (##fixnum? current-dir)
        (##exit-with-err-code current-dir)
        current-dir))
    (macro-check-string val 1 (##current-directory val)
      (let ((normalized-dir
             (##os-path-normalize-directory (##path-expand val))))
        (if (##fixnum? normalized-dir)
          (##raise-os-exception #f normalized-dir ##current-directory val)
          normalized-dir)))))

(define ##current-directory
  (##make-parameter
   (macro-absent-obj)
   ##current-directory-filter))

(define current-directory
  ##current-directory)

(define-prim (##parameter? obj)
  (##declare (not interrupts-enabled))
  (and (##procedure? obj)
       (##closure? obj)
       (##eq? (##closure-code obj)
              (##closure-code ##current-exception-handler))))

(##define-macro (macro-parameter-descr param)
  `(##closure-ref ,param 1))

(define-prim (##parameterize param val thunk)
  (##declare (not interrupts-enabled))
  (macro-check-procedure param 1 (##parameterize param val thunk)
    (macro-check-procedure thunk 3 (##parameterize param val thunk)
      (if (##parameter? param)
        (##dynamic-let
         param
         ((macro-parameter-descr-filter (macro-parameter-descr param)) val)
         thunk)
        (let ((save (param)))
          (##dynamic-wind
           (lambda () ;; before
             (param val))
           thunk
           (lambda () ;; after
             (param save))))))))

(define-prim (##dynamic-ref param)
  (##declare (not interrupts-enabled))
  (cond ((##eq? param ##current-exception-handler)
         (macro-current-exception-handler))
        ((##eq? param ##current-input-port)
         (macro-current-input-port))
        ((##eq? param ##current-output-port)
         (macro-current-output-port))
        (else
         (let* ((current-thread
                 (macro-current-thread))
                (c1
                 (macro-thread-denv-cache1 current-thread)))
           (if (##eq? param (##car c1))
             (##cdr c1)
             (let ((c2 (macro-thread-denv-cache2 current-thread)))
               (if (##eq? param (##car c2))
                 (begin
                   (macro-thread-denv-cache2-set! current-thread c1)
                   (macro-thread-denv-cache1-set! current-thread c2)
                   (##cdr c2))
                 (let ((c3 (macro-thread-denv-cache3 current-thread)))
                   (if (##eq? param (##car c3))
                     (begin
                       (macro-thread-denv-cache3-set! current-thread c2)
                       (macro-thread-denv-cache2-set! current-thread c1)
                       (macro-thread-denv-cache1-set! current-thread c3)
                       (##cdr c3))
                     (let* ((denv
                             (macro-thread-denv current-thread))
                            (x
                             (##env-lookup (macro-denv-local denv) param)))
                       (if x
                         (begin
                           (macro-thread-denv-cache3-set!
                            current-thread
                            (macro-thread-denv-cache2 current-thread))
                           (macro-thread-denv-cache2-set!
                            current-thread
                            (macro-thread-denv-cache1 current-thread))
                           (macro-thread-denv-cache1-set!
                            current-thread
                            x)
                           (##cdr x))
                         (macro-parameter-descr-value
                          (macro-parameter-descr param)))))))))))))

(define-prim (##dynamic-set! param val)
  (##declare (not interrupts-enabled))
  (cond ((##eq? param ##current-exception-handler)
         (macro-current-exception-handler-set! val)
         (##void))
        ((##eq? param ##current-input-port)
         (macro-current-input-port-set! val)
         (##void))
        ((##eq? param ##current-output-port)
         (macro-current-output-port-set! val)
         (##void))
        (else
         (let* ((current-thread
                 (macro-current-thread))
                (c1
                 (macro-thread-denv-cache1 current-thread)))
           (if (##eq? param (##car c1))
             (begin
               (##set-cdr! c1 val)
               (##void))
             (let ((c2 (macro-thread-denv-cache2 current-thread)))
               (if (##eq? param (##car c2))
                 (begin
                   (macro-thread-denv-cache2-set! current-thread c1)
                   (macro-thread-denv-cache1-set! current-thread c2)
                   (##set-cdr! c2 val)
                   (##void))
                 (let ((c3 (macro-thread-denv-cache3 current-thread)))
                   (if (##eq? param (##car c3))
                     (begin
                       (macro-thread-denv-cache3-set! current-thread c2)
                       (macro-thread-denv-cache2-set! current-thread c1)
                       (macro-thread-denv-cache1-set! current-thread c3)
                       (##set-cdr! c3 val)
                       (##void))
                     (let* ((denv
                             (macro-thread-denv current-thread))
                            (x
                             (##env-lookup (macro-denv-local denv) param)))
                       (if x
                         (begin
                           (macro-thread-denv-cache3-set!
                            current-thread
                            (macro-thread-denv-cache2 current-thread))
                           (macro-thread-denv-cache2-set!
                            current-thread
                            (macro-thread-denv-cache1 current-thread))
                           (macro-thread-denv-cache1-set!
                            current-thread
                            x)
                           (##set-cdr! x val)
                           (##void))
                         (begin
                           (macro-parameter-descr-value-set!
                            (macro-parameter-descr param)
                            val)
                           (##void)))))))))))))

(define-prim (##dynamic-let param val thunk)
  (##declare (not interrupts-enabled))
  (cond ((##eq? param ##current-exception-handler)
         (macro-dynamic-bind exception-handler
          val
          thunk))
        ((##eq? param ##current-input-port)
         (macro-dynamic-bind input-port
          val
          thunk))
        ((##eq? param ##current-output-port)
         (macro-dynamic-bind output-port
          val
          thunk))
        (else
         (let* ((param-val
                 (##cons param val))
                (denv
                 (macro-thread-denv (macro-current-thread)))
                (new-local-denv
                 (##env-insert (macro-denv-local denv) param-val)))
           (##dynamic-env-bind
            (macro-make-denv
             new-local-denv
             (macro-denv-dynwind denv)
             (macro-denv-interrupt-mask denv)
             (macro-denv-debugging-settings denv)
             (macro-denv-exception-handler denv)
             (macro-denv-input-port denv)
             (macro-denv-output-port denv)
             (macro-denv-repl-context denv))
            thunk)))))

(define-prim (##dynamic-env->list denv)
  (##cons (macro-denv-exception-handler denv)
          (##cons (macro-denv-input-port denv)
                  (##cons (macro-denv-output-port denv)
                          (##env-flatten (macro-denv-local denv)
                                         '())))))

(define-prim (##env-insert env param-val)
  (let* ((param
          (##car param-val))
         (hash-param
          (macro-parameter-descr-hash
           (macro-parameter-descr param))))

    (define (insert env)
      (if (##null? env)
        (macro-make-env
         param-val
         '()
         '())
        (let* ((x
                (macro-env-param-val env))
               (param-x
                (##car x))
               (hash-param-x
                (macro-parameter-descr-hash
                 (macro-parameter-descr param-x))))
          (cond ((##fx< hash-param hash-param-x)
                 (macro-make-env
                  x
                  (insert (macro-env-left env))
                  (macro-env-right env)))
                ((or (##fx< hash-param-x hash-param)
                     (##not (##eq? param-x param)))
                 (macro-make-env
                  x
                  (macro-env-left env)
                  (insert (macro-env-right env))))
                (else
                 (macro-make-env
                  param-val
                  (macro-env-left env)
                  (macro-env-right env)))))))

    (insert env)))

(define-prim (##env-insert! env param val)
  (##declare (not interrupts-enabled))
  (let ((hash-param
         (macro-parameter-descr-hash
          (macro-parameter-descr param))))

    (define (insert! env)
      (let* ((x
              (macro-env-param-val env))
             (param-x
              (##car x))
             (hash-param-x
              (macro-parameter-descr-hash
               (macro-parameter-descr param-x))))
        (cond ((##fx< hash-param hash-param-x)
               (let ((branch (macro-env-left env)))
                 (if (##null? branch)
                   (let ((y (##cons param val)))
                     (macro-env-left-set! env (macro-make-env y '() '()))
                     (##void))
                   (insert! branch))))
              ((or (##fx< hash-param-x hash-param)
                   (##not (##eq? param-x param)))
               (let ((branch (macro-env-right env)))
                 (if (##null? branch)
                   (let ((y (##cons param val)))
                     (macro-env-right-set! env (macro-make-env y '() '()))
                     (##void))
                   (insert! branch))))
              (else
               (##set-cdr! x val)
               (##void)))))

    (insert! env)))

(define-prim (##env-lookup env param)
  (##declare (not interrupts-enabled))
  (let ((hash-param
         (macro-parameter-descr-hash
          (macro-parameter-descr param))))

    (define (lookup env)
      (if (##null? env)
        #f
        (let* ((x
                (macro-env-param-val env))
               (param-x
                (##car x))
               (hash-param-x
                (macro-parameter-descr-hash
                 (macro-parameter-descr param-x))))
          (cond ((##fx< hash-param hash-param-x)
                 (lookup (macro-env-left env)))
                ((or (##fx< hash-param-x hash-param)
                     (##not (##eq? param-x param)))
                 (lookup (macro-env-right env)))
                (else
                 x)))))

    (lookup env)))

(define-prim (##env-flatten env tail)

  (define (flatten env tail)
    (if (##null? env)
      tail
      (##cons (macro-env-param-val env)
              (flatten (macro-env-left env)
                       (flatten (macro-env-right env)
                                tail)))))

  (flatten env tail))

;;;----------------------------------------------------------------------------

;;; Implementation of time objects.

(define-prim (##absrel-timeout->timeout absrel-timeout)
  (cond ((##not absrel-timeout)
         #t)
        ((macro-time? absrel-timeout)
         (macro-update-current-time!)
         (let ((current-time
                (macro-current-time
                 (macro-thread-floats (macro-run-queue))))
               (point
                (macro-time-point absrel-timeout)))
           (and (##fl< current-time point)
                point)))
        ((and (##fixnum? absrel-timeout)
              (##not (##fx< 0 absrel-timeout)))
         #f)
        (else
         (let ((flonum-absrel-timeout
                (macro-real->inexact absrel-timeout)))
           (and (##flpositive? flonum-absrel-timeout)
                (begin
                  (macro-update-current-time!)
                  (let ((current-time
                         (macro-current-time
                          (macro-thread-floats (macro-run-queue)))))
                    (##fl+ current-time
                           flonum-absrel-timeout))))))))

(define-prim (##timeout->time absrel-timeout)
  (cond ((##not absrel-timeout)
         (macro-make-time (macro-inexact-+inf) #f #f #f))
        ((macro-time? absrel-timeout)
         absrel-timeout)
        ((##real? absrel-timeout)
         (let ((flonum-absrel-timeout
                (macro-real->inexact absrel-timeout)))
           (macro-update-current-time!)
           (let ((current-time
                  (macro-current-time
                   (macro-thread-floats (macro-run-queue)))))
             (macro-make-time
              (##fl+ current-time flonum-absrel-timeout)
              #f
              #f
              #f))))
        (else
         (##fail-check-absrel-time-or-false
          1
          timeout->time
          absrel-timeout))))

;;;----------------------------------------------------------------------------

;;; Implementation of blocked thread queues.

(define-rbtree
 macro-btq-init!
 macro-thread->btq
 ##btq-insert!
 ##btq-remove!
 ##btq-reposition!
 macro-btq-singleton?
 macro-btq-color
 macro-btq-color-set!
 macro-btq-parent
 macro-btq-parent-set!
 macro-btq-left
 macro-btq-left-set!
 macro-btq-right
 macro-btq-right-set!
 macro-thread-higher-prio?
 macro-btq-leftmost
 macro-btq-leftmost-set!
 #f
 #f
)

;;;for debugging
(define ##thread-trace 0)
(define-macro (thread-trace n expr)
  `(begin (set! ##thread-trace (##fx+ ,n (##fx* (##fxmodulo ##thread-trace 10000000) 10))) ,expr))

(define-prim (##btq-abandon! btq)
  (##declare (not interrupts-enabled))
  (##btq-lock! btq)
  (macro-btq-deq-remove! btq)
  (let ((leftmost (macro-btq-leftmost btq)))
    (if (##eq? leftmost btq)
      (macro-btq-unlink! btq (macro-mutex-state-abandoned))
      (if (macro-mutex? btq)
        (##mutex-signal-no-reschedule! btq leftmost #t)
        (begin
          (let ((owner (macro-btq-owner btq)))
            (if (macro-thread? owner)
              (thread-trace 0 (##thread-effective-priority-downgrade! owner))))
          (macro-btq-unlink! btq (macro-mutex-state-abandoned))
          (##btq-unlock! btq))))))

;;; Implementation of timeout queues.

(define-rbtree
 macro-toq-init!
 macro-thread->toq
 ##toq-insert!
 ##toq-remove!
 ##toq-reposition!
 macro-toq-singleton?
 macro-toq-color
 macro-toq-color-set!
 macro-toq-parent
 macro-toq-parent-set!
 macro-toq-left
 macro-toq-left-set!
 macro-toq-right
 macro-toq-right-set!
 macro-thread-sooner-or-simultaneous-and-higher-prio?
 macro-toq-leftmost
 macro-toq-leftmost-set!
 #f
 #f
)

;;;----------------------------------------------------------------------------

;;; Implementation of threads.

(define-prim (##run-queue)
  (##declare (not interrupts-enabled))
  (macro-run-queue))

(define-prim (##current-thread)
  (##declare (not interrupts-enabled))
  (macro-current-thread))

(define-prim (##make-thread thunk name tgroup)
  (##declare (not interrupts-enabled))
  (macro-make-thread thunk name tgroup))

(define-prim (##thread-start! thread)
  (##declare (not interrupts-enabled))
  (macro-thread-result-set! thread ##thread-start-action!)
  (##btq-insert! (macro-run-queue) thread)
  (macro-thread-reschedule-if-needed!)
  thread)

(define-prim (##thread-base-priority-set! thread base-priority)

  (##declare (not interrupts-enabled))

  (let ((floats (macro-thread-floats thread)))

    ;; save old boosted priority for ##thread-boosted-priority-changed!

    (macro-temp-set!
     (macro-thread-floats (macro-run-queue))
     (macro-boosted-priority floats))

    (if (##fl= (macro-base-priority floats)
               (macro-boosted-priority floats))
      (macro-boosted-priority-set!
       floats
       base-priority)
      (macro-boosted-priority-set!
       floats
       (##fl+ base-priority
              (macro-priority-boost floats))))

    (macro-base-priority-set! floats base-priority)

    (thread-trace 1 (##thread-boosted-priority-changed! thread))

    ;; the change of priority may have made a higher priority
    ;; thread runnable, check for this

    (macro-thread-reschedule-if-needed!)))

(define-prim (##thread-quantum-set! thread quantum)

  (##declare (not interrupts-enabled))

  (macro-thread-quantum-set! thread quantum)

  ;; check if the current thread's quantum is now over

  (if (and (##eq? thread (macro-current-thread))
           (##not (##fl< (macro-thread-quantum-used thread) quantum)))
    (##thread-yield!)
    (##void)))

(define-prim (##thread-priority-boost-set! thread priority-boost)

  (##declare (not interrupts-enabled))

  (let ((floats (macro-thread-floats thread)))

    (macro-priority-boost-set! floats priority-boost)

    (if (##fl= (macro-base-priority floats)
               (macro-boosted-priority floats))

      (##void)

      (begin

        ;; save old boosted priority for ##thread-boosted-priority-changed!

        (macro-temp-set!
         (macro-thread-floats (macro-run-queue))
         (macro-boosted-priority floats))

        (macro-boosted-priority-set!
         floats
         (##fl+ (macro-base-priority floats)
                priority-boost))

        (thread-trace 2 (##thread-boosted-priority-changed! thread))

        ;; the change of priority may have made a higher priority
        ;; thread runnable, check for this

        (macro-thread-reschedule-if-needed!)))))

(define-prim (##thread-boosted-priority-changed! thread)

  (##declare (not interrupts-enabled))

  (let ((floats (macro-thread-floats thread)))
    (cond ((##fl<
            (macro-effective-priority floats)
            (macro-boosted-priority floats))
           (macro-effective-priority-set!
            floats
            (macro-boosted-priority floats))
           (thread-trace 3 (##thread-effective-priority-changed! thread #t)))
          ((##fl=
            (macro-effective-priority floats)
            (macro-temp (macro-thread-floats (macro-run-queue))))
           (thread-trace 4 (##thread-effective-priority-downgrade! thread))))))

(define-prim (##thread-effective-priority-changed! thread effective-priority-increased?)

  (##declare (not interrupts-enabled))

  (if (macro-toq-parent thread)
    (##toq-reposition! thread)) ;; reposition thread in the toq it is in

  (if (macro-btq-parent thread)
    (begin
      (##btq-reposition! thread) ;; reposition thread in the btq it is in

      ;; make sure the owner of the blocked thread queue
      ;; (i.e. mutex, condvar, etc) inherits the thread's effective
      ;; priority

      (let ((owner (macro-btq-owner (macro-thread->btq thread))))
        (if (macro-thread? owner)
          (if effective-priority-increased?
            (macro-thread-inherit-priority! owner thread)
            (thread-trace 5 (##thread-effective-priority-downgrade! owner))))))))

;; (##thread-effective-priority-downgrade! thread) is called to
;; recompute the effective priority of a thread.  It is only called in
;; situations where the new effective priority is no more than the old
;; one.

(define-prim (##thread-effective-priority-downgrade! thread)

  (##declare (not interrupts-enabled))

  (let ((floats (macro-thread-floats thread)))

    ;; save old effective priority for later

    (macro-temp-set!
     (macro-thread-floats (macro-run-queue))
     (macro-effective-priority floats))

    ;; compute the maximum of the boosted priority and the
    ;; effective priority of all the threads in blocked thread
    ;; queues (i.e. mutexes, condvars, etc) owned by the thread

    (macro-effective-priority-set!
     floats
     (macro-boosted-priority floats))

    (let loop ((btq (macro-btq-deq-next thread)))
      (if (##not (##eq? btq thread))
        (let ((leftmost (macro-btq-leftmost btq)))
          (if (##not (##eq? leftmost btq))
            (let ((leftmost-floats (macro-thread-floats leftmost)))
              (if (##fl< (macro-effective-priority floats)
                         (macro-effective-priority leftmost-floats))
                (macro-effective-priority-set!
                 floats
                 (macro-effective-priority leftmost-floats)))))
          (loop (macro-btq-deq-next btq)))))

    (if (##not (##fl=
                (macro-temp (macro-thread-floats (macro-run-queue)))
                (macro-effective-priority floats)))
      (thread-trace 6 (##thread-effective-priority-changed! thread #f)))))

(define-prim (##thread-btq-insert! btq thread)
  (##declare (not interrupts-enabled))
  (##btq-insert! btq thread)
  (let ((owner (macro-btq-owner btq)))
    (if (macro-thread? owner)
      (macro-thread-inherit-priority! owner thread))))

(define-prim (##thread-btq-remove! thread)

  (##declare (not interrupts-enabled))

  (let ((owner (macro-btq-owner (macro-thread->btq thread))))
    (##btq-remove! thread)
    (if (macro-thread? owner)
      (if (##fl= (macro-thread-effective-priority thread)
                 (macro-thread-effective-priority owner))
        (thread-trace 7 (##thread-effective-priority-downgrade! owner))))))

(define-prim (##thread-toq-remove! thread)
  (##declare (not interrupts-enabled))
  (##toq-remove! thread))

(define-prim (##thread-check-timeouts!)

  (##declare (not interrupts-enabled))

  (let ((run-queue (macro-run-queue)))
    (if (##not (##eq? (macro-toq-leftmost run-queue) run-queue))
        (begin

          (macro-update-current-time!)

          (let loop ()
            (let ((leftmost (macro-toq-leftmost run-queue)))
              (if (and (##not (##eq? leftmost run-queue))
                       (##not (macro-thread-sooner? run-queue leftmost)))
                  (begin
                    (macro-thread-result-set! leftmost ##thread-timeout-action!)
                    (macro-thread-btq-remove-if-in-btq! leftmost)
                    (##thread-toq-remove! leftmost)
                    (##btq-insert! run-queue leftmost)
                    (loop)))))))))

(define-prim (##thread-check-devices! timeout)

  (##declare (not interrupts-enabled))

  (let* ((run-queue (macro-run-queue))
         (code (##os-condvar-select! run-queue timeout)))
    (let loop ((condvar (macro-btq-deq-next run-queue)))
      (if (##eq? condvar run-queue)
        code
        (let ((next (macro-btq-deq-next condvar)))
          (if (##fxodd? (macro-btq-owner condvar))
            (##device-condvar-broadcast-no-reschedule! condvar))
          (loop next))))))

(define-prim (##thread-poll-devices!)

  (##declare (not interrupts-enabled))

  (let ((run-queue (macro-run-queue)))
    (if (##eq? (macro-btq-deq-next run-queue) run-queue) ;; no devices?
        0
        (##thread-check-devices! #f))))

(define-prim (##thread-heartbeat!)

  (##declare (not interrupts-enabled))

  (let ((code (##thread-poll-devices!)))

    (##thread-check-timeouts!)

    (if (and (##fx< code 0)
             (##not (##fx= code ##err-code-EINTR)))

      ;; there was an error that cannot be handled, so force the
      ;; primordial thread to wakeup and raise a "scheduler
      ;; error" exception

      (##thread-report-scheduler-error! code))

    (let* ((run-queue
            (macro-run-queue))
           (current-thread
            (macro-current-thread))
           (run-queue-floats
            (macro-run-queue-floats run-queue))
           (current-thread-floats
            (macro-thread-floats current-thread))
           (quantum-used
            (##fl+ (macro-quantum-used current-thread-floats)
                   (macro-heartbeat-interval run-queue-floats))))

      (macro-quantum-used-set! current-thread-floats quantum-used)

      (if (##fl< quantum-used
                 (macro-quantum current-thread-floats))
        (macro-thread-reschedule-if-needed!)
        (##thread-yield!)))))

(define-prim (##thread-yield!)

  (##declare (not interrupts-enabled))

  (let* ((current-thread
          (macro-current-thread))
         (run-queue
          (macro-run-queue)))
    (if (##eq? (macro-btq-singleton? run-queue) current-thread)
      (begin
        ;; fast case where only one thread is runnable
        (macro-thread-unboost-and-clear-quantum-used! current-thread)
        (##void))
      (macro-thread-save!
       (lambda (current-thread)
         (##btq-remove! current-thread)
         (macro-thread-unboost-and-clear-quantum-used! current-thread)
         (macro-thread-result-set! current-thread ##thread-void-action!)
         (##btq-insert! (macro-run-queue) current-thread)
         (##thread-schedule!))))))

(define-prim (##thread-reschedule!)

  (##declare (not interrupts-enabled))

  (macro-thread-save!
   (lambda (current-thread)
     (macro-thread-result-set! current-thread ##thread-void-action!)
     (##thread-schedule!))))

(define-prim (##thread-sleep! absrel-timeout)

  (##declare (not interrupts-enabled))

  (let ((timeout (##absrel-timeout->timeout absrel-timeout)))
    (if timeout
      (let loop ()
        (let ((result
               (macro-thread-save!
                (lambda (current-thread timeout)
                  (##btq-remove! current-thread)
                  (macro-thread-unboost-and-clear-quantum-used!
                   current-thread)
                  (if (##not (##eq? timeout #t))
                    (begin
                      (macro-thread-timeout-set! current-thread timeout)
                      (##toq-insert! (macro-run-queue) current-thread)))
                  (##thread-schedule!))
                timeout)))
          (if (##eq? result (##void))
            (loop)
            (##void))))
      (##void))))

(define-prim (##thread-schedule!)

  (##declare (not interrupts-enabled))

  (let ((run-queue
         (macro-run-queue)))

    ;; check if there are runnable threads

    (let ((next-thread
           (macro-btq-leftmost run-queue)))
      (if (##not (##eq? next-thread run-queue))

        ;; there are runnable threads, so continue executing the next
        ;; runnable thread

        (macro-thread-restore!
         next-thread
         (macro-thread-result next-thread))

        ;; there are no runnable threads, so check if there are threads
        ;; waiting for a timeout or for a device to become ready

        (let ((next-sleeper
               (macro-toq-leftmost run-queue))
              (next-condvar
               (macro-btq-deq-next run-queue)))
          (if (or (##not (##eq? next-sleeper run-queue))
                  (##not (##eq? next-condvar run-queue)))

            ;; wait for the next timeout or for a device to become ready

            (let ((code
                   (##thread-check-devices!
                    (if (##eq? next-sleeper run-queue)
                      #t ;; timeout is infinite
                      (macro-thread-floats next-sleeper)))))

              ;; ##thread-check-devices! only returns after a device
              ;; becomes ready or the timeout is reached or an error is
              ;; detected

              (##thread-check-timeouts!)

              (cond ((##not (##fx< code 0)) ;; no error?
                     #f)

                    ((##fx= code ##err-code-EINTR)

                     ;; an interrupt may need to be serviced, so make
                     ;; sure at least one thread is runnable

                     (let ((next-thread
                            (macro-btq-leftmost run-queue)))
                       (if (##eq? next-thread run-queue)

                         ;; no thread is currently runnable, so wake up
                         ;; a thread that is sleeping or waiting on a
                         ;; device

                         (let ((next-sleeper
                                (macro-toq-leftmost run-queue)))
                           (if (##not (##eq? next-sleeper run-queue))

                             ;; a thread was sleeping so make it
                             ;; temporarily wake up so that it detects
                             ;; the interrupt (after the interrupt is
                             ;; processed the thread will resume
                             ;; sleeping)

                             (##thread-int!
                              next-sleeper
                              ##thread-check-interrupts!)

                             (let ((next-condvar
                                    (macro-btq-deq-next run-queue)))
                               (if (##not (##eq? next-condvar run-queue))

                                 ;; a thread is blocked on a device so
                                 ;; make it temporarily wake up so that
                                 ;; it detects the interrupt (after the
                                 ;; interrupt is processed the thread
                                 ;; will resume waiting)

                                 (##device-condvar-broadcast-no-reschedule!
                                  next-condvar)

                                 ;; no thread can possibly make further
                                 ;; progress, so let next call of
                                 ;; ##thread-schedule! detect and
                                 ;; handle the deadlock

                                 #f)))))))

                    (else

                     ;; there was an error that cannot be handled, so
                     ;; force the primordial thread to wakeup (it can't
                     ;; be currently runnable) and raise a "scheduler
                     ;; error" exception

                     (##thread-report-scheduler-error! code))))

            ;; no thread can possibly make further progress, so force
            ;; the primordial thread to wakeup (it can't be currently
            ;; runnable) and raise a "deadlock" exception

            (##thread-int!
             (macro-primordial-thread)
             ##thread-deadlock-action!))

          ;; check things one more time!

          (##thread-schedule!))))))

(define-prim (##thread-report-scheduler-error! code)

  (##declare (not interrupts-enabled))

  (##thread-int!
   (macro-primordial-thread)
   (lambda ()

     (macro-raise
      (macro-make-scheduler-exception
       (macro-make-os-exception #f #f #f code)))

     ;; return void so that primordial thread will continue
     ;; normally if exception handler returns

     (##void))))

(define-prim (##thread-interrupt!
              thread
              #!optional
              (action (macro-absent-obj)))

  (##declare (not interrupts-enabled))

  (let ((act
         (if (##eq? action (macro-absent-obj))
             ##user-interrupt!
             action)))

    (cond ((##eq? thread (macro-current-thread))
           (act)
           (##void))

          ((or (##not (macro-initialized-thread? thread))
               (macro-terminated-thread-given-initialized? thread)
               (##not (macro-started-thread-given-initialized? thread)))
           (##raise-inactive-thread-exception thread-interrupt! thread action))

          (else
           (##thread-int! thread (lambda () (act) (##void)))
           (##void)))))

(define-prim (##thread-int! thread thunk-returning-void)

  (##declare (not interrupts-enabled))

  ;; Note: the thunk-returning-void procedure must return void in
  ;; order to restart the interrupted thread properly.

  ;; remove the thread from any blocked thread queue and
  ;; timeout queue it is in

  (macro-thread-btq-remove-if-in-btq! thread)
  (macro-thread-toq-remove-if-in-toq! thread)

  (macro-thread-result-set! thread thunk-returning-void)

  (##btq-insert! (macro-run-queue) thread))

(define-prim (##thread-continuation-capture thread)
  (##thread-call
   thread
   (lambda ()
     (##continuation-capture (lambda (k) k)))))

(define-prim (##thread-call thread thunk)
  (let ((result-mutex (macro-make-mutex 'thread-call-result)))
    (macro-mutex-lock! result-mutex #f thread)
    (##thread-interrupt!
     thread
     (lambda ()
       (let ((result (thunk)))
         (macro-mutex-specific-set! result-mutex result)
         (macro-mutex-unlock! result-mutex)
         (##void))))
    (macro-mutex-lock! result-mutex #f (macro-current-thread))
    (macro-mutex-specific result-mutex)))

(define-prim (##thread-start-action!)

  (##declare (not interrupts-enabled))

  (let* ((current-thread
          (macro-current-thread))
         (thunk
          (macro-thread-exception? current-thread)))
    (macro-thread-exception?-set! current-thread #f)
    (let ((result (thunk)))
      (##thread-end! (macro-current-thread) #f result))))

(define-prim (##thread-check-interrupts!)
  (##declare (interrupts-enabled))
  (##declare (not inline))
  (##thread-void-action!)) ;; interrupts will be checked here

(define-prim (##thread-void-action!)
  (##declare (not interrupts-enabled))
  (##void))

(define-prim (##thread-abandoned-mutex-action!)
  (##declare (not interrupts-enabled))
  (macro-raise (macro-make-constant-abandoned-mutex-exception)))

(define-prim (##thread-locked-mutex-action!)
  (##declare (not interrupts-enabled))
  #t)

(define-prim (##thread-signaled-condvar-action!)
  (##declare (not interrupts-enabled))
  #t)

(define-prim (##thread-timeout-action!)
  (##declare (not interrupts-enabled))
  #f)

(define-prim (##thread-deadlock-action!)

  (##declare (not interrupts-enabled))

  (macro-raise (macro-make-constant-deadlock-exception))

  ;; return void so that primordial thread will continue normally
  ;; if exception handler returns

  (##void))

(define-prim (##thread-suspend! thread)
  (##declare (not interrupts-enabled))
  (macro-not-yet-implemented));;;;;;;;;;;;;;;;

(define-prim (##thread-resume! thread)
  (##declare (not interrupts-enabled))
  (macro-not-yet-implemented));;;;;;;;;;;;;;

(define-prim (##thread-terminate! thread)
  (##declare (not interrupts-enabled))
  (##thread-end!
   thread
   'terminated-thread-exception
   #f))

(define-prim (##thread-end-with-uncaught-exception! exc)
  (##thread-end!
   (macro-current-thread)
   'uncaught-exception
   exc))

(define-prim (##primordial-exception-handler exc)
  (##declare (not interrupts-enabled))
  (let ((handler ##primordial-exception-handler-hook))
    (if (##procedure? handler)
      (handler exc ##thread-end-with-uncaught-exception!)
      (##thread-end-with-uncaught-exception! exc))))

(define ##primordial-thread #f)

(define primordial-exception-handler ##primordial-exception-handler)

(define ##primordial-exception-handler-hook #f)
(set! ##primordial-exception-handler-hook #f)

(define-prim (##thread-end! thread exception? result)

  (##declare (not interrupts-enabled))

  (if (##eq? thread (macro-primordial-thread))

    ;; termination of the primordial thread causes the program to terminate

    (if (##eq? exception? 'uncaught-exception)
      (##exit-with-exception result)
      (##exit))

    ;; perform thread termination only if thread is not already
    ;; terminated, or in the process of terminating

    (let ((end-condvar (macro-thread-end-condvar thread)))
      (if (##not end-condvar)
        (##void)
        (begin

          ;; the thread must abandon all the blocked thread queues
          ;; (i.e. mutexes, condvars, etc) it owns

          (let loop ()
            (let ((next-btq (macro-btq-deq-next thread)))
              (if (##not (##eq? next-btq thread))
                (begin
                  (##btq-abandon! next-btq)
                  (loop)))))

          (macro-thread-end-condvar-set! thread #f)
          (macro-thread-exception?-set! thread exception?)
          (macro-thread-result-set! thread result)
          (##condvar-signal-no-reschedule! end-condvar #t)
          (macro-thread-btq-remove-if-in-btq! thread)
          (macro-thread-toq-remove-if-in-toq! thread)
          (macro-tgroup-threads-deq-remove! thread)
          (macro-tgroup-threads-deq-init! thread)
          (macro-thread-cont-set! thread #t)
          (macro-thread-denv-set! thread #f)
          (macro-thread-denv-cache1-set! thread #f)
          (macro-thread-denv-cache2-set! thread #f)
          (macro-thread-denv-cache3-set! thread #f)
          (cond ((##eq? thread (macro-current-thread))
                 (##thread-schedule!))
                (else
                 (macro-thread-reschedule-if-needed!))))))))

(define-prim (##thread-join! thread absrel-timeout timeout-val)
  (##declare (not interrupts-enabled))
  (let ((joined-before-timeout?
         (let ((end-condvar (macro-thread-end-condvar thread)))
           (if end-condvar
             (let ((timeout
                    (##absrel-timeout->timeout
                     (if (##eq? absrel-timeout (macro-absent-obj))
                       #f
                       absrel-timeout))))
               (if timeout
                 (let loop ()
                   (let ((result
                          (macro-thread-save!
                           (lambda (current-thread thread timeout)
                             (let ((end-condvar
                                    (macro-thread-end-condvar thread)))

                               ;; do a final check of the state of
                               ;; the thread (this double check is
                               ;; necessary because a thread-switch
                               ;; may occur during the capturing of
                               ;; the continuation by
                               ;; macro-thread-save!)

                               (if end-condvar
                                 (begin
                                   (##btq-remove! current-thread)
                                   (macro-thread-boost-and-clear-quantum-used!
                                    current-thread)
                                   (##thread-btq-insert!
                                    end-condvar
                                    current-thread)
                                   (if (##not (##eq? timeout #t))
                                     (begin
                                       (macro-thread-timeout-set!
                                        current-thread
                                        timeout)
                                       (##toq-insert!
                                        (macro-run-queue)
                                        current-thread)))
                                   (##thread-schedule!))
                                 #t)))
                           thread
                           timeout)))
                     (if (##eq? result (##void))
                       (loop)
                       result)))
                 #f))
             #t))))

    (if joined-before-timeout?
      (case (macro-thread-exception? thread)
        ((uncaught-exception)
         (##raise-uncaught-exception
          (macro-thread-result thread)
          thread-join!
          thread
          absrel-timeout
          timeout-val))
        ((terminated-thread-exception)
         (##raise-terminated-thread-exception
          thread-join!
          thread
          absrel-timeout
          timeout-val))
        (else
         (macro-thread-result thread)))
      (if (##eq? timeout-val (macro-absent-obj))
        (##raise-join-timeout-exception
         thread-join!
         thread
         absrel-timeout
         timeout-val)
        timeout-val))))

(define-prim (##make-root-thread
              thunk
              name
              tgroup
              input-port
              output-port)

  (##declare (not interrupts-enabled))

  (let* ((interrupt-mask
          0)
         (debugging-settings
          0)
         (local-binding
          (##cons ##current-directory
                  (macro-parameter-descr-value
                   (macro-parameter-descr ##current-directory)))))

    ;; these macros are defined to prevent the normal thread
    ;; inheritance mechanism when a root thread is created

    (##define-macro (macro-current-thread)
      `#f)

    (##define-macro (macro-thread-denv thread)
      `#f)

    (##define-macro (macro-denv-local denv)
      `(macro-make-env local-binding '() '()))

    (##define-macro (macro-denv-dynwind denv)
      `##initial-dynwind)

    (##define-macro (macro-denv-interrupt-mask denv)
      `interrupt-mask)

    (##define-macro (macro-denv-debugging-settings denv)
      `debugging-settings)

    (##define-macro (macro-denv-input-port denv)
      `(##cons ##current-input-port input-port))

    (##define-macro (macro-denv-output-port denv)
      `(##cons ##current-output-port output-port))

    (##define-macro (macro-thread-denv-cache1 thread)
      `local-binding)

    (##define-macro (macro-thread-denv-cache2 thread)
      `local-binding)

    (##define-macro (macro-thread-denv-cache3 thread)
      `local-binding)

    (##define-macro (macro-thread-floats thread)
      `#f)

    (##define-macro (macro-base-priority floats)
      `(macro-thread-root-base-priority))

    (##define-macro (macro-quantum floats)
      `(macro-thread-root-quantum))

    (##define-macro (macro-priority-boost floats)
      `(macro-thread-root-priority-boost))

    ;; create root thread

    (macro-make-thread thunk name tgroup)))

(define-prim (make-root-thread
              thunk
              #!optional
              (n (macro-absent-obj))
              (tg (macro-absent-obj))
              (ip (macro-absent-obj))
              (op (macro-absent-obj)))
  (macro-force-vars (thunk n tg ip op)
    (let* ((name
            (if (##eq? n (macro-absent-obj))
              (##void)
              n))
           (tgroup
            (if (##eq? tg (macro-absent-obj))
              (macro-thread-tgroup (macro-current-thread))
              tg))
           (input-port
            (if (##eq? ip (macro-absent-obj))
              ##stdin-port
              ip))
           (output-port
            (if (##eq? op (macro-absent-obj))
              ##stdout-port
              op)))
      (macro-check-procedure thunk 1 (make-root-thread thunk n tg ip op)
        (macro-check-tgroup tgroup 3 (make-root-thread thunk n tg ip op)
          (macro-check-input-port input-port 4 (make-root-thread thunk n tg ip op)
            (macro-check-output-port output-port 5 (make-root-thread thunk n tg ip op)
              (##make-root-thread thunk name tgroup input-port output-port))))))))

(define-prim (##thread-startup!)

  (##declare (not interrupts-enabled))

  (let* ((primordial-tgroup
          (##make-tgroup 'primordial #f))
         (input-port
          (macro-parameter-descr-value
           (macro-parameter-descr ##current-input-port)))
         (output-port
          (macro-parameter-descr-value
           (macro-parameter-descr ##current-output-port)))
         (primordial-thread
          (##make-root-thread
           #f
           'primordial
           primordial-tgroup
           input-port
           output-port)))

    (##c-code
     "
     ___ps->current_thread = ___ARG1;
     ___ps->run_queue = ___ARG2;
     ___RESULT = ___FAL;
     "
     primordial-thread
     (macro-make-run-queue))

    (set! ##primordial-thread primordial-thread)

    (##btq-insert! (macro-run-queue) primordial-thread)

    (##interrupt-vector-set! 1 ##thread-heartbeat!)

    ;; These parameters are locally bound in all threads, so the value
    ;; field of the parameter descriptors are of no use and can be cleared.
    (macro-parameter-descr-value-set!
     (macro-parameter-descr ##current-exception-handler)
     #f)
    (macro-parameter-descr-value-set!
     (macro-parameter-descr ##current-input-port)
     #f)
    (macro-parameter-descr-value-set!
     (macro-parameter-descr ##current-output-port)
     #f)

    ;; assign serial number 1 to primordial thread
    (##object->serial-number primordial-thread)

    (##void)))

(define-prim (##thread-heartbeat-interval-set! seconds)
  (##declare (not interrupts-enabled))
  (let* ((actual-interval
          (##heartbeat-interval-set! seconds))
         (run-queue
          (macro-run-queue))
         (run-queue-floats
          (macro-thread-floats run-queue)))
    (macro-heartbeat-interval-set! run-queue-floats actual-interval)
    actual-interval))

;;;----------------------------------------------------------------------------

;;; Mailbox operations.

(define-prim (##thread-mailbox-get! thread)
  (##declare (not interrupts-enabled))
  (or (macro-thread-mailbox thread)
      (let ((mb (macro-make-mailbox)))
        (or (macro-thread-mailbox thread)
            (begin
              (macro-thread-mailbox-set! thread mb)
              mb)))))

(define-prim (##thread-mailbox-rewind)
  (##declare (not interrupts-enabled))
  (let ((mb (##thread-mailbox-get! (macro-current-thread))))
    (macro-mailbox-cursor-set! mb #f)
    (##void)))

(define-prim (thread-mailbox-rewind)
  (##thread-mailbox-rewind))

(define-prim (##thread-mailbox-extract-and-rewind)
  (##declare (not interrupts-enabled))
  (let* ((mb
          (##thread-mailbox-get! (macro-current-thread)))
         (cursor
          (macro-mailbox-cursor mb)))
    (if cursor
      (let* ((next (macro-fifo-next cursor))
             (next2 (macro-fifo-next next)))
        (macro-fifo-next-set! cursor next2)
        (if (##not (##pair? next2))
          (macro-fifo-tail-set! (macro-mailbox-fifo mb) cursor))
        (macro-mailbox-cursor-set! mb #f)))
    (##void)))

(define-prim (thread-mailbox-extract-and-rewind)
  (##thread-mailbox-extract-and-rewind))

(define-prim (##thread-mailbox-next-or-receive
              extract-and-rewind?
              prim
              absrel-timeout
              timeout-val)
  (##declare (not interrupts-enabled))
  (let* ((mb
          (##thread-mailbox-get! (macro-current-thread)))
         (cursor
          (macro-mailbox-cursor mb))
         (next
          (if cursor
            (macro-fifo-next cursor)
            (macro-mailbox-fifo mb)))
         (next2
          (macro-fifo-next next)))
    (if (##pair? next2)
      (let ((result (macro-fifo-elem next2)))
        (if extract-and-rewind?
          (let ((next3 (macro-fifo-next next2)))
            (macro-fifo-next-set! next next3)
            (if (##not (##pair? next3))
              (macro-fifo-tail-set! (macro-mailbox-fifo mb) next))
            (macro-mailbox-cursor-set! mb #f))
          (macro-mailbox-cursor-set! mb next))
        result)
      (let ((timeout
             (##absrel-timeout->timeout
              (if (##eq? absrel-timeout (macro-absent-obj))
                #f
                absrel-timeout))))
        (let loop ()
          (let* ((mb
                  (##thread-mailbox-get! (macro-current-thread)))
                 (mutex
                  (macro-mailbox-mutex mb)))
            (macro-mutex-lock! mutex #f (macro-current-thread))
            (let* ((cursor
                    (macro-mailbox-cursor mb))
                   (next
                    (if cursor
                      (macro-fifo-next cursor)
                      (macro-mailbox-fifo mb)))
                   (next2
                    (macro-fifo-next next)))
              (if (##pair? next2)
                (let ((result (macro-fifo-elem next2)))
                  (if extract-and-rewind?
                    (let ((next3 (macro-fifo-next next2)))
                      (macro-fifo-next-set! next next3)
                      (if (##not (##pair? next3))
                        (macro-fifo-tail-set! (macro-mailbox-fifo mb) next))
                      (macro-mailbox-cursor-set! mb #f))
                    (macro-mailbox-cursor-set! mb next))
                  (macro-mutex-unlock! mutex)
                  result)
                (if (##mutex-signal-and-condvar-wait!
                     mutex
                     (macro-mailbox-condvar mb)
                     timeout)
                  (loop)
                  (if (##eq? timeout-val (macro-absent-obj))
                    (##raise-mailbox-receive-timeout-exception
                     prim
                     absrel-timeout
                     timeout-val)
                    timeout-val))))))))))

(define-prim (thread-mailbox-next
              #!optional
              (absrel-timeout (macro-absent-obj))
              (timeout-val (macro-absent-obj)))
  (macro-force-vars (absrel-timeout)
    (if (or (##eq? absrel-timeout (macro-absent-obj))
            (macro-absrel-time-or-false? absrel-timeout))
      (##thread-mailbox-next-or-receive
       #f
       thread-mailbox-next
       absrel-timeout
       timeout-val)
      (##fail-check-absrel-time-or-false
       1
       thread-mailbox-next
       absrel-timeout
       timeout-val))))

(define-prim (thread-receive
              #!optional
              (absrel-timeout (macro-absent-obj))
              (timeout-val (macro-absent-obj)))
  (macro-force-vars (absrel-timeout)
    (if (or (##eq? absrel-timeout (macro-absent-obj))
            (macro-absrel-time-or-false? absrel-timeout))
      (##thread-mailbox-next-or-receive
       #t
       thread-receive
       absrel-timeout
       timeout-val)
      (##fail-check-absrel-time-or-false
       1
       thread-receive
       absrel-timeout
       timeout-val))))

(define-prim (##thread-send thread obj)
  (##declare (not interrupts-enabled))
  (let* ((mb
          (##thread-mailbox-get! thread))
         (mutex
          (macro-mailbox-mutex mb)))
    (macro-mutex-lock! mutex #f (macro-current-thread))
    (macro-fifo-insert-at-tail! (macro-mailbox-fifo mb) obj)
    (macro-mutex-unlock! mutex)
    (##condvar-signal! (macro-mailbox-condvar mb) #f)
    (##void)))

(define-prim (thread-send thread obj)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-send thread obj)
      (macro-check-initialized-thread thread (thread-send thread obj)
        (##thread-send thread obj)))))

;;;----------------------------------------------------------------------------

;;; Implementation of mutexes.

(define-prim (##make-mutex name)
  (##declare (not interrupts-enabled))
  (macro-make-mutex name))

(define-prim (##mutex-lock-out-of-line! mutex absrel-timeout owner new-owner)
  (##declare (not interrupts-enabled))
  (let ((timeout (##absrel-timeout->timeout absrel-timeout)))
    (if timeout
        (let loop ()
          (let ((result
                 (macro-thread-save!
                  (lambda (current-thread mutex timeout new-owner)
                    (##btq-lock! mutex)
                    (let ((owner (macro-btq-owner mutex)))

                      ;; do a final check of the state of the
                      ;; mutex and suspend if can't lock the
                      ;; mutex (this double check is necessary
                      ;; because a thread-switch may occur during
                      ;; the capturing of the continuation by
                      ;; macro-thread-save!)

                      (if (or (##eq? owner (macro-mutex-state-not-abandoned))
                              (##eq? owner (macro-mutex-state-abandoned)))

                          (begin
                            (if new-owner
                                (if (macro-thread-end-condvar new-owner)
                                    (macro-btq-link! mutex new-owner)
                                    (macro-btq-owner-set! mutex (macro-mutex-state-abandoned)))
                                (macro-btq-owner-set! mutex (macro-mutex-state-not-owned)))
                            (##btq-unlock! mutex)
                            (if (##eq? owner (macro-mutex-state-not-abandoned))
                                #t
                                (##thread-abandoned-mutex-action!)))

                          (begin
                            (##btq-remove! current-thread)
                            (macro-thread-boost-and-clear-quantum-used!
                             current-thread)
                            (macro-thread-result-set!
                             current-thread
                             new-owner)
                            (##thread-btq-insert! mutex current-thread)
                            (if (##not (##eq? timeout #t))
                                (begin
                                  (macro-thread-timeout-set!
                                   current-thread
                                   timeout)
                                  (##toq-insert!
                                   (macro-run-queue)
                                   current-thread)))
                            (macro-btq-owner-set! mutex owner)
                            (##btq-unlock! mutex)
                            (##thread-schedule!)))))

                  mutex
                  timeout
                  new-owner)))
            (if (##eq? result (##void))
                (loop)
                result)))
        #f)))

(define-prim (##mutex-signal! mutex thread abandoned?)

  (##declare (not interrupts-enabled))

  (##mutex-signal-no-reschedule! mutex thread abandoned?)

  ;; check if the call to ##mutex-signal-no-reschedule! caused a
  ;; higher priority thread to become runnable

  (macro-thread-reschedule-if-needed!))

(define-prim (##mutex-signal-no-reschedule! mutex thread abandoned?)

  (##declare (not interrupts-enabled))

  (thread-trace 8 (##thread-btq-remove! thread))

  (##btq-unlock! mutex)

  (let ((new-owner (macro-thread-result thread)))
    (if new-owner
        (if (macro-thread-end-condvar new-owner)
            (begin
              (macro-btq-link! mutex new-owner)
              (let ((new-leftmost (macro-btq-leftmost mutex)))
                (if (##not (##eq? new-leftmost mutex))
                    (macro-thread-inherit-priority! new-owner new-leftmost))))
            (macro-btq-unlink! mutex (macro-mutex-state-abandoned)))
        (macro-btq-unlink! mutex (macro-mutex-state-not-owned))))

  (macro-thread-result-set!
   thread
   (if abandoned?
       ##thread-abandoned-mutex-action!
       ##thread-locked-mutex-action!))

  (macro-thread-toq-remove-if-in-toq! thread)

  (##btq-insert! (macro-run-queue) thread))

(define-prim (##mutex-signal-and-condvar-wait! mutex condvar timeout)

  (##declare (not interrupts-enabled))

  (if timeout
    (let ((result
           (macro-thread-save!
            (lambda (current-thread mutex condvar timeout)
              (##btq-remove! current-thread)
              (macro-thread-boost-and-clear-quantum-used!
               current-thread)
              (##thread-btq-insert! condvar current-thread)
              (if (##not (##eq? timeout #t))
                (begin
                  (macro-thread-timeout-set!
                   current-thread
                   timeout)
                  (##toq-insert!
                   (macro-run-queue)
                   current-thread)))
              (macro-mutex-unlock-no-reschedule! mutex)
              (##thread-schedule!))
            mutex
            condvar
            timeout)))
      (if (##eq? result (##void))
        #t ;; abort wait when interrupted
        result))
    (begin
      (macro-mutex-unlock-no-reschedule! mutex)
      (macro-thread-reschedule-if-needed!)
      #f)))

(define-prim (##wait-for-io! condvar timeout)
  (##declare (not interrupts-enabled))
  (if timeout
    (let ((result
           (macro-thread-save!
            (lambda (current-thread condvar timeout)
              (##btq-remove! current-thread)
              (macro-thread-boost-and-clear-quantum-used!
               current-thread)
              (##thread-btq-insert! condvar current-thread)
              (if (##not (##eq? timeout #t))
                (begin
                  (macro-thread-timeout-set!
                   current-thread
                   timeout)
                  (##toq-insert!
                   (macro-run-queue)
                   current-thread)))
              (macro-btq-deq-remove! condvar)
              (macro-btq-deq-insert! (macro-run-queue) condvar)
              (##thread-schedule!))
            condvar
            timeout)))
      (##thread-check-interrupts!) ;; catch any user interrupts
      (if (##eq? result (##void))
          #t
          result))
    (begin
      (macro-thread-reschedule-if-needed!)
      #f)))

(define-prim (##device-condvar-broadcast-no-reschedule! condvar)
  (##declare (not interrupts-enabled))
  (macro-btq-deq-remove! condvar)
  (macro-btq-deq-init! condvar)
  (##condvar-signal-no-reschedule! condvar #t))

;;;----------------------------------------------------------------------------

;;; Implementation of condition variables.

(define-prim (##make-condvar name)
  (##declare (not interrupts-enabled))
  (macro-make-condvar name))

(define-prim (##condvar-signal! condvar broadcast?)
  (##declare (not interrupts-enabled))
  (##condvar-signal-no-reschedule! condvar broadcast?)
  (macro-thread-reschedule-if-needed!))

(define-prim (##condvar-signal-no-reschedule! condvar broadcast?)
  (##declare (not interrupts-enabled))
  (let loop ()
    (let ((leftmost (macro-btq-leftmost condvar)))
      (if (##not (##eq? leftmost condvar))
        (begin
          (macro-thread-result-set!
           leftmost
           ##thread-signaled-condvar-action!)
          (thread-trace 9 (##thread-btq-remove! leftmost))
          (macro-thread-toq-remove-if-in-toq! leftmost)
          (##btq-insert! (macro-run-queue) leftmost)
          (if broadcast?
            (loop)
            (##void)))
        (##void)))))

;;;----------------------------------------------------------------------------

;;; Implementation of thread groups.

(define-prim (##make-tgroup name parent)
  (##declare (not interrupts-enabled))
  (macro-make-tgroup name parent))

(define-prim (##tgroup-suspend! tgroup)
  (##declare (not interrupts-enabled))
  (macro-not-yet-implemented))

(define-prim (##tgroup-resume! tgroup)
  (##declare (not interrupts-enabled))
  (macro-not-yet-implemented))

(define-prim (##tgroup-terminate! tgroup)
  (##declare (not interrupts-enabled))
  (macro-not-yet-implemented))

(define-prim (##tgroup->tgroup-vector tgroup)
  (##declare (not interrupts-enabled))
  (let ((deq (macro-tgroup-tgroups tgroup)))
    (let loop1 ((probe deq) (n 0))
      (let ((next (macro-tgroup-tgroups-deq-next probe)))
        (if (##not (##eq? next deq))
            (loop1 next (##fx+ n 1))
            (let ((v (##make-vector n)))
              (let loop2 ((probe deq) (i 0))
                (let ((next (macro-tgroup-tgroups-deq-next probe)))
                  (if (##not (##eq? next deq))
                      (if (##fx= i n) ;; more elements this time around?
                          (loop1 next (##fx+ i 1))
                          (begin
                            (##vector-set! v i next)
                            (loop2 next (##fx+ i 1))))
                      (begin
                        (##vector-shrink! v i) ;; there may be fewer elements!
                        v))))))))))

(define-prim (##tgroup->tgroup-list tgroup)
  (##declare (not interrupts-enabled))
  (##vector->list (##tgroup->tgroup-vector tgroup)))

(define-prim (##tgroup->thread-vector tgroup)
  (##declare (not interrupts-enabled))
  (let ((deq tgroup))
    (let loop1 ((probe deq) (n 0))
      (let ((next (macro-tgroup-threads-deq-next probe)))
        (if (##not (##eq? next deq))
            (loop1 next (##fx+ n 1))
            (let ((v (##make-vector n)))
              (let loop2 ((probe deq) (i 0))
                (let ((next (macro-tgroup-threads-deq-next probe)))
                  (if (##not (##eq? next deq))
                      (if (##fx= i n) ;; more elements this time around?
                          (loop1 next (##fx+ i 1))
                          (begin
                            (##vector-set! v i next)
                            (loop2 next (##fx+ i 1))))
                      (begin
                        (##vector-shrink! v i) ;; there may be fewer elements!
                        v))))))))))

(define-prim (##tgroup->thread-list tgroup)
  (##declare (not interrupts-enabled))
  (##vector->list (##tgroup->thread-vector tgroup)))

;;;----------------------------------------------------------------------------

;;; User accessible primitives for time objects.

(define-prim (##current-time-point)
  (macro-update-current-time!)
  (macro-current-time (macro-thread-floats (macro-run-queue))))

(define-prim (current-time)
  (macro-make-time (##current-time-point) #f #f #f))

(define-prim (time? obj)
  (macro-time? obj))

(define-prim (time->seconds t)
  (macro-force-vars (t)
    (macro-check-time t 1 (time->seconds t)
      (macro-time-point t))))

(define-prim (seconds->time s)
  (macro-force-vars (s)
    (macro-check-real s 1 (seconds->time s)
      (macro-make-time (macro-real->inexact s) #f #f #f))))

(define-prim (timeout->time absrel-timeout)
  (macro-force-vars (absrel-timeout)
    (##timeout->time absrel-timeout)))

;;;----------------------------------------------------------------------------

;;; User accessible primitives for threads.

(define-prim (current-thread)
  (macro-current-thread))

(define-prim (thread? obj)
  (macro-force-vars (obj)
    (macro-thread? obj)))

(define-prim (make-thread
              thunk
              #!optional
              (n (macro-absent-obj))
              (tg (macro-absent-obj)))
  (macro-force-vars (thunk n tg)
    (let* ((name
            (if (##eq? n (macro-absent-obj))
              (##void)
              n))
           (tgroup
            (if (##eq? tg (macro-absent-obj))
              (macro-thread-tgroup (macro-current-thread))
              tg)))
      (macro-check-procedure thunk 1 (make-thread thunk n tg)
        (macro-check-tgroup tgroup 3 (make-thread thunk n tg)
          (macro-make-thread thunk name tgroup))))))

(define-prim (thread-init!
              thread
              thunk
              #!optional
              (n (macro-absent-obj))
              (tg (macro-absent-obj)))
  (macro-force-vars (thread thunk n tg)
    (let* ((name
            (if (##eq? n (macro-absent-obj))
              (##void)
              n))
           (tgroup
            (if (##eq? tg (macro-absent-obj))
              (macro-thread-tgroup (macro-current-thread))
              tg)))
      (macro-check-thread thread 1 (thread-init! thread thunk n tg)
        (macro-check-procedure thunk 2 (thread-init! thread thunk n tg)
          (macro-check-tgroup tgroup 4 (thread-init! thread thunk n tg)
            (macro-check-not-initialized-thread
             thread
             (thread-init! thread thunk n tg)
             (macro-thread-init! thread thunk name tgroup))))))))

(define-prim (thread-name thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-name thread)
      (macro-check-initialized-thread thread (thread-name thread)
        (macro-thread-name thread)))))

(define-prim (thread-thread-group thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-thread-group thread)
      (macro-check-initialized-thread thread (thread-thread-group thread)
        (macro-thread-tgroup thread)))))

(define-prim (thread-specific thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-specific thread)
      (macro-check-initialized-thread thread (thread-specific thread)
        (macro-thread-specific thread)))))

(define-prim (thread-specific-set! thread obj)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-specific-set! thread obj)
      (macro-check-initialized-thread thread (thread-specific-set! thread obj)
        (begin
          (macro-thread-specific-set! thread obj)
          (##void))))))

(define-prim (thread-base-priority thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-base-priority thread)
      (macro-check-initialized-thread thread (thread-base-priority thread)
        (macro-thread-base-priority thread)))))

(define-prim (thread-base-priority-set! thread base-priority)
  (macro-force-vars (thread base-priority)
    (macro-check-thread
     thread
     1
     (thread-base-priority-set! thread base-priority)
     (macro-check-real
      base-priority
      2
      (thread-base-priority-set! thread base-priority)
      (macro-check-initialized-thread
       thread
       (thread-base-priority-set! thread base-priority)
       (##thread-base-priority-set!
        thread
        (macro-real->inexact base-priority)))))))

(define-prim (thread-quantum thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-quantum thread)
      (macro-check-initialized-thread thread (thread-quantum thread)
        (macro-thread-quantum thread)))))

(define-prim (thread-quantum-set! thread quantum)
  (macro-force-vars (thread quantum)
    (macro-check-thread thread 1 (thread-quantum-set! thread quantum)
      (macro-check-real
       quantum
       2
       (thread-quantum-set! thread quantum)
       (let ((q (macro-real->inexact quantum)))
         (if (##flnegative? q)
           (##raise-range-exception 2 thread-quantum-set! thread quantum)
           (macro-check-initialized-thread
            thread
            (thread-quantum-set! thread quantum)
            (##thread-quantum-set! thread q))))))))

(define-prim (thread-priority-boost thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-priority-boost thread)
      (macro-check-initialized-thread thread (thread-priority-boost thread)
        (macro-thread-priority-boost thread)))))

(define-prim (thread-priority-boost-set! thread priority-boost)
  (macro-force-vars (thread priority-boost)
    (macro-check-thread
     thread
     1
     (thread-priority-boost-set! thread priority-boost)
     (macro-check-real
      priority-boost
      2
      (thread-priority-boost-set! thread priority-boost)
      (let ((b (macro-real->inexact priority-boost)))
        (if (##flnegative? b)
          (##raise-range-exception 2
                                   thread-priority-boost-set!
                                   thread
                                   priority-boost)
          (macro-check-initialized-thread
           thread
           (thread-priority-boost-set! thread priority-boost)
           (##thread-priority-boost-set! thread b))))))))

(define-prim (thread-start! thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-start! thread)
      (macro-check-initialized-thread thread (thread-start! thread)
        (macro-check-not-started-thread-given-initialized
         thread
         (thread-start! thread)
         (##thread-start! thread))))))

(define-prim (thread-yield!)
  (##thread-yield!))

(define-prim (thread-sleep! absrel-timeout)
  (macro-force-vars (absrel-timeout)
    (macro-check-absrel-time
     absrel-timeout
     1
     (thread-sleep! absrel-timeout)
     (##thread-sleep! absrel-timeout))))

(define-prim (thread-suspend! thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-suspend! thread)
      (macro-check-initialized-thread thread (thread-suspend! thread)
        (##thread-suspend! thread)))))

(define-prim (thread-resume! thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-resume! thread)
      (macro-check-initialized-thread thread (thread-resume! thread)
        (##thread-resume! thread)))))

(define-prim (thread-terminate! thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-terminate! thread)
      (macro-check-initialized-thread thread (thread-terminate! thread)
        (##thread-terminate! thread)))))

(define-prim (thread-join!
              thread
              #!optional
              (absrel-timeout (macro-absent-obj))
              (timeout-val (macro-absent-obj)))
  (macro-force-vars (thread absrel-timeout)
    (macro-check-thread
     thread
     1
     (thread-join! thread absrel-timeout timeout-val)
     (if (or (##eq? absrel-timeout (macro-absent-obj))
             (macro-absrel-time-or-false? absrel-timeout))
       (macro-check-initialized-thread
        thread
        (thread-join! thread absrel-timeout timeout-val)
        (##thread-join! thread absrel-timeout timeout-val))
       (##fail-check-absrel-time-or-false
        2
        thread-join!
        thread
        absrel-timeout
        timeout-val)))))

(define-prim (thread-interrupt!
              thread
              #!optional
              (thunk (macro-absent-obj)))
  (macro-force-vars (thread thunk)
    (macro-check-thread thread 1 (thread-interrupt! thread thunk)
      (if (##eq? thunk (macro-absent-obj))
          (##thread-interrupt! thread)
          (macro-check-procedure thunk 2 (thread-interrupt! thread thunk)
            (##thread-interrupt! thread thunk))))))

(define-prim (thread-state thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-state thread)
      (##thread-state thread))))

(define-prim (##thread-state thread)
  (##declare (not interrupts-enabled))
  (cond ((##not (macro-initialized-thread? thread))
         (macro-make-constant-thread-state-uninitialized))
        ((macro-terminated-thread-given-initialized? thread)
         (if (macro-thread-exception? thread)
             (macro-make-thread-state-abnormally-terminated
              (macro-thread-result thread))
             (macro-make-thread-state-normally-terminated
              (macro-thread-result thread))))
        ((##not (macro-started-thread-given-initialized? thread))
         (macro-make-constant-thread-state-initialized))
        (else
         (let* ((btq
                 (macro-thread->btq thread))
                (toq
                 (macro-thread->toq thread))
                (timeout
                 (and toq
                      (let* ((floats (macro-thread-floats thread))
                             (timeout (macro-timeout floats)))
                        (macro-make-time timeout #f #f #f)))))
           (macro-make-thread-state-active
            (cond ((##eq? btq (macro-run-queue))
                   #f)
                  ((and (macro-condvar? btq)
                        (##io-condvar? btq))
                   (##io-condvar-port btq))
                  (else
                   btq))
            timeout)))))

;;; User accessible primitives for mutexes.

(define-prim (mutex? obj)
  (macro-force-vars (obj)
    (macro-mutex? obj)))

(define-prim (make-mutex #!optional (n (macro-absent-obj)))
  (macro-force-vars (n)
    (let ((name
           (if (##eq? n (macro-absent-obj))
             (##void)
             n)))
      (macro-make-mutex name))))

(define-prim (mutex-name mutex)
  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-name mutex)
      (macro-mutex-name mutex))))

(define-prim (mutex-specific mutex)
  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-specific mutex)
      (macro-mutex-specific mutex))))

(define-prim (mutex-specific-set! mutex obj)
  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-specific-set! mutex obj)
      (begin
        (macro-mutex-specific-set! mutex obj)
        (##void)))))

(define-prim (mutex-state mutex)
  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-state mutex)
      (macro-btq-owner mutex))))

(define-prim (mutex-lock!
              mutex
              #!optional
              (absrel-timeout (macro-absent-obj))
              (thread (macro-absent-obj)))
  (macro-force-vars (mutex absrel-timeout thread)
    (macro-check-mutex mutex 1 (mutex-lock! mutex absrel-timeout thread)
      (cond ((##eq? absrel-timeout (macro-absent-obj))
             (macro-mutex-lock! mutex #f (macro-current-thread)))
            ((##not absrel-timeout)
             (cond ((##eq? thread (macro-absent-obj))
                    (macro-mutex-lock! mutex #f (macro-current-thread)))
                   ((##not thread)
                    (macro-mutex-lock-anonymously! mutex absrel-timeout))
                   (else
                    (macro-check-thread
                     thread
                     1
                     (mutex-lock! mutex absrel-timeout thread)
                     (macro-check-initialized-thread
                      thread
                      (mutex-lock! mutex absrel-timeout thread)
                      (macro-mutex-lock! mutex absrel-timeout thread))))))
            ((macro-absrel-time? absrel-timeout)
             (cond ((##eq? thread (macro-absent-obj))
                    (macro-mutex-lock!
                     mutex
                     absrel-timeout
                     (macro-current-thread)))
                   ((##not thread)
                    (macro-mutex-lock-anonymously!
                     mutex
                     absrel-timeout))
                   (else
                    (macro-check-thread
                     thread
                     3
                     (mutex-lock! mutex absrel-timeout thread)
                     (macro-check-initialized-thread
                      thread
                      (mutex-lock! mutex absrel-timeout thread)
                      (macro-mutex-lock!
                       mutex
                       absrel-timeout
                       thread))))))
            (else
             (##fail-check-absrel-time-or-false
              2
              mutex-lock!
              mutex
              absrel-timeout
              thread))))))

(define-prim (mutex-unlock!
              mutex
              #!optional
              (condvar (macro-absent-obj))
              (absrel-timeout (macro-absent-obj)))
  (macro-force-vars (mutex condvar absrel-timeout)
    (macro-check-mutex
     mutex
     1
     (mutex-unlock! mutex condvar absrel-timeout)
     (if (##eq? condvar (macro-absent-obj))
       (macro-mutex-unlock! mutex)
       (macro-check-condvar
        condvar
        2
        (mutex-unlock! mutex condvar absrel-timeout)
        (cond ((or (##eq? absrel-timeout (macro-absent-obj))
                   (##not absrel-timeout))
               (##mutex-signal-and-condvar-wait! mutex condvar #t))
              ((macro-absrel-time? absrel-timeout)
               (let ((timeout (##absrel-timeout->timeout absrel-timeout)))
                 (##mutex-signal-and-condvar-wait!
                  mutex
                  condvar
                  timeout)))
              (else
               (##fail-check-absrel-time-or-false
                3
                mutex-unlock!
                mutex
                condvar
                absrel-timeout))))))))

;;; User accessible primitives for condition variables

(define-prim (condition-variable? obj)
  (macro-force-vars (obj)
    (macro-condvar? obj)))

(define-prim (make-condition-variable #!optional (n (macro-absent-obj)))
  (macro-force-vars (n)
    (let ((name
           (if (##eq? n (macro-absent-obj))
             (##void)
             n)))
      (macro-make-condvar name))))

(define-prim (condition-variable-name condvar)
  (macro-force-vars (condvar)
    (macro-check-condvar condvar 1 (condition-variable-name condvar)
      (macro-condvar-name condvar))))

(define-prim (condition-variable-specific condvar)
  (macro-force-vars (condvar)
    (macro-check-condvar condvar 1 (condition-variable-specific condvar)
      (macro-condvar-specific condvar))))

(define-prim (condition-variable-specific-set! condvar obj)
  (macro-force-vars (condvar)
    (macro-check-condvar condvar 1 (condition-variable-specific-set! condvar obj)
      (begin
        (macro-condvar-specific-set! condvar obj)
        (##void)))))

(define-prim (condition-variable-signal! condvar)
  (macro-force-vars (condvar)
    (macro-check-condvar condvar 1 (condition-variable-signal! condvar)
      (##condvar-signal! condvar #f))))

(define-prim (condition-variable-broadcast! condvar)
  (macro-force-vars (condvar)
    (macro-check-condvar condvar 1 (condition-variable-broadcast! condvar)
      (##condvar-signal! condvar #t))))

;;; User accessible primitives for thread groups.

(define-prim (thread-group? obj)
  (macro-force-vars (obj)
    (macro-tgroup? obj)))

(define-prim (make-thread-group
              #!optional
              (n (macro-absent-obj))
              (p (macro-absent-obj)))
  (macro-force-vars (n p)
    (let ((name
           (if (##eq? n (macro-absent-obj))
             (##void)
             n)))
      (cond ((##eq? p (macro-absent-obj))
             (##make-tgroup
              name
              (macro-thread-tgroup (macro-current-thread))))
            (p
             (macro-check-tgroup p 2 (make-thread-group n p)
               (##make-tgroup name p)))
            (else
             (##make-tgroup name #f))))))

(define-prim (thread-group-name tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-name tgroup)
      (macro-tgroup-name tgroup))))

(define-prim (thread-group-parent tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-parent tgroup)
      (macro-tgroup-parent tgroup))))

(define-prim (thread-group-suspend! tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-suspend! tgroup)
      (##tgroup-suspend! tgroup))))

(define-prim (thread-group-resume! tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-resume! tgroup)
      (##tgroup-resume! tgroup))))

(define-prim (thread-group-terminate! tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-terminate! tgroup)
      (##tgroup-terminate! tgroup))))

(define-prim (thread-group->thread-group-vector tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group->thread-group-vector tgroup)
      (##tgroup->tgroup-vector tgroup))))

(define-prim (thread-group->thread-group-list tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group->thread-group-list tgroup)
      (##tgroup->tgroup-list tgroup))))

(define-prim (thread-group->thread-vector tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group->thread-vector tgroup)
      (##tgroup->thread-vector tgroup))))

(define-prim (thread-group->thread-list tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group->thread-list tgroup)
      (##tgroup->thread-list tgroup))))

;;;----------------------------------------------------------------------------

;;; User accessible primitives for exception handling.

(define-prim (with-exception-handler handler thunk)
  (macro-force-vars (handler thunk)
    (macro-check-procedure handler 1 (with-exception-handler handler thunk)
      (macro-check-procedure thunk 2 (with-exception-handler handler thunk)
        (macro-dynamic-bind exception-handler
         handler
         thunk)))))

(define-prim (##with-exception-catcher catcher thunk)
  (##continuation-capture
   (lambda (cont)
     (macro-dynamic-bind exception-handler
      (lambda (exc)
        (##continuation-graft cont catcher exc))
      thunk))))

(define-prim (with-exception-catcher catcher thunk)
  (macro-force-vars (catcher thunk)
    (macro-check-procedure catcher 1 (with-exception-catcher catcher thunk)
      (macro-check-procedure thunk 2 (with-exception-catcher catcher thunk)
        (##with-exception-catcher catcher thunk)))))

(define-prim (##raise obj);;;;;;;;;;;;;;;;;;
  (macro-raise obj))

(define-prim (raise obj)
  (macro-raise obj))

(define-prim (##abort obj);;;;;;;;;;;;;;;;;;;;;;;;;;
  (macro-abort obj))

(define-prim (abort obj)
  (macro-abort obj))

;;;----------------------------------------------------------------------------

(define-prim (##call-with-current-continuation
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)

  (define (reify-continuation cont)
    (lambda (#!optional
             (val1 (macro-absent-obj))
             (val2 (macro-absent-obj))
             (val3 (macro-absent-obj))
             #!rest
             others)
      (##continuation-return-aux cont val1 val2 val3 others)))

  (cond ((##eq? lift1 (macro-absent-obj))
         (##continuation-capture
          (lambda (cont)
            (receiver (reify-continuation cont)))))
        ((##eq? lift2 (macro-absent-obj))
         (##continuation-capture
          (lambda (cont lift1)
            (receiver (reify-continuation cont) lift1))
          lift1))
        ((##eq? lift3 (macro-absent-obj))
         (##continuation-capture
          (lambda (cont lift1 lift2)
            (receiver (reify-continuation cont) lift1 lift2))
          lift1
          lift2))
        ((##null? others)
         (##continuation-capture
          (lambda (cont lift1 lift2 lift3)
            (receiver (reify-continuation cont) lift1 lift2 lift3))
          lift1
          lift2
          lift3))
        (else
         (let ((lifts
                (##cons lift1
                        (##cons lift2
                                (##cons lift3
                                        others)))))
           (##continuation-capture
            (lambda (cont)
              (##apply
               receiver
               (##cons (reify-continuation cont) lifts))))))))

(define-prim (call-with-current-continuation
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)
  (macro-force-vars (receiver)
    (macro-check-procedure
     receiver
     1
     (call-with-current-continuation receiver lift1 lift2 lift3 . others)
     (cond ((##eq? lift1 (macro-absent-obj))
            (##call-with-current-continuation receiver))
           ((##eq? lift2 (macro-absent-obj))
            (##call-with-current-continuation receiver lift1))
           ((##eq? lift3 (macro-absent-obj))
            (##call-with-current-continuation receiver lift1 lift2))
           ((##null? others)
            (##call-with-current-continuation receiver lift1 lift2 lift3))
           (else
            (##apply
             ##call-with-current-continuation
             (##cons receiver
                     (##cons lift1
                             (##cons lift2
                                     (##cons lift3
                                             others))))))))))

(define call/cc
  call-with-current-continuation)

(define ##initial-dynwind
  '#(0)) ;; only the "level" field is needed

(define-prim (##values
              #!optional
              (val1 (macro-absent-obj))
              (val2 (macro-absent-obj))
              (val3 (macro-absent-obj))
              #!rest
              others)
  (cond ((##eq? val2 (macro-absent-obj))
         (if (##eq? val1 (macro-absent-obj))
           (##values)
           val1))
        ((##eq? val3 (macro-absent-obj))
         (##values val1 val2))
        ((##null? others)
         (##values val1 val2 val3))
        (else
         (##subtype-set!
          (##list->vector (##cons val1 (##cons val2 (##cons val3 others))))
          (macro-subtype-boxvalues)))))

(define-prim (values
              #!optional
              (val1 (macro-absent-obj))
              (val2 (macro-absent-obj))
              (val3 (macro-absent-obj))
              #!rest
              others)
  (cond ((##eq? val2 (macro-absent-obj))
         (if (##eq? val1 (macro-absent-obj))
           (##values)
           val1))
        ((##eq? val3 (macro-absent-obj))
         (##values val1 val2))
        ((##null? others)
         (##values val1 val2 val3))
        (else
         (##subtype-set!
          (##list->vector (##cons val1 (##cons val2 (##cons val3 others))))
          (macro-subtype-boxvalues)))))

(define-prim (##call-with-values producer consumer)
  (let ((results ;; may get bound to a multiple-values object
         (producer)))
    (if (##not (##values? results))
      (consumer results)
      (let ((len (##vector-length results)))
        (cond ((##fx= len 2)
               (consumer (##vector-ref results 0)
                         (##vector-ref results 1)))
              ((##fx= len 3)
               (consumer (##vector-ref results 0)
                         (##vector-ref results 1)
                         (##vector-ref results 2)))
              ((##fx= len 0)
               (consumer))
              (else
               (##apply consumer (##vector->list results))))))))

(define-prim (call-with-values producer consumer)
  (macro-force-vars (producer consumer)
    (macro-check-procedure producer 1 (call-with-values producer consumer)
      (macro-check-procedure consumer 2 (call-with-values producer consumer)
        (##call-with-values producer consumer)))))

(define-prim (##dynamic-wind before thunk after)
  (##continuation-capture
   (lambda (cont)
     (before)
     (let* ((dynwind
             (macro-denv-dynwind
              (macro-thread-denv (macro-current-thread))))
            (new-dynwind
             (macro-make-dynwind
              (##fx+ (macro-dynwind-level dynwind) 1)
              before
              after
              cont))
            (results ;; may get bound to a multiple-values object
             (macro-dynamic-bind dynwind
              new-dynwind
              thunk)))
       (after)
       results))))

(define-prim (dynamic-wind before thunk after)
  (macro-force-vars (before thunk after)
    (macro-check-procedure before 1 (dynamic-wind before thunk after)
      (macro-check-procedure thunk 2 (dynamic-wind before thunk after)
        (macro-check-procedure after 3 (dynamic-wind before thunk after)
          (##dynamic-wind before thunk after))))))

(define-prim (##procedure->continuation proc)
  (##declare (not interrupts-enabled))
  (##closure-ref proc 1))

(define-prim ##thread-save!
  (##first-argument
   (lambda (proc #!rest args)
     (##declare (not interrupts-enabled))
     (##thread-save! (lambda (thread) (##apply proc (##cons thread args)))))))

(define-prim ##thread-restore!
  (##first-argument
   (lambda (thread proc #!rest args)
     (##declare (not interrupts-enabled))
     (##thread-restore! thread (lambda () (##apply proc args))))))

(define-prim (continuation? obj)
  (##continuation? obj))

(define-prim (##continuation-capture-aux receiver lift1 lift2 lift3 others)
  (##declare (not interrupts-enabled))
  (cond ((##eq? lift1 (macro-absent-obj))
         (##continuation-capture receiver))
        ((##eq? lift2 (macro-absent-obj))
         (##continuation-capture receiver lift1))
        ((##eq? lift3 (macro-absent-obj))
         (##continuation-capture receiver lift1 lift2))
        ((##null? others)
         (##continuation-capture receiver lift1 lift2 lift3))
        (else
         (let ((lifts
                (##cons lift1
                        (##cons lift2
                                (##cons lift3
                                        others)))))
           (##continuation-capture
            (lambda (cont)
              (##apply receiver (##cons cont lifts))))))))

(define-prim (##continuation-capture
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)
  (##continuation-capture-aux receiver lift1 lift2 lift3 others))

(define-prim (continuation-capture
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)
  (macro-check-procedure receiver 1 (continuation-capture receiver lift1 lift2 lift3 . others)
    (##continuation-capture-aux receiver lift1 lift2 lift3 others)))

(define-prim ##continuation-graft-no-winding
  (##first-argument
   (lambda (cont
            proc
            #!optional
            (arg1 (macro-absent-obj))
            (arg2 (macro-absent-obj))
            (arg3 (macro-absent-obj))
            #!rest
            others)
     (##declare (not interrupts-enabled))
     (cond ((##eq? arg1 (macro-absent-obj))
            (##continuation-graft-no-winding cont proc))
           ((##eq? arg2 (macro-absent-obj))
            (##continuation-graft-no-winding cont proc arg1))
           ((##eq? arg3 (macro-absent-obj))
            (##continuation-graft-no-winding cont proc arg1 arg2))
           ((##null? others)
            (##continuation-graft-no-winding cont proc arg1 arg2 arg3))
           (else
            (let ((args
                   (##cons arg1
                           (##cons arg2
                                   (##cons arg3
                                           others)))))
              (##continuation-graft-no-winding cont ##apply proc args)))))))

(define-prim ##continuation-return-no-winding
  (##first-argument
   (lambda (cont results)
     (##declare (not interrupts-enabled))
     (##continuation-return-no-winding cont results))))

(define-prim (##continuation-unwind-wind src dst continue)

  (define (unwind-src src dst continue) ;; src level > dst level
    (##continuation-graft-no-winding
     (macro-dynwind-cont src)
     (lambda ()
       ((macro-dynwind-after src))
       (let ((new-src
              (macro-denv-dynwind
               (macro-continuation-denv (macro-dynwind-cont src)))))
         (cond ((##fx< (macro-dynwind-level dst)
                       (macro-dynwind-level new-src))
                (unwind-src new-src dst continue))
               ((and (##not (##eq? new-src dst))
                     (##fx< 0 (macro-dynwind-level new-src)))
                (unwind-src-wind-dst new-src dst continue))
               (else
                (continue)))))))

  (define (wind-dst src dst continue) ;; src level < dst level
    (let* ((new-dst
            (macro-denv-dynwind
             (macro-continuation-denv (macro-dynwind-cont dst))))
           (new-continue
            (lambda ()
              (##continuation-graft-no-winding
               (macro-dynwind-cont dst)
               (lambda ()
                 ((macro-dynwind-before dst))
                 (continue))))))
      (cond ((##fx< (macro-dynwind-level src)
                    (macro-dynwind-level new-dst))
             (wind-dst src new-dst new-continue))
            ((and (##not (##eq? src new-dst))
                  (##fx< 0 (macro-dynwind-level new-dst)))
             (unwind-src-wind-dst src new-dst new-continue))
            (else
             (new-continue)))))

  (define (unwind-src-wind-dst src dst continue) ;; src level = dst level
    (##continuation-graft-no-winding
     (macro-dynwind-cont src)
     (lambda ()
       ((macro-dynwind-after src))
       (let* ((new-src
               (macro-denv-dynwind
                (macro-continuation-denv (macro-dynwind-cont src))))
              (new-dst
               (macro-denv-dynwind
                (macro-continuation-denv (macro-dynwind-cont dst))))
              (new-continue
               (lambda ()
                 (##continuation-graft-no-winding
                  (macro-dynwind-cont dst)
                  (lambda ()
                    ((macro-dynwind-before dst))
                    (continue))))))
         (if (and (##not (##eq? new-src new-dst))
                  (##not (##fx= (macro-dynwind-level new-src) 0)))
           (unwind-src-wind-dst
            new-src
            new-dst
            (lambda () (new-continue)))
           (new-continue))))))

  (let ((src-level
         (macro-dynwind-level src))
        (dst-level
         (macro-dynwind-level dst)))
    (cond ((##fx< dst-level src-level)
           (unwind-src src dst continue))
          ((##fx< src-level dst-level)
           (wind-dst src dst continue))
          (else
           (unwind-src-wind-dst src dst continue)))))

(define-prim (##continuation-graft-aux cont proc arg1 arg2 arg3 others)

  (##declare (not interrupts-enabled))

  (define (continue)
    (cond ((##eq? arg1 (macro-absent-obj))
           (##continuation-graft-no-winding cont proc))
          ((##eq? arg2 (macro-absent-obj))
           (##continuation-graft-no-winding cont proc arg1))
          ((##eq? arg3 (macro-absent-obj))
           (##continuation-graft-no-winding cont proc arg1 arg2))
          ((##null? others)
           (##continuation-graft-no-winding cont proc arg1 arg2 arg3))
          (else
           (let ((args
                  (##cons arg1
                          (##cons arg2
                                  (##cons arg3
                                          others)))))
             (##continuation-graft-no-winding cont ##apply proc args)))))

  (let* ((src
          (macro-denv-dynwind
           (macro-thread-denv (macro-current-thread))))
         (dst
          (macro-denv-dynwind
           (macro-continuation-denv cont))))
    (if (or (##eq? src dst) ;; check common case (same dynamic-wind context)
            (and (##fx= (macro-dynwind-level src) 0)
                 (##fx= (macro-dynwind-level dst) 0)))
        (continue)
        (##continuation-unwind-wind src dst (lambda () (continue))))))

(define-prim (##continuation-graft
              cont
              proc
              #!optional
              (arg1 (macro-absent-obj))
              (arg2 (macro-absent-obj))
              (arg3 (macro-absent-obj))
              #!rest
              others)
  (##continuation-graft-aux cont proc arg1 arg2 arg3 others))

(define-prim (continuation-graft
              cont
              proc
              #!optional
              (arg1 (macro-absent-obj))
              (arg2 (macro-absent-obj))
              (arg3 (macro-absent-obj))
              #!rest
              others)
  (macro-check-continuation cont 1 (continuation-graft cont proc arg1 arg2 arg3 . others)
    (macro-check-procedure proc 2 (continuation-graft cont proc arg1 arg2 arg3 . others)
      (##continuation-graft-aux cont proc arg1 arg2 arg3 others))))

(define-prim (##continuation-return-aux cont val1 val2 val3 others)

  (##declare (not interrupts-enabled))

  (define (continue)
    (##continuation-return-no-winding
     cont
     (cond ((##eq? val1 (macro-absent-obj))
            (##values))
           ((##eq? val2 (macro-absent-obj))
            val1)
           ((##eq? val3 (macro-absent-obj))
            (##values val1 val2))
           ((##null? others)
            (##values val1 val2 val3))
           (else
            (##subtype-set!
             (##list->vector
              (##cons val1
                      (##cons val2
                              (##cons val3
                                      others))))
             (macro-subtype-boxvalues))))))

  (let* ((src
          (macro-denv-dynwind
           (macro-thread-denv (macro-current-thread))))
         (dst
          (macro-denv-dynwind
           (macro-continuation-denv cont))))
    (if (or (##eq? src dst) ;; check common case (same dynamic-wind context)
            (and (##fx= (macro-dynwind-level src) 0)
                 (##fx= (macro-dynwind-level dst) 0)))
        (continue)
        (##continuation-unwind-wind src dst (lambda () (continue))))))

(define-prim (##continuation-return
              cont
              #!optional
              (val1 (macro-absent-obj))
              (val2 (macro-absent-obj))
              (val3 (macro-absent-obj))
              #!rest
              others)
  (##continuation-return-aux cont val1 val2 val3 others))

(define-prim (continuation-return
              cont
              #!optional
              (val1 (macro-absent-obj))
              (val2 (macro-absent-obj))
              (val3 (macro-absent-obj))
              #!rest
              others)
  (macro-check-continuation cont 1 (continuation-return cont val1 val2 val3 . others)
    (##continuation-return-aux cont val1 val2 val3 others)))

;;;----------------------------------------------------------------------------

(define-prim (apply proc arg1 . other-args)

  (define (build-arg-list i arg other-args)

    (define (copy-proper-list lst)
      (macro-force-vars (lst)
        (if (##pair? lst)
          (let ((tail (copy-proper-list (##cdr lst))))
            (macro-if-checks
              (if (##fixnum? tail)
                tail
                (##cons (##car lst) tail))
              (##cons (##car lst) tail)))
          (macro-if-checks
            (if (##null? lst)
              '()
              i) ;; error: list expected
            '()))))

    (define (check-proper-list lst)
      (macro-if-checks
        ;; This procedure may get into an infinite loop if another thread
        ;; mutates "lst" (if lst1 and lst2 each point to disconnected cycles).
        (let loop ((lst1 lst) (lst2 lst))
          (macro-force-vars (lst1)
            (if (##not (##pair? lst1))
                (if (##null? lst1)
                    lst
                    i)
                (let ((lst1 (##cdr lst1)))
                  (macro-force-vars (lst1 lst2)
                    (cond ((##eq? lst1 lst2)
                           i)
                          ((##not (##pair? lst2))
                          ;; this case is possible if other threads mutate the list
                          (if (##null? lst2)
                              lst
                              i))
                          ((##pair? lst1)
                           (loop (##cdr lst1) (##cdr lst2)))
                          (else
                           (if (##null? lst1)
                               lst
                               i))))))))
        lst))

    (if (##pair? other-args)
      (let ((tail
             (build-arg-list (##fx+ i 1)
                             (##car other-args)
                             (##cdr other-args))))
        (macro-if-checks
          (if (##fixnum? tail)
            tail
            (##cons arg tail))
          (##cons arg tail)))
      (macro-if-forces
        (copy-proper-list arg)
        (check-proper-list arg))))

  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (apply proc arg1 . other-args)
      (let ((lst (build-arg-list 2 arg1 other-args)))
        (macro-if-checks
          (if (##fixnum? lst)
            (macro-fail-check-list lst (apply proc arg1 . other-args))
            (##apply proc lst))
          (##apply proc lst))))))

;;;----------------------------------------------------------------------------

;;; Implementation of TCP service register.

(define ##tcp-service-table (##make-table))
(define ##tcp-service-mutex (macro-make-mutex 'tcp-service))
(define ##tcp-service-tgroup (macro-make-tgroup 'tcp-service #f))

(define-prim (##tcp-service-serve server-port thunk tgroup)
  (let loop ()
    (let ((connection-port (##read server-port)))
      (if (##port? connection-port)
          (let ((t
                 (##make-root-thread
                  (lambda ()
                    (thunk)
                    (##close-output-port connection-port)
                    (##read-u8 connection-port) ;; wait for client to close
                    (##close-port connection-port))
                  connection-port ;; name of the thread
                  tgroup
                  connection-port
                  connection-port)))
            (##thread-start! t)
            (loop))
          (##close-port server-port)))))

(define-prim (##tcp-service-update! server-address-and-port-number new-value)
  (macro-mutex-lock! ##tcp-service-mutex #f (macro-current-thread))
  (let ((old-value
         (##table-ref ##tcp-service-table
                      server-address-and-port-number
                      #f)))
    (if old-value
        (let ((server-port (##car old-value))
              (thread (##cdr old-value)))
          (##close-port server-port)
          (##thread-terminate! thread)))
    (if new-value
        (##table-set! ##tcp-service-table
                      server-address-and-port-number
                      new-value)
        (##table-set! ##tcp-service-table
                      server-address-and-port-number))
    (macro-mutex-unlock! ##tcp-service-mutex)))

(define-prim (##tcp-service-register! port-number-or-address-or-settings thunk tg tgroup)
  (##process-tcp-server-psettings
   #t
   (lambda (psettings-and-server-address)
     (let* ((psettings
             (##car psettings-and-server-address))
            (server-address
             (##cdr psettings-and-server-address))
            (port-number
             (macro-psettings-port-number psettings))
            (server-address-and-port-number
             (##cons server-address port-number)))
       (##tcp-service-update! server-address-and-port-number
                              #f)
       (##open-tcp-server-aux
        #t
        psettings-and-server-address
        (lambda (server-port)
          (let ((new-thread
                 (##make-root-thread
                  (lambda () (##tcp-service-serve server-port thunk tgroup))
                  server-address-and-port-number
                  ##tcp-service-tgroup
                  ##stdin-port
                  ##stdout-port)))
            (##tcp-service-update! server-address-and-port-number
                                   (##cons server-port new-thread))
            (##thread-start! new-thread)
            (##void)))
        tcp-service-register!
        port-number-or-address-or-settings
        thunk
        tg
        (macro-absent-obj))))
   tcp-service-register!
   port-number-or-address-or-settings
   thunk
   tg
   (macro-absent-obj)))

(define-prim (tcp-service-register!
              port-number-or-address-or-settings
              thunk
              #!optional
              (tg (macro-absent-obj)))
  (macro-force-vars (port-number-or-address-or-settings thunk tg)
    (let ((tgroup
           (if (##eq? tg (macro-absent-obj))
               (macro-thread-tgroup (macro-current-thread))
               tg)))
      (macro-check-procedure
       thunk
       2
       (tcp-service-register! port-number-or-address-or-settings thunk tg)
       (macro-check-tgroup
        tgroup
        3
        (tcp-service-register! port-number-or-address-or-settings thunk tg)
        (##tcp-service-register! port-number-or-address-or-settings thunk tg tgroup))))))

(define-prim (##tcp-service-unregister! port-number-or-address-or-settings)
  (##process-tcp-server-psettings
   #t
   (lambda (psettings-and-server-address)
     (let* ((psettings
             (##car psettings-and-server-address))
            (server-address
             (##cdr psettings-and-server-address))
            (port-number
             (macro-psettings-port-number psettings))
            (server-address-and-port-number
             (##cons server-address port-number)))
       (##tcp-service-update! server-address-and-port-number #f)
       (##void)))
   tcp-service-unregister!
   port-number-or-address-or-settings
   (macro-absent-obj)
   (macro-absent-obj)
   (macro-absent-obj)))

(define-prim (tcp-service-unregister!
              port-number-or-address-or-settings)
  (macro-force-vars (port-number-or-address-or-settings)
    (##tcp-service-unregister! port-number-or-address-or-settings)))

;;;----------------------------------------------------------------------------

;; (##current-user-interrupt-handler) is called on each user interrupt.

(define ##deferred-user-interrupt? #f)

(define-prim (##defer-user-interrupts)
   (##declare (not interrupts-enabled))
   (set! ##deferred-user-interrupt? #t)
   (##void))
     
(define defer-user-interrupts ##defer-user-interrupts)
     
(define ##current-user-interrupt-handler
  (##make-parameter
   ##defer-user-interrupts
   (lambda (val)
     (macro-check-procedure val 1 (##current-user-interrupt-handler val)
       (let ()
         (##declare (not interrupts-enabled))
         (##declare (not safe)) ;; avoid procedure check on the call
         (let ((int? ##deferred-user-interrupt?))
           (set! ##deferred-user-interrupt? #f)
           (if int?
               (val)))
         val)))))

(define current-user-interrupt-handler
  ##current-user-interrupt-handler)

(define-prim (##user-interrupt!)
  (##declare (not interrupts-enabled))
  (let ((handler (##current-user-interrupt-handler)))
    (if (##procedure? handler)
        (let ()
          (##declare (not safe)) ;; avoid procedure check on the call
          (handler)))))

(##interrupt-vector-set! 0 ##user-interrupt!)

(##thread-startup!)

(##thread-heartbeat-interval-set! (macro-default-heartbeat-interval))

;;;============================================================================
;;(##include "termite/termite.scm")
