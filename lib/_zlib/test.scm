;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2005-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Test zlib compression/decompression.

;;; TODO: improve the number of tests!

(import _zlib)
(import _test)

(define (test u8vect)
  (check-equal? (gunzip-u8vector (gzip-u8vector u8vect)) u8vect))

(test '#u8())
(test '#u8(65 66 67))

;;;============================================================================
