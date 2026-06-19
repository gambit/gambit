(include "#.scm")

(test-approximate 0.0 (fltanh 0.) 1e-12)
(test-approximate 0.46211715726000974 (fltanh 0.5) 1e-12)
(test-approximate -0.46211715726000974 (fltanh -0.5) 1e-12)

(test-error-tail type-exception? (fltanh 0))
(test-error-tail type-exception? (fltanh 1/2))
(test-error-tail type-exception? (fltanh 'a))
