;;;============================================================================

;;; File: "27.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 27, Sources of Random Bits

(define-library (srfi 27)

  (namespace "")

  (export

;; these bindings are reexported from the Gambit runtime library
random-integer
random-real
default-random-source
make-random-source
random-source?
random-source-state-ref
random-source-state-set!
random-source-randomize!
random-source-pseudo-randomize!
random-source-make-integers
random-source-make-reals

)

  (include "27.scm"))

;;;============================================================================
