;;;============================================================================

;;; File: "_module#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define-type modref
  id: BD2FB9FB-A937-49EE-9C4E-FE997F4EB1BC
  constructor: macro-make-modref
  implementer: implement-type-modref
  macros:
  prefix: macro-
  unprintable:

  host   ;; #f or list: (account host)
  tag    ;; #f or string
  rpath  ;; non-empty list of path in reverse order
)

;;;============================================================================
