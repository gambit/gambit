(declare (extended-bindings) (not constant-fold) (not safe))

(define (test x)
  (define b (##make-promise x))
  (println (if (##promise? b) "promise" "not promise"))
  (println (if (##promise? (##promise-result b)) "promise" "not promise")))

(test (##make-promise (lambda () "executing thunk 0")))
(test (##make-promise (lambda () "executing thunk 1")))
