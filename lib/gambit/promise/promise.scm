;;;============================================================================

;;; File: "promise.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Promise operations.

(##include "promise#.scm")

;;;----------------------------------------------------------------------------

(define-prim (##make-delay-promise thunk))
(define-prim (##promise-state promise))
(define-prim (##promise-state-set! promise state))

(define-prim (promise? obj)
  (##promise? obj))

(define-prim (make-promise val)
  (if (##promise? val)
      val
      (let ((p (##make-delay-promise #f)))
        (##vector-set! (##promise-state p) 0 val)
        p)))

(define-prim (##force obj)
  (if (##promise? obj)
      (##force-out-of-line obj)
      obj))

(define-prim (force obj)
  (##force obj))

(define-prim (touch obj)
  (##force obj))

;;;============================================================================
