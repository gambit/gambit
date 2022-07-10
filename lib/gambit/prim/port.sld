;;;============================================================================

;;; File: "port.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Port operations.

(define-library (port)

  (namespace "##")

  (export

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

))

;;;============================================================================
