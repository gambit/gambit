;;;============================================================================

;;; File: "s8vector.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; S8vector operations.

(define-library (s8vector)

  (namespace "##")

  (export

;; gambit

list->s8vector
make-s8vector
subs8vector
subs8vector-fill!
subs8vector-move!
s8vector
s8vector->list
s8vector-append
s8vector-concatenate
s8vector-copy
s8vector-copy!
s8vector-fill!
s8vector-length
s8vector-ref
s8vector-set
s8vector-set!
s8vector-shrink!
s8vector?

))

;;;============================================================================
