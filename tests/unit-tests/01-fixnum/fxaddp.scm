(include "#.scm")

(test-eqv 44 (##fx+? 11 33))
(test-eqv (##greatest-fixnum) (##fx+? (##greatest-fixnum) 0))
(test-eqv (##least-fixnum) (##fx+? (##least-fixnum) 0))
(test-eqv #f (##fx+? (##greatest-fixnum) 1))
(test-eqv #f (##fx+? (##least-fixnum) -1))
