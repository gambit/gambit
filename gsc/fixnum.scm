;;;============================================================================

;;; File: "fixnum.scm", Time-stamp: <2007-06-28 17:55:40 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

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
