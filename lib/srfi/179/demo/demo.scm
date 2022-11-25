#!/usr/bin/env gsi-script

(import (srfi 179))

(define (palindrome? s)   ;; is the string a palindrome, ignoring case?
  (let ((n (string-length s)))
    (or (< n 2)
        (let* ((a   ;; an array accessing the characters of s
                (make-array (make-interval (vector n))
                            (lambda (i) (string-ref s i))))
               (ra  ;; the array in reverse order
                (array-reverse a))
               (half-domain
                (make-interval (vector (quotient n 2)))))
          (array-every
           char-ci=?
           (array-extract a half-domain)      ;; first half of s
           (array-extract ra half-domain))))));; reversed second half of s


(for-each (lambda (s) (pretty-print `((palindrome? ,s) => ,(palindrome? s))))
          '("" "A" "AA" "AB" "ABA" "ABBA" "ABCA" "AManAPlanACanalPanama"))

(print "\nDemo source code:\n\n" (read-file-string (this-source-file)))

;;; This demo is simpler using SRFI 231, which should be used instead of
;;; SRFI 179 for new projects.
