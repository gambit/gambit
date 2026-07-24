;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _irregex)
(import _test)

(define-syntax test
  (syntax-rules ()
    ((test label expr)
     (test-assert expr))
    ((test label expected expr)
     (test-equal expected expr))))

(include "irregex-utils.scm")

(include "test-irregex-from-gauche.scm")
(include "test-irregex-pcre.scm")
(include "test-irregex-scsh.scm")
(include "test-irregex-utf8.scm")

;;;============================================================================
