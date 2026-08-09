(include "#.scm")

(test-eqv -7799023 (##fxnor 6684876 5570730))
(test-eqv 557073 (##fxnor 6684876 -2785366))
(test-eqv 557073 (##fxnor -1671220 5570730))
(test-eqv 557073 (##fxnor -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -267964177836343535 (##fxnor 229683581002580172 191402984168816810))
      (test-eqv 19140298416881681 (##fxnor 229683581002580172 -95701492084408406))
      (test-eqv 19140298416881681 (##fxnor -57420895250645044 191402984168816810))
      (test-eqv 19140298416881681 (##fxnor -57420895250645044 -95701492084408406))))

(test-eqv -7799023 (fxnor 6684876 5570730))
(test-eqv 557073 (fxnor 6684876 -2785366))
(test-eqv 557073 (fxnor -1671220 5570730))
(test-eqv 557073 (fxnor -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -267964177836343535 (fxnor 229683581002580172 191402984168816810))
      (test-eqv 19140298416881681 (fxnor 229683581002580172 -95701492084408406))
      (test-eqv 19140298416881681 (fxnor -57420895250645044 191402984168816810))
      (test-eqv 19140298416881681 (fxnor -57420895250645044 -95701492084408406))))

(test-error-tail wrong-number-of-arguments-exception? (fxnor))
(test-error-tail wrong-number-of-arguments-exception? (fxnor 0))
(test-error-tail wrong-number-of-arguments-exception? (fxnor 0 0 0))

(test-error-tail type-exception? (fxnor 1.5 2))
(test-error-tail type-exception? (fxnor 1 2.5))
