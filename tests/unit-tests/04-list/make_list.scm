(include "#.scm")

(define bool #f)

(test-equal '() (make-list 0))
(test-equal '(0) (make-list 1))
(test-equal '(0 0) (make-list 2))
(test-equal '(99 99 99) (make-list 3 99))

(test-error-tail type-exception? (make-list bool))

(test-error-tail range-exception? (make-list -1))

(test-error-tail wrong-number-of-arguments-exception? (make-list))
(test-error-tail wrong-number-of-arguments-exception? (make-list 0 0 0))
