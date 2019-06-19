;;;============================================================================

;;; File: "_prim-port-gambit#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Port operations added by Gambit.

(##namespace ("##"

call-with-input-process
call-with-input-string
call-with-input-u8vector
call-with-input-vector
call-with-output-process
call-with-output-string
call-with-output-u8vector
call-with-output-vector
(console-port console-port#unimplemented)
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
(make-tls-context make-tls-context#unimplemented)
object->string
object->u8vector
open-directory
open-dummy
(open-event-queue open-event-queue#unimplemented)
open-file
open-input-process
open-input-u8vector
open-input-vector
open-output-process
open-output-u8vector
open-output-vector
(open-process open-process#unimplemented)
(open-string open-string#unimplemented)
(open-string-pipe open-string-pipe#unimplemented)
(open-tcp-client open-tcp-client#unimplemented)
(open-tcp-server open-tcp-server#unimplemented)
(open-u8vector open-u8vector#unimplemented)
(open-u8vector-pipe open-u8vector-pipe#unimplemented)
(open-udp open-udp#unimplemented)
(open-vector open-vector#unimplemented)
(open-vector-pipe open-vector-pipe#unimplemented)
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
(pp pp#unimplemented)
pretty-print
(print print#unimplemented)
(println println#unimplemented)
(process-pid process-pid#unimplemented)
(process-status process-status#unimplemented)
read-all
read-substring
read-subu8vector
(readtable-case-conversion? readtable-case-conversion?#unimplemented)
(readtable-case-conversion?-set readtable-case-conversion?-set#unimplemented)
(readtable-comment-handler readtable-comment-handler#unimplemented)
(readtable-comment-handler-set readtable-comment-handler-set#unimplemented)
(readtable-eval-allowed? readtable-eval-allowed?#unimplemented)
(readtable-eval-allowed?-set readtable-eval-allowed?-set#unimplemented)
(readtable-keywords-allowed? readtable-keywords-allowed?#unimplemented)
(readtable-keywords-allowed?-set readtable-keywords-allowed?-set#unimplemented)
(readtable-max-unescaped-char readtable-max-unescaped-char#unimplemented)
(readtable-max-unescaped-char-set readtable-max-unescaped-char-set#unimplemented)
(readtable-max-write-length readtable-max-write-length#unimplemented)
(readtable-max-write-length-set readtable-max-write-length-set#unimplemented)
(readtable-max-write-level readtable-max-write-level#unimplemented)
(readtable-max-write-level-set readtable-max-write-level-set#unimplemented)
(readtable-sharing-allowed? readtable-sharing-allowed?#unimplemented)
(readtable-sharing-allowed?-set readtable-sharing-allowed?-set#unimplemented)
(readtable-start-syntax readtable-start-syntax#unimplemented)
(readtable-start-syntax-set readtable-start-syntax-set#unimplemented)
(readtable-write-cdr-read-macros? readtable-write-cdr-read-macros?#unimplemented)
(readtable-write-cdr-read-macros?-set readtable-write-cdr-read-macros?-set#unimplemented)
(readtable-write-extended-read-macros? readtable-write-extended-read-macros?#unimplemented)
(readtable-write-extended-read-macros?-set readtable-write-extended-read-macros?-set#unimplemented)
(readtable? readtable?#unimplemented)
(tcp-client-local-socket-info tcp-client-local-socket-info#unimplemented)
(tcp-client-peer-socket-info tcp-client-peer-socket-info#unimplemented)
(tcp-client-self-socket-info tcp-client-self-socket-info#unimplemented)
(tcp-server-socket-info tcp-server-socket-info#unimplemented)
(tcp-service-register! tcp-service-register!#unimplemented)
(tcp-service-unregister! tcp-service-unregister!#unimplemented)
(tty-history tty-history#unimplemented)
(tty-history-max-length-set! tty-history-max-length-set!#unimplemented)
(tty-history-set! tty-history-set!#unimplemented)
(tty-mode-set! tty-mode-set!#unimplemented)
(tty-paren-balance-duration-set! tty-paren-balance-duration-set!#unimplemented)
(tty-text-attributes-set! tty-text-attributes-set!#unimplemented)
(tty-type-set! tty-type-set!#unimplemented)
(tty? tty?#unimplemented)
(udp-destination-set! udp-destination-set!#unimplemented)
(udp-local-socket-info udp-local-socket-info#unimplemented)
(udp-read-subu8vector udp-read-subu8vector#unimplemented)
(udp-read-u8vector udp-read-u8vector#unimplemented)
(udp-source-socket-info udp-source-socket-info#unimplemented)
(udp-write-subu8vector udp-write-subu8vector#unimplemented)
(udp-write-u8vector udp-write-u8vector#unimplemented)
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
