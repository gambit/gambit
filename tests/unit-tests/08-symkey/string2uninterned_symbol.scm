(include "#.scm")

(define str "foo")
(define int 11)
(define sym 'foo)

(set! ##symbol-counter (##greatest-fixnum))
;; to cause hash code wrap around

(test-assert (eq? #t (symbol? (string->uninterned-symbol str))))
(test-assert (eq? #t (symbol? (string->uninterned-symbol str int))))

(test-assert (eq? #f (eq? (string->uninterned-symbol str) sym)))
(test-assert
 (eq? #f
      (eq? (string->uninterned-symbol str) (string->uninterned-symbol str))))

(test-error-tail type-exception? (string->uninterned-symbol int))
(test-error-tail type-exception? (string->uninterned-symbol sym))
(test-error-tail type-exception? (string->uninterned-symbol str sym))

(test-error-tail range-exception? (string->uninterned-symbol str -1))
(test-error-tail range-exception? (string->uninterned-symbol str 536870912))

(test-error-tail
 wrong-number-of-arguments-exception?
 (string->uninterned-symbol))
(test-error-tail
 wrong-number-of-arguments-exception?
 (string->uninterned-symbol str int #f))
