;;;============================================================================

;;; File: "list.sld"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; List operations.

(define-library (list)

  (namespace "")

  (export

pair?
cons
car
cdr
caar
cadr
cdar
cddr
caaar
caadr
cadar
caddr
cdaar
cdadr
cddar
cdddr
caaaar
caaadr
caadar
caaddr
cadaar
cadadr
caddar
cadddr
cdaaar
cdaadr
cdadar
cdaddr
cddaar
cddadr
cdddar
cddddr
set-car!
set-cdr!
null?
list?
list
length
append
reverse
list-ref
list-set!
list-set
memq
memv
member
assq
assv
assoc
map
for-each
list-tail

xcons
cons*
make-list
list-tabulate
list-copy
circular-list
iota
take
drop
last-pair
last
butlast
reverse!
fold
fold-right

)

  (include "list#.scm"))

;;;============================================================================
