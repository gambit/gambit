;;;============================================================================

;;; File: "python.scm"

;;; Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2021-2022 by Marc-André Bélanger , All Rights Reserved.

;;;============================================================================

;; Miscellaneous definitions needed at run time to support the
;; six.infix special form for Python.

(##supply-module _six/python)

(##namespace ("_six/python#"))            ;; in _six/python#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-procedure,
                                          ;; macro-absent-obj, etc

(##include "python#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================
