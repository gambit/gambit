(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flcos a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test -1.0  0.5403023058681398)
(test  0.0  1.0)
(test  0.5  0.8775825618903728)
(test  1.0  0.5403023058681398)
(test  4.0 -0.6536436208636119)

(test  5.0 -9.999)
