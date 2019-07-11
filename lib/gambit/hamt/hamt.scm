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

(##include "hamt#.scm")                          ;; correctly map hamt ops

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned (such as hamt?)

;;;----------------------------------------------------------------------------

;;; Type checking.

(define (fail-check-hamt arg-num proc . args)
  (##raise-type-exception arg-num (macro-type-hamt) proc args))

;;;----------------------------------------------------------------------------

;;; Define the primitive HAMT procedures that accesses the test and
;;; hash procedures in a hamt structure.

(define-hamt
  implement-hamt*
  #f
  #f
  make-hamt*
  hamt*-ref
  hamt*-set
  hamt*-remove
  hamt*-search
  hamt*-fold
  hamt*-for-each
  hamt*->list
  #f ;; hamt*<-list not needed
  hamt*<-reverse-list
  hamt*-alist-ref
  hamt*-alist-remove
  (lambda (hamt-obj)
    (macro-hamt-length-set!
     hamt-obj
     (fx+ (macro-hamt-length hamt-obj) 1)))
  (lambda (key1 key2 hamt-obj)
    ((macro-hamt-test hamt-obj) key1 key2))
  (lambda (key hamt-obj)
    ((macro-hamt-hash hamt-obj) key))
  (hamt-obj)
)

(implement-hamt*)

;;;----------------------------------------------------------------------------

;;; HAMT procedures:
;;;
;;;  (hamt? obj)                    return #t iff obj is a HAMT
;;;
;;;  (make-hamt)                    return an empty HAMT
;;;
;;;  (hamt-length hamt)             return the number of keys in hamt
;;;
;;;  (hamt-ref hamt key [default])  return the value associated to key in hamt
;;;
;;;  (hamt-set hamt key [val])      return a copy of hamt where key maps to val
;;;                                 (or where key is removed if val is absent)
;;;
;;;  (hamt-merge hamt1 hamt2 [hamt2-takes-precedence?]) returns a copy of hamt1
;;;                                 to which has been added the key-values
;;;                                 in hamt2 (key-values in hamt2 have
;;;                                 precedence when third parameter is #t)
;;;
;;;  (hamt-search hamt proc)        call (proc key val) for each key in a left
;;;                                 to right scan of the hamt, returning the
;;;                                 first result that is not #f
;;;
;;;  (hamt-fold hamt proc base)     do "base <- (proc base key val)" for
;;;                                 each key in a left to right scan of the
;;;                                 hamt and return the final value of base
;;;
;;;  (hamt-for-each hamt proc)      call (proc key val) for each key in a left
;;;                                 to right scan of the hamt
;;;
;;;  (hamt-map hamt proc)           call (proc key val) for each key,
;;;                                 accumulating the result in a list in the
;;;                                 same order as a left to right scan of
;;;                                 the hamt
;;;
;;;  (hamt-keys hamt)               return the list of keys in a right
;;;                                 to left scan of the hamt
;;;
;;;  (hamt-values hamt)             return the list of values in a right
;;;                                 to left scan of the hamt
;;;
;;;  (hamt->list hamt)              return an association list representation
;;;                                 of hamt (same order as left to right scan)
;;;
;;;  (list->hamt alist)             return a HAMT with the associations taken
;;;                                 from the association list alist (the
;;;                                 earliest occurrence of a key has precedence
;;;                                 over any subsequent ones)
;;;
;;;  (hamt-empty? hamt)             return #t iff the hamt is empty
;;;
;;;  (hamt-has-key? hamt key)       return #t iff there is a value associated
;;;                                 to key in hamt
;;;
;;;  (hamt-has-value? hamt val [test]) return #t iff one of the hamt's values
;;;                                 is val when compared with equal?, or the
;;;                                 test procedure when the third parameter
;;;                                 is specified

(define (hamt-empty? hamt)
  (macro-force-vars (hamt)
    (macro-check-hamt
      hamt
      1
      (hamt-empty? hamt)
      (fxzero? (macro-hamt-length hamt)))))

(define (hamt? obj)
  (macro-force-vars (hamt)
    (macro-hamt? obj)))

(define-syntax macro-make-hamt-from-parameters
  (lambda (src)
    (##deconstruct-call
     src
     -3
     (lambda (receiver prim . other-params)
       `(let ()

          (define (check-test arg-num)
            (if (eq? test (macro-absent-obj))
                (check-hash
                 ##equal?
                 arg-num)
                (let ((arg-num (fx+ arg-num 2)))
                  (macro-check-procedure
                    test
                    arg-num
                    (,prim
                     ,@other-params
                     test: test
                     hash: hash)
                    (check-hash
                     test
                     arg-num)))))

          (define (check-hash test-fn arg-num)
            (if (eq? hash (macro-absent-obj))
                (checks-done
                 test-fn
                 (test->hash test-fn))
                (let ((arg-num (fx+ arg-num 2)))
                  (macro-check-procedure
                    hash
                    arg-num
                    (,prim
                     ,@other-params
                     test: test
                     hash: hash)
                    (checks-done
                     test-fn
                     hash)))))

          (define (checks-done test-fn hash-fn)
            (,receiver
             (macro-make-hamt
              test-fn
              hash-fn
              (make-hamt*)
              0)))

          (check-test ,(length other-params)))))))

(define (make-hamt
         #!key
         (test (macro-absent-obj))
         (hash (macro-absent-obj)))
  (macro-force-vars (test hash)
    (macro-make-hamt-from-parameters
     (lambda (new-hamt)
       new-hamt)
     make-hamt)))

(define (hamt-length hamt)
  (macro-force-vars (hamt)
    (macro-check-hamt
      hamt
      1
      (hamt-length hamt)
      (macro-hamt-length hamt))))

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
                                 new-tree
                                 (fx- (macro-hamt-length hamt) 1))))
          (let ((new-hamt
                 (macro-make-hamt (macro-hamt-test hamt)
                                  (macro-hamt-hash hamt)
                                  #f
                                  (macro-hamt-length hamt))))
            (macro-hamt-tree-set!
             new-hamt
             (hamt*-set (macro-hamt-tree hamt) key val new-hamt))
            new-hamt)))))

(define (hamt-merge
         hamt1
         hamt2
         #!optional
         (hamt2-takes-precedence? (macro-absent-obj)))
  (macro-force-vars (hamt1 hamt2 hamt2-takes-precedence?)
    (macro-check-hamt
      hamt1
      1
      (hamt-merge hamt1 hamt2 hamt2-takes-precedence?)
      (macro-check-hamt
        hamt2
        2
        (hamt-merge hamt1 hamt2 hamt2-takes-precedence?)
        (hamt-merge-aux hamt1 hamt2 hamt2-takes-precedence?)))))

(define (hamt-merge-aux
         hamt1
         hamt2
         #!optional
         (hamt2-takes-precedence? (macro-absent-obj)))

  (define (merge/hamt1-takes-precedence hamt1 hamt2)
    (let ((new-hamt
           (macro-make-hamt (macro-hamt-test hamt1)
                            (macro-hamt-hash hamt1)
                            #f
                            (macro-hamt-length hamt1))))
      (macro-hamt-tree-set!
       new-hamt
       (hamt*-fold (macro-hamt-tree hamt2)
                   (lambda (tree key val)
                     (if (hamt*-ref tree key hamt1) ;; does key exist in hamt1?
                         tree ;; don't overwrite the key's value
                         (hamt*-set tree key val new-hamt)))
                   (macro-hamt-tree hamt1)))
      new-hamt))

  (define (merge/hamt2-takes-precedence hamt1 hamt2)
    (let ((new-hamt
           (macro-make-hamt (macro-hamt-test hamt1)
                            (macro-hamt-hash hamt1)
                            #f
                            (macro-hamt-length hamt1))))
      (macro-hamt-tree-set!
       new-hamt
       (hamt*-fold (macro-hamt-tree hamt2)
                   (lambda (tree key val)
                     (hamt*-set tree key val new-hamt))
                   (macro-hamt-tree hamt1)))
      new-hamt))

  (if (or (eq? hamt2-takes-precedence? (macro-absent-obj))
          (eq? hamt2-takes-precedence? #f))
      (if (and (eq? (macro-hamt-test hamt1) (macro-hamt-test hamt2))
               (eq? (macro-hamt-hash hamt1) (macro-hamt-hash hamt2)))
          (merge/hamt2-takes-precedence hamt2 hamt1) ;; reverse arguments
          (merge/hamt1-takes-precedence hamt1 hamt2))
      (merge/hamt2-takes-precedence hamt1 hamt2)))

(define (hamt-search hamt proc)
  (macro-force-vars (hamt proc)
    (macro-check-hamt
      hamt
      1
      (hamt-search hamt proc)
      (macro-check-procedure
        proc
        2
        (hamt-search hamt proc)
        (hamt*-search (macro-hamt-tree hamt) proc)))))

(define (hamt-fold hamt proc base)
  (macro-force-vars (hamt proc)
    (macro-check-hamt
      hamt
      1
      (hamt-fold hamt proc base)
      (macro-check-procedure
        proc
        2
        (hamt-fold hamt proc base)
        (hamt*-fold (macro-hamt-tree hamt) proc base)))))

(define (hamt-for-each hamt proc)
  (macro-force-vars (hamt proc)
    (macro-check-hamt
      hamt
      1
      (hamt-for-each hamt proc)
      (macro-check-procedure
        proc
        2
        (hamt-for-each hamt proc)
        (hamt*-for-each (macro-hamt-tree hamt) proc)))))

(define (hamt-map hamt proc)
  (macro-force-vars (hamt proc)
    (macro-check-hamt
      hamt
      1
      (hamt-map hamt proc)
      (macro-check-procedure
        proc
        2
        (hamt-map hamt proc)
        (hamt*-fold (macro-hamt-tree hamt)
                    (lambda (base key val)
                      (cons (proc key val) base))
                    '())))))

(define (hamt->list hamt)
  (macro-force-vars (hamt)
    (macro-check-hamt
      hamt
      1
      (hamt->list hamt)
      (hamt*->list (macro-hamt-tree hamt)))))

(define (list->hamt
         alist
         #!key
         (test (macro-absent-obj))
         (hash (macro-absent-obj)))
  (macro-force-vars (alist test hash)
    (let loop ((x alist) (rev-alist '()))
      (macro-force-vars (x)
        (if (pair? x)
            (let ((couple (car x)))
              (macro-force-vars (couple)
                (macro-check-pair-list
                  couple
                  1
                  (list->hamt
                   alist
                   test: test
                   hash: hash)
                  (loop (cdr x) (cons couple rev-alist)))))
            (macro-check-list
              x
              1
              (list->hamt
               alist
               test: test
               hash: hash)
              (macro-make-hamt-from-parameters
               (lambda (new-hamt)
                 (begin
                   (macro-hamt-tree-set!
                    new-hamt
                    (hamt*<-reverse-list rev-alist new-hamt))
                   new-hamt))
               list->hamt
               alist)))))))

(define (hamt-keys hamt)
  (macro-force-vars (hamt)
    (macro-check-hamt
      hamt
      1
      (hamt-keys hamt)
      (hamt*-fold (macro-hamt-tree hamt)
                  (lambda (base key val)
                    (cons key base))
                  '()))))

(define (hamt-values hamt)
  (macro-force-vars (hamt)
    (macro-check-hamt
      hamt
      1
      (hamt-values hamt)
      (hamt*-fold (macro-hamt-tree hamt)
                  (lambda (base key val)
                    (cons val base))
                  '()))))

(define (hamt-has-key? hamt key)
  (macro-force-vars (hamt key)
    (macro-check-hamt
      hamt
      1
      (hamt-has-key? hamt key)
      (if (hamt*-ref (macro-hamt-tree hamt) key hamt)
          #t
          #f))))

(define (hamt-has-value? hamt val #!optional (test (macro-absent-obj)))
  (macro-force-vars (hamt val test)
    (macro-check-hamt
      hamt
      1
      (hamt-has-value? hamt val test)
      (if (eq? test (macro-absent-obj))
          (hamt*-search (macro-hamt-tree hamt)
                        (lambda (key val2)
                          (##equal? val val2)))
          (macro-check-procedure
            test
            3
            (hamt-has-value? hamt val test)
            (hamt*-search (macro-hamt-tree hamt)
                          (lambda (key val2)
                            (test val val2))))))))

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
