(include "#.scm")

(check-eqv? (##fx+? 11 33) 44)
(check-eqv? (##fx+? (##greatest-fixnum) 0) (##greatest-fixnum))
(check-eqv? (##fx+? (##least-fixnum) 0) (##least-fixnum))
(check-eqv? (##fx+? (##greatest-fixnum) 1) #f)
(check-eqv? (##fx+? (##least-fixnum) -1) #f)
