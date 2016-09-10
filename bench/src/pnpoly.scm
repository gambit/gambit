;;; PNPOLY - Test if a point is contained in a 2D polygon.

(define (pt-in-poly2 xp yp x y)
  (let loop ((c #f) (i (- (FLOATvector-length xp) 1)) (j 0))
    (if (< i 0)
      c
      (if (or (and (or (FLOAT> (FLOATvector-ref yp i) y)
                       (FLOAT>= y (FLOATvector-ref yp j)))
                   (or (FLOAT> (FLOATvector-ref yp j) y)
                       (FLOAT>= y (FLOATvector-ref yp i))))
              (FLOAT>= x
                       (FLOAT+ (FLOATvector-ref xp i)
                               (FLOAT/ (FLOAT*
                                        (FLOAT- (FLOATvector-ref xp j)
                                                (FLOATvector-ref xp i))
                                        (FLOAT- y (FLOATvector-ref yp i)))
                                       (FLOAT- (FLOATvector-ref yp j)
                                               (FLOATvector-ref yp i))))))
        (loop c (- i 1) i)
        (loop (not c) (- i 1) i)))))

(define (run)
  (let ((count 0)
        (xp (FLOATvector-const 0. 1. 1. 0. 0. 1. -.5 -1. -1. -2. -2.5
                               -2. -1.5 -.5 1. 1. 0. -.5 -1. -.5))
        (yp (FLOATvector-const 0. 0. 1. 1. 2. 3. 2. 3. 0. -.5 -1.
                               -1.5 -2. -2. -1.5 -1. -.5 -1. -1. -.5)))
    (if (pt-in-poly2 xp yp .5 .5) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp .5 1.5) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp -.5 1.5) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp .75 2.25) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp 0. 2.01) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp -.5 2.5) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp -1. -.5) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp -1.5 .5) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp -2.25 -1.) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp .5 -.25) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp .5 -1.25) (set! count (+ count 1)))
    (if (pt-in-poly2 xp yp -.5 -2.5) (set! count (+ count 1)))
    count))

(define (main . args)
  (run-benchmark
    "pnpoly"
    pnpoly-iters
    (lambda (result)
      (and (number? result) (= result 6)))
    (lambda () (lambda () (run)))))
