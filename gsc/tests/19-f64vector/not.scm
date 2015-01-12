(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 '#f64())
(define v2 '#f64(1.5 2.5 3.5))

(define (test x)
  (println (if (##not x) 11 22)))

(test v1)
(test v2)
