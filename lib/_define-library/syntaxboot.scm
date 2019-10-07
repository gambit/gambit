;;;============================================================================

;;; File: "syntaxboot.scm"

;;; Copyright (c) 2000-2014 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements an unhygienic version of the (syntax-case ...)
;; and (syntax ...) forms that are used for bootstrapping.

;;;----------------------------------------------------------------------------

(include "syntaxpattern.scm") ;; needed by expansion of syntax-case and syntax forms
(include "syntaxtemplate.scm")
(include "syntaxcommon.scm")

;;;----------------------------------------------------------------------------

(##define-syntax syntax-case
  (lambda (src)
    (##include "syntaxcasexformboot.scm")
    (syn#syntax-case-form-transformer src)))

(##define-syntax syntax
  (lambda (src)
    (##include "syntaxxformboot.scm")
    (syn#syntax-form-transformer src '())))

;;;============================================================================
