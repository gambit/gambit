;;;============================================================================

;;; File: "_syntax-boot.scm"

;;; Copyright (c) 2000-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements an unhygienic version of the (syntax-case ...)
;; and (syntax ...) forms that are used for bootstrapping.

;;;----------------------------------------------------------------------------

;; needed by expansion of syntax-case and syntax forms
(include "~~lib/_syntax-pattern.scm")
(include "~~lib/_syntax-template.scm")
(include "~~lib/_syntax-common.scm")

;;;----------------------------------------------------------------------------

(##define-syntax syntax-case
  (lambda (src)
    (##include "~~lib/_syntax-case-xform-boot.scm")
    (syn#syntax-case-form-transformer src)))

(##define-syntax syntax
  (lambda (src)
    (##include "~~lib/_syntax-xform-boot.scm")
    (syn#syntax-form-transformer src '())))

;;;============================================================================
