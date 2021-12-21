(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##make-delay-promise (lambda () (println "executing thunk a"))))
(define b (##make-delay-promise (lambda () (println "executing thunk b"))))

(let ((sa (##promise-state a))
      (sb (##promise-state b)))
  (##promise-state-set! a sb)
  (println (##eq? (##promise-state a) sa))
  (println (##eq? (##promise-state a) sb)))
