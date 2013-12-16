(include "../#.scm")

(define (fixnum-wrap n)
  (declare (standard-bindings) (generic))
  (+ (modulo (- n ##min-fixnum) (* -2 ##min-fixnum)) ##min-fixnum))
