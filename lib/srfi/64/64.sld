;;;============================================================================

;;; File: "64.sld"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 64, A Scheme API for test suites

(define-library (srfi 64)

  (namespace "_test#")

  (export test-assert
          test-equal
          test-eqv
          test-eq
          test-approximate
          test-error
          test-begin
          test-end
          test-group

          %test-predicate
          %test-relation
          %test-approximate
          %test-error
          %test-begin
          %test-end
          %test-group

          %test-expand)

  (import (_test)))

;;;============================================================================
