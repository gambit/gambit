(include "#.scm")

(check-eqv? (##fx*? 6 7) 42)
(check-eqv? (##fx*? -6 -7) 42)
(check-eqv? (##fx*? 6  -7) -42)

(check-eqv? (##fx*? ##max-fixnum 1) ##max-fixnum)
(check-eqv? (##fx*? ##min-fixnum 1) ##min-fixnum)
(check-eqv? (##fx*? ##max-fixnum 2) #f)
(check-eqv? (##fx*? ##min-fixnum 2) #f)
