(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##make-delay-promise (lambda () 1)))
(define v2 (##make-delay-promise (lambda () 2)))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
