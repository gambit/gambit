(include "#.scm")

(check-false (exact-integer? 123.0) #f)
(check-false (exact-integer? 0.5) #f)
(check-true  (exact-integer? 123) #t)
(check-true  (exact-integer? 100000000000000000000) #t)
(check-false (exact-integer? 1/2) #f)
(check-false (exact-integer? 1/2+3/4i) #f)
(check-false (exact-integer? 123+0.i) #f)

;;; Test exceptions

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (exact-integer?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (exact-integer? 0 0)))
