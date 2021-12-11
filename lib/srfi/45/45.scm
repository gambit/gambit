;;;============================================================================

;;; File: "45.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 45, Primitives for Expressing Iterative Lazy Algorithms

(##supply-module srfi/45)

(##namespace ("srfi/45#"))                ;; in srfi/45#
(##include "~~lib/gambit#.scm")           ;; for define, declare, etc

(##include "45#.scm")

;;;============================================================================

(define (eager value)
  (##delay value))

(define (force promise)
  (##force promise))

;;;============================================================================
