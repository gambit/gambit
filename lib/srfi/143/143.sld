;;;============================================================================

;;; File: "132.sld"

;;; Copyright (c) 2018-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 132, Sort Libraries

(define-library (srfi 143)

  (export
   fx-width 
   fx-greatest
   fx-least
   fxsqrt
   fxneg
   fx=?
   fx<?
   fx<=?
   fx>?
   fx>=?
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
