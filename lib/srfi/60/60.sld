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
    logand
    bitwise-ior 
    logior
    bitwise-xor
    logxor
    bitwise-not 
    lognot
    bitwise-merge
    bitwise-if
    any-bits-set?
    logtest
      

   ;;; integer properties
    bit-count
    logcount
    integer-length
    first-set-bit
    log2-binary-factors

   ;;; bit within word
    bit-set? 
    logbit?
    copy-bit

   ;;; field of bits
    bit-field
    copy-bit-field
    ; arithmetic-shift (built-in)
    ash
    rotate-bit-field
    reverse-bit-field

   ;;; bit as booleans
    integer->list
    list->integer
    booleans->integer
)

  (include "60.scm"))

;;;============================================================================
