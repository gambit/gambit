;;;============================================================================

;;; File: "_thread.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(cond-expand (enable-smp

;;;============================================================================

;;; SMP thread scheduler.

;;; Special synchronization considerations for multithreaded VMs.
;;;
;;; In a multithreaded VM, multiple processors are executing code
;;; simultaneously.  It is necessary to coordinate the actions of the
;;; processors to prevent simultaneous modifications to shared state
;;; that could lead to corrupt data structures. For this reason, so
;;; called low-level locks are added to various data types: VM,
;;; processor, thread, mutex and condition variables. Acquiring a
;;; low-level lock is done with a busy wait, so low-level locks must
;;; be held for a very short duration.
;;;
;;; Some operations require that more than one low-level lock be
;;; acquired to perform the operation.  To avoid deadlocks, it is
;;; necessary for all processors to acquire the set of low-level locks
;;; they need in the same order.  This avoids cross locking of two
;;; locks in opposite orders (i.e. processor 1 acquiring L1 then L2,
;;; and processor 2 acquiring L2 then L1).
;;;
;;; To avoid this cross locking, when the locks are on objects of the
;;; same type, a total order of the objects is used to order the lock
;;; acquisitions (e.g. by sorting according to the memory address).
;;; When the locks are on objects of different types, the order
;;; is:
;;;
;;;   mutex -> condition variable -> thread -> thread group -> processor -> VM
;;;
;;; In some situations the ordering of acquisitions is hard to achieve
;;; because the set of objects to lock isn't known when the operation
;;; is started.  The solution is to use non-blocking acquisition of
;;; the locks (using a trylock) and some looping to retry the
;;; operation.

;;;----------------------------------------------------------------------------

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
(implement-check-type-vm)
(implement-check-type-processor)
(implement-check-type-thread)
(implement-check-type-mutex)
(implement-check-type-condvar)
(implement-check-type-tgroup)

;;;----------------------------------------------------------------------------

(implement-type-vm)
(implement-type-processor)
(implement-type-thread)
(implement-type-mutex)
(implement-type-condvar)
(implement-type-tgroups)
(implement-type-tgroup)

(implement-library-type-thread-state-uninitialized)
(implement-library-type-thread-state-initialized)
(implement-library-type-thread-state-normally-terminated)
(implement-library-type-thread-state-abnormally-terminated)
(implement-library-type-thread-state-waiting)
(implement-library-type-thread-state-running)

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

(define ##initial-current-directory-saved
  (let ((current-dir
         (##os-path-normalize-directory #f)))
    (if (##fixnum? current-dir)
        (##exit-with-err-code current-dir)
        current-dir)))

(define-prim (##current-directory-set-filter val)
  (if (##eq? val (macro-absent-obj))
      ##initial-current-directory-saved
      (macro-check-string val 1 (##current-directory val)
        (##path-normalize-directory-existing val))))

(define ##initial-current-directory
  (##make-parameter
   (macro-absent-obj)
   ##current-directory-set-filter))

(define initial-current-directory
  ##initial-current-directory)

(define-prim (##path-normalize-directory-existing path)
  (let ((normalized-dir
         (##os-path-normalize-directory (##path-expand path))))
    (if (##fixnum? normalized-dir)
        (##raise-os-exception #f normalized-dir ##current-directory path)
        normalized-dir)))

(define ##current-directory
  (##make-parameter
   (macro-absent-obj)
   ##current-directory-set-filter))

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

(define-prim (##parameterize1 param val thunk)
  (##declare (not interrupts-enabled))
  (macro-check-procedure param 1 (##parameterize1 param val thunk)
    (macro-check-procedure thunk 3 (##parameterize1 param val thunk)
      (if (##parameter? param)
        (##dynamic-let
         param
         (let ((descr (macro-parameter-descr param)))
           ((macro-parameter-descr-set-filter descr) val))
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
                         (let ((descr (macro-parameter-descr param)))
                           (macro-parameter-descr-value descr)))))))))))))

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
                         (let ((descr (macro-parameter-descr param)))
                           (macro-parameter-descr-value-set! descr val)
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

;; This procedure which mutates the dynamic environment is not
;; currently used and its usefullness in a multithreaded system is
;; doubtful.

#;
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
                 (macro-thread-floats (macro-current-processor))))
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
                          (macro-thread-floats (macro-current-processor)))))
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
                   (macro-thread-floats (macro-current-processor)))))
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

;;; Implementation of blocked thread queues and timeout queues.

(implement-btq) ;; defines ##btq-insert!, etc
(implement-toq) ;; defines ##toq-insert!, etc

;;;----------------------------------------------------------------------------

;;; Inlined thread primitives.

(define-prim (##current-thread))
(define-prim (##current-processor))
(define-prim (##current-processor-id))
(define-prim (##processor id))
(define-prim (##current-vm))

(define-prim (##primitive-lock! btq i j))
(define-prim (##primitive-trylock! btq i j))
(define-prim (##primitive-unlock! btq i j))

(define-prim (##object-before? x y))

;;;----------------------------------------------------------------------------

;;; Operations on processor run queues.

(##define-macro (macro-add-thread-to-run-queue-of-current-processor-without-locking! thread)
  `(##btq-insert! (macro-current-processor) ,thread))

(##define-macro (macro-add-thread-to-run-queue-of-current-processor! thread)
  `(let ((thread ,thread))
     (macro-lock-current-processor!)
     (macro-add-thread-to-run-queue-of-current-processor-without-locking! thread)
     (macro-unlock-current-processor!)))

(define-prim (##add-thread-to-run-queue-of-current-processor-preferably-out-of-line! thread)

  (##declare (not interrupts-enabled))

  (let ((pinned (macro-thread-pinned thread)))
    (if pinned
        (begin
          ;; the thread is pinned to a processor, so add it to that run queue
          (let ((processor pinned))
            (macro-lock-processor! processor)
            (##btq-insert! processor thread)
            (macro-unlock-processor! processor)
            (##wait-abort! processor)))
        (begin
          ;; the thread is not pinned, so add it to the current processor
          (macro-add-thread-to-run-queue-of-current-processor! thread)))))

(##define-macro (macro-add-thread-to-run-queue-of-current-processor-preferably! thread)
  `(##add-thread-to-run-queue-of-current-processor-preferably-out-of-line! ,thread))

(define-prim (##add-thread-to-run-queue-of-some-processor-out-of-line! thread)

  (##declare (not interrupts-enabled))

  (define (add-to-current-processor!)
    (macro-add-thread-to-run-queue-of-current-processor! thread))

  (let ((pinned (macro-thread-pinned thread)))
    (if pinned
        (begin
          ;; the thread is pinned to a processor, so add it to that run queue
          (let ((processor pinned))
            (macro-lock-processor! processor)
            (##btq-insert! processor thread)
            (macro-unlock-processor! processor)
            (##wait-abort! processor)))
        (if (##not (macro-trylock-current-vm!))
            (add-to-current-processor!)
            (let ((processor (macro-processor-deq-head (macro-current-vm))))
              (if (##eq? processor (macro-current-vm))
                  (begin
                    ;; no processor is currently idle
                    (macro-unlock-current-vm!)
                    (add-to-current-processor!))
                  (begin
                    ;; a processor that is currently idle was found
                    (macro-processor-deq-remove! processor)
                    (macro-unlock-current-vm!)
                    (macro-lock-processor! processor)
                    (##btq-insert! processor thread)
                    (macro-unlock-processor! processor)
                    (##wait-abort-no-remove! processor))))))))

(##define-macro (macro-add-thread-to-run-queue-of-some-processor! thread)
  `(##add-thread-to-run-queue-of-some-processor-out-of-line! ,thread))

;;;----------------------------------------------------------------------------

;; The procedure ##thread-lock-remove-btq-toq! acquires the low-level
;; lock of a thread and also removes the thread from any blocked
;; thread queue (processor run queue, mutex or condition variable) and
;; timeout queue containing the thread.

(define-prim (##thread-lock-remove-btq-toq! thread proc arg1)

  (##declare (not interrupts-enabled))

  (let try-again ()

    (define (continue)

      ;; Remove thread from any timeout queue.

      (let ((toq (macro-thread-toq-container thread)))
        (if toq
            (begin
              (macro-lock-toq! toq)
              (##toq-remove! thread) ;; remove thread from toq
              (macro-unlock-toq! toq))))

      (proc arg1))

    ;; acquire low-level lock of thread
    (macro-lock-thread! thread)

    ;; Remove thread from any blocked thread queue (run queue, mutex or
    ;; condition variable).

    (let ((btq (macro-thread-btq-container thread)))
      (if (##not btq)

          (continue)

          (if (macro-processor? btq)

              (begin

                ;; The blocked thread queue is the run queue of a processor.

                (macro-lock-processor! btq)
                (##btq-remove! thread) ;; remove thread from btq
                (macro-unlock-processor! btq)

                (continue))

              (begin

                ;; The blocked thread queue is a mutex or condition variable.

                ;; To prevent cross-locking, the mutex or condition
                ;; variable must be acquired using a trylock.

                (if (##not (macro-trylock-btq! btq))

                    (begin

                      ;; release low-level lock of thread
                      (macro-unlock-thread! thread)

                      (try-again))

                    (begin

                      (##btq-remove! thread) ;; remove thread from btq

                      ;; release low-level lock of mutex or condition variable
                      (macro-unlock-btq! btq)

                      (continue)))))))))

;;;----------------------------------------------------------------------------

;;; Utilities for locking multiple threads.

;;; The procedures ##lock-2-threads! and ##lock-3-threads! acquire
;;; the low-level locks of 2 or 3 threads (with possible duplicates)
;;; in an ordered way to avoid cross locking. The procedures
;;; ##unlock-2-threads! and ##unlock-3-threads! release the low-level
;;; locks of 2 or 3 threads.

(define-prim (##lock-2-threads! thread1 thread2)

  (##declare (not interrupts-enabled))

  ;; This procedure acquires the low-level locks of thread1 and
  ;; thread2, that must be threads.  It is permitted for the
  ;; parameters to refer to the same thread. The implementation orders
  ;; the lock acquisitions to prevent cross locking.

  (define (ordered-locking t1 t2)
    (macro-lock-thread! t1)
    (if (##not (##eq? t1 t2)) (macro-lock-thread! t2)))

  (if (##object-before? thread1 thread2)
      (ordered-locking thread1 thread2)
      (ordered-locking thread2 thread1)))

(define-prim (##unlock-2-threads! thread1 thread2)

  (##declare (not interrupts-enabled))

  ;; This procedure releases the low-level locks of thread1 and
  ;; thread2, that must be threads.  It is permitted for the
  ;; parameters to refer to the same thread.

  (macro-unlock-thread! thread1)
  (if (##not (##eq? thread1 thread2)) (macro-unlock-thread! thread2)))

(define-prim (##lock-3-threads! thread1 thread2 thread3)

  (##declare (not interrupts-enabled))

  ;; This procedure acquires the low-level locks of thread1, thread2
  ;; and thread3, that can be threads or #f.  It is permitted for any
  ;; pair of parameters to refer to the same thread. The
  ;; implementation orders the lock acquisitions to prevent cross
  ;; locking, and also checks for a thread appearing more than once.

  (define (ordered-locking t1 t2 t3)
    (if t1 (macro-lock-thread! t1))
    (if (and t2 (##not (##eq? t1 t2))) (macro-lock-thread! t2))
    (if (and t3 (##not (##eq? t2 t3))) (macro-lock-thread! t3)))

  (if (##object-before? thread1 thread2)
      (if (##object-before? thread2 thread3)
          (ordered-locking thread1 thread2 thread3)
          (if (##object-before? thread1 thread3)
              (ordered-locking thread1 thread3 thread2)
              (ordered-locking thread3 thread1 thread2)))
      (if (##object-before? thread1 thread3)
          (ordered-locking thread2 thread1 thread3)
          (if (##object-before? thread2 thread3)
              (ordered-locking thread2 thread3 thread1)
              (ordered-locking thread3 thread2 thread1)))))

(define-prim (##unlock-3-threads! thread1 thread2 thread3)

  (##declare (not interrupts-enabled))

  ;; This procedure releases the low-level locks of thread1, thread2
  ;; and thread3, that can be threads or #f.  It is permitted for any
  ;; pair of parameters to refer to the same thread. The
  ;; implementation checks for a thread appearing more than once.

  (if thread1
      (macro-unlock-thread! thread1))

  (if (and thread2
           (##not (##eq? thread1 thread2)))
      (macro-unlock-thread! thread2))

  (if (and thread3
           (##not (##eq? thread1 thread3))
           (##not (##eq? thread2 thread3)))
      (macro-unlock-thread! thread3)))

;;;----------------------------------------------------------------------------

;; The procedure current-processor returns the processor executing the
;; current thread.

(define-prim (current-processor)

  (##declare (not interrupts-enabled))

  (macro-current-processor))

;;;----------------------------------------------------------------------------

;; The procedure processor? returns #t when the parameter is a processor
;; and #f otherwise.

(define-prim (processor? obj)

  (##declare (not interrupts-enabled))

  (macro-force-vars (obj)
    (macro-processor? obj)))

;;;----------------------------------------------------------------------------

;; The procedure processor? returns #t when the parameter is a processor
;; and #f otherwise.

(define-prim (processor-id processor)

  (##declare (not interrupts-enabled))

  (macro-force-vars (processor)
    (macro-check-processor processor 1 (processor-id processor)
      (macro-processor-id processor))))

;;;----------------------------------------------------------------------------

;; The procedure current-thread returns the thread currently executing
;; on the current processor.

(define-prim (current-thread)

  (##declare (not interrupts-enabled))

  (macro-current-thread))

;;;----------------------------------------------------------------------------

;; The procedure thread? returns #t when the parameter is a thread
;; and #f otherwise.

(define-prim (thread? obj)

  (##declare (not interrupts-enabled))

  (macro-force-vars (obj)
    (macro-thread? obj)))

;;;----------------------------------------------------------------------------

;; The procedure thread creates and returns a started thread
;; (i.e. there's an implicit call to the procedure thread-start!
;; after the thread is created and initialized).

(define-prim (thread thunk)
  (##declare (not interrupts-enabled))
  (macro-force-vars (thunk)
    (macro-check-procedure thunk 1 (thread thunk)
      (##thread thunk))))

(define-prim (##thread thunk)
  (##declare (not interrupts-enabled))
  (##thread-start! (##make-thread thunk)))

;;;----------------------------------------------------------------------------

;; The procedure make-thread creates and returns an initialized
;; thread.  This thread is not automatically made runnable (the
;; procedure thread-start! must be used for this).

(define-prim (make-thread
              thunk
              #!optional
              (n (macro-absent-obj))
              (tg (macro-absent-obj)))

  (##declare (not interrupts-enabled))

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
          (##make-thread thunk name tgroup))))))

(define-prim (##make-thread
              thunk
              #!optional
              (name (##void))
              (tgroup (macro-thread-tgroup (macro-current-thread))))
  (##declare (not interrupts-enabled))
  (macro-make-thread thunk name tgroup))

;; The procedure make-root-thread creates and returns an initialized
;; thread, like the procedure make-thread. However, the created thread
;; does not inherit the dynamic environment from the current thread
;; and the base priority, the priority boost and the quantum are set
;; to specific values rather than being inherited from the parent
;; thread. Similarly, the dynamic environment of the thread is not
;; inherited. It has the global bindings of the parameter objects,
;; except current-input-port and current-output-port (which are
;; specified by the parameters) and current-directory (which is bound
;; to the initial current working directory of the current process).

(define-prim (make-root-thread
              thunk
              #!optional
              (n (macro-absent-obj))
              (tg (macro-absent-obj))
              (ip (macro-absent-obj))
              (op (macro-absent-obj)))

  (##declare (not interrupts-enabled))

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

(define-prim (##make-root-thread
              thunk
              #!optional
              (name (##void))
              (tgroup (macro-thread-tgroup ##primordial-thread))
              (input-port ##stdin-port)
              (output-port ##stdout-port))

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

;;;----------------------------------------------------------------------------

;; The procedure thread-init! initializes an uninitialized thread (so
;; that it is suitable for calling the procedure thread-start! to make
;; it runnable) and returns the thread.

;; Uninitialized threads can be created when using the special form
;; define-type-of-thread, which defines subtypes of the basic thread
;; type.  When the constructor of a thread subtype is called, it
;; creates an uninitialized thread (i.e. it doesn't yet have a thunk
;; to run, a name, and a thread group).
;;
;; For example:

#;
(begin

 (define-type-of-thread mythread
   myfield)

 (define t (make-mythread "hello")) ;; create an uninitialized thread

 (thread-init! ;; initialize the thread
  t
  (lambda () (println (mythread-myfield (current-thread)))))

 (thread-join! (thread-start! t)) ;; prints "hello"
)

(define-prim (thread-init!
              thread
              thunk
              #!optional
              (n (macro-absent-obj))
              (tg (macro-absent-obj)))

  (##declare (not interrupts-enabled))

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
            (begin
              (macro-lock-thread! thread)
              (macro-check-not-initialized-thread
                thread
                (thread-init! thread thunk n tg)
                (begin
                  (macro-thread-init! thread thunk name tgroup)
                  (macro-unlock-thread! thread)
                  thread)))))))))

;;;----------------------------------------------------------------------------

;; The procedure thread-name returns the name of the thread parameter,
;; which must be an initialized thread.

(define-prim (thread-name thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-name thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-name thread)
          (let ((result (macro-thread-name thread)))
            (macro-unlock-thread! thread)
            result))))))

;;;----------------------------------------------------------------------------

;; The procedure thread-thread-group returns the thread-group of the
;; thread parameter, which must be an initialized thread.

(define-prim (thread-thread-group thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-thread-group thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-thread-group thread)
          (let ((result (macro-thread-tgroup thread)))
            (macro-unlock-thread! thread)
            result))))))

;;;----------------------------------------------------------------------------

;; The procedure thread-specific returns the content of the
;; thread's specific field.

(define-prim (thread-specific thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-specific thread)
      (macro-thread-specific thread))))

;; The procedure thread-specific-set! stores a value into the
;; thread's specific field.

(define-prim (thread-specific-set! thread obj)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-specific-set! thread obj)
      (begin
        (macro-thread-specific-set! thread obj)
        (##void)))))

;;;----------------------------------------------------------------------------

;; The procedure thread-interrupt! causes the target thread to either
;; be interrupted in the midst of execution, or, if it was blocked, to
;; wake up temporarily, to execute a thunk.

(define-prim (thread-interrupt!
              thread
              #!optional
              (thunk (macro-absent-obj)))

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread thunk)
    (macro-check-thread thread 1 (thread-interrupt! thread thunk)
      (if (##eq? thunk (macro-absent-obj))
          (##thread-interrupt! thread)
          (macro-check-procedure thunk 2 (thread-interrupt! thread thunk)
            (##thread-interrupt! thread thunk))))))

(define-prim (##thread-interrupt!
              thread
              #!optional
              (act (macro-absent-obj)))

  (##declare (not interrupts-enabled))

  (let ((action
         (if (##eq? act (macro-absent-obj))
             ##user-interrupt!
             act)))

    (if (##eq? thread (macro-current-thread))

        (action)

        (begin

          ;; Check if the thread is interruptable (it must be active,
          ;; i.e. started but not terminated). Note that the thread
          ;; may subsequently terminate before the interrupt reaches
          ;; it and is handled. However this will cause the result
          ;; mutex in ##thread-intr! to be abandoned, and thus raise
          ;; an abandoned-mutex exception.

          ;; acquire low-level lock of thread
          (macro-lock-thread! thread)

          (if (or (##not (macro-started-thread? thread))
                  (macro-terminated-thread-given-initialized? thread))
              (begin

                ;; Thread is inactive.

                ;; release low-level lock of thread
                (macro-unlock-thread! thread)

                (##raise-inactive-thread-exception thread-interrupt! thread act))
              (begin

                ;; Thread is active and can be interrupted.

                ;; release low-level lock of thread
                (macro-unlock-thread! thread)

                (##thread-intr! thread #f action)))))))

(define-prim (##thread-intr! thread async? thunk)

  (##declare (not interrupts-enabled))

  ;; Construct a "result mutex" to manage the transfer of the
  ;; interrupt request to the interrupted thread and, when async? is
  ;; #f, to transfer the result back to the requesting thread.  The
  ;; mutex's name is the thunk to call and the specific field is the
  ;; target thread and the thunk's result. Note that if the target
  ;; thread is terminated or it terminates while the interrupt is
  ;; being sent, an abandoned mutex exception will be raised.

  (let* ((result-mutex (##make-mutex thunk))
         (interrupt (##vector '() result-mutex)))
    (macro-mutex-specific-set! result-mutex thread)
    (macro-mutex-lock! result-mutex #f thread)
    (##thread-intr-propagate! interrupt)
    (if async?
        (##void)
        (begin
          (macro-mutex-lock! result-mutex #f (macro-current-thread))
          (macro-mutex-unlock! result-mutex)
          (macro-mutex-specific result-mutex)))))

(define-prim (##thread-intr-propagate! interrupt)

  (##declare (not interrupts-enabled))

  (##thread-lock-remove-btq-toq!

   (macro-mutex-specific (##vector-ref interrupt 1)) ;; target thread of interrupt

   (lambda (interrupt)

     (let ((thread (macro-mutex-specific (##vector-ref interrupt 1))))
       (if (##not (macro-terminated-thread-given-initialized? thread))

           (let ((last-processor (macro-thread-last-processor thread)))
             (macro-lock-processor! last-processor)
             (let ((last-processor-current-thread
                    (macro-processor-current-thread last-processor))
                   (last-processor-id (macro-processor-id last-processor)))
               (macro-unlock-processor! last-processor)

               (if (##eq? thread last-processor-current-thread)

                   (begin

                     ;; The thread is currently executing on last-processor,
                     ;; so propagate interrupt to that processor.

                     ;; release low-level lock of thread
                     (macro-unlock-thread! thread)

                     ;; propagate interrupt
                     (##raise-high-level-interrupt last-processor-id interrupt))

                   (begin

                     ;; The thread is not currently executing, so schedule
                     ;; its execution on the current processor.

                     ;; add interrupt to thread's interrupt queue
                     (let ((tail (macro-thread-interrupts-tail thread)))
                       (macro-thread-interrupts-tail-set! thread interrupt)
                       (if (##null? tail)
                           (macro-thread-interrupts-head-set! thread interrupt)
                           (##vector-set! tail 0 interrupt)))

                     (macro-add-thread-to-run-queue-of-current-processor-preferably! thread)

                     ;; release low-level lock of thread
                     (macro-unlock-thread! thread))))))))

   interrupt))

(define-prim (##other-interrupt!)

  (##declare (not interrupts-enabled))

  ;; This procedure is called by a processor to handle the processor's
  ;; high-level interrupts (generated from Scheme code).

  (let loop ()
    (macro-lock-current-processor!)
    (let ((interrupt
           (macro-processor-interrupts-head (macro-current-processor))))
      (if (##null? interrupt)
          (macro-unlock-current-processor!)
          (let ((next (##vector-ref interrupt 0)))
            (macro-processor-interrupts-head-set!
             (macro-current-processor)
             next)
            (if (##null? next)
                (macro-processor-interrupts-tail-set!
                 (macro-current-processor)
                 '()))
            (macro-unlock-current-processor!)
            (let ((x (##vector-ref interrupt 1)))

              ;; There are two types of interrupts:
              ;;
              ;; - procedure: interrupt targets the processor
              ;;
              ;; - mutex: interrupt targets a specific thread

              (cond ((##procedure? x)
                     (x interrupt))

                    ((macro-mutex? x)
                     ;; mutex-specific is thread to interrupt and result
                     ;; mutex-name is thunk
                     (let ((target-thread (macro-mutex-specific x)))
                       (if (##eq? target-thread (macro-current-thread))
                           (let ((thunk (macro-mutex-name x)))
                             (macro-mutex-specific-set! x (thunk))
                             (macro-mutex-unlock! x))
                           (##thread-intr-propagate! interrupt))))))
            (loop))))))

;;TODO:deprecated
(define-prim (##thread-call thread thunk)

  (##declare (not interrupts-enabled))

  (##thread-interrupt! thread thunk))

;;TODO: move to _repl.scm
(define-prim (##thread-continuation-capture thread)

  (##declare (not interrupts-enabled))

  (##thread-interrupt!
   thread
   (lambda ()
     (##continuation-capture (lambda (k) k)))))

;;;----------------------------------------------------------------------------

;; The procedure thread-start! makes a thread runnable.  The thread
;; must be initialized and not started yet.

(define-prim (thread-start! thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-start! thread)
      (##thread-start! thread))))

;;TODO: find better interface
(define-prim (##thread-pin! thread processor)
  (macro-thread-pinned-set! thread processor)
  (##void))

;;TODO: enable this interface
#;
(define-prim (thread-start! thread #!optional (processor (macro-absent-obj)))

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread processor)
    (macro-check-thread thread 1 (thread-start! thread processor)
      (if (##eq? processor (macro-absent-obj))
          (##thread-start! thread processor)
          (macro-check-processor processor 2 (thread-start! thread processor)
            (##thread-start! thread processor))))))

(define-prim (##thread-start! thread)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of thread
  (macro-lock-thread! thread)

  (macro-check-initialized-thread thread (thread-start! thread)
    (macro-check-not-started-thread
      thread
      (thread-start! thread)
      (begin

        ;; set the exception? field to something other than
        ;; 'not-started to indicate thread is started
        (macro-thread-exception?-set! thread #f)

        (macro-add-thread-to-run-queue-of-some-processor! thread)
        #;(macro-add-thread-to-run-queue-of-current-processor-preferably! thread)

        ;;TODO: rethink use of reschedule-if-needed!
        ;;(macro-thread-reschedule-if-needed!)

        ;; release low-level lock of thread
        (macro-unlock-thread! thread)

        thread))))

;;;----------------------------------------------------------------------------

;; The procedure thread-terminate! causes an abnormal termination of
;; the thread parameter, which must be an initialized thread.

(define-prim (thread-terminate! thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-terminate! thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-terminate! thread)
          (begin
            (macro-unlock-thread! thread)
            (##thread-terminate! thread)))))));;TODO: merge unlock and lock

(define-prim (##thread-terminate! thread)

  (##declare (not interrupts-enabled))

  (##thread-end!
   thread
   'terminated-thread-exception
   #f))

(define-prim (##thread-end-with-uncaught-exception! exc)

  (##declare (not interrupts-enabled))

  (##thread-end-current-thread!
   'uncaught-exception
   exc))

(define-prim (##thread-end! thread exception? result)

  (##declare (not interrupts-enabled))

  (if (##eq? thread (macro-current-processor))

      (##thread-end-current-thread! exception? result)

      (begin

        ;; acquire low-level lock of thread
        (macro-lock-thread! thread)

        (if (##not (macro-started-thread? thread))

            (begin

              ;; The thread is not yet started, so just undo what
              ;; macro-thread-init! did.

              (##thread-end-locked! thread exception? result))

            (begin

              ;; release low-level lock of thread
              (macro-unlock-thread! thread)

              (##with-exception-catcher
               (lambda (exc)

                 ;; It is possible that exc is an
                 ;; inactive-thread-exception or an
                 ;; abandoned-mutex-exception, which happen when the
                 ;; thread is terminated or in the process of
                 ;; terminating.  Just ignore the exception.

                 #f)
               (lambda ()
                 (##thread-interrupt!
                  thread
                  (lambda ()
                    (##thread-end-current-thread! exception? result)))))

              (##void))))))

(define-prim (##thread-end-current-thread! exception? result)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of thread
  (macro-lock-current-thread!)

  (##thread-end-locked! (macro-current-thread) exception? result)

  (macro-processor-current-thread-set! (macro-current-processor) #f)
  (##thread-schedule!))

(define-prim (##thread-end-locked! thread exception? result)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the thread has been acquired.

  (let ((end-condvar (macro-thread-end-condvar thread))) ;; check state

    (cond ((##not end-condvar)

           ;; Thread is already terminated.

           ;; this case is impossible, but keep test for now

           ;; release low-level lock of thread
           (macro-unlock-thread! thread)

           (##void))

          ((##eq? thread (macro-primordial-thread))

           ;; Termination of the primordial thread causes the program
           ;; to terminate.

           ;; release low-level lock of thread
           (macro-unlock-thread! thread)

           (if (##eq? exception? 'uncaught-exception)
               (##exit-with-exception result)
               (##exit)))

          (else

           ;; Change state of thread.

           (macro-thread-end-condvar-set! thread #f)
           (macro-thread-exception?-set! thread exception?)
           (macro-thread-result-set! thread result)
           (macro-thread-cont-set! thread #t)
           (macro-thread-denv-set! thread #f)
           (macro-thread-denv-cache1-set! thread #f)
           (macro-thread-denv-cache2-set! thread #f)
           (macro-thread-denv-cache3-set! thread #f)

           ;; Because the thread is currently executing, it can't be in
           ;; a blocked thread queue or a timeout queue.

           ;; Remove thread from its thread group.

           (let ((tgroup (macro-thread-tgroup thread)))
             (macro-lock-tgroup! tgroup)
             (macro-tgroup-threads-deq-remove! thread)
             (macro-tgroup-threads-deq-init! thread)
             (macro-unlock-tgroup! tgroup))

           ;; The thread must abandon all the blocked thread queues
           ;; (i.e. mutexes, condvars, etc) it owns.

           (let loop ()
             (let ((next-btq (macro-btq-deq-next thread)))
               (if (##not (##eq? next-btq thread))
                   (begin
                     (##btq-abandon! next-btq)
                     (loop)))))

           ;; release low-level lock of thread
           (macro-unlock-thread! thread)

           (##condvar-signal-no-reschedule! end-condvar #t)

           (##void)))))

(define-prim (##btq-abandon! btq)

  (##declare (not interrupts-enabled))

  (macro-lock-btq! btq)
  (macro-btq-deq-remove! btq)
  (macro-if-btq-next
   btq
   next-thread

   (if (macro-mutex? btq)
       (begin
         (macro-lock-thread! next-thread)
         (##mutex-signal-no-reschedule! btq next-thread #t))
       (begin
         (let ((owner (macro-btq-owner btq)))
           (if (macro-thread? owner)
               (##thread-effective-priority-downgrade! owner)))
         (macro-btq-unlink! btq (macro-mutex-state-abandoned))
         (macro-unlock-btq! btq)))

   (begin
     (macro-btq-unlink! btq (macro-mutex-state-abandoned))
     (macro-unlock-btq! btq))))

;;;----------------------------------------------------------------------------

;; The procedure thread-join! causes the current thread to wait until
;; the targeted thread terminates (normally or not) or until the
;; timeout is reached if a timeout parameter is supplied.

(define-prim (thread-join!
              thread
              #!optional
              (absrel-timeout (macro-absent-obj))
              (timeout-val (macro-absent-obj)))

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread absrel-timeout)
    (macro-check-thread
     thread
     1
     (thread-join! thread absrel-timeout timeout-val)
     (if (or (##eq? absrel-timeout (macro-absent-obj))
             (macro-absrel-time-or-false? absrel-timeout))
         (begin
           (macro-lock-thread! thread)
           (macro-check-initialized-thread
             thread
             (thread-join! thread absrel-timeout timeout-val)
             (begin
               (macro-unlock-thread! thread)
               (##thread-join! thread absrel-timeout timeout-val))));;TODO: merge unlock and lock
       (##fail-check-absrel-time-or-false
        2
        thread-join!
        thread
        absrel-timeout
        timeout-val)))))

(define-prim (##thread-join! thread absrel-timeout timeout-val)

  (##declare (not interrupts-enabled))

  (define (done thread absrel-timeout timeout-val joined-before-timeout?)
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
            timeout-val)))

  (let ((timeout
         (##absrel-timeout->timeout
          (if (##eq? absrel-timeout (macro-absent-obj))
              #f
              absrel-timeout))))

    (let try-again ()

      ;; acquire low-level lock of the thread
      (macro-lock-thread! thread)

      (let ((end-condvar (macro-thread-end-condvar thread)))

        ;; release low-level lock of the thread
        (macro-unlock-thread! thread)

        (if end-condvar

            (if (##not timeout) ;; timeout already reached?

                (done thread absrel-timeout timeout-val #f)

                (begin

                  ;; acquire low-level lock of end-condvar
                  (macro-lock-condvar! end-condvar)

                  ;; acquire low-level locks of threads
                  (##lock-2-threads! (macro-current-thread) thread)

                  ;; make sure thread is still not terminated
                  (if (macro-thread-end-condvar thread)

                      (let ((result
                             (macro-thread-save!
                              (lambda (current-thread thread timeout end-condvar)

                                ;; setup restart of join as default action
                                (macro-thread-resume-thunk-set!
                                 current-thread
                                 ##thread-void-action!)

                                ;;TODO: reenable
                                ;;(macro-thread-unboost-and-clear-quantum-used! current-thread)

                                ;; suspend current thread on end-condvar
                                (##thread-btq-insert! end-condvar current-thread)

                                ;; acquire low-level lock of processor
                                (macro-lock-current-processor!)

                                ;; thread is no longer the current thread
                                (macro-processor-current-thread-set!
                                 (macro-current-processor)
                                 #f)

                                (if (##not (##eq? timeout #t))
                                    (begin

                                      ;; save current thread's timeout
                                      (macro-thread-timeout-set!
                                       current-thread
                                       timeout)

                                      ;; add current thread to timeout queue
                                      (##toq-insert!
                                       (macro-current-processor)
                                       current-thread)))

                                ;; release low-level locks of threads
                                (##unlock-2-threads! current-thread thread)

                                ;; release low-level lock of end-condvar
                                (macro-unlock-condvar! end-condvar)

                                ;; schedule next runnable thread
                                (##thread-schedule-with-acquired-processor!))
                              thread
                              timeout
                              end-condvar)))

                        (if (##eq? result (##void))
                            (try-again)
                            (done thread absrel-timeout timeout-val result)))

                      (begin

                        ;; release low-level locks of threads
                        (##unlock-2-threads! (macro-current-thread) thread)

                        ;; release low-level lock of end-condvar
                        (macro-unlock-condvar! end-condvar)

                        (done thread absrel-timeout timeout-val #t)))))

            (done thread absrel-timeout timeout-val #t))))))

;;;----------------------------------------------------------------------------

;; The procedure thread-yield! is called by a running thread when it
;; wants to allow other runnable threads of equal or higher priority,
;; on the same processor, to run.  thread-yield! is called when the
;; thread's quantum is over, and it can also be called explicitly by
;; the program.  The current thread will keep on running if there are
;; no other runnable threads of equal or higher priority.

(define-prim (thread-yield!)

  (##declare (not interrupts-enabled))

  (##thread-yield!))

(define-prim (##thread-yield!)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of the thread
  (macro-lock-current-thread!)

  ;; acquire low-level lock of the processor
  (macro-lock-current-processor!)

  ;; Check if there are other runnable threads.

  (macro-if-btq-next
   (macro-current-processor)
   next-thread

   (begin

     ;; There are other runnable threads, so switch to running
     ;; the next runnable thread.

     (macro-thread-save!

      (lambda (current-thread)

        ;;TODO: reenable
        ;;(macro-thread-unboost-and-clear-quantum-used! current-thread)

        (macro-thread-resume-thunk-set!
         current-thread
         ##thread-void-action!)

        (macro-add-thread-to-run-queue-of-current-processor-without-locking! current-thread)

        ;; thread is no longer the current thread
        (macro-processor-current-thread-set!
         (macro-current-processor)
         #f)

        ;; release low-level lock of the thread
        (macro-unlock-thread! current-thread)

        ;; schedule next runnable thread
        (##thread-schedule-with-acquired-processor!))))

   (begin

     ;; Fast case where only the current thread is runnable.

     ;;TODO: reenable
     ;;(macro-thread-unboost-and-clear-quantum-used! (macro-current-thread))

     ;; release low-level lock of processor
     (macro-unlock-current-processor!)

     ;; release low-level lock of the thread
     (macro-unlock-current-thread!)

     (##void))))

;;;----------------------------------------------------------------------------

;; The procedure thread-sleep! causes the current thread to suspend
;; execution until the timeout is reached. The timeout can be a real
;; number expressing a relative time in seconds, or a time object
;; representing an absolute time on the time line.

(define-prim (thread-sleep! absrel-timeout)

  (##declare (not interrupts-enabled))

  (macro-force-vars (absrel-timeout)
    (macro-check-absrel-time
     absrel-timeout
     1
     (thread-sleep! absrel-timeout)
     (##thread-sleep! absrel-timeout))))

(define-prim (##thread-sleep! absrel-timeout)

  (##declare (not interrupts-enabled))

  ;; convert absrel-timeout to an absolute timeout and check if
  ;; timeout has already been reached.

  (let ((timeout (##absrel-timeout->timeout absrel-timeout)))
    (if timeout ;; timeout not reached yet?

        (let try-again ()

          ;; acquire low-level lock of the current thread
          (macro-lock-current-thread!)

          (let ((result
                 (macro-thread-save!

                  (lambda (current-thread timeout)

                    ;; setup restart of sleep as default action
                    (macro-thread-resume-thunk-set!
                     current-thread
                     ##thread-void-action!)

                    ;;TODO:reenable
                    #;
                    (macro-thread-unboost-and-clear-quantum-used!
                    current-thread)

                    ;; acquire low-level lock of processor
                    (macro-lock-current-processor!)

                    ;; thread is no longer the current thread
                    (macro-processor-current-thread-set!
                     (macro-current-processor)
                     #f)

                    ;; When timeout = #t it means there is "no timeout".
                    ;; This should never happen, but for symmetry with
                    ;; other time limited operations it is tested here.

                    (if (##not (##eq? timeout #t))
                        (begin

                          ;; save current thread's timeout
                          (macro-thread-timeout-set!
                           current-thread
                           timeout)

                          ;; add current thread to timeout queue
                          (##toq-insert!
                           (macro-current-processor)
                           current-thread)))

                    ;; release low-level lock of the current thread
                    (macro-unlock-thread! current-thread)

                    ;; schedule next runnable thread
                    (##thread-schedule-with-acquired-processor!))

                  timeout)))

            (if (##eq? result (##void))
                (try-again)
                (##void))))

          (##void))))

;;;----------------------------------------------------------------------------

;; The procedure thread-state returns the state of the thread, which
;; is one of the following:
;;
;;  - thread-state-uninitialized          thread is uninitialized
;;  - thread-state-initialized            thread is initialized but not started
;;  - thread-state-waiting                thread is started and waiting
;;  - thread-state-running                thread is running on a processor
;;  - thread-state-normally-terminated    thread terminated normally
;;  - thread-state-abnormally-terminated  thread terminated with an exception

(define-prim (thread-state thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-state thread)
      (##thread-state thread))))

(define-prim (##thread-state thread)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of the thread
  (macro-lock-thread! thread)

  (cond ((##not (macro-initialized-thread? thread))

         ;; release low-level lock of the thread
         (macro-unlock-thread! thread)

         (macro-make-constant-thread-state-uninitialized))

        ((##not (macro-started-thread? thread))

         ;; release low-level lock of the thread
         (macro-unlock-thread! thread)

         (macro-make-constant-thread-state-initialized))

        ((macro-terminated-thread-given-initialized? thread)
         (if (macro-thread-exception? thread)

             (let ((result (macro-thread-result thread)))

               ;; release low-level lock of the thread
               (macro-unlock-thread! thread)

               (macro-make-thread-state-abnormally-terminated result))

             (let ((result (macro-thread-result thread)))

               ;; release low-level lock of the thread
               (macro-unlock-thread! thread)

               (macro-make-thread-state-normally-terminated result))))

        (else
         (let ((last-processor (macro-thread-last-processor thread)))
           (macro-lock-processor! last-processor)
           (let ((last-processor-current-thread
                  (macro-processor-current-thread last-processor)))
             (macro-unlock-processor! last-processor)
             (if (##eq? thread last-processor-current-thread)

                 (begin

                   ;; release low-level lock of the thread
                   (macro-unlock-thread! thread)

                   (macro-make-thread-state-running last-processor))

                 (let* ((btq
                         (macro-thread->btq thread))
                        (toq
                         (macro-thread->toq thread))
                        (timeout
                         (and toq
                              (macro-timeout (macro-thread-floats thread))))
                        (waiting-for
                         (if (and (macro-condvar? btq)
                                  (##io-condvar? btq))
                             (##io-condvar-port btq)
                             btq)))

                   ;; release low-level lock of the thread
                   (macro-unlock-thread! thread)

                   (macro-make-thread-state-waiting
                    waiting-for
                    (and timeout
                         (macro-make-time timeout #f #f #f))))))))))

;;;----------------------------------------------------------------------------

;; The procedure thread-quantum returns the quantum of the thread.

(define-prim (thread-quantum thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-quantum thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-quantum thread)
          (let ((result (macro-thread-quantum thread)))
            (macro-unlock-thread! thread)
            result))))))

;; The procedure thread-quantum-set! changes the quantum of the thread
;; and reschedules the thread according to its new quantum.

(define-prim (thread-quantum-set! thread quantum)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread quantum)
    (macro-check-thread thread 1 (thread-quantum-set! thread quantum)
      (macro-check-real
        quantum
        2
        (thread-quantum-set! thread quantum)
        (let ((q (macro-real->inexact quantum)))
          (if (##flnegative? q)
              (##raise-range-exception 2 thread-quantum-set! thread quantum)
              (begin
                (macro-lock-thread! thread)
                (macro-check-initialized-thread
                  thread
                  (thread-quantum-set! thread quantum)
                  (##thread-quantum-set-locked! thread q)))))))))

(define-prim (##thread-quantum-set! thread quantum)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of the thread
  (macro-lock-thread! thread)

  (##thread-quantum-set-locked! thread quantum))

(define-prim (##thread-quantum-set-locked! thread quantum)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the thread has been acquired.

  (macro-thread-quantum-set! thread quantum)

  ;; release low-level lock of the thread
  (macro-unlock-thread! thread)

  ;; check if the current thread's quantum is now over

  (if (and (##eq? thread (macro-current-thread))
           (##not (##fl< (macro-thread-quantum-used thread) quantum)))
      (##thread-yield!)
      (##void)))

;;;----------------------------------------------------------------------------

;; The procedure thread-base-priority returns the base priority of the
;; thread.

(define-prim (thread-base-priority thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-base-priority thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-base-priority thread)
          (let ((result (macro-thread-base-priority thread)))
            (macro-unlock-thread! thread)
            result))))))

;; The procedure thread-base-priority-set! changes the base priority
;; of the thread and reschedules the thread according to its new
;; effective priority.

(define-prim (thread-base-priority-set! thread base-priority)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread base-priority)
    (macro-check-thread
      thread
      1
      (thread-base-priority-set! thread base-priority)
      (macro-check-real
        base-priority
        2
        (thread-base-priority-set! thread base-priority)
        (begin
          (macro-lock-thread! thread)
          (macro-check-initialized-thread
            thread
            (thread-base-priority-set! thread base-priority)
            (##thread-base-priority-set-locked!
             thread
             (macro-real->inexact base-priority))))))))

(define-prim (##thread-base-priority-set! thread base-priority)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of the thread
  (macro-lock-thread! thread)

  (##thread-base-priority-set-locked! thread base-priority))

(define-prim (##thread-base-priority-set-locked! thread base-priority)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the thread has been acquired.

  (let ((floats (macro-thread-floats thread)))

    ;; save old boosted priority for ##thread-boosted-priority-changed!

    (macro-temp-set!
     (macro-thread-floats (macro-current-processor))
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

    (##thread-boosted-priority-changed! thread) ;;TOO:integrate rescheduling

    ;; the change of priority may have made a higher priority
    ;; thread runnable, check for this

    (macro-thread-reschedule-if-needed!)))

;; The procedure thread-priority-boot returns the priority boost of
;; the thread.

(define-prim (thread-priority-boost thread)

  (##declare (not interrupts-enabled))

  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-priority-boost thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-priority-boost thread)
          (let ((result (macro-thread-priority-boost thread)))
            (macro-unlock-thread! thread)
            result))))))

;; The procedure thread-priority-boost-set! changes the priority boost
;; of the thread and reschedules the thread according to its new
;; effective priority.

(define-prim (thread-priority-boost-set! thread priority-boost)

  (##declare (not interrupts-enabled))

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
          (begin
            (macro-lock-thread! thread)
            (macro-check-initialized-thread
              thread
              (thread-priority-boost-set! thread priority-boost)
              (##thread-priority-boost-set-locked! thread b)))))))))

(define-prim (##thread-priority-boost-set! thread priority-boost)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of the thread
  (macro-lock-thread! thread)

  (##thread-priority-boost-set-locked! thread priority-boost))

(define-prim (##thread-priority-boost-set-locked! thread priority-boost)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the thread has been acquired.

  (let ((floats (macro-thread-floats thread)))

    (macro-priority-boost-set! floats priority-boost)

    (if (##fl= (macro-base-priority floats)
               (macro-boosted-priority floats))

      (##void)

      (begin

        ;; save old boosted priority for ##thread-boosted-priority-changed!

        (macro-temp-set!
         (macro-thread-floats (macro-current-processor))
         (macro-boosted-priority floats))

        (macro-boosted-priority-set!
         floats
         (##fl+ (macro-base-priority floats)
                priority-boost))

        (##thread-boosted-priority-changed! thread)

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
           (##thread-effective-priority-changed! thread #t))
          ((##fl=
            (macro-effective-priority floats)
            (macro-temp (macro-thread-floats (macro-current-processor))))
           (##thread-effective-priority-downgrade! thread)))))

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
            (##thread-effective-priority-downgrade! owner)))))))

;; (##thread-effective-priority-downgrade! thread) is called to
;; recompute the effective priority of a thread.  It is only called in
;; situations where the new effective priority is no more than the old
;; one.

(define-prim (##thread-effective-priority-downgrade! thread)

  (##declare (not interrupts-enabled))

  (let ((floats (macro-thread-floats thread)))

    ;; save old effective priority for later

    (macro-temp-set!
     (macro-thread-floats (macro-current-processor))
     (macro-effective-priority floats))

    ;; compute the maximum of the boosted priority and the
    ;; effective priority of all the threads in blocked thread
    ;; queues (i.e. mutexes, condvars, etc) owned by the thread

    (macro-effective-priority-set!
     floats
     (macro-boosted-priority floats))

    (let loop ((btq (macro-btq-deq-next thread)))
      (if (##not (##eq? btq thread))
          (macro-if-btq-next
           btq
           next
           (let ((next-floats (macro-thread-floats next)))
             (if (##fl< (macro-effective-priority floats)
                        (macro-effective-priority next-floats))
                 (macro-effective-priority-set!
                  floats
                  (macro-effective-priority next-floats)))))
          (loop (macro-btq-deq-next btq))))

    (if (##not (##fl=
                (macro-temp (macro-thread-floats (macro-current-processor)))
                (macro-effective-priority floats)))
      (##thread-effective-priority-changed! thread #f))))

;;;----------------------------------------------------------------------------

(define-prim (##thread-btq-insert! btq thread)
  (##declare (not interrupts-enabled))
  (##btq-insert! btq thread)
  ;;TODO: fix me
  #;
  (let ((owner (macro-btq-owner btq)))
    (if (macro-thread? owner)
      (macro-thread-inherit-priority! owner thread))))

(define-prim (##thread-btq-remove! thread)

  (##declare (not interrupts-enabled))

  ;; Assumes the btq containing the thread has an acquired low-level lock.

  (##btq-remove! thread)
  ;;TODO:fix priority inheritance
  #;
  (let ((owner (macro-btq-owner (macro-thread->btq thread))))
    (if (macro-thread? owner)
      (if (##fl= (macro-thread-effective-priority thread)
                 (macro-thread-effective-priority owner))
        (##thread-effective-priority-downgrade! owner)))))

(define-prim (##thread-toq-remove! thread)
  (##declare (not interrupts-enabled))
  (##toq-remove! thread))

;; The procedure ##thread-check-timeouts! checks if any of the threads
;; with a limited time wait have expired their timeout and wakes up
;; these threads by transferring them to the run queue.

(define-prim (##thread-check-timeouts!)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the processor has been acquired.

  (macro-if-toq-next
   (macro-current-processor)
   next

   (begin

     ;; The processor's timeout queue is non-empty.

     (macro-update-current-time!) ;; update time (in floats of processor)

     (let loop ()
       (macro-if-toq-next
        (macro-current-processor)
        next-thread

        (if (##not (macro-thread-sooner? (macro-current-processor)
                                         next-thread))

            (let ()

              ;; Found a thread with limited time wait with a timeout
              ;; earlier than the current time. Consequently, that
              ;; thread must wake up.

              (define (done)

                (##thread-toq-remove! next-thread)

                (macro-thread-resume-thunk-set!
                 next-thread
                 ##thread-timeout-action!)

                (macro-add-thread-to-run-queue-of-current-processor-without-locking! next-thread)

                (macro-unlock-thread! next-thread)

                (loop))

              ;;TODO: shouldn't be a trylock!
              (if (macro-trylock-thread! next-thread)
                  (let ((btq (macro-thread->btq next-thread)))
                    (cond ((##not btq)
                           (done))

                          ((macro-trylock-btq! btq)
                           (##thread-btq-remove! next-thread)
                           (macro-unlock-btq! btq)
                           (done))

                          (else
                           (macro-unlock-thread! next-thread))))))))))))

(define-prim (##wait! devices timeout)

  (##declare (not interrupts-enabled))

  (let ((processor (macro-current-processor)))

    (macro-lock-current-vm!)
    (macro-processor-deq-insert-at-tail! (macro-current-vm) processor)
    (macro-unlock-current-vm!)

    (let ((code (##os-condvar-select! devices timeout)))

      (macro-lock-current-vm!)
      (macro-processor-deq-remove! processor)
      (macro-unlock-current-vm!)

      code)))

(define-prim (##wait-abort! processor)

  (##declare (not interrupts-enabled))

  (macro-lock-current-vm!)
  (macro-processor-deq-remove! processor)
  (macro-unlock-current-vm!)

  (##wait-abort-no-remove! processor))

(define-prim (##wait-abort-no-remove! processor)

  (##declare (not interrupts-enabled))

  (##device-select-abort! (macro-processor-id processor)))

(define-prim (##wake-up-one-processor)

  (##declare (not interrupts-enabled))

  (macro-lock-current-vm!)
  (let ((processor (macro-processor-deq-head (macro-current-vm))))
    (macro-unlock-current-vm!)
    (if (##not (##eq? processor (macro-current-vm)))
        (begin
          (##wait-abort! processor)
          #t)
        #f)))

(define-prim (##waiting-processors);;;;for debugging
  (macro-lock-current-vm!)
  (let loop ((lst '())
             (processor (macro-processor-deq-head (macro-current-vm))))
    (if (##eq? processor (macro-current-vm))
        (begin
          (macro-unlock-current-vm!)
          lst)
        (loop (##cons processor lst)
              (macro-processor-deq-next processor)))))

;; The procedure ##thread-poll-devices! checks without blocking if any
;; of the devices on which the processor is waiting for an IO
;; operation to become possible are now ready to perform the IO
;; operation.  Any thread waiting for one of these devices to be ready
;; to perform the IO operation will become runnable when the IO
;; operation becomes possible.

(define-prim (##thread-poll-devices!)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the processor has been acquired.

  ;; The set of devices on which the scheduler is waiting for an IO
  ;; are held in the processor's queue of blocked thread queues.

  (if (##eq? (macro-btq-deq-next (macro-current-processor))
             (macro-current-processor)) ;; not waiting on devices?
      0 ;; "no error" code
      (##thread-check-devices! #f)))

;; The procedure ##thread-check-devices! checks if any of the devices
;; on which the processor is waiting for an IO operation to become
;; possible are now ready to perform the IO operation.  The timeout
;; parameter indicates how long to wait for any of the IO operations
;; to become possible.  When timeout is #f, there is no waiting.

(define-prim (##thread-check-devices! timeout)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the processor has been acquired.

  ;;(##c-code "printf(\"P%d ##wait! in ##thread-check-devices!\\n\",___INT(___ARG1));" (##current-processor-id));;TODO: remove

  (let ((code (##wait! (macro-current-processor) timeout))) ;; wait for IO

    ;; For each device, check if the IO operation is now possible.

    (let loop ((condvar (macro-btq-deq-next (macro-current-processor))))
      (if (##eq? condvar (macro-current-processor))
          code
          (let ((next (macro-btq-deq-next condvar)))

            ;; Wakeup waiting threads when IO becomes possible on a
            ;; device.
            ;;(##c-code "printf(\"(macro-btq-owner condvar)=%d\\n\",___INT(___ARG1));" (macro-btq-owner condvar));;TODO: remove
            (if (##fxodd? (macro-btq-owner condvar)) ;; IO now possible?
                (begin
                  ;;(##c-code "printf(\"P%d calling ##device-condvar-broadcast-no-reschedule!\\n\",___INT(___ARG1));" (##current-processor-id));;TODO: remove
                  ;;TODO: remove possibility of deadlock!
                  (macro-unlock-current-processor!)
                  (##device-condvar-broadcast-no-reschedule! condvar)
                  (macro-lock-current-processor!))
                ;;(##c-code "printf(\"P%d NOT calling ##device-condvar-broadcast-no-reschedule!\\n\",___INT(___ARG1));" (##current-processor-id))
                );;TODO: remove

            (loop next))))))

;; The procedure ##thread-heartbeat! is called periodically, by each
;; non-waiting processor, to perform periodic tasks such as waking up
;; threads that have elapsed their sleep period, preempting the
;; currently running thread, etc.

(define-prim (##thread-heartbeat!)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of the processor
  (macro-lock-current-processor!)

  (let ((code (##thread-poll-devices!)))

    (##thread-check-timeouts!)

    (macro-unlock-current-processor!)

    (if (and (##fx< code 0)
             (##not (##fx= code ##err-code-EINTR)))

        ;; there was an error that cannot be handled, so force the
        ;; primordial thread to wakeup and raise a "scheduler
        ;; error" exception

        ;;TODO: find a better way to report a scheduler error
        (##thread-report-scheduler-error! code))

    (if (macro-current-thread) ;; if currently executing a thread

        (let* ((current-processor-floats ;; to get heartbeat interval
                (macro-thread-floats (macro-current-processor)))
               (current-thread-floats ;; to get current thread's quantum used
                (macro-thread-floats (macro-current-thread)))
               (heartbeat-interval
                (macro-get-heartbeat-interval current-processor-floats))
               (quantum-used
                (##fl+ (macro-quantum-used current-thread-floats)
                       heartbeat-interval)))

          (macro-quantum-used-set! current-thread-floats quantum-used)

          (if (##fl< quantum-used
                     (macro-quantum current-thread-floats))
              (macro-thread-reschedule-if-needed!) ;;TODO: check what this does
              (##thread-yield!))))))

(define-prim (##thread-reschedule!)

  (##declare (not interrupts-enabled))

  (macro-thread-save!
   (lambda (current-thread)
     (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
     (macro-processor-current-thread-set! (macro-current-processor) #f)
     ;; schedule next runnable thread
     (##thread-schedule!))))

(define-prim (##service-interrupts!)

  (##declare (interrupts-enabled))

  (##declare (not inline))

  (define (dummy) #f)

  (dummy)) ;; this call will generate an interrupt check

(define-prim (##thread-resume-execution!)

  (##declare (not interrupts-enabled))

  (let ((resume-thunk (macro-thread-resume-thunk (macro-current-thread))))
    (let loop ()
      (macro-lock-current-thread!)
      (macro-thread-interrupts-remove-from-head!
       interrupt
       (begin
         (macro-unlock-current-thread!)
         (let ((x (##vector-ref interrupt 1)))
           (cond ((##procedure? x)
                  (x interrupt))
                 ((macro-mutex? x)
                  ;; mutex-specific is thread to interrupt and result
                  ;; mutex-name is thunk
                  (let ((thunk (macro-mutex-name x)))
                    (macro-mutex-specific-set! x (thunk))
                    (macro-mutex-unlock! x)))))
         (loop))
       (begin
         (macro-unlock-current-thread!)
         (resume-thunk))))))

;;; The procedure ##thread-schedule! implements the central logic of
;;; the thread scheduler.  It is called by a processor when it needs
;;; to select a runnable thread to continue executing.  If no runnable
;;; threads can be found, the processor will enter a wait state.

(define-prim (##thread-schedule!)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of processor
  (macro-lock-current-processor!)

  (##thread-schedule-with-acquired-processor!))

(define-prim (##thread-schedule-with-acquired-processor!)

  (##declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the processor has been acquired.

  ;; Try extracting the thread at the head of this processor's run queue.

  (macro-if-btq-next
   (macro-current-processor)
   next-thread

   (begin

     ;; There is at least one thread on the run queue of this
     ;; processor, and next-thread is the one with highest priority
     ;; and next in line. However, because this thread must be locked
     ;; before it can be removed from the run queue, and it is
     ;; possible that some other processor has locked it since the
     ;; moment it was observed at the head of the run queue (to
     ;; terminate it, interrupt it, or do some other operation on it),
     ;; we must attempt to lock it but without blocking, otherwise
     ;; this could lead to a deadlock due to a cross locking of two
     ;; locks in opposite orders (i.e. processor followed by thread
     ;; and thread followed by processor). If the thread can't be
     ;; locked, the processor's lock is released and the thread
     ;; scheduling is retried. This leaves a window for completing
     ;; the operation of the other processor.

     (cond ((##not (macro-trylock-thread! next-thread))

            ;; The thread is currently locked by some other processor
            ;; to perform an operation on the thread.  The processor's
            ;; low-level lock must be released to allow other
            ;; processor to complete its operation on the thread.

            ;; release low-level lock of processor
            (macro-unlock-current-processor!)

            ;; Try again... next-thread may or may not be in the run
            ;; queue, and if it is it might no longer be at the head
            ;; (if its priority has changed).

            (##thread-schedule!))

           ;; Commented out because it is impossible to find a terminated
           ;; thread in a run queue.

           #;
           ((macro-terminated-thread-given-initialized? next-thread)

            ;; The thread is not runnable because it is terminated.

            ;; remove thread from processor's run queue
            (##btq-remove! next-thread)

            ;; release low-level lock of thread
            (macro-unlock-thread! next-thread)

            ;; release low-level lock of processor
            (macro-unlock-current-processor!)

            ;; Try again to find a runnable thread.

            (##thread-schedule!))

           (else

            ;; The next thread in the run queue is now locked, so
            ;; continue executing it.

            ;; remove thread from processor's run queue
            (##btq-remove! next-thread)

            ;; resume execution of the thread (this sets the processor's
            ;; current thread, and the thread's last-processor field)
            (macro-thread-restore!
             next-thread
             (lambda ()

               ;; release low-level lock of thread
               (macro-unlock-current-thread!)

               ;; release low-level lock of processor
               (macro-unlock-current-processor!)

               (##thread-resume-execution!))))))

   (begin

     ;; There are no runnable threads locally, so try to steal a
     ;; thread from the run queue of another processor.

     ;; Make a reasonable attempt to steal a thread from the run
     ;; queues of other processors.

     (let loop ((i (##fx- (##current-vm-processor-count) 1)))
       (if (##fx> i 0)

           (let* ((id
                   (##fxmodulo (##fx+ (##current-processor-id) i)
                               (##current-vm-processor-count)))
                  (victim-processor
                   (##processor id)))

             ;; Try to lock the victim processor, but don't block.

             (if (##not (macro-trylock-processor! victim-processor))

                 (begin

                   ;; Try another victim rather than blocking.

                   (loop (##fx- i 1)))

                 (begin

                   ;; Extract the thread at the head of the victim
                   ;; processor's run queue, if it is non-empty.

                   (macro-if-btq-next
                    victim-processor
                    stolen-thread

                    (begin

                      ;; The victim processor has a thread we can
                      ;; steal on its run queue. But to avoid
                      ;; deadlock, for the same reasons explained
                      ;; above, the stolen-thread must be locked first
                      ;; without blocking.

                      ;; Try to lock the stolen thread, but don't block.

                      (if (or (macro-thread-pinned stolen-thread)
                              (##not (macro-trylock-thread! stolen-thread)))

                          (begin

                            ;; The thread is pinned or we couldn't
                            ;; lock it.

                            ;; release low-level lock of victim processor
                            (macro-unlock-processor! victim-processor)

                            ;; try another victim processor
                            (loop (##fx- i 1)))

                          (begin

                            ;; remove the thread from the run queue
                            (##btq-remove! stolen-thread)

                            ;; release low-level lock of processor
                            (macro-unlock-processor! victim-processor)

                            ;; resume execution of the thread (this
                            ;; sets the processor's current thread,
                            ;; and the thread's last-processor field)
                            (macro-thread-restore!
                             stolen-thread
                             (lambda ()

                               ;; release low-level lock of stolen thread
                               (macro-unlock-current-thread!)

                               ;; release low-level lock of processor
                               (macro-unlock-current-processor!)

                               (##thread-resume-execution!))))))

                    (begin

                      ;; The victim processor's run queue is
                      ;; empty.

                      ;; release low-level lock of victim processor
                      (macro-unlock-processor! victim-processor)

                      ;; try another victim processor
                      (loop (##fx- i 1)))))))

           (begin

             ;; A thread was not stolen from another processor.  Note
             ;; that while trying to steal, some threads may have been
             ;; added to the run queues of other processors, so at
             ;; this point it might be possible to steal a thread. But
             ;; it is ok to be approximative in order to avoid a
             ;; centralized lock.

             ;; Check if there are threads waiting for a timeout
             ;; or for a device to become ready.

             (let ((next-sleeper
                    (macro-toq-leftmost (macro-current-processor)));;TODO: use (macro-if-toq-next ...)
                   (next-condvar
                    (macro-btq-deq-next (macro-current-processor))))

               ;;(##c-code "printf(\"no runnable threads\\n\");");;TODO: remove

               (if (and (##eq? next-sleeper (macro-current-processor))
                        (##eq? next-condvar (macro-current-processor)))

                   (begin

                     ;; This processor has no runnable threads
                     ;; and no sleeping threads and it is not
                     ;; waiting for a device to become ready.
                     ;; To avoid wasting CPU time, the processor
                     ;; will be put in a waiting state until
                     ;; another processor has work to share.

                     ;;(##c-code "printf(\"P%d ##wait! in ##thread-schedule!\\n\",___INT(___ARG1));" (##current-processor-id));;TODO: remove

                     ;; release low-level lock of processor
                     (macro-unlock-current-processor!)

                     (##wait! #f #t)
                     (##service-interrupts!) ;;TODO:remove
                     (##thread-schedule!))

                   (begin

                     ;; Wait for the next timeout or for a device
                     ;; to become ready.

                     ;;(##c-code "printf(\"check-devices!\\n\");");;TODO: remove

                     (let ((code
                            (##thread-check-devices!
                             (if (##eq? next-sleeper
                                        (macro-current-processor))
                                 #t ;; no sleeper -> use infinite timeout
                                 (macro-thread-floats next-sleeper)))))

                       ;; ##thread-check-devices! only returns
                       ;; after a device becomes ready or the
                       ;; timeout is reached or an interrupt is
                       ;; received or an error is detected.

                       (##thread-check-timeouts!)

                       ;; release low-level lock of processor
                       (macro-unlock-current-processor!)

                       (##service-interrupts!) ;;TODO:remove

                       (cond ((##not (##fx< code 0)) ;; no error?
                              (##thread-schedule!))

                             ((##fx= code ##err-code-EINTR)

                              ;;(##c-code "printf(\"EINTR\\n\");")
                              (##thread-schedule!))

                             (else

                              ;; there was an error that cannot
                              ;; be handled, so force the
                              ;; primordial thread to wakeup (it
                              ;; can't be currently runnable) and
                              ;; raise a "scheduler error"
                              ;; exception

                              (##thread-report-scheduler-error! code)

                              ;; schedule next runnable thread
                              (##thread-schedule!)))))))))))))

(define-prim (##thread-report-scheduler-error! code)

  (##declare (not interrupts-enabled))

  (##thread-intr!
   (macro-primordial-thread)
   #f
   (lambda ()

     (macro-raise
      (macro-make-scheduler-exception
       (macro-make-os-exception #f #f #f code)))

     ;; return void so that primordial thread will continue
     ;; normally if exception handler returns

     (##void))))

;;;----------------------------------------------------------------------------

(define-prim (##thread-execute-and-end! thunk)

  (##declare (not interrupts-enabled))

  (##thread-end-current-thread! #f (thunk)))

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

(define-prim (##primordial-exception-handler exc)
  (##declare (not interrupts-enabled))
  (let ((handler ##primordial-exception-handler-hook))
    (if (##procedure? handler)
      (handler exc ##thread-end-with-uncaught-exception!)
      (##thread-end-with-uncaught-exception! exc))))

(define ##primordial-thread #f)

(define primordial-exception-handler ##primordial-exception-handler)

(define ##primordial-exception-handler-hook #f)

(define (##primordial-exception-handler-hook-set! handler)
  (set! ##primordial-exception-handler-hook handler))

(define (##startup-processor!)

  (declare (not interrupts-enabled))

  ;; Assumes that exclusive access to the processor has been acquired.
  ;; Note: this is done when the low-level runtime system creates the
  ;; processor object.

  ;; initialize fields of the processor object
  (macro-processor-init! (##current-processor) (##current-processor-id))

  ;; enable interrupting this processor
  (##enable-interrupts!)

  ;; start scheduling threads on this processor
  (##thread-schedule-with-acquired-processor!))

(##c-return-on-other-processor-hook-set!
 (lambda (id)
   (##thread-migrate-to! id)))

(define-prim (##thread-migrate-to! id)
  (##declare (not interrupts-enabled))
  (macro-thread-save!
   (lambda (current-thread id)
     (let ((p (##processor id)))
       (macro-lock-processor! p)
       ;;TODO: reenable
       ;;(macro-thread-unboost-and-clear-quantum-used! current-thread)
       (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
       (##btq-insert! p current-thread)
       (macro-unlock-processor! p)
       (##wait-abort! p)
       ;;TODO: fix this
       ;;wait a short moment so that the thread-schedule! does not steal the thread
       (let loop ((n 10000000)) (if (##fx> n 0) (loop (##fx- n 1))))
       (macro-processor-current-thread-set! (macro-current-processor) #f)
       (##thread-schedule!)))
   id))

(define-prim (##thread-start-on! id thread)
  (##declare (not interrupts-enabled))
  (let ((p (##processor id)))
    (##btq-insert! p thread)
    (##wait-abort! p)
    ;;(macro-thread-reschedule-if-needed!)
    thread))

(define (##cvmr n)
  (##current-vm-resize ##startup-processor! n))

(define (##startup-parallelism!)
  (let* ((level
          (##get-parallelism-level))
         (nb-procs
          (if (##fx> level 0) level (##fx+ (##cpu-count) level))))
    (if (##fx> nb-procs 1)
        (##cvmr nb-procs))))

;; The ##startup-threading! procedure initializes the thread system.
;; It creates the primordial thread, the primordial thread group and
;; the run queue of processor 0.  The run queue of a processor
;; contains the runnable threads that are waiting for the processor to
;; be available to execute them.  A thread is "running" when a
;; processor is currently executing it.  When a processor starts
;; executing a thread, the thread is removed from the processor's run
;; queue.  Since the primordial thread is initially the only runnable
;; thread, ##startup-threading! creates an empty run queue and the
;; primordial thread becomes the current thread of processor 0.

(define-prim (##startup-threading!)

  (##declare (not interrupts-enabled))

  (macro-vm-init! (macro-current-vm))
  (macro-unlock-current-vm!)

  (macro-processor-init! (##current-processor) (##current-processor-id))
  (macro-unlock-current-processor!)

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

    (macro-thread-exception?-set! primordial-thread #f) ;; indicate started

    (macro-processor-current-thread-set!
     (macro-current-processor)
     primordial-thread)

    (set! ##primordial-thread primordial-thread)

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

    ;;(##set-heartbeat-interval! 1.0)
    (##set-heartbeat-interval! (macro-default-heartbeat-interval))

    (##interrupt-vector-set! 2 ##thread-heartbeat!) ;; ___INTR_HEARTBEAT
    (##interrupt-vector-set! 3 ##user-interrupt!) ;; ___INTR_USER
    (##interrupt-vector-set! 4 ##gc-interrupt!) ;; ___INTR_GC
    (##interrupt-vector-set! 5 ##other-interrupt!) ;; ___INTR_OTHER

    (##void)))

(define-prim (##gc-interrupt!)

  (##declare (not interrupts-enabled))

  (##interrupt-some-thread-async! ##handle-gc-interrupt!))

(define-prim (##interrupt-some-thread-async! thunk)

  (##declare (not interrupts-enabled))

  (if (macro-current-thread)
      (thunk)
      (##thread-intr! ##primordial-thread #t thunk)))

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
                  (let ()
                    (declare (interrupts-enabled))
                    result))
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
    (##check-heap-limit) ;; prevent GC while mutex is locked
    (macro-mutex-lock! mutex #f (macro-current-thread))
    (macro-fifo-insert-at-tail! (macro-mailbox-fifo mb) obj)
    (macro-mutex-unlock! mutex)
    (##condvar-signal! (macro-mailbox-condvar mb) #f)
    (##void)))

(define-prim (thread-send thread obj)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-send thread obj)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-send thread obj)
          (begin
            (macro-unlock-thread! thread)
            (##thread-send thread obj)))))));;TODO: merge unlock and lock

;;;----------------------------------------------------------------------------

;;; Implementation of mutexes.

(define-prim (make-mutex #!optional (n (macro-absent-obj)))

  (##declare (not interrupts-enabled))

  (macro-force-vars (n)
    (let ((name
           (if (##eq? n (macro-absent-obj))
             (##void)
             n)))
      (##make-mutex name))))

(define-prim (##make-mutex name)

  (##declare (not interrupts-enabled))

  (macro-make-mutex name))

(define-prim (mutex? obj)

  (##declare (not interrupts-enabled))

  (macro-force-vars (obj)
    (macro-mutex? obj)))

(define-prim (mutex-name mutex)

  (##declare (not interrupts-enabled))

  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-name mutex)
      (macro-mutex-name mutex))))

(define-prim (mutex-specific mutex)

  (##declare (not interrupts-enabled))

  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-specific mutex)
      (macro-mutex-specific mutex))))

(define-prim (mutex-specific-set! mutex obj)

  (##declare (not interrupts-enabled))

  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-specific-set! mutex obj)
      (begin
        (macro-mutex-specific-set! mutex obj)
        (##void)))))

(define-prim (##mutex-state mutex)

  (##declare (not interrupts-enabled))

  (macro-lock-mutex! mutex)
  (let ((result (macro-btq-owner mutex)))
    (macro-unlock-mutex! mutex)
    result))

(define-prim (mutex-state mutex)

  (##declare (not interrupts-enabled))

  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-state mutex)
      (##mutex-state mutex))))

(define-prim (mutex-lock!
              mutex
              #!optional
              (absrel-timeout (macro-absent-obj))
              (thread (macro-absent-obj)))

  (##declare (not interrupts-enabled))

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
                     (begin
                       (macro-lock-thread! thread)
                       (macro-check-initialized-thread
                         thread
                         (mutex-lock! mutex absrel-timeout thread)
                         (begin
                           (macro-unlock-thread! thread)
                           (macro-mutex-lock! mutex absrel-timeout thread))))))));;TODO: merge unlock and lock
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
                     (begin
                       (macro-lock-thread! thread)
                       (macro-check-initialized-thread
                         thread
                         (mutex-lock! mutex absrel-timeout thread)
                         (begin
                           (macro-unlock-thread! thread)
                           ;;TODO:merge unlock and lock
                           (macro-mutex-lock!
                            mutex
                            absrel-timeout
                            thread))))))))
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

  (##declare (not interrupts-enabled))

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

;; The call (##mutex-lock-out-of-line! mutex absrel-timeout new-owner)
;; causes the current thread to attempt locking the mutex.  The
;; current thread will wait up to the indicated timeout for the mutex
;; to be in an unlocked state, and ##mutex-lock-out-of-line! will
;; return #f if the timeout is reached.  Otherwise the mutex will be
;; locked and ##mutex-lock-out-of-line! will return #t after the
;; thread passed in the new-owner parameter (if not #f) has been made
;; the mutex's owner.

(define-prim (##mutex-lock-anonymously-out-of-line! mutex absrel-timeout)
  (##declare (not interrupts-enabled))
  (##mutex-lock-out-of-line! mutex absrel-timeout #f))

(define-prim (##mutex-lock-out-of-line! mutex absrel-timeout new-owner)

  (##declare (not interrupts-enabled))

  ;; Assumes that the low-level locks of the mutex and new-owner are acquired.

  (if new-owner
      (macro-unlock-thread! new-owner))

  (let ((timeout
         (if (##not absrel-timeout)

             #t ;; no timeout

             (begin

               ;; The timeout must be computed with a call to
               ;; ##absrel-timeout->timeout, but because this might be
               ;; interrupted, we must release all locks currently
               ;; held.

               ;; release low-level lock of mutex
               (macro-unlock-mutex! mutex)

               (let ((timeout (##absrel-timeout->timeout absrel-timeout)))

                 ;; acquire low-level lock of mutex
                 (macro-lock-mutex! mutex)

                 timeout)))))

    (let try-again ()

      ;; Try to lock mutex.

      (let ((result
             (macro-thread-save!

              (lambda (current-thread mutex timeout new-owner)

                ;; check the state of the mutex
                (let ((owner (macro-btq-owner mutex)))
                  (cond ((or (##eq? owner (macro-mutex-state-not-abandoned))
                             (##eq? owner (macro-mutex-state-abandoned)))

                         ;; Mutex is unlocked, so lock it.

                         ;; acquire low-level locks of threads
                         (if new-owner
                             (##lock-2-threads! current-thread new-owner)
                             (macro-lock-thread! current-thread))

                         (let ((state
                                (if new-owner

                                    ;; check if new owner thread is terminated
                                    (if (macro-thread-end-condvar new-owner)

                                        (begin

                                          ;; Thread is not terminated.

                                          ;; thread becomes the mutex's owner
                                          (macro-btq-link! mutex new-owner)

                                          ;; release low-level lock of thread
                                          (if (##not (##eq? new-owner
                                                            current-thread))
                                              (macro-unlock-thread! new-owner))

                                          new-owner)

                                        (begin

                                          ;; Thread is terminated.

                                          ;; release low-level lock of thread
                                          (if (##not (##eq? new-owner
                                                            current-thread))
                                              (macro-unlock-thread! new-owner))

                                          ;; change the mutex's state to
                                          ;; abandoned
                                          (macro-btq-owner-set!
                                           mutex
                                           (macro-mutex-state-abandoned))

                                          (macro-mutex-state-abandoned)))

                                    (begin

                                      ;; change the mutex's state to not-owned
                                      (macro-btq-owner-set!
                                       mutex
                                       (macro-mutex-state-not-owned))

                                      (macro-mutex-state-not-owned)))))

                           ;; release low-level lock of current thread
                           (macro-unlock-thread! current-thread)

                           ;; release low-level lock of mutex
                           (macro-unlock-mutex! mutex)

                           ;; check if abandoned mutex exception needs
                           ;; to be raised
                           (if (##eq? state (macro-mutex-state-abandoned))
                               (##thread-abandoned-mutex-action!)
                               #t))) ;; signal success

                        ((##not timeout)

                         ;; Mutex is locked and timeout is already
                         ;; reached, so don't wait.

                         ;; release low-level lock of mutex
                         (macro-unlock-mutex! mutex)

                         #f) ;; signal failure

                        (else

                         ;; Mutex is locked, so current thread needs
                         ;; to wait on the blocked thread queue of the
                         ;; mutex.

                         ;; acquire low-level locks of threads
                         (if new-owner
                             (##lock-2-threads! current-thread new-owner)
                             (macro-lock-thread! current-thread))

                         ;;TODO: reenable
                         #;
                         (macro-thread-boost-and-clear-quantum-used!
                          current-thread)

                         ;; save new-owner in thread so that mutex-unlock!
                         ;; can use this information when thread ends waiting
                         (macro-thread-result-set!
                          current-thread
                          new-owner)

                         ;; add current thread to blocked thread queue
                         ;; of the mutex
                         (##thread-btq-insert! mutex current-thread)

                         ;; acquire low-level lock of processor
                         (macro-lock-current-processor!)

                         ;; thread is no longer the current thread
                         (macro-processor-current-thread-set!
                          (macro-current-processor)
                          #f)

                         ;; also add current thread to timeout queue
                         ;; if the lock operation is time-limited
                         (if (##not (##eq? timeout #t)) ;; finite timeout?
                             (begin

                               ;; save current thread's timeout
                               (macro-thread-timeout-set!
                                current-thread
                                timeout)

                               ;; add current thread to timeout queue
                               (##toq-insert!
                                (macro-current-processor)
                                current-thread)))

                         ;; by default resuming thread should return void
                         (macro-thread-resume-thunk-set!
                          current-thread
                          ##thread-void-action!)

                         ;; release low-level lock of new owner thread
                         (if (and new-owner
                                  (##not (##eq? new-owner
                                                current-thread)))
                             (macro-unlock-thread! new-owner))

                         ;; release low-level lock of current thread
                         (macro-unlock-thread! current-thread)

                         ;; release low-level lock of mutex
                         (macro-unlock-mutex! mutex)

                         ;; schedule next runnable thread
                         (##thread-schedule-with-acquired-processor!)))))

                        mutex
                        timeout
                        new-owner)))

        ;; When result is void, it means the scheduler woke up the
        ;; thread not because the lock was unlocked or the timeout
        ;; was reached, but because the thread needed to be
        ;; interrupted to perform some other work.  In this case
        ;; the lock operation must be restarted.

        (if (##eq? result (##void))

            (begin

              ;;(##c-code "printf(\"try-again\\n\");")

              ;; acquire low-level lock of mutex
              (macro-lock-mutex! mutex)

              (try-again))

            result)))))

(define-prim (##mutex-unlock-out-of-line! mutex first-thread)

  (##declare (not interrupts-enabled))

  ;; Assumes that the low-level lock of the mutex is acquired.

  ;; There is at least one thread waiting on the mutex, and
  ;; first-thread is the next in line to wake up.

  (let* ((new-owner (macro-thread-result first-thread)) ;; fetch saved new owner
         (x (macro-btq-owner mutex)) ;; get current owner if any
         (current-owner (and (macro-mutex-thread-owner? x) x)))

    ;; acquire low-level locks of first-thread, new-owner and current-owner
    (##lock-3-threads! first-thread new-owner current-owner)

    ;; remove mutex from the set of mutexes owned by the owner thread
    (if current-owner
        (macro-btq-deq-remove! mutex))

    ;; remove first-thread from mutex's blocked thread queue
    (##thread-btq-remove! first-thread)

    ;; if first-thread was blocked doing a time limited mutex-lock! then
    ;; remove it from the timeout queue
    (macro-thread-toq-remove-if-in-toq! first-thread)

    (if new-owner

        (begin

          ;; The mutex-lock! operation specified a new-owner thread.

          ;; check if the new-owner thread terminated
          (if (macro-thread-end-condvar new-owner)

              (begin

                ;; The new-owner thread is not terminated.

                ;; new-owner becomes the mutex's owner
                (macro-btq-link! mutex new-owner)

                ;; the new-owner inherits the priority of the thread
                ;; that is next in line to wake up on the mutex
                ;;TODO: reenable
                #;
                (macro-if-btq-next
                mutex
                new-next-thread
                (macro-thread-inherit-priority! new-owner new-next-thread))

                (macro-thread-resume-thunk-set!
                 first-thread
                 ##thread-locked-mutex-action!))

              (begin

                ;; The new-owner thread is terminated.

                ;; change mutex state to unlocked/abandoned
                (macro-btq-unlink! mutex (macro-mutex-state-abandoned))

                (macro-thread-resume-thunk-set!
                 first-thread
                 ##thread-abandoned-mutex-action!))))

        (begin

          ;; The mutex-lock! operation did not specify a new-owner thread.

          ;; change mutex state to locked/not-owned
          (macro-btq-unlink! mutex (macro-mutex-state-not-owned))

          (macro-thread-resume-thunk-set!
           first-thread
           ##thread-locked-mutex-action!)))

    (macro-add-thread-to-run-queue-of-current-processor-preferably! first-thread)

    ;;TODO: this seems slower
    #;(macro-add-thread-to-run-queue-of-some-processor! first-thread)

    ;; release low-level locks of first-thread, new-owner and current-owner
    (##unlock-3-threads! first-thread new-owner current-owner)

    ;; release low-level lock of mutex
    (macro-unlock-mutex! mutex)

    (##void)))

(define-prim (##mutex-signal! mutex thread abandoned?)

  (##declare (not interrupts-enabled))

  ;; Assumes that the low-level locks of the mutex and thread are acquired.

  (##mutex-signal-no-reschedule! mutex thread abandoned?)

  ;; check if the call to ##mutex-signal-no-reschedule! caused a
  ;; higher priority thread to become runnable

  ;;TODO: fix me
  #;
  (macro-thread-reschedule-if-needed!))

(define-prim (##mutex-signal-no-reschedule! mutex thread abandoned?)

  (##declare (not interrupts-enabled))

  ;; Assumes that the low-level locks of the mutex and thread are acquired.

  ;;TODO: review
  ;;(##c-code "printf(\"transferring mutex to thread %p\\n\",(void*)___ARG1);" thread);;TODO:remove

  ;; remove thread from mutex's blocked thread queue
  (##thread-btq-remove! thread)

  (macro-btq-owner-set! mutex (macro-mutex-state-not-owned))

  (let ((new-owner (macro-thread-result thread))) ;; fetch saved new owner
    (if new-owner

        (begin

          ;; the mutex-lock! operation specified a new-owner thread

          (if (##not (##eq? new-owner thread))
              (let loop ()
                (if (##not (macro-trylock-thread! new-owner))
                    (loop))));; TODO: trylock?

          ;; is the new-owner thread terminated?
          (if (macro-thread-end-condvar new-owner)

              (begin

                ;; the new-owner thread is not terminated

                ;; new-owner becomes the mutex's owner
                (macro-btq-link! mutex new-owner)

                ;; the new-owner inherits the priority of the thread
                ;; that is next in line to wake up on the mutex
                ;;TODO: reenable
                #;
                (macro-if-btq-next
                mutex
                new-next-thread
                (macro-thread-inherit-priority! new-owner new-next-thread)))

              (begin

                ;; the new-owner thread is terminated

                ;; change mutex state to unlocked/abandoned
                (macro-btq-unlink! mutex (macro-mutex-state-abandoned))))

          (if (##not (##eq? new-owner thread))
              (macro-unlock-thread! new-owner)))

        (begin

          ;; the mutex-lock! operation did not specify a new-owner thread

          ;; change mutex state to locked/not-owned
          (macro-btq-unlink! mutex (macro-mutex-state-not-owned)))))

  ;; release low-level lock of mutex
  (macro-unlock-mutex! mutex)

  (macro-thread-result-set! thread #f)

  (macro-thread-resume-thunk-set!
   thread
   (if abandoned?
       ##thread-abandoned-mutex-action!
       ##thread-locked-mutex-action!))

  ;; if thread was blocked doing a time limited mutex-lock! then
  ;; remove it from the timeout queue
  (macro-thread-toq-remove-if-in-toq! thread)

  (macro-add-thread-to-run-queue-of-current-processor-preferably! thread)

  ;; release low-level lock of thread
  (macro-unlock-thread! thread))

(define-prim (##mutex-signal-and-condvar-wait! mutex condvar timeout)

  (##declare (not interrupts-enabled))

  ;; acquire low-level lock of condition variable
  (macro-lock-condvar! condvar)

  (if timeout

      (let ((result
             (macro-thread-save!
              (lambda (current-thread mutex condvar timeout)

                ;; acquire low-level lock of the current thread
                (macro-lock-thread! current-thread)

                ;;TODO: reenable
                #;
                (macro-thread-boost-and-clear-quantum-used!
                 current-thread)

                ;; add current thread to blocked thread queue
                ;; of the condition variable
                (##thread-btq-insert! condvar current-thread)

                ;; acquire low-level lock of processor
                (macro-lock-current-processor!)

                ;; thread is no longer the current thread
                (macro-processor-current-thread-set!
                 (macro-current-processor)
                 #f)

                ;; also add current thread to timeout queue
                ;; if the lock operation is time-limited
                (if (##not (##eq? timeout #t)) ;; finite timeout?
                    (begin

                      ;; save current thread's timeout
                      (macro-thread-timeout-set!
                       current-thread
                       timeout)

                      ;; add current thread to timeout queue
                      (##toq-insert!
                       (macro-current-processor)
                       current-thread)))

                ;; release low-level lock of processor
                (macro-unlock-current-processor!)

                ;; by default resuming thread should return void
                (macro-thread-resume-thunk-set!
                 current-thread
                 ##thread-void-action!)

                ;; release low-level lock of the current thread
                (macro-unlock-thread! current-thread)

                ;; release low-level lock of condition variable
                (macro-unlock-condvar! condvar)

                ;; unlock mutex
                (macro-mutex-unlock-no-reschedule! mutex)

                ;; schedule next runnable thread
                (##thread-schedule!))
              mutex
              condvar
              timeout)))
        (if (##eq? result (##void))
            #t ;; abort wait when interrupted
            result))

      (begin

        ;; release low-level lock of condition variable
        (macro-unlock-condvar! condvar)

        ;; unlock mutex
        (macro-mutex-unlock-no-reschedule! mutex)

        ;;TODO:reenable
        ;;(macro-thread-reschedule-if-needed!)

        #f)))

(define-prim (##wait-for-io! condvar timeout)

  (##declare (not interrupts-enabled))

  (if timeout

      (let ((result
             (macro-thread-save!
              (lambda (current-thread condvar timeout)

                ;; acquire low-level lock of condition variable
                (macro-lock-condvar! condvar)

                ;; acquire low-level lock of current thread
                (macro-lock-current-thread!)

                (macro-thread-resume-thunk-set!
                 current-thread
                 ##thread-void-action!)

                ;;TODO: reenable
                #;
                (macro-thread-boost-and-clear-quantum-used!
                current-thread)

                (##thread-btq-insert! condvar current-thread)

                ;; acquire low-level lock of processor
                (macro-lock-current-processor!)

                ;; thread is no longer the current thread
                (macro-processor-current-thread-set!
                 (macro-current-processor)
                 #f)

                (if (##not (##eq? timeout #t))
                    (begin

                      (macro-thread-timeout-set!
                       current-thread
                       timeout)

                      ;; add current thread to timeout queue
                      (##toq-insert!
                       (macro-current-processor)
                       current-thread)))

                ;; add condvar to the set of devices being monitored
                ;; by this processor, if it isn't already being
                ;; monitored
                (if (##eq? (macro-btq-deq-prev condvar) condvar)
                    (macro-btq-deq-insert-at-tail!
                     (macro-current-processor)
                     condvar))

                ;; release low-level lock of current thread
                (macro-unlock-thread! current-thread)

                ;; release low-level lock of condition variable
                (macro-unlock-condvar! condvar)

                ;; schedule next runnable thread
                (##thread-schedule-with-acquired-processor!))
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

  ;; Assumes that exclusive access to the processor has been acquired.

  (macro-btq-deq-remove! condvar)
  (macro-btq-deq-init! condvar)

  (##condvar-signal-no-reschedule! condvar #t))

;;;----------------------------------------------------------------------------

;;; Implementation of condition variables.

(define-prim (make-condition-variable #!optional (n (macro-absent-obj)))

  (##declare (not interrupts-enabled))

  (macro-force-vars (n)
    (let ((name
           (if (##eq? n (macro-absent-obj))
             (##void)
             n)))
      (##make-condvar name))))

(define-prim (##make-condvar name)

  (##declare (not interrupts-enabled))

  (macro-make-condvar name))

(define-prim (condition-variable? obj)

  (##declare (not interrupts-enabled))

  (macro-force-vars (obj)
    (macro-condvar? obj)))

(define-prim (##condvar-signal! condvar broadcast?)
  (##declare (not interrupts-enabled))
  (##condvar-signal-no-reschedule! condvar broadcast?)
  (macro-thread-reschedule-if-needed!))

(define-prim (##condvar-signal-no-reschedule! condvar broadcast?)

  (##declare (not interrupts-enabled))
  ;;(##c-code "printf(\"##condvar-signal-no-reschedule!\\n\");") ;;TODO:remove

  ;; acquire low-level lock of condvar
  (macro-lock-condvar! condvar)

  (let loop ()
    (macro-if-btq-next
     condvar
     next-thread

     (begin
       ;;(##c-code "printf(\"waking up thread\\n\");") ;;TODO:remove

       ;; acquire low-level lock of thread
       (macro-lock-thread! next-thread)

       (macro-thread-resume-thunk-set!
        next-thread
        ##thread-signaled-condvar-action!)

       (##thread-btq-remove! next-thread)
       (macro-thread-toq-remove-if-in-toq! next-thread)

       (macro-add-thread-to-run-queue-of-current-processor-preferably! next-thread)

       ;; release low-level lock of thread
       (macro-unlock-thread! next-thread)

       (if broadcast?
           (loop)
           (begin

             ;; release low-level lock of condvar
             (macro-unlock-condvar! condvar)

             (##void))))

     (begin

       ;; release low-level lock of condvar
       (macro-unlock-condvar! condvar)

       (##void)))))

;;;----------------------------------------------------------------------------

;;; Implementation of thread groups.

(define-prim (make-thread-group
              #!optional
              (n (macro-absent-obj))
              (p (macro-absent-obj)))

  (##declare (not interrupts-enabled))

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

(##define-macro (macro-current-time-point)
  `(begin
     (macro-update-current-time!)
     (macro-current-time (macro-thread-floats (macro-current-processor)))))

(define-prim (##current-time-point)
  (macro-current-time-point))

(define-prim (##current-time)
  (macro-make-time (macro-current-time-point) #f #f #f))

(define-prim (current-time)
  (##current-time))

(define-prim (##time? obj)
  (macro-time? obj))

(define-prim (time? obj)
  (macro-time? obj))

(define-prim (##time->seconds t)
  (macro-time-point t))

(define-prim (time->seconds t)
  (macro-force-vars (t)
    (macro-check-time t 1 (time->seconds t)
      (macro-time-point t))))

(define-prim (##seconds->time s)
  (macro-make-time (macro-real->inexact s) #f #f #f))

(define-prim (seconds->time s)
  (macro-force-vars (s)
    (macro-check-real s 1 (seconds->time s)
      (##seconds->time s))))

(define-prim (timeout->time absrel-timeout)
  (macro-force-vars (absrel-timeout)
    (##timeout->time absrel-timeout)))

(define-prim (current-second)
  (macro-current-time-point))

(define-prim (current-jiffy)
  (macro-update-current-time!)
  (##inexact->exact (##flround (##fl* 1e6 (macro-current-time-point)))))

(define-prim (jiffies-per-second)
  1000000)

;;;----------------------------------------------------------------------------

;;; User accessible primitives for threads.

;;TODO:deprecated
(define-prim (thread-suspend! thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-suspend! thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-suspend! thread)
          (begin
            (macro-unlock-thread! thread)
            (##thread-suspend! thread)))))))

;;TODO:deprecated
(define-prim (thread-resume! thread)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-resume! thread)
      (begin
        (macro-lock-thread! thread)
        (macro-check-initialized-thread thread (thread-resume! thread)
          (begin
            (macro-unlock-thread! thread)
            (##thread-resume! thread)))))))

;;;----------------------------------------------------------------------------

;;; User accessible primitives for condition variables

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

(define-prim (thread-group-name tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-name tgroup)
      (macro-tgroup-name tgroup))))

(define-prim (thread-group-parent tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-parent tgroup)
      (macro-tgroup-parent tgroup))))

(define-prim (thread-group-specific tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-specific tgroup)
      (macro-tgroup-specific tgroup))))

(define-prim (thread-group-specific-set! tgroup obj)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-specific-set! tgroup obj)
      (begin
        (macro-tgroup-specific-set! tgroup obj)
        (##void)))))

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

(define-prim (##with-exception-handler handler thunk)
  (macro-dynamic-bind exception-handler
   handler
   thunk))

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

(define (##r7rs-with-exception-handler handler thunk)
  (let ((original-eh (macro-current-exception-handler)))
    (macro-dynamic-bind
     exception-handler
     (lambda (exc)
       (macro-dynamic-bind
        exception-handler
        original-eh
        (lambda ()
          (handler exc))))
     thunk)))

(define-prim (r7rs-with-exception-handler handler thunk)
  (macro-force-vars (handler thunk)
    (macro-check-procedure handler 1 (r7rs-with-exception-handler handler thunk)
      (macro-check-procedure thunk 2 (r7rs-with-exception-handler handler thunk)
        (##r7rs-with-exception-handler handler thunk)))))

(define (##r7rs-with-exception-catcher handler thunk)
  (##continuation-capture
   (lambda (cont)
     (macro-dynamic-bind
      exception-handler
      (lambda (exc)
        (##continuation-capture
         (lambda (reraise-cont)
           (##continuation-graft cont handler exc reraise-cont))))
      thunk))))

(define (##r7rs-reraise exc cont)
  (let ((original-eh (macro-current-exception-handler)))
    (##continuation-graft
     cont
     (lambda ()
       (macro-dynamic-bind
        exception-handler
        original-eh
        (lambda ()
          (##raise exc)))))))

(define (##r7rs-raise exc) ;; raise noncontinuable exception
  (##abort exc))

(define-prim (r7rs-raise exc)
  (##r7rs-raise exc))

(define (##r7rs-raise-continuable exc) ;; raise continuable exception
  (##raise exc))

(define-prim (r7rs-raise-continuable exc)
  (##r7rs-raise-continuable exc))

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

(define call/cc call-with-current-continuation)
(##global-var-primitive-set! (##make-global-var 'call/cc) call/cc)

(define ##initial-dynwind
  '#(0)) ;; only the "level" field is needed

(define-prim (##list->values lst)
  (let loop1 ((x lst) (n 0))
    (if (##pair? x)
        (loop1 (##cdr x) (##fx+ n 1))
        (let ((vals (##make-values n)))
          (let loop2 ((x lst) (i 0))
            (if (and (##pair? x)  ;; double check in case another
                     (##fx< i n)) ;; thread mutates the list
                (let ((elem (##car x)))
                  (##values-set! vals i elem)
                  (loop2 (##cdr x) (##fx+ i 1)))
                vals))))))

(define-prim (##values->list vals)
  (let ((start 0)
        (end (##values-length vals)))
    (let loop ((lst '()) (i (##fx- end 1)))
      (if (##fx< i start)
          lst
          (loop (##cons (##values-ref vals i) lst) (##fx- i 1))))))

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
         (##list->values
          (##cons val1 (##cons val2 (##cons val3 others)))))))

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
         (##list->values
          (##cons val1 (##cons val2 (##cons val3 others)))))))

(define-prim (##call-with-values producer consumer)
  (let ((results ;; may get bound to a multiple-values object
         (producer)))
    (if (##not (##values? results))
        (consumer results)
        (let ((len (##values-length results)))
          (cond ((##fx= len 2)
                 (consumer (##values-ref results 0)
                           (##values-ref results 1)))
                ((##fx= len 3)
                 (consumer (##values-ref results 0)
                           (##values-ref results 1)
                           (##values-ref results 2)))
                ((##fx= len 0)
                 (consumer))
                (else
                 (##apply consumer (##values->list results))))))))

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
            (##list->values
             (##cons val1 (##cons val2 (##cons val3 others))))))))

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
      (macro-if-auto-forcing
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

(define ##tcp-service-table (##make-table-aux))
(define ##tcp-service-mutex (##make-mutex 'tcp-service))
(define ##tcp-service-tgroup (##make-tgroup 'tcp-service #f))

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
   (lambda (psettings-and-address-and-port-number)
     (let* ((psettings
             (##vector-ref psettings-and-address-and-port-number 0))
            (local-address
             (##vector-ref psettings-and-address-and-port-number 1))
            (local-port-number
             (##vector-ref psettings-and-address-and-port-number 2))
            (local-address-and-local-port-number
             (##cons local-address local-port-number)))
       (##tcp-service-update! local-address-and-local-port-number
                              #f)
       (##open-tcp-server-aux
        #t
        psettings-and-address-and-port-number
        (lambda (server-port)
          (let ((new-thread
                 (##make-root-thread
                  (lambda () (##tcp-service-serve server-port thunk tgroup))
                  local-address-and-local-port-number
                  ##tcp-service-tgroup
                  ##stdin-port
                  ##stdout-port)))
            (##tcp-service-update! local-address-and-local-port-number
                                   (##cons server-port new-thread))
            (##thread-start! new-thread)
            new-thread))
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
   (lambda (psettings-and-address-and-port-number)
     (let* ((psettings
             (##vector-ref psettings-and-address-and-port-number 0))
            (local-address
             (##vector-ref psettings-and-address-and-port-number 1))
            (local-port-number
             (##vector-ref psettings-and-address-and-port-number 2))
            (local-address-and-local-port-number
             (##cons local-address local-port-number)))
       (##tcp-service-update! local-address-and-local-port-number #f)
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

(define ##user-interrupt-pending? #f)

(define-prim (##defer-user-interrupts)
   (##declare (not interrupts-enabled))
   (set! ##user-interrupt-pending? #t)
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
         (if (##not (##eq? val ##defer-user-interrupts))
             (let ((int? ##user-interrupt-pending?))
               (set! ##user-interrupt-pending? #f)
               (if int?
                   (val))))
         val)))))

(define current-user-interrupt-handler
  ##current-user-interrupt-handler)

(define-prim (##user-interrupt!)

  (##declare (not interrupts-enabled))

  (##interrupt-some-thread-async! ##handle-user-interrupt!))

(define-prim (##handle-user-interrupt!)

  (##declare (not interrupts-enabled))

  ;;TODO: add the following procedures to ##hidden-continuation?
  ;;  ##other-interrupt!
  ;;  ##interrupt-handler
  ;;  ##thread-resume-execution!

  (let ((handler (##current-user-interrupt-handler)))
    (if (##procedure? handler)
        (let ()
          (##declare (not safe)) ;; avoid procedure check on the call
          (handler)))))

(##startup-threading!)

;;;============================================================================

) (else

;;;============================================================================

;;; Non-SMP thread scheduler.

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
(implement-check-type-vm)
(implement-check-type-processor)
(implement-check-type-thread)
(implement-check-type-mutex)
(implement-check-type-condvar)
(implement-check-type-tgroup)

;;;----------------------------------------------------------------------------

(implement-type-vm)
(implement-type-processor)
(implement-type-thread)
(implement-type-mutex)
(implement-type-condvar)
(implement-type-tgroups)
(implement-type-tgroup)

(implement-library-type-thread-state-uninitialized)
(implement-library-type-thread-state-initialized)
(implement-library-type-thread-state-normally-terminated)
(implement-library-type-thread-state-abnormally-terminated)
(implement-library-type-thread-state-waiting)
(implement-library-type-thread-state-running)

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

(define ##initial-current-directory-saved
  (let ((current-dir
         (##os-path-normalize-directory #f)))
    (if (##fixnum? current-dir)
        (##exit-with-err-code current-dir)
        current-dir)))

(define-prim (##current-directory-set-filter val)
  (if (##eq? val (macro-absent-obj))
      ##initial-current-directory-saved
      (macro-check-string val 1 (##current-directory val)
        (##path-normalize-directory-existing val))))

(define ##initial-current-directory
  (##make-parameter
   (macro-absent-obj)
   ##current-directory-set-filter))

(define initial-current-directory
  ##initial-current-directory)

(define-prim (##path-normalize-directory-existing path)
  (let ((normalized-dir
         (##os-path-normalize-directory (##path-expand path))))
    (if (##fixnum? normalized-dir)
        (##raise-os-exception #f normalized-dir ##current-directory path)
        normalized-dir)))

(define ##current-directory
  (##make-parameter
   (macro-absent-obj)
   ##current-directory-set-filter))

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

(define-prim (##parameterize1 param val thunk)
  (##declare (not interrupts-enabled))
  (macro-check-procedure param 1 (##parameterize1 param val thunk)
    (macro-check-procedure thunk 3 (##parameterize1 param val thunk)
      (if (##parameter? param)
        (##dynamic-let
         param
         (let ((descr (macro-parameter-descr param)))
           ((macro-parameter-descr-set-filter descr) val))
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
                         (let ((descr (macro-parameter-descr param)))
                           (macro-parameter-descr-value descr)))))))))))))

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
                         (let ((descr (macro-parameter-descr param)))
                           (macro-parameter-descr-value-set! descr val)
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
                 (macro-thread-floats (macro-current-processor))))
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
                          (macro-thread-floats (macro-current-processor)))))
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
                   (macro-thread-floats (macro-current-processor)))))
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

;;; Implementation of blocked thread queues and timeout queues.

(implement-btq) ;; defines ##btq-insert!, etc
(implement-toq) ;; defines ##toq-insert!, etc

;;;----------------------------------------------------------------------------

;;;for debugging
;;(define ##thread-trace 0)
(define-macro (thread-trace n expr)
  expr #;
  `(begin (set! ##thread-trace (##fx+ ,n (##fx* (##fxmodulo ##thread-trace 10000000) 10))) ,expr))

(define-prim (##btq-abandon! btq)
  (##declare (not interrupts-enabled))
  (##primitive-lock! btq 1 9)
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
          (##primitive-unlock! btq 1 9))))))

;;;----------------------------------------------------------------------------

;;; Implementation of threads.

(define-prim (##current-thread))
(define-prim (##current-processor))
(define-prim (##current-processor-id))
(define-prim (##processor id))
(define-prim (##current-vm))

(define-prim (##primitive-lock! btq i j))
(define-prim (##primitive-trylock! btq i j))
(define-prim (##primitive-unlock! btq i j))

(define-prim (##object-before? x y))

(define-prim (##thread thunk)
  (##declare (not interrupts-enabled))
  (##thread-start! (##make-thread thunk)))

(define-prim (##make-thread
              thunk
              #!optional
              (name (##void))
              (tgroup (macro-thread-tgroup (macro-current-thread))))
  (##declare (not interrupts-enabled))
  (macro-make-thread thunk name tgroup))

(define-prim (##thread-start! thread)
  (##declare (not interrupts-enabled))
  (macro-thread-exception?-set! thread #f)
  (##btq-insert! (macro-current-processor) thread)
  (macro-thread-reschedule-if-needed!)
  thread)

(define-prim (##thread-base-priority-set! thread base-priority)

  (##declare (not interrupts-enabled))

  (let ((floats (macro-thread-floats thread)))

    ;; save old boosted priority for ##thread-boosted-priority-changed!

    (macro-temp-set!
     (macro-thread-floats (macro-current-processor))
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
         (macro-thread-floats (macro-current-processor))
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
            (macro-temp (macro-thread-floats (macro-current-processor))))
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
     (macro-thread-floats (macro-current-processor))
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
                (macro-temp (macro-thread-floats (macro-current-processor)))
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

  (let ((current-processor (macro-current-processor)))
    (if (##not (##eq? (macro-toq-leftmost current-processor) current-processor))
        (begin

          (macro-update-current-time!)

          (let loop ()
            (let ((leftmost (macro-toq-leftmost current-processor)))
              (if (and (##not (##eq? leftmost current-processor))
                       (##not (macro-thread-sooner? current-processor leftmost)))
                  (begin
                    (macro-thread-resume-thunk-set! leftmost ##thread-timeout-action!)
                    (macro-thread-btq-remove-if-in-btq! leftmost)
                    (##thread-toq-remove! leftmost)
                    (##btq-insert! current-processor leftmost)
                    (loop)))))))))

(define-prim (##thread-check-devices! timeout)

  (##declare (not interrupts-enabled))

  (##primitive-lock! (macro-current-processor) 1 9)
  (let ((code (##os-condvar-select! (macro-current-processor) timeout)))
    (##primitive-unlock! (macro-current-processor) 1 9)
    (let loop ((condvar (macro-btq-deq-next (macro-current-processor))))
      (if (##eq? condvar (macro-current-processor))
        code
        (let ((next (macro-btq-deq-next condvar)))
          (if (##fxodd? (macro-btq-owner condvar))
            (##device-condvar-broadcast-no-reschedule! condvar))
          (loop next))))))

(define-prim (##thread-poll-devices!)

  (##declare (not interrupts-enabled))

  (let ((current-processor (macro-current-processor)))
    (if (##eq? (macro-btq-deq-next current-processor) current-processor) ;; no devices?
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

    (let* ((current-processor-floats ;; to get heartbeat interval
            (macro-thread-floats (macro-current-processor)))
           (current-thread-floats ;; to get current thread's quantum used
            (macro-thread-floats (macro-current-thread)))
           (heartbeat-interval
            (macro-get-heartbeat-interval current-processor-floats))
           (quantum-used
            (##fl+ (macro-quantum-used current-thread-floats)
                   heartbeat-interval)))

      (macro-quantum-used-set! current-thread-floats quantum-used)

      (if (##fl< quantum-used
                 (macro-quantum current-thread-floats))
        (macro-thread-reschedule-if-needed!)
        (##thread-yield!)))))

(define-prim (##thread-yield!)

  (##declare (not interrupts-enabled))

  (let* ((current-thread
          (macro-current-thread))
         (current-processor
          (macro-current-processor)))
    (if (##eq? (macro-btq-singleton? current-processor) current-thread)
      (begin
        ;; fast case where only one thread is runnable
        (macro-thread-unboost-and-clear-quantum-used! current-thread)
        (##void))
      (macro-thread-save!
       (lambda (current-thread)
         (##btq-remove! current-thread)
         (macro-thread-unboost-and-clear-quantum-used! current-thread)
         (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
         (##btq-insert! (macro-current-processor) current-thread)
         (##thread-schedule!))))))

(define-prim (##thread-reschedule!)

  (##declare (not interrupts-enabled))

  (macro-thread-save!
   (lambda (current-thread)
     (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
     (##thread-schedule!))))

(define-prim (##thread-sleep! absrel-timeout)

  (##declare (not interrupts-enabled))

  (let ((timeout (##absrel-timeout->timeout absrel-timeout)))
    (if timeout
      (let loop ()
        (let ((result
               (macro-thread-save!
                (lambda (current-thread timeout)
                  (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
                  (##btq-remove! current-thread)
                  (macro-thread-unboost-and-clear-quantum-used!
                   current-thread)
                  (if (##not (##eq? timeout #t))
                    (begin
                      (macro-thread-timeout-set! current-thread timeout)
                      (##toq-insert! (macro-current-processor) current-thread)))
                  (##thread-schedule!))
                timeout)))
          (if (##eq? result (##void))
            (loop)
            (##void))))
      (##void))))

(define-prim (##thread-resume-execution!)

  (##declare (not interrupts-enabled))

  (let ((resume-thunk (macro-thread-resume-thunk (macro-current-thread))))
    (let loop ()
      (macro-thread-interrupts-remove-from-head!
       interrupt
       (let ((proc (##vector-ref interrupt 1)))
         (proc interrupt)
         (loop))
       (resume-thunk)))))

(define-prim (##thread-schedule!)

  (##declare (not interrupts-enabled))

  (let ((current-processor
         (macro-current-processor)))

    ;; check if there are runnable threads

    (let ((next-thread
           (macro-btq-leftmost current-processor)))
      (if (##not (##eq? next-thread current-processor))

        ;; there are runnable threads, so continue executing the next
        ;; runnable thread

        (macro-thread-restore!
         next-thread
         ##thread-resume-execution!)

        ;; there are no runnable threads, so check if there are threads
        ;; waiting for a timeout or for a device to become ready

        (let ((next-sleeper
               (macro-toq-leftmost current-processor))
              (next-condvar
               (macro-btq-deq-next current-processor)))
          (if (or (##not (##eq? next-sleeper current-processor))
                  (##not (##eq? next-condvar current-processor)))

            ;; wait for the next timeout or for a device to become ready

            (let ((code
                   (##thread-check-devices!
                    (if (##eq? next-sleeper current-processor)
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
                            (macro-btq-leftmost current-processor)))
                       (if (##eq? next-thread current-processor)

                         ;; no thread is currently runnable, so wake up
                         ;; a thread that is sleeping or waiting on a
                         ;; device

                         (let ((next-sleeper
                                (macro-toq-leftmost current-processor)))
                           (if (##not (##eq? next-sleeper current-processor))

                             ;; a thread was sleeping so make it
                             ;; temporarily wake up so that it detects
                             ;; the interrupt (after the interrupt is
                             ;; processed the thread will resume
                             ;; sleeping)

                             (##thread-int!
                              next-sleeper
                              ##thread-check-interrupts!)

                             (let ((next-condvar
                                    (macro-btq-deq-next current-processor)))
                               (if (##not (##eq? next-condvar current-processor))

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
           (if (##eq? act ##user-interrupt!)
               (begin
                 (##thread-int! thread
                                (lambda () (##user-interrupt!) (##void)))
                 (##void))
               (##thread-call thread act))))))

(define-prim (##thread-int! thread thunk-returning-void)

  (##declare (not interrupts-enabled))

  ;; Note: the thunk-returning-void procedure must return void in
  ;; order to restart the interrupted thread properly.

  ;; remove the thread from any blocked thread queue and
  ;; timeout queue it is in

  (macro-thread-btq-remove-if-in-btq! thread)
  (macro-thread-toq-remove-if-in-toq! thread)

  (macro-thread-interrupts-insert-at-tail!
   thread
   (##vector '()
             (lambda (self) ((##vector-ref self 2)))
             thunk-returning-void))

  (##btq-insert! (macro-current-processor) thread))

(define-prim (##thread-continuation-capture thread)
  (##thread-call
   thread
   (lambda ()
     (##continuation-capture (lambda (k) k)))))

(define-prim (##thread-call thread thunk)
  (let ((result-mutex (macro-make-mutex 'thread-call-result)))
    (##check-heap-limit) ;; prevent GC while mutex is locked
    (macro-mutex-lock! result-mutex #f thread)
    (##thread-int!
     thread
     (lambda ()
       (let ((result (thunk)))
         (macro-mutex-specific-set! result-mutex result)
         (macro-mutex-unlock! result-mutex)
         (##void))))
    (macro-mutex-lock! result-mutex #f (macro-current-thread))
    (macro-mutex-specific result-mutex)))

(define-prim (##thread-execute-and-end! thunk)

  (##declare (not interrupts-enabled))

  (let ((result (thunk)))
    (##thread-end! (macro-current-thread) #f result)))

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

(define (##primordial-exception-handler-hook-set! handler)
  (set! ##primordial-exception-handler-hook handler))

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
                                   (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
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
                                        (macro-current-processor)
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
              #!optional
              (name (##void))
              (tgroup (macro-thread-tgroup ##primordial-thread))
              (input-port ##stdin-port)
              (output-port ##stdout-port))

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

  (##declare (not interrupts-enabled))

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

(define (##startup-processor!)

  (declare (not interrupts-enabled))

  (macro-processor-init! (##current-processor) (##current-processor-id))
  (##primitive-unlock! (##current-processor) 1 9)

  (let* ((tgroup
          (##make-tgroup 'local #f))
         (thread
          (##make-root-thread #f 'local tgroup)))

    (macro-processor-current-thread-set!
     (macro-current-processor)
     thread)

    (##btq-insert! (macro-current-processor) thread)
    )

  (##enable-interrupts!)

  (let loop ()
    (declare (interrupts-enabled))
    (##os-condvar-select! #f #t) ;; wait for interrupt
    (loop)))

(define (##cvmr n)
  (##current-vm-resize ##startup-processor! n))

(define (##startup-parallelism!)
  (let* ((level
          (##get-parallelism-level))
         (nb-procs
          (if (##fx> level 0) level (##fx+ (##cpu-count) level))))
    (if (##fx> nb-procs 1)
        (##cvmr nb-procs))))

(define-prim (##startup-threading!)

  (##declare (not interrupts-enabled))

  (macro-vm-init! (##current-vm))
  (##primitive-unlock! (##current-vm) 1 9)

  (macro-processor-init! (##current-processor) (##current-processor-id))
  (##primitive-unlock! (##current-processor) 1 9)

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

    (macro-thread-exception?-set! primordial-thread #f)

    (macro-processor-current-thread-set!
     (macro-current-processor)
     primordial-thread)

    (##btq-insert! (macro-current-processor) primordial-thread)

    (set! ##primordial-thread primordial-thread)

    (##interrupt-vector-set! 2 ##thread-heartbeat!) ;; ___INTR_HEARTBEAT

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

    (##set-heartbeat-interval! (macro-default-heartbeat-interval))

    (##void)))

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
                  (let ()
                    (declare (interrupts-enabled))
                    result))
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
    (##check-heap-limit) ;; prevent GC while mutex is locked
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
                    (##primitive-lock! mutex 1 9)
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
                            (##primitive-unlock! mutex 1 9)
                            (if (##eq? owner (macro-mutex-state-not-abandoned))
                                #t
                                (##thread-abandoned-mutex-action!)))

                          (begin
                            (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
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
                                   (macro-current-processor)
                                   current-thread)))
                            (macro-btq-owner-set! mutex owner)
                            (##primitive-unlock! mutex 1 9)
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

  (##primitive-unlock! mutex 1 9)

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

  (macro-thread-result-set! thread #f)

  (macro-thread-resume-thunk-set!
   thread
   (if abandoned?
       ##thread-abandoned-mutex-action!
       ##thread-locked-mutex-action!))

  (macro-thread-toq-remove-if-in-toq! thread)

  (##btq-insert! (macro-current-processor) thread))

(define-prim (##mutex-signal-and-condvar-wait! mutex condvar timeout)

  (##declare (not interrupts-enabled))

  (if timeout
    (let ((result
           (macro-thread-save!
            (lambda (current-thread mutex condvar timeout)
              (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)

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
                   (macro-current-processor)
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
              (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
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
                   (macro-current-processor)
                   current-thread)))
              (macro-btq-deq-remove! condvar)
              (macro-btq-deq-insert-at-tail! (macro-current-processor) condvar)
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
          (macro-thread-resume-thunk-set!
           leftmost
           ##thread-signaled-condvar-action!)
          (thread-trace 9 (##thread-btq-remove! leftmost))
          (macro-thread-toq-remove-if-in-toq! leftmost)
          (##btq-insert! (macro-current-processor) leftmost)
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

(##define-macro (macro-current-time-point)
  `(begin
     (macro-update-current-time!)
     (macro-current-time (macro-thread-floats (macro-current-processor)))))

(define-prim (##current-time-point)
  (macro-current-time-point))

(define-prim (##current-time)
  (macro-make-time (macro-current-time-point) #f #f #f))

(define-prim (current-time)
  (##current-time))

(define-prim (##time? obj)
  (macro-time? obj))

(define-prim (time? obj)
  (macro-time? obj))

(define-prim (##time->seconds t)
  (macro-time-point t))

(define-prim (time->seconds t)
  (macro-force-vars (t)
    (macro-check-time t 1 (time->seconds t)
      (macro-time-point t))))

(define-prim (##seconds->time s)
  (macro-make-time (macro-real->inexact s) #f #f #f))

(define-prim (seconds->time s)
  (macro-force-vars (s)
    (macro-check-real s 1 (seconds->time s)
      (##seconds->time s))))

(define-prim (timeout->time absrel-timeout)
  (macro-force-vars (absrel-timeout)
    (##timeout->time absrel-timeout)))

(define-prim (current-second)
  (macro-current-time-point))

(define-prim (current-jiffy)
  (macro-update-current-time!)
  (##inexact->exact (##flround (##fl* 1e6 (macro-current-time-point)))))

(define-prim (jiffies-per-second)
  1000000)

;;;----------------------------------------------------------------------------

;; The procedure current-processor returns the processor executing the
;; current thread.

(define-prim (current-processor)

  (##declare (not interrupts-enabled))

  (macro-current-processor))

;;;----------------------------------------------------------------------------

;; The procedure processor? returns #t when the parameter is a processor
;; and #f otherwise.

(define-prim (processor? obj)

  (##declare (not interrupts-enabled))

  (macro-force-vars (obj)
    (macro-processor? obj)))

;;;----------------------------------------------------------------------------

;; The procedure processor-id returns the integer id of the processor
;; (0, 1, ...).

(define-prim (processor-id processor)

  (##declare (not interrupts-enabled))

  (macro-force-vars (processor)
    (macro-check-processor processor 1 (processor-id processor)
      (macro-processor-id processor))))

(define-prim (##other-interrupt!)

  (##declare (not interrupts-enabled))

  ;; This procedure is called by a processor to handle the processor's
  ;; high-level interrupts (generated from Scheme code).

  (let loop ()
    (let ((interrupt
           (macro-processor-interrupts-head (macro-current-processor))))
      (if (##null? interrupt)
          #f
          (let ((next (##vector-ref interrupt 0)))
            (macro-processor-interrupts-head-set!
             (macro-current-processor)
             next)
            (if (##null? next)
                (macro-processor-interrupts-tail-set!
                 (macro-current-processor)
                 '()))
            (let ((x (##vector-ref interrupt 1)))
              (cond ((##procedure? x)
                     (x interrupt))))
            (loop))))))

;;;----------------------------------------------------------------------------

;;; User accessible primitives for threads.

(define-prim (current-thread)
  (macro-current-thread))

(define-prim (thread? obj)
  (macro-force-vars (obj)
    (macro-thread? obj)))

(define-prim (thread thunk)
  (##declare (not interrupts-enabled))
  (macro-force-vars (thunk)
    (macro-check-procedure thunk 1 (thread thunk)
      (##thread thunk))))

(define-prim (make-thread
              thunk
              #!optional
              (n (macro-absent-obj))
              (tg (macro-absent-obj)))

  (##declare (not interrupts-enabled))

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

  (##declare (not interrupts-enabled))

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
      (macro-thread-specific thread))))

(define-prim (thread-specific-set! thread obj)
  (macro-force-vars (thread)
    (macro-check-thread thread 1 (thread-specific-set! thread obj)
      (begin
        (macro-thread-specific-set! thread obj)
        (##void)))))

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

;;TODO:deprecated
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
           (if (##eq? btq (macro-current-processor))
               (macro-make-thread-state-running
                btq)
               (macro-make-thread-state-waiting
                (if (and (macro-condvar? btq)
                         (##io-condvar? btq))
                    (##io-condvar-port btq)
                    btq)
                timeout))))))

;;;----------------------------------------------------------------------------

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

(define-prim (##mutex-state mutex)
  (##declare (not interrupts-enabled))
  (macro-btq-owner mutex))

(define-prim (mutex-state mutex)
  (macro-force-vars (mutex)
    (macro-check-mutex mutex 1 (mutex-state mutex)
      (##mutex-state mutex))))

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

(define-prim (thread-group-specific tgroup)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-specific tgroup)
      (macro-tgroup-specific tgroup))))

(define-prim (thread-group-specific-set! tgroup obj)
  (macro-force-vars (tgroup)
    (macro-check-tgroup tgroup 1 (thread-group-specific-set! tgroup obj)
      (begin
        (macro-tgroup-specific-set! tgroup obj)
        (##void)))))

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

(define-prim (##with-exception-handler handler thunk)
  (macro-dynamic-bind exception-handler
   handler
   thunk))

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

(define (##r7rs-with-exception-handler handler thunk)
  (let ((original-eh (macro-current-exception-handler)))
    (macro-dynamic-bind
     exception-handler
     (lambda (exc)
       (macro-dynamic-bind
        exception-handler
        original-eh
        (lambda ()
          (handler exc))))
     thunk)))

(define-prim (r7rs-with-exception-handler handler thunk)
  (macro-force-vars (handler thunk)
    (macro-check-procedure handler 1 (r7rs-with-exception-handler handler thunk)
      (macro-check-procedure thunk 2 (r7rs-with-exception-handler handler thunk)
        (##r7rs-with-exception-handler handler thunk)))))

(define (##r7rs-with-exception-catcher handler thunk)
  (##continuation-capture
   (lambda (cont)
     (macro-dynamic-bind
      exception-handler
      (lambda (exc)
        (##continuation-capture
         (lambda (reraise-cont)
           (##continuation-graft cont handler exc reraise-cont))))
      thunk))))

(define (##r7rs-reraise exc cont)
  (let ((original-eh (macro-current-exception-handler)))
    (##continuation-graft
     cont
     (lambda ()
       (macro-dynamic-bind
        exception-handler
        original-eh
        (lambda ()
          (##raise exc)))))))

(define (##r7rs-raise exc) ;; raise noncontinuable exception
  (##abort exc))

(define-prim (r7rs-raise exc)
  (##r7rs-raise exc))

(define (##r7rs-raise-continuable exc) ;; raise continuable exception
  (##raise exc))

(define-prim (r7rs-raise-continuable exc)
  (##r7rs-raise-continuable exc))

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

(define call/cc call-with-current-continuation)
(##global-var-primitive-set! (##make-global-var 'call/cc) call/cc)

(define ##initial-dynwind
  '#(0)) ;; only the "level" field is needed

(define-prim (##list->values lst)
  (let loop1 ((x lst) (n 0))
    (if (##pair? x)
        (loop1 (##cdr x) (##fx+ n 1))
        (let ((vals (##make-values n)))
          (let loop2 ((x lst) (i 0))
            (if (and (##pair? x)  ;; double check in case another
                     (##fx< i n)) ;; thread mutates the list
                (let ((elem (##car x)))
                  (##values-set! vals i elem)
                  (loop2 (##cdr x) (##fx+ i 1)))
                vals))))))

(define-prim (##values->list vals)
  (let ((start 0)
        (end (##values-length vals)))
    (let loop ((lst '()) (i (##fx- end 1)))
      (if (##fx< i start)
          lst
          (loop (##cons (##values-ref vals i) lst) (##fx- i 1))))))

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
         (##list->values
          (##cons val1 (##cons val2 (##cons val3 others)))))))

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
         (##list->values
          (##cons val1 (##cons val2 (##cons val3 others)))))))

(define-prim (##call-with-values producer consumer)
  (let ((results ;; may get bound to a multiple-values object
         (producer)))
    (if (##not (##values? results))
        (consumer results)
        (let ((len (##values-length results)))
          (cond ((##fx= len 2)
                 (consumer (##values-ref results 0)
                           (##values-ref results 1)))
                ((##fx= len 3)
                 (consumer (##values-ref results 0)
                           (##values-ref results 1)
                           (##values-ref results 2)))
                ((##fx= len 0)
                 (consumer))
                (else
                 (##apply consumer (##values->list results))))))))

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
            (##list->values
             (##cons val1 (##cons val2 (##cons val3 others))))))))

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
      (macro-if-auto-forcing
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

(define ##tcp-service-table (##make-table-aux))
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
   (lambda (psettings-and-address-and-port-number)
     (let* ((psettings
             (##vector-ref psettings-and-address-and-port-number 0))
            (local-address
             (##vector-ref psettings-and-address-and-port-number 1))
            (local-port-number
             (##vector-ref psettings-and-address-and-port-number 2))
            (local-address-and-local-port-number
             (##cons local-address local-port-number)))
       (##tcp-service-update! local-address-and-local-port-number
                              #f)
       (##open-tcp-server-aux
        #t
        psettings-and-address-and-port-number
        (lambda (server-port)
          (let ((new-thread
                 (##make-root-thread
                  (lambda () (##tcp-service-serve server-port thunk tgroup))
                  local-address-and-local-port-number
                  ##tcp-service-tgroup)))
            (##tcp-service-update! local-address-and-local-port-number
                                   (##cons server-port new-thread))
            (##thread-start! new-thread)
            new-thread))
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
   (lambda (psettings-and-address-and-port-number)
     (let* ((psettings
             (##vector-ref psettings-and-address-and-port-number 0))
            (local-address
             (##vector-ref psettings-and-address-and-port-number 1))
            (local-port-number
             (##vector-ref psettings-and-address-and-port-number 2))
            (local-address-and-local-port-number
             (##cons local-address local-port-number)))
       (##tcp-service-update! local-address-and-local-port-number #f)
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

(define ##user-interrupt-pending? #f)

(define-prim (##defer-user-interrupts)
   (##declare (not interrupts-enabled))
   (set! ##user-interrupt-pending? #t)
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
         (if (##not (##eq? val ##defer-user-interrupts))
             (let ((int? ##user-interrupt-pending?))
               (set! ##user-interrupt-pending? #f)
               (if int?
                   (val))))
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

(##interrupt-vector-set! 3 ##user-interrupt!) ;; ___INTR_USER

(##interrupt-vector-set! 5 ##other-interrupt!) ;; ___INTR_OTHER

(##startup-threading!)

;;;============================================================================

))

;;(##include "termite/termite.scm")
