(include "#.scm")

(define str "foo")
(define int 11)
(define bool #f)

(define lst1 '(11 22 33))
(define lst2 (list 11 22 33 44))

(test-equal '(99 22 33) (list-set lst1 0 99))
(test-equal '(11 99 33) (list-set lst1 1 99))
(test-equal '(11 22 99) (list-set lst1 2 99))

(test-eq (void) (list-set! lst2 0 55))
(test-equal '(55 22 33 44) lst2)
(test-eq (void) (list-set! lst2 1 66))
(test-equal '(55 66 33 44) lst2)
(test-eq (void) (list-set! lst2 2 77))
(test-equal '(55 66 77 44) lst2)
(test-eq (void) (list-set! lst2 3 88))
(test-equal '(55 66 77 88) lst2)

(test-error-tail type-exception? (list-set bool 0 11))
(test-error-tail type-exception? (list-set lst1 bool 11))

(test-error-tail range-exception? (list-set lst1 -1 0))
(test-error-tail type-exception? (list-set lst1 3 0))

(test-error-tail type-exception? (list-set! bool 0 11))
(test-error-tail type-exception? (list-set! lst1 bool 11))

(test-error-tail range-exception? (list-set! lst1 -1 0))
(test-error-tail type-exception? (list-set! lst1 3 0))

(test-error-tail wrong-number-of-arguments-exception? (list-set!))
(test-error-tail wrong-number-of-arguments-exception? (list-set! lst2))
(test-error-tail wrong-number-of-arguments-exception? (list-set! lst2 0))
(test-error-tail wrong-number-of-arguments-exception? (list-set! lst2 0 0 0))
