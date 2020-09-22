;;;============================================================================

;;; File: "133.sld"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 133, Vector library.

(define-library (srfi 133)
  (namespace "")
  (export
    make-vector
    vector
    vector-unfold
    vector-unfold-right
    vector-copy
    vector-reverse-copy
    vector-append
    vector-concatenate

    vector?
    vector-empty?
    vector=

    vector-ref
    vector-length

    vector-fold
    vector-map 
    vector-map!
    vector-for-each
    vector-count

    vector-index
    vector-skip
    vector-index-right
    vector-skip-right
    vector-binary-search
    vector-any
    vector-every 

    vector-set!
    vector-swap!
    vector-fill!
    vector-reverse!
    vector-copy!
    vector-reverse-copy!    

   vector->list
    list->vector
    reverse-list->vector
    reverse-vector->list )

  (include "133.scm"))

;;;============================================================================
