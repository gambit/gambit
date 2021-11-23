;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2018-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _hamt)
(import _test)

(test-assert (not (hamt? 42)))
(test-assert (hamt? (make-hamt)))
(test-error-tail wrong-number-of-arguments-exception? (hamt?))
(test-error-tail wrong-number-of-arguments-exception? (hamt? 1 2))

(test-assert (hamt? (make-hamt)))
(test-assert (hamt? (make-hamt test: =)))
(test-assert (hamt? (make-hamt hash: square)))
(test-assert (hamt? (make-hamt test: = hash: square)))
(test-error-tail type-exception? (make-hamt test: 1))
(test-error-tail type-exception? (make-hamt hash: 1))
(test-error-tail wrong-number-of-arguments-exception? (make-hamt 1))

(test-equal 0 (hamt-length (make-hamt)))
(test-equal 1 (hamt-length (hamt-set (make-hamt) 'a 5)))
(test-equal 2 (hamt-length (hamt-set (hamt-set (make-hamt) 'a 5) 'b 9)))
(test-error-tail type-exception? (hamt-length 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-length))
(test-error-tail wrong-number-of-arguments-exception? (hamt-length 1 2))

(test-equal 5 (hamt-ref (hamt-set (make-hamt) 'a 5) 'a))
(test-equal 5 (hamt-ref (hamt-set (make-hamt) 'a 5) 'a 3))
(test-equal 3 (hamt-ref (make-hamt) 'a 3))
(test-error-tail type-exception? (hamt-ref 1 'a))
(test-error-tail wrong-number-of-arguments-exception? (hamt-ref))
(test-error-tail wrong-number-of-arguments-exception? (hamt-ref 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-ref 1 2 3 4))
(test-error-tail unbound-key-exception? (hamt-ref (make-hamt) 'a))

(test-equal 1 (hamt-length (hamt-set (make-hamt) 'a 5)))
(test-equal 1 (hamt-length (hamt-set (hamt-set (make-hamt) 'a 5) 'a 3)))
(test-equal 2 (hamt-length (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3)))
(test-equal 3 (hamt-length (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)))
(test-equal 1 (hamt-length (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'a)))
(test-error-tail type-exception? (hamt-set 1 'a 5))
(test-error-tail type-exception? (hamt-set 1 'a))
(test-error-tail wrong-number-of-arguments-exception? (hamt-set))
(test-error-tail wrong-number-of-arguments-exception? (hamt-set 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-set 1 2 3 4))

(test-equal '() (hamt->list (hamt-merge (make-hamt) (make-hamt))))
(test-equal '((a . 5)) (hamt->list (hamt-merge (hamt-set (make-hamt) 'a 5) (make-hamt))))
(test-equal '((a . 5)) (hamt->list (hamt-merge (make-hamt) (hamt-set (make-hamt) 'a 5))))
(test-equal '((a . 5)) (hamt->list (hamt-merge (hamt-set (make-hamt) 'a 5) (hamt-set (make-hamt) 'a 3))))
(test-equal '((a . 5)) (hamt->list (hamt-merge (hamt-set (make-hamt) 'a 5) (hamt-set (make-hamt) 'a 3) #f)))
(test-equal '((a . 3)) (hamt->list (hamt-merge (hamt-set (make-hamt) 'a 5) (hamt-set (make-hamt) 'a 3) #t)))
(test-error-tail type-exception? (hamt-merge 1 (make-hamt)))
(test-error-tail type-exception? (hamt-merge (make-hamt) 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-merge))
(test-error-tail wrong-number-of-arguments-exception? (hamt-merge 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-merge 1 2 3 4))

(test-equal 3
            (hamt-search (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)
                         (lambda (k v) (and (eq? k 'b) v))))
(test-equal #f
            (hamt-search (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)
                         (lambda (k v) (and (eq? k 'z) v))))
(test-error-tail type-exception? (hamt-search 1 pair?))
(test-error-tail type-exception? (hamt-search (make-hamt) 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-search))
(test-error-tail wrong-number-of-arguments-exception? (hamt-search 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-search 1 2 3))

(test-equal 9 (hamt-fold (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) (lambda (b k v) (+ b v)) 0))
(test-error-tail type-exception? (hamt-fold 1 list 2))
(test-error-tail type-exception? (hamt-fold (make-hamt) 1 2))
(test-error-tail wrong-number-of-arguments-exception? (hamt-fold))
(test-error-tail wrong-number-of-arguments-exception? (hamt-fold 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-fold 1 2))
(test-error-tail wrong-number-of-arguments-exception? (hamt-fold 1 2 3 4))

(test-equal 9
            (let ((sum 0))
              (hamt-for-each (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)
                             (lambda (k v) (set! sum (+ sum v))))
              sum))
(test-error-tail type-exception? (hamt-for-each 1 list))
(test-error-tail type-exception? (hamt-for-each (make-hamt) 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-for-each))
(test-error-tail wrong-number-of-arguments-exception? (hamt-for-each 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-for-each 1 2 3))

(test-equal '((a 5) (b 3) (c 1)) (hamt-map (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) list))
(test-error-tail type-exception? (hamt-map 1 list))
(test-error-tail type-exception? (hamt-map (make-hamt) 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-map))
(test-error-tail wrong-number-of-arguments-exception? (hamt-map 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-map 1 2 3))

(test-equal '((c . 1) (b . 3) (a . 5)) (hamt->list (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)))
(test-error-tail type-exception? (hamt->list 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt->list))
(test-error-tail wrong-number-of-arguments-exception? (hamt->list 1 2))

(test-equal (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)
            (list->hamt '((c . 1) (b . 3) (a . 5))))
(test-equal (hamt-set (hamt-set (hamt-set (make-hamt test: eq?) 'a 5) 'b 3) 'c 1)
            (list->hamt '((c . 1) (b . 3) (a . 5)) test: eq?))
(test-equal (hamt-set (hamt-set (hamt-set (make-hamt hash: symbol-hash) 'a 5) 'b 3) 'c 1)
            (list->hamt '((c . 1) (b . 3) (a . 5)) hash: symbol-hash))
(test-equal (hamt-set (hamt-set (hamt-set (make-hamt test: eq? hash: symbol-hash) 'a 5) 'b 3) 'c 1)
            (list->hamt '((c . 1) (b . 3) (a . 5)) test: eq? hash: symbol-hash))
(test-error-tail type-exception? (list->hamt 1))
(test-error-tail type-exception? (list->hamt '(1)))
(test-error-tail type-exception? (list->hamt '((a . 1) . b)))
(test-error-tail type-exception? (list->hamt '() test: 1))
(test-error-tail type-exception? (list->hamt '() hash: 1))
(test-error-tail wrong-number-of-arguments-exception? (list->hamt))
(test-error-tail wrong-number-of-arguments-exception? (list->hamt 1 2))

(test-assert (hamt-empty? (make-hamt)))
(test-assert (not (hamt-empty? (hamt-set (make-hamt) 'a 5))))
(test-error-tail type-exception? (hamt-empty? 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-empty?))
(test-error-tail wrong-number-of-arguments-exception? (hamt-empty? 1 2))

(test-assert (hamt-has-key? (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) 'b))
(test-assert (not (hamt-has-key? (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) 'z)))
(test-error-tail type-exception? (hamt-has-key? 1 'a))
(test-error-tail wrong-number-of-arguments-exception? (hamt-has-key?))
(test-error-tail wrong-number-of-arguments-exception? (hamt-has-key? 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-has-key? 1 2 3))

(test-assert (hamt-has-value? (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) 3))
(test-assert (hamt-has-value? (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) 3 eq?))
(test-assert (not (hamt-has-value? (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) 0)))
(test-assert (not (hamt-has-value? (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1) 0 =)))
(test-error-tail type-exception? (hamt-has-value? 1 'a))
(test-error-tail type-exception? (hamt-has-value? (make-hamt) 'a 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-has-value?))
(test-error-tail wrong-number-of-arguments-exception? (hamt-has-value? 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-has-value? 1 2 3 4))

(test-equal '(a b c) (hamt-keys (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)))
(test-error-tail type-exception? (hamt-keys 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-keys))
(test-error-tail wrong-number-of-arguments-exception? (hamt-keys 1 2))

(test-equal '(5 3 1) (hamt-values (hamt-set (hamt-set (hamt-set (make-hamt) 'a 5) 'b 3) 'c 1)))
(test-error-tail type-exception? (hamt-values 1))
(test-error-tail wrong-number-of-arguments-exception? (hamt-values))
(test-error-tail wrong-number-of-arguments-exception? (hamt-values 1 2))

;; collision tests

(define k1 (expt 2 28)) ;; these keys hash to the same alist bucket
(define k2 (- k1))
(define k3 0)

(define h (hamt-set (hamt-set (hamt-set (make-hamt) k1 1) k2 2) k3 3))

(test-equal 3 (hamt-length h))
(test-equal 1 (hamt-ref h k1))
(test-equal 2 (hamt-ref h k2))
(test-equal 3 (hamt-ref h k3))

;;;============================================================================
