(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 (##string #\a #\b))
(define s2 (##make-string 10 #\!))
(define s3 "ABCDEF")

(define (test s i)
  (println (##string-ref s i)))

(test s1 0)
(test s1 1)

(test s2 9)

(test s3 4)
