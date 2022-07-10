;;;============================================================================

;;; File: "41.sld"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 41, Streams.

(define-library (srfi 41)
  (namespace "")
  (export
    stream-lazy
    stream-eager
    stream-delay
    stream-force
    stream-null
    stream-cons
    stream?
    stream-null?
    stream-pair?
    stream-car
    stream-cdr
    stream-lambda
    define-stream
    list->stream
    stream->list
    port->stream
    stream
    stream-append
    macro-stream-append
    stream-concat
    stream-constant
    stream-drop
    stream-drop-while
    stream-filter
    stream-fold
    stream-for-each
    stream-from
    stream-iterate
    stream-length
    stream-let
    stream-map
    stream-match
    stream-match-test
    stream-match-pattern
    stream-of
    stream-of-aux
    stream-range
    stream-ref
    stream-reverse
    stream-scan
    stream-take
    stream-take-while
    stream-unfold 
    stream-unfolds
    stream-zip)

(include "41.scm"))

;;;============================================================================
