;;;============================================================================

;;; File: "64.sld"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 64, A Scheme API for test suites

(define-library (srfi 64)

  (export test-assert
          test-equal
          test-eqv
          test-eq
          test-approximate
          test-error
          test-error-tail
          test-begin
          test-end
          test-group

          test-all?-set!
          test-quiet?-set!
          test-verbose?-set!

          test-predicate-proc
          test-relation-proc
          test-approximate-proc
          test-error-proc
          test-begin-proc
          test-end-proc
          test-group-proc

          $expand-test$)

  (import (_test)))

;;;============================================================================
