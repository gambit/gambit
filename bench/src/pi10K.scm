;;; PI -- Compute PI using bignums.

; See http://mathworld.wolfram.com/Pi.html for the various algorithms.

; Utilities.

(define (square-root x)
  (integer-sqrt x))

(define (quartic-root x)
  (square-root (square-root x)))

(define (square x)
  (GENERIC* x x))

; Compute pi using the 'brent-salamin' method.

(define (pi-brent-salamin nb-digits)
  (let ((one (GENERICexpt 10 nb-digits)))
    (let loop ((a one)
               (b (square-root (GENERICquotient (square one) 2)))
               (t (GENERICquotient one 4))
               (x 1))
      (if (GENERIC= a b)
          (GENERICquotient (square (GENERIC+ a b)) (GENERIC* 4 t))
          (let ((new-a (GENERICquotient (GENERIC+ a b) 2)))
            (loop new-a
                  (square-root (GENERIC* a b))
                  (GENERIC- t
                            (GENERICquotient
                             (GENERIC* x (square (GENERIC- new-a a)))
                             one))
                  (GENERIC* 2 x)))))))

; Compute pi using the quadratically converging 'borwein' method.

(define (pi-borwein2 nb-digits)
  (let* ((one (GENERICexpt 10 nb-digits))
         (one^2 (square one))
         (one^4 (square one^2))
         (sqrt2 (square-root (GENERIC* one^2 2)))
         (qurt2 (quartic-root (GENERIC* one^4 2))))
    (let loop ((x (GENERICquotient
                   (GENERIC* one (GENERIC+ sqrt2 one))
                   (GENERIC* 2 qurt2)))
               (y qurt2)
               (p (GENERIC+ (GENERIC* 2 one) sqrt2)))
      (let ((new-p (GENERICquotient (GENERIC* p (GENERIC+ x one))
                                    (GENERIC+ y one))))
        (if (GENERIC= x one)
            new-p
            (let ((sqrt-x (square-root (GENERIC* one x))))
              (loop (GENERICquotient
                     (GENERIC* one (GENERIC+ x one))
                     (GENERIC* 2 sqrt-x))
                    (GENERICquotient
                     (GENERIC* one (GENERIC+ (GENERIC* x y) one^2))
                     (GENERIC* (GENERIC+ y one) sqrt-x))
                    new-p)))))))

; Compute pi using the quartically converging 'borwein' method.

(define (pi-borwein4 nb-digits)
  (let* ((one (GENERICexpt 10 nb-digits))
         (one^2 (square one))
         (one^4 (square one^2))
         (sqrt2 (square-root (GENERIC* one^2 2))))
    (let loop ((y (GENERIC- sqrt2 one))
               (a (GENERIC- (GENERIC* 6 one) (GENERIC* 4 sqrt2)))
               (x 8))
      (if (GENERIC= y 0)
          (GENERICquotient one^2 a)
          (let* ((t1 (quartic-root (GENERIC- one^4 (square (square y)))))
                 (t2 (GENERICquotient
                      (GENERIC* one (GENERIC- one t1))
                      (GENERIC+ one t1)))
                 (t3 (GENERICquotient
                      (square (GENERICquotient (square (GENERIC+ one t2)) one))
                      one))
                 (t4 (GENERIC+ one
                               (GENERIC+ t2
                                         (GENERICquotient (square t2) one)))))
            (loop t2
                  (GENERICquotient
                   (GENERIC- (GENERIC* t3 a) (GENERIC* x (GENERIC* t2 t4)))
                   one)
                  (GENERIC* 4 x)))))))

; Try it.

(define (pies n)
  (map (lambda (n) (GENERICremainder n 10000000))
       (list (pi-brent-salamin n)
             (pi-borwein2 n)
             (pi-borwein4 n))))

;;; The last seven digits of the various approximations to pi to
;;; 10,000 digits.

(define expected '(6375574 6375668 6340751))

(define (main . args)
  (run-benchmark
   "pi10K"
   pi10K-iters
   (lambda (result) (equal? result expected))
   (lambda (n) (lambda () (pies n)))
   #e1e4
   ))
