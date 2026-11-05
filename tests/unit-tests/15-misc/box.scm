(include "#.scm")

(define b (box 5))

(test-assert (box? b))
(test-assert (box? (box 0)))
(test-eq #f (box? 5))
(test-eq 5 (unbox b))
(test-eq (void) (set-box! b 7))
(test-eq 7 (unbox b))

(test-error-tail type-exception? (unbox 1))
(test-error-tail type-exception? (set-box! 1 2))
(test-error-tail wrong-number-of-arguments-exception? (box))
(test-error-tail wrong-number-of-arguments-exception? (box 1 2))
(test-error-tail wrong-number-of-arguments-exception? (unbox))
(test-error-tail wrong-number-of-arguments-exception? (set-box! b))
