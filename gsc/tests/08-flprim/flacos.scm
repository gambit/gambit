(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flacos a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 0.0 1.5707963267948966)
(test 0.5 1.0471975511965976)
(test 1.0 0.0)

(test 0.1 -9.999)
