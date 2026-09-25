(include "#.scm")

(define-record-type point
  (make-point x y)
  point?
  (x point-x)
  (y point-y point-y-set!))

(define p (make-point 1 2))

(test-assert (point? p))
(test-equal 1 (point-x p))
(test-equal 2 (point-y p))
(point-y-set! p 9)
(test-equal 9 (point-y p))
(test-eq #f (point? 1))
(test-error-tail type-exception? (point-x 1))
(test-error-tail type-exception? (point-y-set! 1 2))

(define-record-type counter
  (make-counter n)
  counter?
  (n counter-n counter-n-set!))

(define c (make-counter 0))
(counter-n-set! c (+ (counter-n c) 1))
(test-equal 1 (counter-n c))
(test-assert (counter? c))
(test-eq #f (counter? p))
