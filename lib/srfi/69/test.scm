;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2018-2019 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 69, Basic hash tables.

(import (srfi 69))
(import (_test))

;;;============================================================================

;;; Type constructors and predicate

;;; make-hash-table and hash-table?

(test-assert (not (hash-table? 1)))

(test-assert (hash-table? (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table?))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table? 1 2))


;;; alist->hash-table

(test-assert (hash-table? (alist->hash-table '((0 . 0) (1 . 1) (2 . 2)))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (alist->hash-table))

(test-error-tail
 wrong-number-of-arguments-exception?
 (alist->hash-table '() 0 0 0))


;;;============================================================================

;;; Reflexion

(test-equal ##equal?
            (hash-table-equivalence-function (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-equivalence-function))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-equivalence-function (make-hash-table) 0))


(test-equal ##equal?-hash
            (hash-table-hash-function (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-hash-function))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-hash-function (make-hash-table) 0))


;;;============================================================================

;;; Dealing with single elements

;;; hash-table-ref

(test-equal
 0
 (hash-table-ref (alist->hash-table '((0 . 0) (1 . 1))) 0))

(test-equal
 #f
 (hash-table-ref (alist->hash-table '((0 . 0) (1 . 1))) 2 (lambda () #f)))

(test-error-tail
 null?
 (hash-table-ref (alist->hash-table '((0 . 0) (1 . 1)))
                 2
                 (lambda () (raise '()))))

(test-error-tail
 unbound-key-exception?
 (hash-table-ref (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref (make-hash-table) 0 0 0))


;;; hash-table-ref/default

(test-equal
 0
 (hash-table-ref/default (alist->hash-table '((0 . 0) (1 . 1))) 0 #f))

(test-equal
 #f
 (hash-table-ref/default (alist->hash-table '((0 . 0) (1 . 1))) 2 #f))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref/default (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref/default (make-hash-table) 0 0 0))


;;; hash-table-set!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 1)
  (test-equal 1 (hash-table-ref ht 0)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-set! (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-set! (make-hash-table) 0 1 1))


;;; hash-table-delete!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 1)
  (hash-table-delete! ht 0)
  (test-equal #f (hash-table-ref ht 0 (lambda () #f))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-delete! (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-delete! (make-hash-table) 0 0))


;;; hash-table-exists?

(let ((ht (alist->hash-table '((0 . 0) (1 . 1)))))
  (test-assert (hash-table-exists? ht 0))
  (hash-table-delete! ht 0)
  (test-assert (not (hash-table-exists? ht 0))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-exists? (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-exists? (make-hash-table) 0 0))


;;; hash-table-update!

(let ((ht (alist->hash-table '((0 . 0)))))
  (hash-table-update! ht 0 (lambda (val) (+ val 1)))
  (test-equal 1 (hash-table-ref ht 0)))

(test-error-tail
 unbound-key-exception?
 (hash-table-update!
  (make-hash-table)
  0
  (lambda (val) (+ val 1))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update! (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update! (make-hash-table) 0 (lambda () '()) 0 0))


;;; hash-table-update!/default

(let ((ht (alist->hash-table '((0 . 0)))))
  (hash-table-update!/default ht 0 (lambda (val) (+ val 1)) 0)
  (test-equal 1 (hash-table-ref ht 0)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update!/default (make-hash-table) 0 (lambda () '())))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update!/default (make-hash-table) 0 (lambda () '()) 0 0))


;;;============================================================================

;;; dealing with the whole contents

;;; hash-table-size

(test-equal 0 (hash-table-size (make-hash-table)))
(test-equal 1 (hash-table-size (alist->hash-table '((0 . 0)))))
(test-equal 2 (hash-table-size (alist->hash-table '((0 . 0) (1 . 1)))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-size))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-size (make-hash-table) 0))


;;; hash-table-keys and hash-table-values

(let ((ht (alist->hash-table '((0 . 2) (1 . 3)))))
  (test-assert (fold
                (lambda (elem res)
                  (if (equal? res #t)
                      #t
                      (table-search (lambda (key val)
                                      (if (equal? key elem)
                                          #t
                                          #f)) ht)))
                #f
                (hash-table-keys ht))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-keys (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-keys))


(let ((ht (alist->hash-table '((0 . 2) (1 . 3)))))
  (test-assert
   (fold (lambda (elem res)
           (if (equal? res #t)
               #t
               (table-search (lambda (key val) (equal? val elem)) ht)))
         #f
         (hash-table-values ht))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-values (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-values))


;;; hash-table-walk

(let ((ht (alist->hash-table '((0 . 1) (1 . 1)))))
  (hash-table-walk ht (lambda (key val) (hash-table-set! ht key 0)))
  (test-equal 0 (hash-table-ref ht 0)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-walk (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-walk (make-hash-table) (lambda () '()) 0))


;;; hash-table-fold

(let ((ht (alist->hash-table '((0 . 1) (1 . 1) (2 . 2)))))
  (hash-table-fold ht
                   (lambda (key val result)
                     (hash-table-set! ht key result)
                     (hash-table-ref ht key)) 0)
  (test-equal 0 (hash-table-ref ht 0))
  (test-equal 0 (hash-table-ref ht 1))
  (test-equal 0 (hash-table-ref ht 2)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-fold (make-hash-table) (lambda () '())))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-fold (make-hash-table) (lambda () '()) 0 0))


;;; hash-table->alist

(let ((lst '((0 . 0) (1 . 1))))
  (test-assert (fold (lambda (map-elem res1)
                       (if (equal? res1 #f) #f
                           (fold (lambda (elem res2)
                                   (or (equal? res2 #t)
                                       (equal? map-elem elem)))
                                 #f
                                 lst)))
                     #t
                     (hash-table->alist (alist->hash-table lst)))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table->alist))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table->alist (make-hash-table) 0))


;;; hash-table-copy

(let* ((ht1 (make-hash-table))
       (ht2 (hash-table-copy ht1)))
  (test-equal ht1 ht2)
  (hash-table-set! ht1 0 0)
  (test-assert (not (equal? ht1 ht2))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-copy))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-copy (make-hash-table) 0))


;;; hash-table-merge!

(let ((ht1 (alist->hash-table '((0 . 0) (1 . 1))))
      (ht2 (alist->hash-table '((2 . 2) (3 . 3))))
      (ht3 (alist->hash-table '((0 . 0) (1 . 1) (2 . 2) (3 . 3)))))
  (test-equal ht3 (hash-table-merge! ht1 ht2)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-merge! (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-merge! (make-hash-table) (make-hash-table) 0))

;;;============================================================================
