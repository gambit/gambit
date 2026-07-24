(include "#.scm")

(test-eqv #f (##bit-set? 0 0))
(test-eqv #f (##bit-set? 1 0))

(test-eqv #f (##bit-set? (- (##fixnum-width) 1) 3))
(test-eqv #t (##bit-set? (- (##fixnum-width) 1) -3))

(test-eqv #t (##bit-set? 10 (##greatest-fixnum)))
(test-eqv #t (##bit-set? 28 (##greatest-fixnum)))

(test-eqv #t (##bit-set? 59 1152921504606846975))
(test-eqv #f (##bit-set? 60 1152921504606846975))

(test-eqv #t (##bit-set? 100 67185481812096158279325269884928))
(test-eqv #f (##bit-set? 101 67185481812096158279325269884928))

(test-eqv #f (bit-set? 0 0))
(test-eqv #f (bit-set? 1 0))

(test-eqv #f (bit-set? (- (##fixnum-width) 1) 3))
(test-eqv #t (bit-set? (- (##fixnum-width) 1) -3))

(test-eqv #t (bit-set? 10 (##greatest-fixnum)))
(test-eqv #t (bit-set? 28 (##greatest-fixnum)))

(test-eqv #t (bit-set? 59 1152921504606846975))
(test-eqv #f (bit-set? 60 1152921504606846975))

(test-eqv #t (bit-set? 100 67185481812096158279325269884928))
(test-eqv #f (bit-set? 101 67185481812096158279325269884928))

(test-error-tail wrong-number-of-arguments-exception? (bit-set?))
(test-error-tail wrong-number-of-arguments-exception? (bit-set? 1 1 1))

(test-error-tail type-exception? (bit-set? 0.0 1))
(test-error-tail type-exception? (bit-set? 0.5 1))
(test-error-tail type-exception? (bit-set? 1 0.5))
(test-error-tail type-exception? (bit-set? 1 1/2))
