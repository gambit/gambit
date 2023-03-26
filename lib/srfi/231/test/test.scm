#|
SRFI 231: Intervals and Generalized Arrays

Copyright 2016, 2018, 2020, 2021, 2022 Bradley J Lucier.
All Rights Reserved.

Permission is hereby granted, free of charge,
to any person obtaining a copy of this software
and associated documentation files (the "Software"),
to deal in the Software without restriction,
including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice
(including the next paragraph) shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF
ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT
LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO
EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE
FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
|#

;;; A test program for SRFI 231:
;;; Intervals and Generalized Arrays

'(begin
  ;; Uncomment this line to run test-arrays.scm in Gambit.
  (include "generalized-arrays.scm"))

(begin
  ;; To run test-arrays.scm as an R7RS module in Gambit,
  ;; take the following steps:
  ;; 1. Put generalized-arrays.scm and 231.sld in new directory ./srfi/231.
  ;; 2. Uncomment this "begin".
  ;; 2 bis. If you want to compile the library do "gsc . srfi/231".
  ;; 3. Run "gsi . test-arrays".

  (import (srfi 231))

  (##namespace
   ("srfi/231#"
    ;; Internal SRFI 231 procedures that are either tested or called here.
    %%test-moves           ;; TODO: Remove after testing
    %%compose-indexers
    make-%%array
    %%every
    %%interval->basic-indexer
    %%interval-lower-bounds
    %%interval-upper-bounds
    %%move-array-elements
    %%permutation-invert
    %%vector-every
    %%vector-permute
    %%vector-permute->list
    %%order-unknown
    %%compute-array-packed?
    %%array-domain
    %%array-indexer
    %%array-getter
    %%array-packed?))
  )

(declare (standard-bindings)(extended-bindings)(block)(not safe) (mostly-fixnum))

(declare (inlining-limit 0))
(define random-tests 100)
(set! random-tests random-tests)

(define total-tests 0)
(set! total-tests total-tests)

(define failed-tests 0)
(set! failed-tests failed-tests)

;;; The next macros are not hygienic, so don't call any variable
;;; "continuation" ...

(define-macro (test expr value)
  `(let* (;(ignore (pretty-print ',expr))
          (result (call-with-current-continuation
                   (lambda (continuation)
                     (with-exception-catcher
                      (lambda (args)
                        (cond ((error-exception? args)
                               (continuation (error-exception-message args)))
                              ;; I don't expect any of these, but it sure makes debugging easier
                              ((unbound-global-exception? args)
                               (unbound-global-exception-variable args))
                              ((wrong-number-of-arguments-exception? args)
                               "Wrong number of arguments passed to procedure ")
                              (else
                               "piffle")))

                      (lambda ()
                        ,expr))))))
     (set! total-tests (+ total-tests 1))
     (if (not (equal? result ,value))
         (begin
           (set! failed-tests (+ failed-tests 1))
           (pp (list ',expr" => " result ", not " ,value))))))

(define-macro (test-multiple-values expr vals)
  `(call-with-values
       (lambda () ,expr)
     (lambda args
       (set! total-tests (+ total-tests 1))
       (if (not (equal? args ,vals))
           (begin
             (set! failed-tests (+ failed-tests 1))
             (pp (list ',expr  " => " args ", not " ,vals #\newline)))))))

;;; requires make-list function

;;; Pseudo-random infrastructure

;;; The idea is to have more reproducibility in the random tests.
;;; Our goal is that if this file is run with random-tests=N and then
;;; run with random-tests=M>N, then the parameters of the first N of M tests in each block
;;; will be the same as the parameters of the tests in the run with random-tests=N.

;;; Call next-test-random-source-state! immediately *after* each loop that is
;;; executed random-tests number of times.


(define test-random-source
  (make-random-source))

(define initial-test-random-source-state
  (random-source-state-ref test-random-source))

(define next-test-random-source-state!
  (let ((j 0))
    (lambda ()
      (set! j (fx+ j 1))
      (random-source-state-set!
       test-random-source
       initial-test-random-source-state)
      (random-source-pseudo-randomize!
       test-random-source
       0 j))))

(define test-random-integer
  (random-source-make-integers
   test-random-source))

(define test-random-real
  (random-source-make-reals
   test-random-source))



(define (random a #!optional b)
  (if b
      (+ a (test-random-integer (- b a)))
      (test-random-integer a)))

(define (random-inclusive a #!optional b)
  (if b
      (+ a (test-random-integer (- b a -1)))
      (test-random-integer (+ a 1))))

(define (random-char)
  (let ((n (random-inclusive ##max-char)))
    (if (or (fx< n #xd800)
            (fx< #xdfff n))
        (integer->char n)
        (random-char))))

(define (random-sample n #!optional (l 4))
  (list->vector (map (lambda (i)
                       (random 1 l))
                     (iota n))))

(define (random-permutation n)
  (let ((result (make-vector n)))
    ;; fill it
    (do ((i 0 (fx+ i 1)))
        ((fx= i n))
      (vector-set! result i i))
    ;; permute it
    (do ((i 0 (fx+ i 1)))
        ((fx= i n) result)
      (let* ((index (random i n))
             (temp (vector-ref result index)))
        (vector-set! result index (vector-ref result i))
        (vector-set! result i temp)))))

(define (vector-permute v permutation)
  (let* ((n (vector-length v))
         (result (make-vector n)))
    (do ((i 0 (+ i 1)))
        ((= i n) result)
      (vector-set! result i (vector-ref v (vector-ref permutation i))))))

(define (filter p l)
  (cond ((null? l) l)
        ((p (car l))
         (cons (car l) (filter p (cdr l))))
        (else
         (filter p (cdr l)))))

(define (in-order < l)
  (or (null? l)
      (null? (cdr l))
      (and (< (car l) (cadr l))
           (in-order < (cdr l)))))

(define (foldl op id l)
  (if (null? l)
      id
      (foldl op (op id (car l)) (cdr l))))

(define (foldr op id l)
  (if (null? l)
      id
      (op (car l) (foldr op id (cdr l)))))

(define (indices->string  . l)
  (apply string-append (number->string (car l))
         (map (lambda (n) (string-append "_" (number->string n))) (cdr l))))

;; (include "generalized-arrays.scm")

(pp "Interval error tests")

(test (make-interval 1 '#(3 4))
      "make-interval: The first argument is not a vector of exact integers: ")

(test (make-interval '#(1 1)  3)
      "make-interval: The second argument is not a vector of exact integers: ")

(test (make-interval '#(1 1)  '#(3))
      "make-interval: The first and second arguments are not the same length: ")

(test (interval-volume (make-interval '#()  '#()))
      1)

(test (make-interval '#(1.)  '#(1))
      "make-interval: The first argument is not a vector of exact integers: ")

(test (make-interval '#(1 #f)  '#(1 2))
      "make-interval: The first argument is not a vector of exact integers: ")

(test (make-interval '#(1)  '#(1.))
      "make-interval: The second argument is not a vector of exact integers: ")

(test (make-interval '#(1 1)  '#(1 #f))
      "make-interval: The second argument is not a vector of exact integers: ")

(test (interval-volume (make-interval '#(1)  '#(1)))
      0)

(test (interval-volume (make-interval '#(1 2 3)  '#(4 2 6)))
      0)

(test (make-interval 1)
      "make-interval: The argument is not a vector of nonnegative exact integers: ")

(test (interval-volume (make-interval '#()))
      1)

(test (make-interval '#(1.))
      "make-interval: The argument is not a vector of nonnegative exact integers: ")

(test (make-interval '#(-1))
      "make-interval: The argument is not a vector of nonnegative exact integers: ")


(pp "interval result tests")

(test (make-interval '#(11111)  '#(11112))
      (make-interval '#(11111) '#(11112)))

(test (make-interval '#(1 2 3)  '#(4 5 6))
      (make-interval '#(1 2 3) '#(4 5 6)))

(pp "interval? result tests")

(test (interval? #t)
      #f)

(test (interval? (make-interval '#(1 2 3) '#(4 5 6)))
      #t)


(pp "interval-dimension error tests")

(test (interval-dimension 1)
      "interval-dimension: The argument is not an interval: ")

(pp "interval-dimension result tests")

(test (interval-dimension (make-interval '#(1 2 3) '#(4 5 6)))
      3)

(pp "interval-lower-bound error tests")

(test (interval-lower-bound 1 0)
      "interval-lower-bound: The first argument is not an interval: ")

(test (interval-lower-bound (make-interval '#(1 2 3) '#(4 5 6)) #f)
      "interval-lower-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-lower-bound (make-interval '#(1 2 3) '#(4 5 6)) 1.)
      "interval-lower-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-lower-bound (make-interval '#(1 2 3) '#(4 5 6)) -1)
      "interval-lower-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-lower-bound (make-interval '#(1 2 3) '#(4 5 6)) 3)
      "interval-lower-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-lower-bound (make-interval '#(1 2 3) '#(4 5 6)) 4)
      "interval-lower-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-lower-bound (make-interval '#()) 0)
      "interval-lower-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(pp "interval-upper-bound error tests")

(test (interval-upper-bound 1 0)
      "interval-upper-bound: The first argument is not an interval: ")

(test (interval-upper-bound (make-interval '#(1 2 3) '#(4 5 6)) #f)
      "interval-upper-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-upper-bound (make-interval '#(1 2 3) '#(4 5 6)) 1.)
      "interval-upper-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-upper-bound (make-interval '#(1 2 3) '#(4 5 6)) -1)
      "interval-upper-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-upper-bound (make-interval '#(1 2 3) '#(4 5 6)) 3)
      "interval-upper-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-upper-bound (make-interval '#(1 2 3) '#(4 5 6)) 4)
      "interval-upper-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(test (interval-upper-bound (make-interval '#()) 0)
      "interval-upper-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): ")

(pp "interval-lower-bounds->list error tests")

(test (interval-lower-bounds->list 1)
      "interval-lower-bounds->list: The argument is not an interval: ")

(test (interval-lower-bounds->list (make-interval '#()))
      '())

(pp "interval-upper-bounds->list error tests")

(test (interval-upper-bounds->list #f)
      "interval-upper-bounds->list: The argument is not an interval: ")

(test (interval-upper-bounds->list (make-interval '#()))
      '())

(pp "interval-lower-bounds->vector error tests")

(test (interval-lower-bounds->vector 1)
      "interval-lower-bounds->vector: The argument is not an interval: ")

(test (interval-lower-bounds->vector (make-interval '#()))
      '#())

(pp "interval-upper-bounds->vector error tests")

(test (interval-upper-bounds->vector #f)
      "interval-upper-bounds->vector: The argument is not an interval: ")

(test (interval-upper-bounds->vector (make-interval '#()))
      '#())

(pp "interval-width, interval-widths error tests")

(test (interval-width 1 0)
      "interval-width: The first argument is not an interval: ")

(test (interval-width (make-interval '#(1 2 3) '#(4 5 6)) #f)
      "interval-width: The second argument is not an exact integer between 0 (inclusive) and the dimension of the first argument (exclusive): ")

(test (interval-width (make-interval '#(1 2 3) '#(4 5 6)) 1.)
      "interval-width: The second argument is not an exact integer between 0 (inclusive) and the dimension of the first argument (exclusive): ")

(test (interval-width (make-interval '#(1 2 3) '#(4 5 6)) -1)
      "interval-width: The second argument is not an exact integer between 0 (inclusive) and the dimension of the first argument (exclusive): ")

(test (interval-width (make-interval '#(1 2 3) '#(4 5 6)) 3)
      "interval-width: The second argument is not an exact integer between 0 (inclusive) and the dimension of the first argument (exclusive): ")

(test (interval-width (make-interval '#(1 2 3) '#(4 5 6)) 4)
      "interval-width: The second argument is not an exact integer between 0 (inclusive) and the dimension of the first argument (exclusive): ")

(test (interval-widths 1)
      "interval-widths: The argument is not an interval: ")

(test (interval-widths (make-interval '#()))
      '#())

(test (interval-widths (make-interval '#(1 0)))
      '#(1 0))

(pp "interval-lower-bound, interval-upper-bound, interval-lower-bounds->list, interval-upper-bounds->list,")
(pp "interval-lower-bounds->vector, interval-upper-bounds->vector, interval-width, interval-widths result tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower (map (lambda (x) (random 10)) (vector->list (make-vector (random 1 11)))))
         (upper (map (lambda (x) (+ (random 11) x)) lower)))
    (let ((interval (make-interval (list->vector lower)
                                   (list->vector upper)))
          (offset (random (length lower))))
      (test (interval-lower-bound interval offset)
            (list-ref lower offset))
      (test (interval-upper-bound interval offset)
            (list-ref upper offset))
      (test (interval-lower-bounds->list interval)
            lower)
      (test (interval-upper-bounds->list interval)
            upper)
      (test (interval-lower-bounds->vector interval)
            (list->vector lower))
      (test (interval-upper-bounds->vector interval)
            (list->vector upper))
      (test (interval-width interval offset)
            (- (list-ref upper offset)
               (list-ref lower offset)))
      )))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower (map (lambda (x) (random 10)) (vector->list (make-vector (random 1 11)))))
         (upper (map (lambda (x) (+ (random 11) x)) lower)))
    (let ((interval (make-interval (list->vector lower)
                                   (list->vector upper))))
      (test (interval-widths interval)
            (vector-map -
                        (interval-upper-bounds->vector interval)
                        (interval-lower-bounds->vector interval))))))


(next-test-random-source-state!)


(pp "interval-projections error tests")

(test (interval-projections 1 1)
      "interval-projections: The first argument is not an interval: ")

(test (interval-projections (make-interval '#(0) '#(1)) #t)
      "interval-projections: The second argument is not an exact integer between 0 and the dimension of the first argument (inclusive): ")


(test (interval-projections (make-interval '#(0 0) '#(1 1)) 1/2)
      "interval-projections: The second argument is not an exact integer between 0 and the dimension of the first argument (inclusive): ")

(test (interval-projections (make-interval '#(0 0) '#(1 1)) 1.)
      "interval-projections: The second argument is not an exact integer between 0 and the dimension of the first argument (inclusive): ")

(test-multiple-values
 (interval-projections (make-interval '#(0 0) '#(1 1)) 0)
 (list (make-interval '#(1 1))
       (make-interval '#()) ))

(test-multiple-values
 (interval-projections (make-interval '#(0 0) '#(1 1)) 2)
 (list (make-interval '#())
       (make-interval '#(1 1))))

(pp "interval-projections result tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower (map (lambda (x) (random 10)) (vector->list (make-vector (random 3 11)))))
         (upper (map (lambda (x) (+ (random 1 11) x)) lower))
         (left-dimension (random 1 (- (length lower) 1)))
         (right-dimension (- (length lower) left-dimension)))
    (test-multiple-values
     (interval-projections (make-interval (list->vector lower)
                                          (list->vector upper))
                           right-dimension)
     (list (make-interval (list->vector (take lower left-dimension))
                          (list->vector (take upper left-dimension)))
           (make-interval (list->vector (drop lower left-dimension))
                          (list->vector (drop upper left-dimension)))))))

(next-test-random-source-state!)


(pp "interval-contains-multi-index? error tests")



(pp "interval-volume error tests")

(test (interval-volume #f)
      "interval-volume: The argument is not an interval: ")

(pp "interval-volume result tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower (map (lambda (x) (random 6)) (vector->list (make-vector (random 6)))))
         (upper (map (lambda (x) (+ (random 6) x)) lower)))
    (test (interval-volume (make-interval (list->vector lower)
                                          (list->vector upper)))
          (apply * (map - upper lower)))))

(next-test-random-source-state!)

(pp "interval= error tests")

(test (interval= #f (make-interval '#(1 2 3) '#(4 5 6)))
      "interval=: Not all arguments are intervals: ")

(test (interval= (make-interval '#(1 2 3) '#(4 5 6)) #f)
      "interval=: Not all arguments are intervals: ")

(pp "interval= result tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower1 (map (lambda (x) (random 2)) (vector->list (make-vector (random 4)))))
         (upper1 (map (lambda (x) (+ (random 3) x)) lower1))
         (lower2 (map (lambda (x) (random 2)) lower1))
         (upper2 (map (lambda (x) (+ (random 3) x)) lower2)))
    (test (interval= (make-interval (list->vector lower1)
                                    (list->vector upper1))
                     (make-interval (list->vector lower2)
                                    (list->vector upper2)))
          (and (equal? lower1 lower2)                              ;; the probability of this happening is about 1/16
               (equal? upper1 upper2)))))

(next-test-random-source-state!)

(pp "interval-subset? error tests")

(test (interval-subset? #f (make-interval '#(1 2 3) '#(4 5 6)))
      "interval-subset?: Not all arguments are intervals: ")

(test (interval-subset? (make-interval '#(1 2 3) '#(4 5 6)) #f)
      "interval-subset?: Not all arguments are intervals: ")

(test (interval-subset? (make-interval '#(1) '#(2))
                        (make-interval '#(0 0) '#(1 2)))
      "interval-subset?: The arguments do not have the same dimension: ")

(pp "interval-subset? result tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower1 (map (lambda (x) (random 2)) (vector->list (make-vector (random 6)))))
         (upper1 (map (lambda (x) (+ (random 3) x)) lower1))
         (lower2 (map (lambda (x) (random 2)) lower1))
         (upper2 (map (lambda (x) (+ (random 3) x)) lower2)))
    (test (interval-subset? (make-interval (list->vector lower1)
                                           (list->vector upper1))
                            (make-interval (list->vector lower2)
                                           (list->vector upper2)))
          (and (%%every (lambda (x) (>= (car x) (cdr x))) (map cons lower1 lower2))
               (%%every (lambda (x) (<= (car x) (cdr x))) (map cons upper1 upper2))))))

(next-test-random-source-state!)

(pp "interval-contains-multi-index?  error tests")

(test (interval-contains-multi-index? 1 1)
      "interval-contains-multi-index?: The first argument is not an interval: ")

(test (interval-contains-multi-index? (make-interval '#(1 2 3) '#(4 5 6)) 1)
      "interval-contains-multi-index?: The dimension of the first argument (an interval) does not match number of indices: ")

(test (interval-contains-multi-index? (make-interval '#(1 2 3) '#(4 5 6)) 1 1/2 0.1)
      "interval-contains-multi-index?: At least one multi-index component is not an exact integer: ")

(pp "interval-contains-multi-index?  result tests")

(let ((interval   (make-interval '#(1 2 3) '#(4 5 6)))
      (interval-2 (make-interval '#(10 11 12) '#(13 14 15))))
  (if (not (array-fold-left (lambda (result x)
                              (and result (apply interval-contains-multi-index? interval x)))
                            #t
                            (make-array interval list)))
      (error "these should all be true"))
  (if (not (array-fold-left (lambda (result x)
                              (and result (not (apply interval-contains-multi-index? interval x))))
                            #t
                            (make-array interval-2 list)))
      (error "these should all be false")))

(pp "interval-for-each error tests")

(test (interval-for-each (lambda (x) x) 1)
      "interval-for-each: The second argument is not a interval: ")

(test (interval-for-each 1 (make-interval '#(3) '#(4)))
      "interval-for-each: The first argument is not a procedure: ")

(define (local-iota a b)
  (if (= a b)
      '()
      (cons a (local-iota (+ a 1) b))))

(define (all-elements lower upper)
  (if (null? (cdr lower))
      (map list (local-iota (car lower) (car upper)))
      (apply append (map (lambda (x)
                           (map (lambda (y)
                                  (cons x y))
                                (all-elements (cdr lower) (cdr upper))))
                         (local-iota (car lower) (car upper))))))

(pp "interval-for-each result tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower (map (lambda (x) (random 10))
                     (vector->list (make-vector (random 1 7)))))
         (upper (map (lambda (x) (+ (random 1 4) x))
                     lower)))
    (let ((result '()))

      (define (f . args)
        (set! result (cons args result)))

      (test (let ()
              (interval-for-each f
                                 (make-interval (list->vector lower)
                                                (list->vector upper)))
              result)
            (reverse (all-elements lower upper))))))

(next-test-random-source-state!)

(pp "interval-fold-left and interval-fold-right error tests")

(test (interval-fold-left 1 2 3 4)
      "interval-fold-left: The fourth argument is not an interval: ")

(test (interval-fold-left 1 2 3 (make-interval '#(2 2)))
      "interval-fold-left: The second argument is not a procedure: ")

(test (interval-fold-left 1 values 3 (make-interval '#(2 2)))
      "interval-fold-left: The first argument is not a procedure: ")

(test (interval-fold-right 1 2 3 4)
      "interval-fold-right: The fourth argument is not an interval: ")

(test (interval-fold-right 1 2 3 (make-interval '#(2 2)))
      "interval-fold-right: The second argument is not a procedure: ")

(test (interval-fold-right 1 values 3 (make-interval '#(2 2)))
      "interval-fold-right: The first argument is not a procedure: ")

;;; We'll rely on tests for array-fold-{left|right} to test interval-fold-{left|right}

(pp "interval-dilate error tests")

(let ((interval (make-interval '#(0 0) '#(100 100))))
  (test (interval-dilate interval 'a '#(-10 10))
        "interval-dilate: The second argument is not a vector of exact integers: ")
  (test (interval-dilate 'a '#(10 10) '#(-10 -10))
        "interval-dilate: The first argument is not an interval: ")
  (test (interval-dilate interval '#(10 10) 'a)
        "interval-dilate: The third argument is not a vector of exact integers: ")
  (test (interval-dilate interval '#(10) '#(-10 -10))
        "interval-dilate: The second and third arguments must have the same length as the dimension of the first argument: ")
  (test (interval-dilate interval '#(10 10) '#( -10))
        "interval-dilate: The second and third arguments must have the same length as the dimension of the first argument: ")
  (test (interval-dilate interval '#(100 100) '#(-100 -100))
        "interval-dilate: Some resulting lower bounds are greater than corresponding upper bounds: "))



;;; define random-interval, random-multi-index

(define (random-multi-index interval)
  (apply values
         (apply map
                random
                (map (lambda (bounds)
                       (bounds interval))
                     (list interval-lower-bounds->list
                           interval-upper-bounds->list)))))

(define use-bignum-intervals #f)


(define (random-interval #!optional (min 0) (max 6))
  ;; a random interval with min <= dimension < max
  ;; positive and negative lower bounds
  (let* ((lower
          (map (lambda (x)
                 (if use-bignum-intervals
                     (random (- (expt 2 90)) (expt 2 90))
                     (random -10 10)))
               (iota (random min max))))
         (upper
          (map (lambda (x)
                 (+ (random 0 8) x))
               lower)))
    (make-interval (list->vector lower)
                   (list->vector upper))))

(define (random-nonempty-interval #!optional (min 0) (max 6))
  ;; a random interval with min <= dimension < max
  ;; positive and negative lower bounds
  (let* ((lower
          (map (lambda (x)
                 (if use-bignum-intervals
                     (random (- (expt 2 90)) (expt 2 90))
                     (random -10 10)))
               (vector->list (make-vector (random min max)))))
         (upper
          (map (lambda (x)
                 (+ (random 1 8) x))
               lower)))
    (make-interval (list->vector lower)
                   (list->vector upper))))

(define (random-subinterval interval)
  (let* ((lowers (interval-lower-bounds->vector interval))
         (uppers (interval-upper-bounds->vector interval))
         (new-lowers (vector-map random-inclusive lowers uppers))
         (new-uppers (vector-map random-inclusive new-lowers uppers))
         (subinterval (make-interval new-lowers new-uppers)))
    subinterval))


(define (random-nonnegative-interval #!optional (min 1) (max 6))
  ;; a random interval with min <= dimension < max
  ;; positive and negative lower bounds
  (let* ((lower
          (make-vector (random min max) 0))
         (upper
          (vector-map (lambda (x) (random 1 7)) lower)))
    (make-interval lower upper)))

(define (random-positive-vector n #!optional (max 5))
  (vector-map (lambda (x)
                (random 1 max))
              (make-vector n)))

(define (random-boolean)
  (zero? (random 2)))

(define (array-display A)

  (define (display-item x)
    (display x) (display "\t"))

  (newline)
  (case (array-dimension A)
    ((1) (array-for-each display-item A) (newline))
    ((2) (array-for-each (lambda (row)
                           (array-for-each display-item row)
                           (newline))
                         (array-curry A 1)))
    (else
     (error "array-display can't handle > 2 dimensions: " A))))

(pp "storage-class tests")

(define storage-class-names
  (list (list   u1-storage-class   'u1-storage-class 'u16vector make-u16vector)
        (list   u8-storage-class   'u8-storage-class  'u8vector  make-u8vector)
        (list  u16-storage-class  'u16-storage-class 'u16vector make-u16vector)
        (list  u32-storage-class  'u32-storage-class 'u32vector make-u32vector)
        (list  u64-storage-class  'u64-storage-class 'u64vector make-u64vector)
        (list   s8-storage-class   's8-storage-class  's8vector  make-s8vector)
        (list  s16-storage-class  's16-storage-class 's16vector make-s16vector)
        (list  s32-storage-class  's32-storage-class 's32vector make-s32vector)
        (list  s64-storage-class  's64-storage-class 's64vector make-s64vector)
        (list  f16-storage-class  'f16-storage-class 'u16vector make-u16vector)
        (list  f32-storage-class  'f32-storage-class 'f32vector make-f32vector)
        (list  f64-storage-class  'f64-storage-class 'f64vector make-f64vector)
        (list char-storage-class 'char-storage-class 'string    make-string)
        (list  c64-storage-class  'c64-storage-class 'f32vector make-f32vector)
        (list c128-storage-class 'c128-storage-class 'f64vector make-f64vector)
        (list generic-storage-class 'generic-storage-class 'vector make-vector)
        ))

(define uniform-storage-classes
  (list u8-storage-class u16-storage-class u32-storage-class u64-storage-class
        s8-storage-class s16-storage-class s32-storage-class s64-storage-class
        f16-storage-class f32-storage-class f64-storage-class
        char-storage-class
        c64-storage-class c128-storage-class))


(for-each (lambda (storage-class)
            (test ((storage-class-data? storage-class)
                   ((storage-class-maker storage-class)
                    8 (storage-class-default storage-class)))
                  #t))
          uniform-storage-classes)

(test ((storage-class-data? u1-storage-class) (u16vector 0))
      #t)

(for-each (lambda (class-name-data-maker)
            (let* ((class
                    (car class-name-data-maker))
                   (name
                    (cadr class-name-data-maker))
                   (data
                    (caddr class-name-data-maker))
                   (maker
                    (cadddr class-name-data-maker))
                   (message
                    (string-append "Expecting a "
                                   (symbol->string data)
                                   (if (memq class (list c64-storage-class c128-storage-class))
                                       " with an even number of elements passed to "
                                       " passed to ")
                                   "(storage-class-data->body "
                                   (symbol->string name)
                                   "): ")))
              (test ((storage-class-data->body class) 'a)
                    message)
              #;(test ((storage-class-data->body class) (maker 0))
                    message)
              ))
          storage-class-names)

(pp "array error tests")

(test (make-array 1 values)
      "make-array: The first argument is not an interval: ")

(test (make-array (make-interval '#(3) '#(4)) 1)
      "make-array: The second argument is not a procedure: ")

(test (make-array 1 values values)
      "make-array: The first argument is not an interval: ")

(test (make-array (make-interval '#(3) '#(4)) 1 values)
      "make-array: The second argument is not a procedure: ")

(test (make-array (make-interval '#(3) '#(4)) list 1)
      "make-array: The third argument is not a procedure: ")

(pp "array result tests")

(define (myarray= array1 array2 #!optional (compare equal?))
  (and (interval= (array-domain array1)
                  (array-domain array2))
       (array-every compare array1 array2)))

(let ((getter (lambda args 1.)))
  (test (myarray= (make-array (make-interval '#(3) '#(4)) getter)
                   (make-%%array (make-interval '#(3) '#(4))
                                 getter
                                 #f
                                 #f
                                 #f
                                 #f
                                 #f
                                 %%order-unknown))
        #t))

(pp "array-domain and array-getter error tests")

(test (array-domain #f)
      "array-domain: The argument is not an array: ")

(test (array-getter #f)
      "array-getter: The argument is not an array: ")

(pp "array?, array-domain, and array-getter result tests")

(let* ((getter (lambda args 1.))
       (domain (make-interval '#(3) '#(4)))
       (array  (make-array domain getter)))
  (test (array? #f)
        #f)
  (test (array? array)
        #t)
  (test (array-domain array)
        domain)
  (test (array-getter array)
        getter))


(pp "mutable-array result tests")

(let ((result #f))
  (let ((getter (lambda (i) result))
        (setter   (lambda (v i) (set! result v)))
        (domain   (make-interval '#(3) '#(4))))
    (test (make-array domain
                      getter
                      setter)
          (make-%%array domain
                             getter
                             setter
                             #f
                             #f
                             #f
                             #f
                             %%order-unknown))))

(pp "array-setter error tests")

(test (array-setter #f)
      "array-setter: The argument is not an mutable array: ")

(pp "mutable-array? and array-setter result tests")

(let ((result (cons #f #f)))
  (let ((getter (lambda (i) (car result)))
        (setter   (lambda (v i) (set-car! result v)))
        (domain   (make-interval '#(3) '#(4))))
    (let ((array (make-array domain
                             getter
                             setter)))
      (test (array? array)
            #t)
      (test (mutable-array? array)
            #t)
      (test (mutable-array? 1)
            #f)
      (test (array-setter array)
            setter)
      (test (array-getter array)
            getter)
      (test (array-domain array)
            domain))))

(pp "array-freeze! tests")

(test (array-freeze! 'a)
      "array-freeze!: The argument is not an array: ")

(let ((A (make-specialized-array (make-interval '#()))))
  (test (mutable-array? A)
        #t)
  (let ((B (array-freeze! A)))
    (test (mutable-array? B)
          #f)
    (test (eq? A B)
          #t))
  (test (mutable-array? A)
        #f))

(define (myindexer= indexer1 indexer2 interval)
  (array-fold-left (lambda (x y) (and x y))
                   #t
                   (make-array interval
                               (lambda args
                                 (= (apply indexer1 args)
                                    (apply indexer2 args))))))


(define (my-indexer base lower-bounds increments)
  (lambda indices
    (apply + base (map * increments (map - indices lower-bounds)))))



(pp "new-indexer result tests")

(define (random-sign)
  (- 1 (* 2 (random 2))))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((lower-bounds
          (map (lambda (x) (random 2))
               (vector->list (make-vector (random 1 7)))))
         (upper-bounds
          (map (lambda (x) (+ x (random 1 3)))
               lower-bounds))
         (new-domain
          (make-interval (list->vector lower-bounds)
                         (list->vector upper-bounds)))
         (new-domain-dimension
          (interval-dimension new-domain))
         (old-domain-dimension
          (random 1 7))
         (base
          (random 100))
         (coefficients
          (map (lambda (x) (* (random-sign)
                              (random 20)))
               (local-iota 0 old-domain-dimension)))
         (old-indexer
          (lambda args
            (apply + base (map * args coefficients))))
         (new-domain->old-domain-coefficients
          (map (lambda (x)
                 (map (lambda (x) (* (random-sign) (random 10)))
                      (local-iota 0 new-domain-dimension)))
               (local-iota 0 old-domain-dimension)))
         (new-domain->old-domain
          (lambda args
            (apply values (map (lambda (row)
                                 (apply + (map * row args)))
                               new-domain->old-domain-coefficients)))))
    (if (not (and (myindexer= (lambda args
                                (call-with-values
                                    (lambda () (apply new-domain->old-domain args))
                                  old-indexer))
                              (%%compose-indexers old-indexer new-domain  new-domain->old-domain)
                              new-domain)))
        (pp (list new-domain
                  old-domain-dimension
                  base
                  coefficients
                  new-domain->old-domain-coefficients)))))

(next-test-random-source-state!)

(pp "array body, indexer, storage-class, and safe? error tests")

(let ((a (make-array (make-interval '#(0 0) '#(1 1)) ;; not valid
                     values
                     values)))
  (test (array-body a)
        "array-body: The argument is not a specialized array: ")
  (test (array-indexer a)
        "array-indexer: The argument is not a specialized array: ")
  (test (array-storage-class a)
        "array-storage-class: The argument is not a specialized array: ")
  (test (array-safe? a)
        "array-safe?: The argument is not a specialized array: "))

(pp "make-specialized-array error tests")

(test (make-specialized-array  'a)
      "make-specialized-array: The first argument is not an interval: ")

(test (make-specialized-array (make-interval '#(0) '#(10)) 'a 1)
      "make-specialized-array: The second argument is not a storage-class: ")

(test (make-specialized-array (make-interval '#(0) '#(10)) u16-storage-class 'a)
      "make-specialized-array: The third argument cannot be manipulated by the second (a storage class): ")


(test (make-specialized-array (make-interval '#(0) '#(10)) generic-storage-class 'a 'a)
      "make-specialized-array: The fourth argument is not a boolean: ")

;;; let's test a few more

(test (array-every (lambda (x) (eqv? x 42)) (make-specialized-array (make-interval '#(10)) u8-storage-class 42))
      #t)

(test (array-safe? (make-specialized-array (make-interval '#(10)) u8-storage-class 42))
      (specialized-array-default-safe?))

(test (parameterize ((specialized-array-default-safe? #t)) (array-safe? (make-specialized-array (make-interval '#(10)) u8-storage-class 42)))
      #t)

(test (parameterize ((specialized-array-default-safe? #f)) (array-safe? (make-specialized-array (make-interval '#(10)) u8-storage-class 42)))
      #f)

(test (array-safe? (make-specialized-array (make-interval '#(10)) u8-storage-class 42  #t))
      #t)

(test (array-safe? (make-specialized-array (make-interval '#(10)) u8-storage-class 42 #f))
      #f)

(pp "make-specialized-array-from-data error tests")

(test (make-specialized-array-from-data 'a 'a 'a 'a)
      "make-specialized-array-from-data: The fourth argument is not a boolean: ")

(test (make-specialized-array-from-data 'a 'a 'a #t)
      "make-specialized-array-from-data: The third argument is not a boolean: ")

(test (make-specialized-array-from-data 'a 'a 'a)
      "make-specialized-array-from-data: The third argument is not a boolean: ")

(test (make-specialized-array-from-data 'a 'a #f #t)
      "make-specialized-array-from-data: The second argument is not a storage class: ")

(test (make-specialized-array-from-data 'a 'a #f)
      "make-specialized-array-from-data: The second argument is not a storage class: ")

(test (make-specialized-array-from-data 'a 'a)
      "make-specialized-array-from-data: The second argument is not a storage class: ")

(test (make-specialized-array-from-data 'a generic-storage-class #f #t)
      "make-specialized-array-from-data: The first argument is not compatible with the storage class: ")

(test (make-specialized-array-from-data 'a generic-storage-class #f)
      "make-specialized-array-from-data: The first argument is not compatible with the storage class: ")

(test (make-specialized-array-from-data 'a generic-storage-class)
      "make-specialized-array-from-data: The first argument is not compatible with the storage class: ")

(test (make-specialized-array-from-data 'a)
      "make-specialized-array-from-data: The first argument is not compatible with the storage class: ")

(let ((test-values
       (list ;;       storae-class   default other data
        (list generic-storage-class  #f 'a 1 #\c)
        (list    char-storage-class  '#\0 '#\a '#\b)
        (list      u1-storage-class  0 1)
        (list      u8-storage-class  0 23)
        (list     u16-storage-class  0 500)
        (list     u32-storage-class  0 70000)
        (list     u64-storage-class  0 100000000000)
        (list      s8-storage-class  0 -1 1)
        (list     s16-storage-class  0 -300 300)
        (list     s32-storage-class  0 -70000 70000)
        (list     s64-storage-class  0 -1000000000 1000000000)
        (list     f16-storage-class  0. 1.)
        (list     f32-storage-class  0. 1.)
        (list     f64-storage-class  0. 1.)
        (list     c64-storage-class  0.+0.i 1.+1.i)
        (list    c128-storage-class  0.+0.i 1.+1.i))))
  (for-each (lambda (data)
              (let ((storage-class (car data))
                    (default       (cadr data))
                    (other-values  (cddr data)))
                (test (array-every (lambda (v)
                                     (equal? v default))
                                   (make-specialized-array (make-interval '#(4 4)) storage-class))
                      #t)
                (for-each (lambda (val)
                            (test (array-every (lambda (v)
                                                 (equal? v val))
                                               (make-specialized-array (make-interval '#(4 4))
                                                                       storage-class
                                                                       val))
                                  #t))
                          other-values)))
            test-values))

(let ((test-values
       (list ;;       storae-class  good data           bad data
        (list generic-storage-class (make-vector 10)    (make-u16vector 10))
        (list    char-storage-class (make-string 10)    (make-u16vector 10))
        (list      u1-storage-class (make-u16vector 10) (make-u32vector 10))
        (list      u8-storage-class (make-u8vector 10)  (make-u16vector 10))
        (list     u16-storage-class (make-u16vector 10) (make-u32vector 10))
        (list     u32-storage-class (make-u32vector 10) (make-u16vector 10))
        (list     u64-storage-class (make-u64vector 10) (make-s16vector 10))
        (list      s8-storage-class (make-s8vector 10)  (make-u16vector 10))
        (list     s16-storage-class (make-s16vector 10) (make-u16vector 10))
        (list     s32-storage-class (make-s32vector 10) (make-u16vector 10))
        (list     s64-storage-class (make-s64vector 10) (make-u16vector 10))
        (list     f16-storage-class (make-u16vector 10) (make-s16vector 10))
        (list     f32-storage-class (make-f32vector 10) (make-u16vector 10))
        (list     f64-storage-class (make-f64vector 10) (make-u16vector 10))
        (list     c64-storage-class (make-f32vector 10) (make-u16vector 10) (make-f32vector 5))
        (list    c128-storage-class (make-f64vector 10) (make-u16vector 10) (make-f64vector 5)))))
  (for-each (lambda (data)
              (let ((storage-class (car data))
                    (good-data     (cadr data))
                    (rest          (cddr data)))
                (test (and (array? (make-specialized-array-from-data good-data storage-class))
                           (eq? ((storage-class-data? storage-class) good-data)
                                #t))
                      #t)
                (for-each (lambda (bad)
                            (test (make-specialized-array-from-data bad storage-class)
                                  "make-specialized-array-from-data: The first argument is not compatible with the storage class: "))
                          rest)))
            test-values))

#;(pretty-print
 (array->list*
  (specialized-array-reshape           ;; Reshape to a zero-dimensional array
   (array-extract                      ;; Restrict to the first element
    (make-specialized-array-from-data  ;; The basic one-dimensional array
     (vector 'foo 'bar 'baz))
    (make-interval '#(1)))
   (make-interval '#()))))

(let* ((board (u16vector #b111100110111))
       (A (specialized-array-reshape
           (array-extract
            (make-specialized-array-from-data board u1-storage-class)
            (make-interval '#(9)))
           (make-interval '#(3 3))))
       (B (list->array (make-interval '#(3 3))
                       '(1 1 1
                         0 1 1
                         0 0 1)
                       u1-storage-class)))
  (define (pad n s)
    (string-append (make-string (- n (string-length s)) #\0) s))

  (test (array-every = A B)
        #t)
  #|
  (for-each display (list "(array-every = A B) => " (array-every = A B) #\newline))
  (for-each display (list "(array-body A) => " (array-body A) #\newline))
  (for-each display (list "(array-body B) => " (array-body B) #\newline))
  (for-each display (list "(pad 16 (number->string (u16vector-ref (vector-ref (array-body A) 1) 0) 2)) => " #\newline
                          (pad 16 (number->string (u16vector-ref (vector-ref (array-body A) 1) 0) 2)) #\newline))
  (for-each display (list "(pad 16 (number->string (u16vector-ref (vector-ref (array-body B) 1) 0) 2)) => " #\newline
                          (pad 16 (number->string (u16vector-ref (vector-ref (array-body B) 1) 0) 2)) #\newline))
|#
  )

(pp "list*->array and vector*->array tests")

;;; Error tests

(for-each
 (lambda (operation message)

   (test (operation 1 2 3 4 5)
         (string-append message "The fifth argument is not a boolean: "))

   (test (operation 1 2 3 4 #t)
         (string-append message "The fourth argument is not a boolean: "))

   (test (operation 1 2 3 4)
         (string-append message "The fourth argument is not a boolean: "))

   (test (operation 1 2 3 #t #t)
         (string-append message "The third argument is not a storage class: "))

   (test (operation 1 2 3 #t)
         (string-append message "The third argument is not a storage class: "))

   (test (operation 1 2 3)
         (string-append message "The third argument is not a storage class: "))

   (test (operation 'a 1 generic-storage-class #t #f)
         (string-append message "The first argument is not a nonnegative fixnum: "))

   (test (operation -1 1 generic-storage-class #t #f)
         (string-append message "The first argument is not a nonnegative fixnum: "))

   (test (operation 'a 1 generic-storage-class #t)
         (string-append message "The first argument is not a nonnegative fixnum: "))

   (test (operation -1 1 generic-storage-class #t)
         (string-append message "The first argument is not a nonnegative fixnum: "))

   (test (operation 'a 1 generic-storage-class)
         (string-append message "The first argument is not a nonnegative fixnum: "))

   (test (operation -1 1 generic-storage-class)
         (string-append message "The first argument is not a nonnegative fixnum: "))

   (test (operation 'a 1)
         (string-append message "The first argument is not a nonnegative fixnum: "))

   (test (operation -1 1)
         (string-append message "The first argument is not a nonnegative fixnum: ")))
 (list list*->array
       vector*->array)
 (list "list*->array: "
       "vector*->array: "))

;;; Output tests

(test (array-every equal?
                   (list*->array 1 '((a b c) (1 2 3)))
                   (list->array (make-interval '#(2))
                                '((a b c) (1 2 3))))
      #t)

(test (array-every equal?
                   (list*->array 2 '((a b c) (1 2 3)))
                   (list->array (make-interval '#(2 3))
                                '(a b c 1 2 3)))
      #t)

(test (array-every equal?
                   (list*->array 3 '(((a b c) (1 2 3))))
                   (list->array (make-interval '#(1 2 3))
                                '(a b c 1 2 3)))
      #t)

(test (array-every equal?
                   (list*->array 2 '(((a b c) (1 2 3))))
                   (list->array (make-interval '#(1 2))
                                '((a b c) (1 2 3))))
      #t)

(test (list*->array 3 '(((a b c) (1 2))))
      (string-append "list*->array: " "The second argument is not the right shape to be converted to an array of the given dimension: "))

(test (array-every equal?
                   (list*->array 2 '(((a b c) (1 2))))
                   (list->array (make-interval '#(1 2))
                                '((a b c) (1 2))))
      #t)

(test (array-every equal?
                   (list*->array 0 '())
                   (make-array (make-interval '#()) (lambda () '())))
      #t)

(test (array-every equal?
                   (list*->array 1 '())
                   (make-array (make-interval '#(0)) (lambda () (error))))
      #t)

(test (array-every equal?
                   (list*->array 2 '())
                   (make-array (make-interval '#(0 0)) (lambda () (error))))
      #t)

(test (array-every equal?
                   (list*->array 2 '(()()))
                   (make-array (make-interval '#(2 0)) (lambda () (error))))
      #t)

(test (array-every equal?
                   (vector*->array 2 '#(#(a b c) #(1 2 3)))
                   (list->array (make-interval '#(2 3))
                                '(a b c 1 2 3)))
      #t)

(test (array-every equal?
                   (vector*->array 3 '#(#(#(a b c) #(1 2 3))))
                   (list->array (make-interval '#(1 2 3))
                                '(a b c 1 2 3)))
      #t)

(test (array-every equal?
                   (vector*->array 2 '#(#((a b c) (1 2 3))))
                   (list->array (make-interval '#(1 2))
                                '((a b c) (1 2 3))))
      #t)

(test (vector*->array 3 '#(#(#(a b c) #(1 2))))
      (string-append "vector*->array: " "The second argument is not the right shape to be converted to an array of the given dimension: "))

(test (array-every equal?
                   (vector*->array 2 '#(#((a b c) (1 2))))
                   (list->array(make-interval '#(1 2))
                               '((a b c) (1 2))))
      #t)

(test (array-every equal?
                   (vector*->array 0 '#())
                   (make-array (make-interval '#()) (lambda () '#())))
      #t)

(test (array-every equal?
                   (vector*->array 1 '#())
                   (make-array (make-interval '#(0)) (lambda () (error))))
      #t)

(test (array-every equal?
                   (vector*->array 2 '#())
                   (make-array (make-interval '#(0 0)) (lambda () (error))))
      #t)

(test (array-every equal?
                   (vector*->array 2 '#(#()#()))
                   (make-array (make-interval '#(2 0)) (lambda () (error))))
      #t)

(test (vector*->array 2 '#(#((a b c) (1 2))) u8-storage-class)
      "vector*->array: Not all elements of the source can be stored in destination: ")

(test (list*->array 2 '(((a b c) (1 2))) u8-storage-class)
      "list*->array: Not all elements of the source can be stored in destination: ")

(test (list*->array 0 'a u8-storage-class)
      "list*->array: Not all elements of the source can be stored in destination: ")

(test (vector*->array 0 'a u8-storage-class)
      "vector*->array: Not all elements of the source can be stored in destination: ")

(for-each (lambda (operation data)
            (for-each (lambda (mutable?)
                        (for-each (lambda (safe?)
                                    (parameterize
                                        ((specialized-array-default-mutable? mutable?)
                                         (specialized-array-default-safe? safe?))
                                      (let ((A (operation 2 data)))
                                        (test (mutable-array? A) mutable?)
                                        (test (array-safe? A) safe?))))
                                  '(#t #f)))
                      '(#t #f)))
          (list list*->array
                vector*->array)
          (list '(((a b c) (1 2)))
                '#(#((a b c) (1 2)))))

(pp "array->list* and array->vector*")

;;; Minimal tests, sorry.

(test (array->list* 'a)
      "array->list*: The argument is not an array: ")

(test (array->vector* 'a)
      "array->vector*: The argument is not an array: ")

(test (array->list* (make-array (make-interval '#(1 1)) indices->string))
      '(("0_0")))

(test (array->list* (make-array (make-interval '#(1)) indices->string))
      '("0"))

(test (array->list* (make-array (make-interval '#(2 3)) indices->string))
      '(("0_0" "0_1" "0_2") ("1_0" "1_1" "1_2")))

(test (array->list* (make-array (make-interval '#(1 1) '#(2 3)) indices->string))
      '(("1_1" "1_2")))

(test (array->vector* (make-array (make-interval '#(1 1)) indices->string))
      '#(#("0_0")))

(test (array->vector* (make-array (make-interval '#(1)) indices->string))
      '#("0"))

(test (array->vector* (make-array (make-interval '#(2 3)) indices->string))
      '#(#("0_0" "0_1" "0_2") #("1_0" "1_1" "1_2")))

(test (array->list* (make-array (make-interval '#(2 3)) indices->string))
      '(("0_0" "0_1" "0_2") ("1_0" "1_1" "1_2")))

(test (array->vector* (make-array (make-interval '#(1 1) '#(2 3)) indices->string))
      '#(#("1_1" "1_2")))

(test (array->vector* (list->array (make-interval '#(2 3))
                                   '(0 1 0
                                     0 1 1)
                                   u1-storage-class))
      '#(#(0 1 0) #(0 1 1)))

(test (array->list* (list->array (make-interval '#(2 3))
                                 '(0 1 0
                                   0 1 1)
                                  u1-storage-class))
      '((0 1 0) (0 1 1)))

(test (array->vector* (make-array (make-interval '#()) (lambda () 2)))
      2)

(test (array->vector* (make-array (make-interval '#(0)) error))
      '#())

(test (array->vector* (make-array (make-interval '#(2 0)) error))
      '#(#() #()))

(test (array->vector* (make-array (make-interval '#(0 0)) error))
      '#())

(test (array->vector* (make-array (make-interval '#(0 2)) error))
      '#())

(test (array->list* (make-array (make-interval '#()) (lambda () 2)))
      2)

(test (array->list* (make-array (make-interval '#(0)) error))
      '())

(test (array->list* (make-array (make-interval '#(2 0)) error))
      '(() ()))

(test (array->list* (make-array (make-interval '#(0 0)) error))
      '())

(test (array->list* (make-array (make-interval '#(0 2)) error))
      '())

(define random-storage-class-and-initializer
  (let* ((storage-classes
          (vector
           ;; generic
           (list generic-storage-class
                 (lambda args (random-permutation (length args))))
           ;; signed integer
           (list s8-storage-class
                 (lambda args (random (- (expt 2 7)) (- (expt 2 7) 1))))
           (list s16-storage-class
                 (lambda args (random (- (expt 2 15)) (- (expt 2 15) 1))))
           (list s32-storage-class
                 (lambda args (random (- (expt 2 31)) (- (expt 2 31) 1))))
           (list s64-storage-class
                 (lambda args (random (- (expt 2 63)) (- (expt 2 63) 1))))
           ;; unsigned integer
           (list u1-storage-class
                 (lambda args (random (expt 2 1))))
           (list u8-storage-class
                 (lambda args (random (expt 2 8))))
           (list u16-storage-class
                 (lambda args (random (expt 2 16))))
           (list u32-storage-class
                 (lambda args (random (expt 2 32))))
           (list u64-storage-class
                 (lambda args (random (expt 2 64))))
           ;; float
           (list f16-storage-class
                 (lambda args (test-random-real)))
           (list f32-storage-class
                 (lambda args (test-random-real)))
           (list f64-storage-class
                 (lambda args (test-random-real)))
           ;; char
           (list char-storage-class
                 (lambda args (random-char)))
           ;; complex-float
           (list c64-storage-class
                 (lambda args (make-rectangular (test-random-real) (test-random-real))))
           (list c128-storage-class
                 (lambda args (make-rectangular (test-random-real) (test-random-real))))))
         (n
          (vector-length storage-classes)))
    (lambda ()
      (vector-ref storage-classes (random n)))))

(pp "array-packed? tests")

;; We'll use specialized arrays with u1-storage-class---we never
;; use the array contents, just the indexers, and it saves storage.

(test (array-packed? 1)
      "array-packed?: The argument is not a specialized array: ")

(test (array-packed? (make-array (make-interval '#(1 2)) list))
      "array-packed?: The argument is not a specialized array: ")

(test (array-packed? (make-array (make-interval '#(1 2)) list list)) ;; not valid setter
      "array-packed?: The argument is not a specialized array: ")

;; all these are true, we'll have to see how to screw it up later.

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let ((array
         (make-specialized-array (random-interval)
                                 u1-storage-class)))
    (test (array-packed? array)
          #t)))

(next-test-random-source-state!)

;; the elements of curried arrays are in order

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((base
          (make-specialized-array (random-interval 2 5)
                                  u1-storage-class))
         (curried
          (array-curry base (random 1 (array-dimension base)))))
    (test (array-every array-packed? curried)
          #t)))

(next-test-random-source-state!)

;; Extracted arrays are in order if they are empty or have
;; dimension 0.
;; Elements of extracted arrays of newly created specialized
;; arrays are not in order unless
;; (1) the differences in the upper and lower bounds of the
;;     first dimensions all equal 1 *and*
;; (2) the next dimension doesn't matter *and*
;; (3) the upper and lower bounds of the latter dimensions
;;     of the original and extracted arrays are the same
;; Whew!

(define (extracted-array-packed? base extracted)
  (let ((base-domain (array-domain base))
        (extracted-domain (array-domain extracted))
        (dim (array-dimension base)))
    (or (interval-empty? extracted-domain)
        (eqv? dim 0)
        (let loop-1 ((i 0))
          (or (= i (- dim 1))
              (or (and (= 1 (- (interval-upper-bound extracted-domain i)
                               (interval-lower-bound extracted-domain i)))
                       (loop-1 (+ i 1)))
                  (let loop-2 ((i (+ i 1)))
                    (or (= i dim)
                        (and (= (interval-upper-bound extracted-domain i)
                                (interval-upper-bound base-domain i))
                             (= (interval-lower-bound extracted-domain i)
                                (interval-lower-bound base-domain i))
                             (loop-2 (+ i 1)))))))))))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((base
          (make-specialized-array (random-interval 0 6)
                                  u1-storage-class))
         (extracted
          (array-extract base (random-subinterval (array-domain base)))))
    (test (array-packed? extracted)
          (extracted-array-packed? base extracted))))

(next-test-random-source-state!)

;; Should we do reversed now?

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((base
          (make-specialized-array (random-interval)
                                  u1-storage-class))
         (domain
          (array-domain base))
         (reversed-dimensions
          (vector-map (lambda args (random-boolean))
                      (make-vector (array-dimension base))))
         (reversed
          (array-reverse base reversed-dimensions)))
    (test (array-packed? reversed)
          (or (array-empty? reversed)
              (%%vector-every
               (lambda (lower upper reversed)
                 (or (= (+ 1 lower) upper)  ;; side-length 1
                     (not reversed)))       ;; dimension not reversed
               (interval-lower-bounds->vector domain)
               (interval-upper-bounds->vector domain)
               reversed-dimensions)))))

(next-test-random-source-state!)

;; permutations

;; A permuted array has elements in order iff all the dimensions with
;; sidelength > 1 are in the same order, or if it's empty.

(define (permuted-array-packed? array permutation)
  (let* ((domain
          (array-domain array))
         (axes-and-limits
          (vector-map list
                      (list->vector (iota (vector-length permutation)))
                      (interval-lower-bounds->vector domain)
                      (interval-upper-bounds->vector domain)))
         (permuted-axes-and-limits
          (vector->list (vector-permute axes-and-limits permutation))))
    (or (interval-empty? domain)
        (in-order (lambda (x y)
                    (< (car x) (car y)))
                  (filter (lambda (l)
                            (let ((i (car l))
                                  (l (cadr l))
                                  (u (caddr l)))
                              (< 1 (- u l))))
                          permuted-axes-and-limits)))))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((base
          (make-specialized-array (random-interval)
                                  u1-storage-class))
         (domain
          (array-domain base))
         (permutation
          (random-permutation (array-dimension base)))
         (permuted
          (array-permute base permutation)))
    (test (array-packed? permuted)
          (permuted-array-packed? base permutation))))

(next-test-random-source-state!)

;; a sampled array has elements in order iff after a string of
;; dimensions with side-length 1 at the beginning, all the rest
;; of the dimensions have sidelengths the same as the original

(define (sampled-array-packed? base scales)
  (let* ((domain
          (array-domain base))
         (sampled-base
          (array-sample base scales))
         (scaled-domain
          (array-domain sampled-base))
         (base-sidelengths
          (vector->list
           (vector-map -
                       (interval-upper-bounds->vector domain)
                       (interval-lower-bounds->vector domain))))
         (scaled-sidelengths
          (vector->list
           (vector-map -
                       (interval-upper-bounds->vector scaled-domain)
                       (interval-lower-bounds->vector scaled-domain)))))
    (let loop-1 ((base-lengths   base-sidelengths)
                 (scaled-lengths scaled-sidelengths))
      (or (null? base-lengths)
          (if (= (car scaled-lengths) 1)
              (loop-1 (cdr base-lengths)
                      (cdr scaled-lengths))
              (let loop-2 ((base-lengths   base-lengths)
                           (scaled-lengths scaled-lengths))
                (or (null? base-lengths)
                    (and (= (car base-lengths) (car scaled-lengths))
                         (loop-2 (cdr base-lengths)
                                 (cdr scaled-lengths))))))))))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((base
          (make-specialized-array (random-nonnegative-interval 1 6)
                                   u1-storage-class))
         (scales
          (random-positive-vector (array-dimension base) 4))
         (sampled
          (array-sample base scales)))
    (test (array-packed? sampled)
          (sampled-array-packed? base scales))))

(next-test-random-source-state!)

;;; Now we need to test the precomputation and caching of array-packed?
;;; The only places we precompute are
;;; 1.  after creating a new specialized array
;;; 2.  in %%specialized-array-translate
;;; 3.  in %%specialized-array-curry
;;; 4.  reshaping a specialized array in place.
;;; So we need to check these situations.

(let ((array (array-copy (make-array (make-interval '#(3 5)) list))))
  (test (and (%%array-packed? array)
             (%%compute-array-packed? (%%array-domain array) (%%array-indexer array)))
        #t))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((array
          (make-specialized-array (random-nonnegative-interval) u8-storage-class))
         (ignore  ;; compute and cache the results
          (array-packed? array))
         (sampled-array
          (array-sample array (random-sample (array-dimension array))))
         (ignore  ;; compute and cache the results
          ;; possibly not in order
          (array-packed? sampled-array))
         (translated-array
          (array-translate array (vector-map (lambda (x) (random 10)) (make-vector (array-dimension array)))))
         (translated-sampled-array
          (array-translate sampled-array (vector-map (lambda (x) (random 10)) (make-vector (array-dimension array))))))
    (test (%%array-packed? translated-array)
          (%%compute-array-packed? (%%array-domain translated-array) (%%array-indexer translated-array)))
    (test (%%array-packed? translated-sampled-array)
          (%%compute-array-packed? (%%array-domain translated-sampled-array) (%%array-indexer translated-sampled-array)))))

(next-test-random-source-state!)

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((array
          (make-specialized-array (random-nonnegative-interval 2 4) u8-storage-class))
         (d-1
          (- (array-dimension array) 1))
         (ignore
          ;; compute and cache the result, in order
          (array-packed? array))
         (rotated-array
          (array-permute array (index-rotate (array-dimension array) 1)))
         (ignore  ;; compute and cache the results
          ;; possibly not in order
          (array-packed? rotated-array))
         (sampled-array
          (array-sample array (list->vector (cons 2 (make-list d-1 1)))))
         (ignore
          ;; almost definitely not in order,
          ;; but if we curry it with dimension 1 the subarrays are in order.
          (array-packed? sampled-array))
         (curried-array
          (array-ref (array-curry array d-1) (interval-lower-bound (array-domain array) 0)))
         (curried-rotated-array
          (array-ref (array-curry rotated-array d-1) (interval-lower-bound (array-domain rotated-array) 0)))
         (curried-sampled-array
          (array-ref (array-curry sampled-array d-1) (interval-lower-bound (array-domain sampled-array) 0))))
    (test (array-packed? curried-array)
          (%%compute-array-packed? (%%array-domain curried-array) (%%array-indexer curried-array)))
    (test (array-packed? curried-rotated-array)
          (%%compute-array-packed? (%%array-domain curried-rotated-array) (%%array-indexer curried-rotated-array)))
    (test (array-packed? curried-sampled-array)
          (%%compute-array-packed? (%%array-domain curried-sampled-array) (%%array-indexer curried-sampled-array)))))

(next-test-random-source-state!)

;;; FIXME: array-reshape tests.


(pp "%%move-array-elements tests")

;; error tests

(test (%%move-array-elements (array-reverse (make-specialized-array (make-interval '#(2 2))))
                             (make-array (make-interval '#(1 4)) list)
                             "")
      "Arrays must have the same domains: ")

(test (%%move-array-elements (make-specialized-array (make-interval '#(2 2)))
                             (make-array (make-interval '#(1 5)) list)
                             "")
      "Arrays must have the same domains: ")

(test (%%move-array-elements (make-array (make-interval '#(2 2)) list list) ;; not a valid setter
                             (make-array (make-interval '#(1 4)) list)
                             "")
      "Arrays must have the same domains: ")



(do ((d 1 (fx+ d 1)))
    ((= d 6))
  (let* ((uppers-list
          (iota d 2))
         (domain
          (make-interval (list->vector uppers-list))))
    (do ((i 0 (fx+ i 1)))
        ;; distribute "tests" results over five dimensions
        ((= i (quotient random-tests 5)))
      (let* ((storage-class-and-initializer
              (random-storage-class-and-initializer))
             (storage-class
              (car storage-class-and-initializer))
             (initializer
              (cadr storage-class-and-initializer))
             (specialized-source
              (array-copy
               (make-array domain
                           (lambda args
                             (initializer)))
               storage-class))
             (specialized-destination
              (make-specialized-array domain
                                      storage-class))
             (destination
              (make-array (array-domain specialized-destination)
                          (array-getter specialized-destination)
                          (array-setter specialized-destination))))
        ;; specialized-to-specialized, use fast copy
        (test (%%move-array-elements specialized-destination specialized-source "test: ")
              (if (not (storage-class-copier storage-class))
                  "In order, no checks needed"
                  "Block copy"))
        (test (myarray= specialized-source specialized-destination)
              #t)
        ;; copy to non-adjacent elements of destination, no checking needed
        (test (%%move-array-elements (array-reverse specialized-destination) specialized-source "test: ")
              (if (array-packed? (array-reverse specialized-destination))
                  "No checks needed"
                  "No checks needed"))
        (test (myarray= specialized-source (array-reverse specialized-destination))
              #t)
        ))))

(define extreme-values-alist
  (list
   (list u1-storage-class  0 (- (expt 2 1) 1))
   (list u8-storage-class  0 (- (expt 2 8) 1))
   (list u16-storage-class 0 (- (expt 2 16) 1))
   (list u32-storage-class 0 (- (expt 2 32) 1))
   (list u64-storage-class 0 (- (expt 2 64) 1))
   (list s8-storage-class  (- (expt 2 (- 8 1)))  (- (expt 2 (- 8 1)) 1))
   (list s16-storage-class (- (expt 2 (- 16 1))) (- (expt 2 (- 16 1)) 1))
   (list s32-storage-class (- (expt 2 (- 32 1))) (- (expt 2 (- 32 1)) 1))
   (list s64-storage-class (- (expt 2 (- 64 1))) (- (expt 2 (- 64 1)) 1))
   (list generic-storage-class    'a)
   (list f16-storage-class       1.0)
   (list f32-storage-class       1.0)
   (list f64-storage-class       1.0)
   (list char-storage-class (integer->char ##max-char))
   (list c64-storage-class  1.0+1.0i)
   (list c128-storage-class 1.0+1.0i)))

(next-test-random-source-state!)

(do ((d 1 (fx+ d 1)))
    ((= d 6))
  (let* ((uppers-list
          (iota d 2))
         (domain
          (make-interval (list->vector uppers-list)))
         (reversed-domain
          (make-interval (list->vector (reverse uppers-list)))))
    (do ((i 0 (fx+ i 1)))
        ;; distribute "tests" results over five dimensions
        ((= i (quotient random-tests 5)))
      (let* ((destination-storage-class-and-initializer
              (random-storage-class-and-initializer))
             (destination-storage-class
              (car destination-storage-class-and-initializer))
             (destination-initializer
              (cadr destination-storage-class-and-initializer))
             (source-storage-class-and-initializer
              (random-storage-class-and-initializer))
             (source-storage-class
              (car source-storage-class-and-initializer))
             (source-initializer
              (cadr source-storage-class-and-initializer))
             (source
              (array-copy (make-array domain
                                      source-initializer)
                          source-storage-class))
             (generalized-source
              (make-array (array-domain source)
                          (array-getter source)))
             (destination
              (make-specialized-array domain
                                      destination-storage-class))
             (generalized-destination
              (make-array (array-domain destination)
                          (array-getter destination)
                          (array-setter destination)))
             (destination
              (if (zero? (random 2))
                  (array-reverse destination)
                  destination))
             (destination-checker
              (storage-class-checker destination-storage-class))
             (sloppy-compare
              (lambda (x y)      ;; loss of precision in conversion to smaller float format
                (< (magnitude (- x y)) 1e-3))))
        (if (array-every destination-checker source)
            (begin
              (test (let ((%%move-result
                           (%%move-array-elements destination source "test: ")))
                      (and (equal? (if (array-packed? destination)
                                       (cond ((and (eq? destination-storage-class source-storage-class)
                                                   (storage-class-copier destination-storage-class))
                                              "Block copy")
                                             ((eq? destination-storage-class generic-storage-class)
                                              "In order, no checks needed, generic-storage-class")
                                             ((%%every destination-checker (cdr (assq source-storage-class extreme-values-alist)))
                                              "In order, no checks needed")
                                             (else
                                              "In order, checks needed"))
                                       (cond ((%%every destination-checker (cdr (assq source-storage-class extreme-values-alist)))
                                              "No checks needed")
                                             (else
                                              "Checks needed")))
                                   %%move-result)
                           (myarray= destination
                                     source
                                     (if (or (and (eq? source-storage-class c128-storage-class)
                                                  (eq? destination-storage-class c64-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f32-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f16-storage-class))
                                             (and (eq? source-storage-class f32-storage-class)
                                                  (eq? destination-storage-class f16-storage-class)))
                                         sloppy-compare
                                         equal?))))
                    #t)
              (test (let ((%%move-result
                           (%%move-array-elements generalized-destination source "test: ")))
                      (and (equal? "Destination not specialized array"
                                   %%move-result)
                           (myarray= generalized-destination
                                     source
                                     (if (or (and (eq? source-storage-class c128-storage-class)
                                                  (eq? destination-storage-class c64-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f32-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f16-storage-class))
                                             (and (eq? source-storage-class f32-storage-class)
                                                  (eq? destination-storage-class f16-storage-class)))
                                         sloppy-compare
                                         equal?))))
                    #t)
              (test (let ((ignore (array-assign! destination generalized-source)))
                      (myarray= destination
                                generalized-source
                                (if (or (and (eq? source-storage-class c128-storage-class)
                                                  (eq? destination-storage-class c64-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f32-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f16-storage-class))
                                             (and (eq? source-storage-class f32-storage-class)
                                                  (eq? destination-storage-class f16-storage-class)))
                                    sloppy-compare
                                    equal?)))
                    #t)
              (test (let ((ignore (array-assign! generalized-destination generalized-source)))
                      (myarray= generalized-destination
                                 generalized-source
                                 (if (or (and (eq? source-storage-class c128-storage-class)
                                                  (eq? destination-storage-class c64-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f32-storage-class))
                                             (and (eq? source-storage-class f64-storage-class)
                                                  (eq? destination-storage-class f16-storage-class))
                                             (and (eq? source-storage-class f32-storage-class)
                                                  (eq? destination-storage-class f16-storage-class)))
                                     sloppy-compare
                                     equal?)))
                     #t))
            (test (array-assign! destination source)
                  "array-assign!: Not all elements of the source can be stored in destination: "))))))

(next-test-random-source-state!)

(pp "array-copy and array-copy! error tests")

(for-each (lambda (call/cc-safe?)
            (let* ((array-copy (if call/cc-safe?
                                   array-copy
                                   array-copy!))
                   (message    (if call/cc-safe?
                                   "array-copy: "
                                   "array-copy!: ")))

              (define (wrap error-reason)
                (string-append message error-reason))

              (test (array-copy (make-array (make-interval '#(4)) list) u8-storage-class #t 'a)
                    (wrap "The fourth argument is not a boolean: "))

              (test (array-copy (make-array (make-interval '#(4)) list) u8-storage-class 'a #t)
                    (wrap "The third argument is not a boolean: "))

              (test (array-copy (make-array (make-interval '#(4)) list) 'u8-storage-class #t #t)
                    (wrap "The second argument is not a storage-class: "))

              (test (array-copy 'a)
                    (wrap "The first argument is not an array: "))

              (test (array-copy #f generic-storage-class)
                    (wrap "The first argument is not an array: "))

              (test (array-copy (make-array (make-interval '#(1) '#(2))
                                            list)
                                #f)
                    (wrap "The second argument is not a storage-class: "))

              (test (array-copy (make-array (make-interval '#(1) '#(2))
                                            list)
                                generic-storage-class
                                'a)
                    (wrap "The third argument is not a boolean: "))


              (test (array-copy (make-array (make-interval '#(1) '#(2))
                                            list)
                                generic-storage-class
                                #f
                                'a)
                    (wrap "The fourth argument is not a boolean: "))

              ;; Check that explicit setting of mutable? and safe? work


              (test (mutable-array? (array-copy (list->array (make-interval '#(2 2))
                                                             '(1 2 3 4)
                                                             generic-storage-class
                                                             #f)))
                    #f)

              (test (mutable-array? (array-copy (list->array (make-interval '#(2 2))
                                                             '(1 2 3 4)
                                                             generic-storage-class
                                                             #f)
                                                generic-storage-class
                                                #t))
                    #t)


              (test (array-safe? (array-copy (list->array (make-interval '#(2 2))
                                                          '(1 2 3 4)
                                                          generic-storage-class
                                                          #f
                                                          #f)))
                    #f)

              (test (array-safe? (array-copy (list->array (make-interval '#(2 2))
                                                          '(1 2 3 4)
                                                          generic-storage-class
                                                          #f
                                                          #f)
                                             generic-storage-class
                                             #t
                                             #t))
                    #t)

              ;; Check that defaults of mutable? and safe? work

              (parameterize
                  ((specialized-array-default-mutable? #t))
                (test (mutable-array? (array-copy (list->array (make-interval '#(2 2))
                                                               '(1 2 3 4)
                                                               generic-storage-class
                                                               #t)))
                      #t)

                (test (mutable-array? (array-copy (list->array (make-interval '#(2 2))
                                                               '(1 2 3 4)
                                                               generic-storage-class
                                                               #t)
                                                  generic-storage-class
                                                  #f))
                      #f)
                (test (mutable-array? (array-copy (make-array (make-interval '#(2 2)) list)))
                      #t)

                (test (mutable-array? (array-copy (make-array (make-interval '#(2 2)) list)
                                                  generic-storage-class
                                                  #f))
                      #f))

              (parameterize
                  ((specialized-array-default-mutable? #f))
                (test (array-safe? (array-copy (list->array (make-interval '#(2 2))
                                                            '(1 2 3 4)
                                                            generic-storage-class
                                                            #t
                                                            #t)))
                      #t)

                (test (array-safe? (array-copy (list->array (make-interval '#(2 2))
                                                            '(1 2 3 4)
                                                            generic-storage-class
                                                            #t
                                                            #t)
                                               generic-storage-class
                                               #f
                                               #f))
                      #f)

                (test (mutable-array? (array-copy (make-array (make-interval '#(2 2)) list)))
                      #f)

                (test (mutable-array? (array-copy (make-array (make-interval '#(2 2)) list)
                                                  generic-storage-class
                                                  #t))
                      #t))

              (parameterize
                  ((specialized-array-default-safe? #t))
                (test (mutable-array? (array-copy (list->array (make-interval '#(2 2))
                                                               '(1 2 3 4)
                                                               generic-storage-class
                                                               #f)))
                      #f)

                (test (mutable-array? (array-copy (list->array (make-interval '#(2 2))
                                                               '(1 2 3 4)
                                                               generic-storage-class
                                                               #f)
                                                  generic-storage-class
                                                  #t))
                      #t)
                (test (array-safe? (array-copy (make-array (make-interval '#(2 2)) list)))
                      #t)

                (test (array-safe? (array-copy (make-array (make-interval '#(2 2)) list)
                                               generic-storage-class
                                               #f
                                               #f))
                      #f))

              (parameterize
                  ((specialized-array-default-safe? #f))
                (test (array-safe? (array-copy (list->array (make-interval '#(2 2))
                                                            '(1 2 3 4)
                                                            generic-storage-class
                                                            #f
                                                            #f)))
                      #f)

                (test (array-safe? (array-copy (list->array (make-interval '#(2 2))
                                                            '(1 2 3 4)
                                                            generic-storage-class
                                                            #f
                                                            #f)
                                               generic-storage-class
                                               #t
                                               #t))
                      #t)

                (test (array-safe? (array-copy (make-array (make-interval '#(2 2)) list)))
                      #f)

                (test (array-safe? (array-copy (make-array (make-interval '#(2 2)) list)
                                               generic-storage-class
                                               #t
                                               #t))
                      #t))



              ;; We gotta make sure than the error checks work in all dimensions ...

              (test (array-copy (make-array (make-interval '#(1) '#(2))
                                            list)
                                u16-storage-class)
                    (wrap "Not all elements of the source can be stored in destination: "))

              (test (array-copy (make-array (make-interval '#(1 1) '#(2 2))
                                            list)
                                u16-storage-class)
                    (wrap "Not all elements of the source can be stored in destination: "))

              (test (array-copy (make-array (make-interval '#(1 1 1) '#(2 2 2))
                                            list)
                                u16-storage-class)
                    (wrap "Not all elements of the source can be stored in destination: "))

              (test (array-copy (make-array (make-interval '#(1 1 1 1) '#(2 2 2 2))
                                            list)
                                u16-storage-class)
                    (wrap "Not all elements of the source can be stored in destination: "))

              (test (array-copy (make-array (make-interval '#(1 1 1 1 1) '#(2 2 2 2 2))
                                            list)
                                u16-storage-class)
                    (wrap "Not all elements of the source can be stored in destination: "))
              ))
          '(#t #f))

(test (specialized-array-default-safe? 'a)
      "specialized-array-default-safe?: The argument is not a boolean: ")

(test (specialized-array-default-mutable? 'a)
      "specialized-array-default-mutable?: The argument is not a boolean: ")

(let ((mutable-default (specialized-array-default-mutable?)))
  (specialized-array-default-mutable? #f)
  (do ((i 1 (+ i 1)))
      ((= i 6))
    (let ((A (array-copy (make-array (make-interval (make-vector i 2)) (lambda args 10)))))
      (test (apply array-set! A 0 (make-list i 0))
            "array-set!: The first argument is not a mutable array: ")
      (test (array-assign! A A)
            "array-assign!: The destination is not a mutable array: ")))
  (specialized-array-default-mutable? mutable-default))


(pp "array-copy result tests")

(specialized-array-default-safe? #t)

(pp "Safe tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((domain
          (random-interval))
         (lower-bounds
          (interval-lower-bounds->list domain))
         (upper-bounds
          (interval-upper-bounds->list domain))
         (array1
          (let ((alist '()))
            (make-array
             domain
             (lambda indices
               (cond ((assoc indices alist)
                      => cdr)
                     (else
                      indices)))
             (lambda (value . indices)
               (cond ((assoc indices alist)
                      =>(lambda (entry)
                          (set-cdr! entry value)))
                     (else
                      (set! alist (cons (cons indices value)
                                        alist))))))))
         (array2
          (array-copy array1 generic-storage-class))
         (array2!
          (array-copy! array1 generic-storage-class))
         (setter1
          (array-setter array1))
         (setter2
          (array-setter array2))
         (setter2!
          (array-setter array2!)))
    (if (not (array-empty? array1))
        (do ((j 0 (+ j 1)))
            ((= j 25))
          (let ((v (random 1000))
                (indices (map random lower-bounds upper-bounds)))
            (apply setter1 v indices)
            (apply setter2 v indices)
            (apply setter2! v indices))))
    (test (myarray= array1 array2) #t)
    (test (myarray= array1 array2!) #t)
    (test (myarray= (array-copy array1 generic-storage-class) array2) #t)
    (test (myarray= (array-copy array1 generic-storage-class) array2!) #t)))

(next-test-random-source-state!)

(specialized-array-default-safe? #f)

(pp "Unsafe tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((domain
          (random-interval))
         (lower-bounds
          (interval-lower-bounds->list domain))
         (upper-bounds
          (interval-upper-bounds->list domain))
         (array1
          (let ((alist '()))
            (make-array
             domain
             (lambda indices
               (cond ((assoc indices alist)
                      => cdr)
                     (else
                      indices)))
             (lambda (value . indices)
               (cond ((assoc indices alist)
                      =>(lambda (entry)
                          (set-cdr! entry value)))
                     (else
                      (set! alist (cons (cons indices value)
                                        alist))))))))
         (array2
          (array-copy array1 generic-storage-class))
         (array2!
          (array-copy! array1 generic-storage-class))
         (setter1
          (array-setter array1))
         (setter2
          (array-setter array2))
         (setter2!
          (array-setter array2!)))
    (if (not (array-empty? array1))
        (do ((j 0 (+ j 1)))
            ((= j 25))
          (let ((v (random 1000))
                (indices (map random lower-bounds upper-bounds)))
            (apply setter1 v indices)
            (apply setter2 v indices)
            (apply setter2! v indices))))
    (test (myarray= array1 array2) #t)
    (test (myarray= array1 array2!) #t)
    (test (myarray= (array-copy array1 generic-storage-class) array2) #t)
    (test (myarray= (array-copy array1 generic-storage-class) array2!) #t)))

(next-test-random-source-state!)

(pp "array-map error tests")

(test (array-map 1 #f)
      "array-map: The first argument is not a procedure: ")

(test (array-map list 1 (make-array (make-interval '#(3) '#(4))
                                    list))
      "array-map: Not all arguments after the first are arrays: ")

(test (array-map list (make-array (make-interval '#(3) '#(4))
                                  list) 1)
      "array-map: Not all arguments after the first are arrays: ")

(test (array-map list
                 (make-array (make-interval '#(3) '#(4))
                             list)
                 (make-array (make-interval '#(3 4) '#(4 5))
                             list))
      "array-map: Not all arrays have the same domain: ")

(pp "array-every and array-any error tests")

(test (array-every 1 2)
      "array-every: The first argument is not a procedure: ")

(test (array-every list 1)
      "array-every: Not all arguments after the first are arrays: ")

(test (array-every list
                   (make-array (make-interval '#(3) '#(4))
                               list)
                   1)
      "array-every: Not all arguments after the first are arrays: ")

(test (array-every list
                   (make-array (make-interval '#(3) '#(4))
                               list)
                   (make-array (make-interval '#(3 4) '#(4 5))
                               list))
      "array-every: Not all arrays have the same domain: ")

(test (array-any 1 2)
      "array-any: The first argument is not a procedure: ")

(test (array-any list 1)
      "array-any: Not all arguments after the first are arrays: ")

(test (array-any list
                 (make-array (make-interval '#(3) '#(4))
                             list)
                 1)
      "array-any: Not all arguments after the first are arrays: ")

(test (array-any list
                 (make-array (make-interval '#(3) '#(4))
                             list)
                 (make-array (make-interval '#(3 4) '#(4 5))
                             list))
      "array-any: Not all arrays have the same domain: ")

(pp "array-every and array-any")

(define (multi-index< ind1 ind2)
  (and (not (null? ind1))
       (not (null? ind2))
       (or (< (car ind1)
              (car ind2))
           (and (= (car ind1)
                   (car ind2))
                (multi-index< (cdr ind1)
                              (cdr ind2))))))

(define (indices-in-proper-order l)
  (or (null? l)
      (null? (cdr l))
      (and (multi-index< (car l)
                         (cadr l))
           (indices-in-proper-order (cdr l)))))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((interval
          (random-nonnegative-interval 1 6))
         (n
          (interval-volume interval))
         (separator
          ;; I want to make sure that the last item is chosen at least
          ;; once for each random
          (random (max 0 (- n 10)) n))
         (indexer
          (%%interval->basic-indexer interval))
         (arguments-1
          '())
         (array-1
          (make-array interval
                      (lambda args
                        (set! arguments-1 (cons args
                                                arguments-1))
                        (let ((index (apply indexer args)))
                          (cond ((< index separator)
                                 #f)
                                ((= index separator)
                                 1)
                                (else
                                 (error "The array should never be called with these args"
                                        interval
                                        separator
                                        args
                                        index)))))))
         (arguments-2
          '())
         (array-2
          (make-array interval
                      (lambda args
                        (set! arguments-2 (cons args
                                                arguments-2))
                        (let ((index (apply indexer args)))
                          (cond ((< index separator)
                                 #t)
                                ((= index separator)
                                 #f)
                                (else
                                 (error "The array should never be called with these args"
                                        interval
                                        separator
                                        args
                                        index))))))))
    (test (array-any values array-1)
          1)
    (test (array-every values array-2)
          #f)
    (if (not (indices-in-proper-order (reverse arguments-1)))
        (error "arrghh arguments-1" arguments-1))
    (if (not (indices-in-proper-order (reverse arguments-2)))
        (error "arrghh arguments-2" arguments-2))))

(next-test-random-source-state!)




(pp "array-fold-left, array-fold-right error tests")

(test (array-fold-left 1 1 1)
      "array-fold-left: The first argument is not a procedure: ")

(test (array-fold-left list 1 1)
      "array-fold-left: Not all arguments after the first two are arrays: ")

(test (array-fold-left list 1 (make-array (make-interval '#()) list) 1)
      "array-fold-left: Not all arguments after the first two are arrays: ")

(test (array-fold-left list 1 (make-array (make-interval '#()) list) (make-array (make-interval '#(1)) list))
      "array-fold-left: Not all arrays have the same domain: ")

(test (array-fold-left cons '() (make-array (make-interval '#()) (lambda () 42)))
      '(() . 42))

(test (array-fold-right cons 42 (make-array (make-interval '#(0)) error))
      42)

(test (array-fold-right 1 1 1)
      "array-fold-right: The first argument is not a procedure: ")

(test (array-fold-right list 1 1)
      "array-fold-right: Not all arguments after the first two are arrays: ")

(test (array-fold-right list 1 (make-array (make-interval '#()) list) 1)
      "array-fold-right: Not all arguments after the first two are arrays: ")

(test (array-fold-right list 1 (make-array (make-interval '#()) list) (make-array (make-interval '#(1)) list))
      "array-fold-right: Not all arrays have the same domain: ")

(test (array-fold-right cons '() (make-array (make-interval '#()) (lambda () 42)))
      '(42))

(test (array-fold-right cons 42 (make-array (make-interval '#(0)) error))
      42)

(pp "array-for-each error tests")

(test (array-for-each 1 #f)
      "array-for-each: The first argument is not a procedure: ")

(test (array-for-each list 1 (make-array (make-interval '#(3) '#(4))
                                         list))
      "array-for-each: Not all arguments after the first are arrays: ")

(test (array-for-each list (make-array (make-interval '#(3) '#(4))
                                       list) 1)
      "array-for-each: Not all arguments after the first are arrays: ")

(test (array-for-each list
                      (make-array (make-interval '#(3) '#(4))
                                  list)
                      (make-array (make-interval '#(3 4) '#(4 5))
                                  list))
      "array-for-each: Not all arrays have the same domain: ")

(pp "array-map, array-fold-right, and array-for-each result tests")

(let ((list-of-60 (iota 60)))
  (for-each (lambda (divisor)   ;; 1 through 5
              ;; Break up list-of-60 into equivalence classes modulo divisor
              ;; Convert these to arrays.
              ;; Do a simple test on array-fold-left and array-fold-right with cons and '()
              (let* ((specialized-parts
                      (map (lambda (remainder)
                             (list*->array
                              1
                              (filter (lambda (j)
                                        (eqv? (modulo j divisor) remainder))
                                      list-of-60)))
                           (iota divisor)))
                     (generalized-parts
                      (map (lambda (a)
                             (make-array (array-domain a)
                                         (array-getter a)))
                           specialized-parts)))
                (test (apply array-fold-left
                             (lambda (id . lst)
                               (foldl cons id lst))
                             '()
                             specialized-parts)
                      (foldl cons '() list-of-60))
                (test (apply array-fold-right
                             (lambda args
                               (foldr cons (list-ref args divisor) (take args divisor)))
                             '()
                             specialized-parts)
                      (foldr cons '() list-of-60))
                (test (apply array-fold-left
                             (lambda (id . lst)
                               (foldl cons id lst))
                             '()
                             generalized-parts)
                      (foldl cons '() list-of-60))
                (test (apply array-fold-right
                             (lambda args
                               (foldr cons (list-ref args divisor) (take args divisor)))
                             '()
                             generalized-parts)
                      (foldr cons '() list-of-60))
                ))
            (iota 6 1)))




(specialized-array-default-safe? #t)

(let ((array-builders (vector (list u1-storage-class      (lambda indices (random 0 (expt 2 1))))
                              (list u8-storage-class      (lambda indices (random 0 (expt 2 8))))
                              (list u16-storage-class     (lambda indices (random 0 (expt 2 16))))
                              (list u32-storage-class     (lambda indices (random 0 (expt 2 32))))
                              (list u64-storage-class     (lambda indices (random 0 (expt 2 64))))
                              (list s8-storage-class      (lambda indices (random (- (expt 2 7))  (expt 2 7))))
                              (list s16-storage-class     (lambda indices (random (- (expt 2 15)) (expt 2 15))))
                              (list s32-storage-class     (lambda indices (random (- (expt 2 31)) (expt 2 31))))
                              (list s64-storage-class     (lambda indices (random (- (expt 2 63)) (expt 2 63))))
                              (list f16-storage-class     (lambda indices (test-random-real)))
                              (list f32-storage-class     (lambda indices (test-random-real)))
                              (list f64-storage-class     (lambda indices (test-random-real)))
                              (list char-storage-class    (lambda indices (random-char)))
                              (list c64-storage-class     (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list c128-storage-class    (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list generic-storage-class (lambda indices indices)))))
  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain
            (random-interval))
           (lower-bounds
            (interval-lower-bounds->list domain))
           (upper-bounds
            (interval-upper-bounds->list domain))
           (array-length
            (lambda (a)
              (let ((upper-bounds (interval-upper-bounds->list (array-domain a)))
                    (lower-bounds (interval-lower-bounds->list (array-domain a))))
                (apply * (map - upper-bounds lower-bounds)))))
           (arrays
            (map (lambda (ignore)
                   (let ((array-builder (vector-ref array-builders (random (vector-length array-builders)))))
                     (array-copy (make-array domain
                                             (cadr array-builder))
                                 (car array-builder))))
                 (local-iota 0 (random 1 7))))
           (result-array-1
            (apply array-map
                   list
                   arrays))
           (result-array-2
            (array-copy
             (apply array-map
                    list
                    arrays)))
           (getters
            (map array-getter arrays))
           (result-array-3
            (make-array domain
                        (lambda indices
                          (map (lambda (g) (apply g indices)) getters)))))
      (test (myarray= result-array-1 result-array-2)
            #t)
      (test (myarray= result-array-2 result-array-3)
            #t)
      (test (vector->list (array-body result-array-2))
            (array-fold-right (lambda (x y) (cons x y))
                              '()
                              result-array-2))
      (test (vector->list (array-body result-array-2))
            (reverse (let ((result '()))
                       (array-for-each (lambda (f)
                                         (set! result (cons f result)))
                                       result-array-2)
                       result)))
      (test  (map array-length arrays)
             (map (lambda (array)
                    ((storage-class-length (array-storage-class array)) (array-body array)))
                  arrays)))))

(next-test-random-source-state!)

(specialized-array-default-safe? #f)

(let ((array-builders (vector (list u1-storage-class      (lambda indices (random (expt 2 1))))
                              (list u8-storage-class      (lambda indices (random (expt 2 8))))
                              (list u16-storage-class     (lambda indices (random (expt 2 16))))
                              (list u32-storage-class     (lambda indices (random (expt 2 32))))
                              (list u64-storage-class     (lambda indices (random (expt 2 64))))
                              (list s8-storage-class      (lambda indices (random (- (expt 2 7))  (expt 2 7))))
                              (list s16-storage-class     (lambda indices (random (- (expt 2 15)) (expt 2 15))))
                              (list s32-storage-class     (lambda indices (random (- (expt 2 31)) (expt 2 31))))
                              (list s64-storage-class     (lambda indices (random (- (expt 2 63)) (expt 2 63))))
                              (list f16-storage-class     (lambda indices (test-random-real)))
                              (list f32-storage-class     (lambda indices (test-random-real)))
                              (list f64-storage-class     (lambda indices (test-random-real)))
                              (list char-storage-class    (lambda indices (random-char)))
                              (list c64-storage-class     (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list c128-storage-class    (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list generic-storage-class (lambda indices indices)))))
  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain
            (random-interval))
           (lower-bounds
            (interval-lower-bounds->list domain))
           (upper-bounds
            (interval-upper-bounds->list domain))
           (arrays
            (map (lambda (ignore)
                   (let ((array-builder (vector-ref array-builders (random (vector-length array-builders)))))
                     (array-copy (make-array domain
                                             (cadr array-builder))
                                 (car array-builder))))
                 (local-iota 0 (random 1 7))))
           (result-array-1
            (apply array-map
                   list
                   arrays))
           (result-array-2
            (array-copy
             (apply array-map
                    list
                    arrays)))
           (getters
            (map array-getter arrays))
           (result-array-3
            (make-array domain
                        (lambda indices
                          (map (lambda (g) (apply g indices)) getters)))))
      (test (myarray= result-array-1 result-array-2)
            #t)
      (test (myarray= result-array-2 result-array-3)
            #t)
      (test (vector->list (array-body result-array-2))
            (array-fold-right cons
                              '()
                              result-array-2))
      (test (vector->list (array-body result-array-2))
            (reverse (let ((result '()))
                       (array-for-each (lambda (f)
                                         (set! result (cons f result)))
                                       result-array-2)
                       result))))))

(next-test-random-source-state!)

(pp "array-reduce tests")

(test (array-reduce 'a 'a)
      "array-reduce: The second argument is not an array: ")

(test (array-reduce 'a (make-array (make-interval '#(1) '#(3)) list))
      "array-reduce: The first argument is not a procedure: ")

(test (array-reduce + (make-array (make-interval '#(0)) error))
      "array-reduce: Attempting to reduce over an empty array: ")

(test (array-reduce (lambda (a b) error) (make-array (make-interval '#()) (lambda () 42)))
      42)

;;; OK, how to test array-reduce?

;;; Well, we take an associative, non-commutative operation,
;;; multiplying 2x2 matrices, with data such that doing operations
;;; in the opposite order gives the wrong answer, doing it for the
;;; wrong interval (e.g., swapping axes) gives the wrong answer.

;;; This is not in the same style as the other tests, which use random
;;; data to a great extent, but I couldn't see how to choose random
;;; data that would satisfy the constraints.


(define matrix vector)

(define (2x2-multiply A B)
  (let ((a_11 (vector-ref A 0)) (a_12 (vector-ref A 1))
        (a_21 (vector-ref A 2)) (a_22 (vector-ref A 3))
        (b_11 (vector-ref B 0)) (b_12 (vector-ref B 1))
        (b_21 (vector-ref B 2)) (b_22 (vector-ref B 3)))
    (vector (+ (* a_11 b_11) (* a_12 b_21)) (+ (* a_11 b_12) (* a_12 b_22))
            (+ (* a_21 b_11) (* a_22 b_21)) (+ (* a_21 b_12) (* a_22 b_22)))))

(define A (make-array (make-interval '#(1) '#(11))
                      (lambda (i)
                        (if (even? i)
                            (matrix 1 i
                                    0 1)
                            (matrix 1 0
                                    i 1)))))

(test (array-reduce 2x2-multiply A)
      (array-fold-right 2x2-multiply (matrix 1 0 0 1) A))

(test (array-reduce 2x2-multiply A)
      (array-fold-left 2x2-multiply (matrix 1 0 0 1) A))


(define A_2 (make-array (make-interval '#(1 1) '#(3 7))
                        (lambda (i j)
                          (if (and (even? i) (even? j))
                              (matrix 1 i
                                      j 1)
                              (matrix 1 j
                                      i -1)))))

(test (array-reduce 2x2-multiply A_2)
      (array-fold-right 2x2-multiply (matrix 1 0 0 1) A_2))

(test (array-reduce 2x2-multiply A_2)
      (array-fold-left 2x2-multiply (matrix 1 0 0 1) A_2))

(test (equal? (array-reduce 2x2-multiply A_2)
              (array-reduce 2x2-multiply (array-permute A_2 (index-rotate (array-dimension A_2) 1))))
      #f)

(define A_3 (make-array (make-interval '#(1 1 1) '#(3 5 4))
                        (lambda (i j k)
                          (if (and (even? i) (even? j))
                              (matrix 1 i
                                      j k)
                              (matrix k j
                                      i -1)))))

(test (array-reduce 2x2-multiply A_3)
      (array-fold-right 2x2-multiply (matrix 1 0 0 1) A_3))

(test (array-reduce 2x2-multiply A_3)
      (array-fold-left 2x2-multiply (matrix 1 0 0 1) A_3))

(test (equal? (array-reduce 2x2-multiply A_3)
              (array-reduce 2x2-multiply (array-permute A_3 (index-rotate (array-dimension A_3) 1))))
      #f)

(define A_4 (make-array (make-interval '#(1 1 1 1) '#(3 2 4 3))
                        (lambda (i j k l)
                          (if (and (even? i) (even? j))
                              (matrix l i
                                      j k)
                              (matrix l k
                                      i j)))))

(test (array-reduce 2x2-multiply A_4)
      (array-fold-right 2x2-multiply (matrix 1 0 0 1) A_4))

(test (array-reduce 2x2-multiply A_4)
      (array-fold-left 2x2-multiply (matrix 1 0 0 1) A_4))

(test (equal? (array-reduce 2x2-multiply A_4)
              (array-reduce 2x2-multiply (array-permute A_4 (index-rotate (array-dimension A_4) 1))))
      #f)

(define A_5 (make-array (make-interval '#(1 1 1 1 1) '#(3 2 4 3 3))
                        (lambda (i j k l m)
                          (if (even? m)
                              (matrix (+ m l) i
                                      j k)
                              (matrix (- l m) k
                                      i j)))))

(test (array-reduce 2x2-multiply A_5)
      (array-fold-right 2x2-multiply (matrix 1 0 0 1) A_5))


(test (equal? (array-reduce 2x2-multiply A_5)
              (array-reduce 2x2-multiply (array-permute A_5 (index-rotate (array-dimension A_5) 1))))
      #f)

(pp "Some array-curry tests.")

(test (array-curry 'a 1)
      "array-curry: The first argument is not an array: ")

(test (array-curry (make-array (make-interval '#(0) '#(1)) list)  'a)
      "array-curry: The second argument is not an exact integer between 0 and (interval-dimension (array-domain array)) (inclusive): ")

(test (array-curry (make-array (make-interval '#(0 0) '#(1 1)) list)  -1)
      "array-curry: The second argument is not an exact integer between 0 and (interval-dimension (array-domain array)) (inclusive): ")

(test (array-curry (make-array (make-interval '#(0 0) '#(1 1)) list)  3)
      "array-curry: The second argument is not an exact integer between 0 and (interval-dimension (array-domain array)) (inclusive): ")

(let* ((dim 6)
       (domain (make-interval (make-vector dim 3)))
       (immutable (make-array domain list))
       (mutable   (make-array domain list list)) ;; nonsensical
       (special   (make-specialized-array domain)))
  (do ((left-dim 1 (+ left-dim 1)))
      ((> left-dim dim))
    (let* ((right-dim (- dim left-dim))
           (immutable-curry (array-curry immutable right-dim))
           (mutable-curry(array-curry  mutable right-dim))
           (special-curry (array-curry special right-dim)))
      (for-each (lambda (array)
                  (test (apply array-ref array (make-list left-dim 100))
                        "array-curry: domain does not contain multi-index: ")
                  (test (apply array-ref array (make-list left-dim 'a))
                        "array-curry: multi-index component is not an exact integer: ")
                  (if (< 4 left-dim)
                      (test (apply array-ref array '(0 0))
                            "array-curry: multi-index is not the correct dimension: ")))
                (list immutable-curry mutable-curry special-curry)))))

(let ((array-builders (vector (list u1-storage-class      (lambda indices (random (expt 2 1))))
                              (list u8-storage-class      (lambda indices (random (expt 2 8))))
                              (list u16-storage-class     (lambda indices (random (expt 2 16))))
                              (list u32-storage-class     (lambda indices (random (expt 2 32))))
                              (list u64-storage-class     (lambda indices (random (expt 2 64))))
                              (list s8-storage-class      (lambda indices (random (- (expt 2 7))  (expt 2 7))))
                              (list s16-storage-class     (lambda indices (random (- (expt 2 15)) (expt 2 15))))
                              (list s32-storage-class     (lambda indices (random (- (expt 2 31)) (expt 2 31))))
                              (list s64-storage-class     (lambda indices (random (- (expt 2 63)) (expt 2 63))))
                              (list f16-storage-class     (lambda indices (test-random-real)))
                              (list f32-storage-class     (lambda indices (test-random-real)))
                              (list f64-storage-class     (lambda indices (test-random-real)))
                              (list char-storage-class    (lambda indices (random-char)))
                              (list c64-storage-class     (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list c128-storage-class    (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list generic-storage-class (lambda indices indices)))))
  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain
            (random-interval 0 7))
           (lower-bounds
            (interval-lower-bounds->list domain))
           (upper-bounds
            (interval-upper-bounds->list domain))
           (array-builder
            (vector-ref array-builders (random (vector-length array-builders))))
           (random-array-element
            (cadr array-builder))
           (storage-class
            (car array-builder))
           (Array
            (array-copy (make-array domain
                                    random-array-element)
                        storage-class))
           (copied-array
            (array-copy Array
                        storage-class))
           (inner-dimension
            (random-inclusive (interval-dimension domain)))
           (domains
            (call-with-values (lambda ()(interval-projections domain inner-dimension)) list))
           (outer-domain
            (car domains))
           (inner-domain
            (cadr domains))
           (immutable-curry
            (array-curry (make-array (array-domain Array)
                                     (array-getter Array))
                         inner-dimension))
           (mutable-curry
            (array-curry (make-array (array-domain Array)
                                     (array-getter Array)
                                     (array-setter Array))
                         inner-dimension))
           (specialized-curry
            (array-curry Array inner-dimension))
           (immutable-curry-from-definition
            (call-with-values
                (lambda () (interval-projections (array-domain Array) inner-dimension))
              (lambda (outer-interval inner-interval)
                (make-array outer-interval
                            (lambda outer-multi-index
                              (make-array inner-interval
                                          (lambda inner-multi-index
                                            (apply (array-getter Array) (append outer-multi-index inner-multi-index)))))))))
           (mutable-curry-from-definition
            (call-with-values
                (lambda () (interval-projections (array-domain Array) inner-dimension))
              (lambda (outer-interval inner-interval)
                (make-array outer-interval
                            (lambda outer-multi-index
                              (make-array inner-interval
                                          (lambda inner-multi-index
                                            (apply (array-getter Array) (append outer-multi-index inner-multi-index)))
                                          (lambda (v . inner-multi-index)
                                            (apply (array-setter Array) v (append outer-multi-index inner-multi-index)))))))))
           (specialized-curry-from-definition
            (call-with-values
                (lambda () (interval-projections (array-domain Array) inner-dimension))
              (lambda (outer-interval inner-interval)
                (make-array outer-interval
                            (lambda outer-multi-index
                              (specialized-array-share Array
                                                       inner-interval
                                                       (lambda inner-multi-index
                                                         (apply values (append outer-multi-index inner-multi-index))))))))))
      ;; mutate the curried array
      (if (and (not (interval-empty? outer-domain))
               (not (interval-empty? inner-domain)))
          (for-each (lambda (curried-array)
                      (let ((outer-getter
                             (array-getter curried-array)))
                        (do ((i 0 (+ i 1)))
                            ((= i 50))  ;; used to be tests, not 50, but 50 will do fine
                          (call-with-values
                              (lambda ()
                                (random-multi-index outer-domain))
                            (lambda outer-multi-index
                              (let ((inner-setter
                                     (array-setter (apply outer-getter outer-multi-index))))
                                (call-with-values
                                    (lambda ()
                                      (random-multi-index inner-domain))
                                  (lambda inner-multi-index
                                    (let ((new-element
                                           (random-array-element)))
                                      (apply inner-setter new-element inner-multi-index)
                                      ;; mutate the copied array without currying
                                      (apply (array-setter copied-array) new-element (append outer-multi-index inner-multi-index)))))))))))
                    (list mutable-curry
                          specialized-curry
                          mutable-curry-from-definition
                          specialized-curry-from-definition)))

      (test (myarray= Array copied-array) #t)
      (test (array-every array? immutable-curry) #t)
      (test (array-every (lambda (a) (not (mutable-array? a))) immutable-curry) #t)
      (test (array-every (lambda (a) (not (specialized-array? a))) mutable-curry) #t)
      (test (array-every specialized-array? specialized-curry) #t)
      (test (array-every (lambda (xy) (apply myarray= xy))
                         (array-map list immutable-curry immutable-curry-from-definition))
            #t)
      (test (array-every (lambda (xy) (apply myarray= xy))
                         (array-map list mutable-curry mutable-curry-from-definition))
            #t)
      (test (array-every (lambda (xy) (apply myarray= xy))
                         (array-map list specialized-curry specialized-curry-from-definition))
            #t))))


(next-test-random-source-state!)

(pp "array-decurry and array-decurry! tests")

(for-each (lambda (call/cc-safe?)
            (let ((array-decurry
                   (if call/cc-safe?
                       array-decurry
                       array-decurry!))
                  (message
                   (if call/cc-safe?
                       "array-decurry: "
                       "array-decurry!: ")))

              (define (wrap error-reason)
                (string-append message error-reason))

              (test (array-decurry 'a)
                    (wrap "The first argument is not an array: "))

              (test (array-decurry (make-array (make-interval '#(0)) list))
                    (wrap "The first argument is an empty array: "))

              (test (array-decurry (make-array (make-interval '#()) list) 'a)
                    (wrap "The second argument is not a storage class: "))

              (test (array-decurry (make-array (make-interval '#()) list) generic-storage-class 'a)
                    (wrap "The third argument is not a boolean: "))

              (test (array-decurry (make-array (make-interval '#()) list) generic-storage-class #f 'a)
                    (wrap "The fourth argument is not a boolean: "))

              (test (array-decurry (make-array (make-interval '#()) list))
                    (wrap "Not all elements of the first argument (an array) are arrays: "))

              (test (array-decurry (list*->array 1 (list (make-array (make-interval '#()) list)
                                                         (make-array (make-interval '#(1)) list))))
                    (wrap "Not all elements of the first argument (an array) have the domain: "))

              (test (array-decurry (list*->array 1 (list (make-array (make-interval '#(1)) list)
                                                         (make-array (make-interval '#(1)) list)))
                                   u1-storage-class)
                    (wrap "Not all elements of the source can be stored in destination: "))
              ))
          '(#t #f))

(define (my-array-decurry  A)
  (let* ((A
          (array-copy A))      ;; evaluate all elements of A once
         (A_dim
          (array-dimension A))
         (A_
          (array-getter A))
         (A_D
          (array-domain A))
         (element-domain
          (array-domain (apply A_ (interval-lower-bounds->list A_D))))
         (result-domain
          (interval-cartesian-product A_D (array-domain (apply A_ (interval-lower-bounds->list A_D)))))
         (result
          (make-specialized-array result-domain u1-storage-class))
         (curried-result
          (array-curry result (interval-dimension element-domain))))
    (array-for-each array-assign! result-array A)
    result-array))

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((outer-domain
          (random-nonempty-interval 0 5))
         (inner-domain
          (random-interval 0 5))
         (A
          (array-copy (make-array (interval-cartesian-product outer-domain inner-domain)
                                  (lambda args
                                    (random 2)))
                      u1-storage-class))
         (A-curried
          (array-curry A (interval-dimension inner-domain)))
         (A-curried
          (array-map (lambda (A) (make-array (array-domain A) (array-getter A))) A-curried))
         (A-decurried!
          (array-decurry! A-curried u1-storage-class))
         (A-decurried
          (array-decurry A-curried u1-storage-class)))
    (test (myarray= A A-decurried)
          #t)
    (test (myarray= A A-decurried!)
          #t)))

(next-test-random-source-state!)

(pp "specialized-array-share error tests")

(test (specialized-array-share 1 1 1)
      "specialized-array-share: The first argument is not a specialized-array: ")

(test (specialized-array-share (make-specialized-array (make-interval '#(1) '#(2)))
                               1 1)
      "specialized-array-share: The second argument is not an interval: ")

(test (specialized-array-share (make-specialized-array (make-interval '#(1) '#(2)))
                               (make-interval '#(0) '#(1))
                               1)
      "specialized-array-share: The third argument is not a procedure: ")

(test (specialized-array-share (make-specialized-array (make-interval '#(0 0)))
                               (make-interval '#(1))
                               (lambda (i) (values i i)))
      "specialized-array-share: The second argument (a domain) has more elements than the domain of the first argument (an array): ")


(test (myarray= (list->array (make-interval '#(0) '#(10))
                             (reverse (local-iota 0 10)))
                (specialized-array-share (list->array (make-interval '#(0) '#(10))
                                                      (local-iota 0 10))
                                         (make-interval '#(0) '#(10))
                                         (lambda (i)
                                           (- 9 i))))
      #t)

(pp "specialized-array-share result tests")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((n (random 1 11))
         (permutation (random-permutation n))
         (input-vec (list->vector (f64vector->list (random-f64vector n)))))
    (test (vector-permute input-vec permutation)
          (%%vector-permute input-vec permutation))
    (test (list->vector (%%vector-permute->list input-vec permutation))
          (vector-permute input-vec permutation))))


(next-test-random-source-state!)


(specialized-array-default-safe? #t)

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((interval (random-interval))
         (axes (local-iota 0 (interval-dimension interval)))
         (lower-bounds (interval-lower-bounds->vector interval))
         (upper-bounds (interval-upper-bounds->vector interval))
         (a (array-copy (make-array interval list)))
         (new-axis-order (vector-permute (list->vector axes) (random-permutation (length axes))))
         (reverse-order? (list->vector (map (lambda (x) (zero? (random 2))) axes))))
    (let ((b (make-array (make-interval (vector-permute lower-bounds new-axis-order)
                                        (vector-permute upper-bounds new-axis-order))
                         (lambda multi-index
                           (apply (array-getter a)
                                  (let* ((n (vector-length new-axis-order))
                                         (multi-index-vector (list->vector multi-index))
                                         (result (make-vector n)))
                                    (do ((i 0 (+ i 1)))
                                        ((= i n) (vector->list result))
                                      (vector-set! result (vector-ref new-axis-order i)
                                                   (if (vector-ref reverse-order? (vector-ref new-axis-order i))
                                                       (+ (vector-ref lower-bounds (vector-ref new-axis-order i))
                                                          (- (vector-ref upper-bounds (vector-ref new-axis-order i))
                                                             (vector-ref multi-index-vector i)
                                                             1))
                                                       (vector-ref multi-index-vector i)))))))))
          (c (specialized-array-share a
                                      (make-interval (vector-permute lower-bounds new-axis-order)
                                                     (vector-permute upper-bounds new-axis-order))
                                      (lambda multi-index
                                        (apply values
                                               (let* ((n (vector-length new-axis-order))
                                                      (multi-index-vector (list->vector multi-index))
                                                      (result (make-vector n)))
                                                 (do ((i 0 (+ i 1)))
                                                     ((= i n) (vector->list result))
                                                   (vector-set! result (vector-ref new-axis-order i)
                                                                (if (vector-ref reverse-order? (vector-ref new-axis-order i))
                                                                    (+ (vector-ref lower-bounds (vector-ref new-axis-order i))
                                                                       (- (vector-ref upper-bounds (vector-ref new-axis-order i))
                                                                          (vector-ref multi-index-vector i)
                                                                          1))
                                                                    (vector-ref multi-index-vector i))))))))))
      (test (myarray= b c)
            #t))))

(next-test-random-source-state!)

(specialized-array-default-safe? #f)

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((interval (random-interval))
         (axes (local-iota 0 (interval-dimension interval)))
         (lower-bounds (interval-lower-bounds->vector interval))
         (upper-bounds (interval-upper-bounds->vector interval))
         (a (array-copy (make-array interval list)))
         (new-axis-order (vector-permute (list->vector axes) (random-permutation (length axes))))
         (reverse-order? (list->vector (map (lambda (x) (zero? (random 2))) axes))))
    (let ((b (make-array (make-interval (vector-permute lower-bounds new-axis-order)
                                        (vector-permute upper-bounds new-axis-order))
                         (lambda multi-index
                           (apply (array-getter a)
                                  (let* ((n (vector-length new-axis-order))
                                         (multi-index-vector (list->vector multi-index))
                                         (result (make-vector n)))
                                    (do ((i 0 (+ i 1)))
                                        ((= i n) (vector->list result))
                                      (vector-set! result (vector-ref new-axis-order i)
                                                   (if (vector-ref reverse-order? (vector-ref new-axis-order i))
                                                       (+ (vector-ref lower-bounds (vector-ref new-axis-order i))
                                                          (- (vector-ref upper-bounds (vector-ref new-axis-order i))
                                                             (vector-ref multi-index-vector i)
                                                             1))
                                                       (vector-ref multi-index-vector i)))))))))
          (c (specialized-array-share a
                                      (make-interval (vector-permute lower-bounds new-axis-order)
                                                     (vector-permute upper-bounds new-axis-order))
                                      (lambda multi-index
                                        (apply values
                                               (let* ((n (vector-length new-axis-order))
                                                      (multi-index-vector (list->vector multi-index))
                                                      (result (make-vector n)))
                                                 (do ((i 0 (+ i 1)))
                                                     ((= i n) (vector->list result))
                                                   (vector-set! result (vector-ref new-axis-order i)
                                                                (if (vector-ref reverse-order? (vector-ref new-axis-order i))
                                                                    (+ (vector-ref lower-bounds (vector-ref new-axis-order i))
                                                                       (- (vector-ref upper-bounds (vector-ref new-axis-order i))
                                                                          (vector-ref multi-index-vector i)
                                                                          1))
                                                                    (vector-ref multi-index-vector i))))))))))
      (if (not (myarray= b c))
          (pp (list "piffle"
                    a b c))))))

(next-test-random-source-state!)


(pp "interval and array translation tests")

(test (translation? '()) #f)

(test (translation? '#()) #t)

(test (translation? '#(a)) #f)

(test (translation? '#(1.0)) #f)

(test (translation? '#(1 2)) #t)

(let ((int (make-interval '#(0 0) '#(10 10)))
      (translation '#(10 -2)))
  (test (interval-translate 'a 10)
        "interval-translate: The first argument is not an interval: ")
  (test (interval-translate int 10)
        "interval-translate: The second argument is not a vector of exact integers: ")
  (test (interval-translate int '#(a b))
        "interval-translate: The second argument is not a vector of exact integers: ")
  (test (interval-translate int '#(1. 2.))
        "interval-translate: The second argument is not a vector of exact integers: ")
  (test (interval-translate int '#(1))
        "interval-translate: The dimension of the first argument (an interval) does not equal the length of the second (a vector): ")
  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((int (random-interval))
           (lower-bounds (interval-lower-bounds->vector int))
           (upper-bounds (interval-upper-bounds->vector int))
           (translation (list->vector (map (lambda (x)
                                             (random -10 10))
                                           (local-iota 0 (vector-length lower-bounds))))))
      (interval= (interval-translate int translation)
                 (make-interval (vector-map + lower-bounds translation)
                                (vector-map + upper-bounds translation))))))

(next-test-random-source-state!)

(let* ((specialized-array (array-copy (make-array (make-interval '#(0 0) '#(10 12))
                                                  list)))
       (mutable-array (let ((temp (array-copy specialized-array)))
                        (make-array (array-domain temp)
                                    (array-getter temp)
                                    (array-setter temp))))
       (immutable-array (make-array (array-domain mutable-array)
                                    (array-getter mutable-array)))
       (translation '#(10 -2)))

  (define (my-array-translate Array translation)
    (let* ((array-copy (array-copy Array))
           (getter (array-getter array-copy))
           (setter (array-setter array-copy)))
      (make-array (interval-translate (array-domain Array)
                                      translation)
                  (lambda args
                    (apply getter
                           (map - args (vector->list translation))))
                  (lambda (v . args)
                    (apply setter
                           v
                           (map - args (vector->list translation)))))))

  (test (array-translate 'a 1)
        "array-translate: The first argument is not an array: ")
  (test (array-translate immutable-array '#(1.))
        "array-translate: The second argument is not a vector of exact integers: ")
  (test (array-translate immutable-array '#(0 2 3))
        "array-translate: The dimension of the first argument (an array) does not equal the dimension of the second argument (a vector): ")
  (let ((specialized-result (array-translate specialized-array translation)))
    (test (specialized-array? specialized-result)
          #t))
  (let ((mutable-result (array-translate mutable-array translation)))
    (test (and (mutable-array? mutable-array)
               (not (specialized-array? mutable-array))
               (mutable-array? mutable-result)
               (not (specialized-array? mutable-result)))
          #t))
  (let ((immutable-result (array-translate immutable-array translation)))
    (test (and (array? immutable-array)
               (not (mutable-array? immutable-array))
               (array? immutable-result)
               (not (mutable-array? immutable-result)))
          #t))

  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain (random-interval))
           (Array (let ((temp (make-array domain list)))
                    (case (test-random-integer 3)
                      ((0) temp)
                      ((1) (array-copy temp))
                      ((2) (let ((temp (array-copy temp)))
                             (make-array (array-domain temp)
                                         (array-getter temp)
                                         (array-setter temp)))))))
           (translation (list->vector (map (lambda (x) (random -10 10)) (vector->list (%%interval-lower-bounds domain))))))
      ;;(pp (list domain translation (interval-volume domain)))
      (let ((translated-array       (array-translate Array translation))
            (my-translated-array (my-array-translate Array translation)))
        (if (and (mutable-array? Array)
                 (not (interval-empty? (array-domain Array))))
            (let ((translated-domain (interval-translate domain translation)))
              (do ((j 0 (+ j 1)))
                  ((= j 50))
                (call-with-values
                    (lambda ()
                      (random-multi-index translated-domain))
                  (lambda multi-index
                    (let ((value (test-random-integer 10000)))
                      (apply (array-setter translated-array) value multi-index)
                      (apply (array-setter my-translated-array) value multi-index)))))))
        (test (myarray= (array-translate Array translation)
                        (my-array-translate Array translation))
              #t)))))

(next-test-random-source-state!)

(let* ((specialized (make-specialized-array (make-interval '#(0 0 0 0 0) '#(1 1 1 1 1))))
       (mutable (make-array (array-domain specialized)
                            (array-getter specialized)
                            (array-setter specialized)))
       (A (array-translate  mutable '#(0 0 0 0 0))))

  (test ((array-getter A) 0 0)
        "The number of indices does not equal the array dimension: ")

  (test ((array-setter A) 'a 0 0)
        "The number of indices does not equal the array dimension: "))

(next-test-random-source-state!)


(pp "interval and array permutation tests")

(test (index-first 'a 'b)
      "index-first: The first argument is not a positive fixnum: ")

(test (index-first 1. 'b)
      "index-first: The first argument is not a positive fixnum: ")

(test (index-first -1 2)
      "index-first: The first argument is not a positive fixnum: ")

(test (index-first 1 'a)
      "index-first: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-first 2 1.0)
      "index-first: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-first 2 2)
      "index-first: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-first 2 -1)
      "index-first: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-last 'a 'b)
      "index-last: The first argument is not a positive fixnum: ")

(test (index-last 1. 'b)
      "index-last: The first argument is not a positive fixnum: ")

(test (index-last -1 2)
      "index-last: The first argument is not a positive fixnum: ")

(test (index-last 1 'a)
      "index-last: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-last 2 1.0)
      "index-last: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-last 2 2)
      "index-last: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-last 2 -1)
      "index-last: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-rotate 'a 'b)
      "index-rotate: The first argument is not a nonnegative fixnum: ")

(test (index-rotate 1. 'b)
      "index-rotate: The first argument is not a nonnegative fixnum: ")

(test (index-rotate -1 2)
      "index-rotate: The first argument is not a nonnegative fixnum: ")

(test (index-rotate 1 'a)
      "index-rotate: The second argument is not a fixnum between 0 and the first argument (inclusive): ")

(test (index-rotate 2 1.0)
      "index-rotate: The second argument is not a fixnum between 0 and the first argument (inclusive): ")

(test (index-rotate 2 3)
      "index-rotate: The second argument is not a fixnum between 0 and the first argument (inclusive): ")

(test (index-rotate 2 -1)
      "index-rotate: The second argument is not a fixnum between 0 and the first argument (inclusive): ")

(test (index-swap 'a 'b 'c)
      "index-swap: The first argument is not a positive fixnum: ")

(test (index-swap -1 'b 'c)
      "index-swap: The first argument is not a positive fixnum: ")

(test (index-swap 1 'b 'c)
      "index-swap: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-swap 1 -1 'c)
      "index-swap: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-swap 1 1 'c)
      "index-swap: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-swap 2 0 'c)
      "index-swap: The third argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-swap 2 0 -1)
      "index-swap: The third argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

(test (index-swap 2 0 2)
      "index-swap: The third argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): ")

;;; Testing index-*

(define (my-index-first n k)
  (let ((identity (iota n)))
    (list->vector
     (cons k (append (take identity k)
                     (drop identity (+ k 1)))))))

(define (my-index-last n k)
  (let ((identity (iota n)))
    (list->vector
     (append (take identity k)
             (drop identity (+ k 1))
             (list k)))))

(define (my-index-rotate n k)
  (let ((identity (iota n)))
    (list->vector
     (append (drop identity k)
             (take identity k)))))

(define (my-index-swap n i j)
  (let ((result (list->vector (iota n))))
    (vector-set! result i j)
    (vector-set! result j i)
    result))

(do ((n 0 (+ n 1)))
    ((= n 6))
  (do ((i 0 (+ i 1)))
      ((= i n)
       (test (index-rotate n i)
             (my-index-rotate n i)))
    (test (index-first n i)
          (my-index-first n i))
    (test (index-last n i)
          (my-index-last n i))
    (test (index-rotate n i)
          (my-index-rotate n i))
    (do ((j 0 (+ j 1)))
        ((= j n))
      (test (index-swap n i j)
            (my-index-swap n i j)))))

(pp "interval-permute and array-permute tests")

(let ((int (make-interval '#(0 0) '#(10 10)))
      (permutation '#(1 0)))
  (test (interval-permute 'a 10)
        "interval-permute: The first argument is not an interval: ")
  (test (interval-permute int 10)
        "interval-permute: The second argument is not a permutation: ")
  (test (interval-permute int '#(a b))
        "interval-permute: The second argument is not a permutation: ")
  (test (interval-permute int '#(1. 2.))
        "interval-permute: The second argument is not a permutation: ")
  (test (interval-permute int '#(10 -2))
        "interval-permute: The second argument is not a permutation: ")
  (test (interval-permute int '#(0))
        "interval-permute: The dimension of the first argument (an interval) does not equal the length of the second (a permutation): ")
  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((int (random-interval))
           (lower-bounds (interval-lower-bounds->vector int))
           (upper-bounds (interval-upper-bounds->vector int))
           (permutation (random-permutation (vector-length lower-bounds))))
      (interval= (interval-permute int permutation)
                 (make-interval (vector-permute lower-bounds permutation)
                                (vector-permute upper-bounds permutation))))))

(next-test-random-source-state!)

(test (permutation? 'a) #f)
(test (permutation? '#()) #t)
(test (permutation? '#(1.0)) #f)
(test (permutation? '#(1 1)) #f)
(test (permutation? '#(1 2)) #f)
(test (permutation? '#(1 2 0)) #t)

(test (array-every equal?
                   (array-permute (make-array (make-interval '#()) (lambda () 42))
                                  '#())
                   (make-array (make-interval '#()) (lambda () 42)))
      #t)

(test (array-every equal?
                   (array-permute (make-array (make-interval '#(0 1)) error)
                                  '#(1 0))
                   (make-array (make-interval '#(1 0)) error))
      #t)

(let* ((specialized-array (array-copy (make-array (make-interval '#(0 0) '#(10 12))
                                                                list)))
       (mutable-array (let ((temp (array-copy specialized-array)))
                        (make-array (array-domain temp)
                                    (array-getter temp)
                                    (array-setter temp))))
       (immutable-array (make-array (array-domain mutable-array)
                                    (array-getter mutable-array)))
       (permutation '#(1 0)))

  (test (array-permute 'a 1)
        "array-permute: The first argument is not an array: ")
  (test (array-permute immutable-array '#(1.))
        "array-permute: The second argument is not a permutation: ")
  (test (array-permute immutable-array '#(2))
        "array-permute: The second argument is not a permutation: ")
  (test (array-permute immutable-array '#(0 1 2))
        "array-permute: The dimension of the first argument (an array) does not equal the dimension of the second argument (a permutation): ")
  (let ((specialized-result (array-permute specialized-array permutation)))
    (test (specialized-array? specialized-result)
          #t))
  (let ((mutable-result (array-permute mutable-array permutation)))
    (test (and (mutable-array? mutable-array)
               (not (specialized-array? mutable-array))
               (mutable-array? mutable-result)
               (not (specialized-array? mutable-result)))
          #t))
  (let ((immutable-result (array-permute immutable-array permutation)))
    (test (and (array? immutable-array)
               (not (mutable-array? immutable-array))
               (array? immutable-result)
               (not (mutable-array? immutable-result)))
          #t))

  (specialized-array-default-safe? #t)

  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain (random-interval))
           (Array (let ((temp (make-array domain list)))
                    (case (test-random-integer 3)
                      ((0) temp)
                      ((1) (array-copy temp))
                      ((2) (let ((temp (array-copy temp)))
                             (make-array (array-domain temp)
                                         (array-getter temp)
                                         (array-setter temp)))))))
           (permutation (random-permutation (interval-dimension domain))))

      (define (my-array-permute Array permutation)
        (let* ((array-copy (array-copy Array))
               (getter (array-getter array-copy))
               (setter (array-setter array-copy))
               (permutation-inverse (%%permutation-invert permutation)))
          (make-array (interval-permute (array-domain Array)
                                        permutation)
                      (lambda args
                        (apply getter
                               (vector->list (vector-permute (list->vector args) permutation-inverse))))
                      (lambda (v . args)
                        (apply setter
                               v
                               (vector->list (vector-permute (list->vector args) permutation-inverse)))))))

      ;; (pp (list domain permutation (interval-volume domain)))
      (let ((permuted-array       (array-permute Array permutation))
            (my-permuted-array (my-array-permute Array permutation)))
        (if (and (mutable-array? Array)
                 (not (interval-empty? (array-domain Array))))
            (let ((permuted-domain (interval-permute domain permutation)))
              (do ((j 0 (+ j 1)))
                  ((= j 50))
                (call-with-values
                    (lambda ()
                      (random-multi-index permuted-domain))
                  (lambda multi-index
                    (let ((value (test-random-integer 10000)))
                      (apply (array-setter permuted-array) value multi-index)
                      (apply (array-setter my-permuted-array) value multi-index)))))))
        (test (myarray= permuted-array
                        my-permuted-array)
              #t))))

(next-test-random-source-state!)

  (specialized-array-default-safe? #f)

  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain (random-interval))
           (Array (let ((temp (make-array domain list)))
                    (case (test-random-integer 3)
                      ((0) temp)
                      ((1) (array-copy temp))
                      ((2) (let ((temp (array-copy temp)))
                             (make-array (array-domain temp)
                                         (array-getter temp)
                                         (array-setter temp)))))))
           (permutation (random-permutation (interval-dimension domain))))

      (define (my-array-permute Array permutation)
        (let* ((array-copy (array-copy Array))
               (getter (array-getter array-copy))
               (setter (array-setter array-copy))
               (permutation-inverse (%%permutation-invert permutation)))
          (make-array (interval-permute (array-domain Array)
                                        permutation)
                      (lambda args
                        (apply getter
                               (vector->list (vector-permute (list->vector args) permutation-inverse))))
                      (lambda (v . args)
                        (apply setter
                               v
                               (vector->list (vector-permute (list->vector args) permutation-inverse)))))))

      ;; (pp (list domain permutation (interval-volume domain)))
      (let ((permuted-array       (array-permute Array permutation))
            (my-permuted-array (my-array-permute Array permutation)))
        (if (and (not (array-empty? Array))
                 (mutable-array? Array))
            (let ((permuted-domain (interval-permute domain permutation)))
              (do ((j 0 (+ j 1)))
                  ((= j 50))
                (call-with-values
                    (lambda ()
                      (random-multi-index permuted-domain))
                  (lambda multi-index
                    (let ((value (test-random-integer 10000)))
                      (apply (array-setter permuted-array) value multi-index)
                      (apply (array-setter my-permuted-array) value multi-index)))))))
        (test (myarray= permuted-array
                        my-permuted-array)
              #t)))))

(next-test-random-source-state!)


(pp "interval-intersect tests")

(let ((a (make-interval '#(0 0) '#(10 10)))
      (b (make-interval '#(0) '#(10)))
      (c (make-interval '#(10 10) '#(20 20))))
  (test (interval-intersect 'a)
        "interval-intersect: The argument is not an interval: ")
  (test (interval-intersect  a 'a)
        "interval-intersect: Not all arguments are intervals: ")
  (test (interval-intersect a b)
        "interval-intersect: Not all arguments have the same dimension: "))


(define (my-interval-intersect . args)

  (define (fold-left operator           ;; called with (operator result-so-far (car list))
                     initial-value
                     list)
    (if (null? list)
        initial-value
        (fold-left operator
                   (operator initial-value (car list))
                   (cdr list))))


  (let ((new-uppers (let ((uppers (map interval-upper-bounds->vector args)))
                      (fold-left (lambda (arg result)
                                   (vector-map min arg result))
                                 (car uppers)
                                 uppers)))
        (new-lowers (let ((lowers (map interval-lower-bounds->vector args)))
                      (fold-left (lambda (arg result)
                                   (vector-map max arg result))
                                 (car lowers)
                                 lowers))))
    ;; (pp (list args new-lowers new-uppers (vector-every < new-lowers new-uppers)))
    (and (%%vector-every <= new-lowers new-uppers)
         (make-interval new-lowers new-uppers))))


(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((dimension (random 1 6))
         (number-of-intervals (random 1 4))
         (intervals (map (lambda (x)
                           (random-interval dimension (+ dimension 1)))
                         (local-iota 0 number-of-intervals))))
    ;; (pp (list intervals (apply my-interval-intersect intervals)))
    (test (apply my-interval-intersect intervals)
          (apply interval-intersect intervals))))

(next-test-random-source-state!)

(pp "test interval-scale and array-sample")

(test (interval-scale 1 'a)
      "interval-scale: The first argument is not an interval with all lower bounds zero: ")

(test (interval-scale (make-interval '#(1) '#(2)) 'a)
      "interval-scale: The first argument is not an interval with all lower bounds zero: ")

(test (interval-scale (make-interval '#(0) '#(1))
                      'a)
      "interval-scale: The second argument is not a vector of positive, exact, integers: ")

(test (interval-scale (make-interval '#(0) '#(1))
                      '#(a))
      "interval-scale: The second argument is not a vector of positive, exact, integers: ")

(test (interval-scale (make-interval '#(0) '#(1))
                      '#(0))
      "interval-scale: The second argument is not a vector of positive, exact, integers: ")

(test (interval-scale (make-interval '#(0) '#(1))
                      '#(1.))
      "interval-scale: The second argument is not a vector of positive, exact, integers: ")

(test (interval-scale (make-interval '#(0) '#(1))
                      '#(1 2))
      "interval-scale: The dimension of the first argument (an interval) is not equal to the length of the second (a vector): ")

(define (myinterval-scale interval scales)
  (make-interval (interval-lower-bounds->vector interval)
                 (vector-map (lambda (u s)
                               (quotient (+ u s -1) s))
                             (interval-upper-bounds->vector interval)
                             scales)))

(do ((i 0 (fx+ i 1)))
    ((fx= i random-tests))
  (let* ((interval (random-nonnegative-interval))
         (scales   (random-positive-vector (interval-dimension interval))))
    (test (  interval-scale interval scales)
          (myinterval-scale interval scales))))

(next-test-random-source-state!)

(test (array-sample 'a 'a)
      "array-sample: The first argument is not an array whose domain has zero lower bounds: ")

(test (array-sample (make-array (make-interval '#(1) '#(2)) list) 'a)
      "array-sample: The first argument is not an array whose domain has zero lower bounds: ")

(test (array-sample (make-array (make-interval '#(0) '#(2)) list) 'a)
      "array-sample: The second argument is not a vector of positive, exact, integers: ")

(test (array-sample (make-array (make-interval '#(0) '#(2)) list) '#(1.))
      "array-sample: The second argument is not a vector of positive, exact, integers: ")

(test (array-sample (make-array (make-interval '#(0) '#(2)) list) '#(0))
      "array-sample: The second argument is not a vector of positive, exact, integers: ")

(test (array-sample (make-array (make-interval '#(0) '#(2)) list) '#(2 1))
      "array-sample: The dimension of the first argument (an array) is not equal to the length of the second (a vector): ")

(define (myarray-sample array scales)
  (let ((scales-list (vector->list scales)))
    (cond ((specialized-array? array)
           (specialized-array-share array
                                    (interval-scale (array-domain array) scales)
                                    (lambda multi-index
                                      (apply values (map * multi-index scales-list)))))
          ((mutable-array? array)
           (let ((getter (array-getter array))
                 (setter (array-setter array)))
             (make-array (interval-scale (array-domain array) scales)
                         (lambda multi-index
                           (apply getter (map * multi-index scales-list)))
                         (lambda (v . multi-index)
                           (apply setter v (map * multi-index scales-list))))))
          (else
           (let ((getter (array-getter array)))
             (make-array (interval-scale (array-domain array) scales)
                         (lambda multi-index
                           (apply getter (map * multi-index scales-list)))))))))



(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((domain (random-nonnegative-interval 1 6))
         (Array (let ((temp (make-array domain list)))
                  (case (test-random-integer 3)
                    ((0) temp)
                    ((1) (array-copy temp))
                    ((2) (let ((temp (array-copy temp)))
                           (make-array (array-domain temp)
                                       (array-getter temp)
                                       (array-setter temp)))))))
         (scales (random-positive-vector (interval-dimension domain)))
         (sampled-array (array-sample Array scales))
         (my-sampled-array (myarray-sample Array scales)))

      (if (mutable-array? Array)
          (let ((scaled-domain (interval-scale domain scales)))
            (do ((j 0 (+ j 1)))
                ((= j 50))
              (call-with-values
                  (lambda ()
                    (random-multi-index scaled-domain))
                (lambda multi-index
                  (let ((value (test-random-integer 10000)))
                    (apply (array-setter sampled-array) value multi-index)
                    (apply (array-setter my-sampled-array) value multi-index)))))))
      (test (myarray= sampled-array
                      my-sampled-array)
            #t)))

(next-test-random-source-state!)

(pp "test array-extract and array-tile")

(test (array-extract (make-array (make-interval '#(0 0) '#(1 1)) list)
                     'a)
      "array-extract: The second argument is not an interval: ")

(test (array-extract 'a (make-interval '#(0 0) '#(1 1)))
      "array-extract: The first argument is not an array: ")

(test (array-extract (make-array (make-interval '#(0 0) '#(1 1)) list)
                     (make-interval '#(0) '#(1)))
      "array-extract: The dimension of the second argument (an interval) does not equal the dimension of the domain of the first argument (an array): ")

(test (array-extract (make-array (make-interval '#(0 0) '#(1 1)) list)
                     (make-interval '#(0 0) '#(1 3)))
      "array-extract: The second argument (an interval) is not a subset of the domain of the first argument (an array): ")

(let* ((A (list->array (make-interval '#(10)) (iota 10)  generic-storage-class #f)) ;; not mutable
       (B (array-extract A (make-interval '#(0)))))   ;; used to tickle a bug
  (test (mutable-array? A)
        #f)
  (test (mutable-array? B)
        #f))

(do ((i 0 (fx+ i 1)))
    ((fx= i random-tests))
  (let* ((domain (random-interval))
         (subdomain (random-subinterval domain))
         (spec-A (array-copy (make-array domain list)))
         (spec-A-extract (array-extract spec-A subdomain))
         (mut-A (let ((A-prime (array-copy spec-A)))
                  (make-array domain
                              (array-getter A-prime)
                              (array-setter A-prime))))
         (mut-A-extract (array-extract mut-A subdomain))
         (immutable-A (let ((A-prime (array-copy spec-A)))
                        (make-array domain
                                    (array-getter A-prime))))
         (immutable-A-extract (array-extract immutable-A subdomain))
         (spec-B (array-copy (make-array domain list)))
         (spec-B-extract (array-extract spec-B subdomain))
         (mut-B (let ((B-prime (array-copy spec-B)))
                  (make-array domain
                              (array-getter B-prime)
                              (array-setter B-prime))))
         (mut-B-extract (array-extract mut-B subdomain)))
    ;; test that the extracts are the same kind of arrays as the original
    (test (specialized-array? spec-A)
          #t)
    (test (specialized-array? spec-A-extract)
          #t)
    (test (and (mutable-array? mut-A)
               (not (specialized-array? mut-A)))
          #t)
    (test (and (mutable-array? mut-A-extract)
               (not (specialized-array? mut-A-extract)))
          #t)
    (test (and (array? immutable-A)
               (not (mutable-array? immutable-A)))
          #t)
    (test (and (array? immutable-A-extract)
               (not (mutable-array? immutable-A-extract)))
          #t)
    (test (array-domain spec-A-extract)
          subdomain)
    (test (array-domain mut-A-extract)
          subdomain)
    (test (array-domain immutable-A-extract)
          subdomain)
    ;; test that applying the original setter to arguments in
    ;; the subdomain gives the same answer as applying the
    ;; setter of the extracted array to the same arguments.
    (for-each (lambda (A B A-extract B-extract)
                (let ((A-setter (array-setter A))
                      (B-extract-setter (array-setter B-extract)))
                  (do ((i 0 (fx+ i 1)))
                      ((fx= i 100)
                       (test (myarray= spec-A spec-B)
                             #t)
                       (test (myarray= spec-A-extract spec-B-extract)
                             #t))
                    (if (not (interval-empty? subdomain))
                        (call-with-values
                            (lambda ()
                              (random-multi-index subdomain))
                          (lambda multi-index
                            (let ((val (test-random-real)))
                              (apply A-setter val multi-index)
                              (apply B-extract-setter val multi-index))))))))
              (list spec-A mut-A)
              (list spec-B mut-B)
              (list spec-A-extract mut-A-extract)
              (list spec-B-extract mut-B-extract))))

(next-test-random-source-state!)


(test (array-tile 'a '#(10))
      "array-tile: The first argument is not an array: ")
(test (array-tile (make-array (make-interval '#(0 0) '#(10 10)) list) 'a)
      "array-tile: The second argument is not a vector of the same length as the dimension of the array first argument: ")
(test (array-tile (make-array (make-interval '#(0 0) '#(10 10)) list) '#(a a))
      "array-tile: Axis 0 of the domain of the first argument has nonzero width, but element 0 of the second argument is neither an exact positive integer nor a vector of nonnegative exact integers summing to that width: ")
(test (array-tile (make-array (make-interval '#(0 0) '#(10 10)) list) '#(-1 1))
      "array-tile: Axis 0 of the domain of the first argument has nonzero width, but element 0 of the second argument is neither an exact positive integer nor a vector of nonnegative exact integers summing to that width: ")
(test (array-tile (make-array (make-interval '#(0 0) '#(10 10)) list) '#(10))
      "array-tile: The second argument is not a vector of the same length as the dimension of the array first argument: ")
(test (array-tile (make-array (make-interval '#(4)) list) '#(#(0 3 0 -1 2)))
      "array-tile: Axis 0 of the domain of the first argument has nonzero width, but element 0 of the second argument is neither an exact positive integer nor a vector of nonnegative exact integers summing to that width: ")
(test (array-tile (make-array (make-interval '#(4)) list) '#(#(0 3 0 0 2)))
      "array-tile: Axis 0 of the domain of the first argument has nonzero width, but element 0 of the second argument is neither an exact positive integer nor a vector of nonnegative exact integers summing to that width: ")

(test (array-tile (make-array (make-interval '#(0)) list) '#(2))
      "array-tile: Axis 0 of the domain of the first argument has width 0, but element 0 of the second argument is not a nonempty vector of exact zeros: ")

(do ((d 1 (fx+ d 1)))
     ((fx= d 6))
  (let* ((A (make-array (make-interval (make-vector d 100)) list))
         (B (array-tile A (make-vector d 10)))
         (index (make-list d 12)))
    (test (apply array-ref B (make-list d 12))
          "array-tile: domain does not contain multi-index: ")
    (test (apply array-ref B (make-list d 'a))
          "array-tile: multi-index component is not an exact integer: ")
    (if (< 4 d)
        (test (array-ref B 0 0 0 0)
              "array-tile: multi-index is not the correct dimension: "))))

(define (ceiling-quotient x d)
  ;; assumes x and d are positive
  (quotient (+ x d -1) d))

(define (my-array-tile array sidelengths)
  ;; an alternate definition more-or-less from the srfi document
  (let* ((domain
          (array-domain array))
         (lowers
          (%%interval-lower-bounds domain))
         (uppers
          (%%interval-upper-bounds domain))
         (result-lowers
          (vector-map (lambda (x)
                        0)
                      lowers))
         (result-uppers
          (vector-map (lambda (l u s)
                        (ceiling-quotient (- u l) s))
                      lowers uppers sidelengths)))
    (make-array (make-interval result-lowers result-uppers)
                (lambda i
                  (let* ((vec-i
                          (list->vector i))
                         (result-lowers
                          (vector-map (lambda (l i s)
                                        (+ l (* i s)))
                                      lowers vec-i sidelengths))
                         (result-uppers
                          (vector-map (lambda (l u i s)
                                        (min u (+ l (* (+ i 1) s))))
                                      lowers uppers vec-i sidelengths)))
                    (array-extract array
                                   (make-interval result-lowers result-uppers)))))))

;;; The array-block random tests also test array-tile.

(do ((i 0 (fx+ i 1)))
    ((fx= i random-tests))
  (let* ((domain
          (random-nonempty-interval))   ;; We use positive integers for the array-tile arguments here, so we need the domain to be nonempty.
         (array
          (let ((res (make-array domain list)))
            (case (test-random-integer 3)
              ;; immutable
              ((0) res)
              ;; specialized
              ((1) (array-copy res))
              (else
               ;; mutable, but not specialized
               (let ((res (array-copy res)))
                 (make-array domain (array-getter res) (array-setter res)))))))
         (lowers
          (%%interval-lower-bounds domain))
         (uppers
          (%%interval-upper-bounds domain))
         (sidelengths
          (vector-map (lambda (l u)
                        (let ((dim (- u l)))
                          (random 1 (ceiling-quotient (* dim 7) 5))))
                      lowers uppers))
         (result
          (array-tile array sidelengths))
         (test-result
          (my-array-tile array sidelengths)))

    ;; extract-array is tested independently, so we just make a few tests.

    ;; test all the subdomain tiles are the same
    (test (array-every (lambda (r t)
                         (equal? (array-domain r) (array-domain t)))
                       result test-result)
          #t)
    ;; test that the subarrays are the same type
    (test (array-every (lambda (r t)
                         (and
                          (eq? (mutable-array? r) (mutable-array? t))
                          (eq? (mutable-array? r) (mutable-array? array))
                          (eq? (specialized-array? r) (specialized-array? t))
                          (eq? (specialized-array? r) (specialized-array? array))))
                       result test-result)
          #t)
    ;; test that the first tile has the right values
    (test (myarray= (apply (array-getter result) (make-list (vector-length lowers) 0))
                    (apply (array-getter test-result) (make-list (vector-length lowers) 0)))
          #t)))

(next-test-random-source-state!)

(pp "array-reverse tests")

(test (array-reverse 'a)
      "array-reverse: The argument is not an array: ")

(test (array-reverse 'a 'a)
      "array-reverse: The first argument is not an array: ")

(test (array-reverse (make-array (make-interval '#(0 0) '#(2 2)) list)
                     'a)
      "array-reverse: The second argument is not a vector of booleans: ")

(test (array-reverse (make-array (make-interval '#(0 0) '#(2 2)) list)
                     '#(1 0))
      "array-reverse: The second argument is not a vector of booleans: ")

(test (array-reverse (make-array (make-interval '#(0 0) '#(2 2)) list)
                     '#(#t))
      "array-reverse: The dimension of the first argument (an array) does not equal the dimension of the second argument (a vector of booleans): ")


(define (myarray-reverse array flip?)
  (let* ((flips (vector->list flip?))
         (domain (array-domain array))
         (lowers (interval-lower-bounds->list domain))
         (uppers (interval-upper-bounds->list domain))
         (transform
          (lambda (multi-index)
            (map (lambda (i_k l_k u_k f_k?)
                   (if f_k?
                       (- (+ u_k l_k -1) i_k)
                       i_k))
                 multi-index lowers uppers flips))))
    (cond ((specialized-array? array)
           (specialized-array-share array
                                    domain
                                    (lambda multi-index
                                      (apply values (transform multi-index)))))
          ((mutable-array? array)
           (let ((getter (array-getter array))
                 (setter (array-setter array)))
             (make-array domain
                         (lambda multi-index
                           (apply getter (transform multi-index)))
                         (lambda (v . multi-index)
                           (apply setter v (transform multi-index))))))
          (else
           (let ((getter (array-getter array)))
             (make-array domain
                         (lambda multi-index
                           (apply getter (transform multi-index)))))))))


(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((domain (random-interval))
         (Array (let ((temp (make-array domain list)))
                  (case (test-random-integer 3)
                    ((0) temp)
                    ((1) (array-copy temp))
                    ((2) (let ((temp (array-copy temp)))
                           (make-array (array-domain temp)
                                       (array-getter temp)
                                       (array-setter temp)))))))
         (flips (vector-map (lambda (x) (random-boolean)) (make-vector (interval-dimension domain))))
         (reversed-array (array-reverse Array flips))
         (my-reversed-array (myarray-reverse Array flips)))

    (if (and (mutable-array? Array)
             (not (array-empty? Array)))
        (do ((j 0 (+ j 1)))
            ((= j 50))
          (call-with-values
              (lambda ()
                (random-multi-index domain))
            (lambda multi-index
              (let ((value (test-random-integer 10000)))
                (apply (array-setter reversed-array) value multi-index)
                (apply (array-setter my-reversed-array) value multi-index))))))
    (test (myarray= reversed-array
                    my-reversed-array)
          #t)))

(next-test-random-source-state!)

;; next test that the optional flip? argument is computed correctly.

(for-each (lambda (n)
            (let* ((upper-bounds (make-vector n 2))
                   (lower-bounds (make-vector n 0))
                   (domain (make-interval lower-bounds upper-bounds))
                   (A (array-copy (make-array domain list)))
                   (immutable-A
                    (let ((A (array-copy A))) ;; copy A
                      (make-array domain
                                  (array-getter A))))
                   (mutable-A
                    (let ((A (array-copy A))) ;; copy A
                      (make-array domain
                                  (array-getter A)
                                  (array-setter A))))
                   (flip? (make-vector n #t)))
              (let ((r1 (array-reverse A))
                    (r2 (array-reverse A flip?)))
                (if (not (and (specialized-array? r1)
                              (specialized-array? r2)
                              (myarray= r1 r2)))
                    (begin
                      (error "blah reverse specialized")
                      (pp 'crap))))
              (let ((r1 (array-reverse mutable-A))
                    (r2 (array-reverse mutable-A flip?)))
                (if (not (and (mutable-array? r1)
                              (mutable-array? r2)
                              (myarray= r1 r2)))
                    (begin
                      (error "blah reverse mutable")
                      (pp 'crap))))
              (let ((r1 (array-reverse immutable-A))
                    (r2 (array-reverse immutable-A flip?)))
                (if (not (and (array? r1)
                              (array? r2)
                              (myarray= r1 r2)))
                    (begin
                      (error "blah reverse immutable")
                      (pp 'crap))))))
          (iota 5 1))

(pp "array-assign! tests")

(test (array-assign! 'a 'a)
      "array-assign!: The destination is not a mutable array: ")

(test (array-assign! (make-array (make-interval '#(0 0) '#(1 1)) values) 'a)
      "array-assign!: The destination is not a mutable array: ")

(test (array-assign! (array-copy (make-array (make-interval '#(0 0) '#(1 1)) values)) 'a)
      "array-assign!: The source is not an array: ")

(test (array-assign! (array-copy (make-array (make-interval '#(0 0) '#(1 1)) values))
                     (make-array (make-interval '#(0 0) '#(2 1)) values))
      "array-assign: The destination and source do not have the same domains: ")

(test (array-assign! (make-array (make-interval '#(1 2)) list list) ;; not valid
                     (make-array (make-interval '#(0 0) '#(2 1)) values))
      "array-assign: The destination and source do not have the same domains: ")

(test (array-assign! (array-permute (array-copy (make-array (make-interval '#(2 3))
                                                           list))
                                    '#(1 0))
                     (make-array (make-interval '#(2 3)) list))
      "array-assign: The destination and source do not have the same domains: ")

(let ((destination (make-specialized-array (make-interval '#(3 2))))  ;; elements in order
      (source (array-permute (make-array (make-interval '#(3 2)) list) ;; not the same interval, but same volume
                             '#(1 0))))
  (test (array-assign! destination source)
        "array-assign: The destination and source do not have the same domains: "))



(do ((d 1 (fx+ d 1)))
    ((= d 6))
  (let* ((unsafe-specialized-destination
          (make-specialized-array (make-interval (make-vector d 10))
                                  u1-storage-class))
         (safe-specialized-destination
          (make-specialized-array (make-interval (make-vector d 10))
                                  u1-storage-class
                                  0
                                  #t))
         (mutable-destination
          (make-array (array-domain safe-specialized-destination)
                      (array-getter safe-specialized-destination)
                      (array-setter safe-specialized-destination)))
         (source
          (make-array (array-domain safe-specialized-destination)
                      (lambda args 100)))) ;; not 0 or 1
    (test (array-assign! unsafe-specialized-destination source) ;; should check anyway
          "array-assign!: Not all elements of the source can be stored in destination: ")
    (test (array-assign! safe-specialized-destination source)
          "array-assign!: Not all elements of the source can be stored in destination: ")
    (test (array-assign! mutable-destination source)
          "array-setter: value cannot be stored in body: ")))

(do ((i 0 (fx+ i 1)))
    ((fx= i random-tests))
  (let* ((interval
          (random-interval))
         (subinterval
          (random-subinterval interval))
         (storage-class-and-initializer
          (random-storage-class-and-initializer))
         (storage-class
          (car storage-class-and-initializer))
         (initializer
          (cadr storage-class-and-initializer))
         (specialized-array
          (array-copy
           (make-array interval initializer)
           storage-class))
         (mutable-array
          (let ((specialized-array
                 (array-copy
                  (make-array interval initializer)
                  storage-class)))
            (make-array interval
                        (array-getter specialized-array)
                        (array-setter specialized-array))))
         (specialized-subarray
          (array-extract specialized-array subinterval))
         (mutable-subarray
          (array-extract mutable-array subinterval))
         (new-subarray
          (array-copy
           (make-array subinterval initializer)
           storage-class)))
    ;; (pp specialized-array)
    (array-assign! specialized-subarray new-subarray)
    (array-assign! mutable-subarray new-subarray)
    (test (myarray= specialized-array
                    (make-array interval
                                (lambda multi-index
                                  (if (apply interval-contains-multi-index? subinterval multi-index)
                                      (apply (array-getter new-subarray) multi-index)
                                      (apply (array-getter specialized-array) multi-index)))))
          #t)
    (test (myarray= mutable-array
                    (make-array interval
                                (lambda multi-index
                                  (if (apply interval-contains-multi-index? subinterval multi-index)
                                      (apply (array-getter new-subarray) multi-index)
                                      (apply (array-getter mutable-array) multi-index)))))
          #t)))

(next-test-random-source-state!)

(pp "Miscellaneous error tests")

(test (make-array (make-interval '#(0 0) '#(10 10))
                  list
                  'a)
      "make-array: The third argument is not a procedure: ")

(test (array-dimension 'a)
      "array-dimension: The argument is not an array: ")

(test (array-safe?
       (array-copy (make-array (make-interval '#(0 0) '#(10 10)) list)
                   generic-storage-class
                   #t
                   #t))
      #t)


(test (array-safe?
       (array-copy (make-array (make-interval '#(0 0) '#(10 10)) list)
                   generic-storage-class
                   #t
                   #f))
      #f)

(let ((array-builders (vector (list u1-storage-class      (lambda indices (random (expt 2 1))) '(a -1))
                              (list u8-storage-class      (lambda indices (random (expt 2 8))) '(a -1))
                              (list u16-storage-class     (lambda indices (random (expt 2 16))) '(a -1))
                              (list u32-storage-class     (lambda indices (random (expt 2 32))) '(a -1))
                              (list u64-storage-class     (lambda indices (random (expt 2 64))) '(a -1))
                              (list s8-storage-class      (lambda indices (random (- (expt 2 7))  (expt 2 7))) `(a ,(expt 2 8)))
                              (list s16-storage-class     (lambda indices (random (- (expt 2 15)) (expt 2 15))) `(a ,(expt 2 16)))
                              (list s32-storage-class     (lambda indices (random (- (expt 2 31)) (expt 2 31))) `(a ,(expt 2 32)))
                              (list s64-storage-class     (lambda indices (random (- (expt 2 63)) (expt 2 63))) `(a ,(expt 2 64)))
                              (list f16-storage-class     (lambda indices (test-random-real)) `(a 1))
                              (list f32-storage-class     (lambda indices (test-random-real)) `(a 1))
                              (list f64-storage-class     (lambda indices (test-random-real)) `(a 1))
                              (list char-storage-class    (lambda indices (random-char)) `(a 1))
                              (list c64-storage-class     (lambda indices (make-rectangular (test-random-real) (test-random-real))) `(a 1))
                              (list c128-storage-class    (lambda indices (make-rectangular (test-random-real) (test-random-real))) `(a 1))
                              )))
  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain (random-nonempty-interval))  ;; we're testing invalid arguments, so no zero-dimensional arrays
           (builders (vector-ref array-builders (test-random-integer (vector-length array-builders))))
           (storage-class (car builders))
           (random-entry (cadr builders))
           (invalid-entry (list-ref (caddr builders) (random 2)))
           (Array (array-copy (make-array domain random-entry)
                              storage-class
                              #t   ; mutable
                              #t)) ; safe
           (getter (array-getter Array))
           (setter (array-setter Array))
           (dimension (interval-dimension domain))
           (valid-args (call-with-values
                           (lambda ()
                             (random-multi-index domain))
                         list)))
      (test (apply setter invalid-entry valid-args)
            "array-setter: value cannot be stored in body: ")
      (if (positive? dimension)
          (begin
            (set-car! valid-args 'a)
            (test (apply getter valid-args)
                  "array-getter: multi-index component is not an exact integer: ")
            (test (apply setter 10 valid-args)
                  "array-setter: multi-index component is not an exact integer: ")
            (set-car! valid-args 10000) ;; outside the range of any random-interval
            (test (apply getter valid-args)
                  "array-getter: domain does not contain multi-index: ")
            (test (apply setter 10 valid-args)
                  "array-setter: domain does not contain multi-index: ")))
      (if (< 4 dimension)
          (begin
            (set! valid-args (cons 1 valid-args))
            (test (apply getter valid-args)
                  "array-getter: multi-index is not the correct dimension: ")
            (test (apply setter 10 valid-args)
                  "array-setter: multi-index is not the correct dimension: "))))))

(next-test-random-source-state!)

(pp "array->list, array->vector and list->array, vector->array")

(test (array->list 'a)
      "array->list: The argument is not an array: ")

(test (array->vector 'a)
      "array->vector: The argument is not an array: ")

(let* ((multi-indices
        '())
       (a
        (make-array (make-interval '#(3 5))
                    (lambda (i j)
                      (set! multi-indices (cons (list i j) multi-indices))
                      (+ j (* i 5)))))
       (result
        (array->list a))
       (correct-multi-indices
        (let ((result '()))
          (interval-for-each (lambda (i j)
                               (set! result (cons (list i j) result)))
                             (array-domain a))
          result)))
  (test result (iota 15))
  (test multi-indices correct-multi-indices))

(for-each (lambda (function arg name name2)
            (test (function 'b arg)
                  (string-append name "The first argument is not an interval: "))
            (test (function (make-interval '#(0) '#(1)) 'b)
                  (string-append name "The second argument is not a " name2 ": "))
            (test (function (make-interval '#(0) '#(1)) arg 'a)
                  (string-append name "The third argument is not a storage-class: "))
            (test (function (make-interval '#(0) '#(1)) arg generic-storage-class 'a)
                  (string-append name "The fourth argument is not a boolean: "))
            (test (function (make-interval '#(0) '#(1)) arg generic-storage-class #t 'a)
                  (string-append name "The fifth argument is not a boolean: "))
            (test (function (make-interval '#(0) '#(10)) arg)
                  (string-append name "The volume of the first argument does not equal the length of the second: "))
            (test (function (make-interval '#(0) '#(1)) arg u1-storage-class)
                  (string-append name "Not all elements of the source can be stored in destination: "))
            (test (function (make-interval '#(10)) arg)
                  (string-append name "The volume of the first argument does not equal the length of the second: ")))
          (list list->array vector->array)
          '((10) #(10))
          '("list->array: " "vector->array: ")
          '("list" "vector"))


(let ((array-builders (vector (list u1-storage-class      (lambda indices (random 0 (expt 2 1))))
                              (list u8-storage-class      (lambda indices (random 0 (expt 2 8))))
                              (list u16-storage-class     (lambda indices (random 0 (expt 2 16))))
                              (list u32-storage-class     (lambda indices (random 0 (expt 2 32))))
                              (list u64-storage-class     (lambda indices (random 0 (expt 2 64))))
                              (list s8-storage-class      (lambda indices (random (- (expt 2 7))  (expt 2 7))))
                              (list s16-storage-class     (lambda indices (random (- (expt 2 15)) (expt 2 15))))
                              (list s32-storage-class     (lambda indices (random (- (expt 2 31)) (expt 2 31))))
                              (list s64-storage-class     (lambda indices (random (- (expt 2 63)) (expt 2 63))))
                              (list f16-storage-class     (lambda indices (test-random-real)))
                              (list f32-storage-class     (lambda indices (test-random-real)))
                              (list f64-storage-class     (lambda indices (test-random-real)))
                              (list char-storage-class    (lambda indices (random-char)))
                              (list c64-storage-class     (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list c128-storage-class    (lambda indices (make-rectangular (test-random-real) (test-random-real))))
                              (list generic-storage-class (lambda indices indices)))))
  (do ((i 0 (+ i 1)))
      ((= i random-tests))
    (let* ((domain (random-interval))
           (builders (vector-ref array-builders (test-random-integer (vector-length array-builders))))
           (storage-class (car builders))
           (random-entry (cadr builders))
           (Array (array-copy (make-array domain random-entry)
                              storage-class
                              #f
                              #t)) ; safe
           (l (array->list Array))
           (mutable? (zero? (test-random-integer 2)))
           (new-list-array (list->array domain l storage-class mutable?))
           (new-vector-array (vector->array domain (list->vector l) storage-class mutable?)))
      (test (myarray= Array new-list-array)
            #t)
      (test (myarray= Array new-vector-array)
            #t))))

(next-test-random-source-state!)

(pp "interval-cartesian-product and array-outer-product")

(define (my-interval-cartesian-product . args)
  (make-interval (list->vector (apply append (map interval-lower-bounds->list args)))
                 (list->vector (apply append (map interval-upper-bounds->list args)))))

(test (interval-cartesian-product 'a)
      "interval-cartesian-product: Not all arguments are intervals: ")

(test (interval-cartesian-product (make-interval '#(0) '#(1)) 'a)
      "interval-cartesian-product: Not all arguments are intervals: ")

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((intervals
          (map (lambda (ignore)
                 (random-interval 1 4))
               (make-list (random 4)))))
    (test (apply interval-cartesian-product intervals)
          (apply my-interval-cartesian-product intervals))))

(next-test-random-source-state!)

(let ((test-array (make-array  (make-interval '#(0) '#(1)) list)))

  (test (array-outer-product 'a test-array test-array)
        "array-outer-product: The first argument is not a procedure: ")

  (test (array-outer-product append 'a test-array)
        "array-outer-product: The second argument is not an array: ")

  (test (array-outer-product append test-array 'a)
        "array-outer-product: The third argument is not an array: "))

(let* ((A (make-array (make-interval '#(0 10)) list))
       (B (make-array (make-interval '#(10 0)) list))
       (A*B (array-outer-product cons A B)))
  (test ((array-getter A*B) 0 0 0 0) ;; outside of domain
        "array-getter: Array domain is empty: "))


(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((arrays
          (map (lambda (ignore)
                 (make-array (random-interval 0 5) list))
               (make-list 2))))
    (myarray= (apply array-outer-product append arrays)
                    (make-array (apply my-interval-cartesian-product (map array-domain arrays))
                                list))
    (test (myarray= (apply array-outer-product append arrays)
                    (make-array (apply my-interval-cartesian-product (map array-domain arrays))
                                list))
          #t)))

(next-test-random-source-state!)


(pp "array-ref and array-set! tests")

(specialized-array-default-safe? #t)

(define A-ref
  (array-copy
   (make-array (make-interval '#(10 10))
               (lambda (i j) (if (= i j) 1 0)))))

(do ((i 1 (+ i 1)))
    ((= i 6))
  (test (apply array-ref 1 (make-list i 0))
        "array-ref: The first argument is not an array: "))

(test (array-ref A-ref 1)
      "Wrong number of arguments passed to procedure ")

(test (array-ref A-ref 1 1001)
      "array-getter: domain does not contain multi-index: ")

(test (array-ref A-ref 4 4)
      1)

(test (array-ref A-ref 4 5)
      0)

(do ((d 0 (+ d 1)))
    ((= d 6))
  (let ((A (make-specialized-array (make-interval (make-vector d 1)) generic-storage-class 42)))
    (test (apply array-ref A (make-list d 0))
          42)
    (test (apply array-ref 2 (make-list d 0))
          (if (zero? d)
              "array-ref: The argument is not an array: "
              "array-ref: The first argument is not an array: "))))

(test (array-ref (make-specialized-array (make-interval '#(0 0)) generic-storage-class 42) 0 0)
      "array-getter: Array domain is empty: ")

(test (array-set! (make-specialized-array (make-interval '#(0 0)) generic-storage-class 42) 42 0 0)
      "array-setter: Array domain is empty: ")

(define B-set!
  (array-copy
   (make-array (make-interval '#(10 10))
               (lambda (i j) (if (= i j) 1 0)))
   u1-storage-class))

(test (array-set! 1 1 1)
      "array-set!: The first argument is not a mutable array: ")

(test (array-set! B-set!)
      "Wrong number of arguments passed to procedure ")

(test (array-set! B-set! 2)
      "Wrong number of arguments passed to procedure ")

(test (array-set! B-set! 2 1)
      "Wrong number of arguments passed to procedure ")

(test (array-set! B-set! 2 1 1)
      "array-setter: value cannot be stored in body: ")

(array-set! B-set! 1 1 2)
(array-set! B-set! 0 2 2)
'(array-display B-set!)

(do ((d 0 (+ d 1)))
    ((= d 6))
  (let ((A (make-specialized-array (make-interval (make-vector d 1)) generic-storage-class 10)))
    (apply array-set! A 42 (make-list d 0))
    (test (apply array-ref A (make-list d 0))
          42)
    (test (apply array-set! 2 42 (make-list d 0))
          "array-set!: The first argument is not a mutable array: ")))

(specialized-array-default-safe? #f)

(define A-ref
  (array-copy
   (make-array (make-interval '#(10 10))
               (lambda (i j) (if (= i j) 1 0)))))

(do ((i 1 (+ i 1)))
    ((= i 6))
  (test (apply array-ref 1 (make-list i 0))
        "array-ref: The first argument is not an array: "))

(test (array-ref A-ref 1)
      "Wrong number of arguments passed to procedure ")

#|
   For unsafe arrays, this error will not be caught, and could crash the program.
|#
#;
(test (array-ref A-ref 1 1001)
      "array-getter: domain does not contain multi-index: ")

(test (array-ref A-ref 4 4)
      1)

(test (array-ref A-ref 4 5)
      0)

(do ((d 0 (+ d 1)))
    ((= d 6))
  (let ((A (make-specialized-array (make-interval (make-vector d 1)) generic-storage-class 42)))
    (test (apply array-ref A (make-list d 0))
          42)
    (test (apply array-ref 2 (make-list d 0))
          (if (zero? d)
              "array-ref: The argument is not an array: "
              "array-ref: The first argument is not an array: "))))

(test (array-ref (make-specialized-array (make-interval '#(0 0)) generic-storage-class 42) 0 0)
      "array-getter: Array domain is empty: ")

(test (array-set! (make-specialized-array (make-interval '#(0 0)) generic-storage-class 42) 42 0 0)
      "array-setter: Array domain is empty: ")

(define B-set!
  (array-copy
   (make-array (make-interval '#(10 10))
               (lambda (i j) (if (= i j) 1 0)))
   u1-storage-class))

(test (array-set! 1 1 1)
      "array-set!: The first argument is not a mutable array: ")

(test (array-set! B-set!)
      "Wrong number of arguments passed to procedure ")

(test (array-set! B-set! 2)
      "Wrong number of arguments passed to procedure ")

(test (array-set! B-set! 2 1)
      "Wrong number of arguments passed to procedure ")

#|
   For unsafe arrays, this error will not be caught, and could crash the program.
|#
#;
(test (array-set! B-set! 2 1 1)
      "array-setter: value cannot be stored in body: ")

(array-set! B-set! 1 1 2)
(array-set! B-set! 0 2 2)
;;; (array-display B-set!)

(do ((d 0 (+ d 1)))
    ((= d 6))
  (let ((A (make-specialized-array (make-interval (make-vector d 1)) generic-storage-class 10)))
    (apply array-set! A 42 (make-list d 0))
    (test (apply array-ref A (make-list d 0))
          42)
    (test (apply array-set! 2 42 (make-list d 0))
          "array-set!: The first argument is not a mutable array: ")))




(pp "specialized-array-reshape tests")

(test (specialized-array-reshape 'a 1)
      "specialized-array-reshape: The first argument is not a specialized array: ")

(test (specialized-array-reshape A-ref 'a)
      "specialized-array-reshape: The second argument is not an interval ")

(test (specialized-array-reshape A-ref (make-interval '#(5)))
      "specialized-array-reshape: The volume of the domain of the first argument is not equal to the volume of the second argument: ")

(test (specialized-array-reshape A-ref (make-interval '#(100)) 'a)
      "specialized-array-reshape: The third argument is not a boolean: ")

(let ((array (array-copy (make-array (make-interval '#(2 1 3 1)) list))))
  (test (array->list array)
        (array->list (specialized-array-reshape array (make-interval '#(6))))))

(let ((array (array-copy (make-array (make-interval '#(2 1 3 1)) list))))
  (test (array->list array)
        (array->list (specialized-array-reshape array (make-interval '#(3 2))))))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)))))
  (test (array->list array)
        (array->list (specialized-array-reshape array (make-interval '#(6))))))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)))))
  (test (array->list (specialized-array-reshape array (make-interval '#(3 2))))
        (array->list array)))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #f #t))))
  (test (array->list (specialized-array-reshape array (make-interval '#(3 2))))
        (array->list array)))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #f #t))))
  (test (array->list (specialized-array-reshape array (make-interval '#(3 1 2))))
        (array->list array)))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #f #t))))
  (test (array->list (specialized-array-reshape array (make-interval '#(1 1 1 3 2))))
        (array->list array)))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #f #t))))
  (test (array->list (specialized-array-reshape array (make-interval '#(3 2 1 1 1))))
        (array->list array)))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #f #t))))
  (test (array->list (specialized-array-reshape array (make-interval '#(3 1 1 2))))
        (array->list array)))

(let ((array (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #f #t))))
  (test (array->list (specialized-array-reshape array (make-interval '#(3 1 2 1))))
        (array->list array)))

(let ((array (array-sample (array-reverse (array-copy (make-array (make-interval '#(2 1 4 1)) list)) '#(#f #f #f #t)) '#(1 1 2 1))))
  (test (array->list (specialized-array-reshape array (make-interval '#(4))))
        (array->list array)))

(let ((array (array-sample (array-reverse (array-copy (make-array (make-interval '#(2 1 4 1)) list)) '#(#t #f #t #t)) '#(1 1 2 1))))
  (test (array->list (specialized-array-reshape array (make-interval '#(4))))
        (array->list array)))

(test (specialized-array-reshape (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#t #f #f #f)) (make-interval '#(6)))
      "specialized-array-reshape: Requested reshaping is impossible: ")

(test (specialized-array-reshape (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#t #f #f #f)) (make-interval '#(3 2)))
      "specialized-array-reshape: Requested reshaping is impossible: ")

(test (specialized-array-reshape (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #t #f)) (make-interval '#(6)))
      "specialized-array-reshape: Requested reshaping is impossible: ")

(test (specialized-array-reshape (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #t #t)) (make-interval '#(3 2)))
      "specialized-array-reshape: Requested reshaping is impossible: ")

(test (specialized-array-reshape (array-sample (array-reverse (array-copy (make-array (make-interval '#(2 1 3 1)) list)) '#(#f #f #f #t)) '#(1 1 2 1)) (make-interval '#(4)))
      "specialized-array-reshape: Requested reshaping is impossible: ")

(test (specialized-array-reshape (array-sample (array-reverse (array-copy (make-array (make-interval '#(2 1 4 1)) list)) '#(#f #f #t #t)) '#(1 1 2 1)) (make-interval '#(4)))
      "specialized-array-reshape: Requested reshaping is impossible: ")

(test (array? (specialized-array-reshape (make-specialized-array (make-interval '#(1 2 0 4)))
                                         (make-interval '#(2 0 4))))
      #t)

(pp "Test code from the SRFI document")

(test (interval= (interval-dilate (make-interval '#(100 100)) '#(1 1) '#(1 1))
                 (make-interval '#(1 1) '#(101 101)))
      #t)

(test (interval= (interval-dilate (make-interval '#(100 100)) '#(-1 -1) '#(1 1))
                 (make-interval '#(-1 -1) '#(101 101)))
      #t)

(test (interval= (interval-dilate (make-interval '#(100 100))  '#(0 0) '#(-50 -50))
                 (make-interval '#(50 50)))
      #t)

(test (interval-dilate (make-interval '#(100 100)) '#(0 0) '#(-500 -50))
      "interval-dilate: Some resulting lower bounds are greater than corresponding upper bounds: ")

(define a (make-array (make-interval '#(1 1) '#(11 11))
                      (lambda (i j)
                        (if (= i j)
                            1
                            0))))

(test ((array-getter a) 3 3)
      1)

(test ((array-getter a) 2 3)
      0)

;; ((array-getter a) 11 0) is an error, but it isn't signalled

(define a (make-array (make-interval '#(0 0) '#(10 10))
                      list))

(test ((array-getter a) 3 4)
      '(3 4))

(define curried-a (array-curry a 1))

(test ((array-getter ((array-getter curried-a) 3)) 4)
      '(3 4))

(define sparse-array
  (let ((domain (make-interval '#(1000000 1000000)))
        (sparse-rows (make-vector 1000000 '())))
    (make-array domain
                (lambda (i j)
                  (cond ((assv j (vector-ref sparse-rows i))
                         => cdr)
                        (else
                         0.0)))
                (lambda (v i j)
                  (cond ((assv j (vector-ref sparse-rows i))
                         => (lambda (pair)
                              (set-cdr! pair v)))
                        (else
                         (vector-set! sparse-rows i (cons (cons j v) (vector-ref sparse-rows i)))))))))

(test ((array-getter sparse-array) 12345 6789)
      0.)

(test ((array-getter sparse-array) 0 0)
      0.)

((array-setter sparse-array) 1.0 0 0)

(test ((array-getter sparse-array) 12345 6789)
      0.)

(test ((array-getter sparse-array) 0 0)
      1.)
#|
(let ()
  (define a
    (array-copy
     (make-array (make-interval '#(5 10))
                 list)))
  (define b
    (specialized-array-share
     a
     (make-interval '#(5 5))
     (lambda (i j)
       (values i (+ i j)))))
  ;; Print the \"rows\" of b
  (array-for-each (lambda (row)
                    (pretty-print (array->list row)))
                  (array-curry b 1))

  ;; which prints
  ;; ((0 0) (0 1) (0 2) (0 3) (0 4))
  ;; ((1 1) (1 2) (1 3) (1 4) (1 5))
  ;; ((2 2) (2 3) (2 4) (2 5) (2 6))
  ;; ((3 3) (3 4) (3 5) (3 6) (3 7))
  ;; ((4 4) (4 5) (4 6) (4 7) (4 8))
  )

(define (palindrome? s)
  (let* ((n
          (string-length s))
         (a
          ;; an array accessing the characters of s
          (make-array (make-interval (vector n))
                      (lambda (i)
                        (string-ref s i))))
         (ra
          ;; the characters accessed in reverse order
          (array-reverse a))
         (half-domain
          (make-interval (vector (quotient n 2)))))
    ;; If n is 0 or 1 the following extracted arrays
    ;; are empty.
    (array-every
     char=?
     ;; the first half of s
     (array-extract a half-domain)
     ;; the reversed second half of s
     (array-extract ra half-domain))))

(for-each (lambda (s)
            (for-each display
                      (list "(palindrome? \""
                            s
                            "\") => "
                            (palindrome? s)
                            #\newline)))
          '("" "a" "aa" "ab" "aba" "abc" "abba" "abca" "abbc"))
|#

(let ((a (make-array (make-interval '#(10)) (lambda (i) i))))
  (test (array-fold-left cons '() a)
        '((((((((((() . 0) . 1) . 2) . 3) . 4) . 5) . 6) . 7) . 8) . 9))
  (test (array-fold-right cons '() a)
        '(0 1 2 3 4 5 6 7 8 9))
  (test (array-fold-left - 0 a)
        -45)
  (test (array-fold-right - 0 a)
        -5))

#|
(define make-pgm   cons)
(define pgm-greys  car)
(define pgm-pixels cdr)

(define (read-pgm file)

  (define (read-pgm-object port)
    (skip-white-space port)
    (let ((o (read port)))
      (read-char port) ; to skip the newline or next whitespace
      (if (eof-object? o)
          (error "reached end of pgm file")
          o)))

  (define (skip-to-end-of-line port)
    (let loop ((ch (read-char port)))
      (if (not (eqv? ch #\newline))
          (loop (read-char port)))))

  (define (white-space? ch)
    (case ch
      ((#\newline #\space #\tab) #t)
      (else #f)))

  (define (skip-white-space port)
    (let ((ch (peek-char port)))
      (cond ((white-space? ch) (read-char port) (skip-white-space port))
            ((eqv? ch #\#) (skip-to-end-of-line port)(skip-white-space port))
            (else #f))))

  (call-with-input-file
      (list path:          file
            char-encoding: 'ISO-8859-1
            eol-encoding:  'lf)
    (lambda (port)

      ;; We're going to read text for a while,
      ;; then switch to binary.
      ;; So we need to turn off buffering until
      ;; we switch to binary.

      (port-settings-set! port '(buffering: #f))

      (let* ((header (read-pgm-object port))
             (columns (read-pgm-object port))
             (rows (read-pgm-object port))
             (greys (read-pgm-object port)))

        ;; now we switch back to buffering
        ;; to speed things up

        (port-settings-set! port '(buffering: #t))

        (make-pgm greys
                  (array-copy
                   (make-array
                    (make-interval (vector rows columns))
                    (cond ((or (eq? header 'p5)                                     ;; pgm binary
                               (eq? header 'P5))
                           (if (< greys 256)
                               (lambda (i j)                                        ;; one byte/pixel
                                 (char->integer (read-char port)))
                               (lambda (i j)                                        ;; two bytes/pixel, little-endian
                                 (let* ((first-byte (char->integer (read-char port)))
                                        (second-byte (char->integer (read-char port))))
                                   (+ (* second-byte 256) first-byte)))))
                          ((or (eq? header 'p2)                                     ;; pgm ascii
                               (eq? header 'P2))
                           (lambda (i j)
                             (read port)))
                          (else
                           (error "read-pgm: not a pgm file"))))))))))

(define (write-pgm pgm-data file #!optional force-ascii)
  (call-with-output-file
      (list path:          file
            char-encoding: 'ISO-8859-1
            eol-encoding:  'lf)
    (lambda (port)
      (let* ((greys
              (pgm-greys pgm-data))
             (pgm-array
              (pgm-pixels pgm-data))
             (domain
              (array-domain pgm-array))
             (rows
              (fx- (interval-upper-bound domain 0)
                   (interval-lower-bound domain 0)))
             (columns
              (fx- (interval-upper-bound domain 1)
                   (interval-lower-bound domain 1))))
        (if force-ascii
            (display "P2" port)
            (display "P5" port))
        (newline port)
        (display columns port) (display " " port)
        (display rows port) (newline port)
        (display greys port) (newline port)
        (array-for-each (if force-ascii
                            (let ((next-pixel-in-line 1))
                              (lambda (p)
                                (write p port)
                                (if (fxzero? (fxand next-pixel-in-line 15))
                                    (begin
                                      (newline port)
                                      (set! next-pixel-in-line 1))
                                    (begin
                                      (display " " port)
                                      (set! next-pixel-in-line (fx+ 1 next-pixel-in-line))))))
                            (if (fx< greys 256)
                                (lambda (p)
                                  (write-u8 p port))
                                (lambda (p)
                                  (write-u8 (fxand p 255) port)
                                  (write-u8 (fxarithmetic-shift-right p 8) port))))
                        pgm-array)))))

(define test-pgm (read-pgm "girl.pgm"))

(define (array-convolve source filter)
  (let* ((source-domain
          (array-domain source))
         (S_
          (array-getter source))
         (filter-domain
          (array-domain filter))
         (F_
          (array-getter filter))
         (result-domain
          (interval-dilate
           source-domain
           ;; left bound of an interval is an equality,
           ;; right bound is an inequality, hence the
           ;; the difference in the following two expressions
           (vector-map -
                       (interval-lower-bounds->vector filter-domain))
           (vector-map (lambda (x)
                         (- 1 x))
                       (interval-upper-bounds->vector filter-domain)))))
    (make-array result-domain
                (lambda (i j)
                  (array-fold-left
                   (lambda (p q)
                     (+ p q))
                   0
                   (make-array
                    filter-domain
                    (lambda (k l)
                      (* (S_ (+ i k)
                             (+ j l))
                         (F_ k l)))))))))

(define sharpen-filter
  (list->array
   (make-interval '#(-1 -1) '#(2 2))
   '(0 -1  0
    -1  5 -1
     0 -1  0)))

(define edge-filter
  (list->array
   (make-interval '#(-1 -1) '#(2 2))
   '(0 -1  0
    -1  4 -1
     0 -1  0)))

(define (round-and-clip pixel max-grey)
  (max 0 (min (exact (round pixel)) max-grey)))

'(time
 (let ((greys (pgm-greys test-pgm)))
   (write-pgm
    (make-pgm
     greys
     (array-map (lambda (p)
                  (round-and-clip p greys))
                (array-convolve
                 (pgm-pixels test-pgm)
                 sharpen-filter)))
    "sharper-test.pgm")))

'(time
 (let* ((greys (pgm-greys test-pgm))
        (edge-array
         (array-copy
          (array-map
           abs
           (array-convolve
            (pgm-pixels test-pgm)
            edge-filter))))
        (max-pixel
         (array-fold-left max 0 edge-array))
        (normalizer
         (inexact (/ greys max-pixel))))
   (write-pgm
    (make-pgm
     greys
     (array-map (lambda (p)
                  (- greys
                     (round-and-clip (* p normalizer) greys)))
                edge-array))
    "edge-test.pgm")))


(define m (array-copy (make-array (make-interval '#(0 0) '#(40 30)) (lambda (i j) (exact->inexact (+ i j))))))

(define (array-sum a)
  (array-fold-left + 0 a))
(define (array-max a)
  (array-fold-left max -inf.0 a))

(define (max-norm a)
  (array-max (array-map abs a)))
(define (one-norm a)
  (array-sum (array-map abs a)))

(define (operator-max-norm a)
  (max-norm (array-map one-norm (array-curry (array-permute a '#(1 0)) 1))))
(define (operator-one-norm a)
  ;; The "permutation" to apply here is the identity, so we omit it.
  (max-norm (array-map one-norm (array-curry a 1))))

(test (operator-max-norm m) 1940.)

(test (operator-one-norm m) 1605.)

(define (all-second-differences image direction)
  (let ((image-domain (array-domain image)))
    (let loop ((i 1)
               (result '()))
      (let ((negative-scaled-direction
             (vector-map (lambda (j) (* -1 j i)) direction))
            (twice-negative-scaled-direction
             (vector-map (lambda (j) (* -2 j i)) direction)))
        (cond ((interval-intersect image-domain
                                    (interval-translate image-domain negative-scaled-direction)
                                    (interval-translate image-domain twice-negative-scaled-direction))
               => (lambda (subdomain)
                    (loop (+ i 1)
                          (cons (array-copy
                                 (array-map (lambda (f_i f_i+d f_i+2d)
                                              (+ f_i+2d
                                                 (* -2. f_i+d)
                                                 f_i))
                                            (array-extract image
                                                           subdomain)
                                            (array-extract (array-translate image
                                                                            negative-scaled-direction)
                                                           subdomain)
                                            (array-extract (array-translate image
                                                                            twice-negative-scaled-direction)
                                                           subdomain)))
                                result))))
              (else
               (reverse result)))))))

(define image (array-copy (make-array (make-interval '#(8 8))
                                      (lambda (i j)
                                        (exact->inexact (+ (* i i) (* j j)))))))

(define (expose difference-images)
  (pretty-print (map (lambda (difference-image)
                       (list (array-domain difference-image)
                             (array->list* difference-image)))
                     difference-images)))
(begin
  (display "\nOriginal image:\n")
  (pretty-print (list (array-domain image)
                      (array->list* image)))
  (display "\nSecond-difference images in the direction $k\\times (1,0)$, $k=1,2,...$, wherever they're defined:\n")
  (expose (all-second-differences image '#(1 0)))
  (display "\nSecond-difference images in the direction $k\\times (1,1)$, $k=1,2,...$, wherever they're defined:\n")
  (expose (all-second-differences image '#(1 1)))
  (display "\nSecond-difference images in the direction $k\\times (1,-1)$, $k=1,2,...$, wherever they're defined:\n")
  (expose (all-second-differences image '#(1 -1))))

(define (make-separable-transform 1D-transform)
  (lambda (a)
    (let ((n (array-dimension a)))
      (do ((d 0 (fx+ d 1)))
          ((fx= d n))
        (array-for-each
         1D-transform
         (array-curry (array-permute a (index-last n d)) 1))))))

(define (recursively-apply-transform-and-downsample transform)
  (lambda (a)
    (let ((sample-vector (make-vector (array-dimension a) 2)))
      (define (helper a)
        (if (fx< 1 (interval-upper-bound (array-domain a) 0))
            (begin
              (transform a)
              (helper (array-sample a sample-vector)))))
      (helper a))))

(define (recursively-downsample-and-apply-transform transform)
  (lambda (a)
    (let ((sample-vector (make-vector (array-dimension a) 2)))
      (define (helper a)
        (if (fx< 1 (interval-upper-bound (array-domain a) 0))
            (begin
              (helper (array-sample a sample-vector))
              (transform a))))
      (helper a))))

(define (1D-Haar-loop a)
  (let ((a_ (array-getter a))
        (a! (array-setter a))
        (n (interval-upper-bound (array-domain a) 0)))
    (do ((i 0 (fx+ i 2)))
        ((fx= i n))
      (let* ((a_i               (a_ i))
             (a_i+1             (a_ (fx+ i 1)))
             (scaled-sum        (fl/ (fl+ a_i a_i+1) (flsqrt 2.0)))
             (scaled-difference (fl/ (fl- a_i a_i+1) (flsqrt 2.0))))
        (a! scaled-sum i)
        (a! scaled-difference (fx+ i 1))))))

(define 1D-Haar-transform
  (recursively-apply-transform-and-downsample 1D-Haar-loop))

(define 1D-Haar-inverse-transform
  (recursively-downsample-and-apply-transform 1D-Haar-loop))

(define hyperbolic-Haar-transform
  (make-separable-transform 1D-Haar-transform))

(define hyperbolic-Haar-inverse-transform
  (make-separable-transform 1D-Haar-inverse-transform))

(define Haar-transform
  (recursively-apply-transform-and-downsample
   (make-separable-transform 1D-Haar-loop)))

(define Haar-inverse-transform
  (recursively-downsample-and-apply-transform
   (make-separable-transform 1D-Haar-loop)))

(let ((image
       (array-copy
        (make-array (make-interval '#(4 4))
                    (lambda (i j)
                      (case i
                        ((0) 1.)
                        ((1) -1.)
                        (else 0.)))))))
  (display "\nInitial image: \n")
  (pretty-print (list (array-domain image)
                      (array->list* image)))
  (hyperbolic-Haar-transform image)
  (display "\nArray of hyperbolic Haar wavelet coefficients: \n")
  (pretty-print (list (array-domain image)
                      (array->list* image)))
  (hyperbolic-Haar-inverse-transform image)
  (display "\nReconstructed image: \n")
  (pretty-print (list (array-domain image)
                      (array->list* image))))


(let ((image
       (array-copy
        (make-array (make-interval '#(4 4))
                    (lambda (i j)
                      (case i
                        ((0) 1.)
                        ((1) -1.)
                        (else 0.)))))))
  (display "\nInitial image: \n")
  (pretty-print (list (array-domain image)
                      (array->list* image)))
  (Haar-transform image)
  (display "\nArray of Haar wavelet coefficients: \n")
  (pretty-print (list (array-domain image)
                      (array->list* image)))
  (Haar-inverse-transform image)
  (display "\nReconstructed image: \n")
  (pretty-print (list (array-domain image)
                      (array->list* image))))

(define (LU-decomposition A)
  ;; Assumes the domain of A is [0,n)\\times [0,n)
  ;; and that Gaussian elimination can be applied
  ;; without pivoting.
  (let ((n
         (interval-upper-bound (array-domain A) 0))
        (A_
         (array-getter A)))
    (do ((i 0 (fx+ i 1)))
        ((= i (fx- n 1)) A)
      (let* ((pivot
              (A_ i i))
             (column/row-domain
              ;; both will be one-dimensional
              (make-interval (vector (+ i 1))
                             (vector n)))
             (column
              ;; the column below the (i,i) entry
              (specialized-array-share A
                                       column/row-domain
                                       (lambda (k)
                                         (values k i))))
             (row
              ;; the row to the right of the (i,i) entry
              (specialized-array-share A
                                       column/row-domain
                                       (lambda (k)
                                         (values i k))))

             ;; the subarray to the right and
             ;;below the (i,i) entry
             (subarray
              (array-extract
               A (make-interval
                  (vector (fx+ i 1) (fx+ i 1))
                  (vector n         n)))))
        ;; compute multipliers
        (array-assign!
         column
         (array-map (lambda (x)
                      (/ x pivot))
                    column))
        ;; subtract the outer product of i'th
        ;; row and column from the subarray
        (array-assign!
         subarray
         (array-map -
                    subarray
                    (array-outer-product * column row)))))))


(define A
  ;; A Hilbert matrix
  (array-copy
   (make-array (make-interval '#(4 4))
               (lambda (i j)
                 (/ (+ 1 i j))))))

(display "\nHilbert matrix:\n\n")
(array-display A)

(LU-decomposition A)

(display "\nLU decomposition of Hilbert matrix:\n\n")

(array-display A)

;;; Functions to extract the lower- and upper-triangular
;;; matrices of the LU decomposition of A.

(define (L a)
  (let ((a_ (array-getter a))
        (d  (array-domain a)))
    (make-array
     d
     (lambda (i j)
       (cond ((= i j) 1)        ;; diagonal
             ((> i j) (a_ i j)) ;; below diagonal
             (else 0))))))      ;; above diagonal

(define (U a)
  (let ((a_ (array-getter a))
        (d  (array-domain a)))
    (make-array
     d
     (lambda (i j)
       (cond ((<= i j) (a_ i j)) ;; diagonal and above
             (else 0))))))       ;; below diagonal

(display "\nLower triangular matrix of decomposition of Hilbert matrix:\n\n")
(array-display (L A))

(display "\nUpper triangular matrix of decomposition of Hilbert matrix:\n\n")
(array-display (U A))

;;; We'll define a brief, not-very-efficient matrix multiply routine.

(define (matrix-multiply a b)
  (array-inner-product a + * b))

;;; We'll check that the product of the result of LU
;;; decomposition of A is again A.

(define product (matrix-multiply (L A) (U A)))

(display "\nProduct of lower and upper triangular matrices ")
(display "of LU decomposition of Hilbert matrix:\n\n")
(array-display product)

(array-display
 (matrix-multiply (list->array (make-interval '#(2 2))
                               '(1 0
                                 0 1))
                  (make-array (make-interval '#(2 4))
                              (lambda (i j)
                                (+ i j)))))

(test (myarray= (matrix-multiply (list->array (make-interval '#(2 2))
                                              '(1 0
                                                   0 1))
                                  (make-array (make-interval '#(2 4))
                                              (lambda (i j)
                                                (+ i j))))
                 (make-array (make-interval '#(2 4))
                             (lambda (i j)
                               (+ i j))))
      #t)

;; Examples from
;; http://microapl.com/apl_help/ch_020_020_880.htm

(define TABLE1
  (list->array
   (make-interval '#(3 2))
   '(1 2
     5 4
     3 0)))

(define TABLE2
  (list->array
   (make-interval '#(2 4))
   '(6 2 3 4
     7 0 1 8)))

(pp (array->list* (array-inner-product TABLE1 + * TABLE2)))

(array-display (array-inner-product TABLE1 + * TABLE2))

;;; Displays
;;; 20 2 5 20
;;; 58 10 19 52
;;; 18 6 9 12

(define X (list*->array 1 '(1 3 5 7)))

(define Y (list*->array 1 '(2 3 6 7)))

(pp (array->list* (array-inner-product X + (lambda (x y) (if (= x y) 1 0)) Y)))

;;; Displays
;;; 2

(define A (array-copy (make-array (make-interval '#(3 4)) list)))

(array-display A)

(array-display (array-permute A '#(1 0)))

(array-display (specialized-array-reshape A (make-interval '#(4 3))))

(define B (array-sample A '#(2 1)))

(array-display B)

(test (array-display (specialized-array-reshape B (make-interval '#(8))))
      "specialized-array-reshape: Requested reshaping is impossible: ")

(array-display (specialized-array-reshape B (make-interval '#(8)) #t))

(define interval-flat (make-interval '#(100 100 4)))

(define interval-2x2  (make-interval '#(100 100 2 2)))

(define A (array-copy (make-array interval-flat (lambda args (test-random-integer 5)))))

(define B (array-copy (make-array interval-flat (lambda args (test-random-integer 5)))))

(define C (array-copy (make-array interval-flat (lambda args 0))))

(define (2x2-matrix-multiply-into! A B C)
  (let ((C! (array-setter C))
        (A_ (array-getter A))
        (B_ (array-getter B)))
    (C! (+ (* (A_ 0 0) (B_ 0 0))
           (* (A_ 0 1) (B_ 1 0)))
        0 0)
    (C! (+ (* (A_ 0 0) (B_ 0 1))
           (* (A_ 0 1) (B_ 1 1)))
        0 1)
    (C! (+ (* (A_ 1 0) (B_ 0 0))
           (* (A_ 1 1) (B_ 1 0)))
        1 0)
    (C! (+ (* (A_ 1 0) (B_ 0 1))
           (* (A_ 1 1) (B_ 1 1)))
        1 1)))

'(time
 (array-for-each 2x2-matrix-multiply-into!
                 (array-curry (specialized-array-reshape A interval-2x2) 2)
                 (array-curry (specialized-array-reshape B interval-2x2) 2)
                 (array-curry (specialized-array-reshape C interval-2x2) 2)))

'(time
 (array-for-each (lambda (A B C)
                   (array-assign! C (matrix-multiply A B)))
                 (array-curry (specialized-array-reshape A interval-2x2) 2)
                 (array-curry (specialized-array-reshape B interval-2x2) 2)
                 (array-curry (specialized-array-reshape C interval-2x2) 2)))

(array-display ((array-getter
                 (array-curry
                  (specialized-array-reshape A interval-2x2)
                  2))
                0 0))
(array-display ((array-getter
                 (array-curry
                  (specialized-array-reshape B interval-2x2)
                  2))
                0 0))
(array-display ((array-getter
                 (array-curry
                  (specialized-array-reshape C interval-2x2)
                  2))
                0 0))

(define 2x2 (make-interval '#(2 2)))

'(time
 (array-for-each (lambda (A B C)
                   (2x2-matrix-multiply-into!
                    (specialized-array-reshape A 2x2)
                    (specialized-array-reshape B 2x2)
                    (specialized-array-reshape C 2x2)))
                 (array-curry A 1)
                 (array-curry B 1)
                 (array-curry C 1)))

'(time
 (array-for-each (lambda (A B C)
                   (array-assign!
                    (specialized-array-reshape C 2x2)
                    (matrix-multiply
                     (specialized-array-reshape A 2x2)
                     (specialized-array-reshape B 2x2))))
                 (array-curry A 1)
                 (array-curry B 1)
                 (array-curry C 1)))
|#

(pp "cursory array-inner-product tests")

(test (array-inner-product 'a 'a 'a 'a)
      "array-inner-product: The first argument is not an array: ")

(test (array-inner-product (make-array (make-interval '#(10)) list) 'a 'a 'a)
      "array-inner-product: The second argument is not a procedure: ")

(test (array-inner-product (make-array (make-interval '#(10)) list) list 'a 'a)
      "array-inner-product: The third argument is not a procedure: ")

(test (array-inner-product (make-array (make-interval '#(10)) list) list list 'a)
      "array-inner-product: The fourth argument is not an array: ")

(test (array-inner-product (make-array (make-interval '#(10 1)) list) list list (make-array (make-interval '#(10)) list))
      "array-inner-product: The bounds of the last dimension of the first argument are not the same as the bounds of the first dimension of the fourth argument: ")

(test (array-inner-product (make-array (make-interval '#(10 1)) list) list list (make-array (make-interval '#(10 1)) list))
      "array-inner-product: The bounds of the last dimension of the first argument are not the same as the bounds of the first dimension of the fourth argument: ")


(test (array-inner-product (make-array (make-interval '#(1 10)) list)
                           list list
                           (make-array (make-interval '#(0 10)) list))
      "array-inner-product: The bounds of the last dimension of the first argument are not the same as the bounds of the first dimension of the fourth argument: ")


(test (array-inner-product (make-array (make-interval '#()) list)
                           list list
                           (make-array (make-interval '#(10 0)) list))
      "array-inner-product: The first argument has dimension zero: ")

(test (array-inner-product (make-array (make-interval '#(10 0)) list)
                           list list
                           (make-array (make-interval '#()) list))
      "array-inner-product: The fourth argument has dimension zero: ")

(let* ((A (make-array (make-interval '#(0 4)) list))
       (B (make-array (make-interval '#(4 0)) list))
       (C (array-inner-product A list list B))) ;; should be no error, you can take outer product of empty arrays
  (test (array-ref C 0 0)
        "array-getter: Array domain is empty: "))


(let* ((A (make-array (make-interval '#(4 0)) list))
       (B (make-array (make-interval '#(0 4)) list))
       (C (array-inner-product A list list B))) ;; should be no error
  (test (array-ref C 0 0)
        "array-inner-product: Attempting to reduce over an empty array: "))


(pp "array-append and array-append! tests")

(for-each
 (lambda (call/cc-safe?)
   (let ((array-append
          (if call/cc-safe?
              array-append
              array-append!))
         (message
          (if call/cc-safe?
              "array-append:"    ;; no trailing space
              "array-append!:")))

     (define (wrap error-reason)
       (string-append message error-reason))

     (test (array-append 1 'a)
           (wrap " Expecting as the second argument a nonnull list of arrays with the same dimension: "))

     (test (array-append 1 '())
           (wrap " Expecting as the second argument a nonnull list of arrays with the same dimension: "))

     (test (array-append 1 '(a))
           (wrap " Expecting as the second argument a nonnull list of arrays with the same dimension: "))

     (test (array-append 1 (list (make-array (make-interval '#(1)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting as the second argument a nonnull list of arrays with the same dimension: "))

     (test (array-append 1 (list (make-array (make-interval '#(2 2)) list) 'a))
           (wrap " Expecting as the second argument a nonnull list of arrays with the same dimension: "))

     (test (array-append 3 (list (make-array (make-interval '#(1 1)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (exclusive) as the first argument:"))

     (test (array-append -1 (list (make-array (make-interval '#(1 1)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (exclusive) as the first argument:"))

     (test (array-append 2 (list (make-array (make-interval '#(1 1)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (exclusive) as the first argument:"))

     (test (array-append 0
                         (list (make-array (make-interval '#(1 1)) list) (make-array (make-interval '#(2 2)) list))
                         'a)
           (wrap " Expecting a storage class as the third argument: "))

     (test (array-append 0
                         (list (make-array (make-interval '#(1 1)) list) (make-array (make-interval '#(2 2)) list))
                         u1-storage-class
                         'a)
           (wrap " Expecting a boolean as the fourth argument: "))

     (test (array-append 0
                         (list (make-array (make-interval '#(1 1)) list) (make-array (make-interval '#(2 2)) list))
                         u1-storage-class
                         #t
                         'a)
           (wrap " Expecting a boolean as the fifth argument: "))

     (test (array-append 0
                         (list (make-array (make-interval '#(2 4)) list)
                               (make-array (make-interval '#(3 5)) list)))
           (wrap " Expecting as the second argument a nonnull list of arrays with the same upper and lower bounds (except for index 0): "))

     (test (array-append 0
                         (list (make-array (make-interval '#(1 1)) list) (make-array (make-interval '#(2 1)) list))
                         u1-storage-class)
           (wrap " Not all elements of the source can be stored in destination: "))
     ))
 '(#t #f))



(define (my-array-append k . arrays)              ;; call with at least one array
  (call-with-values
      (lambda ()
        ;; compute lower and upper bounds of where
        ;; we'll copy each array argument, plus
        ;; the size of the kth axis of the result array
        (let loop ((result '(0))
                   (arrays arrays))
          (if (null? arrays)
              (values (reverse result) (car result))
              (let ((interval (array-domain (car arrays))))
                (loop (cons (+ (car result)
                               (- (interval-upper-bound interval k)
                                  (interval-lower-bound interval k)))
                            result)
                      (cdr arrays))))))
    (lambda (axis-subdividers kth-size)
      (let* ((array
              (car arrays))
             (lowers                         ;; the domains of the arrays differ only in the kth axis
              (interval-lower-bounds->vector (array-domain array)))
             (uppers
              (interval-upper-bounds->vector (array-domain array)))
             (result                         ;; the result array
              (make-specialized-array
               (let ()
                 (vector-set! lowers k 0)
                 (vector-set! uppers k kth-size)
                 (make-interval lowers uppers))))
             (translation
              ;; a vector we'll use to align each argument
              ;; array into the proper subarray of the result
              (make-vector (array-dimension array) 0)))
        (let loop ((arrays arrays)
                   (subdividers axis-subdividers))
          (if (null? arrays)
              ;; we've assigned every array to the appropriate subarray of result
              result
              (let ((array (car arrays)))
                (vector-set! lowers k (car subdividers))
                (vector-set! uppers k (cadr subdividers))
                (vector-set! translation k (- (car subdividers)
                                              (interval-lower-bound (array-domain array) k)))
                (array-assign!
                 (array-extract result (make-interval lowers uppers))
                 (array-translate array translation))
                (loop (cdr arrays)
                      (cdr subdividers)))))))))





;;; We steal some tests from Alex Shinn's test suite.

(define (append-map f l)
  (foldr append
         '()
         (map f l)))

(define (flatten ls)
  (if (pair? (car ls))
      (append-map flatten ls)
      ls))

(define (tensor nested-ls . o)
  (let lp ((ls nested-ls) (lens '()))
    (cond
     ((pair? ls) (lp (car ls) (cons (length ls) lens)))
     (else
      (apply list->array
             (make-interval (list->vector (reverse lens)))
             (flatten nested-ls)
             o)))))

(define (identity-array k . o)
  (array-copy (make-array (make-interval (vector k k))
                          (lambda args
                            (if (apply = args)
                                1
                                0)))
              (if (null? o) generic-storage-class (car o))))

(for-each
 (lambda (array-append)

   (define (->generalized-array array)
     (make-array (array-domain array)
                 (array-getter array)))

   (test (array-storage-class
          (array-append 0
                        (list (array-copy (make-array (make-interval '#(10)) (lambda (i) (random-integer 10))) u8-storage-class)
                              (array-copy (make-array (make-interval '#(10)) (lambda (i) (random-integer 10))) u16-storage-class))))
         generic-storage-class)

   (test (myarray= (array-append
                    0
                    (list (->generalized-array (list->array (make-interval '#(2 2))
                                                            '(1 2
                                                                3 4)))
                          (->generalized-array (list->array (make-interval '#(2 2))
                                                            '(5 6
                                                                7 8)))))
                   (list->array (make-interval '#(4 2))
                                '(1 2
                                    3 4
                                    5 6
                                    7 8)))
         #t)

   (test (myarray= (array-append
                    1
                    (list (->generalized-array (list->array (make-interval '#(2 2))
                                                            '(1 2
                                                                3 4)))
                          (list->array (make-interval '#(2 2))
                                       '(5 6
                                           7 8))))
                   (list->array (make-interval '#(2 4))
                                '(1 2 5 6
                                    3 4 7 8)))
         #t)

   (test (myarray= (array-append
                    0
                    (list (->generalized-array (list->array (make-interval '#(2 2))
                                                            '(1 2
                                                                3 4)))
                          (list->array (make-interval '#(2 2))
                                       '(5 6
                                           7 8))))
                   (my-array-append
                    0
                    (list->array (make-interval '#(2 2))
                                 '(1 2
                                     3 4))
                    (list->array (make-interval '#(2 2))
                                 '(5 6
                                     7 8))))
         #t)

   (test (myarray= (array-append
                    1
                    (list (->generalized-array (list->array (make-interval '#(2 2))
                                                            '(1 2
                                                                3 4)))
                          (list->array (make-interval '#(2 2))
                                       '(5 6
                                           7 8))))
                   (my-array-append
                    1
                    (list->array (make-interval '#(2 2))
                                 '(1 2
                                     3 4))
                    (list->array (make-interval '#(2 2))
                                 '(5 6
                                     7 8))))
         #t)

   (test (myarray= (tensor '((4 7)
                             (2 6)
                             (1 0)
                             (0 1)))
                   (array-append 0 (list (tensor '((4 7)
                                                   (2 6)))
                                         (identity-array 2))))
         #t)

   (test (myarray= (tensor '((4 7)
                             (2 6)
                             (1 0)
                             (0 1)))
                   (array-append 0
                                 (list (list->array (make-interval '#(2 0) '#(4 2))
                                                    '(4 7 2 6))
                                       (identity-array 2))))
         #t)

   (test (myarray= (tensor '((4 7 1 0)
                             (2 6 0 1)))
                   (array-append 1 (list (tensor '((4 7)
                                                   (2 6)))
                                         (identity-array 2))))
         #t)

   (test (myarray= (tensor '((4 7 2 1 0)
                             (6 3 5 0 1)))
                   (array-append 1 (list (tensor '((4 7 2)
                                                   (6 3 5)))
                                         (identity-array 2))))
         #t)

   (test (myarray= (tensor '((4 7 1 0 0 1 3)
                             (2 6 0 1 5 8 9)))
                   (array-append
                    1
                    (list (list->array (make-interval '#(2 2))
                                       '(4 7 2 6))
                          (identity-array 2)
                          (list->array (make-interval '#(2 3))
                                       '(0 1 3 5 8 9)))))
         #t)

   )
 (list array-append array-append!))


(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((domain
          (random-interval 1 6))  ;; you can't append zero-dimensional arrays
         (dimension
          (interval-dimension domain))
         (A
          (array-copy (make-array domain (lambda args (random 10)))))
         (domain-widths
          (interval-widths domain))
         (cutting-axis
          (random dimension))
         (tiling-argument
          (vector-map (lambda (k)
                        (let ((kth-width (interval-width domain k)))
                          (if (fx= k cutting-axis)
                              (if (zero? kth-width)
                                  (make-vector (random 1 4) 0)
                                  (let loop ((result '())
                                             (sum 0))
                                    (if (fx< sum kth-width)
                                        (let ((slice-width (random (+ 1 kth-width))))
                                          (loop (cons slice-width result)
                                                (+ slice-width sum)))
                                        (vector-permute (list->vector (cons (- (car result) (- sum kth-width))
                                                                            (cdr result)))
                                                        (random-permutation (length result))))))
                              (if (zero? kth-width)
                                  '#(0)
                                  kth-width))))
                      (list->vector (iota dimension))))
         (arrays
          (array->list (array-tile A tiling-argument)))
         (A-reconstructed
          (array-append cutting-axis arrays))
         (A-reconstructed!
          (array-append! cutting-axis arrays)))
    (test (myarray= (array-translate A (vector-map -
                                                   (interval-lower-bounds->vector (array-domain A-reconstructed))
                                                   (interval-lower-bounds->vector (array-domain A))))
                    A-reconstructed)
          #t)
    (test (myarray= (array-translate A (vector-map -
                                                   (interval-lower-bounds->vector (array-domain A-reconstructed))
                                                   (interval-lower-bounds->vector (array-domain A))))
                    A-reconstructed!)
          #t)))

#;(let* ((a (make-array (make-interval '#(4 6)) list))
       (k 2)
       (m (interval-upper-bound (array-domain a) 0))
       (n (interval-upper-bound (array-domain a) 1)))
  (pretty-print
   (array->list* a))
  (newline)
  (pretty-print
   (array->list*
    (array-append
     0
     (list (array-extract a (make-interval (vector k 0) (vector (+ k 1) n)))
           (array-extract a (make-interval (vector k n)))
           (array-extract a (make-interval (vector (+ k 1) 0) (vector m n))))))))


(next-test-random-source-state!)

(pp "array-stack and array-stack! tests")

(for-each
 (lambda (call/cc-safe?)
   (let ((array-stack
          (if call/cc-safe?
              array-stack
              array-stack!))
         (message
          (if call/cc-safe?
              "array-stack:"     ;; no trailing space
              "array-stack!:")))

     (define (wrap error-reason)
       (string-append message error-reason))

     (test (array-stack 1 'a)
           (wrap " Expecting a nonnull list of arrays with the same domains as the second argument: "))

     (test (array-stack 1 '())
           (wrap " Expecting a nonnull list of arrays with the same domains as the second argument: "))

     (test (array-stack 1 '(a))
           (wrap " Expecting a nonnull list of arrays with the same domains as the second argument: "))

     (test (array-stack 1 (list (make-array (make-interval '#(1)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting a nonnull list of arrays with the same domains as the second argument: "))

     (test (array-stack 1 (list (make-array (make-interval '#(2 2)) list) 'a))
           (wrap " Expecting a nonnull list of arrays with the same domains as the second argument: "))

     (test (array-stack 'a (list (make-array (make-interval '#(2 2)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (inclusive) as the first argument:"))

     (test (array-stack -1 (list (make-array (make-interval '#(2 2)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (inclusive) as the first argument:"))

     (test (array-stack 3 (list (make-array (make-interval '#(2 2)) list) (make-array (make-interval '#(2 2)) list)))
           (wrap " Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (inclusive) as the first argument:"))

     (test (array-stack 0
                        (list (make-array (make-interval '#(2 2)) list) (make-array (make-interval '#(2 2)) list))
                        'a)
           (wrap " Expecting a storage class as the third argument: "))

     (test (array-stack 0
                        (list (make-array (make-interval '#(2 2)) list) (make-array (make-interval '#(2 2)) list))
                        u1-storage-class
                        'a)
           (wrap " Expecting a boolean as the fourth argument: "))

     (test (array-stack 0
                        (list (make-array (make-interval '#(2 2)) list) (make-array (make-interval '#(2 2)) list))
                        u1-storage-class
                        #t
                        'a)
           (wrap " Expecting a boolean as the fifth argument: "))


     (test (array-stack 0
                        (list (make-array (make-interval '#(2 2)) list) (make-array (make-interval '#(2 2)) list))
                        u1-storage-class)
           (wrap " Not all elements of the source can be stored in destination: "))

     (test (array-storage-class
            (array-stack 1 (list (make-array (make-interval '#(10)) list))))
           generic-storage-class)

     (test (array-storage-class
            (array-stack 1
                         (list (array-copy (make-array (make-interval '#(10)) (lambda (i) (random-integer 10))) u8-storage-class)
                               (array-copy (make-array (make-interval '#(10)) (lambda (i) (random-integer 10))) u16-storage-class))))
           generic-storage-class)

     (test (myarray= (tensor '(((4 7) (2 6))
                               ((1 0) (0 1))))
                     (array-stack 0 (list (tensor '((4 7)
                                                    (2 6)))
                                          (identity-array 2))))
           #t)

     (test (myarray= (tensor '(((4 7) (1 0))
                               ((2 6) (0 1))))
                     (array-stack 1 (list (tensor '((4 7)
                                                    (2 6)))
                                          (identity-array 2))))
           #t)

     (test (myarray= (tensor '(((4 1) (7 0))
                               ((2 0) (6 1))))
                     (array-stack 2 (list (tensor '((4 7)
                                                    (2 6)))
                                          (identity-array 2))))
           #t)

     (let* ((A
             (make-array
              (make-interval '#(4 10))
              list))
            (column_
             (array-getter                  ;; the getter of ...
              (array-curry                  ;; a 1-D array of the columns of A
               (array-permute A '#(1 0))
               1)))
            (B
             (array-stack                  ;; stack into a new 2-D array ...
              1                            ;; along axis 1 (i.e., columns) ...
              (map column_ '(1 2 5 8))))   ;; the columns of A you want
            (B-prime
             (array-stack 1 (map (array-getter (array-curry (array-permute A '#(1 0)) 1)) '(1 2 5 8)))))
       (test (myarray= B B-prime)
             #t))))
 '(#t #f))


;;; zero-dimensional and empty arrays

(let ()

  (define arrays (map (lambda (ignore) (array-copy (make-array (make-interval '#()) (lambda () (random-integer 10))))) (iota 4)))

  (define b  (array-stack 0 arrays))
  (define c  (array-stack! 0 arrays))

  (test (map array-ref arrays)
        (array->list b))
  (test (map array-ref arrays)
        (array->list c)))

(let* ((arrays (map (lambda (ignore) (array-copy (make-array (make-interval '#(0)) error))) (iota 4)))
       (b (array-stack 0 arrays))
       (c (array-stack 1 arrays))
       (b! (array-stack! 0 arrays))
       (c! (array-stack! 1 arrays)))

  (test (interval-upper-bounds->vector (array-domain b))
        '#(4 0))
  (test (interval-upper-bounds->vector (array-domain c))
        '#(0 4))

  (test (interval-upper-bounds->vector (array-domain b!))
        '#(4 0))
  (test (interval-upper-bounds->vector (array-domain c!))
        '#(0 4)))


;;; FIXME: Need to test the values of other optional arguments to array-append

(define (myarray-stack k . arrays)
  (let* ((array
          (car arrays))
         (domain
          (array-domain array))
         (lowers
          (interval-lower-bounds->list domain))
         (uppers
          (interval-upper-bounds->list domain))
         (new-domain
          (make-interval
           (list->vector (append (take lowers k) (cons 0 (drop lowers k))))
           (list->vector (append (take uppers k) (cons (length arrays) (drop uppers k))))))
         (getters
          (list->vector (map %%array-getter arrays))))
    (make-array new-domain
                (lambda args
                  (apply
                   (vector-ref getters (list-ref args k))
                   (append (take args k)
                           (drop args (+ k 1))))))))

(do ((d 0 (fx+ d 1)))
    ((= d 6))
  (let* ((uppers-list
          (iota d))
         (domain
          (make-interval (list->vector uppers-list))))
    (do ((i 0 (fx+ i 1)))
        ;; distribute "tests" results over five dimensions
        ((= i (quotient random-tests 5)))
      (let* ((arrays
              (map (lambda (ignore)
                     (array-copy
                      (make-array domain
                                  (lambda args
                                    (random 256)))
                      u8-storage-class))
                   (iota (random 1 5))))
             (k
              (random (+ d 1))))
        (test (myarray= (array-stack k arrays)
                        (apply myarray-stack k arrays))
              #t)
        (test (myarray= (array-stack! k arrays)
                        (apply myarray-stack k arrays))
              #t)))))

(next-test-random-source-state!)

(pp "array-block and array-block! tests")

(for-each
 (lambda (call/cc-safe?)
   (let ((array-block
          (if call/cc-safe?
              array-block
              array-block!))
         (message
          (if call/cc-safe?
              "array-block: "
              "array-block!: ")))

     (define (wrap error-reason)
       (string-append message error-reason))

     (test (array-block 'a)
           (wrap "The first argument is not an array: "))

     (test (array-block (make-array (make-interval '#(2 2)) list) 'a)
           (wrap "The second argument is not a storage class: "))

     (test (array-block (make-array (make-interval '#(2 2)) list)
                        u8-storage-class
                        'a)
           (wrap "The third argument is not a boolean: "))

     (test (array-block (make-array (make-interval '#(2 2)) list)
                        u8-storage-class
                        #f
                        'a)
           (wrap "The fourth argument is not a boolean: "))

     (test (array-block (make-array (make-interval '#(2 2)) list))
           (wrap "Not all elements of the first argument (an array) are arrays: "))

     (test (array-block (vector*->array 1 (vector (vector*->array 1 '#(1 1))
                                                  (vector*->array 2 '#(#(1 2) #(3 4))))))
           (wrap "Not all elements of the first argument (an array) have the same dimension as the first argument itself: "))

     (test (array-block (list*->array
                         2
                         (list (list (list*->array 2 '((0 1)
                                                       (2 3)))
                                     (list*->array 2 '((4)
                                                       (5)))
                                     (list*->array 2 '((6 7)     ;; these should each have ...
                                                       (9 10)))) ;; three elements
                               (list (list*->array 2 '((12 13)))
                                     (list*->array 2 '((14)))
                                     (list*->array 2 '((15 16 17)))))))
           (wrap "Cannot stack array elements of the first argument into result array: "))


     (test (array? (array-block (list*->array
                                 1
                                 (list (make-array (make-interval '#(0)) list)
                                       (make-array (make-interval '#(0)) list)))))
           #t)


     (let* ((A (list*->array
                2
                (list (list (list*->array 2 '((0 1)
                                              (2 3)))
                            (list*->array 2 '((4)
                                              (5)))
                            (list*->array 2 '((6 7 8)
                                              (9 10 11))))
                      (list (list*->array 2 '((12 13)))
                            (list*->array 2 '((14)))
                            (list*->array 2 '((15 16 17)))))))
            (A-appended
             (array-block A))
            (A-tiled
             (array-tile A-appended '#(#(2 1) #(2 1 3)))))

       (for-each (lambda (mutable?)
                   (for-each (lambda (safe?)
                               (let ((new-A (array-block A generic-storage-class mutable? safe?)))
                                 (test (array-safe? new-A)
                                       safe?)
                                 (test (mutable-array? new-A)
                                       mutable?)))
                             '(#t #f)))
                 '(#t #f))
       (for-each (lambda (mutable?)
                   (for-each (lambda (safe?)
                               (parameterize ((specialized-array-default-mutable? mutable?)
                                              (specialized-array-default-safe?    safe?))
                                 (let ((new-A (array-block A generic-storage-class)))
                                   (test (array-safe? new-A)
                                         safe?)
                                   (test (mutable-array? new-A)
                                         mutable?))))
                             '(#t #f)))
                 '(#t #f))

       (test (array-every equal?            ;; we convert them to list*'s to ignore domains.
                          (array-map array->list* A)
                          (array-map array->list* A-tiled))
             #t))

     (let* ((A (list*->array
                2
                (list (list (list*->array 2 '((0 1)
                                              (2 3)))
                            (list*->array 2 '((4)
                                              (5)))
                            (list*->array 2 '((6 7 8)
                                              (9 10 11))))
                      (list (list*->array 2 '((12 13)))
                            (list*->array 2 '((14)))
                            (list*->array 2 '((15 16 17))))))))
       (test (array-block A u1-storage-class)
             (wrap "Not all elements of the source can be stored in destination: ")))
     ))
 '(#t #f))



(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((dims
          (random 1 6))
         (A-uppers
          (list->vector (map (lambda (ignore) (random 3 6)) (iota dims))))
         (A
          (array-copy
           (make-array (make-interval A-uppers)
                       (lambda args
                         (random 2)))
           u1-storage-class))
         (A_
          (array-getter A))
         (number-of-cuts
          (array->vector
           (make-array (make-interval (vector dims))
                       (lambda args (random 3)))))
         (cuts
          (vector-map (lambda (cuts upper)
                        (let ((bitmap (make-vector (+ upper 1) #f)))
                          (vector-set! bitmap 0 #t)
                          (vector-set! bitmap upper #t)
                          (let loop ((i 0))
                            (if (fx= i cuts)
                                (let ((result (make-vector (fx+ cuts 2))))
                                  (let inner ((l 0)
                                              (j 0))
                                    (cond ((fx> j cuts)
                                           (vector-set! result j upper)
                                           result)
                                          ((vector-ref bitmap l)
                                           (vector-set! result j l)
                                           (inner (fx+ l 1)
                                                  (fx+ j 1)))
                                          (else
                                           (inner (fx+ l 1)
                                                  j)))))
                                (let ((proposed-cut (random upper)))
                                  (if (vector-ref bitmap proposed-cut)
                                      (loop i)
                                      (begin
                                        (vector-set! bitmap proposed-cut #t)
                                        (loop (fx+ i 1)))))))))
                      number-of-cuts
                      A-uppers))
         (side-lengths
          (vector-map
           (lambda (cuts)
             (let ((result
                    (make-vector (- (vector-length cuts) 1))))
               (do ((i 0 (fx+ i 1)))
                   ((fx= i (vector-length result)) result)
                 (vector-set! result i (- (vector-ref cuts (+ i 1))
                                          (vector-ref cuts i))))))
           cuts))
         (A-blocks
          (make-array (make-interval (vector-map (lambda (v)
                                                              (- (vector-length v) 1))
                                                            cuts))
                                 (lambda args
                                   (let ((vector-args (list->vector args)))
                                     (make-array (make-interval (vector-map (lambda (cuts i)
                                                                              (vector-ref cuts i))
                                                                            cuts
                                                                            vector-args)
                                                                (vector-map (lambda (cuts i)
                                                                              (vector-ref cuts (+ i 1)))
                                                                            cuts
                                                                            vector-args))
                                                 A_)))))
         (A-tiled
          (array-tile A side-lengths))
         (reconstructed-A
          (array-block A-blocks u1-storage-class))
         (reconstructed-A!
          (array-block! A-blocks u1-storage-class)))
    (test (array-every myarray= A-tiled A-blocks)
          #t)
    (test (array-every = A reconstructed-A)
          #t)
    (test (array-every = A reconstructed-A!)
          #t)
    (test (array-every = A
                       (array-block
                        (array-tile A
                                    (list->vector
                                     (map (lambda (ignore) (random 1 5))
                                          (iota dims))))))
          #t)
    (test (array-every = A
                       (array-block!
                        (array-tile A
                                    (list->vector
                                     (map (lambda (ignore) (random 1 5))
                                          (iota dims))))))
          #t)))

(next-test-random-source-state!)

;;; Let's do something similar now with possibly empty arrays and subarrays.

(do ((i 0 (+ i 1)))
    ((= i random-tests))
  (let* ((domain
          (random-interval))
         (domain-widths
          (interval-widths domain))
         (tiling-argument
          (vector-map (lambda (width)
                        (if (zero? width)                  ;; width of kth axis is 0
                            (make-vector (random 1 3) 0)
                            (if (even? (random 2))
                                (let loop ((result '())    ;; accumulate a list of nonnegative integers that (eventually) sum to no less than width
                                           (sum 0))
                                  (if (<= width sum)
                                      (vector-permute (list->vector (cons (- (car result)    ;; adjust last entry so the sum is width
                                                                             (- sum width))
                                                                          (cdr result)))
                                                      (random-permutation (length result)))  ;; randomly permute vector of cuts
                                      (let ((new-width (random (+ width 1))))
                                        (loop (cons new-width result)
                                              (+ new-width sum)))))
                                (random 1 (+ width 3)))))               ;; a positive scalar
                      domain-widths))
         (A
          (array-copy (make-array domain (lambda args (random 10)))))
         (A-tiled
          (array-tile A tiling-argument))
         (A-tiled
          (array-map (lambda (A) (make-array (array-domain A) (array-getter A))) A-tiled))
         (A-blocked!
          (array-block! A-tiled))
         (A-blocked
          (array-block A-tiled)))
    (test (myarray= (array-translate A (vector-map - (interval-lower-bounds->vector (array-domain A)))) ;; array-block returns an array based at the origin
                    A-blocked!)
          #t)
    (test (myarray= (array-translate A (vector-map - (interval-lower-bounds->vector (array-domain A)))) ;; array-block returns an array based at the origin
                    A-blocked)
          #t)))

(next-test-random-source-state!)
#|
(define (array-pad-periodically a N)
  ;; Pad a periodically with N rows and columns top and bottom, left and right.
  ;; Returns a generalized array.
  (let* ((domain     (array-domain a))
         (m          (interval-upper-bound domain 0))
         (n          (interval-upper-bound domain 1))
         (a_         (array-getter a)))
    (make-array (interval-dilate domain (vector (- N) (- N)) (vector N N))
                (lambda (i j)
                  (a_ (modulo i m) (modulo j n))))))

(define (neighbor-count a)
  (let* ((big-a      (array-copy (array-pad-periodically a 1)
                                 (array-storage-class a)))
         (domain     (array-domain a))
         (translates (map (lambda (translation)
                            (array-extract (array-translate big-a translation) domain))
                          '(#(1 0) #(0 1) #(-1 0) #(0 -1)
                            #(1 1) #(1 -1) #(-1 1) #(-1 -1)))))
    ;; Returns a generalized array that contains the number
    ;; of 1s in the 8 cells surrounding each cell in the original array.
    (apply array-map + translates)))

(define (game-rules a neighbor-count)
  ;; a is a single cell, neighbor-count is the count of 1s in
  ;; its 8 neighboring cells.
  (if (= a 1)
      (if (or (= neighbor-count 2)
              (= neighbor-count 3))
          1 0)
      ;; (= a 0)
      (if (= neighbor-count 3)
          1 0)))

(define (advance a)
  (array-copy
   (array-map game-rules a (neighbor-count a))
   (array-storage-class a)))

(define glider
  (list*->array
   2
   '((0 0 0 0 0 0 0 0 0 0)
     (0 0 1 0 0 0 0 0 0 0)
     (0 0 0 1 0 0 0 0 0 0)
     (0 1 1 1 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0)
     (0 0 0 0 0 0 0 0 0 0))
   u1-storage-class))

(define (generations a N)
  (do ((i 0 (fx+ i 1))
       (a a  (advance a)))
      ((fx= i N))
    (newline)
    (pretty-print (array->list* a))))

(generations glider 5)
|#

#;(pp (reverse %%test-moves))

;;; Unit tests

(pp 'unit-tests)

(let ((A (make-specialized-array (make-interval '#(5 5 5 5 5) '#(8 8 8 8 8))))
      (B (make-specialized-array (make-interval '#(5 5 5 5 5)))))
  (test (array-ref A 0 0)
        "Wrong number of arguments passed to procedure ")
  (test (array-set! A 2 0 0)
        "Wrong number of arguments passed to procedure ")
  (test (array-ref B 0 0)
        "Wrong number of arguments passed to procedure ")
  (test (array-set! B 2 0 0)
        "Wrong number of arguments passed to procedure "))

(pp "Test interactions of continuations and array-{copy|append|stack|decurry|block}")

(pp 'array-copy)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (array-list '()))
  (let ((temp (array-copy A)))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4)))
  (for-each (lambda (result truth)
              (test (array->list* result)
                    truth))
            array-list
            '(((4 1) (1 1))
              ((1 1) (1 1)))))

(pp 'array-append)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (array-list '()))
  (let ((temp (array-append 1 (list A B))))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4)))
  (for-each (lambda (result truth)
              (test (array->list* result)
                    truth))
            array-list
            '(((4 1 1 2) (1 1 3 4))
              ((1 1 1 2) (1 1 3 4)))))

(pp 'array-stack)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (array-list '()))
  (let ((temp (array-stack 1 (list A B))))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4)))
  (for-each (lambda (result truth)
              (test (array->list* result)
                    truth))
            array-list
            '((((4 1) (1 2)) ((1 1) (3 4)))
              (((1 1) (1 2)) ((1 1) (3 4))))))

(pp 'array-block)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (C (list*->array 2 (list (list A B))))
       (array-list '()))
  (let ((temp (array-block C)))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4)))
  (for-each (lambda (result truth)
              (test (array->list* result)
                    truth))
            array-list
            '(((4 1 1 2) (1 1 3 4))
              ((1 1 1 2) (1 1 3 4)))))

(pp 'array-decurry)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (C (list*->array 1 (list A B)))
       (array-list '()))
  (let ((temp (array-decurry C)))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4)))
  (for-each (lambda (result truth)
              (test (array->list* result)
                    truth))
            array-list
            '((((4 1) (1 1)) ((1 2) (3 4)))
              (((1 1) (1 1)) ((1 2) (3 4))))))

(pp "Test that the corresponding ! procedures don't crash when dealing with continuations.")

(pp 'array-copy!)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (array-list '()))
  (let ((temp (array-copy! A)))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4))))

(pp 'array-append!)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (array-list '()))
  (let ((temp (array-append 1 (list A B))))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4))))

(pp 'array-stack!)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (array-list '()))
  (let ((temp (array-stack! 1 (list A B))))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4))))

(pp 'array-block!)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (C (list*->array 2 (list (list A B))))
       (array-list '()))
  (let ((temp (array-block! C)))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4))))

(pp 'array-decurry!)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_))
       (C (list*->array 1 (list A B)))
       (array-list '()))
  (let ((temp (array-decurry! C)))
    (set! array-list (cons temp array-list)))
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4))))

(pp 'array-assign!)

(let* ((cont #f)
       (call-cont #t)
       (domain (make-interval '#(2 2)))
       (B (list*->array 2 '((1 2) (3 4))))
       (A_ (lambda (i j)
             (call-with-current-continuation
              (lambda (c)
                (if (= i j 0)
                    (set! cont c))
                1))))
       (A (make-array domain A_)))
  (array-assign! B A)
  (if call-cont
      (begin
        (set! call-cont #f)
        (cont 4))))

(for-each display (list "Failed " failed-tests " out of " total-tests " total tests.\n"))
