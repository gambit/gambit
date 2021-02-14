;;;============================================================================

;;; File: "60#.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 60, Integers as Bits

(##namespace ("srfi/60#"
   ;bitwise-and       ; built-in
    logand

   ;bitwise-ior       ; built-in
    logior

   ;bitwise-xor       ; built-in
    logxor

   ;bitwise-not       ; built-in
    lognot

    bitwise-merge
    bitwise-if

   ;any-bits-set?     ; built-in
    logtest

   ;bit-count         ; built-in
    logcount

    integer-length    ; built-in

    first-set-bit     ; built-in (first-bit-set)
    log2-binary-factors

    bit-set?          ; built-in
    logbit?

   ;##copy-bit
    copy-bit

    bit-field

    copy-bit-field    

   ;arithmetic-shift  ; built-in
    ash

   ;##rotate-bit-field
    rotate-bit-field

    reverse-bit-field

    integer->list

   ;##list->integer
    list->integer

   ;##booleans->integer
    booleans->integer
))

;;;============================================================================
