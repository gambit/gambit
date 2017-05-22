(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flatanh a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test  0.5   0.5493061443340549)
(test -0.5  -0.5493061443340549)
(test  0.9   1.4722194895832204)
(test -0.9  -1.4722194895832204)
(test  0.99  2.6466524123622457)
(test -0.99 -2.6466524123622457)

(println (##fleqv? (##flatanh  0.0)  0.0))
(println (##fleqv? (##flatanh -0.0) -0.0))

(println (##fleqv? (##flatanh  1.0) +inf.0))
(println (##fleqv? (##flatanh -1.0) -inf.0))

(println (##flnan? (##flatanh  10.0)))
(println (##flnan? (##flatanh -10.0)))
