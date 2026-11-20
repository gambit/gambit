(include "#.scm")
(include "~~lib/_gambit#.scm")

;; Pin these scheduling-order cases to one processor even in an SMP run.
;; The public operations under test remain thread/mutex/condition APIs.
(define test-processor (current-processor))
(define (pin! thread)
  (cond-expand
   (enable-smp (##thread-pin! thread test-processor))
   (else #f))
  thread)
(pin! (current-thread))

;; Drive the ordinary heartbeat entry point explicitly instead of relying
;; on wall-clock races.  No automatic heartbeat occurs during these tests.
(##set-heartbeat-interval! 64.0)
(thread-quantum-set! (current-thread) 192.0)

(define (tick n)
  (if (> n 0)
      (begin (##thread-heartbeat!) (tick (- n 1)))))

(define (current-priorities)
  ;; Only inspect the current thread: no concurrent writer can change it
  ;; in these fixtures, and the actual runtime macros avoid layout copies.
  (list (macro-thread-boosted-priority (current-thread))
        (macro-thread-effective-priority (current-thread))
        (macro-thread-quantum-used (current-thread))))

(define (fresh-thread thunk)
  (pin! (make-thread thunk)))

(define (waits-on? thread object)
  (let ((state (thread-state thread)))
    (and (thread-state-waiting? state)
         (eq? (thread-state-waiting-for state) object))))

(define (gate-order before-block after-wake)
  (let ((gate (make-mutex))
        (events '()))
    (define (record value) (set! events (cons value events)))
    ;; An unowned gate isolates boost from priority inheritance.
    (mutex-lock! gate #f #f)
    (let ((a (fresh-thread
              (lambda ()
                (before-block)
                (mutex-lock! gate 2)
                (mutex-unlock! gate)
                (after-wake record)))))
      (thread-start! a)
      (thread-yield!)
      (test-assert (waits-on? a gate))
      (let ((b (fresh-thread (lambda () (record 'b)))))
        (thread-start! b)
        (mutex-unlock! gate)
        ;; Explicit yield makes immediate SMP preemption irrelevant.
        (thread-yield!)
        (thread-join! a 2)
        (thread-join! b 2)
        (reverse events)))))

(test-equal '(a b)
            (gate-order (lambda () #f)
                        (lambda (record) (record 'a))))

(test-equal '(a1 b a2)
            (gate-order (lambda () #f)
                        (lambda (record)
                          (record 'a1)
                          (thread-yield!)
                          (record 'a2))))

(define (three-ticks record)
  (for-each (lambda (step) (record step) (tick 1)) '(a1 a2 a3)))

(test-equal '(a1 a2 a3 b)
            (gate-order (lambda () #f) three-ticks))
(test-equal '(a1 a2 a3 b)
            (gate-order (lambda () (tick 2)) three-ticks))

;; Successful immediate locks and already-expired waits must not boost.
(let ((mutex (make-mutex)))
  (thread-yield!)
  (mutex-lock! mutex)
  (test-equal '(0.0 0.0 0.0) (current-priorities))
  (test-eq #f (mutex-lock! mutex 0))
  (test-equal '(0.0 0.0 0.0) (current-priorities))
  (mutex-unlock! mutex))

;; A genuinely blocked wait which times out does retain its boost.
(let ((gate (make-mutex)))
  (mutex-lock! gate #f #f)
  (let ((worker (fresh-thread
                 (lambda ()
                   (let ((result (mutex-lock! gate 0.01)))
                     (list result (current-priorities)))))))
    (thread-start! worker)
    (test-equal (list #f (list 1e-6 1e-6 0.0)) (thread-join! worker 2)))
  (mutex-unlock! gate))

;; Only the worker is runnable after the main thread blocks in join.
;; A yield must clear boost even on this no-other-runnable fast path.
(let* ((gate (make-mutex))
       (worker (fresh-thread
                (lambda ()
                  (mutex-lock! gate 2)
                  (mutex-unlock! gate)
                  (let ((before (current-priorities)))
                    (tick 2)
                    (thread-yield!)
                    (list before (current-priorities)))))))
  (mutex-lock! gate #f #f)
  (thread-start! worker)
  (thread-yield!)
  (test-assert (waits-on? worker gate))
  (mutex-unlock! gate)
  (test-equal '((0.000001 0.000001 0.0) (0.0 0.0 0.0))
              (thread-join! worker 2)))

;; Join has the same boosting behavior as mutex and condition waits.
(let* ((gate (make-mutex))
       (target (fresh-thread
                (lambda () (mutex-lock! gate 2) (mutex-unlock! gate))))
       (joiner (fresh-thread
                (lambda () (thread-join! target 2) (current-priorities)))))
  (mutex-lock! gate #f #f)
  (thread-start! target)
  (thread-start! joiner)
  (thread-yield!)
  (test-assert (waits-on? target gate))
  (test-assert (thread-state-waiting? (thread-state joiner)))
  (mutex-unlock! gate)
  (test-equal '(0.000001 0.000001 0.0) (thread-join! joiner 2)))

(let* ((mutex (make-mutex))
       (condition (make-condition-variable))
       (worker (fresh-thread
                (lambda ()
                  (mutex-lock! mutex)
                  (mutex-unlock! mutex condition 2)
                  (current-priorities)))))
  (thread-start! worker)
  (thread-yield!)
  (test-assert (waits-on? worker condition))
  (condition-variable-signal! condition)
  (test-equal '(0.000001 0.000001 0.0) (thread-join! worker 2)))

;; Preserve the established unicore exception: sleep clears a boost.
(let* ((gate (make-mutex))
       (worker (fresh-thread
                (lambda ()
                  (mutex-lock! gate 2)
                  (mutex-unlock! gate)
                  (thread-sleep! 0.01)
                  (current-priorities)))))
  (mutex-lock! gate #f #f)
  (thread-start! worker)
  (thread-yield!)
  (mutex-unlock! gate)
  (test-equal '(0.0 0.0 0.0) (thread-join! worker 2)))

;; Several owned mutexes, including empty queues on both sides of a
;; populated one. A waiter is boosted by actually blocking, not by a
;; priority setter, whose separate SMP queue semantics are not at issue.
(define (owned-waiter-case empty-first?)
  (let ((occupied (make-mutex))
        (empty (make-mutex)))
    (thread-yield!)
    (mutex-lock! (if empty-first? empty occupied))
    (mutex-lock! (if empty-first? occupied empty))
    (let ((waiter (fresh-thread
                   (lambda ()
                     (mutex-lock! occupied 2)
                     (mutex-unlock! occupied)))))
      (thread-start! waiter)
      (thread-yield!)
      (test-assert (waits-on? waiter occupied))
      ;; Own boost is already clear. Its effective priority must still
      ;; include the blocked waiter when recomputed by another yield.
      (thread-yield!)
      (let ((inherited (current-priorities)))
        (mutex-unlock! occupied)
        (mutex-unlock! empty)
        ;; No owned waiters remain. A later yield drops stale inheritance
        ;; even though the owner's boosted field is already its base.
        (thread-yield!)
        (let ((released (current-priorities)))
          (thread-join! waiter 2)
          (list inherited released))))))

(test-equal '((0.0 0.000001 0.0) (0.0 0.0 0.0))
            (owned-waiter-case #t))
(test-equal '((0.0 0.000001 0.0) (0.0 0.0 0.0))
            (owned-waiter-case #f))

;; Boost is assigned from base plus the configured amount, not accumulated
;; when a thread blocks again before yielding or exhausting its quantum.
(let* ((first (make-mutex))
       (second (make-mutex))
       (worker
        (fresh-thread
         (lambda ()
           (mutex-lock! first 2)
           (mutex-unlock! first)
           (let ((before (current-priorities)))
             (tick 2)
             (mutex-lock! second 2)
             (mutex-unlock! second)
             (list before (current-priorities)))))))
  (mutex-lock! first #f #f)
  (mutex-lock! second #f #f)
  (thread-start! worker)
  (thread-yield!)
  (test-assert (waits-on? worker first))
  (mutex-unlock! first)
  (thread-yield!)
  (test-assert (waits-on? worker second))
  (mutex-unlock! second)
  (test-equal '((0.000001 0.000001 0.0) (0.000001 0.000001 0.0))
              (thread-join! worker 2)))

;; Zero is a valid configured boost. Set the fixture field while the
;; worker is inactive; SMP's separate public priority-setter lock handling
;; is outside these current-thread transition tests.
(let* ((gate (make-mutex))
       (worker
        (fresh-thread
         (lambda ()
           (tick 2)
           (mutex-lock! gate 2)
           (mutex-unlock! gate)
           (current-priorities)))))
  (macro-priority-boost-set! (macro-thread-floats worker) 0.0)
  (mutex-lock! gate #f #f)
  (thread-start! worker)
  (thread-yield!)
  (test-assert (waits-on? worker gate))
  (mutex-unlock! gate)
  (test-equal '(0.0 0.0 0.0) (thread-join! worker 2)))

;; Effective priority is the maximum across all populated owned queues,
;; independent of their order, and falls when the larger waiter leaves.
(define (owned-max-case larger-first?)
  (let* ((small (make-mutex))
         (large (make-mutex))
         (small-waiter (fresh-thread
                        (lambda () (mutex-lock! small 2)
                                   (mutex-unlock! small))))
         (large-waiter (fresh-thread
                        (lambda () (mutex-lock! large 2)
                                   (mutex-unlock! large)))))
    (macro-priority-boost-set! (macro-thread-floats large-waiter) 0.000002)
    (thread-yield!)
    (mutex-lock! (if larger-first? large small))
    (mutex-lock! (if larger-first? small large))
    (thread-start! small-waiter)
    (thread-start! large-waiter)
    ;; Blocking the owner lets both waiters reach their mutex even when
    ;; unicore immediately raises the owner's inherited priority.
    (thread-join! (thread-start! (fresh-thread (lambda () #t))) 2)
    (test-assert (waits-on? small-waiter small))
    (test-assert (waits-on? large-waiter large))
    (thread-yield!)
    (let ((both (current-priorities)))
      (mutex-unlock! large)
      (thread-yield!)
      (let ((one (current-priorities)))
        (mutex-unlock! small)
        (thread-yield!)
        (let ((none (current-priorities)))
          (thread-join! large-waiter 2)
          (thread-join! small-waiter 2)
          (list both one none))))))

(test-equal '((0.0 0.000002 0.0) (0.0 0.000001 0.0) (0.0 0.0 0.0))
            (owned-max-case #t))
(test-equal '((0.0 0.000002 0.0) (0.0 0.000001 0.0) (0.0 0.0 0.0))
            (owned-max-case #f))
