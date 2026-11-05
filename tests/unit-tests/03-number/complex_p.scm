(include "#.scm")

(test-eq #t (complex? 1+2i))
(test-eq #t (complex? 1))
(test-eq #f (complex? 'a))
(test-error-tail wrong-number-of-arguments-exception? (complex?))
(test-error-tail wrong-number-of-arguments-exception? (complex? 1 2))
