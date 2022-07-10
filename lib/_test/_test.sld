;;;============================================================================

;;; File: "_test.sld"

;;; Copyright (c) 2013-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Testing framework.

(define-library (_test)

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

          test-msg

          test-all?-set!
          test-quiet?-set!
          test-verbose?-set!

          %test-predicate
          %test-relation
          %test-approximate
          %test-error
          %test-begin
          %test-end
          %test-group)

  (include "_test#.scm")
  (include "_test.scm"))

;;;============================================================================
