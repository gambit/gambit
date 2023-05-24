;; execute with './gsi/gsi -:=. ./gsc/igsc.scm test.scm'

(declare
  (version-limit 2)
  (standard-bindings)    ;; +, - and < are the predefined primitives
  (extended-bindings)    ;; identity, etc are the predefined primitives
  (inlining-limit 0)     ;; no inlining
  (not constant-fold)    ;; no constant folding
  (not safe)
)

;; This is probably from Lars Hansen's MS thesis.
;; The quick-1 benchmark.  (Figure 35, page 132.)

;;(import (scheme base) (scheme read) (scheme write) (scheme time))

(define (quick-1 v less?)

  (define (helper left right)
    (if (fx< left right)
        (let ((median (partition v left right less?)))
          (if (fx< (fx- median left) (fx- right median))
              (begin (helper left (fx- median 1))
                     (helper (+ median 1) right))
              (begin (helper (+ median 1) right)
                     (helper left (fx- median 1)))))
        v))

  (helper 0 (fx- (vector-length v) 1)))


(define (partition v left right less?)
  (let ((mid (vector-ref v right)))

    (define (uploop i)
      (let ((i (+ i 1)))
        (if (and (fx< i right) (less? (vector-ref v i) mid))
            (uploop i)
            i)))

    (define (downloop j)
      (let ((j (fx- j 1)))
        (if (and (> j left) (less? mid (vector-ref v j)))
            (downloop j)
            j)))

    (define (ploop i j)
      (let* ((i (uploop i))
             (j (downloop j)))
        (let ((tmp (vector-ref v i)))
          (vector-set! v i (vector-ref v j))
          (vector-set! v j tmp)
          (if (fx< i j)
              (ploop i j)
              (begin (vector-set! v j (vector-ref v i))
                     (vector-set! v i (vector-ref v right))
                     (vector-set! v right tmp)
                     i)))))

    (ploop (fx- left 1) right)))

;;; Hansen's original code for this benchmark used Larceny's
;;; predefined random procedure.  When Marc Feeley modified
;;; Hansen's benchmark for the Gambit benchmark suite, however,
;;; he added a specific random number generator taken from an
;;; article in CACM.  Feeley's generator used bignums, and was
;;; extremely slow, causing the Gambit version of this benchmark
;;; to spend nearly all of its time generating the random numbers.
;;; For a benchmark called quicksort to become a bignum benchmark
;;; was very misleading, so Clinger left Feeley's version of this
;;; benchmark out of the Larceny benchmark suite.
;;;
;;; The following random number generator is much better and
;;; faster than the one used in the Gambit benchmark.  See
;;;
;;; http://srfi.schemers.org/srfi-27/mail-archive/msg00000.html
;;; http://www.math.purdue.edu/~lucier/random/random.scm

;;; A uniform [0,1] random number generator; is
;;; Pierre L'Ecuyer's generator from his paper
;;; "Good parameters and implementations for combined multiple
;;; recursive random number generators"
;;; available at his web site http://www.iro.umontreal.ca/~lecuyer

(define seed-set! #f)
(define seed-ref #f)
(define random-flonum #f)

(let ((norm 2.328306549295728e-10)
      (m1 4294967087.0)
      (m2 4294944443.0)
      (a12 1403580.0)
      (a13n 810728.0)
      (a21 527612.0)
      (a23n 1370589.0)
      (seed (vector 1.0 0.0 0.0 1.0 0.0 0.0)));; will be mutated

  ;; uses no conversions between flonums and fixnums.

  (set! random-flonum
        (lambda ()
          (let ((seed seed));; make it local
            (let ((p1 (fl- (fl* a12 (vector-ref seed 1))
                            (fl* a13n (vector-ref seed 0))))
                  (p2 (fl- (fl* a21 (vector-ref seed 5))
                            (fl* a23n (vector-ref seed 3)))))
              (let ((k1 (truncate (/ p1 m1)))
                    (k2 (truncate (/ p2 m2)))
                    (ignore1 (vector-set! seed 0 (vector-ref seed 1)))
                    (ignore3 (vector-set! seed 3 (vector-ref seed 4))))
                (let ((p1 (fl- p1 (fl* k1 m1)))
                      (p2 (fl- p2 (fl* k2 m2)))
                      (ignore2 (vector-set! seed 1 (vector-ref seed 2)))
                      (ignore4 (vector-set! seed 4 (vector-ref seed 5))))
                  (let ((p1 (if (fl< p1 0.0) (+ p1 m1) p1))
                        (p2 (if (fl< p2 0.0) (+ p2 m2) p2)))
                    (vector-set! seed 2 p1)
                    (vector-set! seed 5 p2)
                    (if (fl<= p1 p2)
                        (fl* norm (+ (fl- p1 p2) m1))
                        (fl* norm (fl- p1 p2))))))))))

  (set! seed-ref (lambda () (vector->list seed)))

  (set! seed-set! (lambda l (set! seed (Slist->vector l)))))

(define (random n)
  (inexact->exact (fltruncate (fl* (exact->inexact n) (random-flonum)))))

;;; Even with the improved random number generator,
;;; this benchmark still spends almost all of its time
;;; generating the random vector.  To make this a true
;;; quicksort benchmark, we generate a relatively small
;;; random vector and then sort many copies of it.

(define n 10000)
(define r 1000000)

(define input
  (let ((v (make-vector n)))
    (do ((i 0 (fx+ i 1)))
        ((fx= i n))
      (vector-set! v i (random r)))
    v))

(define (run #!key (i (##first-argument input)) (less? (##first-argument (lambda (x y) (fx< x y)))))
  (quick-1 i less?))

(define (check result)
  (call-with-current-continuation
   (lambda (return)
     (do ((i 1 (fx+ i 1)))
         ((= i (vector-length result))
          #t)
       (unless (fx<= (vector-ref result (fx- i 1))
                      (vector-ref result i))
         (return #f))))))

(pp (run))
