(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##make-will 0 (lambda (x) "executing action 0")))
(define b (##make-will 1 (lambda (x) "executing action 1")))
(define c (##make-will 2 (lambda (x) "executing action 2")))
 
(define (test x)
  (println (if (##will? x) "will" "not will"))
  (println ((##will-action x) 0))
  (##will-action-set! x (##will-action a))
  (##will-action-set! a (##will-action b))
  (##will-action-set! b (##will-action c))
  (##will-action-set! c (##will-action x))
  (println ((##will-action x) 0)))


(test (##make-will 'a (lambda (x) "executing action a")))
(test (##make-will 'b (lambda (x) "executing action b")))
(test a)
(test b)
(test c)
