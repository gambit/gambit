;;;============================================================================

;;; File: "_digest#.scm"

;;; Copyright (c) 2006-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Message digest computation.

(##namespace ("_digest#"

open-digest
close-digest

digest-update-subu8vector
digest-update-u8
digest-update-u16-le
digest-update-u16-be
digest-update-u32-le
digest-update-u32-be

digest-string
digest-substring
digest-u8vector
digest-subu8vector
digest-file

))

(define-type digest
  id: D3651B91-678F-4C1F-9A3D-7439E3BCA52F
  constructor: macro-make-digest
  implementer: implement-type-digest
  type-exhibitor: macro-digest-type
  copier: #f
  opaque:
  macros:
  prefix: macro-

  end
  update
  state
)

(define-type crc32-digest
  id: D3E2EFFE-DC60-4565-B6D8-91DCB223679E
  constructor: macro-make-crc32-digest
  implementer: implement-type-crc32-digest
  type-exhibitor: macro-crc32-digest-type
  copier: #f
  opaque:
  macros:
  prefix: macro-

  hi16
  lo16
)

(define-type block-digest
  id: B8D2A8C0-DC6B-4224-8646-285C65B28B7B
  constructor: macro-make-block-digest
  implementer: implement-type-block-digest
  type-exhibitor: macro-block-digest-type
  copier: #f
  opaque:
  macros:
  prefix: macro-

  hash-update
  hash
  block
  block-pos
  bit-pos
  big-endian?
  width
)

;;;============================================================================
