;;;============================================================================

;;; File: "process.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Process related operations.

(define-library (process)

  (namespace "")

  (export

emergency-exit
exit
command-line
command-name
script-directory
script-file
shell-command

)

  (include "process#.scm"))

;;;============================================================================
