(include "#.scm")

;; This is the deadlock example from the Gambit manual. The primordial
;; thread must be resumed with an exception instead of waiting forever.
(test-eq #t
 (with-exception-catcher
  deadlock-exception?
  (lambda () (read (open-vector)))))

;; Recovering from the exception must leave the blocked queue usable.
(define m (make-mutex))
(mutex-lock! m)
(test-eq #t
 (with-exception-catcher
  deadlock-exception?
  (lambda () (mutex-lock! m))))
(mutex-unlock! m)
(test-eq #t (mutex-lock! m 0))
(mutex-unlock! m)

;; A join can deadlock together with its target. Only the primordial
;; thread receives the exception; the target can still be terminated.
(define blocked
  (thread-start! (make-thread (lambda () (read (open-vector))))))
(test-eq #t
 (with-exception-catcher
  deadlock-exception?
  (lambda () (thread-join! blocked))))
(thread-terminate! blocked)

;; A pending timeout allows progress, even when no thread is runnable.
(test-eq 'awake
 (thread-join!
  (thread-start!
   (make-thread (lambda () (thread-sleep! .001) 'awake)))))

;; The worker must finish releasing m before it is considered idle.
;; In SMP its current-thread field is cleared before mutex-unlock!
;; finishes waking a waiter; the wait-deque registration distinguishes
;; that transition from an actual deadlock.
(define (handoff)
  (let ((m (make-mutex))
        (ready (make-mutex))
        (cv (make-condition-variable)))
    (mutex-lock! ready)
    (let ((worker
           (thread-start!
            (make-thread
             (lambda ()
               (mutex-lock! m)
               (mutex-unlock! ready)
               (mutex-unlock! m cv)
               'done)))))
      (mutex-lock! ready)
      (mutex-unlock! ready)
      (mutex-lock! m)
      (mutex-unlock! m)
      (condition-variable-signal! cv)
      (thread-join! worker))))

(let loop ((n 200))
  (if (> n 0)
      (begin
        (test-eq 'done (handoff))
        (loop (- n 1)))))
