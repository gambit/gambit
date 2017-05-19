(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flasinh a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))


(println (##eqv? (##flasinh 0.0) 0.0))
(println (##eqv? (##flasinh -0.0) -0.0))

(test 0.1  0.09983407889920758)
(test 1.0  0.8813735870195429)
(test 10.0 2.99822295029797)
