(declare (extended-bindings) (not constant-fold) (not safe))

(define (test x)
  (println (if (##will? x) "will" "not will"))
  (println ((##will-action x) 1)))

(test (##make-will 1 (lambda (x) "executing action")))
