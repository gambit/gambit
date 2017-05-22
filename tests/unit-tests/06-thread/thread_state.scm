(include "#.scm")

(define-type-of-thread mythread)

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num) ;; waste some time
        (waste-time (- n 1)))))

(define var 0)

(define t1
  (make-mythread))

(define t2
  (make-thread
   (lambda ()
     (waste-time 200)
     (set! var 1)
     123)))

(define t3
  (make-thread
   (lambda ()
     (/ 1 0))))

(define mut1 (make-mutex))
(mutex-lock! mut1)

(define mut2 (make-mutex))
(mutex-lock! mut2)

(define mut3 (make-mutex))
(mutex-lock! mut3)

(define cv (make-condition-variable))

(define to (seconds->time (+ 1000 (time->seconds (current-time)))))

(define t4
  (make-thread
   (lambda ()
     (mutex-lock! mut1))))

(define t5
  (make-thread
   (lambda ()
     (mutex-lock! mut1 to))))

(define t6
  (make-thread
   (lambda ()
     (mutex-unlock! mut2 cv))))

(define t7
  (make-thread
   (lambda ()
     (mutex-unlock! mut3 cv to))))

(define t8
  (make-thread
   (lambda ()
     (thread-sleep! to))))

(check-true (thread-state-uninitialized? (thread-state t1)))

(check-true (thread-state-initialized? (thread-state t2)))
(check-true (thread-state-initialized? (thread-state t3)))

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
       (check-true (processor? (thread-state-running-processor s2))))
      ((thread-state-waiting? s2)
       (check-true (processor? (thread-state-waiting-for s2)))
       (check-false (thread-state-waiting-timeout s2)))
      (else
       (check-false "s2 should be thread-state-running or thread-state-waiting")))

(thread-join! t2)

(check-equal? var 1)

(set! s2 (thread-state t2))

(check-true (thread-state-normally-terminated? s2))
(check-equal? (thread-state-normally-terminated-result s2) 123)

(define s3 (thread-state t3))

(check-true (thread-state-abnormally-terminated? s3))
(check-true (divide-by-zero-exception?
             (thread-state-abnormally-terminated-reason s3)))

(define s4 (thread-state t4))

(check-true (thread-state-waiting? s4))
(check-true (mutex? (thread-state-waiting-for s4)))
(check-false (thread-state-waiting-timeout s4))

(define s5 (thread-state t5))

(check-true (thread-state-waiting? s5))
(check-true (mutex? (thread-state-waiting-for s5)))
(check-equal? (time->seconds (thread-state-waiting-timeout s5))
              (time->seconds to))

(define s6 (thread-state t6))

(check-true (thread-state-waiting? s6))
(check-true (condition-variable? (thread-state-waiting-for s6)))
(check-false (thread-state-waiting-timeout s6))

(define s7 (thread-state t7))

(check-true (thread-state-waiting? s7))
(check-true (condition-variable? (thread-state-waiting-for s7)))
(check-equal? (time->seconds (thread-state-waiting-timeout s7))
              (time->seconds to))

(define s8 (thread-state t8))

(check-true (thread-state-waiting? s8))
(check-false (thread-state-waiting-for s8))
(check-equal? (time->seconds (thread-state-waiting-timeout s8))
              (time->seconds to))

(check-tail-exn type-exception? (lambda () (thread-state #f)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-state)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (thread-state #f #f)))
