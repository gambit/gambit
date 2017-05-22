(include "#.scm")

(check-eqv? (##fxarithmetic-shift 1 0) 1)
(check-eqv? (##fxarithmetic-shift 1 1) 2)
(check-eqv? (##fxarithmetic-shift 1 3) 8)
(check-eqv? (##fxarithmetic-shift 1 4) 16)

(check-eqv? (fxarithmetic-shift 1 0) 1)
(check-eqv? (fxarithmetic-shift 1 1) 2)
(check-eqv? (fxarithmetic-shift 1 3) 8)
(check-eqv? (fxarithmetic-shift 1 4) 16)

(check-tail-exn type-exception? (lambda () (fxarithmetic-shift 0.0 1)))
(check-tail-exn type-exception? (lambda () (fxarithmetic-shift 0.5 1)))
(check-tail-exn type-exception? (lambda () (fxarithmetic-shift 1 0.5)))
(check-tail-exn type-exception? (lambda () (fxarithmetic-shift 1 1/2)))

(check-tail-exn fixnum-overflow-exception? (lambda () (fxarithmetic-shift ##min-fixnum 1)))
(check-tail-exn fixnum-overflow-exception? (lambda () (fxarithmetic-shift ##max-fixnum 1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxarithmetic-shift)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fxarithmetic-shift 1 1 1)))
