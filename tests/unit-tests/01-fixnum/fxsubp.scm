(include "#.scm")

(check-eqv? (##fx-? 44 33) 11)
(check-eqv? (##fx-? ##max-fixnum 0) ##max-fixnum)
(check-eqv? (##fx-? ##min-fixnum 0) ##min-fixnum)
(check-eqv? (##fx-? ##min-fixnum) #f)
(check-eqv? (##fx-? ##max-fixnum -1) #f)
