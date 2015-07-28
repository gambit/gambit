(declare (extended-bindings) (not constant-fold) (not safe))

(define (id x) x)

(define (test x)
  (define b (##box x))
  (println (if (##box? b) "box" "not box"))
  (println (if (##eq? x (##unbox b)) "same" "not same")))

(test (##box 0))
(test (##box (lambda (x) x)))
