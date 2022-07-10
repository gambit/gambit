;;;============================================================================

;;; File: "14.sld"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 14, Character-set Library

(define-library (srfi 14)

  (export

char-set? char-set= char-set<=

char-set-hash

char-set-cursor char-set-ref char-set-cursor-next end-of-char-set?
char-set-fold char-set-unfold char-set-unfold!
char-set-for-each char-set-map

char-set-copy char-set

list->char-set  string->char-set
list->char-set! string->char-set!

char-set-filter  ucs-range->char-set
char-set-filter! ucs-range->char-set!

->char-set

char-set->list  char-set->string

char-set-size char-set-count char-set-contains?

char-set-every char-set-any

char-set-adjoin  char-set-delete
char-set-adjoin! char-set-delete!

char-set-complement  char-set-union  char-set-intersection
char-set-complement! char-set-union! char-set-intersection!

char-set-difference  char-set-xor  char-set-diff+intersection
char-set-difference! char-set-xor! char-set-diff+intersection!

char-set:lower-case	char-set:upper-case	char-set:title-case
char-set:letter		char-set:digit		char-set:letter+digit
char-set:graphic	char-set:printing	char-set:whitespace
char-set:iso-control	char-set:punctuation	char-set:symbol
char-set:hex-digit	char-set:blank		char-set:ascii
char-set:empty		char-set:full

)

  (include "14.scm"))

;;;============================================================================
