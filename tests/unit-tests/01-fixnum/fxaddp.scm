(include "#.scm")

(check-eqv? (##fx+? 11 33) 44)
(check-eqv? (##fx+? ##max-fixnum 0) ##max-fixnum)
(check-eqv? (##fx+? ##min-fixnum 0) ##min-fixnum)
(check-eqv? (##fx+? ##max-fixnum 1) #f)
(check-eqv? (##fx+? ##min-fixnum -1) #f)
