;;;============================================================================

;;; File: "_codegen.scm"

;;; Copyright (c) 2010-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; This module implements the code generation infrastructure.

(namespace ("_codegen#") ("" include))
(include "~~lib/gambit#.scm")

(include "_asm#.scm")
(include "_codegen#.scm")

(codegen-implement)

;;;============================================================================

(define (make-codegen-context)
  (let ((cgc (make-vector (+ (asm-code-block-size) 3) 'codegen-context)))
    (codegen-context-listing-format-set! cgc #f)
    (codegen-context-arch-set!           cgc #f)
    (codegen-context-fixup-list-set!     cgc '())
    cgc))

(define (codegen-context-listing-format cgc)
  (vector-ref cgc (+ (asm-code-block-size) 0)))

(define (codegen-context-listing-format-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 0) x))

(define (codegen-context-arch cgc)
  (vector-ref cgc (+ (asm-code-block-size) 1)))

(define (codegen-context-arch-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 1) x))

(define (codegen-context-fixup-list cgc)
  (vector-ref cgc (+ (asm-code-block-size) 2)))

(define (codegen-context-fixup-list-set! cgc x)
  (vector-set! cgc (+ (asm-code-block-size) 2) x))

;;;============================================================================
