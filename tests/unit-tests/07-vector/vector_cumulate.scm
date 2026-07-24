(include "#.scm")

(check-equal? '#(3 4 8 9 14 23 25 30 36)
              (vector-cumulate + 0 '#(3 1 4 1 5 9 2 5 6)))

(check-tail-exn type-exception? (lambda () (vector-cumulate 4 4 'a)))
(check-tail-exn type-exception? (lambda () (vector-cumulate values 'a 'a)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-cumulate)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-cumulate values)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-cumulate values 'a '#(1 2 3) 3)))
