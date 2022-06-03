;;;============================================================================

;;; File: "_base64.sld"

;;; Copyright (c) 2005-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Base64 encoding/decoding.

(define-library (_base64)

  (namespace "")

  (export base64->u8vector
          u8vector->base64)

  (include "_base64.scm"))

;;;============================================================================
