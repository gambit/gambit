;;;============================================================================

;;; File: "_io#.scm", Time-stamp: <2007-12-19 09:39:44 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

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

;; There are 5 kinds of ports, each providing a set of operations.  All
;; port objects have the capability of being both an input port and an
;; output port.  The "none-port" kind provides no operation and is
;; mainly for internal use to indicate that no input operation is
;; available or that no output operation is available.
;;
;; 1) An "object-port" (or simply a "port") provides operations to read
;;    and write Scheme data (i.e. any Scheme object) to/from the port.
;;    It also provides operations to get the name of the port, to force
;;    output to occur, and to close the port.  This kind of port need
;;    not be connected to a character based device or file (it could
;;    for example be a FIFO queue linking two threads that need to
;;    communicate Scheme objects).
;;
;; 2) A "character-port" provides all the operations of an "object-port",
;;    and also operations to read and write individual characters
;;    to/from the port.  When a Scheme object is written to a
;;    character-port, it is converted into the sequence of characters that
;;    corresponds to its "external-representation".  When reading a
;;    Scheme object, an inverse conversion occurs.
;;
;; 3) A "byte-port" provides all the operations of a "character-port", and
;;    also operations to read and write individual bytes to/from the
;;    port.  When a **character** is written to a byte-port, some
;;    encoding of that character into a sequence of bytes will occur
;;    (for example, #\newline might be encoded as the 2 bytes CR-LF
;;    when using ISO-8859-1 encoding, or a non-ASCII character will
;;    generate more than 1 byte when using UTF-8 encoding).  When
;;    reading a character, a similar decoding occurs.
;;
;; 4) A "device-port" provides all the operations of a "byte-port", and
;;    also operations to control the device (file, tty, etc) that is
;;    connected to the port, such as changing the tty settings.

(define-type port
  id: 2babe060-9af6-456f-a26e-40b592f690ec
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
  read-datum         ;; procedure to read a datum
  write-datum        ;; procedure to write a datum
  newline            ;; procedure to write a datum separator
  force-output       ;; procedure to force output to occur on target device
  close              ;; procedure to close the port
  roptions           ;; options for reading (buffering type, encoding, etc)
  rtimeout           ;; time at which a read that would block times out
  rtimeout-thunk     ;; thunk called when a read timeout occurs
  set-rtimeout       ;; procedure to set rtimeout and rtimeout-thunk
  woptions           ;; options for writing (buffering type, encoding, etc)
  wtimeout           ;; time at which a write that would block times out
  wtimeout-thunk     ;; thunk called when a write timeout occurs
  set-wtimeout       ;; procedure to set wtimeout and wtimeout-thunk
)

(define-check-type port (macro-type-port)
  macro-port?)

(##define-macro (macro-port-of-rkind? obj kind)
  `(let ((obj ,obj))
     (and (macro-port? obj)
          (##fixnum.= (##fixnum.bitwise-and (macro-port-rkind obj) ,kind)
                      ,kind))))

(##define-macro (macro-port-of-wkind? obj kind)
  `(let ((obj ,obj))
     (and (macro-port? obj)
          (##fixnum.= (##fixnum.bitwise-and (macro-port-wkind obj) ,kind)
                      ,kind))))

(##define-macro (macro-none-kind)      0) ;; allows nothing
(##define-macro (macro-object-kind)    1) ;; can read and write objects
(##define-macro (macro-character-kind) 3) ;; can also read and write chars
(##define-macro (macro-byte-kind)      7) ;; can also read and write bytes
(##define-macro (macro-device-kind)   15) ;; can also do device operations

(##define-macro (macro-file-kind)        (+ 15 16))
(##define-macro (macro-process-kind)     (+ 15 32))
(##define-macro (macro-tty-kind)         (+ 15 64))
(##define-macro (macro-serial-kind)      (+ 15 128))
(##define-macro (macro-tcp-client-kind)  (+ 15 256))
(##define-macro (macro-tcp-server-kind)  (+ 1 512))
(##define-macro (macro-directory-kind)   (+ 1 1024))
(##define-macro (macro-event-queue-kind) (+ 1 2048))
(##define-macro (macro-timer-kind)       (+ 1 4096))
(##define-macro (macro-vector-kind)      (+ 1 8192))
(##define-macro (macro-string-kind)      (+ 3 16384))
(##define-macro (macro-u8vector-kind)    (+ 7 32768))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of object ports.

(define-check-type input-port 'input-port
  macro-input-port?)
(define-check-type output-port 'output-port
  macro-output-port?)

(##define-macro (macro-input-port? obj)
  `(macro-port-of-rkind? ,obj (macro-object-kind)))

(##define-macro (macro-output-port? obj)
  `(macro-port-of-wkind? ,obj (macro-object-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of char ports.

(define-check-type character-input-port 'character-input-port
  macro-character-input-port?)
(define-check-type character-output-port 'character-output-port
  macro-character-output-port?)

(define-type-of-port character-port
  id: 85099702-35ec-4cb8-ae55-13c4b9b05d10
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
  id: 8a99028e-7b99-4468-b94e-728737ec1b1a
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
  id: b4fa842f-5da6-43b6-b447-d0b0348ae962
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


(define-type-of-port vector-port
  id: 2fb9e1fc-693b-455f-94a2-70c617a304d1
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
  id: 81e73361-b03c-4889-9d02-e340e3309934
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
  id: 04c1b0ae-b11f-4815-b206-ce01648675bd
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
  opaque:

  (name      printable: read-only:)
  (aliases   printable: read-only:)
  (addresses printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of service-info objects.

(define-library-type service-info
  id: 177749b2-beb0-4670-9ab2-4b9c01b54c1d
  constructor: #f
  opaque:

  (name      printable: read-only:)
  (aliases   printable: read-only:)
  (port      printable: read-only:)
  (protocol  printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of protocol-info objects.

(define-library-type protocol-info
  id: ffc668b5-2146-42b7-ab11-7d91641f2124
  constructor: #f
  opaque:

  (name      printable: read-only:)
  (aliases   printable: read-only:)
  (number    printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of network-info objects.

(define-library-type network-info
  id: ce2e418b-96c7-4562-9cb6-419ec113704e
  constructor: #f
  opaque:

  (name      printable: read-only:)
  (aliases   printable: read-only:)
  (net       printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of socket-info objects.

(define-library-type socket-info
  id: 837d9768-9d27-455e-ac65-5ae59f43f79e
  constructor: #f
  opaque:

  (family      printable: read-only:)
  (port-number printable: read-only:)
  (address     printable: read-only:)
)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of TCP client device ports.

(define-check-type tcp-client-port 'tcp-client-port
  macro-tcp-client-port?)

(##define-macro (macro-tcp-client-port? obj)
  `(##port-of-kind? ,obj (macro-tcp-client-kind)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

;;; Representation of TCP server ports.

(define-type-of-port tcp-server-port
  id: 42696abb-6729-4637-99de-cef7d3a230ae
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

(define-type-of-port directory-port
  id: deebf606-97e4-4d34-8fed-b9e5468851b9
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

(define-type-of-port event-queue-port
  id: 59109ed7-6339-4c6e-8bc2-f52e9c91b9f5
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
  id: 0b02934e-7c23-4f9e-a629-0eede16e6987
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
  server-address
  port-number
  socket-type
  coalesce
  keep-alive
  backlog
  reuse-address
  broadcast
  ignore-hidden
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
  eol-encoding
  buffering
  permanent-close
)

(##define-macro (macro-default-readtable) #f)

(##define-macro (macro-char-encoding-shift)      1)
(##define-macro (macro-char-encoding-range)      16)
(##define-macro (macro-default-char-encoding)    0)
(##define-macro (macro-char-encoding-ASCII)      1)
(##define-macro (macro-char-encoding-ISO-8859-1) 2)
(##define-macro (macro-char-encoding-UTF-8)      3)
(##define-macro (macro-char-encoding-UTF-16)     4)
(##define-macro (macro-char-encoding-UTF-16LE)   5)
(##define-macro (macro-char-encoding-UTF-16BE)   6)
(##define-macro (macro-char-encoding-UCS-2)      7)
(##define-macro (macro-char-encoding-UCS-2LE)    8)
(##define-macro (macro-char-encoding-UCS-2BE)    9)
(##define-macro (macro-char-encoding-UCS-4)      10)
(##define-macro (macro-char-encoding-UCS-4LE)    11)
(##define-macro (macro-char-encoding-UCS-4BE)    12)
(##define-macro (macro-char-encoding-wchar)      13)
(##define-macro (macro-char-encoding-native)     14)

(##define-macro (macro-eol-encoding-shift)   16)
(##define-macro (macro-eol-encoding-range)   8)
(##define-macro (macro-default-eol-encoding) 0)
(##define-macro (macro-eol-encoding-lf)      1)
(##define-macro (macro-eol-encoding-cr)      2)
(##define-macro (macro-eol-encoding-crlf)    3)

(##define-macro (macro-decode-state-shift)  128)
(##define-macro (macro-decode-state-range)  3)
(##define-macro (macro-decode-state-none)   0)
(##define-macro (macro-decode-state-lf)     1)
(##define-macro (macro-decode-state-cr)     2)

(##define-macro (macro-open-state-shift)  512)
(##define-macro (macro-open-state-range)  2)
(##define-macro (macro-open-state-open)   0)
(##define-macro (macro-open-state-closed) 1)

(##define-macro (macro-closed? options)
  `(##not (##fixnum.= (##fixnum.bitwise-and ,options 512) 0)))

(##define-macro (macro-close! options)
  `(##fixnum.bitwise-ior ,options 512))

(##define-macro (macro-unclose! options)
  `(##fixnum.bitwise-and ,options -513))

(##define-macro (macro-permanent-close-shift)  1024)
(##define-macro (macro-permanent-close-range)  2)
(##define-macro (macro-permanent-close-no)     0)
(##define-macro (macro-permanent-close-yes)    1)

(##define-macro (macro-perm-close? options)
  `(##not (##fixnum.= (##fixnum.bitwise-and ,options 1024) 0)))

(##define-macro (macro-buffering-shift)   4096)
(##define-macro (macro-buffering-range)   4)
(##define-macro (macro-default-buffering) 0)
(##define-macro (macro-no-buffering)      1)
(##define-macro (macro-line-buffering)    2)
(##define-macro (macro-full-buffering)    3)

(##define-macro (macro-unbuffered? options)
  `(##fixnum.< ,options 8192))

(##define-macro (macro-fully-buffered? options)
  `(##not (##fixnum.< ,options 12288)))

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

(##define-macro (macro-default-server-address) #f)

(##define-macro (macro-default-port-number) #f)

(##define-macro (macro-socket-type-TCP) 0)
(##define-macro (macro-socket-type-UDP) 1)
(##define-macro (macro-socket-type-RAW) 2)
(##define-macro (macro-default-socket-type) `(macro-socket-type-TCP))

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
  close-parens
  level
  limit
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
  filepos
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
         (if (##fixnum.< char-rlo char-rhi)

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
         (if (##fixnum.< char-rlo char-rhi)

           ;; the next character is in the character read buffer

           (let ((c (##string-ref (macro-character-port-rbuf port) char-rlo)))
             (if (##not (##char=? c #\newline))

               ;; frequent simple case, just advance rlo

               (begin
                 (macro-character-port-rlo-set! port (##fixnum.+ char-rlo 1))
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
             (char-whi+1 (##fixnum.+ (macro-character-port-whi port) 1)))
         (if (##fixnum.< char-whi+1 (##string-length char-wbuf))

           ;; adding this character would not make the character write
           ;; buffer full, so add character and increment whi

           (begin
             (##string-set! char-wbuf (##fixnum.- char-whi+1 1) c)
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
  (paren-keyword                  unprintable: read-write:)
  (bracket-keyword                unprintable: read-write:)
  (brace-keyword                  unprintable: read-write:)
  (angle-keyword                  unprintable: read-write:)
  (start-syntax                   unprintable: read-write:)
  (six-type?                      unprintable: read-write:)
  (r6rs-compatible-read?          unprintable: read-write:)
  (r6rs-compatible-write?         unprintable: read-write:)
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
