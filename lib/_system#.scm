;;;============================================================================

;;; File: "_system#.scm"

;;; Copyright (c) 1994-2017 by Marc Feeley, All Rights Reserved.

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

(define-type table
  id: A7AB629D-EAB0-422F-8005-08B2282E04FC
  type-exhibitor: macro-type-table
  constructor: macro-make-table
  implementer: implement-type-table
  opaque:
  macros:
  prefix: macro-

  (test     unprintable:)
  (init     unprintable:)
  (alist    unprintable:)
  (objdict  unprintable:)
  (primdict unprintable:)
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

;; The FNV1a hash algorithm is adapted to hash values, in
;; particular the hashing constants are used (see
;; https://tools.ietf.org/html/draft-eastlake-fnv-12).  Because the
;; hash function result is a fixnum and it needs to give the same
;; result on 32 bit and 64 bit architectures, the constants are
;; adapted to fit in a 32 bit fixnum.

;; FNV1a 32 bit constants
(##define-macro (macro-fnv1a-prime-32bits)          #x01000193)
(##define-macro (macro-fnv1a-offset-basis-32bits)   #x811C9DC5)

;; constants adapted to fit in 29 bits (tagged 32 bit fixnums)
(##define-macro (macro-fnv1a-prime-fixnum32)        #x01000193)
(##define-macro (macro-fnv1a-offset-basis-fixnum32) #x011C9DC5) ;; 29 bits!

(##define-macro (macro-hash-combine a b)
  `(let ((a ,a)
         (b ,b))
     (##fxand (##fxwrap* (macro-fnv1a-prime-fixnum32)
                         (##fxxor a b))
              (macro-max-fixnum32))))

;;;============================================================================
