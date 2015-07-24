(declare (extended-bindings) (not constant-fold) (not safe))

(define (test x)
  (println (if (##promise? x) "promise" "not promise"))
  (println ((##promise-thunk x))))

(test (##make-promise (lambda () "executing thunk 0")))
