(include "#.scm")

(test-eqv 0 (##fxxor))
(test-eqv 1 (##fxxor 1))
(test-eqv -62 (##fxxor 33 22 -11))
(test-eqv -1 (##fxxor (##least-fixnum) (##greatest-fixnum)))

(test-eqv 0 (fxxor))
(test-eqv 1 (fxxor 1))
(test-eqv -62 (fxxor 33 22 -11))
(test-eqv -1 (fxxor (##least-fixnum) (##greatest-fixnum)))

(test-error-tail type-exception? (fxxor 0.))
(test-error-tail type-exception? (fxxor .5))
(test-error-tail type-exception? (fxxor 1/2))
