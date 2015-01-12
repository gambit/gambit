(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#u16())
(define v2 '#u16(1 2 3))

(define (test x)
  (println (if (##not x) 11 22)))

(test v1)
(test v2)
