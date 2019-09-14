;;;============================================================================

;;; File: "gambit/srfi/132/132.scm"

;;; 2018-2019 by Antoine Doucet.

;;;============================================================================

;;; Sort Libraries (srfi-132).

(##supply-module srfi/132)

(##namespace ("srfi/132#"))
(##include "~~lib/_prim#.scm")                   ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")                 ;; for macro-check-procedure, 
(##include "132#.scm")

(##include "lib/merge.scm")
(##include "lib/delndups.scm")
(##include "lib/select.scm")

(##include "lib/lmsort.scm")
(##include "lib/vhsort.scm")
(##include "lib/visort.scm")
(##include "lib/vmsort.scm")
(##include "lib/vqsort2.scm")
(##include "lib/vqsort3.scm")


;;; Predicate

(define (list-sorted? < list)
  (or (not (pair? list))
      (let lp ((prev (car list)) (tail (cdr list)))
	(or (not (pair? tail))
	    (let ((next (car tail)))
	      (and (not (< next prev))
		   (lp next (cdr tail))))))))

(define (vector-sorted? elt< v #!optional (start 0) (end (vector-length v)))
     (or (>= start end)			
	 (let lp ((i (+ start 1)) (vi-1 (vector-ref v start)))
	   (or (>= i end)
	       (let ((vi (vector-ref v i)))
		 (and (not (elt< vi vi-1))
		      (lp (+ i 1) vi)))))))

;;; General sort preocedures

;;; should convert into vector and use heapsort!
(define (list-sort < l)
    (let ((vec (list->vector l)))
            (vector-heap-sort! < vec)
            (vector->list vec)))

(define (list-stable-sort < lst) (list-merge-sort < lst))
(define (list-sort! < lst) (list-merge-sort! < lst))
(define (list-stable-sort! < lst) (list-merge-sort! < lst))

(define (vector-sort < v #!optional (start 0) (end (vector-length v)))
    (vector-quick-sort < v start end))

(define (vector-stable-sort < v #!optional (start 0)
                                          (end (vector-length v)))
        (vector-merge-sort < v start end))


(define (vector-sort! < v #!optional (start 0) (end (vector-length v)))
    (vector-quick-sort! < v start end))

(define (vector-stable-sort! < v #!optional (start 0)
                                          (end (vector-length v))
                                          (temp (vector-copy v)))
        (vector-merge-sort! < v start end temp))

;;; Merge procedure

(define list-merge %list-merge)
(define list-merge! %list-merge!)
(define vector-merge %vector-merge)
(define vector-merge! %vector-merge!)

;;; Deleting duplicate neighbors

(define list-delete-neighbor-dups %list-delete-neighbor-dups)
(define list-delete-neighbor-dups! %list-delete-neighbor-dups!)
(define vector-delete-neighbor-dups %vector-delete-neighbor-dups)
(define vector-delete-neighbor-dups! %vector-delete-neighbor-dups!)

;;; Finding the median

(define vector-find-median %vector-find-median)
(define vector-find-median! %vector-find-median!)

;;; Selection

(define vector-select! %vector-select!)
(define vector-separate! %vector-separate!)

;;;============================================================================
