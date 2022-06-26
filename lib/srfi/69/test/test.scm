;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2018-2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 69, Basic hash tables.

(import (srfi 69))
(import (_test))

;;;============================================================================

;;; Type constructors and predicate


;;  make-hash-table and hash-table?

(test-assert (not (hash-table? 1)))

(test-assert (hash-table? (make-hash-table)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table?))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table? 0 1))

(test-error-tail
 type-exception?
 (make-hash-table 0))

(test-error-tail
 type-exception?
 (make-hash-table equal? 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (make-hash-table equal? (lambda (obj) 0) 1))


;;  alist->hash-table

(test-assert (hash-table? (alist->hash-table '())))

(test-assert (hash-table? (alist->hash-table '((0 . 100) (1 . 101) (2 . 102)))))

(test-error-tail
 type-exception?
 (alist->hash-table 0))

(test-error-tail
 type-exception?
 (alist->hash-table '(0 1)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (alist->hash-table))

(test-error-tail
 wrong-number-of-arguments-exception?
 (alist->hash-table '() equal? (lambda (obj) 0) 1))

(test-error-tail
 type-exception?
 (alist->hash-table '() 0))

(test-error-tail
 type-exception?
 (alist->hash-table '() equal? 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (alist->hash-table '() equal? (lambda (obj) 0) 1))


;;;============================================================================

;;; Reflexion


;;  hash-table-equivalence-function

 ; default
(test-equal ##equal?
            (hash-table-equivalence-function (make-hash-table)))

(let ((f (lambda (x y) #t)))
  (test-equal f (hash-table-equivalence-function (make-hash-table f))))

(test-error-tail
 type-exception?
 (hash-table-equivalence-function 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-equivalence-function))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-equivalence-function (make-hash-table) 0))


;;;  hash-table-hash-function

(test-equal ##equal?-hash
            (hash-table-hash-function (make-hash-table)))

(let ((f (lambda (x y) #t))
      (g (lambda (x) 1)))
  (test-equal g
              (hash-table-hash-function (make-hash-table f g))))


(test-error-tail
 type-exception?
 (hash-table-hash-function 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-hash-function))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-hash-function 0 1))


;;;============================================================================

;;; Dealing with single elements


;;  hash-table-ref

(test-equal
 100
 (hash-table-ref (alist->hash-table '((0 . 100) (1 . 101))) 0))

(test-equal
 #f
 (hash-table-ref (alist->hash-table '((0 . 100) (1 . 101))) 2 (lambda () #f)))

(test-error-tail
 null?
 (hash-table-ref (alist->hash-table '((0 . 100) (1 . 101)))
                 2
                 (lambda () (raise '()))))

(test-error-tail
 unbound-key-exception?
 (hash-table-ref (make-hash-table) 0))

(test-error-tail
 type-exception?
 (hash-table-ref 0 0))

(test-error-tail
 type-exception?
 (hash-table-ref (make-hash-table) 0 1))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref 0 1 2 3))


;;  hash-table-ref/default

(test-equal
 100
 (hash-table-ref/default (alist->hash-table '((0 . 100) (1 . 101))) 0 #f))

(test-equal
 #f
 (hash-table-ref/default (alist->hash-table '((0 . 100) (1 . 101))) 2 #f))

(test-error-tail
 type-exception?
 (hash-table-ref 0 0 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref/default 0 1))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-ref/default 0 1 2 3))


;;  hash-table-set!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 0)
  (test-equal 0 (hash-table-ref ht 0)))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-set! (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-set! 0 1 2 3))


;;  hash-table-delete!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 1)
  (hash-table-delete! ht 0)
  (test-equal #f (hash-table-ref/default ht 0 #f)))

(test-error-tail
 type-exception?
 (hash-table-delete! 0 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-delete! 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-delete! 0 1 2))


;;  hash-table-exists?

(let ((ht (alist->hash-table '((0 . 100) (1 . 101)))))
  (test-assert (hash-table-exists? ht 0))
  (hash-table-delete! ht 0)
  (test-assert (not (hash-table-exists? ht 0))))

(test-error-tail
 type-exception?
 (hash-table-exists? 0 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-exists? 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-exists? 0 1 2))


;;  hash-table-update!

(let ((ht (alist->hash-table '((0 . 100)))))
  (hash-table-update! ht 0 (lambda (val) (+ val 1)))
  (test-equal 101 (hash-table-ref ht 0)))

(test-error-tail
 unbound-key-exception?
 (hash-table-update!
  (make-hash-table)
  0
  (lambda (val) (+ val 1))))

(test-error-tail
 type-exception?
 (hash-table-update! 0 0 (lambda (val) '())))

(test-error-tail
 type-exception?
 (hash-table-update! (make-hash-table) 0 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update! 0 1))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update! 0 1 2 3 4))


;;  hash-table-update!/default

(let ((ht (alist->hash-table '((0 . 100)))))
  (hash-table-update!/default ht 0 (lambda (val) (+ val 1)) 55)
  (test-equal 101 (hash-table-ref ht 0)))

(let ((ht (alist->hash-table '((0 . 100)))))
  (hash-table-update!/default ht 1 (lambda (val) (+ val 1)) 55)
  (test-equal 56 (hash-table-ref ht 1)))

(test-error-tail
 type-exception?
 (hash-table-update!/default 0 0 (lambda (val) '()) 0))

(test-error-tail
 type-exception?
 (hash-table-update! (make-hash-table) 0 0 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update!/default 0 1 2))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-update!/default 0 1 2 3 4))


;;;============================================================================

;;; dealing with the whole contents

;;; hash-table-size

(test-equal 0 (hash-table-size (make-hash-table)))
(test-equal 0 (hash-table-size (alist->hash-table '())))
(test-equal 1 (hash-table-size (alist->hash-table '((0 . 100)))))
(test-equal 2 (hash-table-size (alist->hash-table '((0 . 100) (1 . 101)))))

(test-error-tail
 type-exception?
 (hash-table-size 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-size))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-size 0 1))


;;  hash-table-keys

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
 type-exception?
 (hash-table-keys 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-keys))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-keys 0 1))



;;  hash-table-values

(let ((ht (alist->hash-table '((0 . 2) (1 . 3)))))
  (test-assert
    (fold (lambda (elem res)
            (if (equal? res #t)
                #t
                (table-search (lambda (key val) (equal? val elem)) ht)))
          #f
          (hash-table-values ht))))

(test-error-tail
 type-exception?
 (hash-table-values 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-values))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-values 0 1))


;;; hash-table-walk

(let ((ht (alist->hash-table '((0 . 1) (1 . 1)))))
  (hash-table-walk ht (lambda (key val) (hash-table-set! ht key 0)))
  (test-equal 0 (hash-table-ref ht 0)))

(test-error-tail
 type-exception?
 (hash-table-walk 0 (lambda (key val) '())))

(test-error-tail
 type-exception?
 (hash-table-walk (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-walk 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-walk 0 1 2))


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
 type-exception?
 (hash-table-fold 0 (lambda (key val result) '()) 0))

(test-error-tail
 type-exception?
 (hash-table-fold (make-hash-table) 0 0))


(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-fold 0 1))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-fold 0 1 2 3))


;;; hash-table->alist

(let ((lst '((0 . 100) (1 . 101))))
  (test-assert
    (fold (lambda (map-elem res1)
            (if (equal? res1 #f)
                #f
                (fold (lambda (elem res2)
                        (or (equal? res2 #t)
                            (equal? map-elem elem)))
                      #f
                      lst)))
          #t
          (hash-table->alist (alist->hash-table lst)))))

(let ((alst '((0 . 100) (1 . 101))))
  (test-assert (hash-table->alist (alist->hash-table alst))
               alst))

(test-error-tail
 type-exception?
 (hash-table->alist 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table->alist))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table->alist 0 1))


;;; hash-table-copy

(let* ((ht1 (make-hash-table))
       (ht2 (hash-table-copy ht1)))
  (test-equal ht1 ht2)
  (hash-table-set! ht1 0 0)
  (test-assert (not (equal? ht1 ht2))))

(test-error-tail
 type-exception?
 (hash-table-copy 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-copy))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-copy 0 1))


;;; hash-table-merge!

(let ((ht1 (alist->hash-table '((0 . 100) (1 . 101))))
      (ht2 (alist->hash-table '((2 . 102) (3 . 103))))
      (ht3 (alist->hash-table '((0 . 100) (1 . 101) (2 . 102) (3 . 103)))))
  (test-equal ht3 (hash-table-merge! ht1 ht2)))

(test-error-tail
 type-exception?
 (table-merge! 0 (make-hash-table)))

(test-error-tail
 type-exception?
 (table-merge! (make-hash-table) 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-merge! 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-table-merge! 0 1 2))


;;;============================================================================

;;  hash

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (hash '(1 2 3)))

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (hash '(1 2 3) 100))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash 0 1 2))

(test-error-tail
 divide-by-zero-exception?
 (hash '(1 2 3) 0))

(test-error-tail
 range-exception?
 (hash '(1 2 3) -1))

;;  string-hash

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (string-hash "foo"))

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (string-hash "foo" 100))

(test-error-tail
 type-exception?
 (string-hash 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (string-hash))

(test-error-tail
 wrong-number-of-arguments-exception?
 (string-hash 0 1 2))

(test-error-tail
 divide-by-zero-exception?
 (string-hash "foo" 0))

(test-error-tail
 range-exception?
 (string-hash "foo" -1))


;;  string-ci-hash

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (string-ci-hash "foo"))

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (string-ci-hash "foo" 100))

(test-error-tail
 type-exception?
 (string-ci-hash 0))

(test-error-tail
 wrong-number-of-arguments-exception?
 (string-ci-hash))

(test-error-tail
 wrong-number-of-arguments-exception?
 (string-ci-hash 0 1 2))

(test-error-tail
 divide-by-zero-exception?
 (string-ci-hash "foo" 0))

(test-error-tail
 range-exception?
 (string-ci-hash "foo" -1))


;;  hash-by-identity

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (hash-by-identity 'foo))

(test-assert
  (lambda (x) (and (integer? x) (exact? x) (>= x 0)))
  (hash-by-identity 'foo 100))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-by-identity))

(test-error-tail
 wrong-number-of-arguments-exception?
 (hash-by-identity 0 1 2))

(test-error-tail
 divide-by-zero-exception?
 (hash-by-identity 'foo 0))

(test-error-tail
 range-exception?
 (hash-by-identity 'foo -1))
