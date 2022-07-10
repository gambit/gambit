;;;============================================================================

;;; File: "fixnum.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Fixnum operations.

(define-library (fixnum)

  (namespace "##")

  (export

;; gambit

fixnum?
fx*
fx+
fx-
fx<
fx<=
fx=
fx>
fx>=
fxabs
fxand
fxandc1
fxandc2
fxarithmetic-shift
fxarithmetic-shift-left
fxarithmetic-shift-right
fxbit-count
fxbit-set?
fxeqv
fxeven?
fxfirst-set-bit
fxif
fxior
fxlength
fxmax
fxmin
fxmodulo
fxnand
fxnegative?
fxnor
fxnot
fxodd?
fxorc1
fxorc2
fxpositive?
fxquotient
fxremainder
fxsquare
fxwrap*
fxwrap+
fxwrap-
fxwrapabs
fxwraparithmetic-shift
fxwraparithmetic-shift-left
fxwraplogical-shift-right
fxwrapquotient
fxwrapsquare
fxxor
fxzero?

))

;;;============================================================================
