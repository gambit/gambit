(include "#.scm")

(check-eqv? (##fx*?  6  7)  42)
(check-eqv? (##fx*?  6 -7) -42)
(check-eqv? (##fx*? -6  7) -42)
(check-eqv? (##fx*? -6 -7)  42)

(check-eqv? (##fx*? 0 7) 0)

;; these are invalid tests because the second argument is constrained to be different from 0 and -1
;;(check-eqv? (##fx*? 6 0) 0)
;;(check-eqv? (##fx*? ##min-fixnum -1) ##min-fixnum)

(check-eqv? (##fx*? ##max-fixnum 1) ##max-fixnum)
(check-eqv? (##fx*? ##min-fixnum 1) ##min-fixnum)
(check-eqv? (##fx*? ##max-fixnum 2) #f)
(check-eqv? (##fx*? ##min-fixnum 2) #f)
