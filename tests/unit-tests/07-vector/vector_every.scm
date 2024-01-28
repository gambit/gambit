(include "#.scm")

(define bool #f)

(define vect0 '#())
(define vect1 '#(11))
(define vect2 '#(11 22))
(define vect3 '#(11 22 33))

(define (inc x) (+ x 1))
(define (add x y) (+ x y))

(check-equal? (vector-every + vect0 vect2) #t)
(check-equal? (vector-every + vect1 vect2) 22)
(check-equal? (vector-every + vect3 vect2) 44)

(check-tail-exn type-exception? (lambda () (vector-every #f vect0)))
(check-tail-exn type-exception? (lambda () (vector-every inc #f)))
(check-tail-exn type-exception? (lambda () (vector-every add '#(1 2) #f)))
(check-tail-exn type-exception? (lambda () (vector-every add #f '#(1 2))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-every)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-every inc)))
