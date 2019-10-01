;;;============================================================================

;;; File: "srfi/9/9-test.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 9, Defining Record Types

(import (srfi 9))
(import (gambit test))

;;;============================================================================

(define-record-type :pare
  (kons x y)
  pare?
  (x kar set-kar!)
  (y kdr))

(check-true (pare? (kons 1 2)))
(check-false (pare? (cons 1 2)))
(check-equal? (kar (kons 1 2)) 1)
(check-equal? (kdr (kons 1 2)) 2)

(let ((k (kons 1 2)))
  (set-kar! k 3)
  (check-equal? (kar k) 3))

;;;============================================================================
