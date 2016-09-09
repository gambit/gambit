;;; RAY -- Ray-trace a simple scene with spheres, generating a ".pgm" file.
;;; Translated to Scheme from Paul Graham's book ANSI Common Lisp, Example 9.8

(define (make-point x y z)
  (vector x y z))

(define (point-x p) (vector-ref p 0))
(define (point-y p) (vector-ref p 1))
(define (point-z p) (vector-ref p 2))

(define (sq x) (FLOAT* x x))

(define (mag x y z)
  (FLOATsqrt (FLOAT+ (sq x) (sq y) (sq z))))

(define (unit-vector x y z)
  (let ((d (mag x y z)))
    (make-point (FLOAT/ x d) (FLOAT/ y d) (FLOAT/ z d))))

(define (distance p1 p2)
  (mag (FLOAT- (point-x p1) (point-x p2))
       (FLOAT- (point-y p1) (point-y p2))
       (FLOAT- (point-z p1) (point-z p2))))

(define (minroot a b c)
  (if (FLOATzero? a)
      (FLOAT/ (FLOAT- c) b)
      (let ((disc (FLOAT- (sq b) (FLOAT* 4.0 a c))))
        (if (FLOATnegative? disc)
            #f
            (let ((discrt (FLOATsqrt disc))
                  (minus-b (FLOAT- b))
                  (two-a (FLOAT* 2.0 a)))
              (FLOATmin (FLOAT/ (FLOAT+ minus-b discrt) two-a)
                        (FLOAT/ (FLOAT- minus-b discrt) two-a)))))))

(define *world* '())

(define eye (make-point 0.0 0.0 200.0))

(define (tracer pathname res)
  (call-with-output-file/truncate
   pathname
   (lambda (p)
     (let ((extent (* res 100)))
       (display "P2 " p)
       (write extent p)
       (display " " p)
       (write extent p)
       (display " 255" p)
       (newline p)
       (do ((y 0 (+ y 1)))
           ((= y extent))
         (do ((x 0 (+ x 1)))
             ((= x extent))
           (write (color-at
                   (FLOAT+ -50.0
                           (FLOAT/ (exact->inexact x) (exact->inexact res)))
                   (FLOAT+ -50.0
                           (FLOAT/ (exact->inexact y) (exact->inexact res))))
                  p)
           (newline p)))))))

(define (color-at x y)
  (let ((ray (unit-vector (FLOAT- x (point-x eye))
                          (FLOAT- y (point-y eye))
                          (FLOAT- (point-z eye)))))
    (FLOATinexact->exact (FLOATround (FLOAT* (sendray eye ray) 255.0)))))

(define (sendray pt ray)
  (let* ((x (first-hit pt ray))
         (s (vector-ref x 0))
         (int (vector-ref x 1)))
    (if s
        (FLOAT* (lambert s int ray)
                (surface-color s))
        0.0)))

(define (first-hit pt ray)
  (let loop ((lst *world*) (surface #f) (hit #f) (dist 1e308))
    (if (null? lst)
        (vector surface hit)
        (let ((s (car lst)))
          (let ((h (intersect s pt ray)))
            (if h
                (let ((d (distance h pt)))
                  (if (FLOAT< d dist)
                      (loop (cdr lst) s h d)
                      (loop (cdr lst) surface hit dist)))
                (loop (cdr lst) surface hit dist)))))))

(define (lambert s int ray)
  (let ((n (normal s int)))
    (FLOATmax 0.0
              (FLOAT+ (FLOAT* (point-x ray) (point-x n))
                      (FLOAT* (point-y ray) (point-y n))
                      (FLOAT* (point-z ray) (point-z n))))))

(define (make-sphere color radius center)
  (vector color radius center))

(define (sphere-color s) (vector-ref s 0))
(define (sphere-radius s) (vector-ref s 1))
(define (sphere-center s) (vector-ref s 2))

(define (defsphere x y z r c)
  (let ((s (make-sphere c r (make-point x y z))))
    (set! *world* (cons s *world*))
    s))

(define (surface-color s)
  (sphere-color s))

(define (intersect s pt ray)
  (sphere-intersect s pt ray))

(define (sphere-intersect s pt ray)
  (let* ((xr (point-x ray))
         (yr (point-y ray))
         (zr (point-z ray))
         (c (sphere-center s))
         (n (minroot
             (FLOAT+ (sq xr) (sq yr) (sq zr))
             (FLOAT* 2.0
                     (FLOAT+ (FLOAT* (FLOAT- (point-x pt) (point-x c)) xr)
                             (FLOAT* (FLOAT- (point-y pt) (point-y c)) yr)
                             (FLOAT* (FLOAT- (point-z pt) (point-z c)) zr)))
             (FLOAT+ (sq (FLOAT- (point-x pt) (point-x c)))
                     (sq (FLOAT- (point-y pt) (point-y c)))
                     (sq (FLOAT- (point-z pt) (point-z c)))
                     (FLOAT- (sq (sphere-radius s)))))))
    (if n
        (make-point (FLOAT+ (point-x pt) (FLOAT* n xr))
                    (FLOAT+ (point-y pt) (FLOAT* n yr))
                    (FLOAT+ (point-z pt) (FLOAT* n zr)))
        #f)))

(define (normal s pt)
  (sphere-normal s pt))

(define (sphere-normal s pt)
  (let ((c (sphere-center s)))
    (unit-vector (FLOAT- (point-x c) (point-x pt))
                 (FLOAT- (point-y c) (point-y pt))
                 (FLOAT- (point-z c) (point-z pt)))))

(define (ray-test . opt)
  (set! *world* '())
  (defsphere 0.0 -300.0 -1200.0 200.0 0.8)
  (defsphere -80.0 -150.0 -1200.0 200.0 0.7)
  (defsphere 70.0 -100.0 -1200.0 200.0 0.9)
  (do ((x -2 (+ x 1)))
      ((> x 2))
    (do ((z 2 (+ z 1)))
        ((> z 7))
      (defsphere
        (FLOAT* (exact->inexact x) 200.0)
        300.0
        (FLOAT* (exact->inexact z) -400.0)
        40.0
        0.75)))
  (tracer "spheres.pgm" (if (null? opt) 1 (car opt))))

(define (run)
  (ray-test 1)
  'ok)

(define (main . args)
  (run-benchmark
    "ray"
    ray-iters
    (lambda (result)
      (equal? result 'ok))
    (lambda () (lambda () (run)))))
