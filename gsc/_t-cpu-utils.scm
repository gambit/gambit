;;==============================================================================

;;; File: "_t-cpu-abstract-machine.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

;;------------------------------------------------------------------------------

;; ***** Utils

(define _debug #t)
(define (debug . str)
  (if _debug
    (begin
      (for-each display str)
      (newline))))

;; ***** Utils - Lists

(define (make-bitmap lst)
  (define bitmap 0)
  (define bit-value 1)
  (for-each
    (lambda (x)
      (if x
        (set! bitmap (+ bitmap bit-value)))
      (set! bit-value (* 2 bit-value)))
    lst)
  bitmap)

(define (find pred elems #!optional (index 0))
  (if (null? elems)
    -1
    (if (pred (car elems))
      index
      (find pred (cdr elems) (+ 1 index)))))

(define (index-of elem elems)
  (find (lambda (var) (equal? var elem)) elems))

(define (elem? elem elems)
  (not (= -1 (index-of elem elems))))

(define (iota start end)
  (if (> start end)
    '()
    (cons start (iota (+ start 1) end))))

(define (filter pred elems)
  (if (null? elems)
    '()
    (if (pred (car elems))
      (cons (car elems) (filter pred (cdr elems)))
      (filter pred (cdr elems)))))

(define (map-nth list nth fun)
  (if (= 0 nth)
    (cons (fun (car list)) (cdr list))
    (cons (car list) (map-nth (cdr list) (- nth 1) fun))))

(define (reorder-list elems indexes)
  (if (null? indexes)
    '()
    (cons
      (list-ref elems (car indexes))
      (reorder-list elems (cdr indexes)))))

(define (swap-index index1 index2 elems)
  (define (build-list elems index elem1 elem2)
    (cond ((null? elems)
           '())
          ((= index index1)
           (cons elem2 (build-list (cdr elems) (+ 1 index) elem1 elem2)))
          ((= index index2)
           (cons elem1 (build-list (cdr elems) (+ 1 index) elem1 elem2)))
          (else
           (cons (car elems) (build-list (cdr elems) (+ 1 index) elem1 elem2)))))
  (build-list elems 0 (list-ref elems index1) (list-ref elems index2)))

(define (take-n lst n)
  (if (or (null? lst) (<= n 0))
    '()
    (cons (car lst) (take-n (cdr lst) (- n 1)))))

(define (drop-n lst n)
  (if (or (null? lst) (<= n 0))
    lst
    (drop-n (cdr lst) (- n 1))))