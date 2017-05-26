(include "#.scm")

(define str-one "abc")
(define str-two "aBc")
(define empty-str "")
(define char #\a)

(check-equal? (##string-ci=? str-one str-two) #t)
(check-equal? (##string-ci=? str-two str-two) #t)
(check-equal? (##string-ci=? empty-str str-one) #f)

(check-equal? (string-ci=?) #t)
(check-equal? (string-ci=? empty-str) #t)
(check-equal? (string-ci=? str-one str-two) #t)
(check-equal? (string-ci=? str-two str-two) #t)
(check-equal? (string-ci=? empty-str str-one) #f)
(check-equal? (string-ci=? str-one str-two empty-str) #f)
(check-equal? (string-ci=? str-one str-one str-one) #t)

(check-tail-exn type-exception? (lambda () (string-ci=? empty-str char)))
(check-tail-exn type-exception? (lambda () (string-ci=? char empty-str)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (##string-ci=?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (##string-ci=? empty-str)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (##string-ci=? str-one str-two empty-str)))
