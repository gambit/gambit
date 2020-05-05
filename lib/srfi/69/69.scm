;;;============================================================================

;;; File: "69.scm"

;;; Copyright (c) 2018-2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 69, Basic hash tables

(##supply-module srfi/69)

(##namespace ("srfi/69#"))                ;; in srfi/69#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-string,
                                          ;; macro-absent-obj, etc

(##include "69#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;============================================================================

;;; Local version of an unexported macro definition

(define-check-type table (macro-type-table)
  macro-table?)

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

(define 
  (alist->hash-table alist
                     #!optional
                      (equal-fn (macro-absent-obj))
                      (hash-fn  (macro-absent-obj)))
    (macro-force-vars (alist equal-fn hash-fn)
      (macro-check-pair-list
          alist
          0
          (alist->hash-table alist equal-fn hash-fn)
        (if (eq? equal-fn (macro-absent-obj))
            (list->table alist)
            (macro-check-procedure
                equal-fn
                1
                (alist->hash-table alist equal-fn hash-fn)
              (if (eq? hash-fn (macro-absent-obj))
                  (list->table alist test: equal-fn)
                  (macro-check-procedure
                      hash-fn
                      2
                      (alist->hash-table alist equal-fn hash-fn)
                    (list->table alist test: equal-fn hash: hash-fn))))))))


;;;============================================================================

;;; Reflexion

(define
  (hash-table-equivalence-function ht)
    (macro-force-vars (ht)
      (macro-check-table
          ht
          0
          (hash-table-equivalence-function ht)
        (or (macro-table-test ht)
            eq?))))

(define 
  (hash-table-hash-function ht)
    (macro-force-vars (ht)
      (macro-check-table
          ht
          0
          (hash-table-hash-function ht)
      (or (macro-table-hash ht)
          eq?-hash))))


;;;============================================================================

;;; Dealing with single elements

(define
  (hash-table-ref ht key #!optional (thunk (macro-absent-obj)))
    (macro-force-vars (ht thunk)
      (macro-check-table 
          ht
          0
          (hash-table-ref ht key thunk)
        (let ((val (table-ref ht key (macro-deleted-obj))))
          (if (eq? val (macro-deleted-obj))
              (if (eq? thunk (macro-absent-obj))
                  (##raise-unbound-key-exception hash-table-ref ht key thunk)
                  (macro-check-procedure
                      thunk
                      2
                      (hash-table-ref ht key thunk)
                    (thunk)))
              val)))))

(define-procedure
  (hash-table-ref/default (ht table) 
                          key 
                          default)
    (table-ref ht key default))

(define-procedure
  (hash-table-set! (ht table) 
                   key 
                   val)
    (table-set! ht key val))

(define-procedure
  (hash-table-delete! (ht table) 
                      key)
    (table-set! ht key))

(define-procedure
  (hash-table-exists? (ht table) 
                      key)
    (not (eq? (table-ref ht key (macro-deleted-obj))
              (macro-deleted-obj))))

(define
  (hash-table-update! ht key func
                      #!optional (thunk (macro-absent-obj)))
  (define (update! val)
      (table-set! ht key (func val)))

  (macro-force-vars (ht func)
    (macro-check-table 
        ht
        0
        (hash-table-update! ht key func thunk)
      (macro-check-procedure
          func
          2
          (hash-table-update! ht key func thunk)
        (let ((val (table-ref ht key (macro-deleted-obj))))
                (if (eq? val (macro-deleted-obj))
                    (if (eq? thunk (macro-absent-obj))
                        (##raise-unbound-key-exception hash-table-update! ht key func thunk)
                        (update! (thunk)))
                    (update! val)))))))

(define-procedure
  (hash-table-update!/default (ht table)
                              key 
                              (func procedure)
                              default)
  (table-set! ht key (func (table-ref ht key default))))


;;;============================================================================

;;; Dealing with the whole contents

(define-procedure
  (hash-table-size (ht table))
    (table-length ht))


(define-procedure
  (hash-table-keys (ht table))
    (map car (table->list ht)))

(define-procedure
  (hash-table-values (ht table))
    (map cdr (table->list ht)))

(define-procedure
  (hash-table-walk (ht   table) 
                   (proc procedure))
    (table-for-each proc ht))

(define-procedure
  (hash-table-fold (ht table)
                   (f  procedure)
                   init-value)
  (fold (lambda (elem prec)
          (f (car elem) (cdr elem) prec))
        init-value
        (table->list ht)))

(define-procedure
  (hash-table->alist (ht table))
    (table->list ht))

(define-procedure
  (hash-table-copy (ht table))
    (table-copy ht))

(define-procedure
  (hash-table-merge! (ht1 table)
                     (ht2 table))
    (table-merge! ht1 ht2 #f))

(define-procedure
  (hash obj
        (bound fixnum (macro-max-fixnum32)))
    (modulo (equal?-hash obj) bound))

(define-procedure
  (string-hash (str   string) 
               (bound fixnum (macro-max-fixnum32)))
    (modulo (string=?-hash str) bound))

(define-procedure
  (string-ci-hash (str   string) 
                  (bound fixnum (macro-max-fixnum32)))
    (modulo (string-ci=?-hash str) bound))

(define-procedure 
  (hash-by-identity obj 
                   (bound fixnum (macro-max-fixnum32)))
    (modulo (eq?-hash obj) bound))


;;;============================================================================
