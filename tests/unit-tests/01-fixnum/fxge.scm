(include "#.scm")

(test-eqv #t (##fx>=))
(test-eqv #t (##fx>= 1))
(test-eqv #f (##fx>= (##least-fixnum) (##greatest-fixnum)))
(test-eqv #t (##fx>= (##greatest-fixnum) (##least-fixnum)))
(test-eqv #t (##fx>= (##greatest-fixnum) (##greatest-fixnum)))

(test-eqv #t (fx>=))
(test-eqv #t (fx>= 1))
(test-eqv #f (fx>= (##least-fixnum) (##greatest-fixnum)))
(test-eqv #t (fx>= (##greatest-fixnum) (##least-fixnum)))
(test-eqv #t (fx>= (##greatest-fixnum) (##greatest-fixnum)))

(test-error-tail type-exception? (fx>= 0. 1))
(test-error-tail type-exception? (fx>= .5 1))
(test-error-tail type-exception? (fx>= 1 .5))
(test-error-tail type-exception? (fx>= 1/3 1))
