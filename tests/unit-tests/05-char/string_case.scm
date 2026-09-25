(include "#.scm")

(test-equal "abcde" (string-downcase "AbCdE"))
(test-equal "ABCDE" (string-upcase "AbCdE"))
(test-equal "abcde" (string-foldcase "AbCdE"))
(test-error-tail type-exception? (string-downcase 1))
(test-error-tail type-exception? (string-upcase 1))
(test-error-tail type-exception? (string-foldcase 1))
