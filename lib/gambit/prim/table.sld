;;;============================================================================

;;; File: "table.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Table operations.

(define-library (table)

  (namespace "##")

  (export

;; gambit

list->table
make-table
table->list
table-copy
table-for-each
table-length
table-merge
table-merge!
table-ref
table-search
table-set!
table?

))

;;;============================================================================
