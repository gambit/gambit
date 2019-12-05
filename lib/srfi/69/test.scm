;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2018-2019 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 69, Basic hash tables.

(import (srfi 69))
(import (_test))

;;;============================================================================

;;; Type constructors and predicate


;;; hash-table?

(check-false (hash-table? 0))

(check-true (hash-table? (make-hash-table)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table?)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table? 0 1)))


;;; make-hash-table

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (make-hash-table (lambda () '()) (lambda () '()) 0)))

(check-tail-exn
 type-exception?
 (lambda () (make-hash-table 0 (lambda () '()))))

(check-tail-exn
 type-exception?
 (lambda () (make-hash-table (lambda () '()) 0)))


;;; alist->hash-table

(check-true (hash-table? (alist->hash-table '())))
(check-true (hash-table? (alist->hash-table '((0 . 0) (1 . 1) (2 . 2)))))

(check-tail-exn
 type-exception?
 (lambda () (alist->hash-table 0)))

(check-tail-exn
 type-exception?
 (lambda () (alist->hash-table '(0))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (alist->hash-table)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (alist->hash-table '() 1 2 3)))


;;;============================================================================

;;; Reflexion


;; hash-table-equivalence-function

(check-equal? (hash-table-equivalence-function (make-hash-table))
              ##equal?)

(let ((proc (lambda () '())))
    (check-equal? (hash-table-equivalence-function (make-hash-table proc))
                  proc)

    (check-equal? (hash-table-equivalence-function (alist->hash-table '() proc))
                  proc))

(check-tail-exn
  type-exception?
  (lambda () (hash-table-equivalence-function 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-equivalence-function)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-equivalence-function (make-hash-table) 0)))



;;;----------------------------------------------------------------------------

;; hash-table-hash-function

(check-equal? (hash-table-hash-function (make-hash-table))
              ##equal?-hash)

(let ((proc1 (lambda () '()))
      (proc2 (lambda () '())))
    
    (check-not-equal? proc1 proc2)

    (check-equal? (hash-table-hash-function (make-hash-table proc1 proc2))
              proc2)

    (check-equal? (hash-table-hash-function (alist->hash-table '() proc1 proc2))
              proc2))

(check-tail-exn
 type-exception?
 (lambda () (hash-table-hash-function 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-hash-function)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-hash-function (make-hash-table) 1)))

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
 type-exception?
 (lambda ()
  (hash-table-ref 0 1)))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-ref (make-hash-table) 1 2)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref (make-hash-table) 1 2 3)))

;;;----------------------------------------------------------------------------

;;; hash-table-ref/default

(check-equal?
 (hash-table-ref/default (alist->hash-table '((0 . 0) (1 . 1))) 0 #f)
 0)

(check-equal?
 (hash-table-ref/default (alist->hash-table '((0 . 0) (1 . 1))) 2 #f)
 #f)

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-ref/default 0 0 #f)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref/default (make-hash-table) 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-ref/default (make-hash-table) 1 2 3)))

;;;----------------------------------------------------------------------------

;;; hash-table-set!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 1)
  (check-equal? (hash-table-ref ht 0) 1))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-set! 0 0 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-set! (make-hash-table) 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-set! (make-hash-table) 1 2 3)))

;;;----------------------------------------------------------------------------

;;; hash-table-delete!

(let ((ht (make-hash-table)))
  (hash-table-set! ht 0 1)
  (hash-table-delete! ht 0)
  (check-equal? (hash-table-ref ht 0 (lambda () #f)) #f))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-delete! 0 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-delete! (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-delete! (make-hash-table) 1 2)))

;;;----------------------------------------------------------------------------

;;; hash-table-exists?

(let ((ht (alist->hash-table '((0 . 0) (1 . 1)))))
  (check-true (hash-table-exists? ht 0))
  (hash-table-delete! ht 0)
  (check-false (hash-table-exists? ht 0)))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-exists? 0 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-exists? (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-exists? (make-hash-table) 1 2)))

;;;----------------------------------------------------------------------------

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
 type-exception?
 (lambda ()
  (hash-table-update! 0 0 (lambda () '()))))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-update! (make-hash-table) 0 0)))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-update! (make-hash-table) 0 (lambda () '()) 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update! (make-hash-table) 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update! (make-hash-table) 1 (lambda () 2) (lambda () 3) 4)))

;;;----------------------------------------------------------------------------

;;; hash-table-update!/default

(let ((ht (alist->hash-table '((0 . 0)))))
  (hash-table-update!/default ht 0 (lambda (val) (+ val 1)) 0)
  (check-equal? (hash-table-ref ht 0) 1))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-update!/default 0 0 (lambda () '()) 0)))

(check-tail-exn
 type-exception?
 (lambda ()
  (hash-table-update!/default (make-hash-table) 0 0 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update!/default (make-hash-table) 1 (lambda () 2))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda ()
   (hash-table-update!/default (make-hash-table) 1 (lambda () 2) 3 4)))


;;;============================================================================

;;; dealing with the whole contents


;;; hash-table-size

(check-equal? (hash-table-size (make-hash-table)) 0)
(check-equal? (hash-table-size (alist->hash-table '((0 . 0)))) 1)
(check-equal? (hash-table-size (alist->hash-table '((0 . 0) (1 . 1)))) 2)

(check-tail-exn
 type-exception?
 (lambda () (hash-table-size 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-size)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-size (make-hash-table) 1)))

;;;----------------------------------------------------------------------------

;;; hash-table-keys
(let ((ht (alist->hash-table '((0 . 2) (1 . 3)))))
  (check-true (fold
                (lambda (elem res)
                  (if (equal? res #t)
                      #t
                      (table-search 
                        (lambda (key val)
                          (if (equal? key elem)
                              #t
                              #f)) 
                        ht)))
                #f
                (hash-table-keys ht))))

(check-tail-exn
 type-exception?
 (lambda () (hash-table-keys 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-keys (make-hash-table) 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-keys)))

;;;----------------------------------------------------------------------------

;;; hash-table-values

(let ((ht (alist->hash-table '((0 . 2) (1 . 3)))))
  (check-true
   (fold (lambda (elem res)
           (if (equal? res #t)
               #t
               (table-search (lambda (key val) (equal? val elem)) ht)))
         #f
         (hash-table-values ht))))

(check-tail-exn
 type-exception?
 (lambda () (hash-table-values 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-values (make-hash-table) 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-values)))

;;;----------------------------------------------------------------------------

;;; hash-table-walk

(let ((ht (alist->hash-table '((0 . 1) (1 . 1)))))
  (hash-table-walk ht (lambda (key val) (hash-table-set! ht key 0)))
  (check-equal? (hash-table-ref ht 0) 0))

(check-tail-exn
 type-exception?
 (lambda () (hash-table-walk 0 (lambda () 1))))

(check-tail-exn
 type-exception?
 (lambda () (hash-table-walk (make-hash-table) 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-walk (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-walk (make-hash-table) (lambda () 1) 2)))

;;;----------------------------------------------------------------------------

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
 type-exception?
 (lambda () (hash-table-fold 0 (lambda () '()) 0)))

(check-tail-exn
 type-exception?
 (lambda () (hash-table-fold (make-hash-table) 0 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-fold (make-hash-table) (lambda () 1))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-fold (make-hash-table) (lambda () 1) 2 3)))

;;;----------------------------------------------------------------------------

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
 type-exception?
 (lambda () (hash-table->alist 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table->alist)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table->alist (make-hash-table) 1)))

;;;----------------------------------------------------------------------------

;;; hash-table-copy

(let* ((ht1 (make-hash-table))
       (ht2 (hash-table-copy ht1)))
  (check-equal? ht1 ht2)
  (hash-table-set! ht1 0 0)
  (check-not-equal? ht1 ht2))

(check-tail-exn
 type-exception?
 (lambda() (hash-table-copy 0)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-copy)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-copy (make-hash-table) 0)))

;;;----------------------------------------------------------------------------

;;; hash-table-merge!

(let ((ht1 (alist->hash-table '((0 . 0) (1 . 1))))
      (ht2 (alist->hash-table '((2 . 2) (3 . 3))))
      (ht3 (alist->hash-table '((0 . 0) (1 . 1) (2 . 2) (3 . 3)))))
  (check-equal? ht3 (hash-table-merge! ht1 ht2)))


(check-tail-exn
 type-exception?
 (lambda() (hash-table-merge! 0 (make-hash-table))))

(check-tail-exn
 type-exception?
 (lambda() (hash-table-merge! (make-hash-table) 1)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-merge! (make-hash-table))))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-table-merge! (make-hash-table) (make-hash-table) 0)))

;;;----------------------------------------------------------------------------

;;; hash

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash 0 1 2)))

;;;----------------------------------------------------------------------------

;;; string-hash

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (string-hash)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (string-hash "0" 1 2)))

;;;----------------------------------------------------------------------------

;;; string-ci-hash

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (string-ci-hash)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (string-ci-hash "0" 1 2)))

;;;----------------------------------------------------------------------------

;;; hash-by-identity

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-by-identity)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (hash-by-identity 0 1 2)))

;;;============================================================================
