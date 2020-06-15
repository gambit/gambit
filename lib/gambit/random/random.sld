;;;============================================================================

;;; File: "random.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Pseudo-random number generation.

(define-library (random)

  (namespace "")

  (export

make-random-source
random-source?
random-source-state-ref
random-source-state-set!
random-source-randomize!
random-source-pseudo-randomize!
random-source-make-integers
random-source-make-reals
random-source-make-f64vectors
random-source-make-u8vectors
default-random-source
random-integer
random-real
random-u8vector
random-f64vector

)

  (include "random#.scm"))

;;;============================================================================
