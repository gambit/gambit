(include "#.scm")

(define str "abc")
(define char #\a)

(check-equal? (##string-length "") 0)
(check-equal? (##string-length str) 3)

(check-equal? (string-length "") 0)
(check-equal? (string-length str) 3)

(check-tail-exn type-exception? (lambda () (string-length char)))
(check-tail-exn type-exception? (lambda () (string-length 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-length)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-length str 0)))
