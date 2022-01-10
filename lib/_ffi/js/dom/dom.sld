;;;============================================================================

;;; File: "dom.sld"

;;; Copyright (c) 2022 by Marc-André Bélanger, All Rights Reserved.

;;;============================================================================

(define-library (js dom)
  (import (gambit))
  (export
   select
   get
   create-element
   set-attribute
   append-child
   insert-adjacent-html
   log
   alert
   load-js))
