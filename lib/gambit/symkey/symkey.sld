;;;============================================================================

;;; File: "symkey.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Symbol and keyword operations.

(define-library (symkey)

  (namespace "")

  (export

keyword->string
keyword?
string->keyword
string->symbol
string->uninterned-keyword
string->uninterned-symbol
symbol->string
symbol?
uninterned-keyword?
uninterned-symbol?

)

  (include "symkey#.scm"))

;;;============================================================================
