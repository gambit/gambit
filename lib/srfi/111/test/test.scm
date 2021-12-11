;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 111, Boxes

(import (srfi 111))
(import (_test))

;;;============================================================================

(define b (box (+ 1 2)))

(test-equal #t (box? b))
(test-equal #f (box? #f))
(test-equal #f (box? "hello"))
(test-equal #f (box? '(1)))
(test-equal #f (box? '#(1)))

(test-equal #f (pair? b))
(test-equal #f (vector? b))

(test-equal 3 (unbox b))

(set-box! b (+ 3 4))

(test-equal 7 (unbox b))

;;;============================================================================
