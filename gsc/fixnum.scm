;;;============================================================================

;;; File: "fixnum.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

(##declare
  (standard-bindings)
  (fixnum)
)

(##define-macro (include-adt filename)
  `(begin
     (##declare (not core))
     (##include ,(string-append "../gsc/" filename))
     (##declare (core))))

;; TODO: remove after bootstrap
(define-runtime-syntax ##cond-expand
  (lambda (src)
    (##deconstruct-call
     src
     -1
     (lambda clauses
       (##expand-source-template
        src
        (##cond-expand-build
         src
         clauses))))))

;;;============================================================================
