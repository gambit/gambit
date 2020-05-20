(include "../#.scm")

(define-macro (macro-inexact-+pi)     3.141592653589793)
(define-macro (macro-inexact--pi)    -3.141592653589793)
(define-macro (macro-inexact-+pi/2)   1.5707963267948966)
(define-macro (macro-inexact--pi/2)  -1.5707963267948966)
(define-macro (macro-inexact-+pi/4)    .7853981633974483)
(define-macro (macro-inexact--pi/4)   -.7853981633974483)
(define-macro (macro-inexact-+3pi/4)  2.356194490192345)
(define-macro (macro-inexact--3pi/4) -2.356194490192345)

(define (isnan? x) (not (= x x)))

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

(define (test-complex-+ x y)
  (let ((a (real-part x)) (b (imag-part x))
	(c (real-part y)) (d (imag-part y)))
    (make-rectangular (+ a c)
		      (+ b d))))

(define (test-complex-- x y)
  (let ((a (real-part x)) (b (imag-part x))
	(c (real-part y)) (d (imag-part y)))
    (make-rectangular (- a c)
		      (- b d))))

(define (test-complex-* x y)
  (let ((a (real-part x)) (b (imag-part x))
	(c (real-part y)) (d (imag-part y)))
    (make-rectangular (- (* a c) (* b d))
		      (+ (* a d) (* b c)))))

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

(define (test-bitwise-not x)
  (- -1 x))

(define (test-bitwise-andc1 x y)
  (test-bitwise-and (test-bitwise-not x) y))

(define (test-bitwise-andc2 x y)
  (test-bitwise-and x (test-bitwise-not y)))

(define (test-bitwise-eqv x y)
  (test-bitwise-not (test-bitwise-xor x y)))

(define (test-bitwise-nand x y)
  (test-bitwise-not (test-bitwise-and x y)))

(define (test-bitwise-nor x y)
  (test-bitwise-not (test-bitwise-ior x y)))

(define (test-bitwise-orc1 x y)
  (test-bitwise-ior (test-bitwise-not x) y))

(define (test-bitwise-orc2 x y)
  (test-bitwise-ior x (test-bitwise-not y)))

(define (test-arithmetic-shift x n)
  (if (negative? n)
      (let* ((q (expt 2 (- n)))
	     (bits (modulo x q)))
	(quotient (- x bits) q))
      (* x (expt 2 n))))

(define (test-extract-bit-field size position n)
  (bitwise-and (arithmetic-shift n (- position))
	       (bitwise-not (arithmetic-shift -1 size))))

(define (test-test-bit-field? size position n)
  (not (eqv? (test-extract-bit-field size position n)
	     0)))

(define (test-clear-bit-field size position n)
  (bitwise-ior (arithmetic-shift (arithmetic-shift n (- (+ size position))) (+ size position))
	       (test-extract-bit-field position 0 n)))
