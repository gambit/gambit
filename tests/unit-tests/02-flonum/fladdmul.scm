(include "#.scm")

(check-eqv? (##fl+* -0.4 3. 1.2) -1.1102230246251565e-16)
(check-eqv? (##fl+* (fl- (fl- (flexpt 2. 28.) 1.)) (fl+ 1. (flexpt 2. 28.)) (flexpt 2. 56.)) 1.)

(check-eqv? (fl+* -0.4 3. 1.2) -1.1102230246251565e-16)
(check-eqv? (fl+* (fl- (fl- (flexpt 2. 28.) 1.)) (fl+ 1. (flexpt 2. 28.)) (flexpt 2. 56.)) 1.)

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fl+* 123)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fl+* 123 9.0)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (fl+* 9.0 123)))
(check-tail-exn type-exception? (lambda () (fl+* 123 3.0 9.0)))
(check-tail-exn type-exception? (lambda () (fl+* 3.0 123 9.0)))
(check-tail-exn type-exception? (lambda () (fl+* 3.0 9.0 123)))
