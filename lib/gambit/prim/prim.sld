;;;============================================================================

;;; File: "prim.sld"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Primitive operations and special forms that are in the ## namespace.

(define-library (prim)

  (namespace "##")

  (export

;;; boolean.sld

;; r4rs

boolean?
not

;; r7rs

boolean=?

;;; box.sld

;; gambit

box
box?
set-box!
unbox

;;; bytevector.sld

;; r7rs

;;UNIMPLEMENTED bytevector
;;UNIMPLEMENTED bytevector-append
;;UNIMPLEMENTED bytevector-copy
;;UNIMPLEMENTED bytevector-copy!
;;UNIMPLEMENTED bytevector-length
;;UNIMPLEMENTED bytevector-u8-ref
;;UNIMPLEMENTED bytevector-u8-set!
;;UNIMPLEMENTED bytevector?
;;UNIMPLEMENTED make-bytevector

;;; char.sld

;; r4rs

char->integer
char-alphabetic?
char-ci<=?
char-ci<?
char-ci=?
char-ci>=?
char-ci>?
char-downcase
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
integer->char

;; r7rs

char-foldcase
digit-value

;;; exception.sld

;; gambit

;;UNIMPLEMENTED abort
;;UNIMPLEMENTED cfun-conversion-exception-arguments
;;UNIMPLEMENTED cfun-conversion-exception-code
;;UNIMPLEMENTED cfun-conversion-exception-message
;;UNIMPLEMENTED cfun-conversion-exception-procedure
;;UNIMPLEMENTED cfun-conversion-exception?
;;UNIMPLEMENTED current-exception-handler
;;UNIMPLEMENTED datum-parsing-exception-kind
;;UNIMPLEMENTED datum-parsing-exception-parameters
;;UNIMPLEMENTED datum-parsing-exception-readenv
;;UNIMPLEMENTED datum-parsing-exception?
;;UNIMPLEMENTED divide-by-zero-exception-arguments
;;UNIMPLEMENTED divide-by-zero-exception-procedure
;;UNIMPLEMENTED divide-by-zero-exception?

error

;;UNIMPLEMENTED error-exception-message
;;UNIMPLEMENTED error-exception-parameters
;;UNIMPLEMENTED error-exception?
;;UNIMPLEMENTED error-object-irritants
;;UNIMPLEMENTED error-object-message
;;UNIMPLEMENTED error-object?
;;UNIMPLEMENTED expression-parsing-exception-kind
;;UNIMPLEMENTED expression-parsing-exception-parameters
;;UNIMPLEMENTED expression-parsing-exception-source
;;UNIMPLEMENTED expression-parsing-exception?
;;UNIMPLEMENTED file-exists-exception-arguments
;;UNIMPLEMENTED file-exists-exception-procedure
;;UNIMPLEMENTED file-exists-exception?
;;UNIMPLEMENTED fixnum-overflow-exception-arguments
;;UNIMPLEMENTED fixnum-overflow-exception-procedure
;;UNIMPLEMENTED fixnum-overflow-exception?
;;UNIMPLEMENTED heap-overflow-exception?
;;UNIMPLEMENTED invalid-hash-number-exception-arguments
;;UNIMPLEMENTED invalid-hash-number-exception-procedure
;;UNIMPLEMENTED invalid-hash-number-exception?
;;UNIMPLEMENTED invalid-utf8-encoding-exception-arguments
;;UNIMPLEMENTED invalid-utf8-encoding-exception-procedure
;;UNIMPLEMENTED invalid-utf8-encoding-exception?
;;UNIMPLEMENTED keyword-expected-exception-arguments
;;UNIMPLEMENTED keyword-expected-exception-procedure
;;UNIMPLEMENTED keyword-expected-exception?
;;UNIMPLEMENTED length-mismatch-exception-arg-num
;;UNIMPLEMENTED length-mismatch-exception-arguments
;;UNIMPLEMENTED length-mismatch-exception-procedure
;;UNIMPLEMENTED length-mismatch-exception?
;;UNIMPLEMENTED module-not-found-exception-arguments
;;UNIMPLEMENTED module-not-found-exception-procedure
;;UNIMPLEMENTED module-not-found-exception?
;;UNIMPLEMENTED multiple-c-return-exception?
;;UNIMPLEMENTED no-such-file-or-directory-exception-arguments
;;UNIMPLEMENTED no-such-file-or-directory-exception-procedure
;;UNIMPLEMENTED no-such-file-or-directory-exception?
;;UNIMPLEMENTED noncontinuable-exception-reason
;;UNIMPLEMENTED noncontinuable-exception?
;;UNIMPLEMENTED nonempty-input-port-character-buffer-exception-arguments
;;UNIMPLEMENTED nonempty-input-port-character-buffer-exception-procedure
;;UNIMPLEMENTED nonempty-input-port-character-buffer-exception?
;;UNIMPLEMENTED nonprocedure-operator-exception-arguments
;;UNIMPLEMENTED nonprocedure-operator-exception-code
;;UNIMPLEMENTED nonprocedure-operator-exception-operator
;;UNIMPLEMENTED nonprocedure-operator-exception-rte
;;UNIMPLEMENTED nonprocedure-operator-exception?
;;UNIMPLEMENTED number-of-arguments-limit-exception-arguments
;;UNIMPLEMENTED number-of-arguments-limit-exception-procedure
;;UNIMPLEMENTED number-of-arguments-limit-exception?
;;UNIMPLEMENTED os-exception-arguments
;;UNIMPLEMENTED os-exception-code
;;UNIMPLEMENTED os-exception-message
;;UNIMPLEMENTED os-exception-procedure
;;UNIMPLEMENTED os-exception?
;;UNIMPLEMENTED permission-denied-exception-arguments
;;UNIMPLEMENTED permission-denied-exception-procedure
;;UNIMPLEMENTED permission-denied-exception?
;;UNIMPLEMENTED primordial-exception-handler

r7rs-raise
r7rs-raise-continuable
r7rs-with-exception-handler
raise

;;UNIMPLEMENTED range-exception-arg-num
;;UNIMPLEMENTED range-exception-arguments
;;UNIMPLEMENTED range-exception-procedure
;;UNIMPLEMENTED range-exception?
;;UNIMPLEMENTED rpc-remote-error-exception-arguments
;;UNIMPLEMENTED rpc-remote-error-exception-message
;;UNIMPLEMENTED rpc-remote-error-exception-procedure
;;UNIMPLEMENTED rpc-remote-error-exception?
;;UNIMPLEMENTED scheduler-exception-reason
;;UNIMPLEMENTED scheduler-exception?
;;UNIMPLEMENTED sfun-conversion-exception-arguments
;;UNIMPLEMENTED sfun-conversion-exception-code
;;UNIMPLEMENTED sfun-conversion-exception-message
;;UNIMPLEMENTED sfun-conversion-exception-procedure
;;UNIMPLEMENTED sfun-conversion-exception?
;;UNIMPLEMENTED stack-overflow-exception?
;;UNIMPLEMENTED type-exception-arg-num
;;UNIMPLEMENTED type-exception-arguments
;;UNIMPLEMENTED type-exception-procedure
;;UNIMPLEMENTED type-exception-type-id
;;UNIMPLEMENTED type-exception?
;;UNIMPLEMENTED unbound-global-exception-code
;;UNIMPLEMENTED unbound-global-exception-rte
;;UNIMPLEMENTED unbound-global-exception-variable
;;UNIMPLEMENTED unbound-global-exception?
;;UNIMPLEMENTED unbound-key-exception-arguments
;;UNIMPLEMENTED unbound-key-exception-procedure
;;UNIMPLEMENTED unbound-key-exception?
;;UNIMPLEMENTED unbound-os-environment-variable-exception-arguments
;;UNIMPLEMENTED unbound-os-environment-variable-exception-procedure
;;UNIMPLEMENTED unbound-os-environment-variable-exception?
;;UNIMPLEMENTED unbound-serial-number-exception-arguments
;;UNIMPLEMENTED unbound-serial-number-exception-procedure
;;UNIMPLEMENTED unbound-serial-number-exception?
;;UNIMPLEMENTED uncaught-exception-arguments
;;UNIMPLEMENTED uncaught-exception-procedure
;;UNIMPLEMENTED uncaught-exception-reason
;;UNIMPLEMENTED uncaught-exception?
;;UNIMPLEMENTED unknown-keyword-argument-exception-arguments
;;UNIMPLEMENTED unknown-keyword-argument-exception-procedure
;;UNIMPLEMENTED unknown-keyword-argument-exception?
;;UNIMPLEMENTED unterminated-process-exception-arguments
;;UNIMPLEMENTED unterminated-process-exception-procedure
;;UNIMPLEMENTED unterminated-process-exception?

with-exception-catcher
with-exception-handler

;;UNIMPLEMENTED wrong-number-of-arguments-exception-arguments
;;UNIMPLEMENTED wrong-number-of-arguments-exception-procedure
;;UNIMPLEMENTED wrong-number-of-arguments-exception?
;;UNIMPLEMENTED wrong-number-of-values-exception-code
;;UNIMPLEMENTED wrong-number-of-values-exception-rte
;;UNIMPLEMENTED wrong-number-of-values-exception-vals
;;UNIMPLEMENTED wrong-number-of-values-exception?
;;UNIMPLEMENTED wrong-processor-c-return-exception?

;;; f32vector.sld

;; gambit

f32vector-concatenate
list->f32vector
make-f32vector
subf32vector
subf32vector-fill!
subf32vector-move!
f32vector
f32vector->list
f32vector-append
f32vector-copy
f32vector-copy!
f32vector-fill!
f32vector-length
f32vector-ref
f32vector-set
f32vector-set!
f32vector-shrink!
f32vector?

;;; f64vector.sld

;; gambit

f64vector-concatenate
list->f64vector
make-f64vector
subf64vector
subf64vector-fill!
subf64vector-move!
f64vector
f64vector->list
f64vector-append
f64vector-copy
f64vector-copy!
f64vector-fill!
f64vector-length
f64vector-ref
f64vector-set
f64vector-set!
f64vector-shrink!
f64vector?

;;; filesystem.sld

;; r7rs

file-exists?
delete-file

;; gambit

copy-file
create-directory
create-fifo
create-link
create-symbolic-link
create-temporary-directory
current-directory
delete-directory
delete-file-or-directory
directory-files
executable-path
;;UNIMPLEMENTED file-attributes
;;UNIMPLEMENTED file-creation-time
;;UNIMPLEMENTED file-device
;;UNIMPLEMENTED file-error?
;;UNIMPLEMENTED file-group
file-info
file-info-attributes
file-info-creation-time
file-info-device
file-info-group
file-info-inode
file-info-last-access-time
file-info-last-change-time
file-info-last-modification-time
file-info-mode
file-info-number-of-links
file-info-owner
file-info-size
file-info-type
file-info?
;;UNIMPLEMENTED file-inode
file-last-access-and-modification-times-set!
;;UNIMPLEMENTED file-last-access-time
;;UNIMPLEMENTED file-last-change-time
;;UNIMPLEMENTED file-last-modification-time
;;UNIMPLEMENTED file-mode
;;UNIMPLEMENTED file-number-of-links
;;UNIMPLEMENTED file-owner
;;UNIMPLEMENTED file-size
;;UNIMPLEMENTED file-type
initial-current-directory
path-directory
path-expand
path-extension
path-normalize
path-strip-directory
path-strip-extension
path-strip-trailing-directory-separator
path-strip-volume
path-volume
read-file-string
read-file-string-list
read-file-u8vector
rename-file
write-file-string
write-file-string-list
write-file-u8vector

;;; fixnum.sld

;; gambit

fixnum?
fx*
fx+
fl+*
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

;;; flonum.sld

;; gambit

fixnum->flonum
fl*
fl+
fl-
fl/
fl<
fl<=
fl=
fl>
fl>=
flabs
flacos
flacosh
flasin
flasinh
flatan
flatanh
flceiling
flcos
flcosh
fldenominator
fleven?
flexp
flexpm1
flexpt
flfinite?
flfloor
flhypot
flilogb
flinfinite?
flinteger?
fllog
fllog1p
flmax
flmin
flnan?
flnegative?
flnumerator
flodd?
flonum?
flpositive?
flround
flscalbn
flsin
flsinh
flsqrt
flsquare
fltan
fltanh
fltruncate
flzero?

;;; foreign.sld

;; gambit

;;UNIMPLEMENTED foreign-address
;;UNIMPLEMENTED foreign-release!
;;UNIMPLEMENTED foreign-released?
;;UNIMPLEMENTED foreign-tags
;;UNIMPLEMENTED foreign?

;;; keyword.sld

;; gambit

keyword->string
keyword-hash
keyword?
string->keyword
string->uninterned-keyword
uninterned-keyword?

;;; list.sld

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

;;; misc.sld

;; r4rs

apply
call-with-current-continuation
eq?
equal?
eqv?
;;UNIMPLEMENTED load
procedure?
;;UNIMPLEMENTED transcript-off
;;UNIMPLEMENTED transcript-on

;; r5rs

call-with-values
dynamic-wind
eval
;;UNIMPLEMENTED interaction-environment
;;UNIMPLEMENTED null-environment
;;UNIMPLEMENTED scheme-report-environment
values

;; r7rs

;;UNIMPLEMENTED features
;;UNIMPLEMENTED make-parameter
;;UNIMPLEMENTED make-promise
;;UNIMPLEMENTED promise?

;; gambit

apropos

;;UNIMPLEMENTED break
;;UNIMPLEMENTED call/cc

compilation-target

;;UNIMPLEMENTED not-in-compilation-context-exception-arguments
;;UNIMPLEMENTED not-in-compilation-context-exception-procedure

;;UNIMPLEMENTED not-in-compilation-context-exception?
;;UNIMPLEMENTED compile-file
;;UNIMPLEMENTED compile-file-to-target

continuation-capture
continuation-graft
continuation-return
continuation?

dead-end
define-module-alias

;;UNIMPLEMENTED display-continuation-backtrace
;;UNIMPLEMENTED display-continuation-dynamic-environment
;;UNIMPLEMENTED display-continuation-environment
;;UNIMPLEMENTED display-dynamic-environment?
;;UNIMPLEMENTED display-environment-set!
;;UNIMPLEMENTED display-exception
;;UNIMPLEMENTED display-exception-in-context
;;UNIMPLEMENTED display-procedure-environment

eq?-hash
equal?-hash
eqv?-hash
force

;;UNIMPLEMENTED gc-report-set!
;;UNIMPLEMENTED generate-proper-tail-calls
;;UNIMPLEMENTED help
;;UNIMPLEMENTED help-browser

identity

;;UNIMPLEMENTED link-flat
;;UNIMPLEMENTED link-incremental
;;UNIMPLEMENTED main

module-search-order-add!
module-search-order-reset!
module-whitelist-add!
module-whitelist-reset!

;;UNIMPLEMENTED object->serial-number

poll-point

;;UNIMPLEMENTED repl-display-environment?
;;UNIMPLEMENTED repl-input-port
;;UNIMPLEMENTED repl-output-port
;;UNIMPLEMENTED repl-result-history-max-length-set!
;;UNIMPLEMENTED repl-result-history-ref
;;UNIMPLEMENTED serial-number->object
;;UNIMPLEMENTED step
;;UNIMPLEMENTED step-level-set!
;;UNIMPLEMENTED touch
;;UNIMPLEMENTED trace
;;UNIMPLEMENTED unbreak
;;UNIMPLEMENTED untrace

void

;;; number.sld

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
any-bit-set?
any-bits-set?
arithmetic-shift
asinh
atanh
balanced-quotient
balanced-remainder
balanced/
bit-count
bit-field
bit-field-any?
bit-field-clear
bit-field-every?
bit-field-replace
bit-field-replace-same
bit-field-reverse
bit-field-rotate
bit-field-set
bit-set?
bit-swap
;;UNIMPLEMENTED bits
;;UNIMPLEMENTED bits->list
;;UNIMPLEMENTED bits->vector
bitwise-and
bitwise-andc1
bitwise-andc2
bitwise-eqv
bitwise-fold
bitwise-for-each
bitwise-if
bitwise-ior
bitwise-merge
bitwise-nand
bitwise-nor
bitwise-not
bitwise-orc1
bitwise-orc2
bitwise-unfold
bitwise-xor
ceiling-quotient
ceiling-remainder
ceiling/
clear-bit-field
conjugate
copy-bit
copy-bit-field
cosh
;;UNIMPLEMENTED default-random-source
euclidean-quotient
euclidean-remainder
euclidean/
every-bit-set?
extract-bit-field
first-set-bit
integer-length
integer-nth-root
integer-sqrt
;;UNIMPLEMENTED list->bits
make-bitwise-generator
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
round-quotient
round-remainder
round/
sinh
tanh
test-bit-field?
;;UNIMPLEMENTED vector->bits

;;; os.sld

;; r7rs

command-line

;;UNIMPLEMENTED current-jiffy
;;UNIMPLEMENTED current-second
;;UNIMPLEMENTED emergency-exit

exit

;;UNIMPLEMENTED get-environment-variable
;;UNIMPLEMENTED get-environment-variables
;;UNIMPLEMENTED jiffies-per-second

;; gambit

;;UNIMPLEMENTED address-info-family
;;UNIMPLEMENTED address-info-protocol
;;UNIMPLEMENTED address-info-socket-info
;;UNIMPLEMENTED address-info-socket-type
;;UNIMPLEMENTED address-info?
;;UNIMPLEMENTED address-infos

command-args
command-name

;;UNIMPLEMENTED configure-command-string
;;UNIMPLEMENTED cpu-time

current-time
current-user-interrupt-handler
default-user-interrupt-handler
defer-user-interrupts

;;UNIMPLEMENTED err-code->string

getenv

;;UNIMPLEMENTED group-info
;;UNIMPLEMENTED group-info-gid
;;UNIMPLEMENTED group-info-members
;;UNIMPLEMENTED group-info-name
;;UNIMPLEMENTED group-info?
;;UNIMPLEMENTED host-info
;;UNIMPLEMENTED host-info-addresses
;;UNIMPLEMENTED host-info-aliases
;;UNIMPLEMENTED host-info-name
;;UNIMPLEMENTED host-info?
;;UNIMPLEMENTED host-name
;;UNIMPLEMENTED network-info
;;UNIMPLEMENTED network-info-aliases
;;UNIMPLEMENTED network-info-name
;;UNIMPLEMENTED network-info-number
;;UNIMPLEMENTED network-info?
;;UNIMPLEMENTED process-times
;;UNIMPLEMENTED protocol-info
;;UNIMPLEMENTED protocol-info-aliases
;;UNIMPLEMENTED protocol-info-name
;;UNIMPLEMENTED protocol-info-number
;;UNIMPLEMENTED protocol-info?
;;UNIMPLEMENTED real-time

script-directory
script-file
seconds->time

;;UNIMPLEMENTED service-info
;;UNIMPLEMENTED service-info-aliases
;;UNIMPLEMENTED service-info-name
;;UNIMPLEMENTED service-info-port-number
;;UNIMPLEMENTED service-info-protocol
;;UNIMPLEMENTED service-info?

setenv
shell-command

;;UNIMPLEMENTED socket-info-address
;;UNIMPLEMENTED socket-info-family
;;UNIMPLEMENTED socket-info-port-number
;;UNIMPLEMENTED socket-info?
;;UNIMPLEMENTED system-stamp
;;UNIMPLEMENTED system-type
;;UNIMPLEMENTED system-type-string
;;UNIMPLEMENTED system-version
;;UNIMPLEMENTED system-version-string

time->seconds
time?

;;UNIMPLEMENTED timeout->time
;;UNIMPLEMENTED user-info
;;UNIMPLEMENTED user-info-gid
;;UNIMPLEMENTED user-info-home
;;UNIMPLEMENTED user-info-name
;;UNIMPLEMENTED user-info-shell
;;UNIMPLEMENTED user-info-uid
;;UNIMPLEMENTED user-info?
;;UNIMPLEMENTED user-name

;;; port.sld

;; r4rs

call-with-input-file
call-with-output-file
char-ready?
close-input-port
close-output-port
current-input-port
current-output-port
display
eof-object?
input-port?
newline
open-input-file
open-output-file
output-port?
peek-char
read
read-char
with-input-from-file
with-output-to-file
write
write-char

;; r7rs

;;UNIMPLEMENTED binary-port?
call-with-port
close-port
current-error-port
eof-object
;;UNIMPLEMENTED flush-output-port
;;UNIMPLEMENTED get-output-bytevector
get-output-string
;;UNIMPLEMENTED input-port-open?
;;UNIMPLEMENTED open-binary-input-file
;;UNIMPLEMENTED open-binary-output-file
;;UNIMPLEMENTED open-input-bytevector
open-input-string
open-output-string
;;UNIMPLEMENTED output-port-open?
;;UNIMPLEMENTED peek-u8
port?
;;UNIMPLEMENTED read-bytevector
;;UNIMPLEMENTED read-bytevector!
;;UNIMPLEMENTED read-error?
read-line
;;UNIMPLEMENTED read-string
read-u8
;;UNIMPLEMENTED textual-port?
u8-ready?
write-bytevector
write-shared
write-simple
;;UNIMPLEMENTED write-string
write-u8

;; gambit

call-with-input-process
call-with-input-string
call-with-input-u8vector
call-with-input-vector
call-with-output-process
call-with-output-string
call-with-output-u8vector
call-with-output-vector
;;UNIMPLEMENTED console-port
current-readtable
force-output
get-output-u8vector
get-output-vector
input-port-byte-position
input-port-bytes-buffered
input-port-char-position
input-port-characters-buffered
input-port-column
input-port-line
input-port-readtable
input-port-readtable-set!
input-port-timeout-set!
;;UNIMPLEMENTED make-tls-context
object->string
object->u8vector
open-directory
open-dummy
;;UNIMPLEMENTED open-event-queue
open-file
open-input-process
open-input-u8vector
open-input-vector
open-output-process
open-output-u8vector
open-output-vector
;;UNIMPLEMENTED open-process
;;UNIMPLEMENTED open-string
;;UNIMPLEMENTED open-string-pipe
;;UNIMPLEMENTED open-tcp-client
;;UNIMPLEMENTED open-tcp-server
;;UNIMPLEMENTED open-u8vector
;;UNIMPLEMENTED open-u8vector-pipe
;;UNIMPLEMENTED open-udp
;;UNIMPLEMENTED open-vector
;;UNIMPLEMENTED open-vector-pipe
output-port-byte-position
output-port-char-position
output-port-column
output-port-line
output-port-readtable
output-port-readtable-set!
output-port-timeout-set!
output-port-width
port-io-exception-handler-set!
port-settings-set!
;;UNIMPLEMENTED pp
pretty-print
print
println
process-pid
process-status
read-all
read-substring
read-subu8vector
;;UNIMPLEMENTED readtable-case-conversion?
;;UNIMPLEMENTED readtable-case-conversion?-set
;;UNIMPLEMENTED readtable-comment-handler
;;UNIMPLEMENTED readtable-comment-handler-set
;;UNIMPLEMENTED readtable-eval-allowed?
;;UNIMPLEMENTED readtable-eval-allowed?-set
;;UNIMPLEMENTED readtable-keywords-allowed?
;;UNIMPLEMENTED readtable-keywords-allowed?-set
;;UNIMPLEMENTED readtable-max-unescaped-char
;;UNIMPLEMENTED readtable-max-unescaped-char-set
;;UNIMPLEMENTED readtable-max-write-length
;;UNIMPLEMENTED readtable-max-write-length-set
;;UNIMPLEMENTED readtable-max-write-level
;;UNIMPLEMENTED readtable-max-write-level-set
;;UNIMPLEMENTED readtable-sharing-allowed?
;;UNIMPLEMENTED readtable-sharing-allowed?-set
;;UNIMPLEMENTED readtable-start-syntax
;;UNIMPLEMENTED readtable-start-syntax-set
;;UNIMPLEMENTED readtable-write-cdr-read-macros?
;;UNIMPLEMENTED readtable-write-cdr-read-macros?-set
;;UNIMPLEMENTED readtable-write-extended-read-macros?
;;UNIMPLEMENTED readtable-write-extended-read-macros?-set
;;UNIMPLEMENTED readtable?

repl-error-port
repl-input-port
repl-output-port

;;UNIMPLEMENTED tcp-client-local-socket-info
;;UNIMPLEMENTED tcp-client-peer-socket-info
;;UNIMPLEMENTED tcp-client-self-socket-info
;;UNIMPLEMENTED tcp-server-socket-info
;;UNIMPLEMENTED tcp-service-register!
;;UNIMPLEMENTED tcp-service-unregister!
;;UNIMPLEMENTED tty-history
;;UNIMPLEMENTED tty-history-max-length-set!
;;UNIMPLEMENTED tty-history-set!
;;UNIMPLEMENTED tty-mode-set!
;;UNIMPLEMENTED tty-paren-balance-duration-set!
;;UNIMPLEMENTED tty-text-attributes-set!
;;UNIMPLEMENTED tty-type-set!
;;UNIMPLEMENTED tty?
;;UNIMPLEMENTED udp-destination-set!
;;UNIMPLEMENTED udp-local-socket-info
;;UNIMPLEMENTED udp-read-subu8vector
;;UNIMPLEMENTED udp-read-u8vector
;;UNIMPLEMENTED udp-source-socket-info
;;UNIMPLEMENTED udp-write-subu8vector
;;UNIMPLEMENTED udp-write-u8vector
u8vector->object
with-input-from-port
with-input-from-process
with-input-from-string
with-input-from-u8vector
with-input-from-vector
with-output-to-port
with-output-to-process
with-output-to-string
with-output-to-u8vector
with-output-to-vector
write-substring
write-subu8vector

;;; s16vector.sld

;; gambit

s16vector-concatenate
list->s16vector
make-s16vector
subs16vector
subs16vector-fill!
subs16vector-move!
s16vector
s16vector->list
s16vector-append
s16vector-copy
s16vector-copy!
s16vector-fill!
s16vector-length
s16vector-ref
s16vector-set
s16vector-set!
s16vector-shrink!
s16vector?

;;; s32vector.sld

;; gambit

s32vector-concatenate
list->s32vector
make-s32vector
subs32vector
subs32vector-fill!
subs32vector-move!
s32vector
s32vector->list
s32vector-append
s32vector-copy
s32vector-copy!
s32vector-fill!
s32vector-length
s32vector-ref
s32vector-set
s32vector-set!
s32vector-shrink!
s32vector?

;;; s64vector.sld

;; gambit

s64vector-concatenate
list->s64vector
make-s64vector
subs64vector
subs64vector-fill!
subs64vector-move!
s64vector
s64vector->list
s64vector-append
s64vector-copy
s64vector-copy!
s64vector-fill!
s64vector-length
s64vector-ref
s64vector-set
s64vector-set!
s64vector-shrink!
s64vector?

;;; s8vector.sld

;; gambit

s8vector-concatenate
list->s8vector
make-s8vector
subs8vector
subs8vector-fill!
subs8vector-move!
s8vector
s8vector->list
s8vector-append
s8vector-copy
s8vector-copy!
s8vector-fill!
s8vector-length
s8vector-ref
s8vector-set
s8vector-set!
s8vector-shrink!
s8vector?

;;; six.sld

;; gambit

;;UNIMPLEMENTED six.!
;;UNIMPLEMENTED six.!x
;;UNIMPLEMENTED six.&x
;;UNIMPLEMENTED six.*x
;;UNIMPLEMENTED six.++x
;;UNIMPLEMENTED six.+x
;;UNIMPLEMENTED six.--x
;;UNIMPLEMENTED six.-x
;;UNIMPLEMENTED six.arrow
;;UNIMPLEMENTED six.break
;;UNIMPLEMENTED six.call
;;UNIMPLEMENTED six.case
;;UNIMPLEMENTED six.clause
;;UNIMPLEMENTED six.compound
;;UNIMPLEMENTED six.cons
;;UNIMPLEMENTED six.continue
;;UNIMPLEMENTED six.define-procedure
;;UNIMPLEMENTED six.define-variable
;;UNIMPLEMENTED six.do-while
;;UNIMPLEMENTED six.dot
;;UNIMPLEMENTED six.for
;;UNIMPLEMENTED six.goto
;;UNIMPLEMENTED six.identifier
;;UNIMPLEMENTED six.if
;;UNIMPLEMENTED six.index
;;UNIMPLEMENTED six.label
;;UNIMPLEMENTED six.list
;;UNIMPLEMENTED six.literal
;;UNIMPLEMENTED six.make-array
;;UNIMPLEMENTED six.new
;;UNIMPLEMENTED six.null
;;UNIMPLEMENTED six.prefix
;;UNIMPLEMENTED six.procedure
;;UNIMPLEMENTED six.procedure-body
;;UNIMPLEMENTED six.return
;;UNIMPLEMENTED six.switch
;;UNIMPLEMENTED six.while
;;UNIMPLEMENTED six.x!=y
;;UNIMPLEMENTED six.x%=y
;;UNIMPLEMENTED six.x%y
;;UNIMPLEMENTED six.x&&y
;;UNIMPLEMENTED six.x&=y
;;UNIMPLEMENTED six.x&y
;;UNIMPLEMENTED six.x*=y
;;UNIMPLEMENTED six.x*y
;;UNIMPLEMENTED six.x++
;;UNIMPLEMENTED six.x+=y
;;UNIMPLEMENTED six.x+y
;;UNIMPLEMENTED six.x--
;;UNIMPLEMENTED six.x-=y
;;UNIMPLEMENTED six.x-y
;;UNIMPLEMENTED six.x/=y
;;UNIMPLEMENTED six.x/y
;;UNIMPLEMENTED six.x:-y
;;UNIMPLEMENTED six.x:=y
;;UNIMPLEMENTED six.x:y
;;UNIMPLEMENTED six.x<<=y
;;UNIMPLEMENTED six.x<<y
;;UNIMPLEMENTED six.x<=y
;;UNIMPLEMENTED six.x<y
;;UNIMPLEMENTED six.x==y
;;UNIMPLEMENTED six.x=y
;;UNIMPLEMENTED six.x>=y
;;UNIMPLEMENTED six.x>>=y
;;UNIMPLEMENTED six.x>>y
;;UNIMPLEMENTED six.x>y
;;UNIMPLEMENTED six.x?y:z
;;UNIMPLEMENTED six.x^=y
;;UNIMPLEMENTED six.x^y
;;UNIMPLEMENTED six.~x
;;UNIMPLEMENTED |six.x,y|
;;UNIMPLEMENTED |six.x\|=y|
;;UNIMPLEMENTED |six.x\|\|y|
;;UNIMPLEMENTED |six.x\|y|

;;; special-forms.sld

;; r4rs

and
begin
case
cond
define
delay
do
if
lambda
let
let*
letrec
or
quasiquote
quote
set!

;; r5rs

define-syntax
;;let-syntax ;; not implemented
;;letrec-syntax ;; not implemented
syntax-rules

;; r7rs

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

;; gambit

c-declare
c-define
c-define-type
c-initialize
c-lambda
declare
define-cond-expand-feature
define-macro
define-structure
define-type
define-type-of-thread
define-values
future
import
namespace
r7rs-guard
receive
six.infix
syntax
syntax-case
this-source-file
time

;;; string.sld

;; r4rs

list->string
make-string
string
string->list
string-append
string-ci<=?
string-ci<?
string-ci=?
string-ci>=?
string-ci>?
string-copy
string-fill!
string-length
string-ref
string-set!
string<=?
string<?
string=?
string>=?
string>?
string?
substring

;; r7rs

string->utf8
;;UNIMPLEMENTED string->vector
string-copy!
string-downcase
string-foldcase
;;UNIMPLEMENTED string-for-each
;;UNIMPLEMENTED string-map
string-upcase
utf8->string
;;UNIMPLEMENTED vector->string

;; gambit

string-ci=?-hash
string-concatenate
string-contains
string-contains-ci
string-prefix-ci?
string-prefix-length
string-prefix-length-ci
string-prefix?
string-set
string-shrink!
string-suffix-ci?
string-suffix-length
string-suffix-length-ci
string-suffix?
string=?-hash
substring-fill!
substring-move!

;;; symbol.sld

;; r4rs

string->symbol
symbol->string
symbol?

;; r7rs

symbol=?

;; gambit

gensym
string->uninterned-symbol
symbol-hash
uninterned-symbol?

;;; table.sld

;; gambit

list->table
make-table
table->list
table-copy
table-for-each
table-length
table-merge
table-merge!
table-ref
table-search
table-set!
table?

;;; thread.sld

;; gambit

;;UNIMPLEMENTED abandoned-mutex-exception?
;;UNIMPLEMENTED condition-variable-broadcast!
;;UNIMPLEMENTED condition-variable-name
;;UNIMPLEMENTED condition-variable-signal!
;;UNIMPLEMENTED condition-variable-specific
;;UNIMPLEMENTED condition-variable-specific-set!
;;UNIMPLEMENTED condition-variable?
;;UNIMPLEMENTED current-processor
;;UNIMPLEMENTED current-thread
;;UNIMPLEMENTED deadlock-exception?
;;UNIMPLEMENTED inactive-thread-exception-arguments
;;UNIMPLEMENTED inactive-thread-exception-procedure
;;UNIMPLEMENTED inactive-thread-exception?
;;UNIMPLEMENTED initialized-thread-exception-arguments
;;UNIMPLEMENTED initialized-thread-exception-procedure
;;UNIMPLEMENTED initialized-thread-exception?
;;UNIMPLEMENTED join-timeout-exception-arguments
;;UNIMPLEMENTED join-timeout-exception-procedure
;;UNIMPLEMENTED join-timeout-exception?
;;UNIMPLEMENTED mailbox-receive-timeout-exception-arguments
;;UNIMPLEMENTED mailbox-receive-timeout-exception-procedure
;;UNIMPLEMENTED mailbox-receive-timeout-exception?
;;UNIMPLEMENTED make-condition-variable
;;UNIMPLEMENTED make-mutex
;;UNIMPLEMENTED make-root-thread
;;UNIMPLEMENTED make-thread
;;UNIMPLEMENTED make-thread-group
;;UNIMPLEMENTED mutex-lock!
;;UNIMPLEMENTED mutex-name
;;UNIMPLEMENTED mutex-specific
;;UNIMPLEMENTED mutex-specific-set!
;;UNIMPLEMENTED mutex-state
;;UNIMPLEMENTED mutex-unlock!
;;UNIMPLEMENTED mutex?
;;UNIMPLEMENTED processor-id
;;UNIMPLEMENTED processor?
;;UNIMPLEMENTED started-thread-exception-arguments
;;UNIMPLEMENTED started-thread-exception-procedure
;;UNIMPLEMENTED started-thread-exception?
;;UNIMPLEMENTED terminated-thread-exception-arguments
;;UNIMPLEMENTED terminated-thread-exception-procedure
;;UNIMPLEMENTED terminated-thread-exception?
;;UNIMPLEMENTED thread-base-priority
;;UNIMPLEMENTED thread-base-priority-set!
;;UNIMPLEMENTED thread-group->thread-group-list
;;UNIMPLEMENTED thread-group->thread-group-vector
;;UNIMPLEMENTED thread-group->thread-list
;;UNIMPLEMENTED thread-group->thread-vector
;;UNIMPLEMENTED thread-group-name
;;UNIMPLEMENTED thread-group-parent
;;UNIMPLEMENTED thread-group-resume!
;;UNIMPLEMENTED thread-group-specific
;;UNIMPLEMENTED thread-group-specific-set!
;;UNIMPLEMENTED thread-group-suspend!
;;UNIMPLEMENTED thread-group-terminate!
;;UNIMPLEMENTED thread-group?
;;UNIMPLEMENTED thread-init!
;;UNIMPLEMENTED thread-interrupt!
;;UNIMPLEMENTED thread-join!
;;UNIMPLEMENTED thread-mailbox-extract-and-rewind
;;UNIMPLEMENTED thread-mailbox-next
;;UNIMPLEMENTED thread-mailbox-rewind
;;UNIMPLEMENTED thread-name
;;UNIMPLEMENTED thread-priority-boost
;;UNIMPLEMENTED thread-priority-boost-set!
;;UNIMPLEMENTED thread-quantum
;;UNIMPLEMENTED thread-quantum-set!
;;UNIMPLEMENTED thread-receive
;;UNIMPLEMENTED thread-resume!
;;UNIMPLEMENTED thread-send
;;UNIMPLEMENTED thread-sleep!
;;UNIMPLEMENTED thread-specific
;;UNIMPLEMENTED thread-specific-set!
;;UNIMPLEMENTED thread-start!
;;UNIMPLEMENTED thread-state
;;UNIMPLEMENTED thread-state-abnormally-terminated-reason
;;UNIMPLEMENTED thread-state-abnormally-terminated?
;;UNIMPLEMENTED thread-state-initialized?
;;UNIMPLEMENTED thread-state-normally-terminated-result
;;UNIMPLEMENTED thread-state-normally-terminated?
;;UNIMPLEMENTED thread-state-running-processor
;;UNIMPLEMENTED thread-state-running?
;;UNIMPLEMENTED thread-state-uninitialized?
;;UNIMPLEMENTED thread-state-waiting-for
;;UNIMPLEMENTED thread-state-waiting-timeout
;;UNIMPLEMENTED thread-state-waiting?
;;UNIMPLEMENTED thread-suspend!
;;UNIMPLEMENTED thread-terminate!
;;UNIMPLEMENTED thread-thread-group
;;UNIMPLEMENTED thread-yield!
;;UNIMPLEMENTED thread?
;;UNIMPLEMENTED top
;;UNIMPLEMENTED uninitialized-thread-exception-arguments
;;UNIMPLEMENTED uninitialized-thread-exception-procedure
;;UNIMPLEMENTED uninitialized-thread-exception?

;;; u16vector.sld

;; gambit

u16vector-concatenate
list->u16vector
make-u16vector
subu16vector
subu16vector-fill!
subu16vector-move!
u16vector
u16vector->list
u16vector-append
u16vector-copy
u16vector-copy!
u16vector-fill!
u16vector-length
u16vector-ref
u16vector-set
u16vector-set!
u16vector-shrink!
u16vector?

;;; u32vector.sld

;; gambit

u32vector-concatenate
list->u32vector
make-u32vector
subu32vector
subu32vector-fill!
subu32vector-move!
u32vector
u32vector->list
u32vector-append
u32vector-copy
u32vector-copy!
u32vector-fill!
u32vector-length
u32vector-ref
u32vector-set
u32vector-set!
u32vector-shrink!
u32vector?

;;; u64vector.sld

;; gambit

u64vector-concatenate
list->u64vector
make-u64vector
subu64vector
subu64vector-fill!
subu64vector-move!
u64vector
u64vector->list
u64vector-append
u64vector-copy
u64vector-copy!
u64vector-fill!
u64vector-length
u64vector-ref
u64vector-set
u64vector-set!
u64vector-shrink!
u64vector?

;;; u8vector.sld

;; gambit

u8vector-concatenate
list->u8vector
make-u8vector
subu8vector
subu8vector-fill!
subu8vector-move!
u8vector
u8vector->list
u8vector-append
u8vector-copy
u8vector-copy!
u8vector-fill!
u8vector-length
u8vector-ref
u8vector-set
u8vector-set!
u8vector-shrink!
u8vector?

;;; vector.sld

;; r4rs

list->vector
make-vector
vector
vector->list
vector-fill!
vector-length
vector-ref
vector-set!
vector?

;; r7rs

vector-append
vector-copy
vector-copy!
;;UNIMPLEMENTED vector-for-each
;;UNIMPLEMENTED vector-map

;; gambit

vector-concatenate
vector-set
vector-shrink!
subvector
subvector-fill!
subvector-move!
vector-cas!

;;UNIMPLEMENTED vector-inc!

;;; will.sld

;; gambit

make-will
will-execute!
will-testator
will?

))

;;;============================================================================
