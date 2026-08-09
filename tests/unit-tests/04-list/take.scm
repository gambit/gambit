(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(test-equal '() (take lst1 0))
(test-equal '(11) (take lst1 1))
(test-equal '(11 22) (take lst1 2))
(test-equal '(11 22 33) (take lst1 3))

(test-equal '() (take lst2 0))
(test-equal '(11) (take lst2 1))
(test-equal '(11 22) (take lst2 2))
(test-equal '(11 22 33) (take lst2 3))
(test-equal '(11 22 33 44) (take lst2 4))

(test-equal '() (take bool 0))
(test-equal '() (take '(1 2 . 3) 0))
(test-equal '(1) (take '(1 2 . 3) 1))
(test-equal '(1 2) (take '(1 2 . 3) 2))

(test-error-tail range-exception? (take lst1 4))
(test-error-tail range-exception? (take lst1 -1))

(test-error-tail wrong-number-of-arguments-exception? (take))
(test-error-tail wrong-number-of-arguments-exception? (take lst1))
(test-error-tail wrong-number-of-arguments-exception? (take lst1 0 0))
