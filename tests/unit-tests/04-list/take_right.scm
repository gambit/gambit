(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(test-equal '() (take-right lst1 0))
(test-equal '(33) (take-right lst1 1))
(test-equal '(22 33) (take-right lst1 2))
(test-equal '(11 22 33) (take-right lst1 3))

(test-equal '() (take-right lst2 0))
(test-equal '(44) (take-right lst2 1))
(test-equal '(33 44) (take-right lst2 2))
(test-equal '(22 33 44) (take-right lst2 3))
(test-equal '(11 22 33 44) (take-right lst2 4))

(test-equal bool (take-right bool 0))
(test-equal 3 (take-right '(1 2 . 3) 0))
(test-equal '(2 . 3) (take-right '(1 2 . 3) 1))
(test-equal '(1 2 . 3) (take-right '(1 2 . 3) 2))

(test-error-tail range-exception? (take-right lst1 4))
(test-error-tail range-exception? (take-right lst1 -1))

(test-error-tail wrong-number-of-arguments-exception? (take-right))
(test-error-tail wrong-number-of-arguments-exception? (take-right lst1))
(test-error-tail wrong-number-of-arguments-exception? (take-right lst1 0 0))
