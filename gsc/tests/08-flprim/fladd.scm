(declare (extended-bindings) (not constant-fold) (not safe))

(define (test expected actual)
;;  (println actual)
  (println (##fl= expected actual)))

(test  4.375 (##fl+  3.125  1.25))
(test  1.875 (##fl+  3.125 -1.25))
(test -1.875 (##fl+ -3.125  1.25))
(test -4.375 (##fl+ -3.125 -1.25))

(test     0. (##fl+))
(test  3.125 (##fl+ 3.125))
(test  4.375 (##fl+ 3.125 1.25))
(test  7.125 (##fl+ 3.125 1.25 2.75))
(test  3.625 (##fl+ 3.125 1.25 2.75 -3.5))
