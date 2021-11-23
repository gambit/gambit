;;;============================================================================

;;; File: "124.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 124, Ephemerons

(##supply-module srfi/124)

(##namespace ("srfi/124#"))               ;; in srfi/124#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(##include "124#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

(##define-type ephemeron
  id: E3B20910-F869-4C15-B427-454DC8334518
  type-exhibitor: macro-type-ephemeron
  constructor: macro-make-ephemeron
  implementer: implement-type-ephemeron
  macros:
  prefix: macro-
  opaque:

  (will  unprintable:)
  (datum unprintable:)
)

(implement-type-ephemeron)

(define (##fail-check-ephemeron arg-id proc . args)
  (##raise-type-exception
   arg-id
   (macro-type-ephemeron)
   proc
   args))

(define-check-type ephemeron (macro-type-ephemeron)
  macro-ephemeron?)

;;;============================================================================

(define-procedure (ephemeron? (object object))
  (macro-ephemeron? object))

(define (make-ephemeron-finalizer ephemeron)
  (lambda (key)
    (macro-ephemeron-will-set! ephemeron #f)
    (macro-ephemeron-datum-set! ephemeron #f)))

(define-procedure (make-ephemeron (key object) (datum object))
  (let ((ephemeron (macro-make-ephemeron #f datum)))
    (macro-ephemeron-will-set!
     ephemeron
     (make-will key (make-ephemeron-finalizer ephemeron)))
    ephemeron))

(define-procedure (ephemeron-broken? (ephemeron ephemeron))
  (not (macro-ephemeron-will ephemeron)))

(define-procedure (ephemeron-key (ephemeron ephemeron))
  (let ((will (macro-ephemeron-will ephemeron)))
    (and will
         (will-testator will))))

(define-procedure (ephemeron-datum (ephemeron ephemeron))
  (macro-ephemeron-datum ephemeron))

(define-procedure (reference-barrier (key object))
  (##first-argument key))

;;;============================================================================
