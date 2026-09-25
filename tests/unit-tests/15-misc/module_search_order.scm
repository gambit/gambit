(include "#.scm")

(test-eq (void) (module-search-order-add! "."))
(test-eq (void) (module-whitelist-add! "github.com/gambit"))
(test-eq (void) (module-search-order-reset!))
(test-eq (void) (module-whitelist-reset!))

(test-error-tail wrong-number-of-arguments-exception? (module-search-order-add!))
(test-error-tail wrong-number-of-arguments-exception? (module-search-order-reset! 1))
(test-error-tail wrong-number-of-arguments-exception? (module-whitelist-add!))
(test-error-tail wrong-number-of-arguments-exception? (module-whitelist-reset! 1))
