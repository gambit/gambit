(include "#.scm")

(define (make-owned-mutexes owner count)
  (let loop ((n count) (mutexes '()))
    (if (= n 0)
        (reverse mutexes)
        (let ((mutex (make-mutex)))
          (mutex-lock! mutex #f owner)
          (loop (- n 1) (cons mutex mutexes))))))

(define (wait-at-gate gate)
  (mutex-lock! gate)
  (mutex-unlock! gate))

;; mutex-unlock! is allowed to unlock a mutex owned by another thread.
;; Race that operation against abandonment, then repeat with ownership
;; transferred to a live thread. Abandonment must recheck the owner after
;; releasing its thread lock. A regression can deadlock the SMP runtime,
;; so the test process needs an external timeout.

(define (race-unlock-with-termination transfer?)
  (let loop ((n 50))
    (if (> n 0)
        (let* ((owner (make-thread (lambda () #f)))
               (new-owner (and transfer? (make-thread (lambda () #f))))
               (mutexes (make-owned-mutexes owner 256))
               (gate (make-mutex)))
          (mutex-lock! gate)
          (let ((terminator
                 (make-thread
                  (lambda ()
                    (wait-at-gate gate)
                    (thread-terminate! owner)
                    'terminated)))
                (unlocker
                 (make-thread
                  (lambda ()
                    (wait-at-gate gate)
                    (for-each
                     (lambda (mutex)
                       (mutex-unlock! mutex)
                       (if new-owner (mutex-lock! mutex #f new-owner)))
                     mutexes)
                    'unlocked))))
            (thread-start! terminator)
            (thread-start! unlocker)
            (mutex-unlock! gate)
            (test-eq 'terminated (thread-join! terminator 5 'timeout))
            (test-eq 'unlocked (thread-join! unlocker 5 'timeout))
            (test-equal (make-list 256 (or new-owner 'not-abandoned))
                        (map mutex-state mutexes))
            (if new-owner (thread-terminate! new-owner)))
          (loop (- n 1))))))

(race-unlock-with-termination #f)
(race-unlock-with-termination #t)

;; Joining must observe cleanup as complete after normal return, an
;; uncaught exception, and self-termination, even while abandonment
;; drops and reacquires the terminating thread's low-level lock.

(define (join-result thread #!optional (timeout 5))
  (with-exception-catcher
   (lambda (exc)
     (cond ((terminated-thread-exception? exc) 'terminated)
           ((uncaught-exception? exc)
            (list 'uncaught (uncaught-exception-reason exc)))
           (else (raise exc))))
   (lambda () (thread-join! thread timeout 'timeout))))

(define (wait-for-terminal-state thread)
  (let ((deadline (+ (time->seconds (current-time)) 5)))
    (let loop ()
      (let ((state (thread-state thread)))
        (if (not (or (thread-state-normally-terminated? state)
                     (thread-state-abnormally-terminated? state)))
            (if (< (time->seconds (current-time)) deadline)
                (begin (thread-yield!) (loop))
                (error "thread did not terminate")))))))

(define (check-join-after-abandonment action expected)
  (let loop ((n 20))
    (if (> n 0)
        (let* ((gate (make-mutex))
               (owner
                (make-thread
                 (lambda ()
                   (wait-at-gate gate)
                   (action))))
               (mutexes (make-owned-mutexes owner 256)))
          (mutex-lock! gate)
          (thread-start! owner)
          (mutex-unlock! gate)
          (if (even? n)
              (begin
                ;; Once thread-state reports termination, a join with
                ;; zero timeout must already succeed.
                (wait-for-terminal-state owner)
                (test-equal expected (join-result owner 0)))
              (test-equal expected (join-result owner)))
          (test-equal (make-list 256 'abandoned) (map mutex-state mutexes))
          (loop (- n 1))))))

(check-join-after-abandonment (lambda () 'done) 'done)
(check-join-after-abandonment (lambda () (raise 'failure)) '(uncaught failure))
(check-join-after-abandonment
 (lambda () (thread-terminate! (current-thread)))
 'terminated)

(define (wait-for-mutex-waiter thread mutex)
  (let ((deadline (+ (time->seconds (current-time)) 5)))
    (let loop ()
      (let ((state (thread-state thread)))
        (if (not (and (thread-state-waiting? state)
                      (eq? (thread-state-waiting-for state) mutex)))
            (if (< (time->seconds (current-time)) deadline)
                (begin (thread-yield!) (loop))
                (error "thread did not wait for mutex")))))))

;; A blocked mutex-lock! must receive the abandonment exception after
;; assigning the requested owner: the waiting thread, another live
;; thread, or no owner. Exercise finite waits as well as indefinite waits.

(define (check-abandoned-waiter requested-owner timeout)
  (let* ((owner (make-thread (lambda () #f)))
         (mutex (car (make-owned-mutexes owner 1)))
         (waiter
          (make-thread
           (lambda ()
             (let* ((new-owner
                     (if (eq? requested-owner 'self)
                         (current-thread)
                         requested-owner))
                    (abandoned?
                     (with-exception-catcher
                      (lambda (exc)
                        (if (abandoned-mutex-exception? exc)
                            #t
                            (raise exc)))
                      (lambda ()
                        (mutex-lock! mutex timeout new-owner)
                        #f)))
                    (correct-owner?
                     (eq? (mutex-state mutex) (or new-owner 'not-owned))))
               (mutex-unlock! mutex)
               (list abandoned? correct-owner?))))))
    (thread-start! waiter)
    (wait-for-mutex-waiter waiter mutex)
    (thread-terminate! owner)
    (test-equal '(#t #t) (thread-join! waiter 5 'timeout))
    (test-eq 'not-abandoned (mutex-state mutex))))

(for-each
 (lambda (timeout)
   (check-abandoned-waiter 'self timeout)
   (check-abandoned-waiter #f timeout)
   (let ((new-owner (make-thread (lambda () #f))))
     (check-abandoned-waiter new-owner timeout)
     (thread-terminate! new-owner)))
 '(#f 5))
