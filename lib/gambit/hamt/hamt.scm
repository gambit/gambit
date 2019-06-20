;;;============================================================================

;;; File: "gambit/hamt/hamt.scm"

;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Immutable Hash Array Mapped Tries (HAMT).

(##supply-module gambit/hamt)

(##namespace ("gambit/hamt#"))                   ;; in gambit/hamt#
(##include "primitive-hamt/primitive-hamt#.scm") ;; define define-hamt macro
(##include "~~lib/_prim#.scm")                   ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")                 ;; for macro-check-procedure,
                                                 ;; macro-absent-obj, etc

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned (such as hamt?)

;;;----------------------------------------------------------------------------

;;; Representation of HAMTs.

(define-type hamt
  id: A8E85030-3E96-4AD5-B257-73B99DCBD137
  type-exhibitor: macro-type-hamt
  constructor: macro-make-hamt
  copier: #f
  opaque:
  macros:
  prefix: macro-
  unprintable:

  test
  hash
  tree
)

(define-macro (macro-check-hamt var arg-num form expr)
  `(macro-if-checks
    (if (macro-hamt? ,var)
        ,expr
        ((let () (namespace ("gambit/hamt#")) fail-check-hamt)
         ,arg-num
         ,(car form)
         ,@(cdr form)))
    ,expr))

(define (fail-check-hamt arg-num proc . args)
  (##raise-type-exception arg-num (macro-type-hamt) proc args))

;;;----------------------------------------------------------------------------

;;; Define the primitive HAMT procedures that accesses the test and
;;; hash procedures in a hamt structure.

(define-hamt
  implement-hamt*
  make-hamt*
  hamt*-ref
  hamt*-set
  hamt*-remove
  hamt*->list
  hamt*<-list
  hamt*-alist-search
  hamt*-alist-remove
  (lambda (key1 key2 hamt-object) ((macro-hamt-test hamt-object) key1 key2))
  (lambda (key hamt-object) ((macro-hamt-hash hamt-object) key))
  (hamt-object)
)

(implement-hamt*)

;;;----------------------------------------------------------------------------

;;; HAMT procedures:
;;;
;;;  (hamt? obj)                    return #t iff obj is a HAMT
;;;  (make-hamt)                    return an empty HAMT
;;;  (list->hamt alist)             return a HAMT with the associations taken
;;;                                 from the association list alist
;;;  (hamt->list hamt)              return an association list representation
;;;                                 of hamt
;;;  (hamt-ref hamt key [default])  return the value associated to key in hamt
;;;  (hamt-set hamt key [val])      return a copy of hamt where key maps to val
;;;                                 (or where key is removed if val is absent)

(define (hamt? obj)
  (macro-force-vars (hamt)
    (macro-hamt? obj)))

(define (make-hamt
         #!key
         (test (macro-absent-obj))
         (hash (macro-absent-obj)))
  (macro-force-vars (test hash)
    (let ()

      (define (check-test arg-num)
        (if (eq? test (macro-absent-obj))
            (check-hash ##equal?
                        arg-num)
            (let ((arg-num (fx+ arg-num 2)))
              (macro-check-procedure
                test
                arg-num
                (make-hamt test: test
                           hash: hash)
                (check-hash test
                            arg-num)))))

      (define (check-hash test-fn arg-num)
        (if (eq? hash (macro-absent-obj))
            (checks-done test-fn
                         (test->hash test-fn))
            (let ((arg-num (fx+ arg-num 2)))
              (macro-check-procedure
                hash
                arg-num
                (make-hamt test: test
                           hash: hash)
                (checks-done test-fn
                             hash)))))

      (define (checks-done test-fn hash-fn)
        (macro-make-hamt test-fn
                         hash-fn
                         (make-hamt*)))

      (check-test 0))))

(define (list->hamt
         alist
         #!key
         (test (macro-absent-obj))
         (hash (macro-absent-obj)))
  (macro-force-vars (alist test hash)
    (let ()

      (define (check-test arg-num)
        (if (eq? test (macro-absent-obj))
            (check-hash ##equal?
                        arg-num)
            (let ((arg-num (fx+ arg-num 2)))
              (macro-check-procedure
                test
                arg-num
                (list->hamt alist
                            test: test
                            hash: hash)
                (check-hash test
                            arg-num)))))

      (define (check-hash test-fn arg-num)
        (if (eq? hash (macro-absent-obj))
            (checks-done test-fn
                         (test->hash test-fn))
            (let ((arg-num (fx+ arg-num 2)))
              (macro-check-procedure
                hash
                arg-num
                (list->hamt alist
                            test: test
                            hash: hash)
                (checks-done test-fn
                             hash)))))

      (define (checks-done test-fn hash-fn)
        (let ((hamt
               (macro-make-hamt test-fn
                                hash-fn
                                (make-hamt*))))
          (macro-hamt-tree-set! hamt (hamt*<-list alist hamt))
          hamt))

      (check-test 1))))

(define (hamt->list hamt)
  (macro-force-vars (hamt)
    (macro-check-hamt
      hamt
      1
      (hamt->list hamt)
      (hamt*->list (macro-hamt-tree hamt)))))

(define (hamt-ref
         hamt
         key
         #!optional
         (default-value (macro-absent-obj)))
  (macro-force-vars (hamt key)
    (macro-check-hamt
      hamt
      1
      (hamt-ref hamt key default-value)
      (let ((x (hamt*-ref (macro-hamt-tree hamt) key hamt)))
        (if x
            (cdr x)
            (if (eq? default-value (macro-absent-obj))
                (##raise-unbound-key-exception
                 hamt-ref
                 hamt
                 key)
                default-value))))))

(define (hamt-set
         hamt
         key
         #!optional
         (val (macro-absent-obj)))
  (macro-force-vars (hamt key)
    (macro-check-hamt
      hamt
      1
      (hamt-set hamt key val)
      (if (eq? val (macro-absent-obj))
          (let* ((tree (macro-hamt-tree hamt))
                 (new-tree (hamt*-remove tree key hamt)))
            (if (eq? tree new-tree)
                hamt
                (macro-make-hamt (macro-hamt-test hamt)
                                 (macro-hamt-hash hamt)
                                 new-tree)))
          (macro-make-hamt (macro-hamt-test hamt)
                           (macro-hamt-hash hamt)
                           (hamt*-set (macro-hamt-tree hamt) key val hamt))))))

(define (test->hash test-fn)
  (declare (extended-bindings) (standard-bindings))
  (cond ((or (eq? test-fn ##eq?)
             (eq? test-fn (let () (namespace ("")) eq?)))
         ##eq?-hash)
        ((or (eq? test-fn ##eqv?)
             (eq? test-fn (let () (namespace ("")) eqv?)))
         ##eqv?-hash)
        ((or (eq? test-fn ##equal?)
             (eq? test-fn (let () (namespace ("")) equal?)))
         ##equal?-hash)
        ((or (eq? test-fn ##string=?)
             (eq? test-fn (let () (namespace ("")) string=?)))
         ##string=?-hash)
        ((or (eq? test-fn ##string-ci=?)
             (eq? test-fn (let () (namespace ("")) string-ci=?)))
         ##string-ci=?-hash)
        (else
         ##generic-hash)))

;;;============================================================================
