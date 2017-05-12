(declare (extended-bindings) (not constant-fold) (not safe))

(define (test expected actual)
;;  (println actual)
  (println (##fleqv? expected actual)))

(test  1.875 (##fl-  3.125  1.25))
(test  4.375 (##fl-  3.125 -1.25))
(test -4.375 (##fl- -3.125  1.25))
(test -1.875 (##fl- -3.125 -1.25))

(test -3.125 (##fl- 3.125))
(test  1.875 (##fl- 3.125 1.25))
(test -1.875 (##fl- 3.125 1.25 3.75))
(test  1.625 (##fl- 3.125 1.25 3.75 -3.5))

(test     0. (##fl-  0.0  0.0))
(test     0. (##fl-  0.0 -0.0))
(test    -0. (##fl- -0.0  0.0))
(test     0. (##fl- -0.0 -0.0))
