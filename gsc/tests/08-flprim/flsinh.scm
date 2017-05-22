(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flsinh a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test   0.1  0.10016675001984403)
(test   1.0  1.1752011936438014)
(test  10.0  11013.232874703397)
(test -10.0 -11013.232874703397)

(println (##fleqv? (##flsinh  0.0)  0.0))
(println (##fleqv? (##flsinh -0.0) -0.0))
