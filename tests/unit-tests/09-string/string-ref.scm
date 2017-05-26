(include "#.scm")

(define str "abc")
(define char #\a)

(check-equal? (##string-ref str 0) #\a)
(check-equal? (##string-ref str 1) #\b)
(check-equal? (##string-ref str 2) #\c)

(check-equal? (string-ref str 0) #\a)
(check-equal? (string-ref str 1) #\b)
(check-equal? (string-ref str 2) #\c)

(check-tail-exn type-exception? (lambda () (string-ref str char)))
(check-tail-exn type-exception? (lambda () (string-ref char 0)))

(check-tail-exn range-exception? (lambda () (string-ref "" 0)))
(check-tail-exn range-exception? (lambda () (string-ref str -1)))
(check-tail-exn range-exception? (lambda () (string-ref str 3)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-ref)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string-ref str)))
