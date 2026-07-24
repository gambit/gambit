;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2026 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 39, Parameter objects

(import (srfi 39))
(import (srfi 0))
(import (_test))

;;;============================================================================

;; no argument passed to make-parameter

(test-error-tail wrong-number-of-arguments-exception? (make-parameter))

;; one argument passed to make-parameter

(define p1 (make-parameter "abc"))

(test-equal "abc" (p1))

(parameterize ((p1 "def"))
  (test-equal "def" (p1)))

(test-equal "abc" (p1))

(p1 "ghi")

(test-equal "ghi" (p1))

(test-error-tail wrong-number-of-arguments-exception? (p1 11 22))

;; two arguments passed to make-parameter

(define p2 (make-parameter 123
                           (lambda (x) (if (number? x) (- x) 0))))

(test-equal -123 (p2))

(parameterize ((p2 #f))
  (test-equal 0 (p2)))

(test-equal -123 (p2))

(p2 -13)

(test-equal 13 (p2))

(test-error-tail wrong-number-of-arguments-exception? (p2 11 22))

(test-error-tail type-exception? (make-parameter 11 22))

(cond-expand
  (gambit
   ;; Gambit specific test. The third parameter can be a get-filter procedure

   ;; three arguments passed to make-parameter

   (test-error-tail wrong-number-of-arguments-exception? (make-parameter 11 list 33 44))

   (define p3 (make-parameter 123
                              (lambda (x) (if (number? x) (- x) 0))
                              (lambda (x) (list x))))

   (test-equal '(-123) (p3))

   (parameterize ((p3 #f))
     (test-equal '(0) (p3)))

   (test-equal '(-123) (p3))

   (p3 -13)

   (test-equal '(13) (p3))

   (test-error-tail wrong-number-of-arguments-exception? (p3 11 22))

   (test-error-tail type-exception? (make-parameter 11 list 33))))

(test-error-tail wrong-number-of-arguments-exception? (make-parameter 11 list list 44))

;;;============================================================================
