;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 23, Error reporting mechanism

(import (srfi 23))
(import (_test))

;;;============================================================================

(test-error-tail
 wrong-number-of-arguments-exception?
 (error))

(test-error-tail
 error-object?
 (error "panic!"))

(test-error-tail
 error-object?
 (error "panic!" 1))

(test-error-tail
 error-object?
 (error "panic!" 1 2))

;;;============================================================================
