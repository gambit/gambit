;;;============================================================================

;;; File: "124.sld"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 124, Ephemerons

(define-library (srfi 124)
  (export
   ephemeron?
   make-ephemeron
   ephemeron-broken?
   ephemeron-key
   ephemeron-datum
   reference-barrier)

(include "124.scm"))

;;;============================================================================
