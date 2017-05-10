(include "#.scm")

(check-eqv? 42 42)
(check-eqv? 12345678901234567891234567890 12345678901234567891234567890)
(check-eqv? #t #t)
(check-eqv? #f #f)
(check-eqv? #\x #\x)
(check-eqv? 'hello 'hello)
(check-eqv? '() '())
(check-eqv? 0.0 0.0)
(check-eqv? -0.0 -0.0)

;; Equivalent NaNs should be eqv?
(let ((x (fl/ 0. 0.)))
  (eqv? x x))

(check-eqv? +inf.0 +inf.0)
(check-eqv? -inf.0 -inf.0)
