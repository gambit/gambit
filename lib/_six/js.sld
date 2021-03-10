;;;============================================================================

;;; File: "js.sld"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; JavaScript FFI based on SIX.

(define-library (js)

  (export six.infix)

  (include "js#.scm")
  (include "js.scm"))

;;;============================================================================
