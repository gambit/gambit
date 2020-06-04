;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 158, Generators and Accumulators.

(import (srfi 158))
(import (_test))

;;;============================================================================

(define-macro
  (test-number-args proc m- m+)
    (let* ((z?   (zero? m-))
           (args (iota (if z? (+ m+ 1) (- m- 1)))))
        `(begin
           (test-error-tail
             wrong-number-of-arguments-exception?
             (,proc ,@args))
           ,(if (or z? (zero? m+))
                    '#f
                   `(test-number-args ,proc 0 ,m+)))))

(define-macro
  (test-aux test-type)
    (let* ((test-type (symbol->string test-type))
           (test-name (string->symbol
                       (string-append
                         "test-" test-type )))
           (exception-type (string->symbol
                             (string-append
                               test-type "-exception?"))))
      `(define-syntax ,test-name
         (syntax-rules ()
           ((,test-name proc (arg00 arg01 ...)
                             (arg10 arg11 ...)
                             ...)
            (begin
              (,test-name proc arg00 arg01 ...)
              (,test-name proc arg10 arg11 ...)
              ...))
           ((,test-name proc arg0 ...)
            (test-error
              ,exception-type
              (proc arg0 ...)))))))

(test-aux type)
(test-aux range)

(define-syntax test-exception
  (syntax-rules (type: range: args:)
    ((test-exception proc)
     #f)
    ((test-exception proc (type: t0 t1 ...) tst2 ...)
     (begin
       (test-type proc t0 t1 ...)
       (test-exception proc tst2 ...)))
    ((test-exception proc (range: r0 r1 ...) tst2 ...)
     (begin
       (test-range proc r0 r1 ...)
       (test-exception proc tst2 ...)))
    ((test-exception proc (args: a0 a1) tst2 ...)
     (begin
       (test-number-args proc a0 a1)
       (test-exception proc tst2 ...)))))

;;;============================================================================
;; every-eof-obj?-and-generate

(test-assert (equal? '(0 0) 
                     (every-eof-obj?-and-generate 
                       (list (generator 0)
                             (generator 0)) 
                       '())))

(test-assert (eq? #f 
                  (every-eof-obj?-and-generate 
                    (list (generator 0)
                          (generator)) 
                    '())))

;;;============================================================================
;; generator

(let ((gen (generator 0 1 2)))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object? ((generator))))

;;============================================================================
;; circular-generator

(let ((gen (circular-generator 0 1)))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 0)))

(test-assert (equal? (generator->list
                       (circular-generator 0 1)
                       6)
                     '(0 1 0 1 0 1)))

(test-exception circular-generator
                (args: 1 0))

;;============================================================================
;; make-iota-generator

(let ((gen (make-iota-generator 5)))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2)))

(let ((gen (make-iota-generator 1)))
  (test-assert (= (gen) 0))
  (test-assert (eof-object? (gen))))

(test-assert (equal? (generator->list
                       (make-iota-generator 5 2))
                     '(2 3 4 5 6)))

(test-assert (equal? (generator->list
                       (make-iota-generator 6 2 2))
                     '(2 4 6 8 10 12)))

(let ((gen-exact (make-iota-generator 2 2 1)))
  (gen-exact)
  (test-assert (exact? (gen-exact))))
(let ((gen-inexact (make-iota-generator 2 2 .1)))
  (gen-inexact)
  (test-assert (inexact? (gen-inexact))))
(let ((gen-inexact (make-iota-generator 2 .2 1)))
  (gen-inexact)
  (test-assert (inexact? (gen-inexact))))

(test-exception make-iota-generator
               (type: (#f) (0 #f) (0 1 #f))
               (range: -1)
               (args: 1 3))

;;============================================================================
;; make-range-generator

(let ((gen (make-range-generator 0)))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2)))

(test-assert (equal? (generator->list
                       (make-range-generator 0 2))
                     '(0 1)))

(test-assert (equal? (generator->list
                       (make-range-generator 0 6 2))
                     '(0 2 4)))

(let ((gen-exact   (make-range-generator 0 5 1)))
  (gen-exact)
  (test-assert (exact? (gen-exact))))
(let ((gen-inexact (make-range-generator 0 5 .1)))
  (gen-inexact)
  (test-assert (inexact? (gen-inexact))))
(let ((gen-inexact (make-range-generator .0 5 1)))
  (gen-inexact)
  (test-assert (inexact? (gen-inexact))))

(test-exception make-range-generator
               (type: (#f) (0 #f) (0 1 #f))
               (args: 1 3))

;;============================================================================
;; make-coroutine-generator

(let ((gen (make-coroutine-generator
             (lambda (yield)
               (let loop ((i 0))
                 (when (< i 3)
                       (yield i)
                       (loop (+ i 1))))))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2))
  (test-assert (equal? 
                 (gen) #!eof)))

(test-exception make-coroutine-generator
                (type: 0)
                (args: 1 1))

;;============================================================================
;; list->generator

(let ((gen (list->generator '(0 2 4))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 4))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object?
               ((list->generator '()))))

(test-exception list->generator
                (type: 0)
                (args: 1 1))

;;============================================================================
;; vector->generator

(let ((gen (vector->generator #(0 2 4))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 4))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object?
               ((vector->generator #()))))

(test-exception vector->generator
            (type: (0) (#(0) #f) (#(0) 0 #f))
            (range: (#(0) -1) (#(0) 2 1))
            (args: 1 3))

;;============================================================================
;; reverse-vector->generator

(let ((gen (reverse-vector->generator #(4 2 0))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 4))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object? ((reverse-vector->generator #()))))

(test-exception reverse-vector->generator
                (type: (0) (#(0) #f) (#(0) 0 #f))
                (range: (#(0) -1) (#(0) 2 1))
                (args: 1 3))

;;============================================================================
;; string->generator

(let ((gen (string->generator "024")))
  (test-assert (char=? (gen) #\0))
  (test-assert (char=? (gen) #\2))
  (test-assert (char=? (gen) #\4))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object? ((string->generator ""))))

(test-exception string->generator
                (type: (0) (" " #f) (" " 0 #f))
                (range: (" " -1) (" " 0 -1) (" " 2 1))
                (args: 1 3))

;;============================================================================
;;bytevector->generator

(let ((gen (bytevector->generator (bytevector 0 2 4))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 4))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object? ((bytevector->generator #u8()))))

(test-exception bytevector->generator
                (type: (0) (#u8(0) #f) (#u8(0) 0 #f))
                (range: (#u8(0) -1) (#u8(0) 0 -1) (#u8(0) 2 1))
                (args: 1 3))

;;============================================================================
;; make-for-each-generator

(let ((gen (make-for-each-generator for-each '(0 1 2))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object? ((make-for-each-generator for-each '()))))

(test-exception make-for-each-generator
            (type: 0 0)
            (args: 2 2))

;;============================================================================
;; make-unfold-generator

(let ((gen (make-unfold-generator (lambda (x) (>= x 4))
                                  (lambda (x) (* x x))
                                  (lambda (x) (+ x 1))
                                  1)))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 4))
  (test-assert (= (gen) 9))
  (test-assert (eof-object? (gen))))

(test-exception make-unfold-generator
                (type: (0 + + 0) (+ 0 + 0) (+ + 0 0))
                (args: 4 4))

;;============================================================================
;;============================================================================
;; Generator operations
;;============================================================================
;; gcons*

(let ((gen (gcons* 0 (generator 1))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (eof-object? (gen))))

(test-assert (equal? (generator->list
                       (gcons* 0 1 (generator 2)))
                     '(0 1 2)))
(test-exception gcons*
                (args: 1 0))
        
;;============================================================================
;; gappend

(let ((gen (gappend (list->generator '(0))
                    (list->generator '(1)))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (eof-object? (gen))))

(test-assert (eof-object? ((gappend))))

(test-exception gappend
                (type: (0) (+ 0) (+ + 0) (+ + + 0)))

;;============================================================================
;;gflatten

(let ((gen (gflatten (list->generator '((0 1))))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (eof-object? (gen))))

(test-exception gflatten
                (type: 0)
                (args: 1 1))

;;============================================================================
;; ggroup

(let ((gen (ggroup (list->generator '(0 0 0 1 1 1 2 2 2))
                   3)))
  (test-assert (equal? (gen) '(0 0 0)))
  (test-assert (equal? (gen) '(1 1 1)))
  (test-assert (equal? (gen) '(2 2 2)))
  (test-assert (eof-object? (gen))))

(test-assert (equal? (generator->list
                       (ggroup (generator 0 0 1 1 2) 2 #f))
                     '((0 0) (1 1) (2 #f))))

(test-exception ggroup
                (type: (0 0) (+ #f))
                (range: + -1)
                (args: 2 3))

;;============================================================================
;; gmerge

(let ((gen (gmerge < (list->generator '(0 3))
                     (list->generator '(1 2)))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 3))
  (test-assert (eof-object? (gen))))

(let ((lst '(0 1 2)))
  (test-assert (equal? (generator->list
                         (gmerge < (list->generator lst)))
                       lst)))

(test-exception gmerge
                (type: (0 +) (+ 0) (+ + 0) (+ + + 0))
                (args: 2 0))

;;============================================================================
;; gmap

(let ((gen (gmap - (make-range-generator 0 3))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) -1))
  (test-assert (= (gen) -2))
  (test-assert (eof-object? (gen))))

(test-assert (equal? (generator->list
                       (gmap + (make-range-generator 0 3)
                               (make-range-generator 0 3)))
                     '(0 2 4)))

(test-assert (eof-object? ((gmap + (generator 0 1 2)
                                   (generator)))))

(test-exception gmap
                (type: (0 +) (+ 0) (+ + 0) (+ + + 0))
                (args: 2 0))

;;============================================================================
;; gcombine

(let* ((f (lambda (a b) (values (+ a b) (+ b 1))))
       (gen (gcombine f 0 (generator 1 1 1))))
  (test-assert (= (gen) 1)) ; 0 + 1
  (test-assert (= (gen) 2)) ; 1 + 1
  (test-assert (= (gen) 3)) ; 2 + 1
  (test-assert (eof-object? (gen))))

(test-assert (equal? (generator->list
                       (gcombine (lambda (a c b) (values (+ a b) (+ b c)))
                                 0 (generator 1 1 1) (generator 1 1 1)))
                     '(1 2 3)))
                     
(test-assert (eof-object? ((gcombine + 0 (generator 0 1 2)
                                         (generator)))))

(test-exception gcombine
                (type: (0 0 +) (+ 0 0) (+ 0 + 0))
                (args: 3 0))

;;============================================================================
;;gfilter

(let ((gen (gfilter even?
                    (make-range-generator 0 3))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 2))
  (test-assert (eof-object? (gen))))

(test-exception gfilter
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; gremove

(let ((gen (gremove even?
                    (make-range-generator 0 4))))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 3))
  (test-assert (eof-object? (gen))))

(test-exception gremove
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; gstate-filter

(let ((gen (gstate-filter 
             (lambda (a b)
               (let ((a (= a b)))
                 (values a (+ b 1))))
             1 (generator 1 2 3 5))))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 3))
  (test-assert (eof-object? (gen))))

(test-exception gstate-filter
                (type: (0 0 +) (+ 0 0))
                (args: 3 3))

;;============================================================================
;; gtake

(let ((gen (gtake (make-range-generator 0 4) 2)))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1)))

(test-assert (equal? (generator->list
                       (gtake (generator 0 1) 4 #f))
                     '(0 1 #f #f)))

(test-exception gtake
                (type: (0 0) (+ #f))
                (args: 2 3))

;;============================================================================
;; gdrop

(let ((gen (gdrop (make-range-generator 0 4) 2)))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 3)))

(test-assert (equal? (generator->list
                       (gdrop (generator 0 1 2) 0))
                     '(0 1 2)))

(test-exception gdrop
                (type: (0 0) (+ #f))
                (range: (+ -1))
                (args: 2 2))

;;============================================================================
;; gdrop-while

(let ((gen (gtake-while (lambda (x) (not (eq? x #f)))
                        (generator #f #f 0 1 2))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 1))
  (test-assert (= (gen) 2)))

(test-exception gdrop-while
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; gtake-while

(let ((gen (gtake-while (lambda (x) (< x 4))
                        (generator 0 3 5 6))))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 3))
  (test-assert (eof-object? (gen))))

(test-exception gtake-while
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; gdelete

(let ((gen (gdelete 2 (generator 0 2 4) =)))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 4)))

(test-assert (equal? (generator->list
                       (gdelete 2 (generator 0 2 2 4) =))
                     '(0 4)))

(test-assert (equal? (generator->list
                       (gdelete '(2) (generator '(0) '(2) '(2) '(4))))
                     '((0) (4))))

(test-exception gdelete
                (type: (0 0 +) (0 + 0))
                (args: 2 3))

;;============================================================================
;; gdelete-neighbor-dups

(let ((gen (gdelete-neighbor-dups (generator 0 2 2 4) =)))
  (test-assert (= (gen) 0))
  (test-assert (= (gen) 2))
  (test-assert (= (gen) 4)))

(test-exception gdelete-neighbor-dups
                (type: (0 +) (+ 0))
                (args: 1 2))

;;============================================================================
;; gindex

(let ((gen (gindex (generator 'a 'b 'c 'd)
                   (generator  1 2))))
  (test-assert (eq? (gen) 'b))
  (test-assert (eq? (gen) 'c)))

(test-assert (eof-object? ((gindex (generator)
                                   (generator 0 1 2)))))

(test-assert (eof-object? ((gindex (generator 0 1 2)
                                   (generator)))))


;; run-time exception
(let ((gen (gindex (generator 0 1 2 3)
                   (generator 1 1))))
  (gen)
  (test-error
    range-exception?
    (gen)))



(test-exception gindex
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; gselect

(let ((gen (gselect (generator 'a 'b 'c 'd)
                    (generator  #f #t #t #f))))
  (test-assert (eq? (gen) 'b))
  (test-assert (eq? (gen) 'c)))

(test-assert (eof-object? ((gselect (generator)
                                    (generator #t #f #t)))))


(test-assert (eof-object? ((gselect (generator 0 1 2)
                                    (generator)))))

(test-exception gselect
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; generator->list

(let ((gen (make-range-generator 0 3)))
  (test-assert (equal? (generator->list gen) 
                       '(0 1 2))))

(let ((gen (circular-generator 0 1 2 3)))
  (test-assert (equal? (generator->list gen 4)
                       '(0 1 2 3))))

(test-exception generator->list
                (type: (0) (+ #f))
                (range: + -1)
                (args: 1 2))

;;============================================================================
;; generator->reverse-list

(let ((gen (make-range-generator 0 3)))
  (test-assert (equal? (generator->reverse-list gen) 
                       '(2 1 0))))

(let ((gen (circular-generator 0 1 2)))
  (test-assert (equal? (generator->reverse-list gen 3) 
                       '(2 1 0))))


(test-exception generator->reverse-list
                (type: (0) (+ #f))
                (range: + -1)
                (args: 1 2))

;;============================================================================
;; generator->vector

(let ((gen (make-range-generator 0 3)))
  (test-assert (equal? (generator->vector gen)
                       #(0 1 2))))

(let ((gen (circular-generator 0 1 2)))
  (test-assert (equal? (generator->vector gen 3)
                       #(0 1 2))))

(test-exception generator->vector
                (type: (0) (+ #f))
                (range: + -1)
                (args: 1 2))

;;============================================================================
;; generator->vector!

(let ((vec #(10 10 10)))
  (generator->vector! vec 0 (make-range-generator 0 3))
  (test-assert (equal? vec #(0 1 2))))

(test-exception generator->vector!
                (type: (0 0 +) (#(0) #f +) (#(0) 0 0))
                (range: (#(0 1 2) -1 +) (#(0 1 2) 4 +))
                (args: 3 3))

;;============================================================================
;; generator->string

(let ((gen (generator #\a #\b #\c)))
  (test-assert (equal? (generator->string gen)
                        "abc")))

(let ((gen (circular-generator #\a #\b #\c)))
  (test-assert (equal? (generator->string gen 3)
                        "abc")))

(test-exception generator->string
            (type: (0) (+ #f))
            (range: + -1)
            (args: 1 2))

;;============================================================================
;; generator-fold

(let ((gen (generator 0 1 2 3)))
  (test-assert (= (generator-fold + (gen) gen) 6)))

(test-assert (= 6 (generator-fold + 0 (generator 0 1 2)
                                      (generator 0 1 2))))

(test-assert (= 0 (generator-fold + 0 (generator 1 2 3 4)
                                      (generator))))
(test-exception generator-fold
                (type: (0 0 +) (+ 0 0) (+ 0 + 0))
                (args: 3 0))

;;============================================================================
;; generator-for-each

(let ((var #f)
      (gen (generator 0 1 2 3)))
  (generator-for-each 
    (lambda (x) (set! var x)
                (test-assert var x))
    gen))

(let ((var #f)
      (gen (generator 0 1 2 3 4)))
  (generator-for-each
    (lambda (a b) (set! var (+ a b))
                  (test-assert var (+ a b)))
    gen
    gen))

(let ((var #f))
  (generator-for-each (lambda (a b) (set! var (and a b)))
                      (generator #t #t #t #t)
                      (generator))
  (test-assert (not var)))

(test-exception generator-for-each
                (type: (0 +) (+ 0) (+ + 0) (+ + + 0))
                (args: 2 0))

;;============================================================================
;; generator-map->list

(test-assert 
  (equal? 
    (generator-map->list even? (make-range-generator 0 3))
    '(#t #f #t)))

(test-assert 
  (equal? 
    (generator-map->list (lambda (a b)
                           (even? (+ a b)))
                         (generator 0 1 2 3 4)
                         (generator 0 1 2 3 4))
    '(#t #t #t #t #t)))

(test-assert (null?
               (generator-map->list + (generator 0 1 2)
                                      (generator))))

(test-exception generator-map->list
                (type: (0 +) (+ 0) (+ + 0) (+ + + 0))
                (args: 2 0))

;;============================================================================
;; generator-find

(test-assert
  (= (generator-find (lambda (x) (= 2 x))
                     (make-range-generator 0 3))
     2))

(test-exception generator-find
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; generator-count

(test-assert (= (generator-count even? (make-range-generator 0 3))
                2))

(test-exception generator-count
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; generator-any

(test-assert (eq? (generator-any even? (make-range-generator 1 4)) 
                #t))
(test-assert (eq? (generator-any (lambda (x) (> x 10)) 
                               (make-range-generator 1 4)) 
                #f))

(test-exception generator-any
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; generator-every

(test-assert (eq? (generator-every even? (make-range-generator 1 4)) 
                  #f))

(test-assert (eq? (generator-every even? (generator 0 2 4))
                  #t))

(test-assert (eq? (generator-every even? (generator))
                  #t))

(test-assert (eq? (generator-every even? (generator 1))
                  #f))

(test-exception generator-every
                (type: (0 +) (+ 0))
                (args: 2 2))

;;============================================================================
;; generator-unfold

(define (unfold p f g seed #!optional (tail-gen (lambda (x) '())))
  (if (p seed)
      '()
      (cons (f seed)
            (unfold p f g (g seed)))))

      
(test-assert
  (equal? (list->string 
            (generator-unfold (make-for-each-generator
                        string-for-each "abc")
                      unfold))
          "abc"))

(test-exception generator-unfold
                (type: (0 +) (+ 0))
                (args: 2 0))

;;;============================================================================
;; Accumulators
;;;============================================================================
;; make-accumulator

(let* ((res #f)
       (accu (make-accumulator (lambda (x state)
                                 (+ x state))
                               0
                               (lambda (state)
                                 (set! res state)))))
  (accu 1)
  (test-assert (not res))
  (accu 1)
  (accu #!eof)
  (test-assert (= 2 res))
  (accu #!eof)
  (test-assert (= 2 res))
  (accu 1)
  (accu #!eof)
  (test-assert (= 3 res)))

(let ((accu (make-accumulator + 0 identity)))
  (accu 1)
  (test-assert (+ (accu #!eof) 1)))

(test-exception make-accumulator
                (type: (0 0 +) (+ 0 0))
                (args: 3 3))

;;============================================================================
;; count-accumulator

(let ((accu (count-accumulator)))
  (accu 0)
  (accu 0)
  (accu 0)
  (accu 0)
  (test-assert (= 4 (accu #!eof))))

(test-number-args make-accumulator 0 0)

;;============================================================================
;; list-accumulator

(let ((accu (list-accumulator)))
  (accu 0)
  (accu 1)
  (accu 2)
  (test-assert (equal? (accu #!eof) '(0 1 2))))

(test-number-args list-accumulator 0 0)

;;============================================================================
;; reverse-list-accumulator

(let ((accu (reverse-list-accumulator)))
  (accu 2)
  (accu 1)
  (accu 0)
  (test-assert (equal? (accu #!eof) '(0 1 2))))

(test-number-args reverse-list-accumulator 0 0)

;;============================================================================
;; vector-accumulator

(let ((accu (vector-accumulator)))
  (accu 0)
  (accu 1)
  (accu 2)
  (test-assert (equal? (accu #!eof) #(0 1 2))))

(test-number-args vector-accumulator 0 0)

;;============================================================================
;; reverse-vector-accumulator

(let ((accu (reverse-vector-accumulator)))
  (accu 2)
  (accu 1)
  (accu 0)
  (test-assert (equal? (accu #!eof) #(0 1 2))))

(test-number-args reverse-vector-accumulator 0 0)

;;============================================================================
;;vector-accumulator!

(let* ((vec #(0 1 0 0 0))
       (accu (vector-accumulator! vec 1)))
  (accu 2)
  (accu 2)
  (accu 2)
  (test-assert (equal? vec #(0 2 2 2 0)))
  (test-assert (equal? (accu #!eof) #(0 2 2 2 0))))


;; check cap max

(test-exception vector-accumulator!
                (type: (0 0) (#(0) #f))
                (range: (#(0) -1) (#(0 1 2 3) 5))
                (args: 2 2))

;;============================================================================
;; bytevector-accumulator

(let ((accu (bytevector-accumulator)))
  (accu 0)
  (accu 1)
  (accu 2)
  (test-assert (equal? (accu #!eof) #u8(0 1 2))))

(test-number-args bytevector-accumulator 0 0)

;;============================================================================
;; bytevector-accumulator!

(let* ((str #u8(0 1 0 0 0))
       (accu (bytevector-accumulator! str 1)))
  (accu 2)
  (accu 2)
  (accu 2)
  (test-assert (equal? str #u8(0 2 2 2 0)))
  (test-assert (equal? (accu #!eof) #u8(0 2 2 2 0))))

(test-exception bytevector-accumulator!
                (type: (0 0) (#u8(0) #f))
                (range: (#u8(0) -1) (#u8(0 1 2) 4))
                (args: 2 2))

;;============================================================================
;; string-accumulator

(let ((accu (string-accumulator)))
  (accu #\a)
  (accu #\b)
  (accu #\c)
  (test-assert (equal? (accu #!eof) "abc")))

(test-number-args string-accumulator 0 0)

;;============================================================================
;; sum-accumulator

(let ((accu (sum-accumulator)))
  (accu 1)
  (accu 2)
  (accu 3)
  (test-assert (= 6 (accu #!eof))))

(test-number-args sum-accumulator 0 0)

;;============================================================================
;; product-accumulator

(let ((accu (product-accumulator)))
  (accu 1)
  (accu 2)
  (accu 3)
  (test-assert (= 6 (accu #!eof))))

(test-number-args product-accumulator 0 0)

;;;============================================================================
