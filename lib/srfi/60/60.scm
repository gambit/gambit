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

;;;===========================================================================
;; Type checking

(define-macro (checked-bitwise-op call)
  (let ((op     (car call))
        (n-init (cadr call))
        (ns     (cddr call)))
    `(macro-check-fixnum 
       ,n-init
       1
       ,call
       (let loop ((i 2)
                  (ns ,ns)
                  (n-acc ,n-init))
         (if (null? ns)
             n-acc
             (let ((n (car ns)))
               (macro-check-fixnum
                 n
                 i
                 ,call
                 (loop (+ i 1)
                       (cdr ns)
                       (,op n n-acc)))))))))


;;---------------------------------------------------------------------------
;;===========================================================================
;;
;; Bitwise Operations
;;
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; bitwise-and

(define (bitwise-and n . ns)
  (checked-bitwise-op (##bitwise-and n . ns)))

;;---------------------------------------------------------------------------
;; bitwise-ior

(define (bitwise-ior n . ns)
  (checked-bitwise-op (##bitwise-ior n . ns)))

;;---------------------------------------------------------------------------
;; bitwise-xor

(define (bitwise-xor n . ns)
  (checked-bitwise-op (##bitwise-xor n . ns)))

;;---------------------------------------------------------------------------
;; bitwise-not
;;
;; built-in
  
;;----------------------------------------------------------------------------
;; bitwise-merge

(define (bitwise-merge x y z)
  (macro-force-vars (x y z)
    (cond ((##not (macro-exact-int? x))
           (##fail-check-exact-integer 1 bitwise-merge x y z))
          ((##not (macro-exact-int? y))
           (##fail-check-exact-integer 2 bitwise-merge x y z))
          ((##not (macro-exact-int? z))
           (##fail-check-exact-integer 3 bitwise-merge x y z))
          (else
           (##bitwise-merge (##bitwise-not x) y z)))))  

;;---------------------------------------------------------------------------
;; any-bits-set?
;;
;; built-in



;;===========================================================================
;;===========================================================================
;;
;; Integer Property
;;
;;===========================================================================

;;---------------------------------------------------------------------------
;; bit-count
;;
;; built-in

;;---------------------------------------------------------------------------
;; integer-length
;;
;; built-in

;;---------------------------------------------------------------------------
;; first-set-bit

(define first-set-bit first-bit-set)



;;===========================================================================
;;===========================================================================
;;
;; Bit Within word
;;
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; bit-set?
;;
;; built-in

;;---------------------------------------------------------------------------
;; copy-bit

(define-procedure (copy-bit (index (index-range-incl
                                    0 (macro-max-fixnum32)))
                            (to    fixnum)
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


(define-procedure (bit-field (n     fixnum)
                             (start (index-range-incl
                                      0 (macro-max-fixnum32)))
                             (end   (index-range-incl
                                      start (macro-max-fixnum32))))
  (##extract-bit-field (- end start) start n))

;;---------------------------------------------------------------------------
;; copy-bit-field

(define-procedure (copy-bit-field 
                   (to    fixnum) 
                   (from  fixnum)
                   (start (index-range-incl
                            0 (macro-max-fixnum32)))
                   (end   (index-range-incl
                            start (macro-max-fixnum32))))
  (##copy-bit-field (- end start) start from to)) 
  
;;---------------------------------------------------------------------------
;; arithmetic-shift
;; 
;; built-in

;;---------------------------------------------------------------------------
;; rotate-bit-field

(define-procedure (rotate-bit-field 
                   (n     fixnum) 
                   (count fixnum)
                   (start (index-range-incl
                     0 (macro-max-fixnum32)))
                   (end   (index-range-incl
                            start (macro-max-fixnum32))))
  (let* ((width (- end start))
         (count (modulo count width))
         (mask  (##bitwise-not (##arithmetic-shift -1 width)))
         (zn    (##bitwise-and mask (##arithmetic-shift n (- start)))))
    (##bitwise-ior 
      (##arithmetic-shift
        (##bitwise-ior 
          (##bitwise-and 
            mask 
            (##arithmetic-shift zn count))
          (##arithmetic-shift zn (- count width)))
        start)
      (##bitwise-and 
        (##bitwise-not (##arithmetic-shift mask start))
        n))))

;;---------------------------------------------------------------------------
;; reverse-bit-field

(define-procedure (reverse-bit-field (n fixnum)
                                     (start (index-range-incl 
                                             0 (macro-max-fixnum32)))
                                     (end (index-range-incl
                                            start (macro-max-fixnum32))))
  (define (bit-reverse k n)
    (let rev-loop ((m (if (negative? n)
                          (##bitwise-not n)
                          n))
                   (k (+ -1 k))
                   (rvs 0))
      (if (negative? k)
          (if (negative? n)
              (##bitwise-not rvs)
              rvs)
          (rev-loop (##arithmetic-shift m -1)
                    (+ -1 k)
                    (##bitwise-ior (##arithmetic-shift rvs 1)
                            (##bitwise-and 1 m))))))

  (let* ((width (- end start))
         (mask  (##bitwise-not (##arithmetic-shift -1 width)))
         (zn    (##bitwise-and mask (##arithmetic-shift n (- start)))))
    (##bitwise-ior (##arithmetic-shift (bit-reverse width zn) start)
            (##bitwise-and (##bitwise-not (##arithmetic-shift mask start)) n))))
 


;;===========================================================================
;;===========================================================================
;; 
;; Bits as Booleans
;; 
;;===========================================================================
;;
;;---------------------------------------------------------------------------
;; integer->list

(define (integer->list k #!optional (len (macro-absent-obj)))
  (macro-force-vars (k)
    (macro-check-index-range-incl
      k 0 0 (macro-max-fixnum32)
      (integer->list k len)
    (if (equal? len (macro-absent-obj))
        (let int->list-loop ((k k)
                             (lst '()))
          (if (<= k 0)
              lst
              (int->list-loop (arithmetic-shift k -1)
                              (cons (odd? k) lst))))
        (let int->list-loop ((idx (+ -1 len))
                             (k k)
                             (lst '()))
          (if (negative? idx)
              lst
              (int->list-loop (+ -1 idx)
                              (arithmetic-shift k -1)
                              (cons (odd? k) lst))))))))


;;---------------------------------------------------------------------------
;; list->integer

(define (list->integer bools)
  (macro-force-vars (,@bools)
    (let list->int-loop ((bs  bools)
                         (acc 0))
      (if (null? bs)
          acc
          (let ((b (car bs)))
            (let ((n-acc (macro-check-boolean
                           b
                           0
                           (list->integer bools)
                           (+ acc acc (if b 1 0))))) 
              (list->int-loop (cdr bs) n-acc)))))))


;;---------------------------------------------------------------------------
;; booleans->integer

(define (booleans->integer . bools)
  (macro-force-vars (,@bools)
    (let list->int-loop ((bs  bools)
                         (acc 0))
      (if (null? bs)
          acc
          (let ((b (car bs)))
            (let ((n-acc (macro-check-boolean
                           b
                           0
                           (booleans->integer . bools)
                           (+ acc acc (if b 1 0))))) 
              (list->int-loop (cdr bs) n-acc)))))))


;;;===========================================================================
