(include "#.scm")

(define (test n)
  (string-length (number->string (arithmetic-shift 1 n))))

(check-equal? (test 101639) 30597) ;; did not cause the issue
(check-equal? (test 101652) 30601) ;; was triggering a problem in the reciprocal cache
