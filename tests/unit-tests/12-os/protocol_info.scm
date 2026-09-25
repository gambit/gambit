(include "#.scm")

(define p (protocol-info "tcp"))

(test-assert (protocol-info? p))
(test-equal "tcp" (protocol-info-name p))
(test-eqv 6 (protocol-info-number p))
(test-assert (list? (protocol-info-aliases p)))
(test-assert (protocol-info? (protocol-info 6)))

(test-error-tail wrong-number-of-arguments-exception? (protocol-info))
(test-error-tail wrong-number-of-arguments-exception? (protocol-info "tcp" #f))
(test-error-tail type-exception? (protocol-info #f))
(test-error-tail type-exception? (protocol-info-name #f))
(test-error-tail type-exception? (protocol-info-number #f))
(test-error-tail type-exception? (protocol-info-aliases #f))
(test-error-tail wrong-number-of-arguments-exception? (protocol-info-name))
(test-error-tail wrong-number-of-arguments-exception? (protocol-info-number))
(test-error-tail wrong-number-of-arguments-exception? (protocol-info-aliases))
