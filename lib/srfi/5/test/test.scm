;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 5, Primitives for Expressing Iterative Lazy Algorithms

(import (srfi 5))
(import (_test))

;;;============================================================================

(define (const x) (lambda () x))

(test-equal 1
  (let () (begin (define n 10)) (- n 9)))

(test-equal 1
  (let () ((const 0)) (- 10 9)))

(test-equal 2
  (let ((n 10)) (begin (define m 8)) (- n m)))

(test-equal 2
  (let ((n 10)) ((const 0)) (- n 8)))

(test-equal 3
  (let ((n 10) (m 5)) (begin (define x 2)) (- (- n m) x)))

(test-equal 3
  (let ((n 10) (m 5)) ((const 0)) (- (- n m) 2)))

(define count 0)

(test-equal 4
  (let loop ()
    (begin (define n 4))
    (if (< count n)
        (begin (set! count (+ count 1)) (loop))
        count)))

(set! count 0)

(test-equal 4
  (let loop ()
    ((const 0))
    (if (< count 4)
        (begin (set! count (+ count 1)) (loop))
        count)))

(test-equal 5
  (let loop ((i 0))
    (begin (define n 5))
    (if (< i n)
        (loop (+ i 1))
        i)))

(test-equal 5
  (let loop ((i 0))
    ((const 0))
    (if (< i 5)
        (loop (+ i 1))
        i)))

(test-equal 6
  (let loop ((i 0) (j 12))
    (begin (define one 1))
    (if (< i j)
        (loop (+ i one) (- j one))
        i)))

(test-equal 6
  (let loop ((i 0) (j 12))
    ((const 0))
    (if (< i j)
        (loop (+ i 1) (- j 1))
        i)))

(set! count 0)

(test-equal 4
  (let (loop)
    (begin (define n 4))
    (if (< count n)
        (begin (set! count (+ count 1)) (loop))
        count)))

(set! count 0)

(test-equal 4
  (let (loop)
    ((const 0))
    (if (< count 4)
        (begin (set! count (+ count 1)) (loop))
        count)))

(test-equal 5
  (let (loop (i 0))
    (begin (define n 5))
    (if (< i n)
        (loop (+ i 1))
        i)))

(test-equal 5
  (let (loop (i 0))
    ((const 0))
    (if (< i 5)
        (loop (+ i 1))
        i)))

(test-equal 6
  (let (loop (i 0) (j 12))
    (begin (define one 1))
    (if (< i j)
        (loop (+ i one) (- j one))
        i)))

(test-equal 6
  (let (loop (i 0) (j 12))
    ((const 0))
    (if (< i j)
        (loop (+ i 1) (- j 1))
        i)))

(test-equal '(1 2 3 4 5)
  (let loop (rest 10 11 12)
    (begin (define four 4))
    (if (< (length rest) four)
        (loop 1 2 3 4 5)
        rest)))

(test-equal '(1 2 3 4 5)
  (let loop (rest 10 11 12)
    ((const 0))
    (if (< (length rest) 4)
        (loop 1 2 3 4 5)
        rest)))

(test-equal '(1 1 2 3 4 5)
  (let loop ((i 0) rest 10 11 12)
    (begin (define four 4))
    (if (< (length rest) four)
        (loop (+ i 1) 1 2 3 4 5)
        (cons i rest))))

(test-equal '(1 1 2 3 4 5)
  (let loop ((i 0) rest 10 11 12)
    ((const 0))
    (if (< (length rest) 4)
        (loop (+ i 1) 1 2 3 4 5)
        (cons i rest))))

(test-equal '(1 1 2 3 4 5)
  (let loop ((i 0) . (rest 10 11 12))
    (begin (define four 4))
    (if (< (length rest) four)
        (loop (+ i 1) 1 2 3 4 5)
        (cons i rest))))

(test-equal '(1 1 2 3 4 5)
  (let loop ((i 0) . (rest 10 11 12))
    ((const 0))
    (if (< (length rest) 4)
        (loop (+ i 1) 1 2 3 4 5)
        (cons i rest))))

(test-equal '(1 -1 1 2 3 4 5)
  (let loop ((i 0) (j 0) . (rest 10 11 12))
    (begin (define four 4))
    (if (< (length rest) four)
        (loop (+ i 1) (- j 1) 1 2 3 4 5)
        (cons i (cons j rest)))))

(test-equal '(1 -1 1 2 3 4 5)
  (let loop ((i 0) (j 0) . (rest 10 11 12))
    ((const 0))
    (if (< (length rest) 4)
        (loop (+ i 1) (- j 1) 1 2 3 4 5)
        (cons i (cons j rest)))))

(test-equal '(1 2 3 4 5)
  (let (loop . (rest 10 11 12))
    (begin (define four 4))
    (if (< (length rest) four)
        (loop 1 2 3 4 5)
        rest)))

(test-equal '(1 2 3 4 5)
  (let (loop . (rest 10 11 12))
    ((const 0))
    (if (< (length rest) 4)
        (loop 1 2 3 4 5)
        rest)))

(test-equal '(1 1 2 3 4 5)
  (let (loop (i 0) . (rest 10 11 12))
    (begin (define four 4))
    (if (< (length rest) four)
        (loop (+ i 1) 1 2 3 4 5)
        (cons i rest))))

(test-equal '(1 1 2 3 4 5)
  (let (loop (i 0) . (rest 10 11 12))
    ((const 0))
    (if (< (length rest) 4)
        (loop (+ i 1) 1 2 3 4 5)
        (cons i rest))))

(test-equal '(1 -1 1 2 3 4 5)
  (let (loop (i 0) (j 0) . (rest 10 11 12))
    (begin (define four 4))
    (if (< (length rest) 4)
        (loop (+ i 1) (- j 1) 1 2 3 4 5)
        (cons i (cons j rest)))))

(test-equal '(1 -1 1 2 3 4 5)
  (let (loop (i 0) (j 0) . (rest 10 11 12))
    ((const 0))
    (if (< (length rest) 4)
        (loop (+ i 1) (- j 1) 1 2 3 4 5)
        (cons i (cons j rest)))))

;;;============================================================================
