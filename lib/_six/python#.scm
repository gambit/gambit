;;;============================================================================

;;; File: "python#.scm"

;;; Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2021-2022 by Marc-André Bélanger, All Rights Reserved.

;;;============================================================================

;; Implementation of the six.infix special form for Python.

(##namespace ("_six/python#"

six.infix

))

(##define-syntax six.infix
  (lambda (src)
    (import _six/six-expand)
    (six.infix-python-expand src)))

;;;============================================================================
