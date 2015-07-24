(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##make-will 0 (lambda (x) "executing action 0")))
(define b (##make-will 1 (lambda (x) "executing action 1")))
(define c (##make-will 2 (lambda (x) "executing action 2")))
 
(define (test x)
  (println (if (##will? x) "will" "not will"))
  (println (##will-testator x))
  (##will-testator-set! x (##will-testator a))
  (##will-testator-set! a (##will-testator b))
  (##will-testator-set! b (##will-testator c))
  (##will-testator-set! c (##will-testator x))
  (println (##will-testator x)))


(test (##make-will 'a (lambda (x) "executing action a")))
(test (##make-will 'b (lambda (x) "executing action b")))
(test a)
(test b)
(test c)
