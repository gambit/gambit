;;;============================================================================

;;; File: "_io#.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception datum-parsing-exception
  id: 84660e37-9565-4abf-ac09-f9767f926d40
  constructor: #f
  opaque:

  (kind       unprintable: read-only: no-functional-setter:)
  (readenv    unprintable: read-only: no-functional-setter:)
  (parameters unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception unterminated-process-exception
  id: b320dfbf-c714-4dc5-8bfa-cac5ee6c8421
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception nonempty-input-port-character-buffer-exception
  id: 63b50ae7-375b-4b94-81df-3522686f5634
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type string-or-ip-address 'string-or-ip-address
  macro-string-or-ip-address?)

(##define-macro (macro-string-or-ip-address? obj)
  `(##string-or-ip-address? ,obj))

;;;----------------------------------------------------------------------------

;;; Representation of ports.

;; There are 6 kinds of ports, each providing a set of operations.  All
;; port objects have the capability of being both an input port and an
;; output port.  The "none-port" kind provides no operation and is
;; mainly for internal use to indicate that no input operation is
;; available or that no output operation is available.
;;
;; 1) A "waitable-port" (or simply a "port") provides operations to
;;    wait for the port being readable and/or writable.  It also provides
;;    operations to get the name of the port and to close the port.
;;    This kind of port need not have Scheme-level operations to read
;;    and write data (these operations could be provided by host-level
;;    operations made available with the FFI).
;;
;; 2) An "object-port" provides operations to read and write Scheme
;;    data (i.e. any Scheme object) to/from the port.  It also provides
;;    an operation to force output to occur.  This kind of port need
;;    not be connected to a character based device or file (it could
;;    for example be a FIFO queue linking two threads that need to
;;    communicate Scheme objects).
;;
;; 3) A "character-port" provides all the operations of an "object-port",
;;    and also operations to read and write individual characters
;;    to/from the port.  When a Scheme object is written to a
;;    character-port, it is converted into the sequence of characters that
;;    corresponds to its "external-representation".  When reading a
;;    Scheme object, an inverse conversion occurs.
;;
;; 4) A "byte-port" provides all the operations of a "character-port",
;;    and also operations to read and write individual bytes to/from
;;    the port.  When a **character** is written to a byte-port, some
;;    encoding of that character into a sequence of bytes will occur
;;    (for example, #\newline might be encoded as the 2 bytes CR-LF
;;    when using ISO-8859-1 encoding, or a non-ASCII character will
;;    generate more than 1 byte when using UTF-8 encoding).  When
;;    reading a character, a similar decoding occurs.
;;
;; 5) A "device-port" provides all the operations of a "byte-port", and
;;    also operations to control the device (file, tty, etc) that is
;;    connected to the port, such as changing the tty settings.

(define-type port
  id: fe3e988a-c59d-47ce-8592-93b02ce12af1
  type-exhibitor: macro-type-port
  constructor: macro-make-port
  implementer: implement-type-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-port

  mutex              ;; access to the port is controlled with this mutex

  rkind              ;; port kind for reading (none-port if can't read)
  wkind              ;; port kind for writing (none-port if can't write)

  name               ;; procedure which returns the name of the port

  wait               ;; procedure for waiting until port readable or writable

  close              ;; procedure to close the port

  roptions           ;; options for reading (buffering type, encoding, etc)
  rtimeout           ;; time at which a read that would block times out
  rtimeout-thunk     ;; thunk called when a read timeout occurs
  set-rtimeout       ;; procedure to set rtimeout and rtimeout-thunk

  woptions           ;; options for writing (buffering type, encoding, etc)
  wtimeout           ;; time at which a write that would block times out
  wtimeout-thunk     ;; thunk called when a write timeout occurs
  set-wtimeout       ;; procedure to set wtimeout and wtimeout-thunk

  io-exception-handler ;; procedure to handle I/O exceptions on this port
)

(define-check-type port (macro-type-port)
  macro-port?)

(##define-macro (macro-port-of-rkind? obj kind)
  `(let ((obj ,obj))
     (and (macro-port? obj)
          (##fx= (##fxand (macro-port-rkind obj) ,kind)
                 ,kind))))

(##define-macro (macro-port-of-wkind? obj kind)
  `(let ((obj ,obj))
     (and (macro-port? obj)
          (##fx= (##fxand (macro-port-wkind obj) ,kind)
                 ,kind))))

(##define-macro (macro-none-kind)      0) ;; allows nothing
(##define-macro (macro-waitable-kind)  1) ;; can wait until readable/writable
(##define-macro (macro-object-kind)    3) ;; can also read and write objects
(##define-macro (macro-character-kind) 7) ;; can also read and write chars
(##define-macro (macro-byte-kind)     15) ;; can also read and write bytes
(##define-macro (macro-device-kind)   31) ;; can also do device operations

(##define-macro (macro-file-kind)        (+ 31 32))
(##define-macro (macro-pipe-kind)        (+ 31 64))
(##define-macro (macro-process-kind)     (+ 31 64 131072))
(##define-macro (macro-tty-kind)         (+ 31 128))
(##define-macro (macro-serial-kind)      (+ 31 256))
(##define-macro (macro-tcp-client-kind)  (+ 31 512))
(##define-macro (macro-tcp-server-kind)  (+ 3 1024))
(##define-macro (macro-directory-kind)   (+ 3 2048))
(##define-macro (macro-event-queue-kind) (+ 3 4096))
(##define-macro (macro-timer-kind)       (+ 3 8192))
(##define-macro (macro-vector-kind)      (+ 3 16384))
(##define-macro (macro-string-kind)      (+ 7 32768))
(##define-macro (macro-u8vector-kind)    (+ 15 65536))
(##define-macro (macro-raw-device-kind)  (+ 1 262144))
(##define-macro (macro-udp-kind)         (+ 3 524288))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of waitable ports.

(define-check-type input-port 'input-port
  macro-input-port?)
(define-check-type output-port 'output-port
  macro-output-port?)

(##define-macro (macro-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-waitable-kind)))

(##define-macro (macro-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-waitable-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of object ports.

(define-check-type object-input-port 'object-input-port
  macro-object-input-port?)
(define-check-type object-output-port 'object-output-port
  macro-object-output-port?)

(define-type-of-port object-port
  id: a4ef4750-7ce6-4388-9d5f-48e04bf3ae4b
  type-exhibitor: macro-type-object-port
  constructor: macro-make-object-port
  implementer: implement-type-object-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-object-port

  read-datum         ;; procedure to read a datum
  write-datum        ;; procedure to write a datum
  newline            ;; procedure to write a datum separator
  force-output       ;; procedure to force output to occur on target device
)

(##define-macro (macro-object-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-object-kind)))

(##define-macro (macro-object-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-object-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of char ports.

(define-check-type character-input-port 'character-input-port
  macro-character-input-port?)
(define-check-type character-output-port 'character-output-port
  macro-character-output-port?)

(define-type-of-object-port character-port
  id: a7e0fe95-65e9-4b00-b080-b7e6b12d9c6f
  type-exhibitor: macro-type-character-port
  constructor: macro-make-character-port
  implementer: implement-type-character-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-character-port

  rbuf               ;; character read buffer (a string)
  rlo                ;; low pointer (start of unread characters)
  rhi                ;; high pointer (end of unread characters)
  rchars             ;; number of characters read at start of read buffer
  rlines             ;; number of lines read up to low pointer
  rcurline           ;; absolute character position where current line starts
  rbuf-fill          ;; procedure to read characters into the read buffer
  peek-eof?          ;; peeking the next character should return end-of-file?

  wbuf               ;; character write buffer (a string)
  wlo                ;; low pointer (start of unwritten characters)
  whi                ;; high pointer (end of unwritten characters)
  wchars             ;; number of characters written at start of write buffer
  wlines             ;; number of lines written up to high pointer
  wcurline           ;; absolute character position where current line starts
  wbuf-drain         ;; procedure to write characters from the write buffer

  input-readtable    ;; readtable for reading
  output-readtable   ;; readtable for writing
  output-width       ;; procedure to get the output width in characters
)

(##define-macro (macro-character-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-character-kind)))

(##define-macro (macro-character-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-character-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of byte ports.

(define-check-type byte-port 'byte-port
  macro-byte-port?)
(define-check-type byte-input-port 'byte-input-port
  macro-byte-input-port?)
(define-check-type byte-output-port 'byte-output-port
  macro-byte-output-port?)

(define-type-of-character-port byte-port
  id: fe99424c-d1da-48f1-b613-9c735692790e
  type-exhibitor: macro-type-byte-port
  constructor: macro-make-byte-port
  implementer: implement-type-byte-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-byte-port

  rbuf               ;; byte read buffer (a u8vector)
  rlo                ;; low pointer (start of unread bytes)
  rhi                ;; high pointer (end of unread bytes)
  rbuf-fill          ;; procedure to read bytes into the read buffer

  wbuf               ;; byte write buffer (a u8vector)
  wlo                ;; low pointer (start of unwritten bytes)
  whi                ;; high pointer (end of unwritten bytes)
  wbuf-drain         ;; procedure to write bytes from the write buffer
)

(##define-macro (macro-byte-port? obj)
  `(or (macro-byte-input-port? ,obj)
       (macro-byte-output-port? ,obj)))

(##define-macro (macro-byte-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-byte-kind)))

(##define-macro (macro-byte-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-byte-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of device ports.

(define-check-type device-input-port 'device-input-port
  macro-device-input-port?)
(define-check-type device-output-port 'device-output-port
  macro-device-output-port?)

(define-type-of-byte-port device-port
  id: a1d146d0-78f6-437f-aa67-3b9b5bb333dc
  type-exhibitor: macro-type-device-port
  constructor: macro-make-device-port
  implementer: implement-type-device-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-device-port

  rdevice-condvar    ;; device condvar from which bytes are read
  wdevice-condvar    ;; device condvar to which bytes are written
  event-condvar      ;; only used for process ports
  name               ;; name of device
)

(##define-macro (macro-device-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-device-kind)))

(##define-macro (macro-device-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-device-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of vector, string and u8vector ports.


(define-type-of-object-port vector-port
  id: bf2fa024-cc0a-419a-bcbf-cff3c2385050
  type-exhibitor: macro-type-vector-port
  constructor: macro-make-vector-port
  implementer: implement-type-vector-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-vector-port

  rbuf
  rlo
  rhi
  rbuf-fill
  wbuf
  wlo
  whi
  wbuf-drain
  peer
  fifo
  rcondvar
  wcondvar
  buffering-limit
)

(define-check-type vector-input-port 'vector-input-port
  macro-vector-input-port?)
(define-check-type vector-output-port 'vector-output-port
  macro-vector-output-port?)

(##define-macro (macro-vector-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-vector-kind)))

(##define-macro (macro-vector-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-vector-kind)))

(define-type-of-character-port string-port
  id: f5264d6c-cb90-4a74-8810-9ae0b1e1f08c
  type-exhibitor: macro-type-string-port
  constructor: macro-make-string-port
  implementer: implement-type-string-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-string-port

  peer
  fifo
  rcondvar
  wcondvar
  width
  buffering-limit
)

(define-check-type string-input-port 'string-input-port
  macro-string-input-port?)
(define-check-type string-output-port 'string-output-port
  macro-string-output-port?)

(##define-macro (macro-string-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-string-kind)))

(##define-macro (macro-string-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-string-kind)))

(define-type-of-byte-port u8vector-port
  id: fd0b10bf-219c-4cde-be79-d959cec702a5
  type-exhibitor: macro-type-u8vector-port
  constructor: macro-make-u8vector-port
  implementer: implement-type-u8vector-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-u8vector-port

  peer
  fifo
  rcondvar
  wcondvar
  width
  buffering-limit
)

(define-check-type u8vector-input-port 'u8vector-input-port
  macro-u8vector-input-port?)
(define-check-type u8vector-output-port 'u8vector-output-port
  macro-u8vector-output-port?)

(##define-macro (macro-u8vector-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-u8vector-kind)))

(##define-macro (macro-u8vector-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-u8vector-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of file device ports.

(define-check-type file-port 'file-port
  macro-file-port?)

(##define-macro (macro-file-port? obj)
  `(##port-of-kind? ,obj (macro-file-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of tty device ports.

(define-check-type tty-port 'tty-port
  macro-tty-port?)

(##define-macro (macro-tty-port? obj)
  `(##port-of-kind? ,obj (macro-tty-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of process device ports.

(define-check-type process-port 'process-port
  macro-process-port?)

(##define-macro (macro-process-port? obj)
  `(##port-of-kind? ,obj (macro-process-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of host-info objects.

(define-library-type host-info
  id: e3dc833e-a176-42c1-bdc0-76a6c4b302f8
  constructor: #f

  (name      printable: read-only: no-functional-setter:)
  (aliases   printable: read-only: no-functional-setter:)
  (addresses printable: read-only: no-functional-setter:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of service-info objects.

(define-library-type service-info
  id: 177749b2-beb0-4670-9ab2-4b9c01b54c1d
  constructor: #f

  (name        printable: read-only: no-functional-setter:)
  (aliases     printable: read-only: no-functional-setter:)
  (port-number printable: read-only: no-functional-setter:)
  (protocol    printable: read-only: no-functional-setter:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of protocol-info objects.

(define-library-type protocol-info
  id: ffc668b5-2146-42b7-ab11-7d91641f2124
  constructor: #f

  (name      printable: read-only: no-functional-setter:)
  (aliases   printable: read-only: no-functional-setter:)
  (number    printable: read-only: no-functional-setter:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of network-info objects.

(define-library-type network-info
  id: ce2e418b-96c7-4562-9cb6-419ec113704e
  constructor: #f

  (name      printable: read-only: no-functional-setter:)
  (aliases   printable: read-only: no-functional-setter:)
  (number    printable: read-only: no-functional-setter:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of socket-info objects.

(define-library-type socket-info
  id: 837d9768-9d27-455e-ac65-5ae59f43f79e
  constructor: #f

  (family      printable: read-only: no-functional-setter:)
  (port-number printable: read-only: no-functional-setter:)
  (address     printable: read-only: no-functional-setter:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of address-info objects.

(define-library-type address-info
  id: f165f359-8685-48da-bc99-f38827ad8af9
  constructor: #f

  (family       printable: read-only: no-functional-setter:)
  (socket-type  printable: read-only: no-functional-setter:)
  (protocol     printable: read-only: no-functional-setter:)
  (socket-info  printable: read-only: no-functional-setter:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of TCP client device ports.

(define-check-type tcp-client-port 'tcp-client-port
  macro-tcp-client-port?)

(##define-macro (macro-tcp-client-port? obj)
  `(##port-of-kind? ,obj (macro-tcp-client-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of raw device ports.

(define-type-of-port raw-device-port
  id: E641E009-FCAA-412D-B283-587F5C6D4EC1
  type-exhibitor: macro-type-raw-device-port
  constructor: macro-make-raw-device-port
  implementer: implement-type-raw-device-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-raw-device-port

  rdevice-condvar
  wdevice-condvar
  type
  id
  specific
)

(##define-macro (macro-raw-device-port? obj)
  `(##port-of-kind? ,obj (macro-raw-device-kind)))


;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of TCP server ports.

(define-type-of-object-port tcp-server-port
  id: e7f8dac4-0e85-4605-a8bd-6bd6b5262d4c
  type-exhibitor: macro-type-tcp-server-port
  constructor: macro-make-tcp-server-port
  implementer: implement-type-tcp-server-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-tcp-server-port

  rdevice-condvar
  client-psettings
)

(define-check-type tcp-server-port (macro-type-tcp-server-port)
  macro-tcp-server-port?)

(##define-macro (macro-tcp-server-port? obj)
  `(##port-of-kind? ,obj (macro-tcp-server-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of UDP device ports.

(define-type-of-object-port udp-port
  id: AB62859B-18EF-47D3-8AC5-69D3103EDE6F
  type-exhibitor: macro-type-udp-port
  constructor: macro-make-udp-port
  implementer: implement-type-udp-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-udp-port

  rdevice-condvar
  wdevice-condvar
  latest-source
)

(define-check-type udp-port 'udp-port
  macro-udp-port?)

(##define-macro (macro-udp-port? obj)
  `(##port-of-kind? ,obj (macro-udp-kind)))

(define-check-type udp-input-port 'udp-input-port
  macro-udp-input-port?)
(define-check-type udp-output-port 'udp-output-port
  macro-udp-output-port?)

(##define-macro (macro-udp-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-udp-kind)))

(##define-macro (macro-udp-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-udp-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of pipe device ports.

(define-check-type pipe-port 'pipe-port
  macro-pipe-port?)

(##define-macro (macro-pipe-port? obj)
  `(##port-of-kind? ,obj (macro-pipe-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of serial device ports.

(define-check-type serial-port 'serial-port
  macro-serial-port?)

(##define-macro (macro-serial-port? obj)
  `(##port-of-kind? ,obj (macro-serial-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of directory ports.

(define-type-of-object-port directory-port
  id: f118f601-23ad-493f-9ef9-ac1dd259de18
  type-exhibitor: macro-type-directory-port
  constructor: macro-make-directory-port
  implementer: implement-type-directory-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-directory-port

  rdevice-condvar
  path
)

(define-check-type directory-port 'directory-port
  macro-directory-port?)

(##define-macro (macro-directory-port? obj)
  `(##port-of-kind? ,obj (macro-directory-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of event queue ports.

(define-type-of-object-port event-queue-port
  id: a4a724bb-335a-42dd-8027-5ffd9eaf943c
  type-exhibitor: macro-type-event-queue-port
  constructor: macro-make-event-queue-port
  implementer: implement-type-event-queue-port
  macros:
  prefix: macro-
  opaque:
  unprintable:

  extender: define-type-of-event-queue-port

  rdevice-condvar
  selector
)

(define-check-type event-queue-port 'event-queue-port
  macro-event-queue-port?)

(##define-macro (macro-event-queue-port? obj)
  `(##port-of-kind? ,obj (macro-event-queue-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of timer ports.

(define-check-type timer-port 'timer-port
  macro-timer-port?)

(##define-macro (macro-timer-port? obj)
  `(##port-of-kind? ,obj (macro-timer-kind)))

;;;----------------------------------------------------------------------------

;;; Representation of port mutexes.

(##define-macro (macro-make-port-mutex)
  `(##make-mutex #f))

(##define-macro (macro-port-mutex-lock! port)
  `(macro-mutex-lock! (macro-port-mutex ,port) #f (macro-current-thread)))

(##define-macro (macro-port-mutex-unlock! port)
  `(macro-mutex-unlock! (macro-port-mutex ,port)))

(##define-macro (macro-port-mutex-unlocked-not-abandoned-and-not-multiprocessor? port)
  `(macro-mutex-unlocked-not-abandoned-and-not-multiprocessor? (macro-port-mutex ,port)))

;;;----------------------------------------------------------------------------

;;; Representation of port settings.

(define-type psettings
  id: C4293CA5-B269-494A-B24F-63730C347018
  type-exhibitor: macro-type-psettings
  constructor: macro-make-psettings
  implementer: implement-type-psettings
  macros:
  prefix: macro-
  opaque:
  unprintable:

  direction
  roptions
  woptions
  path
  init
  arguments
  environment
  directory
  append
  create
  truncate
  permissions
  output-width
  stdin-redir
  stdout-redir
  stderr-redir
  pseudo-term
  show-console
  address
  port-number
  local-address
  local-port-number
  coalesce
  keep-alive
  backlog
  reuse-address
  broadcast
  ignore-hidden
  tls-context
)

(define-type psettings-options
  id: edb28923-9aa0-4c55-9756-f1a37136f727
  type-exhibitor: macro-type-psettings-options
  constructor: macro-make-psettings-options
  implementer: implement-type-psettings-options
  macros:
  prefix: macro-
  opaque:
  unprintable:

  readtable
  char-encoding
  char-encoding-errors
  eol-encoding
  buffering
  permanent-close
)

(##define-macro (macro-default-readtable) #f)

(##define-macro (macro-char-encoding-shift)                  0)
(##define-macro (macro-char-encoding-mask)                   (* 31 (expt 2 0)))
(##define-macro (macro-default-char-encoding)                0)
(##define-macro (macro-char-encoding-ASCII)                  1)
(##define-macro (macro-char-encoding-ISO-8859-1)             2)
(##define-macro (macro-char-encoding-UTF-8)                  3)
(##define-macro (macro-char-encoding-UTF-16)                 4)
(##define-macro (macro-char-encoding-UTF-16BE)               5)
(##define-macro (macro-char-encoding-UTF-16LE)               6)
(##define-macro (macro-char-encoding-UTF-fallback-ASCII)     7)
(##define-macro (macro-char-encoding-UTF-fallback-ISO-8859-1)8)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-8)     9)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-16)    10)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-16BE)  11)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-16LE)  12)
(##define-macro (macro-char-encoding-UCS-2)                  13)
(##define-macro (macro-char-encoding-UCS-2BE)                14)
(##define-macro (macro-char-encoding-UCS-2LE)                15)
(##define-macro (macro-char-encoding-UCS-4)                  16)
(##define-macro (macro-char-encoding-UCS-4BE)                17)
(##define-macro (macro-char-encoding-UCS-4LE)                18)
(##define-macro (macro-char-encoding-wchar)                  19)
(##define-macro (macro-char-encoding-native)                 20)

(##define-macro (macro-char-encoding-UTF)
  `(macro-char-encoding-UTF-fallback-UTF-8))

(##define-macro (macro-max-unescaped-char options)
  `(let ((e (##fxarithmetic-shift-right
             (##fxand ,options (macro-char-encoding-mask))
             (macro-char-encoding-shift))))
     (cond ((##fx<= e (macro-char-encoding-ISO-8859-1))
            (if (##fx= e (macro-char-encoding-ISO-8859-1))
                (##integer->char #xff)
                (##integer->char #x7f)))
           ((and (##fx>= e (macro-char-encoding-UCS-2))
                 (##fx<= e (macro-char-encoding-UCS-2LE)))
            (##integer->char #xffff))
           (else
            (##integer->char #x10ffff)))))

(##define-macro (macro-char-encoding-errors-shift)   5)
(##define-macro (macro-char-encoding-errors-mask)    (* 3 (expt 2 5)))
(##define-macro (macro-default-char-encoding-errors) 0)
(##define-macro (macro-char-encoding-errors-on)      1)
(##define-macro (macro-char-encoding-errors-off)     2)

(##define-macro (macro-eol-encoding-shift)   7)
(##define-macro (macro-eol-encoding-mask)    (* 3 (expt 2 7)))
(##define-macro (macro-default-eol-encoding) 0)
(##define-macro (macro-eol-encoding-lf)      1)
(##define-macro (macro-eol-encoding-cr)      2)
(##define-macro (macro-eol-encoding-crlf)    3)

(##define-macro (macro-buffering-shift)   9)
(##define-macro (macro-buffering-mask)    (* 3 (expt 2 9)))
(##define-macro (macro-default-buffering) 0)
(##define-macro (macro-no-buffering)      1)
(##define-macro (macro-line-buffering)    2)
(##define-macro (macro-full-buffering)    3)

(##define-macro (macro-unbuffered? options)
  `(##fx< (##fxand ,options 2047) 1024))

(##define-macro (macro-fully-buffered? options)
  `(##not (##fx< (##fxand ,options 2047) 1536)))

(##define-macro (macro-decode-state-shift)  11)
(##define-macro (macro-decode-state-mask)   (* 3 (expt 2 11)))
(##define-macro (macro-decode-state-none)   0)
(##define-macro (macro-decode-state-lf)     1)
(##define-macro (macro-decode-state-cr)     2)

(##define-macro (macro-open-state-shift)  13)
(##define-macro (macro-open-state-mask)   (* 1 (expt 2 13)))
(##define-macro (macro-open-state-open)   0)
(##define-macro (macro-open-state-closed) 1)

(##define-macro (macro-closed? options)
  `(##not (##fx= (##fxand ,options 8192) 0)))

(##define-macro (macro-close! options)
  `(##fxior ,options 8192))

(##define-macro (macro-unclose! options)
  `(##fxand ,options -8193))

(##define-macro (macro-permanent-close-shift)  14)
(##define-macro (macro-permanent-close-mask)   (* 1 (expt 2 14)))
(##define-macro (macro-permanent-close-no)     0)
(##define-macro (macro-permanent-close-yes)    1)

(##define-macro (macro-perm-close? options)
  `(##not (##fx= (##fxand ,options 16384) 0)))

(##define-macro (macro-direction-shift) 4)
(##define-macro (macro-direction-in)    1)
(##define-macro (macro-direction-out)   2)
(##define-macro (macro-direction-inout) 3)

(##define-macro (macro-default-path) #f)

(##define-macro (macro-default-init) #f)

(##define-macro (macro-default-arguments) ''())

(##define-macro (macro-default-environment) #f)

(##define-macro (macro-default-directory) #f)

(##define-macro (macro-append-shift)   3)
(##define-macro (macro-no-append)      0)
(##define-macro (macro-append)         1)
(##define-macro (macro-default-append) 2)

(##define-macro (macro-create-shift)   1)
(##define-macro (macro-no-create)      0)
(##define-macro (macro-maybe-create)   1)
(##define-macro (macro-create)         2)
(##define-macro (macro-default-create) 3)

(##define-macro (macro-truncate-shift)   0)
(##define-macro (macro-no-truncate)      0)
(##define-macro (macro-truncate)         1)
(##define-macro (macro-default-truncate) 2)

(##define-macro (macro-default-permissions)  -1)

(##define-macro (macro-default-output-width) -1)

(##define-macro (macro-permanent-close) 1)
(##define-macro (macro-no-permanent-close) 0)
(##define-macro (macro-default-permanent-close) `(macro-permanent-close))

(##define-macro (macro-stdin-from-port) 1)
(##define-macro (macro-stdin-unchanged) 0)
(##define-macro (macro-default-stdin-redir) `(macro-stdin-from-port))

(##define-macro (macro-stdout-to-port) 1)
(##define-macro (macro-stdout-unchanged) 0)
(##define-macro (macro-default-stdout-redir) `(macro-stdout-to-port))

(##define-macro (macro-stderr-to-port) 1)
(##define-macro (macro-stderr-unchanged) 0)
(##define-macro (macro-default-stderr-redir) `(macro-stderr-unchanged))

(##define-macro (macro-pseudo-term) 1)
(##define-macro (macro-no-pseudo-term) 0)
(##define-macro (macro-default-pseudo-term) `(macro-no-pseudo-term))

(##define-macro (macro-show-console) 1)
(##define-macro (macro-no-show-console) 0)
(##define-macro (macro-default-show-console) `(macro-show-console))

(##define-macro (macro-coalesce) 1)
(##define-macro (macro-no-coalesce) 0)
(##define-macro (macro-default-coalesce) `(macro-coalesce))

(##define-macro (macro-keep-alive) 1)
(##define-macro (macro-no-keep-alive) 0)
(##define-macro (macro-default-keep-alive) `(macro-no-keep-alive))

(##define-macro (macro-broadcast) 1)
(##define-macro (macro-no-broadcast) 0)
(##define-macro (macro-default-broadcast) `(macro-no-broadcast))

(##define-macro (macro-default-backlog) 128)

(##define-macro (macro-reuse-address) 1)
(##define-macro (macro-no-reuse-address) 0)
(##define-macro (macro-default-reuse-address) `(macro-reuse-address))

(##define-macro (macro-ignore-hidden) 2)
(##define-macro (macro-ignore-dot-and-dot-dot) 1)
(##define-macro (macro-ignore-nothing) 0)
(##define-macro (macro-default-ignore-hidden) `(macro-ignore-hidden))

(##define-macro (macro-default-tls-context) #f)

(##define-macro (macro-localhost) ''#u8(127 0 0 1))

;;;----------------------------------------------------------------------------

;;; Representation of write environments.

;; A writeenv structure maintains the "write environment" throughout
;; the writing of a Scheme datum.  It includes the write style (one of
;; the symbols display, write, pretty-print, mark, etc), the port on
;; which to write, the readtable, the marktable (for detecting
;; cycles), the force flag, the pretty-print width, the number of
;; closing parentheses to follow the datum, the current nesting level,
;; the character count limit, and the maximum unescaped character.

(define-type writeenv
  id: f5cfcf78-bba4-4140-9aa0-1a136c50d36b
  type-exhibitor: macro-type-writeenv
  constructor: macro-make-writeenv
  implementer: implement-type-writeenv
  macros:
  prefix: macro-
  opaque:
  unprintable:

  style ;; 1 of write-simple/write-shared/write/display/print/pretty-print/mark
  port  ;; character output port to write to
  readtable ;; the readtable to use to achieve write/read invariance
  marktable ;; the marktable to use to detect shared parts and cycles
  force?    ;; boolean indicating if promises should be forced or not
  width     ;; for pretty-printing: width of output usually equal to port width
  shift     ;; for pretty-printing: number of implicit spaces at start of line
  close-parens ;; for pretty-printing: number of ')' remaining to output
  level     ;; nesting level counter to elide deeply nested parts
  limit     ;; remaining number of character counter to limit length of output
  max-unescaped-char ;; character above which escapes are used when writing
                     ;; out characters (to use only ASCII in output)
)

;; Accessing the fields of the write environment is useful when
;; implementing extensions to the printer, for example to format
;; data types specially.  For example:
;;
;; (##include "~~lib/_gambit#.scm")
;;
;; (define-type point x y)  ;; define a data type to format specially
;;
;; (##wr-set!
;;  (let ((old-wr ##wr))
;;    (lambda (we obj) ;; we = write environment, obj = object to write
;;      (if (not (point? obj))
;;          (old-wr we obj) ;; write other objects like before
;;          (case (macro-writeenv-style we)
;;            ((mark) ;; the mark style is used by the printer to handle shared
;;             #f)    ;; structures... here we don't do anything special
;;            (else
;;             (##wr-str we "#<a-point>")))))))
;;
;; (write-shared (list (make-point 1 2) (make-point 3 4) (make-point 5 6)))
;; (write-shared (let ((x (make-point 1 2))) (list x x x)))
;;
;; Note that the two calls to write-shared will output the same thing:
;;
;; (#<a-point> #<a-point> #<a-point>)
;;
;; For the second call of write-shared this is not ideal because the
;; list contains 3 references to the same object and it would be good
;; to use datum labels to show the sharing like this:
;;
;; (#0=#<a-point> #0# #0#)
;;
;; To achieve this the printer uses a two phase algorithm: a mark
;; phase followed by an output phase.  During the mark phase the
;; structure is recursively walked to find the number of references it
;; contains to each object.  When an object is referenced more than
;; once a datum label will be used when referring to it.  There is no
;; output generated during the mark phase.
;;
;; To implement this a call to (##wr-mark we obj) must be added so
;; that the object is registered in the marktable during the mark
;; phase.  Then in the output phase a call to (##wr-stamp we obj) will
;; either return #t after writing nothing (when the object has been
;; visited once during the mark phase) or the datum label definition
;; #N= (when the object has been visited multiple times during the
;; mark phase, but the first time during the output phase), or return
;; #f after writing the datum label reference #N# (when the object has
;; been visited multiple times during the mark phase, and after the
;; first time during the output phase).  The updated code is:
;;
;; (##wr-set!
;;  (let ((old-wr ##wr))
;;    (lambda (we obj) ;; we = write environment, obj = object to write
;;      (if (not (point? obj))
;;          (old-wr we obj) ;; write other objects like before
;;          (case (macro-writeenv-style we)
;;            ((mark)                  ;; this is the mark phase...
;;             (##wr-mark we obj))     ;; register the object in the marktable
;;            (else                    ;; this is the output phase...
;;             (if (##wr-stamp we obj) ;; write datum label if needed
;;                 (##wr-str we "#<a-point>"))))))))
;;
;; An obviously nice feature to add is an output formatting of the
;; structure that shows the content of the structure's fields.  This
;; can be done with recursive calls of ##wr like this:
;;
;; (##wr-set!
;;  (let ((old-wr ##wr))
;;    (lambda (we obj) ;; we = write environment, obj = object to write
;;      (if (not (point? obj))
;;          (old-wr we obj) ;; write other objects like before
;;          (case (macro-writeenv-style we)
;;            ((mark)
;;             (if (##wr-mark-begin we obj)    ;; begin a marking extent
;;                 (begin                      ;; this is first visit of obj
;;                   (##wr we (point-x obj))   ;; recursively mark x field
;;                   (##wr we (point-y obj))   ;; recursively mark y field
;;                   (##wr-mark-end we obj)))) ;; end the marking extent
;;            (else
;;             (if (##wr-stamp we obj)
;;                 (begin
;;                   (##wr-str we "#<pt x: ")
;;                   (##wr we (point-x obj))
;;                   (##wr-str we " y: ")
;;                   (##wr we (point-y obj))
;;                   (##wr-str we ">")))))))))
;;
;; Note that both the mark and output phases must recursively call
;; ##wr .  This is necessary to support structures with sharing or
;; cycles.  For example:
;;
;; (let* ((obj0 (make-point 1 2))
;;        (root (make-point obj0 obj0)))
;;   (point-y-set! obj0 obj0)
;;   (write-shared root))
;;
;; will produce the output:
;;
;; #<pt x: #0=#<pt x: 1 y: #0#> y: #0#>

;;;----------------------------------------------------------------------------

;;; Representation of read environments.

;; A readenv structure maintains the "read environment" throughout the
;; reading of a Scheme datum.  It includes the port from which to read,
;; the readtable, the wrap and unwrap procedures, the table of labels
;; (i.e. "#n#"), and the position where the currently being read datum
;; started.

(define-type readenv
  id: A488CFB0-2CF4-4EEF-A8BE-930FC4CB4AB3
  type-exhibitor: macro-type-readenv
  constructor: macro-make-readenv
  implementer: implement-type-readenv
  macros:
  prefix: macro-
  opaque:
  unprintable:

  port
  readtable
  wrapper
  unwrapper
  script-line
  case-conversion?
  labels
  container
  filepos
  read-cont ;; the continuation of the read procedure
)

(##define-macro (macro-readenv-wrap re x)
  `(let ((re ,re)
         (x ,x))
     ((macro-readenv-wrapper re) re x)))

(##define-macro (macro-readenv-unwrap re x)
  `(let ((re ,re)
         (x ,x))
     ((macro-readenv-unwrapper re) re x)))

;;;----------------------------------------------------------------------------

;;; Generic char port procedures.

(##define-macro (macro-peek-char port)
  `(##peek-char1 ,port))

(##define-macro (macro-read-char port)
  `(##read-char1 ,port))

(##define-macro (macro-write-char c port)
  `(let ((c ,c) (port ,port))
     (or (##write-char2? c port)
         (##write-char2 c port))))

(##define-macro (macro-peek-next-char-or-eof re) ;; possibly returns end-of-file
  `(macro-peek-char (macro-readenv-port ,re)))

(##define-macro (macro-read-next-char-or-eof re) ;; possibly returns end-of-file
  `(macro-read-char (macro-readenv-port ,re)))

;;;----------------------------------------------------------------------------

;;; Representation of readtables.

(define-type readtable
  id: B1E5C9EE-B4F9-4D3C-AACD-FE12D696101F
  type-exhibitor: macro-type-readtable
  constructor: macro-make-readtable
  implementer: implement-type-readtable
  macros:
  prefix: macro-
  opaque:

  (case-conversion?               unprintable: read-write:)
  (keywords-allowed?              unprintable: read-write:)
  (escaped-char-table             unprintable: read-write:)
  (named-char-table               unprintable: read-write:)
  (sharp-bang-table               unprintable: read-write:)
  (char-delimiter?-table          unprintable: read-write:)
  (char-handler-table             unprintable: read-write:)
  (char-sharp-handler-table       unprintable: read-write:)
  (max-unescaped-char             unprintable: read-write:)
  (escape-ctrl-chars?             unprintable: read-write:)
  (sharing-allowed?               unprintable: read-write:)
  (eval-allowed?                  unprintable: read-write:)
  (write-extended-read-macros?    unprintable: read-write:)
  (write-cdr-read-macros?         unprintable: read-write:)
  (max-write-level                unprintable: read-write:)
  (max-write-length               unprintable: read-write:)
  (pretty-print-formats           unprintable: read-write:)
  (quote-keyword                  unprintable: read-write:)
  (quasiquote-keyword             unprintable: read-write:)
  (unquote-keyword                unprintable: read-write:)
  (unquote-splicing-keyword       unprintable: read-write:)
  (sharp-quote-keyword            unprintable: read-write:)
  (sharp-quasiquote-keyword       unprintable: read-write:)
  (sharp-unquote-keyword          unprintable: read-write:)
  (sharp-unquote-splicing-keyword unprintable: read-write:)
  (sharp-num-keyword              unprintable: read-write:)
  (sharp-seq-keyword              unprintable: read-write:)
  (paren-handler                  unprintable: read-write:)
  (bracket-handler                unprintable: read-write:)
  (brace-handler                  unprintable: read-write:)
  (angle-handler                  unprintable: read-write:)
  (start-syntax                   unprintable: read-write:)
  (six-type?                      unprintable: read-write:)
  (r6rs-compatible-read?          unprintable: read-write:)
  (r6rs-compatible-write?         unprintable: read-write:)
  (r7rs-compatible-read?          unprintable: read-write:)
  (r7rs-compatible-write?         unprintable: read-write:)
  (here-strings-allowed?          unprintable: read-write:)
  (dot-at-head-of-list-allowed?   unprintable: read-write:)
  (comment-handler                unprintable: read-write:)
  (foreign-write-handler-table    unprintable: read-write:)
)

(define-check-type readtable (macro-type-readtable)
  macro-readtable?)

;;;----------------------------------------------------------------------------

;;; Representation of language specs.

(##define-macro (macro-language-name x)              `(##vector-ref ,x 0))
(##define-macro (macro-language-case-conversion? x)  `(##vector-ref ,x 1))
(##define-macro (macro-language-keywords-allowed? x) `(##vector-ref ,x 2))
(##define-macro (macro-language-start-syntax x)      `(##vector-ref ,x 3))
(##define-macro (macro-language-srfi-22? x)          `(##vector-ref ,x 4))

;;;============================================================================
