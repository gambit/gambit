(declare (extended-bindings) (not constant-fold) (not safe))

(define (test n)
  (println n))

(test -665544)
(test 665544)
(test -1)
(test 1)
(test 0)
