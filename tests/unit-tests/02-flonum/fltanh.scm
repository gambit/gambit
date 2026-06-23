(include "#.scm")

(test-approximate 0. (##fltanh 0.) 1e-12)
(test-approximate .46211715726000974 (##fltanh .5) 1e-12)
(test-approximate -.46211715726000974 (##fltanh -.5) 1e-12)

(test-approximate 0. (fltanh 0.) 1e-12)
(test-approximate .46211715726000974 (fltanh .5) 1e-12)
(test-approximate -.46211715726000974 (fltanh -.5) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (fltanh))
(test-error-tail wrong-number-of-arguments-exception? (fltanh 1. 2. 3.))

(test-error-tail type-exception? (fltanh 0))
(test-error-tail type-exception? (fltanh 1/2))
(test-error-tail type-exception? (fltanh 'a))
