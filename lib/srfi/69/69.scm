;;;============================================================================

;;; File: "gambit/srfi/69/69.scm"

;;; 2018-2019 by Antoine Doucet.

;;;============================================================================

;;; Basic hash tables (srfi-69).

(##supply-module srfi/69)

(##namespace ("srfi/69#"))
(##include "~~lib/_prim#.scm")                   ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")                 ;; for macro-check-procedure, 
(##include "69#.scm")

;;; Type constructors and predicate

(define (hash-table? ht) (table? ht))

(define (make-hash-table #!optional (equal equal?) (hash-function hash)) ;;; use table's default hash
    (make-table test: equal hash: hash-function))
    
(define (list->hash-table alist #!optional (equal equal?) (hash-function hash))
    (list->table alist test: equal hash: hash-function))

;;; reflexive
(define (hash-table-equivalence-function ht)
    (or (macro-table-test ht) eq?))

(define (hash-table-hash-function ht)
    (or (macro-table-hash ht) equal?))

;;; Dealing with single elements

(define (hash-table-ref ht key #!optional (thunk (macro-absent-obj)))
    (let ((func (if (equal? thunk (macro-absent-obj))
                (lambda () (##raise-unbound-key-exception 'hash-table-ref key))
                thunk)))
        (table-ref ht key func)))

(define (hash-table-ref/default ht key #!optional (default 
    (lambda () (##raise-unbound-key-exception 'hash-table-ref/default key)))) 
               (table-ref ht key default))

(define (hash-table-set! ht key val) (table-set! ht key val))

(define (hash-table-delete! ht key) (table-set! ht key))

(define (hash-table-exists? ht key) 
    (not (equal? (hash-table-ref ht key (macro-deleted-obj)) (macro-deleted-obj))))

(define (hash-table-update! ht key func #!optional (thunk (macro-absent-obj)))
    (let ((thunk2 (if (equal? thunk (macro-absent-obj))
                      (lambda () (##raise-unbound-key-exception 'hash-table-update! key func))
                      thunk)))
        (hash-table-set! ht key (func (hash-table-ref ht key thunk)))))

(define (hash-table-update!/default ht key func default)
    (hash-table-update! ht key func (lambda () default)))

;;; Dealing with the whole contents

(define (hash-table-size ht) (table-length ht))

(define (hash-table-keys ht) 
    (map car (table->list ht)))

(define (hash-table-values ht)
    (map cdr (table->list ht)))
            
(define (hash-table-walk ht proc)
    (table-for-each proc ht))

(define (hash-table-fold ht f init-value)
    (let ((lst (hash-table->alist ht))
          (ff (lambda (elem prec)
                      (f (car elem) (cdr elem) prec))))
        (fold ff init-value lst)))

(define (hash-table->alist ht)
    (table->list ht))

(define (hash-table-copy ht)
    (table-copy ht))

(define (hash-table-merge! ht1 ht2)
    (table-merge! ht1 ht2 #f))

(define (hash obj  #!optional (bound (macro-max-fixnum32)))
    (modulo (equal?-hash obj) bound))

(define (string-hash str #!optional (bound (macro-max-fixnum32)))
    (modulo (string=?-hash str) bound))

(define (string-ci-hash #!optional (bound (macro-max-fixnum32)))
    (modulo (string-ci=?-hash str) bound))

(define (hash-by-identity obj  #!optional (bound (macro-max-fixnum32)))
    (modulo (eq?-hash obj) bound))

;;;============================================================================

