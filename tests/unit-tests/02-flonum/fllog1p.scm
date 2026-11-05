(include "#.scm")

(test-eqv 0. (##fllog1p 0.))
(test-approximate .6931471805599453 (##fllog1p 1.) 1e-12)
(test-approximate -.6931471805599453 (##fllog1p -0.5) 1e-12)

(test-eqv 0. (fllog1p 0.))
(test-approximate .6931471805599453 (fllog1p 1.) 1e-12)
(test-approximate -.6931471805599453 (fllog1p -0.5) 1e-12)

(test-error-tail type-exception? (fllog1p 0))
(test-error-tail type-exception? (fllog1p 1/2))
(test-error-tail type-exception? (fllog1p 'a))

(test-error-tail wrong-number-of-arguments-exception? (fllog1p))
(test-error-tail wrong-number-of-arguments-exception? (fllog1p 1. 1.))
