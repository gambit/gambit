(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flexp a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test 0.5  1.6487212707001282)
(test 1.0  2.718281828459045)
(test 2.0  7.38905609893065)
(test 3.0 20.085536923187668)

(test 5.0 -9.999)
