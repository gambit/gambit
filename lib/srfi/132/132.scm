;;;============================================================================

;;; File: "132#.scm"

;;; Copyright (c) 2018-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 132, Sort Libraries

(##supply-module srfi/132)

(##namespace ("srfi/132#"))
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-procedure, 
(##include "132#.scm")

(define (assert x) #f)

;; Code is mostly written by Olin Shivers, with modifications by John Cowan,
;; and comes from:
;; https://github.com/scheme-requests-for-implementation/srfi-132

(include "delndups.scm")     ; list-delete-neighbor-dups etc
(include "lmsort.scm")       ; list-merge, list-merge!
(include "sortp.scm")        ; list-sorted?, vector-sorted?
(include "vector-util.scm")
(include "vhsort.scm")
(include "visort.scm")
(include "vmsort.scm")       ; vector-merge, vector-merge!
(include "vqsort2.scm")
(include "vqsort3.scm")
(include "sort.scm")
(include "select.scm")

;;;============================================================================
