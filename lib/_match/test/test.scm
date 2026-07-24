;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2008-2025 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _match)
(import _test)

;; tests for match form

(define (f x)
  (match (* x x)
    (0 "zero")
    (1 "one")
    (2 "two")
    (3 "three")
    (4 "four")
    (,other "other")))

(test-equal "zero" (f 0))
(test-equal "one" (f 1))
(test-equal "four" (f 2))
(test-equal "other" (f 3))

(define (g x y)
  (match (cons x y)
    ((5 ,a) 0)
    ((a: 5) 9)
    ((,b 5) b)
    ((,c ,d) (+ c d))
    (,other other)))

(test-equal 3 (g 1 '(2)))
(test-equal 9 (g a: '(5)))
(test-equal '(1 2 3) (g 1 '(2 3)))
(test-equal 0 (g 5 '(5)))
(test-equal 0 (g 5 '(1)))
(test-equal 1 (g 1 '(5)))

(define (h x)
  (match x
    (() 0)
    (#f 1)
    (#t 2)
    (abc 3)
    (abc: 9)
    ("abc" 4)
    (123 5)
    (#\x 6)
    ((1 ,z 42) z)
    (else 8))) ;; this must match the symbol "else"

(test-equal 0 (h '()))
(test-equal 1 (h #f))
(test-equal 2 (h #t))
(test-equal 3 (h 'abc))
(test-equal 9 (h abc:))
(test-equal 4 (h "abc"))
(test-equal 5 (h 123))
(test-equal 6 (h #\x))
(test-equal 7 (h '(1 7 42)))
(test-error-tail error-exception? (h '#()))

(test-error-tail error-exception? (match #t))


;; tests for match-syntax form

(define (get-syntax expr-as-string)
  (let ((x (call-with-input-string
             expr-as-string
             ##read-all-as-a-begin-expr-from-port)))
    (cadr (##source-strip (vector-ref x 1)))))

(define (test-syntax expr-as-string proc)
  (##desourcify (proc (get-syntax expr-as-string))))

(define (syntax-h stx)
  (match-syntax stx
    (() 0)
    (#f 1)
    (#t 2)
    (abc 3)
    (abc: 9)
    ("abc" 4)
    (123 5)
    (#\x 6)
    ((1 ,z 42) z)
    (else 8))) ;; this must match the symbol "else"

(define (test-syntax-h expr-as-string)
  (test-syntax expr-as-string syntax-h))

(test-equal 0 (test-syntax-h "()"))
(test-equal 1 (test-syntax-h "#f"))
(test-equal 2 (test-syntax-h "#t"))
(test-equal 3 (test-syntax-h "abc"))
(test-equal 9 (test-syntax-h "abc:"))
(test-equal 4 (test-syntax-h "\"abc\""))
(test-equal 5 (test-syntax-h "123"))
(test-equal 6 (test-syntax-h "#\\x"))
(test-equal 7 (test-syntax-h "(1 7 42)"))
(test-equal 8 (test-syntax-h "else"))
(test-equal '(a . b) (test-syntax-h "(1 (a . b) 42)"))

(test-assert (##source? (syntax-h (get-syntax "(1 (a . b) 42)"))))

;;;============================================================================
