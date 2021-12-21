(declare (extended-bindings) (not constant-fold) (not safe))

(define (make-clo1 a)
  (lambda () a))

(define (make-clo2 a)
  (lambda () (##cons a a)))

(define c1 (make-clo1 (##vector 1 2 3 4 5 6 7 8)))
(define c2 (make-clo2 (##vector 0 1 2 3 4 5 6 7)))

(let ((x (##closure-ref c1 1))
      (y (##closure-ref c2 1)))
  (println (##eq? x y)))

(##closure-set! c1 1 (##closure-ref c2 1))

(let ((x (##closure-ref c1 1))
      (y (##closure-ref c2 1)))
  (println (##eq? x y)))
