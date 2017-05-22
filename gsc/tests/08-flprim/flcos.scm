(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flcos a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test -1.0  0.5403023058681398)
(test  0.0  1.0)
(test  0.5  0.8775825618903728)
(test  1.0  0.5403023058681398)
(test  4.0 -0.6536436208636119)

(test  5.0 -9.999)
