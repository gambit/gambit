;;;============================================================================

;;; File: "5.sld"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 5, A compatible let form with signatures and rest arguments

(define-library (srfi 5)

  (export

let
%let-loop

)

  (include "5#.scm"))

;;;============================================================================
