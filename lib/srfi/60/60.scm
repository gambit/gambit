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

(define-macro (check-fixnum er args body)
  `(macro-force-vars (,@args)
     ,(let loop ((args args)
                 (i    0))
        (if (null? args)
            body
            `(macro-check-fixnum
               ,(car args)
               ,i
               ,er
               ,(loop (cdr args)
                      (+ i 1)))))))

;;============================================================================
;; helpers

(define logical:boole-xor
 '#(#(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)
    #(1 0 3 2 5 4 7 6 9 8 11 10 13 12 15 14)
    #(2 3 0 1 6 7 4 5 10 11 8 9 14 15 12 13)
    #(3 2 1 0 7 6 5 4 11 10 9 8 15 14 13 12)
    #(4 5 6 7 0 1 2 3 12 13 14 15 8 9 10 11)
    #(5 4 7 6 1 0 3 2 13 12 15 14 9 8 11 10)
    #(6 7 4 5 2 3 0 1 14 15 12 13 10 11 8 9)
    #(7 6 5 4 3 2 1 0 15 14 13 12 11 10 9 8)
    #(8 9 10 11 12 13 14 15 0 1 2 3 4 5 6 7)
    #(9 8 11 10 13 12 15 14 1 0 3 2 5 4 7 6)
    #(10 11 8 9 14 15 12 13 2 3 0 1 6 7 4 5)
    #(11 10 9 8 15 14 13 12 3 2 1 0 7 6 5 4)
    #(12 13 14 15 8 9 10 11 4 5 6 7 0 1 2 3)
    #(13 12 15 14 9 8 11 10 5 4 7 6 1 0 3 2)
    #(14 15 12 13 10 11 8 9 6 7 4 5 2 3 0 1)
    #(15 14 13 12 11 10 9 8 7 6 5 4 3 2 1 0)))

(define logical:boole-and
 '#(#(0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)
    #(0 1 0 1 0 1 0 1 0 1 0 1 0 1 0 1)
    #(0 0 2 2 0 0 2 2 0 0 2 2 0 0 2 2)
    #(0 1 2 3 0 1 2 3 0 1 2 3 0 1 2 3)
    #(0 0 0 0 4 4 4 4 0 0 0 0 4 4 4 4)
    #(0 1 0 1 4 5 4 5 0 1 0 1 4 5 4 5)
    #(0 0 2 2 4 4 6 6 0 0 2 2 4 4 6 6)
    #(0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7)
    #(0 0 0 0 0 0 0 0 8 8 8 8 8 8 8 8)
    #(0 1 0 1 0 1 0 1 8 9 8 9 8 9 8 9)
    #(0 0 2 2 0 0 2 2 8 8 10 10 8 8 10 10)
    #(0 1 2 3 0 1 2 3 8 9 10 11 8 9 10 11)
    #(0 0 0 0 4 4 4 4 8 8 8 8 12 12 12 12)
    #(0 1 0 1 4 5 4 5 8 9 8 9 12 13 12 13)
    #(0 0 2 2 4 4 6 6 8 8 10 10 12 12 14 14)
    #(0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15)))

(define (logical:arithmetic-shift-4 x)
  (if (negative? x)
      (+ -1 (quotient (+ 1 x) 16))
      (quotient x 16)))

(define (logical:reduce f ident args)
  (let reduce-loop ((res ident)
                    (rgs args))
    (if (null? rgs)
        res
        (reduce-loop (f res (car rgs) 1 0)
                     (cdr rgs)))))

;;============================================================================
;; ---------------------------------------------------------------------------
;; bitwise-and

(define (logand n . ns)
  (define (unchecked-logand2 n2 n1 scl acc)
    (cond ((= n1 n2)  
           (+ acc (* scl n1)))
          ((zero? n2) acc)
          ((zero? n1) acc)
          (else (unchecked-logand2 (logical:arithmetic-shift-4 n2)
                        (logical:arithmetic-shift-4 n1)
                        (* 16 scl)
                        (+ (* (vector-ref 
                                (vector-ref
                                   logical:boole-and
                                   (modulo n1 16))
                                (modulo n2 16))
                              scl)
                           acc)))))
  (logical:reduce unchecked-logand2 -1 (cons n ns)))

(define (bitwise-and n . ns)
  (define (logand2 n2 n1 scl acc)
    (check-fixnum (bitwise-and n . ns) (n2 n1)
      (cond ((= n1 n2)  
             (+ acc (* scl n1)))
            ((zero? n2) acc)
            ((zero? n1) acc)
            (else (logand2 (logical:arithmetic-shift-4 n2)
                          (logical:arithmetic-shift-4 n1)
                          (* 16 scl)
                          (+ (* (vector-ref 
                                  (vector-ref
                                     logical:boole-and
                                     (modulo n1 16))
                                  (modulo n2 16))
                                scl)
                             acc))))))
  (logical:reduce logand2 -1 (cons n ns)))


;; ---------------------------------------------------------------------------
;; bitwise-ior

(define (logior n . ns)
  (define (unchecked-logior2 n2 n1 scl acc)
    (cond ((= n1 n2)  
           (+ acc (* scl n1)))
          ((zero? n2) (+ acc (* scl n1)))
          ((zero? n1) (+ acc (* scl n2)))
          (else (unchecked-logior2 (logical:arithmetic-shift-4 n2)
                        (logical:arithmetic-shift-4 n1)
                        (* 16 scl)
                        (+ (* (- 15 (vector-ref 
                                      (vector-ref
                                        logical:boole-and
                                        (- 15 (modulo n1 16)))
                                      (- 15 (modulo n2 16))))
                              scl)
                           acc)))))
  (logical:reduce unchecked-logior2 0 (cons n ns)))

(define (bitwise-ior n . ns)
  (define (logior2 n2 n1 scl acc)
    (check-fixnum (bitwise-ior n . ns) (n2 n1)
      (cond ((= n1 n2)  
             (+ acc (* scl n1)))
            ((zero? n2) (+ acc (* scl n1)))
            ((zero? n1) (+ acc (* scl n2)))
            (else (logior2 (logical:arithmetic-shift-4 n2)
                          (logical:arithmetic-shift-4 n1)
                          (* 16 scl)
                          (+ (* (- 15 (vector-ref 
                                        (vector-ref
                                          logical:boole-and
                                          (- 15 (modulo n1 16)))
                                        (- 15 (modulo n2 16))))
                                scl)
                             acc))))))
  (logical:reduce logior2 0 (cons n ns)))


;; ---------------------------------------------------------------------------
;; bitwise-xor

(define (logxor n . ns)
  (define (unchecked-logxor2 n2 n1 scl acc)
    (cond ((= n1 n2) acc)  
          ((zero? n2) (+ acc (* scl n1)))
          ((zero? n1) (+ acc (* scl n2)))
          (else (unchecked-logxor2 (logical:arithmetic-shift-4 n2)
                        (logical:arithmetic-shift-4 n1)
                        (* 16 scl)
                        (+ (* (vector-ref 
                                (vector-ref
                                   logical:boole-xor
                                   (modulo n1 16))
                                (modulo n2 16))
                              scl)
                           acc)))))
  (logical:reduce unchecked-logxor2 0 (cons n ns)))

(define (bitwise-xor n . ns)
  (define (logxor2 n2 n1 scl acc)
    (check-fixnum (bitwise-xor n . ns) (n2 n1)
      (cond ((= n1 n2) acc)  
            ((zero? n2) (+ acc (* scl n1)))
            ((zero? n1) (+ acc (* scl n2)))
            (else (logxor2 (logical:arithmetic-shift-4 n2)
                          (logical:arithmetic-shift-4 n1)
                          (* 16 scl)
                          (+ (* (vector-ref 
                                  (vector-ref
                                     logical:boole-xor
                                     (modulo n1 16))
                                  (modulo n2 16))
                                scl)
                             acc))))))
  (logical:reduce logxor2 0 (cons n ns)))


;; ---------------------------------------------------------------------------
;; bitwise-not

(define (lognot n) 
  (- -1 n))

(define-procedure (bitwise-not (n fixnum))
  (lognot n))


;; ---------------------------------------------------------------------------
;; any-bits-set?

(define (logtest n1 n2)
  (not (zero? (logand n1 n2))))

(define-procedure (any-bits-set? (n1 fixnum)
                                 (n2 fixnum))
  (logtest n1 n2))


;; ---------------------------------------------------------------------------
;; bit-set?

(define-procedure (bit-set? (index (index-range-incl
                                    0 (macro-max-fixnum32)))
                            (n     fixnum))
  (logtest (expt 2 index) n))


;; ---------------------------------------------------------------------------
;; copy-bit

(define-procedure (copy-bit (index (index-range-incl
                                    0 (macro-max-fixnum32)))
                            (to    fixnum)
                            (bool  boolean))
  (if bool
      (logior to (arithmetic-shift 1 index))
      (logand to (lognot (arithmetic-shift 1 index)))))


;; ---------------------------------------------------------------------------
;; bitwise-if

(define (bitwise-if mask n0 n1)
  (logior (logand mask n0)
          (logand (lognot mask) n1)))

(define-procedure (bitwise-merge (mask fixnum)
                                 (n0   fixnum)
                                 (n1   fixnum))
  (bitwise-if mask n0 n1))


;; ---------------------------------------------------------------------------
;; bit-field

(define-procedure (bit-field (n     fixnum)
                             (start (index-range-incl
                                      0 (macro-max-fixnum32)))
                             (end   (index-range-incl
                                      start (macro-max-fixnum32))))
  (logand (lognot (arithmetic-shift -1 (- end start)))
          (arithmetic-shift n (- start))))


;; ---------------------------------------------------------------------------
;; copy-bit-field

(define-procedure (copy-bit-field 
                   (to    fixnum) 
                   (from  fixnum)
                   (start (index-range-incl
                            0 (macro-max-fixnum32)))
                   (end   (index-range-incl
                            start (macro-max-fixnum32))))

  (bitwise-if (arithmetic-shift 
                (lognot (arithmetic-shift -1 (- end start))) 
                start)
              (arithmetic-shift 
                from 
                start)
              to))


;; ---------------------------------------------------------------------------
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
         (mask  (lognot (arithmetic-shift -1 width)))
         (zn    (logand mask (arithmetic-shift n (- start)))))
    (logior (arithmetic-shift
              (logior (logand mask (arithmetic-shift zn count))
                      (arithmetic-shift zn (- count width)))
              start)
            (logand (lognot (arithmetic-shift mask start)) n))))


;; ---------------------------------------------------------------------------
;; integer-length

(define (unchecked-integer-length n)
  (let intlen-loop ((n   n)
                    (tot 0))
    (case n
      ((0 -1) (+ tot 0))
      ((1 -2) (+ tot 1))
      ((2 3 -3 -4) (+ 2 tot))
      ((4 5 6 7 -5 -6 -7 -8) (+ tot 3))
      (else (intlen-loop (logical:arithmetic-shift-4 n) (+ tot 4))))))


(define-procedure (integer-length (n fixnum))
  (unchecked-integer-length n))


;; ---------------------------------------------------------------------------
;; bit-count

(define-procedure (bit-count (n fixnum))
  (define (bit-count-loop n tot)
    (if (zero? n)
        tot
        (bit-count-loop (quotient n 16)
                       (+ (vector-ref
                           '#(0 1 1 2 1 2 2 3 1 2 2 3 2 3 3 4)
                           (modulo n 16))
                          tot))))
  (cond
    ((negative? n)
     (bit-count-loop (lognot n) 0))
    ((positive? n)
     (bit-count-loop n 0))
    (else 0)))


;; ---------------------------------------------------------------------------
;; first-set-bit

; log2 binary factors
(define-procedure (first-set-bit (n fixnum))
  (+ -1 (unchecked-integer-length (logand n (- n)))))


;; ---------------------------------------------------------------------------
;; reverse-bit-field

(define-procedure (reverse-bit-field (n fixnum)
                                     (start (index-range-incl 
                                             0 (macro-max-fixnum32)))
                                     (end (index-range-incl
                                            start (macro-max-fixnum32))))
  (define (bit-reverse k n)
    (let rev-loop ((m (if (negative? n)
                          (lognot n)
                          n))
                   (k (+ -1 k))
                   (rvs 0))
      (if (negative? k)
          (if (negative? n)
              (lognot rvs)
              rvs)
          (rev-loop (arithmetic-shift m -1)
                    (+ -1 k)
                    (logior (arithmetic-shift rvs 1)
                            (logand 1 m))))))

  (let* ((width (- end start))
         (mask  (lognot (arithmetic-shift -1 width)))
         (zn    (logand mask (arithmetic-shift n (- start)))))
    (logior (arithmetic-shift (bit-reverse width zn) start)
            (logand (lognot (arithmetic-shift mask start)) n))))
          

;; ---------------------------------------------------------------------------
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


;; ---------------------------------------------------------------------------
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


;; ---------------------------------------------------------------------------
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


;; ---------------------------------------------------------------------------
;; arithmetic-shift
;
;   -> builtin!
;
;
;;;===========================================================================
