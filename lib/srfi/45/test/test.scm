;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 45, Primitives for Expressing Iterative Lazy Algorithms

(import (srfi 45))
(import (_test))

;;;============================================================================

(define temp 0)

(define p1 (delay (begin (set! temp (+ temp 1)) 5)))

(test-equal 5 (force p1))
(test-equal 1 temp)
(test-equal 5 (force p1))
(test-equal 1 temp)

(define p2 (delay (begin (set! temp (+ temp 1)) 6)))
(define p3 (lazy p2))
(define p4 (lazy p3))

(test-equal 6 (force p4))
(test-equal 2 temp)
(test-equal 6 (force p3))
(test-equal 2 temp)

(define (stream-drop s index)
  (lazy
   (if (zero? index)
       s
       (stream-drop (cdr (force s)) (- index 1)))))

(define (ones)
  (delay (begin
           (set! temp (+ temp 1))
           (cons 1 (ones)))))

(define s (ones))

(test-equal 1 (car (force (stream-drop s 4))))
(test-equal 7 temp)
(test-equal 1 (car (force (stream-drop s 4))))
(test-equal 7 temp)

(define count 0)
(define p
  (delay (begin (set! count (+ count 1))
                (if (> count x)
                    count
                    (force p)))))
(define x 5)
(test-equal 6 (force p))
(set! x 10)
(test-equal 6 (force p))

(define f
  (let ((first? #t))
    (delay
      (if first?
          (begin
            (set! first? #f)
            (force f))
          'second))))

(test-equal 'second (force f))

(define q
  (let ((count 5))
    (define (get-count) count)
    (define p (delay (if (<= count 0)
                         count
                         (begin (set! count (- count 1))
                                (force p)
                                (set! count (+ count 2))
                                count))))
    (list get-count p)))

(define get-count (car q))
(define r (cadr q))

(test-equal 5 (get-count))
(test-equal 0 (force r))
(test-equal 10 (get-count))

(define (from n)
  (delay (cons (make-string (+ 1000000 n)) (from (+ n 1)))))

(test-equal 1001000 (string-length (car (force (stream-drop (from 0) 1000)))))

;;;============================================================================
