(include "#.scm")

(test-equal '(a b c d) (vector-fold-right xcons '() '#(a b c d)))

(test-error-tail type-exception? (vector-fold-right 4 4 '#()))
(test-error-tail type-exception? (vector-fold-right xcons 4 '()))
(test-error-tail type-exception? (vector-fold-right xcons 4 '#() '()))

(test-error-tail wrong-number-of-arguments-exception? (vector-fold-right))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-fold-right xcons))
(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-fold-right xcons 0))

(set! ##allow-length-mismatch? #f)
(test-error-tail
 length-mismatch-exception?
 (vector-fold-right + 0 '#(1) '#(1 2) '#(1)))
