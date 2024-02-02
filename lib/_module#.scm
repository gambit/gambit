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

;; When looking for a module in `find-mod-info`, this is the record we give back
;; if we find the module on the file system.
(define-type mod-info-fs
  id: ABF049E0-AAB8-4A8A-BA8E-A868339DFDB4
  macros:
  dir
  filename-noext
  ext
  mod-path
  port
  root
  path)

;; When looking for a module in `find-mod-info`, this is the record we give back
;; if we find the module in our ##registered-modules
(define-type mod-info-rm
  id: C8654EB8-AA35-4AB4-933C-A92478589465
  registered-module)

;;;============================================================================
