;;;============================================================================

;;; File: "60.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Copyright (C) 1991, 1993, 2001, 2003, 2005 Aubrey Jaffer
;
; Permission to copy this software, to modify it, to redistribute it,
; to distribute modified versions, and to use it for any purpose is
; granted, subject to the following restrictions and understandings.
;
; 1.  Any copy made of this software must include this copyright notice
; in full.
;
; 2.  I have made no warranty or representation that the operation of
; this software will be error-free, and I am under no obligation to
; provide any services, by way of maintenance, update, or otherwise.
;
; 3.  In conjunction with products arising from the use of this
; material, there shall be no use of my name in any advertising,
; promotional, or sales literature without prior written consent in
; each case.

;;;============================================================================

;;; SRFI 60, Integers as Bits

(##supply-module srfi/60)

(include "~~lib/_gambit#.scm")
(include "~~lib/_define-syntax.scm")


;;---------------------------------------------------------------------------
;;===========================================================================
;;
;; Bitwise Operations
;;
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; bitwise-and
;; logand
;;
;; bitwise-ior
;; logior
;;
;; bitwise-xor
;; logxor

(define-macro (define-prim-nary-bitwise-op op prim)
  `(define-prim-nary (,op x y)
     -1
     (if (macro-exact-int? x)
         x
         '(1))
     (,prim x y)
     macro-force-vars
     macro-no-check
     (##pair? ##fail-check-exact-integer)))

(define-prim-nary-bitwise-op logand ##bitwise-and2)
(define-prim-nary-bitwise-op logior ##bitwise-ior2)
(define-prim-nary-bitwise-op logxor ##bitwise-xor2)

;;---------------------------------------------------------------------------
;; bitwise-not
;; lognot
;;
;; bitwise-not -> built-in

(define-prim (lognot x)
  (macro-force-vars (x)
    (let ((type-error
            (lambda ()
              (##fail-check-exact-integer 1 lognot x))))
      (macro-exact-int-dispatch x (type-error)
        (##fxnot x)
        ;; don't copy, bitwise invert
        (##bignum.make (##bignum.adigit-length x) x #t)))))

  
;;----------------------------------------------------------------------------
;; bitwise-merge
;; bitwise-if

(define-procedure (bitwise-merge (x exact-integer)
                                 (y exact-integer)
                                 (z exact-integer))
  (##bitwise-merge (##bitwise-not x) y z))

(define-procedure (bitwise-if (x exact-integer)
                              (y exact-integer)
                              (z exact-integer))
  (##bitwise-merge (##bitwise-not x) y z))


;;---------------------------------------------------------------------------
;; any-bits-set?
;; logtest
;;
;; any-bits-set? -> built-in

(define-prim&proc (logtest (x exact-integer)
                           (y exact-integer))
  (##any-bits-set? x y))

;===========================================================================
;;===========================================================================
;;
;; Integer Property
;;
;;===========================================================================

;;---------------------------------------------------------------------------
;; bit-count
;; logcount
;;
;; bit-count -> built-in

(define-prim (logcount x)
  (macro-force-vars (x)
    (let ((type-error
            (lambda () (##fail-check-exact-integer 1 logcount x))))
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
                        (##fx+ n (##fxbit-count (##bignum.mdigit-ref x i)))))))))))

;;---------------------------------------------------------------------------
;; integer-length
;;
;; built-in

;;---------------------------------------------------------------------------
;; first-set-bit
;; log2-binary-factors

(define-prim (first-set-bit x)
  (macro-force-vars (x)
    (let ((type-error
            (lambda () 
              (##fail-check-exact-integer 1 first-set-bit x))))
      (macro-exact-int-dispatch x (type-error)
        (##fxfirst-bit-set x)
        (let ((x-length (##bignum.mdigit-length x)))
          (let loop ((i 0))
            (let ((mdigit (##bignum.mdigit-ref x i)))
              (if (##fx= mdigit 0)
                  (loop (##fx+ i 1))
                  (##fx+
                   (##fxfirst-bit-set mdigit)
                   (##fx* i ##bignum.mdigit-width))))))))))

(define-prim (log2-binary-factors x)
  (macro-force-vars (x)
    (let ((type-error
            (lambda () 
              (##fail-check-exact-integer 1 log2-binary-factors x))))
      (macro-exact-int-dispatch x (type-error)
        (##fxfirst-bit-set x)
        (let ((x-length (##bignum.mdigit-length x)))
          (let loop ((i 0))
            (let ((mdigit (##bignum.mdigit-ref x i)))
              (if (##fx= mdigit 0)
                  (loop (##fx+ i 1))
                  (##fx+
                   (##fxfirst-bit-set mdigit)
                   (##fx* i ##bignum.mdigit-width))))))))))


;;===========================================================================
;;===========================================================================
;;
;; Bit Within word
;;
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; bit-set?
;; logbit?
;;
;; bit-set? -> built-in

(define-prim (logbit? x y)
  (macro-force-vars (x y)
    (let ((type-error-on-x 
            (lambda ()
              (##fail-check-exact-integer 1 logbit? x y)))
          (type-error-on-y
            (lambda () 
              (##fail-check-exact-integer 2 logbit? x y)))
          (range-error
            (lambda ()
              (##raise-range-exception 1 logbit? x y))))

      (macro-exact-int-dispatch x (type-error-on-x)

        (macro-exact-int-dispatch y (type-error-on-y) ;; x = fixnum
          (if (##fxnegative? x)
              (range-error)
              (if (##fx< x ##fixnum-width)
                  (##fxodd? (##fxarithmetic-shift-right y x))
                  (##fxnegative? y)))
          (if (##fxnegative? x)
              (range-error)
              (let ((i (##fxquotient x ##bignum.mdigit-width)))
                (if (##fx< i (##bignum.mdigit-length y))
                    (##fxodd?
                     (##fxarithmetic-shift-right
                      (##bignum.mdigit-ref y i)
                      (##fxmodulo x ##bignum.mdigit-width)))
                    (##bignum.negative? y)))))

        (macro-exact-int-dispatch y (type-error-on-y) ;; x = bignum
          (if (##bignum.negative? x)
              (range-error)
              (##fxnegative? y))
          (if (##bignum.negative? x)
              (range-error)
              (##bignum.negative? y)))))))



;;---------------------------------------------------------------------------
;; copy-bit

(define-prim&proc (copy-bit (index nonnegative-exact-integer)
                            (to    exact-integer)
                            (bool  boolean))
  (if bool
     (##bitwise-ior to (##arithmetic-shift 1 index))
     (##bitwise-and to (##bitwise-not (##arithmetic-shift 1 index)))))


;;===========================================================================
;;===========================================================================
;; 
;; Field of Bits
;; 
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; bit-field


(define-prim&proc (bit-field (n     exact-integer)
                             (start nonnegative-exact-integer)
                             (end   exact-integer))
  (cond
    ((##> start end)
     (##raise-range-exception end bit-field n start end))
    (else
     (##extract-bit-field (##- end start) start n))))


;;---------------------------------------------------------------------------
;; copy-bit-field

(define-procedure (copy-bit-field (to    exact-integer)
                                  (from  exact-integer)
                                  (start nonnegative-exact-integer)
                                  (end   exact-integer))
  (cond ((##< end start)
         (##raise-range-exception end copy-bit-field to from start end))
        (else
         (##copy-bit-field (##- end start) start from to))))

 
;;---------------------------------------------------------------------------
;; arithmetic-shift
;; ash

(define-prim (ash x y)
  (macro-force-vars (x y)
    (let ((type-error-on-x 
            (lambda ()
              (##fail-check-exact-integer 1 ash x y)))

          (type-error-on-y 
            (lambda () 
              (##fail-check-exact-integer 2 ash x y)))

          (fixnum-overflow 
            (lambda () 
              (##raise-fixnum-overflow-exception ash x y)))

          (overflow 
            (lambda () 
              (##raise-heap-overflow-exception)
              (##arithmetic-shift x y)))

          (general-fixnum-fixnum-case 
            (lambda () 
              (macro-if-bignum
               (##bignum.arithmetic-shift (##fixnum->bignum x) y)
               (fixnum-overflow)))))

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
                 (overflow))))))))

;;---------------------------------------------------------------------------
;; rotate-bit-field

(define-prim (##rotate-bit-field n count start end)
  (let* ((width (##- end start))
         (count (##modulo count width))
         (mask  (##bitwise-not (##arithmetic-shift -1 width)))
         (zn    (##bitwise-and mask (##arithmetic-shift n (##- start)))))
    (##bitwise-ior 
      (##arithmetic-shift
        (##bitwise-ior 
          (##bitwise-and 
            mask 
            (##arithmetic-shift zn count))
          (##arithmetic-shift zn (##- count width)))
        start)
      (##bitwise-and 
        (##bitwise-not (##arithmetic-shift mask start))
        n))))

(define-procedure (rotate-bit-field (n     exact-integer)
                                    (count exact-integer); can be neg
                                    (start nonnegative-exact-integer)
                                    (end   exact-integer)) 
  (cond 
    ((##< end start)
     (##raise-range-exception end rotate-bit-field n count start end))
    (else
     (##rotate-bit-field n count start end))))

;;---------------------------------------------------------------------------
;; reverse-bit-field

(define-prim (reverse-bit-field n start end)

  (define (type-error)
    (##fail-check-exact-integer 1 reverse-bit-field n start end))
            
  (define (fixnum-bit-reverse k n)
    (let reverse-loop ((m (if (##fxnegative? n)
                              (##bitwise-not n)
                              n))
                       (k (##fx- k 1))
                       (rvs-acc 0))
      (if (##fxnegative? k)
          (if (##fxnegative? n)
              (##bitwise-not rvs-acc)
              rvs-acc)
          (reverse-loop (##arithmetic-shift m -1)
                        (##fx- k 1)
                        (##bitwise-ior 
                          (##arithmetic-shift rvs-acc 1)
                          (##bitwise-and 1 m))))))

  (define (bignum-bit-reverse k n)
    (let reverse-loop ((m (if (##bignum.negative? n)
                              (##bitwise-not n)
                              n))
                       (k (##fx- k 1))
                       (rvs-acc 0))
      (if (##fxnegative? k)
          (if (##bignum.negative? n)
              (##bitwise-not rvs-acc)
              rvs-acc)
          (reverse-loop (##arithmetic-shift m -1)
                        (##fx- k 1)
                        (##bitwise-ior 
                          (##arithmetic-shift rvs-acc 1)
                          (##bitwise-and 1 m))))))

  (macro-force-vars (n start end)
    (macro-check-nonnegative-exact-integer
      start
      2
      (reverse-bit-field n start end)
      (macro-check-exact-integer
        end
        3
        (reverse-bit-field n start end)
        (cond
          ((##< end start) 
           (##raise-range-exception end reverse-bit-field n start end))
          (else
           (let* ((width (##fx- end start))
                  (mask  (##bitwise-not (##arithmetic-shift -1 width)))
                  (zn    (##bitwise-and mask (##arithmetic-shift n (##fx- start)))))
            
             (##bitwise-ior 
               (let ((reversed-bit 
                       (macro-exact-int-dispatch n (type-error)
                         (fixnum-bit-reverse width zn)
                         (bignum-bit-reverse width zn))))
                 (##arithmetic-shift reversed-bit start))
               (##bitwise-and 
                 (##bitwise-not (##arithmetic-shift mask start)) n)))))))))
           
;;===========================================================================
;;===========================================================================
;; 
;; Bits as Booleans
;; 
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; integer->list

(define-prim (##integer->list k #!optional (len (macro-absent-obj)))
  (let ((type-error 
          (lambda () (##fail-check-exact-integer k 1 ##integer->list k len))))
  (macro-exact-int-dispatch k (type-error)
    (letrec ((fixnum->list-no-len
               (lambda (k lst)
                 (if (##fx<= k 0)
                     lst
                     (fixnum->list-no-len
                       (##arithmetic-shift k -1)
                       (cons (##fxodd? k) lst)))))

             (fixnum->list
               (lambda (idx k lst)
                 (if (##fxnegative? idx)
                     lst
                     (fixnum->list 
                       (##fx- idx 1)
                       (##arithmetic-shift k -1)
                       (cons (##fxodd? k) lst))))))

      (if (equal? len (macro-absent-obj))
          (fixnum->list-no-len k '())
          (fixnum->list (##fx- len 1) k '())))

    (letrec ((bignum->list-no-len
               (lambda (k lst)
                 (if (<= k 0)
                     lst
                     (bignum->list-no-len
                       (##arithmetic-shift k -1)
                       (cons (odd? k) lst)))))

             (bignum->list
               (lambda (idx k lst)
                 (if (##fxnegative? idx)
                     lst
                     (bignum->list 
                       (##fx- idx 1)
                       (##arithmetic-shift k -1)
                       (cons (odd? k) lst))))))
      (if (equal? len (macro-absent-obj))
          (bignum->list-no-len k '())
          (bignum->list (##fx- len 1) k '()))))))


(define-prim (integer->list k #!optional (len (macro-absent-obj)))
  (let ((type-error 
        (lambda () (##fail-check-exact-integer k 1 ##integer->list k len))))
    (macro-exact-int-dispatch k (type-error)
      (letrec ((fixnum->list-no-len
                 (lambda (k lst)
                   (if (##fx<= k 0)
                       lst
                       (fixnum->list-no-len
                         (##arithmetic-shift k -1)
                         (cons (##fxodd? k) lst)))))

               (fixnum->list
                 (lambda (idx k lst)
                   (if (##fxnegative? idx)
                       lst
                       (fixnum->list 
                         (##fx- idx 1)
                         (##arithmetic-shift k -1)
                         (cons (##fxodd? k) lst))))))

        (if (equal? len (macro-absent-obj))
            (fixnum->list-no-len k '())
            (macro-check-index
              len
              2
              (integer->list k len)
              (fixnum->list (##fx- len 1) k '()))))

      (letrec ((bignum->list-no-len
                 (lambda (k lst)
                   (if (<= k 0)
                       lst
                       (bignum->list-no-len
                         (##arithmetic-shift k -1)
                         (cons (odd? k) lst)))))

               (bignum->list
                 (lambda (idx k lst)
                   (if (##fxnegative? idx)
                       lst
                       (bignum->list 
                         (##fx- idx 1)
                         (##arithmetic-shift k -1)
                         (cons (odd? k) lst))))))
        (if (equal? len (macro-absent-obj))
            (bignum->list-no-len k '())
            (macro-check-index
              len
              2
              (integer->list k len)
              (bignum->list (##fx- len 1) k '())))))))



;;---------------------------------------------------------------------------
;; list->integer
;;
;; booleans->integer

(define-macro (list/booleans->integer fixnum-overflow bools)
  `(let fixnum-loop ((bools ,bools)
                     (int   0))
     (if (##null? bools)
         int
         (let ((bool (if (##car bools) 1 0)))
           (cond
             ((##fx*? 2 int) => 
              (lambda (int2) 
                (fixnum-loop 
                  (##cdr bools)
                  (##fx+ int2 bool))))
             (else
               (macro-if-bignum
                 ; we skip one fixnum/bignum check by tail-calling to this loop
                 ; (no need to dispatch on the `int` accumulator)
                 (let bignum-loop ((bools (##cdr bools))
                                   (int   (+ (* (##fixnum->bignum int)
                                                2)
                                             bool)))
                   (if (##null? bools)
                       int
                       (bignum-loop 
                         (##cdr bools) 
                         (+ int int (if (##car bools) 1 0)))))
                 ,fixnum-overflow)))))))
 
;; ---------------------------------------------------------------------------

(define-prim (##list->integer bools)
  (list/booleans->integer (##raise-fixnum-overflow-exception ##list->integer bools) bools))


(define-prim (list->integer bools)
  (macro-force-vars (bools)
    (macro-check-pair
      bools
      1
      (list->integer bools)
      (let fixnum-loop ((bools bools)
                        (int   0))
        (if (##not (##pair? bools))
            (macro-check-list
              bools
              1
              (list->integer bools)
              int)
            (let ((bool (##car bools)))
              (macro-check-boolean
                bool
                0
                (list->integer bools)
                (let ((bool-val (if bool 1 0)))
                  (cond
                    ((##fx*? 2 int) => 
                       (lambda (int2) 
                         (fixnum-loop 
                           (##cdr bools)
                           (##fx+ int2 bool-val))))
                    (else
                      (macro-if-bignum
                        ; we skip one fixnum/bignum check by tail-calling to this loop
                        ; (no need to dispatch on the `int` accumulator)
                        (let ((int (##fixnum->bignum int)))
                          (let bignum-loop ((bools (##cdr bools))
                                            (int   (##bignum.+
                                                     int
                                                     int 
                                                     (##fixnum->bignum bool-val))))
                            (if (##not ##pair? bools)
                                (macro-check-list
                                  bools
                                  1
                                  (list->integer bools)
                                  int)
                                (let ((bool (##car bools)))
                                  (macro-check-boolean
                                    bool
                                    0
                                    (list->integer bools)
                                    (bignum-loop 
                                      (##cdr bools) 
                                      (##bignum.+ int int (##fixnum->bignum (if bool 1 0)))))))))
                        (##raise-fixnum-overflow-exception list->integer bools))))))))))))

;; ---------------------------------------------------------------------------

(define-prim (##booleans->integer bools)
  (list/booleans->integer (apply ##raise-fixnum-overflow-exception (cons ##booleans->integer bools)) bools))

(define-prim (booleans->integer . bools)
  (macro-force-vars (bools)
    (let fixnum-loop ((bools bools)
                      (index 0)
                      (int   0))
      (if (null? bools)
          int
          (let ((bool (car bools)))
            (macro-check-boolean
              bool
              index
              (list->integer bools)
              (let ((bool-val (if bool 1 0)))
                (cond
                  ((##fx*? 2 int) => 
                     (lambda (int2) 
                       (fixnum-loop 
                         (cdr bools)
                         (##fx+ index 1)
                         (##fx+ int2 bool-val))))
                  (else
                    (macro-if-bignum
                      (let ((int (##fixnum->bignum int)))
                        (let bignum-loop ((bools (##cdr bools))
                                          (index (##fx+ index 1))
                                          (int   (##bignum.+
                                                   int
                                                   int
                                                   (##fixnum->bignum bool-val))))
                          (if (##null? bools)
                              int
                              (let ((bool (##car bools)))
                                (macro-check-boolean
                                  bool
                                  index
                                  (list->integer bools)
                                  (bignum-loop 
                                    (##cdr bools) 
                                    (##fx+ index 1) 
                                    (##bignum.+ 
                                      int
                                      int)
                                      (##fixnum->bignum (if bool 1 0))))))))
                      (apply ##raise-fixnum-overflow-exception (##cons booleans->integer bools))))))))))))


;;;===========================================================================
