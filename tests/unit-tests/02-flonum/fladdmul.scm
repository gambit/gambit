(include "#.scm")

(test-approximate -1.1102230246251565e-16 (##fl+* -.4 3. 1.2) 1e-12)
(test-approximate
 1.
 (##fl+* -268435455. 268435457. 7.205759403792794e16)
 1e-12)

(test-approximate -1.1102230246251565e-16 (fl+* -.4 3. 1.2) 1e-12)
(test-approximate 1. (fl+* -268435455. 268435457. 7.205759403792794e16) 1e-12)

(test-error-tail wrong-number-of-arguments-exception? (fl+* 1.))
(test-error-tail wrong-number-of-arguments-exception? (fl+* 1. 2.))
(test-error-tail wrong-number-of-arguments-exception? (fl+* 1. 2. 3. 4.))

(test-error-tail type-exception? (fl+* 123 3. 9.))
(test-error-tail type-exception? (fl+* 3. 123 9.))
(test-error-tail type-exception? (fl+* 3. 9. 123))
