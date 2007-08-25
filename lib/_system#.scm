;;;============================================================================

;;; File: "_system#.scm", Time-stamp: <2007-05-27 22:03:58 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception invalid-hash-number-exception
  id: 3b7674e5-a6d8-11d9-930c-00039301ba52
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

(define-library-type-of-exception unbound-table-key-exception
  id: 1a1e928d-8df4-11d9-8894-00039301ba52
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

(define-library-type-of-exception unbound-serial-number-exception
  id: 3eb844fe-9381-11d9-b22f-00039301ba52
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type hash-algorithm 'hash-algorithm
  ##hash-algorithm?)

;;;----------------------------------------------------------------------------

;;; Representation of tables.

(define-type table
  id: 5917e472-85e5-11d9-a2c0-00039301ba52
  type-exhibitor: macro-type-table
  constructor: macro-make-table
  implementer: implement-type-table
  opaque:
  macros:
  prefix: macro-

  (flags unprintable:)
  (test  unprintable:)
  (hash  unprintable:)
  (loads unprintable:)
  (gcht  unprintable:)
  (init  unprintable:)
)

;;; Representation of digests.

(define-type digest
  id: 1ce13de0-ccaa-4627-94be-b13eaa2c32e6
  type-exhibitor: macro-type-digest
  constructor: macro-make-digest
  implementer: implement-type-digest
  opaque:
  macros:
  prefix: macro-

  (close-digest unprintable:)
  (hash-update  unprintable:)
  (hash         unprintable:)
  (block        unprintable:)
  (block-pos    unprintable:)
  (bit-pos      unprintable:)
)

;;;============================================================================
