;;;============================================================================

;;; File: "special-forms.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

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
force
if
lambda
let
let*
letrec
or
quasiquote
quote
set!

;; r7rs

case-lambda
cond-expand
define-record-type
define-syntax
delay-force
guard
include
include-ci
let*-values
let-syntax
let-values
letrec*
letrec*-values
letrec-syntax
letrec-values
parameterize
syntax-error
syntax-rules
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
future
namespace
r7rs-guard
receive
this-source-file
time

))

;;;============================================================================
