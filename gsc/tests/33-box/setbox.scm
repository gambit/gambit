(declare (extended-bindings) (not constant-fold) (not safe))

(define a (##box 0))
(define b (##box 1))
(define c (##box -1))

(define (test x)
  (println (if (##box? x) "box" "not box"))
  (println (##unbox x))
  (##set-box! x (##unbox a))
  (##set-box! a (##unbox b))
  (##set-box! b (##unbox c))
  (##set-box! c (##unbox x))
  (println (##unbox x)))


(test (##box 2))
(test (##box 3))
(test a)
(test b)
(test c)
