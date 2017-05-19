(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flatanh a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(println (##eqv? (##flatanh  0.0)  0.0))
(println (##eqv? (##flatanh -0.0) -0.0))

(test 0.5  0.46211715726000974)
(test 1.0  0.7615941559557649)
(test 10.0 0.9999999958776927)

(println (##eqv? (##flatanh  1.0) +inf.0))
(println (##eqv? (##flatanh -1.0) -inf.0))
(println (##flnan? (##flatanh  10.0)))
(println (##flnan? (##flatanh -10.0)))
