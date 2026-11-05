(include "#.scm")

(test-eqv +1. (##fixnum->flonum 1))
(test-eqv -1. (##fixnum->flonum -1))
(test-eqv +0. (##fixnum->flonum 0))

(test-eqv +1. (fixnum->flonum 1))
(test-eqv -1. (fixnum->flonum -1))
(test-eqv +0. (fixnum->flonum 0))

(test-error-tail type-exception? (fixnum->flonum 1/2))
(test-error-tail type-exception? (fixnum->flonum .5))
(test-error-tail type-exception? (fixnum->flonum .5+1.i))

(test-error-tail wrong-number-of-arguments-exception? (fixnum->flonum))
(test-error-tail wrong-number-of-arguments-exception? (fixnum->flonum 1 2))
