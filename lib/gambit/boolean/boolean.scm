;;;============================================================================

;;; File: "boolean.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Boolean operations.

(##include "boolean#.scm")

;;;----------------------------------------------------------------------------

(define-fail-check-type boolean 'boolean)

(define-prim (##boolean? obj)
  (or (##eq? obj #t) (##eq? obj #f)))

(define-prim (boolean? obj)
  (macro-force-vars (obj)
    (##boolean? obj)))

(define-prim (##not obj)
  (if obj #f #t))

(define-prim (not obj)
  (macro-force-vars (obj)
    (##not obj)))

;;;============================================================================
