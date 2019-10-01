;;;============================================================================

;;; File: "srfi/23/23-test.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 23, Error reporting mechanism

(import (srfi 23))
(import (gambit test))

;;;============================================================================

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (error)))

(check-tail-exn
 error-object?
 (lambda () (error "panic!")))

(check-tail-exn
 error-object?
 (lambda () (error "panic!" 1)))

(check-tail-exn
 error-object?
 (lambda () (error "panic!" 1 2)))

;;;============================================================================
