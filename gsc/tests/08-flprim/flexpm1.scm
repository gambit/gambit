(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flexpm1 a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 0.5   0.6487212707001281)
(test 1.0   1.718281828459045)
(test 10.0  22025.465794806725)
(test 20.0 485165194.40979075)
(test -1.0 -0.6321205588285577)

(test 1e-5  1.0000050000166668e-5)
(test 1e-10 1.0000000000500001e-10)

(println (##fleqv? (##flexpm1  0.0)  0.0))
(println (##fleqv? (##flexpm1 -0.0) -0.0))
