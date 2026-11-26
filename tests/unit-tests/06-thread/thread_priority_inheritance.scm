(include "#.scm")
(include "~~lib/_gambit#.scm")

;; Keep the scheduling setup deterministic while still exercising the SMP
;; runtime.  The public thread/mutex operations below are the behavior under
;; test; pinning only prevents another processor from racing the assertions.
(define test-processor (current-processor))
(define (pin! thread)
  (cond-expand
   (enable-smp (##thread-pin! thread test-processor))
   (else #f))
  thread)
(pin! (current-thread))

(define (fresh-thread thunk)
  (pin! (make-thread thunk)))

(define (waits-on? thread object)
  (let ((state (thread-state thread)))
    (and (thread-state-waiting? state)
         (eq? (thread-state-waiting-for state) object))))

(define (wait-until pred)
  (if (not (pred))
      (begin
        (thread-yield!)
        (wait-until pred))))

(define (effective-priority thread)
  ;; All fixture threads are pinned to TEST-PROCESSOR.  While this thread is
  ;; running, blocked fixture threads have no concurrent writer.
  (macro-thread-effective-priority thread))

(define (inheritance-case departure)
  (let* ((target (make-mutex 'target))
         (gate (make-mutex 'gate))
         (low
          (fresh-thread
           (lambda ()
             (mutex-lock! target)
             (mutex-lock! gate)
             (mutex-unlock! gate)
             (mutex-unlock! target))))
         (high
          (fresh-thread
           (lambda ()
             (if (eq? departure 'timeout)
                 (mutex-lock! target 0.01)
                 (begin
                   (mutex-lock! target)
                   (mutex-unlock! target)))))))

    (thread-base-priority-set! low 10)
    (thread-base-priority-set! high 30)

    ;; Current owns GATE so LOW stays blocked while owning TARGET.
    (mutex-lock! gate)
    (thread-start! low)
    (wait-until (lambda () (waits-on? low gate)))

    ;; HIGH now blocks on TARGET.  LOW must inherit HIGH's effective priority,
    ;; and because LOW is itself blocked on GATE the inheritance propagates to
    ;; the current thread too.
    (thread-start! high)
    (wait-until (lambda () (waits-on? high target)))
    (test-assert (> (effective-priority low) 20.0))
    (test-assert (> (effective-priority (current-thread)) 20.0))

    (cond
     ((eq? departure 'timeout)
      (thread-join! high 1)
      ;; Once HIGH leaves TARGET's wait queue, stale inheritance must be
      ;; removed from LOW and propagated through LOW's own wait chain.
      (test-assert (< (effective-priority low) 20.0))
      (test-assert (< (effective-priority (current-thread)) 20.0)))
     ((eq? departure 'terminate)
      (thread-terminate! high)
      (test-assert (< (effective-priority low) 20.0))
      (test-assert (< (effective-priority (current-thread)) 20.0))))

    (mutex-unlock! gate)
    (thread-join! low 1)
    (if (eq? departure 'keep)
        (thread-join! high 1))
    (thread-yield!)))

;; Inheritance is raised when a higher-priority waiter blocks.
(inheritance-case 'keep)

;; Inheritance is removed when the waiter leaves because its timeout expires.
(inheritance-case 'timeout)

;; Removing a blocked waiter by terminating it must also remove inheritance.
(inheritance-case 'terminate)
