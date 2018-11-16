;;;============================================================================

;;; File: "_nonstd#.scm"

;;; Copyright (c) 1994-2018 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception error-exception
  id: efe252c3-9391-4acf-993b-1ad2a9035636
  constructor: #f
  opaque:

  (message    unprintable: read-only: no-functional-setter:)
  (parameters unprintable: read-only: no-functional-setter:)
)

(define-library-type-of-exception unbound-os-environment-variable-exception
  id: d5d5638b-8d10-4cd8-a1b1-10dab77e5869
  constructor: #f
  opaque:

  (procedure unprintable: read-only: no-functional-setter:)
  (arguments unprintable: read-only: no-functional-setter:)
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type string-or-nonnegative-fixnum 'string-or-nonnegative-fixnum
  macro-string-or-nonnegative-fixnum?)

(##define-macro (macro-string-or-nonnegative-fixnum? obj)
  `(let ((obj ,obj))
     (or (##string? obj)
         (and (##fixnum? obj)
              (##not (##fxnegative? obj))))))

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

  (type                   printable: read-only: no-functional-setter:)
  (device                 printable: read-only: no-functional-setter:)
  (inode                  printable: read-only: no-functional-setter:)
  (mode                   printable: read-only: no-functional-setter:)
  (number-of-links        printable: read-only: no-functional-setter:)
  (owner                  printable: read-only: no-functional-setter:)
  (group                  printable: read-only: no-functional-setter:)
  (size                   printable: read-only: no-functional-setter:)
  (last-access-time       printable: read-only: no-functional-setter:)
  (last-modification-time printable: read-only: no-functional-setter:)
  (last-change-time       printable: read-only: no-functional-setter:)
  (attributes             printable: read-only: no-functional-setter:)
  (creation-time          printable: read-only: no-functional-setter:)
)

;;;----------------------------------------------------------------------------

(define-library-type user-info
  id: c206cf7a-66fb-4e32-9f05-30f2bf053750
  constructor: #f
  opaque:

  (name  printable: read-only: no-functional-setter:)
  (uid   printable: read-only: no-functional-setter:)
  (gid   printable: read-only: no-functional-setter:)
  (home  printable: read-only: no-functional-setter:)
  (shell printable: read-only: no-functional-setter:)
)

;;;----------------------------------------------------------------------------

(define-library-type group-info
  id: 9850f1b3-2e29-4407-af9f-202e99aa9555
  constructor: #f
  opaque:

  (name    printable: read-only: no-functional-setter:)
  (gid     printable: read-only: no-functional-setter:)
  (members printable: read-only: no-functional-setter:)
)

;;;============================================================================
