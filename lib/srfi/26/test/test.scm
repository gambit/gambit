(import (srfi 26))
(import (_test))

(test-equal -1 ((cut - 1 <>) 2))

(test-equal -1 ((cut - <> 2) 1))

(test-equal -1 ((cut <> 1 2) -))

(test-equal -1 ((cut - <...>) 1 2))

(test-equal 0 ((cut - <> 10 <>) 11 1))

(test-equal -3 ((cut - <> 10 <...>) 11 1 3))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Following tests adapted from https://srfi.schemers.org/srfi-26/check.scm ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(test-equal '() ((cut list)))
(test-equal '() ((cut list <...>)))
(test-equal '(1) ((cut list 1)))
(test-equal '(1) ((cut list <>) 1))
(test-equal '(1) ((cut list <...>) 1))
(test-equal '(1 2) ((cut list 1 2)))
(test-equal '(1 2) ((cut list 1 <>) 2))
(test-equal '(1 2) ((cut list 1 <...>) 2))
(test-equal '(1 2 3 4) ((cut list 1 <...>) 2 3 4))
(test-equal '(1 2 3 4) ((cut list 1 <> 3 <>) 2 4))
(test-equal '(1 2 3 4 5 6) ((cut list 1 <> 3 <...>) 2 4 5 6))
(test-equal '(ok) (let* ((x 'wrong) (y (cut list x))) (set! x 'ok) (y)))
(test-equal 2
            (let ((a 0))
              (map (cut + (begin (set! a (+ a 1)) a) <>)
                   '(1 2))
              a))

(test-equal '() ((cute list)))
(test-equal '() ((cute list <...>)))
(test-equal '(1) ((cute list 1)))
(test-equal '(1) ((cute list <>) 1))
(test-equal '(1) ((cute list <...>) 1))
(test-equal '(1 2) ((cute list 1 2)))
(test-equal '(1 2) ((cute list 1 <>) 2))
(test-equal '(1 2) ((cute list 1 <...>) 2))
(test-equal '(1 2 3 4) ((cute list 1 <...>) 2 3 4))
(test-equal '(1 2 3 4) ((cute list 1 <> 3 <>) 2 4))
(test-equal '(1 2 3 4 5 6) ((cute list 1 <> 3 <...>) 2 4 5 6))
(test-equal 1
            (let ((a 0))
              (map (cute + (begin (set! a (+ a 1)) a) <>)
                   '(1 2))
              a))
