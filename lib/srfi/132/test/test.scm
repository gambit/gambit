;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2018-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 132, Sort Libraries

(import (srfi 132))
(import (_test))

;;;============================================================================

(define (random-vector size)
  (let ((v (make-vector size)))
    (fill-vector-randomly! v (* 10 size))
    v))

(define (fill-vector-randomly! v range)
  (let ((half (quotient range 2)))
    (do ((i (- (vector-length v) 1) (- i 1)))
	((< i 0))
      (vector-set! v i (- (random-integer range) half)))))

(define random-seed 0)

(define (random-int n)
  (set! random-seed
    (remainder (+ (* random-seed 3581) 12751) 131072))
  (remainder random-seed n))

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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
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
#;
(let ((vec (vector 0 1)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (vector-separate! < vec 0 0 1 0)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Additional tests written specifically for SRFI 132.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-assert (list-sorted? > '()))

(test-assert (list-sorted? > '(987)))

(test-assert (list-sorted? > '(9 8 7)))

(test-assert (vector-sorted? > '#()))

(test-assert (vector-sorted? > '#(987)))

(test-assert (vector-sorted? > '#(9 8 7 6 5)))

(test-assert (vector-sorted? > '#() 0))

(test-assert (vector-sorted? > '#(987) 1))

(test-assert (vector-sorted? > '#(9 8 7 6 5) 1))

(test-assert (vector-sorted? > '#() 0 0))

(test-assert (vector-sorted? > '#(987) 1 1))

(test-assert (vector-sorted? > '#(9 8 7 6 5) 1 2))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal (list-sort > (list))
            '())

(test-equal (list-sort > (list 987))
            '(987))

(test-equal (list-sort > (list 987 654))
            '(987 654))

(test-equal (list-sort > (list 9 8 6 3 0 4 2 5 7 1))
            '(9 8 7 6 5 4 3 2 1 0))

(test-equal (list-stable-sort > (list))
            '())

(test-equal (list-stable-sort > (list 987))
            '(987))

(test-equal (list-stable-sort > (list 987 654))
            '(987 654))

(test-equal (list-stable-sort > (list 9 8 6 3 0 4 2 5 7 1))
            '(9 8 7 6 5 4 3 2 1 0))

(test-equal (list-stable-sort (lambda (x y)
                                 (> (quotient x 2)
                                    (quotient y 2)))
                               (list 9 8 6 3 0 4 2 5 7 1))
            '(9 8 6 7 4 5 3 2 0 1))

(test-equal (let ((v (vector)))
              (vector-sort > v))
            '#())

(test-equal (let ((v (vector 987)))
              (vector-sort > (vector 987)))
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-sort > v))
            '#(987 654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-sort > v))
            '#(9 8 7 6 5 4 3 2 1 0))

(test-equal (let ((v (vector)))
              (vector-stable-sort > v))
            '#())

(test-equal (let ((v (vector 987)))
              (vector-stable-sort > (vector 987)))
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-stable-sort > v))
            '#(987 654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort > v))
            '#(9 8 7 6 5 4 3 2 1 0))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort (lambda (x y)
                                     (> (quotient x 2)
                                        (quotient y 2)))
                                   v))
            '#(9 8 6 7 4 5 3 2 0 1))

(test-equal (let ((v (vector)))
              (vector-sort > v 0))
            '#())

(test-equal (let ((v (vector 987)))
              (vector-sort > (vector 987) 1))
            '#())

(test-equal (let ((v (vector 987 654)))
              (vector-sort > v 1))
            '#(654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-sort > v 3))
            '#(7 5 4 3 2 1 0))

(test-equal (let ((v (vector)))
              (vector-stable-sort > v 0))
            '#())

(test-equal (let ((v (vector 987)))
              (vector-stable-sort > (vector 987) 1))
            '#())

(test-equal (let ((v (vector 987 654)))
              (vector-stable-sort < v 0 2))
            '#(654 987))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort > v 3))
            '#(7 5 4 3 2 1 0))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort (lambda (x y)
                                     (> (quotient x 2)
                                        (quotient y 2)))
                                   v
                                   3))
            '#(7 4 5 3 2 0 1))

(test-equal (let ((v (vector)))
              (vector-sort > v 0 0))
            '#())

(test-equal (let ((v (vector 987)))
              (vector-sort > (vector 987) 1 1))
            '#())

(test-equal (let ((v (vector 987 654)))
              (vector-sort > v 1 2))
            '#(654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-sort > v 4 8))
            '#(5 4 2 0))

(test-equal (let ((v (vector)))
              (vector-stable-sort > v 0 0))
            '#())

(test-equal (let ((v (vector 987)))
              (vector-stable-sort > (vector 987) 1 1))
            '#())

(test-equal (let ((v (vector 987 654)))
              (vector-stable-sort > v 1 2))
            '#(654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort > v 2 6))
            '#(6 4 3 0))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort (lambda (x y)
                                     (> (quotient x 2)
                                        (quotient y 2)))
                                   v
                                   1
                                   8))
            '#(8 6 4 5 3 2 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal (list-sort! > (list))
            '())

(test-equal (list-sort! > (list 987))
            '(987))

(test-equal (list-sort! > (list 987 654))
            '(987 654))

(test-equal (list-sort! > (list 9 8 6 3 0 4 2 5 7 1))
            '(9 8 7 6 5 4 3 2 1 0))

(test-equal (list-stable-sort! > (list))
            '())

(test-equal (list-stable-sort! > (list 987))
            '(987))

(test-equal (list-stable-sort! > (list 987 654))
            '(987 654))

(test-equal (list-stable-sort! > (list 9 8 6 3 0 4 2 5 7 1))
            '(9 8 7 6 5 4 3 2 1 0))

(test-equal (list-stable-sort! (lambda (x y)
                                 (> (quotient x 2)
                                    (quotient y 2)))
                               (list 9 8 6 3 0 4 2 5 7 1))
            '(9 8 6 7 4 5 3 2 0 1))

(test-equal (let ((v (vector)))
              (vector-sort! > v)
              v)
            '#())

(test-equal (let ((v (vector 987)))
              (vector-sort! > (vector 987))
              v)
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-sort! > v)
              v)
            '#(987 654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-sort! > v)
              v)
            '#(9 8 7 6 5 4 3 2 1 0))

(test-equal (let ((v (vector)))
              (vector-stable-sort! > v)
              v)
            '#())

(test-equal (let ((v (vector 987)))
              (vector-stable-sort! > (vector 987))
              v)
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-stable-sort! > v)
              v)
            '#(987 654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort! > v)
              v)
            '#(9 8 7 6 5 4 3 2 1 0))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort! (lambda (x y)
                                     (> (quotient x 2)
                                        (quotient y 2)))
                                   v)
              v)
            '#(9 8 6 7 4 5 3 2 0 1))

(test-equal (let ((v (vector)))
              (vector-sort! > v 0)
              v)
            '#())

(test-equal (let ((v (vector 987)))
              (vector-sort! > (vector 987) 1)
              v)
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-sort! > v 1)
              v)
            '#(987 654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-sort! > v 3)
              v)
            '#(9 8 6 7 5 4 3 2 1 0))

(test-equal (let ((v (vector)))
              (vector-stable-sort! > v 0)
              v)
            '#())

(test-equal (let ((v (vector 987)))
              (vector-stable-sort! > (vector 987) 1)
              v)
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-stable-sort! < v 0 2)
              v)
            '#(654 987))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort! > v 3)
              v)
            '#(9 8 6 7 5 4 3 2 1 0))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort! (lambda (x y)
                                     (> (quotient x 2)
                                        (quotient y 2)))
                                   v
                                   3)
              v)
            '#(9 8 6 7 4 5 3 2 0 1))

(test-equal (let ((v (vector)))
              (vector-sort! > v 0 0)
              v)
            '#())

(test-equal (let ((v (vector 987)))
              (vector-sort! > (vector 987) 1 1)
              v)
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-sort! > v 1 2)
              v)
            '#(987 654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-sort! > v 4 8)
              v)
            '#(9 8 6 3 5 4 2 0 7 1))

(test-equal (let ((v (vector)))
              (vector-stable-sort! > v 0 0)
              v)
            '#())

(test-equal (let ((v (vector 987)))
              (vector-stable-sort! > (vector 987) 1 1)
              v)
            '#(987))

(test-equal (let ((v (vector 987 654)))
              (vector-stable-sort! > v 1 2)
              v)
            '#(987 654))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort! > v 2 6)
              v)
            '#(9 8 6 4 3 0 2 5 7 1))

(test-equal (let ((v (vector 9 8 6 3 0 4 2 5 7 1)))
              (vector-stable-sort! (lambda (x y)
                                     (> (quotient x 2)
                                        (quotient y 2)))
                                   v
                                   1
                                   8)
              v)
            '#(9 8 6 4 5 3 2 0 7 1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal (list-merge > (list) (list))
            '())

(test-equal (list-merge > (list) (list 9 6 3 0))
            '(9 6 3 0))

(test-equal (list-merge > (list 9 7 5 3 1) (list))
            '(9 7 5 3 1))

(test-equal (list-merge > (list 9 7 5 3 1) (list 9 6 3 0))
            '(9 9 7 6 5 3 3 1 0))

(test-equal (list-merge! > (list) (list))
            '())

(test-equal (list-merge! > (list) (list 9 6 3 0))
            '(9 6 3 0))

(test-equal (list-merge! > (list 9 7 5 3 1) (list))
            '(9 7 5 3 1))

(test-equal (list-merge! > (list 9 7 5 3 1) (list 9 6 3 0))
            '(9 9 7 6 5 3 3 1 0))

(test-equal (vector-merge > (vector) (vector))
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0))
            '#(9 6 3 0))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector))
            '#(9 7 5 3 1))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0))
            '#(9 9 7 6 5 3 3 1 0))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector))
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0))
              v)
            '#( 9  6  3  0 #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector))
              v)
            '#( 9  7  5  3  1 #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0))
              v)
            '#( 9  9  7  6  5  3  3  1  0 #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 0)
              v)
            '#( 9  6  3  0 #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 0)
              v)
            '#( 9  7  5  3  1 #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 0)
              v)
            '#( 9  9  7  6  5  3  3  1  0 #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2)
              v)
            '#(#f #f 9  6  3  0 #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2)
              v)
            '#(#f #f  9  7  5  3  1 #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2)
              v)
            '#(#f #f 9  9  7  6  5  3  3  1  0 #f))

(test-equal (vector-merge > (vector) (vector) 0)
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0) 0)
            '#(9 6 3 0))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector) 2)
            '#(5 3 1))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0) 2)
            '#(9 6 5 3 3 1 0))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2 0)
              v)
            '#(#f #f 9  6  3  0 #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2 2)
              v)
            '#(#f #f 5  3  1 #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2 2)
              v)
            '#(#f #f  9   6  5  3  3  1  0 #f #f #f))

(test-equal (vector-merge > (vector) (vector) 0 0)
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0) 0 0)
            '#(9 6 3 0))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector) 2 5)
            '#(5 3 1))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0) 2 5)
            '#(9 6 5 3 3 1 0))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2 0 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2 0 0)
              v)
            '#(#f #f 9  6  3  0 #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2 2 5)
              v)
            '#(#f #f 5  3  1 #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2 2 5)
              v)
            '#(#f #f  9  6  5  3  3  1  0 #f #f #f))

;;; Some tests are duplicated to make the pattern easier to discern.

(test-equal (vector-merge > (vector) (vector) 0 0)
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0) 0 0)
            '#(9 6 3 0))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector) 2 4)
            '#(5 3))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0) 2 4)
            '#(9 6 5 3 3 0))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2 0 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2 0 0)
              v)
            '#(#f #f 9  6  3  0 #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2 2 4)
              v)
            '#(#f #f 5  3 #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2 2 4)
              v)
            '#(#f #f  9  6  5  3  3  0 #f #f #f #f))

(test-equal (vector-merge > (vector) (vector) 0 0 0)
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0) 0 0 0)
            '#(9 6 3 0))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector) 2 4 0)
            '#(5 3))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0) 2 4 0)
            '#(9 6 5 3 3 0))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2 0 0 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2 0 0 0)
              v)
            '#(#f #f  9  6  3  0 #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2 2 4 0)
              v)
            '#(#f #f  5  3 #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2 2 4 0)
              v)
            '#(#f #f  9  6  5  3  3  0 #f #f #f #f))

(test-equal (vector-merge > (vector) (vector) 0 0 0)
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0) 0 0 1)
            '#(6 3 0))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector) 2 4 0)
            '#(5 3))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0) 2 4 1)
            '#(6 5 3 3 0))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2 0 0 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2 0 0 1)
              v)
            '#(#f #f  6  3  0 #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2 2 4 0)
              v)
            '#(#f #f  5  3 #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2 2 4 1)
              v)
            '#(#f #f  6  5  3  3  0 #f #f #f #f #f))

(test-equal (vector-merge > (vector) (vector) 0 0 0 0)
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0) 0 0 1 4)
            '#(6 3 0))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector) 2 4 0 0)
            '#(5 3))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0) 2 4 1 4)
            '#(6 5 3 3 0))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2 0 0 0 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2 0 0 1 4)
              v)
            '#(#f #f  6  3  0 #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2 2 4 0 0)
              v)
            '#(#f #f  5  3 #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2 2 4 1 4)
              v)
            '#(#f #f  6  5  3  3  0 #f #f #f #f #f))

(test-equal (vector-merge > (vector) (vector) 0 0 0 0)
            '#())

(test-equal (vector-merge > (vector) (vector 9 6 3 0) 0 0 1 2)
            '#(6))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector) 2 4 0 0)
            '#(5 3))

(test-equal (vector-merge > (vector 9 7 5 3 1) (vector 9 6 3 0) 2 4 1 2)
            '#(6 5 3))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector) 2 0 0 0 0)
              v)
            '#(#f #f #f #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector) (vector 9 6 3 0) 2 0 0 1 2)
              v)
            '#(#f #f  6 #f #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector) 2 2 4 0 0)
              v)
            '#(#f #f  5  3 #f #f #f #f #f #f #f #f))

(test-equal (let ((v (make-vector 12 #f)))
              (vector-merge! > v (vector 9 7 5 3 1) (vector 9 6 3 0) 2 2 4 1 2)
              v)
            '#(#f #f  6  5  3 #f #f #f #f #f #f #f))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal (list-delete-neighbor-dups char=? (list))
            '())

(test-equal (list-delete-neighbor-dups char=? (list #\a))
            '(#\a))

(test-equal (list-delete-neighbor-dups char=? (list #\a #\a #\a #\b #\b #\a))
            '(#\a #\b #\a))

(test-equal (list-delete-neighbor-dups! char=? (list))
            '())

(test-equal (list-delete-neighbor-dups! char=? (list #\a))
            '(#\a))

(test-equal (list-delete-neighbor-dups! char=? (list #\a #\a #\a #\b #\b #\a))
            '(#\a #\b #\a))

(test-equal (let ((v (vector)))
              (vector-delete-neighbor-dups char=? v))
            '#())

(test-equal (let ((v (vector #\a)))
              (vector-delete-neighbor-dups char=? v))
            '#(#\a))

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (vector-delete-neighbor-dups char=? v))
            '#(#\a #\b #\a))

(test-equal (let ((v (vector)))
              (list (vector-delete-neighbor-dups! char=? v) v))
            '(0 #()))

(test-equal (let ((v (vector #\a)))
              (list (vector-delete-neighbor-dups! char=? v) v))
            '(1 #(#\a)))

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (list (vector-delete-neighbor-dups! char=? v) v))
            '(3 #(#\a #\b #\a #\b #\b #\a)))

(test-equal (let ((v (vector)))
              (vector-delete-neighbor-dups char=? v 0))
            '#())

(test-equal (let ((v (vector #\a)))
              (vector-delete-neighbor-dups char=? v 0))
            '#(#\a))

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (vector-delete-neighbor-dups char=? v 0))
            '#(#\a #\b #\a))

(test-equal (let ((v (vector)))
              (list (vector-delete-neighbor-dups! char=? v 0) v))
            '(0 #()))

(test-equal (let ((v (vector #\a)))
              (list (vector-delete-neighbor-dups! char=? v 0) v))
            '(1 #(#\a)))

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (list (vector-delete-neighbor-dups! char=? v 0) v))
            '(3 #(#\a #\b #\a #\b #\b #\a)))

(test-equal (let ((v (vector)))
              (vector-delete-neighbor-dups char=? v 0))
            '#())

(test-equal (let ((v (vector #\a)))
              (vector-delete-neighbor-dups char=? v 1))
            '#())

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (vector-delete-neighbor-dups char=? v 3))
            '#(#\b #\a))

(test-equal (let ((v (vector)))
              (list (vector-delete-neighbor-dups! char=? v 0) v))
            '(0 #()))

(test-equal (let ((v (vector #\a)))
              (list (vector-delete-neighbor-dups! char=? v 1) v))
            '(1 #(#\a)))

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (list (vector-delete-neighbor-dups! char=? v 3) v))
            '(5 #(#\a #\a #\a #\b #\a #\a)))

(test-equal (let ((v (vector)))
              (vector-delete-neighbor-dups char=? v 0 0))
            '#())

(test-equal (let ((v (vector #\a)))
              (vector-delete-neighbor-dups char=? v 1 1))
            '#())

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (vector-delete-neighbor-dups char=? v 3 5))
            '#(#\b))

(test-equal (let ((v (vector)))
              (list (vector-delete-neighbor-dups! char=? v 0 0) v))
            '(0 #()))

(test-equal (let ((v (vector #\a)))
              (list (vector-delete-neighbor-dups! char=? v 0 1) v))
            '(1 #(#\a)))

(test-equal (let ((v (vector #\a)))
              (list (vector-delete-neighbor-dups! char=? v 1 1) v))
            '(1 #(#\a)))

(test-equal (let ((v (vector #\a #\a #\a #\b #\b #\a)))
              (list (vector-delete-neighbor-dups! char=? v 3 5) v))
            '(4 #(#\a #\a #\a #\b #\b #\a)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal (vector-find-median < (vector) "knil")
            "knil")

(test-equal (vector-find-median < (vector 17) "knil")
            17)

(test-equal (vector-find-median < (vector 18 1 12 14 12 5 18 2) "knil")
            12)

(test-equal (vector-find-median < (vector 18 1 11 14 12 5 18 2) "knil")
            23/2)

(test-equal (vector-find-median < (vector 18 1 12 14 12 5 18 2) "knil" list)
            (list 12 12))

(test-equal (vector-find-median < (vector 18 1 11 14 12 5 18 2) "knil" list)
            (list 11 12))

(test-equal (vector-find-median < (vector 7 6 9 3 1 18 15 7 8) "knil")
            7)

(test-equal (vector-find-median < (vector 7 6 9 3 1 18 15 7 8) "knil" list)
            7)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal (let ((v (vector 19)))
              (vector-select! < v 0))
            19)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 0))
            3)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 2))
            9)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 8))
            22)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 9))
            23)

(test-equal (let ((v (vector 19)))
              (vector-select! < v 0 0))
            19)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 0 0))
            3)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 2 0))
            9)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 8 0))
            22)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 9 0))
            23)

(test-equal (let ((v (vector 19)))
              (vector-select! < v 0 0 1))
            19)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 0 0 10))
            3)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 2 0 10))
            9)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 8 0 10))
            22)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 9 0 10))
            23)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 0 4 10))
            3)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 2 4 10))
            13)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 4 4 10))
            21)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 5 4 10))
            23)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 0 4 10))
            3)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 2 4 10))
            13)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 3 4 10))
            13)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 4 4 10))
            21)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 5 4 10))
            23)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 0 4 8))
            9)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 1 4 8))
            13)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 2 4 8))
            13)

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-select! < v 3 4 8))
            21)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal (let ((v (vector)))
              (vector-separate! < v 0)
              (vector-sort < (vector-copy v 0 0)))
            '#())

(test-equal (let ((v (vector 19)))
              (vector-separate! < v 0)
              (vector-sort < (vector-copy v 0 0)))
            '#())

(test-equal (let ((v (vector 19)))
              (vector-separate! < v 1)
              (vector-sort < (vector-copy v 0 1)))
            '#(19))

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 0)
              (vector-sort < (vector-copy v 0 0)))
            '#())

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 3)
              (vector-sort < (vector-copy v 0 3)))
            '#(3 8 9))

(test-equal (let ((v (vector)))
              (vector-separate! < v 0 0)
              (vector-sort < (vector-copy v 0 0)))
            '#())

(test-equal (let ((v (vector 19)))
              (vector-separate! < v 0 0)
              (vector-sort < (vector-copy v 0 0)))
            '#())

(test-equal (let ((v (vector 19)))
              (vector-separate! < v 1 0)
              (vector-sort < (vector-copy v 0 1)))
            '#(19))

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 0 0)
              (vector-sort < (vector-copy v 0 0)))
            '#())

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 3 0)
              (vector-sort < (vector-copy v 0 3)))
            '#(3 8 9))

(test-equal (let ((v (vector 19)))
              (vector-separate! < v 0 1)
              (vector-sort < (vector-copy v 1 1)))
            '#())

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 0 2)
              (vector-sort < (vector-copy v 2 2)))
            '#())

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 3 2)
              (vector-sort < (vector-copy v 2 5)))
            '#(3 9 13))

(test-equal (let ((v (vector)))
              (vector-separate! < v 0 0 0)
              (vector-sort < (vector-copy v 0 0)))
            '#())

(test-equal (let ((v (vector 19)))
              (vector-separate! < v 0 1 1)
              (vector-sort < (vector-copy v 1 1)))
            '#())

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 0 2 8)
              (vector-sort < (vector-copy v 2 2)))
            '#())

(test-equal (let ((v (vector 8 22 19 19 13 9 21 13 3 23)))
              (vector-separate! < v 3 2 8)
              (vector-sort < (vector-copy v 2 5)))
            '#(9 13 13))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;
;;; Sorting routines often have internal boundary cases or
;;; randomness, so it's prudent to run a lot of tests with
;;; different lengths.
;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (all-sorts-okay? m n)
  (if (> m 0)
      (let* ((v (random-vector n))
             (v2 (vector-copy v))
             (lst (vector->list v))
             (ans (vector-sort < v2))
             (med (cond ((= n 0) -97)
                        ((odd? n)
                         (vector-ref ans (quotient n 2)))
                        (else
                         (/ (+ (vector-ref ans (- (quotient n 2) 1))
                               (vector-ref ans (quotient n 2)))
                            2)))))
        (define (dsort vsort!)
          (let ((v2 (vector-copy v)))
            (vsort! < v2)
            v2))
        (and (equal? ans (list->vector (list-sort < lst)))
             (equal? ans (list->vector (list-stable-sort < lst)))
             (equal? ans (list->vector (list-sort! < (list-copy lst))))
             (equal? ans (list->vector (list-stable-sort! < (list-copy lst))))
             (equal? ans (vector-sort < v2))
             (equal? ans (vector-stable-sort < v2))
             (equal? ans (dsort vector-sort!))
             (equal? ans (dsort vector-stable-sort!))
             (equal? med (vector-find-median < v2 -97))
             (equal? v v2)
             (equal? lst (vector->list v))
             (equal? med (vector-find-median! < v2 -97))
             (equal? ans v2)
             (all-sorts-okay? (- m 1) n)))
      #t))

(define (test-all-sorts m n)
  (test-assert (all-sorts-okay? m n)))

(for-each test-all-sorts
          '( 3  5 10 10 10 20 20 10 10 10 10 10  10  10  10  10  10)
          '( 0  1  2  3  4  5 10 20 30 40 50 99 100 101 499 500 501))

;;;============================================================================
