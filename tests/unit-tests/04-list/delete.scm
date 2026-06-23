(include "#.scm")

(test-equal '() (delete 5 '()))

(let ((nums (iota 20)))
  (test-equal
   '(0 1 2 3 4 6 7 8 9 10 11 12 13 14 15 16 17 18 19)
   (delete 5 nums))
  (test-equal (iota 20) nums))

(let ((nums (iota 20)))
  (test-equal '(0 1 2 3 4 5) (delete 5 nums <))
  (test-equal (iota 20) nums))

(let ((nums (iota 20)))
  (test-equal '(5 6 7 8 9 10 11 12 13 14 15 16 17 18 19) (delete 5 nums >))
  (test-equal (iota 20) nums))

(test-error-tail wrong-number-of-arguments-exception? (delete))
(test-error-tail wrong-number-of-arguments-exception? (delete 1))
(test-error-tail wrong-number-of-arguments-exception? (delete 1 '() < 4))
(test-error-tail type-exception? (delete 5 1))
(test-error-tail type-exception? (delete 5 (cons 1 2)))
(test-error-tail type-exception? (delete 5 '() 99))
