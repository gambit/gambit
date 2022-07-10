;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 28, Basic Format Strings

(import (srfi 28))
(import (_test))

;;;============================================================================

(test-equal "Hello, World!"
            (format "Hello, ~a" "World!"))

(test-equal "Error, list is too short: (one \"two\" 3)\n"
            (format "Error, list is too short: ~s~%" '(one "two" 3)))

(test-equal "~a and ~b"
            (format "~~a and ~~b"))

(test-error-tail
 type-exception?
 (format #f))

(test-error-tail
 wrong-number-of-arguments-exception?
 (format))

(test-error-tail
 error-object?
 (format "a=~ " 123))

(test-error-tail
 error-object?
 (format "b=~a"))

(test-error-tail
 error-object?
 (format "c=~s"))

;;;============================================================================
