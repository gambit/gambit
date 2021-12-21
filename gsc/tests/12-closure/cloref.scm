(declare (extended-bindings) (not constant-fold) (not safe))

(define (make-clo a)
  (lambda () a))

(define c (make-clo (##vector 1 2 3 4 5 6 7 8)))

(let ((x (##closure-ref c 1)))
  (println (##vector? x))
  (if (##vector? x) (println (##vector-length x))))
