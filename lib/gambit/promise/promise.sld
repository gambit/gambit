;;;============================================================================

;;; File: "promise.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Promise operations.

(define-library (promise)

  (namespace "")

  (export

force
make-promise
promise?
touch

)

  (include "promise#.scm"))

;;;============================================================================
