;;;============================================================================

;;; File: "list.sld"

;;; Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved.

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

any
append!
append-reverse!
append-reverse
car+cdr
circular-list
circular-list?
concatenate!
concatenate
cons*
;;UNIMPLEMENTED delete!
delete
dotted-list?
drop
drop-right!
drop-right
eighth
every
fifth
;;UNIMPLEMENTED filter!
filter
first
fold
fold-right
fourth
iota
last
last-pair
length+
list-set
list-sort!
list-sort
list-tabulate
;;UNIMPLEMENTED list=
ninth
not-pair?
null-list?
partition!
partition
proper-list?
;;UNIMPLEMENTED remove!
remove
remq
reverse!
second
seventh
sixth
split-at!
split-at
take!
take
take-right
tenth
third
xcons

))

;;;============================================================================
