;;==============================================================================

;;; File: "_t-cpu-utils.scm"

;;; Copyright (c) 2018 by Laurent Huberdeau, All Rights Reserved.

;;------------------------------------------------------------------------------

(define (flip pair)
  (cons (cdr pair) (car pair)))

(define (in-range? min max val)
  (and (>= val min) (<= val max)))

(define (index-of elem lst #!optional (=? equal?))
  (let loop ((i 0) (lst lst))
    (cond ((null? lst) #f)
          ((=? elem (car lst)) i)
          (else (loop (+ i 1) (cdr lst))))))

(define (elem? elem elems)
  (if (member elem elems) #t #f))

(define (elem-count elem elems)
  (define (worker lst count)
    (if (null? lst)
      count
      (let ((fst (car lst)))
        (if (equal? fst elem)
          (worker (cdr lst) (+ 1 count))
          (worker (cdr lst) count)))))
  (worker elems 0))

(define (filter pred elems)
  (if (null? elems)
    '()
    (if (pred (car elems))
      (cons (car elems) (filter pred (cdr elems)))
      (filter pred (cdr elems)))))

(define (drop-n lst n)
  (if (or (null? lst) (<= n 0))
    lst
    (drop-n (cdr lst) (- n 1))))

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
