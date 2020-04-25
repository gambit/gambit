;;;============================================================================

;;; File: "s16vector.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; S16vector operations.

(define-library (s16vector)

  (namespace "##")

  (export

;; gambit

append-s16vectors
list->s16vector
make-s16vector
subs16vector
subs16vector-fill!
subs16vector-move!
s16vector
s16vector->list
s16vector-append
s16vector-copy
s16vector-copy!
s16vector-fill!
s16vector-length
s16vector-ref
s16vector-set
s16vector-set!
s16vector-shrink!
s16vector?

))

;;;============================================================================
