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

(define (elem-count elem elems)
  (define (worker lst count)
    (if (null? lst)
      count
      (let ((fst (car lst)))
        (if (equal? fst elem)
          (worker (cdr lst) (+ 1 count))
          (worker (cdr lst) count)))))
  (worker elems 0))

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

(define (drop-first elem lst)
  (if (null? lst)
    lst
    (let ((fst (car lst)))
      (if (equal? elem fst)
        (cdr lst)
        (cons fst (drop-first elem (cdr lst)))))))

(define (flip pair) (cons (cdr pair) (car pair)))

(define (sort-list l <?)
  (define (mergesort l)

    (define (merge l1 l2)
      (cond ((null? l1) l2)
            ((null? l2) l1)
            (else
             (let ((e1 (car l1)) (e2 (car l2)))
               (if (<? e1 e2)
                 (cons e1 (merge (cdr l1) l2))
                 (cons e2 (merge l1 (cdr l2))))))))

    (define (split l)
      (if (or (null? l) (null? (cdr l)))
        l
        (cons (car l) (split (cddr l)))))

    (if (or (null? l) (null? (cdr l)))
      l
      (let* ((l1 (mergesort (split l)))
             (l2 (mergesort (split (cdr l)))))
        (merge l1 l2))))

  (mergesort l))


(define (safe-car pair) (if (pair? pair) (car pair) #f))
(define (safe-cdr pair) (if (pair? pair) (cdr pair) #f))