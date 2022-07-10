;;;============================================================================

;;; File: "u64vector.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; U64vector operations.

(define-library (u64vector)

  (namespace "##")

  (export

;; gambit

list->u64vector
make-u64vector
subu64vector
subu64vector-fill!
subu64vector-move!
u64vector
u64vector->list
u64vector-append
u64vector-concatenate
u64vector-copy
u64vector-copy!
u64vector-fill!
u64vector-length
u64vector-ref
u64vector-set
u64vector-set!
u64vector-shrink!
u64vector?

))

;;;============================================================================
