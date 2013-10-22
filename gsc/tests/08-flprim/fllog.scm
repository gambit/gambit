(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##fllog a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test 0.5 -0.6931471805599453)
(test 1.0  0.0)
(test 2.0  0.6931471805599453)
(test 3.0  1.0986122886681098)

(test 5.0 -9.999)
