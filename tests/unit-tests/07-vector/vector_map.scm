(include "#.scm")

(define bool #f)

(define vect0 '#())
(define vect1 '#(11))
(define vect2 (vector 11 22))

(define (inc x) (+ x 1))
(define (add x y) (+ x y))

(check-equal? (vector-map inc vect0) '#())
(check-equal? (vector-map inc vect1) '#(12))
(check-equal? (vector-map inc vect2) '#(12 23))

(check-equal? (vector-map add vect0 '#()) '#())
(check-equal? (vector-map add vect1 '#(1)) '#(12))
(check-equal? (vector-map add vect2 '#(1 2)) '#(12 24))

;; these checks verify that vectors of different lengths can be used
(check-equal? (vector-map add vect2 '#(1)) '#(12))
(check-equal? (vector-map add '#(1) vect2) '#(12))
(check-equal? (vector-map add vect2 '#()) '#())
(check-equal? (vector-map add '#() vect2) '#())

(check-equal? (vector-map list vect0 vect0 '#()) '#())
(check-equal? (vector-map list vect1 vect1 '#(1)) '#((11 11 1)))
(check-equal? (vector-map list vect2 vect2 '#(1 2)) '#((11 11 1) (22 22 2)))
(check-equal? (vector-map list vect2 vect2 '#(1 2)) '#((11 11 1) (22 22 2)))

;; these checks verify that vectors of different lengths can be used
(check-equal? (vector-map list vect2 vect2 '#(1)) '#((11 11 1)))
(check-equal? (vector-map list vect2 '#(1) vect2) '#((11 1 11)))
(check-equal? (vector-map list '#(1) vect2 vect2) '#((1 11 11)))
(check-equal? (vector-map list vect2 vect2 '#()) '#())
(check-equal? (vector-map list vect2 '#() vect2) '#())
(check-equal? (vector-map list '#() vect2 vect2) '#())

(check-tail-exn type-exception? (lambda () (vector-map #f vect0)))
(check-tail-exn type-exception? (lambda () (vector-map inc #f)))
(check-tail-exn type-exception? (lambda () (vector-map add '#(1 2) #f)))
(check-tail-exn type-exception? (lambda () (vector-map add #f '#(1 2))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-map)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-map inc)))
