(include "#.scm")

(test-eqv 5 (##bitwise-merge 3 6 13))
(test-eqv 4 (##bitwise-merge 0 4 15))
(test-eqv 15 (##bitwise-merge 15 0 15))
(test-eqv 285159927045178096942975780541 (##bitwise-merge 53828050899104957602714708999 245358458149467567834270444219 444235402445465020229920298525))

(test-eqv 5 (bitwise-merge 3 6 13))
(test-eqv 4 (bitwise-merge 0 4 15))
(test-eqv 15 (bitwise-merge 15 0 15))
(test-eqv 285159927045178096942975780541 (bitwise-merge 53828050899104957602714708999 245358458149467567834270444219 444235402445465020229920298525))

(test-error-tail wrong-number-of-arguments-exception? (bitwise-merge))
(test-error-tail wrong-number-of-arguments-exception? (bitwise-merge 1))
(test-error-tail wrong-number-of-arguments-exception? (bitwise-merge 1 2))
(test-error-tail wrong-number-of-arguments-exception? (bitwise-merge 1 2 3 4))

(test-error-tail type-exception? (bitwise-merge 1.0 2 3))
(test-error-tail type-exception? (bitwise-merge 1 2.0 3))
(test-error-tail type-exception? (bitwise-merge 1 2 3.0))
