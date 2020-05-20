(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##make-delay-promise (lambda () "executing thunk a")))
(define b (##make-delay-promise (lambda () "executing thunk b")))
(define c (##make-delay-promise (lambda () "executing thunk c")))

(define (test x y)

  (println (if (##promise? x) "promise" "not promise"))
  (println (if (##promise? (##promise-state x)) "promise" "not promise"))

  (##promise-state-set! x y)

  (println (if (##promise? x) "promise" "not promise"))
  (println (if (##vector? (##promise-state x)) "vector" "not vector"))

  (println (if (##eq? y (##vector-ref (##promise-state x) 0)) "same" "not same")))

(test b 0)
(test a b)
(test c 1)
(test a -1)
