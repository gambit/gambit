;;;============================================================================

;;; File: "char.sld"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Character operations.

(define-library (char)

  (namespace "")

  (export

char?
char=?
char<?
char>?
char<=?
char>=?
char-ci=?
char-ci<?
char-ci>?
char-ci<=?
char-ci>=?
char-alphabetic?
char-numeric?
char-whitespace?
char-upper-case?
char-lower-case?
char->integer
integer->char
char-upcase
char-downcase
char-foldcase
digit-value

)

  (include "char#.scm"))

;;;============================================================================
