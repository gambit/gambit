#|
SRFI 179: Nonempty Intervals and Generalized Arrays (Updated)

Copyright 2016, 2018, 2020 Bradley J Lucier.
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

(##namespace ("srfi/179#"))
(##include "~~lib/gambit#.scm")

(##declare (standard-bindings)
           (extended-bindings)
           (block)
           (mostly-fixnum)
           (not safe))

;;; Our naming convention prefixes %% to the names of internal procedures,

(define (c64vector-copy! to at from start end)
  (f32vector-copy! to (fx* 2 at) from (fx* 2 start) (fx* 2 end)))
(define (c128vector-copy! to at from start end)
  (f64vector-copy! to (fx* 2 at) from (fx* 2 start) (fx* 2 end)))

(declare (not inline))

;;; We do not need a multi-argument every.

(define (%%every pred list)
  ;; don't inline %%every, but unroll the loop if advantageous
  (declare (inline))
  (let loop ((list list))
    (or (null? list)
        (and (pred (car list))
             (loop (cdr list))))))

;;; the following is used in error checks.

(define %%vector-every
  (case-lambda
   ((pred vec)
    (let loop ((i (fx- (vector-length vec) 1)))
      (or (fx< i 0)
          (and (pred (vector-ref vec i))
               (loop (fx- i 1))))))
     ((pred vec vec2)
      (let loop ((i (fx- (vector-length vec) 1)))
        (or (fx< i 0)
            (and (pred (vector-ref vec i)
                       (vector-ref vec2 i))
                 (loop (fx- i 1))))))
     ((pred vec vec2 . rest)
      (let ((vecs (cons vec (cons vec2 rest))))
        (let loop ((i (fx- (vector-length vec) 1)))
          (or (fx< i 0)
              (and (apply pred (map (lambda (vec) (vector-ref vec i)) vecs))
                   (loop (fx- i 1)))))))))



;;; requires vector-map, vector-copy function

;;; requires vector-concatenate function

;;; requires exact-integer? function

;;; requires iota, drop, take from SRFI-1

;;; requires fixnum? and flonum?

(declare (inline))

;;; An interval is a cross product of multi-indices

;;; [l_0,u_0) x [l_1,u_1) x ... x [l_n-1,u_n-1)

;;; where l_i < u_i for 0 <= i < n, and n > 0 is the dimension of the interval

(define-structure %%interval
  dimension               ;; a fixnum
  %%volume                ;; #f or an exact integer, calculated when needed
  lower-bounds            ;; a vector of exact integers l_0,...,l_n-1
  upper-bounds            ;; a vector of exact integers u_0,...,u_n-1
  )                       ;; end %%interval
(define (interval? x)
  (%%interval? x))

(declare (not inline))

(define %%vector-of-zeros
  '#(#()
     #(0)
     #(0 0)
     #(0 0 0)
     #(0 0 0 0)))

(define (%%finish-interval lower-bounds upper-bounds)
  (make-%%interval (vector-length upper-bounds)
                   #f
                   (vector-copy lower-bounds)
                   (vector-copy upper-bounds)))

(define make-interval
  (case-lambda
   ((upper-bounds)
    (cond ((not (and (vector? upper-bounds)
                     (fx< 0 (vector-length upper-bounds))
                     (%%vector-every (lambda (x) (exact-integer? x)) upper-bounds)
                     (%%vector-every (lambda (x) (positive? x)) upper-bounds)))
           (error "make-interval: The argument is not a nonempty vector of positive exact integers: " upper-bounds))
          (else
           (let ((dimension (vector-length upper-bounds)))
             (%%finish-interval (if (fx< dimension 5)
                                    (vector-ref %%vector-of-zeros dimension)
                                    (make-vector dimension 0))
                                (vector-copy upper-bounds))))))
   ((lower-bounds upper-bounds)
    (cond ((not (and (vector? lower-bounds)
                     (fx< 0 (vector-length lower-bounds))
                     (%%vector-every (lambda (x) (exact-integer? x)) lower-bounds)))
           (error "make-interval: The first argument is not a nonempty vector of exact integers: " lower-bounds upper-bounds))
          ((not (and (vector? upper-bounds)
                     (fx< 0 (vector-length upper-bounds))
                     (%%vector-every (lambda (x) (exact-integer? x)) upper-bounds)))
           (error "make-interval: The second argument is not a nonempty vector of exact integers: " lower-bounds upper-bounds))
          ((not (fx= (vector-length lower-bounds)
                     (vector-length upper-bounds)))
           (error "make-interval: The first and second arguments are not the same length: " lower-bounds upper-bounds))
          ((not (%%vector-every (lambda (x y) (< x y)) lower-bounds upper-bounds))
           (error "make-interval: Each lower-bound must be less than the associated upper-bound: " lower-bounds upper-bounds))
          (else
           (%%finish-interval (vector-copy lower-bounds)
                              (vector-copy upper-bounds)))))))

(declare (inline))

#|

;;; Now a cached field of %%interval

(define (%%interval-dimension interval)
  (vector-length (%%interval-lower-bounds interval)))

|#

(define (%%interval-lower-bound interval i)
  (vector-ref (%%interval-lower-bounds interval) i))

(define (%%interval-upper-bound interval i)
  (vector-ref (%%interval-upper-bounds interval) i))

(define (%%interval-lower-bounds->vector interval)
  (vector-copy (%%interval-lower-bounds interval)))

(define (%%interval-upper-bounds->vector interval)
  (vector-copy (%%interval-upper-bounds interval)))

(define (%%interval-lower-bounds->list interval)
  (vector->list (%%interval-lower-bounds interval)))

(define (%%interval-upper-bounds->list interval)
  (vector->list (%%interval-upper-bounds interval)))

(declare (not inline))

(define (interval-dimension interval)
  (cond ((not (interval? interval))
         (error "interval-dimension: The argument is not an interval: " interval))
        (else
         (%%interval-dimension interval))))

(define (interval-lower-bound interval i)
  (cond ((not (interval? interval))
         (error "interval-lower-bound: The first argument is not an interval: " interval i))
        ((not (and (fixnum? i)
                   (fx< -1 i (%%interval-dimension interval))))
         (error "interval-lower-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): " interval i))
        (else
         (%%interval-lower-bound interval i))))

(define (interval-upper-bound interval i)
  (cond ((not (interval? interval))
         (error "interval-upper-bound: The first argument is not an interval: " interval i))
        ((not (and (fixnum? i)
                   (fx< -1 i (%%interval-dimension interval))))
         (error "interval-upper-bound: The second argument is not an exact integer between 0 (inclusive) and (interval-dimension interval) (exclusive): " interval i))
        (else
         (%%interval-upper-bound interval i))))

(define (interval-lower-bounds->vector interval)
  (cond ((not (interval? interval))
         (error "interval-lower-bounds->vector: The argument is not an interval: " interval))
        (else
         (%%interval-lower-bounds->vector interval))))

(define (interval-upper-bounds->vector interval)
  (cond ((not (interval? interval))
         (error "interval-upper-bounds->vector: The argument is not an interval: " interval))
        (else
         (%%interval-upper-bounds->vector interval))))

(define (interval-lower-bounds->list interval)
  (cond ((not (interval? interval))
         (error "interval-lower-bounds->list: The argument is not an interval: " interval))
        (else
         (%%interval-lower-bounds->list interval))))

(define (interval-upper-bounds->list interval)
  (cond ((not (interval? interval))
         (error "interval-upper-bounds->list: The argument is not an interval: " interval))
        (else
         (%%interval-upper-bounds->list interval))))

(define (interval-projections interval right-dimension)
  (cond ((not (interval? interval))
         (error "interval-projections: The first argument is not an interval: " interval right-dimension))
        ((not (fx< 1 (%%interval-dimension interval)))  ;; redundant check, but useful error message
         (error "interval-projections: The dimension of the first argument is not greater than 1: " interval right-dimension))
        ((not (and (fixnum? right-dimension)
                   (fx< 0 right-dimension (%%interval-dimension interval))))
         (error "interval-projections: The second argument is not an exact integer between 0 and the dimension of the first argument (exclusive): " interval right-dimension))
        (else
         (%%interval-projections interval right-dimension))))

(define (%%interval-projections interval right-dimension)
  (let* ((n (%%interval-dimension interval))
         (left-dimension (fx- n right-dimension))
         (lower-bounds (%%interval-lower-bounds interval))
         (upper-bounds (%%interval-upper-bounds interval))
         (left-lower-bounds (make-vector left-dimension))
         (left-upper-bounds (make-vector left-dimension))
         (right-lower-bounds (make-vector (- n left-dimension)))
         (right-upper-bounds (make-vector (- n left-dimension))))
    (do ((i 0 (fx+ i 1)))
        ((fx= i left-dimension)
         (do ((i i (fx+ i 1)))
             ((fx= i n)
              (values (%%finish-interval left-lower-bounds
                                         left-upper-bounds)
                      (%%finish-interval right-lower-bounds
                                         right-upper-bounds)))
           (vector-set! right-lower-bounds (fx- i left-dimension) (vector-ref lower-bounds i))
           (vector-set! right-upper-bounds (fx- i left-dimension) (vector-ref upper-bounds i))))
      (vector-set! left-lower-bounds i (vector-ref lower-bounds i))
      (vector-set! left-upper-bounds i (vector-ref upper-bounds i)))))

(define (permutation? permutation)
  (and (vector? permutation)
       (let* ((n (vector-length permutation))
              (permutation-range (make-vector n #f)))
         ;; we'll write things into permutation-range
         ;; each box should be written only once
         (let loop ((i 0))
           (or (fx= i n)
               (let ((p_i (vector-ref permutation i)))
                 (and (fixnum? p_i) ;; a permutation index can't be a bignum
                      (fx< -1 p_i n)
                      (not (vector-ref permutation-range p_i))
                      (let ()
                        (vector-set! permutation-range p_i #t)
                        (loop (fx+ i 1))))))))))



(define (%%vector-permute vector permutation)
  (let* ((n (vector-length vector))
         (result (make-vector n)))
    (do ((i 0 (fx+ i 1)))
        ((fx= i n) result)
      (vector-set! result i (vector-ref vector (vector-ref permutation i))))))

(define (%%vector-permute->list vector permutation)
  (do ((i (fx- (vector-length vector) 1) (fx- i 1))
       (result '() (cons (vector-ref vector (vector-ref permutation i))
                         result)))
      ((fx< i 0) result)))

(define (%%permutation-invert permutation)
  (let* ((n (vector-length permutation))
         (result (make-vector n)))
    (do ((i 0 (fx+ i 1)))
        ((fx= i n) result)
      (vector-set! result (vector-ref permutation i) i))))



(define (%%interval-permute interval permutation)
  (%%finish-interval (%%vector-permute (%%interval-lower-bounds interval) permutation)
                     (%%vector-permute (%%interval-upper-bounds interval) permutation)))

(define (interval-permute interval permutation)
  (cond ((not (interval? interval))
         (error "interval-permute: The first argument is not an interval: " interval permutation))
        ((not (permutation? permutation))
         (error "interval-permute: The second argument is not a permutation: " interval permutation))
        ((not (fx= (%%interval-dimension interval) (vector-length permutation)))
         (error "interval-permute: The dimension of the first argument (an interval) does not equal the length of the second (a permutation): " interval permutation))
        (else
         (%%interval-permute interval permutation))))

(define (translation? translation)
  (and (vector? translation)
       (%%vector-every (lambda (x) (exact-integer? x)) translation)))

(define (interval-translate interval translation)
  (cond ((not (interval? interval))
         (error "interval-translate: The first argument is not an interval: " interval translation))
        ((not (translation? translation))
         (error "interval-translate: The second argument is not a vector of exact integers: " interval translation))
        ((not (fx= (%%interval-dimension interval)
                   (vector-length translation)))
         (error "interval-translate: The dimension of the first argument (an interval) does not equal the length of the second (a vector): " interval translation))
        (else
         (%%interval-translate interval translation))))

(define (%%interval-translate Interval translation)
  (%%finish-interval (vector-map (lambda (x y) (+ x y)) (%%interval-lower-bounds Interval) translation)
                     (vector-map (lambda (x y) (+ x y)) (%%interval-upper-bounds Interval) translation)))

(define (%%interval-scale interval scales)
  (let* ((uppers (%%interval-upper-bounds interval))
         (lowers (%%interval-lower-bounds interval))
         (new-uppers (vector-map (lambda (u s)
                                   (quotient (+ u s -1) s))
                                 uppers scales)))
    (%%finish-interval lowers new-uppers)))

(define (interval-scale interval scales)
  (cond ((not (and (interval? interval)
                   (%%vector-every (lambda (x) (eqv? 0 x)) (%%interval-lower-bounds interval))))
         (error "interval-scale: The first argument is not an interval with all lower bounds zero: " interval scales))
        ((not (and (vector? scales)
                   (%%vector-every (lambda (x) (exact-integer? x)) scales)
                   (%%vector-every (lambda (x) (positive? x)) scales)))
         (error "interval-scale: The second argument is not a vector of positive, exact, integers: " interval scales))
        ((not (fx= (vector-length scales) (%%interval-dimension interval)))
         (error "interval-scale: The dimension of the first argument (an interval) is not equal to the length of the second (a vector): "
                interval scales))
        (else
         (%%interval-scale interval scales))))

(define (%%interval-cartesian-product intervals)
  (%%finish-interval (vector-concatenate (map %%interval-lower-bounds intervals))
                     (vector-concatenate (map %%interval-upper-bounds intervals))))

(define (interval-cartesian-product interval #!rest intervals)
  (let ((intervals (cons interval intervals)))
    (cond ((not (%%every interval? intervals))
           (apply error "interval-cartesian-product: Not all arguments are intervals: " intervals))
          (else
           (%%interval-cartesian-product intervals)))))

(define (interval-dilate interval lower-diffs upper-diffs)
  (cond ((not (interval? interval))
         (error "interval-dilate: The first argument is not an interval: " interval lower-diffs upper-diffs))
        ((not (and (vector? lower-diffs)
                   (%%vector-every (lambda (x) (exact-integer? x)) lower-diffs)))
         (error "interval-dilate: The second argument is not a vector of exact integers: " interval lower-diffs upper-diffs))
        ((not (and (vector? upper-diffs)
                   (%%vector-every (lambda (x) (exact-integer? x)) upper-diffs)))
         (error "interval-dilate: The third argument is not a vector of exact integers: " interval lower-diffs upper-diffs))
        ((not (fx= (vector-length lower-diffs)
                   (vector-length upper-diffs)
                   (%%interval-dimension interval)))
         (error "interval-dilate: The second and third arguments must have the same length as the dimension of the first argument: " interval lower-diffs upper-diffs))
        (else
         (let ((new-lower-bounds (vector-map (lambda (x y) (+ x y)) (%%interval-lower-bounds interval) lower-diffs))
               (new-upper-bounds (vector-map (lambda (x y) (+ x y)) (%%interval-upper-bounds interval) upper-diffs)))
           (if (%%vector-every (lambda (x y) (< x y)) new-lower-bounds new-upper-bounds)
               (%%finish-interval new-lower-bounds new-upper-bounds)
               (error "interval-dilate: The resulting interval is empty: " interval lower-diffs upper-diffs))))))

(define (%%interval-volume interval)
  (or (%%interval-%%volume interval)
      (let* ((upper-bounds
              (%%interval-upper-bounds interval))
             (lower-bounds
              (%%interval-lower-bounds interval))
             (dimension
              (%%interval-dimension interval))
             (volume
              (do ((i (fx- dimension 1) (fx- i 1))
                   (result 1 (* result (- (vector-ref upper-bounds i)
                                          (vector-ref lower-bounds i)))))
                  ((fx< i 0) result))))
        (%%interval-%%volume-set! interval volume)
        volume)))

(define (interval-volume interval)
  (cond ((not (interval? interval))
         (error "interval-volume: The argument is not an interval: " interval))
        (else
         (%%interval-volume interval))))

(define (%%interval= interval1 interval2)
  ;; This can be used a fair amount, so we open-code it
  (or (eq? interval1 interval2)
      (and (let ((upper1 (%%interval-upper-bounds interval1))
                 (upper2 (%%interval-upper-bounds interval2)))
             (or (eq? upper1 upper2)
                 (and (fx= (vector-length upper1) (vector-length upper2))
                      (%%vector-every (lambda (x y) (= x y)) upper1 upper2))))
           (let ((lower1 (%%interval-lower-bounds interval1))
                 (lower2 (%%interval-lower-bounds interval2)))
             (or (eq? lower1 lower2)
                 ;; We don't need to check that the two lower bounds
                 ;; are the same length after checking the upper bounds
                 (%%vector-every (lambda (x y) (= x y)) lower1 lower2))))))

(define (interval= interval1 interval2)
  (cond ((not (and (interval? interval1)
                   (interval? interval2)))
         (error "interval=: Not all arguments are intervals: " interval1 interval2))
        (else
         (%%interval= interval1 interval2))))

(define (%%interval-subset? interval1 interval2)
  (and (fx= (%%interval-dimension interval1) (%%interval-dimension interval2))
       (%%vector-every (lambda (x y) (>= x y)) (%%interval-lower-bounds interval1) (%%interval-lower-bounds interval2))
       (%%vector-every (lambda (x y) (<= x y)) (%%interval-upper-bounds interval1) (%%interval-upper-bounds interval2))))

(define (interval-subset? interval1 interval2)
  (cond ((not (and (interval? interval1)
                   (interval? interval2)))
         (error "interval-subset?: Not all arguments are intervals: " interval1 interval2))
        ((not (fx= (%%interval-dimension interval1)
                   (%%interval-dimension interval2)))
         (error "interval-subset?: The arguments do not have the same dimension: " interval1 interval2))
        (else
         (%%interval-subset? interval1 interval2))))

(define (%%interval-intersect intervals)
  (let ((lower-bounds (apply vector-map max (map %%interval-lower-bounds intervals)))
        (upper-bounds (apply vector-map min (map %%interval-upper-bounds intervals))))
    (and (%%vector-every (lambda (x y) (< x y)) lower-bounds upper-bounds)
         (%%finish-interval lower-bounds upper-bounds))))

(define (interval-intersect interval #!rest intervals)
  (if (null? intervals)
      (if (interval? interval)
          interval
          (error "interval-intersect: The argument is not an interval: " interval))
      (let ((intervals (cons interval intervals)))
        (cond ((not (%%every interval? intervals))
               (apply error "interval-intersect: Not all arguments are intervals: " intervals))
              ((let* ((dims (map %%interval-dimension intervals))
                      (dim1 (car dims)))
                 (not (%%every (lambda (dim) (fx= dim dim1)) (cdr dims))))
               (apply error "interval-intersect: Not all arguments have the same dimension: " intervals))
              (else
               (%%interval-intersect intervals))))))

(declare (inline))

(define (%%interval-contains-multi-index?-1 interval i)
  (and (<= (%%interval-lower-bound interval 0) i) (< i (%%interval-upper-bound interval 0))))

(define (%%interval-contains-multi-index?-2 interval i j)
  (and (<= (%%interval-lower-bound interval 0) i) (< i (%%interval-upper-bound interval 0))
       (<= (%%interval-lower-bound interval 1) j) (< j (%%interval-upper-bound interval 1))))

(define (%%interval-contains-multi-index?-3 interval i j k)
  (and (<= (%%interval-lower-bound interval 0) i) (< i (%%interval-upper-bound interval 0))
       (<= (%%interval-lower-bound interval 1) j) (< j (%%interval-upper-bound interval 1))
       (<= (%%interval-lower-bound interval 2) k) (< k (%%interval-upper-bound interval 2))))

(define (%%interval-contains-multi-index?-4 interval i j k l)
  (and (<= (%%interval-lower-bound interval 0) i) (< i (%%interval-upper-bound interval 0))
       (<= (%%interval-lower-bound interval 1) j) (< j (%%interval-upper-bound interval 1))
       (<= (%%interval-lower-bound interval 2) k) (< k (%%interval-upper-bound interval 2))
       (<= (%%interval-lower-bound interval 3) l) (< l (%%interval-upper-bound interval 3))))

(declare (not inline))

(define (%%interval-contains-multi-index?-general interval multi-index)
  (let loop ((i 0)
             (multi-index multi-index))
    (or (null? multi-index)
        (let ((component (car multi-index)))
          (and (<= (%%interval-lower-bound interval i) component)
               (< component (%%interval-upper-bound interval i))
               (loop (fx+ i 1)
                     (cdr multi-index)))))))

(define (interval-contains-multi-index? interval i #!rest multi-index-tail)

  ;; this is relatively slow, but (a) I haven't seen a need to use it yet, and (b) this formulation
  ;; significantly simplifies testing the error checking

  (cond ((not (interval? interval))
         (error "interval-contains-multi-index?: The first argument is not an interval: " interval))
        (else
         (let ((multi-index (cons i multi-index-tail)))
           (cond ((not (fx= (%%interval-dimension interval)
                            (length multi-index)))
                  (apply error "interval-contains-multi-index?: The dimension of the first argument (an interval) does not match number of indices: " interval multi-index))
                 ((not (%%every (lambda (x) (exact-integer? x)) multi-index))
                  (apply error "interval-contains-multi-index?: At least one multi-index component is not an exact integer: " interval multi-index))
                 (else
                  (%%interval-contains-multi-index?-general interval multi-index)))))))

;;; Applies f to every element of the domain; assumes that f is thread-safe,
;;; the order of application is not specified

(define (interval-for-each f interval)
  (cond ((not (interval? interval))
         (error "interval-for-each: The second argument is not a interval: " interval))
        ((not (procedure? f))
         (error "interval-for-each: The first argument is not a procedure: " f))
        (else
         (%%interval-for-each f interval))))

(define (%%interval-for-each f interval)
  (case (%%interval-dimension interval)
    ((1) (let ((lower-i (%%interval-lower-bound interval 0))
               (upper-i (%%interval-upper-bound interval 0)))
           (let i-loop ((i lower-i))
             (if (< i upper-i)
                 (begin
                   (f i)
                   (i-loop (+ i 1)))))))
    ((2) (let ((lower-i (%%interval-lower-bound interval 0))
               (lower-j (%%interval-lower-bound interval 1))
               (upper-i (%%interval-upper-bound interval 0))
               (upper-j (%%interval-upper-bound interval 1)))
           (let i-loop ((i lower-i))
             (if (< i upper-i)
                 (let j-loop ((j lower-j))
                   (if (< j upper-j)
                       (begin
                         (f i j)
                         (j-loop (+ j 1)))
                       (i-loop (+ i 1))))))))
    ((3) (let ((lower-i (%%interval-lower-bound interval 0))
               (lower-j (%%interval-lower-bound interval 1))
               (lower-k (%%interval-lower-bound interval 2))
               (upper-i (%%interval-upper-bound interval 0))
               (upper-j (%%interval-upper-bound interval 1))
               (upper-k (%%interval-upper-bound interval 2)))
           (let i-loop ((i lower-i))
             (if (< i upper-i)
                 (let j-loop ((j lower-j))
                   (if (< j upper-j)
                       (let k-loop ((k lower-k))
                         (if (< k upper-k)
                             (begin
                               (f i j k)
                               (k-loop (+ k 1)))
                             (j-loop (+ j 1))))
                       (i-loop (+ i 1))))))))
    ((4) (let ((lower-i (%%interval-lower-bound interval 0))
               (lower-j (%%interval-lower-bound interval 1))
               (lower-k (%%interval-lower-bound interval 2))
               (lower-l (%%interval-lower-bound interval 3))
               (upper-i (%%interval-upper-bound interval 0))
               (upper-j (%%interval-upper-bound interval 1))
               (upper-k (%%interval-upper-bound interval 2))
               (upper-l (%%interval-upper-bound interval 3)))
           (let i-loop ((i lower-i))
             (if (< i upper-i)
                 (let j-loop ((j lower-j))
                   (if (< j upper-j)
                       (let k-loop ((k lower-k))
                         (if (< k upper-k)
                             (let l-loop ((l lower-l))
                               (if (< l upper-l)
                                   (begin
                                     (f i j k l)
                                     (l-loop (+ l 1)))
                                   (k-loop (+ k 1))))
                             (j-loop (+ j 1))))
                       (i-loop (+ i 1))))))))
    (else

     (let* ((lower-bounds (%%interval-lower-bounds->list interval))
            (upper-bounds (%%interval-upper-bounds->list interval))
            (arg          (map values lower-bounds)))                ; copy lower-bounds

       ;; I'm not particularly happy with set! here because f might capture the continuation
       ;; and then funny things might pursue ...
       ;; But it seems that the only way to have this work efficiently without the set
       ;; is to have arrays with fortran-style numbering.
       ;; blah

       (define (iterate lower-bounds-tail
                        upper-bounds-tail
                        arg-tail)
         (let ((lower-bound (car lower-bounds-tail))
               (upper-bound (car upper-bounds-tail)))
           (if (null? (cdr arg-tail))
               (let loop ((i lower-bound))
                 (if (< i upper-bound)
                     (begin
                       (set-car! arg-tail i)
                       (apply f arg)
                       (loop (+ i 1)))))
               (let loop ((i lower-bound))
                 (if (< i upper-bound)
                     (begin
                       (set-car! arg-tail i)
                       (iterate (cdr lower-bounds-tail)
                                (cdr upper-bounds-tail)
                                (cdr arg-tail))
                       (loop (+ i 1))))))))

       (iterate lower-bounds
                upper-bounds
                arg)))))

;;; Calculates
;;;
;;; (...(operator (operator (operator identity (f multi-index_1)) (f multi-index_2)) (f multi-index_3)) ...)
;;;
;;; where multi-index_1, multi-index_2, ... are the elements of interval in lexicographical order
;;; This version assumes, and may use, that f is thread-safe and that operator is associative.
;;; The order of application of f and operator is not specified.

(define (%%interval-fold f operator identity interval)
  (case (%%interval-dimension interval)
    ((1) (let ((lower-i (%%interval-lower-bound interval 0))
               (upper-i (%%interval-upper-bound interval 0)))
           (let i-loop ((i lower-i) (result identity))
             (if (= i upper-i)
                 result
                 (i-loop (+ i 1) (operator (f i) result))))))
    ((2) (let ((lower-i (%%interval-lower-bound interval 0))
               (lower-j (%%interval-lower-bound interval 1))
               (upper-i (%%interval-upper-bound interval 0))
               (upper-j (%%interval-upper-bound interval 1)))
           (let i-loop ((i lower-i) (result identity))
             (if (= i upper-i)
                 result
                 (let j-loop ((j lower-j) (result result))
                   (if (= j upper-j)
                       (i-loop (+ i 1) result)
                       (j-loop (+ j 1) (operator (f i j) result))))))))
    ((3) (let ((lower-i (%%interval-lower-bound interval 0))
               (lower-j (%%interval-lower-bound interval 1))
               (lower-k (%%interval-lower-bound interval 2))
               (upper-i (%%interval-upper-bound interval 0))
               (upper-j (%%interval-upper-bound interval 1))
               (upper-k (%%interval-upper-bound interval 2)))
           (let i-loop ((i lower-i) (result identity))
             (if (= i upper-i)
                 result
                 (let j-loop ((j lower-j) (result result))
                   (if (= j upper-j)
                       (i-loop (+ i 1) result)
                       (let k-loop ((k lower-k) (result result))
                         (if (= k upper-k)
                             (j-loop (+ j 1) result)
                             (k-loop (+ k 1) (operator (f i j k) result))))))))))
    ((4) (let ((lower-i (%%interval-lower-bound interval 0))
               (lower-j (%%interval-lower-bound interval 1))
               (lower-k (%%interval-lower-bound interval 2))
               (lower-l (%%interval-lower-bound interval 3))
               (upper-i (%%interval-upper-bound interval 0))
               (upper-j (%%interval-upper-bound interval 1))
               (upper-k (%%interval-upper-bound interval 2))
               (upper-l (%%interval-upper-bound interval 3)))
           (let i-loop ((i lower-i) (result identity))
             (if (= i upper-i)
                 result
                 (let j-loop ((j lower-j) (result result))
                   (if (= j upper-j)
                       (i-loop (+ i 1) result)
                       (let k-loop ((k lower-k) (result result))
                         (if (= k upper-k)
                             (j-loop (+ j 1) result)
                             (let l-loop ((l lower-l) (result result))
                               (if (= l upper-l)
                                   (k-loop (+ k 1) result)
                                   (l-loop (+ l 1) (operator (f i j k l) result))))))))))))
    (else
     (let* ((lower-bounds (%%interval-lower-bounds->list interval))
            (upper-bounds (%%interval-upper-bounds->list interval))
            (arg          (map values lower-bounds)))                ; copy lower-bounds

       ;; I'm not particularly happy with set! here because f or operator might capture
       ;; the continuation and then funny things might pursue ...
       ;; But it seems that the only way to have this work efficiently without the set~
       ;; is to have arrays with fortran-style numbering.
       ;; blah

       (define (iterate lower-bounds-tail
                        upper-bounds-tail
                        arg-tail
                        result)
         (let ((lower-bound (car lower-bounds-tail))
               (upper-bound (car upper-bounds-tail)))
           (if (null? (cdr arg-tail))
               (let loop ((i lower-bound)
                          (result result))
                 (if (= i upper-bound)
                     result
                     (begin
                       (set-car! arg-tail i)
                       (loop (+ i 1)
                             (operator (apply f arg) result)))))
               (let loop ((i lower-bound)
                          (result result))
                 (if (= i upper-bound)
                     result
                     (begin
                       (set-car! arg-tail i)
                       (loop (+ i 1)
                             (iterate (cdr lower-bounds-tail)
                                      (cdr upper-bounds-tail)
                                      (cdr arg-tail)
                                      result))))))))

       (iterate lower-bounds
                upper-bounds
                arg
                identity)))))

;; We'll use the same basic container for all types of arrays.

(declare (inline))

(define-structure %%array
  ;; Part of all arrays
  domain                  ;; an interval
  getter                  ;; (lambda (i_0 ... i_n-1) ...) returns a value for (i_0,...,i_n-1) in (array-domain a)
  ;; Part of mutable arrays
  setter                  ;; (lambda (v i_0 ... i_n-1) ...) sets a value for (i_0,...,i_n-1) in (array-domain a)
  ;; Part of specialized arrays
  storage-class           ;; a storage-class
  body                    ;; the backing store for this array
  indexer                 ;; see below
  safe?                   ;; do we check whether bounds (in getters and setters) and values (in setters) are valid
  in-order?               ;; are the elements adjacent and in order?
  copier: #f              ;; We'll define our own %%array-copy
  )

(define specialized-array-default-safe?
  (let ((%%specialized-array-default-safe? #f))
    (case-lambda
     (() %%specialized-array-default-safe?)
     ((bool)
      (cond ((not (boolean? bool))
             (error "specialized-array-default-safe?: The argument is not a boolean: " bool))
            (else
             (set! %%specialized-array-default-safe? bool)))))))

(define specialized-array-default-mutable?
  (let ((%%specialized-array-default-mutable? #t))
    (case-lambda
     (()
      %%specialized-array-default-mutable?)
     ((bool)
      (cond ((not (boolean? bool))
             (error "specialized-array-default-mutable?: The argument is not a boolean: " bool))
            (else
             (set! %%specialized-array-default-mutable? bool)))))))


(declare (not inline))

;; An array has a domain (which is an interval) and an getter that maps that domain into some type of
;; Scheme objects

(define %%order-unknown 1) ;; can be any nonboolean

(define make-array
  (case-lambda
   ((domain getter)
    (cond ((not (interval? domain))
           (error "make-array: The first argument is not an interval: " domain getter))
          ((not (procedure? getter))
           (error "make-array: The second argument is not a procedure: " domain getter))
          (else
           (make-%%array domain
                         getter
                         #f              ; no setter
                         #f              ; storage-class
                         #f              ; body
                         #f              ; indexer
                         #f              ; safe?
                         %%order-unknown ; in-order?
                         ))))
   ((domain getter setter)
    (cond ((not (interval? domain))
           (error "make-array: The first argument is not an interval: " domain getter setter))
          ((not (procedure? getter))
           (error "make-array: The second argument is not a procedure: " domain getter setter))
          ((not (procedure? setter))
           (error "make-array: The third argument is not a procedure: " domain getter setter))
          (else
           (make-%%array domain
                         getter
                         setter
                         #f              ; storage-class
                         #f              ; body
                         #f              ; indexer
                         #f              ; safe?
                         %%order-unknown ; in-order?
                         ))))))

(define (array? x)
  (%%array? x))

(define (array-domain obj)
  (cond ((not (array? obj))
         (error "array-domain: The argument is not an array: " obj))
        (else
         (%%array-domain obj))))

(define (array-getter obj)
  (cond ((not (array? obj))
         (error "array-getter: The argument is not an array: " obj))
        (else
         (%%array-getter obj))))

(define (%%array-dimension array)
  (%%interval-dimension (%%array-domain array)))

(define (array-dimension array)
  (cond ((not (array? array))
         (error "array-dimension: The argument is not an array: " array))
        (else
         (%%array-dimension array))))


;;;
;;; A mutable array has, in addition a setter, that satisfies, roughly
;;;
;;; If (i_1, ..., i_n)\neq (j_1, ..., j_n) \in (array-domain a)
;;;
;;; and
;;;
;;; ((array-getter a) j_1 ... j_n) => x
;;;
;;; then "after"
;;;
;;; ((array-setter a) v i_1 ... i_n)
;;;
;;; we have
;;;
;;; ((array-getter a) j_1 ... j_n) => x
;;;
;;; and
;;;
;;; ((array-getter a) i_1 ... i_n) => v
;;;

(define (mutable-array? obj)
  (and (array? obj)
       (not (eq? (%%array-setter obj) #f))))

(define (array-setter obj)
  (cond ((not (mutable-array? obj))
         (error "array-setter: The argument is not an mutable array: " obj))
        (else
         (%%array-setter obj))))

;;;
;;; A storage-class contains functions and objects to manipulate the
;;; backing store of a specialized-array.
;;;
;;; getter:   (lambda (body i) ...)   returns the value of body at index i
;;; setter:   (lambda (body i v) ...) sets the value of body at index i to v
;;; checker:  (lambda (val) ...)      checks that val is an appropriate value for storing in (maker n)
;;; maker:    (lambda (n val) ...)    makes a body of length n with value val
;;; length:   (lambda (body) ...)     returns the number of objects in body
;;; default:  object                  is the default value with which to fill body
;;;

(define-structure storage-class getter setter checker maker copier length default)

;;; We define specialized storage-classes for:
;;;
;;; 32- and 64-bit floating-point numbers,
;;; complex numbers with real and imaginary parts of 32- and 64-bit floating-point numbers respectively
;;; 8-, 16-, 32-, and 64-bit signed integers,
;;; 8-, 16-, 32-, and 64-bit unsigned integers, and
;;; 1-bit unsigned integers
;;;
;;; as well as generic objects.

(define-macro (srfi/179#make-standard-storage-classes)

  (define (symbol-concatenate . symbols)
    (string->symbol (apply string-append (map (lambda (s)
                                                (if (string? s)
                                                    s
                                                    (symbol->string s)))
                                              symbols))))

  `(begin
     ,@(map (lambda (name prefix default checker)
              `(define ,(symbol-concatenate name '-storage-class)
                 (make-storage-class
                  ;; getter:
                  (lambda (v i)
                    (,(symbol-concatenate prefix 'vector-ref) v i))
                  ;; setter:
                  (lambda (v i val)
                    (,(symbol-concatenate prefix 'vector-set!) v i val))
                  ;; checker
                  ,checker
                  ;; maker:
                  ,(symbol-concatenate 'make- prefix 'vector)
                  ;; copier
                  ,(symbol-concatenate prefix 'vector-copy!)
                  ;; length:
                  ,(symbol-concatenate prefix 'vector-length)
                  ;; default:
                  ,default)))
            '(generic s8 u8 s16 u16 s32 u32 s64 u64 f32 f64)
            '(""      s8 u8 s16 u16 s32 u32 s64 u64 f32 f64)
            '(#f       0  0   0   0   0   0   0   0 0.0 0.0)
            `((lambda (x) #t)                             ; generic
              (lambda (x)                                 ; s8
                (and (fixnum? x)
                     (fx<= ,(- (expt 2 7))
                           x
                           ,(- (expt 2 7) 1))))
              (lambda (x)                                ; u8
                (and (fixnum? x)
                     (fx<= 0
                           x
                           ,(- (expt 2 8) 1))))
              (lambda (x)                               ; s16
                (and (fixnum? x)
                     (fx<= ,(- (expt 2 15))
                           x
                           ,(- (expt 2 15) 1))))
              (lambda (x)                               ; u16
                (and (fixnum? x)
                     (fx<= 0
                           x
                           ,(- (expt 2 16) 1))))
              (lambda (x)                               ; s32
                (declare (generic))
                (and (exact-integer? x)
                     (<= ,(- (expt 2 31))
                         x
                         ,(- (expt 2 31) 1))))
              (lambda (x)                               ; u32
                (declare (generic))
                (and (exact-integer? x)
                     (<= 0
                         x
                         ,(- (expt 2 32) 1))))
              (lambda (x)                              ; s64
                (declare (generic))
                (and (exact-integer? x)
                     (<= ,(- (expt 2 63))
                         x
                         ,(- (expt 2 63) 1))))
              (lambda (x)                              ; u64
                (declare (generic))
                (and (exact-integer? x)
                     (<= 0
                         x
                         ,(- (expt 2 64) 1))))
              (lambda (x) (flonum? x))               ; f32
              (lambda (x) (flonum? x))               ; f64
              ))))

(make-standard-storage-classes)

;;; This sample implementation does not implement the following.

(define f16-storage-class #f)
(define f8-storage-class #f)

;;; for bit-arrays, body is a vector, the first element of which is the actual number of elements,
;;; the second element of which is a u16vector that contains the bit string

(define u1-storage-class
  (make-storage-class
   ;; getter:
   (lambda (v i)
     (let ((index (fxarithmetic-shift-right i 4))
           (shift (fxand i 15))
           (bodyv (vector-ref v  1)))
       (fxand
        (fxarithmetic-shift-right
         (u16vector-ref bodyv index)
         shift)
        1)))
   ;; setter:
   (lambda (v i val)
     (let ((index (fxarithmetic-shift-right i 4))
           (shift (fxand i 15))
           (bodyv (vector-ref v  1)))
       (u16vector-set! bodyv index (fxior (fxarithmetic-shift-left val shift)
                                          (fxand (u16vector-ref bodyv index)
                                                 (fxnot  (fxarithmetic-shift-left 1 shift)))))))
   ;; checker
   (lambda (val)
     (and (fixnum? val)
          (eq? 0 (fxand -2 val))))
   ;; maker:
   (lambda (size initializer)
     (let ((u16-size (fxarithmetic-shift-right (+ size 15) 4)))
       (vector size (make-u16vector u16-size (if (eqv? 0 initializer) 0 65535)))))
   ;; no copier (for now)
   #f
   ;; length:
   (lambda (v)
     (vector-ref v 0))
   ;; default:
   0))

(define-macro (srfi/179#make-complex-storage-classes)
  (define (symbol-concatenate . symbols)
    (string->symbol (apply string-append (map (lambda (s)
                                                (if (string? s)
                                                    s
                                                    (symbol->string s)))
                                              symbols))))
  (define construct
    (lambda (size)
      (let ((prefix (string-append "c" (number->string (fx* 2 size))))
            (floating-point-prefix (string-append "f" (number->string size))))
        `(define ,(symbol-concatenate prefix '-storage-class)
           (make-storage-class
            ;; getter
            (lambda (body i)
              (make-rectangular (,(symbol-concatenate floating-point-prefix 'vector-ref) body (fx* 2 i))
                                (,(symbol-concatenate floating-point-prefix 'vector-ref) body (fx+ (fx* 2 i) 1))))
            ;; setter
            (lambda (body i obj)
              (,(symbol-concatenate floating-point-prefix 'vector-set!) body (fx* 2 i)         (real-part obj))
              (,(symbol-concatenate floating-point-prefix 'vector-set!) body (fx+ (fx* 2 i) 1) (imag-part obj)))
            ;; checker
            (lambda (obj)
              (and (complex? obj)
                   (inexact? (real-part obj))
                   (inexact? (imag-part obj))))
            ;; maker
            (lambda (n val)
              (let ((l (* 2 n))
                    (re (real-part val))
                    (im (imag-part val)))
                (let ((result (,(symbol-concatenate 'make-
                                                    floating-point-prefix
                                                    'vector)
                               l)))
                  (do ((i 0 (+ i 2)))
                      ((= i l) result)
                    (,(symbol-concatenate floating-point-prefix 'vector-set!) result i re)
                    (,(symbol-concatenate floating-point-prefix 'vector-set!) result (fx+ i 1) im)))))
            ;; copier
            ,(symbol-concatenate prefix 'vector-copy!)
            ;; length
            (lambda (body)
              (fxquotient (,(symbol-concatenate floating-point-prefix 'vector-length) body) 2))
            ;; default
            0.+0.i)))))
  (let ((result
         `(begin
            ,@(map construct
                   '(32 64)))))
    result))

(make-complex-storage-classes)

;;;
;;; Conceptually, an indexer is itself a 1-1 array that maps one interval to another; thus, it is
;;; an example of an array that can return multiple values.
;;;
;;; Rather than trying to formalize this idea, and trying to get it to work with array-map,
;;; array-fold, ..., we'll just manipulate the getter functions of these conceptual arrays.
;;;
;;; Indexers are 1-1 affine maps from one interval to another.
;;;
;;; The indexer field of a specialized-array obj is a 1-1 mapping from
;;;
;;; (array-domain obj)
;;;
;;; to [0, top), where top is
;;;
;;; ((storage-class-length (array-storage-class obj)) (array-body obj))
;;;

;; unfortunately, the next two functions were written by hand, so beware of bugs.

(define (%%indexer-1 base
                     low-0
                     increment-0)
  (if (eqv? base 0)
      (if (eqv? 0 low-0)
          (cond ((eqv? 1 increment-0)    (lambda (i) i))
                ;;((eqv? -1 increment-0)   (lambda (i) (- i)))               ;; an impossible case
                (else                    (lambda (i) (* i increment-0))))
          (cond ((eqv? 1 increment-0)    (lambda (i) (- i low-0)))
                ;;((eqv? -1 increment-0)   (lambda (i) (- low-0 i)))         ;; an impossible case
                (else                    (lambda (i) (* increment-0 (- i low-0))))))
      (if (eqv? 0 low-0)
          (cond ((eqv? 1 increment-0)    (lambda (i) (+ base i)))
                ((eqv? -1 increment-0)   (lambda (i) (- base i)))
                (else                    (lambda (i) (+ base (* increment-0 i)))))
          (cond ((eqv? 1 increment-0)    (lambda (i) (+ base (- i low-0))))
                ((eqv? -1 increment-0)   (lambda (i) (+ base (- low-0 i))))
                (else                    (lambda (i) (+ base (* increment-0 (- i low-0)))))))))

(define (%%indexer-2 base
                     low-0       low-1
                     increment-0 increment-1)
  (if (eqv? 0 base)
      (if (eqv? 0 low-0)
          (cond ((eqv? 1 increment-0)
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ i j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ i (- j))))
                           (else                  (lambda (i j) (+ i (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ i (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ i (- low-1 j))))
                           (else                  (lambda (i j) (+ i (* increment-1 (- j low-1))))))))
               #; ((eqv? -1 increment-0)         ;; an impossible case
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- j                           i)))
                           ((eqv? -1 increment-1) (lambda (i j) (- (- j)                       i)))
                           (else                  (lambda (i j) (- (* increment-1 j)           i))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- (- j low-1)                 i)))
                           ((eqv? -1 increment-1) (lambda (i j) (- (- low-1 j)                 i)))
                           (else                  (lambda (i j) (- (* increment-1 (- j low-1)) i))))))
                (else
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ (* increment-0 i) j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ (* increment-0 i) (- j))))
                           (else                  (lambda (i j) (+ (* increment-0 i) (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ (* increment-0 i) (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ (* increment-0 i) (- low-1 j))))
                           (else                  (lambda (i j) (+ (* increment-0 i) (* increment-1 (- j low-1)))))))))
          (cond ((eqv? 1 increment-0)
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ (- i low-0) j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ (- i low-0) (- j))))
                           (else                  (lambda (i j) (+ (- i low-0) (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ (- i low-0) (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ (- i low-0) (- low-1 j))))
                           (else                  (lambda (i j) (+ (- i low-0) (* increment-1 (- j low-1))))))))
                #;((eqv? -1 increment-0)         ;; an impossible case
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- j                           (- i low-0))))
                           ((eqv? -1 increment-1) (lambda (i j) (- (- j)                       (- i low-0))))
                           (else                  (lambda (i j) (- (* increment-1 j)           (- i low-0)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- (- j low-1)                 (- i low-0))))
                           ((eqv? -1 increment-1) (lambda (i j) (- (- low-1 j)                 (- i low-0))))
                           (else                  (lambda (i j) (- (* increment-1 (- j low-1)) (- i low-0)))))))
                (else
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ (* increment-0 (- i low-0)) j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ (* increment-0 (- i low-0)) (- j))))
                           (else                  (lambda (i j) (+ (* increment-0 (- i low-0)) (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ (* increment-0 (- i low-0)) (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ (* increment-0 (- i low-0)) (- low-1 j))))
                           (else                  (lambda (i j) (+ (* increment-0 (- i low-0)) (* increment-1 (- j low-1))))))))))
      (if (eqv? 0 low-0)
          (cond ((eqv? 1 increment-0)
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base i j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base i (- j))))
                           (else                  (lambda (i j) (+ base i (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base i (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base i (- low-1 j))))
                           (else                  (lambda (i j) (+ base i (* increment-1 (- j low-1))))))))
                ((eqv? -1 increment-0)
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- (+ base j)                           i)))
                           ((eqv? -1 increment-1) (lambda (i j) (- (- base j)                           i)))
                           (else                  (lambda (i j) (- (+ base (* increment-1 j))           i))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- (+ base (- j low-1))                 i)))
                           ((eqv? -1 increment-1) (lambda (i j) (- (+ base (- low-1 j))                 i)))
                           (else                  (lambda (i j) (- (+ base (* increment-1 (- j low-1))) i))))))
                (else
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base (* increment-0 i) j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base (* increment-0 i) (- j))))
                           (else                  (lambda (i j) (+ base (* increment-0 i) (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base (* increment-0 i) (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base (* increment-0 i) (- low-1 j))))
                           (else                  (lambda (i j) (+ base (* increment-0 i) (* increment-1 (- j low-1)))))))))
          (cond ((eqv? 1 increment-0)
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base (- i low-0) j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base (- i low-0) (- j))))
                           (else                  (lambda (i j) (+ base (- i low-0) (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base (- i low-0) (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base (- i low-0) (- low-1 j))))
                           (else                  (lambda (i j) (+ base (- i low-0) (* increment-1 (- j low-1))))))))
                ((eqv? -1 increment-0)
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- (+ base j)                           (- i low-0))))
                           ((eqv? -1 increment-1) (lambda (i j) (- (- base j)                           (- i low-0))))
                           (else                  (lambda (i j) (- (+ base (* increment-1 j))           (- i low-0)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (- (+ base (- j low-1))                 (- i low-0))))
                           ((eqv? -1 increment-1) (lambda (i j) (- (+ base (- low-1 j))                 (- i low-0))))
                           (else                  (lambda (i j) (- (+ base (* increment-1 (- j low-1))) (- i low-0)))))))
                (else
                 (if (eqv? 0 low-1)
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base (* increment-0 (- i low-0)) j)))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base (* increment-0 (- i low-0)) (- j))))
                           (else                  (lambda (i j) (+ base (* increment-0 (- i low-0)) (* increment-1 j)))))
                     (cond ((eqv? 1 increment-1)  (lambda (i j) (+ base (* increment-0 (- i low-0)) (- j low-1))))
                           ((eqv? -1 increment-1) (lambda (i j) (+ base (* increment-0 (- i low-0)) (- low-1 j))))
                           (else                  (lambda (i j) (+ base (* increment-0 (- i low-0)) (* increment-1 (- j low-1))))))))))))

;;; after this we basically punt

(define (%%indexer-3 base
                     low-0       low-1       low-2
                     increment-0 increment-1 increment-2)
  (if (and (eqv? 0 low-0)
           (eqv? 0 low-1)
           (eqv? 0 low-2))
      (if (eqv? base 0)
          (if (eqv? increment-2 1)
              (lambda (i j k)
                (+ (* increment-0 i)
                   (* increment-1 j)
                   k))
              (lambda (i j k)
                (+ (* increment-0 i)
                   (* increment-1 j)
                   (* increment-2 k))))
          (if (eqv? increment-2 1)
              (lambda (i j k)
                (+ base
                   (* increment-0 i)
                   (* increment-1 j)
                   k))
              (lambda (i j k)
                (+ base
                   (* increment-0 i)
                   (* increment-1 j)
                   (* increment-2 k)))))
      (if (eqv? base 0)
          (if (eqv? increment-2 1)
              (lambda (i j k)
                (+ (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (- k low-2)))
              (lambda (i j k)
                (+ (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (* increment-2 (- k low-2)))))
          (if (eqv? increment-2 1)
              (lambda (i j k)
                (+ base
                   (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (- k low-2)))
              (lambda (i j k)
                (+ base
                   (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (* increment-2 (- k low-2))))))))

(define (%%indexer-4 base
                     low-0       low-1       low-2       low-3
                     increment-0 increment-1 increment-2 increment-3)
  (if (and (eqv? 0 low-0)
           (eqv? 0 low-1)
           (eqv? 0 low-2)
           (eqv? 0 low-3))
      (if (eqv? base 0)
          (if (eqv? increment-3 1)
              (lambda (i j k l)
                (+ (* increment-0 i)
                   (* increment-1 j)
                   (* increment-2 k)
                   l))
              (lambda (i j k l)
                (+ (* increment-0 i)
                   (* increment-1 j)
                   (* increment-2 k)
                   (* increment-3 l))))
          (if (eqv? increment-3 1)
              (lambda (i j k l)
                (+ base
                   (* increment-0 i)
                   (* increment-1 j)
                   (* increment-2 k)
                   l))
              (lambda (i j k l)
                (+ base
                   (* increment-0 i)
                   (* increment-1 j)
                   (* increment-2 k)
                   (* increment-3 l)))))
      (if (eqv? base 0)
          (if (eqv? increment-3 1)
              (lambda (i j k l)
                (+ (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (* increment-2 (- k low-2))
                   (- l low-3)))
              (lambda (i j k l)
                (+ (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (* increment-2 (- k low-2))
                   (* increment-3 (- l low-3)))))
          (if (eqv? increment-3 1)
              (lambda (i j k l)
                (+ base
                   (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (* increment-2 (- k low-2))
                   (- l low-3)))
              (lambda (i j k l)
                (+ base
                   (* increment-0 (- i low-0))
                   (* increment-1 (- j low-1))
                   (* increment-2 (- k low-2))
                   (* increment-3 (- l low-3))))))))

(define (%%indexer-generic base lower-bounds increments)
  (let ((result
         (lambda multi-index
           (do ((multi-index  multi-index  (cdr multi-index))
                (lower-bounds lower-bounds (cdr lower-bounds))
                (increments   increments   (cdr increments))
                (result       base         (+ result (* (car increments)
                                                        (- (car multi-index)
                                                           (car lower-bounds))))))
               ((null? multi-index) result)))))
    result))


;;;
;;; The default getter and the setter of a specialized-array a are given by
;;;
;;; (lambda (i_0 ... i_n-1)
;;;   ((storage-class-getter (array-storage-class a))
;;;    (array-body a)
;;;    ((array-indexer a) i_0 ... i_n-1)))
;;;
;;; (lambda (v i_0 ... i_n-1)
;;;   ((storage-class-setter (array-storage-class a))
;;;    (array-body a)
;;;    ((array-indexer a) i_0 ... i_n-1)
;;;    v))
;;;
;;; The default initializer-value is
;;;
;;; (storage-class-default (array-storage-class a))
;;;
;;; The default body is
;;;
;;; ((storage-class-maker (array-storage-class a))
;;;  (interval-volume domain)
;;;  initializer-value)
;;;
;;; The default indexer is the mapping of
;;; the domain to the natural numbers in lexicographical order.
;;;

(define (specialized-array? obj)
  (and (array? obj)
       (not (eq? (%%array-body obj) #f))))

(define (array-body obj)
  (cond ((not (specialized-array? obj))
         (error "array-body: The argument is not a specialized array: " obj))
        (else
         (%%array-body obj))))

(define (array-indexer obj)
  (cond ((not (specialized-array? obj))
         (error "array-indexer: The argument is not a specialized array: " obj))
        (else
         (%%array-indexer obj))))

(define (array-storage-class obj)
  (cond ((not (specialized-array? obj))
         (error "array-storage-class: The argument is not a specialized array: " obj))
        (else
         (%%array-storage-class obj))))

(define (array-safe? obj)
  (cond ((not (specialized-array? obj))
         (error "array-safe?: The argument is not a specialized array: " obj))
        (else
         (%%array-safe? obj))))

(define (%%compute-array-elements-in-order? domain indexer)
  (case (%%interval-dimension domain)
    ((1) (let ((lower-0 (%%interval-lower-bound domain 0))
               (upper-0 (%%interval-upper-bound domain 0)))
           (let ((increment 1))
             (or (eqv? 1 (- upper-0 lower-0))
                 (= increment
                    (- (indexer (+ lower-0 1))
                       (indexer lower-0)))))))
    ((2) (let ((lower-0 (%%interval-lower-bound domain 0))
               (lower-1 (%%interval-lower-bound domain 1))
               (upper-0 (%%interval-upper-bound domain 0))
               (upper-1 (%%interval-upper-bound domain 1)))
           (let ((increment 1))
             (and (or (eqv? 1 (- upper-1 lower-1))
                      (= increment
                         (- (indexer lower-0 (+ lower-1 1))
                            (indexer lower-0    lower-1))))
                  (let ((increment (* increment (- upper-1 lower-1))))
                    (or (eqv? 1 (- upper-0 lower-0))
                        (= increment
                           (- (indexer (+ lower-0 1) lower-1)
                              (indexer    lower-0    lower-1)))))))))
    ((3) (let ((lower-0 (%%interval-lower-bound domain 0))
               (lower-1 (%%interval-lower-bound domain 1))
               (lower-2 (%%interval-lower-bound domain 2))
               (upper-0 (%%interval-upper-bound domain 0))
               (upper-1 (%%interval-upper-bound domain 1))
               (upper-2 (%%interval-upper-bound domain 2)))
           (let ((increment 1))
             (and (or (eqv? 1 (- upper-2 lower-2))
                      (= increment
                         (- (indexer lower-0 lower-1 (+ lower-2 1))
                            (indexer lower-0 lower-1    lower-2))))
                  (let ((increment (* increment (- upper-2 lower-2))))
                    (and (or (eqv? 1 (- upper-1 lower-1))
                             (= increment
                                (- (indexer lower-0 (+ lower-1 1) lower-2)
                                   (indexer lower-0    lower-1    lower-2))))
                         (let ((increment (* increment (- upper-1 lower-1))))
                           (or (eqv? 1 (- upper-0 lower-0))
                               (= increment
                                  (- (indexer (+ lower-0 1) lower-1 lower-2)
                                     (indexer    lower-0    lower-1 lower-2)))))))))))
    ((4) (let ((lower-0 (%%interval-lower-bound domain 0))
               (lower-1 (%%interval-lower-bound domain 1))
               (lower-2 (%%interval-lower-bound domain 2))
               (lower-3 (%%interval-lower-bound domain 3))
               (upper-0 (%%interval-upper-bound domain 0))
               (upper-1 (%%interval-upper-bound domain 1))
               (upper-2 (%%interval-upper-bound domain 2))
               (upper-3 (%%interval-upper-bound domain 3)))
           (let ((increment 1))
             (and (or (eqv? 1 (- upper-3 lower-3))
                      (= increment
                         (- (indexer lower-0 lower-1 lower-2 (+ lower-3 1))
                            (indexer lower-0 lower-1 lower-2    lower-3))))
                  (let ((increment (* increment (- upper-3 lower-3))))
                    (and (or (eqv? 1 (- upper-2 lower-2))
                             (= increment
                                (- (indexer lower-0 lower-1 (+ lower-2 1) lower-3)
                                   (indexer lower-0 lower-1    lower-2    lower-3))))
                         (let ((increment (* increment (- upper-2 lower-2))))
                           (and (or (eqv? 1 (- upper-1 lower-1))
                                    (= increment
                                       (- (indexer lower-0 (+ lower-1 1) lower-2 lower-3)
                                          (indexer lower-0    lower-1    lower-2 lower-3))))
                                (let ((increment (* increment (- upper-1 lower-1))))
                                  (or (eqv? 1 (- upper-0 lower-0))
                                      (= increment
                                         (- (indexer (+ lower-0 1) lower-1 lower-2 lower-3)
                                            (indexer    lower-0    lower-1 lower-2 lower-3)))))))))))))
    (else (let ((global-lowers
                 ;; will use as an argument list
                 (%%interval-lower-bounds->list domain))
                (global-lowers+1
                 ;; will modify and use as an argument list
                 (%%interval-lower-bounds->list domain)))
            (and
             (let loop ((lowers global-lowers+1)
                        (uppers (%%interval-upper-bounds->list domain)))
               ;; returns either #f or the increment
               ;; that the difference of indexers must equal.
               (if (null? lowers)
                   1 ;; increment
                   (let ((increment (loop (cdr lowers) (cdr uppers))))
                     (and increment
                          (or (and (eqv? 1 (- (car uppers) (car lowers)))
                                   ;; increment doesn't change
                                   increment)
                              (begin
                                ;; increment the correct index by 1
                                (set-car! lowers (+ (car lowers) 1))
                                (and (= (- (apply indexer global-lowers+1)
                                           (apply indexer global-lowers))
                                        increment)
                                     (begin
                                       ;; set it back
                                       (set-car! lowers (- (car lowers) 1))
                                       ;; multiply the increment by the difference in
                                       ;; the current upper and lower bounds and
                                       ;; return it.
                                       (* increment (- (car uppers) (car lowers)))))))))))
             ;; return a proper boolean instead of the volume of the domain
             #t)))))

(define (%%array-elements-in-order? array)
  (let ((in-order? (%%array-in-order? array)))
    (if (boolean? in-order?)
        in-order?
        (let ((in-order?
               (%%compute-array-elements-in-order?
                (%%array-domain array)
                (%%array-indexer array))))
          (%%array-in-order?-set! array in-order?)
          in-order?))))

(define (array-elements-in-order? array)
  (cond ((not (specialized-array? array))
         (error "array-elements-in-order?: The argument is not a specialized array: " array))
        (else
         (%%array-elements-in-order? array))))


(define (%%finish-specialized-array domain storage-class body indexer mutable? safe? in-order?)
  (let ((storage-class-getter (storage-class-getter storage-class))
        (storage-class-setter (storage-class-setter storage-class))
        (checker (storage-class-checker storage-class))
        (indexer indexer)
        (body body))

    ;;; we write the following three macros to specialize the setters and getters in the
    ;;; non-safe case to reduce one more function call.

    (define-macro (expand-storage-class original-suffix replacement-suffix expr)

      (define (symbol-append . args)
        (string->symbol (apply string-append (map (lambda (x) (if (symbol? x) (symbol->string x) x)) args))))

      (define (replace old-symbol new-symbol expr)
        (let loop ((expr expr))
          (cond ((pair? expr)           ;; we don't use map because of dotted argument list in general setter
                 (cons (loop (car expr))
                       (loop (cdr expr))))
                ((eq? expr old-symbol)
                 new-symbol)
                (else
                 expr))))

      `(cond ,@(map (lambda (name prefix)
                      `((eq? storage-class ,(symbol-append name '-storage-class))
                        ,(replace (symbol-append 'storage-class original-suffix)
                                  (symbol-append prefix 'vector replacement-suffix)
                                  expr)))
                    '(generic s8 u8 s16 u16 s32 u32 s64 u64 f32 f64)
                    '(""      s8 u8 s16 u16 s32 u32 s64 u64 f32 f64))
             (else
              ,expr)))

    (define-macro (expand-getters expr)
      `(expand-storage-class -getter -ref ,expr))

    (define-macro (expand-setters expr)
      `(expand-storage-class -setter -set! ,expr))

    (let ((getter
           (if safe?
               (case (%%interval-dimension domain)
                 ((1)  (lambda (i)
                         (cond ((not (exact-integer? i))
                                (error "array-getter: multi-index component is not an exact integer: " i))
                               ((not (%%interval-contains-multi-index?-1 domain i))
                                (error "array-getter: domain does not contain multi-index: "    domain i))
                               (else
                                (storage-class-getter body (indexer i))))))
                 ((2)  (lambda (i j)
                         (cond ((not (and (exact-integer? i)
                                          (exact-integer? j)))
                                (error "array-getter: multi-index component is not an exact integer: " i j))
                               ((not (%%interval-contains-multi-index?-2 domain i j))
                                (error "array-getter: domain does not contain multi-index: "    domain i j))
                               (else
                                (storage-class-getter body (indexer i j))))))
                 ((3)  (lambda (i j k)
                         (cond ((not (and (exact-integer? i)
                                          (exact-integer? j)
                                          (exact-integer? k)))
                                (error "array-getter: multi-index component is not an exact integer: " i j k))
                               ((not (%%interval-contains-multi-index?-3 domain i j k))
                                (error "array-getter: domain does not contain multi-index: "    domain i j k))
                               (else
                                (storage-class-getter body (indexer i j k))))))
                 ((4)  (lambda (i j k l)
                         (cond ((not (and (exact-integer? i)
                                          (exact-integer? j)
                                          (exact-integer? k)
                                          (exact-integer? l)))
                                (error "array-getter: multi-index component is not an exact integer: " i j k l))
                               ((not (%%interval-contains-multi-index?-4 domain i j k l))
                                (error "array-getter: domain does not contain multi-index: "    domain i j k l))
                               (else
                                (storage-class-getter body (indexer i j k l))))))
                 (else (lambda multi-index
                         (cond ((not (%%every (lambda (x) (exact-integer? x)) multi-index))
                                (apply error "array-getter: multi-index component is not an exact integer: " multi-index))
                               ((not (fx= (%%interval-dimension domain) (length multi-index)))
                                (apply error "array-getter: multi-index is not the correct dimension: " domain multi-index))
                               ((not (%%interval-contains-multi-index?-general domain multi-index))
                                (apply error "array-getter: domain does not contain multi-index: "    domain multi-index))
                               (else
                                (storage-class-getter body (apply indexer multi-index)))))))
               (case (%%interval-dimension domain)
                 ((1)  (expand-getters (lambda (i)         (storage-class-getter body (indexer i)))))
                 ((2)  (expand-getters (lambda (i j)       (storage-class-getter body (indexer i j)))))
                 ((3)  (expand-getters (lambda (i j k)     (storage-class-getter body (indexer i j k)))))
                 ((4)  (expand-getters (lambda (i j k l)   (storage-class-getter body (indexer i j k l)))))
                 (else (expand-getters (lambda multi-index (storage-class-getter body (apply indexer multi-index))))))))
          (setter
           (and mutable?
                (if safe?
                    (case (%%interval-dimension domain)
                      ((1)  (lambda (value i)
                              (cond ((not (exact-integer? i))
                                     (error "array-setter: multi-index component is not an exact integer: " i))
                                    ((not (%%interval-contains-multi-index?-1 domain i))
                                     (error "array-setter: domain does not contain multi-index: "    domain i))
                                    ((not (checker value))
                                     (error "array-setter: value cannot be stored in body: " value))
                                    (else
                                     (storage-class-setter body (indexer i) value)))))
                      ((2)  (lambda (value i j)
                              (cond ((not (and (exact-integer? i)
                                               (exact-integer? j)))
                                     (error "array-setter: multi-index component is not an exact integer: " i j))
                                    ((not (%%interval-contains-multi-index?-2 domain i j))
                                     (error "array-setter: domain does not contain multi-index: "    domain i j))
                                    ((not (checker value))
                                     (error "array-setter: value cannot be stored in body: " value))
                                    (else
                                     (storage-class-setter body (indexer i j) value)))))
                      ((3)  (lambda (value i j k)
                              (cond ((not (and (exact-integer? i)
                                               (exact-integer? j)
                                               (exact-integer? k)))
                                     (error "array-setter: multi-index component is not an exact integer: " i j k))
                                    ((not (%%interval-contains-multi-index?-3 domain i j k))
                                     (error "array-setter: domain does not contain multi-index: "    domain i j k))
                                    ((not (checker value))
                                     (error "array-setter: value cannot be stored in body: " value))
                                    (else
                                     (storage-class-setter body (indexer i j k) value)))))
                      ((4)  (lambda (value i j k l)
                              (cond ((not (and (exact-integer? i)
                                               (exact-integer? j)
                                               (exact-integer? k)
                                               (exact-integer? l)))
                                     (error "array-setter: multi-index component is not an exact integer: " i j k l))
                                    ((not (%%interval-contains-multi-index?-4 domain i j k l))
                                     (error "array-setter: domain does not contain multi-index: "    domain i j k l))
                                    ((not (checker value))
                                     (error "array-setter: value cannot be stored in body: " value))
                                    (else
                                     (storage-class-setter body (indexer i j k l) value)))))
                      (else (lambda (value . multi-index)
                              (cond ((not (%%every (lambda (x) (exact-integer? x)) multi-index))
                                     (apply error "array-setter: multi-index component is not an exact integer: " multi-index))
                                    ((not (fx= (%%interval-dimension domain) (length multi-index)))
                                     (apply error "array-setter: multi-index is not the correct dimension: " domain multi-index))
                                    ((not (%%interval-contains-multi-index?-general domain multi-index))
                                     (apply error "array-setter: domain does not contain multi-index: "    domain multi-index))
                                    ((not (checker value))
                                     (error "array-setter: value cannot be stored in body: " value))
                                    (else
                                     (storage-class-setter body (apply indexer multi-index) value))))))
                    (case (%%interval-dimension domain)
                      ((1)  (expand-setters (lambda (value i)             (storage-class-setter body (indexer i)                 value))))
                      ((2)  (expand-setters (lambda (value i j)           (storage-class-setter body (indexer i j)               value))))
                      ((3)  (expand-setters (lambda (value i j k)         (storage-class-setter body (indexer i j k)             value))))
                      ((4)  (expand-setters (lambda (value i j k l)       (storage-class-setter body (indexer i j k l)           value))))
                      (else (expand-setters (lambda (value . multi-index) (storage-class-setter body (apply indexer multi-index) value)))))))))
      (make-%%array domain
                    getter
                    setter
                    storage-class
                    body
                    indexer
                    safe?
                    in-order?))))

(define (%%interval->basic-indexer interval)
  (case (%%interval-dimension interval)
    ((1) (let ((low-0 (%%interval-lower-bound interval 0))
               (increment-0 1))
           (%%indexer-1 0 low-0 increment-0)))
    ((2) (let* ((low-0 (%%interval-lower-bound interval 0))
                (low-1 (%%interval-lower-bound interval 1))
                (increment-1 1)
                (increment-0 (* increment-1
                                (- (%%interval-upper-bound interval 1)
                                   (%%interval-lower-bound interval 1)))))
           (%%indexer-2 0
                        low-0 low-1
                        increment-0 increment-1)))
    ((3) (let* ((low-0 (%%interval-lower-bound interval 0))
                (low-1 (%%interval-lower-bound interval 1))
                (low-2 (%%interval-lower-bound interval 2))
                (increment-2 1)
                (increment-1 (* increment-2
                                (- (%%interval-upper-bound interval 2)
                                   (%%interval-lower-bound interval 2))))
                (increment-0 (* increment-1
                                (- (%%interval-upper-bound interval 1)
                                   (%%interval-lower-bound interval 1)))))
           (%%indexer-3 0
                        low-0 low-1 low-2
                        increment-0 increment-1 increment-2)))
    ((4) (let* ((low-0 (%%interval-lower-bound interval 0))
                (low-1 (%%interval-lower-bound interval 1))
                (low-2 (%%interval-lower-bound interval 2))
                (low-3 (%%interval-lower-bound interval 3))
                (increment-3 1)
                (increment-2 (* increment-3
                                (- (%%interval-upper-bound interval 3)
                                   (%%interval-lower-bound interval 3))))
                (increment-1 (* increment-2
                                (- (%%interval-upper-bound interval 2)
                                   (%%interval-lower-bound interval 2))))
                (increment-0 (* increment-1
                                (- (%%interval-upper-bound interval 1)
                                   (%%interval-lower-bound interval 1)))))
           (%%indexer-4 0
                        low-0 low-1 low-2 low-3
                        increment-0 increment-1 increment-2 increment-3)))
    (else
     (let ((lower-bounds (%%interval-lower-bounds->list interval))
           (upper-bounds (%%interval-upper-bounds->list interval)))
       (let ((ranges (map (lambda (u l) (- u l)) upper-bounds lower-bounds)))
         (do ((ranges (reverse ranges) (cdr ranges))
              (increments (list 1) (cons (* (car increments) (car ranges))
                                         increments)))
             ((null? (cdr ranges)) (%%indexer-generic 0 lower-bounds increments))))))))

(define (%%make-specialized-array interval
                                  storage-class
                                  ;; must be mutable
                                  safe?)
  (let* ((body    ((storage-class-maker storage-class)
                   (%%interval-volume interval)
                   (storage-class-default storage-class)))
         (indexer (%%interval->basic-indexer interval)))
    (%%finish-specialized-array interval
                                storage-class
                                body
                                indexer
                                #t            ;; mutable?
                                safe?
                                #t)))         ;; new arrays are always in order


(define (make-specialized-array interval
                                #!optional
                                (storage-class generic-storage-class)
                                ;; must be mutable?
                                (safe? (specialized-array-default-safe?)))
  ;; Returns a mutable specialized-array
  (cond ((not (interval? interval))
         (error "make-specialized-array: The first argument is not an interval: " interval))
        ((not (storage-class? storage-class))
         (error "make-specialized-array: The second argument is not a storage-class: " interval storage-class))
        ((not (boolean? safe?))
         (error "make-specialized-array: The third argument is not a boolean: " interval storage-class safe?))
        (else
         (%%make-specialized-array interval
                                   storage-class
                                   ;; must be mutable
                                   safe?))))

;;; We consolidate all moving of array elements to the following procedure.

(define (%%move-array-elements destination source caller)

  ;; Here's the logic:
  ;; We require the source and destination to have the same number of elements.
  ;; If destination is a specialized array
  ;; then
  ;;   If its elements are in order
  ;;   then
  ;;      If the source is a specialized array
  ;;         with the same storage class
  ;;         for which a copier exists
  ;;         and whose elements are also in order
  ;;      then
  ;;         do a block copy
  ;;      else
  ;;         if no checks are needed
  ;;         then
  ;;            step through the cells of the destination in order,
  ;;            storing the source elements
  ;;         else
  ;;            step through the cells of the destination in order,
  ;;            storing the source elements after testing they're OK
  ;;            for the destination
  ;;   else
  ;;     we now require that the domains of destination and source are
  ;;     the same.
  ;;     If no checks are needed
  ;;     then
  ;;        Copy elements from the source to destination, without checks.
  ;;     else
  ;;        Copy elements from the source to destination, checking whether
  ;;        they're OK
  ;; else
  ;;    We require the domains of destination and source to be the same.
  ;;    Copy elements of source to destination

  ;; We check the whether the elements of the destination are in order to save
  ;; a bit of array indexing (or perhaps to a block copy, which is even better).

  ;; We check that the elements we move to the destination are OK for the
  ;; destination because if we don't catch errors here they can be very tricky to find.

  (if (not (= (%%interval-volume (%%array-domain source))
              (%%interval-volume (%%array-domain destination))))
      (error (string-append caller "Arrays must have the same volume: ")
             destination source))

  (if (specialized-array? destination)
      (if (%%array-elements-in-order? destination)
          ;; Now we do not assume that the domains are the same
          ;; maybe we can do a block copy
          (if (and (specialized-array? source)
                   (eq? (%%array-storage-class destination)
                        (%%array-storage-class source))
                   ;; does a copier for this storage-class exist?
                   (storage-class-copier (%%array-storage-class destination))
                   (%%array-elements-in-order? source))
              ;; do a block copy
              (let* ((source-indexer
                      (%%array-indexer source))
                     (destination-indexer
                      (%%array-indexer destination))
                     (copier
                      (storage-class-copier (%%array-storage-class source)))
                     (initial-destination-index
                      (%%interval-lower-bounds->list (%%array-domain destination)))
                     (destination-start
                      (apply destination-indexer initial-destination-index))
                     (initial-source-index
                      (%%interval-lower-bounds->list (%%array-domain source)))
                     (source-start
                      (apply source-indexer initial-source-index))
                     (source-end
                      (fx+ source-start (%%interval-volume (%%array-domain source)))))
                (copier (%%array-body destination)
                        destination-start
                        (%%array-body source)
                        source-start
                        source-end)
                "Block copy")
              ;;  we can step through the elements of destination in order.
              (let* ((domain
                      (%%array-domain source))
                     (getter
                      (%%array-getter source))
                     (destination-storage-class
                      (%%array-storage-class destination))
                     (initial-offset
                      (apply (%%array-indexer destination)
                             (%%interval-lower-bounds->list (%%array-domain destination)))))
                (cond ((eq? destination-storage-class generic-storage-class)
                       ;; No checks needed, storage-class-setter is vector-set!
                       (let ((body (%%array-body destination)))
                         (%%interval-for-each
                          (case (%%interval-dimension domain)
                            ((1)  (let ((index initial-offset))
                                    (lambda (i)
                                      (vector-set! body index (getter i))
                                      (set! index (fx+ index 1)))))
                            ((2)  (let ((index initial-offset))
                                    (lambda (i j)
                                      (vector-set! body index (getter i j))
                                      (set! index (fx+ index 1)))))
                            ((3)  (let ((index initial-offset))
                                    (lambda (i j k)
                                      (vector-set! body index (getter i j k))
                                      (set! index (fx+ index 1)))))
                            ((4)  (let ((index initial-offset))
                                    (lambda (i j k l)
                                      (vector-set! body index (getter i j k l))
                                      (set! index (fx+ index 1)))))
                            (else (let ((index initial-offset))
                                    (lambda multi-index
                                      (vector-set! body index (apply getter multi-index))
                                      (set! index (fx+ index 1))))))
                          domain))
                       "In order, no checks needed, generic-storage-class")
                      ((and (specialized-array? source)
                            (eq? destination-storage-class
                                 (%%array-storage-class source)))
                       ;; No checks needed
                       (let ((setter (storage-class-setter destination-storage-class))
                             (body (%%array-body destination)))
                         (%%interval-for-each
                          (case (%%interval-dimension domain)
                            ((1)  (let ((index initial-offset))
                                    (lambda (i)
                                      (setter body index (getter i))
                                      (set! index (fx+ index 1)))))
                            ((2)  (let ((index initial-offset))
                                    (lambda (i j)
                                      (setter body index (getter i j))
                                      (set! index (fx+ index 1)))))
                            ((3)  (let ((index initial-offset))
                                    (lambda (i j k)
                                      (setter body index (getter i j k))
                                      (set! index (fx+ index 1)))))
                            ((4)  (let ((index initial-offset))
                                    (lambda (i j k l)
                                      (setter body index (getter i j k l))
                                      (set! index (fx+ index 1)))))
                            (else (let ((index initial-offset))
                                    (lambda multi-index
                                      (setter body index (apply getter multi-index))
                                      (set! index (fx+ index 1))))))
                          domain))
                       "In order, no checks needed")
                      (else
                       ;; checks needed
                       (let ((checker
                              (storage-class-checker destination-storage-class))
                             (body
                              (%%array-body destination))
                             (setter
                              (storage-class-setter destination-storage-class)))
                         (%%interval-for-each
                          (case (%%interval-dimension domain)
                            ((1)
                             (let ((index initial-offset))
                               (lambda (i)
                                 (let ((item (getter i)))
                                   (if (checker item)
                                       (begin
                                         (setter body index item)
                                         (set! index (fx+ index 1)))
                                       (error
                                        (string-append
                                         caller
                                         "Not all elements of the source can be stored in destination: ")
                                        destination source i item))))))
                            ((2)
                             (let ((index initial-offset))
                               (lambda (i j)
                                 (let ((item (getter i j)))
                                   (if (checker item)
                                       (begin
                                         (setter body index item)
                                         (set! index (fx+ index 1)))
                                       (error
                                        (string-append
                                         caller
                                         "Not all elements of the source can be stored in destination: ")
                                        destination source i j item))))))
                            ((3)
                             (let ((index initial-offset))
                               (lambda (i j k)
                                 (let ((item (getter i j k)))
                                   (if (checker item)
                                       (begin
                                         (setter body index item)
                                         (set! index (fx+ index 1)))
                                       (error
                                        (string-append
                                         caller
                                         "Not all elements of the source can be stored in destination: ")
                                        destination source i j k item) )))))
                            ((4)
                             (let ((index initial-offset))
                               (lambda (i j k l)
                                 (let ((item (getter i j k l)))
                                   (if (checker item)
                                       (begin
                                         (setter body index item)
                                         (set! index (fx+ index 1)))
                                       (error
                                        (string-append
                                         caller
                                         "Not all elements of the source can be stored in destination: ")
                                        destination source i j k l item))))))
                            (else
                             (let ((index initial-offset))
                               (lambda multi-index
                                 (let ((item (apply getter multi-index)))
                                   (if (checker item)
                                       (begin
                                         (setter body index item)
                                         (set! index (fx+ index 1)))
                                       (error
                                        (string-append
                                         caller
                                         "Not all elements of the source can be stored in destination: ")
                                        destination source multi-index item)))))))
                          domain))
                       "In order, checks needed"))))
          ;; the elements of destination are not in order.
          ;; so we need the domains to be the same.
          (let* ((setter
                  (%%array-setter destination))
                 (getter
                  (%%array-getter source))
                 (checker
                  (storage-class-checker (%%array-storage-class destination)))
                 (domain
                  (%%array-domain destination)))
            (cond ((not (%%interval= domain (%%array-domain source)))
                   (error (string-append
                           caller
                           "Arrays must have the same domains: ")
                          destination source))
                  ((or (eq? (%%array-storage-class destination)
                            generic-storage-class)
                       (and (specialized-array? source)
                            (eq? (%%array-storage-class destination)
                                 (%%array-storage-class source))))
                   ;; no checks needed
                   (%%interval-for-each
                    (case (%%interval-dimension domain)
                      ((1) (lambda (i)
                             (setter (getter i) i)))
                      ((2) (lambda (i j)
                             (setter (getter i j) i j)))
                      ((3) (lambda (i j k)
                             (setter (getter i j k) i j k)))
                      ((4) (lambda (i j k l)
                             (setter (getter i j k l) i j k l)))
                      (else
                       (lambda multi-index
                         (apply setter (apply getter multi-index) multi-index))))
                    domain)
                   "Out of order, no checks needed")
                  (else
                   ;; checks needed
                   (%%interval-for-each
                    (case (%%interval-dimension domain)
                      ((1)
                       (lambda (i)
                         (let ((item (getter i)))
                           (if (checker item)
                               (setter item i)
                               (error
                                (string-append
                                 caller
                                 "Not all elements of the source can be stored in destination: ")
                                destination source i item)))))
                      ((2)
                       (lambda (i j)
                         (let ((item (getter i j)))
                           (if (checker item)
                               (setter item i j)
                               (error
                                (string-append
                                 caller
                                 "Not all elements of the source can be stored in destination: ")
                                destination source i j item)))))
                      ((3)
                       (lambda (i j k)
                         (let ((item (getter i j k)))
                           (if (checker item)
                               (setter item i j k)
                               (error
                                (string-append
                                 caller
                                 "Not all elements of the source can be stored in destination: ")
                                destination source i j k item)))))
                      ((4)
                       (lambda (i j k l)
                         (let ((item (getter i j k l)))
                           (if (checker item)
                               (setter item i j k l)
                               (error
                                (string-append
                                 caller
                                 "Not all elements of the source can be stored in destination: ")
                                destination source i j k l item)))))
                      (else
                       (lambda multi-index
                         (let ((item (apply getter multi-index)))
                           (if (checker item)
                               (apply setter item multi-index)
                               (error
                                (string-append
                                 caller
                                 "Not all elements of the source can be stored in destination: ")
                                destination source multi-index item))))))
                    domain)
                   "Out of order, checks needed"))))
      ;; destination is not a specialized array, so checks,
      ;; if any, are built into the setter.
      (let ((domain (%%array-domain destination)))
        (if (not (%%interval= domain (%%array-domain source)))
            (error (string-append
                    caller
                    "Arrays must have the same domains: ")
                   destination source)
            (let* ((setter
                    (%%array-setter destination))
                   (getter
                    (%%array-getter source))
                   (domain
                    (%%array-domain destination)))
              (%%interval-for-each
               (case (%%interval-dimension domain)
                 ((1) (lambda (i)
                        (setter (getter i)
                                i)))
                 ((2) (lambda (i j)
                        (setter (getter i j)
                                i j)))
                 ((3) (lambda (i j k)
                        (setter (getter i j k)
                                i j k)))
                 ((4) (lambda (i j k l)
                        (setter (getter i j k l)
                                i j k l)))
                 (else
                  (lambda multi-index
                    (apply setter
                           (apply getter multi-index)
                           multi-index))))
               domain)
              "Destination not specialized array"))))
  ;; %%move-array-elements returns a string that designates
  ;; the copying method it used.
  ;; Calling functions should return something useful.
  )

;;;
;;; The domain of the result is the same as the domain of the argument.
;;;
;;; Builds a new specialized-array and populates the body of the result with
;;; (array-getter array) applied to the elements of (array-domain array)

(define (%%array-copy array
                      result-storage-class
                      domain
                      mutable?
                      safe?)
  (let ((result (%%make-specialized-array domain
                                          result-storage-class
                                          safe?)))
    (%%move-array-elements result array "array-copy: ")
    (if (not mutable?)            ;; set the setter to #f if the final array is not mutable
        (%%array-setter-set! result #f))
    result))

(define (array-copy array
                    #!optional
                    (result-storage-class generic-storage-class)
                    (new-domain #f)
                    (mutable? (specialized-array-default-mutable?))
                    (safe? (specialized-array-default-safe?)))
  (cond ((not (array? array))
         (error "array-copy: The first argument is not an array: " array))
        ((not (storage-class? result-storage-class))
         (error "array-copy: The second argument is not a storage-class: " result-storage-class))
        ((not (or (eq? new-domain #f) (%%interval? new-domain)))
         (error "array-copy: The third argument is neither #f nor an interval: " new-domain))
        ((and (%%interval? new-domain)
              (not (= (%%interval-volume new-domain)
                      (%%interval-volume (%%array-domain array)))))
         (error
          "array-copy: The volume of the third argument is not the volume of the domain of the first argument: "
          array result-storage-class new-domain))
        ((not (boolean? mutable?))
         (error "array-copy: The fourth argument is not a boolean: " mutable?))
        ((not (boolean? safe?))
         (error "array-copy: The fifth argument is not a boolean: " safe?))
        (else
         (%%array-copy array
                       result-storage-class
                       (if new-domain new-domain (%%array-domain array))
                       mutable?
                       safe?))))

;;;
;;; In the next function, old-indexer is an affine 1-1 mapping from an interval to [0,N), for some N.
;;;
;;; new-domain->old-domain is an affine 1-1 mapping from new-domain to the domain of old-indexer.
;;;

(define (%%compose-indexers old-indexer new-domain new-domain->old-domain)
  (case (%%interval-dimension new-domain)
    ((1) (let* ((lower-0 (%%interval-lower-bound new-domain 0))
                (upper-0 (%%interval-upper-bound new-domain 0))
                (base (call-with-values
                          (lambda () (new-domain->old-domain lower-0))
                        old-indexer))
                (increment-0 (if (< (+ lower-0 1) upper-0)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain (+ lower-0 1)))
                                      old-indexer)
                                    base)
                                 0)))
           (%%indexer-1 base lower-0 increment-0)))

    ((2) (let* ((lower-0 (%%interval-lower-bound new-domain 0))
                (lower-1 (%%interval-lower-bound new-domain 1))
                (upper-0 (%%interval-upper-bound new-domain 0))
                (upper-1 (%%interval-upper-bound new-domain 1))
                (base (call-with-values
                          (lambda () (new-domain->old-domain lower-0 lower-1))
                        old-indexer))
                (increment-0 (if (< (+ lower-0 1) upper-0)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain (+ lower-0 1) lower-1))
                                      old-indexer)
                                    base)
                                 0))
                (increment-1 (if (< (+ lower-1 1) upper-1)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain lower-0 (+ lower-1 1)))
                                      old-indexer)
                                    base)
                                 0)))
           (%%indexer-2 base lower-0 lower-1 increment-0 increment-1)))
    ((3) (let* ((lower-0 (%%interval-lower-bound new-domain 0))
                (lower-1 (%%interval-lower-bound new-domain 1))
                (lower-2 (%%interval-lower-bound new-domain 2))
                (upper-0 (%%interval-upper-bound new-domain 0))
                (upper-1 (%%interval-upper-bound new-domain 1))
                (upper-2 (%%interval-upper-bound new-domain 2))
                (base (call-with-values
                          (lambda () (new-domain->old-domain lower-0 lower-1 lower-2))
                        old-indexer))
                (increment-0 (if (< (+ lower-0 1) upper-0)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain (+ lower-0 1) lower-1 lower-2))
                                      old-indexer)
                                    base)
                                 0))
                (increment-1 (if (< (+ lower-1 1) upper-1)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain lower-0 (+ lower-1 1) lower-2))
                                      old-indexer)
                                    base)
                                 0))
                (increment-2 (if (< (+ lower-2 1) upper-2)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain lower-0 lower-1 (+ lower-2 1)))
                                      old-indexer)
                                    base)
                                 0)))
           (%%indexer-3 base lower-0 lower-1 lower-2 increment-0 increment-1 increment-2)))
    ((4) (let* ((lower-0 (%%interval-lower-bound new-domain 0))
                (lower-1 (%%interval-lower-bound new-domain 1))
                (lower-2 (%%interval-lower-bound new-domain 2))
                (lower-3 (%%interval-lower-bound new-domain 3))
                (upper-0 (%%interval-upper-bound new-domain 0))
                (upper-1 (%%interval-upper-bound new-domain 1))
                (upper-2 (%%interval-upper-bound new-domain 2))
                (upper-3 (%%interval-upper-bound new-domain 3))
                (base (call-with-values
                          (lambda () (new-domain->old-domain lower-0 lower-1 lower-2 lower-3))
                        old-indexer))
                (increment-0 (if (< (+ lower-0 1) upper-0)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain (+ lower-0 1) lower-1 lower-2 lower-3))
                                      old-indexer)
                                    base)
                                 0))
                (increment-1 (if (< (+ lower-1 1) upper-1)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain lower-0 (+ lower-1 1) lower-2 lower-3))
                                      old-indexer)
                                    base)
                                 0))
                (increment-2 (if (< (+ lower-2 1) upper-2)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain lower-0 lower-1 (+ lower-2 1) lower-3))
                                      old-indexer)
                                    base)
                                 0))
                (increment-3 (if (< (+ lower-3 1) upper-3)
                                 (- (call-with-values
                                        (lambda () (new-domain->old-domain lower-0 lower-1 lower-2 (+ lower-3 1)))
                                      old-indexer)
                                    base)
                                 0)))
           (%%indexer-4 base lower-0 lower-1 lower-2 lower-3 increment-0 increment-1 increment-2 increment-3)))
    (else
     (let* ((lower-bounds (%%interval-lower-bounds->list new-domain))
            (upper-bounds (%%interval-upper-bounds->list new-domain))
            (base (call-with-values
                      (lambda () (apply new-domain->old-domain lower-bounds))
                    old-indexer))
            (increments (let ((increments   (map (lambda (x) 0) lower-bounds))
                              (lower-bounds (map (lambda (x) x) lower-bounds)))
                          (let loop ((l lower-bounds)
                                     (u upper-bounds)
                                     (i increments)
                                     (base base))
                            (if (null? l)
                                increments
                                (let ((new-base
                                       (if (< (+ (car l) 1)
                                              (car u))
                                           (begin
                                             (set-car! l (+ (car l) 1))
                                             (let ((new-base (call-with-values
                                                                 (lambda () (apply new-domain->old-domain lower-bounds))
                                                               old-indexer)))
                                               (set-car! i (- new-base base))
                                               new-base))
                                           base)))
                                  (loop (cdr l)
                                        (cdr u)
                                        (cdr i)
                                        new-base)))))))
       (%%indexer-generic base lower-bounds increments)))))

;;; You want to share the backing store of array.
;;;
;;; So you specify a new domain and an affine 1-1 mapping from the new-domain to the old-domain.

(define (%%specialized-array-share array
                                   new-domain
                                   new-domain->old-domain
                                   #!optional
                                   (in-order? %%order-unknown))
  (let ((old-domain        (%%array-domain       array))
        (old-indexer       (%%array-indexer      array))
        (body              (%%array-body         array))
        (storage-class     (%%array-storage-class array)))
    (%%finish-specialized-array new-domain
                                storage-class
                                body
                                (%%compose-indexers old-indexer new-domain new-domain->old-domain)
                                (mutable-array? array)
                                (%%array-safe? array)
                                in-order?)))


(define (specialized-array-share array
                                 new-domain
                                 new-domain->old-domain)
  (cond ((not (specialized-array? array))
         (error "specialized-array-share: The first argument is not a specialized-array: "
                array new-domain new-domain->old-domain))
        ((not (interval? new-domain))
         (error "specialized-array-share: The second argument is not an interval: "
                array new-domain new-domain->old-domain))
        ((not (procedure? new-domain->old-domain))
         (error "specialized-array-share: The third argument is not a procedure: "
                array new-domain new-domain->old-domain))
        (else
         (%%specialized-array-share array
                                    new-domain
                                    new-domain->old-domain))))

(define (%%immutable-array-extract array new-domain)
  (make-array new-domain
              (%%array-getter array)))

(define (%%mutable-array-extract array new-domain)
  (make-array new-domain
              (%%array-getter array)
              (%%array-setter array)))

(define (%%specialized-array-extract array new-domain)
  (%%specialized-array-share array
                             new-domain
                             values))

(define (%%array-extract array new-domain)
  (cond ((specialized-array? array)
         (%%specialized-array-extract array new-domain))
        ((mutable-array? array)
         (%%mutable-array-extract array new-domain))
        (else
         (%%immutable-array-extract array new-domain))))

(define (array-extract array new-domain)
  (cond ((not (array? array))
         (error "array-extract: The first argument is not an array: " array new-domain))
        ((not (interval? new-domain))
         (error "array-extract: The second argument is not an interval: " array new-domain))
        ((not (fx= (%%array-dimension array)
                   (%%interval-dimension new-domain)))
         (error "array-extract: The dimension of the second argument (an interval) does not equal the dimension of the domain of the first argument (an array): " array new-domain))
        ((not (%%interval-subset? new-domain (%%array-domain array)))
         (error "array-extract: The second argument (an interval) is not a subset of the domain of the first argument (an array): " array new-domain))
        (else
         (%%array-extract array new-domain))))

(define (array-tile array sides)
  (cond ((not (array? array))
         (error "array-tile: The first argument is not an array: " array sides))
        ((not (and (vector? sides)
                   (%%vector-every (lambda (x) (and (exact-integer? x) (positive? x))) sides)))
         (error "array-tile: The second argument is not a vector of exact positive integers: " array sides))
        ((not (fx= (%%array-dimension array)
                   (vector-length sides)))
         (error "array-tile: The dimension of the first argument (an array) does not equal the length of the second argument (a vector): " array sides))
        (else
         (let* ((n
                 (vector-length sides))
                (domain
                 (%%array-domain array))
                (lower-bounds
                 (%%interval-lower-bounds domain))
                (upper-bounds
                 (%%interval-upper-bounds domain))
                (result-lower-bounds
                 (make-vector n 0))
                (result-upper-bounds
                 (vector-map (lambda (l u s)
                               (quotient (+ (- u l)
                                            (- s 1))
                                         s))
                             lower-bounds upper-bounds sides))
                (result-domain
                 (%%finish-interval result-lower-bounds result-upper-bounds)))

           (define-macro (generate-result)

             (define (symbol-append . args)
               (string->symbol
                (apply string-append (map (lambda (x)
                                            (cond ((symbol? x)
                                                   (symbol->string x))
                                                  ((number? x)
                                                   (number->string x))
                                                  ((string? x)
                                                   x)
                                                  (else
                                                   (error "Arghh!"))))
                                          args))))

             `(case n
                ,@(map (lambda (k)
                         (let* ((indices
                                 (iota k))
                                (args
                                 (map (lambda (j) (symbol-append 'i j)) indices))
                                (lowers
                                 (map (lambda (j) (symbol-append 'l j)) indices))
                                (uppers
                                 (map (lambda (j) (symbol-append 'u j)) indices))
                                (sides
                                 (map (lambda (j) (symbol-append 's j)) indices)))
                           `((,k)
                             (lambda ,args
                               (if (not (and ,@(map (lambda (arg) `(exact-integer? ,arg)) args)
                                             (,(symbol-append '%%interval-contains-multi-index?- k) result-domain ,@args)))
                                   (error "array-tile: Index to result array is not valid: " ,@args)
                                   (let* (,@(map (lambda (l j)
                                                   `(,l (vector-ref lower-bounds ,j)))
                                                 lowers indices)
                                          ,@(map (lambda (u j)
                                                   `(,u (vector-ref upper-bounds ,j)))
                                                 uppers indices)
                                          ,@(map (lambda (s j)
                                                   `(,s (vector-ref sides ,j)))
                                                 sides indices)
                                          (subdomain
                                           (%%finish-interval (vector ,@(map (lambda (l s i)
                                                                               `(+ ,l (* ,s ,i)))
                                                                             lowers sides args))
                                                              (vector ,@(map (lambda (l u s i)
                                                                               `(min ,u (+ ,l (* ,s (+ ,i 1)))))
                                                                             lowers uppers sides args)))))
                                     (%%array-extract array subdomain)))))))
                       '(1 2 3 4))
                (else
                 (lambda i
                   (if (not (and (fx= (length i) n)
                                 (%%every (lambda (x) (exact-integer? x)) i)
                                 (%%interval-contains-multi-index?-general result-domain i)))
                       (apply error "array-tile: Index to result array is not valid: " i)
                       (let* ((i (list->vector i))
                              (subdomain (%%finish-interval
                                          (vector-map (lambda (l s i)
                                                        (+ l (* s i)))
                                                      lower-bounds sides i)
                                          (vector-map (lambda (l u s i)
                                                        (min u (+ l (* s (+ i 1)))))
                                                      lower-bounds upper-bounds sides i))))
                         (%%array-extract array subdomain)))))))

           (make-array result-domain (generate-result))))))


(define (%%getter-translate getter translation)
  (case (vector-length translation)
    ((1) (lambda (i)
           (getter (- i (vector-ref translation 0)))))
    ((2) (lambda (i j)
           (getter (- i (vector-ref translation 0))
                   (- j (vector-ref translation 1)))))
    ((3) (lambda (i j k)
           (getter (- i (vector-ref translation 0))
                   (- j (vector-ref translation 1))
                   (- k (vector-ref translation 2)))))
    ((4) (lambda (i j k l)
           (getter (- i (vector-ref translation 0))
                   (- j (vector-ref translation 1))
                   (- k (vector-ref translation 2))
                   (- l (vector-ref translation 3)))))
    (else
     (let ((n (vector-length translation))
           (translation-list (vector->list translation)))
       (lambda indices
         (cond ((not (fx= (length indices) n))
                (error "The number of indices does not equal the array dimension: " indices))
               (else
                (apply getter (map - indices translation-list)))))))))

(define (%%setter-translate setter translation)
  (case (vector-length translation)
    ((1) (lambda (v i)
           (setter v
                   (- i (vector-ref translation 0)))))
    ((2) (lambda (v i j)
           (setter v
                   (- i (vector-ref translation 0))
                   (- j (vector-ref translation 1)))))
    ((3) (lambda (v i j k)
           (setter v
                   (- i (vector-ref translation 0))
                   (- j (vector-ref translation 1))
                   (- k (vector-ref translation 2)))))
    ((4) (lambda (v i j k l)
           (setter v
                   (- i (vector-ref translation 0))
                   (- j (vector-ref translation 1))
                   (- k (vector-ref translation 2))
                   (- l (vector-ref translation 3)))))
    (else
     (let ((n (vector-length translation))
           (translation-list (vector->list translation)))
       (lambda (v . indices)
         (cond ((not (fx= (length indices) n))
                (error "The number of indices does not equal the array dimension: " v indices))
               (else
                (apply setter v (map - indices translation-list)))))))))

(define (%%immutable-array-translate array translation)
  (make-array (%%interval-translate (%%array-domain array) translation)
              (%%getter-translate (%%array-getter array) translation)))

(define (%%mutable-array-translate array translation)
  (make-array (%%interval-translate (%%array-domain array) translation)
              (%%getter-translate (%%array-getter array) translation)
              (%%setter-translate (%%array-setter array) translation)))

(define (%%specialized-array-translate array translation)
  (%%specialized-array-share array
                             (%%interval-translate (%%array-domain array) translation)
                             (%%getter-translate values translation)
                             (%%array-in-order? array)))

(define (array-translate array translation)
  (cond ((not (array? array))
         (error "array-translate: The first argument is not an array: " array translation))
        ((not (translation? translation))
         (error "array-translate: The second argument is not a vector of exact integers: " array translation))
        ((not (fx= (%%array-dimension array)
                   (vector-length translation)))
         (error "array-translate: The dimension of the first argument (an array) does not equal the dimension of the second argument (a vector): " array translation))
        ((specialized-array? array)
         (%%specialized-array-translate array translation))
        ((mutable-array? array)
         (%%mutable-array-translate array translation))
        (else
         (%%immutable-array-translate array translation))))

(define-macro (srfi/179#setup-permuted-getters-and-setters)

  (define (list-remove l i)
    ;; new list that removes (list-ref l i) from l
    (if (zero? i)
        (cdr l)
        (cons (car l)
              (list-remove (cdr l) (- i 1)))))

  (define (permutations l)
    ;; generates list of all permutations of l
    (if (null? (cdr l))
        (list l)
        (apply append (map (lambda (i)
                             (let ((x    (list-ref l i))
                                   (rest (list-remove l i)))
                               (map (lambda (tail)
                                      (cons x tail))
                                    (permutations rest))))
                           (iota (length l))))))

  (define (concat . args)
    (string->symbol (apply string-append (map (lambda (s) (if (string? s) s (symbol->string s ))) args))))

  (define (permuter name transform-arguments)
    `(define (,(concat name '-permute) ,name permutation)
       (case (vector-length permutation)
         ,@(map (lambda (i)
                  `((,i) (cond ,@(let ((args (take '(i j k l) i)))
                                   (map (lambda (perm permuted-args)
                                          `((equal? permutation ',(list->vector perm))
                                            (lambda ,(transform-arguments permuted-args)
                                              ,`(,name ,@(transform-arguments args)))))
                                        (permutations (take '(0 1 2 3) i))
                                        (permutations args))))))
                '(1 2 3 4))
         (else
          (let ((n (vector-length permutation))
                (permutation-inverse (%%permutation-invert permutation)))
            (lambda ,(transform-arguments 'indices)
              (if (not (fx= (length indices) n))
                  (error "number of indices does not equal permutation dimension: " indices permutation)
                  (apply ,name ,@(transform-arguments '((%%vector-permute->list (list->vector indices) permutation-inverse)))))))))))

  (let ((result
         `(begin
            ,(permuter '%%getter values)
            ,(permuter '%%setter (lambda (args) (cons 'v args))))))
    result))

(setup-permuted-getters-and-setters)

(define (%%array-permute array permutation)
  (cond ((specialized-array? array)
         (%%specialized-array-share array
                                    (%%interval-permute (%%array-domain array) permutation)
                                    (%%getter-permute values permutation)))
        ((mutable-array? array)
         (make-array (%%interval-permute (%%array-domain array) permutation)
                     (%%getter-permute (%%array-getter array) permutation)
                     (%%setter-permute (%%array-setter array) permutation)))
        (else
         (make-array (%%interval-permute (%%array-domain array) permutation)
                     (%%getter-permute (%%array-getter array) permutation)))))

(define (array-permute array permutation)
  (cond ((not (array? array))
         (error "array-permute: The first argument is not an array: " array permutation))
        ((not (permutation? permutation))
         (error "array-permute: The second argument is not a permutation: " array permutation))
        ((not (fx= (%%array-dimension array)
                   (vector-length permutation)))
         (error "array-permute: The dimension of the first argument (an array) does not equal the dimension of the second argument (a permutation): " array permutation))
        (else
         (%%array-permute array permutation))))

(define (%%rotation->permutation k size)

  ;; Generates a permutation that rotates
  ;; 0 1 ... size-1
  ;; left by k units.

  (let ((result (make-vector size)))
    (let left-loop ((i 0)
                    (j k))
      (if (fx< j size)
          (begin
            (vector-set! result i j)
            (left-loop (fx+ i 1)
                       (fx+ j 1)))
          (let right-loop ((i i)
                           (j 0))
            (if (fx< i size)
                (begin
                  (vector-set! result i j)
                  (right-loop (fx+ i 1)
                              (fx+ j 1)))
                result))))))

(define (interval-rotate interval dim)
  (if (not (interval? interval))
      (error "interval-rotate: The first argument is not an interval: " interval dim)
      (let ((d (%%interval-dimension interval)))
        (if (not (and (fixnum? dim)
                      (fx< -1 dim d)))
            (error "interval-rotate: The second argument is not an exact integer betweeen 0 (inclusive) and the interval-dimension of the first argument (exclusive): " interval dim)
            (%%interval-permute interval (%%rotation->permutation dim d))))))

(define (array-rotate array dim)
  (if (not (array? array))
      (error "array-rotate: The first argument is not an array: " array dim)
      (let ((d (%%array-dimension array)))
        (if (not (and (fixnum? dim)
                      (fx< -1 dim d)))
            (error "array-rotate: The second argument is not an exact integer betweeen 0 (inclusive) and the array-dimension of the first argument (exclusive): " array dim)
            (%%array-permute array (%%rotation->permutation dim d))))))

(define-macro (srfi/179#setup-reversed-getters-and-setters)

  (define (make-symbol . args)
    (string->symbol
     (apply string-append
            (map (lambda (x)
                   (cond ((string? x) x)
                         ((symbol? x) (symbol->string x))
                         ((number? x) (number->string x))))
                 args))))

  (define (truth-table n)   ;; generate all combinations of n #t and #f
    (if (zero? n)
        '(())
        (let ((subtable (truth-table (- n 1))))
          (apply append (map (lambda (value)
                               (map (lambda (t)
                                      (cons value t))
                                    subtable))
                             '(#t #f))))))

  (define (generate-code-for-fixed-n name transformer n)
    (let ((zero-to-n-1
           (iota n))
          (table
           (truth-table n)))
      `((,n) (let (,@(map (lambda (k)
                            `(,(make-symbol 'adjust_ k) (+ (%%interval-upper-bound interval ,k)
                                                           (%%interval-lower-bound interval ,k)
                                                           -1)))
                          zero-to-n-1))
               (cond ,@(map (lambda (table-entry)
                              `((equal? flip? ',(list->vector table-entry))
                                (lambda ,(transformer (map (lambda (k)
                                                             (make-symbol 'i_ k))
                                                           zero-to-n-1))
                                  (,name ,@(transformer (map (lambda (flip? k)
                                                               (if flip?
                                                                   `(- ,(make-symbol 'adjust_ k)
                                                                       ,(make-symbol 'i_ k))
                                                                   `,(make-symbol 'i_ k)))
                                                             table-entry zero-to-n-1))))))
                            table))))))

  (define (reverser name transform-arguments)
    `(define (,(make-symbol name '-reverse) ,name flip? interval)
       (case (vector-length flip?)
         ,@(map (lambda (n)
                  (generate-code-for-fixed-n name transform-arguments n))
                '(1 2 3 4))
         (else
          (let ((n
                 (vector-length flip?))
                (flip?
                 (vector->list flip?))
                (adjust
                 (map (lambda (u_k l_k)
                        (+ u_k l_k -1))
                      (vector->list (%%interval-upper-bounds interval))
                      (vector->list (%%interval-lower-bounds interval)))))
            (lambda ,(transform-arguments 'indices)
              (if (not (fx= (length indices) n))
                  (error "number of indices does not equal array dimension: " indices)
                  (apply ,name ,@(transform-arguments '((map (lambda (i adjust flip?)
                                                               (if flip?
                                                                   (- adjust i)
                                                                   i))
                                                             indices adjust flip?)))))))))))
  (let ((result
         `(begin
            ,(reverser '%%getter values)
            ,(reverser '%%setter (lambda (args) (cons 'v args))))))
    result))

(setup-reversed-getters-and-setters)

(define (%%array-reverse array flip?)
  (cond ((specialized-array? array)
         (%%specialized-array-share array
                                    (%%array-domain array)
                                    (%%getter-reverse values flip? (%%array-domain array))))
        ((mutable-array? array)
         (make-array (%%array-domain array)
                     (%%getter-reverse (%%array-getter array) flip? (%%array-domain array))
                     (%%setter-reverse (%%array-setter array) flip? (%%array-domain array))))
        (else
         (make-array (%%array-domain array)
                     (%%getter-reverse (%%array-getter array) flip? (%%array-domain array))))))

(define %%vector-of-trues
  '#(#()
     #(#t)
     #(#t #t)
     #(#t #t #t)
     #(#t #t #t #t)))

(define array-reverse
  (case-lambda
   ((array)
    (cond ((not (array? array))
           (error "array-reverse: The argument is not an array: " array))
          (else
           (%%array-reverse array
                            (let ((dim (%%array-dimension array)))
                              (if (fx< dim 5)
                                  (vector-ref %%vector-of-trues dim)
                                  (make-vector dim #t)))))))
   ((array flip?)
    (cond  ((not (array? array))
            (error "array-reverse: The first argument is not an array: " array flip?))
           ((not (and (vector? flip?)
                      (%%vector-every (lambda (x) (boolean? x)) flip?)))
            (error "array-reverse: The second argument is not a vector of booleans: " array flip?))
           ((not (fx= (%%array-dimension array)
                      (vector-length flip?)))
            (error "array-reverse: The dimension of the first argument (an array) does not equal the dimension of the second argument (a vector of booleans): " array flip?))
           (else
            (%%array-reverse array flip?))))))

(define-macro (srfi/179#macro-generate-sample)

  (define (make-symbol . args)
    (string->symbol
     (apply string-append
            (map (lambda (x)
                   (cond ((string? x) x)
                         ((symbol? x) (symbol->string x))
                         ((number? x) (number->string x))))
                 args))))

  (define (first-half l)
    (take l (quotient (length l) 2)))

  (define (second-half l)
    (drop l (quotient (length l) 2)))

  (define (arg-lists ks)
    (if (null? ks)
        '(())
        (let* ((k (car ks))
               (i_k (make-symbol 'i_ k))
               (s_k (make-symbol 's_ k))
               (sublists
                (arg-lists (cdr ks)))
               (plains
                (map (lambda (l)
                       (cons i_k l))
                     sublists))
               (scales
                (map (lambda (l)
                       (cons `(* ,i_k ,s_k) l))
                     sublists)))
          (append plains
                  scales))))

  (define (code-for-one-n name transformer n)
    (let* ((zero-to-n-1
            (iota n))
           (arg-list
            (map (lambda (k)
                   (make-symbol 'i_ k))
                 zero-to-n-1))
           (args
            (arg-lists zero-to-n-1)))
      (define (build-code args ks)
        (if (null? (cdr args))
            `(lambda ,(transformer arg-list)
               (,name ,@(transformer (car args))))
            (let* ((k (car ks))
                   (s_k (make-symbol 's_ k))
                   (plains (first-half args))
                   (scales (second-half args)))
              `(if (= 1 ,s_k)
                   ,(build-code plains (cdr ks))
                   ,(build-code scales (cdr ks))))))
      `((,n)
        (let (,@(map (lambda (k)
                       `(,(make-symbol 's_ k) (vector-ref scales ,k)))
                     zero-to-n-1))
          ,(build-code args zero-to-n-1)))))

  (define (sampler name transformer)
    `(define (,(make-symbol name '-sample) ,name scales interval)
       (case (vector-length scales)
         ,@(map (lambda (n)
                  (code-for-one-n name transformer n))
                '(1 2 3 4))
         (else
          (let ((n
                 (vector-length scales))
                (scales
                 (vector->list scales)))
            (lambda ,(transformer 'indices)
              (if (not (fx= (length indices) n))
                  (error "number of indices does not equal array dimension: " indices)
                  (apply ,name ,@(transformer '((map (lambda (i s)
                                                       (* s i))
                                                     indices scales)))))))))))



  (let ((result
         `(begin
            ,(sampler '%%getter values)
            ,(sampler '%%setter (lambda (args) (cons 'v args))))))
    result))

(macro-generate-sample)


(define (%%immutable-array-sample array scales)
  (make-array (%%interval-scale (%%array-domain array) scales)
              (%%getter-sample (%%array-getter array) scales (%%array-domain array))))

(define (%%mutable-array-sample array scales)
  (make-array (%%interval-scale (%%array-domain array) scales)
              (%%getter-sample (%%array-getter array) scales (%%array-domain array))
              (%%setter-sample (%%array-setter array) scales (%%array-domain array))))

(define (%%specialized-array-sample array scales)
  (%%specialized-array-share array
                             (%%interval-scale (%%array-domain array) scales)
                             (%%getter-sample values scales (%%array-domain array))))

(define (array-sample array scales)
  (cond ((not (and (array? array)
                   (%%vector-every (lambda (x) (eqv? x 0)) (%%interval-lower-bounds (%%array-domain array)))))
         (error "array-sample: The first argument is not an array whose domain has zero lower bounds: " array scales))
        ((not (and (vector? scales)
                   (%%vector-every (lambda (x) (exact-integer? x)) scales)
                   (%%vector-every (lambda (x) (positive? x)) scales)))
         (error "array-sample: The second argument is not a vector of positive, exact, integers: " array scales))
        ((not (fx= (vector-length scales) (%%array-dimension array)))
         (error "array-sample: The dimension of the first argument (an array) is not equal to the length of the second (a vector): "
                array scales))
        ((specialized-array? array)
         (%%specialized-array-sample array scales))
        ((mutable-array? array)
         (%%mutable-array-sample array scales))
        (else
         (%%immutable-array-sample array scales))))

(define (%%array-outer-product combiner array1 array2)
  (let* ((domain1 (%%array-domain array1))
         (domain2 (%%array-domain array2))
         (getter1 (%%array-getter array1))
         (getter2 (%%array-getter array2))
         (dimension1
          (%%interval-dimension domain1))
         (dimension2
          (%%interval-dimension domain2))
         (result-domain
          (%%interval-cartesian-product (list domain1 domain2)))
         (result-getter
          (case dimension1
            ((1)
             (case dimension2
               ((1)
                (lambda (i1 i2)
                  (combiner (getter1 i1)
                            (getter2 i2))))
               ((2)
                (lambda (i1 i2 j2)
                  (combiner (getter1 i1)
                            (getter2 i2 j2))))
               ((3)
                (lambda (i1 i2 j2 k2)
                  (combiner (getter1 i1)
                            (getter2 i2 j2 k2))))
               (else
                (lambda (i1 . rest)
                  (combiner (getter1 i1)
                            (apply getter2 rest))))))
            ((2)
             (case dimension2
               ((1)
                (lambda (i1 j1 i2)
                  (combiner (getter1 i1 j1)
                            (getter2 i2))))
               ((2)
                (lambda (i1 j1 i2 j2)
                  (combiner (getter1 i1 j1)
                            (getter2 i2 j2))))
               (else
                (lambda (i1 j1 . rest)
                  (combiner (getter1 i1 j1)
                            (apply getter2 rest))))))
            ((3)
             (case dimension2
               ((1)
                (lambda (i1 j1 k1 i2)
                  (combiner (getter1 i1 j1 k1)
                            (getter2 i2))))
               (else
                (lambda (i1 j1 k1 . rest)
                  (combiner (getter1 i1 j1 k1)
                            (apply getter2 rest))))))
            (else
             (lambda args
               (combiner (apply getter1 (take args dimension1))
                         (apply getter2 (drop args dimension1))))))))
    (make-array result-domain result-getter)))

(define (array-outer-product combiner array1 array2)
  (cond ((not (array? array1))
         (error "array-outer-product: The second argument is not an array: " combiner array1 array2))
        ((not (array? array2))
         (error "array-outer-product: The third argument is not an array: " combiner array1 array2))
        ((not (procedure? combiner))
         (error "array-outer-product: The first argument is not a procedure: " combiner array1 array2))
        (else
         (%%array-outer-product combiner array1 array2))))

(define (%%immutable-array-curry array right-dimension)
  (call-with-values
      (lambda () (%%interval-projections (%%array-domain array) right-dimension))
    (lambda (left-interval right-interval)
      (let ((getter (%%array-getter array)))
        (make-array left-interval
                    (case (%%interval-dimension left-interval)
                      ((1)  (case (%%interval-dimension right-interval)
                              ((1)  (lambda (i)      (make-array right-interval (lambda (j)         (getter i j)))))
                              ((2)  (lambda (i)      (make-array right-interval (lambda (j k)       (getter i j k)))))
                              ((3)  (lambda (i)      (make-array right-interval (lambda (j k l)     (getter i j k l)))))
                              (else (lambda (i)      (make-array right-interval (lambda multi-index (apply getter i multi-index)))))))
                      ((2)  (case (%%interval-dimension right-interval)
                              ((1)  (lambda (i j)    (make-array right-interval (lambda   (k)       (getter i j k)))))
                              ((2)  (lambda (i j)    (make-array right-interval (lambda   (k l)     (getter i j k l)))))
                              (else (lambda (i j)    (make-array right-interval (lambda multi-index (apply getter i j multi-index)))))))
                      ((3)  (case (%%interval-dimension right-interval)
                              ((1)  (lambda (i j k)  (make-array right-interval (lambda     (l)     (getter i j k l)))))
                              (else (lambda (i j k)  (make-array right-interval (lambda multi-index (apply getter i j k multi-index)))))))
                      (else (lambda left-multi-index
                              (make-array right-interval
                                          (lambda right-multi-index
                                            (apply getter (append left-multi-index right-multi-index))))))))))))

(define (%%mutable-array-curry array right-dimension)
  (call-with-values
      (lambda () (%%interval-projections (%%array-domain array) right-dimension))
    (lambda (left-interval right-interval)
      (let ((getter (%%array-getter array))
            (setter (%%array-setter   array)))
        (make-array left-interval
                    (case (%%interval-dimension left-interval)
                      ((1)  (case (%%interval-dimension right-interval)
                              ((1)  (lambda (i)     (make-array right-interval
                                                                (lambda (  j)     (getter   i j))
                                                                (lambda (v j)     (setter v i j)))))
                              ((2)  (lambda (i)     (make-array right-interval
                                                                (lambda (  j k)   (getter   i j k))
                                                                (lambda (v j k)   (setter v i j k)))))
                              ((3)  (lambda (i)     (make-array right-interval
                                                                (lambda (  j k l) (getter   i j k l))
                                                                (lambda (v j k l) (setter v i j k l)))))
                              (else (lambda (i)     (make-array right-interval
                                                                (lambda      multi-index  (apply getter   i     multi-index))
                                                                (lambda (v . multi-index) (apply setter v i     multi-index)))))))
                      ((2)  (case (%%interval-dimension right-interval)
                              ((1)  (lambda (i j)   (make-array right-interval
                                                                (lambda (    k)   (getter   i j k))
                                                                (lambda (v   k)   (setter v i j k)))))
                              ((2)  (lambda (i j)   (make-array right-interval
                                                                (lambda (    k l) (getter   i j k l))
                                                                (lambda (v   k l) (setter v i j k l)))))
                              (else (lambda (i j)   (make-array right-interval
                                                                (lambda      multi-index  (apply getter   i j   multi-index))
                                                                (lambda (v . multi-index) (apply setter v i j   multi-index)))))))
                      ((3)  (case (%%interval-dimension right-interval)
                              ((1)  (lambda (i j k) (make-array right-interval
                                                                (lambda (      l) (getter   i j k l))
                                                                (lambda (v     l) (setter v i j k l)))))
                              (else (lambda (i j k) (make-array right-interval
                                                                (lambda      multi-index  (apply getter   i j k multi-index))
                                                                (lambda (v . multi-index) (apply setter v i j k multi-index)))))))
                      (else (lambda left-multi-index
                              (make-array right-interval
                                          (lambda      right-multi-index  (apply getter   (append left-multi-index right-multi-index)))
                                          (lambda (v . right-multi-index) (apply setter v (append left-multi-index right-multi-index))))))))))))

(define (%%specialized-array-curry array right-dimension)
  (call-with-values
      (lambda () (%%interval-projections (%%array-domain array) right-dimension))
    (lambda (left-interval right-interval)
      (let* ((input-array-in-order?
              (%%array-in-order? array))
             (in-order?
              (or (and (boolean? input-array-in-order?)  ;; we know whether the input array is in order
                       input-array-in-order?)            ;; and it is in order
                  ;; But even if it isn't, the subarrays may be in order, so we
                  ;; compute once whether all the subarrays are in order.
                  ;; We do this without actually instantiating one of the subarrays.
                  (%%compute-array-elements-in-order?
                   ;; The same domain for all subarrays.
                   right-interval
                   ;; The new indexer computed using the general, nonspecialized new-domain->old-domain function,
                   ;; applied specifically to the first multi-index in the left-interval.
                   (%%compose-indexers (%%array-indexer array)
                                       right-interval
                                       (lambda right-multi-index
                                         (apply values
                                                (append (%%interval-lower-bounds->list left-interval)
                                                        right-multi-index))))))))
        (make-array
         left-interval
         (case (%%interval-dimension left-interval)
           ((1)  (case (%%interval-dimension right-interval)
                   ((1)  (lambda (i)     (%%specialized-array-share array right-interval (lambda (j)                         (values i j    )) in-order?)))
                   ((2)  (lambda (i)     (%%specialized-array-share array right-interval (lambda (j k)                       (values i j k  )) in-order?)))
                   ((3)  (lambda (i)     (%%specialized-array-share array right-interval (lambda (j k l)                     (values i j k l)) in-order?)))
                   (else (lambda (i)     (%%specialized-array-share array right-interval (lambda multi-index (apply values i     multi-index)) in-order?)))))
           ((2)  (case (%%interval-dimension right-interval)
                   ((1)  (lambda (i j)   (%%specialized-array-share array right-interval (lambda (  k)                       (values i j k  )) in-order?)))
                   ((2)  (lambda (i j)   (%%specialized-array-share array right-interval (lambda (  k l)                     (values i j k l)) in-order?)))
                   (else (lambda (i j)   (%%specialized-array-share array right-interval (lambda multi-index (apply values i j   multi-index)) in-order?)))))
           ((3)  (case (%%interval-dimension right-interval)
                   ((1)  (lambda (i j k) (%%specialized-array-share array right-interval (lambda (    l)                     (values i j k l)) in-order?)))
                   (else (lambda (i j k) (%%specialized-array-share array right-interval (lambda multi-index (apply values i j k multi-index)) in-order?)))))
           (else (lambda left-multi-index
                   (%%specialized-array-share array right-interval (lambda right-multi-index (apply values (append left-multi-index right-multi-index))) in-order?)))))))))

(define (array-curry array right-dimension)
  (cond ((not (array? array))
         (error "array-curry: The first argument is not an array: " array right-dimension))
        ((not (and (fixnum? right-dimension)
                   (fx< 0 right-dimension (%%array-dimension array))))
         (error "array-curry: The second argument is not an exact integer between 0 and (interval-dimension (array-domain array)) (exclusive): " array right-dimension))
        ((specialized-array? array)
         (%%specialized-array-curry array right-dimension))
        ((mutable-array? array)
         (%%mutable-array-curry array right-dimension))
        (else ; immutable array
         (%%immutable-array-curry array right-dimension))))

;;;
;;; array-map returns an array whose domain is the same as the common domain of (cons array arrays)
;;; and whose getter is
;;;
;;; (lambda multi-index
;;;   (apply f (map (lambda (g) (apply g multi-index)) (map array-getter (cons array arrays)))))
;;;
;;; This function is also used in array-for-each, so we try to specialize the this
;;; function to speed things up a bit.
;;;

(define (%%specialize-function-applied-to-array-getters f array arrays)
  (let ((domain (%%array-domain array))
        (getter-0 (%%array-getter array)))
    (case (length arrays)
      ((0) (case (%%interval-dimension domain)
             ((1)  (lambda (i)         (f (getter-0 i))))
             ((2)  (lambda (i j)       (f (getter-0 i j))))
             ((3)  (lambda (i j k)     (f (getter-0 i j k))))
             ((4)  (lambda (i j k l)   (f (getter-0 i j k l))))
             (else (lambda multi-index (f (apply getter-0 multi-index))))))

      ((1) (let ((getter-1 (%%array-getter (car arrays))))
             (case (%%interval-dimension domain)
               ((1)  (lambda (i)         (f (getter-0 i)
                                            (getter-1 i))))
               ((2)  (lambda (i j)       (f (getter-0 i j)
                                            (getter-1 i j))))
               ((3)  (lambda (i j k)     (f (getter-0 i j k)
                                            (getter-1 i j k))))
               ((4)  (lambda (i j k l)   (f (getter-0 i j k l)
                                            (getter-1 i j k l))))
               (else (lambda multi-index (f (apply getter-0 multi-index)
                                            (apply getter-1 multi-index)))))))
      ((2) (let ((getter-1 (%%array-getter (car arrays)))
                 (getter-2 (%%array-getter (cadr arrays))))
             (case (%%interval-dimension domain)
               ((1)  (lambda (i)         (f (getter-0 i)
                                            (getter-1 i)
                                            (getter-2 i))))
               ((2)  (lambda (i j)       (f (getter-0 i j)
                                            (getter-1 i j)
                                            (getter-2 i j))))
               ((3)  (lambda (i j k)     (f (getter-0 i j k)
                                            (getter-1 i j k)
                                            (getter-2 i j k))))
               ((4)  (lambda (i j k l)   (f (getter-0 i j k l)
                                            (getter-1 i j k l)
                                            (getter-2 i j k l))))
               (else (lambda multi-index (f (apply getter-0 multi-index)
                                            (apply getter-1 multi-index)
                                            (apply getter-2 multi-index)))))))
      ((3) (let ((getter-1 (%%array-getter (car arrays)))
                 (getter-2 (%%array-getter (cadr arrays)))
                 (getter-3 (%%array-getter (caddr arrays))))
             (case (%%interval-dimension domain)
               ((1)  (lambda (i)         (f (getter-0 i)
                                            (getter-1 i)
                                            (getter-2 i)
                                            (getter-3 i))))
               ((2)  (lambda (i j)       (f (getter-0 i j)
                                            (getter-1 i j)
                                            (getter-2 i j)
                                            (getter-3 i j))))
               ((3)  (lambda (i j k)     (f (getter-0 i j k)
                                            (getter-1 i j k)
                                            (getter-2 i j k)
                                            (getter-3 i j k))))
               ((4)  (lambda (i j k l)   (f (getter-0 i j k l)
                                            (getter-1 i j k l)
                                            (getter-2 i j k l)
                                            (getter-3 i j k l))))
               (else (lambda multi-index (f (apply getter-0 multi-index)
                                            (apply getter-1 multi-index)
                                            (apply getter-2 multi-index)
                                            (apply getter-3 multi-index)))))))
      (else
       (let ((getters (cons getter-0 (map array-getter arrays))))
         (case (%%interval-dimension domain)
           ((1)  (lambda (i)         (apply f (map (lambda (g) (g i))                 getters))))
           ((2)  (lambda (i j)       (apply f (map (lambda (g) (g i j))               getters))))
           ((3)  (lambda (i j k)     (apply f (map (lambda (g) (g i j k))             getters))))
           ((4)  (lambda (i j k l)   (apply f (map (lambda (g) (g i j k l))           getters))))
           (else (lambda multi-index (apply f (map (lambda (g) (apply g multi-index)) getters))))))))))

(define (array-map f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-map: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-map: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-map: Not all arguments after the first have the same domain: " f array arrays))
        (else
         (make-array (%%array-domain array)
                     (%%specialize-function-applied-to-array-getters f array arrays)))))

;;; applies f to the elements of the arrays in lexicographical order.

(define (array-for-each f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-for-each: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-for-each: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-for-each: Not all arguments after the first have the same domain: " f array arrays))
        (else
         (%%interval-for-each (%%specialize-function-applied-to-array-getters f array arrays)
                              (%%array-domain array)))))

(define-macro (srfi/179#macro-make-predicates)

  (define (concat . args)
    (string->symbol (apply string-append (map (lambda (s) (if (string? s) s (symbol->string s ))) args))))

  (define (make-predicate name connector)
    `(define (,(concat '%%interval- name) f interval)
       (case (%%interval-dimension interval)
         ((1) (let ((lower-i (%%interval-lower-bound interval 0))
                    (upper-i (%%interval-upper-bound interval 0))
                    (index   0)
                    (n       (%%interval-volume interval)))
                (let i-loop ((i lower-i)
                             (index (fx- n 1)))
                  (cond ((eqv? 0 index)
                         (f i))
                        (else
                         (,connector (f i)
                                     (i-loop (+ i 1)
                                             (fx- index 1))))))))
         ((2) (let ((lower-i (%%interval-lower-bound interval 0))
                    (lower-j (%%interval-lower-bound interval 1))
                    (upper-i (%%interval-upper-bound interval 0))
                    (upper-j (%%interval-upper-bound interval 1))
                    (n       (%%interval-volume interval)))
                (let i-loop ((i lower-i)
                             (index (fx- n 1)))
                  ;; (< i upper-i) is always true because index is >= 0
                  (let j-loop ((j lower-j)
                               (index index))
                    (cond ((= j upper-j)
                           (i-loop (+ i 1)
                                   index))
                          ((eqv? 0 index)
                           (f i j))
                          (else
                           (,connector (f i j)
                                       (j-loop (+ j 1)
                                               (fx- index 1)))))))))
         ((3) (let ((lower-i (%%interval-lower-bound interval 0))
                    (lower-j (%%interval-lower-bound interval 1))
                    (lower-k (%%interval-lower-bound interval 2))
                    (upper-i (%%interval-upper-bound interval 0))
                    (upper-j (%%interval-upper-bound interval 1))
                    (upper-k (%%interval-upper-bound interval 2))
                    (n       (%%interval-volume interval)))
                (let i-loop ((i lower-i)
                             (index (fx- n 1)))
                  ;; (< i upper-i) is always true because index is >= 0
                  (let j-loop ((j lower-j)
                               (index index))
                    (if (< j upper-j)
                        (let k-loop ((k lower-k)
                                     (index index))
                          (cond ((= k upper-k)
                                 (j-loop (+ j 1)
                                         index))
                                ((eqv? 0 index)
                                 (f i j k))
                                (else
                                 (,connector (f i j k)
                                             (k-loop (+ k 1)
                                                     (fx- index 1))))))
                        (i-loop (+ i 1)
                                index))))))
         ((4) (let ((lower-i (%%interval-lower-bound interval 0))
                    (lower-j (%%interval-lower-bound interval 1))
                    (lower-k (%%interval-lower-bound interval 2))
                    (lower-l (%%interval-lower-bound interval 3))
                    (upper-i (%%interval-upper-bound interval 0))
                    (upper-j (%%interval-upper-bound interval 1))
                    (upper-k (%%interval-upper-bound interval 2))
                    (upper-l (%%interval-upper-bound interval 3))
                    (n       (%%interval-volume interval)))
                (let i-loop ((i lower-i)
                             (index (fx- n 1)))
                  (let j-loop ((j lower-j)
                               (index index))
                    (if (< j upper-j)
                        (let k-loop ((k lower-k)
                                     (index index))
                          (if (< k upper-k)
                              (let l-loop ((l lower-l)
                                           (index index))
                                (cond ((= l upper-l)
                                       (k-loop (+ k 1)
                                               index))
                                      ((eqv? 0 index)
                                       (f i j k l))
                                      (else
                                       (,connector (f i j k l)
                                                   (l-loop (+ l 1)
                                                           (fx- index 1))))))
                              (j-loop (+ j 1)
                                      index)))
                        (i-loop (+ i 1)
                                index))))))
         (else

          (let* ((lowers     (%%interval-lower-bounds interval))
                 (uppers     (%%interval-upper-bounds interval))
                 (dimensions (vector-length lowers))
                 (arg        (vector->list lowers))                    ;; the argument to which f is applied
                 (tails      (let ((result (make-vector dimensions)))  ;; the tails of the argument
                               (do ((i 0 (fx+ i 1))
                                    (arg arg (cdr arg)))
                                   ((fx= i dimensions) result)
                                 (vector-set! result i arg)))))
            (let loop ((dimension 0)
                       (total-index (fx- (%%interval-volume interval) 1)))
              (cond ((= (car (vector-ref tails dimension))
                        (vector-ref uppers dimension))
                     ;; We're done iterating in this dimension, set the arg index
                     ;; at this dimension back to the lower bound, increment the
                     ;; arg index at the previous dimension, and go back to the
                     ;; previous dimension
                     (let ((previous-tail (vector-ref tails (fx- dimension 1))))
                       (set-car! (vector-ref tails  dimension)
                                 (vector-ref lowers dimension))
                       (set-car! previous-tail
                                 (+ 1 (car previous-tail)))
                       (loop (fx- dimension 1)
                             total-index)))
                    ((fx< dimension (fx- dimensions 1))
                     (loop (fx+ dimension 1)
                           total-index))
                    ;; Now we're at the final dimension
                    ((eqv? 0 total-index)
                     (apply f arg))
                    (else
                     (,connector (apply f arg)
                                 (let ((current-tail (vector-ref tails dimension)))
                                   (set-car! current-tail
                                             (+ (car current-tail) 1))
                                   (loop dimension
                                         (fx- total-index 1))))))))))))

  (let ((result
         `(begin
            ,@(map make-predicate
                   '(any every)
                   '(or and)))))
    result))

(macro-make-predicates)

(define (array-every f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-every: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-every: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-every: Not all arguments after the first have the same domain: " f array arrays))
        (else
         (%%interval-every (%%specialize-function-applied-to-array-getters f array arrays)
                           (%%array-domain array)))))

(define (array-any f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-any: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-any: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-any: Not all arguments after the first have the same domain: " f array arrays))
        (else
         (%%interval-any (%%specialize-function-applied-to-array-getters f array arrays)
                         (%%array-domain array)))))


(define (%%array-fold op id a)
  (%%interval-fold (%%array-getter a) op id (%%array-domain a)))

(define (array-fold op id a)
  (cond ((not (procedure? op))
         (error "array-fold: The first argument is not a procedure: " op id a))
        ((not (array? a))
         (error "array-fold: The third argument is not an array: " op id a))
        (else
         (%%array-fold op id a))))

(define (array-fold-right op id a)
  (cond ((not (procedure? op))
         (error "array-fold-right: The first argument is not a procedure: " op id a))
        ((not (array? a))
         (error "array-fold-right: The third argument is not an array: " op id a))
        (else
         ;; We let array-reverse do a redundant array? check to not generate
         ;; a new vector of #t's.
         (%%array-fold op id (array-reverse a)))))

(define (array-reduce sum A)
  (cond ((not (array? A))
         (error "array-reduce: The second argument is not an array: " sum A))
        ((not (procedure? sum))
         (error "array-reduce: The first argument is not a procedure: " sum A))
        (else
         (case (%%array-dimension A)
           ((1) (let ((box '())
                      (A_ (%%array-getter A)))
                  (%%interval-for-each
                   (lambda (i)
                     (if (null? box)
                         (set! box (list (A_ i)))
                         (set-car! box (sum (car box)
                                            (A_ i)))))
                   (%%array-domain A))
                  (car box)))
           ((2) (let ((box '())
                      (A_ (%%array-getter A)))
                  (%%interval-for-each
                   (lambda (i j)
                     (if (null? box)
                         (set! box (list (A_ i j)))
                         (set-car! box (sum (car box)
                                            (A_ i j)))))
                   (%%array-domain A))
                  (car box)))
           ((3) (let ((box '())
                      (A_ (%%array-getter A)))
                  (%%interval-for-each
                   (lambda (i j k)
                     (if (null? box)
                         (set! box (list (A_ i j k)))
                         (set-car! box (sum (car box)
                                            (A_ i j k)))))
                   (%%array-domain A))
                  (car box)))
           ((4) (let ((box '())
                      (A_ (%%array-getter A)))
                  (%%interval-for-each
                   (lambda (i j k l)
                     (if (null? box)
                         (set! box (list (A_ i j k l)))
                         (set-car! box (sum (car box)
                                            (A_ i j k l)))))
                   (%%array-domain A))
                  (car box)))
           (else (let ((box '())
                       (A_ (%%array-getter A)))
                   (%%interval-for-each
                    (lambda args
                      (if (null? box)
                          (set! box (list (apply A_ args)))
                          (set-car! box (sum (car box)
                                             (apply A_ args)))))
                    (%%array-domain A))
                   (car box)))))))

(define (array->list array)
  (cond ((not (array? array))
         (error "array->list: The argument is not an array: " array))
        (else
         (array-fold-right cons '() array))))

(define (list->array l
                     interval
                     #!optional
                     (result-storage-class generic-storage-class)
                     (mutable? (specialized-array-default-mutable?))
                     (safe? (specialized-array-default-safe?)))
  (cond ((not (list? l))
         (error "list->array: The first argument is not a list: " l interval))
        ((not (interval? interval))
         (error "list->array: The second argument is not an interval: " l interval))
        ((not (storage-class? result-storage-class))
         (error "list->array: The third argument is not a storage-class: " l interval result-storage-class))
        ((not (boolean? mutable?))
         (error "list->array: The fourth argument is not a boolean: " l interval result-storage-class mutable?))
        ((not (boolean? safe?))
         (error "list->array: The fifth argument is not a boolean: " l interval result-storage-class mutable? safe?))
        (else
         (let* ((checker
                 (storage-class-checker  result-storage-class))
                (setter
                 (storage-class-setter   result-storage-class))
                (result
                 (%%make-specialized-array interval
                                           result-storage-class
                                           safe?))
                (body
                 (%%array-body result))
                (n
                 (%%interval-volume interval)))
           (let loop ((i 0)
                      (local l))
             (if (or (fx= i n) (null? local))
                 (if (and (fx= i n) (null? local))
                     (begin
                       (if (not mutable?)
                           (%%array-setter-set! result #f))
                       result)
                     (error "list->array: The length of the first argument does not equal the volume of the second: " l interval))
                 (let ((item (car local)))
                   (if (checker item)
                       (begin
                         (setter body i item)
                         (loop (fx+ i 1)
                               (cdr local)))
                       (error "list->array: Not every element of the list can be stored in the body of the array: " l interval item)))))))))

(define (array-assign! destination source)
  (cond ((not (mutable-array? destination))
         (error "array-assign!: The destination is not a mutable array: " destination source))
        ((not (array? source))
         (error "array-assign!: The source is not an array: " destination source))
        ((interval= (%%array-domain destination)
                    (%%array-domain source))
         (%%move-array-elements destination source "array-assign!: ")
         destination)
        ((not (fx= (%%interval-volume (%%array-domain destination))
                   (%%interval-volume (%%array-domain source))))
         (error "array-assign!: The destination and source do not have the same number of elements: " destination source))
        ((not (specialized-array? destination))
         (error "array-assign!: The destination and source do not have the same domains, and the destination is not a specialized array: " destination source))
        ((not (%%array-elements-in-order? destination))
         (error "array-assign!: The destination and source do not have the same domains, and the elements of the destination are not stored adjacently and in order: "
                destination source))
        (else
         (%%move-array-elements destination source "array-assign!: ")
         destination)))

;;; Because array-ref and array-set! have variable number of arguments, and
;;; they have to check on every call that the first argument is an array,
;;; compiled code using array-ref and array-set! can take up to three times
;;; as long as our usual notational convention:
;;;
;;; (let ((A_ (array-getter A))) ... (A_ i j) ...)
;;;

(define array-ref
  (case-lambda
   ((A i0)
    (if (not (array? A))
        (error "array-ref: The first argument is not an array: " A i0)
        ((%%array-getter A) i0)))
   ((A i0 i1)
    (if (not (array? A))
        (error "array-ref: The first argument is not an array: " A i0 i1)
        ((%%array-getter A) i0 i1)))
   ((A i0 i1 i2)
    (if (not (array? A))
        (error "array-ref: The first argument is not an array: " A i0 i1 i2)
        ((%%array-getter A) i0 i1 i2)))
   ((A i0 i1 i2 i3)
    (if (not (array? A))
        (error "array-ref: The first argument is not an array: " A i0 i1 i2 i3)
        ((%%array-getter A) i0 i1 i2 i3)))
   ((A i0 i1 i2 i3 . i-tail)
    (if (not (array? A))
        (apply error "array-ref: The first argument is not an array: " A i0 i1 i2 i3 i-tail)
        (apply (%%array-getter A) i0 i1 i2 i3 i-tail)))))

(define array-set!
  (case-lambda
   ((A v i0)
    (if (not (mutable-array? A))
        (error "array-set!: The first argument is not a mutable array: " A v i0)
        ((%%array-setter A) v i0)))
   ((A v i0 i1)
    (if (not (mutable-array? A))
        (error "array-set!: The first argument is not a mutable array: " A v i0 i1)
        ((%%array-setter A) v i0 i1)))
   ((A v i0 i1 i2)
    (if (not (mutable-array? A))
        (error "array-set!: The first argument is not a mutable array: " A v i0 i1 i2)
        ((%%array-setter A) v i0 i1 i2)))
   ((A v i0 i1 i2 i3)
    (if (not (mutable-array? A))
        (error "array-set!: The first argument is not a mutable array: " A v i0 i1 i2 i3)
        ((%%array-setter A) v i0 i1 i2 i3)))
   ((A v i0 i1 i2 i3 . i-tail)
    (if (not (mutable-array? A))
        (apply error "array-set!: The first argument is not a mutable array: " A v i0 i1 i2 i3 i-tail)
        (apply (%%array-setter A) v i0 i1 i2 i3 i-tail)))))

#|

The code for specialized-array-reshape is derived from _attempt_nocopy_reshape in

https://github.com/numpy/numpy/blob/7f836a9aca57de7fcae188b66ee1d8b60c6fc7b1/numpy/core/src/multiarray/shape.c

which is distributed under the following license:

Copyright (c) 2005-2020, NumPy Developers.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    * Redistributions of source code must retain the above copyright
       notice, this list of conditions and the following disclaimer.

    * Redistributions in binary form must reproduce the above
       copyright notice, this list of conditions and the following
       disclaimer in the documentation and/or other materials provided
       with the distribution.

    * Neither the name of the NumPy Developers nor the names of any
       contributors may be used to endorse or promote products derived
       from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

|#

(define (specialized-array-reshape array new-domain #!optional (copy-on-failure? #f))

  (define (vector-filter p v)

    ;; Decides whether to include v(k) in the result vector
    ;; by testing p(k), not p(v(k)).

    (let ((n (vector-length v)))
      (define (helper k i)
        (cond ((fx= k n)
               (make-vector i))
              ((p k)
               (let ((result (helper (fx+ k 1) (fx+ i 1))))
                 (vector-set! result i (vector-ref v k))
                 result))
              (else
               (helper (fx+ k 1) i))))
      (helper 0 0)))

  (cond ((not (specialized-array? array))
         (error "specialized-array-reshape: The first argument is not a specialized array: " array new-domain))
        ((not (interval? new-domain))
         (error "specialized-array-reshape: The second argument is not an interval " array new-domain))
        ((not (fx= (%%interval-volume (%%array-domain array))
                   (%%interval-volume new-domain)))
         (error "specialized-array-reshape: The volume of the domain of the first argument is not equal to the volume of the second argument: " array new-domain))
        ((not (boolean? copy-on-failure?))
         (error "specialized-array-reshape: The third argument is not a boolean: " array new-domain copy-on-failure?))
        (else
         (let* ((indexer
                 (%%array-indexer array))
                (domain
                 (%%array-domain array))
                (lowers
                 (%%interval-lower-bounds domain))
                (uppers
                 (%%interval-upper-bounds domain))
                (dims
                 (vector-length lowers))
                (sides
                 (vector-map (lambda (u l) (- u l)) uppers lowers))
                (args
                 (vector->list lowers))
                (base
                 (apply indexer args))
                (strides
                 (let ((result   (make-vector dims))
                       (vec-args (let ((result (make-vector dims)))
                                   (do ((i 0 (fx+ i 1))
                                        (args-tail args (cdr args-tail)))
                                       ((fx= i dims) result)
                                     (vector-set! result i args-tail)))))
                   (do ((i 0 (fx+ i 1)))
                       ((fx= i dims) result)
                     (let ((arg (vector-ref vec-args i)))
                       ;; gives a nonsense result if (vector-ref sides i) is 1,
                       ;; but doesn't matter.
                       (set-car! arg (+ 1 (car arg)))
                       (vector-set! result i (fx- (apply indexer args) base))
                       (set-car! arg (+ -1 (car arg)))))))
                (filtered-strides
                 (vector-filter (lambda (i)
                                  (not (eqv? 1 (vector-ref sides i))))
                                strides))
                (filtered-sides
                 (vector-filter (lambda (i)
                                  (not (eqv? 1 (vector-ref sides i))))
                                sides))
                (new-sides
                 (vector-map (lambda (u l) (- u l))
                             (%%interval-upper-bounds new-domain)
                             (%%interval-lower-bounds new-domain)))
                ;; Notation from the NumPy code
                (newdims
                 new-sides)
                (olddims
                 filtered-sides)
                (oldstrides
                 filtered-strides)
                (newnd
                 (vector-length new-sides))
                (newstrides
                 (make-vector newnd 0))
                (oldnd
                 (vector-length filtered-sides)))
           ;; In the following loops, the error call is in tail position
           ;; so it can be continued.
           ;; From this point on we're going to closely follow NumPy's code
           (let loop-1 ((oi 0)
                        (oj 1)
                        (ni 0)
                        (nj 1))
             (if (and (fx< ni newnd)
                      (fx< oi oldnd))
                 ;; We find a minimal group of adjacent dimensions from left to right
                 ;; on the old and new intervals with the same volume.
                 ;; We then check to see that the elements in the old array of these
                 ;; dimensions are evenly spaced, so an affine map can
                 ;; cover them.
                 (let loop-2 ((nj nj)
                              (oj oj)
                              (np (vector-ref newdims ni))
                              (op (vector-ref olddims oi)))
                   (if (not (fx= np op))
                       (if (fx< np op)
                           (loop-2 (fx+ nj 1)
                                   oj
                                   (fx* np (vector-ref newdims nj))
                                   op)
                           (loop-2 nj
                                   (fx+ oj 1)
                                   np
                                   (fx* op (vector-ref olddims oj))))
                       (let loop-3 ((ok oi))
                         (if (fx< ok (fx- oj 1))
                             (if (not (fx= (vector-ref oldstrides ok)
                                           (fx* (vector-ref olddims    (fx+ ok 1))
                                                (vector-ref oldstrides (fx+ ok 1)))))
                                 (if copy-on-failure?
                                     (%%array-copy array
                                                   (%%array-storage-class array)
                                                   new-domain
                                                   (mutable-array? array)
                                                   (array-safe? array))
                                     (error "specialized-array-reshape: Requested reshaping is impossible: " array new-domain))
                                 (loop-3 (fx+ ok 1)))
                             (begin
                               (vector-set! newstrides (fx- nj 1) (vector-ref oldstrides (fx- oj 1)))
                               (let loop-4 ((nk (fx- nj 1)))
                                 (if (fx< ni nk)
                                     (begin
                                       (vector-set! newstrides (fx- nk 1) (fx* (vector-ref newstrides nk)
                                                                               (vector-ref newdims nk)))
                                       (loop-4 (fx- nk 1)))
                                     (loop-1 oj
                                             (fx+ oj 1)
                                             nj
                                             (fx+ nj 1)))))))))
                 ;; The NumPy code then sets the strides of the last
                 ;; dimensions with side-length 1 to a value, we leave it zero.
                 (let* ((new-lowers
                         (%%interval-lower-bounds new-domain))
                        (indexer
                         (case newnd
                           ((1) (%%indexer-1 base
                                             (vector-ref new-lowers 0)
                                             (vector-ref newstrides 0)))
                           ((2) (%%indexer-2 base
                                             (vector-ref new-lowers 0)
                                             (vector-ref new-lowers 1)
                                             (vector-ref newstrides 0)
                                             (vector-ref newstrides 1)))
                           ((3) (%%indexer-3 base
                                             (vector-ref new-lowers 0)
                                             (vector-ref new-lowers 1)
                                             (vector-ref new-lowers 2)
                                             (vector-ref newstrides 0)
                                             (vector-ref newstrides 1)
                                             (vector-ref newstrides 2)))
                           ((4) (%%indexer-4 base
                                             (vector-ref new-lowers 0)
                                             (vector-ref new-lowers 1)
                                             (vector-ref new-lowers 2)
                                             (vector-ref new-lowers 3)
                                             (vector-ref newstrides 0)
                                             (vector-ref newstrides 1)
                                             (vector-ref newstrides 2)
                                             (vector-ref newstrides 3)))
                           (else
                            (%%indexer-generic base
                                               (vector->list new-lowers)
                                               (vector->list newstrides))))))
                   (%%finish-specialized-array new-domain
                                               (%%array-storage-class array)
                                               (%%array-body array)
                                               indexer
                                               (mutable-array? array)
                                               (%%array-safe? array)
                                               (%%array-in-order? array)))))))))

(declare (inline))
