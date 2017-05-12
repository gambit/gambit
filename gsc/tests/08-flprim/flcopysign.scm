(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b c)
  (let ((x (##flcopysign a b)))
    (println (##fleqv? x c))))

(test 0.0  1.0  0.0)
(test 0.0 -1.0 -0.0)
(test 0.0  0.0  0.0)
(test 0.0 -0.0 -0.0)

(test -0.0  1.0  0.0)
(test -0.0 -1.0 -0.0)
(test -0.0  0.0  0.0)
(test -0.0 -0.0 -0.0)

(test 1.0  1.0  1.0)
(test 1.0 -1.0 -1.0)
(test 1.0  0.0  1.0)
(test 1.0 -0.0 -1.0)

(test -1.0  1.0  1.0)
(test -1.0 -1.0 -1.0)
(test -1.0  0.0  1.0)
(test -1.0 -0.0 -1.0)
