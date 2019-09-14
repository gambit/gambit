;;;============================================================================

;;; File: "gambit/srfi/69/69-test.scm"

;;; 2018-2019 by Antoine Doucet.

;;;============================================================================

;;; Basic hash tables (srfi-69).
(##import srfi/69)
(##import gambit/test)


;;; Type constructors and predicate

;;; make-hash-table && hash-table? 
(check-false (hash-table? 1))
(check-true (hash-table? (make-hash-table)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (hash-table?)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (hash-table? 1 2)))

;; alist->hash-table

(check-true (hash-table? (list->hash-table '((0 . 0) (1 . 1) (2 . 2)))))

(check-tail-exn wrong-number-of-arguments-exception? 
    (lambda () (list->hash-table)))

(check-tail-exn wrong-number-of-arguments-exception? 
    (lambda () (list->hash-table '() 0 0 0))) 

;;; Reflexive

(check-equal? (hash-table-equivalence-function (make-hash-table)) ##equal?)
(check-equal? (hash-table-hash-function (make-hash-table)) srfi/69#hash)


;;; Dealing with single elements

;;; hash-table-ref 

(check-equal? (hash-table-ref (list->hash-table '((0 . 0) (1 . 1))) 0) 0)

(check-equal? (hash-table-ref (list->hash-table '((0 . 0) (1 . 1))) 2 #f) #f)

(check-tail-exn wrong-number-of-arguments-exception? 
        (lambda () (hash-table-ref (make-hash-table))))

(check-tail-exn wrong-number-of-arguments-exception? 
        (lambda () (hash-table-ref (make-hash-table) 0 0 0)))

;;; hash-table-set!

(let ((ht (make-hash-table)))
    (hash-table-set! ht 0 1)
    (check-equal? (hash-table-ref ht 0) 1)
    (check-tail-exn wrong-number-of-arguments-exception?
        (lambda () (hash-table-set! ht 0)))
    (check-tail-exn wrong-number-of-arguments-exception?
        (lambda () (hash-table-set! ht 0 1 1))))

;;; hash-table-delete!
(let ((ht (make-hash-table)))
    (hash-table-set! ht 0 1)
    (hash-table-delete! ht 0)
    (check-equal? (hash-table-ref ht 0 #f) #f))


;;; hash-table-exists?
(let ((ht (list->hash-table '((0 . 0) (1 . 1)))))
    (check-true (hash-table-exists? ht 0))
    (hash-table-delete! ht 0)
    (check-false (hash-table-exists? ht 0)))
;;; hash-table-update!

(let ((ht (list->hash-table '((0 . 0)))))
      (hash-table-update! ht 0 (lambda (val) (+ val 1)))
      (check-equal? (hash-table-ref/default ht 0) 1))

;;;
;;; dealing with the whole contents
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; hash-table-size

(check-equal? (hash-table-size (make-hash-table)) 0)
(check-equal? (hash-table-size (list->hash-table '((0 . 0)))) 1)
(check-equal? (hash-table-size (list->hash-table '((0 . 0) (1 . 1)))) 2)


;;; hash-table-keys && hash-table-values

(let ((ht (list->hash-table '((0 . 2) (1 . 3)))))
    (check-true (fold 
        (lambda (elem res) 
            (if (equal? res #t) 
                #t 
                (table-search (lambda (key val) 
                    (if (equal? key elem) 
                    #t 
                    #f)) ht))) #f (hash-table-keys ht))))

(let ((ht (list->hash-table '((0 . 2) (1 . 3)))))
    (check-true (fold (lambda (elem res) (if (equal? res #t) #t (table-search (lambda (key val) (if (equal? val elem) #t #f)) ht))) #f (hash-table-values ht))))

(check-tail-exn wrong-number-of-arguments-exception?
            (lambda () (hash-table-keys (make-hash-table) 0)))
(check-tail-exn wrong-number-of-arguments-exception?
            (lambda () (hash-table-keys)))

(check-tail-exn wrong-number-of-arguments-exception?
            (lambda () (hash-table-values (make-hash-table) 0)))
(check-tail-exn wrong-number-of-arguments-exception?
            (lambda () (hash-table-values)))

;;; hash-table-walk && hash-table-fold
(let ((ht (list->hash-table '((0 . 1) (1 . 1)))))
    (hash-table-walk ht (lambda (key val) (hash-table-set! ht key 0)))
    (check-equal? (hash-table-ref/default ht 0) 0))

(let ((ht (list->hash-table '((0 . 1) (1 . 1) (2 . 2)))))
    (hash-table-fold ht 
            (lambda (key val result) (hash-table-set! ht key result)
                                     (hash-table-ref/default ht key)) 0)
    (check-equal? (hash-table-ref/default ht 0) 0)
    (check-equal? (hash-table-ref/default ht 1) 0)
    (check-equal? (hash-table-ref/default ht 2) 0))

;;; hash-table->alist
(let ((lst '((0 . 0) (1 . 1))))
    (check-true (fold (lambda (map-elem res1) (if (equal? res1 #f) #f 
                    (fold (lambda (elem res2) (if (equal? res2 #t) #t 
                            (if (equal? map-elem elem) #t #f))) #f lst) ))
                      #t
                      (hash-table->alist (list->hash-table lst)))))

;;; hash-table-copy

(let* ((ht1 (make-hash-table))
      (ht2 (hash-table-copy ht1)))
      (check-equal? ht1 ht2)
      (hash-table-set! ht1 0 0)
      (check-not-equal? ht1 ht2))

;;; hash-table-merge!

(let ((ht1 (list->hash-table '((0 . 0) (1 . 1))))
      (ht2 (list->hash-table '((2 . 2) (3 . 3))))
      (ht3 (list->hash-table '((0 . 0) (1 . 1) (2 . 2) (3 . 3)))))
      (check-equal? ht3 (hash-table-merge! ht1 ht2)))

;;; Hashing

;;;============================================================================
