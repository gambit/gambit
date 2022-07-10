;;;============================================================================

;;; File: "r5rs#.scm"

;;; Copyright (c) 2005-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Identifiers bound to syntactic forms and procedures defined by R5RS
;; are mapped to the empty namespace (no prefix).

(##include "r4rs#.scm") ;; most identifier bindings are inherited from R4RS

(##namespace ("" ;; these identifier bindings are new in R5RS

;; special forms
define-syntax
;;let-syntax ;; not implemented
;;letrec-syntax ;; not implemented
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
