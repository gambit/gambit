;;;============================================================================

;;; File: "u16vector.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; U16vector operations.

(define-library (u16vector)

  (namespace "##")

  (export

;; gambit

append-u16vectors
list->u16vector
make-u16vector
subu16vector
subu16vector-fill!
subu16vector-move!
u16vector
u16vector->list
u16vector-append
u16vector-copy
u16vector-copy!
u16vector-fill!
u16vector-length
u16vector-ref
u16vector-set
u16vector-set!
u16vector-shrink!
u16vector?

))

;;;============================================================================
