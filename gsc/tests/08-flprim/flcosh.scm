(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flcosh a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test   0.0 1.0)
(test  -0.0 1.0)
(test   0.1 1.0050041680558035)
(test   1.0 1.5430806348152437)
(test  -1.0 1.5430806348152437)
(test  10.0 11013.232920103328)
(test -10.0 11013.232920103328)

(println (##fleqv? (##flcosh +inf.0) +inf.0))
(println (##fleqv? (##flcosh -inf.0) +inf.0))
