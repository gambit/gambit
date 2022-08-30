;;;============================================================================

;;; File: "python.sld"

;;; Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2021-2022 by Marc-André Bélanger, All Rights Reserved.

;;;============================================================================

;;; Python FFI based on SIX.

(define-library (python)

  (export six.infix)

  (include "python#.scm")
  (begin
    (##include "python.scm")))

;;;============================================================================
