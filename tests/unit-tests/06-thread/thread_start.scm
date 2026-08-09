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

(define t2 (make-thread (lambda () (waste-time 200) (set! var 1))))

(test-error-tail uninitialized-thread-exception? (thread-start! t1))

(thread-start! t2)

(test-error-tail started-thread-exception? (thread-start! t2))

(waste-time 400)

(test-equal 1 var)

(test-error-tail started-thread-exception? (thread-start! t2))

(test-error-tail type-exception? (thread-start! #f))

(test-error-tail wrong-number-of-arguments-exception? (thread-start!))
(test-error-tail wrong-number-of-arguments-exception? (thread-start! #f #f))
