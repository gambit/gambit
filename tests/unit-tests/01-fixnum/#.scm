(include "../#.scm")

(define (fixnum-wrap n)
  (declare (standard-bindings) (generic))
  (+ (modulo (- n (##least-fixnum)) (* -2 (##least-fixnum))) (##least-fixnum)))
