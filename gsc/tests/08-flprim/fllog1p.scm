(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##fllog1p a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 10.0  2.3978952727983707)
(test 1.0   0.6931471805599453)
(test 0.1   0.09531017980432487)
(test 0.01  0.009950330853168083)
(test 0.001 9.995003330835331e-4)

(test 1e-5  9.999950000333332e-6)
(test 1e-10 9.999999999500001e-11)

(test 1e-20 1e-20)
(test 1e-40 1e-40)

(println (##fleqv? (##fllog1p  0.0)  0.0))
(println (##fleqv? (##fllog1p -0.0) -0.0))
