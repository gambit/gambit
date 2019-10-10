;;;============================================================================

;;; File: "_prim-string-r7rs#.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; String operations added by R7RS.

(##namespace ("##"

string->utf8
(string->vector string->vector#unimplemented)
string-copy!
string-downcase
string-foldcase
(string-for-each string-for-each#unimplemented)
(string-map string-map#unimplemented)
string-upcase
utf8->string
(vector->string vector->string#unimplemented)

))

;;;============================================================================
