;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 124, Ephemerons

(import (srfi 124))
(import (_test))

;=========================================================================

;; ephemeron?

(test-assert (not (ephemeron? #f)))
(test-assert (not (ephemeron? (cons 1 2))))

(test-assert (ephemeron? (make-ephemeron (cons 1 2) (cons 3 4))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron?))

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron? 1 2))

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron? 1 2))

(test-error-tail
 wrong-number-of-arguments-exception?
 (make-ephemeron))

;; make-ephemeron

(test-error-tail
 wrong-number-of-arguments-exception?
 (make-ephemeron))

(test-error-tail
 wrong-number-of-arguments-exception?
 (make-ephemeron 1 2 3))

;; reference-barrier

(test-error-tail
 wrong-number-of-arguments-exception?
 (reference-barrier))

(test-error-tail
 wrong-number-of-arguments-exception?
 (reference-barrier 1 2))

;; ephemeron-broken?

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron-broken?))

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron-broken? 1 2))

(test-error-tail
 type-exception?
 (ephemeron-broken? #f))

;; ephemeron-key

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron-key))

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron-key 1 2))

(test-error-tail
 type-exception?
 (ephemeron-key #f))

(let ((key (cons 1 2)))
  (let ((ephemeron (make-ephemeron key (cons 3 4))))
    (##gc)
    (test-equal (cons 1 2) (ephemeron-key ephemeron))
    (reference-barrier key)))

(let ((ephemeron
       (let ((key (cons 1 2)))
         (make-ephemeron key (cons 3 4)))))
  (##gc)
  (test-equal #f (ephemeron-key ephemeron)))

;; ephemeron-datum

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron-datum))

(test-error-tail
 wrong-number-of-arguments-exception?
 (ephemeron-datum 1 2))

(test-error-tail
 type-exception?
 (ephemeron-datum #f))

(let ((key (cons 1 2)))
  (let ((ephemeron (make-ephemeron key (cons 3 4))))
    (##gc)
    (test-equal (cons 3 4) (ephemeron-datum ephemeron))
    (reference-barrier key)))

(let ((ephemeron
       (let ((key (cons 1 2)))
         (make-ephemeron key (cons 3 4)))))
  (##gc)
  (test-equal #f (ephemeron-datum ephemeron)))

;;;=========================================================================
