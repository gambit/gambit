(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#u32())
(define v2 '#u32(1 2 4294967295))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
