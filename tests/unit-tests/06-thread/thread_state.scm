(include "#.scm")

(define-type-of-thread mythread)

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num)
        ;; waste some time
        (waste-time (- n 1)))))

(define var 0)

(define t1 (make-mythread))

(define t2 (make-thread (lambda () (waste-time 200) (set! var 1) 123)))

(define t3 (make-thread (lambda () (/ 1 0))))

(define mut1 (make-mutex))
(mutex-lock! mut1)

(define mut2 (make-mutex))
(mutex-lock! mut2)

(define mut3 (make-mutex))
(mutex-lock! mut3)

(define cv (make-condition-variable))

(define to (seconds->time (+ 1000 (time->seconds (current-time)))))

(define t4 (make-thread (lambda () (mutex-lock! mut1))))

(define t5 (make-thread (lambda () (mutex-lock! mut1 to))))

(define t6 (make-thread (lambda () (mutex-unlock! mut2 cv))))

(define t7 (make-thread (lambda () (mutex-unlock! mut3 cv to))))

(define t8 (make-thread (lambda () (thread-sleep! to))))

(test-assert (eq? #t (thread-state-uninitialized? (thread-state t1))))

(test-assert (eq? #t (thread-state-initialized? (thread-state t2))))
(test-assert (eq? #t (thread-state-initialized? (thread-state t3))))

(thread-start! t2)
(thread-start! t3)
(thread-start! t4)
(thread-start! t5)
(thread-start! t6)
(thread-start! t7)
(thread-start! t8)

(waste-time 100)

(define s2 (thread-state t2))

(cond ((thread-state-running? s2)
       (test-assert (eq? #t (processor? (thread-state-running-processor s2)))))
      ((thread-state-waiting? s2)
       (test-assert (eq? #t (processor? (thread-state-waiting-for s2))))
       (test-assert (eq? #f (thread-state-waiting-timeout s2))))
      (else
       (test-assert
        (eq? #f "s2 should be thread-state-running or thread-state-waiting"))))

(thread-join! t2)

(test-equal 1 var)

(set! s2 (thread-state t2))

(test-assert (eq? #t (thread-state-normally-terminated? s2)))
(test-equal 123 (thread-state-normally-terminated-result s2))

(define s3 (thread-state t3))

(test-assert (eq? #t (thread-state-abnormally-terminated? s3)))
(test-assert
 (eq? #t
      (divide-by-zero-exception?
       (thread-state-abnormally-terminated-reason s3))))

(define s4 (thread-state t4))

(test-assert (eq? #t (thread-state-waiting? s4)))
(test-assert (eq? #t (mutex? (thread-state-waiting-for s4))))
(test-assert (eq? #f (thread-state-waiting-timeout s4)))

(define s5 (thread-state t5))

(test-assert (eq? #t (thread-state-waiting? s5)))
(test-assert (eq? #t (mutex? (thread-state-waiting-for s5))))
(test-equal
 (time->seconds to)
 (time->seconds (thread-state-waiting-timeout s5)))

(define s6 (thread-state t6))

(test-assert (eq? #t (thread-state-waiting? s6)))
(test-assert (eq? #t (condition-variable? (thread-state-waiting-for s6))))
(test-assert (eq? #f (thread-state-waiting-timeout s6)))

(define s7 (thread-state t7))

(test-assert (eq? #t (thread-state-waiting? s7)))
(test-assert (eq? #t (condition-variable? (thread-state-waiting-for s7))))
(test-equal
 (time->seconds to)
 (time->seconds (thread-state-waiting-timeout s7)))

(define s8 (thread-state t8))

(test-assert (eq? #t (thread-state-waiting? s8)))
(test-assert (eq? #f (thread-state-waiting-for s8)))
(test-equal
 (time->seconds to)
 (time->seconds (thread-state-waiting-timeout s8)))

(test-error-tail type-exception? (thread-state #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-state))
(test-error-tail wrong-number-of-arguments-exception? (thread-state #f #f))
