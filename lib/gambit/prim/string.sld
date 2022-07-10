;;;============================================================================

;;; File: "string.sld"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; String operations.

(define-library (string)

  (namespace "##")

  (export

;; r4rs

list->string
make-string
string
string->list
string-append
string-ci<=?
string-ci<?
string-ci=?
string-ci>=?
string-ci>?
string-copy
string-fill!
string-length
string-ref
string-set!
string<=?
string<?
string=?
string>=?
string>?
string?
substring

;; r7rs

string->utf8
;;UNIMPLEMENTED string->vector
string-copy!
string-downcase
string-foldcase
;;UNIMPLEMENTED string-for-each
;;UNIMPLEMENTED string-map
string-upcase
utf8->string
;;UNIMPLEMENTED vector->string

;; gambit

string-concatenate
string-ci=?-hash
string-set
string-shrink!
string=?-hash
substring-fill!
substring-move!

))

;;;============================================================================
