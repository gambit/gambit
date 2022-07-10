;;;============================================================================

;;; File: "13#.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 13, String Libraries

(##namespace ("srfi/13#"

string? string-null?
string-every string-any

make-string string string-tabulate

string->list list->string
reverse-list->string string-join

string-length
string-ref
string-copy
substring/shared
string-copy!
string-take string-take-right
string-drop string-drop-right
string-pad  string-pad-right
string-trim string-trim-right string-trim-both

string-set! string-fill!

string-compare string-compare-ci
string<>     string=    string<    string>    string<=    string>=
string-ci<>  string-ci= string-ci< string-ci> string-ci<= string-ci>=
string-hash  string-hash-ci

string-prefix-length    string-suffix-length
string-prefix-length-ci string-suffix-length-ci

string-prefix?    string-suffix?
string-prefix-ci? string-suffix-ci?

string-index string-index-right
string-skip  string-skip-right
string-count
string-contains string-contains-ci

string-titlecase  string-upcase  string-downcase
string-titlecase! string-upcase! string-downcase!

string-reverse string-reverse!
string-append
string-concatenate
string-concatenate/shared string-append/shared
string-concatenate-reverse string-concatenate-reverse/shared

string-map      string-map!
string-fold     string-fold-right
string-unfold   string-unfold-right
string-for-each string-for-each-index

xsubstring string-xcopy!

string-replace string-tokenize

string-filter string-delete

string-parse-start+end
string-parse-final-start+end
let-string-start+end

check-substring-spec
substring-spec-ok?

make-kmp-restart-vector kmp-step string-kmp-partial-search

))

;;;============================================================================
