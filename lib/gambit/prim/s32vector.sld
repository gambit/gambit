;;;============================================================================

;;; File: "s32vector.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; S32vector operations.

(define-library (s32vector)

  (namespace "##")

  (export

;; gambit

list->s32vector
make-s32vector
subs32vector
subs32vector-fill!
subs32vector-move!
s32vector
s32vector->list
s32vector-append
s32vector-concatenate
s32vector-copy
s32vector-copy!
s32vector-fill!
s32vector-length
s32vector-ref
s32vector-set
s32vector-set!
s32vector-shrink!
s32vector?

))

;;;============================================================================
