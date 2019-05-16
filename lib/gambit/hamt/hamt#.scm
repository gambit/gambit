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
;;;  (hamt? obj)                    returns #t iff obj is a HAMT
;;;  (make-hamt)                    returns an empty HAMT
;;;  (hamt-ref hamt key [default])  return the value associated to key in hamt
;;;  (hamt-set hamt key val)        return a copy of hamt where key maps to val
;;;  (hamt-remove hamt key)         return a copy of hamt where key is removed
;;;  (hamt->list hamt)              return an association list representation
;;;                                 of hamt
;;;  (list->hamt alist)             return a HAMT with the associations taken
;;;                                 from the association list alist

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
;;; hash is not specified, a default hash procedure is used.  The
;;; default hash procedure is reasonably good when the key comparison
;;; procedure is eq?, eqv?, equal?, string=?, or string-ci=?.

(##namespace ("gambit/hamt#"
              hamt?
              make-hamt
              hamt-ref
              hamt-set
              hamt-remove
              hamt->list
              list->hamt))

;;;============================================================================
