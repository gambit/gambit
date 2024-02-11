;;;============================================================================

;;; File: "vector.scm"

;;; Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Vector operations.

;;(##include "vector#.scm")

;;;----------------------------------------------------------------------------

(define-prim-vector-procedures
  vector
  obj
  object
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
  u8value
  exact-unsigned-int8
  0
  macro-force-vars
  macro-check-exact-unsigned-int8
  macro-check-exact-unsigned-int8-list-exact-unsigned-int8
  macro-test-exact-unsigned-int8
  ##fail-check-exact-unsigned-int8
  #f
  ##fx=)

(macro-if-s8vector
 (define-prim-vector-procedures
   s8vector
   s8value
   exact-signed-int8
   0
   macro-force-vars
   macro-check-exact-signed-int8
   macro-check-exact-signed-int8-list-exact-signed-int8
   macro-test-exact-signed-int8
   ##fail-check-exact-signed-int8
   #f
   ##fx=))

(macro-if-u16vector
 (define-prim-vector-procedures
   u16vector
   u16value
   exact-unsigned-int16
   0
   macro-force-vars
   macro-check-exact-unsigned-int16
   macro-check-exact-unsigned-int16-list-exact-unsigned-int16
   macro-test-exact-unsigned-int16
   ##fail-check-exact-unsigned-int16
   #f
   ##fx=))

(macro-if-s16vector
 (define-prim-vector-procedures
   s16vector
   s16value
   exact-signed-int16
   0
   macro-force-vars
   macro-check-exact-signed-int16
   macro-check-exact-signed-int16-list-exact-signed-int16
   macro-test-exact-signed-int16
   ##fail-check-exact-signed-int16
   #f
   ##fx=))

(macro-if-u32vector
 (define-prim-vector-procedures
   u32vector
   u32value
   exact-unsigned-int32
   0
   macro-force-vars
   macro-check-exact-unsigned-int32
   macro-check-exact-unsigned-int32-list-exact-unsigned-int32
   macro-test-exact-unsigned-int32
   ##fail-check-exact-unsigned-int32
   #f
   ##eqv?))

(macro-if-s32vector
 (define-prim-vector-procedures
   s32vector
   s32value
   exact-signed-int32
   0
   macro-force-vars
   macro-check-exact-signed-int32
   macro-check-exact-signed-int32-list-exact-signed-int32
   macro-test-exact-signed-int32
   ##fail-check-exact-signed-int32
   #f
   ##eqv?))

(macro-if-u64vector
 (define-prim-vector-procedures
   u64vector
   u64value
   exact-unsigned-int64
   0
   macro-force-vars
   macro-check-exact-unsigned-int64
   macro-check-exact-unsigned-int64-list-exact-unsigned-int64
   macro-test-exact-unsigned-int64
   ##fail-check-exact-unsigned-int64
   #f
   ##eqv?))

(macro-if-s64vector
 (define-prim-vector-procedures
   s64vector
   s64value
   exact-signed-int64
   0
   macro-force-vars
   macro-check-exact-signed-int64
   macro-check-exact-signed-int64-list-exact-signed-int64
   macro-test-exact-signed-int64
   ##fail-check-exact-signed-int64
   #f
   ##eqv?))

(macro-if-f32vector
 (define-prim-vector-procedures
   f32vector
   f32value
   inexact-real
   0.
   macro-force-vars
   macro-check-inexact-real
   macro-check-inexact-real-list-inexact-real
   macro-test-inexact-real
   ##fail-check-inexact-real
   #f
   ##fleqv?))

(define-prim-vector-procedures
  f64vector
  f64value
  inexact-real
  0.
  macro-force-vars
  macro-check-inexact-real
  macro-check-inexact-real-list-inexact-real
  macro-test-inexact-real
  ##fail-check-inexact-real
  #f
  ##fleqv?)

(define-prim-vector-procedures
  values
  obj
  object
  0
  macro-no-force
  macro-no-check
  macro-no-check
  #f
  #f
  #f
  ##equal?)

;;;----------------------------------------------------------------------------

(define-prim (##vector-cas! vect k val oldval))

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

(define-prim (##vector-inc! vect k val))

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

(define-procedure (vector-every (pred procedure)
				(x vector)
				(y vector) ...)

  (define (vect-every-1 x)

    (define (vect-every-1 i last)
      (if (fx< i last)
          (and (macro-auto-force (pred (vector-ref x i)))
               (vect-every-1 (fx+ i 1) last))
          (pred (vector-ref x i))))  ;; last call in tail position

    (let ((len (vector-length x)))
      (or (fx= len 0)
          (vect-every-1 0 (fx- len 1)))))

  (define (vect-every-n len rev-x-y)

    (define (get-args i)
      (let loop ((lst rev-x-y)
                 (args '()))
        (if (pair? lst)
            (loop (cdr lst)
                  (cons
                   (vector-ref (car lst) i)
                   args))
            args)))

    (define (vect-every-n i last)
      (if (fx< i last)
          (and (macro-auto-force (apply pred (get-args i)))
               (vect-every-n (fx+ i 1) last))
          (apply pred (get-args i))))  ;; last call in tail position

    (or (fx= len 0)
        (vect-every-n 0 (fx- len 1))))

  (if (null? y)
      (vect-every-1 x)
      (if ##allow-length-mismatch?

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (arg-num 3))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-every pred . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (loop (cdr lst)
                                (cons arg rev-x-y)
                                (fxmin min-len len-arg)
                                (fx+ arg-num 1))))))
                  (vect-every-n min-len rev-x-y))))

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (max-len len-x)
                       (max-arg 2)
                       (arg-num 3))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-every pred . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (if (fx> len-arg max-len)
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    len-arg
                                    max-len
                                    arg-num
                                    (fx+ arg-num 1))
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    (fxmin min-len
                                           len-arg)
                                    max-len
                                    max-arg
                                    (fx+ arg-num 1)))))))
                  (if (fx= min-len max-len)
                      (vect-every-n min-len rev-x-y)
                      (##raise-length-mismatch-exception
                       max-arg
                       '()
                       vector-every
                       pred
                       x-y))))))))

(define-procedure (vector-any (pred procedure)
			      (x vector)
			      (y vector) ...)

  (define (vect-any-1 x)

    (define (vect-any-1 i last)
      (if (fx< i last)
          (or (macro-auto-force (pred (vector-ref x i)))
              (vect-any-1 (fx+ i 1) last))
          (pred (vector-ref x i))))  ;; last call in tail position

    (let ((len (vector-length x)))
      (and (fx> len 0)
           (vect-any-1 0 (fx- len 1)))))

  (define (vect-any-n len rev-x-y)

    (define (get-args i)
      (let loop ((lst rev-x-y)
                 (args '()))
        (if (pair? lst)
            (loop (cdr lst)
                  (cons
                   (vector-ref (car lst) i)
                   args))
            args)))

    (define (vect-any-n i last)
      (if (fx< i last)
          (or (macro-auto-force (apply pred (get-args i)))
              (vect-any-n (fx+ i 1) last))
          (apply pred (get-args i))))  ;; last call in tail position

    (and (fx> len 0)
         (vect-any-n 0 (fx- len 1))))

  (if (null? y)
      (vect-any-1 x)
      (if ##allow-length-mismatch?

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (arg-num 3))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-any pred . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (loop (cdr lst)
                                (cons arg rev-x-y)
                                (fxmin min-len len-arg)
                                (fx+ arg-num 1))))))
                  (vect-any-n min-len rev-x-y))))

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (max-len len-x)
                       (max-arg 2)
                       (arg-num 3))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-any pred . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (if (fx> len-arg max-len)
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    len-arg
                                    max-len
                                    arg-num
                                    (fx+ arg-num 1))
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    (fxmin min-len
                                           len-arg)
                                    max-len
                                    max-arg
                                    (fx+ arg-num 1)))))))
                  (if (fx= min-len max-len)
                      (vect-any-n min-len rev-x-y)
                      (##raise-length-mismatch-exception
                       max-arg
                       '()
                       vector-any
                       pred
                       x-y))))))))

(define-procedure (vector-fold (kons procedure)
                               (knil object)
                               (x vector)
                               (y vector) ...)

  (define (vect-fold-1 x)

    (define (vect-fold-1 state i)
      (if (fx< i (vector-length x))
          (vect-fold-1 (kons state (vector-ref x i))
                       (fx+ i 1))
          state))

    (vect-fold-1 knil 0))

  (define (vect-fold-n len rev-x-y)

    (define (vect-fold-n state i)
      (if (fx< i len)
          (let loop ((lst rev-x-y)
                     (args '()))
            (if (pair? lst)
                (loop (cdr lst)
                      (cons
                       (vector-ref (car lst) i)
                       args))
                (vect-fold-n (apply kons state args)
                             (fx+ i 1))))
          state))

    (vect-fold-n knil 0))

  (if (null? y)
      (vect-fold-1 x)
      (if ##allow-length-mismatch?

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (arg-num 4))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-fold kons knil . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (loop (cdr lst)
                                (cons arg rev-x-y)
                                (fxmin min-len len-arg)
                                (fx+ arg-num 1))))))
                  (vect-fold-n min-len rev-x-y))))

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (max-len len-x)
                       (max-arg 3)
                       (arg-num 4))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-fold kons knil . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (if (fx> len-arg max-len)
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    len-arg
                                    max-len
                                    arg-num
                                    (fx+ arg-num 1))
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    (fxmin min-len
                                           len-arg)
                                    max-len
                                    max-arg
                                    (fx+ arg-num 1)))))))
                  (if (fx= min-len max-len)
                      (vect-fold-n min-len rev-x-y)
                      (##raise-length-mismatch-exception
                       max-arg
                       '()
                       vector-fold
                       kons
                       knil
                       x-y))))))))

(define-procedure (vector-fold-right (kons procedure)
                                     (knil object)
                                     (x vector)
                                     (y vector) ...)

  (define (vect-fold-right-1 x)

    (define (vect-fold-right-1 state i)
      (if (fx< i 0)
          state
          (vect-fold-right-1 (kons state (vector-ref x i))
                             (fx- i 1))))

    (vect-fold-right-1 knil (fx- (vector-length x) 1)))

  (define (vect-fold-right-n len rev-x-y)

    (define (vect-fold-right-n state i)
      (if (fx< i 0)
          state
          (let loop ((lst rev-x-y)
                     (args '()))
            (if (pair? lst)
                (loop (cdr lst)
                      (cons
                       (vector-ref (car lst) i)
                       args))
                (vect-fold-right-n (apply kons state args)
                                   (fx- i 1))))))

    (vect-fold-right-n knil (fx- len 1)))

  (if (null? y)
      (vect-fold-right-1 x)
      (if ##allow-length-mismatch?

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (arg-num 4))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-fold-right kons knil . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (loop (cdr lst)
                                (cons arg rev-x-y)
                                (fxmin min-len len-arg)
                                (fx+ arg-num 1))))))
                  (vect-fold-right-n min-len rev-x-y))))

          (let ((len-x (vector-length x))
                (x-y (cons x y)))
            (let loop ((lst y)
                       (rev-x-y (cons x '()))
                       (min-len len-x)
                       (max-len len-x)
                       (max-arg 3)
                       (arg-num 4))
              (if (pair? lst)
                  (let ((arg (car lst)))
                    (macro-force-vars (arg)
                      (macro-check-vector
                        arg
                        arg-num
                        (vector-fold-right kons knil . x-y)
                        (let ((len-arg
                               (vector-length arg)))
                          (if (fx> len-arg max-len)
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    len-arg
                                    max-len
                                    arg-num
                                    (fx+ arg-num 1))
                              (loop (cdr lst)
                                    (cons arg rev-x-y)
                                    (fxmin min-len
                                           len-arg)
                                    max-len
                                    max-arg
                                    (fx+ arg-num 1)))))))
                  (if (fx= min-len max-len)
                      (vect-fold-right-n min-len rev-x-y)
                      (##raise-length-mismatch-exception
                       max-arg
                       '()
                       vector-fold-right
                       kons
                       knil
                       x-y))))))))

(define-procedure (vector-unfold (proc procedure)
                                 (len  index)
                                 (seed object) ...)

  (define (vect-unfold-0)

    (define (vect-unfold-0 i)
      (if (fx< i len)
          (let* ((elt
                  (proc i))
                 (vect
                  (vect-unfold-0 (fx+ i 1))))
            (vector-set! vect i elt)
            vect)
          (make-vector len)))

    (vect-unfold-0 0))

  (define (vect-unfold-1 seed)

    (define (vect-unfold-1 i seed)
      (if (fx< i len)
          (receive (elt new-seed)
              (proc i seed)
            (let ((vect
                   (vect-unfold-1 (fx+ i 1) new-seed)))
              (vector-set! vect i elt)
              vect))
          (make-vector len)))

    (vect-unfold-1 0 seed))

  (define (vect-unfold-n seeds)

    (define (vect-unfold-n i seeds)
      (if (fx< i len)
          (receive (elt . new-seeds)
              (apply proc i seeds)
            (let ((vect
                   (vect-unfold-n (fx+ i 1) new-seeds)))
              (vector-set! vect i elt)
              vect))
          (make-vector len)))

    (vect-unfold-n 0 seeds))

  (cond ((null? seed)
         (vect-unfold-0))
        ((null? (cdr seed))
         (vect-unfold-1 (car seed)))
        (else
         (vect-unfold-n seed))))

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
