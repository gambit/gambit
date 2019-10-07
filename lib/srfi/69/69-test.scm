;;;============================================================================

;;; File: "srfi/69/69-test.scm"

;;; Copyright (c) 2018-2019 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 69, Basic hash tables.

(import (srfi 69))
(import (_test))

;;;============================================================================

;;; Type constructors and predicate

;;; make-hash-table and hash-table?

(check-false (hash-table? 1))

(check-true (hash-table? (make-hash-table)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table?)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table? 1 2)))


;;; alist->hash-table

(check-true (hash-table? (alist->hash-table '((0 . 0) (1 . 1) (2 . 2)))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (alist->hash-table)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (alist->hash-table '() 0 0 0)))


;;;============================================================================

;;; Reflexion

(check-equal? (hash-table-equivalence-function (make-hash-table))
              ##equal?)

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-equivalence-function)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-equivalence-function (make-hash-table) 0)))


(check-equal? (hash-table-hash-function (make-hash-table))
              ##equal?-hash)

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-hash-function)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-hash-function (make-hash-table) 0)))


;;;============================================================================

;;; Dealing with single elements

;;; hash-table-ref

(check-equal?
 (hash-table-ref (alist->hash-table '((0 . 0) (1 . 1))) 0)
 0)

(check-equal?
 (hash-table-ref (alist->hash-table '((0 . 0) (1 . 1))) 2 (lambda () #f))
 #f)

(check-tail-exn
 null?
 (lambda ()
   (hash-table-ref (alist->hash-table '((0 . 0) (1 . 1)))
                   2
                   (lambda () (raise '())))))

(check-tail-exn
 unbound-key-exception?
 (lambda () (hash-table-ref (make-hash-table) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref (make-hash-table) 0 0 0)))


;;; hash-table-ref/default

(check-equal?
 (hash-table-ref/default (alist->hash-table '((0 . 0) (1 . 1))) 0 #f)
 0)

(check-equal?
 (hash-table-ref/default (alist->hash-table '((0 . 0) (1 . 1))) 2 #f)
 #f)

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref/default (make-hash-table) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref/default (make-hash-table) 0 0 0)))


;;; hash-table-set!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 1)
  (check-equal? (hash-table-ref ht 0) 1))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-set! (make-hash-table) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-set! (make-hash-table) 0 1 1)))


;;; hash-table-delete!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 1)
  (hash-table-delete! ht 0)
  (check-equal? (hash-table-ref ht 0 (lambda () #f)) #f))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-delete! (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-delete! (make-hash-table) 0 0)))


;;; hash-table-exists?

(let ((ht (alist->hash-table '((0 . 0) (1 . 1)))))
  (check-true (hash-table-exists? ht 0))
  (hash-table-delete! ht 0)
  (check-false (hash-table-exists? ht 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-exists? (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-exists? (make-hash-table) 0 0)))


;;; hash-table-update!

(let ((ht (alist->hash-table '((0 . 0)))))
  (hash-table-update! ht 0 (lambda (val) (+ val 1)))
  (check-equal? (hash-table-ref ht 0) 1))

(check-tail-exn
 unbound-key-exception?
 (lambda () (hash-table-update!
             (make-hash-table)
             0
             (lambda (val) (+ val 1)))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update! (make-hash-table) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update! (make-hash-table) 0 (lambda () '()) 0 0)))


;;; hash-table-update!/default

(let ((ht (alist->hash-table '((0 . 0)))))
  (hash-table-update!/default ht 0 (lambda (val) (+ val 1)) 0)
  (check-equal? (hash-table-ref ht 0) 1))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update!/default (make-hash-table) 0 (lambda () '()))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update!/default (make-hash-table) 0 (lambda () '()) 0 0)))


;;;============================================================================

;;; dealing with the whole contents

;;; hash-table-size

(check-equal? (hash-table-size (make-hash-table)) 0)
(check-equal? (hash-table-size (alist->hash-table '((0 . 0)))) 1)
(check-equal? (hash-table-size (alist->hash-table '((0 . 0) (1 . 1)))) 2)

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-size)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-size (make-hash-table) 0)))


;;; hash-table-keys and hash-table-values

(let ((ht (alist->hash-table '((0 . 2) (1 . 3)))))
  (check-true (fold
               (lambda (elem res)
                 (if (equal? res #t)
                     #t
                     (table-search (lambda (key val)
                                     (if (equal? key elem)
                                         #t
                                         #f)) ht)))
               #f
               (hash-table-keys ht))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-keys (make-hash-table) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-keys)))


(let ((ht (alist->hash-table '((0 . 2) (1 . 3)))))
  (check-true
   (fold (lambda (elem res)
           (if (equal? res #t)
               #t
               (table-search (lambda (key val) (equal? val elem)) ht)))
         #f
         (hash-table-values ht))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-values (make-hash-table) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-values)))


;;; hash-table-walk

(let ((ht (alist->hash-table '((0 . 1) (1 . 1)))))
  (hash-table-walk ht (lambda (key val) (hash-table-set! ht key 0)))
  (check-equal? (hash-table-ref ht 0) 0))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-walk (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-walk (make-hash-table) (lambda () '()) 0)))


;;; hash-table-fold

(let ((ht (alist->hash-table '((0 . 1) (1 . 1) (2 . 2)))))
  (hash-table-fold ht
                   (lambda (key val result)
                     (hash-table-set! ht key result)
                     (hash-table-ref ht key)) 0)
  (check-equal? (hash-table-ref ht 0) 0)
  (check-equal? (hash-table-ref ht 1) 0)
  (check-equal? (hash-table-ref ht 2) 0))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-fold (make-hash-table) (lambda () '()))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-fold (make-hash-table) (lambda () '()) 0 0)))


;;; hash-table->alist

(let ((lst '((0 . 0) (1 . 1))))
  (check-true (fold (lambda (map-elem res1)
                      (if (equal? res1 #f) #f
                          (fold (lambda (elem res2)
                                  (or (equal? res2 #t)
                                      (equal? map-elem elem)))
                                #f
                                lst)))
                    #t
                    (hash-table->alist (alist->hash-table lst)))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table->alist)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table->alist (make-hash-table) 0)))


;;; hash-table-copy

(let* ((ht1 (make-hash-table))
       (ht2 (hash-table-copy ht1)))
  (check-equal? ht1 ht2)
  (hash-table-set! ht1 0 0)
  (check-not-equal? ht1 ht2))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-copy)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-copy (make-hash-table) 0)))


;;; hash-table-merge!

(let ((ht1 (alist->hash-table '((0 . 0) (1 . 1))))
      (ht2 (alist->hash-table '((2 . 2) (3 . 3))))
      (ht3 (alist->hash-table '((0 . 0) (1 . 1) (2 . 2) (3 . 3)))))
  (check-equal? ht3 (hash-table-merge! ht1 ht2)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-merge! (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-merge! (make-hash-table) (make-hash-table) 0)))

;;;============================================================================
