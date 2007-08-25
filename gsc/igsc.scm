#! /bin/sh
":";exec ../gsi/gsi -:dar -f $0 $*

;;;============================================================================

;;; File: "igsc.scm", Time-stamp: <2007-04-04 16:53:46 feeley>

;;; Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved.

;;;----------------------------------------------------------------------------

(define c#absent-object
  (string->symbol "#<absent>")) ; (##type-cast -6 2)

(define ##compilation-options '(check))

(##include "../gsc/fixnum.scm")

(define root "")

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
"_t-c-1"
"_t-c-2"
"_t-c-3"
"_gsc"
))

(define (load-from-gsc file)
  (##namespace ("" load))
  (display (list "loading " file "\n"))
  (load (string-append root "../gsc/" file ".scm")))

(eval '(##define-macro (include file)
        `(##include ,(string-append "../gsc/" file))))

;;;----------------------------------------------------------------------------

(load-from-gsc "_host")

(set! **main-readtable
  (and **main-readtable
       (##list->vector (##vector->list **main-readtable))))

(for-each load-from-gsc modules)

(##main-gsi/gsc)

;;;----------------------------------------------------------------------------
