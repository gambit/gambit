;;;============================================================================

;;; File: "_system#.scm"

;;; Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved.

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

;;; Representation of tables.

(macro-case-target

 ((C)

(define-type table
  id: F3F63A41-2974-4D41-8B24-1744E866741D
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
)

 (else

;; This representation uses an association list and does not implement
;; key and value weakness.

;; TODO: implement using host language hash tables.

(define-type table
  id: A7AB629D-EAB0-422F-8005-08B2282E04FC
  type-exhibitor: macro-type-table
  constructor: macro-make-table
  implementer: implement-type-table
  opaque:
  macros:
  prefix: macro-

  (test  unprintable:)
  (init  unprintable:)
  (alist unprintable:)
)

))

;;;----------------------------------------------------------------------------

;;; Partially initialized structures.

(define-type partially-initialized-structure
  id: cd85663e-b289-472c-b943-a41768e2f8a3
  type-exhibitor: macro-type-partially-initialized-structure
  constructor: macro-make-partially-initialized-structure
  implementer: implement-type-partially-initialized-structure
  opaque:
  macros:
  prefix: macro-
)

;;;----------------------------------------------------------------------------

;;; Auxiliary macro for computing hash key.

(##define-macro (macro-hash-combine a b)
  `(let ((a ,a)
         (b ,b))
     (##fxand
      (##fxwrap* (##fxwrap+ a (##fxwraparithmetic-shift-left b 1))
                 331804471)
      (macro-max-fixnum32))))

;;;============================================================================
