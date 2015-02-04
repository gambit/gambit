;;;============================================================================

;;; File: "_with-syntax-boot.scm"

;;; Copyright (c) 2000-2015 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; This file implements a version of the (syntax ...) form that is
;; used for bootstrapping.

;;;----------------------------------------------------------------------------

(##define-syntax with-syntax
  (lambda (src)
    (include "~~lib/_syntax-boot.scm")
    (syntax-case src ()
      ((_ ((pattern expr1)) expr2)
       #'(syntax-case expr1 ()
           (pattern expr2))))))

;;;============================================================================
