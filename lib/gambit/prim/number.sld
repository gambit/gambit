;;;============================================================================

;;; File: "number.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Numeric operations.

(define-library (number)

  (namespace "##")

  (export

;; r4rs

*
+
-
/
<
<=
=
>
>=
abs
acos
angle
asin
atan
ceiling
complex?
cos
denominator
even?
exact->inexact
exact?
exp
expt
floor
gcd
imag-part
inexact->exact
inexact?
integer?
lcm
log
magnitude
make-polar
make-rectangular
max
min
modulo
negative?
number->string
number?
numerator
odd?
positive?
quotient
rational?
rationalize
real-part
real?
remainder
round
sin
sqrt
string->number
tan
truncate
zero?

;; r7rs

exact
exact-integer-sqrt
exact-integer?
finite?
floor-quotient
floor-remainder
floor/
inexact
infinite?
nan?
square
truncate-quotient
truncate-remainder
truncate/

;; gambit

acosh
all-bits-set?
any-bits-set?
arithmetic-shift
asinh
atanh
bit-count
bit-set?
bitwise-and
bitwise-andc1
bitwise-andc2
bitwise-eqv
bitwise-ior
bitwise-merge
bitwise-nand
bitwise-nor
bitwise-not
bitwise-orc1
bitwise-orc2
bitwise-xor
clear-bit-field
conjugate
copy-bit-field
cosh
;;UNIMPLEMENTED default-random-source
extract-bit-field
first-bit-set
integer-length
integer-nth-root
integer-sqrt
;;UNIMPLEMENTED make-random-source
;;UNIMPLEMENTED random-f64vector
;;UNIMPLEMENTED random-integer
;;UNIMPLEMENTED random-real
;;UNIMPLEMENTED random-source-make-f64vectors
;;UNIMPLEMENTED random-source-make-integers
;;UNIMPLEMENTED random-source-make-reals
;;UNIMPLEMENTED random-source-make-u8vectors
;;UNIMPLEMENTED random-source-pseudo-randomize!
;;UNIMPLEMENTED random-source-randomize!
;;UNIMPLEMENTED random-source-state-ref
;;UNIMPLEMENTED random-source-state-set!
;;UNIMPLEMENTED random-source?
;;UNIMPLEMENTED random-u8vector
replace-bit-field
sinh
tanh
test-bit-field?

))

;;;============================================================================
