(include "#.scm")

(test-eqv 42 42)
(test-eqv 12345678901234567891234567890 12345678901234567891234567890)
(test-eqv #t #t)
(test-eqv #f #f)
(test-eqv #\x #\x)
(test-eqv 'hello 'hello)
(test-eqv '() '())
(test-eqv 0. 0.)
(test-eqv -0. -0.)

;; Equivalent NaNs should be eqv?
(define (f x y) (fl/ x y))
(let ((x (f 0. 0.)) (y (f 0. 0.))) (test-eqv y x))

(test-eqv +inf.0 +inf.0)
(test-eqv -inf.0 -inf.0)
