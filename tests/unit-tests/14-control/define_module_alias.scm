(include "#.scm")

(test-eq (void) (eval '(define-module-alias foo bar)))

(test-error expression-parsing-exception? (eval '(define-module-alias)))
(test-error expression-parsing-exception? (eval '(define-module-alias foo)))
(test-error expression-parsing-exception? (eval '(define-module-alias 1 2)))
