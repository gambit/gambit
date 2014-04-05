#! /bin/sh
":";exec ../gsi/gsi -:dar,=.. -f $0 $*

;;;============================================================================

;;; File: "igsc.scm"

;;; Copyright (c) 1994-2014 by Marc Feeley, All Rights Reserved.

;;;----------------------------------------------------------------------------

(##include "../gsc/fixnum.scm")

;; use custom absent object otherwise the interpreter gets confused

(define c#absent-object (string->symbol "#<absent>")) ;; (##type-cast -6 2)

;; remove runtime options if any

(let* ((cl ##processed-command-line)
       (args (cdr cl)))
  (if (and (pair? args)
           (string? (car args))
           (>= (string-length (car args)) 2)
           (string=? (substring (car args) 0 2) "-:"))
      (set! ##processed-command-line (cons (car cl) (cdr args)))))

;;;----------------------------------------------------------------------------

(define modules '(
"_utils"
"_source"
"_parms"
"_env"
"_ptree1"
"_ptree2"
"_gvm"
"_back"
"_front"
"_prims"
"_assert"
"_asm"
"_x86"
"_codegen"
"_t-univ"
"_t-c-1"
"_t-c-3"
"_t-c-2"
"_gsclib"
"_gsc"
))

(define root "")

(define (load-from-gsc file)
  (##namespace ("" load))
  (display "loading ")
  (write file)
  (load (string-append root "../gsc/" file ".scm"))
  (newline))

;;;----------------------------------------------------------------------------

(load-from-gsc "_host")

(set! **main-readtable
  (and **main-readtable
       (##list->vector (##vector->list **main-readtable))))

(for-each load-from-gsc modules)

(##main-gsi/gsc)

;;;----------------------------------------------------------------------------
