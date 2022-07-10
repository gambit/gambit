;;;============================================================================

;;; File: "string-r7rs#.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; String operations added by R7RS.

(##namespace ("##"

string->utf8
(string->vector unimplemented#string->vector)
string-copy!
string-downcase
string-foldcase
(string-for-each unimplemented#string-for-each)
(string-map unimplemented#string-map)
string-upcase
utf8->string
(vector->string unimplemented#vector->string)

))

;;;============================================================================
