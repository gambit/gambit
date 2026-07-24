(include "#.scm")

(check-equal? (vector-unfold values 0)
              '#())

(check-equal? (vector-unfold (lambda (k i j)
                               (values j j (+ i j)))
                             10 1 1)
              '#(1 2 3 5 8 13 21 34 55 89))

(check-equal? (vector-unfold values 10)
              '#(0 1 2 3 4 5 6 7 8 9))

(let ((v '#(0 2 4 6 8)))
  (check-equal? (vector-unfold (lambda (i)
                                 (vector-ref v i))
                               3)
                '#(0 2 4)))

(check-tail-exn type-exception? (lambda () (vector-unfold 4 4)))
(check-tail-exn type-exception? (lambda () (vector-unfold values 'a)))

(check-tail-exn range-exception? (lambda () (vector-unfold values -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-unfold)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-unfold values)))
