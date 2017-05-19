(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flexpm1 a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test 0.5   0.6487212707001281)
(test 1.0   1.718281828459045)
(test 10.0  22025.465794806725)
(test 20.0 485165194.40979075)

(test 1e-5  1.0000050000166668e-5)
(test 1e-10 1.0000000000500001e-10)

(println (##fleqv? (##flexpm1  0.0)  0.0))
(println (##fleqv? (##flexpm1 -0.0) -0.0))
