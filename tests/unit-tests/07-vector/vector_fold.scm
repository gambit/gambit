(include "#.scm")


(check-equal? (vector-fold (lambda (len str)
                             (max (string-length str) len))
                           0
                           '#("a b c" "ab" "" "cde"))
              5)

(check-equal? (vector-fold xcons
                           '()
                           '#(a b c d))
              '(d c b a))
(check-equal? (vector-fold (lambda (counter n)
                             (if (even? n) (+ counter 1) counter))
                           0
                           '#(0 1 2 3 4))
              3)

(check-tail-exn type-exception? (lambda () (vector-fold 4 4 '#())))
(check-tail-exn type-exception? (lambda () (vector-fold xcons 4 '())))
(check-tail-exn type-exception? (lambda () (vector-fold xcons 4 '#()'())))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fold)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fold xcons)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (vector-fold xcons 0)))

(set! ##allow-length-mismatch? #f)
(check-tail-exn length-mismatch-exception? (lambda () (vector-fold + 0 '#(1) '#(1 2) '#(1))))
