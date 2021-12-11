;;;============================================================================

;;; File: "45.sld"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 45, Primitives for Expressing Iterative Lazy Algorithms

(define-library (srfi 45)

  (export

delay
eager
force
lazy

)

  (include "45#.scm")
  (include "45.scm"))

;;;============================================================================
