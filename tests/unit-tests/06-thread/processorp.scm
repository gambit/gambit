(include "#.scm")

(check-false (processor? 0))
(check-false (processor? #f))
(check-false (processor? "hello"))

(check-true  (processor? (current-processor)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (processor?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (processor? #f #f)))
