;;;============================================================================

;;; File: "60.sld"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 60, Integers as Bits

(define-library (srfi 60)
  (namespace "")
  (export
   ;;; bitwise ops
    bitwise-and
    bitwise-ior 
    bitwise-xor
    bitwise-not 
    bitwise-merge
    any-bits-set?

   ;;; integer properties
    bit-count
    integer-length
    first-set-bit

   ;;; bit within word
    bit-set? 
    copy-bit

   ;;; field of bits
    bit-field
    copy-bit-field
    ; arithmetic-shift (built-in)
    rotate-bit-field
    reverse-bit-field

   ;;; bit as booleans
    integer->list
    list->integer
    booleans->integer
)

  (include "60.scm"))

;;;============================================================================
