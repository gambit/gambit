;;;============================================================================

;;; File: "debug.scm"

;;; Copyright (c) 2014-2019 by Marc Feeley and Frédéric Hamel, All Rights Reserved.

;;;============================================================================

(import _define-library/define-library-expand)

;; turn on debug-expansion? when this module is loaded

(_define-library/define-library-expand#debug-expansion?-set! #t)

;;;============================================================================
