(include "#.scm")

(test-equal '() (remove! even? '()))

(let ((nums (iota 20)))
  (test-equal '(0 2 4 6 8 10 12 14 16 18) (remove! odd? nums))
  (test-equal (iota 20) nums))

(test-equal '(1 3 5 7 9 11 13 15 17 19) (remove! even? (iota 20)))

(test-error-tail wrong-number-of-arguments-exception? (remove!))
(test-error-tail wrong-number-of-arguments-exception? (remove! 1))
(test-error-tail wrong-number-of-arguments-exception? (remove! 1 2 3))
(test-error-tail type-exception? (remove! odd? '(1 . 2)))
