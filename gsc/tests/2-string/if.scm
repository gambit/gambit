(declare (extended-bindings))

(define s1 "")
(define s2 "hello")

(define (test x)
  (println (if x 11 22)))

(test s1)
(test s2)
