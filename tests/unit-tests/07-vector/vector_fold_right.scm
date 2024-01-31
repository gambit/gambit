(include "#.scm")

(check-equal? (vector-fold-right xcons
                                 '()
                                 '#(a b c d))
              '(a b c d))

(check-tail-exn type-exception? (lambda () (vector-fold-right 4 4 '#())))
(check-tail-exn type-exception? (lambda () (vector-fold-right xcons 4 '())))
(check-tail-exn type-exception? (lambda () (vector-fold-right xcons 4 '#()'())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fold-right)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fold-right xcons)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fold-right xcons 0)))
