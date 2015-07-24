(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##make-promise (lambda () "executing thunk a")))
(define b (##make-promise (lambda () "executing thunk b")))
(define c (##make-promise (lambda () "executing thunk c")))

(define (test x y)

  (println (if (##promise? x) "promise" "not promise"))
  (println (if (##promise? (##promise-result x)) "promise" "not promise"))

  (##promise-result-set! x y)

  (println (if (##promise? x) "promise" "not promise"))
  (println (if (##promise? (##promise-result x)) "promise" "not promise"))

  (println (if (##eq? y (##promise-result x)) "same" "not same")))

(test b 0)
(test a b)
(test c 1)
(test a -1)
