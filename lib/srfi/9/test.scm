;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 9, Defining Record Types

(import (srfi 9))
(import (_test))

;;;============================================================================

(define-record-type :pare
  (kons x y)
  pare?
  (x kar set-kar!)
  (y kdr))

(test-assert (pare? (kons 1 2)))
(test-assert (not (pare? (cons 1 2))))
(test-equal 1 (kar (kons 1 2)))
(test-equal 2 (kdr (kons 1 2)))

(let ((k (kons 1 2)))
  (set-kar! k 3)
  (test-equal 3 (kar k)))

;;;============================================================================
