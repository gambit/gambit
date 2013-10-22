(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flfloor a)))
    (println (##fl= x b))))

(test  1.4  1.0)
(test  1.5  1.0)
(test  1.6  1.0)
(test -3.4 -4.0)
(test -3.5 -4.0)
(test -3.6 -4.0)

(test  2.2  9.1)
