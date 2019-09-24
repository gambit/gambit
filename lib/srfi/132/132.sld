;;;============================================================================

;;; File: "srfi/132/132.sld"

;;; Copyright (c) 2018-2019 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 132, Sort Libraries

(define-library (srfi 132)

  (export

list-sorted?
vector-sorted?
list-sort
list-stable-sort
list-sort!
list-stable-sort!
vector-sort
vector-stable-sort
vector-sort!
vector-stable-sort!
list-merge
list-merge!
vector-merge
vector-merge!
list-delete-neighbor-dups
list-delete-neighbor-dups!
vector-delete-neighbor-dups
vector-delete-neighbor-dups!
vector-find-median
vector-find-median!
vector-select!
vector-separate!

)

  (include "132.scm"))

;;;============================================================================
