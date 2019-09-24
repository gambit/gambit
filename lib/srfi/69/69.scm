;;;============================================================================

;;; File: "srfi/69/69.scm"

;;; Copyright (c) 2018-2019 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 69, Basic hash tables

(##supply-module srfi/69)

(##namespace ("srfi/69#"))       ;; in srfi/69#
(##include "~~lib/_prim#.scm")   ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm") ;; for macro-check-string,
                                 ;; macro-absent-obj, etc

(##include "69#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

;;; Type constructors and predicate

(define (hash-table? ht)
  (table? ht))

(define (make-hash-table
         #!optional
         (equal-fn (macro-absent-obj))
         (hash-fn (macro-absent-obj)))
  (if (eq? equal-fn (macro-absent-obj))
      (make-table)
      (if (eq? hash-fn (macro-absent-obj))
          (make-table test: equal-fn)
          (make-table test: equal-fn hash: hash-fn))))

(define (alist->hash-table
         alist
         #!optional
         (equal-fn (macro-absent-obj))
         (hash-fn (macro-absent-obj)))
  (if (eq? equal-fn (macro-absent-obj))
      (list->table alist)
      (if (eq? hash-fn (macro-absent-obj))
          (list->table alist test: equal-fn)
          (list->table alist test: equal-fn hash: hash-fn))))

;;;============================================================================

;;; Reflexion

(define (hash-table-equivalence-function ht)
  (or (macro-table-test ht)
      eq?))

(define (hash-table-hash-function ht)
  (or (macro-table-hash ht)
      eq?-hash))

;;;============================================================================

;;; Dealing with single elements

(define (hash-table-ref ht key #!optional (thunk (macro-absent-obj)))
  (let ((val (table-ref ht key (macro-deleted-obj))))
    (if (eq? val (macro-deleted-obj))
        (if (eq? thunk (macro-absent-obj))
            (##raise-unbound-key-exception hash-table-ref ht key thunk)
            (thunk))
        val)))

(define (hash-table-ref/default ht key default)
  (table-ref ht key default))

(define (hash-table-set! ht key val)
  (table-set! ht key val))

(define (hash-table-delete! ht key)
  (table-set! ht key))

(define (hash-table-exists? ht key)
  (not (eq? (table-ref ht key (macro-deleted-obj))
            (macro-deleted-obj))))

(define (hash-table-update! ht key func #!optional (thunk (macro-absent-obj)))

  (define (update! val)
    (table-set! ht key (func val)))

  (let ((val (table-ref ht key (macro-deleted-obj))))
    (if (eq? val (macro-deleted-obj))
        (if (eq? thunk (macro-absent-obj))
            (##raise-unbound-key-exception hash-table-update! ht key func thunk)
            (update! (thunk)))
        (update! val))))

(define (hash-table-update!/default ht key func default)
  (table-set! ht key (func (table-ref ht key default))))

;;;============================================================================

;;; Dealing with the whole contents

(define (hash-table-size ht)
  (table-length ht))

(define (hash-table-keys ht)
  (map car (table->list ht)))

(define (hash-table-values ht)
  (map cdr (table->list ht)))

(define (hash-table-walk ht proc)
  (table-for-each proc ht))

(define (hash-table-fold ht f init-value)
  (fold (lambda (elem prec)
          (f (car elem) (cdr elem) prec))
        init-value
        (table->list ht)))

(define (hash-table->alist ht)
  (table->list ht))

(define (hash-table-copy ht)
  (table-copy ht))

(define (hash-table-merge! ht1 ht2)
  (table-merge! ht1 ht2 #f))

(define (hash obj #!optional (bound (macro-max-fixnum32)))
  (modulo (equal?-hash obj) bound))

(define (string-hash str #!optional (bound (macro-max-fixnum32)))
  (modulo (string=?-hash str) bound))

(define (string-ci-hash str #!optional (bound (macro-max-fixnum32)))
  (modulo (string-ci=?-hash str) bound))

(define (hash-by-identity obj #!optional (bound (macro-max-fixnum32)))
  (modulo (eq?-hash obj) bound))

;;;============================================================================
