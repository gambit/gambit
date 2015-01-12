(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#u8())
(define v2 '#u8(1 2 3))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
