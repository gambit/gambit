;;;============================================================================

;;; File: "_num.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2004-2022 by Brad Lucier, All Rights Reserved.

;;;============================================================================

(macro-case-target
 ((C)
  (c-declare "#include \"mem.h\"")
  (##define-macro (macro-min-bignum-adigits) 1)
  (##define-macro (use-fast-bignum-algorithms) #t))

 ((js)
  (##define-macro (macro-min-bignum-adigits) 3)
  ;; Set this to minimize code size, but js is fast enough to benefit
  ;; from fast bignum algorithms.
  (##define-macro (use-fast-bignum-algorithms) #f))

 (else
  (##define-macro (macro-min-bignum-adigits) 3)
  (##define-macro (use-fast-bignum-algorithms) #f)))

(define-prim (##use-fast-bignum-algorithms?)
  (use-fast-bignum-algorithms))

(##declare (mostly-fixnum))

;;;============================================================================

;;; Implementation of exceptions.

(implement-library-type-range-exception)

(define-prim (##raise-range-exception arg-num proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   arg-num
   #f
   #f
   (lambda (procedure arguments arg-num dummy1 dummy2)
     (macro-raise
      (macro-make-range-exception procedure arguments arg-num)))))

(implement-library-type-divide-by-zero-exception)

(define-prim (##raise-divide-by-zero-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-divide-by-zero-exception procedure arguments)))))

(implement-library-type-fixnum-overflow-exception)

(define-prim (##raise-fixnum-overflow-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-fixnum-overflow-exception procedure arguments)))))

;;;----------------------------------------------------------------------------

;;; Define type checking procedures.
;;; If you add another, update the list in _repl.scm.

(define-fail-check-type exact-unsigned-int8 'exact-unsigned-int8)
(define-fail-check-type exact-unsigned-int8-list 'exact-unsigned-int8-list)

(macro-if-s8vector
 (begin
   (define-fail-check-type exact-signed-int8 'exact-signed-int8)
   (define-fail-check-type exact-signed-int8-list 'exact-signed-int8-list)))

(macro-if-u16vector
 (begin
   (define-fail-check-type exact-unsigned-int16 'exact-unsigned-int16)
   (define-fail-check-type exact-unsigned-int16-list 'exact-unsigned-int16-list)))

(macro-if-s16vector
 (begin
   (define-fail-check-type exact-signed-int16 'exact-signed-int16)
   (define-fail-check-type exact-signed-int16-list 'exact-signed-int16-list)))


(macro-if-u32vector
 (begin
   (define-fail-check-type exact-unsigned-int32 'exact-unsigned-int32)
   (define-fail-check-type exact-unsigned-int32-list 'exact-unsigned-int32-list)))

(macro-if-s32vector
 (begin
   (define-fail-check-type exact-signed-int32 'exact-signed-int32)
   (define-fail-check-type exact-signed-int32-list 'exact-signed-int32-list)))

(macro-if-u64vector
 (begin
   (define-fail-check-type exact-unsigned-int64 'exact-unsigned-int64)
   (define-fail-check-type exact-unsigned-int64-list 'exact-unsigned-int64-list)))

(macro-if-s64vector
 (begin
   (define-fail-check-type exact-signed-int64 'exact-signed-int64)
   (define-fail-check-type exact-signed-int64-list 'exact-signed-int64-list)))

(define-fail-check-type inexact-real 'inexact-real)
(define-fail-check-type inexact-real-list 'inexact-real-list)

(define-fail-check-type number 'number)
(define-fail-check-type real 'real)
(define-fail-check-type finite-real 'finite-real)
(define-fail-check-type rational 'rational)
(define-fail-check-type integer 'integer)
(define-fail-check-type exact-integer 'exact-integer)
(define-fail-check-type nonnegative-exact-integer 'nonnegative-exact-integer)
(define-fail-check-type fixnum 'fixnum)
(define-fail-check-type flonum 'flonum)

;;;----------------------------------------------------------------------------

;;; Numerical type predicates.

(define-prim (##number? x)
  (##complex? x))

(define-prim (##complex? x)
  (macro-number-dispatch x #f
    #t ;; x = fixnum
    #t ;; x = bignum
    #t ;; x = ratnum
    #t ;; x = flonum
    #t)) ;; x = cpxnum

(define-prim (number? x)
  (macro-force-vars (x)
    (##number? x)))

(define-prim (complex? x)
  (macro-force-vars (x)
    (##complex? x)))

(define-prim (##real? x)
  (macro-number-dispatch x #f
    #t ;; x = fixnum
    #t ;; x = bignum
    #t ;; x = ratnum
    #t ;; x = flonum
    (macro-cpxnum-real? x))) ;; x = cpxnum

(define-prim (real? x)
  (macro-force-vars (x)
    (##real? x)))

(define-prim (##rational? x)
  (macro-number-dispatch x #f
    #t ;; x = fixnum
    #t ;; x = bignum
    #t ;; x = ratnum
    (macro-flonum-rational? x) ;; x = flonum
    (macro-cpxnum-rational? x))) ;; x = cpxnum

(define-prim (rational? x)
  (macro-force-vars (x)
    (##rational? x)))

(define-prim (##integer? x)
  (macro-number-dispatch x #f
    #t ;; x = fixnum
    #t ;; x = bignum
    #f ;; x = ratnum
    (macro-flonum-int? x) ;; x = flonum
    (macro-cpxnum-int? x))) ;; x = cpxnum

(define-prim (integer? x)
  (macro-force-vars (x)
    (##integer? x)))

(define-prim (##exact-integer? x)
  (macro-exact-int? x))

(define-prim (exact-integer? x)
  (macro-force-vars (x)
    (macro-exact-int? x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Exactness predicates.

(define-prim (##exact? x)

  (define (type-error) #f)

  (macro-number-dispatch x (type-error)
    #t ;; x = fixnum
    #t ;; x = bignum
    #t ;; x = ratnum
    #f ;; x = flonum
    (and (##not (##flonum? (macro-cpxnum-real x))) ;; x = cpxnum
         (##not (##flonum? (macro-cpxnum-imag x))))))

(define-prim (exact? x)
  (macro-force-vars (x)
    (let ()

      (define (type-error)
        (##fail-check-number 1 exact? x))

      (macro-number-dispatch x (type-error)
        #t ;; x = fixnum
        #t ;; x = bignum
        #t ;; x = ratnum
        #f ;; x = flonum
        (and (##not (##flonum? (macro-cpxnum-real x))) ;; x = cpxnum
             (##not (##flonum? (macro-cpxnum-imag x))))))))

(define-prim (##inexact? x)

  (define (type-error) #f)

  (macro-number-dispatch x (type-error)
    #f ;; x = fixnum
    #f ;; x = bignum
    #f ;; x = ratnum
    #t ;; x = flonum
    (or (##flonum? (macro-cpxnum-real x)) ;; x = cpxnum
        (##flonum? (macro-cpxnum-imag x)))))

(define-prim (inexact? x)
  (macro-force-vars (x)
    (let ()

      (define (type-error)
        (##fail-check-number 1 inexact? x))

      (macro-number-dispatch x (type-error)
        #f ;; x = fixnum
        #f ;; x = bignum
        #f ;; x = ratnum
        #t ;; x = flonum
        (or (##flonum? (macro-cpxnum-real x)) ;; x = cpxnum
            (##flonum? (macro-cpxnum-imag x)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Comparison predicates.

(define-prim (##=2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (macro-number-dispatch x (type-error-on-x)

    (macro-number-dispatch y (type-error-on-y) ;; x = fixnum
      (##fx= x y)
      #f
      #f
      (and (##fixnum->flonum-exact? x)
           (##fl= (##fixnum->flonum x) y))
      (##cpxnum.= (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = bignum
      #f
      (or (##eq? x y)
          (##exact-int.= x y))
      #f
      (and (##exact-int->flonum-exact? x)
           (##fl= (##exact-int->flonum x) y))
      (##cpxnum.= (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = ratnum
      #f
      #f
      (or (##eq? x y)
          (##ratnum.= x y))
      (and (##flfinite? y)
           (##ratnum.= x (##flonum->ratnum y)))
      (##cpxnum.= (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = flonum
      (and (##fixnum->flonum-exact? y)
           (##fl= x (##fixnum->flonum y)))
      (and (##exact-int->flonum-exact? y)
           (##fl= (##exact-int->flonum y) x))
      (and (##flfinite? x)
           (##ratnum.= (##flonum->ratnum x) y))
      (##fl= x y)
      (##cpxnum.= (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = cpxnum
      (##cpxnum.= x (macro-noncpxnum->cpxnum y))
      (##cpxnum.= x (macro-noncpxnum->cpxnum y))
      (##cpxnum.= x (macro-noncpxnum->cpxnum y))
      (##cpxnum.= x (macro-noncpxnum->cpxnum y))
      (##cpxnum.= x y))))

(define-prim-nary-bool (##= x y)
  #t
  #t
  (##=2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (= x y)
  #t
  (if (##number? x) #t '(1))
  (##=2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-number))

(define-prim (##<2 x y #!optional (nan-result #f))

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (macro-number-dispatch x (type-error-on-x)

    (macro-number-dispatch y (type-error-on-y) ;; x = fixnum
      (##fx< x y)
      (##not (##bignum.negative? y))
      (##ratnum.< (macro-exact-int->ratnum x) y)
      (cond ((##flfinite? y)
             (macro-if-ratnum
              (if (##fixnum->flonum-exact? x)
                  (##fl< (##fixnum->flonum x) y)
                  (##ratnum.< (macro-exact-int->ratnum x) (##flonum->ratnum y)))
              (##fl< (##fixnum->flonum x) y)))
            ((##flnan? y)
             nan-result)
            (else
             (##flpositive? y)))
      (if (macro-cpxnum-real? y)
          (##< x (macro-cpxnum-real y) nan-result)
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = bignum
      (##bignum.negative? x)
      (##exact-int.< x y)
      (##ratnum.< (macro-exact-int->ratnum x) y)
      (cond ((##flfinite? y)
             (macro-if-ratnum
              (##ratnum.< (macro-exact-int->ratnum x) (##flonum->ratnum y))
              (##fl< (##exact-int->flonum x) y)))
            ((##flnan? y)
             nan-result)
            (else
             (##flpositive? y)))
      (if (macro-cpxnum-real? y)
          (##< x (macro-cpxnum-real y) nan-result)
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = ratnum
      (##ratnum.< x (macro-exact-int->ratnum y))
      (##ratnum.< x (macro-exact-int->ratnum y))
      (##ratnum.< x y)
      (cond ((##flfinite? y)
             (##ratnum.< x (##flonum->ratnum y)))
            ((##flnan? y)
             nan-result)
            (else
             (##flpositive? y)))
      (if (macro-cpxnum-real? y)
          (##< x (macro-cpxnum-real y) nan-result)
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = flonum
      (cond ((##flfinite? x)
             (macro-if-ratnum
              (if (##fixnum->flonum-exact? y)
                  (##fl< x (##fixnum->flonum y))
                  (##ratnum.< (##flonum->ratnum x) (macro-exact-int->ratnum y)))
              (##fl< x (##fixnum->flonum y))))
            ((##flnan? x)
             nan-result)
            (else
             (##flnegative? x)))
      (cond ((##flfinite? x)
             (macro-if-ratnum
              (##ratnum.< (##flonum->ratnum x) (macro-exact-int->ratnum y))
              (##fl< x (##exact-int->flonum y))))
            ((##flnan? x)
             nan-result)
            (else
             (##flnegative? x)))
      (cond ((##flfinite? x)
             (##ratnum.< (##flonum->ratnum x) y))
            ((##flnan? x)
             nan-result)
            (else
             (##flnegative? x)))
      (if (or (##flnan? x) (##flnan? y))
          nan-result
          (##fl< x y))
      (if (macro-cpxnum-real? y)
          (##< x (macro-cpxnum-real y) nan-result)
          (type-error-on-y)))

    (if (macro-cpxnum-real? x) ;; x = cpxnum
        (macro-number-dispatch y (type-error-on-y)
          (##< (macro-cpxnum-real x) y nan-result)
          (##< (macro-cpxnum-real x) y nan-result)
          (##< (macro-cpxnum-real x) y nan-result)
          (##< (macro-cpxnum-real x) y nan-result)
          (if (macro-cpxnum-real? y)
              (##< (macro-cpxnum-real x) (macro-cpxnum-real y) nan-result)
              (type-error-on-y)))
        (type-error-on-x))))

(define-prim-nary-bool (##< x y)
  #t
  #t
  (##<2 x y #f)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (< x y)
  #t
  (if (##real? x) #t '(1))
  (##<2 x y #f)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-real))

(define-prim-nary-bool (##> x y)
  #t
  #t
  (##<2 y x #f)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (> x y)
  #t
  (if (##real? x) #t '(1))
  (##<2 y x #f)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-real))

(define-prim-nary-bool (##<= x y)
  #t
  #t
  (##not (##<2 y x #t))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (<= x y)
  #t
  (if (##real? x) #t '(1))
  (##not (##<2 y x #t))
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-real))

(define-prim-nary-bool (##>= x y)
  #t
  #t
  (##not (##<2 x y #t))
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (>= x y)
  #t
  (if (##real? x) #t '(1))
  (##not (##<2 x y #t))
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-real))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Numerical property predicates.

(define-prim (##zero? x)

  (define (type-error)
    (##fail-check-number 1 zero? x))

  (macro-number-dispatch x (type-error)
    (##fxzero? x)
    #f
    #f
    (##flzero? x)
    (and (let ((imag (macro-cpxnum-imag x)))
           (and (##flonum? imag) (##flzero? imag)))
         (let ((real (macro-cpxnum-real x)))
           (if (##flonum? real)
               (##flzero? real)
               (##eqv? real 0))))))

(define-prim (zero? x)
  (macro-force-vars (x)
    (##zero? x)))

(define-prim (##positive? x)

  (define (type-error)
    (##fail-check-real 1 positive? x))

  (macro-number-dispatch x (type-error)
    (##fxpositive? x)
    (##not (##bignum.negative? x))
    (##positive? (macro-ratnum-numerator x))
    (##flpositive? x)
    (if (macro-cpxnum-real? x)
        (##positive? (macro-cpxnum-real x))
        (type-error))))

(define-prim (positive? x)
  (macro-force-vars (x)
    (##positive? x)))

(define-prim (##negative? x)

  (define (type-error)
    (##fail-check-real 1 negative? x))

  (macro-number-dispatch x (type-error)
    (##fxnegative? x)
    (##bignum.negative? x)
    (##negative? (macro-ratnum-numerator x))
    (##flnegative? x)
    (if (macro-cpxnum-real? x)
        (##negative? (macro-cpxnum-real x))
        (type-error))))

(define-prim (negative? x)
  (macro-force-vars (x)
    (##negative? x)))

(define-prim (##odd? x)

  (define (type-error)
    (##fail-check-integer 1 odd? x))

  (macro-number-dispatch x (type-error)
    (##fxodd? x)
    (macro-bignum-odd? x)
    (type-error)
    (if (macro-flonum-int? x)
        (##odd? (##flonum->exact-int x))
        (type-error))
    (if (macro-cpxnum-int? x)
        (##odd? (##inexact->exact (macro-cpxnum-real x)))
        (type-error))))

(define-prim (odd? x)
  (macro-force-vars (x)
    (##odd? x)))

(define-prim (##exact-int.odd? x)
  (macro-if-bignum
   (if (##fixnum? x)
       (##fxodd? x)
       (macro-bignum-odd? x))
   (##fxodd? x)))

(define-prim (##even? x)

  (define (type-error)
    (##fail-check-integer 1 even? x))

  (macro-number-dispatch x (type-error)
    (##not (##fxodd? x))
    (##not (macro-bignum-odd? x))
    (type-error)
    (if (macro-flonum-int? x)
        (##even? (##flonum->exact-int x))
        (type-error))
    (if (macro-cpxnum-int? x)
        (##even? (##inexact->exact (macro-cpxnum-real x)))
        (type-error))))

(define-prim (even? x)
  (macro-force-vars (x)
    (##even? x)))

(define-prim (##finite? x)

  (define (type-error)
    (##fail-check-number 1 finite? x))

  (macro-number-dispatch x (type-error)
    #t
    #t
    #t
    (##flfinite? x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (and (or (##not (##flonum? real))
               (##flfinite? real))
           (or (##not (##flonum? imag))
               (##flfinite? imag))))))

(define-prim (finite? x)
  (macro-force-vars (x)
    (##finite? x)))

(define-prim (##infinite? x)

  (define (type-error)
    (##fail-check-number 1 infinite? x))

  (macro-number-dispatch x (type-error)
    #f
    #f
    #f
    (##flinfinite? x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (##flonum? real)
          (if (##flnan? real)
              #f
              (if (##flinfinite? real)
                  (##not (and (##flonum? imag)
                              (##flnan? imag)))
                  (and (##flonum? imag)
                       (##flinfinite? imag))))
          (and (##flonum? imag)
               (##flinfinite? imag))))))

(define-prim (infinite? x)
  (macro-force-vars (x)
    (##infinite? x)))

(define-prim (##nan? x)

  (define (type-error)
    (##fail-check-number 1 nan? x))

  (macro-number-dispatch x (type-error)
    #f
    #f
    #f
    (##flnan? x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (or (and (##flonum? real)
               (##flnan? real))
          (and (##flonum? imag)
               (##flnan? imag))))))

(define-prim (nan? x)
  (macro-force-vars (x)
    (##nan? x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Max and min.

(define-prim (##max2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (macro-number-dispatch x (type-error-on-x)

    (macro-number-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxmax x y)
      (if (##< x y) y x)
      (if (##< x y) y x)
      (##flmax (##fixnum->flonum x) y)
      (if (macro-cpxnum-real? y)
          (##max x (macro-cpxnum-real y))
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = bignum
      (if (##< x y) y x)
      (if (##< x y) y x)
      (if (##< x y) y x)
      (##flmax (##exact-int->flonum x) y)
      (if (macro-cpxnum-real? y)
          (##max x (macro-cpxnum-real y))
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = ratnum
      (if (##< x y) y x)
      (if (##< x y) y x)
      (if (##< x y) y x)
      (##flmax (##ratnum->flonum x) y)
      (if (macro-cpxnum-real? y)
          (##max x (macro-cpxnum-real y))
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = flonum
      (##flmax x (##fixnum->flonum y))
      (##flmax x (##exact-int->flonum y))
      (##flmax x (##ratnum->flonum y))
      (##flmax x y)
      (if (macro-cpxnum-real? y)
          (##max x (macro-cpxnum-real y))
          (type-error-on-y)))

    (if (macro-cpxnum-real? x) ;; x = cpxnum
        (macro-number-dispatch y (type-error-on-y)
          (##max (macro-cpxnum-real x) y)
          (##max (macro-cpxnum-real x) y)
          (##max (macro-cpxnum-real x) y)
          (##max (macro-cpxnum-real x) y)
          (if (macro-cpxnum-real? y)
              (##max (macro-cpxnum-real x) (macro-cpxnum-real y))
              (type-error-on-y)))
        (type-error-on-x))))

(define-prim-nary (##max x y)
  ()
  x
  (##max2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (max x y)
  ()
  (if (##real? x) x '(1))
  (##max2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-real))

(define-prim (##min2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (macro-number-dispatch x (type-error-on-x)

    (macro-number-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxmin x y)
      (if (##< x y) x y)
      (if (##< x y) x y)
      (##flmin (##fixnum->flonum x) y)
      (if (macro-cpxnum-real? y)
          (##min x (macro-cpxnum-real y))
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = bignum
      (if (##< x y) x y)
      (if (##< x y) x y)
      (if (##< x y) x y)
      (##flmin (##exact-int->flonum x) y)
      (if (macro-cpxnum-real? y)
          (##min x (macro-cpxnum-real y))
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = ratnum
      (if (##< x y) x y)
      (if (##< x y) x y)
      (if (##< x y) x y)
      (##flmin (##ratnum->flonum x) y)
      (if (macro-cpxnum-real? y)
          (##min x (macro-cpxnum-real y))
          (type-error-on-y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = flonum
      (##flmin x (##fixnum->flonum y))
      (##flmin x (##exact-int->flonum y))
      (##flmin x (##ratnum->flonum y))
      (##flmin x y)
      (if (macro-cpxnum-real? y)
          (##min x (macro-cpxnum-real y))
          (type-error-on-y)))

    (if (macro-cpxnum-real? x) ;; x = cpxnum
        (macro-number-dispatch y (type-error-on-y)
          (##min (macro-cpxnum-real x) y)
          (##min (macro-cpxnum-real x) y)
          (##min (macro-cpxnum-real x) y)
          (##min (macro-cpxnum-real x) y)
          (if (macro-cpxnum-real? y)
              (##min (macro-cpxnum-real x) (macro-cpxnum-real y))
              (type-error-on-y)))
        (type-error-on-x))))

(define-prim-nary (##min x y)
  ()
  x
  (##min2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (min x y)
  ()
  (if (##real? x) x '(1))
  (##min2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-real))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; +, *, -, /

(define-prim (##+2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))
  (##define-macro (fixnum-overflow) `#f)

  (define (int+rat int rat)
    (macro-ratnum-make
     (##+ (##* (macro-ratnum-denominator rat)
               int)
          (macro-ratnum-numerator rat))
     (macro-ratnum-denominator rat)))

  (macro-number-dispatch x (type-error-on-x)

    (macro-number-dispatch y (type-error-on-y) ;; x = fixnum
      (or (##fx+? x y)
          (macro-if-bignum
           (##bignum.+ (##fixnum->bignum x) (##fixnum->bignum y))
           (fixnum-overflow)))
      (if (##fxzero? x)
          y
          (##bignum.+ (##fixnum->bignum x) y))
      (if (##fxzero? x)
          y
          (int+rat x y))
      (if (and (macro-special-case-exact-zero?) (##fxzero? x))
          y
          (##fl+ (##fixnum->flonum x) y))
      (if (and (macro-special-case-exact-zero?) (##fxzero? x))
          y
          (##cpxnum.+ (macro-noncpxnum->cpxnum x) y)))

    (macro-number-dispatch y (type-error-on-y) ;; x = bignum
      (if (##fxzero? y)
          x
          (##bignum.+ x (##fixnum->bignum y)))
      (##bignum.+ x y)
      (int+rat x y)
      (##fl+ (##exact-int->flonum x) y)
      (##cpxnum.+ (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = ratnum
      (if (##fxzero? y)
          x
          (int+rat y x))
      (int+rat y x)
      (##ratnum.+ x y)
      (##fl+ (##ratnum->flonum x) y)
      (##cpxnum.+ (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = flonum
      (if (and (macro-special-case-exact-zero?) (##fxzero? y))
          x
          (##fl+ x (##fixnum->flonum y)))
      (##fl+ x (##exact-int->flonum y))
      (##fl+ x (##ratnum->flonum y))
      (##fl+ x y)
      (##cpxnum.+ (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = cpxnum
      (if (and (macro-special-case-exact-zero?) (##fxzero? y))
          x
          (##cpxnum.+ x (macro-noncpxnum->cpxnum y)))
      (##cpxnum.+ x (macro-noncpxnum->cpxnum y))
      (##cpxnum.+ x (macro-noncpxnum->cpxnum y))
      (##cpxnum.+ x (macro-noncpxnum->cpxnum y))
      (##cpxnum.+ x y))))

(define-prim-nary (##+ x y)
  0
  x
  (##+2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (+ x y)
  0
  (if (##number? x) x '(1))
  (##+2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-number)
  (##not ##raise-fixnum-overflow-exception))

(define-prim (##*2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))
  (##define-macro (fixnum-overflow) `#f)

  (define (int*rat int rat)
    (let* ((num (macro-ratnum-numerator rat))
           (den (macro-ratnum-denominator rat))
           (gcd (##gcd den int))
           (result-num (##* num (##quotient int gcd)))
           (result-den (##quotient den gcd)))
      (if (##eqv? result-den 1)
          result-num
          (macro-ratnum-make result-num result-den))))

  (macro-number-dispatch x (type-error-on-x)

    (macro-number-dispatch y (type-error-on-y) ;; x = fixnum
      (cond ((##fx= y 0)
             0)
            ((if (##fx= y -1)
                 (##fx-? x)
                 (##fx*? x y))
             => (lambda (result) result))
            (else
             (macro-if-bignum
              (##bignum.* (##fixnum->bignum x) (##fixnum->bignum y))
              (fixnum-overflow))))
      (cond ((##fxzero? x)
             0)
            ((##fx= x 1)
             y)
            ((##fx= x -1)
             (##negate y))
            (else
             (##bignum.* (##fixnum->bignum x) y)))
      (cond ((##fxzero? x)
             0)
            ((##fx= x 1)
             y)
            ((##fx= x -1)
             (##negate y))
            (else
             (int*rat x y)))
      (cond ((and (macro-special-case-exact-zero?)
                  (##fxzero? x))
             0)
            ((##fx= x 1)
             y)
            (else
             (##fl* (##fixnum->flonum x) y)))
      (cond ((and (macro-special-case-exact-zero?)
                  (##fxzero? x))
             0)
            ((##fx= x 1)
             y)
            (else
             (##cpxnum.* (macro-noncpxnum->cpxnum x) y))))

    (macro-number-dispatch y (type-error-on-y) ;; x = bignum
      (cond ((##fx= y 0)
             0)
            ((##fx= y 1)
             x)
            ((##fx= y -1)
             (##negate x))
            (else
             (##bignum.* x (##fixnum->bignum y))))
      (##bignum.* x y)
      (int*rat x y)
      (##fl* (##exact-int->flonum x) y)
      (##cpxnum.* (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = ratnum
      (cond ((##fxzero? y)
             0)
            ((##fx= y 1)
             x)
            ((##fx= y -1)
             (##negate x))
            (else
             (int*rat y x)))
      (int*rat y x)
      (##ratnum.* x y)
      (##fl* (##ratnum->flonum x) y)
      (##cpxnum.* (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = flonum
      (cond ((and (macro-special-case-exact-zero?) (##fxzero? y))
             0)
            ((##fx= y 1)
             x)
            (else
             (##fl* x (##fixnum->flonum y))))
      (##fl* x (##exact-int->flonum y))
      (##fl* x (##ratnum->flonum y))
      (##fl* x y)
      (##cpxnum.* (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = cpxnum
      (cond ((and (macro-special-case-exact-zero?) (##fxzero? y))
             0)
            ((##fx= y 1)
             x)
            (else
             (##cpxnum.* x (macro-noncpxnum->cpxnum y))))
      (##cpxnum.* x (macro-noncpxnum->cpxnum y))
      (##cpxnum.* x (macro-noncpxnum->cpxnum y))
      (##cpxnum.* x (macro-noncpxnum->cpxnum y))
      (##cpxnum.* x y))))

(define-prim-nary (##* x y)
  1
  x
  (##*2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (* x y)
  1
  (if (##number? x) x '(1))
  (##*2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-number)
  (##not ##raise-fixnum-overflow-exception))

(define-prim (##exact-int.* x y)
  (macro-if-bignum
   (if (##fixnum? x)
       (if (##fixnum? y)
           (or (##fx*? x y)
               (##bignum.* (##fixnum->bignum x) (##fixnum->bignum y)))
           (##bignum.* (##fixnum->bignum x) y))
       (if (##fixnum? y)
           (##bignum.* x (##fixnum->bignum y))
           (##bignum.* x y)))
   (or (##fx*? x y)
       (##raise-fixnum-overflow-exception ##exact-int.* x y))))

(define-prim (##square x)

  (define (type-error)
    (##fail-check-number 1 square x))

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception square x))

  (macro-number-dispatch x (type-error)
    (or (##fxsquare? x)
        (macro-if-bignum
         (let ((x (##fixnum->bignum x)))
           (##bignum.* x x))
         (fixnum-overflow)))
    (##bignum.* x x)
    (macro-ratnum-make (##square (macro-ratnum-numerator x))
                       (##square (macro-ratnum-denominator x)))
    (##fl* x x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (or (##eqv? real 0)
              (##exact? x))
          (##make-rectangular (##* (##- real imag) (##+ real imag))
                              (##* 2 (##* real imag)))
          (##csquare (##exact->inexact x))))))

(define-prim (square x)
  (macro-force-vars (x)
    (##square x)))

(define-prim (##exact-int.square x)
  (macro-if-bignum
   (if (##fixnum? x)
       (or (##fxsquare? x)
           (let ((x (##fixnum->bignum x)))
             (##bignum.* x x)))
       (##bignum.* x x))
   (or (##fxsquare? x)
       (##raise-fixnum-overflow-exception ##exact-int.square x))))

(define-prim (##negate x)

  (##define-macro (type-error) `'(1))
  (##define-macro (fixnum-overflow) `#f)

  (macro-number-dispatch x (type-error)
    (or (##fx-? x)
        (macro-if-bignum
         ##bignum.-min-fixnum
         (fixnum-overflow)))
    (##bignum.- (##fixnum->bignum 0) x)
    (macro-ratnum-make (##negate (macro-ratnum-numerator x))
                       (macro-ratnum-denominator x))
    (##fl- x)
    (##make-rectangular (##negate (macro-cpxnum-real x))
                        (##negate (macro-cpxnum-imag x)))))

(define-prim (##-2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))
  (##define-macro (fixnum-overflow) `#f)

  (define (int-rat int rat)
    (macro-ratnum-make
     (##- (##* (macro-ratnum-denominator rat)
               int)
          (macro-ratnum-numerator rat))
     (macro-ratnum-denominator rat)))

  (define (rat-int rat int)
    (macro-ratnum-make
     (##- (macro-ratnum-numerator rat)
          (##* (macro-ratnum-denominator rat)
               int))
     (macro-ratnum-denominator rat)))

  (macro-number-dispatch x (type-error-on-x)

    (macro-number-dispatch y (type-error-on-y) ;; x = fixnum
      (or (##fx-? x y)
          (macro-if-bignum
           (##bignum.- (##fixnum->bignum x) (##fixnum->bignum y))
           (fixnum-overflow)))
      (##bignum.- (##fixnum->bignum x) y)
      (if (##fxzero? x)
          (##negate y)
          (int-rat x y))
      (if (and (macro-special-case-exact-zero?) (##fxzero? x))
          (##fl- y)
          (##fl- (##fixnum->flonum x) y))
      (##cpxnum.- (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = bignum
      (if (##fxzero? y)
          x
          (##bignum.- x (##fixnum->bignum y)))
      (##bignum.- x y)
      (int-rat x y)
      (##fl- (##exact-int->flonum x) y)
      (##cpxnum.- (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = ratnum
      (if (##fxzero? y)
          x
          (rat-int x y))
      (rat-int x y)
      (##ratnum.- x y)
      (##fl- (##ratnum->flonum x) y)
      (##cpxnum.- (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = flonum
      (if (and (macro-special-case-exact-zero?) (##fxzero? y))
          x
          (##fl- x (##fixnum->flonum y)))
      (##fl- x (##exact-int->flonum y))
      (##fl- x (##ratnum->flonum y))
      (##fl- x y)
      (##cpxnum.- (macro-noncpxnum->cpxnum x) y))

    (macro-number-dispatch y (type-error-on-y) ;; x = cpxnum
      (if (and (macro-special-case-exact-zero?) (##fxzero? y))
          x
          (##cpxnum.- x (macro-noncpxnum->cpxnum y)))
      (##cpxnum.- x (macro-noncpxnum->cpxnum y))
      (##cpxnum.- x (macro-noncpxnum->cpxnum y))
      (##cpxnum.- x (macro-noncpxnum->cpxnum y))
      (##cpxnum.- x y))))

(define-prim-nary (##- x y)
  ()
  (##negate x)
  (##-2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (- x y)
  ()
  (##negate x)
  (##-2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-number)
  (##not ##raise-fixnum-overflow-exception))

(define-prim (##inverse x)

  (##define-macro (type-error) `'(1))

  (define (divide-by-zero-error) #f)

  (macro-number-dispatch x (type-error)
    (cond ((##eqv? x 0)
           (divide-by-zero-error))
          ((or (##eqv? x 1)
               (##eqv? x -1))
           x)
          (else
           (macro-if-ratnum
            (if (##fxnegative? x)
                (macro-ratnum-make -1 (##negate x))
                (macro-ratnum-make 1 x))
            (##fl/ (macro-inexact-+1) (##fixnum->flonum x)))))
    (if (##bignum.negative? x)
        (macro-ratnum-make -1 (##negate x))
        (macro-ratnum-make 1 x))
    (let ((num (macro-ratnum-numerator x))
          (den (macro-ratnum-denominator x)))
      (cond ((##fx= num 1)
             den)
            ((##fx= num -1)
             (##negate den))
            (else
             (if (##negative? num)
                 (macro-ratnum-make (##negate den) (##negate num))
                 (macro-ratnum-make den num)))))
    (##fl/ (macro-inexact-+1) x)
    (##cpxnum./ (macro-noncpxnum->cpxnum 1) x)))

(cond-expand
  (use-pairs-for-qr-structures
   (##define-macro (macro-make-qr q r) `(##cons ,q ,r))
   (##define-macro (macro-qr-q qr)     `(##car ,qr))
   (##define-macro (macro-qr-r qr)     `(##cdr ,qr)))
  (else
   (##define-macro (macro-make-qr q r) `(##values ,q ,r))
   (##define-macro (macro-qr-q qr)     `(##values-ref ,qr 0))
   (##define-macro (macro-qr-r qr)     `(##values-ref ,qr 1))))

(define-prim (##/2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (define (divide-by-zero-error) #f)

  (define (int/rat int rat)
    (let* ((num (macro-ratnum-numerator rat))
           (den (macro-ratnum-denominator rat))
           (gcd (##gcd num int))
           (result-num (##* den (##quotient int gcd)))
           (result-den (##quotient num gcd)))
      (cond ((##eqv? result-den 1)
           result-num)
          ((##eqv? result-den -1)
           (##negate result-num))
          ((##negative? result-den)
           (macro-ratnum-make (##negate result-num) (##negate result-den)))
          (else
           (macro-ratnum-make result-num result-den)))))

  (define (rat/int rat int)
    (let* ((num (macro-ratnum-numerator rat))
           (den (macro-ratnum-denominator rat))
           (gcd (##gcd num int))
           (result-num (##quotient num gcd))
           (result-den (##* den (##quotient int gcd))))  ;; |result-den|>1
      (if (##negative? result-den)
          (macro-ratnum-make (##negate result-num) (##negate result-den))
          (macro-ratnum-make result-num result-den))))

  (define (divide-exact-ints)
    (macro-if-ratnum
     (##ratnum.normalize x y)
     (let ((qr (##exact-int.div x y)))
       (if (##eqv? (macro-qr-r qr) 0)
           (macro-qr-q qr)
           (##fl/ (##exact-int->flonum x) (##exact-int->flonum y))))))

  (macro-number-dispatch y (type-error-on-y)

    (macro-number-dispatch x (type-error-on-x) ;; y = fixnum
      (cond ((##fxzero? y)
             (divide-by-zero-error))
            ((##fx= y 1)
             x)
            ((##fx= y -1)
             (##negate x))
            ((##fxzero? x)
             0)
            ((##fx= x 1)
             (##inverse y))
            (else
             (divide-exact-ints)))
      (cond ((##fxzero? y)
             (divide-by-zero-error))
            ((##fx= y 1)
             x)
            ((##fx= y -1)
             (##negate x))
            (else
             (divide-exact-ints)))
      (cond ((##fxzero? y)
             (divide-by-zero-error))
            ((##fx= y 1)
             x)
            ((##fx= y -1)
             (##negate x))
            (else
             (rat/int x y)))
      (cond ((##fxzero? y)
             (divide-by-zero-error))
            ((##fx= y 1)
             x)
            (else
             (##fl/ x (##fixnum->flonum y))))
      (cond ((##fxzero? y)
             (divide-by-zero-error))
            ((##fx= y 1)
             x)
            (else
             (##cpxnum./ x (macro-noncpxnum->cpxnum y)))))

    (macro-number-dispatch x (type-error-on-x) ;; y = bignum
      (cond ((##fxzero? x)
             0)
            ((##fx= x 1)
             (##inverse y))
            (else
             (divide-exact-ints)))
      (divide-exact-ints)
      (rat/int x y)
      (##fl/ x (##exact-int->flonum y))
      (##cpxnum./ x (macro-noncpxnum->cpxnum y)))

    (macro-number-dispatch x (type-error-on-x) ;; y = ratnum
      (cond ((##fxzero? x)
             0)
            ((##fx= x 1)
             (##inverse y))
            (else
             (int/rat x y)))
      (int/rat x y)
      (##ratnum./ x y)
      (##fl/ x (##ratnum->flonum y))
      (##cpxnum./ x (macro-noncpxnum->cpxnum y)))

    (macro-number-dispatch x (type-error-on-x) ;; y = flonum, no error possible
      (if (and (macro-special-case-exact-zero?) (##fxzero? x))
          0
          (##fl/ (##fixnum->flonum x) y))
      (##fl/ (##exact-int->flonum x) y)
      (##fl/ (##ratnum->flonum x) y)
      (##fl/ x y)
      (##cpxnum./ x (macro-noncpxnum->cpxnum y)))

    (macro-number-dispatch x (type-error-on-x) ;; y = cpxnum
      (##cpxnum./ (macro-noncpxnum->cpxnum x) y)
      (##cpxnum./ (macro-noncpxnum->cpxnum x) y)
      (##cpxnum./ (macro-noncpxnum->cpxnum x) y)
      (##cpxnum./ (macro-noncpxnum->cpxnum x) y)
      (##cpxnum./ x y))))

(define-prim-nary (##/ x y)
  ()
  (##inverse x)
  (##/2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (/ x y)
  ()
  (##inverse x)
  (##/2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-number)
  (##not ##raise-divide-by-zero-exception))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; abs

(define-prim (##exact-int.negative? x)
  (macro-if-bignum
   (if (##fixnum? x)
       (##fxnegative? x)
       (##bignum.negative? x))
   (##fxnegative? x)))

(define-prim (##abs x)

  (define (type-error)
    (##fail-check-real 1 abs x))

  (macro-number-dispatch x (type-error)
    (if (##fxnegative? x) (##negate x) x)
    (if (##bignum.negative? x) (##negate x) x)
    (if (##exact-int.negative? (macro-ratnum-numerator x))
        (macro-ratnum-make (##negate (macro-ratnum-numerator x))
                           (macro-ratnum-denominator x))
        x)
    (##flabs x)
    (if (macro-cpxnum-real? x)
        (##make-rectangular (##abs (macro-cpxnum-real x))
                            (##abs (macro-cpxnum-imag x)))
        (type-error))))

(define-prim (abs x)
  (macro-force-vars (x)
    (##abs x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; division operators

(define-prim (##division x y operation)

  ;; The last two bits of operation determine which of
  ;; quotient and remainder (of whatever flavor) you
  ;; *don't* want:
  ;; 00: return both quotient and remainder
  ;; 10: return remainder
  ;; 01: return quotient
  ;; 11: not used

  ;; The upper bits determine which division operation we want:
  ;; 0: truncate
  ;; 1: floor
  ;; 2: ceiling
  ;; 3: round
  ;; 4: euclidean
  ;; 5: balanced

  ;; Then there are the classical three procedures, which operate
  ;; identically to some of the new ones but with different names:

  ;; (+ (* 6 4) 1) = 25: quotient, same as truncate-quotient
  ;; (+ (* 6 4) 2) = 26: remainder, same as truncate-remainder
  ;; (+ (* 7 4) 2) = 30: modulo, same as floor-remainder

  (define-macro (return-quotient?)
    `(fxzero? (fxand operation 2)))

  (define-macro (return-remainder?)
    `(fxzero? (fxand operation 1)))

  (define-macro (define-proc)

    (define (suffix operation)
      (case (fxand operation 3)
        ((0) "/")
        ((1) "-quotient")
        (else ;; (2)
         "-remainder")))

    (define (prefix operation)
      (case (fxarithmetic-shift-right operation 2)
        ((0) "truncate")
        ((1) "floor")
        ((2) "ceiling")
        ((3) "round")
        ((4) "euclidean")
        (else ;; (5)
         "balanced")))

    (define (make-name operation)
      (string->symbol (string-append (prefix operation)
                                     (suffix operation))))

    (let ((result
           `(define (proc)
              (case operation
                ,@(apply append (map (lambda (main-operation)
                                       (map (lambda (sub-operation)
                                              (let ((operation (+ (* 4 main-operation) sub-operation)))
                                                `((,operation)
                                                  ,(make-name operation))))
                                            (iota 3)))
                                     (iota 6)))
                ,@'(((25) quotient)
                    ((26) remainder)
                    ((30) modulo))))))
      result))

  (define-proc)

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception (proc) x))

  (define (return quo rem)
    (case (fxand operation 3)
      ((0) (values quo rem))
      ((1) quo)
      (else ;; (2)
       rem)))

  (define (inexactify quo rem require-inexact?)
    ;; quo and rem are each either #f or an exact integer
    (return (if (and require-inexact? quo) (exact->inexact quo) quo)
            (if (and require-inexact? rem) (exact->inexact rem) rem)))

  (define (type-error-on-x)
    (##fail-check-integer 1 (proc) x y))

  (define (type-error-on-y)
    (##fail-check-integer 2 (proc) x y))

  (define (divide-by-zero-error)
    (##raise-divide-by-zero-exception (proc) x y))

  (define (fixnum-fixnum-case x y require-inexact?)
    (if (and (fx= y -1)           ;; neither is likely, check cheaper one first
             (fx= x ##min-fixnum))
        (inexactify (and (fxzero? (fxand operation 2)) ;; return bignum quo only if necessary
                         (macro-if-bignum
                          ##bignum.-min-fixnum
                          (fixnum-overflow)))
                    0
                    require-inexact?)
        (let ((quo (fxquotient x y))
              (rem (fxremainder x y)))
          (if (fxzero? rem)
              (inexactify quo rem require-inexact?)
              ;; neither y nor rem is zero
              (let ((op (fxarithmetic-shift-right operation 2)))
                (case op
                  ((0 6) ;; truncate, quotient, and remainder
                   (inexactify quo rem require-inexact?))
                  ((1 7) ;; floor modulo
                   (if (eq? (fxpositive? y) (fxpositive? rem))
                       (inexactify quo rem require-inexact?)
                       (inexactify (fx- quo 1) (fx+ rem y) require-inexact?)))
                  ((2) ;; ceiling
                   (if (eq? (fxpositive? y) (fxnegative? rem))
                       (inexactify quo rem require-inexact?)
                       (inexactify (fx+ quo 1) (fx- rem y) require-inexact?)))
                  ((3) ;; round
                   (let ((abs-y/2 (fxabs (if (fxpositive? y)
                                             (fxarithmetic-shift-right y 1)
                                             (fxarithmetic-shift-right (fx+ y 1) 1)))))
                     (cond ((and (fxeven? y)
                                 (fxodd? quo)
                                 (fx= (fxabs rem) abs-y/2))
                            ;; we need to fix this very special case of round
                            (if (eq? (fxpositive? rem) (fxpositive? y))
                                (inexactify (fx+ quo 1) (fx- rem y) require-inexact?)
                                (inexactify (fx- quo 1) (fx+ rem y) require-inexact?)))
                           ((fx< abs-y/2 rem)
                            (if (fxnegative? y)               ;; avoid (abs ##min-fixnum)
                                (inexactify (fx- quo 1) (fx+ rem y) require-inexact?)
                                (inexactify (fx+ quo 1) (fx- rem y) require-inexact?)))
                           ((fx< rem (fx- abs-y/2))
                            (if (fxnegative? y)               ;; avoid (abs ##min-fixnum)
                                (inexactify (fx+ quo 1) (fx- rem y) require-inexact?)
                                (inexactify (fx- quo 1) (fx+ rem y) require-inexact?)))
                           (else
                            (inexactify quo rem require-inexact?)))))
                  ((4) ;; euclidean
                   (if (fxnegative? rem)
                       (if (fxnegative? y)                    ;; avoid (abs ##min-fixnum)
                           (inexactify (fx+ quo 1) (fx- rem y) require-inexact?)
                           (inexactify (fx- quo 1) (fx+ rem y) require-inexact?))
                       (inexactify quo rem require-inexact?)))
                  (else ;; balanced
                   (let ((abs-y/2 (fxabs (fxarithmetic-shift-right y 1))))
                     (cond ((fx<= abs-y/2 rem)
                            (if (fxnegative? y)               ;; avoid (abs ##min-fixnum)
                                (inexactify (fx- quo 1) (fx+ rem y) require-inexact?)
                                (inexactify (fx+ quo 1) (fx- rem y) require-inexact?)))
                           ((fx< rem (fx- abs-y/2))
                            (if (fxnegative? y)               ;; avoid (abs ##min-fixnum)
                                (inexactify (fx+ quo 1) (fx- rem y) require-inexact?)
                                (inexactify (fx- quo 1) (fx+ rem y) require-inexact?)))
                           (else
                            (inexactify quo rem require-inexact?)))))))))))

  (define (general-case x y require-inexact?)

    (declare (mostly-fixnum))

    (define-macro (inc-quotient x)
      ;; possibly increment x
      `(and (return-quotient?) (+ ,x 1)))

    (define-macro (dec-quotient x)
      ;; possibly decrement x
      `(and (return-quotient?) (- ,x 1)))

    (define-macro (inc-remainder x y)
      ;; possibly increment x
      `(and (return-remainder?) (+ ,x ,y)))

    (define-macro (dec-remainder x y)
      ;; possibly decrement x
      `(and (return-remainder?) (- ,x ,y)))

    (let* ((q+r (##exact-int.div x y
                                 (or (fxzero? (fxand operation 2))
                                     ;; In round, the remainder you return depends on the quotient
                                     (fx= (fxarithmetic-shift-right operation 2) 3))
                                 #t))
           (quo (macro-qr-q q+r))
           (rem (macro-qr-r q+r)))
      (if (eqv? rem 0)
          (inexactify quo rem require-inexact?)
          ;; neither y nor rem is zero
          (let ((op (fxarithmetic-shift-right operation 2)))
            (case op
              ((0 6) ;; truncate, quotient, remainder
               (inexactify quo rem require-inexact?))
              ((1 7) ;; floor, modulo
               (if (eq? (positive? y) (positive? rem))
                   (inexactify quo rem require-inexact?)
                   (inexactify (dec-quotient quo) (inc-remainder rem y) require-inexact?)))
              ((2) ;; ceiling
               (if (eq? (positive? y) (negative? rem))
                   (inexactify quo rem require-inexact?)
                   (inexactify (inc-quotient quo) (dec-remainder rem y) require-inexact?)))
              ((3) ;; round
               (let ((abs-y/2 (abs (if (positive? y)
                                       (arithmetic-shift y -1)
                                       (arithmetic-shift (+ y 1) -1)))))
                 (cond ((and (even? y)
                             (odd? quo)
                             (= (abs rem) abs-y/2))
                        ;; we need to fix this very special case of round
                        (if (eq? (positive? rem) (positive? y))
                            (inexactify (inc-quotient quo) (dec-remainder rem y) require-inexact?)
                            (inexactify (dec-quotient quo) (inc-remainder rem y) require-inexact?)))
                       ((< abs-y/2 rem)
                        (if (negative? y)
                            (inexactify (dec-quotient quo) (inc-remainder rem y) require-inexact?)
                            (inexactify (inc-quotient quo) (dec-remainder rem y) require-inexact?)))
                       ((< rem (- abs-y/2))
                        (if (negative? y)
                            (inexactify (inc-quotient quo) (dec-remainder rem y) require-inexact?)
                            (inexactify (dec-quotient quo) (inc-remainder rem y) require-inexact?)))
                       (else
                        (inexactify quo rem require-inexact?)))))
              ((4) ;; euclidean
               (if (negative? rem)
                   (if (negative? y)
                       (inexactify (inc-quotient quo) (dec-remainder rem y) require-inexact?)
                       (inexactify (dec-quotient quo) (inc-remainder rem y) require-inexact?))
                   (inexactify quo rem require-inexact?)))
              (else ;; balanced
               (let ((abs-y/2 (abs (arithmetic-shift y -1))))
                 (cond ((<= abs-y/2 rem)
                        (if (negative? y)
                            (inexactify (dec-quotient quo) (inc-remainder rem y) require-inexact?)
                            (inexactify (inc-quotient quo) (dec-remainder rem y) require-inexact?)))
                       ((< rem (- abs-y/2))
                        (if (negative? y)
                            (inexactify (inc-quotient quo) (dec-remainder rem y) require-inexact?)
                            (inexactify (dec-quotient quo) (inc-remainder rem y) require-inexact?)))
                       (else
                        (inexactify quo rem require-inexact?))))))))))

  (define (inexact-case x y)
    (let ((exact-x (inexact->exact x))
          (exact-y (inexact->exact y)))
      (cond ((eqv? exact-y 0)
             (divide-by-zero-error))
            ((and (fixnum? exact-x)
                  (fixnum? exact-y))
             (fixnum-fixnum-case exact-x exact-y #t))
            (else
             (macro-if-bignum
              (general-case exact-x exact-y #t)
              (fixnum-overflow))))))

  (macro-number-dispatch y (type-error-on-y)

    (macro-number-dispatch x (type-error-on-x) ;; y = fixnum
      (cond ((##fx= y 0)
             (divide-by-zero-error))
            (else
             (fixnum-fixnum-case x y #f)))
      (cond ((##fx= y 0)
             (divide-by-zero-error))
            (else
             (general-case x y #f)))
      (type-error-on-x)
      (if (macro-flonum-int? x)
          (inexact-case x y)
          (type-error-on-x))
      (if (macro-cpxnum-int? x)
          (inexact-case x y)
          (type-error-on-x)))

    (macro-number-dispatch x (type-error-on-x) ;; y = bignum
      (general-case x y #f)
      (general-case x y #f)
      (type-error-on-x)
      (if (macro-flonum-int? x)
          (inexact-case x y)
          (type-error-on-x))
      (if (macro-cpxnum-int? x)
          (inexact-case x y)
          (type-error-on-x)))

    (type-error-on-y) ;; y = ratnum

    (macro-number-dispatch x (type-error-on-x) ;; y = flonum
      (if (macro-flonum-int? y)
          (if (and (macro-special-case-exact-zero?)
                   (##fxzero? x)
                   (##not (##flzero? y)))
              (return 0 0)
              (inexact-case x y))
          (type-error-on-y))
      (if (macro-flonum-int? y)
          (inexact-case x y)
          (type-error-on-y))
      (type-error-on-x)
      (if (macro-flonum-int? x)
          (if (macro-flonum-int? y)
              (inexact-case x y)
              (type-error-on-y))
          (type-error-on-x))
      (if (macro-cpxnum-int? x)
          (if (macro-flonum-int? y)
              (inexact-case x y)
              (type-error-on-y))
          (type-error-on-x)))

    (if (macro-cpxnum-int? y) ;; y = cpxnum
        (macro-number-dispatch x (type-error-on-x)
          (if (and (macro-special-case-exact-zero?)
                   (##fxzero? x)
                   (##not (##zero? y)))
              (return 0 0)
              (inexact-case x y))
          (inexact-case x y)
          (type-error-on-x)
          (if (macro-flonum-int? x)
              (inexact-case x y)
              (type-error-on-x))
          (if (macro-cpxnum-int? x)
              (inexact-case x y)
              (type-error-on-x)))
        (type-error-on-y))))

(define-macro (define-most-division-operators)

  (define (suffix operation)
    (case (fxand operation 3)
      ((0) "/")
      ((1) "-quotient")
      (else ;; (2)
       "-remainder")))

  (define (prefix operation)
    (case (fxarithmetic-shift-right operation 2)
      ((0) "truncate")
      ((1) "floor")
      ((2) "ceiling")
      ((3) "round")
      ((4) "euclidean")
      (else ;; (5)
       "balanced")))

  (define (make-name operation)
    (string->symbol (string-append (prefix operation)
                                   (suffix operation))))

  (define (make-##name operation)
    (string->symbol (string-append "##"
                                   (prefix operation)
                                   (suffix operation))))

  (let ((result
         `(begin
            ,@(apply append (map (lambda (main-operation)
                                   (apply append
                                          (map (lambda (sub-operation)
                                                 (let ((operation (+ (* 4 main-operation) sub-operation)))
                                                   `((define-prim (,(make-##name operation) x y)
                                                       (##division x y ,operation))
                                                     (define-prim (,(make-name operation) x y)
                                                       (macro-force-vars (x y)
                                                         (##division x y ,operation))))))
                                               (iota 3))))
                                (iota 6))))))
    result))

(define-most-division-operators)

;; Then there are the classical three procedures, which operate
;; identically to some of the new ones but with different names:

;; (+ (* 6 4) 1) = 25: quotient, same as truncate-quotient
;; (+ (* 6 4) 2) = 26: remainder, same as truncate-remainder
;; (+ (* 7 4) 2) = 30: modulo, same as floor-remainder

(define-macro (define-r4rs-division-operators)
  (define (hashify name)
    (string->symbol (string-append "##" (symbol->string name))))
  (let ((result
         `(begin
            ,@(apply append (map (lambda (name operation)
                                   `((define-prim (,(hashify name) x y)
                                       (##division x y ,operation))
                                     (define-prim (,name x y)
                                       (macro-force-vars (x y)
                                         (##division x y ,operation)))))
                                 '(quotient remainder modulo)
                                 '(25 26 30))))))
    result))

(define-r4rs-division-operators)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; gcd, lcm

(define-primitive (gcd2 x y)

  ;; We're going to write this assuming that every
  ;; other routine like ##abs, ##negate, ##exact->inexact,
  ;; etc, return #f if, e.g., bignums don't exist and an
  ;; operation would otherwise return a bignum.

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))
  (##define-macro (fixnum-overflow) `#f)

  (define (fast-gcd u v)

    ;; See the paper "Fast Reduction and Composition of Binary
    ;; Quadratic Forms" by Arnold Schoenhage.  His algorithm and proof
    ;; are derived from, and basically the same for, his Controlled
    ;; Euclidean Descent algorithm for gcd, which is outlined in
    ;; Section 7.2.1 of the following book:
    ;; @book {MR1290996,
    ;;     AUTHOR = {Sch\"{o}nhage, Arnold and Grotefeld, Andreas F. W. and Vetter,
    ;;               Ekkehart},
    ;;      TITLE = {Fast algorithms},
    ;;       NOTE = {A multitape Turing machine implementation},
    ;;  PUBLISHER = {Bibliographisches Institut, Mannheim},
    ;;       YEAR = {1994},
    ;;      PAGES = {x+297},
    ;;       ISBN = {3-411-16891-9},
    ;;    MRCLASS = {68Q05 (11Y16 68Q25)},
    ;;   MRNUMBER = {1290996},
    ;; MRREVIEWER = {Jeffrey O. Shallit},
    ;; }
    ;; This algorithm has complexity log N times a
    ;; constant times the complexity of a multiplication of the same
    ;; size.  We don't use it until we get to about 6800 bits.  Note
    ;; that this is the same place that we start using FFT
    ;; multiplication and fast division with Newton's method for
    ;; finding inverses.

    ;; Niels Mo"ller has written two papers about an improved version
    ;; of this algorithm that he wrote for GMP.

    ;; assumes u and v are nonnegative exact ints

    (define (make-gcd-matrix A_11 A_12
                             A_21 A_22)
      (##vector A_11 A_12
                A_21 A_22))

    (define (gcd-matrix_11 A)
      (##vector-ref A 0))

    (define (gcd-matrix_12 A)
      (##vector-ref A 1))

    (define (gcd-matrix_21 A)
      (##vector-ref A 2))

    (define (gcd-matrix_22 A)
      (##vector-ref A 3))

    (define (make-gcd-vector v_1 v_2)
      (##vector v_1 v_2))

    (define (gcd-vector_1 v)
      (##vector-ref v 0))

    (define (gcd-vector_2 v)
      (##vector-ref v 1))

    (define gcd-matrix-identity '#(1 0
                                   0 1))

    (define (gcd-matrix-multiply A B)
      (cond ((##eq? A gcd-matrix-identity)
             B)
            ((##eq? B gcd-matrix-identity)
             A)
            (else
             (let ((A_11 (gcd-matrix_11 A)) (A_12 (gcd-matrix_12 A))
                   (A_21 (gcd-matrix_21 A)) (A_22 (gcd-matrix_22 A))
                   (B_11 (gcd-matrix_11 B)) (B_12 (gcd-matrix_12 B))
                   (B_21 (gcd-matrix_21 B)) (B_22 (gcd-matrix_22 B)))
               (make-gcd-matrix (##+ (##* A_11 B_11)
                                     (##* A_12 B_21))
                                (##+ (##* A_11 B_12)
                                     (##* A_12 B_22))
                                (##+ (##* A_21 B_11)
                                     (##* A_22 B_21))
                                (##+ (##* A_21 B_12)
                                     (##* A_22 B_22)))))))

    (define (gcd-matrix-multiply-strassen A B)
      ;; from http://mathworld.wolfram.com/StrassenFormulas.html
      (cond ((##eq? A gcd-matrix-identity)
             B)
            ((##eq? B gcd-matrix-identity)
             A)
            (else
             (let ((A_11 (gcd-matrix_11 A)) (A_12 (gcd-matrix_12 A))
                   (A_21 (gcd-matrix_21 A)) (A_22 (gcd-matrix_22 A))
                   (B_11 (gcd-matrix_11 B)) (B_12 (gcd-matrix_12 B))
                   (B_21 (gcd-matrix_21 B)) (B_22 (gcd-matrix_22 B)))
               (let ((Q_1 (##* (##+ A_11 A_22) (##+ B_11 B_22)))
                     (Q_2 (##* (##+ A_21 A_22) B_11))
                     (Q_3 (##* A_11 (##- B_12 B_22)))
                     (Q_4 (##* A_22 (##- B_21 B_11)))
                     (Q_5 (##* (##+ A_11 A_12) B_22))
                     (Q_6 (##* (##- A_21 A_11) (##+ B_11 B_12)))
                     (Q_7 (##* (##- A_12 A_22) (##+ B_21 B_22))))
                 (make-gcd-matrix (##+ (##+ Q_1 Q_4) (##- Q_7 Q_5))
                                  (##+ Q_3 Q_5)
                                  (##+ Q_2 Q_4)
                                  (##+ (##+ Q_1 Q_3) (##- Q_6 Q_2))))))))

    (define (gcd-matrix-solve A y)
      (let ((y_1 (gcd-vector_1 y))
            (y_2 (gcd-vector_2 y)))
        (make-gcd-vector (##- (##* y_1 (gcd-matrix_22 A))
                              (##* y_2 (gcd-matrix_12 A)))
                         (##- (##* y_2 (gcd-matrix_11 A))
                              (##* y_1 (gcd-matrix_21 A))))))

    (define (x>=2^n x n)
      (##fx< n (##integer-length x)))

    (define (determined-minimal? u v s)
      ;; assumes  2^s <= u , v; s>= 0 fixnum
      ;; returns #t if we can determine that |u-v|<2^s
      ;; at least one of u and v is a bignum
      (let ((u (if (##fixnum? u) (##fixnum->bignum u) u))
            (v (if (##fixnum? v) (##fixnum->bignum v) v)))
        (let ((u-length (##bignum.mdigit-length u)))
          (and (##fx= u-length (##bignum.mdigit-length v))
               (let loop ((i (##fx- u-length 1)))
                 (let ((v-digit (##bignum.mdigit-ref v i))
                       (u-digit (##bignum.mdigit-ref u i)))
                   (if (and (##fxzero? u-digit)
                            (##fxzero? v-digit))
                       (loop (##fx- i 1))
                       (and (##fx= (##bignum.mdigit-div s)
                                   i)
                            (##fx< (##fxmax (##fx- u-digit v-digit)
                                            (##fx- v-digit u-digit))
                                   (##fxarithmetic-shift-left
                                    1
                                    (##bignum.mdigit-mod s)))))))))))

    (define (gcd-small-step cont M u v s)
      ;;  u, v >= 2^s
      ;; M is the matrix product of the partial sums of
      ;; the continued fraction representation of a/b so far
      ;; returns updated M, u, v, and a truth value
      ;;  u, v >= 2^s and
      ;; if last return value is #t, we know that
      ;; (- (max u v) (min u v)) < 2^s, i.e, u, v are minimal above 2^s

      (define (gcd-matrix-multiply-low M q)
        (let ((M_11 (gcd-matrix_11 M))
              (M_12 (gcd-matrix_12 M))
              (M_21 (gcd-matrix_21 M))
              (M_22 (gcd-matrix_22 M)))
          (make-gcd-matrix (##+ M_11 (##* q M_12))  M_12
                           (##+ M_21 (##* q M_22))  M_22)))

      (define (gcd-matrix-multiply-high M q)
        (let ((M_11 (gcd-matrix_11 M))
              (M_12 (gcd-matrix_12 M))
              (M_21 (gcd-matrix_21 M))
              (M_22 (gcd-matrix_22 M)))
          (make-gcd-matrix M_11  (##+ (##* q M_11) M_12)
                           M_21  (##+ (##* q M_21) M_22))))

      (if (or (##bignum? u)
              (##bignum? v))

          ;; if u and v are nearly equal bignums, the two ##<
          ;; following this condition could take O(N) time to compute.
          ;; When this happens, however, it will be likely that
          ;; determined-minimal? will return true.

          (cond ((determined-minimal? u v s)
                 (cont M
                       u
                       v
                       #t))
                ((##< u v)
                 (let* ((qr (##exact-int.div v u))
                        (q (macro-qr-q qr))
                        (r (macro-qr-r qr)))
                   (cond ((x>=2^n r s)
                          (cont (gcd-matrix-multiply-low M q)
                                u
                                r
                                #f))
                         ((##eqv? q 1)
                          (cont M
                                u
                                v
                                #t))
                         (else
                          (cont (gcd-matrix-multiply-low M (##- q 1))
                                u
                                (##+ r u)
                                #t)))))
                ((##< v u)
                 (let* ((qr (##exact-int.div u v))
                        (q (macro-qr-q qr))
                        (r (macro-qr-r qr)))
                   (cond ((x>=2^n r s)
                          (cont (gcd-matrix-multiply-high M q)
                                r
                                v
                                #f))
                         ((##eqv? q 1)
                          (cont M
                                u
                                v
                                #t))
                         (else
                          (cont (gcd-matrix-multiply-high M (##- q 1))
                                (##+ r v)
                                v
                                #t)))))
                (else
                 (cont M
                       u
                       v
                       #t)))
          ;; here u and v are fixnums, so 2^s, which is <= u and v, is
          ;; also a fixnum
          (let ((two^s (##fxarithmetic-shift-left 1 s)))
            (if (##fx< u v)
                (if (##fx< (##fx- v u) two^s)
                    (cont M
                          u
                          v
                          #t)
                    (let ((r (##fxremainder v u))
                          (q (##fxquotient  v u)))
                      (if (##fx>= r two^s)
                          (cont (gcd-matrix-multiply-low M q)
                                u
                                r
                                #f)
                          ;; the case when q is one and the remainder is < two^s
                          ;; is covered in the first test
                          (cont (gcd-matrix-multiply-low M (##fx- q 1))
                                u
                                (##fx+ r u)
                                #t))))
                ;; here u >= v, but the case u = v is covered by the first test
                (if (##fx< (##fx- u v) two^s)
                    (cont M
                          u
                          v
                          #t)
                    (let ((r (##fxremainder u v))
                          (q (##fxquotient  u v)))
                      (if (##fx>= r two^s)
                          (cont (gcd-matrix-multiply-high M q)
                                r
                                v
                                #f)
                          ;; the case when q is one and the remainder is < two^s
                          ;; is covered in the first test
                          (cont (gcd-matrix-multiply-high M (##fx- q 1))
                                (##fx+ r v)
                                v
                                #t))))))))

    (define (gcd-middle-step cont a b h m-prime cont-needs-M?)
      ((lambda (cont)
         (if (and (x>=2^n a h)
                  (x>=2^n b h))
             (MR cont a b h cont-needs-M?)
             (cont gcd-matrix-identity a b)))
       (lambda (M x y)
         (let loop ((M M)
                    (x x)
                    (y y))
           (if (or (x>=2^n x h)
                   (x>=2^n y h))
               ((lambda (cont) (gcd-small-step cont M x y m-prime))
                (lambda (M x y minimal?)
                  (if minimal?
                      (cont M x y)
                      (loop M x y))))
               ((lambda (cont) (MR cont x y m-prime cont-needs-M?))
                (lambda (M-prime alpha beta)
                  (cont (if cont-needs-M?
                            (if (##fx> (##fx- h m-prime) 1024)
                                ;; here we trade off 1 multiplication
                                ;; for 21 additions
                                (gcd-matrix-multiply-strassen M M-prime)
                                (gcd-matrix-multiply          M M-prime))
                            gcd-matrix-identity)
                        alpha
                        beta))))))))

    (define (MR cont a b m cont-needs-M?)
      ((lambda (cont)
         (if (and (x>=2^n a (##fx+ m 2))
                  (x>=2^n b (##fx+ m 2)))
             (let ((n (##fx- (##fxmax (##integer-length a)
                                      (##integer-length b))
                             m)))
               ((lambda (cont)
                  (if (##fx<= m n)
                      (cont m 0)
                      (cont n (##fx- (##fx+ m 1) n))))
                (lambda (m-prime p)
                  (let ((h (##fx+ m-prime (##fxquotient n 2))))
                    (if (##fx< 0 p)
                        (let ((a   (##arithmetic-shift a (##fx- p)))
                              (b   (##arithmetic-shift b (##fx- p)))
                              (a_0 (##extract-bit-field p 0 a))
                              (b_0 (##extract-bit-field p 0 b)))
                          ((lambda (cont)
                             (gcd-middle-step cont a b h m-prime #t))
                           (lambda (M alpha beta)
                             (let ((M-inverse-v_0 (gcd-matrix-solve M (make-gcd-vector a_0 b_0))))
                               (cont (if cont-needs-M? M gcd-matrix-identity)
                                     (##+ (##arithmetic-shift alpha p)
                                          (gcd-vector_1 M-inverse-v_0))
                                     (##+ (##arithmetic-shift beta p)
                                          (gcd-vector_2 M-inverse-v_0)))))))
                        (gcd-middle-step cont a b h m-prime cont-needs-M?))))))
             (cont gcd-matrix-identity
                   a
                   b)))
       (lambda (M alpha beta)
         (let loop ((M M)
                    (alpha alpha)
                    (beta beta)
                    (minimal? #f))
           (if minimal?
               (cont M alpha beta)
               (gcd-small-step loop M alpha beta m))))))

    ;; Beginning of body of fast-gcd; requires a and b to be
    ;; overwriteable (i.e., newly allocated).

    ((lambda (cont)
       (if (and (use-fast-bignum-algorithms)
                (x>=2^n u ##bignum.fast-gcd-size)
                (x>=2^n v ##bignum.fast-gcd-size))
           (MR cont u v ##bignum.fast-gcd-size #f)
           (cont 0 u v)))
     (lambda (M a b)
       (general-base a b))))

  (define (general-base a b)
    (if (##eqv? b 0)
        a
        (let ((r (macro-qr-r (##exact-int.div a  ;; calculate (remainder a b)
                                              b
                                              #f ;; need-quotient?
                                              #f ;; keep-dividend?
                                              ))))
          (if (##fixnum? b)
              (fixnum-base b r)
              (general-base b r)))))

  (define (fixnum-base a b)

    ;; Note that (remainder a b) has the same
    ;; sign as a with absolute value < |b|, so we allow
    ;; these fixnums to be negative, which allows
    ;; us to handle ##min-fixnum gracefully when there
    ;; are no bignums unless the result itself is ##min-fixnum.

    (##declare (not interrupts-enabled))
    (if (##eqv? b 0)
        (##abs a)
        (let ((a b)
              (b (##fxremainder a b)))
          (if (##eqv? b 0)
              (##abs a)
              (fixnum-base b (##fxremainder a b))))))

  (define (bignums-case x new-x? y new-y?)
    (let* ((x-negative?     (##bignum.negative? x))
           (y-negative?     (##bignum.negative? y))
           (x-first-bit     (##first-set-bit x))
           (y-first-bit     (##first-set-bit y))
           (x-length        (##integer-length x))
           (y-length        (##integer-length y))

           ;; We need to decide whether to shift out lower zero bits.
           ;; There are two algorithms for GCD, a naive one that's
           ;; O(N^2), and a "fast" one that's O(N (\log N)^2). A shift
           ;; takes O(N) time.  N is the size of the arguments in bits.

           ;; To do our very naive analysis, we'll assume that all
           ;; constants are 1, so the algorithms take N^2, N(\log N)^2,
           ;; and N time, respectively, and logarithms are base 2.

           ;; If the arguments are small enough that we use the naive
           ;; algorithm, then shifting out K low-order zero bits
           ;; reduces the run time to
           ;; (N-K)^2 = N^2 - 2NK + K^2,
           ;; which always pays for the cost of the shift.

           ;; If both arguments are large, then shifting out K
           ;; low-order zero bits results in a runtime of
           ;; (N-K) (\log (N-K))^2 \approx N (\log N)^2 - K (\log N)^2
           ;; so for the reduction to be greater than N, the shift cost,
           ;; N < K(\log N)^2 or K > N/(log N)^2.

           (use-fast-gcd-algorithm?
            (and (use-fast-bignum-algorithms)
                 (##fx>= (##fx- x-length x-first-bit)
                         ##bignum.fast-gcd-size)
                 (##fx>= (##fx- y-length y-first-bit)
                         ##bignum.fast-gcd-size)))
           (N
            (##fxmin x-length y-length))
           (shift-zero-bits?
            (if use-fast-gcd-algorithm?
                (##fx> (##fxmax x-first-bit y-first-bit)
                       (##fxquotient N (##fxsquare (##fxlength N))))
                (##fxpositive? (##fxmax x-first-bit y-first-bit))))

           ;; We'll rename x and y for simplicity.  Both are nonzero.

           (x
            (##abs (if shift-zero-bits?
                       (##arithmetic-shift x (##fx- x-first-bit))
                       x)))
           (y
            (##abs (if shift-zero-bits?
                       (##arithmetic-shift y (##fx- y-first-bit))
                       y))))

      (##arithmetic-shift
       (macro-exact-int-dispatch y #f

         (macro-exact-int-dispatch x #f                ;; y = fixnum
           (fixnum-base x y)
           (fixnum-base y (##remainder x y)))

         (macro-exact-int-dispatch x #f                ;; y = bignum
           (fixnum-base x (##remainder y x))

           ;; fast-gcd requires that its bignum arguments
           ;; are newly allocated.

           (fast-gcd
            (if (or new-x?
                    x-negative?
                    (and shift-zero-bits?
                         (##fxpositive? x-first-bit)))
                x
                (##bignum.copy x))
            (if (or new-y?
                    y-negative?
                    (and shift-zero-bits?
                         (##fxpositive? y-first-bit)))
                y
                (##bignum.copy y)))))
       (if shift-zero-bits?
           (##fxmin x-first-bit y-first-bit)
           0))))

  ;; Beginning of body of top-level routine.

  (macro-number-dispatch y (type-error-on-y)

    (macro-number-dispatch x (type-error-on-x)        ;; y = fixnum
      (fixnum-base x y)
      (cond ((##eqv? y 0)
             (##abs x))
            ((or (##eqv? y 1)
                 (##eqv? y -1))
             1)
            (else
             (fixnum-base y (##remainder x y))))
      (type-error-on-x)
      (if (##flinteger? x)
          (cond ((##eqv? y 0)
                 (##flabs x))
                ((or (##eqv? y 1)
                     (##eqv? y -1))
                 (macro-inexact-+1))
                (else
                 (let ((exact-x (##inexact->exact x)))
                   (and exact-x
                        (##exact->inexact
                         (fixnum-base y (##remainder exact-x y)))))))
          (type-error-on-x))
      (type-error-on-x))

    (macro-number-dispatch x (type-error-on-x)       ;; y = bignum
      (cond ((##eqv? x 0)
             (##abs y))
            ((or (##eqv? x 1)
                 (##eqv? x -1))
             1)
            (else
             (fixnum-base x (##remainder y x))))
      (if (##= x y)
          (##abs x)
          (bignums-case x  #f y #f))
      (type-error-on-x)
      (if (##flinteger? x)
          (cond ((##flzero? x)
                 (##flabs (##exact->inexact y)))
                ((##fl= (##flabs x) (macro-inexact-+1))
                 (macro-inexact-+1))
                (else
                 ;; bignums exist, so exact-x is not #f
                 (let ((exact-x (##inexact->exact x)))
                   (##exact->inexact
                    (if (##fixnum? exact-x)
                        (fixnum-base exact-x (##remainder y exact-x))
                        (bignums-case exact-x #t y #f))))))
          (type-error-on-x))
      (type-error-on-x))

    (type-error-on-y)                                ;; y = ratnum

    (if (##flinteger? y)                             ;; y = flonum
          (macro-number-dispatch x (type-error-on-x)
            (cond ((##eqv? x 0)                ;; x = fixnum
                   (##flabs y))
                  ((or (##eqv? x 1)
                       (##eqv? x -1))
                   (macro-inexact-+1))
                  (else
                   (let ((exact-y (##inexact->exact y)))
                     (and exact-y
                          (##exact->inexact
                           (fixnum-base x (##remainder exact-y x)))))))
            ;; In the following, bignums exist,
            ;; so exact-y is not #f
            (cond ((##flzero? y)               ;; x = bignum
                   (##flabs (##exact->inexact x)))
                  ((##fl= (##flabs y) (macro-inexact-+1))
                   (macro-inexact-+1))
                  (else
                   (##exact->inexact
                    (let ((exact-y (##inexact->exact y)))
                      (if (##fixnum? exact-y)
                          (fixnum-base exact-y (##remainder x exact-y))
                          (bignums-case x #f exact-y #t))))))
            (type-error-on-x)                  ;; x = ratnum
            (if (##flinteger? x)               ;; x = flonum
                (cond ((##fl= (##flabs x) (##flabs y))
                       (##flabs x))
                      ((##flzero? x)
                       (##flabs y))
                      ((##flzero? y)
                       (##flabs x))
                      ((or (##fl= (##flabs x) (macro-inexact-+1))
                           (##fl= (##flabs y) (macro-inexact-+1)))
                       (macro-inexact-+1))
                      (else
                       (let ((exact-x (##inexact->exact x))
                             (exact-y (##inexact->exact y)))
                         (and exact-x
                              exact-y
                              (##exact->inexact
                               (macro-exact-int-dispatch exact-x #f
                                 (macro-exact-int-dispatch exact-y #f        ;; exact-x = fixnum
                                   (fixnum-base exact-x exact-y)
                                   (fixnum-base exact-x (##remainder exact-y exact-x)))
                                 (macro-exact-int-dispatch exact-y #f        ;; exact-x = bignum
                                   (fixnum-base exact-y (##remainder exact-x exact-y))
                                   (bignums-case exact-x #t exact-y #t))))))))
                (type-error-on-x))
            (type-error-on-x)))                ;; x = cpxnum

    (type-error-on-y)))                              ;; y = cpxnum

(define-prim-nary (##gcd x y)
  0
  (##abs x)
  (##gcd2 x y)
  macro-force-vars
  macro-no-check)

(define-prim-nary (gcd x y)
  0
  (if (##integer? x) (##abs x) '(1))
  (##gcd2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-integer))

(define-prim (##lcm2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (define (exact-lcm x y)
    (if (or (##eqv? x 0) (##eqv? y 0))
        0
        (##abs (##* (##quotient x (##gcd x y))
                    y))))

  (define (inexact-lcm x y)
    (##exact->inexact
     (exact-lcm (##inexact->exact x)
                (##inexact->exact y))))

  (cond ((##not (##integer? x))
         (type-error-on-x))
        ((##not (##integer? y))
         (type-error-on-y))
        (else
         (if (and (##exact? x) (##exact? y))
             (exact-lcm x y)
             (inexact-lcm x y)))))

(define-prim-nary (##lcm x y)
  1
  (##abs x)
  (##lcm2 x y)
  macro-force-vars
  macro-no-check)

(define-prim-nary (lcm x y)
  1
  (if (##integer? x) (##abs x) '(1))
  (##lcm2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-integer))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; numerator, denominator

(define-prim (##numerator x)

  (define (type-error)
    (##fail-check-rational 1 numerator x))

  (macro-number-dispatch x (type-error)
    x
    x
    (macro-ratnum-numerator x)
    (cond ((##flzero? x)
           x)
          ((macro-flonum-rational? x)
           (##exact->inexact (##numerator (##flonum->exact x))))
          (else
           (type-error)))
    (if (macro-cpxnum-rational? x)
        (##numerator (macro-cpxnum-real x))
        (type-error))))

(define-prim (numerator x)
  (macro-force-vars (x)
    (##numerator x)))

(define-prim (##denominator x)

  (define (type-error)
    (##fail-check-rational 1 denominator x))

  (macro-number-dispatch x (type-error)
    1
    1
    (macro-ratnum-denominator x)
    (if (macro-flonum-rational? x)
        (##exact->inexact (##denominator (##flonum->exact x)))
        (type-error))
    (if (macro-cpxnum-rational? x)
        (##denominator (macro-cpxnum-real x))
        (type-error))))

(define-prim (denominator x)
  (macro-force-vars (x)
    (##denominator x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; floor, ceiling, truncate, round

(define-prim (##floor x)

  (define (type-error)
    (##fail-check-finite-real 1 floor x))

  (macro-number-dispatch x (type-error)
    x
    x
    (let ((num (macro-ratnum-numerator x))
          (den (macro-ratnum-denominator x)))
      (if (##negative? num)
          (##quotient (##- num (##- den 1)) den)
          (##quotient num den)))
    (if (##flfinite? x)
        (##flfloor x)
        (type-error))
    (if (macro-cpxnum-real? x)
        (##floor (macro-cpxnum-real x))
        (type-error))))

(define-prim (floor x)
  (macro-force-vars (x)
    (##floor x)))

(define-prim (##ceiling x)

  (define (type-error)
    (##fail-check-finite-real 1 ceiling x))

  (macro-number-dispatch x (type-error)
    x
    x
    (let ((num (macro-ratnum-numerator x))
          (den (macro-ratnum-denominator x)))
      (if (##negative? num)
          (##quotient num den)
          (##quotient (##+ num (##- den 1)) den)))
    (if (##flfinite? x)
        (##flceiling x)
        (type-error))
    (if (macro-cpxnum-real? x)
        (##ceiling (macro-cpxnum-real x))
        (type-error))))

(define-prim (ceiling x)
  (macro-force-vars (x)
    (##ceiling x)))

(define-prim (##truncate x)

  (define (type-error)
    (##fail-check-finite-real 1 truncate x))

  (macro-number-dispatch x (type-error)
    x
    x
    (##quotient (macro-ratnum-numerator x)
                (macro-ratnum-denominator x))
    (if (##flfinite? x)
        (##fltruncate x)
        (type-error))
    (if (macro-cpxnum-real? x)
        (##truncate (macro-cpxnum-real x))
        (type-error))))

(define-prim (truncate x)
  (macro-force-vars (x)
    (##truncate x)))

(define-prim (##round x)

  (define (type-error)
    (##fail-check-finite-real 1 round x))

  (macro-number-dispatch x (type-error)
    x
    x
    (##ratnum.round x)
    (if (##flfinite? x)
        (##flround x)
        (type-error))
    (if (macro-cpxnum-real? x)
        (##round (macro-cpxnum-real x))
        (type-error))))

(define-prim (round x)
  (macro-force-vars (x)
    (##round x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; rationalize

(define-prim (##rationalize x y)

  (define (simplest-rational1 x y)
    (if (##< y x)
        (simplest-rational2 y x)
        (simplest-rational2 x y)))

  (define (simplest-rational2 x y)
    (cond ((##not (##< x y))
           x)
          ((##positive? x)
           (simplest-rational3 x y))
          ((##negative? y)
           (##negate (simplest-rational3 (##negate y) (##negate x))))
          (else
           0)))

  (define (simplest-rational3 x y)
    (let ((fx (##floor x))
          (fy (##floor y)))
      (cond ((##not (##< fx x))
             fx)
            ((##= fx fy)
             (##+ fx
                  (##inverse
                   (simplest-rational3
                    (##inverse (##- y fy))
                    (##inverse (##- x fx))))))
            (else
             (##+ fx 1)))))

  (cond ((##not (##rational? x))
         (##fail-check-finite-real 1 rationalize x y))
        ((and (##flonum? y)
              (##fl= y (macro-inexact-+inf)))
         (macro-inexact-+0))
        ((##not (##rational? y))
         (##fail-check-real 2 rationalize x y))
        ((##negative? y)
         (##raise-range-exception 2 rationalize x y))
        ((and (##exact? x) (##exact? y))
         (simplest-rational1 (##- x y) (##+ x y)))
        (else
         (let ((exact-x (##inexact->exact x))
               (exact-y (##inexact->exact y)))
           (##exact->inexact
            (simplest-rational1 (##- exact-x exact-y)
                                (##+ exact-x exact-y)))))))

(define-prim (rationalize x y)
  (macro-force-vars (x y)
    (##rationalize x y)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; trigonometry and complex numbers

#|

The next functions are from

 Functions from
 Branch Cuts for Complex Elementary Functions
 or
 Much Ado About Nothing's Sign Bit
 by W. Kahan

Full reference:

Kahan, W: Branch cuts for complex elementary functions;
or, Much ado about nothing's sign bit. In Iserles, A., and Powell, M. (eds.),
The state of the art in numerical analysis. Clarendon Press (1987) pp 165-211.

Note that Kahan's paper contains two treatments of branch cuts---Section 4,
which deals with arithmetic with signed zeros (like IEEE arithmetic) and
Section 5, which deals with arithmetic with only unsigned zeros.
The codes in the paper are only for IEEE-style arithmetic.

Gambit Scheme is in a funny position, as it allows mixed-exactness
complex numbers.  We'll consider inexact real zeros (+0., -0.)
as signed (of course), but we'll interpret exact zero (0) as unsigned.

The branch cuts of all the functions considered here lie on the exact
real axis or the exact imaginary axis.

All of the inverse functions are defined in terms of log and sqrt, and
the side of the continuity at the branch cuts is determined by the sides
of continuity of those two functions.

I believe that this is the same as the continuity rules that the CLHS
gives for atan, asin, acos, etc., along branch cuts.

Thanks to Raymond Toy for email discussions and for the code for cmucl,
which gets this stuff right in the Common Lisp context.

See

http://140.177.205.23/InverseHyperbolicFunctions.html

for a discussion of branch cuts.

|#

(macro-if-cpxnum (begin

(define-prim (##carg z)
  (##angle z))

(define-prim (##csquare xi+ieta)
  (let ((xi  (macro-cpxnum-real xi+ieta))
        (eta (macro-cpxnum-imag xi+ieta)))
    (let ((x (##fl* (##fl- xi eta) (##fl+ xi eta)))
          (y (##fl* (macro-inexact-+2) xi eta)))
      (cond ((##flnan? x)
             (cond ((##flinfinite? y)
                    (macro-cpxnum-make (##flcopysign (macro-inexact-+0) xi) y))
                   ((##flinfinite? eta)
                    (macro-cpxnum-make (macro-inexact--inf) y))
                   ((##flinfinite? xi)
                    (macro-cpxnum-make (macro-inexact-+inf) y))
                   (else
                    (macro-cpxnum-make x y))))
            ((and (##flnan? y)
                  (##flinfinite? x))
             (macro-cpxnum-make x (##flcopysign (macro-inexact-+0) y)))
            (else
             (macro-cpxnum-make x y))))))

(define-prim (##cssqs x+iy)
  (let ((x (macro-cpxnum-real x+iy))
        (y (macro-cpxnum-imag x+iy)))
    (cond ((or (##flinfinite? x)
               (##flinfinite? y))
           (##cons (macro-inexact-+inf) 0))
          ((and (##flzero? x)
                (##flzero? y))
           (##cons (macro-inexact-+0) 0))
          (else
           ;; from now on, neither x nor y are infinite, and one is non-zero
           (let* ((x^2 (##flsquare x))
                  (y^2 (##flsquare y))
                  (rho (##fl+ x^2 y^2)))
             (if (or (##flinfinite? rho)     ;; false if rho is NaN
                     (and (or (##fl< x^2 (macro-inexact-lambda)) ;; underflow?
                              (##fl< y^2 (macro-inexact-lambda)))
                          (##fl< rho
                                 (##fl/
                                  (macro-inexact-lambda) ;; false if rho is NaN
                                  (macro-inexact-epsilon)))))
                 ;; rho is not NaN, so x and y are not NaN,
                 ;; and x and y are not infinite.  Whew.
                 (let ((k (##flilogb (##flmax (##flabs x) (##flabs y)))))
                   (##cons (##fl+ (##flsquare (##flscalbn x (##fx- k)))
                                  (##flsquare (##flscalbn y (##fx- k))))
                           k))
                 (##cons rho 0)))))))

(define-prim (##csqrt x+iy)
  (let* ((x (macro-cpxnum-real x+iy))
         (y (macro-cpxnum-imag x+iy))
         (rho+ik (##cssqs x+iy))
         (rho (##car rho+ik))
         (k   (##cdr rho+ik))
         (rho (if (##flnan? x)
                  rho
                  (##fl+ (##flscalbn (##flabs x) (##fx- k))
                         (##flsqrt rho))))
         (rho (if (##fxodd? k)
                  (##flscalbn (##flsqrt rho) (##fxquotient (##fx- k 1) 2))
                  (##flscalbn (##flsqrt (##fl* (macro-inexact-+2) rho)) (##fx- (##fxquotient k 2) 1))))
         (xi rho)
         (eta y))
    (if (##not (##fl= rho (macro-inexact-+0)))
        (let ((eta (if (##not (##flinfinite? (##flabs eta)))
                       (##fl/ (##fl/ eta rho) (macro-inexact-+2))
                       eta)))
          (if (##flnegative? x)
              (macro-cpxnum-make (##flabs eta) (##flcopysign rho y))
              (macro-cpxnum-make xi eta)))
        (macro-cpxnum-make xi eta))))

(define-prim (##cacos z)
  (##- (macro-inexact-+pi/2) (##casin z)))

(define-prim (##cacosh z)
  (let ((sqrt-z-1 (##sqrt (##- z 1)))
        (sqrt-z+1 (##sqrt (##+ z 1))))

    ;; if z is real and > 1, then the imaginary part of the next expression
    ;; can be inexact 0, but that's OK because this routine is not called
    ;; in this case.

    (##make-rectangular
     (##asinh (##real-part (##* (##conjugate sqrt-z-1) sqrt-z+1)))
     (##* 2 (##atan2 (##imag-part sqrt-z-1) (##real-part sqrt-z+1))))))

(define-prim (##casin z)

  ;; if (##real-part z) is exact zero, then there is a correlation of
  ;; errors in sqrt-1-z and sqrt-1+z that allows the next substitution

  (let ((x (##real-part z)))
    (if (##eqv? x 0)
        (##make-rectangular 0 (##asinh (##imag-part z)))
        (let ((sqrt-1-z (##sqrt (##- 1 z)))
              (sqrt-1+z (##sqrt (##+ 1 z))))
          (##make-rectangular (if (and (##= (##abs x) (macro-inexact-+inf))
                                       (##finite? (##imag-part z)))
                                  (##flcopysign (macro-inexact-+pi/2) x)
                                  (##atan2 x (##real-part (##* sqrt-1-z sqrt-1+z))))
                              (##asinh (##imag-part (##* (##conjugate sqrt-1-z) sqrt-1+z))))))))

(define-prim (##casinh z)
  (##* -i (##casin (##* +i z))))

(define-prim (##catanh x+iy)

  (define (x/x^2+y^2 x y)
    (let ((abs-x (flabs x))
          (abs-y (flabs y)))
      (cond ((or (= abs-x (macro-inexact-+inf))
                 (= abs-y (macro-inexact-+inf)))
             (##flcopysign (macro-inexact-+0) x))
            ((or (nan? abs-x)
                 (nan? abs-y))
             (macro-inexact-+nan))
            ((fl< abs-y abs-x)
             (fl/ (macro-inexact-+1) (fl+ x (fl* (fl/ y x) y))))
            (else
             (let ((x/y (fl/ x y)))
               (fl/ x/y (fl+ (fl* x x/y) y)))))))

  (define (##->exact-sign x)
    ;; returns an exact number with the same sign as x, returns 1 if x is exact zero
    (if (##flonum? x)
        (##inexact->exact (##flcopysign (macro-inexact-+1) x))
        (if (##negative? x) -1 1)))

  (let* ((pi/2 (##* 2 (##atan 1)))
         (theta (##fl/ (##flsqrt (macro-inexact-omega)) (macro-inexact-+4)))
         (rho (##fl/ theta))
         (beta (##->exact-sign (##real-part x+iy))) ;; beta is exact
         (x+iy (##* beta (##conjugate x+iy)))
         (x (##real-part x+iy))
         (y (##imag-part x+iy))
         (inexact-x (##exact->inexact x))
         (inexact-y (##exact->inexact y))
         (abs-y (##flabs inexact-y))
         (zeta (cond ((or (##fl< theta inexact-x)
                          (##fl< theta abs-y))
                      (macro-cpxnum-make (##exact->inexact (x/x^2+y^2 inexact-x inexact-y))
                                         (##flcopysign pi/2 inexact-y)))
                     ((##fl= inexact-x (macro-inexact-+1))
                      (macro-cpxnum-make
                       (if (fl= inexact-y (macro-inexact-+0))
                           (macro-inexact--inf)
                           (##fllog (##fl/ (##flsqrt (##flsqrt (##fl+ (macro-inexact-+4) (##flsquare abs-y))))
                                           (##flsqrt (##fl+ abs-y rho)))))
                       (##fl/ (##flcopysign (##fl+ pi/2 (##flatan (##fl/ (##fl+ abs-y rho) (macro-inexact-+2))))
                                            inexact-y)
                              (macro-inexact-+2))))
                     (else
                      (macro-cpxnum-make
                       (if (##eqv? x 0)
                           ;; if rho and abs-y were exact in the next expression (no matter their values)
                           ;; then the argument to fllog1p would be exact 0, so the result would be exact 0.
                           0
                           (##fl/ (##fllog1p (##fl/ (##fl* (macro-inexact-+4) inexact-x)   ;; was (##* 4 x) originally
                                                    (##fl+ (##flsquare (##fl- (macro-inexact-+1) inexact-x))
                                                           (##flsquare (##fl+ abs-y rho)))))
                                  (macro-inexact-+4)))
                       (##fl/ (##carg (macro-cpxnum-make (##fl- (##fl* (##fl- (macro-inexact-+1) inexact-x)
                                                                       (##fl+ (macro-inexact-+1) inexact-x))
                                                                (##flsquare (##fl+ abs-y rho)))
                                                         (##fl* (macro-inexact-+2) inexact-y)))
                              (macro-inexact-+2)))))))
    (##* beta (##conjugate zeta))))

(define-prim (##ctanh xi+ieta)
  ;; we assume that neither xi nor eta can be exact 0
  (let* ((xi  (macro-cpxnum-real xi+ieta))
         (eta (macro-cpxnum-imag xi+ieta)))
    (if (##< (##fl/ (##flasinh (macro-inexact-omega)) (macro-inexact-+4))
             (##abs xi))
        (macro-cpxnum-make
         (##flcopysign (macro-inexact-+1) (##exact->inexact xi))   ;; xi cannot be exact 0
         (##flcopysign (macro-inexact-+0) (##exact->inexact eta))) ;; eta cannot be exact 0
        (let* ((t (##tan eta))                                     ;; sin(eta)/cos(eta) can't be exact 0, so can't be exact
               (beta (##fl+ (macro-inexact-+1) (##flsquare t)))    ;; 1/cos^2(eta), can't be exact
               (s (##sinh xi))                                     ;; sinh(xi), can't be exact zero, so can't be exact
               (rho (##flsqrt (##fl+ (macro-inexact-+1)            ;; cosh(xi), can't be exact
                                     (##flsquare s)))))
          (if (##infinite? t)                                      ;; if sin(eta)/cos(eta) = infinity (how, I don't know)
              (macro-cpxnum-make (##fl/ rho s)
                                 (##fl/ t))
              (let ((one+beta*s^2 (##fl+ (macro-inexact-+1) (##fl* beta (##flsquare s)))))
                (macro-cpxnum-make (##fl/ (##fl* beta (##fl* rho s))
                                          one+beta*s^2)
                                   (##fl/ t
                                          one+beta*s^2))))))))
))

;;; End of Kahan's functions

(define-prim (##conjugate x)

  (define (type-error)
    (##fail-check-number 1 conjugate x))

  (macro-number-dispatch x (type-error)
    x x x x (macro-cpxnum-make (macro-cpxnum-real x)
                               (##negate (macro-cpxnum-imag x)))))

(define-prim (conjugate x)
  (macro-force-vars (x)
    (##conjugate x)))

(define-prim (##exp x)

  (define (type-error)
    (##fail-check-number 1 exp x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        1
        (##flexp (##fixnum->flonum x)))
    (##flexp (##exact-int->flonum x))
    (##flexp (##ratnum->flonum x))
    (##flexp x)
    (##make-polar (##exp (macro-cpxnum-real x))
                  (macro-cpxnum-imag x))))

(define-prim (exp x)
  (macro-force-vars (x)
    (##exp x)))

(define-prim (##flonum-full-precision? x)
  (let ((y (##flabs x)))
    (and (##fl< y (macro-inexact-+inf))
         (##fl<= (macro-flonum-min-normal) y))))

(define-prim (##log x #!optional (y (macro-absent-obj)))

  (define (type-error)
    (##fail-check-number 1 log x))

  (define (range-error)
    (##raise-range-exception 1 log x))

  (define (negative-log)
    (macro-if-cpxnum
     (##make-rectangular (##log (##negate x)) (macro-inexact-+pi))
     (range-error)))

  (define (exact-log x)

    ;; x is positive, x is not 1.

    ;; There are three places where just converting to a flonum and
    ;; taking the flonum logarithm doesn't work well.
    ;; 1. Overflow in the conversion
    ;; 2. Underflow in the conversion (or even loss of precision
    ;;    because of a denormalized conversion result)
    ;; 3. When the number is close to 1.

    (let ((float-x (##exact->inexact x)))
      (cond ((##= x float-x)
             (##fllog float-x)) ;; first, we trust the builtin flonum log

            ((##not (##flonum-full-precision? float-x))

             ;; direct conversion to flonum could incur massive relative
             ;; rounding errors, or would just lead to an infinite result
             ;; so we tolerate more than one rounding error in the calculation

             (let* ((wn (##integer-length (##numerator x)))
                    (wd (##integer-length (##denominator x)))
                    (p  (##fx- wn wd))
                    (float-p (##fixnum->flonum p))
                    (partial-result (##fllog
                                     (##exact->inexact
                                      (##* x (##expt 2 (##fx- p)))))))
               (##fl+ (##fl* float-p
                             (macro-inexact-log-2))
                      partial-result)))

            ((or (##fl< (macro-inexact-exp-+1/2) float-x)
                 (##fl< float-x (macro-inexact-exp--1/2)))

             ;; here the absolute value of the logarithm is at least 0.5,
             ;; so there is less rounding error in the final result.

             (##fllog float-x))

            (else

             ;; use ln1p for arguments near one.

             (##fllog1p (##exact->inexact (##- x 1)))))))

  (define (complex-log-magnitude x)

    (define (log-mag a b)
      ;; both are finite, 0 < a <= b
      (let* ((c (##/ a b))
             (approx-mag (##* b (##sqrt (##+ 1 (##* c c))))))
        (if (or (##exact? approx-mag)
                (and (##flonum-full-precision? approx-mag)
                     (or (##fl< (macro-inexact-exp-+1/2) approx-mag)
                         (##fl< approx-mag (macro-inexact-exp--1/2)))))
            ;; log composed with magnitude will compute a relatively accurate answer
            (##log approx-mag)
            (let ((a (##inexact->exact a))
                  (b (##inexact->exact b)))
              (##* 1/2 (exact-log (##+ (##* a a) (##* b b))))))))

    (let ((abs-r (##abs (##real-part x)))
          (abs-i (##abs (##imag-part x))))

      ;; abs-i is not exact 0
      (cond ((or (and (##flonum? abs-r)
                      (##fl= abs-r (macro-inexact-+inf)))
                 (and (##flonum? abs-i)
                      (##fl= abs-i (macro-inexact-+inf))))
             (macro-inexact-+inf))
            ;; neither abs-r or abs-i is infinite
            ((and (##flonum? abs-r)
                  (##flnan? abs-r))
             abs-r)
            ;; abs-r is not a NaN
            ((and (##flonum? abs-i)
                  (##flnan? abs-i))
             abs-i)
            ;; abs-i is not a NaN
            ((##zero? abs-r)
             (let ((temp (##log abs-i)))
               (if (##eqv? abs-r 0)
                   temp
                   (##exact->inexact temp))))
            ;; abs-r is not zero
            ((##zero? abs-i)
             ;; abs-i is an inexact zero
             (##exact->inexact (##log abs-r)))
            ;; neither absi nor abs-r are zero
            (else
             (if (##< abs-r abs-i)
                 (log-mag abs-r abs-i)
                 (log-mag abs-i abs-r))))))

  (if (##eq? y (macro-absent-obj))
      (macro-number-dispatch x (type-error)
        (if (##fxzero? x)
            (range-error)
            (if (##fxnegative? x)
                (negative-log)
                (if (##eqv? x 1)
                    0
                    (exact-log x))))
        (if (##bignum.negative? x)
            (negative-log)
            (exact-log x))
        (if (##negative? (macro-ratnum-numerator x))
            (negative-log)
            (exact-log x))
        (if (or (##flnan? x)
                (##not (##flnegative?
                        (##flcopysign (macro-inexact-+1) x))))
            (##fllog x)
            (negative-log))
        (##make-rectangular (complex-log-magnitude x) (##angle x)))
      (##log2 x y)))

(define-prim (##log2 x y)

  ;; Assumes x is not zero and y is not 0 or 1

  (define (positive-exact-real? x)
    (and (or (##fixnum? x)
             (macro-if-bignum (##bignum? x) #f)
             (macro-if-ratnum (##ratnum? x) #f))
         (##positive? x)))

  (define (num x)
    ;; assumes x is exact real
    (if (macro-if-ratnum (##ratnum? x) #f)
        (##ratnum-numerator x)
        x))

  (define (den x)
    ;; assumes x is exact real
    (if (macro-if-ratnum (##ratnum? x) #f)
        (##ratnum-denominator x)
        1))

  (define (log-2 n)
    ;; assumes n is positive exact integer power of 2
    (##fx- (##integer-length n) 1))

  (if (and (positive-exact-real? x)
           (positive-exact-real? y)
           (##power-of-two? (num x))
           (##power-of-two? (den x))
           (##power-of-two? (num y))
           (##power-of-two? (den y)))
      (##/ (##- (log-2 (num x))
                (log-2 (den x)))
           (##- (log-2 (num y))
                (log-2 (den y))))
      (##/ (##log x) (##log y))))

(define-prim (log x #!optional (y (macro-absent-obj)))
  (macro-force-vars (x)
    (if (##eq? y (macro-absent-obj))
        (##log x)
        (macro-force-vars (y)
          (cond ((##not (##number? x))
                 (##fail-check-number 1 log x y))
                ((##not (##number? y))
                 (##fail-check-number 2 log x y))
                ((##eqv? x 0)
                 (##raise-range-exception 1 log x y))
                ((##eqv? y 0)
                 (##raise-range-exception 2 log x y))
                ((##eqv? y 1)
                 (##raise-range-exception 2 log x y))
                (else
                 (##log2 x y)))))))

(define-prim (##sin x)

  (define (type-error)
    (##fail-check-number 1 sin x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        0
        (##flsin (##fixnum->flonum x)))
    (##flsin (##exact-int->flonum x))
    (##flsin (##ratnum->flonum x))
    (##flsin x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (and (##flonum? real)
               (##flonum? imag))
          ;; fast path for flonums case
          (macro-cpxnum-make  (##fl* (##flsin real) (##flcosh imag))
                              (##fl* (##flcos real) (##flsinh imag)))
          (##make-rectangular (##* (##sin real) (##cosh imag))
                              (##* (##cos real) (##sinh imag)))))))

(define-prim (sin x)
  (macro-force-vars (x)
    (##sin x)))

(define-prim (##cos x)

  (define (type-error)
    (##fail-check-number 1 cos x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        1
        (##flcos (##fixnum->flonum x)))
    (##flcos (##exact-int->flonum x))
    (##flcos (##ratnum->flonum x))
    (##flcos x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (and (##flonum? real)
               (##flonum? imag))
          ;; fast path for flonums case
          (macro-cpxnum-make        (##fl* (##flcos real) (##flcosh imag))
                             (##fl- (##fl* (##flsin real) (##flsinh imag))))
          (##make-rectangular           (##* (##cos real) (##cosh imag))
                              (##negate (##* (##sin real) (##sinh imag))))))))

(define-prim (cos x)
  (macro-force-vars (x)
    (##cos x)))

(define-prim (##tan x)

  (define (type-error)
    (##fail-check-number 1 tan x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        0
        (##fltan (##fixnum->flonum x)))
    (##fltan (##exact-int->flonum x))
    (##fltan (##ratnum->flonum x))
    (##fltan x)
    ;; ##tanh is the basic function here.
    ;; Note that multiplying a purely imaginary argument
    ;; x by +i gives a purely real result, so we apply
    ;; ##tanh to (##* +i x), not ##ctanh.
    (##* -i (##tanh (##* +i x)))))

(define-prim (tan x)
  (macro-force-vars (x)
    (##tan x)))

(define-prim (##asin x)

  (define (type-error)
    (##fail-check-number 1 asin x))

  (define (range-error)
    (##raise-range-exception 1 asin x))

  (define (real-case x)
    (if (or (##< 1 x)
            (##< x -1))
        (macro-if-cpxnum
         (##casin (macro-cpxnum-make x 0))
         (range-error))
        (##flasin (##exact->inexact x))))

  (macro-number-dispatch x (type-error)
    (if (##eqv? x 0)
        0
        (real-case x))
    (real-case x)
    (real-case x)
    (real-case x)
    (##casin x)))

(define-prim (asin x)
  (macro-force-vars (x)
    (##asin x)))

(define-prim (##acos x)

  (define (type-error)
    (##fail-check-number 1 acos x))

  (define (range-error)
    (##raise-range-exception 1 acos x))

  (define (real-case x)
    (if (or (##< 1 x)
            (##< x -1))
        (macro-if-cpxnum
         (##cacos (macro-cpxnum-make x 0))
         (range-error))
        (##flacos (##exact->inexact x))))

  (macro-number-dispatch x (type-error)
    (if (##eqv? x 1)
        0
        (real-case x))
    (real-case x)
    (real-case x)
    (real-case x)
    (##cacos x)))

(define-prim (acos x)
  (macro-force-vars (x)
    (##acos x)))

(define-prim (##atan x #!optional (y (macro-absent-obj)))

  (define (type-error)
    (##fail-check-number 1 atan x))

  (define (range-error)
    (##raise-range-exception 1 atan x))

  (if (##eq? y (macro-absent-obj))
      (macro-number-dispatch x (type-error)
        (if (##fxzero? x)
            0
            (##flatan (##fixnum->flonum x)))
        (##flatan (##exact-int->flonum x))
        (##flatan (##ratnum->flonum x))
        (##flatan x)
        (let ((real (macro-cpxnum-real x))
              (imag (macro-cpxnum-imag x)))
          (if (and (##eqv? real 0)
                   (or (##eqv? imag 1)
                       (##eqv? imag -1)))
              (range-error)
              (##* -i (##atanh (##* +i x))))))
      (##atan2 x y)))

(define-prim (##atan2 y x)
  (cond ((or (and (##flonum? x) (##flnan? x))
             (and (##flonum? y) (##flnan? y)))
         (macro-inexact-+nan))
        ((##eqv? 0 y)
         (if (##exact? x)
             (if (##negative? x)
                 (macro-inexact-+pi)
                 0)
             (if (##negative? (##flcopysign (macro-inexact-+1) x))
                 (macro-inexact-+pi)
                 (macro-inexact-+0))))
        ((and (##not (##finite? x))
              (##not (##finite? y)))
         (if (##positive? x)
             (##flcopysign (macro-inexact-+pi/4) y)
             (##flcopysign (macro-inexact-+3pi/4) y)))
        (else
         (let ((inexact-x (##exact->inexact x))
               (inexact-y (##exact->inexact y)))
           (if (and (or (##flonum? x)
                        (##flonum-full-precision? inexact-x)
                        (##= x inexact-x))
                    (or (##flonum? y)
                        (##flonum-full-precision? inexact-y)
                        (##= y inexact-y)))
               (##flatan inexact-y inexact-x)
               ;; at least one of x or y is nonzero
               ;; and at least one of them is not a flonum
               (let* ((exact-x (##inexact->exact x))
                      (exact-y (##inexact->exact y))
                      (max-arg (##max (##abs exact-x)
                                      (##abs exact-y)))
                      (normalizer (##expt 2 (##- (##integer-length (##denominator max-arg))
                                                 (##integer-length (##numerator   max-arg))))))
                 ;; now the largest argument will be about 1.
                 (##flatan (##exact->inexact (##* normalizer exact-y))
                           (##exact->inexact (##* normalizer exact-x)))))))))

(define-prim (atan x #!optional (y (macro-absent-obj)))
  (macro-force-vars (x)
    (if (##eq? y (macro-absent-obj))
        (##atan x)
        (macro-force-vars (y)
          (cond ((##not (##real? x))
                 (##fail-check-real 1 atan x y))
                ((##not (##real? y))
                 (##fail-check-real 2 atan x y))
                (else
                 (##atan2 x y)))))))

;;; Hyperbolic functions

(define-prim (##sinh x)

  (define (type-error)
    (##fail-check-number 1 sinh x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        0
        (##flsinh (##fixnum->flonum x)))
    (##flsinh (##exact-int->flonum x))
    (##flsinh (##ratnum->flonum x))
    (##flsinh x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (and (##flonum? real) (##flonum? imag))
          ;; fast path for flonum case
          (macro-cpxnum-make (##fl* (##flsinh real) (##flcos imag))
                             (##fl* (##flcosh real) (##flsin imag)))
          (macro-cpxnum-make (##* (##sinh real) (##cos imag))
                             (##* (##cosh real) (##sin imag)))))))

(define-prim (sinh x)
  (macro-force-vars (x)
    (##sinh x)))

(define-prim (##cosh x)

  (define (type-error)
    (##fail-check-number 1 cosh x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        1
        (##flcosh (##fixnum->flonum x)))
    (##flcosh (##exact-int->flonum x))
    (##flcosh (##ratnum->flonum x))
    (##flcosh x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (and (##flonum? real) (##flonum? imag))
          ;; fast path for flonum case
          (macro-cpxnum-make (##fl* (##flcosh real) (##flcos imag))
                             (##fl* (##flsinh real) (##flsin imag)))
          (macro-cpxnum-make (##* (##cosh real) (##cos imag))
                             (##* (##sinh real) (##sin imag)))))))

(define-prim (cosh x)
  (macro-force-vars (x)
    (##cosh x)))

(define-prim (##tanh x)

  (define (type-error)
    (##fail-check-number 1 tanh x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        0
        (##fltanh (##fixnum->flonum x)))
    (##fltanh (##exact-int->flonum x))
    (##fltanh (##ratnum->flonum x))
    (##fltanh x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (##eqv? real 0)
          ;; the argument of the next ##tan is real
          ;; (##* +i (##tan (##* -i x)))
          (macro-cpxnum-make 0 (##tan imag))
          (##ctanh x)))))

(define-prim (tanh x)
  (macro-force-vars (x)
    (##tanh x)))

;;; Inverse hyperbolic functions

(define-prim (##asinh x)

  (define (type-error)
    (##fail-check-number 1 asinh x))

  (macro-number-dispatch x (type-error)
    (if (##fxzero? x)
        0
        (##flasinh (##fixnum->flonum x)))
    (##flasinh (##exact-int->flonum x))
    (##flasinh (##ratnum->flonum x))
    (##flasinh x)
    (##casinh x)))

(define-prim (asinh x)
  (macro-force-vars (x)
    (##asinh x)))

(define-prim (##acosh x)

  (define (type-error)
    (##fail-check-number 1 acosh x))

  (define (range-error)
    (##raise-range-exception 1 acosh x))

  (define (real-case x)
    (if (##< x 1)
        (macro-if-cpxnum
         (##cacosh (macro-cpxnum-make x 0))
         (range-error))
        (##flacosh (##exact->inexact x))))

  (macro-number-dispatch x (type-error)
    (if (##fx= x 1)
        0
        (real-case x))
    (real-case x)
    (real-case x)
    (real-case x)
    (##cacosh x)))

(define-prim (acosh x)
  (macro-force-vars (x)
    (##acosh x)))

(define-prim (##atanh x)

  (define (type-error)
    (##fail-check-number 1 atanh x))

  (define (range-error)
    (##raise-range-exception 1 atanh x))

  (define (real-case x)
    (cond ((##< 1 x) ;; TODO: avoid calling real-case in non-tail position
           (##negate (real-case (##negate x))))
          ((##< x -1)
           (macro-if-cpxnum
            (##make-rectangular
             (##fl/ (##fllog1p (##exact->inexact (##/ (##* 4 x)
                                                      (##square (##- x 1)))))
                    (macro-inexact-+4))
             (macro-inexact-+pi/2))
            (range-error)))
          (else
           (##flatanh (##exact->inexact x)))))

  (macro-number-dispatch x (type-error)
    (case x
      ((0)
       0)
      ((-1 1)
       (range-error))
      (else
       (real-case x)))
    (real-case x)
    (real-case x)
    (real-case x)
    (##catanh x)))

(define-prim (atanh x)
  (macro-force-vars (x)
    (##atanh x)))

(##define-macro (macro-make-sr s r) `(##values ,s ,r))
(##define-macro (macro-sr-s sr)     `(##values-ref ,sr 0))
(##define-macro (macro-sr-r sr)     `(##values-ref ,sr 1))

(define-prim (##sqrt x)

  (define (type-error)
    (##fail-check-number 1 sqrt x))

  (define (range-error)
    (##raise-range-exception 1 sqrt x))

  (define (exact-int-sqrt x)
    (if (##negative? x)
        (macro-if-cpxnum
         (##make-rectangular 0 (nonneg-exact-int-sqrt (##negate x)))
         (range-error))
        (nonneg-exact-int-sqrt x)))

  (define (nonneg-exact-int-sqrt x)
    (let ((y (##exact-int.sqrt x)))
      (cond ((##eqv? (macro-sr-r y) 0)
             (macro-sr-s y))
            ((##not (##exact-int.< (macro-flonum-+m-max-plus-1) x))
             ;; 0 <= x <= (macro-flonum-+m-max-plus-1), can be
             ;; converted to flonum exactly so avoids double
             ;; rounding in next expression. This has a relatively
             ;; fast path for small integers.
             (##flsqrt (##exact-int->flonum x)))
            ((##not (##< (macro-sr-s y) (macro-flonum-+m-max-plus-1)))
             ;; ##exact-int->flonum uses second argument correctly
             (##exact-int->flonum (macro-sr-s y) #t))
            (else
             ;; The integer part of y does not have enough bits accuracy
             ;; to round it correctly to a flonum, so to
             ;; make sure (macro-sr-s y) is big enough in the next call we
             ;; multiply by (expt 2 (macro-flonum-m-bits-plus-1*2)),
             ;; which is somewhat extravagant;
             ;; (expt 2 (+ 1 (macro-flonum-m-bits-plus-1))) should
             ;; work fine.
             (##fl* (macro-flonum-inverse-+m-max-plus-1-inexact)
                    (exact-int-sqrt
                     (##arithmetic-shift
                      x
                      (macro-flonum-m-bits-plus-1*2))))))))

  (define (ratnum-sqrt x)
    (if (##negative? x)
        (macro-if-cpxnum
         (##make-rectangular 0 (nonneg-ratnum-sqrt (##negate x)))
         (range-error))
        (nonneg-ratnum-sqrt x)))

  (define (nonneg-ratnum-sqrt x)
    (let ((p (macro-ratnum-numerator x))
          (q (macro-ratnum-denominator x)))
      (let ((sqrt-p (##exact-int.sqrt p))
            (sqrt-q (##exact-int.sqrt q)))
        (if (and (##zero? (macro-sr-r sqrt-p))
                 (##zero? (macro-sr-r sqrt-q)))
            ;; both (abs p) and q are perfect squares and
            ;; their square roots do not have any common factors
            (macro-ratnum-make (macro-sr-s sqrt-p)
                               (macro-sr-s sqrt-q))
            (let ((inexact-x (##exact->inexact x)))
              (if (##= x inexact-x)
                  (##flsqrt inexact-x)
                  (let ((wp (##integer-length p))
                        (wq (##integer-length q)))

                    ;; for IEEE 754 double precision, we need at least
                    ;; 53 or 54 (I can't seem to work it out) of the
                    ;; leading bits of (sqrt (/ p q)).  Here we get
                    ;; about 64 leading bits.  We just shift p (either
                    ;; right or left) until it is about 128 bits longer
                    ;; than q (shift must be even), then take the
                    ;; integer square root of the result.

                    (let* ((shift
                            (##fxarithmetic-shift-left
                             (##fxarithmetic-shift-right
                              (##fx- 128 (##fx- wp wq))
                              1)
                             1))
                           (leading-bits
                            (macro-sr-s
                             (##exact-int.sqrt
                              (##quotient
                               (##arithmetic-shift p shift)
                               q))))
                           (pre-rounded-result
                            (if (##fxnegative? shift)
                                (##arithmetic-shift
                                 leading-bits
                                 (##fx-
                                  (##fxarithmetic-shift-right
                                   shift
                                   1)))
                                (##ratnum.normalize
                                 leading-bits
                                 (##arithmetic-shift
                                  1
                                  (##fxarithmetic-shift-right
                                   shift
                                   1))))))
                      (if (##ratnum? pre-rounded-result)
                          (##ratnum->flonum pre-rounded-result #t)
                          (##exact-int->flonum  pre-rounded-result #t))))))))))

  (macro-number-dispatch x (type-error)
    (exact-int-sqrt x)
    (exact-int-sqrt x)
    (ratnum-sqrt x)
    (if (##flnegative? x)
        (macro-if-cpxnum
         (##make-rectangular 0 (##flsqrt (##fl- x)))
         (range-error))
        (##flsqrt x))
    (let ((real (##real-part x))
          (imag (##imag-part x)))
      (or (and (##exact? real)
               (##exact? imag)
               (let ((discriminant (##sqrt (##+ (##* real real)
                                                (##* imag imag)))))
                 (and (##exact? discriminant)
                      (let ((result-real (##sqrt (##/ (##+ real discriminant) 2))))
                        (and (##exact? result-real)
                             (##make-rectangular result-real (##/ imag (##* 2 result-real))))))))
          (##csqrt (##exact->inexact x))))))

(define-prim (sqrt x)
  (macro-force-vars (x)
    (##sqrt x)))

(define-prim (##power-of-two? n)
  ;; assumes n is a positive fixnum or bignum
  (if (macro-if-bignum (##fixnum? n) #t)
      (##fxzero? (##fxand n (##fx- n 1)))
      (##fx= (##fx+ (##first-set-bit n) 1)
             (##integer-length n))))

(define-prim (##expt x y)

  (define (type-error-on-x)
    (##fail-check-number 1 expt x y))

  (define (type-error-on-y)
    (##fail-check-number 2 expt x y))

  (define (range-error)
    (##raise-range-exception 1 expt x y))

  (define (exact-int-expt x y)

    (define (positive-int-expt x y)

      ;; x is an exact number and y is a positive exact integer

      (define (expt-aux x y)

        ;; x is an exact integer (not 0 or 1) and y is a nonzero exact integer

        (if (##eqv? y 1)
            x
            (let ((temp (##square (expt-aux x (##arithmetic-shift y -1)))))
              (if (##exact-int.odd? y)
                  (##* x temp)
                  temp))))

      (cond ((or (##eqv? x 0)
                 (##eqv? x 1))
             x)
            ((eqv? x -1)
             (if (##exact-int.odd? y)
                 -1
                 1))
            ((macro-if-ratnum (##ratnum? x) #f)
             (macro-ratnum-make
              (exact-int-expt (macro-ratnum-numerator   x) y)
              (exact-int-expt (macro-ratnum-denominator x) y)))
            (else
             (expt-aux x y))))

    (define (invert z)
      ;; z is exact
      (or (##inverse z)
          (range-error)))

    (if (##negative? y)
        (invert (positive-int-expt x (##negate y)))
        (positive-int-expt x y)))

  (define (complex-expt x y)
    (macro-if-cpxnum
     (##exp (##* (##log x) y))
     (range-error)))

  (define (ratnum-expt x y)
    ;; x is exact-int or ratnum
    (cond ((##eqv? x 0)
           (if (##negative? y)
               (range-error)
               0))
          ((##eqv? x 1)
           1)
          ((##negative? x)
           (macro-if-cpxnum
            ;; We'll do some nice multiples of angles of pi carefully
            (case (macro-ratnum-denominator y)
              ((2)
               (##* (##expt (##negate x) y)
                    (case (##modulo (macro-ratnum-numerator y) 4)
                      ((1)
                       (macro-cpxnum-+i))
                      (else ;; (3)
                       (macro-cpxnum--i)))))
              ((3)
               (##* (##expt (##negate x) y)
                    (case (##modulo (macro-ratnum-numerator y) 6)
                      ((1)
                       (macro-cpxnum-+1/2+sqrt3/2i))
                      ((2)
                       (macro-cpxnum--1/2+sqrt3/2i))
                      ((4)
                       (macro-cpxnum--1/2-sqrt3/2i))
                      (else ;; (5)
                       (macro-cpxnum-+1/2-sqrt3/2i)))))
              ((6)
               (##* (##expt (##negate x) y)
                    (case (##modulo (macro-ratnum-numerator y) 12)
                      ((1)
                       (macro-cpxnum-+sqrt3/2+1/2i))
                      ((5)
                       (macro-cpxnum--sqrt3/2+1/2i))
                      ((7)
                       (macro-cpxnum--sqrt3/2-1/2i))
                      (else ;; (11)
                       (macro-cpxnum-+sqrt3/2-1/2i)))))
              ;; otherwise, we punt
              (else
               (ratnum-complex-expt x y)))
            (range-error)))
          ((macro-exact-int? x)
           (let* ((y-den (macro-ratnum-denominator y))
                  (temp (##exact-int.nth-root x y-den)))
             (if (##= x (exact-int-expt temp y-den))
                 (exact-int-expt temp (macro-ratnum-numerator y))
                 (##flexpt (##exact-int->flonum x)
                           (##ratnum->flonum y)))))
          (else
           ;; x is a ratnum
           (let ((x-num (macro-ratnum-numerator   x))
                 (x-den (macro-ratnum-denominator x))
                 (y-num (macro-ratnum-numerator   y))
                 (y-den (macro-ratnum-denominator y)))
             (let ((temp-num (##exact-int.nth-root x-num y-den)))
               (if (##= (exact-int-expt temp-num y-den) x-num)
                   (let ((temp-den (##exact-int.nth-root x-den y-den)))
                     (if (##= (exact-int-expt temp-den y-den) x-den)
                         (exact-int-expt (macro-ratnum-make temp-num temp-den)
                                         y-num)
                         (##flexpt (##ratnum->flonum x)
                                   (##ratnum->flonum y))))
                   (##flexpt (##ratnum->flonum x)
                             (##ratnum->flonum y))))))))

  (define (ratnum-complex-expt x y)

    ;; y is ratnum, x is negative exact or complex

    (define (exact-dyadic-root? x n)
      (and (##exact? x)
           (or (and (##fxzero? n) x)
               (exact-dyadic-root? (##sqrt x)
                                   (##fx- n 1)))))

    (or (and (##power-of-two? (macro-ratnum-denominator y))
             (or (and (##eqv? (macro-ratnum-denominator y) 2)
                      (##eqv? (macro-ratnum-numerator y) 1)
                      (##sqrt x))
                 (let ((root? (exact-dyadic-root? x (##first-set-bit (macro-ratnum-denominator y)))))
                   (and root?
                        (##expt root? (macro-ratnum-numerator y))))))
        (complex-expt x y)))

  (macro-number-dispatch y (type-error-on-y)

    (macro-number-dispatch x (type-error-on-x) ;; y a fixnum
      (if (##fx= y 0)
          1
          (exact-int-expt x y))
      (if (##fx= y 0)
          1
          (exact-int-expt x y))
      (if (##fx= y 0)
          1
          (exact-int-expt x y))
      (cond ((##fx= y 0)
             1)
            ((##flnan? x)
             x)
            ((##flnegative? x)
             ;; we do this because (##fixnum->flonum y) is always
             ;; even for large enough y on 64-bit machines
             (let ((abs-result
                    (##flexpt (##fl- x) (##fixnum->flonum y))))
               (if (##fxodd? y)
                   (##fl- abs-result)
                   abs-result)))
            (else
             (##flexpt x (##fixnum->flonum y))))
      (cond ((##fx= y 0)
             1)
            ((##fx= y 1)
             x)
            ((##exact? x)
             (exact-int-expt x y))
            (else
             (complex-expt x y))))

    (macro-number-dispatch x (type-error-on-x) ;; y a bignum
      (exact-int-expt x y)
      (exact-int-expt x y)
      (exact-int-expt x y)
      (cond ((##flnan? x)
             x)
            ((##flnegative? x)
             ;; we do this because (##exact-int->flonum y) is always
             ;; even for large enough y
             (let ((abs-result
                    (##flexpt (##fl- x) (##exact-int->flonum y))))
               (if (macro-bignum-odd? y)
                   (##fl- abs-result)
                   abs-result)))
            (else
             (##flexpt x (##exact-int->flonum y))))
      (if (##exact? x)
          (exact-int-expt x y)
          (complex-expt x y)))

    (macro-number-dispatch x (type-error-on-x) ;; y a ratnum
      (ratnum-expt x y)
      (ratnum-expt x y)
      (ratnum-expt x y)
      (cond ((##flnan? x)
             x)
            ((##flnegative? x)
             (macro-if-cpxnum
              (if (##eqv? 2 (macro-ratnum-denominator y))
                  (let ((magnitude (##flexpt (##fl- x) (##ratnum->flonum y))))
                    (if (##eqv? 1 (##modulo (macro-ratnum-numerator y) 4))
                        ;; multiple of i
                        (macro-cpxnum-make 0 magnitude)
                        ;; multiple of -i
                        (macro-cpxnum-make 0 (##fl- magnitude))))
                  (complex-expt x y))
              (range-error)))
            (else
             (##flexpt x (##ratnum->flonum y))))
      (ratnum-complex-expt x y))

    (macro-number-dispatch x (type-error-on-x) ;; y a flonum
      (cond ((##flnan? y)
             y)
            ((##eqv? x 0)
             (if (##flnegative? y)
                 (range-error)
                 (macro-inexact-+0)))
            ((or (##fxpositive? x)
                 (macro-flonum-int? y))
             (##flexpt (##fixnum->flonum x) y))
            (else
             (complex-expt x y)))
      (cond ((##flnan? y)
             y)
            ((or (##positive? x)
                 (macro-flonum-int? y))
             (##flexpt (##exact-int->flonum x) y))
            (else
             (complex-expt x y)))
      (cond ((##flnan? y)
             y)
            ((or (##positive? x)
                 (macro-flonum-int? y))
             (##flexpt (##ratnum->flonum x) y))
            (else
             (complex-expt x y)))
      (cond ((##flnan? x)
             x)
            ((##flnan? y)
             y)
            ((or (##flpositive? x)
                 (macro-flonum-int? y))
             (##flexpt x y))
            (else
             (complex-expt x y)))
      (cond ((##flnan? y)
             y)
            (else
             (complex-expt x y))))

    (macro-number-dispatch x (type-error-on-x)  ;; y a cpxnum
      (if (##eqv? x 0)
          (let ((real (##real-part y)))
            (if (##positive? real)
                0
                ;; If we call (complex-expt 0 y),
                ;; we'll try to take (##log 0) in complex-expt,
                ;; so we raise the exception here.
                (range-error)))
          (complex-expt x y))
      (complex-expt x y)
      (complex-expt x y)
      (complex-expt x y)
      (complex-expt x y))))

(define-prim (expt x y)
  (macro-force-vars (x y)
    (##expt x y)))

(define-prim (##make-rectangular x y)
  (cond ((##not (##real? x))
         (##fail-check-real 1 make-rectangular x y))
        ((##not (##real? y))
         (##fail-check-real 2 make-rectangular x y))
        (else
         (let ((real (##real-part x))
               (imag (##real-part y)))
           (if (##eqv? imag 0)
               real
               (macro-if-cpxnum
                (macro-cpxnum-make real imag)
                (##raise-range-exception 2 make-rectangular x y)))))))

(define-prim (make-rectangular x y)
  (macro-force-vars (x y)
    (##make-rectangular x y)))

(define-prim (##make-polar x y)
  (##declare (mostly-flonum-fixnum))
  (cond ((##not (##real? x))
         (##fail-check-real 1 make-polar x y))
        ((##not (##real? y))
         (##fail-check-real 2 make-polar x y))
        (else
         (let ((real-x (##real-part x))
               (real-y (##real-part y)))
           (##make-rectangular (##* real-x (##cos real-y))
                               (##* real-x (##sin real-y)))))))

(define-prim (make-polar x y)
  (macro-force-vars (x y)
    (##make-polar x y)))

(define-prim (##real-part x)
  (macro-number-dispatch x x
    x x x x (macro-cpxnum-real x)))

(define-prim (real-part x)

  (define (type-error)
    (##fail-check-number 1 real-part x))

  (macro-force-vars (x)
    (macro-number-dispatch x (type-error)
      x x x x (macro-cpxnum-real x))))

(define-prim (##imag-part x)
  (macro-number-dispatch x 0
    0 0 0 0 (macro-cpxnum-imag x)))

(define-prim (imag-part x)

  (define (type-error)
    (##fail-check-number 1 imag-part x))

  (macro-force-vars (x)
    (macro-number-dispatch x (type-error)
      0 0 0 0 (macro-cpxnum-imag x))))

(define-prim (##magnitude x)

  (define (type-error)
    (##fail-check-number 1 magnitude x))

  (macro-number-dispatch x (type-error)
    (if (##fxnegative? x) (##negate x) x)
    (if (##bignum.negative? x) (##negate x) x)
    (if (##exact-int.negative? (macro-ratnum-numerator x))
        (macro-ratnum-make (##negate (macro-ratnum-numerator x))
                           (macro-ratnum-denominator x))
        x)
    (##flabs x)
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (cond ((and (##flonum? real) (##flonum? imag))
             (##flhypot real imag))
            ;; at least one of real or imag is exact
            ((and (##finite? real) (##finite? imag))
             (let ((possibly-exact-result
                    (##sqrt (##+ (##square (##inexact->exact real))
                                 (##square (##inexact->exact imag))))))
               (if (or (##flonum? real) (##flonum? imag))
                   (##exact->inexact possibly-exact-result)
                   possibly-exact-result)))
            ;; at least one of real or imag is not finite
            ((or (##infinite? real) (##infinite? imag))
             +inf.0)
            ;; At least one of real and imag is a NaN, and
            ;; if real or imag is a flonum then it is a NaN.
            ((##flonum? real)
             real)
            (else
             imag)))))

(define-prim (magnitude x)
  (macro-force-vars (x)
    (##magnitude x)))

(define-prim (##angle x)

  (define (type-error)
    (##fail-check-number 1 angle x))

  (macro-number-dispatch x (type-error)
    (if (##fxnegative? x)
        (macro-inexact-+pi)
        0)
    (if (##bignum.negative? x)
        (macro-inexact-+pi)
        0)
    (if (##negative? (macro-ratnum-numerator x))
        (macro-inexact-+pi)
        0)
    (if (##flnegative? (##flcopysign (macro-inexact-+1) x))
        (macro-inexact-+pi)
        (macro-inexact-+0))
    (##atan2 (macro-cpxnum-imag x) (macro-cpxnum-real x))))

(define-prim (angle x)
  (macro-force-vars (x)
    (##angle x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; exact->inexact, inexact->exact

(define-prim (##exact->inexact x)

  (define (type-error)
    (##fail-check-number 1 exact->inexact x))

  (macro-number-dispatch x (type-error)
    (##fixnum->flonum x)
    (##exact-int->flonum x)
    (##ratnum->flonum x)
    x
    (##make-rectangular (##exact->inexact (macro-cpxnum-real x))
                        (##exact->inexact (macro-cpxnum-imag x)))))

(define-prim (exact->inexact x)
  (macro-force-vars (x)
    (##exact->inexact x)))

(define-prim (##inexact x)

  (define (type-error)
    (##fail-check-number 1 inexact x))

  (macro-number-dispatch x (type-error)
    (##fixnum->flonum x)
    (##exact-int->flonum x)
    (##ratnum->flonum x)
    x
    (##make-rectangular (##inexact (macro-cpxnum-real x))
                        (##inexact (macro-cpxnum-imag x)))))

(define-prim (inexact x)
  (macro-force-vars (x)
    (##inexact x)))

(define-prim (##inexact->exact x)

  (define (type-error)
    (##fail-check-number 1 inexact->exact x))

  (define (range-error)
    (##raise-range-exception 1 inexact->exact x))

  (macro-number-dispatch x (type-error)
    x
    x
    x
    (if (macro-flonum-rational? x)
        (##flonum->exact x)
        (range-error))
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (and (macro-noncpxnum-rational? real)
               (macro-noncpxnum-rational? imag))
          (##make-rectangular (##inexact->exact real)
                              (##inexact->exact imag))
          (range-error)))))

(define-prim (inexact->exact x)
  (macro-force-vars (x)
    (##inexact->exact x)))

(define-prim (##exact x)

  (define (type-error)
    (##fail-check-number 1 exact x))

  (define (range-error)
    (##raise-range-exception 1 exact x))

  (macro-number-dispatch x (type-error)
    x
    x
    x
    (if (macro-flonum-rational? x)
        (##flonum->exact x)
        (range-error))
    (let ((real (macro-cpxnum-real x))
          (imag (macro-cpxnum-imag x)))
      (if (and (macro-noncpxnum-rational? real)
               (macro-noncpxnum-rational? imag))
          (##make-rectangular (##exact real)
                              (##exact imag))
          (range-error)))))

(define-prim (exact x)
  (macro-force-vars (x)
    (##exact x)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; number->string, string->number

(define ##digit-to-char-table "0123456789abcdefghijklmnopqrstuvwxyz")

(define-prim (##fixnum->string x #!optional (rad 10) (force-sign? #f))
  (cond ((##fxnegative? x)
         (let ((s (##fixnum->string-neg x rad 1 0)))
           (##string-set! s 0 #\-)
           s))
        ((##fxzero? x)
         (if force-sign?
             (##string #\+ #\0)
             (##string #\0)))
        (else
         (if force-sign?
             (let ((s (##fixnum->string-neg (##fx- x) rad 1 0)))
               (##string-set! s 0 #\+)
               s)
             (##fixnum->string-neg (##fx- x) rad 0 0)))))

(define (##fixnum->string-neg neg-x #!optional (rad 10) (len 0) (pos 0))

  ;; This procedure avoids the special case of the most negative fixnum
  ;; by working with negative fixnums.

  (let loop ((neg-x neg-x) (rad rad) (len len) (pos pos))
    (if (##fx= neg-x 0)
        (##make-string len)
        (let* ((new-pos
                (##fx+ pos 1))
               (s
                (loop (##fxquotient neg-x rad)
                      rad
                      (##fx+ len 1)
                      new-pos)))
          (##string-set!
           s
           (##fx- (##string-length s) new-pos)
           (##string-ref ##digit-to-char-table
                         (##fx- (##fxremainder neg-x rad))))
          s))))

(define-prim (##exact-int->string x #!optional (rad 10) (force-sign? #f))

  (##define-macro (macro-make-block-size)
    (let* ((max-rad 16)
           (t (make-vector (+ max-rad 1) 0)))

      (define max-fixnum 536870911) ;; OK to be conservative

      (define (block-size-for rad)
        (let loop ((i 0) (rad^i 1))
          (let ((new-rad^i (* rad^i rad)))
            (if (<= new-rad^i max-fixnum)
                (loop (+ i 1) new-rad^i)
                i))))

      (let loop ((i max-rad))
        (if (< 1 i)
            (begin
              (vector-set! t i (block-size-for i))
              (loop (- i 1)))))

      `',t))

  (define block-size (macro-make-block-size))

  (##define-macro (macro-make-rad^block-size)
    (let* ((max-rad 16)
           (t (make-vector (+ max-rad 1) 0)))

      (define max-fixnum 536870911) ;; OK to be conservative

      (define (rad^block-size-for rad)
        (let loop ((i 0) (rad^i 1))
          (let ((new-rad^i (* rad^i rad)))
            (if (<= new-rad^i max-fixnum)
                (loop (+ i 1) new-rad^i)
                rad^i))))

      (let loop ((i max-rad))
        (if (< 1 i)
            (begin
              (vector-set! t i (rad^block-size-for i))
              (loop (- i 1)))))

      `',t))

  (define rad^block-size (macro-make-rad^block-size))

  (define (convert-non-last-fixnum s rad x pos)
    (let loop ((x x)
               (size (##vector-ref block-size rad))
               (i (##fx- (##string-length s) pos)))
      (if (##fx< 0 size)
          (let ((new-i (##fx- i 1)))
            (##string-set!
             s
             new-i
             (##string-ref ##digit-to-char-table
                           (##fxremainder x rad)))
            (loop (##fxquotient x rad)
                  (##fx- size 1)
                  new-i)))))

  (define (make-string-from-fixnums rad lst len pos)
    (let loop ((lst lst) (pos pos))
      (let ((new-lst (##cdr lst)))
        (if (##null? new-lst)
            (##fixnum->string-neg
             (##fx- (##car lst))
             rad
             (##fx+ len pos)
             pos)
            (let* ((size
                    (##vector-ref block-size rad))
                   (new-pos
                    (##fx+ pos size))
                   (s
                    (loop new-lst new-pos)))
              (convert-non-last-fixnum s rad (##car lst) pos)
              s)))))

  (define (uinteger->fixnums level sqs x lst)
    (cond ((and (##null? lst) (##eqv? x 0))
           lst)
          ((##fx= level 0)
           (##cons x lst))
          (else
           (let* ((qr (##exact-int.div x (##car sqs)))
                  (new-level (##fx- level 1))
                  (new-sqs (##cdr sqs))
                  (q (macro-qr-q qr))
                  (r (macro-qr-r qr)))
             (uinteger->fixnums
              new-level
              new-sqs
              r
              (uinteger->fixnums new-level new-sqs q lst))))))

  (define (uinteger->string x rad len)
    (make-string-from-fixnums
     rad
     (let ((rad^size
            (##vector-ref rad^block-size rad))
           (x-length
            (##integer-length x)))
       (let loop ((level 0)
                  (sqs '())
                  (rad^size^2^level rad^size))
         (let ((new-level
                (##fx+ level 1))
               (new-sqs
                (##cons rad^size^2^level sqs)))
           (if (##fx< x-length
                      (##fx-
                       (##fx* (##integer-length rad^size^2^level) 2)
                       1))
               (uinteger->fixnums new-level new-sqs x '())
               (let ((new-rad^size^2^level
                      (##exact-int.square rad^size^2^level)))
                 (if (##< x new-rad^size^2^level)
                     (uinteger->fixnums new-level new-sqs x '())
                     (loop new-level
                           new-sqs
                           new-rad^size^2^level)))))))
     len
     0))

  (macro-exact-int-dispatch-no-error x

    (##fixnum->string x rad force-sign?)

    (cond ((##bignum.negative? x)
           (let ((s (uinteger->string (##negate x) rad 1)))
             (##string-set! s 0 #\-)
             s))
          (else
           (if force-sign?
               (let ((s (uinteger->string x rad 1)))
                 (##string-set! s 0 #\+)
                 s)
               (uinteger->string x rad 0))))))

(macro-if-ratnum
 (define-prim (##ratnum->string x #!optional (rad 10) (force-sign? #f))
   (##string-append
    (##exact-int->string (macro-ratnum-numerator x) rad force-sign?)
    "/"
    (##exact-int->string (macro-ratnum-denominator x) rad #f))))

(##define-macro (macro-r6rs-fp-syntax) #t)
(##define-macro (macro-chez-fp-syntax) #f)

(##define-macro (macro-make-10^-constants n)
  (let ((v (make-vector n)))
    (let loop ((i 0) (x 1))
      (if (< i n)
          (begin
            (vector-set! v i x)
            (loop (+ i 1) (* x 10)))))
    `',v))

(define ##10^-constants
  (if (use-fast-bignum-algorithms)
      (macro-make-10^-constants 326)
      (macro-make-10^-constants 9))) ;; powers of 10 that are in fixnum32 range

(define (##exact-int.expt x y) ;; x and y are exact integers
  (let* ((x-negative? (##exact-int.< x 0))
         (abs-x (if x-negative? (##negate x) x))
         (y-negative? (##exact-int.< y 0))
         (abs-y (if y-negative? (##negate y) y))
         (abs-x^abs-y (##nonneg-exact-int.expt abs-x abs-y))
         (abs-result
          (if y-negative? (##inverse abs-x^abs-y) abs-x^abs-y)))
    (if (and x-negative? (##exact-int.odd? abs-y))
        (##negate abs-result)
        abs-result)))

(define (##nonneg-exact-int.expt x y) ;; x and y are nonnegative exact integers

  (define (nonneg-expt10 y)
    (if (and (macro-if-bignum (##fixnum? y) #t)
             (##fx< y (##vector-length ##10^-constants)))
        (##vector-ref ##10^-constants y)
        (let ((temp
               (##exact-int.square (nonneg-expt10 (##arithmetic-shift y -1)))))
          (if (##exact-int.odd? y)
              (##exact-int.* 10 temp)
              temp))))

  (define (nonneg-expt x y)
    (if (##eqv? y 1)
        x
        (let ((temp
               (##exact-int.square (nonneg-expt x (##arithmetic-shift y -1)))))
          (if (##exact-int.odd? y)
              (##exact-int.* x temp)
              temp))))

  (cond ((##eqv? y 0)
         1)
        ((or (##eqv? x 0) (##eqv? x 1) (##eqv? y 1))
         x)
        ((##eqv? x 2)
         (##arithmetic-shift 1 y))
        ((##eqv? x 10)
         (nonneg-expt10 y))
        (else
         (nonneg-expt x y))))

(define-prim (##flonum-printout v sign-prefix)

  ;; This algorithm is derived from the paper "Printing Floating-Point
  ;; Numbers Quickly and Accurately" by Robert G. Burger and R. Kent Dybvig,
  ;; SIGPLAN'96 Conference on Programming Language Design an Implementation.

  ;; v is a flonum
  ;; f is an exact integer (fixnum or bignum)
  ;; e is an exact integer (fixnum only)

  (define (10^ n) ;; 0 <= n < 326
    (if (use-fast-bignum-algorithms)
        (##vector-ref ##10^-constants n)
        (##nonneg-exact-int.expt 10 n)))

  (define (base-10-log x)
    (##define-macro (1/log10) `',(/ (log 10)))
    (##fl* (##fllog x) (1/log10)))

  (##define-macro (epsilon)
    1e-10)

  (define (scale r s m+ m- round? v)

    ;; r is an exact integer (fixnum or bignum)
    ;; s is an exact integer (fixnum or bignum)
    ;; m+ is an exact integer (fixnum or bignum)
    ;; m- is an exact integer (fixnum or bignum)
    ;; round? is a boolean
    ;; v is a flonum

    (let ((est
           (##flonum->fixnum
            (##flceiling (##fl- (base-10-log v) (epsilon))))))
      (if (##fxnegative? est)
          (let ((factor (10^ (##fx- est))))
            (fixup (##* r factor)
                   s
                   (##* m+ factor)
                   (##* m- factor)
                   est
                   round?))
          (let ((factor (10^ est)))
            (fixup r
                   (##* s factor)
                   m+
                   m-
                   est
                   round?)))))

  (define (fixup r s m+ m- k round?)
    (if (if round?
            (##not (##< (##+ r m+) s))
            (##< s (##+ r m+)))
        (##cons (##fx+ k 1)
                (generate r
                          s
                          m+
                          m-
                          round?
                          0))
        (##cons k
                (generate (##* r 10)
                          s
                          (##* m+ 10)
                          (##* m- 10)
                          round?
                          0))))

  (define (generate r s m+ m- round? n)
    (let* ((dr (##exact-int.div r s))
           (d (macro-qr-q dr))
           (r (macro-qr-r dr))
           (tc (if round?
                   (##not (##< (##+ r m+) s))
                   (##< s (##+ r m+)))))
      (if (if round? (##not (##< m- r)) (##< r m-))
          (let* ((last-digit
                  (if tc
                      (let ((r*2 (##arithmetic-shift r 1)))
                        (if (or (and (##fxeven? d)
                                     (##= r*2 s)) ;; tie, round d to even
                                (##< r*2 s))
                            d
                            (##fx+ d 1)))
                      d))
                 (str
                  (##make-string (##fx+ n 1))))
            (##string-set!
             str
             n
             (##string-ref ##digit-to-char-table last-digit))
            str)
          (if tc
              (let ((str
                     (##make-string (##fx+ n 1))))
                (##string-set!
                 str
                 n
                 (##string-ref ##digit-to-char-table (##fx+ d 1)))
                str)
              (let ((str
                     (generate (##* r 10)
                               s
                               (##* m+ 10)
                               (##* m- 10)
                               round?
                               (##fx+ n 1))))
                (##string-set!
                 str
                 n
                 (##string-ref ##digit-to-char-table d))
                str)))))

  (define (flonum->exponent-and-digits v)
    (macro-if-bignum
     (flonum->exponent-and-digits-accurately v)
     (flonum->exponent-and-digits-host v)))

  (define (flonum->exponent-and-digits-accurately v)
    (let* ((x (##flonum->exact-exponential-format v))
           (f (##vector-ref x 0))
           (e (##vector-ref x 1))
           (round? (##not (##exact-int.odd? f))))
      (if (##fxnegative? e)
          (if (and (##not (##fx= e (macro-flonum-e-min)))
                   (##= f (macro-flonum-+m-min)))
              (scale (##arithmetic-shift f 2)
                     (##arithmetic-shift 1 (##fx- 2 e))
                     2
                     1
                     round?
                     v)
              (scale (##arithmetic-shift f 1)
                     (##arithmetic-shift 1 (##fx- 1 e))
                     1
                     1
                     round?
                     v))
          (let ((2^e (##arithmetic-shift 1 e)))
            (if (##= f (macro-flonum-+m-min))
                (scale (##arithmetic-shift f (##fx+ e 2))
                       4
                       (##arithmetic-shift 1 (##fx+ e 1))
                       2^e
                       round?
                       v)
                (scale (##arithmetic-shift f (##fx+ e 1))
                       2
                       2^e
                       2^e
                       round?
                       v))))))

  (define (flonum->exponent-and-digits-host v)
    (string->exponent-and-digits (##flonum->string-host v)))

  (define (string->exponent-and-digits str)
    (let loop1 ((i 0)
                (j 0)
                (last-nz #f)
                (decimals #f))

      (define (err)
        (##cons 1 "0error"))

      (define (done e)
        (if last-nz

            (let ((len (##fx+ last-nz 1)))
              (##string-shrink! str len)
              (let ((decimals (##fx- (or decimals 0) (##fx- j len))))
                (##cons (##fx+ e (##fx- len decimals)) str)))

            (##cons 1 "0")))

      (if (##fx< i (##string-length str))
          (let* ((c (##string-ref str i))
                 (ic (##char->integer c))
                 (d
                  (if (##fx< ic 128)
                      (##u8vector-ref
                       ##char-to-digit-table
                       ic)
                      99)))
            (cond ((##fx= d 0)
                   (loop1 (##fx+ i 1)
                          (if last-nz
                              (begin
                                (##string-set! str j c)
                                (##fx+ j 1))
                              j)
                          last-nz
                          (and decimals (##fx+ decimals 1))))
                  ((##fx< d 10)
                   (##string-set! str j c)
                   (loop1 (##fx+ i 1)
                          (##fx+ j 1)
                          j
                          (and decimals (##fx+ decimals 1))))
                  ((##char=? c #\.)
                   (if decimals
                       (err)
                       (loop1 (##fx+ i 1)
                              j
                              last-nz
                              0)))
                  ((or (##char=? c #\e)
                       (##char=? c #\E))
                   (let ((i (##fx+ i 1)))
                     (if (##fx< i (##string-length str))
                         (let ((sign (##string-ref str i)))
                           (let ((i (if (or (##char=? sign #\-)
                                            (##char=? sign #\+))
                                        (##fx+ i 1)
                                        i)))
                             (if (##not (##fx< i (##string-length str)))
                                 (err)
                                 (let loop2 ((i i)
                                             (e 0))
                                   (if (##fx< i (##string-length str))
                                       (let* ((c (##string-ref str i))
                                              (ic (##char->integer c))
                                              (d
                                               (if (##fx< ic 128)
                                                   (##u8vector-ref
                                                    ##char-to-digit-table
                                                    ic)
                                                   99)))
                                         (if (and (##fx< d 10)
                                                  (##fx< e 100))
                                             (loop2 (##fx+ i 1)
                                                    (##fx+ (##fx* e 10) d))
                                             (err)))
                                       (done (if (##char=? sign #\-)
                                                 (##fx- e)
                                                 e)))))))
                         (err))))
                  ((##fx< i (##string-length str))
                   (err))
                  (else
                   (done 0))))
          (done 0))))

  (let* ((x (flonum->exponent-and-digits v))
         (e (##car x))
         (d (##cdr x))            ;; d = digits
         (n (##string-length d))) ;; n = number of digits

    (cond ((and (##not (##fx< e 0)) ;; 0<=e<=10
                (##not (##fx< 10 e)))

           (cond ((##fx= e 0) ;; e=0

                  ;; Format 1: .DDD    (0.DDD in chez-fp-syntax)

                  (##string-append sign-prefix
                                   (if (macro-chez-fp-syntax) "0." ".")
                                   d))

                 ((##fx< e n) ;; e<n

                  ;; Format 2: D.DDD up to DDD.D

                  (##string-append sign-prefix
                                   (##substring d 0 e)
                                   "."
                                   (##substring d e n)))

                 ((##fx= e n) ;; e=n

                  ;; Format 3: DDD.    (DDD.0 in chez-fp-syntax)

                  (##string-append sign-prefix
                                   d
                                   (if (macro-chez-fp-syntax) ".0" ".")))

                 (else ;; e>n

                  ;; Format 4: DDD000000.    (DDD000000.0 in chez-fp-syntax)

                  (##string-append sign-prefix
                                   d
                                   (##make-string (##fx- e n) #\0)
                                   (if (macro-chez-fp-syntax) ".0" ".")))))

          ((and (##not (##fx< e -2)) ;; -2<=e<=-1
                (##not (##fx< -1 e)))

           ;; Format 5: .0DDD or .00DDD    (0.0DDD or 0.00DDD in chez-fp-syntax)

           (##string-append sign-prefix
                            (if (macro-chez-fp-syntax) "0." ".")
                            (##make-string (##fx- e) #\0)
                            d))

          (else

           ;; Format 6: D.DDDeEEE
           ;;
           ;; This is the most general format.  We insert a period after
           ;; the first digit (unless there is only one digit) and add
           ;; an exponent.

           (##string-append sign-prefix
                            (##substring d 0 1)
                            (if (##fx= n 1) "" ".")
                            (##substring d 1 n)
                            "e"
                            (##exact-int->string (##fx- e 1) 10 #f))))))

(define-prim (##flonum->string x #!optional (rad 10) (force-sign? #f))

  (define (non-neg-num->str x rad sign-prefix)
    (if (##flzero? x)
        (##string-append sign-prefix (if (macro-chez-fp-syntax) "0.0" "0."))
        (##flonum-printout x sign-prefix)))

  (cond ((##flnan? x)
         (##string-copy (if (and #f ;; always use positive sign for NaNs
                                 (##flnegative? (##flcopysign (macro-inexact-+1) x)))
                            (if (or (macro-r6rs-fp-syntax)
                                    (macro-chez-fp-syntax))
                                "-nan.0"
                                "-nan.")
                            (if (or (macro-r6rs-fp-syntax)
                                    (macro-chez-fp-syntax))
                                "+nan.0"
                                "+nan."))))
        ((##flnegative? (##flcopysign (macro-inexact-+1) x))
         (let ((abs-x (##flcopysign x (macro-inexact-+1))))
           (cond ((##fl= abs-x (macro-inexact-+inf))
                  (##string-copy (if (or (macro-r6rs-fp-syntax)
                                         (macro-chez-fp-syntax))
                                     "-inf.0"
                                     "-inf.")))
                 (else
                  (non-neg-num->str abs-x rad "-")))))
        (else
         (cond ((##fl= x (macro-inexact-+inf))
                (##string-copy (if (or (macro-r6rs-fp-syntax)
                                       (macro-chez-fp-syntax))
                                   "+inf.0"
                                   "+inf.")))
               (force-sign?
                (non-neg-num->str x rad "+"))
               (else
                (non-neg-num->str x rad ""))))))

(define-prim (##flonum->string-host x)
  (##flonum->string x 10 #f))

(macro-if-cpxnum
 (define-prim (##cpxnum->string x #!optional (rad 10) (force-sign? #f))
   (let* ((real
           (macro-cpxnum-real x))
          (real-str
           (if (##eqv? real 0) "" (##number->string real rad force-sign?))))
     (let ((imag (macro-cpxnum-imag x)))
       (cond ((##eqv? imag 1)
              (##string-append real-str "+i"))
             ((##eqv? imag -1)
              (##string-append real-str "-i"))
             (else
              (##string-append real-str
                               (##number->string imag rad #t)
                               "i")))))))

(define-prim (##number->string x #!optional (rad 10) (force-sign? #f))
  (macro-number-dispatch x '()
    (##exact-int->string x rad force-sign?)
    (let ((normalized-x (or (##bignum->fixnum? x) x))) ;; allow conversion of unnormalized bignums
      (##exact-int->string normalized-x rad force-sign?))
    (##ratnum->string x rad force-sign?)
    (##flonum->string x rad force-sign?)
    (##cpxnum->string x rad force-sign?)))

(define-prim (number->string n #!optional (r (macro-absent-obj)))
  (macro-force-vars (n r)
    (let ((rad (if (##eq? r (macro-absent-obj)) 10 r)))
      (if (macro-exact-int? rad)
          (if (or (##eqv? rad 2)
                  (##eqv? rad 8)
                  (##eqv? rad 10)
                  (##eqv? rad 16))
              (let ((result (##number->string n rad #f)))
                (if (##null? result)
                    (##fail-check-number 1 number->string n r)
                    result))
              (##raise-range-exception 2 number->string n r))
          (##fail-check-exact-integer 2 number->string n r)))))

(##define-macro (macro-make-char-to-digit-table)
  (let ((t (make-vector 128 99)))
    (vector-set! t (char->integer #\#) 0) ;; #\# counts as 0
    (let loop1 ((i 9))
      (if (not (< i 0))
          (begin
            (vector-set! t (+ (char->integer #\0) i) i)
            (loop1 (- i 1)))))
    (let loop2 ((i 25))
      (if (not (< i 0))
          (begin
            (vector-set! t (+ (char->integer #\A) i) (+ i 10))
            (vector-set! t (+ (char->integer #\a) i) (+ i 10))
            (loop2 (- i 1)))))
    `',(list->u8vector (vector->list t))))

(define ##char-to-digit-table (macro-make-char-to-digit-table))

(define-prim (##string->number-slow-path str #!optional (rad 10) (check-only? #f))

  ;; The number grammar parsed by this procedure is:
  ;;
  ;; <num R E> : <prefix R E> <complex R E>
  ;;
  ;; <complex R E> : <real R E>
  ;;               | <real R E> @ <real R E>
  ;;               | <real R E> <sign> <ureal R> i
  ;;               | <real R E> <sign-inf-nan R E> i
  ;;               | <real R E> <sign> i
  ;;               | <sign> <ureal R> i
  ;;               | <sign-inf-nan R E> i
  ;;               | <sign> i
  ;;
  ;; <real R E> : <ureal R>
  ;;            | <sign> <ureal R>
  ;;            | <sign-inf-nan R E>
  ;;
  ;; <sign-inf-nan R i> : +inf.0
  ;;                    | -inf.0
  ;;                    | +nan.0
  ;;                    | -nan.0
  ;; <sign-inf-nan R empty> : <sign-inf-nan R i>
  ;;
  ;; <ureal R> : <uinteger R>
  ;;           | <uinteger R> / <uinteger R>
  ;;           | <decimal R>
  ;;
  ;; <decimal 10> : <uinteger 10> <suffix>
  ;;              | . <digit 10>+ #* <suffix>
  ;;              | <digit 10>+ . <digit 10>* #* <suffix>
  ;;              | <digit 10>+ #+ . #* <suffix>
  ;;
  ;; <uinteger R> : <digit R>+ #*
  ;;
  ;; <prefix R E> : <radix R E> <exactness E>
  ;;              | <exactness E> <radix R E>
  ;;
  ;; <suffix> : <empty>
  ;;          | <exponent marker> <digit 10>+
  ;;          | <exponent marker> <sign> <digit 10>+
  ;;
  ;; <exponent marker> : e | s | f | d | l
  ;; <sign> : + | -
  ;; <exactness empty> : <empty>
  ;; <exactness i> : #i
  ;; <exactness e> : #e
  ;; <radix 2> : #b
  ;; <radix 8> : #o
  ;; <radix 10> : <empty> | #d
  ;; <radix 16> : #x
  ;; <digit 2> : 0 | 1
  ;; <digit 8> : 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7
  ;; <digit 10> : 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9
  ;; <digit 16> : <digit 10> | a | b | c | d | e | f

  (##define-macro (macro-make-exact-10^n-table)

    (define max-exact-power-of-10 22) ;; (floor (inexact->exact (/ (log (expt 2 (macro-flonum-m-bits-plus-1))) (log 5))))

    (let ((t (make-vector (+ max-exact-power-of-10 1))))

      (let loop ((i max-exact-power-of-10))
        (if (not (< i 0))
            (begin
              (vector-set! t i (exact->inexact (expt 10 i)))
              (loop (- i 1)))))

      `',(list->f64vector (vector->list t))))

  (define exact-10^n-table (macro-make-exact-10^n-table))

  (##define-macro (macro-make-block-size)
    (let* ((max-rad 16)
           (t (make-vector (+ max-rad 1) 0)))

      (define max-fixnum 536870911) ;; OK to be conservative

      (define (block-size-for rad)
        (let loop ((i 0) (rad^i 1))
          (let ((new-rad^i (* rad^i rad)))
            (if (<= new-rad^i max-fixnum)
                (loop (+ i 1) new-rad^i)
                i))))

      (let loop ((i max-rad))
        (if (< 1 i)
            (begin
              (vector-set! t i (block-size-for i))
              (loop (- i 1)))))

      `',t))

  (define block-size (macro-make-block-size))

  (##define-macro (macro-make-rad^block-size)
    (let* ((max-rad 16)
           (t (make-vector (+ max-rad 1) 0)))

      (define max-fixnum 536870911) ;; OK to be conservative

      (define (rad^block-size-for rad)
        (let loop ((i 0) (rad^i 1))
          (let ((new-rad^i (* rad^i rad)))
            (if (<= new-rad^i max-fixnum)
                (loop (+ i 1) new-rad^i)
                rad^i))))

      (let loop ((i max-rad))
        (if (< 1 i)
            (begin
              (vector-set! t i (rad^block-size-for i))
              (loop (- i 1)))))

      `',t))

  (define rad^block-size (macro-make-rad^block-size))

  (define (substring->uinteger-fixnum str rad i j)

    ;; Simple case: result is known to fit in a fixnum.

    (let loop ((i i) (n 0))
      (if (##fx< i j)
          (let* ((c (##string-ref str i))
                 (ic (##char->integer c)))
            (loop (##fx+ i 1)
                  (##fx+ (##fx* n rad)
                         (if (##fx< ic 128)
                             (##u8vector-ref ##char-to-digit-table ic)
                             0))))
          n)))

  (define (substring->uinteger-aux sqs width str rad i j)

    ;; Divide-and-conquer algorithm (fast for large bignums if bignum
    ;; multiplication is fast).

    (if (##null? sqs)
        (substring->uinteger-fixnum str rad i j)
        (let* ((new-sqs (##cdr sqs))
               (new-width (##fxquotient width 2))
               (mid (##fx- j new-width)))
          (if (##fx< i mid)
              (let* ((a (substring->uinteger-aux new-sqs new-width str rad i mid))
                     (b (substring->uinteger-aux new-sqs new-width str rad mid j)))
                (##+ (##* a (##car sqs)) b))
              (substring->uinteger-aux new-sqs new-width str rad i j)))))

  (define (squares rad n)
    (let loop ((rad rad) (n n) (lst '()))
      (if (##fx= n 1)
          (##cons rad lst)
          (loop (##exact-int.square rad)
                (##fx- n 1)
                (##cons rad lst)))))

  (define (substring->uinteger str rad i j)

    ;; Converts a substring into an unsigned integer.  Selects a fast
    ;; conversion algorithm when result fits in a fixnum.

    (let ((len (##fx- j i))
          (size (##vector-ref block-size rad)))
      (if (##fx< size len)
          (let ((levels
                 (##integer-length (##fxquotient (##fx- len 1) size))))
            (substring->uinteger-aux
             (squares (##vector-ref rad^block-size rad) levels)
             (##fxarithmetic-shift-left size levels)
             str
             rad
             i
             j))
          (substring->uinteger-fixnum str rad i j))))

  (define (float-substring->uinteger str i j)

    ;; Converts a substring containing the decimals of a floating-point
    ;; number into an unsigned integer (any period is simply skipped).

    (let loop1 ((i i) (n 0))
      (if (##not (##fx< i j))
          n
          (let ((c (##string-ref str i)))
            (if (##char=? c #\.)
                (loop1 (##fx+ i 1) n)
                (let* ((ic
                        (##char->integer c))
                       (new-n
                        (##fx+ (##fx* n 10)
                               (if (##fx< ic 128)
                                   (##u8vector-ref ##char-to-digit-table ic)
                                   0))))
                  (if (##fx< new-n (macro-max-fixnum32-div-10))
                      (loop1 (##fx+ i 1) new-n)
                      (let loop2 ((i i) (n n))
                        (if (##not (##fx< i j))
                            n
                            (let ((c (##string-ref str i)))
                              (if (##char=? c #\.)
                                  (loop2 (##fx+ i 1) n)
                                  (let* ((ic
                                          (##char->integer c))
                                         (new-n
                                          (##+ (##* n 10)
                                               (if (##fx< ic 128)
                                                   (##u8vector-ref ##char-to-digit-table ic)
                                                   0))))
                                    (loop2 (##fx+ i 1) new-n)))))))))))))

  (define (uinteger str rad i)
    (and (##fx< i (##string-length str))
         (let* ((c (##string-ref str i))
                (ic (##char->integer c)))
           (and (##fx< ic 128)
                (##not (##char=? c #\#))
                (##fx< (##u8vector-ref ##char-to-digit-table ic) rad)
                (digits-and-sharps str rad (##fx+ i 1))))))

  (define (digits-and-sharps str rad i)
    (let loop ((i i))
      (if (##fx< i (##string-length str))
          (let* ((c (##string-ref str i))
                 (ic (##char->integer c)))
            (if (##fx< ic 128)
                (if (##char=? c #\#)
                    (sharps str (##fx+ i 1))
                    (if (##fx< (##u8vector-ref ##char-to-digit-table ic) rad)
                        (loop (##fx+ i 1))
                        i))
                i))
          i)))

  (define (sharps str i)
    (let loop ((i i))
      (if (##fx< i (##string-length str))
          (if (##char=? (##string-ref str i) #\#)
              (loop (##fx+ i 1))
              i)
          i)))

  (define (suffix str i1)
    (if (##fx< (##fx+ i1 1) (##string-length str))
        (let ((c1 (##string-ref str i1)))
          (if (or (##char=? c1 #\e) (##char=? c1 #\E)
                  (##char=? c1 #\s) (##char=? c1 #\S)
                  (##char=? c1 #\f) (##char=? c1 #\F)
                  (##char=? c1 #\d) (##char=? c1 #\D)
                  (##char=? c1 #\l) (##char=? c1 #\L))
              (let ((c2 (##string-ref str (##fx+ i1 1))))
                (let ((i2
                       (if (or (##char=? c2 #\+) (##char=? c2 #\-))
                           (uinteger str 10 (##fx+ i1 2))
                           (uinteger str 10 (##fx+ i1 1)))))
                  (if (and i2
                           (##not (##char=? (##string-ref str (##fx- i2 1))
                                            #\#)))
                      i2
                      i1)))
              i1))
        i1))

  (define (ureal str rad e i1)
    (let ((i2 (uinteger str rad i1)))
      (if i2
          (if (##fx< i2 (##string-length str))
              (let ((c (##string-ref str i2)))
                (cond ((##char=? c #\/)
                       (let ((i3 (uinteger str rad (##fx+ i2 1))))
                         (and i3
                              (let ((inexact-num?
                                     (or (##eq? e 'i)
                                         (and (##not e)
                                              (or (##char=? (##string-ref
                                                             str
                                                             (##fx- i2 1))
                                                            #\#)
                                                  (##char=? (##string-ref
                                                             str
                                                             (##fx- i3 1))
                                                            #\#))))))
                                (if (and (##not inexact-num?)
                                         (##eqv? (substring->uinteger
                                                  str
                                                  rad
                                                  (##fx+ i2 1)
                                                  i3)
                                                 0))
                                    #f
                                    (##vector i3 i2))))))
                      ((##fx= rad 10)
                       (if (##char=? c #\.)
                           (let ((i3
                                  (if (##char=? (##string-ref str (##fx- i2 1))
                                                #\#)
                                      (sharps str (##fx+ i2 1))
                                      (digits-and-sharps str 10 (##fx+ i2 1)))))
                             (and i3
                                  (let ((i4 (suffix str i3)))
                                    (##vector i4 i3 i2))))
                           (let ((i3 (suffix str i2)))
                             (if (##fx= i2 i3)
                                 i2
                                 (##vector i3 i2 i2)))))
                      (else
                       i2)))
              i2)
          (and (##fx= rad 10)
               (##fx< i1 (##string-length str))
               (##char=? (##string-ref str i1) #\.)
               (let ((i3 (uinteger str rad (##fx+ i1 1))))
                 (and i3
                      (let ((i4 (suffix str i3)))
                        (##vector i4 i3 i1))))))))

  (define (inf-nan str sign i e)
    (and (##not (##eq? e 'e))
         (if (##fx< (##fx+ i (if (or (macro-r6rs-fp-syntax)
                                     (macro-chez-fp-syntax))
                                 4
                                 3))
                    (##string-length str))
             (and (##char=? (##string-ref str (##fx+ i 3)) #\.)
                  (if (or (macro-r6rs-fp-syntax)
                          (macro-chez-fp-syntax))
                      (##char=? (##string-ref str (##fx+ i 4)) #\0)
                      #t)
                  (or (and (let ((c (##string-ref str i)))
                             (or (##char=? c #\i) (##char=? c #\I)))
                           (let ((c (##string-ref str (##fx+ i 1))))
                             (or (##char=? c #\n) (##char=? c #\N)))
                           (let ((c (##string-ref str (##fx+ i 2))))
                             (or (##char=? c #\f) (##char=? c #\F))))
                      (and ;; (##not (##char=? sign #\-))
                           (let ((c (##string-ref str i)))
                             (or (##char=? c #\n) (##char=? c #\N)))
                           (let ((c (##string-ref str (##fx+ i 1))))
                             (or (##char=? c #\a) (##char=? c #\A)))
                           (let ((c (##string-ref str (##fx+ i 2))))
                             (or (##char=? c #\n) (##char=? c #\N)))))
                  (##vector (##fx+ i (if (or (macro-r6rs-fp-syntax)
                                             (macro-chez-fp-syntax))
                                         5
                                         4))))
             #f)))

  (define (make-rec x y)
    (if (##eqv? y 0)
        x
        (macro-if-cpxnum
         (##make-rectangular x y)
         #f)))

  (define (make-pol x y e)
    (macro-if-cpxnum
     (let ((n (##make-polar x y)))
       (if (##eq? e 'e)
           (##inexact->exact n)
           n))
     (if (##eqv? y 0)
         (if (##eq? e 'e)
             (##inexact->exact x)
             x)
         #f)))

  (define (make-inexact-real sign uinteger exponent)
    (let ((n
           (if (and (##fixnum? uinteger)
                    (##fixnum->flonum-exact? uinteger)
                    (##fixnum? exponent)
                    (##fx< (##fx- exponent)
                           (##f64vector-length exact-10^n-table))
                    (##fx< exponent
                           (##f64vector-length exact-10^n-table)))
               (if (##fx< exponent 0)
                   (##fl/ (##fixnum->flonum uinteger)
                          (##f64vector-ref exact-10^n-table
                                           (##fx- exponent)))
                   (##fl* (##fixnum->flonum uinteger)
                          (##f64vector-ref exact-10^n-table
                                           exponent)))
               (##exact->inexact
                (##* uinteger
                     (##exact-int.expt 10 exponent))))))
      (if (##char=? sign #\-)
          (##flcopysign n (macro-inexact--1))
          n)))

  (define (get-zero e)
    (if (##eq? e 'i)
        (macro-inexact-+0)
        0))

  (define (get-one sign e)
    (if (##eq? e 'i)
        (if (##char=? sign #\-) (macro-inexact--1) (macro-inexact-+1))
        (if (##char=? sign #\-) -1 1)))

  (define (get-real start sign str rad e i)
    (if (##fixnum? i)
        (let* ((abs-n
                (substring->uinteger str rad start i))
               (n
                (if (##char=? sign #\-)
                    (##negate abs-n)
                    abs-n)))
          (if (or (##eq? e 'i)
                  (and (##not e)
                       (##char=? (##string-ref str (##fx- i 1)) #\#)))
              (##exact->inexact n)
              n))
        (let ((j (##vector-ref i 0))
              (len (##vector-length i)))
          (cond ((##fx= len 3) ;; xxx.yyyEzzz
                 (let* ((after-frac-part
                         (##vector-ref i 1))
                        (unadjusted-exponent
                         (if (##fx= after-frac-part j) ;; no exponent part?
                             0
                             (let* ((c
                                     (##string-ref
                                      str
                                      (##fx+ after-frac-part 1)))
                                    (n
                                     (substring->uinteger
                                      str
                                      10
                                      (if (or (##char=? c #\+) (##char=? c #\-))
                                          (##fx+ after-frac-part 2)
                                          (##fx+ after-frac-part 1))
                                      j)))
                               (if (##char=? c #\-)
                                   (##negate n)
                                   n))))
                        (c
                         (##string-ref str start))
                        (uinteger
                         (float-substring->uinteger str start after-frac-part))
                        (decimals-after-point
                         (##fx-
                          (##fx- after-frac-part (##vector-ref i 2))
                          1))
                        (exponent
                         (if (##fx< 0 decimals-after-point)
                             (if (and (##fixnum? unadjusted-exponent)
                                      (##fx< (##fx- unadjusted-exponent
                                                    decimals-after-point)
                                             unadjusted-exponent))
                                 (##fx- unadjusted-exponent
                                        decimals-after-point)
                                 (##- unadjusted-exponent
                                      decimals-after-point))
                             unadjusted-exponent)))
                   (if (##eq? e 'e)
                       (##*
                        (if (##char=? sign #\-)
                            (##negate uinteger)
                            uinteger)
                        (##exact-int.expt 10 exponent))
                       (make-inexact-real sign uinteger exponent))))
                ((##fx= len 2) ;; xxx/yyy
                 (let* ((after-num
                         (##vector-ref i 1))
                        (inexact-num?
                         (or (##eq? e 'i)
                             (and (##not e)
                                  (or (##char=? (##string-ref
                                                 str
                                                 (##fx- after-num 1))
                                                #\#)
                                      (##char=? (##string-ref
                                                 str
                                                 (##fx- j 1))
                                                #\#)))))
                        (abs-num
                         (substring->uinteger str rad start after-num))
                        (den
                         (substring->uinteger str
                                              rad
                                              (##fx+ after-num 1)
                                              j)))

                   (define (num-div-den)
                     (##/ (if (##char=? sign #\-)
                              (##negate abs-num)
                              abs-num)
                          den))

                   (if inexact-num?
                       (if (##eqv? den 0)
                           (let ((n
                                  (if (##eqv? abs-num 0)
                                      (macro-inexact-+nan)
                                      (macro-inexact-+inf))))
                             (if (##char=? sign #\-)
                                 (##flcopysign n (macro-inexact--1))
                                 n))
                           (##exact->inexact (num-div-den)))
                       (num-div-den))))
                (else ;; (##fx= len 1) ;; inf or nan
                 (let* ((c
                         (##string-ref str start))
                        (n
                         (if (or (##char=? c #\i) (##char=? c #\I))
                             (macro-inexact-+inf)
                             (macro-inexact-+nan))))
                   (if (##char=? sign #\-)
                       (##flcopysign n (macro-inexact--1))
                       n)))))))

  (define (i-end str i)
    (and (##fx= (##fx+ i 1) (##string-length str))
         (let ((c (##string-ref str i)))
           (or (##char=? c #\i) (##char=? c #\I)))))

  (define (complex start sign str rad e i)
    (let ((j (if (##fixnum? i) i (##vector-ref i 0))))
      (let ((c (##string-ref str j)))
        (cond ((##char=? c #\@)
               (let ((j+1 (##fx+ j 1)))
                 (if (##fx< j+1 (##string-length str))
                     (let* ((sign2
                             (##string-ref str j+1))
                            (start2
                             (if (or (##char=? sign2 #\+) (##char=? sign2 #\-))
                                 (##fx+ j+1 1)
                                 j+1))
                            (k
                             (or (ureal str rad e start2)
                                 (and (##fx< j+1 start2)
                                      (inf-nan str sign2 start2 e)))))
                       (and k
                            (let ((l (if (##fixnum? k) k (##vector-ref k 0))))
                              (and (##fx= l (##string-length str))
                                   (or check-only?
                                       (make-pol
                                        (get-real start sign str rad e i)
                                        (get-real start2 sign2 str rad e k)
                                        e))))))
                     #f)))
              ((or (##char=? c #\+) (##char=? c #\-))
               (let* ((start2
                       (##fx+ j 1))
                      (k
                       (or (ureal str rad e start2)
                           (inf-nan str c start2 e))))
                 (if (##not k)
                     (if (i-end str start2)
                         (or check-only?
                             (make-rec
                              (get-real start sign str rad e i)
                              (get-one c e)))
                         #f)
                     (let ((l (if (##fixnum? k) k (##vector-ref k 0))))
                       (and (i-end str l)
                            (or check-only?
                                (make-rec
                                 (get-real start sign str rad e i)
                                 (get-real start2 c str rad e k))))))))
              (else
               #f)))))

  (define (after-prefix start str rad e)

    ;; invariant: start = 0, 2 or 4, (string-length str) > start

    (let ((c (##string-ref str start)))
      (if (or (##char=? c #\+) (##char=? c #\-))
          (let ((i (or (ureal str rad e (##fx+ start 1))
                       (inf-nan str c (##fx+ start 1) e))))
            (if (##not i)
                (if (i-end str (##fx+ start 1))
                    (or check-only?
                        (make-rec
                         (get-zero e)
                         (get-one c e)))
                    #f)
                (let ((j (if (##fixnum? i) i (##vector-ref i 0))))
                  (cond ((##fx= j (##string-length str))
                         (or check-only?
                             (get-real (##fx+ start 1) c str rad e i)))
                        ((i-end str j)
                         (or check-only?
                             (make-rec
                              (get-zero e)
                              (get-real (##fx+ start 1) c str rad e i))))
                        (else
                         (complex (##fx+ start 1) c str rad e i))))))
          (let ((i (ureal str rad e start)))
            (if (##not i)
                #f
                (let ((j (if (##fixnum? i) i (##vector-ref i 0))))
                  (cond ((##fx= j (##string-length str))
                         (or check-only?
                             (get-real start #\+ str rad e i)))
                        (else
                         (complex start #\+ str rad e i)))))))))

  (define (radix-prefix c)
    (cond ((or (##char=? c #\b) (##char=? c #\B))  2)
          ((or (##char=? c #\o) (##char=? c #\O))  8)
          ((or (##char=? c #\d) (##char=? c #\D)) 10)
          ((or (##char=? c #\x) (##char=? c #\X)) 16)
          (else                                   #f)))

  (define (exactness-prefix c)
    (cond ((or (##char=? c #\i) (##char=? c #\I)) 'i)
          ((or (##char=? c #\e) (##char=? c #\E)) 'e)
          (else                                   #f)))

  (cond ((##fx< 2 (##string-length str)) ;; >= 3 chars
         (if (##char=? (##string-ref str 0) #\#)
             (let ((rad1 (radix-prefix (##string-ref str 1))))
               (if rad1
                   (if (and (##fx< 4 (##string-length str)) ;; >= 5 chars
                            (##char=? (##string-ref str 2) #\#))
                       (let ((e1 (exactness-prefix (##string-ref str 3))))
                         (if e1
                             (after-prefix 4 str rad1 e1)
                             #f))
                       (after-prefix 2 str rad1 #f))
                   (let ((e2 (exactness-prefix (##string-ref str 1))))
                     (if e2
                         (if (and (##fx< 4 (##string-length str)) ;; >= 5 chars
                                  (##char=? (##string-ref str 2) #\#))
                             (let ((rad2 (radix-prefix (##string-ref str 3))))
                               (if rad2
                                   (after-prefix 4 str rad2 e2)
                                   #f))
                             (after-prefix 2 str rad e2))
                         #f))))
             (after-prefix 0 str rad #f)))
        ((##fx< 0 (##string-length str)) ;; >= 1 char
         (after-prefix 0 str rad #f))
        (else
         #f)))

(define-prim (##string->number str #!optional (rad 10) (check-only? #f))
  (if (and (##fx= rad 10) (##not check-only?))
      (or (macro-string->number-decimal-fast-path str)
          (##string->number-slow-path str rad check-only?))
      (##string->number-slow-path str rad check-only?)))

(define-prim (string->number str #!optional (r (macro-absent-obj)))
  (macro-force-vars (str r)
    (macro-check-string str 1 (string->number str r)
      (let ((rad (if (##eq? r (macro-absent-obj)) 10 r)))
        (if (macro-exact-int? rad)
            (if (or (##eqv? rad 2)
                    (##eqv? rad 8)
                    (##eqv? rad 10)
                    (##eqv? rad 16))
                (##string->number str rad #f)
                (##raise-range-exception 2 string->number str r))
            (##fail-check-exact-integer 2 string->number str r))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Bitwise operations.

(define-prim (##bitwise-ior2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (define (bignum-bitwise-ior-loop x result n)
    (##declare (not interrupts-enabled))
    (let loop ((i (##fx- n 1)))
      (if (##fx< i 0)
          (##bignum.normalize! result)
          (begin
            (##bignum.adigit-bitwise-ior! result i x i)
            (loop (##fx- i 1))))))

  (define (bignum-bitwise-ior x x-length y y-length)
    ;; x-length <= y-length
    (if (##bignum.negative? x)
        (bignum-bitwise-ior-loop y (##bignum.copy x) x-length)
        (bignum-bitwise-ior-loop x (##bignum.copy y) x-length)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxior x y)
      (let* ((x-bignum (##fixnum->bignum x))
             (x-length (##bignum.adigit-length x-bignum))
             (y-length (##bignum.adigit-length y)))
        (bignum-bitwise-ior x-bignum x-length y y-length)))

    (let ((x-length (##bignum.adigit-length x))) ;; x = bignum
      (macro-exact-int-dispatch y (type-error-on-y)
        (let* ((y-bignum (##fixnum->bignum y))
               (y-length (##bignum.adigit-length y-bignum)))
          (bignum-bitwise-ior y-bignum y-length x x-length))
        (let ((y-length (##bignum.adigit-length y)))
          (if (##fx< x-length y-length)
              (bignum-bitwise-ior x x-length y y-length)
              (bignum-bitwise-ior y y-length x x-length)))))))

(define-prim-nary (##bitwise-ior x y)
  0
  x
  (##bitwise-ior2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (bitwise-ior x y)
  0
  (if (macro-exact-int? x) x '(1))
  (##bitwise-ior2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-exact-integer))

(define-prim (##bitwise-xor2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (define (bignum-bitwise-xor x x-length y y-length)
    (let ((result (##bignum.copy y)))
      (##declare (not interrupts-enabled))
      (let loop1 ((i 0))
        (if (##fx< i x-length)
            (begin
              (##bignum.adigit-bitwise-xor! result i x i)
              (loop1 (##fx+ i 1)))
            (if (##bignum.negative? x)
                (let loop2 ((i i))
                  (if (##fx< i y-length)
                      (begin
                        (##bignum.adigit-bitwise-not! result i)
                        (loop2 (##fx+ i 1)))
                      (##bignum.normalize! result)))
                (##bignum.normalize! result))))))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxxor x y)
      (let* ((x-bignum (##fixnum->bignum x))
             (x-length (##bignum.adigit-length x-bignum))
             (y-length (##bignum.adigit-length y)))
        (bignum-bitwise-xor x-bignum x-length y y-length)))

    (let ((x-length (##bignum.adigit-length x))) ;; x = bignum
      (macro-exact-int-dispatch y (type-error-on-y)
        (let* ((y-bignum (##fixnum->bignum y))
               (y-length (##bignum.adigit-length y-bignum)))
          (bignum-bitwise-xor y-bignum y-length x x-length))
        (let ((y-length (##bignum.adigit-length y)))
          (if (##fx< x-length y-length)
              (bignum-bitwise-xor x x-length y y-length)
              (bignum-bitwise-xor y y-length x x-length)))))))

(define-prim-nary (##bitwise-xor x y)
  0
  x
  (##bitwise-xor2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (bitwise-xor x y)
  0
  (if (macro-exact-int? x) x '(1))
  (##bitwise-xor2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-exact-integer))

(define-prim (##bitwise-and2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (define (bignum-bitwise-and-loop x result n)
    (##declare (not interrupts-enabled))
    (let loop ((i (##fx- n 1)))
      (if (##fx< i 0)
          (##bignum.normalize! result)
          (begin
            (##bignum.adigit-bitwise-and! result i x i)
            (loop (##fx- i 1))))))

  (define (bignum-bitwise-and x x-length y y-length)
    ;; x-length <= y-length
    (if (##bignum.negative? x)
        (bignum-bitwise-and-loop x (##bignum.copy y) x-length)
        (bignum-bitwise-and-loop y (##bignum.copy x) x-length)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxand x y)
      (let* ((x-bignum (##fixnum->bignum x))
             (x-length (##bignum.adigit-length x-bignum))
             (y-length (##bignum.adigit-length y)))
        (bignum-bitwise-and x-bignum x-length y y-length)))

    (let ((x-length (##bignum.adigit-length x))) ;; x = bignum
      (macro-exact-int-dispatch y (type-error-on-y)
        (let* ((y-bignum (##fixnum->bignum y))
               (y-length (##bignum.adigit-length y-bignum)))
          (bignum-bitwise-and y-bignum y-length x x-length))
        (let ((y-length (##bignum.adigit-length y)))
          (if (##fx< x-length y-length)
              (bignum-bitwise-and x x-length y y-length)
              (bignum-bitwise-and y y-length x x-length)))))))

(define-prim-nary (##bitwise-and x y)
  -1
  x
  (##bitwise-and2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (bitwise-and x y)
  -1
  (if (macro-exact-int? x) x '(1))
  (##bitwise-and2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-exact-integer))

(define-prim (##bitwise-not x)

  (define (type-error)
    (##fail-check-exact-integer 1 bitwise-not x))

  (macro-exact-int-dispatch x (type-error)
    (##fxnot x)
    (##bignum.make (##bignum.adigit-length x) x #t)))  ;; don't copy, bitwise invert

(define-prim (bitwise-not x)
  (macro-force-vars (x)
    (##bitwise-not x)))

(define-prim (##bitwise-andc1 x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 bitwise-andc1 x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 bitwise-andc1 x y))

  (define (bignum-case x y)
    ;; TODO: compute using a single loop over the arguments
    (##bitwise-and2 (##bitwise-not x) y))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxandc1 x y)
      (bignum-case x y))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (bignum-case x y)
      (bignum-case x y))))

(define-prim (bitwise-andc1 x y)
  (macro-force-vars (x y)
    (##bitwise-andc1 x y)))

(define-prim (##bitwise-andc2 x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 bitwise-andc2 x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 bitwise-andc2 x y))

  (define (bignum-case x y)
    ;; TODO: compute using a single loop over the arguments
    (##bitwise-and2 x (##bitwise-not y)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxandc2 x y)
      (bignum-case x y))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (bignum-case x y)
      (bignum-case x y))))

(define-prim (bitwise-andc2 x y)
  (macro-force-vars (x y)
    (##bitwise-andc2 x y)))

(define-prim (##bitwise-nand x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 bitwise-nand x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 bitwise-nand x y))

  (define (bignum-case x y)
    ;; TODO: compute using a single loop over the arguments
    (##bitwise-not (##bitwise-and2 x y)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxnand x y)
      (bignum-case x y))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (bignum-case x y)
      (bignum-case x y))))

(define-prim (##bitwise-eqv2 x y)

  (##define-macro (type-error-on-x) `'(1))
  (##define-macro (type-error-on-y) `'(2))

  (define (bignum-case x y)
    ;; TODO: compute using a single loop over the arguments
    (##bitwise-not (##bitwise-xor2 x y)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxeqv x y)
      (bignum-case x y))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (bignum-case x y)
      (bignum-case x y))))

(define-prim-nary (##bitwise-eqv x y)
  0
  x
  (##bitwise-eqv2 x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (bitwise-eqv x y)
  0
  (if (macro-exact-int? x) x '(1))
  (##bitwise-eqv2 x y)
  macro-force-vars
  macro-no-check
  (##pair? ##fail-check-exact-integer))

(define-prim (bitwise-nand x y)
  (macro-force-vars (x y)
    (##bitwise-nand x y)))

(define-prim (##bitwise-nor x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 bitwise-nor x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 bitwise-nor x y))

  (define (bignum-case x y)
    ;; TODO: compute using a single loop over the arguments
    (##bitwise-not (##bitwise-ior2 x y)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxnor x y)
      (bignum-case x y))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (bignum-case x y)
      (bignum-case x y))))

(define-prim (bitwise-nor x y)
  (macro-force-vars (x y)
    (##bitwise-nor x y)))

(define-prim (##bitwise-orc1 x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 bitwise-orc1 x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 bitwise-orc1 x y))

  (define (bignum-case x y)
    ;; TODO: compute using a single loop over the arguments
    (##bitwise-ior2 (##bitwise-not x) y))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxorc1 x y)
      (bignum-case x y))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (bignum-case x y)
      (bignum-case x y))))

(define-prim (bitwise-orc1 x y)
  (macro-force-vars (x y)
    (##bitwise-orc1 x y)))

(define-prim (##bitwise-orc2 x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 bitwise-orc2 x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 bitwise-orc2 x y))

  (define (bignum-case x y)
    ;; TODO: compute using a single loop over the arguments
    (##bitwise-ior2 x (##bitwise-not y)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (##fxorc2 x y)
      (bignum-case x y))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (bignum-case x y)
      (bignum-case x y))))

(define-prim (bitwise-orc2 x y)
  (macro-force-vars (x y)
    (##bitwise-orc2 x y)))

(define-prim (##arithmetic-shift x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 arithmetic-shift x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 arithmetic-shift x y))

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception arithmetic-shift x y))

  (define (overflow)
    (##raise-heap-overflow-exception)
    (##arithmetic-shift x y))

  (define (general-fixnum-fixnum-case)
    (macro-if-bignum
     (##bignum.arithmetic-shift (##fixnum->bignum x) y)
     (fixnum-overflow)))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (cond ((##fxzero? y)
             x)
            ((##fxnegative? y) ;; right shift
             (if (##fx< (##fx- ##fixnum-width) y)
                 (##fxarithmetic-shift-right x (##fx- y))
                 (if (##fxnegative? x)
                     -1
                     0)))
            (else ;; left shift
             (or (and (##fx< y ##fixnum-width)
                      (##fxarithmetic-shift-left? x y))
                 (general-fixnum-fixnum-case))))
      (cond ((##fxzero? x)
             0)
            ((##bignum.negative? y)
             (if (##fxnegative? x)
                 -1
                 0))
            (else
             (overflow))))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (cond ((##fxzero? y)
             x)
            (else
             (##bignum.arithmetic-shift x y)))
      (cond ((##bignum.negative? y)
             (if (##bignum.negative? x)
                 -1
                 0))
            (else
             (overflow))))))

(define-prim (arithmetic-shift x y)
  (macro-force-vars (x y)
    (##arithmetic-shift x y)))

(define-prim (##bit-count x)

  (define (type-error)
    (##fail-check-exact-integer 1 bit-count x))

  (macro-exact-int-dispatch x (type-error)
    (##fxbit-count x)
    (let ((x-length (##bignum.mdigit-length x)))
      (let loop ((i (##fx- x-length 1))
                 (n 0))
        (if (##fx< i 0)
            (if (##bignum.negative? x)
                (##fx- (##fx* x-length ##bignum.mdigit-width) n)
                n)
            (loop (##fx- i 1)
                  (##fx+ n (##fxbit-count (##bignum.mdigit-ref x i)))))))))

(define-prim (bit-count x)
  (macro-force-vars (x)
    (##bit-count x)))

(define-prim (##integer-length x)

  (define (type-error)
    (##fail-check-exact-integer 1 integer-length x))

  (macro-exact-int-dispatch x (type-error)
    (##fxlength x)
    (let ((x-length (##bignum.mdigit-length x)))
      (if (##bignum.negative? x)
          (let loop1 ((i (##fx- x-length 1)))
            (let ((mdigit (##bignum.mdigit-ref x i)))
              (if (##fx= mdigit ##bignum.mdigit-base-minus-1)
                  (loop1 (##fx- i 1))
                  (##fx+
                   (##fxlength (##fx- ##bignum.mdigit-base-minus-1 mdigit))
                   (##fx* i ##bignum.mdigit-width)))))
          (let loop2 ((i (##fx- x-length 1)))
            (let ((mdigit (##bignum.mdigit-ref x i)))
              (if (##fx= mdigit 0)
                  (loop2 (##fx- i 1))
                  (##fx+
                   (##fxlength mdigit)
                   (##fx* i ##bignum.mdigit-width)))))))))

(define-prim (integer-length x)
  (macro-force-vars (x)
    (##integer-length x)))

(define-prim (##bitwise-merge x y z)
  (##bitwise-ior2 (##bitwise-and2 (##bitwise-not x) y)
                  (##bitwise-and2 x z)))

(define-prim (bitwise-merge x y z)
  (macro-force-vars
   (x y z)
   (macro-check-exact-integer
    x 1 (bitwise-merge x y z)
    (macro-check-exact-integer
     y 2 (bitwise-merge x y z)
     (macro-check-exact-integer
      z 3 (bitwise-merge x y z)
      (##bitwise-merge x y z))))))

(define-prim (##bit-set? x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 bit-set? x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 bit-set? x y))

  (define (range-error)
    (##raise-range-exception 1 bit-set? x y))

  (macro-exact-int-dispatch x (type-error-on-x)

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
      (if (##fxnegative? x)
          (range-error)
          (if (##fx< x ##fixnum-width)
              (##fxodd? (##fxarithmetic-shift-right y x))
              (##fxnegative? y)))
      (if (##fxnegative? x)
          (range-error)
          (let ((i (##bignum.mdigit-div x)))
            (if (##fx< i (##bignum.mdigit-length y))
                (##fxodd?
                 (##fxarithmetic-shift-right
                  (##bignum.mdigit-ref y i)
                  (##bignum.mdigit-mod x)))
                (##bignum.negative? y)))))

    (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
      (if (##bignum.negative? x)
          (range-error)
          (##fxnegative? y))
      (if (##bignum.negative? x)
          (range-error)
          (##bignum.negative? y)))))

(define-prim (bit-set? x y)
  (macro-force-vars (x y)
    (##bit-set? x y)))

(define-prim (##any-bits-set? x y)
  (##not (##eqv? (##bitwise-and2 x y) 0)))

(define-prim (any-bits-set? x y)
  (macro-force-vars
   (x y)
   (macro-check-exact-integer
    x 1 (any-bits-set? x y)
    (macro-check-exact-integer
     y 2 (any-bits-set? x y)
     (##any-bits-set? x y)))))

(define-prim (##all-bits-set? x y)
  (##= x (##bitwise-and2 x y)))

(define-prim (all-bits-set? x y)
  (macro-force-vars
   (x y)
   (macro-check-exact-integer
    x 1 (all-bits-set? x y)
    (macro-check-exact-integer
     y 2 (all-bits-set? x y)
     (##all-bits-set? x y)))))

(define-prim (##first-set-bit x)

  (define (type-error)
    (##fail-check-exact-integer 1 first-set-bit x))

  (macro-exact-int-dispatch x (type-error)
    (##fxfirst-set-bit x)
    (let ((x-length (##bignum.mdigit-length x)))
      (let loop ((i 0))
        (let ((mdigit (##bignum.mdigit-ref x i)))
          (if (##fx= mdigit 0)
              (loop (##fx+ i 1))
              (##fx+
               (##fxfirst-set-bit mdigit)
               (##fx* i ##bignum.mdigit-width))))))))

(define-prim (first-set-bit x)
  (macro-force-vars (x)
    (##first-set-bit x)))

(define (##bignum.extract-bit-field size position n)

  ;; n is a (possibly unnormalized) nonzero bignum, size and position are nonnegative exact integers

  (let* ((result-bit-length
          (cond ((##positive? n)
                 (##fx+ 1 (##min size (##max 0 (##- (##integer-length n) position)))))
                ((##not (and (##fixnum? size)
                             (##fx< size ##max-fixnum)))
                 (##raise-heap-overflow-exception))
                (else
                 (##fx+ 1 size))))
         (result-word-length
          (##bignum.adigit-div (##fx+ result-bit-length ##bignum.adigit-width -1)))
         (result
          (##bignum.arithmetic-shift-into!
           n (##max ##min-fixnum (##- position)) (##bignum.make result-word-length #f #f))))
    ;; zero top bits of result and normalize
    (let ((size-words (##bignum.mdigit-div size))
          (size-bits  (##bignum.mdigit-mod size)))
      (##declare (not interrupts-enabled))
      (let loop ((i (##fx- (##bignum.mdigit-length result) 1)))
        (if (##fx< size-words i)
            (begin
              (##bignum.mdigit-set! result i 0)
              (loop (##fx- i 1)))
            (if (##fx= size-words i)
                (##bignum.mdigit-set!
                 result i
                 (##fxand
                  (##bignum.mdigit-ref result i)
                  (##fxnot (##fxarithmetic-shift-left -1 size-bits))))))
        (##bignum.normalize! result)))))

(define-prim&proc (extract-bit-field (size     nonnegative-exact-integer)
                                     (position nonnegative-exact-integer)
                                     (n        exact-integer))

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception extract-bit-field size position n))

  (define (general-fixnum-case)
    (macro-if-bignum
     (##bignum.extract-bit-field size position (##fixnum->bignum n))
     (fixnum-overflow)))

  (cond ((##eqv? size 0)
         0)
        ;; The next case can come up in Karatsuba multiplication,
        ;; (##eq? (##arithmetic-shift n 0) n) => #t
        ((and (##not (##negative? n))
              (##< (##- (##integer-length n) size) ;; a fixnum, if size is a fixnum
                   position))
         (##arithmetic-shift n (##- position)))
        (else
         (macro-exact-int-dispatch-no-error
          n
          ;; The next bit is a bit tricky, since it still has to work
          ;; if size and/or position are bignums.
          (cond ((##< size ##fixnum-width)
                 (##fxand (##bit-mask size) (##arithmetic-shift n (##- position))))
                ((##fxnegative? n)
                 (general-fixnum-case))
                (else
                 (##arithmetic-shift n (##- position))))
          (##bignum.extract-bit-field size position n)))))

(define-prim&proc (test-bit-field? (size     nonnegative-exact-integer)
                                   (position nonnegative-exact-integer)
                                   (n        exact-integer))

  (define (general-case)
    (##not (##eqv? 0 (##extract-bit-field size position n))))

  (and (##not (##eqv? 0 size))
       (##not (##eqv? 0 n))
       (if (##negative? n)
           (or (##< (##- (##integer-length n) size) ;; a fixnum, if size is a fixnum
                    position)
               (general-case))
           (and (##< position (##integer-length n))
                (general-case)))))

(define-prim&proc (clear-bit-field (size     nonnegative-exact-integer)
                                   (position nonnegative-exact-integer)
                                   (n        exact-integer))
  (##replace-bit-field size position 0 n))

(define-prim&proc (replace-bit-field (size     nonnegative-exact-integer)
                                     (position nonnegative-exact-integer)
                                     (newfield exact-integer)
                                     (n        exact-integer))
  (let ((m (##bit-mask size)))
    (##bitwise-ior2
     (##bitwise-and2 n (##bitwise-not (##arithmetic-shift m position)))
     (##arithmetic-shift (##bitwise-and2 newfield m) position))))

(define-prim&proc (copy-bit-field (size     nonnegative-exact-integer)
                                  (position nonnegative-exact-integer)
                                  (from     exact-integer)
                                  (to       exact-integer))
  (##bitwise-merge
   (##arithmetic-shift (##bit-mask size) position)
   to
   from))

(define-prim (##bit-mask size)
  (##bitwise-not (##arithmetic-shift -1 size)))

(define-procedure (bits . (bool boolean))
  (let loop ((lst bool) (pow2 1) (result 0))
    (if (pair? lst)
        (let ((elem (car lst)))
          (macro-check-boolean elem (integer-length pow2) ((%procedure%) . bool)
            (loop (cdr lst)
                  (arithmetic-shift pow2 1)
                  (if elem
                      (+ result pow2)
                      result))))
        result)))

(define-procedure (list->bits (list list))
  (let loop ((lst list) (pow2 1) (result 0))
    (if (pair? lst)
        (let ((elem (car lst)))
          (macro-check-boolean-list-boolean elem '(1 . list) ((%procedure%) list)
            (loop (cdr lst)
                  (arithmetic-shift pow2 1)
                  (if elem
                      (+ result pow2)
                      result))))
        (macro-check-proper-list-null* lst list '(1 . list) ((%procedure%) list)
          result))))

(define-procedure (vector->bits (vector boolean-vector))
  (let ((len (vector-length vector)))
    (let loop ((i (fx- len 1)) (result 0))
      (if (fx< i 0)
          result
          (let ((elem (vector-ref vector i)))
            (macro-check-boolean-vector-boolean elem '(1 . vector) ((%procedure%) vector)
              (let ((result*2 (arithmetic-shift result 1)))
                (loop (fx- i 1)
                      (if elem
                          (+ result*2 1)
                          result*2)))))))))

(define-procedure (bits->list (i   exact-integer)
                              (len index (integer-length i)))
  (let loop ((j (fx- len 1)) (result '()))
    (if (fx< j 0)
        result
        (loop (fx- j 1)
              (cons (bit-set? j i) result)))))

(define-procedure (bits->vector (i   exact-integer)
                                (len index (integer-length i)))
  (let ((vect (make-vector len #f)))
    (let loop ((j (fx- len 1)))
      (if (fx< j 0)
          vect
          (begin
            (if (bit-set? j i)
                (vector-set! vect j #t))
            (loop (fx- j 1)))))))

;;;---------------------------------------------------------------------------
;;;===========================================================================
;;;
;;; Bitwise Operations
;;;
;;;===========================================================================
;;;
;;;---------------------------------------------------------------------------
;;; These operations are listed in the same way as in
;;; https://srfi.schemers.org/srfi-151/srfi-151.html
;;; Code for procedures already in _num.scm is not included here.
;;;
;;; bitwise-not
;;; bitwise-and   bitwise-ior
;;; bitwise-xor   bitwise-eqv
;;; bitwise-nand  bitwise-nor
;;; bitwise-andc1 bitwise-andc2
;;; bitwise-orc1  bitwise-orc2
;;;
;;; arithmetic-shift bit-count
;;; integer-length bitwise-if
;;;---------------------------------------------------------------------------


(define-prim&proc (bitwise-if (x exact-integer)
                              (y exact-integer)
                              (z exact-integer))
  (##bitwise-ior2 (##bitwise-and2 x y)
                  (##bitwise-and2 (##bitwise-not x) z)))

;;;---------------------------------------------------------------------------
;;; bit-set? copy-bit bit-swap
;;;---------------------------------------------------------------------------

(define-prim&proc (copy-bit (ind  index)
                            (i    exact-integer)
                            (bool boolean))

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception copy-bit ind i bool))

  (define (general-case)
    (macro-if-bignum
     (##bitwise-xor2 i (##arithmetic-shift 1 ind))
     (fixnum-overflow)))

  (if (##eq? bool (##bit-set? ind i))
      i
      (macro-exact-int-dispatch-no-error
       i
       ;; i a fixnum
       (if (##< ind ##fixnum-width)
           (##fxxor i (##fxarithmetic-shift-left 1 ind))
           (general-case))
       ;; i a bignum
       (general-case))))

(define-prim&proc (bit-swap (ind1 index)
                            (ind2 index)
                            (i exact-integer))
  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception bit-swap ind i bool))

  (define (general-case)
    (macro-if-bignum
     (##bitwise-xor2 (##bitwise-ior2 (##arithmetic-shift 1 ind1)
                                     (##arithmetic-shift 1 ind2))
                    i)
     (fixnum-overflow)))

  (if (##eq? (##bit-set? ind1 i)
             (##bit-set? ind2 i))
      i
      (macro-exact-int-dispatch-no-error
       i
       (if (and (##fx< ind1 ##fixnum-width)
                (##fx< ind2 ##fixnum-width))
           (##fxxor (##fxior (##fxarithmetic-shift-left 1 ind1)
                             (##fxarithmetic-shift-left 1 ind2))
                    i)
           (general-case))
       (general-case))))

;;;---------------------------------------------------------------------------
;;; any-bit-set? every-bit-set?
;;;---------------------------------------------------------------------------

(define-prim&proc (any-bit-set? (test-bits exact-integer)
                                (i         exact-integer))
  (##not (##eqv? (##bitwise-and2 test-bits i) 0)))

(define-prim&proc (every-bit-set? (test-bits exact-integer)
                                  (i         exact-integer))
  (##eqv? (##bitwise-and2 test-bits i) test-bits))

;;;---------------------------------------------------------------------------
;;; first-set-bit
;;;
;;; bit-field bit-field-any? bit-field-every?
;;;---------------------------------------------------------------------------

(define-prim&proc (bit-field (i     exact-integer)
                             (start index)
                             (end   index))
  (if (##fx> start end)
      (##raise-range-exception end bit-field i start end)
      (let ((size (##- end start)))

        (define (fixnum-overflow)
          (##raise-fixnum-overflow-exception bit-field i start end))

        (define (general-fixnum-case)
          (macro-if-bignum
           (##extract-bit-field size start (##fixnum->bignum i))
           (fixnum-overflow)))

        (cond ((##eqv? size 0)
               0)
              ((and (##not (##negative? i))
                    (##fx< (##fx- (##integer-length i) size)
                           start))
               (##arithmetic-shift i (##- start)))
              (else
               (macro-exact-int-dispatch-no-error
                i
                (cond ((##fx< size ##fixnum-width)
                       (##fxand (##bit-mask size) (##fxarithmetic-shift-right i start)))
                      ((##fxnegative? i)
                       (general-fixnum-case))
                      (else
                       (##fxarithmetic-shift-right i start)))
                (##extract-bit-field size start i)))))))

(define-prim&proc (bit-field-any? (i     exact-integer)
                                  (start index)
                                  (end   index))
  (if (##fx> start end)
      (##raise-range-exception end bit-field-any? i start end)
      (let ((size (##- end start)))
        (if (##eqv? size 0)
            #f
            (macro-exact-int-dispatch-no-error
             i
             ;; fixnum
             (##not
              ;; seems easier to check that no bits are set
              (if (##fx< size ##fixnum-width)
                  (##eqv? 0 (##fxand (##bit-mask size)
                                     (##arithmetic-shift i (##- start))))
                  (##eqv? 0 (##arithmetic-shift i (##- start)))))
             ;; bignum
             (##not (##eqv? 0 (##bitwise-and2 (##bit-mask size)
                                             (##arithmetic-shift i (##- start))))))))))

(define-prim&proc (bit-field-every? (i     exact-integer)
                                    (start index)
                                    (end   index))
  (if (##fx> start end)
      (##raise-range-exception end bit-field-any? i start end)
      (let ((size (##- end start)))
        (if (##eqv? size 0)
            #t
            (macro-exact-int-dispatch-no-error
             i
             ;; fixnum
             (if (##fx< size ##fixnum-width)
                 (let ((mask (##bit-mask size)))
                   (##eqv? mask (##fxand mask (##arithmetic-shift i (##- start)))))
                 (##eqv? -1 (##arithmetic-shift i (##- start))))
             ;; bignum
             (let ((mask (##bit-mask size)))
               (##eqv? mask (##bitwise-and2 mask (##arithmetic-shift i (##- start))))))))))

;;;---------------------------------------------------------------------------
;;; bit-field-clear bit-field-set
;;;---------------------------------------------------------------------------

(define-prim&proc (bit-field-clear (i     exact-integer)
                                   (start index)
                                   (end   index))

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception bit-field-clear i start end))

  (define (general-case size)
    (macro-if-bignum
     (##bitwise-and2 i (##bitwise-not (##fxarithmetic-shift-left (##bit-mask size) start)))
     (fixnum-overflow)))

  (if (##fx> start end)
      (##raise-range-exception end bit-field-clear i start end)
      (let ((size (##- end start)))
        (if (##eqv? size 0)
            i
            (macro-exact-int-dispatch-no-error
             i
             (cond ((##fx< end ##fixnum-width)
                    (##fxand i (##fxnot (##fxarithmetic-shift-left (##bit-mask size) start))))
                   ((##fxnegative? i)
                    (general-case size))
                   ((##fx< start ##fixnum-width)
                    (##fxand i (##fxnot (##fxarithmetic-shift-left -1 start))))
                   (else
                    i))
             (general-case size))))))

(define-prim&proc (bit-field-set (i     exact-integer)
                                 (start index)
                                 (end   index))

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception bit-field-set i start end))

  (define (general-case size)
    (macro-if-bignum
     (##bitwise-ior2 i (##fxarithmetic-shift-left (##bit-mask size) start))
     (fixnum-overflow)))

  (if (##fx> start end)
      (##raise-range-exception end bit-field-set i start end)
      (let ((size (##- end start)))
        (if (##eqv? size 0)
            i
            (macro-exact-int-dispatch-no-error
             i
             (cond ((##< end ##fixnum-width)
                    (##fxior i (##fxarithmetic-shift-left (##bit-mask size) start)))
                   ((##not (##fxnegative? i))
                    (general-case size))
                   ((##< start ##fixnum-width)
                    (##fxior i (##fxarithmetic-shift-left -1 start)))
                   (else
                    i))
             (general-case size))))))

;;;---------------------------------------------------------------------------
;;; bit-field-replace bit-field-replace-same
;;;---------------------------------------------------------------------------


(define-prim&proc (bit-field-replace (dest   exact-integer)
                                     (source exact-integer)
                                     (start  index)
                                     (end    index))

  (if (##fx> start end)
      (##raise-range-exception end bit-field-replace dest source start end)
      (let ((size (##- end start)))
        (if (##eqv? size 0)
            dest
            (##replace-bit-field size start source dest)))))

(define-prim&proc (bit-field-replace-same (dest   exact-integer)
                                          (source exact-integer)
                                          (start  index)
                                          (end    index))
  (##if (##fx> start end)
        (##raise-range-exception end bit-field-replace-same dest source start end)
        (let ((size (##- end start)))
          (if (##eqv? size 0)
              dest
              (##copy-bit-field size start source dest)))))

;;;---------------------------------------------------------------------------
;;; bit-field-rotate bit-field-reverse
;;;---------------------------------------------------------------------------

(define-prim&proc (bit-field-rotate (n     exact-integer)
                                    (count exact-integer); can be neg
                                    (start index)
                                    (end   index))
  (if (##< end start)
      (##raise-range-exception end bit-field-rotate n count start end)
      (let ((width (##fx- end start)))
        (if (##eqv? 0 width)
            n
            (let* ((count (##modulo count width))
                   (mask  (##bit-mask width))
                   (zn    (##bitwise-and2 mask (##arithmetic-shift n (##- start)))))
              (##bitwise-ior2
               (##arithmetic-shift
                (##bitwise-ior2
                 (##bitwise-and2
                  mask
                  (##arithmetic-shift zn count))
                 (##arithmetic-shift zn (##fx- count width)))
                start)
               (##bitwise-and2
                (##bitwise-not (##arithmetic-shift mask start))
                n)))))))

(define ##fdigits-per-adigit
  (##fxquotient ##bignum.adigit-width ##bignum.fdigit-width))

(macro-case-target
 ((C)
  (define-macro (macro-bit-reverse-table)

    (define (bit-reverse i)
      ;; 0 <= i <= (- ##bignum.fdigit-base 1)
      (let loop ((i i)
                 (result 0)
                 (bit 8))
        (if (eqv? bit 0)
            result
            (loop (fxarithmetic-shift-right i 1)
                  (fxior (fxarithmetic-shift-left result 1)
                         (fxand i 1))
                  (fx- bit 1)))))

    `',(list->vector
        (map bit-reverse (iota 256)))))
 (else
  (define-macro (macro-bit-reverse-table)

    (define (bit-reverse i)
      ;; 0 <= i <= (- ##bignum.fdigit-base 1)
      (let loop ((i i)
                 (result 0)
                 (bit 7))
        (if (eqv? bit 0)
            result
            (loop (fxarithmetic-shift-right i 1)
                  (fxior (fxarithmetic-shift-left result 1)
                         (fxand i 1))
                  (fx- bit 1)))))

    `',(list->vector
        (map bit-reverse (iota 128))))))

(define-prim&proc (bit-field-reverse (i     exact-integer)
                                     (start index)
                                     (end   index))

  (define (bit-reverse i)

    ;; 0 <= i <= (- bignum.fdigit-base 1)

    (define bit-reverse-table (macro-bit-reverse-table))

    (vector-ref bit-reverse-table i))

  (if (##fx< end start)
      (##raise-range-exception end bit-field-reverse i start end)
      (let ((width (##fx- end start)))
        (if (##eqv? width 0)
            i
            (let ((reversed-field
                   (let* ((field
                           (##bit-field i start end))
                          (field-fdigit-size
                           (##fxquotient (fx+ ##bignum.fdigit-width width -1)
                                         ##bignum.fdigit-width))
                          (field-bit-size
                           (##fx* field-fdigit-size ##bignum.fdigit-width)))
                     (if (##< field-bit-size ##fixnum-width)
                         ;; fixnum loop
                         (let loop ((f field)
                                    (s field-fdigit-size)
                                    (result 0))
                           (if (##eqv? s 0)
                               (##fxarithmetic-shift-right result (##fx- field-bit-size width))
                               (loop (##fxarithmetic-shift-right f ##bignum.fdigit-width)
                                     (##fx- s 1)
                                     (##fxior (##fxarithmetic-shift-left result ##bignum.fdigit-width)
                                              (bit-reverse (##fxand ##bignum.fdigit-mask f))))))
                         ;; bignum loop
                         (let* ((big-field
                                 (if (##fixnum? field)
                                     (##fixnum->bignum field)
                                     field))
                                (big-field-adigits   ;; want a zero adigit up top
                                 (##fx+ (##fxquotient (##fx+ field-fdigit-size ##fdigits-per-adigit -1)
                                                      ##fdigits-per-adigit)
                                        1))
                                (big-field-fdigits
                                 (##fx* big-field-adigits ##fdigits-per-adigit))
                                (result
                                 (##bignum.make big-field-adigits big-field #f)))
                           (let loop ((low 0)
                                      (high (##fx- big-field-fdigits 1)))
                             (if (##fx<= low high)
                                 (let ((temp (##bignum.fdigit-ref result low)))
                                   ;; redundant but correct when low = high
                                   (##bignum.fdigit-set! result low  (bit-reverse (##bignum.fdigit-ref result high)))
                                   (##bignum.fdigit-set! result high (bit-reverse temp))
                                   (loop (##fx+ low 1)
                                         (##fx- high 1)))
                                 (##arithmetic-shift (##bignum.normalize! result) (##fx- width (##fx* big-field-adigits ##bignum.adigit-width))))))))))
              (##bit-field-replace i reversed-field start end))))))

;;;---------------------------------------------------------------------------
;;; bits->list list->bits bits->vector vector->bits
;;; bits
;;; bitwise-fold bitwise-for-each bitwise-unfold
;;;---------------------------------------------------------------------------

(define-prim&proc (bitwise-fold (proc procedure)
                                (seed object)
                                (i    exact-integer))
  (macro-exact-int-dispatch-no-error
   i
   (let loop ((result seed)
              (i i)
              (N (##integer-length i)))
     (if (##eqv? N 0)
         result
         (loop (proc (##fxodd? i) result)
               (##fxarithmetic-shift-right i 1)
               (##fx- N 1))))
   ;; bignum; a linear algorithm in (integer-length i)
   (let ((N (##integer-length i)))
     (let loop ((k 0)
                (result seed))
       (if (##fx= k N)
           result
           (loop (##fx+ k 1)
                 (proc (##bit-set? k i) result)))))))

(define-prim&proc (bitwise-for-each (proc procedure)
                                    (i    exact-integer))
  (macro-exact-int-dispatch-no-error
   i
   ;; fixnum
   (let loop ((i i)
              (N (##integer-length i)))
     (if (##< 0 N)
         (begin
           (proc (##fxodd? i))
           (loop (##fxarithmetic-shift-right i 1)
                 (##fx- N 1)))))
   ;; bignum, a linear algorithm in (integer-legnth i)
   (let ((N (##integer-length i)))
     (let loop ((k 0))
       (if (##fx< k N)
           (begin
             (proc (##bit-set? k i))
             (loop (##fx+ k 1))))))))

(define-prim&proc (bitwise-unfold (stop?     procedure)
                                  (mapper    procedure)
                                  (successor procedure)
                                  (seed      object))

  (define (fixnum-overflow)
    (##raise-fixnum-overflow-exception bitwise-unfold stop? mapper successor seed))

  (let loop ((indices '())      ;; indices of 1 bits in result, in decreasing order
             (index 0)          ;; a bignum here is OK as long as no entries of indices are bignums
             (state seed))
    (if (stop? state)
        (if (or (null? indices)
                (< (car indices)            ;; largest index
                   (fx- ##fixnum-width 1))) ;; (expt 2 (- ##fixnum-width 1)) is not a fixnum
            ;; result is a fixnum
            (let inner ((result 0)
                        (indices indices))
              (if (null? indices)
                  result
                  (inner (fxior result
                                (fxarithmetic-shift-left 1 (car indices)))
                         (cdr indices))))
            ;; result is a bignum
            (macro-if-bignum
             (let* ((needed-bits
                     (+ (car indices)
                        ##bignum.adigit-width
                        -1))
                    (result
                     (if (fixnum? needed-bits)
                         ;; ##bignum.make requires a fixnum argument, and so does
                         ;; ##bignum.adigit-div.
                         (##bignum.make (##bignum.adigit-div needed-bits) #f #f)
                         ;; can't make a bignum this big.
                         (##raise-heap-overflow-exception))))
               (for-each (lambda (index)
                           (let ((mdigit-index  (##bignum.mdigit-div index))
                                 (mdigit-offset (##bignum.mdigit-mod index)))
                             (##bignum.mdigit-set! result
                                                   mdigit-index
                                                   (fxior (##bignum.mdigit-ref result mdigit-index)
                                                          (fxarithmetic-shift-left 1 mdigit-offset)))))
                         indices)
               (##bignum.normalize! result))
             (fixnum-overflow)))
        (loop (if (mapper state)
                  (cons index indices)
                  indices)
              (+ index 1)
              (successor state)))))

;;;---------------------------------------------------------------------------
;;; make-bitwise-generator
;;;---------------------------------------------------------------------------

(define-prim&proc (make-bitwise-generator (i exact-integer))
  (let ((index 0))
    (lambda ()
      (let ((result (##bit-set? index i)))
        (set! index (##+ index 1))  ;;; this could be a bignum
        result))))

;;;---------------------------------------------------------------------------
;;; END
;;;---------------------------------------------------------------------------


;;;----------------------------------------------------------------------------

;;; Fixnum operations
;;; -----------------

(##define-macro (define-prim-fixnum form . special-body)
  (let ((body (if (null? special-body) form `(begin ,@special-body))))
    (cond ((= 1 (length (cdr form)))
           (let* ((name-fn (car form))
                  (name-param1 (cadr form)))
             `(define-prim ,form
                (macro-force-vars (,name-param1)
                  (macro-check-fixnum
                    ,name-param1
                    1
                    ,form
                    ,body)))))
          ((= 2 (length (cdr form)))
           (let* ((name-fn (car form))
                  (name-param1 (cadr form))
                  (name-param2 (caddr form)))
             `(define-prim ,form
                (macro-force-vars (,name-param1 ,name-param2)
                  (macro-check-fixnum
                    ,name-param1
                    1
                    ,form
                    (macro-check-fixnum
                      ,name-param2
                      2
                      ,form
                      ,body))))))
          (else
           (error "define-prim-fixnum supports only 1 or 2 parameter procedures")))))

(define-prim (fixnum? obj)
  (macro-force-vars (obj)
    (##fixnum? obj)))

(define-prim-nary-bool (##fx= x y)
  #t
  #t
  (##fx= x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fx= x y)
  #t
  #t
  (##fx= x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary-bool (##fx< x y)
  #t
  #t
  (##fx< x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fx< x y)
  #t
  #t
  (##fx< x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary-bool (##fx> x y)
  #t
  #t
  (##fx> x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fx> x y)
  #t
  #t
  (##fx> x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary-bool (##fx<= x y)
  #t
  #t
  (##fx<= x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fx<= x y)
  #t
  #t
  (##fx<= x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary-bool (##fx>= x y)
  #t
  #t
  (##fx>= x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fx>= x y)
  #t
  #t
  (##fx>= x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim (##fxzero? x))

(define-prim-fixnum (fxzero? x)
  (##fxzero? x))

(define-prim (##fxpositive? x))

(define-prim-fixnum (fxpositive? x)
  (##fxpositive? x))

(define-prim (##fxnegative? x))

(define-prim-fixnum (fxnegative? x)
  (##fxnegative? x))

(define-prim (##fxodd? x))

(define-prim-fixnum (fxodd? x)
  (##fxodd? x))

(define-prim (##fxeven? x))

(define-prim-fixnum (fxeven? x)
  (##fxeven? x))

(define-prim-nary (##fxmax x y)
  ()
  x
  (##fxmax x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxmax x y)
  ()
  x
  (##fxmax x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary (##fxmin x y)
  ()
  x
  (##fxmin x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxmin x y)
  ()
  x
  (##fxmin x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary (##fxwrap+ x y)
  0
  x
  (##fxwrap+ x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxwrap+ x y)
  0
  x
  (##fxwrap+ x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary (##fx+ x y)
  0
  x
  (##fx+ x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fx+ x y)
  0
  x
  (##fx+? x y)
  macro-force-vars
  macro-check-fixnum
  (##not ##raise-fixnum-overflow-exception))

(define-prim (##fx+? x y))

(define-prim-nary (##fxwrap* x y)
  1
  x
  (##fxwrap* x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxwrap* x y)
  1
  x
  (##fxwrap* x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary (##fx* x y)
  1
  x
  (##fx* x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fx* x y)
  1
  x
  ((lambda (x y)
     (cond ((##fx= y 0)
            0)
           ((##fx= y -1)
            (##fx-? x))
           (else
            (##fx*? x y))))
   x
   y)
  macro-force-vars
  macro-check-fixnum
  (##not ##raise-fixnum-overflow-exception))

(define-prim (##fx*? x y))

(define-prim-nary (##fxwrap- x y)
  ()
  (##fxwrap- x)
  (##fxwrap- x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxwrap- x y)
  ()
  (##fxwrap- x)
  (##fxwrap- x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary (##fx- x y)
  ()
  (##fx- x)
  (##fx- x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fx- x y)
  ()
  (##fx-? x)
  (##fx-? x y)
  macro-force-vars
  macro-check-fixnum
  (##not ##raise-fixnum-overflow-exception))

(define-prim (##fx-? x #!optional (y (macro-absent-obj)))
  (if (##eq? y (macro-absent-obj))
      (##fx-? x)
      (##fx-? x y)))

(define-prim (##fxwrapquotient x y))

(define-prim-fixnum (fxwrapquotient x y)
  (if (##fx= y 0)
      (##raise-divide-by-zero-exception fxwrapquotient x y)
      (##fxwrapquotient x y)))

(define-prim (##fxquotient x y))

(define-prim-fixnum (fxquotient x y)
  (if (##fx= y 0)
      (##raise-divide-by-zero-exception fxquotient x y)
      (if (##fx= y -1)
          (or (##fx-? x)
              (##raise-fixnum-overflow-exception fxquotient x y))
          (##fxquotient x y))))

(define-prim (##fxremainder x y))

(define-prim-fixnum (fxremainder x y)
  (if (##fx= y 0)
      (##raise-divide-by-zero-exception fxremainder x y)
      (##fxremainder x y)))

(define-prim (##fxmodulo x y))

(define-prim-fixnum (fxmodulo x y)
  (if (##fx= y 0)
      (##raise-divide-by-zero-exception fxmodulo x y)
      (##fxmodulo x y)))

(define-prim (##fxnot x)
  (##fx- -1 x))

(define-prim-fixnum (fxnot x)
  (##fxnot x))

(define-prim-nary (##fxand x y)
  -1
  x
  (##fxand x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxand x y)
  -1
  x
  (##fxand x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary (##fxior x y)
  0
  x
  (##fxior x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxior x y)
  0
  x
  (##fxior x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim-nary (##fxxor x y)
  0
  x
  (##fxxor x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxxor x y)
  0
  x
  (##fxxor x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim (##fxandc1 x y)
  (##fxand (##fxnot x) y))

(define-prim-fixnum (fxandc1 x y)
  (##fxandc1 x y))

(define-prim (##fxandc2 x y)
  (##fxand x (##fxnot y)))

(define-prim-fixnum (fxandc2 x y)
  (##fxandc2 x y))

(define-prim-nary (##fxeqv x y)
  -1
  x
  (##fxeqv x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fxeqv x y)
  -1
  x
  (##fxeqv x y)
  macro-force-vars
  macro-check-fixnum)

(define-prim (##fxnand x y)
  (##fxnot (##fxand x y)))

(define-prim-fixnum (fxnand x y)
  (##fxnand x y))

(define-prim (##fxnor x y)
  (##fxnot (##fxior x y)))

(define-prim-fixnum (fxnor x y)
  (##fxnor x y))

(define-prim (##fxorc1 x y)
  (##fxior (##fxnot x) y))

(define-prim-fixnum (fxorc1 x y)
  (##fxorc1 x y))

(define-prim (##fxorc2 x y)
  (##fxior x (##fxnot y)))

(define-prim-fixnum (fxorc2 x y)
  (##fxorc2 x y))

(define-prim (##fxif x y z))

(define-prim (fxif x y z)
  (macro-force-vars (x y z)
    (macro-check-fixnum
      x
      1
      (fxif x y z)
      (macro-check-fixnum
        y
        2
        (fxif x y z)
        (macro-check-fixnum
          z
          3
          (fxif x y z)
          (##fxif x y z))))))

(define-prim (##fxbit-count x))

(define-prim (fxbit-count x)
  (macro-force-vars (x)
    (macro-check-fixnum
      x
      1
      (fxbit-count x)
      (##fxbit-count x))))

(define-prim (##fxlength x))

(define-prim (fxlength x)
  (macro-force-vars (x)
    (macro-check-fixnum
      x
      1
      (fxlength x)
      (##fxlength x))))

(define-prim (##fxfirst-set-bit x))

(define-prim (fxfirst-set-bit x)
  (macro-force-vars (x)
    (macro-check-fixnum
      x
      1
      (fxfirst-set-bit x)
      (##fxfirst-set-bit x))))

(define-prim (##fxbit-set? x y))

(define-prim (fxbit-set? x y)
  (macro-force-vars (x y)
    (macro-check-fixnum-range-incl
      x
      1
      0
      ##fixnum-width
      (fxbit-set? x y)
      (macro-check-fixnum
        y
        2
        (fxbit-set? x y)
        (##fxbit-set? x y)))))

(define-prim (##fxwraparithmetic-shift x y))

(define-prim (fxwraparithmetic-shift x y)
  (macro-force-vars (x y)
    (macro-check-fixnum
      x
      1
      (fxwraparithmetic-shift x y)
      (macro-check-fixnum-range-incl
        y
        2
        ##fixnum-width-neg
        ##fixnum-width
        (fxwraparithmetic-shift x y)
        (##fxwraparithmetic-shift x y)))))

(define-prim (##fxwraparithmetic-shift? x y))

(define-prim (##fxarithmetic-shift x y))

(define-prim-fixnum (fxarithmetic-shift x y)
  (or (##fxarithmetic-shift? x y)
      (##raise-fixnum-overflow-exception fxarithmetic-shift x y)))

(define-prim (##fxarithmetic-shift? x y))

(define-prim (##fxwraparithmetic-shift-left x y))

(define-prim (fxwraparithmetic-shift-left x y)
  (macro-force-vars (x y)
    (macro-check-fixnum
      x
      1
      (fxwraparithmetic-shift-left x y)
      (macro-check-fixnum-range-incl
        y
        2
        0
        ##fixnum-width
        (fxwraparithmetic-shift-left x y)
        (##fxwraparithmetic-shift-left x y)))))

(define-prim (##fxwraparithmetic-shift-left? x y))

(define-prim (##fxarithmetic-shift-left x y))

(define-prim-fixnum (fxarithmetic-shift-left x y)
  (or (##fxarithmetic-shift-left? x y)
      (if (##fx< y 0)
          (##raise-range-exception 2 fxarithmetic-shift-left x y)
          (##raise-fixnum-overflow-exception fxarithmetic-shift-left x y))))

(define-prim (##fxarithmetic-shift-left? x y))

(define-prim (##fxarithmetic-shift-right x y))

(define-prim-fixnum (fxarithmetic-shift-right x y)
  (or (##fxarithmetic-shift-right? x y)
      (##raise-range-exception 2 fxarithmetic-shift-right x y)))

(define-prim (##fxarithmetic-shift-right? x y))

(define-prim (##fxwraplogical-shift-right x y))

(define-prim-fixnum (fxwraplogical-shift-right x y)
  (or (##fxwraplogical-shift-right? x y)
      (##raise-range-exception 2 fxwraplogical-shift-right x y)))

(define-prim (##fxwraplogical-shift-right? x y))

(define-prim (##fxwrapabs x))

(define-prim-fixnum (fxwrapabs x)
  (##fxwrapabs x))

(define-prim (##fxabs x))

(define-prim-fixnum (fxabs x)
  (or (##fxabs? x)
      (##raise-fixnum-overflow-exception fxabs x)))

(define-prim (##fxabs? x))

(define-prim (##fxwrapsquare x))

(define-prim-fixnum (fxwrapsquare x)
  (##fxwrapsquare x))

(define-prim (##fxsquare x))

(define-prim-fixnum (fxsquare x)
  (or (##fxsquare? x)
      (##raise-fixnum-overflow-exception fxsquare x)))

(define-prim (##fxsquare? x))

(define-prim (##integer->char x))
(define-prim (##char->integer x))

;;;------------------------------------------------------------------------------
;;; Bignum Operations
;;;------------------------------------------------------------------------------
;;;
;;; The bignum operations were implemented mostly by the über
;;; numerical analyst Brad Lucier (http://www.math.purdue.edu/~lucier)
;;; with some coding guidance from Marc Feeley.
;;;
;;; The low-level representation of bignums and the low-level operations on
;;; bignums are inspired by the paper
;;;
;;; Reconfigurable, retargetable bignums:
;;; a case study in efficient, portable Lisp system building
;;; Jon L White
;;; Conference on LISP and Functional Programming
;;; Proceedings of the 1986 ACM conference on LISP and functional programming
;;; Cambridge, Massachusetts, United States
;;; Pages: 174 - 191
;;; Year of Publication: 1986
;;; ISBN:0-89791-200-4
;;;
;;; We describe here the representation for the C back end.  See _univlib.scm for
;;; other back ends.
;;;
;;; Bignums are represented as vectors of "adigit"s.  Each element is an unsigned
;;; integer containing ##bignum.adigit-width bits, which is 64 bits if a 64-bit
;;; type is available (either as long or as long long).  Logically, the 0th adigit
;;; of a bignum contains its least-significant bits; bignums are little-endian,
;;; and the top bit of the last adigit is interpreted as the sign bit of the bignum.
;;; Before being returned to the user, bignums must be normalized so that they have
;;; no redundant all-zero or all-one high-order adigits.  Adigits are so called
;;; because they're used in addition (among other operations).  For the purpose of
;;; documentation we'll use "adigit-base" to represent (expt 2 ##bignum.adigit-width).
;;;
;;; The bits of a bignum can be accessed as a vector of "mdigit"s, which are
;;; unsigned integers containing ##bignum.mdigit-width bits, which is 16 bits
;;; on a 32-bit Gambit or 32 bits on a 64-bit Gambit (so an mdigit always fits
;;; in a fixnum).  Mdigits are so called because they're used in multiplciation
;;; (among other operations). For the purpose of documentation we'll use "mdigit-base"
;;; to represent (expt 2 ##bignum.mdigit-width).
;;;
;;; Finally, the bits of a bignum can be accessed as a vector of "fdigit"s,
;;; which are unsigned integers containing ##bignum.fdigit-width bits, which
;;; is currently 8 on all architectures in the C backend, and 7 in the universal backend.
;;; Fdigits are so called because a
;;; bignum is represented as fdigits before the Fast Fourier Transforms used
;;; in large bignum multiplications are performed.  Some comments indicate that for
;;; bignums of larger than half a billion bits, four-bit fdigits may be useful in the C
;;; backend, but that isn't implemented.
;;;
;;; The global variables ##bignum.adigit-width, ##bignum.mdigit-width, and
;;; ##bignum.fdigit-width are defined in _kernel.scm for the C backend.
;;;
;;; All issues of big-endian or little-endian accesses are taken care of in the
;;; C macros implementing the low-level operations, so we can program as if we're
;;; on a little-endian machine.
;;;
;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(macro-if-bignum (begin

;;; Bignum related constants.

(define ##bignum.adigit-ones (##fixnum->bignum -1))           ;; the 0th adigit is all ones
(define ##bignum.adigit-zeros (##fixnum->bignum 0))           ;; the 0th adigit is all zeros

(macro-case-target
 ((C)
  (begin)) ;; ##bignum.fdigit-width defined in _kernel.scm

 (else
  (define ##bignum.fdigit-width 7))
 )

(define ##bignum.fdigit-base
  (##fxarithmetic-shift-left 1 ##bignum.fdigit-width))

(define ##bignum.fdigit-mask
  (##fx- ##bignum.fdigit-base 1))

(define ##bignum.mdigit-base
  (##fxarithmetic-shift-left 1 ##bignum.mdigit-width))

(define ##bignum.inexact-mdigit-base
  (##fixnum->flonum ##bignum.mdigit-base))

(define ##bignum.mdigit-base-minus-1
  (##fx- ##bignum.mdigit-base 1))

(define ##bignum.minus-mdigit-base
  (##fx- ##bignum.mdigit-base))

(define ##bignum.max-fixnum-div-mdigit-base
  (##fxquotient ##max-fixnum ##bignum.mdigit-base))

(define ##bignum.min-fixnum-div-mdigit-base
  (##fxquotient ##min-fixnum ##bignum.mdigit-base))

(define ##bignum.2*min-fixnum
  (if (##fixnum? -1073741824)
      -4611686018427387904 ;; (- (expt 2 62))
      -1073741824))        ;; (- (expt 2 30))

(define ##bignum.-min-fixnum
  (if (##fixnum? 536870912)
      2305843009213693952 ;; (expt 2 61)
      536870912))         ;; (expt 2 29)

;;; The following global variables control when each of the three
;;; multiplication algorithms are used.
;;;
;;; Naive (grade-school) multiplication is used as long as one of
;;; the arguments has fewer than ##bignum.naive-mul-max-width
;;; bits.
;;;
;;; Karatsuba multiplication is used if the smaller of the two
;;; multiplication arguments has fewer than ##bignum.fft-mul-min-width
;;; or the larger of the two arguments has more than
;;; ##bignum.fft-mul-max-width bits
;;;
;;; For other sizes of the arguments use FFT multiplication.
;;;
;;; A "fast", reciprocal-based division is used if the divisor has
;;; more than ##bignum.fft-mul-min-width bits and the difference in
;;; size of the divident and divisor is more than
;;; ##bignum.fft-mul-min-width bits.
;;;
;;; Note that these global variables are not constants that are
;;; inlined, so one can change them if you like.

(define ##bignum.naive-mul-max-width 1400)

(define-prim (##bignum.naive-mul-max-width-set! x)
  (set! ##bignum.naive-mul-max-width x))

(define ##bignum.fft-mul-min-width 20000)

(define-prim (##bignum.fft-mul-min-width-set! x)
  (set! ##bignum.fft-mul-min-width x))

(define ##bignum.fft-mul-max-width
  (if (##fixnum? -1073741824) ;; #t iff using 64-bit fixnums
      536870912
       ;; to avoid creating f64vectors that are too long
      4194304))

(define-prim (##bignum.fft-mul-max-width-set! x)
  (set! ##bignum.fft-mul-max-width x))

;;; An O(N(\log N)^2) algorithm for GCD is used if both arguments have more
;;; than ##bignum.fast-gcd-size bits

(define ##bignum.fast-gcd-size ##bignum.naive-mul-max-width)  ;; must be >= 64

(define-prim (##bignum.fast-gcd-size-set! x)
  (set! ##bignum.fast-gcd-size x))

;;;-----------------------------------------------------------------------------

;;; These are the low-level operations on adigits, mdigits, and fdigits.
;;; Two-argument functions are generally destructive, and overwrite part of
;;; their first argument.  These operations are supported in the Gambit Virtual
;;; Machine (GVM) and the Gambit Scheme Compiler (gsc).

;;; Returns #t if x is negative, #f otherwise
(define-prim (##bignum.negative? x))

;;; Returns the number of adigits in x (always a fixnum)
(define-prim (##bignum.adigit-length x))

;;; Increments the i'th adigit of x by 1 and returns 1 if the result
;;; overflowed, and 0 otherwise.
(define-prim (##bignum.adigit-inc! x i))

;;; Decrements the i'th digit of x by 1 and returns 1 if the result
;;; underflowed and 0 otherwise.
(define-prim (##bignum.adigit-dec! x i))

;;; Calculate
;;; sum = x[i] + y[j] + carry (accessing x and y as adigits)
;;; Sets x[i] = sum modulo adigit-base; returns 1 if overflow occured,
;;; 0 otherwise.
(define-prim (##bignum.adigit-add! x i y j carry))

;;; Calculate
;;; difference = x[i] - y[j] - borrow (accessing x and y as adigits)
;;; Sets x[i] = difference modulo adigit-base; returns 1 if underflow occured,
;;; 0 otherwise.
(define-prim (##bignum.adigit-sub! x i y j borrow))

;;; Returns the number of mdigits in x (always a fixnum)
(define-prim (##bignum.mdigit-length x))

;;; Returns the i'th mdigit of x
(define-prim (##bignum.mdigit-ref x i))

;;; Sets the i'th mdigit of x to mdigit
(define-prim (##bignum.mdigit-set! x i mdigit))

;;; Calculate
;;; z = x[i] + y[j] * multiplier + carry (accessing x and y as mdigits)
;;; Sets x[i] = z modulo mdigit-base; returns (quotient z mdigit-base)
(define-prim (##bignum.mdigit-mul! x i y j multiplier carry))

;;; Calculate
;;; z = x[i] - y[j] * quotient + borrow
;;; Sets x[i] to z modulo mdigit-base; returns
;;; (quotient (z - x[i]) mdigit-base)
(define-prim (##bignum.mdigit-div! x i y j quotient borrow))

;;; Returns
;;; (u[j] * mdigit-base + u[j-1]) / v
;;; (accessing u as mdigits)
(define-prim (##bignum.mdigit-quotient u j v_n-1))

;;; Returns
;;; (u[j] * mdigit-base + u[j-1] - v_n-1 * q-hat)
;;; (accessing u as mdigits)
(define-prim (##bignum.mdigit-remainder u j v_n-1 q-hat))

;;; Returns #t if
;;; q-hat * v_n-2 > (r-hat * mdigit-base + u_j-2)
;;; and #f otherwise
(define-prim (##bignum.mdigit-test? q-hat v_n-2 r-hat u_j-2))

;;; Returns #t if x[i] (accessed as adigits) is all ones, and
;;; #f otherwise
(define-prim (##bignum.adigit-ones? x i))

;;; Returns #t if x[i] (accessed as adigits) is all zeros, and
;;; #f otherwise
(define-prim (##bignum.adigit-zero? x i))

;;; Returns #t if the high-order bit of x[i] (accessing x as
;;; adigits) is 1, and #f otherwise
(define-prim (##bignum.adigit-negative? x i))

;;; Returns #t if x[i]=y[i] (accessing x and y as adigits) and
;;; #f otherwise
(define-prim (##bignum.adigit-= x y i))

;;; Returns #t if x[i]<y[i] (accessing x and y as adigits) and
;;; #f otherwise
(define-prim (##bignum.adigit-< x y i))

;;; Convert the fixnum x to an (unnormalized) bignum with one adigit
(define-prim (##fixnum->bignum x))

;;; Sets the number of adigits in the bignum x to n; must not increase
;;; the number of adigits in x
(define-prim (##bignum.adigit-shrink! x n))

;;; Sets x[i] to y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-copy! x i y j))

;;; Calculate
;;; z = hi[j] << divider | lo[k] >> (##bignum.adigit-width - divider)
;;; (accessing hi and lo as adigits)
;;; Sets x[i] to z modulo adigit-base
(define-prim (##bignum.adigit-cat! x i hi j lo k divider))

;;; Sets x[i] to x[i] & y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-and! x i y j))

;;; Sets x[i] to ~x[i] & y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-andc1! x i y j))

;;; Sets x[i] to x[i] & ~y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-andc2! x i y j))

;;; Sets x[i] to ~(x[i] ^ y[j]) (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-eqv! x i y j))

;;; Sets x[i] to x[i] | y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-ior! x i y j))

;;; Sets x[i] to ~(x[i] & y[j]) (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-nand! x i y j))

;;; Sets x[i] to ~(x[i] | y[j]) (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-nor! x i y j))

;;; Sets x[i] to !x[i] (accessing x as adigits)
(define-prim (##bignum.adigit-bitwise-not! x i))

;;; Sets x[i] to ~x[i] | y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-orc1! x i y j))

;;; Sets x[i] to x[i] | ~y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-orc2! x i y j))

;;; Sets x[i] to x[i] ^ y[j] (accessing x and y as adigits)
(define-prim (##bignum.adigit-bitwise-xor! x i y j))

(macro-case-target
 ((C)
  ;; fdigit operations

  ;; Returns the number of fdigits in x
  (define-prim (##bignum.fdigit-length x))

  ;; Returns x[i] (accessing x as fdigits)
  (define-prim (##bignum.fdigit-ref x i))

  ;; Sets x[i] to fdigit (accessing x as fdigits)
  (define-prim (##bignum.fdigit-set! x i fdigit))

  ;; adigit operations

  (define ##bignum.adigit-log-width
    (##fx- (##fxlength ##bignum.adigit-width) 1))

  (define ##bignum.adigit-log-mask
    (##fx- ##bignum.adigit-width 1))

  ;; Caclulates (fxmodulo x ##bignum.adigit-width)

  (define-prim (##bignum.adigit-mod x)
    (##fxand x ##bignum.adigit-log-mask))

  ;; Assumes that x is either nonnegative or
  ;; a multiple of ##bignum.adigit-width.
  ;; Calculates  (##fxquotient x ##bignum.adigit-width)

  (define-prim (##bignum.adigit-div x)
    (##fxarithmetic-shift-right x ##bignum.adigit-log-width))

  ;; mdigit operations

  (define ##bignum.mdigit-log-width
    (##fx- (##fxlength ##bignum.mdigit-width) 1))

  (define ##bignum.mdigit-log-mask
    (##fx- ##bignum.mdigit-width 1))

  ;; Caclulates (fxmodulo x ##bignum.mdigit-width)

  (define-prim (##bignum.mdigit-mod x)
    (##fxand x ##bignum.mdigit-log-mask))

  ;; Assumes that x is either nonnegative or
  ;; a multiple of ##bignum.mdigit-width.
  ;; Calculates  (##fxquotient x ##bignum.mdigit-width)

  (define-prim (##bignum.mdigit-div x)
    (##fxarithmetic-shift-right x ##bignum.mdigit-log-width))


  )

 (else

  ;; fdigit operations

  ;; assumes that mdigits are 14 bits wide and fdigits are
  ;; halves of mdigits

  ;; Returns the number of fdigits in x

  (define-prim (##bignum.fdigit-length x)
    (##fx* (##bignum.adigit-length x) 2))

  ;; Returns x[i] (accessing x as fdigits)
  (define-prim (##bignum.fdigit-ref x i)
    (let ((mdigit (##bignum.mdigit-ref x (##fxquotient i 2))))
      (if (##fxeven? i)
          (##fxand mdigit ##bignum.fdigit-mask)
          (##fxarithmetic-shift-right mdigit ##bignum.fdigit-width))))

  ;; Sets x[i] to fdigit (accessing x as fdigits)
  (define-prim (##bignum.fdigit-set! x i fdigit)
    (let* ((i/2         (##fxquotient i 2))
           (mdigit      (##bignum.mdigit-ref x i/2))
           (new-mdigit
            (if (##fxeven? i)
                (##fxior (##fxand (##fxnot ##bignum.fdigit-mask)
                                  mdigit)
                         fdigit)
                (##fxior (##fxarithmetic-shift-left fdigit ##bignum.fdigit-width)
                         (##fxand mdigit ##bignum.fdigit-mask)))))
      (##bignum.mdigit-set! x i/2 new-mdigit)))

  ;; adigit operations

  ;; Caclulates (fxmodulo x ##bignum.adigit-width)

  (define-prim (##bignum.adigit-mod x)
    (##fxmodulo x ##bignum.adigit-width))

  ;; Assumes that x is either nonnegative or
  ;; a multiple of ##bignum.adigit-width.
  ;; Calculates  (##fxquotient x ##bignum.adigit-width)

  (define-prim (##bignum.adigit-div x)
    (##fxquotient x ##bignum.adigit-width))

  ;; mdigit operations

  ;; Caclulates (fxmodulo x ##bignum.mdigit-width)

  (define-prim (##bignum.mdigit-mod x)
    (##fxmodulo x ##bignum.mdigit-width))

  ;; Assumes that x is either nonnegative or
  ;; a multiple of ##bignum.mdigit-width.
  ;; Calculates  (##fxquotient x ##bignum.mdigit-width)

  (define-prim (##bignum.mdigit-div x)
    (##fxquotient x ##bignum.mdigit-width))

  )

 )

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Operations where arguments are in bignum format

(define-prim (##bignum.make k x complement?)
  (##declare (not interrupts-enabled))
  (let ((v (##c-code #<<end-of-code
___SCMOBJ k;
___SCMOBJ x;
___SCMOBJ complement;
___SIZE_TS i;
___SIZE_TS n;
___SCMOBJ result;
___POP_ARGS3(k,x,complement);
___ps->saved[0] = k;
___ps->saved[1] = x;
___ps->saved[2] = complement;
n = ___INT(k);

if (n > ___CAST(___WORD, ___LMASK>>___LF)/(___BIG_ABASE_WIDTH/8))
  result = ___FIX(___HEAP_OVERFLOW_ERR); /* requested object is too big! */
else
  {
    ___SIZE_TS words = ___WORDS((n*(___BIG_ABASE_WIDTH/8))) + ___SUBTYPED_BODY;

#if ___BIG_ABASE_WIDTH == 64 && ___WS == 4
    words++;
#endif

    if (words > ___MSECTION_BIGGEST)
      {
        ___FRAME_STORE_RA(___R0)
        ___W_ALL
#if ___BIG_ABASE_WIDTH == 32
        result = ___EXT(___alloc_scmobj) (___ps, ___sBIGNUM, n<<2);
#else
        result = ___EXT(___alloc_scmobj) (___ps, ___sBIGNUM, n<<3);
#endif
        ___R_ALL
        ___SET_R0(___FRAME_FETCH_RA)
        if (!___FIXNUMP(result))
          ___still_obj_refcount_dec (result);
      }
    else
      {
        ___BOOL overflow = 0;
        ___hp += words;
        if (___hp > ___ps->heap_limit)
          {
            ___FRAME_STORE_RA(___R0)
            ___W_ALL
            overflow = ___heap_limit (___PSPNC) && ___garbage_collect (___PSP 0);
            ___R_ALL
            ___SET_R0(___FRAME_FETCH_RA)
          }
        else
          ___hp -= words;
        if (overflow)
          result = ___FIX(___HEAP_OVERFLOW_ERR);
        else
          {
#if ___BIG_ABASE_WIDTH == 64 && ___WS == 4
            result = ___SUBTYPED_FROM_BODY(___CAST(___WORD,___hp+___SUBTYPED_BODY+1)&~7);
#else
            result = ___SUBTYPED_FROM_START(___hp);
#endif
#if ___BIG_ABASE_WIDTH == 32
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<2), ___sBIGNUM));
#else
            ___SUBTYPED_HEADER_SET(result, ___MAKE_HD_BYTES((n<<3), ___sBIGNUM));
#endif
            ___hp += words;
          }
      }
  }
k = ___ps->saved[0];
x = ___ps->saved[1];
complement = ___ps->saved[2];
___ps->saved[0] = ___VOID;
___ps->saved[1] = ___VOID;
___ps->saved[2] = ___VOID;
if (!___FIXNUMP(result))
  {
    ___SCMOBJ len;
    if (x == ___FAL)
      len = 0;
    else
      {
        len = ___INT(___BIGALENGTH(x));
        if (len > n)
          len = n;
      }
#if ___BIG_ABASE_WIDTH == 32
    if (complement == ___FAL)
      {
        for (i=0; i<len; i++)
          ___STORE_U32(___BODY_AS(result,___tSUBTYPED),i,
                       ___FETCH_U32(___BODY_AS(x,___tSUBTYPED),i));
        if (x != ___FAL &&
            ___FETCH_S32(___BODY_AS(x,___tSUBTYPED),(i-1)) < 0)
          for (; i<n; i++)
            ___STORE_U32(___BODY_AS(result,___tSUBTYPED),i,___BIG_ABASE_MIN_1);
        else
          for (; i<n; i++)
            ___STORE_U32(___BODY_AS(result,___tSUBTYPED),i,0);
      }
    else
      {
        for (i=0; i<len; i++)
          ___STORE_U32(___BODY_AS(result,___tSUBTYPED),i,
                       ~___FETCH_U32(___BODY_AS(x,___tSUBTYPED),i));
        if (x != ___FAL &&
            ___FETCH_S32(___BODY_AS(x,___tSUBTYPED),(i-1)) < 0)
          for (; i<n; i++)
            ___STORE_U32(___BODY_AS(result,___tSUBTYPED),i,0);
        else
          for (; i<n; i++)
            ___STORE_U32(___BODY_AS(result,___tSUBTYPED),i,___BIG_ABASE_MIN_1);
      }
#else
    if (complement == ___FAL)
      {
        for (i=0; i<len; i++)
          ___STORE_U64(___BODY_AS(result,___tSUBTYPED),i,
                       ___FETCH_U64(___BODY_AS(x,___tSUBTYPED),i));
        if (x != ___FAL &&
            ___FETCH_S64(___BODY_AS(x,___tSUBTYPED),(i-1)) < 0)
          for (; i<n; i++)
            ___STORE_U64(___BODY_AS(result,___tSUBTYPED),i,___BIG_ABASE_MIN_1);
        else
          for (; i<n; i++)
            ___STORE_U64(___BODY_AS(result,___tSUBTYPED),i,0);
      }
    else
      {
        for (i=0; i<len; i++)
          ___STORE_U64(___BODY_AS(result,___tSUBTYPED),i,
                       ~___FETCH_U64(___BODY_AS(x,___tSUBTYPED),i));
        if (x != ___FAL &&
            ___FETCH_S64(___BODY_AS(x,___tSUBTYPED),(i-1)) < 0)
          for (; i<n; i++)
            ___STORE_U64(___BODY_AS(result,___tSUBTYPED),i,0);
        else
          for (; i<n; i++)
            ___STORE_U64(___BODY_AS(result,___tSUBTYPED),i,___BIG_ABASE_MIN_1);
      }
#endif
  }
___RESULT = result;
___PUSH_ARGS3(k,x,complement);

end-of-code
)))
    (if (##fixnum? v)
        (begin
          (##raise-heap-overflow-exception)
          (##bignum.make k x complement?))
        v)))

(define-prim (##bignum.copy x)
  (##bignum.make (##bignum.adigit-length x) x #f))

;;; Bignum addition and subtraction.

(define-prim (##bignum.+ x y)

  ;; x is an unnormalized bignum, y is an unnormalized bignum

  (define (add x x-length y y-length)
    (let* ((result-length
            (##fx+ y-length
                   (if (##eq? (##bignum.negative? x)
                              (##bignum.negative? y))
                       1
                       0)))
           (result
            (##bignum.make result-length y #f)))

      (##declare (not interrupts-enabled))

      (let loop ((i 0)
                 (carry 0))
        (if (##fx< i x-length)
            (loop (##fx+ i 1)
                  (##bignum.adigit-add! result i x i carry))
            (##bignum.propagate-carry-and-normalize!
             result
             result-length
             x-length
             (##bignum.negative? x)
             (##fxzero? carry))))))

  (let ((x-length (##bignum.adigit-length x))
        (y-length (##bignum.adigit-length y)))
    (if (##fx< x-length y-length)
        (add x x-length y y-length)
        (add y y-length x x-length))))

(define-prim (##bignum.- x y)

  ;; x is an unnormalized bignum, y is an unnormalized bignum

  (let ((x-length (##bignum.adigit-length x))
        (y-length (##bignum.adigit-length y)))
    (if (##fx< x-length y-length)

        (let* ((result-length
                (##fx+ y-length
                       (if (##eq? (##bignum.negative? x)
                                  (##bignum.negative? y))
                           0
                           1)))
               (result
                (##bignum.make result-length y #t)))

          (##declare (not interrupts-enabled))

          (let loop1 ((i 0)
                      (carry 1))
            (if (##fx< i x-length)
                (loop1 (##fx+ i 1)
                       (##bignum.adigit-add! result i x i carry))
                (##bignum.propagate-carry-and-normalize!
                 result
                 result-length
                 x-length
                 (##bignum.negative? x)
                 (##fxzero? carry)))))

        (let* ((result-length
                (##fx+ x-length
                       (if (##eq? (##bignum.negative? x)
                                  (##bignum.negative? y))
                           0
                           1)))
               (result
                (##bignum.make result-length x #f)))

          (##declare (not interrupts-enabled))

          (let loop2 ((i 0)
                      (borrow 0))
            (if (##fx< i y-length)
                (loop2 (##fx+ i 1)
                       (##bignum.adigit-sub! result i y i borrow))
                (##bignum.propagate-carry-and-normalize!
                 result
                 result-length
                 y-length
                 (##not (##bignum.negative? y))
                 (##not (##fxzero? borrow)))))))))

(define-prim (##bignum.propagate-carry-and-normalize!
              result
              result-length
              i
              borrow?
              propagate?)

  (##declare (not interrupts-enabled))

  (if (##eq? borrow? propagate?)
      (if borrow?

          (let loop1 ((i i)
                      (borrow 1))
            (if (and (##not (##fxzero? borrow))
                     (##fx< i result-length))
                (loop1 (##fx+ i 1)
                       (##bignum.adigit-dec! result i))
                (##bignum.normalize! result)))

          (let loop2 ((i i)
                      (carry 1))
            (if (and (##not (##fxzero? carry))
                     (##fx< i result-length))
                (loop2 (##fx+ i 1)
                       (##bignum.adigit-inc! result i))
                (##bignum.normalize! result))))

      (##bignum.normalize! result)))

(define-prim (##bignum->fixnum? bn)
  (let* ((i
          (##fx- (##bignum.mdigit-length bn) 1))
         (n
          (##bignum.mdigit-ref bn i))
         (bias
          (if (##fx< (##fx* 2 n) ##bignum.mdigit-base)
              0
              ##bignum.mdigit-base-minus-1)))
    (let loop ((n (##fx- n bias))
               (i (##fx- i 1)))
      (if (##fx< i 0)
          (if (##fx= 0 bias)
              n
              (##fx+? n -1))
          (let ((n1 (##fx*? n ##bignum.mdigit-base)))
            (and n1
                 (let ((n2 (##fx+? n1 (##fx- (##bignum.mdigit-ref bn i) bias))))
                   (and n2
                        (loop n2
                              (##fx- i 1))))))))))

(define-prim (##bignum.normalize! result)

  (##declare (not interrupts-enabled))

  (or (##bignum->fixnum? result)

      (let ((n (##fx- (##bignum.adigit-length result) 1)))

        (cond ((##bignum.adigit-zero? result n)

               ;; result is a bignum of the form:
               ;;   0000 abcd .... efgh (adigits in binary)
               ;;    n   n-1        0   (adigit index)

               ;; we know result represents a nonnegative integer
               ;; must check if adigits abcd .... are also 0000

               (let loop1 ((i (##fx- n 1)))
                 (cond ((##fx< i 0)
                        ;; all adigits are 0000
                        0)
                       ((##bignum.adigit-zero? result i)
                        ;; continue skipping top adigits that are 0000
                        (loop1 (##fx- i 1)))
                       ((##bignum.adigit-negative? result i)
                        ;; result is a bignum of the form:
                        ;;   0000 .... 0000 1bcd .... efgh (adigits in binary)
                        ;;    n         i+1  i         0   (adigit index)
                        ;; so we must include adigit i+1 to avoid result
                        ;; being interpreted as a negative integer
                        (##bignum.adigit-shrink! result (##fx+ i 2)))
                       (else
                        ;; result is a bignum of the form:
                        ;;   0000 .... 0000 0bcd .... efgh (adigits in binary)
                        ;;    n         i+1  i         0   (adigit index)
                        ;; with 0bcd != 0000, so the top 0000 adigits can
                        ;; be removed without changing the sign of result
                        (##bignum.adigit-shrink! result (##fx+ i 1))))))

              ((##bignum.adigit-ones? result n)

               ;; result is a bignum of the form:
               ;;   1111 abcd .... efgh (adigits in binary)
               ;;    n   n-1        0   (adigit index)

               ;; we know result represents a negative integer
               ;; must check if adigits abcd .... are also 1111

               (let loop2 ((i (##fx- n 1)))
                 (cond ((##fx< i 0)
                        ;; all adigits are 1111
                        -1)
                       ((##bignum.adigit-ones? result i)
                        ;; continue skipping top adigits that are 1111
                        (loop2 (##fx- i 1)))
                       ((##not (##bignum.adigit-negative? result i))
                        ;; result is a bignum of the form:
                        ;;   1111 .... 1111 0bcd .... efgh (adigits in binary)
                        ;;    n         i+1  i         0   (adigit index)
                        ;; so we must include adigit i+1 to avoid result
                        ;; being interpreted as a nonnegative integer
                        (##bignum.adigit-shrink! result (##fx+ i 2)))
                       (else
                        ;; result is a bignum of the form:
                        ;;   1111 .... 1111 1bcd .... efgh (adigits in binary)
                        ;;    n         i+1  i         0   (adigit index)
                        ;; with 1bcd != 1111, so the top 1111 adigits can
                        ;; be removed without changing the sign of result
                        (##bignum.adigit-shrink! result (##fx+ i 1))))))

              (else
               result)))))

(macro-if-enable-assert-normalized-exact-int

 (define-prim (##bignum.normalized? x)
   (let ((n (##fx- (##bignum.adigit-length x) 1)))
     (and (##fx>= n 0)
          (cond ((##bignum.adigit-zero? x n)
                 (and (##fx> n 0)
                      (##bignum.adigit-negative? x (##fx- n 1))))
                ((##bignum.adigit-ones? x n)
                 (and (##fx> n 0)
                      (##not (##bignum.adigit-negative? x (##fx- n 1)))))
                (else
                 #t))))))

;;; Bignum multiplication.

(define-prim (##bignum.* x y)

  (define (fft-mul x y)

    ;; Marc, the results of make-w should be cached, since bigger
    ;; tables can be used for any smaller size FFT.

    ;; This code works for x and y up to 536,870,912 bits, with
    ;; results up to 1Gb; numbers of this size require 8Gb, or 1GB, of
    ;; intermediate storage. It is always faster than the old code,
    ;; and it is mathematically correct.  (Whether it is
    ;; programmatically correct is, of course, another matter, but I
    ;; have tested it extensively.)

    ;; This is an experiment.

    ;; This code implements bignum multiplication based on
    ;; double-precision FFT computations rather than on
    ;; number-theoretic FFTs and the Chinese remainder theorem.

    ;; The theory is in the article

    ;; Rapid multiplication modulo the sum and difference of highly
    ;; composite numbers, by Colin Percival

    ;; The complex roots of unity ("twiddle factors") need to be
    ;; computed in such a way that there is a known bound on the
    ;; error.  I did this with a "computable reals" package I wrote.
    ;; I did not know a bound for the roots of unity in Ooura's FFT,
    ;; which is what we previously used..

    ;; If you use a different complex FFT, then you need to ensure
    ;; that the same operations are done as in this FFT (perhaps in a
    ;; somewhat different order), or that you prove the corresponding
    ;; theorem for your FFT that Percival proved in his paper.  On a
    ;; 2GHz PPC 970, my complex FFT seems to be about half as fast as
    ;; FFTW's complex FFT, so that doesn't seem too bad for one
    ;; written by hand in Scheme.

    ;; After years of fiddling around, I finally understook the
    ;; weighted FT transform and the so-called right-angle
    ;; convolution.  See section 8.3.2 the book "Algorithms for
    ;; Programmers" by Jo"rg Arndt, currently available at
    ;; www.jjj.de/fxt/fxtbook.pdf for a description of the right-angle
    ;; transform.  It's also covered in "Prime Numbers" by Crandall
    ;; and Pomerance, and was originally introduced in 1994 by
    ;; Crandall and Fagin.

    ;; The basic reference for the fft codes is
    ;; {\it Inside the FFT Black Box,} by Eleanor Chu and Alan George,
    ;; CRC Press, New York, 2000.  In the end, I should say that these
    ;; codes are just motivated by this book.

    ;; One of the biggest problem in translating their notation is
    ;; that they work with complex numbers, and we're working with
    ;; pairs of reals.  Let us assume that all complex numbers are
    ;; stored with adjacent real and imaginary parts, real first.

    #|

    The strategy in the next function is to calculate a 2^n'th
    root of unity by multiplying entries from up to three look-up
    tables, each of which has lut-table-size complex entries, stored
    as pairs of f64s.  Each of the tables contains correctly-rounded
    complex roots of unity, as computed by my computable-reals code.

    The j'th entry of the first table is

    exp(\pi/2 * i * (bit-reverse j log-lut-table-size)/lut-table-size),  j = 0,...,lut-table-size - 1.

    where (bit-reverse j k) reverses the bits of j when
    considered as a bit string of length k.

    The j'th entry of the second table is

    exp(\pi/2 * i * j/lut-table-size^2), j = 0,...,lut-table-size-1

    and the j'th entry in the third table is

    exp(\pi/2 * i * j/lut-table-size^3), j = 0,...,lut-table-size-1

    From these three tables we construct a lut w in bit-reverse
    order of size 2^log-n.

    Any table we construct is also usable for ffts of a smaller size.

    The errors in the tables are as follows.

    When log-lut-table-size=10, we have the error in the first
    table is bounded by

    7.241394152931137e-17

    Theoretically, it should be bounded by

    > (* (sqrt 1/2) (expt 2. -53))
    7.850462293418875e-17

    The maximum error in the product of the first two tables is bounded by

    2.5438950740364204e-16

    The error in the general product of two correctly-rounded
    complex floating-point numbers of magnitude one is bounded by

    > (* (+ (sqrt 5) (sqrt 1/2) (sqrt 1/2)) (expt 2. -53))
    4.052626611931048e-16

    but what we're seeing here is that the entries of the second
    table have real part close to 1 and imaginary part <
    pi/2*2^{-10}, so (a) the error in the entries of the second table
    is much closer to 1/2 epsilon rather than (sqrt 1/2) epsilon,
    and (2) we might expect an error of about sqrt(2)epsilon in the
    complex product instead of the general result of sqrt(5)epsilon,
    or

    > (* (+ (sqrt 2) (sqrt 1/2) 1/2) (expt 2. -53))
    2.910250200338241e-16

    The maximum error in the product of entries from all three tables is

    4.158491068379826e-16

    which we can plug into the error bounds.  Using the above
    heuristics, we would expect it to be <

    > (* (+ (sqrt 2) (sqrt 2) (sqrt 1/2) 1/2 1/2) (expt 2. -53))
    5.035454171334594e-16

    and we have the general bound of

    > (* (+ (* 2 (sqrt 5)) (* 3 (sqrt 1/2))) (expt 2. -53))
    7.320206994520208e-16

    so I'm glad I measured it.

    And, yes, I waited six days to compute the difference between
    the computed roots of unity and the exact roots of unity for all
    2^{30} products from the three tables.

    When log-lut-table-size=9, the corresponding maximum errors are

    7.113686303921851e-17

    for entries in the first table,

    2.4506454051660923e-16

    for products of entries in the first two tables, and

    4.164343159519809e-16

    for products from all three tables.

    Added later:

    We could try a different strategy here.

    If it's necessary to multiply entries of all three tables to populate
    the result, we multiply the entries from the last two tables first to
    get a multiplier.  Because the real parts of the second and third table
    entries are nearly one and the imaginary parts are < 2^{-9} or so, the
    rounding error in each entry is about 1/2 epsilon instead of (sqrt 1/2)
    epsilon, and the biggest error in the product is 1/2 epsilon in the
    product of the real parts and then another 1/2 epsilon when subtracting
    the product of the imaginary parts.  So the total error is about

    (* (+ 1/2 1/2 1/2 1/2) (expt 2 -53))

    or 2.220446049250313e-16.

    The final product adds further error of (sqrt 1/2) epsilon in the
    entries in the first table and then (sqrt 2) epsilon in the product.
    So my guess is that the total error in the product of three entries
    from the table will be bounded by

    (* (+ 1/2 1/2 1/2 1/2 (sqrt 1/2) (sqrt 2)) (expt 2 -53))

    or 4.575584737275976e-16.

    |#

    (define lut-table-size 512)
    (define lut-table-size^2 262144)
    (define lut-table-size^3 134217728)
    (define log-lut-table-size 9)

    (define low-lut
    '#f64(1. 0.
       .7071067811865476 .7071067811865476
       .9238795325112867 .3826834323650898
       .3826834323650898 .9238795325112867
       .9807852804032304 .19509032201612828
       .5555702330196022 .8314696123025452
       .8314696123025452 .5555702330196022
       .19509032201612828 .9807852804032304
       .9951847266721969 .0980171403295606
       .6343932841636455 .773010453362737
       .881921264348355 .47139673682599764
       .2902846772544624 .9569403357322088
       .9569403357322088 .2902846772544624
       .47139673682599764 .881921264348355
       .773010453362737 .6343932841636455
       .0980171403295606 .9951847266721969
       .9987954562051724 .049067674327418015
       .6715589548470184 .7409511253549591
       .9039892931234433 .4275550934302821
       .33688985339222005 .9415440651830208
       .970031253194544 .2429801799032639
       .5141027441932218 .8577286100002721
       .8032075314806449 .5956993044924334
       .14673047445536175 .989176509964781
       .989176509964781 .14673047445536175
       .5956993044924334 .8032075314806449
       .8577286100002721 .5141027441932218
       .2429801799032639 .970031253194544
       .9415440651830208 .33688985339222005
       .4275550934302821 .9039892931234433
       .7409511253549591 .6715589548470184
       .049067674327418015 .9987954562051724
       .9996988186962042 .024541228522912288
       .6895405447370669 .7242470829514669
       .9142097557035307 .40524131400498986
       .35989503653498817 .9329927988347388
       .9757021300385286 .2191012401568698
       .5349976198870973 .8448535652497071
       .8175848131515837 .5758081914178453
       .17096188876030122 .9852776423889412
       .99247953459871 .1224106751992162
       .6152315905806268 .7883464276266062
       .8700869911087115 .49289819222978404
       .26671275747489837 .9637760657954398
       .9495281805930367 .31368174039889146
       .4496113296546066 .8932243011955153
       .7572088465064846 .6531728429537768
       .07356456359966743 .9972904566786902
       .9972904566786902 .07356456359966743
       .6531728429537768 .7572088465064846
       .8932243011955153 .4496113296546066
       .31368174039889146 .9495281805930367
       .9637760657954398 .26671275747489837
       .49289819222978404 .8700869911087115
       .7883464276266062 .6152315905806268
       .1224106751992162 .99247953459871
       .9852776423889412 .17096188876030122
       .5758081914178453 .8175848131515837
       .8448535652497071 .5349976198870973
       .2191012401568698 .9757021300385286
       .9329927988347388 .35989503653498817
       .40524131400498986 .9142097557035307
       .7242470829514669 .6895405447370669
       .024541228522912288 .9996988186962042
       .9999247018391445 .012271538285719925
       .6983762494089728 .7157308252838187
       .9191138516900578 .3939920400610481
       .37131719395183754 .9285060804732156
       .9783173707196277 .20711137619221856
       .5453249884220465 .8382247055548381
       .8245893027850253 .5657318107836132
       .18303988795514095 .9831054874312163
       .9939069700023561 .11022220729388306
       .6248594881423863 .7807372285720945
       .8760700941954066 .4821837720791228
       .2785196893850531 .9604305194155658
       .9533060403541939 .3020059493192281
       .46053871095824 .8876396204028539
       .765167265622459 .6438315428897915
       .0857973123444399 .996312612182778
       .9981181129001492 .06132073630220858
       .6624157775901718 .7491363945234594
       .8986744656939538 .43861623853852766
       .3253102921622629 .9456073253805213
       .9669764710448521 .25486565960451457
       .5035383837257176 .8639728561215867
       .7958369046088836 .6055110414043255
       .1345807085071262 .99090263542778
       .9873014181578584 .15885814333386145
       .5857978574564389 .8104571982525948
       .8513551931052652 .524589682678469
       .2310581082806711 .9729399522055602
       .937339011912575 .34841868024943456
       .4164295600976372 .9091679830905224
       .7326542716724128 .680600997795453
       .03680722294135883 .9993223845883495
       .9993223845883495 .03680722294135883
       .680600997795453 .7326542716724128
       .9091679830905224 .4164295600976372
       .34841868024943456 .937339011912575
       .9729399522055602 .2310581082806711
       .524589682678469 .8513551931052652
       .8104571982525948 .5857978574564389
       .15885814333386145 .9873014181578584
       .99090263542778 .1345807085071262
       .6055110414043255 .7958369046088836
       .8639728561215867 .5035383837257176
       .25486565960451457 .9669764710448521
       .9456073253805213 .3253102921622629
       .43861623853852766 .8986744656939538
       .7491363945234594 .6624157775901718
       .06132073630220858 .9981181129001492
       .996312612182778 .0857973123444399
       .6438315428897915 .765167265622459
       .8876396204028539 .46053871095824
       .3020059493192281 .9533060403541939
       .9604305194155658 .2785196893850531
       .4821837720791228 .8760700941954066
       .7807372285720945 .6248594881423863
       .11022220729388306 .9939069700023561
       .9831054874312163 .18303988795514095
       .5657318107836132 .8245893027850253
       .8382247055548381 .5453249884220465
       .20711137619221856 .9783173707196277
       .9285060804732156 .37131719395183754
       .3939920400610481 .9191138516900578
       .7157308252838187 .6983762494089728
       .012271538285719925 .9999247018391445
       .9999811752826011 .006135884649154475
       .7027547444572253 .7114321957452164
       .9215140393420419 .3883450466988263
       .37700741021641826 .9262102421383114
       .9795697656854405 .2011046348420919
       .5504579729366048 .83486287498638
       .8280450452577558 .560661576197336
       .18906866414980622 .9819638691095552
       .9945645707342554 .10412163387205457
       .629638238914927 .7768884656732324
       .8790122264286335 .47679923006332214
       .2844075372112718 .9587034748958716
       .9551411683057707 .29615088824362384
       .4659764957679662 .8847970984309378
       .7691033376455796 .6391244448637757
       .09190895649713272 .9957674144676598
       .9984755805732948 .05519524434968994
       .6669999223036375 .745057785441466
       .901348847046022 .43309381885315196
       .33110630575987643 .9435934581619604
       .9685220942744173 .24892760574572018
       .508830142543107 .8608669386377673
       .799537269107905 .600616479383869
       .14065823933284924 .9900582102622971
       .9882575677307495 .15279718525844344
       .5907597018588743 .8068475535437992
       .8545579883654005 .5193559901655896
       .2370236059943672 .9715038909862518
       .9394592236021899 .3426607173119944
       .4220002707997997 .9065957045149153
       .7368165688773699 .6760927035753159
       .04293825693494082 .9990777277526454
       .9995294175010931 .030674803176636626
       .6850836677727004 .7284643904482252
       .9117060320054299 .41084317105790397
       .3541635254204904 .9351835099389476
       .9743393827855759 .22508391135979283
       .5298036246862947 .8481203448032972
       .8140363297059484 .5808139580957645
       .16491312048996992 .9863080972445987
       .9917097536690995 .12849811079379317
       .6103828062763095 .7921065773002124
       .8670462455156926 .49822766697278187
       .2607941179152755 .9653944416976894
       .9475855910177411 .3195020308160157
       .44412214457042926 .8959662497561851
       .7531867990436125 .6578066932970786
       .06744391956366406 .9977230666441916
       .9968202992911657 .07968243797143013
       .6485144010221124 .7612023854842618
       .8904487232447579 .45508358712634384
       .30784964004153487 .9514350209690083
       .9621214042690416 .272621355449949
       .48755016014843594 .8730949784182901
       .7845565971555752 .6200572117632892
       .11631863091190477 .9932119492347945
       .984210092386929 .17700422041214875
       .5707807458869673 .8211025149911046
       .8415549774368984 .5401714727298929
       .21311031991609136 .9770281426577544
       .9307669610789837 .36561299780477385
       .39962419984564684 .9166790599210427
       .7200025079613817 .693971460889654
       .01840672990580482 .9998305817958234
       .9998305817958234 .01840672990580482
       .693971460889654 .7200025079613817
       .9166790599210427 .39962419984564684
       .36561299780477385 .9307669610789837
       .9770281426577544 .21311031991609136
       .5401714727298929 .8415549774368984
       .8211025149911046 .5707807458869673
       .17700422041214875 .984210092386929
       .9932119492347945 .11631863091190477
       .6200572117632892 .7845565971555752
       .8730949784182901 .48755016014843594
       .272621355449949 .9621214042690416
       .9514350209690083 .30784964004153487
       .45508358712634384 .8904487232447579
       .7612023854842618 .6485144010221124
       .07968243797143013 .9968202992911657
       .9977230666441916 .06744391956366406
       .6578066932970786 .7531867990436125
       .8959662497561851 .44412214457042926
       .3195020308160157 .9475855910177411
       .9653944416976894 .2607941179152755
       .49822766697278187 .8670462455156926
       .7921065773002124 .6103828062763095
       .12849811079379317 .9917097536690995
       .9863080972445987 .16491312048996992
       .5808139580957645 .8140363297059484
       .8481203448032972 .5298036246862947
       .22508391135979283 .9743393827855759
       .9351835099389476 .3541635254204904
       .41084317105790397 .9117060320054299
       .7284643904482252 .6850836677727004
       .030674803176636626 .9995294175010931
       .9990777277526454 .04293825693494082
       .6760927035753159 .7368165688773699
       .9065957045149153 .4220002707997997
       .3426607173119944 .9394592236021899
       .9715038909862518 .2370236059943672
       .5193559901655896 .8545579883654005
       .8068475535437992 .5907597018588743
       .15279718525844344 .9882575677307495
       .9900582102622971 .14065823933284924
       .600616479383869 .799537269107905
       .8608669386377673 .508830142543107
       .24892760574572018 .9685220942744173
       .9435934581619604 .33110630575987643
       .43309381885315196 .901348847046022
       .745057785441466 .6669999223036375
       .05519524434968994 .9984755805732948
       .9957674144676598 .09190895649713272
       .6391244448637757 .7691033376455796
       .8847970984309378 .4659764957679662
       .29615088824362384 .9551411683057707
       .9587034748958716 .2844075372112718
       .47679923006332214 .8790122264286335
       .7768884656732324 .629638238914927
       .10412163387205457 .9945645707342554
       .9819638691095552 .18906866414980622
       .560661576197336 .8280450452577558
       .83486287498638 .5504579729366048
       .2011046348420919 .9795697656854405
       .9262102421383114 .37700741021641826
       .3883450466988263 .9215140393420419
       .7114321957452164 .7027547444572253
       .006135884649154475 .9999811752826011
       .9999952938095762 .003067956762965976
       .7049340803759049 .7092728264388657
       .9227011283338785 .38551605384391885
       .37984720892405116 .9250492407826776
       .9801821359681174 .1980984107179536
       .5530167055800276 .8331701647019132
       .829761233794523 .5581185312205561
       .19208039704989244 .9813791933137546
       .9948793307948056 .10106986275482782
       .6320187359398091 .7749531065948739
       .8804708890521608 .47410021465055
       .2873474595447295 .9578264130275329
       .9560452513499964 .29321916269425863
       .46868882203582796 .8833633386657316
       .7710605242618138 .6367618612362842
       .094963495329639 .9954807554919269
       .9986402181802653 .052131704680283324
       .6692825883466361 .7430079521351217
       .9026733182372588 .4303264813400826
       .3339996514420094 .9425731976014469
       .9692812353565485 .24595505033579462
       .5114688504379704 .8593018183570084
       .8013761717231402 .5981607069963423
       .14369503315029444 .9896220174632009
       .9887216919603238 .1497645346773215
       .5932322950397998 .8050313311429635
       .8561473283751945 .5167317990176499
       .2400030224487415 .9707721407289504
       .9405060705932683 .33977688440682685
       .4247796812091088 .9052967593181188
       .7388873244606151 .673829000378756
       .04600318213091463 .9989412931868569
       .9996188224951786 .027608145778965743
       .6873153408917592 .726359155084346
       .9129621904283982 .4080441628649787
       .35703096123343003 .9340925504042589
       .9750253450669941 .22209362097320354
       .532403127877198 .8464909387740521
       .8158144108067338 .5783137964116556
       .16793829497473117 .9857975091675675
       .9920993131421918 .12545498341154623
       .6128100824294097 .79023022143731
       .8685707059713409 .49556526182577254
       .2637546789748314 .9645897932898128
       .9485613499157303 .31659337555616585
       .4468688401623742 .8945994856313827
       .7552013768965365 .6554928529996153
       .07050457338961387 .9975114561403035
       .997060070339483 .07662386139203149
       .6508466849963809 .7592091889783881
       .8918407093923427 .4523495872337709
       .3107671527496115 .9504860739494817
       .9629532668736839 .2696683255729151
       .49022648328829116 .8715950866559511
       .7864552135990858 .617647307937804
       .11936521481099137 .9928504144598651
       .9847485018019042 .17398387338746382
       .5732971666980422 .819347520076797
       .8432082396418454 .5375870762956455
       .21610679707621952 .9763697313300211
       .9318842655816681 .3627557243673972
       .40243465085941843 .9154487160882678
       .7221281939292153 .6917592583641577
       .021474080275469508 .9997694053512153
       .9998823474542126 .015339206284988102
       .696177131491463 .7178700450557317
       .9179007756213905 .3968099874167103
       .3684668299533723 .9296408958431812
       .9776773578245099 .2101118368804696
       .5427507848645159 .8398937941959995
       .8228497813758263 .5682589526701316
       .18002290140569951 .9836624192117303
       .9935641355205953 .11327095217756435
       .62246127937415 .7826505961665757
       .8745866522781761 .4848692480007911
       .27557181931095814 .9612804858113206
       .9523750127197659 .30492922973540243
       .45781330359887723 .8890483558546646
       .7631884172633813 .6461760129833164
       .08274026454937569 .9965711457905548
       .997925286198596 .06438263092985747
       .6601143420674205 .7511651319096864
       .8973245807054183 .44137126873171667
       .32240767880106985 .9466009130832835
       .9661900034454125 .257831102162159
       .5008853826112408 .8655136240905691
       .7939754775543372 .6079497849677736
       .13154002870288312 .9913108598461154
       .9868094018141855 .16188639378011183
       .5833086529376983 .8122505865852039
       .8497417680008524 .5271991347819014
       .22807208317088573 .973644249650812
       .9362656671702783 .35129275608556715
       .41363831223843456 .9104412922580672
       .7305627692278276 .6828455463852481
       .03374117185137759 .9994306045554617
       .9992047586183639 .03987292758773981
       .6783500431298615 .7347388780959635
       .9078861164876663 .41921688836322396
       .34554132496398904 .9384035340631081
       .9722264970789363 .23404195858354343
       .5219752929371544 .8529606049303636
       .808656181588175 .5882815482226453
       .15582839765426523 .9877841416445722
       .9904850842564571 .13762012158648604
       .6030665985403482 .7976908409433912
       .8624239561110405 .5061866453451553
       .25189781815421697 .9677538370934755
       .9446048372614803 .32820984357909255
       .4358570799222555 .9000158920161603
       .7471006059801801 .6647109782033449
       .05825826450043576 .9983015449338929
       .996044700901252 .0888535525825246
       .6414810128085832 .7671389119358204
       .8862225301488806 .4632597835518602
       .2990798263080405 .9542280951091057
       .9595715130819845 .281464937925758
       .479493757660153 .8775452902072612
       .778816512381476 .6272518154951441
       .10717242495680884 .9942404494531879
       .9825393022874412 .18605515166344666
       .5631993440138341 .8263210628456635
       .836547727223512 .5478940591731002
       .20410896609281687 .9789481753190622
       .9273625256504011 .374164062971458
       .39117038430225387 .9203182767091106
       .7135848687807936 .7005687939432483
       .00920375478205982 .9999576445519639
       .9999576445519639 .00920375478205982
       .7005687939432483 .7135848687807936
       .9203182767091106 .39117038430225387
       .374164062971458 .9273625256504011
       .9789481753190622 .20410896609281687
       .5478940591731002 .836547727223512
       .8263210628456635 .5631993440138341
       .18605515166344666 .9825393022874412
       .9942404494531879 .10717242495680884
       .6272518154951441 .778816512381476
       .8775452902072612 .479493757660153
       .281464937925758 .9595715130819845
       .9542280951091057 .2990798263080405
       .4632597835518602 .8862225301488806
       .7671389119358204 .6414810128085832
       .0888535525825246 .996044700901252
       .9983015449338929 .05825826450043576
       .6647109782033449 .7471006059801801
       .9000158920161603 .4358570799222555
       .32820984357909255 .9446048372614803
       .9677538370934755 .25189781815421697
       .5061866453451553 .8624239561110405
       .7976908409433912 .6030665985403482
       .13762012158648604 .9904850842564571
       .9877841416445722 .15582839765426523
       .5882815482226453 .808656181588175
       .8529606049303636 .5219752929371544
       .23404195858354343 .9722264970789363
       .9384035340631081 .34554132496398904
       .41921688836322396 .9078861164876663
       .7347388780959635 .6783500431298615
       .03987292758773981 .9992047586183639
       .9994306045554617 .03374117185137759
       .6828455463852481 .7305627692278276
       .9104412922580672 .41363831223843456
       .35129275608556715 .9362656671702783
       .973644249650812 .22807208317088573
       .5271991347819014 .8497417680008524
       .8122505865852039 .5833086529376983
       .16188639378011183 .9868094018141855
       .9913108598461154 .13154002870288312
       .6079497849677736 .7939754775543372
       .8655136240905691 .5008853826112408
       .257831102162159 .9661900034454125
       .9466009130832835 .32240767880106985
       .44137126873171667 .8973245807054183
       .7511651319096864 .6601143420674205
       .06438263092985747 .997925286198596
       .9965711457905548 .08274026454937569
       .6461760129833164 .7631884172633813
       .8890483558546646 .45781330359887723
       .30492922973540243 .9523750127197659
       .9612804858113206 .27557181931095814
       .4848692480007911 .8745866522781761
       .7826505961665757 .62246127937415
       .11327095217756435 .9935641355205953
       .9836624192117303 .18002290140569951
       .5682589526701316 .8228497813758263
       .8398937941959995 .5427507848645159
       .2101118368804696 .9776773578245099
       .9296408958431812 .3684668299533723
       .3968099874167103 .9179007756213905
       .7178700450557317 .696177131491463
       .015339206284988102 .9998823474542126
       .9997694053512153 .021474080275469508
       .6917592583641577 .7221281939292153
       .9154487160882678 .40243465085941843
       .3627557243673972 .9318842655816681
       .9763697313300211 .21610679707621952
       .5375870762956455 .8432082396418454
       .819347520076797 .5732971666980422
       .17398387338746382 .9847485018019042
       .9928504144598651 .11936521481099137
       .617647307937804 .7864552135990858
       .8715950866559511 .49022648328829116
       .2696683255729151 .9629532668736839
       .9504860739494817 .3107671527496115
       .4523495872337709 .8918407093923427
       .7592091889783881 .6508466849963809
       .07662386139203149 .997060070339483
       .9975114561403035 .07050457338961387
       .6554928529996153 .7552013768965365
       .8945994856313827 .4468688401623742
       .31659337555616585 .9485613499157303
       .9645897932898128 .2637546789748314
       .49556526182577254 .8685707059713409
       .79023022143731 .6128100824294097
       .12545498341154623 .9920993131421918
       .9857975091675675 .16793829497473117
       .5783137964116556 .8158144108067338
       .8464909387740521 .532403127877198
       .22209362097320354 .9750253450669941
       .9340925504042589 .35703096123343003
       .4080441628649787 .9129621904283982
       .726359155084346 .6873153408917592
       .027608145778965743 .9996188224951786
       .9989412931868569 .04600318213091463
       .673829000378756 .7388873244606151
       .9052967593181188 .4247796812091088
       .33977688440682685 .9405060705932683
       .9707721407289504 .2400030224487415
       .5167317990176499 .8561473283751945
       .8050313311429635 .5932322950397998
       .1497645346773215 .9887216919603238
       .9896220174632009 .14369503315029444
       .5981607069963423 .8013761717231402
       .8593018183570084 .5114688504379704
       .24595505033579462 .9692812353565485
       .9425731976014469 .3339996514420094
       .4303264813400826 .9026733182372588
       .7430079521351217 .6692825883466361
       .052131704680283324 .9986402181802653
       .9954807554919269 .094963495329639
       .6367618612362842 .7710605242618138
       .8833633386657316 .46868882203582796
       .29321916269425863 .9560452513499964
       .9578264130275329 .2873474595447295
       .47410021465055 .8804708890521608
       .7749531065948739 .6320187359398091
       .10106986275482782 .9948793307948056
       .9813791933137546 .19208039704989244
       .5581185312205561 .829761233794523
       .8331701647019132 .5530167055800276
       .1980984107179536 .9801821359681174
       .9250492407826776 .37984720892405116
       .38551605384391885 .9227011283338785
       .7092728264388657 .7049340803759049
       .003067956762965976 .9999952938095762
       ))

    (define med-lut
    '#f64(1. 0.
       .9999999999820472 5.9921124526424275e-6
       .9999999999281892 1.1984224905069707e-5
       .9999999998384257 1.7976337357066685e-5
       .9999999997127567 2.396844980841822e-5
       .9999999995511824 2.9960562258909154e-5
       .9999999993537025 3.5952674708324344e-5
       .9999999991203175 4.1944787156448635e-5
       .9999999988510269 4.793689960306688e-5
       .9999999985458309 5.3929012047963936e-5
       .9999999982047294 5.992112449092465e-5
       .9999999978277226 6.591323693173387e-5
       .9999999974148104 7.190534937017645e-5
       .9999999969659927 7.789746180603723e-5
       .9999999964812697 8.388957423910108e-5
       .9999999959606412 8.988168666915283e-5
       .9999999954041073 9.587379909597734e-5
       .999999994811668 1.0186591151935948e-4
       .9999999941833233 1.0785802393908407e-4
       .9999999935190732 1.1385013635493597e-4
       .9999999928189177 1.1984224876670004e-4
       .9999999920828567 1.2583436117416112e-4
       .9999999913108903 1.3182647357710405e-4
       .9999999905030187 1.3781858597531374e-4
       .9999999896592414 1.4381069836857496e-4
       .9999999887795589 1.498028107566726e-4
       .9999999878639709 1.5579492313939151e-4
       .9999999869124775 1.6178703551651655e-4
       .9999999859250787 1.6777914788783258e-4
       .9999999849017744 1.737712602531244e-4
       .9999999838425648 1.797633726121769e-4
       .9999999827474497 1.8575548496477492e-4
       .9999999816164293 1.9174759731070332e-4
       .9999999804495034 1.9773970964974692e-4
       .9999999792466722 2.037318219816906e-4
       .9999999780079355 2.0972393430631923e-4
       .9999999767332933 2.1571604662341763e-4
       .9999999754227459 2.2170815893277063e-4
       .9999999740762929 2.2770027123416315e-4
       .9999999726939346 2.3369238352737996e-4
       .9999999712756709 2.3968449581220595e-4
       .9999999698215016 2.45676608088426e-4
       .9999999683314271 2.5166872035582493e-4
       .9999999668054471 2.5766083261418755e-4
       .9999999652435617 2.636529448632988e-4
       .9999999636457709 2.696450571029434e-4
       .9999999620120748 2.756371693329064e-4
       .9999999603424731 2.8162928155297243e-4
       .9999999586369661 2.876213937629265e-4
       .9999999568955537 2.936135059625534e-4
       .9999999551182358 2.99605618151638e-4
       .9999999533050126 3.055977303299651e-4
       .9999999514558838 3.115898424973196e-4
       .9999999495708498 3.1758195465348636e-4
       .9999999476499103 3.235740667982502e-4
       .9999999456930654 3.2956617893139595e-4
       .9999999437003151 3.3555829105270853e-4
       .9999999416716594 3.4155040316197275e-4
       .9999999396070982 3.475425152589734e-4
       .9999999375066316 3.535346273434955e-4
       .9999999353702598 3.595267394153237e-4
       .9999999331979824 3.6551885147424295e-4
       .9999999309897996 3.7151096352003814e-4
       .9999999287457114 3.7750307555249406e-4
       .9999999264657179 3.8349518757139556e-4
       .9999999241498189 3.8948729957652753e-4
       .9999999217980144 3.954794115676748e-4
       .9999999194103046 4.0147152354462224e-4
       .9999999169866894 4.0746363550715466e-4
       .9999999145271687 4.134557474550569e-4
       .9999999120317428 4.194478593881139e-4
       .9999999095004113 4.2543997130611036e-4
       .9999999069331744 4.314320832088313e-4
       .9999999043300322 4.3742419509606144e-4
       .9999999016909845 4.4341630696758576e-4
       .9999998990160315 4.4940841882318896e-4
       .9999998963051729 4.55400530662656e-4
       .999999893558409 4.613926424857717e-4
       .9999998907757398 4.673847542923209e-4
       .9999998879571651 4.7337686608208844e-4
       .9999998851026849 4.793689778548592e-4
       .9999998822122994 4.8536108961041806e-4
       .9999998792860085 4.913532013485497e-4
       .9999998763238122 4.973453130690393e-4
       .9999998733257104 5.033374247716714e-4
       .9999998702917032 5.09329536456231e-4
       .9999998672217907 5.153216481225028e-4
       .9999998641159727 5.213137597702719e-4
       .9999998609742493 5.27305871399323e-4
       .9999998577966206 5.332979830094408e-4
       .9999998545830864 5.392900946004105e-4
       .9999998513336468 5.452822061720168e-4
       .9999998480483018 5.512743177240444e-4
       .9999998447270514 5.572664292562783e-4
       .9999998413698955 5.632585407685033e-4
       .9999998379768343 5.692506522605043e-4
       .9999998345478677 5.752427637320661e-4
       .9999998310829956 5.812348751829735e-4
       .9999998275822183 5.872269866130116e-4
       .9999998240455354 5.93219098021965e-4
       .9999998204729471 5.992112094096185e-4
       .9999998168644535 6.052033207757572e-4
       .9999998132200545 6.111954321201659e-4
       .99999980953975 6.171875434426292e-4
       .9999998058235401 6.231796547429323e-4
       .9999998020714248 6.291717660208597e-4
       .9999997982834041 6.351638772761965e-4
       .9999997944594781 6.411559885087275e-4
       .9999997905996466 6.471480997182375e-4
       .9999997867039097 6.531402109045114e-4
       .9999997827722674 6.591323220673341e-4
       .9999997788047197 6.651244332064902e-4
       .9999997748012666 6.711165443217649e-4
       .9999997707619082 6.771086554129428e-4
       .9999997666866443 6.83100766479809e-4
       .9999997625754748 6.89092877522148e-4
       .9999997584284002 6.950849885397449e-4
       .9999997542454201 7.010770995323844e-4
       .9999997500265345 7.070692104998515e-4
       .9999997457717437 7.130613214419311e-4
       .9999997414810473 7.190534323584079e-4
       .9999997371544456 7.250455432490666e-4
       .9999997327919384 7.310376541136925e-4
       .9999997283935259 7.3702976495207e-4
       .999999723959208 7.430218757639842e-4
       .9999997194889846 7.490139865492199e-4
       .9999997149828559 7.55006097307562e-4
       .9999997104408218 7.609982080387952e-4
       .9999997058628822 7.669903187427045e-4
       .9999997012490373 7.729824294190747e-4
       .9999996965992869 7.789745400676906e-4
       .9999996919136313 7.849666506883372e-4
       .99999968719207 7.909587612807992e-4
       .9999996824346035 7.969508718448614e-4
       .9999996776412315 8.029429823803089e-4
       .9999996728119542 8.089350928869263e-4
       .9999996679467715 8.149272033644986e-4
       .9999996630456833 8.209193138128106e-4
       .9999996581086897 8.269114242316472e-4
       .9999996531357909 8.329035346207931e-4
       .9999996481269865 8.388956449800333e-4
       .9999996430822767 8.448877553091527e-4
       .9999996380016616 8.508798656079359e-4
       .999999632885141 8.56871975876168e-4
       .9999996277327151 8.628640861136338e-4
       .9999996225443838 8.68856196320118e-4
       .9999996173201471 8.748483064954056e-4
       .999999612060005 8.808404166392814e-4
       .9999996067639574 8.868325267515304e-4
       .9999996014320045 8.928246368319371e-4
       .9999995960641462 8.988167468802867e-4
       .9999995906603825 9.048088568963639e-4
       .9999995852207133 9.108009668799535e-4
       .9999995797451389 9.167930768308405e-4
       .9999995742336589 9.227851867488095e-4
       .9999995686862736 9.287772966336457e-4
       .9999995631029829 9.347694064851338e-4
       .9999995574837868 9.407615163030585e-4
       .9999995518286853 9.467536260872047e-4
       .9999995461376784 9.527457358373575e-4
       .9999995404107661 9.587378455533015e-4
       .9999995346479484 9.647299552348216e-4
       .9999995288492254 9.707220648817027e-4
       .9999995230145969 9.767141744937296e-4
       .9999995171440631 9.827062840706872e-4
       .9999995112376238 9.886983936123602e-4
       .9999995052952791 9.946905031185337e-4
       .9999994993170291 .0010006826125889925
       .9999994933028736 .0010066747220235214
       .9999994872528128 .001012666831421905
       .9999994811668466 .0010186589407839286
       .999999475044975 .0010246510501093766
       .9999994688871979 .0010306431593980344
       .9999994626935156 .0010366352686496862
       .9999994564639277 .0010426273778641173
       .9999994501984345 .0010486194870411127
       .999999443897036 .0010546115961804568
       .999999437559732 .0010606037052819344
       .9999994311865227 .0010665958143453308
       .9999994247774079 .0010725879233704307
       .9999994183323877 .0010785800323570187
       .9999994118514622 .0010845721413048801
       .9999994053346313 .0010905642502137994
       .9999993987818949 .0010965563590835613
       .9999993921932533 .0011025484679139511
       .9999993855687062 .0011085405767047535
       .9999993789082536 .0011145326854557532
       .9999993722118957 .001120524794166735
       .9999993654796325 .0011265169028374842
       .9999993587114638 .0011325090114677853
       .9999993519073898 .001138501120057423
       .9999993450674104 .0011444932286061825
       .9999993381915255 .0011504853371138485
       .9999993312797354 .0011564774455802057
       .9999993243320398 .0011624695540050393
       .9999993173484387 .001168461662388134
       .9999993103289324 .0011744537707292742
       .9999993032735206 .0011804458790282454
       .9999992961822035 .0011864379872848323
       .9999992890549809 .0011924300954988195
       .999999281891853 .001198422203669992
       .9999992746928197 .0012044143117981348
       .999999267457881 .0012104064198830327
       .999999260187037 .0012163985279244702
       .9999992528802875 .0012223906359222325
       .9999992455376326 .0012283827438761045
       .9999992381590724 .0012343748517858707
       .9999992307446068 .0012403669596513162
       .9999992232942359 .001246359067472226
       .9999992158079595 .0012523511752483847
       .9999992082857777 .001258343282979577
       .9999992007276906 .001264335390665588
       .999999193133698 .0012703274983062026
       .9999991855038001 .0012763196059012057
       .9999991778379967 .001282311713450382
       .9999991701362881 .0012883038209535163
       .999999162398674 .0012942959284103935
       .9999991546251547 .0013002880358207985
       .9999991468157298 .001306280143184516
       .9999991389703996 .001312272250501331
       .999999131089164 .0013182643577710285
       .999999123172023 .0013242564649933932
       .9999991152189767 .0013302485721682098
       .9999991072300249 .001336240679295263
       .9999990992051678 .0013422327863743383
       .9999990911444054 .0013482248934052201
       .9999990830477375 .0013542170003876934
       .9999990749151643 .001360209107321543
       .9999990667466857 .0013662012142065536
       .9999990585423016 .0013721933210425101
       .9999990503020123 .0013781854278291975
       .9999990420258176 .0013841775345664006
       .9999990337137175 .0013901696412539043
       .999999025365712 .0013961617478914935
       .999999016981801 .0014021538544789526
       .9999990085619848 .001408145961016067
       .9999990001062631 .0014141380675026214
       .9999989916146361 .0014201301739384005
       .9999989830871038 .0014261222803231893
       .9999989745236659 .0014321143866567725
       .9999989659243228 .001438106492938935
       .9999989572890743 .0014440985991694619
       .9999989486179204 .0014500907053481378
       .9999989399108612 .0014560828114747475
       .9999989311678965 .0014620749175490758
       .9999989223890265 .001468067023570908
       .9999989135742512 .0014740591295400284
       .9999989047235704 .0014800512354562223
       .9999988958369843 .0014860433413192743
       .9999988869144928 .0014920354471289693
       .9999988779560959 .0014980275528850922
       .9999988689617937 .0015040196585874275
       .9999988599315861 .0015100117642357607
       .999998850865473 .0015160038698298762
       .9999988417634548 .001521995975369559
       .999998832625531 .0015279880808545937
       .9999988234517019 .0015339801862847657
       .9999988142419675 .0015399722916598592
       .9999988049963277 .0015459643969796596
       .9999987957147825 .0015519565022439512
       .9999987863973319 .0015579486074525195
       .9999987770439759 .001563940712605149
       .9999987676547146 .0015699328177016243
       .999998758229548 .0015759249227417307
       .9999987487684759 .0015819170277252528
       .9999987392714985 .0015879091326519755
       .9999987297386157 .0015939012375216837
       .9999987201698276 .0015998933423341623
       .9999987105651341 .001605885447089196
       .9999987009245352 .0016118775517865696
       .999998691248031 .0016178696564260683
       .9999986815356214 .0016238617610074765
       .9999986717873064 .0016298538655305794
       .9999986620030861 .0016358459699951618
       .9999986521829605 .0016418380744010084
       .9999986423269294 .0016478301787479041
       .999998632434993 .0016538222830356339
       .9999986225071512 .0016598143872639823
       .999998612543404 .0016658064914327345
       .9999986025437515 .0016717985955416754
       .9999985925081937 .0016777906995905894
       .9999985824367305 .0016837828035792617
       .9999985723293618 .0016897749075074774
       .999998562186088 .0016957670113750207
       .9999985520069086 .0017017591151816769
       .9999985417918239 .0017077512189272307
       .999998531540834 .001713743322611467
       .9999985212539385 .0017197354262341706
       .9999985109311378 .0017257275297951264
       .9999985005724317 .0017317196332941192
       .9999984901778203 .0017377117367309341
       .9999984797473034 .0017437038401053556
       .9999984692808812 .0017496959434171687
       .9999984587785538 .0017556880466661582
       .9999984482403208 .001761680149852109
       .9999984376661826 .0017676722529748061
       .999998427056139 .0017736643560340342
       .99999841641019 .001779656459029578
       .9999984057283358 .0017856485619612225
       .9999983950105761 .0017916406648287528
       .999998384256911 .0017976327676319532
       .9999983734673407 .001803624870370609
       .9999983626418649 .0018096169730445048
       .9999983517804839 .0018156090756534257
       .9999983408831975 .0018216011781971562
       .9999983299500057 .0018275932806754815
       .9999983189809085 .0018335853830881864
       .999998307975906 .0018395774854350557
       .9999982969349982 .001845569587715874
       .9999982858581851 .0018515616899304264
       .9999982747454665 .001857553792078498
       .9999982635968426 .001863545894159873
       .9999982524123134 .0018695379961743367
       .9999982411918789 .001875530098121674
       .9999982299355389 .0018815222000016696
       .9999982186432936 .0018875143018141083
       .999998207315143 .0018935064035587748
       .999998195951087 .0018994985052354545
       .9999981845511257 .0019054906068439318
       .9999981731152591 .0019114827083839918
       .999998161643487 .001917474809855419
       .9999981501358096 .0019234669112579987
       .999998138592227 .0019294590125915154
       .9999981270127389 .0019354511138557542
       .9999981153973455 .0019414432150504997
       .9999981037460468 .0019474353161755369
       .9999980920588427 .001953427417230651
       .9999980803357332 .001959419518215626
       .9999980685767185 .0019654116191302473
       .9999980567817984 .0019714037199743
       .9999980449509729 .0019773958207475683
       .9999980330842422 .0019833879214498375
       .999998021181606 .001989380022080892
       .9999980092430646 .0019953721226405176
       .9999979972686177 .002001364223128498
       .9999979852582656 .002007356323544619
       .9999979732120081 .002013348423888665
       .9999979611298453 .002019340524160421
       .9999979490117771 .0020253326243596715
       .9999979368578036 .0020313247244862017
       .9999979246679247 .002037316824539796
       .9999979124421405 .00204330892452024
       .999997900180451 .002049301024427318
       .9999978878828562 .0020552931242608153
       .9999978755493559 .002061285224020516
       .9999978631799504 .0020672773237062057
       .9999978507746395 .002073269423317669
       .9999978383334234 .0020792615228546903
       .9999978258563018 .002085253622317055
       .999997813343275 .0020912457217045484
       .9999978007943428 .002097237821016954
       .9999977882095052 .0021032299202540577
       .9999977755887623 .0021092220194156444
       .9999977629321142 .0021152141185014984
       .9999977502395607 .0021212062175114043
       .9999977375111019 .002127198316445148
       .9999977247467376 .0021331904153025134
       .9999977119464681 .002139182514083286
       .9999976991102932 .0021451746127872503
       .9999976862382131 .002151166711414191
       .9999976733302276 .0021571588099638934
       .9999976603863368 .0021631509084361423
       .9999976474065406 .002169143006830722
       .9999976343908391 .002175135105147418
       .9999976213392323 .0021811272033860148
       .9999976082517201 .002187119301546297
       .9999975951283027 .00219311139962805
       .9999975819689799 .0021991034976310588
       .9999975687737518 .0022050955955551076
       .9999975555426184 .0022110876933999816
       .9999975422755796 .0022170797911654654
       .9999975289726355 .002223071888851344
       .9999975156337861 .0022290639864574026
       .9999975022590314 .0022350560839834253
       .9999974888483714 .002241048181429198
       .999997475401806 .0022470402787945045
       .9999974619193353 .00225303237607913
       .9999974484009593 .0022590244732828596
       .9999974348466779 .0022650165704054784
       .9999974212564913 .0022710086674467703
       .9999974076303992 .002277000764406521
       .9999973939684019 .002282992861284515
       .9999973802704993 .0022889849580805368
       .9999973665366915 .0022949770547943723
       .9999973527669782 .0023009691514258054
       .9999973389613596 .002306961247974621
       .9999973251198357 .0023129533444406045
       .9999973112424065 .0023189454408235406
       .999997297329072 .0023249375371232135
       .9999972833798322 .002330929633339409
       .999997269394687 .0023369217294719113
       .9999972553736366 .0023429138255205055
       .9999972413166809 .0023489059214849765
       .9999972272238198 .002354898017365109
       .9999972130950534 .0023608901131606883
       .9999971989303816 .0023668822088714985
       .9999971847298047 .0023728743044973246
       .9999971704933224 .0023788664000379523
       .9999971562209347 .0023848584954931653
       .9999971419126418 .0023908505908627493
       .9999971275684435 .0023968426861464883
       .99999711318834 .002402834781344168
       .9999970987723311 .0024088268764555732
       .9999970843204169 .002414818971480488
       .9999970698325974 .002420811066418698
       .9999970553088726 .0024268031612699878
       .9999970407492426 .002432795256034142
       .9999970261537071 .002438787350710946
       .9999970115222664 .002444779445300184
       .9999969968549204 .0024507715398016418
       .9999969821516691 .002456763634215103
       .9999969674125124 .002462755728540353
       .9999969526374506 .0024687478227771774
       .9999969378264834 .00247473991692536
       .9999969229796108 .002480732010984686
       .999996908096833 .0024867241049549406
       .9999968931781499 .002492716198835908
       .9999968782235614 .0024987082926273734
       .9999968632330677 .002504700386329122
       .9999968482066687 .002510692479940938
       .9999968331443644 .0025166845734626068
       .9999968180461547 .0025226766668939127
       .9999968029120399 .002528668760234641
       .9999967877420196 .002534660853484576
       .9999967725360941 .0025406529466435036
       .9999967572942633 .002546645039711208
       .9999967420165272 .002552637132687474
       .9999967267028858 .002558629225572086
       .9999967113533391 .0025646213183648297
       .9999966959678871 .0025706134110654896
       .9999966805465298 .002576605503673851
       .9999966650892672 .0025825975961896977
       .9999966495960994 .0025885896886128153
       .9999966340670262 .0025945817809429885
       .9999966185020478 .0026005738731800024
       .9999966029011641 .0026065659653236417
       .999996587264375 .002612558057373691
       .9999965715916808 .002618550149329935
       .9999965558830811 .0026245422411921592
       .9999965401385762 .002630534332960148
       .9999965243581661 .002636526424633687
       .9999965085418506 .0026425185162125596
       .9999964926896299 .0026485106076965517
       .9999964768015038 .0026545026990854484
       .9999964608774725 .0026604947903790337
       .9999964449175359 .0026664868815770926
       .999996428921694 .0026724789726794104
       .9999964128899468 .002678471063685772
       .9999963968222944 .0026844631545959617
       .9999963807187366 .002690455245409765
       .9999963645792737 .002696447336126966
       .9999963484039053 .00270243942674735
       .9999963321926317 .002708431517270702
       .9999963159454529 .0027144236076968066
       .9999962996623687 .0027204156980254485
       .9999962833433793 .002726407788256413
       .9999962669884847 .002732399878389485
       .9999962505976846 .0027383919684244484
       .9999962341709794 .002744384058361089
       .9999962177083689 .0027503761481991913
       .999996201209853 .0027563682379385403
       .9999961846754319 .0027623603275789207
       .9999961681051056 .0027683524171201175
       .999996151498874 .002774344506561915
       .9999961348567371 .002780336595904099
       .9999961181786949 .0027863286851464537
       .9999961014647475 .0027923207742887642
       .9999960847148948 .0027983128633308155
       .9999960679291368 .002804304952272392
       .9999960511074735 .002810297041113279
       .9999960342499049 .0028162891298532606
       .9999960173564312 .0028222812184921227
       .9999960004270521 .002828273307029649
       .9999959834617678 .002834265395465626
       .9999959664605781 .0028402574837998367
       .9999959494234832 .002846249572032067
       .9999959323504831 .0028522416601621014
       .9999959152415777 .002858233748189725
       .999995898096767 .002864225836114723
       .9999958809160512 .0028702179239368793
       .9999958636994299 .0028762100116559793
       .9999958464469034 .0028822020992718077
       .9999958291584717 .0028881941867841495
       .9999958118341348 .0028941862741927895
       .9999957944738925 .0029001783614975127
       .999995777077745 .002906170448698104
       .9999957596456922 .0029121625357943475
       .9999957421777342 .002918154622786029
       .999995724673871 .0029241467096729327
       .9999957071341024 .002930138796454844
       .9999956895584287 .0029361308831315474
       .9999956719468496 .0029421229697028273
       .9999956542993652 .0029481150561684695
       .9999956366159757 .0029541071425282584
       .9999956188966809 .002960099228781979
       .9999956011414808 .002966091314929416
       .9999955833503754 .002972083400970354
       .9999955655233649 .0029780754869045785
       .9999955476604491 .0029840675727318736
       .999995529761628 .002990059658452025
       .9999955118269016 .0029960517440648163
       .99999549385627 .0030020438295700336
       .9999954758497331 .0030080359149674612
       .999995457807291 .003014028000256884
       .9999954397289438 .003020020085438087
       .9999954216146911 .0030260121705108552
       .9999954034645333 .003032004255474973
       .9999953852784702 .003037996340330225
       .9999953670565019 .003043988425076397
       .9999953487986284 .003049980509713273
       .9999953305048496 .0030559725942406386
       .9999953121751655 .003061964678658278
       ))

    (define high-lut
    '#f64(1. 0.
       .9999999999999999 1.1703344634137277e-8
       .9999999999999998 2.3406689268274554e-8
       .9999999999999993 3.5110033902411824e-8
       .9999999999999989 4.6813378536549095e-8
       .9999999999999983 5.851672317068635e-8
       .9999999999999976 7.022006780482361e-8
       .9999999999999967 8.192341243896085e-8
       .9999999999999957 9.362675707309808e-8
       .9999999999999944 1.0533010170723531e-7
       .9999999999999931 1.170334463413725e-7
       .9999999999999917 1.287367909755097e-7
       .9999999999999901 1.4044013560964687e-7
       .9999999999999885 1.5214348024378403e-7
       .9999999999999866 1.6384682487792116e-7
       .9999999999999846 1.7555016951205827e-7
       .9999999999999825 1.8725351414619535e-7
       .9999999999999802 1.989568587803324e-7
       .9999999999999778 2.1066020341446942e-7
       .9999999999999752 2.2236354804860645e-7
       .9999999999999726 2.3406689268274342e-7
       .9999999999999698 2.4577023731688034e-7
       .9999999999999668 2.5747358195101726e-7
       .9999999999999638 2.6917692658515413e-7
       .9999999999999606 2.8088027121929094e-7
       .9999999999999571 2.9258361585342776e-7
       .9999999999999537 3.042869604875645e-7
       .99999999999995 3.159903051217012e-7
       .9999999999999463 3.276936497558379e-7
       .9999999999999424 3.3939699438997453e-7
       .9999999999999384 3.5110033902411114e-7
       .9999999999999342 3.6280368365824763e-7
       .9999999999999298 3.7450702829238413e-7
       .9999999999999254 3.8621037292652057e-7
       .9999999999999208 3.979137175606569e-7
       .9999999999999161 4.0961706219479325e-7
       .9999999999999113 4.2132040682892953e-7
       .9999999999999063 4.330237514630657e-7
       .9999999999999011 4.447270960972019e-7
       .9999999999998959 4.5643044073133796e-7
       .9999999999998904 4.68133785365474e-7
       .9999999999998849 4.7983712999961e-7
       .9999999999998792 4.915404746337459e-7
       .9999999999998733 5.032438192678817e-7
       .9999999999998674 5.149471639020175e-7
       .9999999999998613 5.266505085361531e-7
       .9999999999998551 5.383538531702888e-7
       .9999999999998487 5.500571978044243e-7
       .9999999999998422 5.617605424385598e-7
       .9999999999998356 5.734638870726952e-7
       .9999999999998288 5.851672317068305e-7
       .9999999999998219 5.968705763409657e-7
       .9999999999998148 6.085739209751009e-7
       .9999999999998076 6.202772656092359e-7
       .9999999999998003 6.319806102433709e-7
       .9999999999997928 6.436839548775058e-7
       .9999999999997853 6.553872995116406e-7
       .9999999999997775 6.670906441457753e-7
       .9999999999997696 6.7879398877991e-7
       .9999999999997616 6.904973334140445e-7
       .9999999999997534 7.02200678048179e-7
       .9999999999997452 7.139040226823132e-7
       .9999999999997368 7.256073673164475e-7
       .9999999999997282 7.373107119505817e-7
       .9999999999997194 7.490140565847157e-7
       .9999999999997107 7.607174012188497e-7
       .9999999999997017 7.724207458529835e-7
       .9999999999996926 7.841240904871172e-7
       .9999999999996834 7.958274351212508e-7
       .9999999999996739 8.075307797553844e-7
       .9999999999996644 8.192341243895178e-7
       .9999999999996547 8.309374690236511e-7
       .999999999999645 8.426408136577842e-7
       .9999999999996351 8.543441582919173e-7
       .999999999999625 8.660475029260503e-7
       .9999999999996148 8.777508475601831e-7
       .9999999999996044 8.894541921943158e-7
       .999999999999594 9.011575368284484e-7
       .9999999999995833 9.128608814625808e-7
       .9999999999995726 9.245642260967132e-7
       .9999999999995617 9.362675707308454e-7
       .9999999999995507 9.479709153649775e-7
       .9999999999995395 9.596742599991095e-7
       .9999999999995283 9.713776046332412e-7
       .9999999999995168 9.83080949267373e-7
       .9999999999995052 9.947842939015044e-7
       .9999999999994935 1.006487638535636e-6
       .9999999999994816 1.0181909831697673e-6
       .9999999999994696 1.0298943278038984e-6
       .9999999999994575 1.0415976724380293e-6
       .9999999999994453 1.0533010170721601e-6
       .9999999999994329 1.065004361706291e-6
       .9999999999994204 1.0767077063404215e-6
       .9999999999994077 1.088411050974552e-6
       .9999999999993949 1.1001143956086822e-6
       .9999999999993819 1.1118177402428122e-6
       .9999999999993688 1.1235210848769423e-6
       .9999999999993556 1.135224429511072e-6
       .9999999999993423 1.1469277741452017e-6
       .9999999999993288 1.1586311187793313e-6
       .9999999999993151 1.1703344634134605e-6
       .9999999999993014 1.1820378080475897e-6
       .9999999999992875 1.1937411526817187e-6
       .9999999999992735 1.2054444973158477e-6
       .9999999999992593 1.2171478419499764e-6
       .9999999999992449 1.2288511865841048e-6
       .9999999999992305 1.2405545312182331e-6
       .999999999999216 1.2522578758523615e-6
       .9999999999992012 1.2639612204864894e-6
       .9999999999991863 1.2756645651206173e-6
       .9999999999991713 1.287367909754745e-6
       .9999999999991562 1.2990712543888725e-6
       .9999999999991409 1.3107745990229998e-6
       .9999999999991255 1.3224779436571269e-6
       .9999999999991099 1.3341812882912537e-6
       .9999999999990943 1.3458846329253806e-6
       .9999999999990785 1.3575879775595072e-6
       .9999999999990625 1.3692913221936337e-6
       .9999999999990464 1.3809946668277597e-6
       .9999999999990302 1.3926980114618857e-6
       .9999999999990138 1.4044013560960117e-6
       .9999999999989974 1.4161047007301373e-6
       .9999999999989807 1.4278080453642627e-6
       .9999999999989639 1.439511389998388e-6
       .999999999998947 1.451214734632513e-6
       .99999999999893 1.462918079266638e-6
       .9999999999989128 1.4746214239007625e-6
       .9999999999988954 1.486324768534887e-6
       .999999999998878 1.4980281131690111e-6
       .9999999999988604 1.5097314578031353e-6
       .9999999999988426 1.5214348024372591e-6
       .9999999999988247 1.5331381470713828e-6
       .9999999999988067 1.544841491705506e-6
       .9999999999987886 1.5565448363396294e-6
       .9999999999987703 1.5682481809737524e-6
       .9999999999987519 1.579951525607875e-6
       .9999999999987333 1.5916548702419977e-6
       .9999999999987146 1.60335821487612e-6
       .9999999999986958 1.615061559510242e-6
       .9999999999986768 1.626764904144364e-6
       .9999999999986577 1.6384682487784858e-6
       .9999999999986384 1.6501715934126072e-6
       .9999999999986191 1.6618749380467283e-6
       .9999999999985996 1.6735782826808495e-6
       .9999999999985799 1.6852816273149702e-6
       .9999999999985602 1.6969849719490907e-6
       .9999999999985402 1.708688316583211e-6
       .9999999999985201 1.720391661217331e-6
       .9999999999985 1.732095005851451e-6
       .9999999999984795 1.7437983504855706e-6
       .9999999999984591 1.7555016951196899e-6
       .9999999999984385 1.767205039753809e-6
       .9999999999984177 1.778908384387928e-6
       .9999999999983968 1.7906117290220465e-6
       .9999999999983759 1.802315073656165e-6
       .9999999999983546 1.814018418290283e-6
       .9999999999983333 1.825721762924401e-6
       .9999999999983119 1.8374251075585186e-6
       .9999999999982904 1.8491284521926361e-6
       .9999999999982686 1.8608317968267533e-6
       .9999999999982468 1.8725351414608702e-6
       .9999999999982249 1.8842384860949866e-6
       .9999999999982027 1.8959418307291031e-6
       .9999999999981805 1.9076451753632194e-6
       .999999999998158 1.919348519997335e-6
       .9999999999981355 1.9310518646314507e-6
       .9999999999981128 1.942755209265566e-6
       .9999999999980901 1.954458553899681e-6
       .9999999999980671 1.966161898533796e-6
       .999999999998044 1.9778652431679103e-6
       .9999999999980208 1.9895685878020246e-6
       .9999999999979975 2.0012719324361386e-6
       .999999999997974 2.012975277070252e-6
       .9999999999979503 2.0246786217043656e-6
       .9999999999979265 2.0363819663384787e-6
       .9999999999979027 2.048085310972592e-6
       .9999999999978786 2.0597886556067045e-6
       .9999999999978545 2.0714920002408167e-6
       .9999999999978302 2.0831953448749286e-6
       .9999999999978058 2.0948986895090404e-6
       .9999999999977811 2.106602034143152e-6
       .9999999999977564 2.118305378777263e-6
       .9999999999977315 2.1300087234113738e-6
       .9999999999977065 2.1417120680454843e-6
       .9999999999976814 2.153415412679595e-6
       .9999999999976561 2.1651187573137046e-6
       .9999999999976307 2.1768221019478143e-6
       .9999999999976051 2.188525446581924e-6
       .9999999999975795 2.200228791216033e-6
       .9999999999975536 2.2119321358501417e-6
       .9999999999975278 2.22363548048425e-6
       .9999999999975017 2.2353388251183586e-6
       .9999999999974754 2.247042169752466e-6
       .999999999997449 2.2587455143865738e-6
       .9999999999974225 2.2704488590206814e-6
       .9999999999973959 2.282152203654788e-6
       .9999999999973691 2.293855548288895e-6
       .9999999999973422 2.305558892923001e-6
       .9999999999973151 2.317262237557107e-6
       .999999999997288 2.328965582191213e-6
       .9999999999972606 2.340668926825318e-6
       .9999999999972332 2.352372271459423e-6
       .9999999999972056 2.364075616093528e-6
       .9999999999971778 2.3757789607276323e-6
       .99999999999715 2.3874823053617365e-6
       .999999999997122 2.3991856499958403e-6
       .9999999999970938 2.4108889946299437e-6
       .9999999999970656 2.4225923392640466e-6
       .9999999999970371 2.4342956838981495e-6
       .9999999999970085 2.445999028532252e-6
       .9999999999969799 2.457702373166354e-6
       .999999999996951 2.4694057178004558e-6
       .999999999996922 2.4811090624345574e-6
       .9999999999968929 2.4928124070686583e-6
       .9999999999968637 2.504515751702759e-6
       .9999999999968343 2.5162190963368595e-6
       .9999999999968048 2.5279224409709594e-6
       .9999999999967751 2.5396257856050594e-6
       .9999999999967454 2.5513291302391585e-6
       .9999999999967154 2.5630324748732576e-6
       .9999999999966853 2.5747358195073563e-6
       .9999999999966551 2.5864391641414546e-6
       .9999999999966248 2.5981425087755525e-6
       .9999999999965944 2.6098458534096503e-6
       .9999999999965637 2.6215491980437473e-6
       .999999999996533 2.6332525426778443e-6
       .9999999999965021 2.644955887311941e-6
       .999999999996471 2.656659231946037e-6
       .99999999999644 2.6683625765801328e-6
       .9999999999964087 2.680065921214228e-6
       .9999999999963772 2.6917692658483234e-6
       .9999999999963456 2.703472610482418e-6
       .999999999996314 2.7151759551165123e-6
       .9999999999962821 2.7268792997506064e-6
       .9999999999962501 2.7385826443846996e-6
       .9999999999962179 2.750285989018793e-6
       .9999999999961857 2.761989333652886e-6
       .9999999999961533 2.7736926782869783e-6
       .9999999999961208 2.78539602292107e-6
       .9999999999960881 2.797099367555162e-6
       .9999999999960553 2.808802712189253e-6
       .9999999999960224 2.8205060568233443e-6
       .9999999999959893 2.832209401457435e-6
       .9999999999959561 2.8439127460915247e-6
       .9999999999959227 2.8556160907256145e-6
       .9999999999958893 2.867319435359704e-6
       .9999999999958556 2.879022779993793e-6
       .9999999999958219 2.8907261246278814e-6
       .9999999999957879 2.90242946926197e-6
       .999999999995754 2.9141328138960576e-6
       .9999999999957198 2.925836158530145e-6
       .9999999999956855 2.9375395031642317e-6
       .999999999995651 2.9492428477983186e-6
       .9999999999956164 2.9609461924324046e-6
       .9999999999955816 2.9726495370664905e-6
       .9999999999955468 2.9843528817005757e-6
       .9999999999955118 2.996056226334661e-6
       .9999999999954767 3.007759570968745e-6
       .9999999999954414 3.0194629156028294e-6
       .999999999995406 3.0311662602369133e-6
       .9999999999953705 3.0428696048709963e-6
       .9999999999953348 3.0545729495050794e-6
       .999999999995299 3.066276294139162e-6
       .999999999995263 3.0779796387732437e-6
       .9999999999952269 3.0896829834073255e-6
       .9999999999951907 3.101386328041407e-6
       .9999999999951543 3.1130896726754873e-6
       .9999999999951178 3.1247930173095678e-6
       .9999999999950812 3.136496361943648e-6
       .9999999999950444 3.148199706577727e-6
       .9999999999950075 3.1599030512118063e-6
       .9999999999949705 3.171606395845885e-6
       .9999999999949333 3.183309740479963e-6
       .999999999994896 3.195013085114041e-6
       .9999999999948584 3.206716429748118e-6
       .9999999999948209 3.218419774382195e-6
       .9999999999947832 3.2301231190162714e-6
       .9999999999947453 3.2418264636503477e-6
       .9999999999947072 3.253529808284423e-6
       .9999999999946692 3.265233152918498e-6
       .9999999999946309 3.276936497552573e-6
       .9999999999945924 3.288639842186647e-6
       .9999999999945539 3.300343186820721e-6
       .9999999999945152 3.312046531454794e-6
       .9999999999944763 3.323749876088867e-6
       .9999999999944373 3.3354532207229395e-6
       .9999999999943983 3.3471565653570115e-6
       .9999999999943591 3.358859909991083e-6
       .9999999999943197 3.370563254625154e-6
       .9999999999942801 3.3822665992592245e-6
       .9999999999942405 3.3939699438932944e-6
       .9999999999942008 3.4056732885273643e-6
       .9999999999941608 3.4173766331614334e-6
       .9999999999941207 3.429079977795502e-6
       .9999999999940805 3.4407833224295702e-6
       .9999999999940402 3.452486667063638e-6
       .9999999999939997 3.4641900116977054e-6
       .999999999993959 3.4758933563317723e-6
       .9999999999939183 3.4875967009658384e-6
       .9999999999938775 3.4993000455999045e-6
       .9999999999938364 3.5110033902339697e-6
       .9999999999937953 3.5227067348680345e-6
       .999999999993754 3.534410079502099e-6
       .9999999999937126 3.546113424136163e-6
       .999999999993671 3.5578167687702264e-6
       .9999999999936293 3.5695201134042896e-6
       .9999999999935875 3.581223458038352e-6
       .9999999999935454 3.592926802672414e-6
       .9999999999935033 3.6046301473064755e-6
       .9999999999934611 3.6163334919405365e-6
       .9999999999934187 3.628036836574597e-6
       .9999999999933762 3.639740181208657e-6
       .9999999999933334 3.6514435258427166e-6
       .9999999999932907 3.6631468704767755e-6
       .9999999999932477 3.674850215110834e-6
       .9999999999932047 3.686553559744892e-6
       .9999999999931615 3.6982569043789496e-6
       .9999999999931181 3.7099602490130064e-6
       .9999999999930747 3.7216635936470627e-6
       .999999999993031 3.733366938281119e-6
       .9999999999929873 3.745070282915174e-6
       .9999999999929433 3.756773627549229e-6
       .9999999999928992 3.768476972183284e-6
       .9999999999928552 3.7801803168173377e-6
       .9999999999928109 3.791883661451391e-6
       .9999999999927663 3.803587006085444e-6
       .9999999999927218 3.8152903507194965e-6
       .9999999999926771 3.826993695353548e-6
       .9999999999926322 3.838697039987599e-6
       .9999999999925873 3.85040038462165e-6
       .9999999999925421 3.862103729255701e-6
       .9999999999924968 3.87380707388975e-6
       .9999999999924514 3.885510418523799e-6
       .9999999999924059 3.897213763157848e-6
       .9999999999923602 3.9089171077918965e-6
       .9999999999923144 3.9206204524259435e-6
       .9999999999922684 3.9323237970599905e-6
       .9999999999922223 3.9440271416940376e-6
       .9999999999921761 3.955730486328084e-6
       .9999999999921297 3.967433830962129e-6
       .9999999999920832 3.9791371755961736e-6
       .9999999999920366 3.990840520230218e-6
       .9999999999919899 4.002543864864262e-6
       .9999999999919429 4.014247209498305e-6
       .9999999999918958 4.025950554132348e-6
       .9999999999918486 4.03765389876639e-6
       .9999999999918013 4.049357243400431e-6
       .9999999999917539 4.061060588034472e-6
       .9999999999917063 4.072763932668513e-6
       .9999999999916586 4.084467277302553e-6
       .9999999999916107 4.096170621936592e-6
       .9999999999915626 4.107873966570632e-6
       .9999999999915146 4.119577311204669e-6
       .9999999999914663 4.131280655838707e-6
       .9999999999914179 4.142984000472745e-6
       .9999999999913692 4.154687345106781e-6
       .9999999999913206 4.166390689740817e-6
       .9999999999912718 4.178094034374852e-6
       .9999999999912228 4.189797379008887e-6
       .9999999999911737 4.201500723642921e-6
       .9999999999911244 4.213204068276955e-6
       .999999999991075 4.224907412910988e-6
       .9999999999910255 4.236610757545021e-6
       .9999999999909759 4.248314102179053e-6
       .9999999999909261 4.260017446813084e-6
       .9999999999908762 4.271720791447115e-6
       .9999999999908261 4.283424136081145e-6
       .9999999999907759 4.295127480715175e-6
       .9999999999907256 4.306830825349204e-6
       .9999999999906751 4.3185341699832325e-6
       .9999999999906245 4.33023751461726e-6
       .9999999999905738 4.3419408592512875e-6
       .9999999999905229 4.353644203885314e-6
       .9999999999904718 4.36534754851934e-6
       .9999999999904207 4.377050893153365e-6
       .9999999999903694 4.38875423778739e-6
       .999999999990318 4.400457582421414e-6
       .9999999999902665 4.4121609270554384e-6
       .9999999999902147 4.423864271689461e-6
       .9999999999901629 4.435567616323483e-6
       .9999999999901109 4.447270960957506e-6
       .9999999999900587 4.458974305591527e-6
       .9999999999900065 4.470677650225547e-6
       .9999999999899541 4.482380994859567e-6
       .9999999999899016 4.494084339493587e-6
       .9999999999898489 4.5057876841276054e-6
       .9999999999897962 4.517491028761624e-6
       .9999999999897432 4.529194373395641e-6
       .9999999999896901 4.5408977180296584e-6
       .999999999989637 4.552601062663675e-6
       .9999999999895836 4.564304407297691e-6
       .99999999998953 4.5760077519317055e-6
       .9999999999894764 4.5877110965657195e-6
       .9999999999894227 4.5994144411997335e-6
       .9999999999893688 4.611117785833747e-6
       .9999999999893148 4.622821130467759e-6
       .9999999999892606 4.634524475101771e-6
       .9999999999892063 4.646227819735783e-6
       .9999999999891518 4.657931164369793e-6
       .9999999999890973 4.669634509003803e-6
       .9999999999890425 4.681337853637813e-6
       .9999999999889877 4.693041198271821e-6
       .9999999999889327 4.704744542905829e-6
       .9999999999888776 4.716447887539837e-6
       .9999999999888223 4.728151232173843e-6
       .9999999999887669 4.73985457680785e-6
       .9999999999887114 4.751557921441855e-6
       .9999999999886556 4.76326126607586e-6
       .9999999999885999 4.774964610709864e-6
       .9999999999885439 4.786667955343868e-6
       .9999999999884878 4.798371299977871e-6
       .9999999999884316 4.810074644611873e-6
       .9999999999883752 4.821777989245874e-6
       .9999999999883187 4.833481333879875e-6
       .9999999999882621 4.845184678513876e-6
       .9999999999882053 4.856888023147875e-6
       .9999999999881484 4.868591367781874e-6
       .9999999999880914 4.880294712415872e-6
       .9999999999880341 4.89199805704987e-6
       .9999999999879768 4.903701401683867e-6
       .9999999999879194 4.915404746317863e-6
       .9999999999878618 4.9271080909518585e-6
       .9999999999878041 4.938811435585853e-6
       .9999999999877462 4.9505147802198475e-6
       .9999999999876882 4.962218124853841e-6
       .99999999998763 4.973921469487834e-6
       .9999999999875717 4.985624814121826e-6
       .9999999999875133 4.997328158755817e-6
       .9999999999874548 5.009031503389808e-6
       .9999999999873961 5.0207348480237985e-6
       .9999999999873372 5.032438192657788e-6
       .9999999999872783 5.0441415372917765e-6
       .9999999999872192 5.055844881925764e-6
       .9999999999871599 5.067548226559752e-6
       .9999999999871007 5.079251571193739e-6
       .9999999999870411 5.090954915827725e-6
       .9999999999869814 5.10265826046171e-6
       .9999999999869217 5.1143616050956945e-6
       .9999999999868617 5.126064949729678e-6
       .9999999999868017 5.1377682943636615e-6
       .9999999999867415 5.149471638997644e-6
       .9999999999866811 5.161174983631626e-6
       .9999999999866207 5.172878328265607e-6
       .9999999999865601 5.184581672899587e-6
       .9999999999864994 5.196285017533567e-6
       .9999999999864384 5.2079883621675455e-6
       .9999999999863775 5.219691706801524e-6
       .9999999999863163 5.2313950514355015e-6
       .999999999986255 5.243098396069478e-6
       .9999999999861935 5.254801740703454e-6
       .999999999986132 5.266505085337429e-6
       .9999999999860703 5.278208429971404e-6
       .9999999999860084 5.289911774605378e-6
       .9999999999859465 5.301615119239351e-6
       .9999999999858843 5.313318463873323e-6
       .9999999999858221 5.325021808507295e-6
       .9999999999857597 5.336725153141267e-6
       .9999999999856971 5.3484284977752366e-6
       .9999999999856345 5.360131842409206e-6
       .9999999999855717 5.371835187043175e-6
       .9999999999855087 5.383538531677143e-6
       .9999999999854456 5.3952418763111104e-6
       .9999999999853825 5.406945220945077e-6
       .9999999999853191 5.418648565579043e-6
       .9999999999852557 5.4303519102130076e-6
       .9999999999851921 5.4420552548469724e-6
       .9999999999851282 5.453758599480936e-6
       .9999999999850644 5.465461944114899e-6
       .9999999999850003 5.47716528874886e-6
       .9999999999849362 5.488868633382822e-6
       .9999999999848719 5.500571978016782e-6
       .9999999999848074 5.512275322650742e-6
       .9999999999847429 5.523978667284702e-6
       .9999999999846781 5.53568201191866e-6
       .9999999999846133 5.547385356552617e-6
       .9999999999845482 5.5590887011865745e-6
       .9999999999844832 5.57079204582053e-6
       .9999999999844179 5.582495390454486e-6
       .9999999999843525 5.59419873508844e-6
       .9999999999842869 5.605902079722394e-6
       .9999999999842213 5.617605424356347e-6
       .9999999999841555 5.629308768990299e-6
       .9999999999840895 5.641012113624251e-6
       .9999999999840234 5.652715458258201e-6
       .9999999999839572 5.664418802892152e-6
       .9999999999838908 5.6761221475261e-6
       .9999999999838243 5.687825492160048e-6
       .9999999999837577 5.699528836793996e-6
       .9999999999836909 5.711232181427943e-6
       .999999999983624 5.722935526061889e-6
       .9999999999835569 5.734638870695834e-6
       .9999999999834898 5.746342215329779e-6
       .9999999999834225 5.758045559963722e-6
       .999999999983355 5.769748904597665e-6
       .9999999999832874 5.781452249231607e-6
       .9999999999832196 5.793155593865548e-6
       .9999999999831518 5.804858938499489e-6
       .9999999999830838 5.816562283133429e-6
       .9999999999830157 5.8282656277673675e-6
       .9999999999829474 5.839968972401306e-6
       .9999999999828789 5.851672317035243e-6
       .9999999999828104 5.86337566166918e-6
       .9999999999827417 5.875079006303115e-6
       .9999999999826729 5.88678235093705e-6
       .9999999999826039 5.898485695570985e-6
       .9999999999825349 5.910189040204917e-6
       .9999999999824656 5.92189238483885e-6
       .9999999999823962 5.933595729472782e-6
       .9999999999823267 5.945299074106713e-6
       .9999999999822571 5.957002418740643e-6
       .9999999999821872 5.9687057633745715e-6
       .9999999999821173 5.9804091080085e-6
       ))

    (define low-lut-rac
    '#f64(1. 0.
       .9999952938095762 .003067956762965976
       .9999811752826011 .006135884649154475
       .9999576445519639 .00920375478205982
       .9999247018391445 .012271538285719925
       .9998823474542126 .015339206284988102
       .9998305817958234 .01840672990580482
       .9997694053512153 .021474080275469508
       .9996988186962042 .024541228522912288
       .9996188224951786 .027608145778965743
       .9995294175010931 .030674803176636626
       .9994306045554617 .03374117185137759
       .9993223845883495 .03680722294135883
       .9992047586183639 .03987292758773981
       .9990777277526454 .04293825693494082
       .9989412931868569 .04600318213091463
       .9987954562051724 .049067674327418015
       .9986402181802653 .052131704680283324
       .9984755805732948 .05519524434968994
       .9983015449338929 .05825826450043576
       .9981181129001492 .06132073630220858
       .997925286198596 .06438263092985747
       .9977230666441916 .06744391956366406
       .9975114561403035 .07050457338961387
       .9972904566786902 .07356456359966743
       .997060070339483 .07662386139203149
       .9968202992911657 .07968243797143013
       .9965711457905548 .08274026454937569
       .996312612182778 .0857973123444399
       .996044700901252 .0888535525825246
       .9957674144676598 .09190895649713272
       .9954807554919269 .094963495329639
       .9951847266721969 .0980171403295606
       .9948793307948056 .10106986275482782
       .9945645707342554 .10412163387205457
       .9942404494531879 .10717242495680884
       .9939069700023561 .11022220729388306
       .9935641355205953 .11327095217756435
       .9932119492347945 .11631863091190477
       .9928504144598651 .11936521481099137
       .99247953459871 .1224106751992162
       .9920993131421918 .12545498341154623
       .9917097536690995 .12849811079379317
       .9913108598461154 .13154002870288312
       .99090263542778 .1345807085071262
       .9904850842564571 .13762012158648604
       .9900582102622971 .14065823933284924
       .9896220174632009 .14369503315029444
       .989176509964781 .14673047445536175
       .9887216919603238 .1497645346773215
       .9882575677307495 .15279718525844344
       .9877841416445722 .15582839765426523
       .9873014181578584 .15885814333386145
       .9868094018141855 .16188639378011183
       .9863080972445987 .16491312048996992
       .9857975091675675 .16793829497473117
       .9852776423889412 .17096188876030122
       .9847485018019042 .17398387338746382
       .984210092386929 .17700422041214875
       .9836624192117303 .18002290140569951
       .9831054874312163 .18303988795514095
       .9825393022874412 .18605515166344666
       .9819638691095552 .18906866414980622
       .9813791933137546 .19208039704989244
       .9807852804032304 .19509032201612828
       .9801821359681174 .1980984107179536
       .9795697656854405 .2011046348420919
       .9789481753190622 .20410896609281687
       .9783173707196277 .20711137619221856
       .9776773578245099 .2101118368804696
       .9770281426577544 .21311031991609136
       .9763697313300211 .21610679707621952
       .9757021300385286 .2191012401568698
       .9750253450669941 .22209362097320354
       .9743393827855759 .22508391135979283
       .973644249650812 .22807208317088573
       .9729399522055602 .2310581082806711
       .9722264970789363 .23404195858354343
       .9715038909862518 .2370236059943672
       .9707721407289504 .2400030224487415
       .970031253194544 .2429801799032639
       .9692812353565485 .24595505033579462
       .9685220942744173 .24892760574572018
       .9677538370934755 .25189781815421697
       .9669764710448521 .25486565960451457
       .9661900034454125 .257831102162159
       .9653944416976894 .2607941179152755
       .9645897932898128 .2637546789748314
       .9637760657954398 .26671275747489837
       .9629532668736839 .2696683255729151
       .9621214042690416 .272621355449949
       .9612804858113206 .27557181931095814
       .9604305194155658 .2785196893850531
       .9595715130819845 .281464937925758
       .9587034748958716 .2844075372112718
       .9578264130275329 .2873474595447295
       .9569403357322088 .2902846772544624
       .9560452513499964 .29321916269425863
       .9551411683057707 .29615088824362384
       .9542280951091057 .2990798263080405
       .9533060403541939 .3020059493192281
       .9523750127197659 .30492922973540243
       .9514350209690083 .30784964004153487
       .9504860739494817 .3107671527496115
       .9495281805930367 .31368174039889146
       .9485613499157303 .31659337555616585
       .9475855910177411 .3195020308160157
       .9466009130832835 .32240767880106985
       .9456073253805213 .3253102921622629
       .9446048372614803 .32820984357909255
       .9435934581619604 .33110630575987643
       .9425731976014469 .3339996514420094
       .9415440651830208 .33688985339222005
       .9405060705932683 .33977688440682685
       .9394592236021899 .3426607173119944
       .9384035340631081 .34554132496398904
       .937339011912575 .34841868024943456
       .9362656671702783 .35129275608556715
       .9351835099389476 .3541635254204904
       .9340925504042589 .35703096123343003
       .9329927988347388 .35989503653498817
       .9318842655816681 .3627557243673972
       .9307669610789837 .36561299780477385
       .9296408958431812 .3684668299533723
       .9285060804732156 .37131719395183754
       .9273625256504011 .374164062971458
       .9262102421383114 .37700741021641826
       .9250492407826776 .37984720892405116
       .9238795325112867 .3826834323650898
       .9227011283338785 .38551605384391885
       .9215140393420419 .3883450466988263
       .9203182767091106 .39117038430225387
       .9191138516900578 .3939920400610481
       .9179007756213905 .3968099874167103
       .9166790599210427 .39962419984564684
       .9154487160882678 .40243465085941843
       .9142097557035307 .40524131400498986
       .9129621904283982 .4080441628649787
       .9117060320054299 .41084317105790397
       .9104412922580672 .41363831223843456
       .9091679830905224 .4164295600976372
       .9078861164876663 .41921688836322396
       .9065957045149153 .4220002707997997
       .9052967593181188 .4247796812091088
       .9039892931234433 .4275550934302821
       .9026733182372588 .4303264813400826
       .901348847046022 .43309381885315196
       .9000158920161603 .4358570799222555
       .8986744656939538 .43861623853852766
       .8973245807054183 .44137126873171667
       .8959662497561851 .44412214457042926
       .8945994856313827 .4468688401623742
       .8932243011955153 .4496113296546066
       .8918407093923427 .4523495872337709
       .8904487232447579 .45508358712634384
       .8890483558546646 .45781330359887723
       .8876396204028539 .46053871095824
       .8862225301488806 .4632597835518602
       .8847970984309378 .4659764957679662
       .8833633386657316 .46868882203582796
       .881921264348355 .47139673682599764
       .8804708890521608 .47410021465055
       .8790122264286335 .47679923006332214
       .8775452902072612 .479493757660153
       .8760700941954066 .4821837720791228
       .8745866522781761 .4848692480007911
       .8730949784182901 .48755016014843594
       .8715950866559511 .49022648328829116
       .8700869911087115 .49289819222978404
       .8685707059713409 .49556526182577254
       .8670462455156926 .49822766697278187
       .8655136240905691 .5008853826112408
       .8639728561215867 .5035383837257176
       .8624239561110405 .5061866453451553
       .8608669386377673 .508830142543107
       .8593018183570084 .5114688504379704
       .8577286100002721 .5141027441932218
       .8561473283751945 .5167317990176499
       .8545579883654005 .5193559901655896
       .8529606049303636 .5219752929371544
       .8513551931052652 .524589682678469
       .8497417680008524 .5271991347819014
       .8481203448032972 .5298036246862947
       .8464909387740521 .532403127877198
       .8448535652497071 .5349976198870973
       .8432082396418454 .5375870762956455
       .8415549774368984 .5401714727298929
       .8398937941959995 .5427507848645159
       .8382247055548381 .5453249884220465
       .836547727223512 .5478940591731002
       .83486287498638 .5504579729366048
       .8331701647019132 .5530167055800276
       .8314696123025452 .5555702330196022
       .829761233794523 .5581185312205561
       .8280450452577558 .560661576197336
       .8263210628456635 .5631993440138341
       .8245893027850253 .5657318107836132
       .8228497813758263 .5682589526701316
       .8211025149911046 .5707807458869673
       .819347520076797 .5732971666980422
       .8175848131515837 .5758081914178453
       .8158144108067338 .5783137964116556
       .8140363297059484 .5808139580957645
       .8122505865852039 .5833086529376983
       .8104571982525948 .5857978574564389
       .808656181588175 .5882815482226453
       .8068475535437992 .5907597018588743
       .8050313311429635 .5932322950397998
       .8032075314806449 .5956993044924334
       .8013761717231402 .5981607069963423
       .799537269107905 .600616479383869
       .7976908409433912 .6030665985403482
       .7958369046088836 .6055110414043255
       .7939754775543372 .6079497849677736
       .7921065773002124 .6103828062763095
       .79023022143731 .6128100824294097
       .7883464276266062 .6152315905806268
       .7864552135990858 .617647307937804
       .7845565971555752 .6200572117632892
       .7826505961665757 .62246127937415
       .7807372285720945 .6248594881423863
       .778816512381476 .6272518154951441
       .7768884656732324 .629638238914927
       .7749531065948739 .6320187359398091
       .773010453362737 .6343932841636455
       .7710605242618138 .6367618612362842
       .7691033376455796 .6391244448637757
       .7671389119358204 .6414810128085832
       .765167265622459 .6438315428897915
       .7631884172633813 .6461760129833164
       .7612023854842618 .6485144010221124
       .7592091889783881 .6508466849963809
       .7572088465064846 .6531728429537768
       .7552013768965365 .6554928529996153
       .7531867990436125 .6578066932970786
       .7511651319096864 .6601143420674205
       .7491363945234594 .6624157775901718
       .7471006059801801 .6647109782033449
       .745057785441466 .6669999223036375
       .7430079521351217 .6692825883466361
       .7409511253549591 .6715589548470184
       .7388873244606151 .673829000378756
       .7368165688773699 .6760927035753159
       .7347388780959635 .6783500431298615
       .7326542716724128 .680600997795453
       .7305627692278276 .6828455463852481
       .7284643904482252 .6850836677727004
       .726359155084346 .6873153408917592
       .7242470829514669 .6895405447370669
       .7221281939292153 .6917592583641577
       .7200025079613817 .693971460889654
       .7178700450557317 .696177131491463
       .7157308252838187 .6983762494089728
       .7135848687807936 .7005687939432483
       .7114321957452164 .7027547444572253
       .7092728264388657 .7049340803759049
       ))

    (define (make-w log-n)
      (let* ((n (##fxarithmetic-shift-left 1 log-n))  ;; number of complexes
             (result (##make-f64vector (##fx* 2 n))))

        (define (copy-low-lut)
          (##declare (not interrupts-enabled))
          (do ((i 0 (##fx+ i 1)))
              ((##fx= i lut-table-size))
            (let ((index (##fx* i 2)))
              (##f64vector-set!
               result
               index
               (##f64vector-ref low-lut index))
              (##f64vector-set!
               result
               (##fx+ index 1)
               (##f64vector-ref low-lut (##fx+ index 1))))))

        (define (extend-lut multiplier-lut bit-reverse-size bit-reverse-multiplier start end)

          (define (bit-reverse x n)
            (declare (not interrupts-enabled))
            (do ((i 0 (##fx+ i 1))
                 (x x (##fxarithmetic-shift-right x 1))
                 (result 0 (##fx+ (##fx* result 2)
                                  (##fxand x 1))))
                ((##fx= i n) result)))

          (let loop ((i start)
                     (j 1))
            (if (##fx< i end)
                (let* ((multiplier-index
                        (##fx* 2
                                    (bit-reverse j bit-reverse-size)
                                    bit-reverse-multiplier))
                       (multiplier-real
                        (##f64vector-ref multiplier-lut multiplier-index))
                       (multiplier-imag
                        (##f64vector-ref multiplier-lut (##fx+ multiplier-index 1))))
                  (let inner ((i i)
                              (k 0))
                    (declare (not interrupts-enabled))
                    ;; we copy complex multiples of all entries below
                    ;; start to entries starting at start
                    (if (##fx< k start)
                        (let* ((index
                                (##fx* k 2))
                               (real
                                (##f64vector-ref result index))
                               (imag
                                (##f64vector-ref result (##fx+ index 1)))
                               (result-real
                                (##fl- (##fl* multiplier-real real)
                                       (##fl* multiplier-imag imag)))
                               (result-imag
                                (##fl+ (##fl* multiplier-real imag)
                                       (##fl* multiplier-imag real)))
                               (result-index (##fx* i 2)))
                          (##f64vector-set! result result-index result-real)
                          (##f64vector-set! result (##fx+ result-index 1) result-imag)
                          (inner (##fx+ i 1)
                                 (##fx+ k 1)))
                        (loop i
                              (##fx+ j 1)))))
                result)))

        (cond ((##fx<= n lut-table-size)
               low-lut)
              ((##fx<= n lut-table-size^2)
               (copy-low-lut)
               (extend-lut med-lut
                           (##fx- log-n log-lut-table-size)
                           (##fxarithmetic-shift-left 1 (##fx- (##fx* 2 log-lut-table-size) log-n))
                           lut-table-size
                           n))
              (else ;; (##fx<= n lut-table-size^3)
               (copy-low-lut)
               (extend-lut med-lut
                           log-lut-table-size
                           1
                           lut-table-size
                           lut-table-size^2)
               (extend-lut high-lut
                           (##fx- log-n (##fx* 2 log-lut-table-size))
                           (##fxarithmetic-shift-left 1 (##fx- (##fx* 3 log-lut-table-size) log-n))
                           lut-table-size^2
                           n)))))

    (define (two^p>=m m)
      ;; returns smallest p, assumes fixnum m >= 0
      (##fxlength (##fx- m)))

    ;; The next two routines are so-called radix-4 ffts, which seems
    ;; to mean that they combine two passes, each of which works on
    ;; pairs of complex numbers (hence radix-2?), so if you combine
    ;; two passes in one, you work on two pairs of complex numbers at
    ;; a time and make half as many passes through the f64vector a.

    (define (direct-fft-recursive-4 a W-table)

      ;; This is a direcct complex fft, using a decimation-in-time
      ;; algorithm with inputs in natural order and outputs in
      ;; bit-reversed order.  The table of "twiddle" factors is in
      ;; bit-reversed order.

      ;; this is from page 66 of Chu and George, except that we have
      ;; combined passes in pairs to cut the number of passes through
      ;; the vector a

      (let ((W (##f64vector (macro-inexact-+0)
                            (macro-inexact-+0)
                            (macro-inexact-+0)
                            (macro-inexact-+0))))

        (define (main-loop M N K SizeOfGroup)

          (##declare (not interrupts-enabled))

          (let inner-loop ((K K)
                           (JFirst M))

            (if (##fx< JFirst N)

                (let* ((JLast  (##fx+ JFirst SizeOfGroup)))

                  (if (##fxeven? K)
                      (begin
                        (##f64vector-set! W 0 (##f64vector-ref W-table K))
                        (##f64vector-set! W 1 (##f64vector-ref W-table (##fx+ K 1))))
                      (begin
                        (##f64vector-set! W 0 (##fl- (##f64vector-ref W-table K)))
                        (##f64vector-set! W 1 (##f64vector-ref W-table (##fx- K 1)))))

                  ;; we know the that the next two complex roots of
                  ;; unity have index 2K and 2K+1 so that the 2K+1
                  ;; index root can be gotten from the 2K index root
                  ;; in the same way that we get W_0 and W_1 from the
                  ;; table depending on whether K is even or not

                  (##f64vector-set! W 2 (##f64vector-ref W-table (##fx* K 2)))
                  (##f64vector-set! W 3 (##f64vector-ref W-table (##fx+ (##fx* K 2) 1)))

                  (let J-loop ((J0 JFirst))
                    (if (##fx< J0 JLast)

                        (let* ((J0 J0)
                               (J1 (##fx+ J0 1))
                               (J2 (##fx+ J0 SizeOfGroup))
                               (J3 (##fx+ J2 1))
                               (J4 (##fx+ J2 SizeOfGroup))
                               (J5 (##fx+ J4 1))
                               (J6 (##fx+ J4 SizeOfGroup))
                               (J7 (##fx+ J6 1)))

                          (let ((W_0  (##f64vector-ref W 0))
                                (W_1  (##f64vector-ref W 1))
                                (W_2  (##f64vector-ref W 2))
                                (W_3  (##f64vector-ref W 3))
                                (a_J0 (##f64vector-ref a J0))
                                (a_J1 (##f64vector-ref a J1))
                                (a_J2 (##f64vector-ref a J2))
                                (a_J3 (##f64vector-ref a J3))
                                (a_J4 (##f64vector-ref a J4))
                                (a_J5 (##f64vector-ref a J5))
                                (a_J6 (##f64vector-ref a J6))
                                (a_J7 (##f64vector-ref a J7)))

                            ;; first we do the (overlapping) pairs of
                            ;; butterflies with entries 2*SizeOfGroup
                            ;; apart.

                            (let ((Temp_0 (##fl- (##fl* W_0 a_J4)
                                                      (##fl* W_1 a_J5)))
                                  (Temp_1 (##fl+ (##fl* W_0 a_J5)
                                                      (##fl* W_1 a_J4)))
                                  (Temp_2 (##fl- (##fl* W_0 a_J6)
                                                      (##fl* W_1 a_J7)))
                                  (Temp_3 (##fl+ (##fl* W_0 a_J7)
                                                      (##fl* W_1 a_J6))))

                              (let ((a_J0 (##fl+ a_J0 Temp_0))
                                    (a_J1 (##fl+ a_J1 Temp_1))
                                    (a_J2 (##fl+ a_J2 Temp_2))
                                    (a_J3 (##fl+ a_J3 Temp_3))
                                    (a_J4 (##fl- a_J0 Temp_0))
                                    (a_J5 (##fl- a_J1 Temp_1))
                                    (a_J6 (##fl- a_J2 Temp_2))
                                    (a_J7 (##fl- a_J3 Temp_3)))

                                ;; now we do the two (disjoint) pairs
                                ;; of butterflies distance SizeOfGroup
                                ;; apart, the first pair with W2+W3i,
                                ;; the second with -W3+W2i

                                ;; we rewrite the multipliers so I
                                ;; don't hurt my head too much when
                                ;; thinking about them.

                                (let ((W_0 W_2)
                                      (W_1 W_3)
                                      (W_2 (##fl- W_3))
                                      (W_3 W_2))

                                  (let ((Temp_0
                                         (##fl- (##fl* W_0 a_J2)
                                                     (##fl* W_1 a_J3)))
                                        (Temp_1
                                         (##fl+ (##fl* W_0 a_J3)
                                                     (##fl* W_1 a_J2)))
                                        (Temp_2
                                         (##fl- (##fl* W_2 a_J6)
                                                     (##fl* W_3 a_J7)))
                                        (Temp_3
                                         (##fl+ (##fl* W_2 a_J7)
                                                     (##fl* W_3 a_J6))))

                                    (let ((a_J0 (##fl+ a_J0 Temp_0))
                                          (a_J1 (##fl+ a_J1 Temp_1))
                                          (a_J2 (##fl- a_J0 Temp_0))
                                          (a_J3 (##fl- a_J1 Temp_1))
                                          (a_J4 (##fl+ a_J4 Temp_2))
                                          (a_J5 (##fl+ a_J5 Temp_3))
                                          (a_J6 (##fl- a_J4 Temp_2))
                                          (a_J7 (##fl- a_J5 Temp_3)))

                                      (##f64vector-set! a J0 a_J0)
                                      (##f64vector-set! a J1 a_J1)
                                      (##f64vector-set! a J2 a_J2)
                                      (##f64vector-set! a J3 a_J3)
                                      (##f64vector-set! a J4 a_J4)
                                      (##f64vector-set! a J5 a_J5)
                                      (##f64vector-set! a J6 a_J6)
                                      (##f64vector-set! a J7 a_J7)

                                      (J-loop (##fx+ J0 2)))))))))
                        (inner-loop (##fx+ K 1)
                                    (##fx+ JFirst (##fx* SizeOfGroup 4)))))))))

        (define (recursive-bit M N K SizeOfGroup)
          (if (##fx<= 2 SizeOfGroup)
              (begin
                (main-loop M N K SizeOfGroup)
                (if (##fx< 2048 (##fx- N M))
                    (let ((new-size (##fxarithmetic-shift-right (##fx- N M) 2)))
                      (recursive-bit M
                                     (##fx+ M new-size)
                                     (##fx* K 4)
                                     (##fxarithmetic-shift-right SizeOfGroup 2))
                      (recursive-bit (##fx+ M new-size)
                                     (##fx+ M (##fx* new-size 2))
                                     (##fx+ (##fx* K 4) 1)
                                     (##fxarithmetic-shift-right SizeOfGroup 2))
                      (recursive-bit (##fx+ M (##fx* new-size 2))
                                     (##fx+ M (##fx* new-size 3))
                                     (##fx+ (##fx* K 4) 2)
                                     (##fxarithmetic-shift-right SizeOfGroup 2))
                      (recursive-bit (##fx+ M (##fx* new-size 3))
                                     N
                                     (##fx+ (##fx* K 4) 3)
                                     (##fxarithmetic-shift-right SizeOfGroup 2)))
                    (recursive-bit M
                                   N
                                   (##fx* K 4)
                                   (##fxarithmetic-shift-right SizeOfGroup 2))))))

        (define (radix-2-pass a)

          ;; If we're here, the size of our (conceptually complex)
          ;; array is not a power of 4, so we need to do a basic radix
          ;; two pass with w=1 (so W[0]=1.0 and W[1] = 0.)  and then
          ;; call recursive-bit appropriately on the two half arrays.

          (declare (not interrupts-enabled))

          (let ((SizeOfGroup
                 (##fxarithmetic-shift-right (##f64vector-length a) 1)))
            (let loop ((J0 0))
              (if (##fx< J0 SizeOfGroup)
                  (let ((J0 J0)
                        (J2 (##fx+ J0 SizeOfGroup)))
                    (let ((J1 (##fx+ J0 1))
                          (J3 (##fx+ J2 1)))
                      (let ((a_J0 (##f64vector-ref a J0))
                            (a_J1 (##f64vector-ref a J1))
                            (a_J2 (##f64vector-ref a J2))
                            (a_J3 (##f64vector-ref a J3)))
                        (let ((a_J0 (##fl+ a_J0 a_J2))
                              (a_J1 (##fl+ a_J1 a_J3))
                              (a_J2 (##fl- a_J0 a_J2))
                              (a_J3 (##fl- a_J1 a_J3)))
                          (##f64vector-set! a J0 a_J0)
                          (##f64vector-set! a J1 a_J1)
                          (##f64vector-set! a J2 a_J2)
                          (##f64vector-set! a J3 a_J3)
                          (loop (##fx+ J0 2))))))))))

        (let* ((n (##f64vector-length a))
               (log_n (two^p>=m n)))

          ;; there are n/2 complex entries in a; if n/2 is not a power
          ;; of 4, then do a single radix-2 pass and do the rest of
          ;; the passes as radix-4 passes

          (if (##fxodd? log_n)
              (recursive-bit 0 n 0 (##fxarithmetic-shift-right n 2))
              (let ((n/2 (##fxarithmetic-shift-right n 1))
                    (n/8 (##fxarithmetic-shift-right n 3)))
                (radix-2-pass a)
                (recursive-bit 0 n/2 0 n/8)
                (recursive-bit n/2 n 1 n/8))))))

    ;; The following routine simply reverses the operations of the
    ;; previous routine.

    (define (inverse-fft-recursive-4 a W-table)

      ;; This is an complex fft, using a decimation-in-frequency algorithm
      ;; with inputs in bit-reversed order and outputs in natural order.

      ;; The organization of the algorithm has little to do with the the
      ;; associated algorithm on page 41 of Chu and George,
      ;; I just reversed the operations of the direct algorithm given
      ;; above (without dividing by 2 each time, so that this has to
      ;; be "normalized" by dividing by N/2 at the end.

      ;; The table of "twiddle" factors is in bit-reversed order.

      (let ((W (##f64vector (macro-inexact-+0)
                            (macro-inexact-+0)
                            (macro-inexact-+0)
                            (macro-inexact-+0))))

        (define (main-loop M N K SizeOfGroup)
          (##declare (not interrupts-enabled))
          (let inner-loop ((K K)
                           (JFirst M))
            (if (##fx< JFirst N)
                (let* ((JLast  (##fx+ JFirst SizeOfGroup)))
                  (if (##fxeven? K)
                      (begin
                        (##f64vector-set! W 0 (##f64vector-ref W-table K))
                        (##f64vector-set! W 1 (##f64vector-ref W-table (##fx+ K 1))))
                      (begin
                        (##f64vector-set! W 0 (##fl- (##f64vector-ref W-table K)))
                        (##f64vector-set! W 1 (##f64vector-ref W-table (##fx- K 1)))))
                  (##f64vector-set! W 2 (##f64vector-ref W-table (##fx* K 2)))
                  (##f64vector-set! W 3 (##f64vector-ref W-table (##fx+ (##fx* K 2) 1)))
                  (let J-loop ((J0 JFirst))
                    (if (##fx< J0 JLast)
                        (let* ((J0 J0)
                               (J1 (##fx+ J0 1))
                               (J2 (##fx+ J0 SizeOfGroup))
                               (J3 (##fx+ J2 1))
                               (J4 (##fx+ J2 SizeOfGroup))
                               (J5 (##fx+ J4 1))
                               (J6 (##fx+ J4 SizeOfGroup))
                               (J7 (##fx+ J6 1)))
                          (let ((W_0  (##f64vector-ref W 0))
                                (W_1  (##f64vector-ref W 1))
                                (W_2  (##f64vector-ref W 2))
                                (W_3  (##f64vector-ref W 3))
                                (a_J0 (##f64vector-ref a J0))
                                (a_J1 (##f64vector-ref a J1))
                                (a_J2 (##f64vector-ref a J2))
                                (a_J3 (##f64vector-ref a J3))
                                (a_J4 (##f64vector-ref a J4))
                                (a_J5 (##f64vector-ref a J5))
                                (a_J6 (##f64vector-ref a J6))
                                (a_J7 (##f64vector-ref a J7)))
                            (let ((W_00 W_2)
                                  (W_01 W_3)
                                  (W_02 (##fl- W_3))
                                  (W_03 W_2))
                              (let ((Temp_0 (##fl- a_J0 a_J2))
                                    (Temp_1 (##fl- a_J1 a_J3))
                                    (Temp_2 (##fl- a_J4 a_J6))
                                    (Temp_3 (##fl- a_J5 a_J7)))
                                (let ((a_J0 (##fl+ a_J0 a_J2))
                                      (a_J1 (##fl+ a_J1 a_J3))
                                      (a_J4 (##fl+ a_J4 a_J6))
                                      (a_J5 (##fl+ a_J5 a_J7))
                                      (a_J2 (##fl+ (##fl* W_00 Temp_0)
                                                        (##fl* W_01 Temp_1)))
                                      (a_J3 (##fl- (##fl* W_00 Temp_1)
                                                        (##fl* W_01 Temp_0)))
                                      (a_J6 (##fl+ (##fl* W_02 Temp_2)
                                                        (##fl* W_03 Temp_3)))
                                      (a_J7 (##fl- (##fl* W_02 Temp_3)
                                                        (##fl* W_03 Temp_2))))
                                  (let ((Temp_0 (##fl- a_J0 a_J4))
                                        (Temp_1 (##fl- a_J1 a_J5))
                                        (Temp_2 (##fl- a_J2 a_J6))
                                        (Temp_3 (##fl- a_J3 a_J7)))
                                    (let ((a_J0 (##fl+ a_J0 a_J4))
                                          (a_J1 (##fl+ a_J1 a_J5))
                                          (a_J2 (##fl+ a_J2 a_J6))
                                          (a_J3 (##fl+ a_J3 a_J7))
                                          (a_J4 (##fl+ (##fl* W_0 Temp_0)
                                                            (##fl* W_1 Temp_1)))
                                          (a_J5 (##fl- (##fl* W_0 Temp_1)
                                                            (##fl* W_1 Temp_0)))
                                          (a_J6 (##fl+ (##fl* W_0 Temp_2)
                                                            (##fl* W_1 Temp_3)))
                                          (a_J7 (##fl- (##fl* W_0 Temp_3)
                                                            (##fl* W_1 Temp_2))))
                                      (##f64vector-set! a J0 a_J0)
                                      (##f64vector-set! a J1 a_J1)
                                      (##f64vector-set! a J2 a_J2)
                                      (##f64vector-set! a J3 a_J3)
                                      (##f64vector-set! a J4 a_J4)
                                      (##f64vector-set! a J5 a_J5)
                                      (##f64vector-set! a J6 a_J6)
                                      (##f64vector-set! a J7 a_J7)
                                      (J-loop (##fx+ J0 2)))))))))
                        (inner-loop (##fx+ K 1)
                                    (##fx+ JFirst (##fx* SizeOfGroup 4)))))))))

        (define (recursive-bit M N K SizeOfGroup)
          (if (##fx<= 2 SizeOfGroup)
              (begin
                (if (##fx< 2048 (##fx- N M))
                    (let ((new-size (##fxarithmetic-shift-right (##fx- N M) 2)))
                      (recursive-bit M
                                     (##fx+ M new-size)
                                     (##fx* K 4)
                                     (##fxarithmetic-shift-right SizeOfGroup 2))
                      (recursive-bit (##fx+ M new-size)
                                     (##fx+ M (##fx* new-size 2))
                                     (##fx+ (##fx* K 4) 1)
                                     (##fxarithmetic-shift-right SizeOfGroup 2))
                      (recursive-bit (##fx+ M (##fx* new-size 2))
                                     (##fx+ M (##fx* new-size 3))
                                     (##fx+ (##fx* K 4) 2)
                                     (##fxarithmetic-shift-right SizeOfGroup 2))
                      (recursive-bit (##fx+ M (##fx* new-size 3))
                                     N
                                     (##fx+ (##fx* K 4) 3)
                                     (##fxarithmetic-shift-right SizeOfGroup 2)))
                    (recursive-bit M
                                   N
                                   (##fx* K 4)
                                   (##fxarithmetic-shift-right SizeOfGroup 2)))
                (main-loop M N K SizeOfGroup))))

        (define (radix-2-pass a)
          (declare (not interrupts-enabled))
          (let ((SizeOfGroup
                 (##fxarithmetic-shift-right (##f64vector-length a) 1)))
            (let loop ((J0 0))
              (if (##fx< J0 SizeOfGroup)
                  (let ((J0 J0)
                        (J2 (##fx+ J0 SizeOfGroup)))
                    (let ((J1 (##fx+ J0 1))
                          (J3 (##fx+ J2 1)))
                      (let ((a_J0 (##f64vector-ref a J0))
                            (a_J1 (##f64vector-ref a J1))
                            (a_J2 (##f64vector-ref a J2))
                            (a_J3 (##f64vector-ref a J3)))
                        (let ((a_J0 (##fl+ a_J0 a_J2))
                              (a_J1 (##fl+ a_J1 a_J3))
                              (a_J2 (##fl- a_J0 a_J2))
                              (a_J3 (##fl- a_J1 a_J3)))
                          (##f64vector-set! a J0 a_J0)
                          (##f64vector-set! a J1 a_J1)
                          (##f64vector-set! a J2 a_J2)
                          (##f64vector-set! a J3 a_J3)
                          (loop (##fx+ J0 2))))))))))

        (let* ((n (##f64vector-length a))
               (log_n (two^p>=m n)))
          (if (##fxodd? log_n)
              (recursive-bit 0 n 0 (##fxarithmetic-shift-right n 2))
              (let ((n/2 (##fxarithmetic-shift-right n 1))
                    (n/8 (##fxarithmetic-shift-right n 3)))
                (recursive-bit 0 n/2 0 n/8)
                (recursive-bit n/2 n 1 n/8)
                (radix-2-pass a))))))

    #|

    See the wonderful paper
    Rapid multiplication modulo the sum and difference of highly
    composite numbers, by Colin Percival, electronically published
    by Mathematics of Computation, number S 0025-5718(02)01419-9, URL
    http://www.ams.org/journal-getitem?pii=S0025-5718-02-01419-9
    that gives these very nice error bounds.  This should be published
    in the paper journal sometime after March 2002.

    What we're going to do is:

    Take x and y, each with <= 2^n 8-bit fdigits.
    Put the fdigits of x and y into the real parts of the
    first 2^n complex entries of a vector of length 2^{n+1}.
    Do ffts of length 2^{n+1}.
    Multiply the complex fft coefficients of x and y.
    do an inverse fft of length 2^{n+1}.
    Extract the digits of x*y from the real parts of the inverse fft.

    From theorem 5.1 we get the following error bound:

    (define epsilon (expt 2. -53))
    (define bigepsilon (* epsilon (sqrt 5)))
    (define n 26)
    (define beta 4.158491068379826e-16)      ;; accuracy of product of three entries from the tables
    (define norm-x (sqrt (* (expt 2 n) (* 255 255))))
    (define norm-y norm-x)
    (define error (* norm-x
                     norm-y
                     ;; the following three lines use the slight overestimate that
                     ;; ln(1+epsilon) = epsilon, etc.
                     ;; there are more accurate ways to calculate this, but we
                     ;; don't really need them.
                     (- (exp (+ (* 3 (+ n 1) epsilon)
                                (* (+ (* 3 (+ n 1)) 1) bigepsilon)
                                (* 3 (+ n 1) beta)))
                        1)))
    (pp error)

    Error bound is .27518123388290405  < 1/2

    So if x and y have fewer than 2^{26}\times 8=536,870,912 bits, this computes the product exactly.

    It appears that we need tables only of size 2^9 complex entries rather than 2^10 if we do this.
    That would cut down on memory.

    Let's look at what happens when you have 4-bit fft words:

    (define epsilon (expt 2. -53))
    (define bigepsilon (* epsilon (sqrt 5)))
    (define n 34)
    (define beta 4.158491068379826e-16)      ;; accuracy of trigonometric inputs
    (define l 4)
    (define norm-x (sqrt (* (expt 2 n) (* 15 15))))
    (define norm-y norm-x)
    (define error (* norm-x
                     norm-y
                     (- (exp (+ (* 3 (+ n 1) epsilon)
                                (* (+ (* 3 (+ n 1)) 1) bigepsilon)
                                (* 3 (+ n 1) beta)))
                        1)))
    (pp error)

    Error bound is .31585693359375 < 1/2

    So if x and y have fewer than 2^{34}\times 4=68,719,476,736 bits, this
    computes the product exactly.

    But then I would have to increase the size of the tables to 2^{11}
    complex entries each, so we'd have tables of 4 times the size.

    I think I won't add a four-bit fft word option for now.

    Because the fft algorithm as written requires temporary storage at least
    sixteen times the size of the final result, people working with large
    integers but barely enough memory on 64-bit machines may wish to
    set! ##bignum.fft-mul-max-width to a slightly smaller value so that
    karatsuba will kick in earlier for the largest integers.

    COMMENTS FOR THE RAC (Right-Angle Convolution) VERSION

    What we're going to do is:

    Take x and y, which together have a total of  <= 2^{n+1} 8-bit fdigits.
    We take the fdigits of f and put them into the real parts of a complex
    vector of length 2^n; if there are any left over, place the rest in the
    imaginary parts of the complex vector, starting over at the 0 entry.
    We do the same for y.
    We componentwise multiply x_j by e^{\pi/2 i j/2^n}; similarly for y_j.
    (This is the "right-angle" part of the right-angle transform.)
    The maximum possible product of |x|_2 and |y|_2 are when they both
    have 2^n eight-bit digits.
    Do ffts of length 2^n.
    Multiply the complex fft coefficients of x and y.
    do an inverse fft of length 2^n.
    We componentwise multiply the result by e^{-\pi/2 i j/2^n}, i.e.,
    the inverse of the entries of the weights applied to x and y

    Extract the digits of x*y from the real parts and then the imaginary
    parts of the weighted inverse fft.

    From Theorem 6.1 and the following displayed equation we have

    (define epsilon (expt 2. -53))
    (define bigepsilon (* epsilon (sqrt 5)))
    (define n 26)
    (define beta 4.164343159519809e-16)      ;; accuracy of product of three entries from the tables
    (define norm-x (sqrt (* (expt 2 n) (* 255 255))))
    (define norm-y norm-x)
    (define error (* norm-x
                     norm-y
                     ;; the following three lines use the slight overestimate that
                     ;; ln(1+epsilon) = epsilon, etc.
                     ;; there are more accurate ways to calculate this, but we
                     ;; don't really need them.
                     (- (exp (+ (* 3 n epsilon)
                                (* (+ (* 3 n) 4) bigepsilon)
                                (* (+ (* 3 n) 3) beta)))
                        1)))
    (pp error)

    The error bound is .2742122858762741, so we're cool.

    |#

    #|

    Let n = 2^{\log n}; the following routine calculates

    e^{\pi/2 i (j/n)} j=0,\ldots, n/2-1

    It uses the tables med-lut and high-lut (both described above) and
    low-lut-rac, which contains in fftluts-9.scm

    e^{\pi/2 i (j/2^9)}, j=0,\ldots, 2^8-1

    It uses the same general strategy as make-w, except, because the
    final result is in normal order rather than bit-reversed order, we
    start with the highest table and work our way to the lowest.  As
    noted above, this should result in slightly smaller error than from make-w.

    Instead of always building a new table, one could reuse a bigger one with
    a stride (do the math).  I don't want to do this, however; I'd rather build
    a new, compact table and hope that this will result in fewer cache/TLB/page
    misses.

    |#

    (define (make-w-rac log-n)
      (let* ((n (##fxarithmetic-shift-left 1 log-n))
             (result (##make-f64vector n)))   ;; contains n/2 complexes

        (define (copy-lut lut stride)

          ;; copies the (conceptually complex) entries
          ;; lut[0], lut[(stride/2)], lut[2*(stride/2)], ...
          ;; to the first entries of result.  We stop when we hit
          ;; the end of lut.

          (##declare (not interrupts-enabled))
          (let ((lut-size (##f64vector-length lut)))
            (do ((i 0 (##fx+ i 2))
                 (j 0 (##fx+ j stride)))
                ((##fx= j lut-size) result)
              (##f64vector-set! result             i    (##f64vector-ref lut             j   ))
              (##f64vector-set! result (##fx+ i 1) (##f64vector-ref lut (##fx+ j 1))))))

        (define (extend-lut multiplier-lut start)

          ;; we multiply the table from 0 to start-1 (in pairs of reals
          ;; as complexes) by all the multipliers in multiplier-lut
          ;; starting at 2 (again in pairs of reals)

          (let ((end (##f64vector-length multiplier-lut)))
            (let loop ((i start)
                       (j 2))
              (if (##fx< j end)
                  (let* ((multiplier-real (##f64vector-ref multiplier-lut j))
                         (multiplier-imag (##f64vector-ref multiplier-lut (##fx+ j 1))))
                    (let inner ((i i)
                                (k 0))
                      (declare (not interrupts-enabled))
                      (if (##fx< k start)
                          (let* ((real  (##f64vector-ref result k))
                                 (imag  (##f64vector-ref result (##fx+ k 1)))
                                 (result-real (##fl- (##fl* multiplier-real real)
                                                          (##fl* multiplier-imag imag)))
                                 (result-imag (##fl+ (##fl* multiplier-real imag)
                                                          (##fl* multiplier-imag real))))
                            (##f64vector-set! result i result-real)
                            (##f64vector-set! result (##fx+ i 1) result-imag)
                            (inner (##fx+ i 2)
                                   (##fx+ k 2)))
                          (loop i
                                (##fx+ j 2)))))
                  result))))

        (cond ((##fx= n lut-table-size)
               low-lut-rac)

              ((##fx< n lut-table-size)
               (let ((stride (##fxquotient (##fx* lut-table-size 2) n))) ;; = 2 when n = lut-table-size, etc.
                 (copy-lut low-lut-rac stride)))

              ((##fx<= n lut-table-size^2)
               (let* ((stride (##fxquotient (##fx* lut-table-size^2 2) n))
                      (start  (##fxquotient (##fx* lut-table-size 4) stride))) ;; = 2 lut-table-size when n=lut-table-size^2
                 (copy-lut med-lut stride)
                 (extend-lut low-lut-rac (##fxarithmetic-shift-right n (##fx- log-lut-table-size 1)))))

              (else ;; (##fx<= n lut-table-size^3)
               (let* ((stride (##fxquotient (##fx* lut-table-size^3 2) n))
                      (start  (##fxquotient (##fx* lut-table-size 4) stride)))
                 (copy-lut high-lut stride)
                 (extend-lut med-lut start)
                 (extend-lut low-lut-rac (##fx* start lut-table-size)))))))

    (define (bignum->f64vector-rac x a)

      ;; Copies the first (##f64vector-length a)/2 fdigits of x into the
      ;; even components of a, which represent the real parts of complex
      ;; elements, and then the rest of the fdigits of x into the odd
      ;; components of a, starting over at 1.

      (let ((two^n (##f64vector-length a))
            (x-length (##bignum.fdigit-length x)))

        (if (##fx<= (##fx* x-length 2)
                         two^n)
            ;; all imaginary parts are 0.
            (let loop1 ((i 0)
                        (j 0))
              (##declare (not interrupts-enabled))
              (if (##fx< i x-length)
                  (let ((digit-real   (##fixnum->flonum (##bignum.fdigit-ref x i))))
                    (##f64vector-set! a             j    digit-real)
                    (##f64vector-set! a (##fx+ j 1) (macro-inexact-+0))
                    (loop1 (##fx+ i 1)
                           (##fx+ j 2)))
                                        ;; all parts are zero
                  (let loop2 ((j j))
                    (if (##fx< j two^n)
                        (begin
                          (##f64vector-set! a j (macro-inexact-+0))
                          (##f64vector-set! a (##fx+ j 1) (macro-inexact-+0))
                          (loop2 (##fx+ j 2)))))))

            (let ((offset (##fxarithmetic-shift-right two^n 1)))
              (let loop1 ((i 0)
                          (j 0))
                (##declare (not interrupts-enabled))
                (if (##fx< (##fx+ i offset) x-length)
                    (let ((digit-real (##fixnum->flonum (##bignum.fdigit-ref x             i        )))
                          (digit-imag (##fixnum->flonum (##bignum.fdigit-ref x (##fx+ i offset)))))
                      (##f64vector-set! a             j    digit-real)
                      (##f64vector-set! a (##fx+ j 1) digit-imag)
                      (loop1 (##fx+ i 1)
                             (##fx+ j 2)))
                    ;; all imaginary parts are 0.
                    (let loop2 ((i i)
                                (j j))
                      (if (##fx< j two^n)
                          (let ((digit-real   (##fixnum->flonum (##bignum.fdigit-ref x i))))
                            (##f64vector-set! a             j    digit-real)
                            (##f64vector-set! a (##fx+ j 1) (macro-inexact-+0))
                            (loop2 (##fx+ i 1)
                                   (##fx+ j 2)))))))))))

    (define (componentwise-rac-multiply a table)

      ;; the (conceptually complex) entries of table are
      ;; e^{\pi/2 i (j/2^n)}, j=0,...,2^{n-1}-1.
      ;; We multiply a_i componentwise by table_i, using symmetry when i\geq 2^{n-1}

      (let ((table-size (##f64vector-length table))
            (a-size (##f64vector-length a)))
        (declare (not interrupts-enabled))   ;; note that this means we have to be careful not to cons.
        (let loop ((i 2)
                   (j 2))
          (if (##fx< i table-size)
              (let ((multiplier-real (##f64vector-ref table i))
                    (multiplier-imag (##f64vector-ref table (##fx+ i 1))))
                (let ((a_j-real   (##f64vector-ref a             j   ))
                      (a_j-imag   (##f64vector-ref a (##fx+ j 1)))
                      (a_N-j-real (##f64vector-ref a (##fx- a-size j   )))
                      (a_N-j-imag (##f64vector-ref a (##fx- a-size j -1))))
                  (let ((result_j-real (##fl- (##fl* a_j-real multiplier-real)
                                                   (##fl* a_j-imag multiplier-imag)))
                        (result_j-imag (##fl+ (##fl* a_j-imag multiplier-real)
                                                   (##fl* a_j-real multiplier-imag)))
                        ;; if multipler_j=(make-rectangular r i) then multiplier_{N-j}=(make-rectangular i r)
                        (result_N-j-real (##fl- (##fl* a_N-j-real multiplier-imag)
                                                     (##fl* a_N-j-imag multiplier-real)))
                        (result_N-j-imag (##fl+ (##fl* a_N-j-imag multiplier-imag)
                                                     (##fl* a_N-j-real multiplier-real))))
                    (##f64vector-set! a             j    result_j-real)
                    (##f64vector-set! a (##fx+ j 1) result_j-imag)
                    (##f64vector-set! a (##fx- a-size j   ) result_N-j-real)
                    (##f64vector-set! a (##fx- a-size j -1) result_N-j-imag)
                    (loop (##fx+ i 2)
                          (##fx+ j 2)))))
              (let ((multiplier-real .7071067811865476)  ;; here the multiplier is always (sqrt i)
                    (multiplier-imag .7071067811865476)
                    (a_j-real (##f64vector-ref a j))
                    (a_j-imag (##f64vector-ref a (##fx+ j 1))))
                (let ((result_j-real (##fl- (##fl* a_j-real multiplier-real)
                                                 (##fl* a_j-imag multiplier-imag)))
                      (result_j-imag (##fl+ (##fl* a_j-imag multiplier-real)
                                                 (##fl* a_j-real multiplier-imag))))
                  (##f64vector-set! a             j    result_j-real)
                  (##f64vector-set! a (##fx+ j 1) result_j-imag)))))))

    (define (componentwise-rac-multiply-conjugate a table)
      ;; the (conceptually complex) entries of table are
      ;; e^{\pi/2 i (j/2^n)}, j=0,...,2^{n-1}-1.
      ;; We multiply a_i componentwise by the conjugate/inverse of table_i, using symmetry when i\geq 2^{n-1}

      (let ((table-size (##f64vector-length table))
            (a-size (##f64vector-length a)))
        (declare (not interrupts-enabled))   ;; note that this means we have to be careful not to cons.
        (let loop ((i 2)
                   (j 2))
          (if (##fx< i table-size)
              (let ((multiplier-real (##f64vector-ref table i))
                    (multiplier-imag (##f64vector-ref table (##fx+ i 1))))
                (let ((a_j-real   (##f64vector-ref a             j   ))
                      (a_j-imag   (##f64vector-ref a (##fx+ j 1)))
                      (a_N-j-real (##f64vector-ref a (##fx- a-size j   )))
                      (a_N-j-imag (##f64vector-ref a (##fx- a-size j -1))))

                  (let ((result_j-real (##fl+ (##fl* a_j-real multiplier-real)
                                                   (##fl* a_j-imag multiplier-imag)))
                        (result_j-imag (##fl- (##fl* a_j-imag multiplier-real)
                                                   (##fl* a_j-real multiplier-imag)))
                        ;; if multipler_j=(make-rectangular r i) then multiplier_{N-j}=(make-rectangular i r)
                        (result_N-j-real (##fl+ (##fl* a_N-j-real multiplier-imag)
                                                     (##fl* a_N-j-imag multiplier-real)))
                        (result_N-j-imag (##fl- (##fl* a_N-j-imag multiplier-imag)
                                                     (##fl* a_N-j-real multiplier-real))))
                    (##f64vector-set! a             j    result_j-real)
                    (##f64vector-set! a (##fx+ j 1) result_j-imag)
                    (##f64vector-set! a (##fx- a-size j   ) result_N-j-real)
                    (##f64vector-set! a (##fx- a-size j -1) result_N-j-imag)
                    (loop (##fx+ i 2)
                          (##fx+ j 2)))))
              (let ((multiplier-real .7071067811865476)  ;; here the multiplier is always (sqrt i)
                    (multiplier-imag .7071067811865476)
                    (a_j-real (##f64vector-ref a j))
                    (a_j-imag (##f64vector-ref a (##fx+ j 1))))
                (let ((result_j-real (##fl+ (##fl* a_j-real multiplier-real)
                                                 (##fl* a_j-imag multiplier-imag)))
                      (result_j-imag (##fl- (##fl* a_j-imag multiplier-real)
                                                 (##fl* a_j-real multiplier-imag))))
                  (##f64vector-set! a             j    result_j-real)
                  (##f64vector-set! a (##fx+ j 1) result_j-imag)))))))

    (define (componentwise-complex-multiply a b)
      (let ((two^n (##f64vector-length a)))
        (let loop ((j 0))
          (##declare (not interrupts-enabled))
          (if (##fx< j two^n)
              (let ((aj (##f64vector-ref a j))
                    (aj+1 (##f64vector-ref a (##fx+ j 1)))
                    (bj (##f64vector-ref b j))
                    (bj+1 (##f64vector-ref b (##fx+ j 1))))
                (##f64vector-set! a j
                                  (##fl- (##fl* bj aj)   (##fl* aj+1 bj+1)))
                (##f64vector-set! a (##fx+ j 1)
                                  (##fl+ (##fl* bj aj+1) (##fl* aj   bj+1)))
                (loop (##fx+ j 2)))))))

    (define (f64vector-rac->bignum a result result-length)

      ;; result-length is > the number of complex entries in a, because
      ;; otherwise the length of a would be cut in half.

      (let ((normalizer (##fl/ (##fixnum->flonum (##fxarithmetic-shift-right (##f64vector-length a) 1)))))
        (if (and (##fx> ##fixnum-width 32)
                 (##fx= ##bignum.fdigit-base 256))
            ;; Here we have faster code for the case of
            ;; (1) 64-bit fixnums and
            ;; (2) 8-bit fdigits
            ;; So each rounded entry of a can fit into a fixnum, and
            ;; we know how many bits to mask out and shift for fdigits.
            (let loop ((i 0)
                       (j 0)
                       (carry 0)
                       (limit (##fxarithmetic-shift-right (##f64vector-length a) 1)))
              (##declare (not interrupts-enabled))
              (if (##fx< i limit)
                  (let* ((t (##fx+ carry
                                   (##flonum->fixnum (##fl+ (macro-inexact-+1/2)
                                                            (##fl* (##f64vector-ref a j)
                                                                   normalizer))))))
                    (##bignum.fdigit-set! result i (##fxand t 255))
                    (loop (##fx+ i 1)
                          (##fx+ j 2)
                          (##fxarithmetic-shift-right t 8)
                          limit))
                  (if (##fxeven? j)
                      (loop i
                            1
                            carry
                            result-length))))
            (let* ((fbase (##fixnum->flonum ##bignum.fdigit-base))
                   (fbase-inverse (##fl/ fbase)))
              (let ((loop-carry (##f64vector (macro-inexact-+0))))
                (let loop ((i 0)
                           (j 0)
                           (limit (##fxarithmetic-shift-right (##f64vector-length a) 1)))
                  (##declare (not interrupts-enabled))
                  (if (##fx< i limit)
                      (let* ((t
                              (##fl+ (##fl+ (##f64vector-ref loop-carry 0)
                                            (macro-inexact-+1/2))
                                     (##fl* (##f64vector-ref a j)
                                            normalizer)))
                             (carry
                              (##flfloor (##fl* t fbase-inverse)))
                             (digit
                              (##fl- t (##fl* carry fbase))))
                        (##bignum.fdigit-set! result i (##flonum->fixnum digit))
                        (##f64vector-set! loop-carry 0 carry)
                        (loop (##fx+ i 1)
                              (##fx+ j 2)
                              limit))
                      (if (##fxeven? j)
                          (loop i
                                1
                                result-length)))))))))

    ;; this is the right-angle convolution method of section 6 in Percival's paper

    (let* ((x-length (##bignum.fdigit-length x))
           (y-length (##bignum.fdigit-length y))
           (result-length (##fx+ x-length y-length))
           (result (##bignum.make
                    (##fxquotient
                     result-length
                     (##fxquotient ##bignum.adigit-width
                                   ##bignum.fdigit-width))
                    #f
                    #f))
           ;; minimum power of 2 >= x-length + y-length, half # of complex elements in fft vectors
           (log-two^n (##fx- (two^p>=m (##fx+ x-length y-length)) 1))
           (two^n (##fxarithmetic-shift-left 1 log-two^n)))

      (let ((a         (##make-f64vector (##fx* two^n 2)))
            (table     (make-w     (##fx- log-two^n 1)))
            (rac-table (make-w-rac log-two^n)))

        (bignum->f64vector-rac x a)
        (componentwise-rac-multiply a rac-table)
        (direct-fft-recursive-4 a table)
        (if (##eq? x y)
            (componentwise-complex-multiply a a)
            (let ((b (##make-f64vector (##fx* two^n 2))))
              (bignum->f64vector-rac y b)
              (componentwise-rac-multiply b rac-table)
              (direct-fft-recursive-4 b table)
              (componentwise-complex-multiply a b)))
        (inverse-fft-recursive-4 a table)
        (componentwise-rac-multiply-conjugate a rac-table)
        (f64vector-rac->bignum a result result-length)
        (cleanup x y result))))


  (define (naive-mul x x-length y y-length)  ;; multiplies x by each digit of y
    (let ((result
           (##bignum.make
            (##fx+ (##bignum.adigit-length x) (##bignum.adigit-length y))
            #f
            #f)))
      (##declare (not interrupts-enabled))
      (let loop1 ((k 0))
        (if (##fx< k y-length)
            (let ((multiplier (##bignum.mdigit-ref y k)))
              (if (##fx= multiplier 0)
                (loop1 (##fx+ k 1))
                (let loop2 ((i 0)
                            (j k)
                            (carry 0))
                  (if (##fx< i x-length)
                    (loop2 (##fx+ i 1)
                           (##fx+ j 1)
                           (##bignum.mdigit-mul! result
                                                 j
                                                 x
                                                 i
                                                 multiplier
                                                 carry))
                    (begin
                      (##bignum.mdigit-set! result j carry)
                      (loop1 (##fx+ k 1)))))))
            (cleanup x y result)))))

  (define (cleanup x y result)

    ;; Both naive-mul and fft-mul do unsigned multiplies, fix that here.

    (define (fix x y result)

      (##declare (not interrupts-enabled))

      (if (##bignum.negative? y)
        (let ((x-length (##bignum.adigit-length x)))
          (let loop ((i 0)
                     (j (##bignum.adigit-length y))
                     (borrow 0))
            (if (##fx< i x-length)
              (loop (##fx+ i 1)
                    (##fx+ j 1)
                    (##bignum.adigit-sub! result j x i borrow)))))))

    (fix x y result)
    (fix y x result)
    (##bignum.normalize! result))

  (define (karatsuba-mul x y)
    (let* ((x-length
            (##bignum.adigit-length x))
           (y-length
            (##bignum.adigit-length y))
           (shift-digits
            (##fxarithmetic-shift-right y-length 1))
           (shift-bits
            (##fx* shift-digits ##bignum.adigit-width))
           (y-high
            (##bignum.arithmetic-shift y (##fx- shift-bits)))
           (y-low
            (##extract-bit-field shift-bits 0 y)))
      (if (##eq? x y)
          (let ((high-term
                 (##* y-high y-high))
                (low-term
                 (##* y-low y-low))
                (mid-term
                 (let ((arg (##- y-high y-low)))
                   (##* arg arg))))
            (##+ (##arithmetic-shift high-term (##fx* shift-bits 2))
                 (##+ (##arithmetic-shift
                       (##+ high-term
                            (##- low-term mid-term))
                       shift-bits)
                      low-term)))
          (let ((x-high
                 (##bignum.arithmetic-shift x (##fx- shift-bits)))
                (x-low
                 (##extract-bit-field shift-bits 0 x)))
            (let ((high-term
                   (##* x-high y-high))
                  (low-term
                   (##* x-low y-low))
                  (mid-term
                   (##* (##- x-high x-low)
                        (##- y-high y-low))))
              (##+ (##arithmetic-shift high-term (##fx* shift-bits 2))
                   (##+ (##arithmetic-shift
                         (##+ high-term
                              (##- low-term mid-term))
                         shift-bits)
                        low-term)))))))

  (define (mul x x-length y y-length) ;; x-length <= y-length
    (let ((x-width (##fx* x-length ##bignum.mdigit-width)))
      (cond ((##fx< x-width ##bignum.naive-mul-max-width)
             (naive-mul y y-length x x-length))
            ((or (##not (use-fast-bignum-algorithms))       ;; Use Karatsuba even for very large integers
                 (##fx< x-width ##bignum.fft-mul-min-width) ;; or if x is small enough
                 (##fx< ##bignum.fft-mul-max-width          ;; or if y is too large for FFT to work.
                        (##fx* y-length ##bignum.mdigit-width)))
             (karatsuba-mul x y))
            (else
             (fft-mul x y)))))

  ;; Certain decisions must be made for multiplication.
  ;; First, if either bignum is small, just do naive mul to avoid
  ;; further overhead.
  ;; This is done in the main body of ##bignum.*.
  ;; Second, if it would help to shift out low-order zeros of an
  ;; argument, do so.  That's done in the main body of ##bignum.*.
  ;; Finally, one must decide whether one is using naive mul, karatsuba, or fft.
  ;; This is done in mul.

  (define (low-bits-to-shift x)
    (let ((size (##integer-length x))
          (low-bits (##first-set-bit x)))
      (if (##fx< size (##fx+ low-bits low-bits))
          ;; At least half the lowest bits are zero
          (##fx* (##bignum.adigit-div low-bits) ;; Shift full adigits.
                 ##bignum.adigit-width)
          0)))

  (let ((x-length (##bignum.mdigit-length x))
        (y-length (##bignum.mdigit-length y)))
    (cond ((or (##fx< x-length 20)
               (##fx< y-length 20))
           ;; Don't bother shifting out low order zero bits,
           ;; just use naive multiplication
           (if (##fx< x-length y-length)
               (naive-mul y y-length x x-length)
               (naive-mul x x-length y y-length)))
          ;; Both x and y are normalized bignums.
          ;; Shift out low-order zero bits if that will help
          ((##eq? x y)
           (let ((low-bits (low-bits-to-shift x)))
             (if (##fx= low-bits 0)
                 (mul x x-length x x-length)
                 (##arithmetic-shift
                  (##exact-int.square (##bignum.arithmetic-shift x (##fx- low-bits)))
                  (##fx+ low-bits low-bits)))))
          (else
           (let ((x-low-bits (low-bits-to-shift x))
                 (y-low-bits (low-bits-to-shift y)))
             (if (##fx= (##fx+ x-low-bits y-low-bits) 0)
                 (if (##fx< x-length y-length)
                     (mul x x-length y y-length)
                     (mul y y-length x x-length))
                 (##arithmetic-shift
                  (##* (##arithmetic-shift x (##fx- x-low-bits))
                       (##arithmetic-shift y (##fx- y-low-bits)))
                  (##fx+ x-low-bits y-low-bits))))))))

(define-prim (##bignum.arithmetic-shift x shift)
  (let* ((bit-shift
          (##bignum.adigit-mod shift))
         (digit-shift
          (##bignum.adigit-div (##fx- shift bit-shift)))
         (x-length
          (##bignum.adigit-length x))
         (result-length
          (##fx+ (##fx+ x-length digit-shift)
                 (if (##fxzero? bit-shift) 0 1))))
    (cond ((##fx< 0 result-length)
           (##bignum.normalize!
            (##bignum.arithmetic-shift-into! x shift (##bignum.make result-length #f #f))))
          ((##bignum.negative? x)
            -1)
          (else
           0))))

(define-prim (##bignum.arithmetic-shift-into! x shift result)

  #|
  Shifts x by shift bits into result.

  Left pads by sign bit as necessary, right pads by zeros as necessary.
  Makes *no* error checks.
  |#

  ;; allocates nothing
  (declare (not interrupts-enabled))

  (let* ((bit-shift
          (##bignum.adigit-mod shift))
         (digit-shift
          (##bignum.adigit-div (##fx- shift bit-shift)))
         (x-length
          (##bignum.adigit-length x))
         (result-length
          (##bignum.adigit-length result))
         (zeros
          ##bignum.adigit-zeros)
         (left-fill
          (if (##bignum.negative? x)
              ##bignum.adigit-ones
              ##bignum.adigit-zeros)))
    (if (##fxzero? bit-shift)
        ;; Copy left-fill into leftmost digits of result as needed.
        (let loop1 ((i (##fx- result-length 1))              ;; index for adigit in result
                    (j (##fx- result-length 1 digit-shift))) ;; index for adigit in x
          (if (and (##fx>= i 0) (##fx>= j x-length))
              (begin (##bignum.adigit-copy! result i left-fill 0)
                     (loop1 (##fx- i 1) (##fx- j 1)))
              ;; Copy the digits from x into result as needed.
              (let loop2 ((i i)
                          (j j))
                (if (and (##fx>= i 0) (##fx>= j 0))
                    (begin (##bignum.adigit-copy! result i x j)
                           (loop2 (##fx- i 1) (##fx- j 1)))
                    ;; copy zero into digits of result as needed.
                    (let loop3 ((i i))
                      (if (##fx>= i 0)
                          (begin (##bignum.adigit-copy! result i zeros 0)
                                 (loop3 (##fx- i 1)))))))))
        (let ()
          ;; copy left-fill into leftmost digits of result as needed,
          ;; then concatenate left-fill with leftmost digit of x if needed.
          (define (loop4 i j)
            (if (and (##fx>= i 0) (##fx>= j x-length))
                (begin (##bignum.adigit-copy! result i left-fill 0)
                       (loop4 (##fx- i 1) (##fx- j 1)))
                (if (##fx>= i 0)
                    (if (##fx= (##fx+ j 1) x-length)
                        (begin (##bignum.adigit-cat! result i left-fill 0 x j bit-shift)
                               (loop5 (##fx- i 1) (##fx- j 1)))
                        (loop5 i j)))))
          ;; concatenate adjacent digits of x into result as needed,
          ;; then concatenate rightmost digit of x with 0 if needed.
          (define (loop5 i j)
            (if (and (##fx>= i 0) (##fx>= j 0))
                (begin (##bignum.adigit-cat! result i x (##fx+ j 1) x j bit-shift)
                       (loop5 (##fx- i 1) (##fx- j 1)))
                (if (##fx>= i 0)
                    (if (##fx= (##fx+ j 1) 0)
                        (begin (##bignum.adigit-cat! result i x 0 zeros 0 bit-shift)
                               (loop6 (##fx- i 1)))
                        (loop6 i)))))
          ;; copy 0 into rightmost digits of x as needed.
          (define (loop6 i)
            (if (##fx>= i 0)
                (begin (##bignum.adigit-copy! result i zeros 0)
                       (loop6 (##fx- i 1)))))

          (loop4 (##fx- result-length 1)                  ;; index for adigit in result
                 (##fx- result-length digit-shift 2))))   ;; index for adigit in x
    ;; return something useful
    result))

;;; Bignum division.

(cond-expand
  (use-pairs-for-rb-structures
   (##define-macro (macro-make-rb r b) `(##cons ,r ,b))
   (##define-macro (macro-rb-r rb)     `(##car ,rb))
   (##define-macro (macro-rb-b rb)     `(##cdr ,rb)))
  (else
   (##define-macro (macro-make-rb r b) `(##values ,r ,b))
   (##define-macro (macro-rb-r rb)     `(##values-ref ,rb 0))
   (##define-macro (macro-rb-b rb)     `(##values-ref ,rb 1))))

(define ##reciprocal-cache (##make-table-aux 0 #f #t #f ##eq?))

(define ##bignum.mdigit-width/2
  (##fxquotient ##bignum.mdigit-width 2))

(define ##bignum.mdigit-base*16
  (##fx* ##bignum.mdigit-base 16))

(define-prim (##bignum.div u v #!optional (need-quotient? #t) (keep-dividend? #t))

  ;; u is an unnormalized bignum, v is a normalized exact-int
  ;; 0 < v <= u

  (define (reciprocal v bits)

    ;; computes an approximation to the reciprocal of
    ;; .v1 v2 v3 ...
    ;; where v1 is the highest set bit of v; the reciprocal is of the form
    ;; xx . xxxxxxxxxxxxxxxxxxx where there are bits + 1 bits to the
    ;; right of the binary point. The reciprocal is always <= 2.
    ;; See Knuth, volume 2, Algorithm R in Section 4.3.3

    ;; this procedure returns a rb structure containing the reciprocal
    ;; in the r field and the number of bits in the b field

    (let ((cached-rb (##table-ref ##reciprocal-cache v #f)))
      (if (and cached-rb
               (##not (##fx< (macro-rb-b cached-rb) bits)))
          cached-rb
          (let ((v-length (##integer-length v)))

            (define (recip v bits)
              (cond ((and cached-rb
                          (##not (##fx< (macro-rb-b cached-rb) bits)))
                     cached-rb)
                    ((##fx<= bits ##bignum.mdigit-width/2)
                     (macro-make-rb
                      (##fxquotient
                       ##bignum.mdigit-base*16
                       (##arithmetic-shift
                        v
                        (##fx- ##bignum.mdigit-width/2 -3 v-length)))
                      ##bignum.mdigit-width/2))
                    (else
                     (let* ((high-bits
                             (##fxarithmetic-shift-right
                              (##fx+ bits 1)
                              1))
                            (z-bits      ;; >= high-bits + 1 to right of point
                             (recip v high-bits))
                            (z           ;; high-bits + 1 to right of point
                             (##arithmetic-shift
                              (macro-rb-r z-bits)
                              (##fx- high-bits (macro-rb-b z-bits))))
                            (v-bits      ;; bits + 3 to right of point
                             (##arithmetic-shift
                              v
                              (##fx- (##fx+ bits 3)
                                     v-length)))
                            (v*z*z       ;; 2 * high-bits + bits + 5 to right
                             (##* v-bits (##exact-int.square z)))
                            (two-z       ;; 2 * high-bits + bits + 5 to right
                             (##arithmetic-shift
                              z
                              (##fx+ high-bits (##fx+ bits 5))))
                            (temp
                             (##- two-z v*z*z))
                            (bits-to-shift
                             (##fx+ 4 (##fx+ high-bits high-bits)))
                            (shifted-temp
                             (##arithmetic-shift
                              temp
                              (##fx- bits-to-shift))))
                       (if (##fx< (##first-set-bit temp) bits-to-shift)
                           (macro-make-rb (##+ shifted-temp 1) bits)
                           (macro-make-rb shifted-temp bits))))))

            (let ((rb (recip v bits)))
              (##table-set! ##reciprocal-cache v rb)
              rb)))))

  (define (naive-div u v)

    ;; u is a normalized bignum, v is a possibly unnormalized bignum
    ;; u >= v >= ##bignum.mdigit-base
    ;; Based on Algorithm D of Knuth, Volume 2, Section 4.3.1

    (define (estimate-q-hat top-bits-of-u v_n-1 v_n-2)
      (let ((q-hat
             (##bignum.mdigit-quotient top-bits-of-u 2 v_n-1))
            (u_n+j-2
             (##bignum.mdigit-ref top-bits-of-u 0 )))
        (let ((r-hat
               (##bignum.mdigit-remainder top-bits-of-u 2 v_n-1 q-hat)))
          (if (or (##fx= q-hat ##bignum.mdigit-base)
                  (##bignum.mdigit-test? q-hat v_n-2 r-hat u_n+j-2))
              (let ((q-hat
                     (##fx- q-hat 1))
                    (r-hat
                     (##fx+ r-hat v_n-1)))
                (if (and (##fx< r-hat ##bignum.mdigit-base)
                         (or (##fx= q-hat ##bignum.mdigit-base)
                             (##bignum.mdigit-test? q-hat v_n-2 r-hat u_n+j-2)))
                    (##fx- q-hat 1)
                    q-hat))
              q-hat))))

    (define (subtract-multiple-of-v u v q-hat n j)
      ;; subtracts q-hat * v from u, starting at mdigit j, returns final q-hat
      (##declare (not interrupts-enabled))
      (if (##fx= q-hat 0)
          q-hat
          (let loop4 ((i j)
                      (k 0)
                      (borrow 0))
            (if (##fx< k n)
                (loop4 (##fx+ i 1)
                       (##fx+ k 1)
                       (##bignum.mdigit-div! u i v k q-hat borrow))
                (let* ((borrow  (if (or (##fxzero? borrow)
                                        (##fx= i (##bignum.mdigit-length u))
                                        (##fx= (##bignum.mdigit-ref u i) 0))
                                    borrow
                                    (##bignum.mdigit-div! u i ##bignum.adigit-zeros 0 q-hat borrow))))
                  (if (##fx< borrow 0)
                      (let loop5 ((i j)
                                  (l 0)
                                  (carry 0))
                        (if (##fx< l n)
                            (loop5 (##fx+ i 1)
                                   (##fx+ l 1)
                                   (##bignum.mdigit-mul! u i v l 1 carry))
                            (begin
                              (if (and (##fx= carry 1)
                                       (not (or (##fx= i (##bignum.mdigit-length u))
                                                (##fx= (##bignum.mdigit-ref u i) 0))))
                                  (##bignum.mdigit-mul! u i ##bignum.adigit-zeros 0 1 carry))
                              (##fx- q-hat 1))))
                      q-hat))))))


    (let ((u-bits
           (##integer-length u))
          (v-bits
           (##integer-length v)))
      (let* ((n
              (##bignum.mdigit-div (fx+ v-bits ##bignum.mdigit-width -1)))
             (temp
              ;; need three mdigits for top-bits-of-u
              (##bignum.make (##bignum.adigit-div (+ (##fx* 3 ##bignum.mdigit-width)
                                                     ##bignum.adigit-width
                                                     -1))
                             #f
                             #f))
             (top-2*mdigit-width-bits-of-v
              (##bignum.arithmetic-shift-into! v (##fx- (##fx* ##bignum.mdigit-width 2) v-bits) temp))
             (v_n-1
              (##bignum.mdigit-ref top-2*mdigit-width-bits-of-v 1))
             (v_n-2
              (##bignum.mdigit-ref top-2*mdigit-width-bits-of-v 0)))

        ;; Knuth says to simplify things by shifting u and v so that
        ;; the top nonzero mdigit of v is >= mdigit-base/2

        ;; We're not going to do the shift, but we're going to use that idea.

        ;; This strategy does a bit more work, but generates less garbage.

        (let* ((q-bits                             ;; maximum number of possible bits in q
                (##fx+ (##fx- u-bits v-bits) 2))   ;; 1 is not always sufficient...
               (q-adigits
                (##bignum.adigit-div (fx+ q-bits ##bignum.adigit-width -1)))
               (q-mdigits
                (##bignum.mdigit-div (fx+ q-bits ##bignum.mdigit-width -1)))
               (q
                (and need-quotient?
                     (##fx> q-mdigits 1) ;; result might be bignum
                     (##bignum.make q-adigits #f #f)))
               (u
                (if keep-dividend?
                    ;; copy u
                    (##bignum.copy u)
                    ;; overwrite u with remainder
                    u)))
          (if (##fx= q-mdigits 1)
              ;; final result can't be bignum
              (let* ((top-bits-of-u
                      (##bignum.arithmetic-shift-into!
                       u
                       (##fx- (##fx* 2 ##bignum.mdigit-width) v-bits)
                       temp))
                     (q-hat-estimate
                      (estimate-q-hat top-bits-of-u v_n-1 v_n-2))
                     (q-hat
                      (subtract-multiple-of-v u v q-hat-estimate n 0)))
                (macro-make-qr (and need-quotient? q-hat)
                               (##bignum.normalize! u)))
              ;; final result may be bignum
              (let loop3 ((j (##fx- q-mdigits 1)))
                (if (##not (##fx< j 0))
                    (let* ((top-bits-of-u
                            (##bignum.arithmetic-shift-into!
                             u
                             (##fx- (##fx* (##fx- 2 j) ##bignum.mdigit-width) v-bits)
                             temp))
                           (q-hat-estimate
                            (estimate-q-hat top-bits-of-u v_n-1 v_n-2))
                           (q-hat
                            (subtract-multiple-of-v u v q-hat-estimate n j)))
                      (and need-quotient? (##bignum.mdigit-set! q j q-hat))
                      (loop3 (##fx- j 1)))
                    (macro-make-qr (and need-quotient? (##bignum.normalize! q))
                                   (##bignum.normalize! u)))))))))

  (define (div-one u v)
    (let ((m
           (let loop6 ((i (##fx- (##bignum.mdigit-length u) 1)))
             (if (##fx< 0 (##bignum.mdigit-ref u i))
                 (##fx+ i 1)
                 (loop6 (##fx- i 1))))))
      (let ((work-u (##bignum.make
                     (##bignum.adigit-div (##fx+ (##fx* 2 ##bignum.mdigit-width)
                                                 ##bignum.adigit-width
                                                 -1))
                     #f
                     #f))
            (q (and need-quotient?
                    (##bignum.make (##bignum.adigit-length u) #f #f))))

        (##declare (not interrupts-enabled))

        (let loop7 ((i m)
                    (r-hat 0))
          (##bignum.mdigit-set!
           work-u
           1
           r-hat)
          (##bignum.mdigit-set!
           work-u
           0
           (##bignum.mdigit-ref u (##fx- i 1)))
          (let ((q-hat (##bignum.mdigit-quotient work-u 1 v)))
            (let ((r-hat (##bignum.mdigit-remainder work-u 1 v q-hat)))
              (and need-quotient? (##bignum.mdigit-set! q (##fx- i 1) q-hat))
              (if (##fx< 1 i)
                  (loop7 (##fx- i 1)
                         r-hat)
                  (let ()
                    (##declare (interrupts-enabled))
                    (macro-make-qr (and need-quotient? (##bignum.normalize! q))
                                   r-hat)))))))))

  (define (big-divide u v)

    ;; u and v are positive bignums

    (let ((v-length (##integer-length v))
          (v-first-set-bit (##first-set-bit v)))
      ;; first we check whether it may be beneficial to shift out
      ;; low-order zero bits of v
      (if (##fx>= v-first-set-bit
                  (##fxarithmetic-shift-right v-length 1))
          (let ((reduced-quotient
                 (##exact-int.div
                  (##bignum.arithmetic-shift u (##fx- v-first-set-bit))
                  (##bignum.arithmetic-shift v (##fx- v-first-set-bit))
                  #t          ;; need-quotient?
                  #f          ;; keep-dividend?
                  ))
                (extra-remainder
                 (##extract-bit-field v-first-set-bit 0 u)))
            (macro-make-qr (macro-qr-q reduced-quotient)
                           (##+ (##arithmetic-shift
                                 (macro-qr-r reduced-quotient)
                                 v-first-set-bit)
                                extra-remainder)))
          (if (##fx< v-length ##bignum.fft-mul-min-width)
              (naive-div u v)
              (let* ((u-length (##integer-length u))
                     (length-difference (##fx- u-length v-length)))
                (if (##fx< length-difference ##bignum.fft-mul-min-width)
                    (naive-div u v)
                    (let* ((z-bits (reciprocal v length-difference))
                           (z (macro-rb-r z-bits))
                           (bits (macro-rb-b z-bits)))
                      (let ((test-quotient
                             (##bignum.arithmetic-shift
                              (##* (##bignum.arithmetic-shift
                                    u
                                    (##fx- length-difference
                                           (##fx- u-length 2)))
                                   (##bignum.arithmetic-shift
                                    z
                                    (##fx- length-difference bits)))
                              (##fx- -3 length-difference))))
                        (let ((rem (##- u (##* test-quotient v))))
                          ;; I believe, and I haven't found any counterexamples in my tests
                          ;; to disprove it, that test-quotient can be off by at most +-1.
                          ;; I can't prove this, however, so we put in the following loops.

                          ;; Especially note that our reciprocal does not satisfy the
                          ;; error bounds in Knuth's volume 2 in perhaps a vain effort to
                          ;; save some computations. perhaps this should be fixed.  blah.

                          (cond ((##negative? rem)
                                 (let loop ((test-quotient test-quotient)
                                            (rem rem))
                                   (let ((test-quotient (##- test-quotient 1))
                                         (rem (##+ rem v)))
                                     (if (##negative? rem)
                                         (loop test-quotient rem)
                                         (macro-make-qr test-quotient rem)))))
                                ((##< rem v)
                                 (macro-make-qr test-quotient
                                                rem))
                                (else
                                 (let loop ((test-quotient test-quotient)
                                            (rem rem))
                                   (let ((test-quotient (##+ test-quotient 1))
                                         (rem (##- rem v)))
                                     (if (##< rem v)
                                         (macro-make-qr test-quotient rem)
                                         (loop test-quotient rem)))))))))))))))

  (macro-exact-int-dispatch-no-error v
    (if (##fx< v ##bignum.mdigit-base)
        (div-one u v)
        (begin
          ;; here it's probably not worth the extra cycles to check whether
          ;; a subtraction would be sufficient, i.e., we don't call
          ;; short-divisor-or-quotient-divide
          (naive-div u (##fixnum->bignum v))))
    (if (use-fast-bignum-algorithms)
        (big-divide u v)
        (naive-div u v))))

))

;;;----------------------------------------------------------------------------

;;; Exact integer operations
;;; ------------------------

(define (##exact-int.= x y)
  (##fx= 0 (##exact-int.compare x y)))

(define (##exact-int.< x y)
  (##fx= -1 (##exact-int.compare x y)))

(define (##exact-int.compare x y)

  ;; returns -1 if x < y, 0 if x = y, or 1 if x > y

  (define (compare x y x-smaller)
    (##declare (not interrupts-enabled))
    (let ((x-digits (##bignum.adigit-length x))
          (y-digits (##bignum.adigit-length y)))
      (cond ((##fx< x-digits y-digits) x-smaller)
            ((##fx< y-digits x-digits) (##fx- x-smaller))
            (else
             (let loop ((i (##fx- x-digits 1)))
               (cond ((##fx< i 0) 0)
                     ((##bignum.adigit-< x y i) -1)
                     ((##bignum.adigit-< y x i) 1)
                     (else
                      (loop (##fx- i 1)))))))))

  (macro-exact-int-dispatch-no-error x

    (macro-exact-int-dispatch-no-error y ;; x = fixnum
      (cond ((##fx< x y) -1)
            ((##fx= x y)  0)
            (else         1))
      (if (##bignum.negative? y) 1 -1))

    (macro-exact-int-dispatch-no-error y ;; x = bignum
      (if (##bignum.negative? x) -1 1)
      (if (##bignum.negative? x)
          (if (##bignum.negative? y) (compare x y 1) -1)
          (if (##bignum.negative? y) 1 (compare x y -1))))))

(define-prim (##exact-int.*-expt2 x y)
  (if (##fxnegative? y)
      (##/ x (##arithmetic-shift 1 (##fx- y)))
      (##arithmetic-shift x y)))

(define-prim (##exact-int.div x y #!optional (need-quotient? #t) (keep-dividend? #t))

  (define (big-quotient x y)
    (let* ((x-negative? (##negative? x))
           (abs-x (if x-negative?
                      (begin
                        ;; (##negate ##min-fixnum) always returns the same bignum!
                        ;; So don't have ##bignum.div overwrite it!
                        (set! keep-dividend? (##eqv? x ##min-fixnum))
                        (##negate x))
                      x))
           (y-negative? (##negative? y))
           (abs-y (if y-negative?
                      (##negate y)
                      y)))
      (if (##< abs-x abs-y)
          (macro-make-qr 0 x)

          ;; at least one of x and y is a bignum, so
          ;; here abs-x must be a bignum

          (let ((result (##bignum.div abs-x abs-y need-quotient? keep-dividend?)))

            (if (and need-quotient?
                     (##not (##eq? x-negative? y-negative?)))
                (macro-make-qr (##negate (macro-qr-q result))
                               (if x-negative?
                                   (##negate (macro-qr-r result))
                                   (macro-qr-r result)))
                (if x-negative?
                    (macro-make-qr (macro-qr-q result)
                                   (##negate (macro-qr-r result)))
                    result))))))

  (cond ((##eqv? y 1)
         (macro-make-qr x 0))
        ((##eqv? y -1)
         (macro-make-qr (##negate x) 0))
        ((##eq? x y)              ;; can come up in rational arithmetic
         (macro-make-qr 1 0))
        (else
         (macro-exact-int-dispatch-no-error x

           (macro-exact-int-dispatch-no-error y ;; x = fixnum
             (macro-make-qr (##fxquotient x y) ;; note: y can't be -1
                            (##fxremainder x y))
             (if (##fx< (macro-min-bignum-adigits) (##bignum.adigit-length y))
                 ;; y has at least enough adigits, so
                 ;; (abs y) > (abs x)
                 (macro-make-qr 0 x)
                 (big-quotient x y)))

           (macro-exact-int-dispatch-no-error y ;; x = bignum
             (big-quotient x y)
             (if (##fx< 1 (##fx- (##bignum.adigit-length y)
                                 (##bignum.adigit-length x)))
                 ;; x and y are bignums, and y has at least two more adigits
                 ;; than x, so (abs y) > (abs x)
                 (macro-make-qr 0 x)
                 (big-quotient x y)))))))

(define-prim (##exact-int.nth-root x y)
  ;; TODO: Rewrite to return result plus remainder
  (cond ((##eqv? x 0)
         0)
        ((##eqv? x 1)
         1)
        ((##eqv? y 1)
         x)
        ((##eqv? y 2)
         (macro-sr-s (##exact-int.sqrt x)))
        (else
         (macro-exact-int-dispatch-no-error y
           (let ((length (##integer-length x)))
             ;; (expt 2 (- length l 1)) <= x < (expt 2 length)
             (cond ((##fx<= length y)
                    1)
                   ;; result is >= 2
                   ((##fx<= length (##fx* 2 y))
                    ;; result is < 4
                    (if (##< x (##exact-int.expt 3 y))
                        2
                        3))
                   ((##fxeven? y)
                    (##exact-int.nth-root
                     (macro-sr-s (##exact-int.sqrt x))
                     (##fxarithmetic-shift-right y 1)))
                   (else
                    (let* ((length/y/2 ;; length/y/2 >= 1 because (< (* 2 y) length)
                            (##fxarithmetic-shift-right
                             (##fxquotient
                              (##fx- length 1)
                              y)
                             1)))
                      (let ((init-g
                             (let* ((top-bits
                                     (##arithmetic-shift
                                      x
                                      (##fx- (##fx* length/y/2 y))))
                                    (nth-root-top-bits
                                     (##exact-int.nth-root top-bits y)))
                               (##arithmetic-shift
                                (##+ nth-root-top-bits 1)
                                length/y/2))))
                        (let loop ((g init-g))
                          (let* ((a (##exact-int.expt g (##fx- y 1)))
                                 (b (##* a y))
                                 (c (##* a (##fx- y 1)))
                                 (d (##quotient (##+ x (##* g c)) b)))
                            (let ((diff (##- d g)))
                              (cond ((##not (##negative? diff))
                                     g)
                                    ((##< diff -1)
                                     (loop d))
                                    (else
                                     ;; once the difference is one, it's more
                                     ;; efficient to just decrement until g^y <= x
                                     (let loop ((g d))
                                       (if (##not (##< x (##exact-int.expt g y)))
                                           g
                                           (loop (##- g 1))))))))))))))
           1))))

(define-prim (##integer-nth-root x y)

  (define (type-error-on-x)
    (##fail-check-exact-integer 1 integer-nth-root x y))

  (define (type-error-on-y)
    (##fail-check-exact-integer 2 integer-nth-root x y))

  (define (range-error-on-x)
    (##raise-range-exception 1 integer-nth-root x y))

  (define (range-error-on-y)
    (##raise-range-exception 2 integer-nth-root x y))

  (if (macro-exact-int? x)
      (if (macro-exact-int? y)
          (cond ((##negative? x)
                 (range-error-on-x))
                ((##positive? y)
                 (##exact-int.nth-root x y))
                (else
                 (range-error-on-y)))
          (type-error-on-y))
      (type-error-on-x)))

(define-prim (integer-nth-root x y)
  (macro-force-vars (x y)
    (##integer-nth-root x y)))

(define-prim (##exact-int.sqrt x)

  ;; Derived from the paper "Karatsuba Square Root" by Paul Zimmermann,
  ;; INRIA technical report RR-3805, 1999.  (Used in gmp 4.*)

  ;; Note that the statement of the theorem requires that
  ;; b/4 <= high-order digit of x < b which can be impossible when b is a
  ;; power of 2; the paper later notes that it is the lower bound that is
  ;; necessary, which we preserve.

  (macro-exact-int-dispatch-no-error x

    ;; Here we assume that we have at least as much precision as
    ;; IEEE double precision, that we round to nearest, and that
    ;; fixnums have no more than 64 bits.

    ;; Here's why this works.

    ;; The three functions ##fixnum->flonum, ##flsqrt, and
    ;; ##flonum->fixnum are all monotone, in that if the
    ;; argument is increased, the result does not decrease.
    ;; So for each fixnum i such that (* i i) and (+ (* i i) (* 2 i))
    ;; are fixnums, check that

    ;; (##exact-int.sqrt (* i i)) => i and
    ;; (##exact-int.sqrt (+ (* i i) (* 2 i))) => i

    ;; and this will be true of all fixnums in between.
    ;; And that is all fixnums.  So we ran a code to check this.

    (let* ((s (##flonum->fixnum (##flsqrt (##fixnum->flonum x))))
           (r (##fx- x (##fx* s s))))
      ;; s can be too big, so we check for that here.
      (if (##fxnegative? r)
          (macro-make-sr (##fx- s 1)
                         (##fx+ r (##fx* s 2) -1))
          (macro-make-sr s r)))

    (let ((length/4
           (##fxarithmetic-shift-right
            (##fx+ (##integer-length x) 1)
            2)))
      (let* ((s-prime&r-prime
              (##exact-int.sqrt
               (##arithmetic-shift
                x
                (##fx- (##fxarithmetic-shift-left length/4 1)))))
             (s-prime
              (macro-sr-s s-prime&r-prime))
             (r-prime
              (macro-sr-r s-prime&r-prime)))
        (let* ((qu
                (##exact-int.div
                 (##+ (##arithmetic-shift r-prime length/4)
                      (##extract-bit-field length/4 length/4 x))
                 (##arithmetic-shift s-prime 1)
                 #t           ;; need-quotient?
                 #f))         ;; keep-dividend?
               (q
                (macro-qr-q qu))
               (u
                (macro-qr-r qu)))
          (let ((s
                 (##+ (##arithmetic-shift s-prime length/4) q))
                (r
                 (##- (##+ (##arithmetic-shift u length/4)
                           (##extract-bit-field length/4 0 x))
                      (##* q q))))
            (if (##negative? r)
                (macro-make-sr (##- s 1)
                               (##+ r
                                    (##- (##arithmetic-shift s 1) 1)))
                (macro-make-sr s
                               r))))))))

(define-prim (##integer-sqrt x)

  (define (type-error)
    (##fail-check-exact-integer 1 integer-sqrt x))

  (define (range-error)
    (##raise-range-exception 1 integer-sqrt x))

  (if (macro-exact-int? x)
      (if (##negative? x)
          (range-error)
          (macro-sr-s (##exact-int.sqrt x)))
      (type-error)))

(define-prim (integer-sqrt x)
  (macro-force-vars (x)
    (##integer-sqrt x)))

(define-prim (##exact-integer-sqrt x)

  (define (type-error)
    (##fail-check-exact-integer 1 exact-integer-sqrt x))

  (define (range-error)
    (##raise-range-exception 1 exact-integer-sqrt x))

  (if (macro-exact-int? x)
      (if (##negative? x)
          (range-error)
          (##exact-int.sqrt x))
      (type-error)))

(define-prim (exact-integer-sqrt x)
  (macro-force-vars (x)
    (##exact-integer-sqrt x)))

;;;----------------------------------------------------------------------------

;;; Ratnum operations
;;; -----------------

;;; In the following ratnum routines we sometimes use generic numeric
;;; operators with a mostly-fixnum declaration.  The compiler expands
;;; these operations into inline fixnum arithmetic if the arguments
;;; and results are fixnums.  In the common case where all
;;; numerators and denominators are fixnums this speeds up
;;; these routines noticeably.

(macro-if-ratnum (begin

(define-prim (##ratnum-make num den)
  (macro-ratnum-make num den))

(define-prim (##ratnum-numerator x)
  (macro-ratnum-numerator x))

(define-prim (##ratnum-denominator x)
  (macro-ratnum-denominator x))

(define-prim (##ratnum.= x y)
  (and (##= (macro-ratnum-numerator x)
            (macro-ratnum-numerator y))
       (##= (macro-ratnum-denominator x)
            (macro-ratnum-denominator y))))

(define-prim (##ratnum.< x y)
  (##< (##* (macro-ratnum-numerator x)
            (macro-ratnum-denominator y))
       (##* (macro-ratnum-denominator x)
            (macro-ratnum-numerator y))))

(define-prim (##ratnum.+ x y)
  (let ((p (macro-ratnum-numerator x))
        (q (macro-ratnum-denominator x))
        (r (macro-ratnum-numerator y))
        (s (macro-ratnum-denominator y)))
    (let ((d1 (##gcd q s)))
      (if (##eqv? d1 1)
          (macro-ratnum-make (##+ (##* p s)
                                  (##* r q))
                             (##* q s))
          (let* ((s-prime (##quotient s d1))
                 (t (##+ (##* p s-prime)
                         (##* r (##quotient q d1))))
                 (d2 (##gcd d1 t))
                 (num (##quotient t d2))
                 (den (##* (##quotient q d2)
                           s-prime)))
            (if (##eqv? den 1)
                num
                (macro-ratnum-make num den)))))))

(define-prim (##ratnum.- x y)
  (let ((p (macro-ratnum-numerator x))
        (q (macro-ratnum-denominator x))
        (r (macro-ratnum-numerator y))
        (s (macro-ratnum-denominator y)))
    (let ((d1 (##gcd q s)))
      (if (##eqv? d1 1)
          (macro-ratnum-make (##- (##* p s)
                                  (##* r q))
                             (##* q s))
          (let* ((s-prime (##quotient s d1))
                 (t (##- (##* p s-prime)
                         (##* r (##quotient q d1))))
                 (d2 (##gcd d1 t))
                 (num (##quotient t d2))
                 (den (##* (##quotient q d2)
                           s-prime)))
            (if (##eqv? den 1)
                num
                (macro-ratnum-make num den)))))))

(define-prim (##ratnum.* x y)
  (let ((p (macro-ratnum-numerator x))
        (q (macro-ratnum-denominator x))
        (r (macro-ratnum-numerator y))
        (s (macro-ratnum-denominator y)))
    (if (##eq? x y)
        (macro-ratnum-make (##square p) (##square q))     ;; already in lowest form
        (let* ((gcd-ps (##gcd p s))
               (gcd-rq (##gcd r q))
               (num (##* (##quotient p gcd-ps) (##quotient r gcd-rq)))
               (den (##* (##quotient q gcd-rq) (##quotient s gcd-ps))))
          (if (##eqv? den 1)
              num
              (macro-ratnum-make num den))))))

(define-prim (##ratnum./ x y)
  (let ((p (macro-ratnum-numerator x))
        (q (macro-ratnum-denominator x))
        (r (macro-ratnum-denominator y))
        (s (macro-ratnum-numerator y)))
    (if (##eq? x y)
        1
        (let* ((gcd-ps (##gcd p s))
               (gcd-rq (##gcd r q))
               (num (##* (##quotient p gcd-ps) (##quotient r gcd-rq)))
               (den (##* (##quotient q gcd-rq) (##quotient s gcd-ps))))
          (if (##negative? den)
              (if (##eqv? den -1)
                  (##- num)
                  (macro-ratnum-make (##- num) (##- den)))
              (if (##eqv? den 1)
                  num
                  (macro-ratnum-make num den)))))))

(define-prim (##ratnum.normalize num den)
  (let* ((x (##gcd num den)) ;; gcd always returns nonnegative
         (num (##quotient num x))
         (den (##quotient den x)))
    (if (##negative? den)
        (if (##eqv? den -1)
            (##- num)
            (macro-ratnum-make (##- num) (##- den)))
        (if (##eqv? den 1)
            num
            (macro-ratnum-make num den)))))

(define-prim (##ratnum.round x #!optional (round-half-away-from-zero? #f))
  (let ((num (macro-ratnum-numerator x))
        (den (macro-ratnum-denominator x)))
    (if (##eqv? den 2)
        (if round-half-away-from-zero?
            (##arithmetic-shift (##+ num (if (##positive? num) 1 -1)) -1)
            (##arithmetic-shift (##arithmetic-shift (##+ num 1) -2) 1))
        ;; here the ratnum cannot have fractional part = 1/2
        (##floor
         (##ratnum.normalize
          (##+ (##arithmetic-shift num 1) den)
          (##arithmetic-shift den 1))))))

))

;;;----------------------------------------------------------------------------

;;; Flonum operations
;;; -----------------

(##define-macro (define-prim-flonum form . special-body)
  (let ((body (if (null? special-body) form `(begin ,@special-body))))
    (cond ((= 1 (length (cdr form)))
           (let* ((name-fn (car form))
                  (name-param1 (cadr form)))
             `(define-prim ,form
                (macro-force-vars (,name-param1)
                  (macro-check-flonum
                    ,name-param1
                    1
                    ,form
                    ,body)))))
          ((= 2 (length (cdr form)))
           (let* ((name-fn (car form))
                  (name-param1 (cadr form))
                  (name-param2 (caddr form)))
             `(define-prim ,form
                (macro-force-vars (,name-param1 ,name-param2)
                  (macro-check-flonum
                    ,name-param1
                    1
                    ,form
                    (macro-check-flonum
                      ,name-param2
                      2
                      ,form
                      ,body))))))
          (else
           (error "define-prim-flonum supports only 1 or 2 parameter procedures")))))

(define-prim (flonum? obj)
  (macro-force-vars (obj)
    (##flonum? obj)))

(define-prim (##fleqv? x y))

(define-prim-nary-bool (##fl= x y)
  #t
  #t
  (##fl= x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fl= x y)
  #t
  #t
  (##fl= x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary-bool (##fl< x y)
  #t
  #t
  (##fl< x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fl< x y)
  #t
  #t
  (##fl< x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary-bool (##fl> x y)
  #t
  #t
  (##fl> x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fl> x y)
  #t
  #t
  (##fl> x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary-bool (##fl<= x y)
  #t
  #t
  (##fl<= x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fl<= x y)
  #t
  #t
  (##fl<= x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary-bool (##fl>= x y)
  #t
  #t
  (##fl>= x y)
  macro-no-force
  macro-no-check)

(define-prim-nary-bool (fl>= x y)
  #t
  #t
  (##fl>= x y)
  macro-force-vars
  macro-check-flonum)

(define-prim (##flinteger? x))

(define-prim-flonum (flinteger? x)
  (##flinteger? x))

(define-prim (##flzero? x))

(define-prim-flonum (flzero? x)
  (##flzero? x))

(define-prim (##flpositive? x))

(define-prim-flonum (flpositive? x)
  (##flpositive? x))

(define-prim (##flnegative? x))

(define-prim-flonum (flnegative? x)
  (##flnegative? x))

(define-prim (##flodd? x))

(define-prim-flonum (flodd? x)
  (##flodd? x))

(define-prim (##fleven? x))

(define-prim-flonum (fleven? x)
  (##fleven? x))

(define-prim (##flfinite? x))

(define-prim-flonum (flfinite? x)
  (##flfinite? x))

(define-prim (##flinfinite? x))

(define-prim-flonum (flinfinite? x)
  (##flinfinite? x))

(define-prim (##flnan? x))

(define-prim-flonum (flnan? x)
  (##flnan? x))

(define-prim-nary (##flmax x y)
  ()
  x
  (##flmax x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (flmax x y)
  ()
  x
  (##flmax x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary (##flmin x y)
  ()
  x
  (##flmin x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (flmin x y)
  ()
  x
  (##flmin x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary (##fl+ x y)
  (macro-inexact-+0)
  x
  (##fl+ x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fl+ x y)
  (macro-inexact-+0)
  x
  (##fl+ x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary (##fl* x y)
  (macro-inexact-+1)
  x
  (##fl* x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fl* x y)
  (macro-inexact-+1)
  x
  (##fl* x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary (##fl- x y)
  ()
  (##fl- x)
  (##fl- x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fl- x y)
  ()
  (##fl- x)
  (##fl- x y)
  macro-force-vars
  macro-check-flonum)

(define-prim-nary (##fl/ x y)
  ()
  (##fl/ x)
  (##fl/ x y)
  macro-no-force
  macro-no-check)

(define-prim-nary (fl/ x y)
  ()
  (##fl/ x)
  (##fl/ x y)
  macro-force-vars
  macro-check-flonum)

(define-prim&proc (fl+* (x flonum)
                        (y flonum)
                        (z flonum))
  (if (and (flfinite? x) (flfinite? y))
      (if (flfinite? z)
          (let ((x (exact x))
                (y (exact y))
                (z (exact z)))
            (inexact (+ (* x y) z)))
          z)
      (fl+ (fl* x y) z)))

(define-prim (##flabs x))

(define-prim-flonum (flabs x)
  (##flabs x))

(define-prim (##flnumerator x)
  (if (##flzero? x)
      x
      (##exact->inexact (##numerator (##flonum->exact x)))))

(define-prim-flonum (flnumerator x)
  (if (macro-flonum-rational? x)
      (##flnumerator x)
      (##fail-check-rational 1 flnumerator x)))

(define-prim (##fldenominator x)
  (##exact->inexact (##denominator (##flonum->exact x))))

(define-prim-flonum (fldenominator x)
  (if (macro-flonum-rational? x)
      (##fldenominator x)
      (##fail-check-rational 1 fldenominator x)))

(define-prim (##flfloor x))

(define-prim-flonum (flfloor x)
  (##flfloor x))

(define-prim (##flceiling x))

(define-prim-flonum (flceiling x)
  (##flceiling x))

(define-prim (##fltruncate x))

(define-prim-flonum (fltruncate x)
  (##fltruncate x))

(define-prim (##flround x))

(define-prim-flonum (flround x)
  (##flround x))

(define-prim (##flscalbn x n))

(define-prim (flscalbn x n)
  (macro-force-vars (x n)
    (macro-check-flonum x 1 (flscalbn x n)
      (macro-check-fixnum n 2 (flscalbn x n)
        (##flscalbn x n)))))

(define-prim (##flilogb x))

(define-prim-flonum (flilogb x)
  (##flilogb x))

(define-prim (##flexp x))

(define-prim-flonum (flexp x)
  (##flexp x))

(define-prim (##flexpm1 x))

(define-prim-flonum (flexpm1 x)
  (##flexpm1 x))

(define-prim (##fllog x #!optional (y (macro-absent-obj)))
  (if (##eq? y (macro-absent-obj))
      (##fllog x)
      (##fllog x y)))

(define-prim (fllog x #!optional (y (macro-absent-obj)))
  (macro-force-vars (x y)
    (macro-check-flonum x 1 (fllog x y)
      (if (##eq? y (macro-absent-obj))
          (##fllog x)
          (macro-check-flonum y 2 (fllog x y)
            (##fllog x y))))))

(define-prim (##fllog1p x))

(define-prim-flonum (fllog1p x)
  (##fllog1p x))

(define-prim (##flsin x))

(define-prim-flonum (flsin x)
  (##flsin x))

(define-prim (##flcos x))

(define-prim-flonum (flcos x)
  (##flcos x))

(define-prim (##fltan x))

(define-prim-flonum (fltan x)
  (##fltan x))

(define-prim (##flasin x))

(define-prim-flonum (flasin x)
  (##flasin x))

(define-prim (##flacos x))

(define-prim-flonum (flacos x)
  (##flacos x))

(define-prim (##flatan x #!optional (y (macro-absent-obj)))
  (if (##eq? y (macro-absent-obj))
      (##flatan x)
      (##flatan x y)))

(define-prim (flatan x #!optional (y (macro-absent-obj)))
  (macro-force-vars (x y)
    (macro-check-flonum x 1 (flatan x y)
      (if (##eq? y (macro-absent-obj))
          (##flatan x)
          (macro-check-flonum y 2 (flatan x y)
            (##flatan x y))))))

(define-prim (##flsinh x))

(define-prim-flonum (flsinh x)
  (##flsinh x))

(define-prim (##flcosh x))

(define-prim-flonum (flcosh x)
  (##flcosh x))

(define-prim (##fltanh x))

(define-prim-flonum (fltanh x)
  (##fltanh x))

(define-prim (##flasinh x))

(define-prim-flonum (flasinh x)
  (##flasinh x))

(define-prim (##flacosh x))

(define-prim-flonum (flacosh x)
  (##flacosh x))

(define-prim (##flatanh x))

(define-prim-flonum (flatanh x)
  (##flatanh x))

(define-prim (##flexpt x y))

(define-prim-flonum (flexpt x y)
  (##flexpt x y))

(define-prim (##flsqrt x))

(define-prim-flonum (flsqrt x)
  (##flsqrt x))

(define-prim (##flsquare x))

(define-prim-flonum (flsquare x)
  (##flsquare x))

(define-prim-fixnum (fixnum->flonum x)
  (##fixnum->flonum x))

(define-prim (##flcopysign x y))

(define-prim (##flhypot x y)

  #|
  This function is from

  Functions from
  Branch Cuts for Complex Elementary Functions
  or
  Much Ado About Nothing's Sign Bit
  by W. Kahan

  Full reference:

  Kahan, W: Branch cuts for complex elementary functions; or,
  Much ado about nothing's sign bit. In Iserles, A., and Powell, M. (eds.),
  The state of the art in numerical analysis. Clarendon Press (1987) pp 165-211.

  Code to compute the constants using my computable reals package.

  (load "exact-reals")
  (define r2-exact
    (computable-sqrt (exact->computable 2)))
  (define r2p1-exact
    (computable-+ r2-exact (exact->computable 1)))
  (define r2p1
    (computable->inexact r2p1-exact))
  (define t2p1-exact
    (computable-- r2p1-exact (exact->computable (inexact->exact r2p1))))
  (define r2
    (computable->inexact r2-exact))
  (define t2p1
    (computable->inexact t2p1-exact))
  (for-each pretty-print
            `((define r2 ,r2) (define r2p1 ,r2p1) (define t2p1 ,t2p1)))
  |#

  (define r2 1.4142135623730951)
  (define r2p1 2.414213562373095)
  (define t2p1 1.2537167179050217e-16)

  (let ((x (##flabs x))
        (y (##flabs y)))

    (define (continue x y)
      (let* ((x (if (##flinfinite? y) y x))
             (t (##fl- x y)))
        (if (and (##not (##fl= x +inf.0))
                 (##not (##fl= t x)))
            (if (##fl> t y)
                (let* ((s (##fl/ x y))
                       (s (##fl+ s (##flsqrt (##fl+ (macro-inexact-+1) (##fl* s s))))))
                  (##fl+ x (##fl/ y s)))
                (let* ((s (##fl/ t y))
                       (t (##fl* (##fl+ (macro-inexact-+2) s) s))
                       (s (##fl+ r2p1
                                 (##fl+ s
                                        (##fl+ t2p1
                                               (##fl/ t
                                                      (##fl+ r2 (##flsqrt (##fl+ (macro-inexact-+2) t)))))))))
                  (##fl+ x (##fl/ y s))))
            x)))

    (if (##fl< x y)
        (continue y x)
        (continue x y))))

(define-prim-flonum (flhypot x y)
  (##flhypot x y))

(define-prim (##flonum->fixnum x))
(define-prim (##fixnum->flonum x))
(define-prim (##fixnum->flonum-exact? x))

(macro-if-ratnum

(define-prim (##ratnum->flonum x #!optional (nonzero-fractional-part? #f))
  (let ((num (macro-ratnum-numerator x))
        (den (macro-ratnum-denominator x)))

    (define (f1 sn sd p)
      (if (##< sn sd) ;; n/(d*2^p) < 1 ?
          (f2 (##arithmetic-shift sn 1) sd (##fx- p 1))
          (f2 sn sd p)))

    (define (f2 a b p)
      ;; 1 <= a/b < 2  and  n/d = (2^p*a)/b  and  n/d < 2^(p+1)
      (let* ((shift
              (##fxmin (macro-flonum-m-bits)
                       (##fx- p (macro-flonum-e-min))))
             (normalized-result
              (##ratnum.normalize
               (##arithmetic-shift a shift)
               b))
             (abs-result
              (##fl*
               (##exact-int->flonum
                (if (##ratnum? normalized-result)
                    (##ratnum.round
                     normalized-result
                     nonzero-fractional-part?)
                    normalized-result))
               (##flonum-expt2 (##fx- p shift)))))
        (if (##negative? num)
            (##flcopysign abs-result (macro-inexact--1))
            abs-result)))

    (if (and (##fixnum? num)
             (##fixnum? den)
             (##fixnum->flonum-exact? num)
             (##fixnum->flonum-exact? den))

        (##fl/ (##fixnum->flonum num)
               (##fixnum->flonum den))

        (let* ((n (##abs num))
               (d den)
               (wn (##integer-length n)) ;; 2^(wn-1) <= n < 2^wn
               (wd (##integer-length d)) ;; 2^(wd-1) <= d < 2^wd
               (p (##fx- wn wd)))

          ;; 2^(p-1) <= n/d < 2^(p+1)
          ;; 1/2 <= n/(d*2^p) < 2  or equivalently  1/2 <= (n*2^-p)/d < 2

          (if (##fxnegative? p)
              (f1 (##arithmetic-shift n (##fx- p)) d p)
              (f1 n (##arithmetic-shift d p) p))))))

)

(define-prim (##exact-int->flonum-exact? x)
  (macro-exact-int-dispatch-no-error x
   (##fixnum->flonum-exact? x)             ;; x = fixnum
   (let ((len   (##integer-length x))      ;; x = bignum
         (first (##first-set-bit x)))
     (##not (or (##fx> len (macro-flonum-e-bias-plus-1))
                (##fx> (##fx- len first) (macro-flonum-m-bits-plus-1))
                (and (##fx= len first)
                     (##fx= len (macro-flonum-e-bias-plus-1))
                     (##bignum.negative? x)))))))

(define-prim (##exact-int->flonum x #!optional (nonzero-fractional-part? #f))

  (define (f1 x)
    (let* ((w ;; 2^(w-1) <= x < 2^w
            (##integer-length x))
           (p ;; 2^52 <= x/2^p < 2^53
            (##fx- w (macro-flonum-m-bits-plus-1))))
      (if (##fx< p 1)
          ;; it really should be an error here if
          ;; positive-fractional-part? is true because we can't
          ;; determine the value of the first discarded bit
          (f2 x)
          (let* ((q (##arithmetic-shift x (##fx- p)))
                 (next-bit-index (##fx- p 1)))
            (##fl*
             (##flonum-expt2 p)
             (f2 (if (and (##bit-set? next-bit-index x)
                          (or nonzero-fractional-part?
                              (##exact-int.odd? q)
                              (##fx< (##first-set-bit x)
                                     next-bit-index)))
                     (##+ q 1)
                     q)))))))

  (define (f2 x) ;; 0 <= x < 2^53
    (macro-exact-int-dispatch-no-error x
      (##fixnum->flonum x)
      (let ((n (##bignum.mdigit-length x)))
        (let loop ((i (##fx- n 1))
                   (result (macro-inexact-+0)))
          (if (##fx< i 0)
              result
              (let ((mdigit (##bignum.mdigit-ref x i)))
                (loop (##fx- i 1)
                      (##fl+ (##fl* result
                                    ##bignum.inexact-mdigit-base)
                             (##fixnum->flonum mdigit)))))))))

  (macro-exact-int-dispatch-no-error x
    (##fixnum->flonum x)
    (if (##negative? x)
        (##flcopysign (f1 (##negate x)) (macro-inexact--1))
        (f1 x))))

(define-prim (##flonum-expt2 n)
  (##flexpt (macro-inexact-+2) (##fixnum->flonum n)))

(define-prim (##flonum->exact-int x)
  (let loop1 ((z (##flabs x))
              (n 1))
    (if (##fl< ##bignum.inexact-mdigit-base z)
        (loop1 (##fl/ z ##bignum.inexact-mdigit-base)
               (##fx+ n 1))
        (let loop2 ((result 0)
                    (z z)
                    (i n))
          (if (##fx< 0 i)
              (let* ((inexact-floor-z
                      (##flfloor z))
                     (floor-z
                      (##flonum->fixnum inexact-floor-z))
                     (new-z
                      (##fl* (##fl- z inexact-floor-z)
                             ##bignum.inexact-mdigit-base)))
                (loop2 (##+ floor-z
                            (##arithmetic-shift result ##bignum.mdigit-width))
                       new-z
                       (##fx- i 1)))
              (if (##flnegative? x)
                  (##negate result)
                  result))))))

(define-prim (##flonum->inexact-exponential-format x)

  (define (exp-form-pos x y i)
    (let ((i*2 (##fx+ i i)))
      (let ((z (if (and (##not (##fx< (macro-flonum-e-bias) i*2))
                        (##not (##fl< x y)))
                   (exp-form-pos x (##fl* y y) i*2)
                   (##vector x 0 1))))
        (let ((a (##vector-ref z 0)) (b (##vector-ref z 1)))
          (let ((i+b (##fx+ i b)))
            (if (and (##not (##fx< (macro-flonum-e-bias) i+b))
                     (##not (##fl< a y)))
                (begin
                  (##vector-set! z 0 (##fl/ a y))
                  (##vector-set! z 1 i+b)))
            z)))))

  (define (exp-form-neg x y i)
    (let ((i*2 (##fx+ i i)))
      (let ((z (if (and (##fx< i*2 (macro-flonum-e-bias-minus-1))
                        (##fl< x y))
                   (exp-form-neg x (##fl* y y) i*2)
                   (##vector x 0 1))))
        (let ((a (##vector-ref z 0)) (b (##vector-ref z 1)))
          (let ((i+b (##fx+ i b)))
            (if (and (##fx< i+b (macro-flonum-e-bias-minus-1))
                     (##fl< a y))
                (begin
                  (##vector-set! z 0 (##fl/ a y))
                  (##vector-set! z 1 i+b)))
            z)))))

  (define (exp-form x)
    (if (##fl< x (macro-inexact-+1))
        (let ((z (exp-form-neg x (macro-inexact-+1/2) 1)))
          (##vector-set! z 0 (##fl* (macro-inexact-+2) (##vector-ref z 0)))
          (##vector-set! z 1 (##fx- -1 (##vector-ref z 1)))
          z)
        (exp-form-pos x (macro-inexact-+2) 1)))

  (if (##flnegative? (##flcopysign (macro-inexact-+1) x))
      (let ((z (exp-form (##flcopysign x (macro-inexact-+1)))))
        (##vector-set! z 2 -1)
        z)
      (exp-form x)))

(define-prim (##flonum->exact-exponential-format x)
  (let ((z (##flonum->inexact-exponential-format x)))
    (let ((y (##vector-ref z 0)))
      (if (##not (##fl< y (macro-inexact-+2))) ;; +inf.0 or +nan.0?
          (begin
            (if (##fl< (macro-inexact-+0) y)
                (##vector-set! z 0 (macro-flonum-+m-min))  ;; +inf.0
                (##vector-set! z 0 (macro-flonum-+m-max))) ;; +nan.0
            (##vector-set! z 1 (macro-flonum-e-bias-plus-1)))
          (##vector-set! z 0
                         (##flonum->exact-int
                          (##fl* (##vector-ref z 0) (macro-flonum-m-min)))))
      (##vector-set! z 1 (##fx- (##vector-ref z 1) (macro-flonum-m-bits)))
      z)))

(define-prim (##flonum->exact x)
  (let ((y (##flonum->exact-exponential-format x)))
    (##exact-int.*-expt2
     (if (##fxnegative? (##vector-ref y 2))
         (##negate (##vector-ref y 0))
         (##vector-ref y 0))
     (##vector-ref y 1))))

(macro-if-ratnum

(define-prim (##flonum->ratnum x)
  (let ((y (##flonum->exact x)))
    (if (macro-exact-int? y)
        (macro-exact-int->ratnum y)
        y)))

)

;;;----------------------------------------------------------------------------

;;; IEEE-754 representation of floating point numbers.

(define (##flonum->ieee754-32 x)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((C)
    ((c-lambda (float32)
               unsigned-int32
      "___return(*___CAST(___U32*,&___arg1));")
     x))

   ((js)
    (##inline-host-declaration "

@flonum_to_ieee754_32@ = function (x) {
  var buf = new ArrayBuffer(4);
  (new Float32Array(buf))[0] = @scm2host@(x);
  return @u32_box@((new Uint32Array(buf))[0]);
};

")
    (##inline-host-expression "@flonum_to_ieee754_32@(@1@)" x))

   ((python)
    (##inline-host-declaration "

def @flonum_to_ieee754_32@(x):
    return @host2scm@(ctypes.c_uint32.from_buffer(ctypes.c_float(@scm2host@(x))).value)

")
    (##inline-host-expression "@flonum_to_ieee754_32@(@1@)" x))

   (else
    (println "unimplemented ##flonum->ieee754-32 called")
    0)))

(define (##ieee754-32->flonum n)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((C)
    ((c-lambda (unsigned-int32)
               float32
      "___return(*___CAST(___F32*,&___arg1));")
     n))

   ((js)
    (##inline-host-declaration "

@flonum_from_ieee754_32@ = function (n) {
  var buf = new ArrayBuffer(4);
  (new Uint32Array(buf))[0] = n instanceof @Bignum@ ? Number(@bignum_to_bigint@(n)) : n;
  return new @Flonum@((new Float32Array(buf))[0]);
};

")
    (##inline-host-expression "@flonum_from_ieee754_32@(@1@)" n))

   ((python)
    (##inline-host-declaration "

def @flonum_from_ieee754_32@(n):
    return @Flonum@(ctypes.c_float.from_buffer(ctypes.c_uint32(@bignum_to_bigint@(n) if isinstance(n,@Bignum@) else n)).value)

")
    (##inline-host-expression "@flonum_from_ieee754_32@(@1@)" n))

   (else
    (println "unimplemented ##ieee754-32->flonum called")
    0.0)))

(define (##flonum->ieee754-64 x)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((C)
    ((c-lambda (float64)
               unsigned-int64
      "___return(*___CAST(___U64*,&___arg1));")
     x))

   ((js)
    (##inline-host-declaration "

@flonum_to_ieee754_64@ = function (x) {
  var buf = new ArrayBuffer(8);
  (new Float64Array(buf))[0] = @scm2host@(x);
  return @host2scm@(18446744073709551615n & (new BigInt64Array(buf))[0]);
};

")
    (##inline-host-expression "@flonum_to_ieee754_64@(@1@)" x))

   ((python)
    (##inline-host-declaration "

def @flonum_to_ieee754_64@(x):
    return @host2scm@(ctypes.c_uint64.from_buffer(ctypes.c_double(@scm2host@(x))).value)

")
    (##inline-host-expression "@flonum_to_ieee754_64@(@1@)" x))

   (else
    (println "unimplemented ##flonum->ieee754-64 called")
    0)))

(define (##ieee754-64->flonum n)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((C)
    ((c-lambda (unsigned-int64)
               float64
      "___return(*___CAST(___F64*,&___arg1));")
     n))

   ((js)
    (##inline-host-declaration "

@flonum_from_ieee754_64@ = function (n) {
  var buf = new ArrayBuffer(8);
  (new BigInt64Array(buf))[0] = n instanceof @Bignum@ ? @bignum_to_bigint@(n) : BigInt(n);
  return new @Flonum@((new Float64Array(buf))[0]);
};

")
    (##inline-host-expression "@flonum_from_ieee754_64@(@1@)" n))

   ((python)
    (##inline-host-declaration "

def @flonum_from_ieee754_64@(n):
    return @Flonum@(ctypes.c_double.from_buffer(ctypes.c_uint64(@bignum_to_bigint@(n) if isinstance(n,@Bignum@) else n)).value)

")
    (##inline-host-expression "@flonum_from_ieee754_64@(@1@)" n))

   (else
    (println "unimplemented ##ieee754-64->flonum called")
    0.0)))

;;;----------------------------------------------------------------------------

;;; Cpxnum operations
;;; -----------------

(macro-if-cpxnum (begin

(define-prim (##cpxnum-make real imag)
  (macro-cpxnum-make real imag))

(define-prim (##cpxnum-real x)
  (macro-cpxnum-real x))

(define-prim (##cpxnum-imag x)
  (macro-cpxnum-imag x))

(define-prim (##cpxnum.= x y)
  (##declare (mostly-fixnum-flonum))
  (and (##= (macro-cpxnum-real x) (macro-cpxnum-real y))
       (##= (macro-cpxnum-imag x) (macro-cpxnum-imag y))))

(define-prim (##cpxnum.+ x y)
  (let ((a (macro-cpxnum-real x)) (b (macro-cpxnum-imag x))
        (c (macro-cpxnum-real y)) (d (macro-cpxnum-imag y)))
    (if (and (##flonum? a) (##flonum? b)
             (##flonum? c) (##flonum? d))
        (##make-rectangular (##fl+ a c) (##fl+ b d))
        (##make-rectangular (##+ a c) (##+ b d)))))

(define-prim (##cpxnum.* x y)
  (let ((a (macro-cpxnum-real x)) (b (macro-cpxnum-imag x))
        (c (macro-cpxnum-real y)) (d (macro-cpxnum-imag y)))
    (if (and (##flonum? a) (##flonum? b)
             (##flonum? c) (##flonum? d))
        (##make-rectangular (##fl- (##fl* a c) (##fl* b d))
                            (##fl+ (##fl* a d) (##fl* b c)))
        (##make-rectangular (##- (##* a c) (##* b d))
                            (##+ (##* a d) (##* b c))))))
(define-prim (##cpxnum.- x y)
  (let ((a (macro-cpxnum-real x)) (b (macro-cpxnum-imag x))
        (c (macro-cpxnum-real y)) (d (macro-cpxnum-imag y)))
    (if (and (##flonum? a) (##flonum? b)
             (##flonum? c) (##flonum? d))
        (##make-rectangular (##fl- a c) (##fl- b d))
        (##make-rectangular (##- a c) (##- b d)))))


(define-prim (##cpxnum./ x y)

  (##declare (mostly-fixnum-flonum))

  (define (basic/ a b c d q)
    (##make-rectangular (##/ (##+ (##* a c) (##* b d)) q)
                        (##/ (##- (##* b c) (##* a d)) q)))

  (let ((a (macro-cpxnum-real x)) (b (macro-cpxnum-imag x))
        (c (macro-cpxnum-real y)) (d (macro-cpxnum-imag y)))
    (cond ((##eqv? d 0)
           ;; A normalized cpxnum can't have an imaginary part that is
           ;; exact 0 but it is possible that ##cpxnum./ receives a
           ;; nonnormalized cpxnum as x or y when it is called from ##/.
           (##make-rectangular (##/ a c)
                               (##/ b c)))
          ((##eqv? c 0)
           (##make-rectangular (##/ b d)
                               (##negate (##/ a d))))
          ((and (##exact? c) (##exact? d))
           (basic/ a b c d (##+ (##* c c) (##* d d))))
          (else
           ;; just coerce everything to inexact and move on
           (let ((inexact-c (##exact->inexact c))
                 (inexact-d (##exact->inexact d)))
             (if (and (##flfinite? inexact-c)
                      (##flfinite? inexact-d))
                 (let ((q
                        (##fl+ (##fl* inexact-c inexact-c)
                               (##fl* inexact-d inexact-d))))
                   (cond ((##not (##flfinite? q))
                          (let ((a
                                 (if (##flonum? a)
                                     (##fl* a (macro-inexact-scale-down))
                                     (##* a (macro-scale-down))))
                                (b
                                 (if (##flonum? b)
                                     (##fl* b (macro-inexact-scale-down))
                                     (##* b (macro-scale-down))))
                                (inexact-c
                                 (##fl* inexact-c
                                        (macro-inexact-scale-down)))
                                (inexact-d
                                 (##fl* inexact-d
                                        (macro-inexact-scale-down))))
                            (basic/ a
                                    b
                                    inexact-c
                                    inexact-d
                                    (##fl+
                                     (##fl* inexact-c inexact-c)
                                     (##fl* inexact-d inexact-d)))))
                         ((##fl< q (macro-flonum-min-normal))
                          (let ((a
                                 (if (##flonum? a)
                                     (##fl* a (macro-inexact-scale-up))
                                     (##* a (macro-scale-up))))
                                (b
                                 (if (##flonum? b)
                                     (##fl* b (macro-inexact-scale-up))
                                     (##* b (macro-scale-up))))
                                (inexact-c
                                 (##fl* inexact-c
                                        (macro-inexact-scale-up)))
                                (inexact-d
                                 (##fl* inexact-d
                                        (macro-inexact-scale-up))))
                            (basic/ a
                                    b
                                    inexact-c
                                    inexact-d
                                    (##fl+
                                     (##fl* inexact-c inexact-c)
                                     (##fl* inexact-d inexact-d)))))
                         (else
                          (basic/ a b inexact-c inexact-d q))))
                 (cond ((##fl= inexact-c (macro-inexact-+inf))
                        (basic/ a
                                b
                                (macro-inexact-+0)
                                (if (##flnan? inexact-d)
                                    inexact-d
                                    (##flcopysign (macro-inexact-+0)
                                                  inexact-d))
                                (macro-inexact-+1)))
                       ((##fl= inexact-c (macro-inexact--inf))
                        (basic/ a
                                b
                                (macro-inexact--0)
                                (if (##flnan? inexact-d)
                                    inexact-d
                                    (##flcopysign (macro-inexact-+0)
                                                  inexact-d))
                                (macro-inexact-+1)))
                       ((##flnan? inexact-c)
                        (cond ((##fl= inexact-d (macro-inexact-+inf))
                               (basic/ a
                                       b
                                       inexact-c
                                       (macro-inexact-+0)
                                       (macro-inexact-+1)))
                              ((##fl= inexact-d (macro-inexact--inf))
                               (basic/ a
                                       b
                                       inexact-c
                                       (macro-inexact--0)
                                       (macro-inexact-+1)))
                              ((##flnan? inexact-d)
                               (basic/ a
                                       b
                                       inexact-c
                                       inexact-d
                                       (macro-inexact-+1)))
                              (else
                               (basic/ a
                                       b
                                       inexact-c
                                       (macro-inexact-+nan)
                                       (macro-inexact-+1)))))
                       (else
                        ;; finite inexact-c
                        (cond ((##flnan? inexact-d)
                               (basic/ a
                                       b
                                       (macro-inexact-+nan)
                                       inexact-d
                                       (macro-inexact-+1)))
                              (else
                               ;; inexact-d is +inf.0 or -inf.0
                               (basic/ a
                                       b
                                       (##flcopysign (macro-inexact-+0)
                                                     inexact-c)
                                       (##flcopysign (macro-inexact-+0)
                                                     inexact-d)
                                       (macro-inexact-+1))))))))))))

))

;;;----------------------------------------------------------------------------

(##include "~~lib/gambit/random/random.scm")

;;;============================================================================
