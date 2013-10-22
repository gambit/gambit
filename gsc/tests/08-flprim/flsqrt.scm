(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flsqrt a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test 0.0 0.0)
(test 0.5 0.7071067811865476)
(test 1.0 1.0)
(test 4.0 2.0)

(test  5.0 -9.999)
