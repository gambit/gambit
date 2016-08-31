(include "#.scm")

(define str "abc")
(define char #\a)
(define int 1)

(check-equal? (##string-copy "") "")
(check-equal? (string-copy "") "")

(check-equal? (##string-copy str) str)
(check-equal? (string-copy str) str)

(check-tail-exn type-exception? (lambda () (string-copy char)))
(check-tail-exn type-exception? (lambda () (string-copy int)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-copy)))
