;;;============================================================================

;;; File: "vector.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

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

append-vectors
vector-set
vector-shrink!
subvector
subvector-fill!
subvector-move!
vector-cas!
vector-inc!

))

;;;============================================================================
