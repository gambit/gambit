(declare (extended-bindings) (not constant-fold) (not safe))

(define (test x)
  (define b (##make-delay-promise x))
  (println (if (##promise? b) "promise" "not promise"))
  (println (if (##vector? (##promise-state b)) "vector" "not vector")))

(test (##make-delay-promise (lambda () "executing thunk 0")))
(test (##make-delay-promise (lambda () "executing thunk 1")))
