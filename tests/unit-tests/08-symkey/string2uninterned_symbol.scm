(include "#.scm")

(define str "foo")
(define int 11)
(define sym 'foo)

(set! ##symbol-counter ##max-fixnum) ;; to cause hash code wrap around

(check-true (symbol? (string->uninterned-symbol str)))
(check-true (symbol? (string->uninterned-symbol str int)))

(check-false (eq? (string->uninterned-symbol str) sym))
(check-false (eq? (string->uninterned-symbol str) (string->uninterned-symbol str)))

(check-tail-exn type-exception? (lambda () (string->uninterned-symbol int)))
(check-tail-exn type-exception? (lambda () (string->uninterned-symbol sym)))
(check-tail-exn type-exception? (lambda () (string->uninterned-symbol str sym)))

(check-tail-exn range-exception? (lambda () (string->uninterned-symbol str -1)))
(check-tail-exn range-exception? (lambda () (string->uninterned-symbol str 536870912)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string->uninterned-symbol)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string->uninterned-symbol str int #f)))
