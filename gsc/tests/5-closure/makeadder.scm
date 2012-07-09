(declare
 (standard-bindings)
 (extended-bindings)
 (not safe)
)

(define (make-adder x)
  (lambda (y) (fx+ x y)))

(define inc (make-adder 1))

(println (inc 1000))
