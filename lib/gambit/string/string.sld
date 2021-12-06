;;;============================================================================

;;; File: "string.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; String operations.

(define-library (string)

  (namespace "")

  (export

string?
make-string
string
string-length
string-ref
string-set!
string-set
string->list
list->string
string-fill!
string-concatenate
string-copy
string-copy!
substring
string-append
substring-move!
substring-fill!
string-shrink!
string-map
string-for-each
string=?
string<?
string>?
string<=?
string>=?
string-ci=?
string-ci<?
string-ci>?
string-ci<=?
string-ci>=?
string-upcase
string-downcase
string-foldcase
invalid-utf8-encoding-exception?
invalid-utf8-encoding-exception-procedure
invalid-utf8-encoding-exception-arguments
string->utf8
utf8->string

)

  (include "string#.scm"))

;;;============================================================================
