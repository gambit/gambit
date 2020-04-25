;;;============================================================================

;;; File: "u8vector.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; U8vector operations.

(define-library (u8vector)

  (namespace "##")

  (export

;; gambit

append-u8vectors
list->u8vector
make-u8vector
subu8vector
subu8vector-fill!
subu8vector-move!
u8vector
u8vector->list
u8vector-append
u8vector-copy
u8vector-copy!
u8vector-fill!
u8vector-length
u8vector-ref
u8vector-set
u8vector-set!
u8vector-shrink!
u8vector?

))

;;;============================================================================
