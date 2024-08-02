;;;============================================================================

;;; File: "_json.sld"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; JSON encoding/decoding.

(define-library (_json)

  (namespace "")

  (export

object->json-string
json-string->object

write-json

)

  (include "_json.scm"))

;;;============================================================================
