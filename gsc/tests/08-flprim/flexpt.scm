(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b c)
  (let ((x (##flexpt a b)))
    (println (and (##fl>= x (##fl* 0.999999999999999 c))
                  (##fl<= x (##fl* 1.000000000000001 c))))))

(test 0.0 9.3 0.0)
(test 0.5 2.0 0.25)
(test 5.0 5.2 4311.655192066298)

(test 0.1 2.0 -9.999)
