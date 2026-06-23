(include "#.scm")

(define num (expt 11 10001))

(define (waste-time n)
  (if (> n 0)
      (begin
        (integer-sqrt num)
        ;; waste some time
        (waste-time (- n 1)))))

(define var 0)

(define t (thread (lambda () (set! var 1))))

(waste-time 400)

(test-equal 1 var)

(test-error-tail type-exception? (thread #f))

(test-error-tail wrong-number-of-arguments-exception? (thread))
(test-error-tail wrong-number-of-arguments-exception? (thread list #f))
