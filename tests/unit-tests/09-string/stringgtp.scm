(include "#.scm")

(define str-one "abc")
(define str-two "cde")
(define empty-str "")
(define char #\a)

(check-equal? (string>?) #t)
(check-equal? (string>? empty-str) #t)
(check-equal? (string>? str-one str-two) #f)
(check-equal? (string>? str-two str-one) #t)
(check-equal? (string>? empty-str str-one) #f)
(check-equal? (string>? str-one str-two empty-str) #f)

(check-tail-exn type-exception? (lambda () (string>? empty-str char)))
(check-tail-exn type-exception? (lambda () (string>? char empty-str)))
