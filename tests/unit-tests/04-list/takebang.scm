(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(test-equal '() (take! (append lst1 '()) 0))
(test-equal '(11) (take! (append lst1 '()) 1))
(test-equal '(11 22) (take! (append lst1 '()) 2))
(test-equal '(11 22 33) (take! (append lst1 '()) 3))

(test-equal '() (take! (append lst2 '()) 0))
(test-equal '(11) (take! (append lst2 '()) 1))
(test-equal '(11 22) (take! (append lst2 '()) 2))
(test-equal '(11 22 33) (take! (append lst2 '()) 3))
(test-equal '(11 22 33 44) (take! (append lst2 '()) 4))

(test-equal '() (take! bool 0))
(test-equal '() (take! (cons 1 (cons 2 3)) 0))
(test-equal '(1) (take! (cons 1 (cons 2 3)) 1))
(test-equal '(1 2) (take! (cons 1 (cons 2 3)) 2))

(test-error-tail range-exception? (take! (append lst1 '()) 4))
(test-error-tail range-exception? (take! (append lst1 '()) -1))

(test-error-tail wrong-number-of-arguments-exception? (take!))
(test-error-tail
 wrong-number-of-arguments-exception?
 (take! (append lst1 '())))
(test-error-tail
 wrong-number-of-arguments-exception?
 (take! (append lst1 '()) 0 0))
