(include "#.scm")

(test-equal '() (remq 1 '()))

(let* ((lst1 '(a b a a b a)) (lst2 (list-copy lst1)))
  (test-equal '(b b) (remq 'a lst2))
  (test-equal lst2 lst1)
  (test-equal lst2 (remq 'c lst2)))

(test-error-tail wrong-number-of-arguments-exception? (remq))
(test-error-tail wrong-number-of-arguments-exception? (remq 1))
(test-error-tail wrong-number-of-arguments-exception? (remq 1 '() 3))
(test-error-tail type-exception? (remq 1 '(1 . 2)))
