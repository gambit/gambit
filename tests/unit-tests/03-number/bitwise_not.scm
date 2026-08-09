(include "#.scm")

(test-eqv -6684877 (##bitwise-not 6684876))
(test-eqv 1671219 (##bitwise-not -1671220))

(test-eqv -229683581002580173 (##bitwise-not 229683581002580172))
(test-eqv 57420895250645043 (##bitwise-not -57420895250645044))

(test-eqv -258600722446559027588908456476877 (##bitwise-not 258600722446559027588908456476876))
(test-eqv 64650180611639756897227114119219 (##bitwise-not -64650180611639756897227114119220))

(test-eqv -6684877 (bitwise-not 6684876))
(test-eqv 1671219 (bitwise-not -1671220))

(test-eqv -229683581002580173 (bitwise-not 229683581002580172))
(test-eqv 57420895250645043 (bitwise-not -57420895250645044))

(test-eqv -258600722446559027588908456476877 (bitwise-not 258600722446559027588908456476876))
(test-eqv 64650180611639756897227114119219 (bitwise-not -64650180611639756897227114119220))

(test-error-tail wrong-number-of-arguments-exception? (bitwise-not))
(test-error-tail wrong-number-of-arguments-exception? (bitwise-not 0 0))

(test-error-tail type-exception? (bitwise-not 1.5))
