(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flsinh a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test   0.1  0.10016675001984403)
(test   1.0  1.1752011936438014)
(test  10.0  11013.232874703397)
(test -10.0 -11013.232874703397)

(println (##fleqv? (##flsinh  0.0)  0.0))
(println (##fleqv? (##flsinh -0.0) -0.0))
