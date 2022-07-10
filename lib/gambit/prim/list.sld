;;;============================================================================

;;; File: "list.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; List operations.

(define-library (list)

  (namespace "##")

  (export

;; r4rs

append
assoc
assq
assv
caaaar
caaadr
caaar
caadar
caaddr
caadr
caar
cadaar
cadadr
cadar
caddar
cadddr
caddr
cadr
car
cdaaar
cdaadr
cdaar
cdadar
cdaddr
cdadr
cdar
cddaar
cddadr
cddar
cdddar
cddddr
cdddr
cddr
cdr
concatenate
concatenate!
cons
for-each
length
list
list-ref
list-tail
list?
map
member
memq
memv
null?
pair?
reverse
set-car!
set-cdr!

;; r7rs

make-list
list-copy
list-set!

;; gambit

append-reverse
append-reverse!
circular-list
circular-list?
cons*
dotted-list?
drop
filter
fold
fold-right
iota
last
last-pair
length+
list-set
list-sort
list-sort!
list-tabulate
proper-list?
remove
remq
reverse!
take
xcons

car+cdr
eighth
fifth
first
fourth
ninth
not-pair?
null-list?
second
seventh
sixth
tenth
third

))

;;;============================================================================
