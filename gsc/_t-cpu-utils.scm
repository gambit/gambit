;;=============================================================================

;;; File: "_t-cpu-utils.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.
;;; Copyright (c) 2019 by Abdelhakim Qbaich, All Rights Reserved.

;;-----------------------------------------------------------------------------

(define (safe-car pair) ; XXX
  (and (pair? pair) (car pair)))

(define (safe-cdr pair) ; XXX
  (and (pair? pair) (cdr pair)))

(define (flip pair)
  (cons (cdr pair) (car pair)))

(define (in-range? min max val)
  (and (>= val min) (<= val max)))

(define (count item lst #!optional (=? equal?))
  (cond ((null? lst) 0)
        ((=? item (car lst))
         (+ 1 (count item (cdr lst) =?)))
        (else (count item (cdr lst) =?))))

(define (filter pred lst)
  (cond ((null? lst) '())
        ((pred (car lst))
         (cons (car lst) (filter pred (cdr lst))))
        (else (filter pred (cdr lst)))))

;;=============================================================================
