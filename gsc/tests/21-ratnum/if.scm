(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##ratnum-make 2 3))
(define s2 (##ratnum-make 4 6))
(define s3 (##ratnum-make -1 6))

(define (test x)
  (println (if x 11 22)))

(test s1)
(test s2)
(test s3)
