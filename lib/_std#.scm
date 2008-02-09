;;;============================================================================

;;; File: "_std#.scm", Time-stamp: <2008-02-08 22:44:13 feeley>

;;; Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Representation of exceptions.

(define-library-type-of-exception improper-length-list-exception
  id: 15d36810-b4bf-4609-83cc-761a8868e4a0
  constructor: #f
  opaque:

  (procedure unprintable: read-only:)
  (arguments unprintable: read-only:)
  (arg-num   unprintable: read-only:)
)

;;;----------------------------------------------------------------------------

;;; Define type checking macros.

(define-check-type string 'string
  ##string?)

(define-check-type string-list 'string-list
  ##string?)

(define-check-type vector 'vector
  ##vector?)

(define-check-type vector-list 'vector-list
  ##vector?)

(define-check-type s8vector 's8vector
  ##s8vector?)

(define-check-type s8vector-list 's8vector-list
  ##s8vector?)

(define-check-type u8vector 'u8vector
  ##u8vector?)

(define-check-type u8vector-list 'u8vector-list
  ##u8vector?)

(define-check-type s16vector 's16vector
  ##s16vector?)

(define-check-type s16vector-list 's16vector-list
  ##s16vector?)

(define-check-type u16vector 'u16vector
  ##u16vector?)

(define-check-type u16vector-list 'u16vector-list
  ##u16vector?)

(define-check-type s32vector 's32vector
  ##s32vector?)

(define-check-type s32vector-list 's32vector-list
  ##s32vector?)

(define-check-type u32vector 'u32vector
  ##u32vector?)

(define-check-type u32vector-list 'u32vector-list
  ##u32vector?)

(define-check-type s64vector 's64vector
  ##s64vector?)

(define-check-type s64vector-list 's64vector-list
  ##s64vector?)

(define-check-type u64vector 'u64vector
  ##u64vector?)

(define-check-type u64vector-list 'u64vector-list
  ##u64vector?)

(define-check-type f32vector 'f32vector
  ##f32vector?)

(define-check-type f32vector-list 'f32vector-list
  ##f32vector?)

(define-check-type f64vector 'f64vector
  ##f64vector?)

(define-check-type f64vector-list 'f64vector-list
  ##f64vector?)

(define-check-type pair-mutable 'mutable
  ##pair-mutable?)

(define-check-type subtyped-mutable 'mutable
  ##subtyped-mutable?)

(define-check-type pair 'pair
  ##pair?)

(define-check-type pair-list 'pair-list
  ##pair?)

(define-check-type list 'list
  ##null?)

(define-check-type symbol 'symbol
  ##symbol?)

(define-check-type char 'char
  ##char?)

(define-check-type char-list 'char-list
  ##char?)

(define-check-type procedure 'procedure
  ##procedure?)

(define-check-type keyword 'keyword
  ##keyword?)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(##define-macro (macro-fail-check-list arg-num form)

  (define (rest-param x)
    (if (pair? x)
        (rest-param (cdr x))
        x))

  (define (nonrest-params x)
    (if (pair? x)
      (cons (car x) (nonrest-params (cdr x)))
      '()))

  (define (key-params x)
    (if (pair? x)
      (if (keyword? (car x))
        (cons (car x) (cons (cadr x) (key-params (cddr x))))
        (key-params (cdr x)))
      '()))

  (define (prekey-params x)
    (if (or (not (pair? x)) (keyword? (car x)))
      '()
      (cons (car x) (prekey-params (cdr x)))))

  (define (failure name)
    (let* ((k (key-params (cdr form)))
           (r (rest-param (cdr form)))
           (nr (nonrest-params (cdr form)))
           (pk (prekey-params nr)))
      (if (and (null? k) (not (null? r)))
        `(,name ,arg-num '() ,(car form) ,@pk ,r)
        `(,name
          ,arg-num
          ,(if (and (null? k) (null? r))
             (car form)
             `(##list ,(car form) ,@k ,@(if (null? r) '() (list r))))
          ,@pk))))

  (failure '##fail-check-list))

;;;============================================================================
