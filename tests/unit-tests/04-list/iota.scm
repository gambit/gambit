(include "#.scm")

(define bool #f)

(test-equal '() (iota 0))
(test-equal '(0) (iota 1))
(test-equal '(0 1) (iota 2))
(test-equal '(0 1 2) (iota 3))
(test-equal '(0 1 2 3) (iota 4))
(test-equal '(3 4 5 6) (iota 4 3))
(test-equal '(10 12 14 16) (iota 4 10 2))
(test-equal '(10 9 8 7) (iota 4 10 -1))

(test-equal '(10 10.5 11. 11.5) (iota 4 10 .5))

(test-equal '(10 10 10 10) (iota 4 10 0))
(test-equal '(10 10. 10. 10.) (iota 4 10 0.))
(test-equal '(10. 11. 12. 13.) (iota 4 10. 1))

(test-error-tail type-exception? (iota bool))
(test-error-tail type-exception? (iota bool 0))
(test-error-tail type-exception? (iota 0 bool))
(test-error-tail type-exception? (iota bool 0 0))
(test-error-tail type-exception? (iota 0 bool 0))
(test-error-tail type-exception? (iota 0 0 bool))

(test-error-tail range-exception? (iota -1))
(test-error-tail range-exception? (iota -1 0))
(test-error-tail range-exception? (iota -1 0 0))

(test-error-tail wrong-number-of-arguments-exception? (iota))
(test-error-tail wrong-number-of-arguments-exception? (iota 0 0 0 0))
