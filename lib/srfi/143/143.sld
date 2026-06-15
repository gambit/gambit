;;;============================================================================

;;; File: "132.sld"

;;; Copyright (c) 2018-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 132, Sort Libraries

(define-library (srfi 143)
  (export
   fx-width 
   fx-greatest
   fxquotient
   fx-least
   fxneg
   fixnum?
   fx=?
   fx<?
   fx<=?
   fx>?
   fx>=?
   fxzero?
   fxpositive?
   fxnegative?
   fxodd?
   fxeven?
   fxmax
   fxmin
   fxremainder
   fxabs
   fxsquare
   fxsqrt   
   fxnot
   fxand
   fxior
   fxxor
   fxarithmetic-shift
   fxarithmetic-shift-left
   fxbit-count
   fxlength
   fxif
   fxbit-set?
   fxfirst-set-bit
   fxbit-field
   fx+/carry
   fx-/carry
   fx*/carry
   fx+
   fx-
   fx*
   fxbit-field-reverse
   fxbit-field-rotate
   fxarithmetic-shift-right
   fxcopy-bit
    )
(include "143.scm"))

;;;============================================================================
