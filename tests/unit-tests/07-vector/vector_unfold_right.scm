(include "#.scm")

(check-equal? (vector-unfold-right values 0)
              '#())

(check-equal? '#((0 . 4) (1 . 3) (2 . 2) (3 . 1) (4 . 0))
              (vector-unfold-right (lambda (i x)
                                     (values (cons i x) (+ x 1)))
                                   5 0))

(check-equal? '#(4 3 2 1 0)
              (let ((vec '#(0 1 2 3 4)))
                (vector-unfold-right (lambda (i x)
                                       (values (vector-ref vec x) (+ x 1)))
                                     (vector-length vec) 0)))

(check-tail-exn type-exception? (lambda () (vector-unfold-right 4 4)))
(check-tail-exn type-exception? (lambda () (vector-unfold-right values 'a)))

(check-tail-exn range-exception? (lambda () (vector-unfold-right values -1)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-unfold-right)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-unfold-right values)))
