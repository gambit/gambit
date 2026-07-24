(include "#.scm")

(test-eqv 1 (##integer-nth-root 1 3))
(test-eqv 10 (##integer-nth-root 1024 3))
(test-eqv 3 (##integer-nth-root 81 4))
(test-eqv 2 (##integer-nth-root 15 3))
(test-eqv 12345678901234567890123456789 (##integer-nth-root 12345678901234567890123456789 1))
(test-eqv 111111110611111 (##integer-nth-root 12345678901234567890123456789 2))
(test-eqv 2311204240 (##integer-nth-root 12345678901234567890123456789 3))
(test-eqv 10540925 (##integer-nth-root 12345678901234567890123456789 4))

(test-eqv 1 (integer-nth-root 1 3))
(test-eqv 10 (integer-nth-root 1024 3))
(test-eqv 3 (integer-nth-root 81 4))
(test-eqv 2 (integer-nth-root 15 3))
(test-eqv 12345678901234567890123456789 (integer-nth-root 12345678901234567890123456789 1))
(test-eqv 111111110611111 (integer-nth-root 12345678901234567890123456789 2))
(test-eqv 2311204240 (integer-nth-root 12345678901234567890123456789 3))
(test-eqv 10540925 (integer-nth-root 12345678901234567890123456789 4))

(test-error-tail wrong-number-of-arguments-exception? (integer-nth-root))
(test-error-tail wrong-number-of-arguments-exception? (integer-nth-root 8))
(test-error-tail wrong-number-of-arguments-exception? (integer-nth-root 1 2 3))

(test-error-tail type-exception? (integer-nth-root 1.0 2))
(test-error-tail type-exception? (integer-nth-root 1 2.0))

(test-error-tail range-exception? (integer-nth-root -1 1))
(test-error-tail range-exception? (integer-nth-root 1 0))
