(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flsin a)))
    (println (and (##fl>= x (##fl* 0.999999999999999 b))
                  (##fl<= x (##fl* 1.000000000000001 b))))))

(test -1.0 -0.8414709848078965)
(test  0.0  0.0)
(test  0.5  0.479425538604203)
(test  1.0  0.8414709848078965)
(test  4.0 -0.7568024953079282)

(test  5.0 -9.999)
