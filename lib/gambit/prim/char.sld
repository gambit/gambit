;;;============================================================================

;;; File: "char.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Character operations.

(define-library (char)

  (namespace "##")

  (export

;; r4rs

char->integer
char-alphabetic?
char-ci<=?
char-ci<?
char-ci=?
char-ci>=?
char-ci>?
char-downcase
char-lower-case?
char-numeric?
char-upcase
char-upper-case?
char-whitespace?
char<=?
char<?
char=?
char>=?
char>?
char?
integer->char

;; r7rs

char-foldcase
digit-value

))

;;;============================================================================
