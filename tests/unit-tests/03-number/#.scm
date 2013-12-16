(include "../#.scm")

(define-macro (macro-inexact-+pi/2)  1.5707963267948966)

(set! epsilon 1e-12)

;;; Naive, but correct, definitions of inverse trigonometric and
;;; hyperbolic functions in terms of log and sqrt.

(define (test-atanh z)
  (declare (standard-bindings) (generic))
  (* 1/2 (- (log (+ 1 z)) (log (- 1 z)))))

(define (test-atan z)
  (declare (standard-bindings) (generic))
  (/ (test-atanh (* +i z)) +i))

(define (test-asinh z)
  (declare (standard-bindings) (generic))
  (log (+ z (sqrt (+ (* z z) 1)))))

(define (test-asin z)
  (declare (standard-bindings) (generic))
  (/ (test-asinh (* +i z)) +i))

(define (test-acos z)
  (declare (standard-bindings) (generic))
  (- (macro-inexact-+pi/2) (test-asin z)))

(define (test-acosh z)
  (declare (standard-bindings) (generic))
  (* 2 (log (+ (sqrt (/ (+ z 1) 2)) (sqrt (/ (- z 1) 2))))))
