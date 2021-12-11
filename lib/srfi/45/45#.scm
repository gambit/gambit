;;;============================================================================

;;; File: "45#.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 45, Primitives for Expressing Iterative Lazy Algorithms

(##namespace ("srfi/45#"

delay
eager
force
lazy

))

(##define-syntax delay
  (syntax-rules ()
    ((_ exp)
     (##delay exp))))

(##define-syntax lazy
  (syntax-rules ()
    ((_ exp)
     (##delay exp))))

;;;============================================================================
