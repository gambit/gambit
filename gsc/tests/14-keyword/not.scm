(declare (extended-bindings) (not constant-fold) (not safe))

(define s1 '||:)
(define s2 'hello:)

(define (test x)
  (println (if (##not x) 11 22)))

(test s1)
(test s2)
