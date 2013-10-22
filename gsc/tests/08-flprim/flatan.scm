(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flatan a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test 0.0 0.0)
(test 0.5 0.46364760900080615)
(test 1.0 0.7853981633974483)
(test 4.0 1.3258176636680326)

(test 5.0 -9.999)
