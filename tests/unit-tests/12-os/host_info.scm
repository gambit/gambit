(include "#.scm")


(test-assert (host-info? (##host-info "localhost")))
(test-assert (host-info? (##host-info '#u8(127 0 0 1))))

;;(test-assert (string? (##host-info-name (##host-info "localhost"))))
;;(test-assert (list? (##host-info-aliases (##host-info "localhost"))))
;;(test-assert (list? (##host-info-addresses (##host-info "localhost"))))


(test-assert (host-info? (host-info "localhost")))
(test-assert (host-info? (host-info '#u8(127 0 0 1))))

(test-assert (string? (host-info-name (host-info "localhost"))))
(test-assert (list? (host-info-aliases (host-info "localhost"))))
(test-assert (list? (host-info-addresses (host-info "localhost"))))


(test-error-tail wrong-number-of-arguments-exception? (host-info))
(test-error-tail wrong-number-of-arguments-exception? (host-info "localhost" #f))

(test-error-tail wrong-number-of-arguments-exception? (host-info-name))
(test-error-tail wrong-number-of-arguments-exception? (host-info-name (host-info "localhost") #f))
(test-error-tail wrong-number-of-arguments-exception? (host-info-aliases))
(test-error-tail wrong-number-of-arguments-exception? (host-info-aliases (host-info "localhost") #f))
(test-error-tail wrong-number-of-arguments-exception? (host-info-addresses))
(test-error-tail wrong-number-of-arguments-exception? (host-info-addresses (host-info "localhost") #f))

(test-error-tail type-exception? (host-info #f))

(test-error-tail type-exception? (host-info-name #f))
(test-error-tail type-exception? (host-info-aliases #f))
(test-error-tail type-exception? (host-info-addresses #f))
