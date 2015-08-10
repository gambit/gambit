(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#u64())
(define v2 '#u64(1 2 18446744073709551615))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
