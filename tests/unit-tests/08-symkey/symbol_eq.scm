(include "#.scm")

;; These names are only called outside test-* in prim_symbol.scm.
(test-eq #t (symbol=? 'a 'a 'a))
(test-eq #f (symbol=? 'a 'b))
(test-eq 'a (string->symbol "a"))
(test-equal "a" (symbol->string 'a))
(test-error-tail type-exception? (symbol=? 'a 1))
(test-error-tail type-exception? (string->symbol 1))
(test-error-tail type-exception? (symbol->string 1))
(test-error-tail wrong-number-of-arguments-exception? (string->symbol))
(test-error-tail wrong-number-of-arguments-exception? (symbol->string))
(test-error-tail wrong-number-of-arguments-exception? (symbol->string 'a 1))
