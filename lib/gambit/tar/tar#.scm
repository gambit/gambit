;;;============================================================================

;;; File: "gambit/tar/tar#.scm"

;;; Copyright (c) 2006-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Tar file packing/unpacking.

(##namespace ("##"
              tar-pack-file
              tar-pack-port
              tar-pack-u8vector
              tar-rec-list-read
              tar-rec-list-write
              tar-unpack-file
              tar-unpack-port
              tar-unpack-u8vector))

(define-type tar-rec
  id: F5AFD9DF-942D-4E2A-9BF9-89B2C57448A5
  constructor: macro-make-tar-rec
  implementer: implement-type-tar-rec
  copier: #f
  opaque:
  macros:
  prefix: macro-

  (name       no-functional-setter: read-only:)
  (mode       no-functional-setter: read-only:)
  (uid        no-functional-setter: read-only:)
  (gid        no-functional-setter: read-only:)
  (mtime      no-functional-setter: read-only:)
  (type       no-functional-setter: read-only:)
  (linkname   no-functional-setter: read-only:)
  (uname      no-functional-setter: read-only:)
  (gname      no-functional-setter: read-only:)
  (devmajor   no-functional-setter: read-only:)
  (devminor   no-functional-setter: read-only:)
  (atime      no-functional-setter: read-only:)
  (ctime      no-functional-setter: read-only:)

  (content    no-functional-setter: read-write: unprintable:)
)

;;;============================================================================
