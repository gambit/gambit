;;;============================================================================

;;; File: "header.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "gambit#.scm")
(##namespace ("" cond-expand)) ;; TODO: remove after bootstrap
(##include "_gambit#.scm")

(##declare
  (multilisp)
  (extended-bindings)
  (not safe)
  (block)
;;  (fixnum)
  (inlining-limit 134)
  (not run-time-bindings)
)

;;;============================================================================
