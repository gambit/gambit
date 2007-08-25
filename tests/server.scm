; File: "server.scm", Time-stamp: <2007-04-04 11:40:46 feeley>

; Copyright (c) 1996-2007 by Marc Feeley, All Rights Reserved.

; This file shows how to use the C-interface to implement a "Scheme
; server", that is a program which is mainly written in C and that
; makes calls to Scheme functions to access certain services.

;------------------------------------------------------------------------------

; This is a simple server that can evaluate a string of Scheme code.

(define (catch-all-errors thunk)
  (with-exception-catcher
   (lambda (exc)
     (write-to-string exc))
   thunk))

(define (write-to-string obj)
  (with-output-to-string
    '()
    (lambda () (write obj))))

(define (read-from-string str)
  (with-input-from-string str read))

; The following "c-define" form will define the function "eval_string"
; which can be called from C just like an ordinary C function.  The
; single argument is a character string (C type "char*") and the
; result is also a character string.

(c-define (eval-string str) (char-string) char-string "eval_string" "extern"
  (catch-all-errors
    (lambda () (write-to-string (eval (read-from-string str))))))

;------------------------------------------------------------------------------
