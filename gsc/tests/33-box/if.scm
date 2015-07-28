(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##box 1))
(define v2 (##box 2))

(define (test x)
  (println (if x 11 22)))

(test v1)
(test v2)
