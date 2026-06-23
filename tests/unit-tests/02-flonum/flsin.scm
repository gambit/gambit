(include "#.scm")

(test-approximate -.8414709848078965 (##flsin -1.) 1e-12)
(test-approximate -.479425538604203 (##flsin -.5) 1e-12)
(test-approximate -0. (##flsin -0.) 1e-12)
(test-approximate 0. (##flsin 0.) 1e-12)
(test-approximate .479425538604203 (##flsin .5) 1e-12)
(test-approximate .8414709848078965 (##flsin 1.) 1e-12)

(test-approximate -.8414709848078965 (flsin -1.) 1e-12)
(test-approximate -.479425538604203 (flsin -.5) 1e-12)
(test-approximate -0. (flsin -0.) 1e-12)
(test-approximate 0. (flsin 0.) 1e-12)
(test-approximate .479425538604203 (flsin .5) 1e-12)
(test-approximate .8414709848078965 (flsin 1.) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (flsin))
(test-error-tail wrong-number-of-arguments-exception? (flsin 1. 2. 3.))

(test-error-tail type-exception? (flsin 0))
(test-error-tail type-exception? (flsin 1/2))
(test-error-tail type-exception? (flsin 'a))
