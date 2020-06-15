;;;============================================================================

;;; File: "procedure.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Procedure operations.

(##include "procedure#.scm")

;;;----------------------------------------------------------------------------

(define-fail-check-type procedure 'procedure)

(define-prim (##procedure? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-procedure))))

(define-prim (procedure? obj)
  (macro-force-vars (obj)
    (##procedure? obj)))

;;;============================================================================
