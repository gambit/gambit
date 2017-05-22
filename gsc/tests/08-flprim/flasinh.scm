(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flasinh a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 0.1  0.09983407889920758)
(test 1.0  0.8813735870195429)
(test 10.0 2.99822295029797)

(println (##fleqv? (##flasinh 0.0) 0.0))
(println (##fleqv? (##flasinh -0.0) -0.0))

(println (##fleqv? (##flasinh +inf.0) +inf.0))
(println (##fleqv? (##flasinh -inf.0) -inf.0))
