#!/usr/bin/env gsi-script

(import (srfi 231))

;; This demo implements some naive matrix algorithms, including
;; matrix multiplication and Gaussian (LU) decomposition.

;;; Matrix multiply

(define (matrix-multiply a b)
  (array-inner-product a + * b))

;; Gaussian Elimination without pivoting, A = L x U, where L is
;; lower triangular with 1's on the diagonal and U is upper triangular;
;; A is overwritten with the nontrivial elements of  L and U.

(define (LU-decomposition A)
  ;; Assumes the domain of A is [0,n)\\times [0,n)
  ;; and that Gaussian elimination can be applied
  ;; without pivoting.
  (let ((n
         (interval-upper-bound (array-domain A) 0))
        (A_
         (array-getter A)))
    (do ((i 0 (fx+ i 1)))
        ((= i n) A)
      (let* ((pivot
              (A_ i i))
             (column/row-domain
              ;; both will be one-dimensional
              (make-interval (vector (+ i 1))
                             (vector n)))
             (column
              ;; the column below the (i,i) entry
              (specialized-array-share A
                                       column/row-domain
                                       (lambda (k)
                                         (values k i))))
             (row
              ;; the row to the right of the (i,i) entry
              (specialized-array-share A
                                       column/row-domain
                                       (lambda (k)
                                         (values i k))))

             ;; the subarray to the right and
             ;;below the (i,i) entry
             (subarray
              (array-extract
               A (make-interval
                  (vector (fx+ i 1) (fx+ i 1))
                  (vector n         n)))))
        ;; compute multipliers
        (array-assign!
         column
         (array-map (lambda (x)
                      (/ x pivot))
                    column))
        ;; subtract the outer product of i'th
        ;; row and column from the subarray
        (array-assign!
         subarray
         (array-map -
                    subarray
                    (array-outer-product * column row)))))))

;; Functions to extract the lower- and upper-triangular
;; matrices of the LU decomposition of A.

(define (L a)
  (let ((a_ (array-getter a))
        (d  (array-domain a)))
    (make-array
     d
     (lambda (i j)
       (cond ((= i j) 1)        ;; diagonal
             ((> i j) (a_ i j)) ;; below diagonal
             (else 0))))))      ;; above diagonal

(define (U a)
  (let ((a_ (array-getter a))
        (d  (array-domain a)))
    (make-array
     d
     (lambda (i j)
       (cond ((<= i j) (a_ i j)) ;; diagonal and above
             (else 0))))))       ;; below diagonal

;; 8x8 Hilbert matrix:

(define Hilbert
  (array-copy
   (make-array (make-interval '#(8 8))
               (lambda (i j)
                 (/ (+ 1 i j))))))

(display "Hilbert matrix:\n\n")
(pretty-print (array->list* Hilbert))

(LU-decomposition Hilbert)

(display "\nLU-decomposition of the Hilbert matrix:\n\n")
(pretty-print (array->list* Hilbert))

(display "\nLower-triangular factor of Hilbert matrix:\n\n")
(pretty-print (array->list* (L Hilbert)))

(display "\nUpper-triangular factor of Hilbert matrix:\n\n")
(pretty-print (array->list* (U Hilbert)))

(display "\nProduct of lower-triangular and upper triangular factors of Hilbert matrix:\n\n")
(pretty-print (array->list* (matrix-multiply (L Hilbert) (U Hilbert))))

(println "\nDemo source code: " (this-source-file))
