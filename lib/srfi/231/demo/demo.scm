(import (srfi 231))

;;; Examples from https://srfi.schemers.org/srfi-231/srfi-231.html

(display
 "
This demo has a simple program for determining whether
a string is a palindrome (ignoring case).

Try the other demos:
demo2: Conway's Game of Life.
demo3: Matrix operations, Gaussian elimination
demo4: Image processing, wavelet transform, denoising.
")

;;; Detecting whether a string is a palindrome, ignoring case

(define (palindrome? s)
  (let* ((n
          (string-length s))
         (a    ;; an array accessing the characters of s
          (make-array (make-interval (vector n))
                      (lambda (i)
                        (string-ref s i))))
         (ra   ;; the characters accessed in reverse order
          (array-reverse a))
         (half-domain
          (make-interval (vector (quotient n 2)))))
    ;; If n is 0 or 1 the following extracted arrays
    ;; are empty.
    (array-every
     char-ci=?
     ;; the first half of s
     (array-extract a half-domain)
     ;; the reversed second half of s
     (array-extract ra half-domain))))

(let ((strings '("" "A" "AA" "AB" "ABA" "ABBA" "ABCA" "AManAPlanACanalPanama")))
  (display "\nStrings:\n")
  (pretty-print strings)
  (display "\nPalindrome?:\n")
  (pretty-print (map palindrome? strings)))
