;;;============================================================================

;;; File: "r6rs#.scm"

;;; Copyright (c) 2026 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Identifiers bound to syntactic forms and procedures defined by R6RS
;; are mapped to the empty namespace (no prefix).

(##include "r5rs#.scm") ;; most identifier bindings are inherited from R5RS

(##namespace ("" ;; these identifier bindings are new in R6RS

;; special forms
with-syntax

;; procedures
bound-identifier=?
free-identifier=?
identifier?

))

;;;============================================================================
