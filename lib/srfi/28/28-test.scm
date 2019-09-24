;;============================================================================

;;; File: "srfi/28/28-test.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 28, Basic Format Strings

(import (srfi 28))
(import (gambit test))

;;;============================================================================

(check-equal? (format "Hello, ~a" "World!")
              "Hello, World!")

(check-equal? (format "Error, list is too short: ~s~%" '(one "two" 3))
              "Error, list is too short: (one \"two\" 3)\n")

(check-equal? (format "~~a and ~~b")
              "~a and ~b")

(check-tail-exn
 type-exception?
 (lambda () (format #f)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (format)))

(check-tail-exn
 error-object?
 (lambda () (format "a=~ " 123)))

(check-tail-exn
 error-object?
 (lambda () (format "b=~a")))

(check-tail-exn
 error-object?
 (lambda () (format "c=~s")))

;;;============================================================================
