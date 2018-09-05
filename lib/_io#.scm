;;;============================================================================

;;; File: "_io#.scm"

;;; Copyright (c) 1994-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception datum-parsing-exception
  id: 84660e37-9565-4abf-ac09-f9767f926d40
  constructor: #f
  opaque:

  (kind       unprintable: read-only:)
  (readenv    unprintable: read-only:)
  (parameters unprintable: read-only:)
)

(define-library-type-of-exception unterminated-process-exception
  id: b320dfbf-c714-4dc5-8bfa-cac5ee6c8421
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
)

(define-library-type-of-exception nonempty-input-port-character-buffer-exception
  id: 63b50ae7-375b-4b94-81df-3522686f5634
  constructor: #f
  opaque:

  unprintable:
  read-only:

  procedure
  arguments
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
(##define-macro (macro-process-kind)     (+ 31 64))
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

  (name      printable: read-only:)
  (aliases   printable: read-only:)
  (addresses printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of service-info objects.

(define-library-type service-info
  id: 177749b2-beb0-4670-9ab2-4b9c01b54c1d
  constructor: #f

  (name        printable: read-only:)
  (aliases     printable: read-only:)
  (port-number printable: read-only:)
  (protocol    printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of protocol-info objects.

(define-library-type protocol-info
  id: ffc668b5-2146-42b7-ab11-7d91641f2124
  constructor: #f

  (name      printable: read-only:)
  (aliases   printable: read-only:)
  (number    printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of network-info objects.

(define-library-type network-info
  id: ce2e418b-96c7-4562-9cb6-419ec113704e
  constructor: #f

  (name      printable: read-only:)
  (aliases   printable: read-only:)
  (number    printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of socket-info objects.

(define-library-type socket-info
  id: 837d9768-9d27-455e-ac65-5ae59f43f79e
  constructor: #f

  (family      printable: read-only:)
  (port-number printable: read-only:)
  (address     printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of address-info objects.

(define-library-type address-info
  id: f165f359-8685-48da-bc99-f38827ad8af9
  constructor: #f

  (family       printable: read-only:)
  (socket-type  printable: read-only:)
  (protocol     printable: read-only:)
  (socket-info  printable: read-only:)
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
  index
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

(##define-macro (macro-char-encoding-shift)                     1)
(##define-macro (macro-char-encoding-range)                     32)
(##define-macro (macro-default-char-encoding)                   0)
(##define-macro (macro-char-encoding-ASCII)                     1)
(##define-macro (macro-char-encoding-ISO-8859-1)                2)
(##define-macro (macro-char-encoding-UTF-8)                     3)
(##define-macro (macro-char-encoding-UTF-16)                    4)
(##define-macro (macro-char-encoding-UTF-16BE)                  5)
(##define-macro (macro-char-encoding-UTF-16LE)                  6)
(##define-macro (macro-char-encoding-UTF-fallback-ASCII)        7)
(##define-macro (macro-char-encoding-UTF-fallback-ISO-8859-1)   8)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-8)        9)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-16)       10)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-16BE)     11)
(##define-macro (macro-char-encoding-UTF-fallback-UTF-16LE)     12)
(##define-macro (macro-char-encoding-UCS-2)                     13)
(##define-macro (macro-char-encoding-UCS-2BE)                   14)
(##define-macro (macro-char-encoding-UCS-2LE)                   15)
(##define-macro (macro-char-encoding-UCS-4)                     16)
(##define-macro (macro-char-encoding-UCS-4BE)                   17)
(##define-macro (macro-char-encoding-UCS-4LE)                   18)
(##define-macro (macro-char-encoding-wchar)                     19)
(##define-macro (macro-char-encoding-native)                    20)

(##define-macro (macro-char-encoding-UTF)
  `(macro-char-encoding-UTF-fallback-UTF-8))

(##define-macro (macro-char-encoding options)
  `(##fxand (##fxquotient ,options (macro-char-encoding-shift))
            (##fx- (macro-char-encoding-range) 1)))

(##define-macro (macro-char-encoding-set! options value)
  `(set! ,options
         (##fx+ ,options
                (##fx* (macro-char-encoding-shift)
                       (##fx- ,value (macro-char-encoding ,options))))))


(##define-macro (macro-max-unescaped-char options)
  `(let ((e (##fxmodulo (##fxquotient ,options (macro-char-encoding-shift))
                        (macro-char-encoding-range))))
     (cond ((##fx<= e (macro-char-encoding-ISO-8859-1))
            (if (##fx= e (macro-char-encoding-ISO-8859-1))
                (##integer->char #xff)
                (##integer->char #x7f)))
           ((and (##fx>= e (macro-char-encoding-UCS-2))
                 (##fx<= e (macro-char-encoding-UCS-2LE)))
            (##integer->char #xffff))
           (else
            (##integer->char #x10ffff)))))


(##define-macro (macro-char-encoding-errors-shift)   32)
(##define-macro (macro-char-encoding-errors-range)   4)
(##define-macro (macro-default-char-encoding-errors) 0)
(##define-macro (macro-char-encoding-errors-on)      1)
(##define-macro (macro-char-encoding-errors-off)     2)

(##define-macro (macro-char-encoding-errors options)
  `(##fxand (##fxquotient ,options (macro-char-encoding-errors-shift))
            (##fx- (macro-char-encoding-errors-range) 1)))

(##define-macro (macro-char-encoding-errors-set! options value)
  `(set! ,options
         (##fx+ ,options
                (##fx* (macro-char-encoding-errors-shift)
                       (##fx- ,value (macro-char-encoding-errors ,options))))))


(##define-macro (macro-eol-encoding-shift)   128)
(##define-macro (macro-eol-encoding-range)   4)
(##define-macro (macro-default-eol-encoding) 0)
(##define-macro (macro-eol-encoding-lf)      1)
(##define-macro (macro-eol-encoding-cr)      2)
(##define-macro (macro-eol-encoding-crlf)    3)

(##define-macro (macro-eol-encoding options)
  `(##fxand (##fxquotient ,options (macro-eol-encoding-shift))
            (##fx- (macro-eol-encoding-range) 1)))

(##define-macro (macro-eol-encoding-set! options value)
  `(set! ,options
         (##fx+ ,options
                (##fx* (macro-eol-encoding-shift)
                       (##fx- ,value (macro-eol-encoding ,options))))))


(##define-macro (macro-buffering-shift)   512)
(##define-macro (macro-buffering-range)   4)
(##define-macro (macro-default-buffering) 0)
(##define-macro (macro-no-buffering)      1)
(##define-macro (macro-line-buffering)    2)
(##define-macro (macro-full-buffering)    3)

(##define-macro (macro-unbuffered? options)
  `(##fx< (##fxand ,options 2047) 1024))

(##define-macro (macro-fully-buffered? options)
  `(##not (##fx< (##fxand ,options 2047) 1536)))


(##define-macro (macro-decode-state-shift)  2048)
(##define-macro (macro-decode-state-range)  4)
(##define-macro (macro-decode-state-none)   0)
(##define-macro (macro-decode-state-lf)     1)
(##define-macro (macro-decode-state-cr)     2)

(##define-macro (macro-decode-state options)
  `(##fxand (##fxquotient ,options (macro-decode-state-shift))
            (##fx- (macro-decode-state-range) 1)))

(##define-macro (macro-decode-state-set! options value)
  `(set! ,options
         (##fx+ ,options
                (##fx* (macro-decode-state-shift)
                       (##fx- ,value (macro-decode-state ,options))))))


(##define-macro (macro-open-state-shift)  8192)
(##define-macro (macro-open-state-range)  2)
(##define-macro (macro-open-state-open)   0)
(##define-macro (macro-open-state-closed) 1)

(##define-macro (macro-closed? options)
  `(##not (##fx= (##fxand ,options 8192) 0)))

(##define-macro (macro-close! options)
  `(##fxior ,options 8192))

(##define-macro (macro-unclose! options)
  `(##fxand ,options -8193))


(##define-macro (macro-permanent-close-shift)  16384)
(##define-macro (macro-permanent-close-range)  2)
(##define-macro (macro-permanent-close-no)     0)
(##define-macro (macro-permanent-close-yes)    1)

(##define-macro (macro-perm-close? options)
  `(##not (##fx= (##fxand ,options 16384) 0)))


(##define-macro (macro-direction-shift) 16)
(##define-macro (macro-direction-in)    1)
(##define-macro (macro-direction-out)   2)
(##define-macro (macro-direction-inout) 3)


(##define-macro (macro-default-path) #f)

(##define-macro (macro-default-init) #f)

(##define-macro (macro-default-arguments) ''())

(##define-macro (macro-default-environment) #f)

(##define-macro (macro-default-directory) #f)

(##define-macro (macro-append-shift)   8)
(##define-macro (macro-no-append)      0)
(##define-macro (macro-append)         1)
(##define-macro (macro-default-append) 2)

(##define-macro (macro-create-shift)   2)
(##define-macro (macro-no-create)      0)
(##define-macro (macro-maybe-create)   1)
(##define-macro (macro-create)         2)
(##define-macro (macro-default-create) 3)

(##define-macro (macro-truncate-shift)   1)
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

;;; error code construction

(##define-macro (macro-err-code-facility-system)   448)
(##define-macro (macro-err-code-facility-macos)    384)
(##define-macro (macro-err-code-facility-errno)    320)
(##define-macro (macro-err-code-facility-h-errno)  319)
(##define-macro (macro-err-code-facility-gai-code) 318)
(##define-macro (macro-err-code-facility-tls)      317)

(##define-macro (macro-err-code-build facility code)
  `(##fx+ (##fxnot (##fx- (##fxarithmetic-shift 1 29) 1))
          (##fxarithmetic-shift ,facility 16)
          ,code))

(##define-macro (macro-err-base)
  `(macro-err-code-build (macro-err-code-facility-system) 0))

(##define-macro (macro-no-err)                               0)
(##define-macro (macro-unwind-c-stack)                       `(##fx+ (macro-err-base) 0))
(##define-macro (macro-sfun-heap-overflow-err)               `(##fx+ (macro-err-base) 1))
(##define-macro (macro-impl-limit-err)                       `(##fx+ (macro-err-base) 2))
(##define-macro (macro-unknown-err)                          `(##fx+ (macro-err-base) 3))
(##define-macro (macro-unimpl-err)                           `(##fx+ (macro-err-base) 4))
(##define-macro (macro-heap-overflow-err)                    `(##fx+ (macro-err-base) 5))
(##define-macro (macro-closed-device-err)                    `(##fx+ (macro-err-base) 6))
(##define-macro (macro-invalid-op-err)                       `(##fx+ (macro-err-base) 7))
(##define-macro (macro-module-version-too-old-err)           `(##fx+ (macro-err-base) 8))
(##define-macro (macro-module-version-too-new-err)           `(##fx+ (macro-err-base) 9))
(##define-macro (macro-module-already-loaded-err)            `(##fx+ (macro-err-base) 10))
(##define-macro (macro-dynamic-loading-not-available-err)    `(##fx+ (macro-err-base) 11))
(##define-macro (macro-dynamic-loading-lookup-err)           `(##fx+ (macro-err-base) 12))
(##define-macro (macro-kill-pump)                            `(##fx+ (macro-err-base) 13))
(##define-macro (macro-select-setup-done)                    `(##fx+ (macro-err-base) 14))

(##define-macro (macro-stoc-base)                            `(macro-stoc-s8-err))

(##define-macro (macro-stoc-s8-err)                          `(##fx+ (macro-err-base)
                                                                     (##fx* 1 128)))
(##define-macro (macro-stoc-u8-err)                          `(##fx+ (macro-err-base)
                                                                     (##fx* 2 128)))
(##define-macro (macro-stoc-s16-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 3 128)))
(##define-macro (macro-stoc-u16-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 4 128)))
(##define-macro (macro-stoc-s32-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 5 128)))
(##define-macro (macro-stoc-u32-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 6 128)))
(##define-macro (macro-stoc-s64-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 7 128)))
(##define-macro (macro-stoc-u64-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 8 128)))
(##define-macro (macro-stoc-f32-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 9 128)))
(##define-macro (macro-stoc-f64-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 10 128)))
(##define-macro (macro-stoc-char-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 11 128)))
(##define-macro (macro-stoc-schar-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 12 128)))
(##define-macro (macro-stoc-uchar-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 13 128)))
(##define-macro (macro-stoc-ISO-8859-1-err)                  `(##fx+ (macro-err-base)
                                                                     (##fx* 14 128)))
(##define-macro (macro-stoc-UCS-2-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 15 128)))
(##define-macro (macro-stoc-UCS-4-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 16 128)))
(##define-macro (macro-stoc-wchar-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 17 128)))
(##define-macro (macro-stoc-size-t-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 18 128)))
(##define-macro (macro-stoc-ssize-t-err)                     `(##fx+ (macro-err-base)
                                                                     (##fx* 19 128)))
(##define-macro (macro-stoc-ptrdiff-t-err)                   `(##fx+ (macro-err-base)
                                                                     (##fx* 20 128)))
(##define-macro (macro-stoc-short-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 21 128)))
(##define-macro (macro-stoc-ushort-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 22 128)))
(##define-macro (macro-stoc-int-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 23 128)))
(##define-macro (macro-stoc-uint-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 24 128)))
(##define-macro (macro-stoc-long-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 25 128)))
(##define-macro (macro-stoc-ulong-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 26 128)))
(##define-macro (macro-stoc-longlong-err)                    `(##fx+ (macro-err-base)
                                                                     (##fx* 27 128)))
(##define-macro (macro-stoc-ulonglong-err)                   `(##fx+ (macro-err-base)
                                                                     (##fx* 28 128)))
(##define-macro (macro-stoc-float-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 29 128)))
(##define-macro (macro-stoc-double-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 30 128)))
(##define-macro (macro-stoc-struct-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 31 128)))
(##define-macro (macro-stoc-union-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 32 128)))
(##define-macro (macro-stoc-type-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 33 128)))
(##define-macro (macro-stoc-pointer-err)                     `(##fx+ (macro-err-base)
                                                                     (##fx* 34 128)))
(##define-macro (macro-stoc-nonnullpointer-err)              `(##fx+ (macro-err-base)
                                                                     (##fx* 35 128)))
(##define-macro (macro-stoc-function-err)                    `(##fx+ (macro-err-base)
                                                                     (##fx* 36 128)))
(##define-macro (macro-stoc-nonnullfunction-err)             `(##fx+ (macro-err-base)
                                                                     (##fx* 37 128)))
(##define-macro (macro-stoc-bool-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 38 128)))
(##define-macro (macro-stoc-charstring-err)                  `(##fx+ (macro-err-base)
                                                                     (##fx* 39 128)))
(##define-macro (macro-stoc-nonnullcharstring-err)           `(##fx+ (macro-err-base)
                                                                     (##fx* 40 128)))
(##define-macro (macro-stoc-nonnullcharstringlist-err)       `(##fx+ (macro-err-base)
                                                                     (##fx* 41 128)))
(##define-macro (macro-stoc-ISO-8859-1string-err)            `(##fx+ (macro-err-base)
                                                                     (##fx* 42 128)))
(##define-macro (macro-stoc-nonnullISO-8859-1string-err)     `(##fx+ (macro-err-base)
                                                                     (##fx* 43 128)))
(##define-macro (macro-stoc-nonnullISO-8859-1stringlist-err) `(##fx+ (macro-err-base)
                                                                     (##fx* 44 128)))
(##define-macro (macro-stoc-UTF-8string-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 45 128)))
(##define-macro (macro-stoc-nonnullUTF-8string-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 46 128)))
(##define-macro (macro-stoc-nonnullUTF-8stringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 47 128)))
(##define-macro (macro-stoc-UTF-16string-err)                `(##fx+ (macro-err-base)
                                                                     (##fx* 48 128)))
(##define-macro (macro-stoc-nonnullUTF-16string-err)         `(##fx+ (macro-err-base)
                                                                     (##fx* 49 128)))
(##define-macro (macro-stoc-nonnullUTF-16stringlist-err)     `(##fx+ (macro-err-base)
                                                                     (##fx* 50 128)))
(##define-macro (macro-stoc-UCS-2string-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 51 128)))
(##define-macro (macro-stoc-nonnullUCS-2string-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 52 128)))
(##define-macro (macro-stoc-nonnullUCS-2stringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 53 128)))
(##define-macro (macro-stoc-UCS-4string-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 54 128)))
(##define-macro (macro-stoc-nonnullUCS-4string-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 55 128)))
(##define-macro (macro-stoc-nonnullUCS-4stringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 56 128)))
(##define-macro (macro-stoc-wcharstring-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 57 128)))
(##define-macro (macro-stoc-nonnullwcharstring-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 58 128)))
(##define-macro (macro-stoc-nonnullwcharstringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 59 128)))
(##define-macro (macro-stoc-variant-err)                     `(##fx+ (macro-err-base)
                                                                     (##fx* 60 128)))
(##define-macro (macro-stoc-heap-overflow-err)               `(##fx+ (macro-err-base)
                                                                     (##fx* 61 128)))
(##define-macro (macro-stoc-max)                             `(##fx+ (macro-err-base)
                                                                     (##fx- (##fx* 62 128)
                                                                            1)))

(##define-macro (macro-ctos-base)                            `(macro-ctos-s8-err))

(##define-macro (macro-ctos-s8-err)                          `(##fx+ (macro-err-base)
                                                                     (##fx* 65 128)))
(##define-macro (macro-ctos-u8-err)                          `(##fx+ (macro-err-base)
                                                                     (##fx* 66 128)))
(##define-macro (macro-ctos-s16-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 67 128)))
(##define-macro (macro-ctos-u16-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 68 128)))
(##define-macro (macro-ctos-s32-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 69 128)))
(##define-macro (macro-ctos-u32-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 70 128)))
(##define-macro (macro-ctos-s64-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 71 128)))
(##define-macro (macro-ctos-u64-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 72 128)))
(##define-macro (macro-ctos-f32-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 73 128)))
(##define-macro (macro-ctos-f64-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 74 128)))
(##define-macro (macro-ctos-char-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 75 128)))
(##define-macro (macro-ctos-schar-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 76 128)))
(##define-macro (macro-ctos-uchar-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 77 128)))
(##define-macro (macro-ctos-ISO-8859-1-err)                  `(##fx+ (macro-err-base)
                                                                     (##fx* 78 128)))
(##define-macro (macro-ctos-UCS-2-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 79 128)))
(##define-macro (macro-ctos-UCS-4-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 80 128)))
(##define-macro (macro-ctos-wchar-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 81 128)))
(##define-macro (macro-ctos-size-t-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 82 128)))
(##define-macro (macro-ctos-ssize-t-err)                     `(##fx+ (macro-err-base)
                                                                     (##fx* 83 128)))
(##define-macro (macro-ctos-ptrdiff-t-err)                   `(##fx+ (macro-err-base)
                                                                     (##fx* 84 128)))
(##define-macro (macro-ctos-short-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 85 128)))
(##define-macro (macro-ctos-ushort-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 86 128)))
(##define-macro (macro-ctos-int-err)                         `(##fx+ (macro-err-base)
                                                                     (##fx* 87 128)))
(##define-macro (macro-ctos-uint-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 88 128)))
(##define-macro (macro-ctos-long-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 89 128)))
(##define-macro (macro-ctos-ulong-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 90 128)))
(##define-macro (macro-ctos-longlong-err)                    `(##fx+ (macro-err-base)
                                                                     (##fx* 91 128)))
(##define-macro (macro-ctos-ulonglong-err)                   `(##fx+ (macro-err-base)
                                                                     (##fx* 92 128)))
(##define-macro (macro-ctos-float-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 93 128)))
(##define-macro (macro-ctos-double-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 94 128)))
(##define-macro (macro-ctos-struct-err)                      `(##fx+ (macro-err-base)
                                                                     (##fx* 95 128)))
(##define-macro (macro-ctos-union-err)                       `(##fx+ (macro-err-base)
                                                                     (##fx* 96 128)))
(##define-macro (macro-ctos-type-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 97 128)))
(##define-macro (macro-ctos-pointer-err)                     `(##fx+ (macro-err-base)
                                                                     (##fx* 98 128)))
(##define-macro (macro-ctos-nonnullpointer-err)              `(##fx+ (macro-err-base)
                                                                     (##fx* 99 128)))
(##define-macro (macro-ctos-function-err)                    `(##fx+ (macro-err-base)
                                                                     (##fx* 100 128)))
(##define-macro (macro-ctos-nonnullfunction-err)             `(##fx+ (macro-err-base)
                                                                     (##fx* 101 128)))
(##define-macro (macro-ctos-bool-err)                        `(##fx+ (macro-err-base)
                                                                     (##fx* 102 128)))
(##define-macro (macro-ctos-charstring-err)                  `(##fx+ (macro-err-base)
                                                                     (##fx* 103 128)))
(##define-macro (macro-ctos-nonnullcharstring-err)           `(##fx+ (macro-err-base)
                                                                     (##fx* 104 128)))
(##define-macro (macro-ctos-nonnullcharstringlist-err)       `(##fx+ (macro-err-base)
                                                                     (##fx* 105 128)))
(##define-macro (macro-ctos-ISO-8859-1string-err)            `(##fx+ (macro-err-base)
                                                                     (##fx* 106 128)))
(##define-macro (macro-ctos-nonnullISO-8859-1string-err)     `(##fx+ (macro-err-base)
                                                                     (##fx* 107 128)))
(##define-macro (macro-ctos-nonnullISO-8859-1stringlist-err) `(##fx+ (macro-err-base)
                                                                     (##fx* 108 128)))
(##define-macro (macro-ctos-UTF-8string-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 109 128)))
(##define-macro (macro-ctos-nonnullUTF-8string-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 110 128)))
(##define-macro (macro-ctos-nonnullUTF-8stringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 111 128)))
(##define-macro (macro-ctos-UTF-16string-err)                `(##fx+ (macro-err-base)
                                                                     (##fx* 112 128)))
(##define-macro (macro-ctos-nonnullUTF-16string-err)         `(##fx+ (macro-err-base)
                                                                     (##fx* 113 128)))
(##define-macro (macro-ctos-nonnullUTF-16stringlist-err)     `(##fx+ (macro-err-base)
                                                                     (##fx* 114 128)))
(##define-macro (macro-ctos-UCS-2string-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 115 128)))
(##define-macro (macro-ctos-nonnullUCS-2string-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 116 128)))
(##define-macro (macro-ctos-nonnullUCS-2stringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 117 128)))
(##define-macro (macro-ctos-UCS-4string-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 118 128)))
(##define-macro (macro-ctos-nonnullUCS-4string-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 119 128)))
(##define-macro (macro-ctos-nonnullUCS-4stringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 120 128)))
(##define-macro (macro-ctos-wcharstring-err)                 `(##fx+ (macro-err-base)
                                                                     (##fx* 121 128)))
(##define-macro (macro-ctos-nonnullwcharstring-err)          `(##fx+ (macro-err-base)
                                                                     (##fx* 122 128)))
(##define-macro (macro-ctos-nonnullwcharstringlist-err)      `(##fx+ (macro-err-base)
                                                                     (##fx* 123 128)))
(##define-macro (macro-ctos-variant-err)                     `(##fx+ (macro-err-base)
                                                                     (##fx* 124 128)))
(##define-macro (macro-ctos-heap-overflow-err)               `(##fx+ (macro-err-base)
                                                                     (##fx* 125 128)))
(##define-macro (macro-ctos-max)                             `(##fx+ (macro-err-base)
                                                                     (##fx- (##fx* 126 128)
                                                                            1)))

(##define-macro (macro-return-pos)                           127)

;;;----------------------------------------------------------------------------

;;; error code macros

(##define-macro (macro-conversion-done)       0)
(##define-macro (macro-incomplete-char)       1)
(##define-macro (macro-illegal-char)          2)

;;; char-eol macro

(##define-macro (macro-char-eol)              `(macro-unicode-linefeed))

;;; unicode character macros

(##define-macro (macro-unicode-linefeed)      10)
(##define-macro (macro-unicode-return)        13)
(##define-macro (macro-unicode-question)      63)
(##define-macro (macro-unicode-replacement)   #xfffd)

;;; char-encoding-supports-bmp macro

(##define-macro (macro-char-encoding-supports-BMP x)
  `(and (##fx>= ,x (macro-char-encoding-UTF-8))
        (##fx<= ,x (macro-char-encoding-UCS-4LE))))

;;; bytes-per-encoding macros

(##define-macro (macro-bytes-per-ISO-8859-1)  1)
(##define-macro (macro-max-ISO-8859-1)        #xff)

(##define-macro (macro-bytes-per-UTF-8)       1) ;; optimization for 1 byte case
(##define-macro (macro-max-UTF-8)             #x7f)

(##define-macro (macro-bytes-per-UTF-16)      2) ;; optimization for 2 byte case
(##define-macro (macro-max-UTF-16)            #x10ffff)

(##define-macro (macro-bytes-per-UCS-2)       2)
(##define-macro (macro-max-UCS-2)             #xffff)

(##define-macro (macro-bytes-per-UCS-4)       4)
(##define-macro (macro-max-UCS-4)             #x7fffffff)

(##define-macro (macro-max-char)              #x10ffff)

;;;

(##define-macro (macro-unicode-BOM)           #xfeff)

;;; get-char/put-char macros

(##define-macro (macro-get-ISO-8859-1 i)
  `(##u8vector-ref bbuf (##fx+ blo (##fx* ,i (macro-bytes-per-ISO-8859-1)))))

(##define-macro (macro-get-UTF-8 i)
  `(##u8vector-ref bbuf (##fx+ blo (##fx* ,i (macro-bytes-per-UTF-8)))))

(##define-macro (macro-get-UTF-16BE i)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UTF-16)))))
     (##fx+ (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 0)) 8)
            (##u8vector-ref bbuf (##fx+ index 1)))))

(##define-macro (macro-get-UTF-16LE i)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UTF-16)))))
     (##fx+ (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 1)) 8)
            (##u8vector-ref bbuf (##fx+ index 0)))))

(##define-macro (macro-get-UCS-2BE i)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-2)))))
     (##fx+ (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 0)) 8)
            (##u8vector-ref bbuf (##fx+ index 1)))))

(##define-macro (macro-get-UCS-2LE i)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-2)))))
     (##fx+ (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 1)) 8)
            (##u8vector-ref bbuf (##fx+ index 0)))))

(##define-macro (macro-get-UCS-4BE i)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-4)))))
     (##fx+ (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 0)) 24)
            (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 1)) 16)
            (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 2)) 8)
            (##u8vector-ref bbuf (##fx+ index 3)))))

(##define-macro (macro-get-UCS-4LE i)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-4)))))
     (##fx+ (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 3)) 24)
            (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 2)) 16)
            (##fxarithmetic-shift (##u8vector-ref bbuf (##fx+ index 1)) 8)
            (##u8vector-ref bbuf (##fx+ index 0)))))

(##define-macro (macro-put-ISO-8859-1 i c)
  `(##u8vector-set! bbuf (##fx+ blo (##fx* ,i (macro-bytes-per-ISO-8859-1))) ,c))

(##define-macro (macro-put-UTF-8 i c)
  `(##u8vector-set! bbuf (##fx+ blo (##fx* ,i (macro-bytes-per-UTF-8))) ,c))

(##define-macro (macro-put-UTF-16BE i c)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UTF-16)))))
     (##u8vector-set! bbuf (##fx+ index 1) (##fxand ,c #xff))
     (##u8vector-set! bbuf (##fx+ index 0) (##fxand (##fxarithmetic-shift ,c -8) #xff))))

(##define-macro (macro-put-UTF-16LE i c)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UTF-16)))))
     (##u8vector-set! bbuf (##fx+ index 0) (##fxand ,c #xff))
     (##u8vector-set! bbuf (##fx+ index 1) (##fxand (##fxarithmetic-shift ,c -8) #xff))))

(##define-macro (macro-put-UCS-2BE i c)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-2)))))
     (##u8vector-set! bbuf (##fx+ index 1) (##fxand ,c #xff))
     (##u8vector-set! bbuf (##fx+ index 0) (##fxand (##fxarithmetic-shift ,c -8) #xff))))

(##define-macro (macro-put-UCS-2LE i c)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-2)))))
     (##u8vector-set! bbuf (##fx+ index 0) (##fxand ,c #xff))
     (##u8vector-set! bbuf (##fx+ index 1) (##fxand (##fxarithmetic-shift ,c -8) #xff))))

(##define-macro (macro-put-UCS-4BE i c)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-4)))))
     (##u8vector-set! bbuf (##fx+ index 3) (##fxand ,c #xff))
     (##u8vector-set! bbuf (##fx+ index 2) (##fxand (##fxarithmetic-shift ,c -8) #xff))
     (##u8vector-set! bbuf (##fx+ index 1) (##fxand (##fxarithmetic-shift ,c -16) #xff))
     (##u8vector-set! bbuf (##fx+ index 0) (##fxand (##fxarithmetic-shift ,c -24) #xff))))

(##define-macro (macro-put-UCS-4LE i c)
  `(let ((index (##fx+ blo (##fx* ,i (macro-bytes-per-UCS-4)))))
     (##u8vector-set! bbuf (##fx+ index 0) (##fxand ,c #xff))
     (##u8vector-set! bbuf (##fx+ index 1) (##fxand (##fxarithmetic-shift ,c -8) #xff))
     (##u8vector-set! bbuf (##fx+ index 2) (##fxand (##fxarithmetic-shift ,c -16) #xff))
     (##u8vector-set! bbuf (##fx+ index 3) (##fxand (##fxarithmetic-shift ,c -24) #xff))))

;;;----------------------------------------------------------------------------

;;; macros for char decoding

(##define-macro (macro-decode-char
                 new-decode-state
                 loop-label)
  `(begin
     (macro-decode-state-set! state ,new-decode-state)
     (##string-set! cbuf clo c)
     (set! clo (##fx+ clo 1))
     (if (##fx< clo chi)
         (,loop-label))))


(##define-macro (macro-restore-blo
                 current-blo
                 byte-cnt)
  `(if (##fx= (##fx- ,current-blo ,byte-cnt) blo-save)
       (set! result (macro-illegal-char))
       (set! blo (##fx- ,current-blo ,byte-cnt))))


(##define-macro (macro-get-decode-char-encoding
                 macro-get-char-BE
                 char-encoding-BE
                 char-encoding-LE
                 bytes-per-char)
  `(begin
     (set! blo (##fx+ blo ,bytes-per-char))
     (if (##fx<= blo bhi)
         (let* ((c
                 (##char->integer (,macro-get-char-BE -1)))
                (cle
                 (let ((shift-24 (##fxarithmetic-shift 1 24))
                       (shift-16 (##fxarithmetic-shift 1 16))
                       (shift-8 (##fxarithmetic-shift 1 8)))
                   (if (##fx> ,bytes-per-char 2)
                       (##fx+ (##fx* (##fxand c #xff) shift-24)
                              (##fx* (##fxand (##fxarithmetic-shift c -8) #xff) shift-16)
                              (##fx* (##fxand (##fxarithmetic-shift c -16) #xff) shift-8)
                              (##fxand (##fxarithmetic-shift c -24) #xff))
                       (##fx+ (##fx* (##fxand c #xff) shift-8)
                              (##fxand (##fxarithmetic-shift c -8) #xff)))))
                (char-encoding
                 (cond ((##fx= c (macro-unicode-BOM))
                        ,char-encoding-BE)
                       ((##fx= cle (macro-unicode-BOM))
                        ,char-encoding-LE)
                       (else
                        (set! blo (##fx- blo ,bytes-per-char))
                        ,char-encoding-LE))))
           (macro-char-encoding-set! state char-encoding)
           (dispatch-on-char-encoding char-encoding))
         (begin
           (set! blo (##fx- blo ,bytes-per-char))
           (if (and (##fx> ,bytes-per-char 1)
                    (##fx= blo blo-save))
               (set! result (macro-incomplete-char)))))))


(##define-macro (macro-decode-eol-end loop-label)
  `(begin
     (##string-set! cbuf clo c)
     (set! clo (##fx+ clo 1))
     (if (##fx< clo chi)
         (,loop-label))))


(##define-macro (macro-decode-eol loop-label)
  
  `(let ((eol (macro-eol-encoding state))
         (rs (macro-decode-state state)))
     
     (if (##fx= c (macro-unicode-linefeed))

         (cond ((##fx= eol (macro-eol-encoding-cr))
                (macro-decode-eol-end ,loop-label))
               ((##fx= eol (macro-eol-encoding-lf))
                (begin
                  (set! c (macro-char-eol))
                  (macro-decode-eol-end ,loop-label)))
               ((##fx= rs (macro-decode-state-cr))
                (begin
                  (macro-decode-state-set! state (macro-decode-state-none))
                  (,loop-label)))
               (else
                (begin
                  (macro-decode-state-set! state (macro-decode-state-lf))
                  (set! c (macro-char-eol))
                  (macro-decode-eol-end ,loop-label))))

         (if (##fx= c (macro-unicode-return))
             (cond ((##fx= eol (macro-eol-encoding-lf))
                    (macro-decode-eol-end ,loop-label))
                   ((##fx= eol (macro-eol-encoding-cr))
                    (begin
                      (set! c (macro-char-eol))
                      (macro-decode-eol-end ,loop-label)))
                   ((##fx= rs (macro-decode-state-lf))
                    (begin
                      (macro-decode-state-set! state (macro-decode-state-none))
                      (,loop-label)))
                   (else
                    (begin
                      (macro-decode-state-set! state (macro-decode-state-cr))
                      (set! c (macro-char-eol))
                      (macro-decode-eol-end ,loop-label))))
             (begin
               (macro-decode-state-set! state (macro-decode-state-none))
               (macro-decode-eol-end ,loop-label))))))


(##define-macro (macro-decode-chars-loop
                 loop-label
                 bytes-per-char
                 max-char
                 macro-get-char)
  
  `(let ,loop-label ()
        (begin
          (set! blo (##fx+ blo ,bytes-per-char))
          (if (##fx<= blo bhi)
              (begin
                (set! c (,macro-get-char -1))
                (if (##char? c)
                    (set! c (##char->integer c)))
                (cond ((or (##fx<= ,max-char (macro-max-char))
                           (##fx<= c (macro-max-char)))
                       (macro-decode-eol ,loop-label))
                      ((##fx= (##fx- blo ,bytes-per-char) blo-save)
                       (set! result (macro-illegal-char)))
                      (else
                       (set! blo (##fx- blo ,bytes-per-char)))))
              (begin
                (set! blo (##fx- blo ,bytes-per-char))
                (if (and (##fx> ,bytes-per-char 1)
                         (##fx= blo blo-save))
                    (set! result (macro-incomplete-char))))))))

;;;----------------------------------------------------------------------------

;;; macros for char encoding

(##define-macro (macro-get-encode-char-encoding
                 macro-put-char-BE
                 macro-put-char-LE
                 char-encoding-BE
                 char-encoding-LE
                 bytes-per-char)
  `(begin
     (set! blo (##fx+ blo ,bytes-per-char))
     (if (##fx> blo bhi)
         (set! blo (##fx- blo ,bytes-per-char))
         (begin
           (,macro-put-char-LE -1 (macro-unicode-BOM))
           (macro-char-encoding-set! state ,char-encoding-LE)
           (dispatch-on-char-encoding ,char-encoding-LE)))))


(##define-macro (macro-encode-eol
                 loop-label
                 bytes-per-char
                 macro-put-char)
  
  `(let ((eol (macro-eol-encoding state)))
     (begin
       (cond ((##fx= eol (macro-eol-encoding-cr))
              (,macro-put-char -1 (macro-unicode-return)))
             ((##fx= eol (macro-eol-encoding-crlf))
              (begin
                (set! blo (##fx+ blo ,bytes-per-char))
                (if (##fx> blo bhi)
                    (begin
                      (set! blo (##fx- blo (##fx* 2 ,bytes-per-char)))
                      (set! clo (##fx- clo 1)))
                    (begin
                      (,macro-put-char -2 (macro-unicode-return))
                      (,macro-put-char -1 (macro-unicode-linefeed))))))
             (else
              (,macro-put-char -1 (macro-unicode-linefeed))))
       (if (and (macro-fully-buffered? state)
                (##fx< clo chi))
           (,loop-label)))))


(##define-macro (macro-encode-chars-loop
                 loop-label
                 bytes-per-char
                 max-char
                 macro-put-char)
  
  `(let ,loop-label ()
        (begin
          (set! c (##char->integer (##string-ref cbuf clo)))
          (set! clo (##fx+ clo 1))
          
          (if (or (##fx<= (macro-max-char) ,max-char)
                  (##fx<= c ,max-char))
              
              (begin
                (set! blo (##fx+ blo ,bytes-per-char))
                (if (##fx<= blo bhi)
                    
                    (if (##not (##fx= c (macro-char-eol)))
                        
                        (begin
                          (,macro-put-char -1 c)
                          (if (##fx< clo chi)
                              (,loop-label)))

                        (macro-encode-eol ,loop-label
                                          ,bytes-per-char
                                          ,macro-put-char))
                    
                    (begin
                      (set! blo (##fx- blo ,bytes-per-char))
                      (set! clo (##fx- clo 1)))))
              
              (begin
                (set! clo (##fx- clo 1))
                (if (##fx= clo clo-save)
                    (set! result (macro-illegal-char))))))))

;;;----------------------------------------------------------------------------

;;; Representation of write environments.

;; A writeenv structure maintains the "write environment" throughout
;; the writing of a Scheme datum.  It includes the write style
;; (display, write, pretty-print, mark), the port on which to write,
;; the readtable, the marktable (for detecting cycles), the force flag,
;; the pretty-print width, the number of closing parentheses to follow
;; the datum, the current nesting level, and the character count limit.

(define-type writeenv
  id: f5cfcf78-bba4-4140-9aa0-1a136c50d36b
  type-exhibitor: macro-type-writeenv
  constructor: macro-make-writeenv
  implementer: implement-type-writeenv
  macros:
  prefix: macro-
  opaque:
  unprintable:

  style
  port
  readtable
  marktable
  force?
  width
  shift
  close-parens
  level
  limit
  max-unescaped-char
)

;;;----------------------------------------------------------------------------

;;; Representation of read environments.

;; A readenv structure maintains the "read environment" throughout the
;; reading of a Scheme datum.  It includes the port from which to read,
;; the readtable, the wrap and unwrap procedures, the table of labels
;; (i.e. "#n#"), and the position where the currently being read datum
;; started.

(define-type readenv
  id: edd21ef2-ee48-407f-a9a9-c1c361078e55
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
  allow-script?
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
  `(let ((port ,port))

     (##declare (not interrupts-enabled))

     ;; try to get exclusive access to port and if successful perform
     ;; operation inline

     (if (macro-port-mutex-unlocked-not-abandoned-and-not-multiprocessor? port)

       (let ((char-rlo (macro-character-port-rlo port))
             (char-rhi (macro-character-port-rhi port)))
         (if (##fx< char-rlo char-rhi)

           ;; the next character is in the character read buffer

           (##string-ref (macro-character-port-rbuf port) char-rlo)

           ;; more characters are needed, do this out-of-line

           (let ()
             (##declare (interrupts-enabled))
             (##peek-char port))))

       ;; couldn't easily get exclusive access to port, handle this out-of-line

       (let ()
         (##declare (interrupts-enabled))
         (##peek-char port)))))

(##define-macro (macro-read-char port)
  `(let ((port ,port))

     (##declare (not interrupts-enabled))

     ;; try to get exclusive access to port and if successful perform
     ;; operation inline

     (if (macro-port-mutex-unlocked-not-abandoned-and-not-multiprocessor? port)

       (let ((char-rlo (macro-character-port-rlo port))
             (char-rhi (macro-character-port-rhi port)))
         (if (##fx< char-rlo char-rhi)

           ;; the next character is in the character read buffer

           (let ((c (##string-ref (macro-character-port-rbuf port) char-rlo)))
             (if (##not (##char=? c #\newline))

               ;; frequent simple case, just advance rlo

               (begin
                 (macro-character-port-rlo-set! port (##fx+ char-rlo 1))
                 c)

               ;; end-of-line processing is complex, so do it out-of-line

               (let ()
                 (##declare (interrupts-enabled))
                 (##read-char port))))

           ;; more characters are needed, do this out-of-line

           (let ()
             (##declare (interrupts-enabled))
             (##read-char port))))

       ;; couldn't easily get exclusive access to port, handle this out-of-line

       (let ()
         (##declare (interrupts-enabled))
         (##read-char port)))))

(##define-macro (macro-write-char c port)
  `(let ((c ,c)
         (port ,port))

     (##declare (not interrupts-enabled))

     ;; try to get exclusive access to port and if successful perform
     ;; operation inline

     (if (and (##not (##char=? c #\newline))
              (macro-port-mutex-unlocked-not-abandoned-and-not-multiprocessor? port))

       (let ((char-wbuf (macro-character-port-wbuf port))
             (char-whi+1 (##fx+ (macro-character-port-whi port) 1)))
         (if (##fx< char-whi+1 (##string-length char-wbuf))

           ;; adding this character would not make the character write
           ;; buffer full, so add character and increment whi

           (begin
             (##string-set! char-wbuf (##fx- char-whi+1 1) c)
             (macro-character-port-whi-set! port char-whi+1)
             (##void))

           ;; the character write buffer would become full, so handle
           ;; this out-of-line

           (let ()
             (##declare (interrupts-enabled))
             (##write-char c port))))

       ;; end-of-line processing is needed or exclusive access to port
       ;; cannot be obtained easily, so handle this out-of-line

       (let ()
         (##declare (interrupts-enabled))
         (##write-char c port)))))

(##define-macro (macro-peek-next-char-or-eof re) ;; possibly returns end-of-file
  `(macro-peek-char (macro-readenv-port ,re)))

(##define-macro (macro-read-next-char-or-eof re) ;; possibly returns end-of-file
  `(macro-read-char (macro-readenv-port ,re)))

;;;----------------------------------------------------------------------------

;;; Representation of readtables.

(define-type readtable
  id: bebee95d-0da2-401d-a33a-c1afc75b9e43
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
  (paren-keyword                  unprintable: read-write:)
  (bracket-keyword                unprintable: read-write:)
  (brace-keyword                  unprintable: read-write:)
  (angle-keyword                  unprintable: read-write:)
  (start-syntax                   unprintable: read-write:)
  (six-type?                      unprintable: read-write:)
  (r6rs-compatible-read?          unprintable: read-write:)
  (r6rs-compatible-write?         unprintable: read-write:)
  (here-strings-allowed?          unprintable: read-write:)
  (dot-at-head-of-list-allowed?   unprintable: read-write:)
  (comment-handler                unprintable: read-write:)
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
