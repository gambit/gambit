(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##make-promise (lambda () "executing thunk 0")))
(define b (##make-promise (lambda () "executing thunk 1")))
(define c (##make-promise (lambda () "executing thunk -1")))
 
(define (test x)
  (println (if (##promise? x) "promise" "not promise"))
  (println ((##promise-thunk x)))
  (##promise-thunk-set! x (##promise-thunk a))
  (##promise-thunk-set! a (##promise-thunk b))
  (##promise-thunk-set! b (##promise-thunk c))
  (##promise-thunk-set! c (##promise-thunk x))
  (println ((##promise-thunk x))))


(test (##make-promise (lambda () "executing thunk a")))
(test (##make-promise (lambda () "executing thunk b")))
(test a)
(test b)
(test c)
