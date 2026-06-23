(include "#.scm")

(test-eqv 11 (##fx-? 44 33))
(test-eqv (##greatest-fixnum) (##fx-? (##greatest-fixnum) 0))
(test-eqv (##least-fixnum) (##fx-? (##least-fixnum) 0))
(test-eqv #f (##fx-? (##least-fixnum)))
(test-eqv #f (##fx-? (##greatest-fixnum) -1))
