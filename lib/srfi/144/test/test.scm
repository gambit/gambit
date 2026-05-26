(import (_test))
(import (srfi 144))


(define-syntax test-approx-eq
  (syntax-rules ()
    ((_ a b) 
     (begin
     (test-assert (>= b a) (list  a b))
     (test-assert (>= (+ b 0.00005) a))))))

(define-syntax test-values-equal
  (syntax-rules ()
    ((_ a b)
     (let ((k (##values->list a))
           (j (##values->list b)))
       (test-approx-eq (car k) (car j))
       (test-approx-eq (cadr k) (cadr j))))))
 
(define-macro 
  (test-equivalent names arg prefix suffix)
  (define (sym . lst)
    (string->symbol
     (apply string-append
            (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                 lst))))
  `(begin
     ,@(map (lambda (name)
         `(test-equal (,(sym prefix name suffix) ,@arg) (,name ,@arg)))
     names)))

(define-macro 
  (test-almost-equivalent names arg prefix suffix)
  (define (sym . lst)
    (string->symbol
     (apply string-append
            (map (lambda (s) (if (symbol? s) (symbol->string s) s))
                 lst))))
  `(begin
     ,@(map (lambda (name)
         `(test-approx-eq (,(sym prefix name suffix) ,@arg) (,name ,@arg))) names)))

(define-syntax single-number-tests
  (syntax-rules ()
    ((single-number-tests) (write 1))
    ((single-number-tests x . x*)
     (begin
       (cond 
         ((and (real? x) (inexact? x)) (test-equal (flonum x) x))
         ((exact? x) (test-equal (flonum x) (exact->inexact x)))
         (else (test-error #t (flonum x))))
       (test-equal (flinteger-exponent x)  (floor (flexponent x)))
       (if (< x 0) (test-equal (flsign-bit x) 1)
         (test-equal (flsign-bit x) 0))
       (cond ((finite? x)
              (test-equal (flinteger? x) (= x (floor x)))
              (test-equal (flpositive? x) (positive? x))
              (let-values (((y n) (flnormalized-fraction-exponent x)))
                (test-assert (exact? y))
                (test-assert (integer? n))
                (test-assert (<= 1/2 (abs y)))
                (test-assert (< y 1))
                (test-approx-eq (* y (expt 2 n)) x))
              (test-assert (<= (flexponent (abs x)) (log (abs x) 2)))
              (test-assert (<= (flinteger-exponent (abs x)) (log (abs x) 2)))
              )
             (else 
               (test-equal #f (flinteger? x))
               (test-equal #f (flpositive? x))))
       (if (integer? x)
         (test-equivalent (odd? even?) (x) fl ||)
         (begin
           (test-error #t (flodd? x))
           (test-error #t (fleven? x))))
       (when (not (nan? x))
           (test-equal (flfinite? x) (not (flinfinite? x))) ;; Sanity check
           (test-equal (flnormalized? x) (not (fldenormalized? x))) ;; sanity check
           (test-almost-equivalent
             (square sin 
             cos tan atan sinh cosh tanh) (x) fl ||)
          (if (<= (abs x) 1)
           (test-almost-equivalent
             (asin acos) (x) fl ||)
           (begin
           (test-assert (nan? (flasin x)))
           (test-assert (nan? (flacos x)))))
           (if (and (real? (atanh x)) (finite? (atanh x)))
             (test-equal (flatanh x) (atanh x))
             (test-assert (not (finite? (flatanh x)))))
                
           (test-approx-eq (flsqrt (abs x)) (sqrt (abs x)))
           (test-equal (flnumerator x) (flonum (numerator (##flonum->exact x))))
           (test-equal (fldenominator x) (flonum (denominator (##flonum->exact x))))
           (test-approx-eq (flexp2 x) (expt 2 x))
           (test-approx-eq (flexp-1 x) (- (exp x) 1))
           (test-equivalent
             (positive? negative? floor ceiling round truncate) (x) fl ||))
       (test-equivalent
         (infinite? finite? nan?) (x) fl ||)
       (test-equal (flcopysign 1.0 x) (flsgn x))
       (single-number-tests . x*)
       ))))

(define-syntax double-number-tests
  (syntax-rules ()
    ((_ x y)
     (begin
     (cond 
       ((< x y)
       (test-assert (<= (fladjacent x y) y))
       (test-assert (> (fladjacent x y) x))
       (test-assert (<= (fladjacent x y) (+ x 0.00002)))) 
       ((> x y)
           (test-assert (>= (fladjacent x y) y))
           (test-assert (< (fladjacent x y) x))
           (test-assert (>= (fladjacent x y) (- x 0.00002)))) 
       ((= x y) (test-assert (fladjacent x y) x)))
       (cond
         ((integer? y) (test-equal (make-flonum x y) (* x (expt 2 y))))
         (else (test-error #t (make-flonum x y))))
       (test-equal (abs (flcopysign x y)) (abs x))
       (cond
         ((< y 0) (test-assert (<= (flcopysign x y) 0)))
         ((> y 0) (test-assert (>= (flcopysign x y) 0))))
      (test-equivalence
        (= < > <= >=) (x y) fl ?)
      (test-equal (flunordered? x y) (flunoredered? y x)) ;; simple reflexivity test
      (test-almost-equivalent
        (max min + * - / abs) (x y) fl ||)
      (test-equal (abs (- x y)) (flabsdiff x y))
      (test-equal (max (- x y) 0) (flposdiff x y))
     ))))

(define (test-exists a)
  (test-equal a a))

(define e 2.718281828459045)
(define pi 3.1415926535897932384626433832795028841971)
(test-approx-eq fl-sqrt-2 1.4142135623730951)
(test-approx-eq fl-sqrt-3 1.7320508075688772)
(test-approx-eq fl-sqrt-5 2.23606797749979)
(test-approx-eq fl-sqrt-10 3.1622776601683795)
(test-approx-eq fl-e e)
(test-approx-eq fl-1/e 0.36787944117144233)
(test-approx-eq fl-e-pi/4 2.1932800507380152)
(test-approx-eq fl-log-2-e 1.4426950408889634)
(test-approx-eq fl-log10-e 0.4342944819032518)
(test-approx-eq fl-log-2 0.6931471805599453)
(test-approx-eq fl-1/log-2 1.4426950408889634)
(test-approx-eq fl-log-3 1.0986122886681098)
(test-approx-eq fl-log-pi 1.1447298858494002)
(test-approx-eq fl-log-10 2.302585092994046)
(test-approx-eq fl-1/log-10 0.43429448190325176)
(test-approx-eq fl-pi pi) ;; I know them by heart. no need to verify
(test-approx-eq fl-1/pi 0.3183098861837907)
(test-approx-eq fl-2pi 6.283185307179586)
(test-approx-eq fl-pi/2 1.5707963267948966)
(test-approx-eq fl-pi/4 0.7853981633974483)
(test-approx-eq fl-pi-squared 9.869604401089358)
(test-approx-eq fl-degree 0.017453292519943295)
(test-approx-eq fl-2/pi 0.6366197723675814)
(test-approx-eq fl-2/sqrt-pi 1.1283791670955126)
(test-approx-eq fl-1/sqrt-2 0.7071067811865475)
(test-approx-eq fl-cbrt-2 1.2599210498948734)
(test-approx-eq fl-4thrt-2 1.189207115002721)
(test-approx-eq fl-phi 1.618033988749895) ;; golden ratio
(test-approx-eq fl-log-phi 0.48121182505960347)
(test-approx-eq fl-euler 0.57721566490153286060651209008240243104215933593992) ;; according to https://en.wikipedia.org/wiki/Euler%27s_constant
(test-approx-eq fl-sin-1 0.8414709848078965)
(test-approx-eq fl-cos-1 0.5403023058681398)
(test-approx-eq fl-gamma-1/2 1.7724538509055159)
(test-approx-eq fl-gamma-1/3 2.678938534707748)
(test-approx-eq fl-gamma-2/3 1.3541179394264005)
(test-values-equal (flinteger-fraction 2.5) (values 2.0 0.5))
(test-values-equal (flinteger-fraction 2.75) (values 2.0 0.75))
(test-values-equal (flinteger-fraction 3.25) (values 3.0 0.25))
(test-approx-eq (flexponent 4.0) 2.0)
(test-approx-eq (flexponent 8.0) 3.0)
(test-equal 2 (flexponent 4.0))
(test-equal 0 (flsign-bit 0.0))
(test-equal 1 (flsign-bit -0.0))
(test-assert (flunordered? 1.0 +nan.0))
(test-assert (flunordered? 2.0 +nan.0))
(test-assert (flunordered? 2.0 -nan.0))
(test-assert (flinteger? 1.0))
(test-approx-eq 2.0 (flcopysign 2.0 1.0))
(write (flcopysign -2.0 1.0))
(test-approx-eq (flcopysign 2.0 -1.0) -2.0)
(test-approx-eq (flexponent 2.0) 1.0)
(test-approx-eq (flexponent 4.0) 2.0)
(test-assert (not (flinteger? 1.5)))
(test-exists fl-greatest)
(test-exists fl-least)
(test-exists fl-epsilon)
(test-exists fl-fast-fl+*)
(test-equal fl-integer-exponent-zero (flinteger-exponent 0.0))
(test-equal fl-integer-exponent-nan (flinteger-exponent +nan.0))
(test-assert (flfinite? 2.0))
(test-assert (flfinite? 3.0))
(test-assert (flfinite? 4.0))
(test-assert (flfinite? -1.0))
(test-assert (flfinite? -3.0))
(test-equal #f (flfinite? +nan.0))
(test-equal #f (flfinite? +inf.0))
(test-equal #f (flfinite? -inf.0))
(test-equal #f (flfinite? -nan.0))
(test-assert (isnan? +nan.0))
(test-assert (isnan? -nan.0))
(test-equal #f (isnan? 0.0))
(test-assert (flnormalized? 0.2))
(test-assert (fldenormalized? +nan.0))
(test-assert (fldenormalized? 0.0))
(test-assert (fldenormalized? 0.0000000000000000001))
(test-assert (infinite? (asin 2.0)))
(test-approx-eq (flcbrt 8.0) 2.0)
(test-approx-eq (flcbrt -8.0) -2.0)
(test-approx-eq (flcbrt -1.0) -1.0)
(test-approx-eq (flcbrt 1.0) 1.0)
(test-approx-eq (flcbrt +nan.0) +nan.0)
(test-approx-eq (flcbrt +inf.0) +inf.0)
(test-approx-eq (flcbrt -inf.0) -inf.0)
(single-number-tests 1.0)
(single-number-tests -1.0)
(single-number-tests -2.0)
(single-number-tests 2.0)
(double-number-tests 0.1 fl-pi)
(double-number-tests fl-pi fl-e)
(single-number-tests 1.0 2.0 3.0 +nan.0)
