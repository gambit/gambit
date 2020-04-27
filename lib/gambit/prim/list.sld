;;;============================================================================

;;; File: "list.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

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

circular-list
cons*
drop
fold
fold-right
iota
last
last-pair
list-set
list-sort
list-sort!
list-tabulate
reverse!
append-reverse
append-reverse!
take
xcons

))

;;;============================================================================
