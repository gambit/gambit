(include "#.scm")

(test-eqv 192 (##copy-bit-field 4 2 1 240))
(test-eqv 240 (##copy-bit-field 0 4 15 240))
(test-eqv 48 (##copy-bit-field 2 6 0 240))
(test-eqv 45358457817518384129853008571 (##copy-bit-field 50 20 444235402445465020229920298525 45358458149467567834270444219))

(test-eqv 192 (copy-bit-field 4 2 1 240))
(test-eqv 240 (copy-bit-field 0 4 15 240))
(test-eqv 48 (copy-bit-field 2 6 0 240))
(test-eqv 45358457817518384129853008571 (copy-bit-field 50 20 444235402445465020229920298525 45358458149467567834270444219))

(test-error-tail wrong-number-of-arguments-exception? (copy-bit-field))
(test-error-tail wrong-number-of-arguments-exception? (copy-bit-field 1))
(test-error-tail wrong-number-of-arguments-exception? (copy-bit-field 1 2))
(test-error-tail wrong-number-of-arguments-exception? (copy-bit-field 1 2 3))
(test-error-tail wrong-number-of-arguments-exception? (copy-bit-field 1 2 3 4 5))

(test-error-tail type-exception? (copy-bit-field 1.0 2 3 4))
(test-error-tail type-exception? (copy-bit-field 1 2.0 3 4))
(test-error-tail type-exception? (copy-bit-field 1 2 3.0 4))
(test-error-tail type-exception? (copy-bit-field 1 2 3 4.0))
(test-error-tail type-exception? (copy-bit-field -1 0 0 0))
(test-error-tail type-exception? (copy-bit-field 0 -1 0 0))
