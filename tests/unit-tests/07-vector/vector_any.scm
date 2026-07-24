(include "#.scm")

(define bool #f)

(define vect0 '#())
(define vect1 '#(11))
(define vect2 '#(11 22))
(define vect3 '#(11 22 33))

(define (inc x) (+ x 1))
(define add +)

(check-equal? (vector-any + vect0 vect2) #f)
(check-equal? (vector-any + vect1 vect2) 22)
(check-equal? (vector-any + vect3 vect2) 22)

(check-tail-exn type-exception? (lambda () (vector-any #f vect0)))
(check-tail-exn type-exception? (lambda () (vector-any inc #f)))
(check-tail-exn type-exception? (lambda () (vector-any add '#(1 2) #f)))
(check-tail-exn type-exception? (lambda () (vector-any add #f '#(1 2))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-any)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-any inc)))

(set! ##allow-length-mismatch? #f)
(check-tail-exn length-mismatch-exception? (lambda () (vector-any add '#(1) '#(1 2) '#(1))))
