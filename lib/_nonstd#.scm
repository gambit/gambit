;;;============================================================================

;;; File: "_nonstd#.scm", Time-stamp: <2009-01-29 14:51:49 feeley>

;;; Copyright (c) 1994-2009 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception error-exception
  id: efe252c3-9391-4acf-993b-1ad2a9035636
  constructor: #f
  opaque:

  (message    unprintable: read-only:)
  (parameters unprintable: read-only:)
)

(define-library-type-of-exception unbound-os-environment-variable-exception
  id: d5d5638b-8d10-4cd8-a1b1-10dab77e5869
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type string-or-nonnegative-fixnum 'string-or-nonnegative-fixnum
  macro-string-or-nonnegative-fixnum?)

(##define-macro (macro-string-or-nonnegative-fixnum? obj)
  `(let ((obj ,obj))
     (or (##string? obj)
         (and (##fixnum? obj)
              (##not (##fixnum.negative? obj))))))

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type will 'will
  ##will?)

(define-check-type box 'box
  ##box?)

;;;----------------------------------------------------------------------------

(define-library-type file-info
  id: 41abc50f-928b-48b9-8d2b-77f53b260e71
  constructor: #f
  opaque:

  (type                   printable: read-only:)
  (device                 printable: read-only:)
  (inode                  printable: read-only:)
  (mode                   printable: read-only:)
  (number-of-links        printable: read-only:)
  (owner                  printable: read-only:)
  (group                  printable: read-only:)
  (size                   printable: read-only:)
  (last-access-time       printable: read-only:)
  (last-modification-time printable: read-only:)
  (last-change-time       printable: read-only:)
  (attributes             printable: read-only:)
  (creation-time          printable: read-only:)
)

;;;----------------------------------------------------------------------------

(define-library-type user-info
  id: c206cf7a-66fb-4e32-9f05-30f2bf053750
  constructor: #f
  opaque:

  (name  printable: read-only:)
  (uid   printable: read-only:)
  (gid   printable: read-only:)
  (home  printable: read-only:)
  (shell printable: read-only:)
)

;;;----------------------------------------------------------------------------

(define-library-type group-info
  id: 9850f1b3-2e29-4407-af9f-202e99aa9555
  constructor: #f
  opaque:

  (name    printable: read-only:)
  (gid     printable: read-only:)
  (members printable: read-only:)
)

;;;============================================================================
