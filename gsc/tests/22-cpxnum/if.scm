(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##cpxnum-make 2 3))
(define s2 (##cpxnum-make -1 6))

(define (test x)
  (println (if x 11 22)))

(test s1)
(test s2)
