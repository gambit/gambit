;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2005-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Test zlib compression/decompression.

;;; TODO: improve the number of tests!

(import _zlib)
(import _test)

(define (test u8vect)
  (test-equal u8vect (gunzip-u8vector (gzip-u8vector u8vect))))

(test '#u8())
(test '#u8(65 66 67))

;;;============================================================================
