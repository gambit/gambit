;;;============================================================================

;;; File: "js.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Miscellaneous definitions needed at run time to support the
;; six.infix special form for JavaScript.

(##supply-module _six/js)

(##namespace ("_six/js#"))                ;; in _six/js#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-procedure,
                                          ;; macro-absent-obj, etc

(##include "js#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================
