;;;============================================================================

;;; File: "gambit/hamt/hamt#.scm"

;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Immutable Hash Array Mapped Tries (HAMT).

;;; A HAMT is a data structure that behaves as a dictionary that maps
;;; keys to values.  It is similar to an association list, but looking
;;; up a key is more efficient because it uses hashing on the keys to
;;; search the data structure.

;;; The HAMT procedures exported by this module are:
;;;
;;;  (hamt? obj)                    return #t iff obj is a HAMT
;;;  (make-hamt)                    return an empty HAMT
;;;  (hamt-length hamt)             return the number of keys in hamt
;;;  (hamt-ref hamt key [default])  return the value associated to key in hamt
;;;  (hamt-set hamt key [val])      return a copy of hamt where key maps to val
;;;                                 (or where key is removed if val is absent)
;;;  (hamt-merge hamt1 hamt2 [hamt2-takes-precedence?]) returns a copy of hamt1
;;;                                 to which has been added the key-values
;;;                                 in hamt2 (key-values in hamt2 have
;;;                                 precedence when third parameter is #t)
;;;  (hamt-search hamt proc)        call (proc key val) for each key in a left
;;;                                 to right scan of the hamt, returning the
;;;                                 first result that is not #f
;;;  (hamt-fold hamt proc base)     do "base <- (proc base key val)" for
;;;                                 each key in a left to right scan of the
;;;                                 hamt and return the final value of base
;;;  (hamt-for-each hamt proc)      call (proc key val) for each key in a left
;;;                                 to right scan of the hamt
;;;  (hamt->list hamt)              return an association list representation
;;;                                 of hamt
;;;  (list->hamt alist)             return a HAMT with the associations taken
;;;                                 from the association list alist (the
;;;                                 earliest occurrence of a key has precedence
;;;                                 over any subsequent ones)

;;; The procedures make-hamt and list->hamt take additional keyword
;;; parameters to specify how equality is tested and how keys are
;;; hashed:
;;;
;;;  test: test  test is a 2 argument procedure that compares keys for equality
;;;  hash: hash  hash is a 1 argument hashing procedure taking a key and
;;;              returning a fixnum
;;;
;;; The default test procedure is equal?.  The key comparison
;;; procedures eq?, eqv?, equal?, string=?, and string-ci=? are
;;; special because the system will use a reasonably good hash
;;; procedure when none is specified.
;;;
;;; The hash procedure must accept a single key parameter, return a
;;; fixnum, and be consistent with the key comparison procedure.  When
;;; hash is not specified, and the test procedure is not one of the
;;; special ones, the HAMT degenerates to a list with access time
;;; linear in the number of elements in the HAMT.

(##namespace ("gambit/hamt#"

hamt?
make-hamt
hamt-length
hamt-ref
hamt-set
hamt-merge
hamt-search
hamt-fold
hamt-for-each
hamt-map
hamt->list
list->hamt
hamt-empty?
hamt-has-key?
hamt-has-value?
hamt-keys
hamt-values

))

;;;----------------------------------------------------------------------------

;;; Representation of HAMTs.

(define-type hamt
  id: A8E85030-3E96-4AD5-B257-73B99DCBD137
  type-exhibitor: macro-type-hamt
  constructor: macro-make-hamt
  copier: #f
  macros:
  prefix: macro-
  unprintable:

  test
  hash
  tree
  length
)

;;; Type checking.

(##define-syntax macro-check-hamt
  (lambda (src)
    (##deconstruct-call
     src
     5
     (lambda (var arg-num form expr)
       (let ((form* (##source-code form)))
         `(macro-if-checks
           (if (macro-hamt? ,var)
               ,expr
               ((let () (namespace ("gambit/hamt#")) fail-check-hamt)
                ,arg-num
                ,(car form*)
                ,@(cdr form*)))
           ,expr))))))

;;;============================================================================
