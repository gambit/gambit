(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##fltanh a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test   0.5  0.46211715726000974)
(test   1.0  0.7615941559557649)
(test  10.0  0.9999999958776927)
(test -10.0 -0.9999999958776927)

(println (##fleqv? (##fltanh  0.0)  0.0))
(println (##fleqv? (##fltanh -0.0) -0.0))

(println (##fleqv? (##fltanh  10000000.0)  1.0))
(println (##fleqv? (##fltanh -10000000.0) -1.0))

(println (##fleqv? (##fltanh +inf.0)  1.0))
(println (##fleqv? (##fltanh -inf.0) -1.0))
