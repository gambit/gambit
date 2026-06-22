(include "#.scm")

(test-eqv 2228292 (##fxandc2 6684876 5570730))
(test-eqv 2228292 (##fxandc2 6684876 -2785366))
(test-eqv -6127804 (##fxandc2 -1671220 5570730))
(test-eqv 2228292 (##fxandc2 -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv 76561193667526724 (##fxandc2 229683581002580172 191402984168816810))
      (test-eqv 76561193667526724 (##fxandc2 229683581002580172 -95701492084408406))
      (test-eqv -210543282585698492 (##fxandc2 -57420895250645044 191402984168816810))
      (test-eqv 76561193667526724 (##fxandc2 -57420895250645044 -95701492084408406))))

(test-eqv 2228292 (fxandc2 6684876 5570730))
(test-eqv 2228292 (fxandc2 6684876 -2785366))
(test-eqv -6127804 (fxandc2 -1671220 5570730))
(test-eqv 2228292 (fxandc2 -1671220 -2785366))

(if (fixnum? 1152921504606846975)
    (begin
      (test-eqv 76561193667526724 (fxandc2 229683581002580172 191402984168816810))
      (test-eqv 76561193667526724 (fxandc2 229683581002580172 -95701492084408406))
      (test-eqv -210543282585698492 (fxandc2 -57420895250645044 191402984168816810))
      (test-eqv 76561193667526724 (fxandc2 -57420895250645044 -95701492084408406))))

(test-error-tail wrong-number-of-arguments-exception? (fxandc2))
(test-error-tail wrong-number-of-arguments-exception? (fxandc2 0))
(test-error-tail wrong-number-of-arguments-exception? (fxandc2 0 0 0))

(test-error-tail type-exception? (fxandc2 1.5 2))
(test-error-tail type-exception? (fxandc2 1 2.5))
