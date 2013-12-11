(include "#.scm")

(check-eqv? 42 42)
(check-eqv? 12345678901234567891234567890 12345678901234567891234567890)
(check-eqv? #t #t)
(check-eqv? #f #f)
(check-eqv? #\x #\x)
(check-eqv? 'hello 'hello)
(check-eqv? '() '())
