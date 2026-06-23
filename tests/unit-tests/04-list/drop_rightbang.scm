(include "#.scm")

(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(test-equal '(11 22 33) (drop-right! (append lst1 '()) 0))
(test-equal '(11 22) (drop-right! (append lst1 '()) 1))
(test-equal '(11) (drop-right! (append lst1 '()) 2))
(test-equal '() (drop-right! (append lst1 '()) 3))

(test-equal '(11 22 33 44) (drop-right! (append lst2 '()) 0))
(test-equal '(11 22 33) (drop-right! (append lst2 '()) 1))
(test-equal '(11 22) (drop-right! (append lst2 '()) 2))
(test-equal '(11) (drop-right! (append lst2 '()) 3))
(test-equal '() (drop-right! (append lst2 '()) 4))

(test-equal '() (drop-right! bool 0))
(test-equal '(1 2) (drop-right! (cons 1 (cons 2 3)) 0))
(test-equal '(1) (drop-right! (cons 1 (cons 2 3)) 1))
(test-equal '() (drop-right! (cons 1 (cons 2 3)) 2))

(test-error-tail range-exception? (drop-right! (append lst1 '()) 4))
(test-error-tail range-exception? (drop-right! (append lst1 '()) -1))

(test-error-tail wrong-number-of-arguments-exception? (drop-right!))
(test-error-tail
 wrong-number-of-arguments-exception?
 (drop-right! (append lst1 '())))
(test-error-tail
 wrong-number-of-arguments-exception?
 (drop-right! (append lst1 '()) 0 0))
