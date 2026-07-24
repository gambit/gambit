(include "#.scm")

(test-eqv -6684877 (##fxnot 6684876))
(test-eqv 1671219 (##fxnot -1671220))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -229683581002580173 (##fxnot 229683581002580172))
      (test-eqv 57420895250645043 (##fxnot -57420895250645044))))

(test-eqv -6684877 (fxnot 6684876))
(test-eqv 1671219 (fxnot -1671220))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -229683581002580173 (fxnot 229683581002580172))
      (test-eqv 57420895250645043 (fxnot -57420895250645044))))

(test-error-tail wrong-number-of-arguments-exception? (fxnot))
(test-error-tail wrong-number-of-arguments-exception? (fxnot 0 0))

(test-error-tail type-exception? (fxnot 1.5))
