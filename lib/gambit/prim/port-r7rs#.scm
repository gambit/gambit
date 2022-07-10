;;;============================================================================

;;; File: "port-r7rs#.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Port operations added by R7RS.

(##namespace ("##"

(binary-port? unimplemented#binary-port?)
call-with-port
close-port
current-error-port
eof-object
(flush-output-port unimplemented#flush-output-port)
(get-output-bytevector unimplemented#get-output-bytevector)
get-output-string
(input-port-open? unimplemented#input-port-open?)
(open-binary-input-file unimplemented#open-binary-input-file)
(open-binary-output-file unimplemented#open-binary-output-file)
(open-input-bytevector unimplemented#open-input-bytevector)
open-input-string
open-output-string
(output-port-open? unimplemented#output-port-open?)
(peek-u8 unimplemented#peek-u8)
port?
(read-bytevector unimplemented#read-bytevector)
(read-bytevector! unimplemented#read-bytevector!)
(read-error? unimplemented#read-error?)
read-line
(read-string unimplemented#read-string)
read-u8
(textual-port? unimplemented#textual-port?)
u8-ready?
write-bytevector
write-shared
write-simple
(write-string unimplemented#write-string)
write-u8

))

;;;============================================================================
