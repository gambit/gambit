;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 141, Integer division

(import (srfi 141))
(import (_test))

;;;============================================================================

(test-equal (call-with-values (lambda () (balanced/ -1 2)) list) '(0 -1))
(test-equal (call-with-values (lambda () (balanced/ 2 3)) list) '(1 -1))
(test-equal (call-with-values (lambda () (balanced/ 1 -2)) list) '(-1 -1))
(test-equal (call-with-values (lambda () (balanced/ 1 4)) list) '(0 1))
(test-equal (call-with-values (lambda () (balanced/ 1 2)) list) '(1 -1))

(test-equal (call-with-values (lambda () (ceiling/ -1 2)) list) '(0 -1))
(test-equal (call-with-values (lambda () (ceiling/ 2 3)) list) '(1 -1))
(test-equal (call-with-values (lambda () (ceiling/ 1 -2)) list) '(0 1))
(test-equal (call-with-values (lambda () (ceiling/ 1 4)) list) '(1 -3))
(test-equal (call-with-values (lambda () (ceiling/ 1 2)) list) '(1 -1))

(test-equal (call-with-values (lambda () (euclidean/ -1 2)) list) '(-1 1))
(test-equal (call-with-values (lambda () (euclidean/ 2 3)) list) '(0 2))
(test-equal (call-with-values (lambda () (euclidean/ 1 -2)) list) '(0 1))
(test-equal (call-with-values (lambda () (euclidean/ 1 4)) list) '(0 1))
(test-equal (call-with-values (lambda () (euclidean/ 1 2)) list) '(0 1))

(test-equal (call-with-values (lambda () (floor/ -1 2)) list) '(-1 1))
(test-equal (call-with-values (lambda () (floor/ 2 3)) list) '(0 2))
(test-equal (call-with-values (lambda () (floor/ 1 -2)) list) '(-1 -1))
(test-equal (call-with-values (lambda () (floor/ 1 4)) list) '(0 1))
(test-equal (call-with-values (lambda () (floor/ 1 2)) list) '(0 1))

(test-equal (call-with-values (lambda () (round/ -1 2)) list) '(0 -1))
(test-equal (call-with-values (lambda () (round/ 2 3)) list) '(1 -1))
(test-equal (call-with-values (lambda () (round/ 1 -2)) list) '(0 1))
(test-equal (call-with-values (lambda () (round/ 1 4)) list) '(0 1))
(test-equal (call-with-values (lambda () (round/ 1 2)) list) '(0 1))

(test-equal (call-with-values (lambda () (truncate/ -1 2)) list) '(0 -1))
(test-equal (call-with-values (lambda () (truncate/ 2 3)) list) '(0 2))
(test-equal (call-with-values (lambda () (truncate/ 1 -2)) list) '(0 1))
(test-equal (call-with-values (lambda () (truncate/ 1 4)) list) '(0 1))
(test-equal (call-with-values (lambda () (truncate/ 1 2)) list) '(0 1))

#|

Program for generating test cases:

(define name+procs (map list
                        '(balanced/
                          ceiling/
                          euclidean/
                          floor/
                          round/
                          truncate/)
                        (list balanced/
                              ceiling/
                              euclidean/
                              floor/
                              round/
                              truncate/)))

(define test-pairs '((-1 2) (2 3) (1 -2) (1 4) (1 2)) )

(for-each (lambda (name+proc)
            (for-each (lambda (test-pair)
                        (let ((name (car name+proc))
                              (proc (cadr name+proc)))
                          (pretty-print
                           `(test-equal (call-with-values (lambda () ,(cons name test-pair)) list)
                                        ',(call-with-values (lambda () (apply proc test-pair)) list)))))
                      test-pairs))
          name+procs)

These arguments were chosen to distinguish among the various division procedures.

|#

;;;============================================================================
