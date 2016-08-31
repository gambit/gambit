(include "#.scm")

(define str "abc")
(define empty-str "")
(define char #\a)
(define int 1)

(##string-fill! empty-str char)
(check-equal? empty-str "")
(set! empty-str "")

(string-fill! empty-str char)
(check-equal? empty-str "")

(##string-fill! str char)
(check-equal? str "aaa")
(set! str "abc")

(string-fill! str char)
(check-equal? str "aaa")
(set! str "abc")

(check-tail-exn type-exception? (lambda () (string-fill! char char)))
(check-tail-exn type-exception? (lambda () (string-fill! str int)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-fill!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-fill! str)))
