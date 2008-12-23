;;;============================================================================

;;; File: "fixnum.scm", Time-stamp: <2008-12-15 11:36:06 feeley>

;;; Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved.

(##namespace ("c#"))

(##include "../lib/header.scm")

(##declare
  (standard-bindings)
  (fixnum)
)

(##define-macro (include-adt filename)
  `(begin
     (##declare (not core))
     (##include ,(string-append "../gsc/" filename))
     (##declare (core))))

;;;============================================================================
