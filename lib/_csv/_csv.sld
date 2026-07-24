;;;============================================================================

;;; File: "_csv.sld"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; CSV reading/writing.

(define-library (_csv)

  (namespace "")

  (export

read-csv
read-file-csv
csv-string->vector
csv-string->list

write-csv
write-file-csv
->csv-string

)

  (include "_csv.scm"))

;;;============================================================================
