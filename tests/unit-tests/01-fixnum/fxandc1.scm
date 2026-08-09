(include "#.scm")

(test-eqv 1114146 (##fxandc1 6684876 5570730))
(test-eqv -7241950 (##fxandc1 6684876 -2785366))
(test-eqv 1114146 (##fxandc1 -1671220 5570730))
(test-eqv 1114146 (##fxandc1 -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv 38280596833763362 (##fxandc1 229683581002580172 191402984168816810))
      (test-eqv -248823879419461854 (##fxandc1 229683581002580172 -95701492084408406))
      (test-eqv 38280596833763362 (##fxandc1 -57420895250645044 191402984168816810))
      (test-eqv 38280596833763362 (##fxandc1 -57420895250645044 -95701492084408406))))

(test-eqv 1114146 (fxandc1 6684876 5570730))
(test-eqv -7241950 (fxandc1 6684876 -2785366))
(test-eqv 1114146 (fxandc1 -1671220 5570730))
(test-eqv 1114146 (fxandc1 -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv 38280596833763362 (fxandc1 229683581002580172 191402984168816810))
      (test-eqv -248823879419461854 (fxandc1 229683581002580172 -95701492084408406))
      (test-eqv 38280596833763362 (fxandc1 -57420895250645044 191402984168816810))
      (test-eqv 38280596833763362 (fxandc1 -57420895250645044 -95701492084408406))))

(test-error-tail wrong-number-of-arguments-exception? (fxandc1))
(test-error-tail wrong-number-of-arguments-exception? (fxandc1 0))
(test-error-tail wrong-number-of-arguments-exception? (fxandc1 0 0 0))

(test-error-tail type-exception? (fxandc1 1.5 2))
(test-error-tail type-exception? (fxandc1 1 2.5))
