;;;============================================================================

;;; File: "js#.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Implementation of the six.infix special form for JavaScript.

(##namespace ("_six/js#"

six.infix

))

(##define-syntax six.infix
  (lambda (src)
    (##import _six/six-expand)
    (six.infix-js-expand src)))

;;;============================================================================
