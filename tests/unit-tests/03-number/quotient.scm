(include "#.scm")

(define ##min-bignum (+ ##max-fixnum 1))

(check-eqv? (quotient ##min-bignum ##min-fixnum) -1)
(check-eqv? (remainder ##min-bignum ##min-fixnum) 0)

(check-eqv? (quotient ##min-fixnum ##min-bignum) -1)
(check-eqv? (remainder ##min-fixnum ##min-bignum) 0)

(check-eqv? (quotient ##min-fixnum ##max-fixnum) -1)
(check-eqv? (remainder ##min-fixnum ##max-fixnum) -1)
