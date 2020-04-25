;;;============================================================================

;;; File: "u32vector.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; U32vector operations.

(define-library (u32vector)

  (namespace "##")

  (export

;; gambit

append-u32vectors
list->u32vector
make-u32vector
subu32vector
subu32vector-fill!
subu32vector-move!
u32vector
u32vector->list
u32vector-append
u32vector-copy
u32vector-copy!
u32vector-fill!
u32vector-length
u32vector-ref
u32vector-set
u32vector-set!
u32vector-shrink!
u32vector?

))

;;;============================================================================
