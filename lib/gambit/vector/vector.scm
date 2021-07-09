;;;============================================================================

;;; File: "vector.scm"

;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Vector operations.

;;(##include "vector#.scm")

;;;----------------------------------------------------------------------------

(define-prim-vector-procedures
  vector
  0
  macro-no-force
  macro-no-check
  macro-no-check
  #f
  #f
  define-map-and-for-each
  ##equal?)

(define-prim-vector-procedures
  u8vector
  0
  macro-force-vars
  macro-check-exact-unsigned-int8
  macro-check-exact-unsigned-int8-list
  macro-test-exact-unsigned-int8
  ##fail-check-exact-unsigned-int8
  #f
  ##fx=)

(macro-if-s8vector
 (define-prim-vector-procedures
   s8vector
   0
   macro-force-vars
   macro-check-exact-signed-int8
   macro-check-exact-signed-int8-list
   macro-test-exact-signed-int8
   ##fail-check-exact-signed-int8
   #f
   ##fx=))

(macro-if-u16vector
 (define-prim-vector-procedures
   u16vector
   0
   macro-force-vars
   macro-check-exact-unsigned-int16
   macro-check-exact-unsigned-int16-list
   macro-test-exact-unsigned-int16
   ##fail-check-exact-unsigned-int16
   #f
   ##fx=))

(macro-if-s16vector
 (define-prim-vector-procedures
   s16vector
   0
   macro-force-vars
   macro-check-exact-signed-int16
   macro-check-exact-signed-int16-list
   macro-test-exact-signed-int16
   ##fail-check-exact-signed-int16
   #f
   ##fx=))

(macro-if-u32vector
 (define-prim-vector-procedures
   u32vector
   0
   macro-force-vars
   macro-check-exact-unsigned-int32
   macro-check-exact-unsigned-int32-list
   macro-test-exact-unsigned-int32
   ##fail-check-exact-unsigned-int32
   #f
   ##eqv?))

(macro-if-s32vector
 (define-prim-vector-procedures
   s32vector
   0
   macro-force-vars
   macro-check-exact-signed-int32
   macro-check-exact-signed-int32-list
   macro-test-exact-signed-int32
   ##fail-check-exact-signed-int32
   #f
   ##eqv?))

(macro-if-u64vector
 (define-prim-vector-procedures
   u64vector
   0
   macro-force-vars
   macro-check-exact-unsigned-int64
   macro-check-exact-unsigned-int64-list
   macro-test-exact-unsigned-int64
   ##fail-check-exact-unsigned-int64
   #f
   ##eqv?))

(macro-if-s64vector
 (define-prim-vector-procedures
   s64vector
   0
   macro-force-vars
   macro-check-exact-signed-int64
   macro-check-exact-signed-int64-list
   macro-test-exact-signed-int64
   ##fail-check-exact-signed-int64
   #f
   ##eqv?))

(macro-if-f32vector
 (define-prim-vector-procedures
   f32vector
   0.
   macro-force-vars
   macro-check-inexact-real
   macro-check-inexact-real-list
   macro-test-inexact-real
   ##fail-check-inexact-real
   #f
   ##fleqv?))

(define-prim-vector-procedures
  f64vector
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list
  macro-test-inexact-real
  ##fail-check-inexact-real
  #f
  ##fleqv?)

;;;----------------------------------------------------------------------------

(define-prim (##vector-cas! vect k val oldval)
  ;;TODO: remove after bootstrap
  (##declare (not interrupts-enabled))
  (let ((result (##vector-ref vect k)))
    (if (##eq? result oldval)
        (##vector-set! vect k val))
    result))

(define-prim (vector-cas! vect k val oldval)
  (macro-force-vars (vect k oldval)
    (macro-check-vector vect 1 (vector-cas! vect k val oldval)
      (macro-check-mutable vect 1 (vector-cas! vect k val oldval)
        (macro-check-index-range
          k
          2
          0
          (##vector-length vect)
          (vector-cas! vect k val oldval)
          (##vector-cas! vect k val oldval))))))

(define-prim (##vector-inc! vect k #!optional (val 1))
  ;;TODO: remove after bootstrap
  (##declare (not interrupts-enabled))
  (let ((result (##vector-ref vect k)))
    (##vector-set! vect k (##fxwrap+ result val))
    result))

(define-prim (vector-inc! vect k #!optional (v (macro-absent-obj)))
  (macro-force-vars (vect k v)
    (macro-check-vector vect 1 (vector-inc! vect k v)
      (macro-check-mutable vect 1 (vector-inc! vect k v)
        (macro-check-index-range
          k
          2
          0
          (##vector-length vect)
          (vector-inc! vect k v)
          (let ((val (if (##eq? v (macro-absent-obj)) 1 v)))
            (macro-check-fixnum
              val
              3
              (vector-inc! vect k v)
              (let ((elem (##vector-ref vect k)))
                (macro-check-fixnum
                  elem
                  1
                  (vector-inc! vect k v)
                  (##vector-inc! vect k val))))))))))

(define bytevector?        u8vector?)
(define make-bytevector    make-u8vector)
(define bytevector         u8vector)
(define bytevector-length  u8vector-length)
(define bytevector-u8-ref  u8vector-ref)
(define bytevector-u8-set! u8vector-set!)
(define bytevector-copy    u8vector-copy)
(define bytevector-copy!   u8vector-copy!)
(define bytevector-append  u8vector-append)

;;;============================================================================
