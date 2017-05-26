(include "#.scm")

(define str "abc")
(define char #\a)
(define int 1)

(check-true (##string? str))
(check-true (string? str))

(check-false (##string? char))
(check-false (##string? int))
(check-false (string? char))
(check-false (string? int))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string? str str)))
