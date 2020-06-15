;;;============================================================================

;;; File: "list.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; List operations.

(define-library (list)

  (namespace "")

  (export

append
append-reverse
append-reverse!
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
circular-list
cons
cons*
drop
fold
fold-right
for-each
iota
last
last-pair
length
list
list-copy
list-ref
list-set
list-set!
list-sort
list-sort!
list-tabulate
list-tail
list?
make-list
map
member
memq
memv
null?
pair?
reverse
reverse!
set-car!
set-cdr!
take
xcons

)

  (include "list#.scm"))

;;;============================================================================
