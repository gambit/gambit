;;;============================================================================

;;; File: "_irregex.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; IRREGEX reading/writing.

(##supply-module _irregex)

(##namespace ("_irregex#"))               ;; in _irregex#
;(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

(##namespace ("_irregex#" ;; Don't import these from Gambit:
vector-copy
find
find-tail
last
any
every
fold
filter
remove
))

;;;----------------------------------------------------------------------------

(##include "_irregex#.scm")

;;;----------------------------------------------------------------------------

(##include "irregex.scm")

;;;============================================================================
