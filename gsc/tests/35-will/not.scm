(declare (extended-bindings) (not constant-fold) (not safe))

(define v1 (##make-will 1 (lambda (x) x)))
(define v2 (##make-will 2 (lambda (x) x)))

(define (test x)
  (println (if (##not x) 11 22)))

(test v1)
(test v2)
