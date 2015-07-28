(declare (extended-bindings) (not constant-fold) (not safe))

(define (test x)
  (println (if (##will? x) "will" "not will"))
  (println (if (##will? (##will-testator x)) "will" "will")))

(test (##make-will 1 (lambda (x) "executing action 0")))
(test (##make-will 'a (lambda (x) "executing action 1")))
