;;;============================================================================

;;; File: "69.scm"

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
;;; Local version of an unexported macro definition

(define-fail-check-type table (macro-type-table))
(define-check-type table (macro-type-table)
  macro-table?)

;;;============================================================================

(define-syntax with-table-check
    (syntax-rules ()
        ((with-table-check (function-name hash-table . rest) function-def)
         (macro-force-vars (hash-table . rest)
          (macro-check-table
            hash-table
            1
            (function-name hash-table . rest)
            function-def)))))

(define-syntax define-table-check
    (syntax-rules ()
        ((define-table-check (function-name hash-table . rest) function-def)
         (define (function-name hash-table . rest)
            (with-table-check (function-name hash-table . rest) function-def)))))

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
          (macro-force-vars (equal-fn)
            (macro-check-procedure
              equal-fn
              2
              (make-hash-table equal-fn hash-fn)
              (if (eq? hash-fn (macro-absent-obj))
                  (make-table test: equal-fn)
                  (macro-force-vars (hash-fn)
                    (macro-check-procedure
                       hash-fn
                       3
                       (make-hash-table equal-fn hash-fn)
                       (make-table test: equal-fn hash: hash-fn))))))))
 
(define (alist->hash-table
         alist
         #!optional
         (equal-fn (macro-absent-obj))
         (hash-fn (macro-absent-obj)))
     (let ((ht
       (if (eq? equal-fn (macro-absent-obj))
          (make-table)
          (macro-force-vars (equal-fn)
            (macro-check-procedure
              equal-fn
              2
              (alist->hash-table alist equal-fn hash-fn)
              (if (eq? hash-fn (macro-absent-obj))
                  (make-table test: equal-fn)
                  (macro-force-vars (hash-fn)
                    (macro-check-procedure
                       hash-fn
                       3
                       (alist->hash-table alist equal-fn hash-fn)
                       (make-table test: equal-fn hash: hash-fn)))))))))

    (let loop ((x alist))
      (macro-force-vars (x)
        (if (pair? x)
          (let ((couple (car x)))
            (macro-force-vars (couple)
              (macro-check-pair-list
               couple
               1
               (alist->hash-table alist equal-fn hash-fn)
               (let ((key (car couple)))
                 (if (eq? ht (table-ref ht key ht))
                   (table-set! ht key (cdr couple)))
                 (loop (cdr x))))))
          (macro-check-list
           x
           1
           (alist->hash-table alist equal-fn hash-fn)
           ht))))))



;;;============================================================================

;;; Reflexion

(define-table-check (hash-table-equivalence-function ht)
  (or (macro-table-test ht)
      eq?))

(define-table-check (hash-table-hash-function ht)
  (or (macro-table-hash ht)
      eq?-hash))

;;;============================================================================

;;; Dealing with single elements

(define (hash-table-ref ht key #!optional (thunk (macro-absent-obj)))
        (with-table-check (hash-table-ref ht key thunk)
            (if (eq? thunk (macro-absent-obj))
                (table-ref ht key)
                  (macro-check-procedure
                    thunk
                    3
                    (hash-table-ref ht key thunk)
                    (let ((x (table-ref ht key (macro-deleted-obj))))
                                  (if (eq? x (macro-deleted-obj))
                                      (thunk)
                                      x))))))

(define-table-check (hash-table-ref/default ht key default)
  (table-ref ht key default))

(define-table-check (hash-table-set! ht key val)
  (table-set! ht key val))

(define-table-check (hash-table-delete! ht key)
  (table-set! ht key))

(define-table-check (hash-table-exists? ht key)
  (not (eq? (table-ref ht key (macro-deleted-obj))
            (macro-deleted-obj))))


(define (hash-table-update! ht key func #!optional (thunk (macro-absent-obj)))

  (define (update! val)
    (table-set! ht key (func val)))
  
  (with-table-check (hash-table-update! ht key func thunk)
      (let ((val (table-ref ht key (macro-deleted-obj))))
           (macro-check-procedure 
           func
           3
           (hash-table-update! ht key func thunk)     
           (if (eq? val (macro-deleted-obj))
               (if (eq? thunk (macro-absent-obj))
                   (##raise-unbound-key-exception 
                     hash-table-update! ht key func thunk)
                   (macro-check-procedure
                     thunk
                     4
                     (hash-table-update! ht key func thunk)
                     (update! (thunk))))
               (update! val))))))


(define-table-check (hash-table-update!/default ht key func default)
  (macro-check-procedure
    func
    3
    (hash-table-update!/default ht key func default)
    (table-set! ht key (func (table-ref ht key default)))))

;;;============================================================================

;;; Dealing with the whole contents

(define-table-check (hash-table-size ht)
  (table-length ht))

(define-table-check (hash-table-keys ht)
  (map car (table->list ht)))

(define-table-check (hash-table-values ht)
  (map cdr (table->list ht)))

(define-table-check (hash-table-walk ht proc)
  (macro-check-procedure
    proc
    2
    (hash-table-walk ht proc)
    (table-for-each proc ht)))

(define-table-check (hash-table-fold ht func init-value)
  (macro-check-procedure 
    func
    2
    (hash-table-fold ht func init-value)
    (fold (lambda (elem prec)
            (func (car elem) (cdr elem) prec))
          init-value
          (table->list ht))))

(define-table-check (hash-table->alist ht)
  (table->list ht))

(define-table-check (hash-table-copy ht)
  (table-copy ht))

(define (hash-table-merge! ht1 ht2)
  (with-table-check (hash-table-merge! ht1 ht2)
    (macro-check-table 
      ht2
      2
      (hash-table-merge! ht1 ht2)
      (table-merge! ht1 ht2 #f))))

(define (hash obj #!optional (bound (macro-max-fixnum32)))
  (modulo (equal?-hash obj) bound))

(define (string-hash str #!optional (bound (macro-max-fixnum32)))
  (modulo (string=?-hash str) bound))

(define (string-ci-hash str #!optional (bound (macro-max-fixnum32)))
  (modulo (string-ci=?-hash str) bound))

(define (hash-by-identity obj #!optional (bound (macro-max-fixnum32)))
  (modulo (eq?-hash obj) bound))

;;;============================================================================
