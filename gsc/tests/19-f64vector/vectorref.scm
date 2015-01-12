(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##f64vector 1.5 2.5))
(define v2 (##make-f64vector 10 5.5))
(define v3 '#f64(1.5 2.5 3.5 4.5))

(define (test v i)
  (println (##f64vector-ref v i)))

(test v1 0)
(test v1 1)

(test v2 9)

(test v3 3)
