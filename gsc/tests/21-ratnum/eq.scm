(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##ratnum-make 2 3))
(define s2 (##ratnum-make 4 6))
(define s3 (##ratnum-make -1 6))

(define (test2 x y)
  (println (##eq? x y))
  (println (if (##eq? x y) 11 22)))

(define (test x)
  (test2 x s1)
  (test2 x s2))

(test s1)
(test s2)
(test s3)
