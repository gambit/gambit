(include "#.scm")

;; Both setters must release their lock so the value can be read back.
;; Increasing, decreasing and retaining the priority exercise both paths
;; through boosted-priority recomputation.
(define (check-priorities thread)
  (for-each
   (lambda (priority)
     (test-equal (void) (thread-base-priority-set! thread priority))
     (test-equal priority (thread-base-priority thread)))
   '(12.3 -2.0 -2.0 0.0))
  (for-each
   (lambda (boost)
     (test-equal (void) (thread-priority-boost-set! thread boost))
     (test-equal boost (thread-priority-boost thread)))
   '(2.5 0.0 1.0)))

(define current (current-thread))
(define saved-base (thread-base-priority current))
(define saved-boost (thread-priority-boost current))
(check-priorities current)
(thread-base-priority-set! current saved-base)
(thread-priority-boost-set! current saved-boost)

(define worker (make-thread (lambda () (check-priorities (current-thread)) 42)))
(check-priorities worker)
(thread-start! worker)
(test-equal 42 (thread-join! worker))
(check-priorities worker)

;; Traversing a nonempty owned-mutex list must also terminate.
(define lock1 (make-mutex))
(define lock2 (make-mutex))
(mutex-lock! lock1)
(mutex-lock! lock2)
(check-priorities current)
(mutex-unlock! lock2)
(mutex-unlock! lock1)
(thread-base-priority-set! current saved-base)
(thread-priority-boost-set! current saved-boost)
