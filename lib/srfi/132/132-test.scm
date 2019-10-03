;;============================================================================

;;; File: "srfi/132/132-test.scm"

;;; Copyright (c) 2018-2019 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 132, Sort Libraries

(import (srfi 132))
(import (gambit test))

(##include "vr7rs.scm")
(##include "vqsort3.scm")


;;; r7rs-vector-copy

(let ((vec '#(0 1 2 3 4)))
  (check-equal? (r7rs-vector-copy vec 0 3) '#(0 1 2))
  (check-equal? vec '#(0 1 2 3 4)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (r7rs-vector-copy)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (r7rs-vector-copy '#(0 1) 0 0 0)))

;;; r7rs-vector-copy!
(let ((vec1 '#(1 2 3 4))
      (vec2 '#(0 0 0 0)))
  (r7rs-vector-copy! vec2 0 vec1)
  (check-equal? vec1 '#(1 2 3 4)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (r7rs-vector-copy! '#(0 1) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (r7rs-vector-copy! '#(0 1) 0 '#(0 1) 0 0 0)))

;;; r7rs-vector-fill!

(let ((vecfrom-r7rs-vector-fill! '#(1 2 3 4)))
  (r7rs-vector-fill! vecfrom-r7rs-vector-fill! 0 0 2)
  (check-equal? vecfrom-r7rs-vector-fill! '#(0 0 3 4)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (r7rs-vector-fill! '#(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (r7rs-vector-fill! '#(0 1) 0 0 0 0)))

;;; list-sorted?

(check-true (list-sorted? < '(0 1 2)))
(check-false (list-sorted? < '(2 1 0)))
(check-true (list-sorted? > '(2 1 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-sorted? <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-sorted? < '(0 1) 0)))

;;; vector-sorted?

(check-true (vector-sorted? < '#(0 1 2)))
(check-false (vector-sorted? < '#(2 1 0)))
(check-true (vector-sorted? > '#(2 1 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-sorted? <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-sorted? < '#(0 1) 0 0 0)))


;;; list-sort

(let ((lst '(3 2 1)))
  (check-equal? (list-sort < lst) '(1 2 3))
  (check-equal? lst '(3 2 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-sort <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-sort < '(0 1) 0)))


;;; list-stable-sort

(let ((lst '((3 . 0) (1 . 0) (1 . 1) (2 . 0) ))
      (gt (lambda (a b)
            (if (< (car a) (car b))
                #t
                #f))))
  (check-equal? (list-stable-sort gt lst)
                '((1 . 0) (1 . 1) (2 . 0) (3 . 0)))
  (check-equal? lst '((3 . 0) (1 . 0) (1 . 1) (2 . 0))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-stable-sort <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-stable-sort < '(0 1) 0)))


;;; list-sort!

(check-equal? (list-sort! < '(3 2 1 4)) '(1 2 3 4))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-sort! <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-sort! < '(0 1) 0)))


;;; list-stable-sort!

(let ((gt (lambda (a b) (< (car a) (car b)))))
  (check-equal? (list-stable-sort! gt '((3 . 0) (1 . 0) (2 . 0) (1 . 1)))
                '((1 . 0) (1 . 1) (2 . 0) (3 . 0))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-stable-sort! <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-stable-sort! < '(0 1) 0)))


;;; vector-sort

(let ((vec '#(3 2 1)))
  (check-equal? (vector-sort < vec) '#(1 2 3))
  (check-equal? vec '#(3 2 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-sort <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-sort < '(0 1) 0 0 0)))

;;; vector-stable-sort

(let ((vec '#((3 . 0) (1 . 0) (1 . 1) (2 . 0) ))
      (gt (lambda (a b) (< (car a) (car b)))))
  (check-equal? (vector-stable-sort gt vec) '#((1 . 0) (1 . 1) (2 . 0) (3 . 0)))
  (check-equal? vec '#((3 . 0) (1 . 0) (1 . 1) (2 . 0))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-stable-sort <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-stable-sort < '#(0 1) 0 0 0)))


;;; vector-sort!

(let ((vecfrom-vector-sort! '#(3 2 1)))
  (vector-sort! < vecfrom-vector-sort!)
  (check-equal? vecfrom-vector-sort! '#(1 2 3)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-stable-sort <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-stable-sort < '#(0 1) 0 0 0)))

;;; vector-stable-sort!

(let ((vecfrom-vector-stable-sort!  '#((3 . 0) (1 . 0) (2 . 0) (1 . 1)))
      (gt (lambda (a b) (< (car a) (car b)))))
  (vector-stable-sort! gt vecfrom-vector-stable-sort!)
  (check-equal? vecfrom-vector-stable-sort! '#((1 . 0) (1 . 1) (2 . 0) (3 . 0))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-stable-sort! <)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-stable-sort! < '#(0 1) 0 0 '#(0 1) 0)))


;;; list-merge

(let ((lst1from-list-merge '(0 1 2))
      (lst2from-list-merge '(3 4 5)))
  (check-equal? (list-merge < lst1from-list-merge lst2from-list-merge)
                '(0 1 2 3 4 5))
  (check-equal? lst1from-list-merge '(0 1 2))
  (check-equal? lst2from-list-merge '(3 4 5)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-merge < '(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-merge < '(0 1) '(0 1) 0)))


;;; list-merge!

(check-equal? (list-merge! < '(0 1 2) '(3 4 5)) '(0 1 2 3 4 5))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-merge! < '(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-merge! < '(0 1) '(0 1) 0)))


;;; vector-merge

(let ((vec1from-vector-merge '#(0 1 2))
      (vec2from-vector-merge '#(3 4 5)))
  (check-equal? (vector-merge < vec1from-vector-merge vec2from-vector-merge)
                '#(0 1 2 3 4 5))
  (check-equal? vec1from-vector-merge '#(0 1 2))
  (check-equal? vec2from-vector-merge '#(3 4 5)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-merge < '#(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-merge < '#(0 1) '#(0 1) 0 1 0 1 0)))


;;; vector-merge!

(let ((vec '#(0 0 0 0 0 0)))
  (vector-merge! < vec '#(0 1 2) '#(3 4 5))
  (check-equal? vec '#(0 1 2 3 4 5)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-merge! < '#(0 1) '#(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-merge! < '#(0 1) '#(0 1) '#(0 1) 0 0 1 0 1 0)))


;;; list-delete-neighbor-dups

(let ((lstfrom-list-delete-neighbor-dups '(0 1 1 2 2 3)))
  (check-equal? (list-delete-neighbor-dups = lstfrom-list-delete-neighbor-dups)
                '(0 1 2 3))
  (check-equal? lstfrom-list-delete-neighbor-dups '(0 1 1 2 2 3)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-delete-neighbor-dups =)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-delete-neighbor-dups = '(0 1) 0)))


;;; list-delete-neighbor-dups!

(check-equal? (list-delete-neighbor-dups! = '(0 0 1 2 3 3)) '(0 1 2 3))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-delete-neighbor-dups! =)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (list-delete-neighbor-dups! = '(0 1) 0)))

;;; vector-delete-neighbor-dups

(let ((vecfrom-vector-delete-neighbor-dups '#(0 1 1 2 2 3)))
  (check-equal? (vector-delete-neighbor-dups = vecfrom-vector-delete-neighbor-dups)
                '#(0 1 2 3))
  (check-equal? vecfrom-vector-delete-neighbor-dups '#(0 1 1 2 2 3)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-delete-neighbor-dups =)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-delete-neighbor-dups = '#(0 1) 0 0 0)))


;;; vector-delete-neighbor-dups!

(let ((vecfrom-vector-delete-neighbor-dups! '#(0 0 1 2 3 3)))
  (check-equal? (vector-delete-neighbor-dups! = vecfrom-vector-delete-neighbor-dups!) 4)
  (check-equal? vecfrom-vector-delete-neighbor-dups! '#(0 1 2 3 3 3))) ;;; final list contain only 4 space

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-delete-neighbor-dups! =)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-delete-neighbor-dups! = '#(0 1) 0 0 0)))


;;; vector-find-median

(let ((vecfrom-vector-find-median '#(0 3 2 1 24 26 63 61 74 72 ) ))
  (check-equal? (vector-find-median < vecfrom-vector-find-median 0) 25)
  (check-equal? vecfrom-vector-find-median '#(0 3 2 1 24 26 63 61 74 72 )))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-find-median < '#(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-find-median < '#(0 1) 0 0 0)))

;;; vector-find-median!

(check-equal? (vector-find-median! < '#(0 3 2 1 24 26 63 61 74 72 ) 0) 25)
(check-equal? (vector-find-median! < '#( 3 2 24 26 74 72 ) 0) 25)


(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-find-median! < '#(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-find-median! < '#(0 1) 0 0 0)))


;;; vector-select!

(check-equal? (vector-select! < '#(3 4 5 0 2 5) 2) 3)

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-select! < '#(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-select! < '#(0 1) 0 0 1 0)))


;;; vector-separate!

(let ((vecfrom-vector-separate! '#(5 3 1 2 5 2)))
  (vector-separate! < vecfrom-vector-separate! 3)
  (check-equal? vecfrom-vector-separate! '#(1 2 2 5 3 5 )))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-separate! < '#(0 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-separate! < '#(0 1) 0 0 1 0)))


;;; Optional

;;; vector-quick-sort3

(let ((vecfrom-vector-quick-sort3 '#(0 3 2 1)))
  (check-equal? (vector-quick-sort3 - vecfrom-vector-quick-sort3) '#(0 1 2 3))
  (check-equal? vecfrom-vector-quick-sort3 '#(0 3 2 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-quick-sort3 -)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (vector-quick-sort3 - '#(0 1) 0 1 0)))

;;;============================================================================
