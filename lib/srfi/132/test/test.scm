;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2018-2019 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 132, Sort Libraries

(import (srfi 132))
(import (_test))

(##include "../vr7rs.scm")
(##include "../vqsort3.scm")


;;; r7rs-vector-copy

(let ((vec (vector 0 1 2 3 4)))
  (test-equal '#(1 2) (r7rs-vector-copy vec 1 3))
  (test-equal '#(0 1 2 3 4) vec))

(test-error-tail
 wrong-number-of-arguments-exception?
 (r7rs-vector-copy))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (r7rs-vector-copy vec 0 0 0)))

;;; r7rs-vector-copy!

(let ((vec1 (vector 1 2 3 4))
      (vec2 (vector 0 0 0 0)))
  (r7rs-vector-copy! vec2 0 vec1)
  (test-equal '#(1 2 3 4) vec1)
  (test-equal '#(1 2 3 4) vec2))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (r7rs-vector-copy! vec 0)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (r7rs-vector-copy! vec 0 vec 0 0 0)))

;;; r7rs-vector-fill!

(let ((vec (vector 1 2 3 4)))
  (r7rs-vector-fill! vec 0 0 2)
  (test-equal '#(0 0 3 4) vec))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (r7rs-vector-fill! vec)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (r7rs-vector-fill! vec 0 0 0 0)))

;;; list-sorted?

(test-assert (list-sorted? < '(0 1 2)))
(test-assert (not (list-sorted? < '(2 1 0))))
(test-assert (list-sorted? > '(2 1 0)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-sorted? <))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-sorted? < '(0 1) 0))

;;; vector-sorted?

(test-assert (vector-sorted? < '#(0 1 2)))
(test-assert (not (vector-sorted? < '#(2 1 0))))
(test-assert (vector-sorted? > '#(2 1 0)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-sorted? <))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-sorted? < '#(0 1) 0 0 0))


;;; list-sort

(let ((lst '(3 2 1)))
  (test-equal '(1 2 3) (list-sort < lst))
  (test-equal '(3 2 1) lst))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-sort <))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-sort < '(0 1) 0))


;;; list-stable-sort

(let ((lst (list '(3 . 0) '(1 . 0) '(1 . 1) '(2 . 0)))
      (gt (lambda (a b) (< (car a) (car b)))))
  (test-equal '((1 . 0) (1 . 1) (2 . 0) (3 . 0))
              (list-stable-sort gt lst))
  (test-equal '((3 . 0) (1 . 0) (1 . 1) (2 . 0)) lst))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-stable-sort <))

(let ((lst (list 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-stable-sort < lst 0)))


;;; list-sort!

(let ((lst (list 3 2 1 4)))
  (test-equal '(1 2 3 4) (list-sort! < lst)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-sort! <))

(let ((lst (list 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-sort! < lst 0)))


;;; list-stable-sort!

(let ((lst (list '(3 . 0) '(1 . 0) '(2 . 0) '(1 . 1)))
      (gt (lambda (a b) (< (car a) (car b)))))
  (test-equal '((1 . 0) (1 . 1) (2 . 0) (3 . 0))
              (list-stable-sort! gt lst)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-stable-sort! <))

(let ((lst (list 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-stable-sort! < lst 0)))


;;; vector-sort

(let ((vec '#(3 2 1)))
  (test-equal '#(1 2 3) (vector-sort < vec))
  (test-equal '#(3 2 1) vec))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-sort <))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-sort < '(0 1) 0 0 0))

;;; vector-stable-sort

(let ((vec (vector '(3 . 0) '(1 . 0) '(1 . 1) '(2 . 0)))
      (gt (lambda (a b) (< (car a) (car b)))))
  (test-equal '#((1 . 0) (1 . 1) (2 . 0) (3 . 0)) (vector-stable-sort gt vec))
  (test-equal '#((3 . 0) (1 . 0) (1 . 1) (2 . 0)) vec))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-stable-sort <))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-stable-sort < vec 0 0 0)))


;;; vector-sort!

(let ((vec (vector 3 2 1)))
  (vector-sort! < vec)
  (test-equal '#(1 2 3) vec))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-sort! <))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-sort! < vec 0 0 0)))

;;; vector-stable-sort!

(let ((vec (vector '(3 . 0) '(1 . 0) '(2 . 0) '(1 . 1)))
      (gt (lambda (a b) (< (car a) (car b)))))
  (vector-stable-sort! gt vec)
  (test-equal '#((1 . 0) (1 . 1) (2 . 0) (3 . 0)) vec))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-stable-sort! <))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-stable-sort! < vec 0 0 '#(0 1) 0)))


;;; list-merge

(let ((lst1 '(0 1 2))
      (lst2 '(3 4 5)))
  (test-equal '(0 1 2 3 4 5)
              (list-merge < lst1 lst2))
  (test-equal '(0 1 2) lst1)
  (test-equal '(3 4 5) lst2))

(let ((lst '(0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-merge < lst)))

(let ((lst '(0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-merge < lst lst 0)))


;;; list-merge!

(let ((lst1 (list 0 1 2))
      (lst2 (list 3 4 5)))
  (test-equal '(0 1 2 3 4 5) (list-merge! < lst1 lst2)))

(let ((lst (list 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-merge! < lst)))

(let ((lst (list 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-merge! < lst lst 0)))


;;; vector-merge

(let ((vec1 '#(0 1 2))
      (vec2 '#(3 4 5)))
  (test-equal '#(0 1 2 3 4 5)
              (vector-merge < vec1 vec2))
  (test-equal '#(0 1 2) vec1)
  (test-equal '#(3 4 5) vec2))

(let ((vec (vector 0 0)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-merge < vec)))

(let ((vec (vector 0 0)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-merge < vec vec 0 1 0 1 0)))


;;; vector-merge!

(let ((vec (vector 0 0 0 0 0 0)))
  (vector-merge! < vec '#(0 1 2) '#(3 4 5))
  (test-equal '#(0 1 2 3 4 5) vec))

(let ((vec (vector 0 0)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-merge! < vec vec)))

(let ((vec (vector 0 0)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-merge! < vec vec vec 0 0 1 0 1 0)))


;;; list-delete-neighbor-dups

(let ((lst (list 0 1 1 2 2 3)))
  (test-equal '(0 1 2 3)
              (list-delete-neighbor-dups = lst))
  (test-equal '(0 1 1 2 2 3) lst))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-delete-neighbor-dups =))

(let ((lst (list 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-delete-neighbor-dups = lst 0)))


;;; list-delete-neighbor-dups!

(let ((lst (list 0 0 1 2 3 3)))
  (test-equal '(0 1 2 3)
              (list-delete-neighbor-dups! = lst)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (list-delete-neighbor-dups! =))

(let ((lst (list 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (list-delete-neighbor-dups! = lst 0)))

;;; vector-delete-neighbor-dups

(let ((vec (vector 0 1 1 2 2 3)))
  (test-equal '#(0 1 2 3)
              (vector-delete-neighbor-dups = vec))
  (test-equal '#(0 1 1 2 2 3) vec))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-delete-neighbor-dups =))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-delete-neighbor-dups = vec 0 0 0)))


;;; vector-delete-neighbor-dups!

(let ((vec (vector 0 0 1 2 3 3)))
  (test-equal 4 (vector-delete-neighbor-dups! = vec))
  (test-equal '#(0 1 2 3 3 3) vec)) ;;; final list contain only 4 space

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-delete-neighbor-dups! =))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-delete-neighbor-dups! = vec 0 0 0)))


;;; vector-find-median

(let ((vec (vector 3 2 1 24 26 63 61 74 72)))
  (test-equal 26 (vector-find-median < vec 0))
  (test-equal '#(3 2 1 24 26 63 61 74 72) vec))

(let ((vec (vector 0 3 2 1 24 26 63 61 74 72)))
  (test-equal 25 (vector-find-median < vec 0))
  (test-equal '#(0 3 2 1 24 26 63 61 74 72) vec))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-find-median < vec)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-find-median < vec 0 0 0)))

;;; vector-find-median!

(let ((vec (vector 3 2 1 24 26 63 61 74 72)))
  (test-equal 26 (vector-find-median! < vec 0)))

(let ((vec (vector 0 3 2 1 24 26 63 61 74 72)))
  (test-equal 25 (vector-find-median! < vec 0)))

(let ((vec (vector 2 24 26 74 72)))
  (test-equal 26 (vector-find-median! < vec 0)))

(let ((vec (vector 3 2 24 26 74 72)))
  (test-equal 25 (vector-find-median! < vec 0)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-find-median! < vec)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-find-median! < vec 0 0 0)))


;;; vector-select!

(let ((vec (vector 3 4 5 0 2 5)))
  (test-equal 3 (vector-select! < vec 2)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-select! < vec)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-select! < vec 0 0 1 0)))


;;; vector-separate!

(let ((vec (vector 5 3 1 2 5 2)))
  (vector-separate! < vec 3)
  (test-equal '#(1 2 2 5 3 5) vec))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-separate! < vec)))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-separate! < vec 0 0 1 0)))


;;; Optional

;;; vector-quick-sort3

(let ((vec (vector 0 3 2 1)))
  (test-equal '#(0 1 2 3) (vector-quick-sort3 - vec))
  (test-equal '#(0 3 2 1) vec))

(test-error-tail
 wrong-number-of-arguments-exception?
 (vector-quick-sort3 -))

(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-quick-sort3 - vec 0 1 0)))

;;;============================================================================
