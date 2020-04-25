;;;============================================================================

;;; File: "symbol.sld"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Symbol operations.

(define-library (symbol)

  (namespace "##")

  (export

;; r4rs

string->symbol
symbol->string
symbol?

;; r7rs

symbol=?

;; gambit

gensym
string->uninterned-symbol
symbol-hash
uninterned-symbol?

))

;;;============================================================================
