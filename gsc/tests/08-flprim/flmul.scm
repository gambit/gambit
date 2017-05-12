(declare (extended-bindings) (not constant-fold) (not safe))

(define (test expected actual)
;;  (println actual)
  (println (##fleqv? expected actual)))

(test   3.90625    (##fl*  3.125  1.25))
(test  -3.90625    (##fl*  3.125 -1.25))
(test  -3.90625    (##fl* -3.125  1.25))
(test   3.90625    (##fl* -3.125 -1.25))

(test   1.         (##fl*))
(test   3.125      (##fl* 3.125))
(test   3.90625    (##fl* 3.125 1.25))
(test  10.7421875  (##fl* 3.125 1.25 2.75))
(test -37.59765625 (##fl* 3.125 1.25 2.75 -3.5))

(test     0. (##fl*  0.0  0.0))
(test    -0. (##fl*  0.0 -0.0))
(test    -0. (##fl* -0.0  0.0))
(test     0. (##fl* -0.0 -0.0))
