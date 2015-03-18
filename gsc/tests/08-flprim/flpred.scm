(declare (extended-bindings) (not constant-fold) (not safe))

(define (test1 x)
  (println (##flinteger? x))
  (println (##flzero? x))
  (println (##flpositive? x))
  (println (##flnegative? x))
  (println (##flodd? x))
  (println (##fleven? x))
  (println (##flfinite? x))
  (println (##flinfinite? x))
  (println (##flnan? x))
  (println ""))

(define (test2 n)
  (println (##fixnum->flonum-exact? n)))

(test1   0.0)
(test1  -0.0)
(test1  13.0)
(test1 -90.0)
(test1   1.5)

(test2 12345)
