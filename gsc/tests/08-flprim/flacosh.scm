(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flacosh a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 1.0 0.0)
(test 1.1 0.4435682543851153)
(test 2.0 1.3169578969248166)

(println (##fleqv? (##flacosh +inf.0) +inf.0))

(println (##flnan? (##flacosh 0.0)))
(println (##flnan? (##flacosh 0.99)))
(println (##flnan? (##flacosh -1.0)))
(println (##flnan? (##flacosh -inf.0)))
