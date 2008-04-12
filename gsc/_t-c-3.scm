;;;============================================================================

;;; File: "_t-c-3.scm", Time-stamp: <2008-04-12 10:08:26 feeley>

;;; Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved.

(include "generic.scm")

(include-adt "_envadt.scm")
(include-adt "_gvmadt.scm")
(include-adt "_ptreeadt.scm")
(include-adt "_sourceadt.scm")

'(begin;**************brad
(##declare (fixnum))
(##include "_hostadt.scm")
(##declare (generic))
)

;;;----------------------------------------------------------------------------
;;
;; Back end for C language (part 3)
;; -----------------------

(define targ-bits-per-byte 8) ; 8 bits per byte

(define (targ-ceiling-log2 n)
  (let loop ((i 0) (x 1))
    (if (< x n)
      (loop (+ i 1) (* x 2))
      i)))

;; FIXNUM representation.

;; Limits of fixnums (assumes 2's complement representation):

(define targ-min-fixnum32
  (* -2
     (expt 2 (- (* 4 targ-bits-per-byte)
                (+ targ-tag-bits 2)))))

(define targ-max-fixnum32
  (- (+ targ-min-fixnum32 1)))

(define (targ-fixnum32? x)
  (and (integer? x)
       (exact? x)
       (>= x targ-min-fixnum32)
       (<= x targ-max-fixnum32)))

(define (targ-nonzero-fixnum32? x)
  (and (targ-fixnum32? x)
       (not (zero? x))))

(define targ-min-fixnum64
  (* -2
     (expt 2 (- (* 8 targ-bits-per-byte)
                (+ targ-tag-bits 2)))))

(define targ-max-fixnum64
  (- (+ targ-min-fixnum64 1)))

(define (targ-fixnum64? x)
  (and (integer? x)
       (exact? x)
       (>= x targ-min-fixnum64)
       (<= x targ-max-fixnum64)))

(define (targ-cast-to-fixnum32 n)
  (+ (modulo (- n targ-min-fixnum32) (* -2 targ-min-fixnum32))
     targ-min-fixnum32))

(define (targ-u32-to-s32 n)
  (if (< 2147483647 n)
    (- n 4294967296)
    n))

(define (targ-s32-to-u32 n)
  (if (< n 0)
    (+ n 4294967296)
    n))

(define (targ-u64-to-s64 n)
  (if (< 9223372036854775807 n)
    (- n 18446744073709551616)
    n))

(define (targ-s64-to-u64 n)
  (if (< n 0)
    (+ n 18446744073709551616)
    n))

(define (targ-s32->hex-string n)
  (cond ((= n -2147483648)
         "-1-0x7FFFFFFF")
        ((< n 0)
         (string-append "-0x" (number->string (- n) 16)))
        (else
         (string-append "0x" (number->string n 16)))))

(define (targ-s64->hi-lo-bits x)
  (let* ((y (targ-u64->hi-lo-bits (targ-s64-to-u64 x)))
         (hi (car y))
         (lo (cdr y)))
    (cons (targ-u32-to-s32 hi)
          lo)))

(define (targ-u64->hi-lo-bits x)
  (cons (quotient x #x100000000)
        (modulo   x #x100000000)))

;; BIGNUM representation.

(define targ-min-adigit-width 32) ; At least 32 bits per adigit
(define targ-max-adigit-width 64) ; At most 64 bits per adigit

(define (targ-bignum-digits obj)

  (define (dig n len rest)
    (cond ((= len 1)
           (cons n rest))
          (else
           (let* ((hi-len (quotient len 2))
                  (lo-len (- len hi-len))
                  (lo-len-bits (* targ-min-adigit-width lo-len)))
             (let* ((hi (arithmetic-shift n (- lo-len-bits)))
                    (lo (- n (arithmetic-shift hi lo-len-bits))))
               (dig lo
                    lo-len
                    (dig hi
                         hi-len
                         rest)))))))

  (let* ((width (integer-length obj))
         (len (+ (quotient width targ-min-adigit-width) 1)))
    (dig (if (< obj 0)
           (+ (arithmetic-shift 1 (* targ-min-adigit-width len)) obj)
           obj)
         len
         '())))

;; FLONUM representation.

(define targ-inexact-+2   (exact->inexact 2))
(define targ-inexact--2   (exact->inexact -2))
(define targ-inexact-+1   (exact->inexact 1))
(define targ-inexact-+1/2 (exact->inexact (/ 1 2)))
(define targ-inexact-+0   (exact->inexact 0))

(define (targ-float->inexact-exponential-format x f64?)
  (let* ((e-bits (if f64? 11 8))
         (e-bias (- (expt 2 (- e-bits 1)) 1)))

    (define (exp-form-pos x y i)
      (let ((i*2 (+ i i)))
        (let ((z (if (and (not (< e-bias i*2))
                          (not (< x y)))
                   (exp-form-pos x (* y y) i*2)
                   (vector x 0 1))))
          (let ((a (vector-ref z 0)) (b (vector-ref z 1)))
            (let ((i+b (+ i b)))
              (if (and (not (< e-bias i+b))
                       (not (< a y)))
                (begin
                  (vector-set! z 0 (/ a y))
                  (vector-set! z 1 i+b)))
              z)))))

    (define (exp-form-neg x y i)
      (let ((i*2 (+ i i)))
        (let ((z (if (and (< i*2 (- e-bias 1))
                          (< x y))
                   (exp-form-neg x (* y y) i*2)
                   (vector x 0 1))))
          (let ((a (vector-ref z 0)) (b (vector-ref z 1)))
            (let ((i+b (+ i b)))
              (if (and (< i+b (- e-bias 1))
                       (< a y))
                (begin
                  (vector-set! z 0 (/ a y))
                  (vector-set! z 1 i+b)))
              z)))))

    (define (exp-form x)
      (if (< x targ-inexact-+1)
        (let ((z (exp-form-neg x targ-inexact-+1/2 1)))
          (vector-set! z 0 (* targ-inexact-+2 (vector-ref z 0)))
          (vector-set! z 1 (- -1 (vector-ref z 1)))
          z)
        (exp-form-pos x targ-inexact-+2 1)))

    (if (negative? (float-copysign targ-inexact-+1 x))
      (let ((z (exp-form (float-copysign x targ-inexact-+1))))
        (vector-set! z 2 -1)
        z)
      (exp-form x))))

(define (targ-float->exact-exponential-format x f64?)
  (let* ((z      (targ-float->inexact-exponential-format x f64?))
         (m-bits (if f64? 52 23))
         (e-bits (if f64? 11 8)))

    (let ((y (vector-ref z 0)))
      (if (not (< y targ-inexact-+2)) ; +inf.0 or +nan.0?
        (begin
          (if (< targ-inexact-+0 y)
            (vector-set! z 0 (expt 2 m-bits))              ; +inf.0
            (vector-set! z 0 (- (* (expt 2 m-bits) 2) 1))) ; +nan.0
          (vector-set! z 1 (expt 2 (- e-bits 1))))
        (vector-set! z 0
          (truncate
            (inexact->exact
             (* (vector-ref z 0) (exact->inexact (expt 2 m-bits)))))))
      (vector-set! z 1 (- (vector-ref z 1) m-bits))
      z)))

(define (targ-float->bits x f64?)
  (let ((m-bits (if f64? 52 23))
        (e-bits (if f64? 11 8)))

    (define (bits a b)
      (let ((m-min (expt 2 m-bits)))
        (if (< a m-min)
          a
          (+ (- a m-min)
             (* (+ (+ b m-bits) (- (expt 2 (- e-bits 1)) 1))
                m-min)))))

    (let* ((z (targ-float->exact-exponential-format x f64?))
           (y (bits (vector-ref z 0) (vector-ref z 1))))
      (if (negative? (vector-ref z 2))
        (+ (expt 2 (+ e-bits m-bits)) y)
        y))))

(define (targ-f32->bits x)
  (targ-float->bits x #f))

(define (targ-f64->hi-lo-bits x)
  (targ-u64->hi-lo-bits (targ-float->bits x #t)))

(define (targ-unusual-float? x)
  (cond ((zero? x)
         (negative? (float-copysign targ-inexact-+1 x)))
        ((negative? x)
         (not (< x (/ x targ-inexact-+2))))
        (else
         (not (< (/ x targ-inexact-+2) x)))))

(define (targ-flonum? x)
  (and (number? x)
       (inexact? (targ-real-part x))
       (exact? (targ-imag-part x))
       (zero? (targ-imag-part x))))

(define (targ-nonzero-flonum? x)
  (and (targ-flonum? x)
       (not (zero? x))))

;; RATNUM representation.

(define (targ-numerator x)
  (numerator x))

(define (targ-denominator x)
  (denominator x))

;; CPXNUM representation.

(define (targ-real-part x)
  (real-part x))

(define (targ-imag-part x)
  (imag-part x))

(define (targ-integer? x)
  (integer? x))

(define (targ-nonzero-integer? x)
  (and (targ-integer? x)
       (not (zero? x))))

(define (targ-number? x)
  (number? x))

(define (targ-nonzero-number? x)
  (and (targ-number? x)
       (not (zero? x))))

;; Extraction of object's type and subtype.

(define (targ-obj-type obj)
  (cond ((false-object? obj)
         'boolean)
        ((eq? obj #t)
         'boolean)
        ((null? obj)
         'null)
        ((absent-object? obj)
         'absent)
        ((unused-object? obj)
         'unused)
        ((deleted-object? obj)
         'deleted)
        ((void-object? obj)
         'void)
        ((unbound1-object? obj)
         'unbound1)
        ((unbound2-object? obj)
         'unbound2)
        ((end-of-file-object? obj)
         'eof)
        ((optional-object? obj)
         'optional)
        ((key-object? obj)
         'key)
        ((rest-object? obj)
         'rest)
        ((symbol-object? obj)
         'subtyped)
        ((keyword-object? obj)
         'subtyped)
        ((structure-object? obj)
         'subtyped)
        ((box-object? obj)
         'subtyped)
        ((proc-obj? obj)
         'subtyped)
        ((pair? obj)
         'pair)
        ((number? obj)
         (cond ((targ-fixnum32? obj)
                'fixnum32)
               (else
                'subtyped)))
        ((char? obj)
         'char)
        (else
         'subtyped)))

(define (targ-obj-subtype obj)
  (cond ((proc-obj? obj)
         'procedure)
        ((symbol-object? obj)
         'symbol)
        ((keyword-object? obj)
         'keyword)
        ((structure-object? obj)
         'structure)
        ((box-object? obj)
         'box)
        ((number? obj)
         (cond ((and (integer? obj) (exact? obj))
                (if (targ-fixnum64? obj)
                  'bigfixnum
                  'bignum))
               ((and (rational? obj) (exact? obj))
                'ratnum)
               ((and (inexact? (targ-real-part obj))
                     (exact? (targ-imag-part obj))
                     (zero? (targ-imag-part obj)))
                'flonum)
               (else
                'cpxnum)))
        ((s8vect? obj)
         's8vector)
        ((u8vect? obj)
         'u8vector)
        ((s16vect? obj)
         's16vector)
        ((u16vect? obj)
         'u16vector)
        ((s32vect? obj)
         's32vector)
        ((u32vect? obj)
         'u32vector)
        ((s64vect? obj)
         's64vector)
        ((u64vect? obj)
         'u64vector)
        ((f32vect? obj)
         'f32vector)
        ((f64vect? obj)
         'f64vector)
        ((vector-object? obj)
         'vector)
        ((string? obj)
         'string)
        (else
         (compiler-internal-error
           "targ-obj-subtype, unknown object 'obj'" obj))))

(define (targ-obj-subtype-integer obj)

  (define (err)
    (compiler-internal-error
     "targ-obj-subtype-integer, unknown subtyped object 'obj'" obj))

  (case (targ-obj-type obj)
    ((pair)
     1)
    ((subtyped)
     (case (targ-obj-subtype obj)
       ((vector)     0)
       ((ratnum)     2)
       ((cpxnum)     3)
       ((structure)  4)
       ((box)        5)
       ((symbol)     8)
       ((keyword)    9)
       ((procedure) 14)
       ((string)    19)
       ((s8vector)  20)
       ((u8vector)  21)
       ((s16vector) 22)
       ((u16vector) 23)
       ((s32vector) 24)
       ((u32vector) 25)
       ((s64vector) 26)
       ((u64vector) 27)
       ((f32vector) 28)
       ((f64vector) 29)
       ((flonum)    30)
       ((bignum)    31)
       (else        (err))))
    (else
     (err))))

;; Note: The following hashing function must return the same value as the
;; functions "hash_UTF_8_string" and "hash_scheme_string" in "lib/setup.c".

(define (targ-hash str)
  (let ((len (string-length str)))
    (let loop ((h 0) (i 0))
      (if (< i len)
        (loop (modulo
               (* (+ (quotient h 256)
                     (character->unicode (string-ref str i)))
                  331804471); =(* (/ (- (sqrt 5) 1) 2) (+ targ-max-fixnum32 1))
               (+ targ-max-fixnum32 1))
              (+ i 1))
        h))))

(define (targ-build-gc-map slots live?)
  (let loop ((i 0)
             (2^i 1)
             (lst slots)
             (gc-map 0))
    (if (pair? lst)
      (let ((var (car lst)))
        (loop (+ i 1)
              (* 2^i 2)
              (cdr lst)
              (if (live? i var)
                (+ gc-map 2^i)
                gc-map)))
      gc-map)))

(define (targ-build-gc-map-all-live fs)
  (- (expt 2 fs) 1))

(define (targ-gc-map-chunks gc-map kind fs)

  (define bits-per-chunk 32)
  (define two^32 4294967296)

  (define (build-chunks gc-map fs)
    (if (<= fs 0)
      '()
      (cons (remainder gc-map two^32)
            (build-chunks (quotient gc-map two^32) (- fs bits-per-chunk)))))

  (build-chunks gc-map (targ-actual-fs kind fs)))

(define (targ-out-of-line-frame? kind fs)
  (> (targ-actual-fs kind fs) targ-max-inline-fs))

(define (targ-actual-fs kind fs)
  (if (eq? kind 'internal)
    (+ (targ-align-frame fs) (+ targ-nb-gvm-regs 1))
    fs))

(define (targ-align-frame fs)
  (* (quotient (+ fs (- targ-frame-alignment 1))
               targ-frame-alignment)
     targ-frame-alignment))

(define targ-min-word-size-in-bits
  (* targ-min-word-size targ-bits-per-byte))

(define targ-max-inline-fs
  (- targ-min-word-size-in-bits
     (+ 2 ; 2 bits needed for tag
        (* 2 ; space for fs and link
           (targ-ceiling-log2 targ-min-word-size-in-bits)))))

;;;----------------------------------------------------------------------------
