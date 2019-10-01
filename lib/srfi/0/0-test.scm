;;;============================================================================

;;; File: "srfi/0/0-test.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 0, Feature-based conditional expansion construct

(import (srfi 0))
(import (gambit test))

;;;============================================================================

(cond-expand
  (gambit
   (check-true #t))
  (else
   (check-true #f)))

;;;============================================================================
