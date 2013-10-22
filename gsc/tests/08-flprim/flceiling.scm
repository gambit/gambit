(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flceiling a)))
    (println (##fl= x b))))

(test  1.4  2.0)
(test  1.5  2.0)
(test  1.6  2.0)
(test -3.4 -3.0)
(test -3.5 -3.0)
(test -3.6 -3.0)

(test  2.2  9.1)
