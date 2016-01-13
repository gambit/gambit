#! /bin/sh
":";if test "`basename $0`" == "igsc.scm" ; then exec /usr/bin/env gsi -:dar,=`dirname $0`/.. -f $0 $*; else exec /usr/bin/env gsi -:dar,=`dirname $0` -f $0 $*; fi

;;;============================================================================

;;; File: "igsc.scm"

;;; Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved.

;;;----------------------------------------------------------------------------

;; This is a drop-in replacement for gsc-boot, which is the Gambit
;; Scheme compiler used to compile the Gambit system.  It has the
;; advantage of executing the whole compiler with all type checking
;; turned on, which is useful to debug the compiler.  Also, it only
;; requires a working Gambit interpreter (gsi), preferably a recent
;; version.
;;
;; To bootstrap Gambit using igsc.scm, from the root directory do:
;;
;;   cp gsc/igsc.scm gsc-boot
;;   make bootclean
;;   make

;;;----------------------------------------------------------------------------

(define-macro (at-expansion-time expr) (eval expr) '(begin))

(at-expansion-time (define ##compilation-options '()))

#;
(define-macro (set-root-dir)
  (let* ((script-path (path-normalize (car ##processed-command-line)))
         (dir (path-directory script-path)))
    (if (equal? (path-strip-directory script-path) "igsc.scm")
        `(begin
           (include "fixnum.scm")
           (define root ,(path-directory
                          (path-strip-trailing-directory-separator dir))))
        `(begin
           (include "gsc/fixnum.scm")
           (define root ,dir)))))
#;
(set-root-dir)

(include "~~/gsc/fixnum.scm")

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

;; normalize program name

(set! ##processed-command-line
      (cons (path-normalize (car ##processed-command-line))
            (cdr ##processed-command-line)))

;;;----------------------------------------------------------------------------

(define gsc-modules '(
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
"_t-univ-1"
"_t-univ-2"
"_t-univ-3"
"_t-univ-4"
"_t-c-1"
"_t-c-3"
"_t-c-2"
"_gsclib"
"_gsc"
"_gscdebug"
))

(define (load-from-root dir)
  (lambda (base)
    (with-output-to-port
        (current-error-port)
      (lambda ()
        (let ((file (string-append "~~/" dir base ".scm")))
          (display "loading ")
          (write file)
          (load file)
          (newline))))))

;;;----------------------------------------------------------------------------

((load-from-root "gsc/") "_host")

(set! **main-readtable
  (and **main-readtable
       (##list->vector (##vector->list **main-readtable))))

(for-each (load-from-root "gsc/") gsc-modules)

(##main-gsi/gsc)

;;;----------------------------------------------------------------------------
