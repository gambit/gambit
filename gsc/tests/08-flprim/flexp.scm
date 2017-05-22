(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let* ((x (##flsin a))
         (b-small (##fl* 0.9999999999999 b))
         (b-large (##fl* 1.0000000000001 b))
         (lo (##flmin b-small b-large))
         (hi (##flmax b-small b-large)))
    (println (and (##fl>= x lo) (##fl<= x hi)))))

(test 0.5  1.6487212707001282)
(test 1.0  2.718281828459045)
(test 2.0  7.38905609893065)
(test 3.0 20.085536923187668)

(test 5.0 -9.999)
