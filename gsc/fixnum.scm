;;;============================================================================

;;; File: "fixnum.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

(##declare
  (standard-bindings)
  ;(fixnum)
  (safe)
  (debug)
)

(##define-macro (include-adt filename)
  `(begin
     (##declare (not core))
     (##include ,(string-append "../gsc/" filename))
     (##declare (core))))

;;;============================================================================
