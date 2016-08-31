(include "#.scm")

(define str "abc")
(define empty-str "")
(define char #\a)

(##string-set! str 2 char)
(check-equal? str "aba")
(set! str "abc")

(string-set! str 2 char)
(check-equal? str "aba")
(set! str "abc")

(check-tail-exn type-exception? (lambda () (string-set! char 0 char)))
(check-tail-exn type-exception? (lambda () (string-set! str 0 0)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-set!)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-set! str)))

(check-tail-exn range-exception? (lambda () (string-set! empty-str 0 char)))
(check-tail-exn range-exception? (lambda () (string-set! str 3 char)))
