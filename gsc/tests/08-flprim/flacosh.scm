(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flacosh a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test 1.0 0.0)
(test 1.1 0.4435682543851153)
(test 2.0 1.3169578969248166)

(println (##fleqv? (##flacosh +inf.0) +inf.0))

(println (##flnan? (##flacosh 0.0)))
(println (##flnan? (##flacosh 0.99)))
(println (##flnan? (##flacosh -1.0)))
(println (##flnan? (##flacosh -inf.0)))
