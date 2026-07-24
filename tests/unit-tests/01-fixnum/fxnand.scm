(include "#.scm")

(test-eqv -4456585 (##fxnand 6684876 5570730))
(test-eqv -4456585 (##fxnand 6684876 -2785366))
(test-eqv -4456585 (##fxnand -1671220 5570730))
(test-eqv 3899511 (##fxnand -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -153122387335053449 (##fxnand 229683581002580172 191402984168816810))
      (test-eqv -153122387335053449 (##fxnand 229683581002580172 -95701492084408406))
      (test-eqv -153122387335053449 (##fxnand -57420895250645044 191402984168816810))
      (test-eqv 133982088918171767 (##fxnand -57420895250645044 -95701492084408406))))

(test-eqv -4456585 (fxnand 6684876 5570730))
(test-eqv -4456585 (fxnand 6684876 -2785366))
(test-eqv -4456585 (fxnand -1671220 5570730))
(test-eqv 3899511 (fxnand -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv -153122387335053449 (fxnand 229683581002580172 191402984168816810))
      (test-eqv -153122387335053449 (fxnand 229683581002580172 -95701492084408406))
      (test-eqv -153122387335053449 (fxnand -57420895250645044 191402984168816810))
      (test-eqv 133982088918171767 (fxnand -57420895250645044 -95701492084408406))))

(test-error-tail wrong-number-of-arguments-exception? (fxnand))
(test-error-tail wrong-number-of-arguments-exception? (fxnand 0))
(test-error-tail wrong-number-of-arguments-exception? (fxnand 0 0 0))

(test-error-tail type-exception? (fxnand 1.5 2))
(test-error-tail type-exception? (fxnand 1 2.5))
