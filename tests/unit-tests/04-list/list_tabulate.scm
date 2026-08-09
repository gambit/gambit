(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(define (f x) (+ x 100))

(test-equal '() (list-tabulate 0 f))
(test-equal '(100) (list-tabulate 1 f))
(test-equal '(100 101) (list-tabulate 2 f))
(test-equal '(100 101 102) (list-tabulate 3 f))

(test-equal '() (list-tabulate 0 list))
(test-equal '((0)) (list-tabulate 1 list))
(test-equal '((0) (1)) (list-tabulate 2 list))
(test-equal '((0) (1) (2)) (list-tabulate 3 list))

(test-error-tail type-exception? (list-tabulate bool f))
(test-error-tail type-exception? (list-tabulate 0 bool))

(test-error-tail range-exception? (list-tabulate -1 f))

(test-error-tail wrong-number-of-arguments-exception? (list-tabulate))
(test-error-tail wrong-number-of-arguments-exception? (list-tabulate 0))
(test-error-tail wrong-number-of-arguments-exception? (list-tabulate 0 f 0))
