(include "../#.scm")

(define-macro (macro-inexact-+pi/2)  1.5707963267948966)

(set! epsilon 1e-12)

;;; Naive, but correct, definitions of inverse trigonometric and
;;; hyperbolic functions in terms of log and sqrt.

(define (test-atanh z)
  (* 1/2 (- (log (+ 1 z)) (log (- 1 z)))))

(define (test-atan z)
  (/ (test-atanh (* +i z)) +i))

(define (test-asinh z)
  (log (+ z (sqrt (+ (* z z) 1)))))

(define (test-asin z)
  (/ (test-asinh (* +i z)) +i))

(define (test-acos z)
  (- (macro-inexact-+pi/2) (test-asin z)))

(define (test-acosh z)
  (* 2 (log (+ (sqrt (/ (+ z 1) 2)) (sqrt (/ (- z 1) 2))))))
