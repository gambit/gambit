;;;============================================================================

;;; File: "tar#.scm"

;;; Copyright (c) 2006-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("tar#"

implement-type-tar-rec
make-tar-rec
tar-rec-name
tar-rec-mode
tar-rec-uid
tar-rec-gid
tar-rec-mtime
tar-rec-type
tar-rec-linkname
tar-rec-uname
tar-rec-gname
tar-rec-devmajor
tar-rec-devminor
tar-rec-atime
tar-rec-ctime
tar-rec-content

make-tar-condition
tar-condition?
tar-condition-msg

tar-pack-genport
tar-pack-file
tar-pack-u8vector
tar-unpack-genport
tar-unpack-file
tar-unpack-u8vector

tar-read
tar-write
tar-write-unchecked

tar-file
untar-file

))

;;;============================================================================

(define-type tar-rec
  id: tar-rec-1e4c3b06-1a6f-4765-9d77-c1093d1c15ee
  implementer: implement-type-tar-rec
  name
  mode
  uid
  gid
  mtime
  type
  linkname
  uname
  gname
  devmajor
  devminor
  atime
  ctime
  content
)

;;;============================================================================
