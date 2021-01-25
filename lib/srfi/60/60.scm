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
;; built-in

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

(define-macro (bitwise-merge/if merge/if)
  `(lambda (x y z)
     (macro-force-vars (x y z)
       (cond ((##not (macro-exact-int? x))
              (##fail-check-exact-integer 1 ,merge/if x y z))
             ((##not (macro-exact-int? y))
              (##fail-check-exact-integer 2 ,merge/if x y z))
             ((##not (macro-exact-int? z))
              (##fail-check-exact-integer 3 ,merge/if x y z))
             (else
              (##bitwise-merge (##bitwise-not x) y z))))))

(define-prim bitwise-merge (bitwise-merge/if bitwise-merge))
(define-prim bitwise-if (bitwise-merge/if bitwise-if))

;;---------------------------------------------------------------------------
;; any-bits-set?
;; logtest

(define-prim (logtest x y)
  (macro-force-vars (x y)
    (cond ((##not (macro-exact-int? x))
           (##fail-check-exact-integer 1 logtest x y))
          ((##not (macro-exact-int? y))
           (##fail-check-exact-integer 2 logtest x y))
          (else
           (##any-bits-set? x y)))))


;===========================================================================
;;===========================================================================
;;
;; Integer Property
;;
;;===========================================================================

;;---------------------------------------------------------------------------
;; bit-count
;; logcount

(define-prim (logcount x)
  (macro-force-vars (x)
    (let ((type-error 
            (lambda ()
              (##fail-check-exact-integer 
                1 
                logcount 
                x))))
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

(define first-set-bit first-bit-set)
(define log2-binary-factors first-bit-set)


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

(define-prim (##copy-bit index to bool)
  (if bool
     (##bitwise-ior to (##arithmetic-shift 1 index))
     (##bitwise-and to (##bitwise-not (##arithmetic-shift 1 index)))))


(define-prim (copy-bit index to bool)
  (macro-force-vars (index to bool)
    (macro-check-index
      index
      1
      (copy-bit index to bool)
      (macro-check-boolean
        bool
        3
        (copy-bit index to bool)
        (begin
        (if (##not (macro-exact-int? to))
            (##fail-check-exact-integer 2 copy-bit index to bool)
            (##copy-bit index to bool)))))))


;;===========================================================================
;;===========================================================================
;; 
;; Field of Bits
;; 
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; bit-field


(define-prim (bit-field n start end)
  (macro-force-vars (n start end)
    (macro-check-index
      start
      2
      (bit-field n start end)
      (macro-check-fixnum-range-incl
        end
        3
        start ##max-fixnum
        (bit-field n start end)
        (if (##not (macro-exact-int? n))
            (##fail-check-exact-integer 
              1 
              bit-field
              n 
              start 
              end)
            (##extract-bit-field 
              (##fx- end start) 
              start 
              n))))))

;;---------------------------------------------------------------------------
;; copy-bit-field

(define-prim (copy-bit-field to from start end)
  (macro-force-vars (to from start end)
    (macro-check-index
      start
      3
      (copy-bit-field size position from to)
      (macro-check-fixnum-range-incl
        end
        4
        start ##max-fixnum
        (copy-bit-field to from start end)
        (cond ((##not (macro-exact-int? from))
               (##fail-check-exact-integer 2 copy-bit-field to from start end))
              ((##not (macro-exact-int? to))
               (##fail-check-exact-integer 1 copy-bit-field to from start end))
              (else
               (##copy-bit-field (##fx- end start) start from to)))))))

  
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
  (let* ((width (##fx- end start))
         (count (##fxmodulo count width))
         (mask  (##bitwise-not (##arithmetic-shift -1 width)))
         (zn    (##bitwise-and mask (##arithmetic-shift n (##fx- start)))))
    (##bitwise-ior 
      (##arithmetic-shift
        (##bitwise-ior 
          (##bitwise-and 
            mask 
            (##arithmetic-shift zn count))
          (##arithmetic-shift zn (##fx- count width)))
        start)
      (##bitwise-and 
        (##bitwise-not (##arithmetic-shift mask start))
        n))))

(define-prim (rotate-bit-field n count start end)
  (macro-force-vars (n count start end)
    (macro-check-fixnum
      count
      2
      (rotate-bit-field n count start end)
      (macro-check-index
        start
        3
        (rotate-bit-field n count start end)
        (macro-check-fixnum-range-incl
          end
          4
          start ##max-fixnum
          (rotate-bit-field n count start end)
          (if (##not (macro-exact-int? n))
              (##fail-check-exact-integer 
                1 
                bit-field 
                n
                start
                end)
              (##rotate-bit-field n count start end)))))))
 

;;---------------------------------------------------------------------------
;; reverse-bit-field

(define-prim (reverse-bit-field n start end)

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
    (macro-check-index
      start
      2
      (reverse-bit-field n start end)
      (macro-check-fixnum-range-incl
        end
        3
        start ##max-fixnum
        (reverse-bit-field n start end)
        (let* ((width (##fx- end start))
               (mask  (##bitwise-not (##arithmetic-shift -1 width)))
               (zn    (##bitwise-and mask (##arithmetic-shift n (##fx- start)))))
          
          (##bitwise-ior 
            (let ((reversed-bit 
                    (macro-exact-int-dispatch n (type-error)
                      (fixmum-bit-reverse width zn)
                      (bignum-bit-reverse width zn))))
              (##arithmetic-shift reversed-bit start))
            (##bitwise-and 
              (##bitwise-not (##arithmetic-shift mask start)) n)))))))
       
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
