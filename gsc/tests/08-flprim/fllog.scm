(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##fllog a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 0.5 -0.6931471805599453)
(test 1.0  0.0)
(test 2.0  0.6931471805599453)
(test 3.0  1.0986122886681098)

(test 5.0 -9.999)
