(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##f32vector 1.5 2.5))
(define b (##make-f32vector 10 5.5))
(define c '#f32(1.5 2.5 3.5 4.5))

(define (test v)
  (println (##f32vector-length v)))

(test a)
(test b)
(test c)
