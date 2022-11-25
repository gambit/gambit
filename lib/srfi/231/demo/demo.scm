#!/usr/bin/env gsi-script

(import (srfi 231))

(define (palindrome? s) ;;; is the string s a palindrome, ignoring case
  (let* ((n
          (string-length s))
         (a    ;; an array accessing the characters of s
          (make-array (make-interval (vector n))
                      (lambda (i) (string-ref s i))))
         (ra   ;; the characters accessed in reverse order
          (array-reverse a))
         (half-domain
          (make-interval (vector (quotient n 2)))))
    ;; when n is 0 or 1 the following extracted arrays are empty
    (array-every char-ci=?
                 (array-extract a half-domain)    ;; first half of s
                 (array-extract ra half-domain))));; reversed second half of s

(for-each (lambda (s) (pretty-print `((palindrome? ,s) => ,(palindrome? s))))
          '("" "A" "AA" "AB" "ABA" "ABBA" "ABCA" "AManAPlanACanalPanama"))

(print "\nDemo source code:\n\n" (read-file-string (this-source-file)))

;; Other demos: demo2 -- Conway's Game of Life.
;;              demo3 -- Matrix operations, Gaussian elimination
;;              demo4 -- Image processing, wavelet transform, denoising.
