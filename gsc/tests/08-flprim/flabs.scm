(declare (extended-bindings) (not constant-fold) (not safe))

(define (test a b)
  (let ((x (##flabs a)))
    (println (##fl= x b))))

(test  1.4  1.4)
(test  1.5  1.5)
(test  1.6  1.6)
(test -3.4  3.4)
(test -3.5  3.5)
(test -3.6  3.6)

(test  2.2  9.1)
