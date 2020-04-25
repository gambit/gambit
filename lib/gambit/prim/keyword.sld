;;;============================================================================

;;; File: "keyword.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Keyword operations.

(define-library (keyword)

  (namespace "##")

  (export

;; gambit

keyword->string
keyword-hash
keyword?
string->keyword
string->uninterned-keyword
uninterned-keyword?

))

;;;============================================================================
