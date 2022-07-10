;;;============================================================================

;;; File: "env-vars.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Environment variable operations.

(define-library (env-vars)

  (namespace "")

  (export

get-environment-variable
get-environment-variables
getenv
setenv

)

  (include "env-vars#.scm"))

;;;============================================================================
