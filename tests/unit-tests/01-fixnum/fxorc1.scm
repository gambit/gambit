(include "#.scm")

(test-eqv -2228293 (##fxorc1 6684876 5570730))
(test-eqv -2228293 (##fxorc1 6684876 -2785366))
(test-eqv 6127803 (##fxorc1 -1671220 5570730))
(test-eqv -2228293 (##fxorc1 -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -76561193667526725 (##fxorc1 229683581002580172 191402984168816810))
      (test-eqv -76561193667526725 (##fxorc1 229683581002580172 -95701492084408406))
      (test-eqv 210543282585698491 (##fxorc1 -57420895250645044 191402984168816810))
      (test-eqv -76561193667526725 (##fxorc1 -57420895250645044 -95701492084408406))))

(test-eqv -2228293 (fxorc1 6684876 5570730))
(test-eqv -2228293 (fxorc1 6684876 -2785366))
(test-eqv 6127803 (fxorc1 -1671220 5570730))
(test-eqv -2228293 (fxorc1 -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -76561193667526725 (fxorc1 229683581002580172 191402984168816810))
      (test-eqv -76561193667526725 (fxorc1 229683581002580172 -95701492084408406))
      (test-eqv 210543282585698491 (fxorc1 -57420895250645044 191402984168816810))
      (test-eqv -76561193667526725 (fxorc1 -57420895250645044 -95701492084408406))))

(test-error-tail wrong-number-of-arguments-exception? (fxorc1))
(test-error-tail wrong-number-of-arguments-exception? (fxorc1 0))
(test-error-tail wrong-number-of-arguments-exception? (fxorc1 0 0 0))

(test-error-tail type-exception? (fxorc1 1.5 2))
(test-error-tail type-exception? (fxorc1 1 2.5))
