(include "#.scm")

(define (lock-result thunk)
  (with-exception-catcher
   (lambda (exc)
     (if (abandoned-mutex-exception? exc)
         'abandoned
         (raise exc)))
   thunk))

(define (check-abandoned-lock lock expected-owner)
  (let ((m (make-mutex))
        (owner (make-thread (lambda () #f))))
    ;; Terminate the owner after acquiring the mutex so that the mutex
    ;; is abandoned before the acquisition being tested.
    (test-eq #t (mutex-lock! m #f owner))
    (test-eq owner (mutex-state m))
    (thread-terminate! owner)
    (test-eq 'abandoned (mutex-state m))

    ;; The exception depends on the old state, and must be raised after
    ;; installing the requested owner, including an anonymous owner.
    (test-eq 'abandoned (lock-result (lambda () (lock m))))
    (test-eq expected-owner (mutex-state m))

    (mutex-unlock! m)
    (test-eq 'not-abandoned (mutex-state m))
    (test-eq #t (mutex-lock! m 0))
    (mutex-unlock! m)))

(check-abandoned-lock (lambda (m) (mutex-lock! m)) (current-thread))
(check-abandoned-lock (lambda (m) (mutex-lock! m #f)) (current-thread))
(check-abandoned-lock (lambda (m) (mutex-lock! m 60)) (current-thread))
(check-abandoned-lock (lambda (m) (mutex-lock! m #f #f)) 'not-owned)
(check-abandoned-lock (lambda (m) (mutex-lock! m 60 #f)) 'not-owned)

(let ((owner (make-thread (lambda () #f))))
  (check-abandoned-lock (lambda (m) (mutex-lock! m #f owner)) owner)
  (thread-terminate! owner))

(let ((owner (make-thread (lambda () #f))))
  (thread-terminate! owner)
  (check-abandoned-lock
   (lambda (m) (mutex-lock! m #f owner))
   'abandoned))
