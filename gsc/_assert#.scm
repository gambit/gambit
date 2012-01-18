;;;============================================================================

;;; File: "_assert#.scm"

;;; Copyright (c) 2010-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(namespace ("_assert#"

assert-implement

if-assertion-testing-enabled

assert
assert-failed

))

;;;============================================================================

(define-macro (assert-implement)
  `(begin))

(define-macro (if-assertion-testing-enabled yes #!optional (no `(begin)))
  yes
;;  no
)

(define-macro (assert must-be-true . fail-msgs)
  `(if-assertion-testing-enabled
    (if (not ,must-be-true)
        (assert-failed ,@fail-msgs))))

(define-macro (assert-failed . fail-msgs)
  `(error ,@fail-msgs))

;;;============================================================================
