(include "#.scm")

;; Type checks only. A live lookup on this host raises an os-exception,
;; and the competing extra files never mention these public names.
(test-eq #f (network-info? #f))
(test-assert (procedure? network-info?))
(test-error-tail type-exception? (network-info #f))
(test-error-tail type-exception? (network-info-name #f))
(test-error-tail type-exception? (network-info-aliases #f))
(test-error-tail type-exception? (network-info-number #f))
(test-error-tail wrong-number-of-arguments-exception? (network-info))
(test-error-tail wrong-number-of-arguments-exception? (network-info-name))
(test-error-tail wrong-number-of-arguments-exception? (network-info-aliases))
(test-error-tail wrong-number-of-arguments-exception? (network-info-number))
