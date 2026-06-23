(include "#.scm")

(define str "foo")
(define int 11)
(define key 'foo:)

(set! ##keyword-counter (##greatest-fixnum))
;; to cause hash code wrap around

(test-assert (eq? #t (keyword? (string->uninterned-keyword str))))
(test-assert (eq? #t (keyword? (string->uninterned-keyword str int))))

(test-assert (eq? #f (eq? (string->uninterned-keyword str) key)))
(test-assert
 (eq? #f
      (eq? (string->uninterned-keyword str) (string->uninterned-keyword str))))

(test-error-tail type-exception? (string->uninterned-keyword int))
(test-error-tail type-exception? (string->uninterned-keyword key))
(test-error-tail type-exception? (string->uninterned-keyword str key))

(test-error-tail range-exception? (string->uninterned-keyword str -1))
(test-error-tail range-exception? (string->uninterned-keyword str 536870912))

(test-error-tail
 wrong-number-of-arguments-exception?
 (string->uninterned-keyword))
(test-error-tail
 wrong-number-of-arguments-exception?
 (string->uninterned-keyword str int #f))
