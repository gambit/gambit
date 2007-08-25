;;;============================================================================

;;; File: "r5rs#.scm", Time-stamp: <2007-04-04 11:32:06 feeley>

;;; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Identifiers bound to syntactic forms and procedures defined by R5RS
;; are mapped to the empty namespace (no prefix).

(##include "~~/lib/r4rs#.scm") ;; most identifier bindings are inherited from R4RS

(##namespace ("" ;; these identifier bindings are new in R5RS

;; special forms
define-syntax
let-syntax
letrec-syntax
syntax-rules

;; procedures
call-with-values
dynamic-wind
eval
interaction-environment
null-environment
scheme-report-environment
values

))

;;;============================================================================
