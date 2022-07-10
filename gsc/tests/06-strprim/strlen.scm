(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##string #\a #\b #\c))
(define s2 (##make-string 10 #\!))
(define s3 "hello")
(define s4 "abc\0def")
(define s5 "été")

(define (test v)
  (println (##string-length v)))

(test s1)
(test s2)
(test s3)
(test s4)
(test s5)
