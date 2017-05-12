(declare (extended-bindings) (not constant-fold) (not safe))

(define (test expected actual)
;;  (println actual)
  (println (##fleqv? expected actual)))

(test  2.5 (##fl/  3.125  1.25))
(test -2.5 (##fl/  3.125 -1.25))
(test -2.5 (##fl/ -3.125  1.25))
(test  2.5 (##fl/ -3.125 -1.25))

(test  2.5 (##fl/ 0.4))
(test 12.8 (##fl/ 16.0 1.25))
(test  6.4 (##fl/ 16.0 1.25 2.0))
(test -3.2 (##fl/ 16.0 1.25 2.0 -2.0))

(println (##flnan? (##fl/  0.0  0.0)))
(println (##flnan? (##fl/  0.0 -0.0)))
(println (##flnan? (##fl/ -0.0  0.0)))
(println (##flnan? (##fl/ -0.0 -0.0)))
