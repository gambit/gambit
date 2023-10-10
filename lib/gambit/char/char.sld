;;;============================================================================

;;; File: "char.sld"

;;; Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Character operations.

(define-library (char)

  (namespace "")

  (export

char->integer
char-alphabetic?
char-ci<=?
char-ci<?
char-ci=?
char-ci>=?
char-ci>?
char-downcase
char-foldcase
char-lower-case?
char-numeric?
char-upcase
char-upper-case?
char-whitespace?
char<=?
char<?
char=?
char>=?
char>?
char?
digit-value
integer->char

->char-set
char-set
char-set->list
char-set->string
char-set-adjoin
char-set-adjoin!
char-set-any
char-set-complement
char-set-complement!
char-set-contains?
char-set-copy
char-set-count
char-set-cursor
char-set-cursor-next
char-set-delete
char-set-delete!
char-set-diff+intersection
char-set-diff+intersection!
char-set-difference
char-set-difference!
char-set-every
char-set-filter
char-set-filter!
char-set-fold
char-set-for-each
char-set-hash
char-set-intersection
char-set-intersection!
char-set-map
char-set-ref
char-set-size
char-set-unfold
char-set-unfold!
char-set-union
char-set-union!
char-set-xor
char-set-xor!
char-set<=
char-set=
char-set?
end-of-char-set?
list->char-set
list->char-set!
string->char-set
string->char-set!
ucs-range->char-set
ucs-range->char-set!

char-set:ascii
char-set:blank
char-set:digit
char-set:empty
char-set:full
char-set:graphic
char-set:hex-digit
char-set:iso-control
char-set:letter
char-set:letter+digit
char-set:lower-case
char-set:printing
char-set:punctuation
char-set:symbol
char-set:title-case
char-set:upper-case
char-set:whitespace

))

;;;============================================================================
