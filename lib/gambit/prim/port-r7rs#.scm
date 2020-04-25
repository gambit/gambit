;;;============================================================================

;;; File: "port-r7rs#.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Port operations added by R7RS.

(##namespace ("##"

(binary-port? binary-port?#unimplemented)
call-with-port
close-port
current-error-port
eof-object
(flush-output-port flush-output-port#unimplemented)
(get-output-bytevector get-output-bytevector#unimplemented)
get-output-string
(input-port-open? input-port-open?#unimplemented)
(open-binary-input-file open-binary-input-file#unimplemented)
(open-binary-output-file open-binary-output-file#unimplemented)
(open-input-bytevector open-input-bytevector#unimplemented)
open-input-string
open-output-string
(output-port-open? output-port-open?#unimplemented)
(peek-u8 peek-u8#unimplemented)
port?
(read-bytevector read-bytevector#unimplemented)
(read-bytevector! read-bytevector!#unimplemented)
(read-error? read-error?#unimplemented)
read-line
(read-string read-string#unimplemented)
read-u8
(textual-port? textual-port?#unimplemented)
u8-ready?
write-bytevector
write-shared
write-simple
(write-string write-string#unimplemented)
write-u8

))

;;;============================================================================
