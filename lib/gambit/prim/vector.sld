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
vector-empty?
vector-unfold
vector-unfold!
vector-unfold-right
vector-unfold-right!
vector-reverse-copy!
vector-reverse-copy
binary-vector=
vector=
vector-fold
vector-map!
vector-coutn
vector-index
vector-index-right
vector-skip
vector-skip-right
vector-binary-search
vector-any
vector-every
vector-swap!
vector-reverse!
reverse-vector->list
reverse-list->vector
vector-cumulate
vector-partition

))

;;;============================================================================
