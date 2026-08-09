(include "#.scm")

(define (test n) (string-length (number->string (arithmetic-shift 1 n))))

(test-eqv 30597 (test 101639))
;; did not cause the issue
(test-eqv 30601 (test 101652))
;; triggered a problem in the reciprocal cache
