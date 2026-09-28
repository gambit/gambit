(include "#.scm")

(test-eqv 0. (##flexpm1 0.))
(test-approximate 1.718281828459045 (##flexpm1 1.) 1e-12)
(test-approximate -.6321205588285577 (##flexpm1 -1.) 1e-12)

(test-eqv 0. (flexpm1 0.))
(test-approximate 1.718281828459045 (flexpm1 1.) 1e-12)
(test-approximate -.6321205588285577 (flexpm1 -1.) 1e-12)

(test-error-tail type-exception? (flexpm1 0))
(test-error-tail type-exception? (flexpm1 1/2))
(test-error-tail type-exception? (flexpm1 'a))

(test-error-tail wrong-number-of-arguments-exception? (flexpm1))
(test-error-tail wrong-number-of-arguments-exception? (flexpm1 1. 1.))
