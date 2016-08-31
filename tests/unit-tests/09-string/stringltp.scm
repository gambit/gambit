(include "#.scm")

(define str-one "abc")
(define str-two "cde")
(define empty-str "")
(define char #\a)

(check-equal? (##string<? str-one str-two) #t)
(check-equal? (##string<? str-two str-one) #f)
(check-equal? (##string<? empty-str str-one) #t)

(check-equal? (string<?) #t)
(check-equal? (string<? empty-str) #t)
(check-equal? (string<? str-one str-two) #t)
(check-equal? (string<? str-two str-one) #f)
(check-equal? (string<? empty-str str-one) #t)
(check-equal? (string<? str-one str-two empty-str) #f)

(check-tail-exn type-exception? (lambda () (string<? empty-str char)))
(check-tail-exn type-exception? (lambda () (string<? char empty-str)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (##string<?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (##string<? empty-str)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (##string<? str-one str-two empty-str)))
