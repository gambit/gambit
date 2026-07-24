(include "#.scm")

(check-eqv? (##fx-? 44 33) 11)
(check-eqv? (##fx-? (##greatest-fixnum) 0) (##greatest-fixnum))
(check-eqv? (##fx-? (##least-fixnum) 0) (##least-fixnum))
(check-eqv? (##fx-? (##least-fixnum)) #f)
(check-eqv? (##fx-? (##greatest-fixnum) -1) #f)
