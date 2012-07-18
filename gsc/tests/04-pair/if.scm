(declare (extended-bindings))

(define l1 '())
(define l2 '(1 2 3))

(define (test x)
  (println (if x 11 22)))

(test l1)
(test l2)
