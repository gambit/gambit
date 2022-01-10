;;;============================================================================

;;; File: "dom.sld"

;;; Copyright (c) 2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2022 by Marc-André Bélanger, All Rights Reserved.

;;;============================================================================

(define-library (dom)
  (import (scheme base) (_six js))
  (export querySelector
          getElementById
          createElement
          setAttribute
          appendChild
          insertAdjacentHTML
          console.log
          alert
          load-js)
  (include "dom.scm"))
