;;;============================================================================

;;; File: "special-forms.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Special-forms.

(define-library (special-forms)

  (namespace "##")

  (export

;; r4rs

and
begin
case
cond
define
delay
do
if
lambda
let
let*
letrec
or
quasiquote
quote
set!

;; r5rs

define-syntax
;;let-syntax ;; not implemented
;;letrec-syntax ;; not implemented
syntax-rules

;; r7rs

case-lambda
cond-expand
define-library
define-record-type
delay-force
guard
include
include-ci
let*-values
let-values
letrec*
letrec*-values
letrec-values
parameterize
syntax-error
unless
when

;; gambit

c-declare
c-define
c-define-type
c-initialize
c-lambda
declare
define-cond-expand-feature
define-macro
define-structure
define-type
define-type-of-thread
define-values
future
import
namespace
r7rs-guard
receive
six.infix
syntax
syntax-case
this-source-file
time

))

;;;============================================================================
