(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(test-equal '(11 22 33) (drop lst1 0))
(test-equal '(22 33) (drop lst1 1))
(test-equal '(33) (drop lst1 2))
(test-equal '() (drop lst1 3))

(test-equal '(11 22 33 44) (drop lst2 0))
(test-equal '(22 33 44) (drop lst2 1))
(test-equal '(33 44) (drop lst2 2))
(test-equal '(44) (drop lst2 3))
(test-equal '() (drop lst2 4))

(test-equal bool (drop bool 0))
(test-equal '(1 2 . 3) (drop '(1 2 . 3) 0))
(test-equal '(2 . 3) (drop '(1 2 . 3) 1))
(test-equal 3 (drop '(1 2 . 3) 2))

(test-error-tail range-exception? (drop lst1 4))
(test-error-tail range-exception? (drop lst1 -1))

(test-error-tail wrong-number-of-arguments-exception? (drop))
(test-error-tail wrong-number-of-arguments-exception? (drop lst1))
(test-error-tail wrong-number-of-arguments-exception? (drop lst1 0 0))
