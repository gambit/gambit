(include "#.scm")

(define str "foo")
(define int 11)
(define key 'foo:)

(set! ##keyword-counter ##max-fixnum) ;; to cause hash code wrap around

(check-true (keyword? (string->uninterned-keyword str)))
(check-true (keyword? (string->uninterned-keyword str int)))

(check-false (eq? (string->uninterned-keyword str) key))
(check-false (eq? (string->uninterned-keyword str) (string->uninterned-keyword str)))

(check-tail-exn type-exception? (lambda () (string->uninterned-keyword int)))
(check-tail-exn type-exception? (lambda () (string->uninterned-keyword key)))
(check-tail-exn type-exception? (lambda () (string->uninterned-keyword str key)))

(check-tail-exn range-exception? (lambda () (string->uninterned-keyword str -1)))
(check-tail-exn range-exception? (lambda () (string->uninterned-keyword str 536870912)))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string->uninterned-keyword)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (string->uninterned-keyword str int #f)))
