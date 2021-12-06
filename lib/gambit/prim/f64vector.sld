;;;============================================================================

;;; File: "f64vector.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; F64vector operations.

(define-library (f64vector)

  (namespace "##")

  (export

;; gambit

list->f64vector
make-f64vector
subf64vector
subf64vector-fill!
subf64vector-move!
f64vector
f64vector->list
f64vector-append
f64vector-concatenate
f64vector-copy
f64vector-copy!
f64vector-fill!
f64vector-length
f64vector-ref
f64vector-set
f64vector-set!
f64vector-shrink!
f64vector?

))

;;;============================================================================
