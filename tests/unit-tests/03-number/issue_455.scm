(include "#.scm")

(define (test n)
 (string-length (number->string (arithmetic-shift 1 n))))

(check-eqv? (test 101639) 30597) ;; did not cause the issue
(check-eqv? (test 101652) 30601) ;; triggered a problem in the reciprocal cache
