;;;============================================================================

;;; File: "_json.sld"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; JSON encoding/decoding.

(define-library (_json)

  (namespace "")

  (export

read-json
read-file-json
json-string->object

write-json
write-file-json
object->json-string

)

  (include "_json.scm"))

;;;============================================================================
