;;;============================================================================

;;; File: "string.sld"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

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

string-ci=?-hash
string-concatenate
string-contains
string-contains-ci
string-prefix-ci?
string-prefix-length
string-prefix-length-ci
string-prefix?
string-set
string-shrink!
string-suffix-ci?
string-suffix-length
string-suffix-length-ci
string-suffix?
string=?-hash
substring-fill!
substring-move!

))

;;;============================================================================
