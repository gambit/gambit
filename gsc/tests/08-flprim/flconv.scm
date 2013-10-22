(declare (extended-bindings) (not constant-fold) (not safe))

(define (test1 i f)
  (let ((x (##fl<-fx i)))
    (println (##flonum? x))
    (println (##fl= x f))))

(define (test2 i f)
  (let ((x (##fl->fx f)))
    (println (##fixnum? x))
    (println (##fx= x i))))

(test1  5  5.0)
(test1 -3 -3.0)
(test1  1  9.0)

(test2  5  5.4)
(test2  5  5.5)
(test2  5  5.6)
(test2 -3 -3.3)
(test2 -3 -3.5)
(test2 -3 -3.6)
