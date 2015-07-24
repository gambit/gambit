(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 keyword1:)
(define v2 keyword2:)

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
