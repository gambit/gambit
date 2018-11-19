(include "#.scm")

(define bool #f)

(define lst0 '())
(define lst1 '(11))
(define lst2 (list 11 22))

(define (inc x) (+ x 1))
(define (add x y) (+ x y))

(check-equal? (map inc lst0) '())
(check-equal? (map inc lst1) '(12))
(check-equal? (map inc lst2) '(12 23))

(check-equal? (map add lst0 '()) '())
(check-equal? (map add lst1 '(1)) '(12))
(check-equal? (map add lst2 '(1 2)) '(12 24))

;; these checks verify that lists of different lengths can be used
(check-equal? (map add lst2 '(1)) '(12))
(check-equal? (map add '(1) lst2) '(12))
(check-equal? (map add lst2 '()) '())
(check-equal? (map add '() lst2) '())

(check-equal? (map list lst0 lst0 '()) '())
(check-equal? (map list lst1 lst1 '(1)) '((11 11 1)))
(check-equal? (map list lst2 lst2 '(1 2)) '((11 11 1) (22 22 2)))
(check-equal? (map list lst2 lst2 '(1 2)) '((11 11 1) (22 22 2)))

;; these checks verify that lists of different lengths can be used
(check-equal? (map list lst2 lst2 '(1)) '((11 11 1)))
(check-equal? (map list lst2 '(1) lst2) '((11 1 11)))
(check-equal? (map list '(1) lst2 lst2) '((1 11 11)))
(check-equal? (map list lst2 lst2 '()) '())
(check-equal? (map list lst2 '() lst2) '())
(check-equal? (map list '() lst2 lst2) '())

(check-tail-exn type-exception? (lambda () (map bool lst0)))

;; these checks are disabled (bool is an improper list)
;;(check-tail-exn type-exception? (lambda () (map inc bool)))
;;(check-tail-exn type-exception? (lambda () (map add lst0 bool)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (map)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (map inc)))
