(declare (extended-bindings) (not constant-fold) (not safe))

(define (test1 a b)
  (let* ((x (##flatan a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(define (test2 a b c)
  (let* ((x (##flatan a b))
         (c-small (##fl* 0.9999999999999 c))
         (c-large (##fl* 1.0000000000001 c))
         (lo (##flmin c-small c-large))
         (hi (##flmax c-small c-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test1 0.0 0.0)
(test1 0.5 0.46364760900080615)
(test1 1.0 0.7853981633974483)
(test1 4.0 1.3258176636680326)

(test1 5.0 -9.999)

(test2  0.0  0.0  0.0)
(test2  0.0 -0.0  3.141592653589793)
(test2 -0.0  0.0 -0.0)
(test2 -0.0 -0.0 -3.141592653589793)

(test2  0.5  1.0  0.4636476090008061)
(test2  0.5 -1.0  2.677945044588987)
(test2 -0.5  1.0 -0.4636476090008061)
(test2 -0.5 -1.0 -2.677945044588987)
