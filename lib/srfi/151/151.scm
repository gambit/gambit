#|
(define (bitwise-if . rest) 0)
(define (copy-bit . rest) 0)
(define (bit-swap . rest) 0)
(define (any-bit-set? . rest) #f)
(define (every-bit-set? . rest) #f)
(define (bit-field . rest) 0)
(define (bit-field-any? . rest) 0)
(define (bit-field-every? . rest) 0)
(define (bit-field-rotate . rest) 0)
(define (bit-field-reverse . rest) 0)
(define (bit-field-clear . rest) 0)
(define (bit-field-set . rest) 0)
(define (bit-field-replace . rest) 0)
(define (bit-field-replace-same . rest) 0)
(define (list->bits . rest) 0)
;;(define (bits->list . rest) 0)
(define (vector->bits . rest) 0)
;;(define (bits->vector . rest) 0)
(define (bits . rest) 0)
(define (bitwise-fold . rest) 0)
(define (bitwise-for-each . rest) 0)
(define (bitwise-unfold . rest) 0)
(define (make-bitwise-generator . rest) (lambda x 0))
|#

;;;============================================================================

;;; File: "151.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 151, Bitwise Operations

(##supply-module srfi/151)

(##namespace ("srfi/151#"))               ;; in srfi/151#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(##include "151#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

;; Most of the procedures are builtin.


;;;============================================================================
