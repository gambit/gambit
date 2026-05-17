;;;============================================================================

;;; File: "vector.sld"

;;; Copyright (c) 1994-2026 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Vector operations.

(define-library (vector)

  (namespace "##")

  (export

;; r4rs

list->vector
make-vector
vector
vector->list
vector-fill!
vector-length
vector-ref
vector-set!
vector?

;; r7rs

vector-append
vector-copy
vector-copy!
;;UNIMPLEMENTED vector-for-each
;;UNIMPLEMENTED vector-map

;; gambit

subvector
subvector-fill!
subvector-move!
vector-cas!
vector-concatenate
vector-set
vector-shrink!
vector-sort
vector-sort!

;;UNIMPLEMENTED vector-inc!

))

;;;============================================================================
