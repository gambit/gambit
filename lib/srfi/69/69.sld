;;;============================================================================

;;; File: "69.sld"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 69, Basic hash tables

(define-library (srfi 69)

  (export

hash
string-hash
string-ci-hash
hash-by-identity
make-hash-table
hash-table?
alist->hash-table
hash-table-equivalence-function
hash-table-hash-function
hash-table-ref
hash-table-ref/default
hash-table-set!
hash-table-delete!
hash-table-exists?
hash-table-update!
hash-table-update!/default
hash-table-size
hash-table-keys
hash-table-values
hash-table-walk
hash-table-fold
hash-table->alist
hash-table-copy
hash-table-merge!

)

  (include "69.scm"))

;;;============================================================================
