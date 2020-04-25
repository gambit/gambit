;;;============================================================================

;;; File: "f32vector.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; F32vector operations.

(define-library (f32vector)

  (namespace "##")

  (export

;; gambit

append-f32vectors
list->f32vector
make-f32vector
subf32vector
subf32vector-fill!
subf32vector-move!
f32vector
f32vector->list
f32vector-append
f32vector-copy
f32vector-copy!
f32vector-fill!
f32vector-length
f32vector-ref
f32vector-set
f32vector-set!
f32vector-shrink!
f32vector?

))

;;;============================================================================
