;;;============================================================================

;;; File: "42.sld"

;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 42, Eager Comprehensions

(define-library (srfi 42)
  (export

;; special forms
do-ec
do-ec:do
ec-simplify
:do
:let
:parallel
:parallel-1
:while
:while-1
:while-2
:until
:until-1
:list
:string
:vector
:integers
:range
:real-range
:char-range
:port
:dispatched
:generator-proc
:
fold3-ec
fold-ec
list-ec
append-ec
string-ec
string-append-ec
vector-ec
vector-of-length-ec
sum-ec
product-ec
min-ec
max-ec
last-ec
first-ec
ec-guarded-do-ec
any?-ec
every?-ec

;; procedures
ec-:vector-filter
dispatch-union
make-initial-:-dispatch
:-dispatch
:-dispatch-ref
:-dispatch-set!

)

(include "42#.scm")
(include "42.scm"))

;;;============================================================================
