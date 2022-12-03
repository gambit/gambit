;;;============================================================================

;;; File: "r7rs#.scm"

;;; Copyright (c) 2005-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Identifiers bound to syntactic forms and procedures defined by R7RS
;; are mapped to the empty namespace (no prefix).

(##include "r5rs#.scm") ;; most identifier bindings are inherited from R5RS

(##namespace ("" ;; these identifier bindings are new in R7RS

;; special forms
case-lambda
cond-expand
define-library
define-record-type
delay-force
guard
include
include-ci
let*-values
let-values
letrec*
letrec*-values
letrec-values
parameterize
syntax-error
unless
when

;; procedures
binary-port?
boolean=?
bytevector
bytevector-append
bytevector-copy
bytevector-copy!
bytevector-length
bytevector-u8-ref
bytevector-u8-set!
bytevector?
call-with-port
char-foldcase
close-port
command-line
current-error-port
current-jiffy
current-second
delete-file
digit-value
emergency-exit
eof-object
error-object-irritants
error-object-message
error-object?
exact
exact-integer-sqrt
exact-integer?
exit
features
file-error?
file-exists?
finite?
floor-quotient
floor-remainder
floor/
flush-output-port
get-environment-variable
get-environment-variables
get-output-bytevector
get-output-string
inexact
infinite?
input-port-open?
jiffies-per-second
list-copy
list-set!
make-bytevector
make-list
make-parameter
make-promise
nan?
open-binary-input-file
open-binary-output-file
open-input-bytevector
open-input-string
open-output-string
output-port-open?
peek-u8
port?
promise?
read-bytevector
read-bytevector!
read-error?
read-line
read-string
read-u8
square
string->utf8
string->vector
string-copy!
string-downcase
string-foldcase
string-for-each
string-map
string-upcase
symbol=?
textual-port?
truncate-quotient
truncate-remainder
truncate/
u8-ready?
utf8->string
vector->string
vector-append
vector-copy
vector-copy!
vector-for-each
vector-map
write-bytevector
write-shared
write-simple
write-string
write-u8

))

;;;============================================================================
