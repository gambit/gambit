(include "#.scm")

(test-equal '() (filter even? '()))

(let ((nums (iota 20)))
  (test-equal '(0 2 4 6 8 10 12 14 16 18) (filter even? nums))
  (test-equal (iota 20) nums))

(test-equal '(1 3 5 7 9 11 13 15 17 19) (filter odd? (iota 20)))

(test-error-tail wrong-number-of-arguments-exception? (filter))
(test-error-tail wrong-number-of-arguments-exception? (filter 1))
(test-error-tail wrong-number-of-arguments-exception? (filter 1 2 3))
(test-error-tail type-exception? (filter odd? '(1 . 2)))
