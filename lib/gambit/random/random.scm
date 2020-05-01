;;;============================================================================

;;; File: "random.scm"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Pseudo-random number generation.

(##include "random#.scm")

;;;----------------------------------------------------------------------------

;;; SRFI 27 compatibility.

;;; This code is based on Pierre Lecuyer's MRG32K3A generator.

(define-type random-source
  id: 1b002758-f900-4e96-be5e-fa407e331fc0
  implementer: implement-type-random-source
  constructor: macro-make-random-source
  type-exhibitor: macro-type-random-source
  macros:
  prefix: macro-
  opaque:

  (state-ref         unprintable: read-only:)
  (state-set!        unprintable: read-only:)
  (randomize!        unprintable: read-only:)
  (pseudo-randomize! unprintable: read-only:)
  (make-integers     unprintable: read-only:)
  (make-reals        unprintable: read-only:)
  (make-u8vectors    unprintable: read-only:)
  (make-f64vectors   unprintable: read-only:)
  )

(define-check-type random-source
  (macro-type-random-source)
  macro-random-source?)

(implement-type-random-source)
(implement-check-type-random-source)

(define-prim (##make-random-source-mrg32k3a)

  (##define-macro (macro-w)
    65536)

  (##define-macro (macro-w^2-mod-m1)
    209)

  (##define-macro (macro-w^2-mod-m2)
    22853)

  (##define-macro (macro-m1)
    4294967087) ;; (- (expt (macro-w) 2) (macro-w^2-mod-m1))

  (##define-macro (macro-m1-inexact)
    4294967087.0) ;; (exact->inexact (macro-m1))

  (##define-macro (macro-m1-plus-1-inexact)
    4294967088.0) ;; (exact->inexact (+ (macro-m1) 1))

  (##define-macro (macro-inv-m1-plus-1-inexact)
    2.328306549295728e-10) ;; (exact->inexact (/ (+ (macro-m1) 1)))

  (##define-macro (macro-m1-minus-1)
    4294967086) ;; (- (macro-m1) 1)

  (##define-macro (macro-k)
    28)

  (##define-macro (macro-2^k)
    268435456) ;; (expt 2 (macro-k))

  (##define-macro (macro-2^k-inexact)
    268435456.0) ;; (exact->inexact (expt 2 (macro-k)))

  (##define-macro (macro-inv-2^k-inexact)
    3.725290298461914e-9) ;; (exact->inexact (/ (expt 2 (macro-k))))

  (##define-macro (macro-2^53-k-inexact)
    33554432.0) ;; (exact->inexact (expt 2 (- 53 (macro-k))))

  (##define-macro (macro-m1-div-2^k-inexact)
    15.0) ;; (exact->inexact (quotient (macro-m1) (expt 2 (macro-k))))

  (##define-macro (macro-m1-div-2^k-times-2^k-inexact)
    4026531840.0) ;; (exact->inexact (* (quotient (macro-m1) (expt 2 (macro-k))) (expt 2 (macro-k))))

  (##define-macro (macro-m2)
    4294944443) ;; (- (expt (macro-w) 2) (macro-w^2-mod-m2))

  (##define-macro (macro-m2-inexact)
    4294944443.0) ;; (exact->inexact (macro-m2))

  (##define-macro (macro-m2-minus-1)
    4294944442) ;; (- (macro-m2) 1)

  (define (pack-state a b c d e f)
    (##f64vector
     (##exact-int->flonum a)
     (##exact-int->flonum b)
     (##exact-int->flonum c)
     (##exact-int->flonum d)
     (##exact-int->flonum e)
     (##exact-int->flonum f)
     (macro-inexact-+0) ;; where the result of advance-state! is put
     (macro-inexact-+0) ;; q in rand-fixnum32
     (macro-inexact-+0) ;; qn in rand-fixnum32
     ))

  (define (unpack-state state)
    (##vector
     (##flonum->exact-int (##f64vector-ref state 0))
     (##flonum->exact-int (##f64vector-ref state 1))
     (##flonum->exact-int (##f64vector-ref state 2))
     (##flonum->exact-int (##f64vector-ref state 3))
     (##flonum->exact-int (##f64vector-ref state 4))
     (##flonum->exact-int (##f64vector-ref state 5))))

  (let ((state ;; initial state is 0 3 6 9 12 15 of A^(2^4), see below
         (pack-state
          1062452522
          2961816100
          342112271
          2854655037
          3321940838
          3542344109)))

    (define (state-ref)
      (unpack-state state))

    (define (state-set! rs new-state)

      (define (integer-in-range? x m)
        (and (macro-exact-int? x)
             (##not (##negative? x))
             (##< x m)))

      (or (and (##vector? new-state)
               (##fx= (##vector-length new-state) 6)
               (let ((a (##vector-ref new-state 0))
                     (b (##vector-ref new-state 1))
                     (c (##vector-ref new-state 2))
                     (d (##vector-ref new-state 3))
                     (e (##vector-ref new-state 4))
                     (f (##vector-ref new-state 5)))
                 (and (integer-in-range? a (macro-m1))
                      (integer-in-range? b (macro-m1))
                      (integer-in-range? c (macro-m1))
                      (integer-in-range? d (macro-m2))
                      (integer-in-range? e (macro-m2))
                      (integer-in-range? f (macro-m2))
                      (not (and (eqv? a 0) (eqv? b 0) (eqv? c 0)))
                      (not (and (eqv? d 0) (eqv? e 0) (eqv? f 0)))
                      (begin
                        (set! state
                              (pack-state a b c d e f))
                        (void)))))
          (##raise-type-exception
           2
           'random-source-state
           random-source-state-set!
           (list rs new-state))))

    (define (randomize!)

      (define (random-fixnum-from-time)
        (let ((v (##f64vector (macro-inexact-+0))))
          (##get-current-time! v 0)
          (let ((x (##f64vector-ref v 0)))
            (##flonum->fixnum
             (##fl* 536870912.0 ;; (expt 2.0 29)
                    (##fl- x (##flfloor x)))))))

      (define seed16
        (random-fixnum-from-time))

      (define (simple-random16)
        (let ((r (##bitwise-and2 seed16 65535)))
          (set! seed16
                (##+ (##* 30903 r)
                     (##arithmetic-shift seed16 -16)))
          r))

      (define (simple-random32)
        (##+ (##arithmetic-shift (simple-random16) 16)
             (simple-random16)))

      ;; perturb the state randomly

      (let ((s (unpack-state state)))
        (set! state
              (pack-state
               (##+ 1
                    (##modulo (##+ (##vector-ref s 0)
                                   (simple-random32))
                              (macro-m1-minus-1)))
               (##modulo (##+ (##vector-ref s 1)
                              (simple-random32))
                         (macro-m1))
               (##modulo (##+ (##vector-ref s 2)
                              (simple-random32))
                         (macro-m1))
               (##+ 1
                    (##modulo (##+ (##vector-ref s 3)
                                   (simple-random32))
                              (macro-m2-minus-1)))
               (##modulo (##+ (##vector-ref s 4)
                              (simple-random32))
                         (macro-m2))
               (##modulo (##+ (##vector-ref s 5)
                              (simple-random32))
                         (macro-m2))))
        (void)))

    (define (pseudo-randomize! i j)

      (define (mult A B) ;; A*B

        (define (lc i0 i1 i2 j0 j1 j2 m)
          (##modulo (##+ (##* (##vector-ref A i0)
                              (##vector-ref B j0))
                         (##+ (##* (##vector-ref A i1)
                                   (##vector-ref B j1))
                              (##* (##vector-ref A i2)
                                   (##vector-ref B j2))))
                    m))

        (##vector
         (lc  0  1  2   0  3  6  (macro-m1))
         (lc  0  1  2   1  4  7  (macro-m1))
         (lc  0  1  2   2  5  8  (macro-m1))
         (lc  3  4  5   0  3  6  (macro-m1))
         (lc  3  4  5   1  4  7  (macro-m1))
         (lc  3  4  5   2  5  8  (macro-m1))
         (lc  6  7  8   0  3  6  (macro-m1))
         (lc  6  7  8   1  4  7  (macro-m1))
         (lc  6  7  8   2  5  8  (macro-m1))
         (lc  9 10 11   9 12 15  (macro-m2))
         (lc  9 10 11  10 13 16  (macro-m2))
         (lc  9 10 11  11 14 17  (macro-m2))
         (lc 12 13 14   9 12 15  (macro-m2))
         (lc 12 13 14  10 13 16  (macro-m2))
         (lc 12 13 14  11 14 17  (macro-m2))
         (lc 15 16 17   9 12 15  (macro-m2))
         (lc 15 16 17  10 13 16  (macro-m2))
         (lc 15 16 17  11 14 17  (macro-m2))))

      (define (power A e) ;; A^e
        (cond ((##eq? e 0)
               identity)
              ((##eq? e 1)
               A)
              ((##even? e)
               (power (mult A A) (##arithmetic-shift e -1)))
              (else
               (mult (power A (##- e 1)) A))))

      (define identity
        '#(         1           0           0
                    0           1           0
                    0           0           1
                    1           0           0
                    0           1           0
                    0           0           1))

      (define A ;; primary MRG32k3a equations
        '#(         0     1403580  4294156359
                    1           0           0
                    0           1           0
               527612           0  4293573854
                    1           0           0
                    0           1           0))

      (define A^2^127 ;; A^(2^127)
        '#(1230515664   986791581  1988835001
           3580155704  1230515664   226153695
            949770784  3580155704  2427906178
           2093834863    32183930  2824425944
           1022607788  1464411153    32183930
           1610723613   277697599  1464411153))

      (define A^2^76 ;; A^(2^76)
        '#(  69195019  3528743235  3672091415
           1871391091    69195019  3672831523
           4127413238  1871391091    82758667
           3708466080  4292754251  3859662829
           3889917532  1511326704  4292754251
           1610795712  3759209742  1511326704))

      (define A^2^4 ;; A^(2^4)
        '#(1062452522   340793741  2955879160
           2961816100  1062452522   387300998
            342112271  2961816100   736416029
           2854655037  1817134745  3493477402
           3321940838   818368950  1817134745
           3542344109  3790774567   818368950))

      (let ((M ;; M = A^(2^4 + i*2^127 + j*2^76)
             (mult A^2^4
                   (mult (power A^2^127 i)
                         (power A^2^76 j)))))
        (set! state
              (pack-state
               (##vector-ref M 0)
               (##vector-ref M 3)
               (##vector-ref M 6)
               (##vector-ref M 9)
               (##vector-ref M 12)
               (##vector-ref M 15)))
        (void)))

    (define (advance-state!)
      (##declare (not interrupts-enabled))
      (let* ((state state)
             (x10
              (##fl- (##fl* 1403580.0 (##f64vector-ref state 1))
                     (##fl*  810728.0 (##f64vector-ref state 2))))
             (y10
              (##fl- x10
                     (##fl* (##flfloor (##fl/ x10 (macro-m1-inexact)))
                            (macro-m1-inexact))))
             (x20
              (##fl- (##fl*  527612.0 (##f64vector-ref state 3))
                     (##fl* 1370589.0 (##f64vector-ref state 5))))
             (y20
              (##fl- x20
                     (##fl* (##flfloor (##fl/ x20 (macro-m2-inexact)))
                            (macro-m2-inexact)))))
        (##f64vector-set! state 5 (##f64vector-ref state 4))
        (##f64vector-set! state 4 (##f64vector-ref state 3))
        (##f64vector-set! state 3 y20)
        (##f64vector-set! state 2 (##f64vector-ref state 1))
        (##f64vector-set! state 1 (##f64vector-ref state 0))
        (##f64vector-set! state 0 y10)
        (if (##fl< y10 y20)
            (##f64vector-set! state 6 (##fl+ (macro-m1-inexact)
                                             (##fl- (##f64vector-ref state 0)
                                                    (##f64vector-ref state 3))))
            (##f64vector-set! state 6 (##fl- (##f64vector-ref state 0)
                                             (##f64vector-ref state 3))))))

    (define (make-integers)

      (define (random-integer range)

        (define (type-error)
          (##fail-check-exact-integer 1 random-integer range))

        (define (range-error)
          (##raise-range-exception 1 random-integer range))

        (macro-force-vars (range)
          (macro-exact-int-dispatch range (type-error)
            (if (##fxpositive? range)
                (if (##fx< (macro-max-fixnum32) range) ;;TODO: check if this should be fx<=
                    (rand-integer range)
                    (rand-fixnum32 range))
                (range-error))
            (if (##bignum.negative? range)
                (range-error)
                (rand-integer range)))))

      random-integer)

    (define (rand-integer range)

      ;; constants for computing fixnum approximation of inverse of range

      (define size 14)
      (define 2^2*size 268435456)

      (let ((len (integer-length range)))
        (if (##fx= (##fx- len 1) ;; check if range is a power of 2
                   (##first-bit-set range))
            (rand-integer-2^ (##fx- len 1))
            (let* ((inv
                    (##fxquotient
                     2^2*size
                     (##fx+ 1
                            (##extract-bit-field size (##fx- len size) range))))
                   (range2
                    (##* range inv)))
              (let loop ()
                (let ((r (rand-integer-2^ (##fx+ len size))))
                  (if (##< r range2)
                      (##quotient r inv)
                      (loop))))))))

    (define (rand-integer-2^ w)

      (define (rand w s)
        (cond ((##fx< w (macro-k))
               (##fxand (rand-fixnum32-2^k)
                        (##fx- (##fxarithmetic-shift-left 1 w) 1)))
              ((##fx= w (macro-k))
               (rand-fixnum32-2^k))
              (else
               (let ((s/2 (##fxarithmetic-shift-right s 1)))
                 (if (##fx< s w)
                     (##+ (rand s s/2)
                          (##arithmetic-shift (rand (##fx- w s) s/2) s))
                     (rand w s/2))))))

      (define (split w s)
        (let ((s*2 (##fx* 2 s)))
          (if (##fx< s*2 w)
              (split w s*2)
              s)))

      (rand w (split w (macro-k))))

    (define (rand-fixnum32-2^k)
      (##declare (not interrupts-enabled))
      (let loop ()
        (advance-state!)
        (if (##fl< (##f64vector-ref state 6)
                   (macro-m1-div-2^k-times-2^k-inexact))
            (##flonum->fixnum
             (##fl/ (##f64vector-ref state 6)
                    (macro-m1-div-2^k-inexact)))
            (loop))))

    (define (rand-fixnum32 range) ;; range is a fixnum32
      (##declare (not interrupts-enabled))
      (let* ((a (##fixnum->flonum range))
             (b (##flfloor (##fl/ (macro-m1-inexact) a))))
        (##f64vector-set! state 7 b)
        (##f64vector-set! state 8 (##fl* a b)))
      (let loop ()
        (advance-state!)
        (if (##fl< (##f64vector-ref state 6)
                   (##f64vector-ref state 8))
            (##flonum->fixnum
             (##fl/ (##f64vector-ref state 6)
                    (##f64vector-ref state 7)))
            (loop))))

    (define (make-reals precision)
      (if (##fl< precision (macro-inv-m1-plus-1-inexact))
          (lambda ()
            (let loop ((r (##fixnum->flonum (rand-fixnum32-2^k)))
                       (d (macro-inv-2^k-inexact)))
              (if (##fl< r (macro-flonum-+m-max-plus-1-inexact))
                  (loop (##fl+ (##fl* r (macro-2^k-inexact))
                               (##fixnum->flonum (rand-fixnum32-2^k)))
                        (##fl* d (macro-inv-2^k-inexact)))
                  (##fl* r d))))
          (lambda ()
            (##declare (not interrupts-enabled))
            (advance-state!)
            (##fl* (##fl+ (macro-inexact-+1) (##f64vector-ref state 6))
                   (macro-inv-m1-plus-1-inexact)))))

    (define (make-u8vectors)
      (lambda (len)
        (macro-force-vars (len)
          (macro-check-index len 1 (random-u8vector len)
            (let ((u8vect (##make-u8vector len 0)))
              (let loop ((i (##fx- len 1)))
                (if (##fx< i 0)
                    u8vect
                    (begin
                      (##u8vector-set! u8vect i (rand-fixnum32 256))
                      (loop (##fx- i 1))))))))))

    (define (make-f64vectors precision)
      (if (##fl< precision (macro-inv-m1-plus-1-inexact))
          (let ((make-real (make-reals precision)))
            (lambda (len)
              (macro-force-vars (len)
                (macro-check-index len 1 (random-f64vector len)
                  (let ((f64vect (##make-f64vector len (macro-inexact-+0))))
                    (let loop ((i (##fx- len 1)))
                      (if (##fx< i 0)
                          f64vect
                          (begin
                            (##f64vector-set! f64vect i (make-real))
                            (loop (##fx- i 1))))))))))
          (lambda (len)
            (macro-force-vars (len)
              (macro-check-index len 1 (random-f64vector len)
                (let ((f64vect (##make-f64vector len (macro-inexact-+0))))
                  (let loop ((i (##fx- len 1)))
                    (if (##fx< i 0)
                        f64vect
                        (let ()
                          (##declare (not interrupts-enabled))
                          (advance-state!)
                          (##f64vector-set! f64vect i (##fl* (##fl+ (macro-inexact-+1)
                                                                (##f64vector-ref state 6))
                                                           (macro-inv-m1-plus-1-inexact)))
                          (loop (##fx- i 1)))))))))))

    (macro-make-random-source
     state-ref
     state-set!
     randomize!
     pseudo-randomize!
     make-integers
     make-reals
     make-u8vectors
     make-f64vectors)))

(define-prim (make-random-source)
  (##make-random-source-mrg32k3a))

(define-prim (random-source? obj)
  (macro-force-vars (obj)
    (macro-random-source? obj)))

(define-prim (##random-source-state-ref rs)
  ((macro-random-source-state-ref rs)))

(define-prim (random-source-state-ref rs)
  (macro-force-vars (rs)
    (macro-check-random-source rs 1 (random-source-state-ref rs)
      (##random-source-state-ref rs))))

(define-prim (##random-source-state-set! rs new-state)
  ((macro-random-source-state-set! rs) rs new-state))

(define-prim (random-source-state-set! rs new-state)
  (macro-force-vars (rs new-state)
    (macro-check-random-source rs 1 (random-source-state-set! rs new-state)
      (##random-source-state-set! rs new-state))))

(define-prim (##random-source-randomize! rs)
  ((macro-random-source-randomize! rs)))

(define-prim (random-source-randomize! rs)
  (macro-force-vars (rs)
    (macro-check-random-source rs 1 (random-source-randomize! rs)
      (##random-source-randomize! rs))))

(define-prim (##random-source-pseudo-randomize! rs i j)
  ((macro-random-source-pseudo-randomize! rs) i j))

(define-prim (random-source-pseudo-randomize! rs i j)
  (macro-force-vars (rs i j)
    (macro-check-random-source rs 1 (random-source-pseudo-randomize! rs i j)
      (if (not (macro-exact-int? i))
          (##fail-check-exact-integer 2 random-source-pseudo-randomize! rs i j)
          (if (not (macro-exact-int? j))
              (##fail-check-exact-integer 3 random-source-pseudo-randomize! rs i j)
              (if (##negative? i)
                  (##raise-range-exception 2 random-source-pseudo-randomize! rs i j)
                  (if (##negative? j)
                      (##raise-range-exception 3 random-source-pseudo-randomize! rs i j)
                      (##random-source-pseudo-randomize! rs i j))))))))

(define-prim (##random-source-make-integers rs)
  ((macro-random-source-make-integers rs)))

(define-prim (random-source-make-integers rs)
  (macro-force-vars (rs)
    (macro-check-random-source rs 1 (random-source-make-integers rs)
      (##random-source-make-integers rs))))

(define-prim (##random-source-make-reals rs #!optional (p (macro-absent-obj)))
  ((macro-random-source-make-reals rs)
   (if (eq? p (macro-absent-obj))
       (macro-inexact-+1)
       p)))

(define-prim (random-source-make-reals rs #!optional (p (macro-absent-obj)))
  (macro-force-vars (rs p)
    (macro-check-random-source rs 1 (random-source-make-reals rs p)
      (if (eq? p (macro-absent-obj))
          (##random-source-make-reals rs)
          (if (rational? p)
              (let ((precision (macro-real->inexact p)))
                (if (and (##fl< (macro-inexact-+0) precision)
                         (##fl< precision (macro-inexact-+1)))
                    (##random-source-make-reals rs precision)
                    (##raise-range-exception 2 random-source-make-reals rs p)))
              (##fail-check-finite-real 2 random-source-make-reals rs p))))))

(define-prim (##random-source-make-f64vectors rs #!optional (p (macro-absent-obj)))
  ((macro-random-source-make-f64vectors rs)
   (if (eq? p (macro-absent-obj))
       (macro-inexact-+1)
       p)))

(define-prim (random-source-make-f64vectors rs #!optional (p (macro-absent-obj)))
  (macro-force-vars (rs p)
    (macro-check-random-source rs 1 (random-source-make-f64vectors rs p)
      (if (eq? p (macro-absent-obj))
          (##random-source-make-f64vectors rs)
          (if (rational? p)
              (let ((precision (macro-real->inexact p)))
                (if (and (##fl< (macro-inexact-+0) precision)
                         (##fl< precision (macro-inexact-+1)))
                    (##random-source-make-f64vectors rs precision)
                    (##raise-range-exception 2 random-source-make-f64vectors rs p)))
              (##fail-check-finite-real 2 random-source-make-f64vectors rs p))))))

(define-prim (##random-source-make-u8vectors rs)
  ((macro-random-source-make-u8vectors rs)))

(define-prim (random-source-make-u8vectors rs)
  (macro-force-vars (rs)
    (macro-check-random-source rs 1 (random-source-make-u8vectors rs)
      (##random-source-make-u8vectors rs))))

(define ##default-random-source (##make-random-source-mrg32k3a))

(define default-random-source ##default-random-source)

(define random-integer
  (##random-source-make-integers ##default-random-source))

(define random-real
  (##random-source-make-reals ##default-random-source))

(define random-u8vector
  (##random-source-make-u8vectors ##default-random-source))

(define random-f64vector
  (##random-source-make-f64vectors ##default-random-source))

;;;============================================================================
