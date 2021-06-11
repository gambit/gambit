;;;============================================================================

;;; File: "193.sld"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 193, Command line

(define-library (srfi 193)

  (namespace "")

  (export

command-line
command-name
command-args
script-file
script-directory

)

  (include "193.scm"))

;;;============================================================================
