;;;============================================================================

;;; File: "env-vars.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Environment variable operations.

(##include "env-vars#.scm")

;;;----------------------------------------------------------------------------

;;; Support for R7RS process-context library and Gambit specific
;;; procedures related to environment variables.

;;;----------------------------------------------------------------------------

;;; Interface to OS.

(macro-case-target

 ((C)  ;;......................................................................

(c-declare #<<c-declare-end

#include "os_shell.h"

c-declare-end
)

(define-prim ##os-getenv
  (c-lambda (scheme-object)
            scheme-object
   "___os_getenv"))

(define-prim ##os-setenv
  (c-lambda (scheme-object
             scheme-object)
            scheme-object
   "___os_setenv"))

(define-prim ##os-environ
  (c-lambda ()
            scheme-object
   "___os_environ"))
)

 (else))  ;;...................................................................

;;;----------------------------------------------------------------------------

(define-prim (##get-environment-variables)
  (let ((result (##os-environ)))
    (if (##fixnum? result)
        (##raise-os-exception #f result get-environment-variables)
        (begin
          (let loop1 ((lst result))
            (if (##pair? lst)
                (let ((s (##car lst)))
                  (let loop2 ((i 0))
                    (if (##fx< i (##string-length s))
                        (let ((c (##string-ref s i)))
                          (if (##char=? c #\=)
                              (##set-car!
                               lst
                               (##cons (##substring s
                                                    0
                                                    i)
                                       (##substring s
                                                    (##fx+ i 1)
                                                    (##string-length s))))
                              (loop2 (##fx+ i 1))))
                        (##set-car!
                         lst
                         (##cons s
                                 ""))))
                  (loop1 (##cdr lst)))))
          result))))

(define-prim (get-environment-variables)
  (##get-environment-variables))

(define-prim (##getenv
              name
              #!optional
              (default-value (macro-absent-obj)))
  (let ((result (##os-getenv name)))
    (cond ((##fixnum? result)
           (##raise-os-exception
            #f
            result
            getenv
            name
            default-value))
          ((##not result)
           (if (##eq? default-value (macro-absent-obj))
               (##raise-unbound-os-environment-variable-exception
                getenv
                name)
               default-value))
          (else
           result))))

(define-prim (getenv name #!optional (default-value (macro-absent-obj)))
  (macro-force-vars (name)
    (macro-check-string name 1 (getenv name default-value)
      (##getenv name default-value))))

(define-prim (##get-environment-variable name)
  (let ((result (##os-getenv name)))
    (if (##fixnum? result)
        (##raise-os-exception
         #f
         result
         get-environment-variable
         name)
        result)))

(define-prim (get-environment-variable name)
  (macro-force-vars (name)
    (macro-check-string name 1 (get-environment-variable name)
      (##get-environment-variable name))))

(define-prim (##setenv name #!optional (value (macro-absent-obj)))
  (let ((code (##os-setenv name value)))
    (if (##fx< code 0)
        (##raise-os-exception #f code setenv name value)
        (##void))))

(define-prim (setenv name #!optional (value (macro-absent-obj)))
  (macro-force-vars (name value)
    (macro-check-string name 1 (setenv name value)
      (if (##eq? value (macro-absent-obj))
          (##setenv name)
          (macro-check-string value 2 (setenv name value)
            (##setenv name value))))))

;;;============================================================================
