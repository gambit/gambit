(include "../#.scm")

(define-macro (macro-inexact-+pi)    3.141592653589793)
(define-macro (macro-inexact--pi)   -3.141592653589793)
(define-macro (macro-inexact-+pi/2)  1.5707963267948966)
(define-macro (macro-inexact--pi/2) -1.5707963267948966)
(define-macro (macro-inexact-+pi/4)   .7853981633974483)
(define-macro (macro-inexact-+3pi/4) 2.356194490192345)
(##define-macro (macro-cpxnum-+1/2+sqrt3/2i)
  (make-rectangular 1/2 (/ (sqrt 3) 2)))

(##define-macro (macro-cpxnum-+1/2-sqrt3/2i)
  (make-rectangular 1/2 (- (/ (sqrt 3) 2))))

(##define-macro (macro-cpxnum--1/2+sqrt3/2i)
  (make-rectangular -1/2 (/ (sqrt 3) 2)))

(##define-macro (macro-cpxnum--1/2-sqrt3/2i)
  (make-rectangular -1/2 (- (/ (sqrt 3) 2))))

(##define-macro (macro-cpxnum-+sqrt3/2+1/2i)
  (make-rectangular (/ (sqrt 3) 2) 1/2))

(##define-macro (macro-cpxnum-+sqrt3/2-1/2i)
  (make-rectangular (/ (sqrt 3) 2) -1/2))

(##define-macro (macro-cpxnum--sqrt3/2+1/2i)
  (make-rectangular (- (/ (sqrt 3) 2)) 1/2))

(##define-macro (macro-cpxnum--sqrt3/2-1/2i)
  (make-rectangular (- (/ (sqrt 3) 2)) -1/2))

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

(define (test-bitwise-ior x y)
  (cond ((or (= x -1)
	     (= y -1))
	 -1)
	((and (= x 0)
	      (= y 0))
	 0)
	(else (+ (* 2 (test-bitwise-ior (arithmetic-shift x -1)
					(arithmetic-shift y -1)))
		 (if (or (odd? x) (odd? y))
		     1
		     0)))))

(define (test-bitwise-and x y)
  (cond ((or (= x 0)
	     (= y 0))
	 0)
	((and (= x -1)
	      (= y -1))
	 -1)
	(else (+ (* 2 (test-bitwise-and (arithmetic-shift x -1)
					(arithmetic-shift y -1)))
		 (if (and (odd? x) (odd? y))
		     1
		     0)))))

(define (test-bitwise-xor x y)
  (cond ((= x y)
	 0)
	((or (and (= x -1)
		  (= y 0))
	     (and (= x 0)
		  (= y -1)))
	 -1)
	(else
	 (+ (* 2 (test-bitwise-xor (arithmetic-shift x -1)
				   (arithmetic-shift y -1)))
	    (if (eq? (odd? x) (odd? y))
		0
		1)))))

(define (test-arithmetic-shift x n)
  (if (negative? n)
      (if (negative? x)
	  (- (quotient (- x) (expt 2 (- n))))
	  (quotient x (expt 2 (- n))))
      (* x (expt 2 n))))
