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

;;; declarations to reduce the size of the .o file in Gambit

(declare (standard-bindings)
         (extended-bindings)
         (inlining-limit 600)
         (block)
         (mostly-fixnum)
         (not safe))

;;; VOID: Since the results returned by <whatever>vector-set! is not defined,
;;; and Gambit returns the vector itself when code is compiled with
;;; (declare (standard-bindings) (not safe)),
;;; we follow all setters with the nonstandard procedure (void).
;;; If your Scheme doesn't have (void) you can
;;; (define (void) (if #f #f))
;;; This doesn't work on Racket, which disallows one-armed if's, but Racket
;;; already defines (void).

;;; INLINING: Gambit's inlining directives are a bit of a coarse tool.
;;; So what I've decided to do is not inline by default, and inline
;;; small accessors, etc., by hand.  Let's hope I catch them all.

(declare (inline))

;;; An interval is a cross product of multi-indices

;;; [l_0,u_0) x [l_1,u_1) x ... x [l_n-1,u_n-1)

;;; where l_i < u_i for 0 <= i < n, and n >= 0 is the dimension of the interval

(define-type %%interval
  id: 63374ab5-06fa-4d43-8c74-dd46f75ff7b5
  copier: #f
  no-functional-setter:
  (dimension read-only:)                  ;; a fixnum
  (%%volume read-write: equality-skip:)   ;; #f or an exact integer, calculated when needed
  (lower-bounds read-only:)               ;; a vector of exact integers l_0,...,l_n-1
  (upper-bounds read-only:)               ;; a vector of exact integers u_0,...,u_n-1
  )


(define-type %%array
  id: d0995125-4e60-4b86-90a2-3bffbe52bcc4
  copier: #f
  ;; Part of all arrays
  ;; an interval
  no-functional-setter:
  (domain read-only:)
  ;; (lambda (i_0 ... i_n-1) ...) returns a value for (i_0,...,i_n-1) in (array-domain a)
  (getter read-only:)
  ;; Part of mutable arrays
  ;; (lambda (v i_0 ... i_n-1) ...) sets a value for (i_0,...,i_n-1) in (array-domain a)
  (setter read-write:)
  ;; Part of specialized arrays
  ;; a storage class
  (storage-class read-only:)
  ;; the backing store for this array
  (body read-only:)
  ;; see below
  (indexer read-only:)
  ; do we check whether bounds (in getters and setters) and values (in setters) are valid
  (safe? read-only:)
  ; are the elements adjacent and in order?
  (in-order? read-write:)
  )

;;;
;;; A storage-class contains functions and objects to manipulate the
;;; backing store of a specialized-array.
;;;
;;; getter:     (lambda (body i) ...)   returns the value of body at index i
;;; setter:     (lambda (body i v) ...) sets the value of body at index i to v
;;; checker:    (lambda (val) ...)      checks that val is an appropriate value for storing in (maker n)
;;; maker:      (lambda (n val) ...)    makes a body of length n with value val
;;; length:     (lambda (body) ...)     returns the number of objects in body
;;; default:    object                  is the default value with which to fill body
;;; data?:      (lambda (data) ...)     returns #t iff data can be converted to a body
;;; data->body: (lambda (data) ...)     converts data to a body, raising an exception if needed
;;;

(define-type storage-class
  id: 65dd13e3-eb6d-4214-8de6-78d962d71885
  copier: #f
  read-only:
  no-functional-setter:
  getter
  setter
  checker
  maker
  copier
  length
  default
  data?
  data->body
  )

(declare (not inline))

;;; Our naming convention prefixes %% to the names of internal procedures,

(cond-expand
 ((or gambit r7rs)
  (begin
    (define (c64vector-copy! to at from start end)
      (f32vector-copy! to (fx* 2 at) from (fx* 2 start) (fx* 2 end)))
    (define (c128vector-copy! to at from start end)
      (f64vector-copy! to (fx* 2 at) from (fx* 2 start) (fx* 2 end)))))
 (else
  ;; Punt
  (begin
    (define vector-copy! #f)
    (define s8vector-copy! #f)
    (define s16vector-copy! #f)
    (define s32vector-copy! #f)
    (define s64vector-copy! #f)
    (define u8vector-copy! #f)
    (define u16vector-copy! #f)
    (define u32vector-copy! #f)
    (define u64vector-copy! #f)
    (define string-copy! #f)
    (define c64vector-copy! #f)
    (define c128vector-copy! #f))))

;;; We use the built-in Gambit procedure ##mutable?

;; Inlining the following routines causes too much code bloat
;; after compilation.

;;; We do not need a multi-argument every.

(define (%%every pred list)
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

(define (interval? x)
  (%%interval? x))

(define %%vector-of-zeros
  '#(#()
     #(0)
     #(0 0)
     #(0 0 0)
     #(0 0 0 0)))

(define (%%finish-interval lower-bounds upper-bounds)
  ;; Requires that lower-bounds and upper-bounds are not user visible and therefore
  ;; not user modifiable.
  (make-%%interval (vector-length upper-bounds)
                   #f
                   lower-bounds
                   upper-bounds))

(define make-interval
  (case-lambda
   ((upper-bounds)
    (cond ((not (and (vector? upper-bounds)
                     (%%vector-every (lambda (x) (exact-integer? x)) upper-bounds)
                     (%%vector-every (lambda (x) (not (negative? x))) upper-bounds)))
           (error "make-interval: The argument is not a vector of nonnegative exact integers: " upper-bounds))
          (else
           (let ((dimension (vector-length upper-bounds)))
             (%%finish-interval (if (fx< dimension 5)
                                    (vector-ref %%vector-of-zeros dimension)
                                    (make-vector dimension 0))
                                (vector-copy upper-bounds))))))
   ((lower-bounds upper-bounds)
    (cond ((not (and (vector? lower-bounds)
                     (%%vector-every (lambda (x) (exact-integer? x)) lower-bounds)))
           (error "make-interval: The first argument is not a vector of exact integers: " lower-bounds upper-bounds))
          ((not (and (vector? upper-bounds)
                     (%%vector-every (lambda (x) (exact-integer? x)) upper-bounds)))
           (error "make-interval: The second argument is not a vector of exact integers: " lower-bounds upper-bounds))
          ((not (fx= (vector-length lower-bounds)
                     (vector-length upper-bounds)))
           (error "make-interval: The first and second arguments are not the same length: " lower-bounds upper-bounds))
          ((not (%%vector-every (lambda (x y) (<= x y)) lower-bounds upper-bounds))
           (error "make-interval: Each lower-bound must be no greater than the associated upper-bound: " lower-bounds upper-bounds))
          (else
           (%%finish-interval (vector-copy lower-bounds)
                              (vector-copy upper-bounds)))))))

(define (%%interval-lower-bound interval i)
  (vector-ref (%%interval-lower-bounds interval) i))

(define (%%interval-upper-bound interval i)
  (vector-ref (%%interval-upper-bounds interval) i))

(define (%%interval-width interval k)
  (- (%%interval-upper-bound interval k)
     (%%interval-lower-bound interval k)))

(define (%%interval-widths interval)
  (vector-map (lambda (x y) (- x y))
              (%%interval-upper-bounds interval)
              (%%interval-lower-bounds interval)))

(define (%%interval-lower-bounds->vector interval)
  (vector-copy (%%interval-lower-bounds interval)))

(define (%%interval-upper-bounds->vector interval)
  (vector-copy (%%interval-upper-bounds interval)))

(define (%%interval-lower-bounds->list interval)
  (vector->list (%%interval-lower-bounds interval)))

(define (%%interval-upper-bounds->list interval)
  (vector->list (%%interval-upper-bounds interval)))

(define-macro (macro-make-index-tables)
  `(begin
     (define %%index-rotates
       ',(list->vector
          (map (lambda (n)
                 (list->vector
                  (map (lambda (k)
                         (list->vector
                          (let ((identity-permutation (iota n)))
                            (append (drop identity-permutation k)
                                    (take identity-permutation k)))))
                       (iota (+ n 1)))))
               (iota 5))))

     (define %%index-firsts
       ',(list->vector
          (map (lambda (n)
                 (list->vector
                  (map (lambda (k)
                         (list->vector
                          (let ((identity-permutation (iota n)))
                            (cons k
                                  (append (take identity-permutation k)
                                          (drop identity-permutation (fx+ k 1)))))))
                       (iota n))))
               (iota 5))))

     (define %%index-lasts
       ',(list->vector
          (map (lambda (n)
                 (list->vector
                  (map (lambda (k)
                         (list->vector
                          (let ((identity-permutation (iota n)))
                            (append (take identity-permutation k)
                                    (drop identity-permutation (fx+ k 1))
                                    (list k)))))
                       (iota n))))
               (iota 5))))
     (define %%index-swaps
       `,(list->vector
          (map (lambda (n)
                 (list->vector
                  (map (lambda (i)
                         (list->vector
                          (map (lambda (j)
                                 (let ((result (list->vector (iota n))))
                                   (vector-set! result i j)
                                   (vector-set! result j i)
                                   result))
                               (iota n))))
                       (iota n))))
               (iota 5))))))

(macro-make-index-tables)

(define (%%index-rotate n k)
  (if (fx< n 5)
      (vector-ref (vector-ref %%index-rotates n) k)
      (let ((identity-permutation (iota n)))
        (list->vector (append (drop identity-permutation k)
                              (take identity-permutation k))))))

(define (%%index-first n k)
  (if (fx< n 5)
      (vector-ref (vector-ref %%index-firsts n) k)
      (let ((identity-permutation (iota n)))
        (list->vector (cons k
                            (append (take identity-permutation k)
                                    (drop identity-permutation (fx+ k 1))))))))

(define (%%index-last n k)
  (if (fx< n 5)
      (vector-ref (vector-ref %%index-lasts n) k)
      (let ((identity-permutation (iota n)))
        (list->vector (append (take identity-permutation k)
                              (drop identity-permutation (fx+ k 1))
                              (list k))))))

(define (%%index-swap n i j)
  (if (fx< n 5)
      (vector-ref (vector-ref (vector-ref %%index-swaps n) i) j)
      (let ((result (list->vector (iota n))))
        (vector-set! result i j)
        (vector-set! result j i)
        result)))

(define (%%interval-empty? interval)
  (eqv? (%%interval-volume interval) 0))

(define (%%interval-volume interval)
  (or (%%interval-%%volume interval)
      (%%compute-interval-volume interval)))

(declare (not inline))

(define (%%compute-interval-volume interval)
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
        volume))

(define (index-rotate n k)
  (cond ((not (and (fixnum? n)
                   (fx<= 0 n)))
         (error "index-rotate: The first argument is not a nonnegative fixnum: " n k))
        ((not (and (fixnum? k)
                   (fx<= 0 k n)))
         (error "index-rotate: The second argument is not a fixnum between 0 and the first argument (inclusive): " n k))
        (else
         (%%index-rotate n k))))

(define (index-first n k)
  (cond ((not (and (fixnum? n)
                   (fxpositive? n)))
         (error "index-first: The first argument is not a positive fixnum: " n k))
        ((not (and (fixnum? k)
                   (fx<= 0 k)
                   (fx< k n)))
         (error "index-first: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): " n k))
        (else
         (%%index-first n k))))

(define (index-last n k)
  (cond ((not (and (fixnum? n)
                   (fxpositive? n)))
         (error "index-last: The first argument is not a positive fixnum: " n k))
        ((not (and (fixnum? k)
                   (fx<= 0 k)
                   (fx< k n)))
         (error "index-last: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): " n k))
        (else
         (%%index-last n k))))

(define (index-swap n i j)
  (cond ((not (and (fixnum? n)
                   (fxpositive? n)))
         (error "index-swap: The first argument is not a positive fixnum: " n i j))
        ((not (and (fixnum? i) (fx<= 0 i) (fx< i n)))
         (error "index-swap: The second argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): " n i j))
        ((not (and (fixnum? j) (fx<= 0 j) (fx< j n)))
         (error "index-swap: The third argument is not a fixnum between 0 (inclusive) and the first argument (exclusive): " n i j))
        (else
         (%%index-swap n i j))))

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

(define (interval-width interval k)
  (cond ((not (interval? interval))
         (error "interval-width: The first argument is not an interval: " interval k))
        ((not (and (fixnum? k)
                   (fx< -1 k (%%interval-dimension interval))))
         (error "interval-width: The second argument is not an exact integer between 0 (inclusive) and the dimension of the first argument (exclusive): " interval k))
        (else
         (%%interval-width interval k))))

(define (interval-widths interval)
  (cond ((not (interval? interval))
         (error "interval-widths: The argument is not an interval: " interval))
        (else
         (%%interval-widths interval))))

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
        ((not (and (fixnum? right-dimension)
                   (fx<= 0 right-dimension (%%interval-dimension interval))))
         (error "interval-projections: The second argument is not an exact integer between 0 and the dimension of the first argument (inclusive): " interval right-dimension))
        (else
         (%%interval-projections interval right-dimension))))

(define (%%interval-projections interval right-dimension)
  (let ((left-dimension
         (fx- (%%interval-dimension interval) right-dimension))
        (lowers
         (%%interval-lower-bounds->list interval))
        (uppers
         (%%interval-upper-bounds->list interval)))
    (values (%%finish-interval (list->vector (take lowers left-dimension))
                               (list->vector (take uppers left-dimension)))
            (%%finish-interval (list->vector (drop lowers left-dimension))
                               (list->vector (drop uppers left-dimension))))))

(define (interval-volume interval)
  (cond ((not (interval? interval))
         (error "interval-volume: The argument is not an interval: " interval))
        (else
         (%%interval-volume interval))))

(define (interval-empty? interval)
  (cond ((not (interval? interval))
         (error "interval-empty?: The argument is not an interval: " interval))
        (else
         (%%interval-empty? interval))))

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
    ;; lowers is not newly allocated, but it's already been copied because it's the
    ;; lower bounds of an existing interval
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
  ;; Even if there is only one interval, its lower and upper bounds have already been copied.
  (%%finish-interval (vector-concatenate (map %%interval-lower-bounds intervals))
                     (vector-concatenate (map %%interval-upper-bounds intervals))))

(define (interval-cartesian-product #!rest intervals)
  (cond ((not (%%every interval? intervals))
         (apply error "interval-cartesian-product: Not all arguments are intervals: " intervals))
        (else
         (%%interval-cartesian-product intervals))))

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
           (if (%%vector-every (lambda (x y) (<= x y)) new-lower-bounds new-upper-bounds)
               (%%finish-interval new-lower-bounds new-upper-bounds)
               (error "interval-dilate: Some resulting lower bounds are greater than corresponding upper bounds: " interval lower-diffs upper-diffs))))))

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
  (and (%%vector-every (lambda (x y) (>= x y)) (%%interval-lower-bounds interval1) (%%interval-lower-bounds interval2))
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
    (and (%%vector-every (lambda (x y) (<= x y)) lower-bounds upper-bounds)
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

(define (interval-contains-multi-index? interval #!rest multi-index)

  ;; this is relatively slow, but (a) I haven't seen a need to use it yet, and (b) this formulation
  ;; significantly simplifies testing the error checking

  (cond ((not (interval? interval))
         (error "interval-contains-multi-index?: The first argument is not an interval: " interval))
        ((not (fx= (%%interval-dimension interval)
                   (length multi-index)))
         (apply error "interval-contains-multi-index?: The dimension of the first argument (an interval) does not match number of indices: " interval multi-index))
        ((not (%%every (lambda (x) (exact-integer? x)) multi-index))
         (apply error "interval-contains-multi-index?: At least one multi-index component is not an exact integer: " interval multi-index))
        (else
         (%%interval-contains-multi-index?-general interval multi-index))))

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
  (%%interval-fold-left f
                        (lambda (ignore f_i)
                          #t)   ;; just compute (apply f multi-index)
                        'ignore
                        interval)
  (void))

;;; Calculates
;;;
;;; (...(operator (operator (operator identity (f multi-index_1)) (f multi-index_2)) (f multi-index_3)) ...)
;;;
;;; where multi-index_1, multi-index_2, ... are the elements of interval in lexicographical order

(define (interval-fold-left f operator identity interval)
  (cond ((not (interval? interval))
         (error "interval-fold-left: The fourth argument is not an interval: " f operator identity interval))
        ((not (procedure? operator))
         (error "interval-fold-left: The second argument is not a procedure: " f operator identity interval))
        ((not (procedure? f))
         (error "interval-fold-left: The first argument is not a procedure: " f operator identity interval))
        (else
         (%%interval-fold-left f operator identity interval))))

(define (%%interval-fold-left f operator identity interval)

  (define-macro (generate-code)

    (define (symbol-append . args)
      (string->symbol
       (apply string-append (map (lambda (x)
                                   (cond ((symbol? x) (symbol->string x))
                                         ((number? x) (number->string x))
                                         ((string? x) x)
                                         (else (error "Arghh!"))))
                                 args))))


      (define (make-lower k)
        (symbol-append 'lower- k))

      (define (make-upper k)
        (symbol-append 'upper- k))

      (define (make-arg k)
        (symbol-append 'i_ k))

      (define (make-loop-name k)
        (symbol-append 'loop- k))

      (define (make-loop index depth k)
        `(let ,(make-loop-name index) ((,(make-arg index) ,(make-lower index))
                                       (result result))
              (if (= ,(make-arg index) ,(make-upper index))
                  ,(if (= index 0)
                       `result
                       `(,(make-loop-name (- index 1)) (+ ,(make-arg (- index 1)) 1) result))
                  ,(if (= depth 0)
                       `(,(make-loop-name index) (+ ,(make-arg index) 1) (operator result (f ,@(map (lambda (i) (make-arg i)) (iota k)))))
                       (make-loop (+ index 1) (- depth 1) k)))))

      (define (do-one-case k)
        (let ((result
               `((,k)
                 (let (,@(map (lambda (j)
                                `(,(make-lower j) (%%interval-lower-bound interval ,j)))
                              (iota k))
                       ,@(map (lambda (j)
                                `(,(make-upper j) (%%interval-upper-bound interval ,j)))
                              (iota k))
                       (result identity))
                   ,(make-loop 0 (- k 1) k)))))
          result))

      `(case (%%interval-dimension interval)
         ((0) (operator identity (f)))
         ,@(map do-one-case (iota 8 1))
         (else
          (let ()

            (define (get-next-args reversed-args
                                   reversed-lowers
                                   reversed-uppers)
              (let ((next-index (+ (car reversed-args) 1)))
                (if (< next-index (car reversed-uppers))
                    (cons next-index (cdr reversed-args))
                    (and (not (null? (cdr reversed-args)))
                         (let ((tail-result (get-next-args (cdr reversed-args)
                                                           (cdr reversed-lowers)
                                                           (cdr reversed-uppers))))
                           (and tail-result
                                (cons (car reversed-lowers) tail-result)))))))

            (let ((reversed-lowers (reverse (%%interval-lower-bounds->list interval)))
                  (reversed-uppers (reverse (%%interval-upper-bounds->list interval))))
              (let loop ((reversed-args reversed-lowers)
                         (result identity))
             ;;; There's at least one element of the interval, so we can
             ;;; use a do-until loop
                (let ((result (operator result (apply f (reverse reversed-args))))
                      (next-reversed-args (get-next-args reversed-args
                                                         reversed-lowers
                                                         reversed-uppers)))
                  (if next-reversed-args
                      (loop next-reversed-args result)
                      result))))))))

  (if (%%interval-empty? interval) ;; handle (make-interval '#(10000000 10000000 0)) efficiently
      identity
      (generate-code)))

(define (interval-fold-right f operator identity interval)
  (cond ((not (interval? interval))
         (error "interval-fold-right: The fourth argument is not an interval: " f operator identity interval))
        ((not (procedure? operator))
         (error "interval-fold-right: The second argument is not a procedure: " f operator identity interval))
        ((not (procedure? f))
         (error "interval-fold-right: The first argument is not a procedure: " f operator identity interval))
        (else
         (%%interval-fold-right f operator identity interval))))

(define (%%interval-fold-right f operator identity interval)

  (declare (not lambda-lift))

  (define-macro (generate-code)

    (define (symbol-append . args)
      (string->symbol
       (apply string-append (map (lambda (x)
                                   (cond ((symbol? x) (symbol->string x))
                                         ((number? x) (number->string x))
                                         ((string? x) x)
                                         (else (error "Arghh!"))))
                                 args))))


      (define (make-lower k)
        (symbol-append 'lower- k))

      (define (make-upper k)
        (symbol-append 'upper- k))

      (define (make-arg k)
        (symbol-append 'i_ k))

      (define (make-loop-name k)
        (symbol-append 'loop- k))

      (define (make-loop index depth k)
        `(let ,(make-loop-name index) ((,(make-arg index) ,(make-lower index)))
              (if (= ,(make-arg index) ,(make-upper index))
                  ,(if (= index 0)
                       `identity
                       `(,(make-loop-name (- index 1)) (+ ,(make-arg (- index 1)) 1)))
                  ,(if (= depth 0)
                       `(let* ((item (f ,@(map (lambda (i) (make-arg i)) (iota k))))
                               (result (,(make-loop-name index) (+ ,(make-arg index) 1))))
                          (operator item result))
                       (make-loop (+ index 1) (- depth 1) k)))))

      (define (do-one-case k)
        (let ((result
               `((,k)
                 (let (,@(map (lambda (j)
                                `(,(make-lower j) (%%interval-lower-bound interval ,j)))
                              (iota k))
                       ,@(map (lambda (j)
                                `(,(make-upper j) (%%interval-upper-bound interval ,j)))
                              (iota k))
                       (i 0))
                   ,(make-loop 0 (- k 1) k)))))
          result))

      (let ((result
             `(case (%%interval-dimension interval)
                ((0) (operator (f) identity))
                ,@(map do-one-case (iota 8 1))
                (else
                 (let ()

                   (define (get-next-args reversed-args
                                          reversed-lowers
                                          reversed-uppers)
                     (let ((next-index (+ (car reversed-args) 1)))
                       (if (< next-index (car reversed-uppers))
                           (cons next-index (cdr reversed-args))
                           (and (not (null? (cdr reversed-args)))
                                (let ((tail-result (get-next-args (cdr reversed-args)
                                                                  (cdr reversed-lowers)
                                                                  (cdr reversed-uppers))))
                                  (and tail-result
                                       (cons (car reversed-lowers) tail-result)))))))

                     (let ((reversed-lowers (reverse (%%interval-lower-bounds->list interval)))
                           (reversed-uppers (reverse (%%interval-upper-bounds->list interval))))
                       (let loop ((reversed-args reversed-lowers))
                         (if reversed-args
                             (let* ((item (apply f (reverse reversed-args)))
                                    (result (loop (get-next-args reversed-args
                                                               reversed-lowers
                                                               reversed-uppers))))
                               (operator item result))
                             identity))))))))
        result))

  (if (%%interval-empty? interval)
      identity
      (generate-code)))

;; We'll use the same basic container for all types of arrays.

(declare (inline))

(define specialized-array-default-safe?
  (make-parameter
   #f
   (lambda (bool)
     (if (boolean? bool)
         bool
         (error "specialized-array-default-safe?: The argument is not a boolean: " bool)))))

(define specialized-array-default-mutable?
  (make-parameter
   #t
   (lambda (bool)
     (if (boolean? bool)
         bool
         (error "specialized-array-default-mutable?: The argument is not a boolean: " bool)))))


;; An array has a domain (which is an interval) and an getter that maps that domain into some type of
;; Scheme objects

(define %%order-unknown 1) ;; can be any nonboolean

(define (%%empty-getter domain)
  (lambda args (apply error "array-getter: Array domain is empty: " domain args)))

(define (%%empty-setter domain)
  (lambda args (apply error "array-setter: Array domain is empty: " domain args)))

(define make-array
  (case-lambda
   ((domain getter)
    (cond ((not (interval? domain))
           (error "make-array: The first argument is not an interval: " domain getter))
          ((not (procedure? getter))
           (error "make-array: The second argument is not a procedure: " domain getter))
          (else
           (make-%%array domain
                         (if (%%interval-empty? domain)
                             (%%empty-getter domain)
                             getter)
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
                         (if (%%interval-empty? domain)
                             (%%empty-getter domain)
                             getter)
                         (if (%%interval-empty? domain)
                             (%%empty-setter domain)
                             setter)
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

(define (%%array-freeze! A)
  (%%array-setter-set! A #f)
  A)

(define (array-freeze! A)
  (cond ((not (array? A))
         (error "array-freeze!: The argument is not an array: " A))
        (else
         (%%array-freeze! A))))

(declare (not inline))

;;; We define specialized storage-classes for:
;;;
;;; 32- and 64-bit floating-point numbers,
;;; complex numbers with real and imaginary parts of 32- and 64-bit floating-point numbers respectively
;;; 8-, 16-, 32-, and 64-bit signed integers,
;;; 8-, 16-, 32-, and 64-bit unsigned integers, and
;;; 1-bit unsigned integers
;;;
;;; as well as generic objects.

(define-macro (make-standard-storage-classes)

  (define (symbol-concatenate . symbols)
    (string->symbol (apply string-append (map (lambda (s)
                                                (if (string? s)
                                                    s
                                                    (symbol->string s)))
                                              symbols))))

  `(begin
     ,@(map (lambda (name prefix default checker)
              (let ((name   (symbol-concatenate name '-storage-class))
                    (ref    (symbol-concatenate prefix '-ref))
                    (set!   (symbol-concatenate prefix '-set!))
                    (make   (symbol-concatenate 'make- prefix))
                    (copy!  (symbol-concatenate prefix '-copy!))
                    (length (symbol-concatenate prefix '-length))
                    (?      (symbol-concatenate prefix '?)))
                `(define ,name
                   (make-storage-class
                    ;; getter
                    (lambda (v i)
                      (,ref v i))
                    ;; setter
                    (lambda (v i val)
                      (,set! v i val) (void))
                    ;; checker
                    ,checker           ;; already expanded
                    ;; maker
                    (lambda (n val)
                      (,make n val))
                    ;; copier
                    ,copy!             ;; complex call to memcopy, so don't expand
                    ;; length
                    (lambda (v)
                      (,length v))
                    ;; default
                    ,default
                    ;; data?
                    (lambda (data)
                      (,? data))
                    ;; data->body
                    (lambda (data)
                      (if (,? data)
                          data
                          (error ,(symbol->string
                                   (symbol-concatenate
                                    "Expecting a "
                                    prefix
                                    " passed to "
                                    "(storage-class-data->body "
                                    name
                                    "): "))
                                 data)))))))
            '(generic s8       u8       s16       u16       s32       u32       s64       u64       f32       f64       char)
            '(vector  s8vector u8vector s16vector u16vector s32vector u32vector s64vector u64vector f32vector f64vector string)
            '(#f      0        0        0         0         0         0         0         0         0.0        0.0     #\0)
            `((lambda (x) #t)                        ; generic
              (lambda (x)                            ; s8
                (and (fixnum? x)
                     (fx<= ,(- (expt 2 7))
                           x
                           ,(- (expt 2 7) 1))))
              (lambda (x)                            ; u8
                (and (fixnum? x)
                     (fx<= 0
                           x
                           ,(- (expt 2 8) 1))))
              (lambda (x)                            ; s16
                (and (fixnum? x)
                     (fx<= ,(- (expt 2 15))
                           x
                           ,(- (expt 2 15) 1))))
              (lambda (x)                            ; u16
                (and (fixnum? x)
                     (fx<= 0
                           x
                           ,(- (expt 2 16) 1))))
              (lambda (x)                            ; s32
                (declare (generic))
                (and (exact-integer? x)
                     (<= ,(- (expt 2 31))
                         x
                         ,(- (expt 2 31) 1))))
              (lambda (x)                            ; u32
                (declare (generic))
                (and (exact-integer? x)
                     (<= 0
                         x
                         ,(- (expt 2 32) 1))))
              (lambda (x)                            ; s64
                (declare (generic))
                (and (exact-integer? x)
                     (<= ,(- (expt 2 63))
                         x
                         ,(- (expt 2 63) 1))))
              (lambda (x)                            ; u64
                (declare (generic))
                (and (exact-integer? x)
                     (<= 0
                         x
                         ,(- (expt 2 64) 1))))
              (lambda (x) (flonum? x))               ; f32
              (lambda (x) (flonum? x))               ; f64
              (lambda (x) (char? x))                 ; char
              ))))

(make-standard-storage-classes)

;;; for bit-arrays, body is a vector, the first element of which is the actual number of elements,
;;; the second element of which is a u16vector that contains the bit string

(define u1-storage-class
  (make-storage-class
   ;; getter
   (lambda (v i)
     (let ((index (fxarithmetic-shift-right i 4))
           (shift (fxand i 15))
           (bodyv (vector-ref v  1)))
       (fxand
        (fxarithmetic-shift-right
         (u16vector-ref bodyv index)
         shift)
        1)))
   ;; setter
   (lambda (v i val)
     (let ((index (fxarithmetic-shift-right i 4))
           (shift (fxand i 15))
           (bodyv (vector-ref v  1)))
       (u16vector-set! bodyv index (fxior (fxarithmetic-shift-left val shift)
                                          (fxand (u16vector-ref bodyv index)
                                                 (fxnot  (fxarithmetic-shift-left 1 shift)))))
       (void)))
   ;; checker
   (lambda (val)
     (and (fixnum? val)
          (eq? 0 (fxand -2 val))))
   ;; maker
   (lambda (size initializer)
     (let ((u16-size (fxarithmetic-shift-right (+ size 15) 4)))
       (vector size (make-u16vector u16-size (if (eqv? 0 initializer) 0 65535)))))
   ;; no copier (for now)
   #f
   ;; length
   (lambda (v)
     (vector-ref v 0))
   ;; default
   0
   ;; data?
   (lambda (data)
     (u16vector? data))
   ;; data->body
   (lambda (data)
     (if (not (u16vector? data))
         (error "Expecting a u16vector passed to (storage-class-data->body u1-storage-class): " data)
         (vector (fx* 16 (u16vector-length data))
                 data)))))

(define-macro (make-complex-storage-classes)
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
              (,(symbol-concatenate floating-point-prefix 'vector-set!) body (fx+ (fx* 2 i) 1) (imag-part obj))
              (void))
            ;; checker
            (lambda (obj)
              (and (complex? obj)
                   (inexact? (real-part obj))
                   (inexact? (imag-part obj))))
            ;; maker
            (lambda (n val)
              (let ((l (fx* 2 n))
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
            0.+0.i
            ;; data?
            (lambda (data)
              (and (,(symbol-concatenate floating-point-prefix 'vector?) data)
                   (fxeven? (,(symbol-concatenate floating-point-prefix 'vector-length) data))))
            ;; data->body
            (lambda (data)
              (if (and (,(symbol-concatenate floating-point-prefix 'vector?) data)
                       (fxeven? (,(symbol-concatenate floating-point-prefix 'vector-length) data)))
                  data
                  (error ,(symbol->string
                           (symbol-concatenate
                            "Expecting a "
                            floating-point-prefix 'vector
                            " with an even number of elements passed to "
                            "(storage-class-data->body "
                            prefix '-storage-class
                            "): "))
                         data))))))))
  (let ((result
         `(begin
            ,@(map construct
                   '(32 64)))))
    result))

(make-complex-storage-classes)

;;; And now we define a small float storage class:

;;; Since there is no native f16 in most schemes, we represent an f16 object
;;; with an integer between 0 (inclusive) and 65536 (exclusive), with the
;;; body of f16-storage-class represented by a u16vector.  We assume that
;;; integers in this range are fixnums.

;;; It takes noticeable computations and boxing a double to extract the
;;; object represented by an element of an f16-storage-class array, and
;;; even more computations to take a double object and convert it to the
;;; representation of its f16 rounded value.  So I may add "hidden" entries
;;; to f16-storage-class to extract and insert the representation of an
;;; f16 value directly, instead of converting to a double and back.

(define-macro (macro-make-representation->double name mantissa-width exponent-width exponent-bias)

  (define (append-symbols . args)
    (string->symbol
     (apply string-append (map (lambda (arg)
                                 (cond ((symbol? arg) (symbol->string arg))
                                       ((number? arg) (number->string arg))
                                       ((string? arg) arg)
                                       (else
                                        (apply error "append-symbols: unknown argument: " arg))))
                               args))))

  (let* ((exponent-mask (- (fxarithmetic-shift-left 1 exponent-width) 1))
         (mantissa-mask (- (fxarithmetic-shift-left 1 mantissa-width) 1))
         (2^mantissa-width (fxarithmetic-shift-left 1 mantissa-width))
         (result
          `(define (,(append-symbols name '->double) x)
             (let ((e (fxand ,exponent-mask (fxarithmetic-shift-right x ,mantissa-width)))
                   (m (fxand ,mantissa-mask x))
                   (s (fxarithmetic-shift-right x ,(+ mantissa-width exponent-width))))
               (cond ((fx= e ,exponent-mask)
                      (if (fxzero? m)
                          (if (fxzero? s) +inf.0 -inf.0)
                          +nan.0))
                     ((fx> e 0)
                      (let* ((abs-numerator (fx+ ,2^mantissa-width m))
                             (numerator (if (fxzero? s) abs-numerator (fx- abs-numerator))))
                        (flscalbn (fl* (fixnum->flonum numerator) ,(fl/ (fixnum->flonum 2^mantissa-width))) (fx- e ,exponent-bias))))
                     ((fxzero? m)
                      (if (fxzero? s) +0. -0.))
                     (else
                      (let* ((abs-numerator m)
                             (numerator (if (fxzero? s) abs-numerator (fx- abs-numerator))))
                        (flscalbn (fl* (fixnum->flonum numerator) ,(fl/ (fixnum->flonum 2^mantissa-width))) ,(fx- 1 exponent-bias)))))))))
    ;; (pp result)
    result))

(define-macro (macro-make-double->representation name mantissa-width exponent-width exponent-bias)

  (define (append-symbols . args)
    (string->symbol
     (apply string-append (map (lambda (arg)
                                 (cond ((symbol? arg) (symbol->string arg))
                                       ((number? arg) (number->string arg))
                                       ((string? arg) arg)
                                       (else
                                        (apply error "append-symbols: unknown argument: " arg))))
                               args))))

  (let* ((exponent-mask (- (fxarithmetic-shift-left 1 exponent-width) 1))
         (mantissa-mask (- (fxarithmetic-shift-left 1 mantissa-width) 1))
         (2^mantissa-width (fxarithmetic-shift-left 1 mantissa-width))
         (result
          `(define (,(append-symbols 'double-> name) x)

             (declare (inline))

             (define (construct-representation sign-bit biased-exponent mantissa)
               (fxior (fxarithmetic-shift-left sign-bit ,(+ exponent-width mantissa-width))
                      (fxior (fxarithmetic-shift-left biased-exponent ,mantissa-width)
                             mantissa)))

             (let ((sign-bit
                    (if (flnegative? (##flcopysign 1. x)) 1 0)))
               (cond ((not (flfinite? x))
                      (if (flnan? x)
                          (construct-representation sign-bit ,exponent-mask ,mantissa-mask)
                          ;; an infinity
                          (construct-representation sign-bit ,exponent-mask 0)))
                     ((flzero? x)
                      ;; a zero
                      (construct-representation sign-bit 0 0))
                     (else
                      ;; finite
                      (let ((exponent (flilogb x)))
                        (cond ((fx<=  ,(- exponent-mask exponent-bias) exponent)
                               ;; infinity, because the exponent is too large
                               (construct-representation sign-bit ,exponent-mask 0))
                              ((fx< ,(fx- exponent-bias) exponent)
                               ;; probably normal, finite in representation, unless overflow
                               (let ((possible-mantissa
                                      (##flonum->fixnum (flround (flscalbn (flabs x) (fx- ,mantissa-width exponent))))))
                                 (if (fx< possible-mantissa ,(fx* 2 2^mantissa-width))
                                     ;; no overflow
                                     (construct-representation sign-bit
                                                               (fx+ exponent ,exponent-bias)
                                                               (fxand possible-mantissa ,mantissa-mask))
                                     ;; overflow
                                     (if (fx= exponent ,exponent-bias)
                                         ;; maximum finite exponent, overflow to infinity
                                         (construct-representation sign-bit ,exponent-mask 0)
                                         ;; increase exponent by 1, mantissa is zero, no double rounding
                                         (construct-representation sign-bit (fx+ exponent ,(fx+ exponent-bias 1)) 0)))))
                              (else
                               ;; usally subnormal
                               (let ((possible-mantissa
                                      (##flonum->fixnum (flround (flscalbn (flabs x) ,(fx+ exponent-bias mantissa-width -1))))))
                                 (if (fx< possible-mantissa ,2^mantissa-width)
                                     ;; doesn't overflow to normal
                                     (construct-representation sign-bit 0 possible-mantissa)
                                     ;; overflow to smallest normal
                                     (construct-representation sign-bit 1 0))))))))))))
    ;; (pp result)
    result))

(define f16-storage-class
  (let ()

    (macro-make-representation->double f16 10 5 15)
    (macro-make-double->representation f16 10 5 15)

    (make-storage-class
     ;; getter
     (lambda (body i)
       (f16->double (u16vector-ref body i)))
     ;; setter
     (lambda (body i obj)
       (u16vector-set! body i (double->f16 obj)) (void))
     ;; checker
     (lambda (obj)
       (flonum? obj))
     ;; maker
     (lambda (n val)
       (make-u16vector n (double->f16 val)))
     ;; copier
     u16vector-copy!
     ;; length
     (lambda (body)
       (u16vector-length body))
     ;; default
     0.
     ;; data?
     (lambda (data)
       (u16vector? data))
     ;; data->body
     (lambda (data)
       (if (u16vector? data)
           data
           (error "Expecting a u16vector passed to (storage-class-data->body f16-storage-class): " data))))))

#|

;;; The test code for the conversion routines:

(define (test)

  (declare (inlining-limit 0))

  (define (compose-f16 sign exponent mantissa)
    (bitwise-ior (arithmetic-shift sign 15)
                 (arithmetic-shift exponent 10)
                 mantissa))

  (define-macro (check i expr)
    `(if (not (= ,i ,expr))
         (begin
           (pp (list ,i , expr ',expr))
           (error "crap"))))

  ;; The general strategy is: for the representation of each finite f16 number,
  ;; 1.  Compute the double (x) associated with that representation, the one before (previous-x)
  ;;     and the one after (next-x).
  ;; 2.  Choose a random double strictly between the halfway point between x and each of next-x
  ;;     and previous-x, and see that it rounds to the f16 representation of x.  (It's strict
  ;;     for f16, double, and the reference implementation of SRFI 27.)
  ;; 3.  If the representation is even, check that the double exactly between s and next-x, and
  ;;     x and previous x rounds to x.  (Round to even rule.)
  ;; Some care must be taken for the representation of the largest normal f16 number and the representation of 0.

  (do ((i 1 (fx+ i 1)))                  ;; representation of smallest positive number
      ((fx= i (compose-f16 0 30 1023)))  ;; representation of largest finite number
    (let* ((x (f16->double i))
           (next-x (f16->double (+ i 1)))
           (previous-x (f16->double (- i 1))))
      (check i (double->f16 (+ x (* 0.5 (random-real) (- next-x x)))))
      (check i (double->f16 (+ x (* 0.5 (random-real) (- previous-x x)))))
      (if (even? i)
          (begin
            (check i (double->f16 (+ x (* 0.5 (- next-x x)))))
            (check i (double->f16 (+ x (* 0.5 (- previous-x x)))))))))
  ;; i = 0
  (let* ((i 0)
         (x (f16->double i))
         (next-x (f16->double (+ i 1)))) ;; no previous-x
    (check i (double->f16 (+ x (* 0.5 (random-real) (- next-x x)))))
    (check i (double->f16 (+ x (* 0.5 (- next-x x))))))
  ;; largest normal
  (let* ((i (compose-f16 0 30 1023))
         (x (f16->double i))
         (previous-x (f16->double (- i 1)))) ;; no next-x
    (check i (double->f16 (+ x (* 0.5 (random-real) (- previous-x x)))))
    (check i (double->f16 (+ x (* 0.5 (random-real) (- x previous-x))))) ;; if next-x were finite, this would be the same
    (check (+ i 1) (double->f16 (+ x (* 0.5 (- x previous-x))))))        ;; check that 1/2 the difference rounds up to +inf.0
  )

|#

;;; This sample implementation does not implement the following.

(define f8-storage-class #f)

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

;; unfortunately, the next three functions were written by hand, so beware of bugs.

(define (%%indexer-0 base)
  (if (eqv? base 0)
      (lambda () 0)       ;; Don't generate closure for common case.
      (lambda () base)))

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
         (if (%%every (lambda (x) (eqv? x 0)) lower-bounds)
             (lambda multi-index
               (let loop ((result base)
                          (indices multi-index)
                          (increments increments))
                 (if (null? indices)
                     (if (null? increments)
                         result
                         (apply error "Wrong number of arguments passed to procedure " multi-index))
                     (if (null? increments)
                         (apply error "Wrong number of arguments passed to procedure " multi-index)
                         (loop (+ result (* (car increments) (car indices)))
                               (cdr indices)
                               (cdr increments))))))
             (lambda multi-index
               (let loop ((result base)
                          (indices multi-index)
                          (lower-bounds lower-bounds)
                          (increments increments))
                 (if (null? indices)
                     (if (null? increments)
                         result
                         (apply error "Wrong number of arguments passed to procedure " multi-index))
                     (if (null? increments)
                         (apply error "Wrong number of arguments passed to procedure " multi-index)
                         (loop (+ result (* (car increments)
                                            (- (car indices)
                                               (car lower-bounds))))
                               (cdr indices)
                               (cdr lower-bounds)
                               (cdr increments)))))))))
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

(declare (inline))

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

(define (%%array-empty? array)
  (%%interval-empty? (%%array-domain array)))

(define (array-empty? obj)
  (cond ((not (array? obj))
         (error "array-empty?: The argument is not an array: " obj))
        (else
         (%%array-empty? obj))))

(declare (not inline))

(define (%%compute-array-packed? domain indexer)
  (or (%%interval-empty? domain)
      (case (%%interval-dimension domain)
        ((0) #t)
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
        ;; The next part is not call/cc safe, but the only function we call is indexer,
        ;; and we calculate all specialized array indexers internally, and they don't call call/cc.
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
                 #t))))))

(define (%%array-packed? array)
  (let ((in-order? (%%array-in-order? array)))
    (if (boolean? in-order?)
        in-order?
        (let ((in-order?
               (%%compute-array-packed?
                (%%array-domain array)
                (%%array-indexer array))))
          (%%array-in-order?-set! array in-order?)
          in-order?))))

(define (array-packed? array)
  (cond ((not (specialized-array? array))
         (error "array-packed?: The argument is not a specialized array: " array))
        (else
         (%%array-packed? array))))


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
                                  (symbol-append prefix         replacement-suffix)
                                  expr)))
                    '(generic s8       u8       s16       u16       s32       u32       s64       u64       f32       f64       char)
                    '(vector  s8vector u8vector s16vector u16vector s32vector u32vector s64vector u64vector f32vector f64vector string))
             (else
              ;; There are conversion routines required for getters and setters of other standard storage classes.
              ,expr)))

    (define-macro (expand-getters expr)
      `(expand-storage-class -getter -ref ,expr))

    (define-macro (expand-setters expr)
      `(expand-storage-class -setter -set! ,expr))

    (let ((getter
           (cond ((%%interval-empty? domain)
                  (%%empty-getter domain))
                 (safe?
                  (case (%%interval-dimension domain)
                    ((0)  (lambda ()
                            (storage-class-getter body (indexer))))
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
                                   (storage-class-getter body (apply indexer multi-index))))))))
                 (else
                  (case (%%interval-dimension domain)
                    ((0)  (expand-getters (lambda ()          (storage-class-getter body (indexer)))))
                    ((1)  (expand-getters (lambda (i)         (storage-class-getter body (indexer i)))))
                    ((2)  (expand-getters (lambda (i j)       (storage-class-getter body (indexer i j)))))
                    ((3)  (expand-getters (lambda (i j k)     (storage-class-getter body (indexer i j k)))))
                    ((4)  (expand-getters (lambda (i j k l)   (storage-class-getter body (indexer i j k l)))))
                    (else (expand-getters (lambda multi-index (storage-class-getter body (apply indexer multi-index)))))))))
          (setter
           (and mutable?
                (cond ((%%interval-empty? domain)
                       (%%empty-setter domain))
                      (safe?
                       (case (%%interval-dimension domain)
                         ((0)  (lambda (value)
                                 (cond ((not (checker value))
                                        (error "array-setter: value cannot be stored in body: " value))
                                       (else
                                        (storage-class-setter body (indexer) value)))))
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
                                        (storage-class-setter body (apply indexer multi-index) value)))))))
                      (else
                       (case (%%interval-dimension domain)
                         ((0)  (expand-setters (lambda (value)               (storage-class-setter body (indexer)                   value) (void))))
                         ((1)  (expand-setters (lambda (value i)             (storage-class-setter body (indexer i)                 value) (void))))
                         ((2)  (expand-setters (lambda (value i j)           (storage-class-setter body (indexer i j)               value) (void))))
                         ((3)  (expand-setters (lambda (value i j k)         (storage-class-setter body (indexer i j k)             value) (void))))
                         ((4)  (expand-setters (lambda (value i j k l)       (storage-class-setter body (indexer i j k l)           value) (void))))
                         (else (expand-setters (lambda (value . multi-index) (storage-class-setter body (apply indexer multi-index) value) (void))))))))))
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
    ((0) (%%indexer-0 0))
    ((1) (let ((low-0 (%%interval-lower-bound interval 0))
               (increment-0 1))
           (%%indexer-1 0 low-0 increment-0)))
    ((2) (let* ((low-0 (%%interval-lower-bound interval 0))
                (low-1 (%%interval-lower-bound interval 1))
                (increment-1 1)
                (increment-0 (* increment-1 (%%interval-width interval 1))))
           (%%indexer-2 0
                        low-0 low-1
                        increment-0 increment-1)))
    ((3) (let* ((low-0 (%%interval-lower-bound interval 0))
                (low-1 (%%interval-lower-bound interval 1))
                (low-2 (%%interval-lower-bound interval 2))
                (increment-2 1)
                (increment-1 (* increment-2 (%%interval-width interval 2)))
                (increment-0 (* increment-1 (%%interval-width interval 1))))
           (%%indexer-3 0
                        low-0 low-1 low-2
                        increment-0 increment-1 increment-2)))
    ((4) (let* ((low-0 (%%interval-lower-bound interval 0))
                (low-1 (%%interval-lower-bound interval 1))
                (low-2 (%%interval-lower-bound interval 2))
                (low-3 (%%interval-lower-bound interval 3))
                (increment-3 1)
                (increment-2 (* increment-3 (%%interval-width interval 3)))
                (increment-1 (* increment-2 (%%interval-width interval 2)))
                (increment-0 (* increment-1 (%%interval-width interval 1))))
           (%%indexer-4 0
                        low-0 low-1 low-2 low-3
                        increment-0 increment-1 increment-2 increment-3)))
    (else
     (do ((widths
           (reverse (vector->list (%%interval-widths interval)))
           (cdr widths))
          (increments
           (list 1)
           (cons (* (car increments) (car widths))
                 increments)))
         ((null? (cdr widths))
          (%%indexer-generic 0 (%%interval-lower-bounds->list interval) increments))))))

(define (%%make-specialized-array interval
                                  storage-class
                                  initial-value
                                  ;; must be mutable
                                  safe?)
  (let* ((body    ((storage-class-maker storage-class)
                   (%%interval-volume interval)
                   initial-value))
         (indexer (%%interval->basic-indexer interval)))
    (%%finish-specialized-array interval
                                storage-class
                                body
                                indexer
                                #t            ;; mutable?
                                safe?
                                #t)))         ;; new arrays are always in order

(define (make-specialized-array-from-data data
                                          #!optional
                                          (storage-class generic-storage-class)
                                          (mutable?      (specialized-array-default-mutable?))
                                          (safe?         (specialized-array-default-safe?)))
  (cond ((not (boolean? safe?))
         (error "make-specialized-array-from-data: The fourth argument is not a boolean: " data storage-class mutable? safe?))
        ((not (boolean? mutable?))
         (error "make-specialized-array-from-data: The third argument is not a boolean: " data storage-class mutable?))
        ((not (storage-class? storage-class))
         (error "make-specialized-array-from-data: The second argument is not a storage class: " data storage-class))
        ((not ((storage-class-data? storage-class) data))
         (error "make-specialized-array-from-data: The first argument is not compatible with the storage class: " data))
        ((and mutable?
              (not (##mutable? data)))
         (error "make-specialized-array-from-data: Cannot make mutable array from immutable data: " data storage-class mutable? safe?))
        (else
         (%%make-specialized-array-from-data data storage-class mutable? safe?))))


(define (%%make-specialized-array-from-data data storage-class mutable? safe?)
  (let* ((body
          ((storage-class-data->body storage-class) data))
         (indexer
          (lambda (i) i))
         (domain
          (make-interval (vector ((storage-class-length storage-class) body)))))
    (%%finish-specialized-array domain
                                storage-class
                                body
                                indexer
                                mutable?
                                safe?
                                #t)))         ;; this array is in order by definition

(define (%%list*->array dimension nested-list storage-class mutable? safe? caller)

  (define (check-nested-list dimension nested-data)
    (or (eqv? dimension 0)  ;; anything goes in dimension 0
        (and (list? nested-data)
             (let ((len (length nested-data)))
               (cond ((eqv? len 0)
                      '())
                     ((eqv? dimension 1)
                      (list len))
                     (else
                      (let* ((sublists
                              (map (lambda (l)
                                     (check-nested-list (fx- dimension 1) l))
                                   nested-data))
                             (first
                              (car sublists)))
                        (and first
                             (%%every (lambda (l)
                                        (equal? first l))
                                      (cdr sublists))
                             (cons len first)))))))))

  (define (nested-list->array dimension nested-data)
    (case dimension
      ((0)
       (%!array-copy (make-array (make-interval '#()) (lambda () nested-data))
                     storage-class
                     mutable?
                     safe?
                     caller
                     #f))
      ((1)
       (%%list->array (make-interval (vector (length nested-data)))
                      nested-data
                      storage-class
                      mutable?
                      safe?
                      caller))
      (else
       (if (null? nested-data)
           (let ((result (%%make-specialized-array (make-interval (make-vector dimension 0))
                                                   storage-class
                                                   (storage-class-default storage-class) ;; never used
                                                   safe?)))
             (if (not mutable?)
                 (%%array-freeze! result)
                 result))
           (%%%array-stack 0             ;; the new dimension is always the first
                           (map (lambda (l)
                                  (nested-list->array (fx- dimension 1) l))
                                nested-data)
                           storage-class
                           mutable?
                           safe?
                           caller
                           #f)))))   ;; already call/cc-safe

  (if (check-nested-list dimension nested-list)
      (nested-list->array dimension nested-list)
      (error (string-append caller
                            "The second argument is not the right shape to be converted to an array of the given dimension: ")
             dimension nested-list)))

(define (list*->array dimension
                      nested-data
                      #!optional
                      (storage-class generic-storage-class)
                      (mutable?      (specialized-array-default-mutable?))
                      (safe?         (specialized-array-default-safe?)))
  (cond ((not (boolean? safe?))
         (error "list*->array: The fifth argument is not a boolean: " dimension nested-data storage-class mutable? safe?))
        ((not (boolean? mutable?))
         (error "list*->array: The fourth argument is not a boolean: " dimension nested-data storage-class mutable?))
        ((not (storage-class? storage-class))
         (error "list*->array: The third argument is not a storage class: " dimension nested-data storage-class))
        ((not (and (fixnum? dimension)
                   (fx<= 0 dimension)))
         (error "list*->array: The first argument is not a nonnegative fixnum: " dimension nested-data))
        (else
         (%%list*->array dimension nested-data storage-class mutable? safe? "list*->array: "))))

(define (%%vector*->array dimension nested-vector storage-class mutable? safe? caller)

  (define (check-nested-vector dimension nested-data)
    (or (eqv? dimension 0)  ;; anything goes in dimension 0
        (and (vector? nested-data)
             (let ((len (vector-length nested-data)))
               (cond ((eqv? len 0)
                      '())
                     ((eqv? dimension 1)
                      (list len))
                     (else
                      (let* ((sublists
                              (vector-map (lambda (l)
                                            (check-nested-vector (fx- dimension 1) l))
                                          nested-data))
                             (first
                              (vector-ref sublists 0)))
                        (and first
                             (%%vector-every (lambda (l)
                                               (equal? first l))
                                             sublists)
                             (cons len first)))))))))

  (define (nested-vector->array dimension nested-data)
    (case dimension
      ((0)
       (%!array-copy (make-array (make-interval '#()) (lambda () nested-data))
                     storage-class
                     mutable?
                     safe?
                     caller
                     #f))
      ((1)
       (let ((generic-array
              (%%make-specialized-array-from-data nested-data generic-storage-class mutable? safe?))) ;; data is always a generic-vector
         (%!array-copy generic-array
                       storage-class
                       mutable?
                       safe?
                       caller
                       #f)))
      (else
       (if (eqv? (vector-length nested-data) 0)
           (let ((result (make-specialized-array (make-interval (make-vector dimension 0))
                                                 storage-class
                                                 (storage-class-default storage-class) ;; never used
                                                 safe?)))
             (if (not mutable?)
                 (%%array-freeze! result)
                 result))
           (%%%array-stack 0             ;; the new dimension is always the first
                           (map (lambda (l)
                                  (nested-vector->array (fx- dimension 1) l))
                                (vector->list nested-data))
                           storage-class
                           mutable?
                           safe?
                           caller
                           #f)))))   ;; already call/cc-safe

  (if (check-nested-vector dimension nested-vector)
      (nested-vector->array dimension nested-vector)
      (error (string-append caller "The second argument is not the right shape to be converted to an array of the given dimension: ") dimension nested-vector)))

(define (vector*->array dimension
                        nested-data
                        #!optional
                        (storage-class generic-storage-class)
                        (mutable?      (specialized-array-default-mutable?))
                        (safe?         (specialized-array-default-safe?)))
  (cond ((not (boolean? safe?))
         (error "vector*->array: The fifth argument is not a boolean: " dimension nested-data storage-class mutable? safe?))
        ((not (boolean? mutable?))
         (error "vector*->array: The fourth argument is not a boolean: " dimension nested-data storage-class mutable?))
        ((not (storage-class? storage-class))
         (error "vector*->array: The third argument is not a storage class: " dimension nested-data storage-class))
        ((not (and (fixnum? dimension)
                   (fx<= 0 dimension)))
         (error "vector*->array: The first argument is not a nonnegative fixnum: " dimension nested-data))
        (else
         (%%vector*->array dimension nested-data storage-class mutable? safe? "vector*->array: "))))

(define make-specialized-array
  (let ()
    (define (one-arg interval storage-class initial-value safe?)
      (cond ((not (interval? interval))
             (error "make-specialized-array: The first argument is not an interval: "
                    interval))
            (else
             (%%make-specialized-array interval
                                       storage-class
                                       initial-value
                                       safe?))))
    (define (two-args interval storage-class initial-value safe?)
      (cond ((not (storage-class? storage-class))
             (error "make-specialized-array: The second argument is not a storage-class: "
                    interval storage-class))
            (else
             (one-arg interval
                      storage-class
                      (storage-class-default storage-class)
                      safe?))))
    (define (three-args interval storage-class initial-value safe?)
      (cond ((not (storage-class? storage-class))
             (error "make-specialized-array: The second argument is not a storage-class: "
                    interval storage-class initial-value))
            ((not ((storage-class-checker storage-class) initial-value))
             (error "make-specialized-array: The third argument cannot be manipulated by the second (a storage class): "
                    interval storage-class initial-value))
            (else
             (one-arg interval           ;; calls one-arg directly, not two-args
                      storage-class
                      initial-value
                      safe?))))
    (define (four-args interval storage-class initial-value safe?)
      (cond ((not (boolean? safe?))
             (error "make-specialized-array: The fourth argument is not a boolean: "
                    interval storage-class initial-value safe?))
            (else
             (three-args interval
                         storage-class
                         initial-value
                         safe?))))
    (case-lambda
     ((interval)
      (one-arg interval
               generic-storage-class
               (storage-class-default generic-storage-class)
               (specialized-array-default-safe?)))
     ((interval storage-class)
      (two-args interval
                storage-class
                'ignore
                (specialized-array-default-safe?)))
     ((interval storage-class initial-value)
      (three-args interval
                  storage-class
                  initial-value
                  (specialized-array-default-safe?)))
     ((interval storage-class initial-value safe?)
      (four-args interval
                 storage-class
                 initial-value
                 safe?)))))

(define %%storage-class-compatibility-alist

  ;; An a-list of compatible storage-classes;
  ;; in each list, members of the first storage class can be
  ;; stored without error in all storage classes in the list.

  ;; We're going to test separately for generic-storage-class,
  ;; so we can deal gracefully with storing data from
  ;; a user-defined storage-class to generic-storage-class
  ;; without running the checker for generic-storage-class
  ;; (which always returns #t)
  (list
   (list u1-storage-class
         u8-storage-class
         u16-storage-class
         u32-storage-class
         u64-storage-class
         s8-storage-class
         s16-storage-class
         s32-storage-class
         s64-storage-class)
   (list u8-storage-class
         u16-storage-class
         u32-storage-class
         u64-storage-class
         s16-storage-class
         s32-storage-class
         s64-storage-class)
   (list u16-storage-class
         u32-storage-class
         u64-storage-class
         s32-storage-class
         s64-storage-class)
   (list u32-storage-class
         u64-storage-class
         s64-storage-class)
   (list u64-storage-class)
   (list s8-storage-class
         s16-storage-class
         s32-storage-class
         s64-storage-class)
   (list s16-storage-class
         s32-storage-class
         s64-storage-class)
   (list s32-storage-class
         s64-storage-class)
   (list s64-storage-class)
   (list f16-storage-class
         f32-storage-class
         f64-storage-class)
   (list f32-storage-class    ;; the checkers for these classes are the same, no point in checking
         f64-storage-class    ;; going from f32-storage-class to f16-storage-class
         f16-storage-class)
   (list f64-storage-class    ;; the checkers for these classes are the same, no point in checking
         f32-storage-class    ;; going from f64-storage-class to f32-storage-class or f16-storage-class
         f16-storage-class)
   (list char-storage-class)
   (list c64-storage-class
         c128-storage-class)
   (list c128-storage-class   ;; the checker for these classes are the same, no point in checking
         c64-storage-class))) ;; going from c128-storage-class to c64-storage-class

;;; We consolidate all moving of array elements to the following procedure.

#;(define %%test-moves '())    ;; TODO: REMOVE AFTER TESTING

(define (%%move-array-elements destination source caller)

  ;; Here's the logic:
  ;; We require the source and destination to have the same number of elements.
  ;; If destination is a specialized array
  ;; then
  ;;   If its elements are in order
  ;;      and the source is a specialized array
  ;;   then
  ;;      If the source has the same storage class
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
  ;;     If no checks are needed
  ;;     then
  ;;        Copy elements from the source to destination, without checks.
  ;;     else
  ;;        Copy elements from the source to destination, checking whether
  ;;        they're OK
  ;; else
  ;;    Copy elements of source to destination

  ;; We check the whether the elements of the destination are in order to save
  ;; a bit of array indexing (or perhaps to a block copy, which is even better).

  ;; We check that the elements we move to the destination are OK for the
  ;; destination because if we don't catch errors here they can be very tricky to find.

  ;; We'll put this here temporarily because we know these
  ;; algorithms are not call/cc safe.  We'll decide later
  ;; whether there are some circumstances when we want to
  ;; use these on generalized arrays.

  ;; TODO
  ;; REMOVE BEFORE RELEASE

  #;(if (not (or (specialized-array? source)
               (member caller %%test-moves)))
      (set! %%test-moves (cons caller %%test-moves)))

  (cond ((not (%%interval= (%%array-domain source)
                           (%%array-domain destination)))
         (error (string-append
                 caller
                 "Arrays must have the same domains: ")
                destination source))
        ((%%interval-empty? (%%array-domain source))
         "Empty arrays")
        ((specialized-array? destination)
         (if (and (%%array-packed? destination)
                  (specialized-array? source))
             ;; Maybe we can do a block copy
             (if (and (eq? (%%array-storage-class destination)
                           (%%array-storage-class source))
                      ;; does a copier for this storage-class exist?
                      (storage-class-copier (%%array-storage-class destination))
                      (%%array-packed? source))
                 ;; do a block copy
                 (begin
                   (if (not (%%interval-empty? (%%array-domain source)))
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
                                 source-end)))
                   "Block copy")
                 ;; We can step through the elements of destination in order,
                 ;; and the getter of the source doesn't capture any continuations.
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
                               ((0)  (let ((index initial-offset))
                                       (lambda ()
                                         (vector-set! body index (getter))
                                         (set! index (fx+ index 1)))))    ;; not necessary
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
                         ((or (eq? (%%array-storage-class source)
                                   destination-storage-class)
                              (let ((compatibility-list
                                     (assq (%%array-storage-class source)
                                           %%storage-class-compatibility-alist)))
                                (and compatibility-list
                                     (memq destination-storage-class
                                           compatibility-list))))
                          ;; No checks needed
                          (let ((setter (storage-class-setter destination-storage-class))
                                (body (%%array-body destination)))
                            (%%interval-for-each
                             (case (%%interval-dimension domain)
                               ((0)  (let ((index initial-offset))
                                       (lambda ()
                                         (setter body index (getter))
                                         (set! index (fx+ index 1))))) ;; not necessary
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
                               ((0)
                                (let ((index initial-offset))
                                  (lambda ()
                                    (let ((item (getter)))
                                      (if (checker item)
                                          (begin
                                            (setter body index item)
                                            (set! index (fx+ index 1)))  ;; not necessary
                                          (error
                                           (string-append
                                            caller
                                            "Not all elements of the source can be stored in destination: ")
                                           destination source item))))))
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
                                          (apply
                                           error
                                           (string-append
                                            caller
                                            "Not all elements of the source can be stored in destination: ")
                                           destination source (append multi-index (list item)))))))))
                             domain))
                          "In order, checks needed"))))
             ;; Either the elements of destination are not in order, or source is not a specialized array.
             (let* ((setter
                     (%%array-setter destination))
                    (getter
                     (%%array-getter source))
                    (destination-storage-class
                     (%%array-storage-class destination))
                    (checker
                     (storage-class-checker destination-storage-class))
                    (domain
                     (%%array-domain destination)))
               (cond ((or (eq? destination-storage-class generic-storage-class)
                          (and (specialized-array? source)
                               (or (eq? (%%array-storage-class source) destination-storage-class)
                                   (let ((compatibility-list
                                          (assq (%%array-storage-class source)
                                                %%storage-class-compatibility-alist)))
                                     (and compatibility-list
                                          (memq destination-storage-class
                                                compatibility-list))))))
                      ;; no checks needed
                      (%%interval-for-each
                       (case (%%interval-dimension domain)
                         ((0) (lambda ()
                                (setter (getter))))
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
                      "No checks needed")
                     (else
                      ;; checks needed
                      (%%interval-for-each
                       (case (%%interval-dimension domain)
                         ((0)
                          (lambda ()
                            (let ((item (getter)))
                              (if (checker item)
                                  (setter item)
                                  (error
                                   (string-append
                                    caller
                                    "Not all elements of the source can be stored in destination: ")
                                   destination source item)))))
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
                                  (apply
                                   error
                                   (string-append
                                    caller
                                    "Not all elements of the source can be stored in destination: ")
                                   destination source (append multi-index (list item))))))))
                       domain)
                      "Checks needed")))))
        (else
         ;; destination is not a specialized array, so checks,
         ;; if any, are built into the setter.
         (let ((setter
                (%%array-setter destination))
               (getter
                (%%array-getter source))
               (domain
                (%%array-domain destination)))
           (%%interval-for-each
            (case (%%interval-dimension domain)
              ((0) (lambda ()
                     (setter (getter))))
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
           "Destination not specialized array")))
  ;; %%move-array-elements returns a string that designates
  ;; the copying method it used.
  ;; Calling functions should return something useful.
  )

;;;
;;; The domain of the result is the same as the domain of the argument.
;;;
;;; Builds a new specialized-array and populates the body of the result with
;;; (array-getter array) applied to the elements of (array-domain array)

(define (%%generalized-array->specialized-array array storage-class mutable? safe? caller)
  (let* ((domain            (%%array-domain array))
         (reversed-elements (%%array->reversed-list array))
         (n                 (%%interval-volume domain))
         (body              ((storage-class-maker storage-class) n (storage-class-default storage-class)))
         (indexer           (%%interval->basic-indexer domain))
         (setter            (storage-class-setter storage-class))
         (checker           (storage-class-checker storage-class)))
    (if (eq? storage-class generic-storage-class)
        (let loop ((i (fx- n 1))
                   (l reversed-elements))
          (if (fx<= 0 i)
              (begin
                (vector-set! body i (car l))
                (loop (fx- i 1)
                      (cdr l)))
              (%%finish-specialized-array domain
                                          storage-class
                                          body
                                          indexer
                                          mutable?
                                          safe?
                                          #t)))
        (let loop ((i (fx- n 1))
                   (l reversed-elements))
          (if (fx<= 0 i)
              (if (checker (car l))
                  (begin
                    (setter body i (car l))
                    (loop (fx- i 1)
                          (cdr l)))
                  (error (string-append caller "Not all elements of the source can be stored in destination: ") array storage-class mutable? safe?))
              (%%finish-specialized-array domain
                                          storage-class
                                          body
                                          indexer
                                          mutable?
                                          safe?
                                          #t))))))

(define (%%->specialized-array array storage-class caller)
  (if (specialized-array? array)
      array
      (%%generalized-array->specialized-array array storage-class #f #f caller)))

(define (%!array-copy array
                      result-storage-class
                      mutable?
                      safe?
                      caller
                      call/cc-safe?)
  (if (or (specialized-array? array)
          (not call/cc-safe?))
      (let ((result (%%make-specialized-array (%%array-domain array)
                                              result-storage-class
                                              (storage-class-default result-storage-class)
                                              safe?)))
        (%%move-array-elements result array caller)
        (if (not mutable?)            ;; set the setter to #f if the final array is not mutable
            (%%array-freeze! result)
            result))
      (%%generalized-array->specialized-array array
                                              result-storage-class
                                              mutable?
                                              safe?
                                              caller)))

(define (%%make-array-copy call/cc-safe?)

  (define caller
    (if call/cc-safe?
        "array-copy: "
        "array-copy!: "))

  (define (wrap error-reason)
    (string-append caller error-reason))

  (define (four-args array result-storage-class mutable? safe?)
    (if (not (boolean? safe?))
        (error (wrap "The fourth argument is not a boolean: ") safe?)
        (three-args array
                    result-storage-class
                    mutable?
                    safe?)))

  (define (three-args array result-storage-class mutable? safe?)
    (if (not (boolean? mutable?))
        (error (wrap "The third argument is not a boolean: ") mutable?)
        (two-args array
                  result-storage-class
                  mutable?
                  safe?)))

  (define (two-args array result-storage-class mutable? safe?)
    (if (not (storage-class? result-storage-class))
        (error (wrap "The second argument is not a storage-class: ") result-storage-class)
        (one-arg array
                 result-storage-class
                 mutable?
                 safe?)))

  (define (one-arg array result-storage-class mutable? safe?)
    (if (not (array? array))
        (error (wrap "The first argument is not an array: ") array)
        (%!array-copy array
                      result-storage-class
                      mutable?
                      safe?
                      caller
                      call/cc-safe?)))

  (case-lambda
   ((array)
    (if (specialized-array? array)
        (one-arg array
                 (%%array-storage-class array)
                 (mutable-array? array)
                 (%%array-safe? array))
        (one-arg array
                 generic-storage-class
                 (specialized-array-default-mutable?)
                 (specialized-array-default-safe?))))
   ((array storage-class)
    (if (specialized-array? array)
        (two-args array
                  storage-class
                  (mutable-array? array)
                  (%%array-safe? array))
        (two-args array
                  storage-class
                  (specialized-array-default-mutable?)
                  (specialized-array-default-safe?))))
   ((array storage-class mutable?)
    (if (specialized-array? array)
        (three-args array
                    storage-class
                    mutable?
                    (%%array-safe? array))
        (three-args array
                    storage-class
                    mutable?
                    (specialized-array-default-safe?))))
   ((array storage-class mutable? safe?)
    (four-args array
               storage-class
               mutable?
               safe?))))

(define array-copy (%%make-array-copy #t))

(define array-copy! (%%make-array-copy #f))

;;;
;;; In the next function, old-indexer is an affine 1-1 mapping from an interval to [0,N), for some N.
;;;
;;; new-domain->old-domain is an affine 1-1 mapping from new-domain to the domain of old-indexer.
;;;

(define (%%compose-indexers old-indexer new-domain new-domain->old-domain)

  (define (compute-multi-indices lowers uppers)
    (if (null? lowers)
        (list lowers)
        (let* ((temp (compute-multi-indices (cdr lowers) (cdr uppers)))
               (lower (car lowers))
               (upper (car uppers))
               (next-index (+ lower 1)))
          ;; returns all lowers first, then list of multi-indices where one
          ;; of the lowers is incremented if possible while staying in the domain.
          (cons (cons lower (car temp))
                (cons (cons (if (< next-index upper)
                                next-index
                                lower)
                            (car temp))
                      (map (lambda (multi-index)
                             (cons lower multi-index))
                           (cdr temp)))))))

  (if (%%interval-empty? new-domain)
      (lambda args
        (error "%%compose-indexers: indexer on empty interval should never be called: "
               old-indexer new-domain new-domain->old-domain))
      (let* ((lowers
              (%%interval-lower-bounds->list new-domain))
             (uppers
              (%%interval-upper-bounds->list new-domain))
             (multi-indices
              (compute-multi-indices lowers uppers))
             (computed-offsets-for-multi-indices
              (map (lambda (multi-index)
                     (call-with-values
                         (lambda ()
                           (apply new-domain->old-domain multi-index))
                       old-indexer))
                   multi-indices))
             (base
              (car computed-offsets-for-multi-indices))
             (increments
              (map (lambda (v)
                     (- v base))
                   (cdr computed-offsets-for-multi-indices))))
        (case (%%interval-dimension new-domain)
          ((0) (%%indexer-0 base))
          ((1) (%%indexer-1 base
                            (car lowers)
                            (car increments)))
          ((2) (%%indexer-2 base
                            (car lowers)     (cadr lowers)
                            (car increments) (cadr increments)))
          ((3) (%%indexer-3 base
                            (car lowers)     (cadr lowers)     (caddr lowers)
                            (car increments) (cadr increments) (caddr increments)))
          ((4) (%%indexer-4 base
                            (car lowers)     (cadr lowers)     (caddr lowers)     (cadddr lowers)
                            (car increments) (cadr increments) (caddr increments) (cadddr increments)))
          (else
           (%%indexer-generic base lowers increments))))))

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
        ((not (<= (%%interval-volume new-domain)
                  (%%interval-volume (%%array-domain array))))
         ;; If new-domain->old-domain is a 1-1 map, then the volume of
         ;; the new-domain must have no more elements than old-domain
         (error "specialized-array-share: The second argument (a domain) has more elements than the domain of the first argument (an array): " array new-domain new-domain->old-domain))
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

  ;; (%%specialized-array-share array new-domain values)

  ;; We can speed this by calling make-%%array directly,
  ;; and so avoid a call to %%compose-indexers with values as
  ;; new-domain->old-domain and avoid the computation of the
  ;; new indexer, getter, and setter.

  (make-%%array new-domain
                (if (%%interval-empty? new-domain)
                    (%%empty-getter new-domain)
                    (%%array-getter array))
                (and (%%array-setter array)   ;; If array has no setter, then don't add one to extracted array
                     (if (%%interval-empty? new-domain)
                         (%%empty-setter new-domain)
                         (%%array-setter array)))
                (%%array-storage-class array)
                (%%array-body array)
                (%%array-indexer array)
                (%%array-safe? array)
                %%order-unknown))

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

(define (array-tile A slice-widths)

  (define (%%vector-fold-left op id v)
    (let ((n (vector-length v)))
      (do ((i 0 (fx+ i 1))
           (id id (op id (vector-ref v i))))
          ((fx= i n) id))))

  (cond ((not (array? A))
         (error "array-tile: The first argument is not an array: " A slice-widths))
        ((not (and (vector? slice-widths)
                   (fx= (vector-length slice-widths)
                        (%%array-dimension A))))
         (error "array-tile: The second argument is not a vector of the same length as the dimension of the array first argument: " A slice-widths))
        (else
         (let* ((A-dim  (%%array-dimension A))
                (domain (%%array-domain A))
                (lowers (%%interval-lower-bounds domain))
                (uppers (%%interval-upper-bounds domain))
                (widths (%%interval-widths domain)))
           (let slice-widths-check ((k 0))
             (if (fx< k A-dim)
                 (let ((S_k (vector-ref slice-widths k)))
                   (if (eqv? (%%interval-width domain k) 0)
                       (if (and (vector? S_k)
                                (not (fx= (vector-length S_k) 0))
                                (%%vector-every (lambda (x) (eqv? x 0)) S_k))
                           (slice-widths-check (fx+ k 1))
                           (error (string-append "array-tile: Axis "
                                                 (number->string k)
                                                 " of the domain of the first argument has width 0, but element "
                                                 (number->string k)
                                                 " of the second argument is not a nonempty vector of exact zeros: ")
                                  A slice-widths))
                       (if (or (and (exact-integer? S_k)
                                    (positive? S_k))
                               (and (vector? S_k)
                                    (%%vector-every (lambda (x) (and (exact-integer? x) (not (negative? x)))) S_k)
                                    (= (%%vector-fold-left (lambda (x y) (+ x y)) 0 S_k) (%%interval-width domain k))))
                           (slice-widths-check (fx+ k 1))
                           (error (string-append "array-tile: Axis "
                                                 (number->string k)
                                                 " of the domain of the first argument has nonzero width, but element "
                                                 (number->string k)
                                                 " of the second argument is neither an exact positive integer nor a vector of nonnegative exact integers summing to that width: ")
                                  A slice-widths))))
                 (let ((offsets (make-vector A-dim)))
                   (do ((k 0 (fx+ k 1)))
                       ((fx= k A-dim))
                     (let ((S_k (vector-ref slice-widths k)))
                       (if (exact-integer? S_k)
                           (let* ((width_k          (vector-ref widths k))
                                  (number-of-slices (quotient (+ width_k (- S_k 1)) S_k))
                                  (slice-offsets    (make-vector (+ number-of-slices 1))))
                             (vector-set! slice-offsets 0 (vector-ref lowers k))
                             (do ((i 0 (fx+ i 1)))
                                 ((fx= i number-of-slices)
                                  (vector-set! slice-offsets
                                               number-of-slices
                                               (min (vector-ref uppers k)
                                                    (vector-ref slice-offsets number-of-slices)))
                                  (vector-set! offsets k slice-offsets))
                               (vector-set! slice-offsets
                                            (fx+ i 1)
                                            (+ (vector-ref slice-offsets i) S_k))))
                           (let* ((number-of-slices (vector-length S_k))
                                  (slice-offsets    (make-vector (+ number-of-slices 1))))
                             (vector-set! slice-offsets 0 (vector-ref lowers k))
                             (do ((i 0 (fx+ i 1)))
                                 ((fx= i number-of-slices)
                                  (vector-set! offsets k slice-offsets))
                               (vector-set! slice-offsets
                                            (fx+ i 1)
                                            (+ (vector-ref slice-offsets i)
                                               (vector-ref S_k i))))))))
                   (let ((result-domain
                          (make-interval (vector-map (lambda (v)
                                                       (- (vector-length v) 1))
                                                     offsets))))

                     (define-macro (generate-result)

                       (define (symbol-append . args)
                         (string->symbol
                          (apply string-append (map (lambda (x)
                                                      (cond ((symbol? x) (symbol->string x))
                                                            ((number? x) (number->string x))
                                                            ((string? x) x)
                                                            (else (error "Arghh!"))))
                                                    args))))

                       `(case A-dim
                          ,@(map (lambda (k)
                                   (let* ((indices (iota k))
                                          (args    (map (lambda (j) (symbol-append 'i_ j)) indices)))
                                     `((,k)
                                       (lambda ,args
                                         (%%array-extract
                                          A
                                          (%%finish-interval (vector ,@(map (lambda (index slice-index)
                                                                              `(vector-ref (vector-ref offsets ,index) ,slice-index))
                                                                            indices args))
                                                             (vector ,@(map (lambda (index slice-index)
                                                                              `(vector-ref (vector-ref offsets ,index) (fx+ ,slice-index 1)))
                                                                            indices args))))))))
                                 '(0 1 2 3 4))
                          (else
                           (lambda i
                             (let* ((i
                                     (list->vector i))
                                    (subdomain
                                     (%%finish-interval (vector-map (lambda (slice-offsets i) (vector-ref slice-offsets i)) offsets i)
                                                        (vector-map (lambda (slice-offsets i) (vector-ref slice-offsets (fx+ i 1))) offsets i))))
                               (%%array-extract A subdomain))))))

                     (%%make-safe-immutable-array result-domain (generate-result) "array-tile: ")))))))))

(define (%%getter-translate getter translation)
  (case (vector-length translation)
    ((0) (lambda ()
           (getter)))
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
                (apply getter (map (lambda (x y) (- x y))  indices translation-list)))))))))

(define (%%setter-translate setter translation)
  (case (vector-length translation)
    ((0) (lambda (v)
           (setter v)))
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
                (apply setter v (map (lambda (x y) (- x y))  indices translation-list)))))))))

(define (%%array-translate array translation)
  (cond ((specialized-array? array)
         (%%specialized-array-share array
                                    (%%interval-translate (%%array-domain array) translation)
                                    (%%getter-translate values translation)
                                    (%%array-in-order? array)))
        ((mutable-array? array)
         (make-array (%%interval-translate (%%array-domain array) translation)
                     (%%getter-translate (%%array-getter array) translation)
                     (%%setter-translate (%%array-setter array) translation)))
        (else
         (make-array (%%interval-translate (%%array-domain array) translation)
                     (%%getter-translate (%%array-getter array) translation)))))

(define (array-translate array translation)
  (cond ((not (array? array))
         (error "array-translate: The first argument is not an array: " array translation))
        ((not (translation? translation))
         (error "array-translate: The second argument is not a vector of exact integers: " array translation))
        ((not (fx= (%%array-dimension array)
                   (vector-length translation)))
         (error "array-translate: The dimension of the first argument (an array) does not equal the dimension of the second argument (a vector): " array translation))
        (else
         (%%array-translate array translation))))

(define-macro (setup-permuted-getters-and-setters)

  (define (list-remove l i)
    ;; new list that removes (list-ref l i) from l
    (if (zero? i)
        (cdr l)
        (cons (car l)
              (list-remove (cdr l) (- i 1)))))

  (define (permutations l)
    ;; generates list of all permutations of l
    (if (or (null? l)
            (null? (cdr l)))
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
                '(0 1 2 3 4))
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

(define-macro (setup-reversed-getters-and-setters)

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
                '(0 1 2 3 4))
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

(define-macro (macro-generate-sample)

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
                '(0 1 2 3 4))
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

(define (%%array-outer-product combiner A B)
  (let* ((D_A            (%%array-domain A))
         (D_B            (%%array-domain B))
         (A_             (%%array-getter A))
         (B_             (%%array-getter B))
         (dim_A          (%%interval-dimension D_A))
         (dim_B          (%%interval-dimension D_B))
         (result-domain  (%%interval-cartesian-product (list D_A D_B)))
         (result-getter
          (case dim_A
            ((0)
             (case dim_B
               ((0)
                (lambda ()
                  (combiner (A_) (B_))))
               ((1)
                (lambda (i2)
                  (combiner (A_) (B_ i2))))
               ((2)
                (lambda (i2 j2)
                  (combiner (A_) (B_ i2 j2))))
               ((3)
                (lambda (i2 j2 k2)
                  (combiner (A_) (B_ i2 j2 k2))))
               ((4)
                (lambda (i2 j2 k2 l2)
                  (combiner (A_) (B_ i2 j2 k2 l2))))
               (else
                (lambda rest
                  (combiner (A_) (apply B_ rest))))))
            ((1)
             (case dim_B
               ((0)
                (lambda (i1)
                  (combiner (A_ i1) (B_))))
               ((1)
                (lambda (i1 i2)
                  (combiner (A_ i1) (B_ i2))))
               ((2)
                (lambda (i1 i2 j2)
                  (combiner (A_ i1) (B_ i2 j2))))
               ((3)
                (lambda (i1 i2 j2 k2)
                  (combiner (A_ i1) (B_ i2 j2 k2))))
               (else
                (lambda (i1 . rest)
                  (combiner (A_ i1) (apply B_ rest))))))
            ((2)
             (case dim_B
               ((0)
                (lambda (i1 j1)
                  (combiner (A_ i1 j1) (B_))))
               ((1)
                (lambda (i1 j1 i2)
                  (combiner (A_ i1 j1) (B_ i2))))
               ((2)
                (lambda (i1 j1 i2 j2)
                  (combiner (A_ i1 j1) (B_ i2 j2))))
               (else
                (lambda (i1 j1 . rest)
                  (combiner (A_ i1 j1) (apply B_ rest))))))
            ((3)
             (case dim_B
               ((0)
                (lambda (i1 j1 k1)
                  (combiner (A_ i1 j1 k1) (B_))))
               ((1)
                (lambda (i1 j1 k1 i2)
                  (combiner (A_ i1 j1 k1) (B_ i2))))
               (else
                (lambda (i1 j1 k1 . rest)
                  (combiner (A_ i1 j1 k1) (apply B_ rest))))))
            ((4)
             (case dim_B
               ((0)
                (lambda (i1 j1 k1 l1)
                  (combiner (A_ i1 j1 k1 l1) (B_))))
               (else
                (lambda (i1 j1 k1 l1 . rest)
                  (combiner (A_ i1 j1 k1 l1) (apply B_ rest))))))
            (else
             (lambda args
               (combiner (apply A_ (take args dim_A))
                         (apply B_ (drop args dim_A))))))))
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

(define (%%make-safe-immutable-array domain getter caller)
  (make-array
   domain
   (case (%%interval-dimension domain)
     ((0) (lambda ()
            (getter)))
     ((1) (lambda (i)
            (cond ((not (exact-integer? i))
                   (error (string-append caller "multi-index component is not an exact integer: ") i))
                  ((not (%%interval-contains-multi-index?-1 domain i))
                   (error (string-append caller "domain does not contain multi-index: ") domain i))
                  (else
                   (getter i)))))
     ((2) (lambda (i j)
            (cond ((not (and (exact-integer? i)
                             (exact-integer? j)))
                   (error (string-append caller "multi-index component is not an exact integer: ") i j))
                  ((not (%%interval-contains-multi-index?-2 domain i j))
                   (error (string-append caller "domain does not contain multi-index: ") domain i j))
                  (else
                   (getter i j)))))
     ((3) (lambda (i j k)
            (cond ((not (and (exact-integer? i)
                             (exact-integer? j)
                             (exact-integer? k)))
                   (error (string-append caller "multi-index component is not an exact integer: ") i j k))
                  ((not (%%interval-contains-multi-index?-3 domain i j k))
                   (error (string-append caller "domain does not contain multi-index: ") domain i j k))
                  (else
                   (getter i j k)))))
     ((4) (lambda (i j k l)
            (cond ((not (and (exact-integer? i)
                             (exact-integer? j)
                             (exact-integer? k)
                             (exact-integer? l)))
                   (error (string-append caller "multi-index component is not an exact integer: ") i j k l))
                  ((not (%%interval-contains-multi-index?-4 domain i j k l))
                   (error (string-append caller "domain does not contain multi-index: ") domain i j k l))
                  (else
                   (getter i j k l)))))
     (else (lambda multi-index
             (cond ((not (%%every exact-integer? multi-index))
                    (apply error (string-append caller "multi-index component is not an exact integer: ") multi-index))
                   ((not (= (length multi-index) (%%interval-dimension domain)))
                    (apply error (string-append caller "multi-index is not the correct dimension: ") domain multi-index))
                   ((not (%%interval-contains-multi-index?-general domain multi-index))
                    (apply error (string-append caller "domain does not contain multi-index: ") domain multi-index))
                   (else
                    (apply getter multi-index))))))))

(define (%%immutable-array-curry array right-dimension)
  (call-with-values
      (lambda () (%%interval-projections (%%array-domain array) right-dimension))
    (lambda (left-interval right-interval)
      (let ((getter (%%array-getter array)))
        (%%make-safe-immutable-array
         left-interval
         (case (%%interval-dimension left-interval)
           ((0)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda ()        (make-array right-interval (lambda ()          (getter)))))
                   ((1)  (lambda ()        (make-array right-interval (lambda (i)         (getter i)))))
                   ((2)  (lambda ()        (make-array right-interval (lambda (i j)       (getter i j)))))
                   ((3)  (lambda ()        (make-array right-interval (lambda (i j k)     (getter i j k)))))
                   ((4)  (lambda ()        (make-array right-interval (lambda (i j k l)   (getter i j k l)))))
                   (else (lambda ()        (make-array right-interval (lambda multi-index (apply getter multi-index)))))))
           ((1)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i)       (make-array right-interval (lambda ()          (getter i)))))
                   ((1)  (lambda (i)       (make-array right-interval (lambda (j)         (getter i j)))))
                   ((2)  (lambda (i)       (make-array right-interval (lambda (j k)       (getter i j k)))))
                   ((3)  (lambda (i)       (make-array right-interval (lambda (j k l)     (getter i j k l)))))
                   (else (lambda (i)       (make-array right-interval (lambda multi-index (apply getter i multi-index)))))))
           ((2)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j)     (make-array right-interval (lambda ( )         (getter i j)))))
                   ((1)  (lambda (i j)     (make-array right-interval (lambda (  k)       (getter i j k)))))
                   ((2)  (lambda (i j)     (make-array right-interval (lambda (  k l)     (getter i j k l)))))
                   (else (lambda (i j)     (make-array right-interval (lambda multi-index (apply getter i j multi-index)))))))
           ((3)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j k)   (make-array right-interval (lambda (   )       (getter i j k)))))
                   ((1)  (lambda (i j k)   (make-array right-interval (lambda (    l)     (getter i j k l)))))
                   (else (lambda (i j k)   (make-array right-interval (lambda multi-index (apply getter i j k multi-index)))))))
           ((4)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j k l) (make-array right-interval (lambda (     )     (getter i j k l)))))
                   (else (lambda (i j k l) (make-array right-interval (lambda multi-index (apply getter i j k l multi-index)))))))
           (else (lambda left-multi-index
                   (make-array right-interval
                               (lambda right-multi-index
                                 (apply getter (append left-multi-index right-multi-index)))))))
         "array-curry: ")))))

(define (%%mutable-array-curry array right-dimension)
  (call-with-values
      (lambda () (%%interval-projections (%%array-domain array) right-dimension))
    (lambda (left-interval right-interval)
      (let ((getter (%%array-getter array))
            (setter (%%array-setter   array)))
        (%%make-safe-immutable-array
         left-interval
         (case (%%interval-dimension left-interval)
           ((0)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda ()        (make-array right-interval
                                                       (lambda ( )       (getter  ))
                                                       (lambda (v)       (setter v)))))
                   ((1)  (lambda ()        (make-array right-interval
                                                       (lambda (  i)     (getter   i))
                                                       (lambda (v i)     (setter v i)))))
                   ((2)  (lambda ()        (make-array right-interval
                                                       (lambda (  i j)   (getter   i j))
                                                       (lambda (v i j)   (setter v i j)))))
                   ((3)  (lambda ()        (make-array right-interval
                                                       (lambda (  i j k) (getter   i j k))
                                                       (lambda (v i j k) (setter v i j k)))))
                   ((4)  (lambda ()        (make-array right-interval
                                                       (lambda (  i j k l) (getter   i j k l))
                                                       (lambda (v i j k l) (setter v i j k l)))))
                   (else (lambda ()        (make-array right-interval
                                                       (lambda      multi-index  (apply getter           multi-index))
                                                       (lambda (v . multi-index) (apply setter v         multi-index)))))))
           ((1)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i)       (make-array right-interval
                                                       (lambda ( )       (getter   i))
                                                       (lambda (v)       (setter v i)))))
                   ((1)  (lambda (i)       (make-array right-interval
                                                       (lambda (  j)     (getter   i j))
                                                       (lambda (v j)     (setter v i j)))))
                   ((2)  (lambda (i)       (make-array right-interval
                                                       (lambda (  j k)   (getter   i j k))
                                                       (lambda (v j k)   (setter v i j k)))))
                   ((3)  (lambda (i)       (make-array right-interval
                                                       (lambda (  j k l) (getter   i j k l))
                                                       (lambda (v j k l) (setter v i j k l)))))
                   (else (lambda (i)       (make-array right-interval
                                                       (lambda      multi-index  (apply getter   i       multi-index))
                                                       (lambda (v . multi-index) (apply setter v i       multi-index)))))))
           ((2)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j)     (make-array right-interval
                                                       (lambda (   )     (getter   i j))
                                                       (lambda (v  )     (setter v i j)))))
                   ((1)  (lambda (i j)     (make-array right-interval
                                                       (lambda (    k)   (getter   i j k))
                                                       (lambda (v   k)   (setter v i j k)))))
                   ((2)  (lambda (i j)     (make-array right-interval
                                                       (lambda (    k l) (getter   i j k l))
                                                       (lambda (v   k l) (setter v i j k l)))))
                   (else (lambda (i j)     (make-array right-interval
                                                       (lambda      multi-index  (apply getter   i j     multi-index))
                                                       (lambda (v . multi-index) (apply setter v i j     multi-index)))))))
           ((3)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j k)   (make-array right-interval
                                                       (lambda (     )   (getter   i j k))
                                                       (lambda (v    )   (setter v i j k)))))
                   ((1)  (lambda (i j k)   (make-array right-interval
                                                       (lambda (      l) (getter   i j k l))
                                                       (lambda (v     l) (setter v i j k l)))))
                   (else (lambda (i j k)   (make-array right-interval
                                                       (lambda      multi-index  (apply getter   i j k   multi-index))
                                                       (lambda (v . multi-index) (apply setter v i j k   multi-index)))))))
           ((4)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j k l) (make-array right-interval
                                                       (lambda (     )   (getter   i j k l))
                                                       (lambda (v    )   (setter v i j k l)))))
                   (else (lambda (i j k l) (make-array right-interval
                                                       (lambda      multi-index  (apply getter   i j k l multi-index))
                                                       (lambda (v . multi-index) (apply setter v i j k l multi-index)))))))
           (else (lambda left-multi-index
                   (make-array right-interval
                               (lambda      right-multi-index  (apply getter   (append left-multi-index right-multi-index)))
                               (lambda (v . right-multi-index) (apply setter v (append left-multi-index right-multi-index)))))))
         "array-curry: ")))))

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
                  (%%compute-array-packed?
                   ;; The same domain for all subarrays.
                   right-interval
                   ;; The new indexer computed using the general, nonspecialized new-domain->old-domain function,
                   ;; applied specifically to the first multi-index in the left-interval.
                   ;; If any of the arrays are empty then the indexers could be nonsense, but
                   ;; %%compute-array-packed? special-cases empty intervals.
                   (%%compose-indexers (%%array-indexer array)
                                       right-interval
                                       (lambda right-multi-index
                                         (apply values
                                                (append (%%interval-lower-bounds->list left-interval)
                                                        right-multi-index))))))))
        (%%make-safe-immutable-array
         left-interval
         (case (%%interval-dimension left-interval)
           ((0)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda ()        (%%specialized-array-share array right-interval (lambda ()                            (values        )) in-order?)))
                   ((1)  (lambda ()        (%%specialized-array-share array right-interval (lambda (i)                           (values i      )) in-order?)))
                   ((2)  (lambda ()        (%%specialized-array-share array right-interval (lambda (i j)                         (values i j    )) in-order?)))
                   ((3)  (lambda ()        (%%specialized-array-share array right-interval (lambda (i j k)                       (values i j k  )) in-order?)))
                   ((4)  (lambda ()        (%%specialized-array-share array right-interval (lambda (i j k l)                     (values i j k l)) in-order?)))
                   (else (lambda ()        (%%specialized-array-share array right-interval (lambda multi-index (apply values         multi-index)) in-order?)))))
           ((1)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i)       (%%specialized-array-share array right-interval (lambda ()                            (values i      )) in-order?)))
                   ((1)  (lambda (i)       (%%specialized-array-share array right-interval (lambda (j)                           (values i j    )) in-order?)))
                   ((2)  (lambda (i)       (%%specialized-array-share array right-interval (lambda (j k)                         (values i j k  )) in-order?)))
                   ((3)  (lambda (i)       (%%specialized-array-share array right-interval (lambda (j k l)                       (values i j k l)) in-order?)))
                   (else (lambda (i)       (%%specialized-array-share array right-interval (lambda multi-index (apply values i       multi-index)) in-order?)))))
           ((2)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j)     (%%specialized-array-share array right-interval (lambda ()                            (values i j    )) in-order?)))
                   ((1)  (lambda (i j)     (%%specialized-array-share array right-interval (lambda (k)                           (values i j k  )) in-order?)))
                   ((2)  (lambda (i j)     (%%specialized-array-share array right-interval (lambda (k l)                         (values i j k l)) in-order?)))
                   (else (lambda (i j)     (%%specialized-array-share array right-interval (lambda multi-index (apply values i j     multi-index)) in-order?)))))
           ((3)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j k)   (%%specialized-array-share array right-interval (lambda ()                            (values i j k  )) in-order?)))
                   ((1)  (lambda (i j k)   (%%specialized-array-share array right-interval (lambda (l)                           (values i j k l)) in-order?)))
                   (else (lambda (i j k)   (%%specialized-array-share array right-interval (lambda multi-index (apply values i j k   multi-index)) in-order?)))))
           ((4)  (case (%%interval-dimension right-interval)
                   ((0)  (lambda (i j k l) (%%specialized-array-share array right-interval (lambda ()                            (values i j k l)) in-order?)))
                   (else (lambda (i j k l) (%%specialized-array-share array right-interval (lambda multi-index (apply values i j k l multi-index)) in-order?)))))
           (else (lambda left-multi-index
                   (%%specialized-array-share array right-interval (lambda right-multi-index (apply values (append left-multi-index right-multi-index))) in-order?))))
         "array-curry: ")))))

(define (%%array-curry array right-dimension)
  (cond ((specialized-array? array)
         (%%specialized-array-curry array right-dimension))
        ((mutable-array? array)
         (%%mutable-array-curry array right-dimension))
        (else ; immutable array
         (%%immutable-array-curry array right-dimension))))

(define (array-curry array right-dimension)
  (cond ((not (array? array))
         (error "array-curry: The first argument is not an array: " array right-dimension))
        ((not (and (fixnum? right-dimension)
                   (fx<= 0 right-dimension (%%array-dimension array))))
         (error "array-curry: The second argument is not an exact integer between 0 and (interval-dimension (array-domain array)) (inclusive): " array right-dimension))
        (else
         (%%array-curry array right-dimension))))

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
        (arrays (cons array arrays)))

    (define-macro (generate-cases)

      (define-macro (max-getters) 8)

      (define-macro (number-of-dimensions) 5)

      (define (make-getter i)
        (symbol-append 'getter- i))

      (define (symbol-append . args)
        (string->symbol
         (apply string-append (map (lambda (x)
                                     (cond ((symbol? x) (symbol->string x))
                                           ((number? x) (number->string x))
                                           ((string? x) x)
                                           (else (error "Arghh!"))))
                                   args))))

      (define (do-one number-of-getters)
        (let ((getters (map make-getter
                            (iota number-of-getters))))
          `((,number-of-getters) (let ,(map (lambda (getter i)
                                               `(,getter (%%array-getter (list-ref arrays ,i))))
                                             getters
                                             (iota number-of-getters))
                                   (case (%%interval-dimension domain)
                                     ,@(map (lambda (dimension)
                                              (let ((multi-index (map (lambda (dim)
                                                                        (symbol-append 'i_ dim))
                                                                      (iota dimension))))
                                                `((,dimension) (lambda ,multi-index
                                                                 (f ,@(map (lambda (getter)
                                                                             `(,(make-getter getter) ,@multi-index))
                                                                           (iota number-of-getters)))))))
                                            (iota (number-of-dimensions)))
                                     (else (lambda multi-index (f ,@(map (lambda (getter)
                                                                           `(apply ,getter multi-index))
                                                                         getters)))))))))

      (let ((result
             `(case (length arrays)
                ,@(map do-one (iota (max-getters) 1))
                (else
                 (let ((getters (map array-getter arrays)))
                   (case (%%interval-dimension domain)
                     ,@(map (lambda (dimension)
                              (let ((multi-index (map (lambda (dim)
                                                        (symbol-append 'i_ dim))
                                                      (iota dimension))))
                                `((,dimension) (lambda ,multi-index
                                                 (apply f (map (lambda (g)
                                                                 (g ,@multi-index))
                                                               getters))))))
                            (iota (number-of-dimensions)))
                     (else (lambda multi-index (apply f (map (lambda (g) (apply g multi-index)) getters))))))))))
        result))

    (generate-cases)))

(define (%%array-map f array arrays)
  ;; unsafe, for internal use on known intervals
  (make-array (%%array-domain array)
              (%%specialize-function-applied-to-array-getters f array arrays)))

(define (array-map f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-map: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-map: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-map: Not all arrays have the same domain: " f array arrays))
        (else
         ;; safe
         (make-array (%%array-domain array)
                     (%%specialize-function-applied-to-array-getters f array arrays)))))

;;; applies f to the elements of the arrays in lexicographical order.

(define (%%array-for-each f array arrays)
  (%%interval-for-each (%%specialize-function-applied-to-array-getters f array arrays)
                       (%%array-domain array)))

(define (array-for-each f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-for-each: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-for-each: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-for-each: Not all arrays have the same domain: " f array arrays))
        (else
         (%%array-for-each f array arrays))))

(define-macro (macro-make-predicates)

  (define (symbol-append . args)
    (string->symbol
     (apply string-append (map (lambda (x)
                                 (cond ((symbol? x) (symbol->string x))
                                       ((number? x) (number->string x))
                                       ((string? x) x)
                                       (else (error "Arghh!"))))
                               args))))

  (define (make-lower k)
    (symbol-append 'lower- k))

  (define (make-upper k)
    (symbol-append 'upper- k))

  (define (make-arg k)
    (symbol-append 'i_ k))

  (define (make-loop-name k)
    (symbol-append 'loop- k))

  (define (make-predicate name connector)

    (define (make-loop indentation depth k)
      `(let ,(make-loop-name indentation) ((,(make-arg indentation) ,(make-lower indentation))
                                           (index ,(if (= indentation 0)
                                                       `(- n 1)
                                                       `index)))
            ,(if (= indentation 0)
                 (if (= depth 0)
                     `(cond ((eqv? index 0)
                             (f ,@(map make-arg (iota k))))
                            (else
                             (,connector (f ,@(map make-arg (iota k)))
                                         (,(make-loop-name indentation) (+ ,(make-arg indentation) 1) (- index 1)))))
                     (make-loop (+ indentation 1) (- depth 1) k))
                 (if (= depth 0)
                     `(cond ((= ,(make-arg indentation) ,(make-upper indentation))
                             (,(make-loop-name (- indentation 1)) (+ ,(make-arg (- indentation  1)) 1) index))
                            ((eqv? index 0)
                             (f ,@(map make-arg (iota k))))
                            (else
                             (,connector (f ,@(map make-arg (iota k)))
                                         (,(make-loop-name indentation) (+ ,(make-arg indentation) 1) (- index 1)))))
                     `(if (< ,(make-arg indentation) ,(make-upper indentation))
                          ,(make-loop (+ indentation 1) (- depth 1) k)
                          (,(make-loop-name (- indentation 1)) (+ ,(make-arg (- indentation 1)) 1) index))))))

    (define (do-one-case k)
      (let ((result
             `((,k)
               (let (,@(map (lambda (j)
                                `(,(make-lower j) (%%interval-lower-bound interval ,j)))
                              (iota k))
                       ,@(map (lambda (j)
                                `(,(make-upper j) (%%interval-upper-bound interval ,j)))
                              (iota k))
                       (n (%%interval-volume interval)))
                 ,(make-loop 0 (- k 1) k)))))
        result))

    `(define (,(symbol-append '%%interval- name) f interval)
       (if (eqv? (%%interval-volume interval) 0)
           ,(if (eq? name 'any) #f #t)
           (case (%%interval-dimension interval)
             ((0) (f))
             ,@(map do-one-case (iota 8 1))
             (else
              (let ()

                (define (get-next-args reversed-args
                                       reversed-lowers
                                       reversed-uppers)
                  (let ((next-index (+ (car reversed-args) 1)))
                    (if (< next-index (car reversed-uppers))
                        (cons next-index (cdr reversed-args))
                        (and (not (null? (cdr reversed-args)))
                             (let ((tail-result (get-next-args (cdr reversed-args)
                                                               (cdr reversed-lowers)
                                                               (cdr reversed-uppers))))
                               (and tail-result
                                    (cons (car reversed-lowers) tail-result)))))))

                (let ((reversed-lowers (reverse (%%interval-lower-bounds->list interval)))
                      (reversed-uppers (reverse (%%interval-upper-bounds->list interval))))
                  (let loop ((reversed-args reversed-lowers)
                             (index (- (%%interval-volume interval) 1)))
                    (if (eqv? index 0)
                        (apply f (reverse reversed-args))
                        (,connector (apply f (reverse reversed-args))
                                    (loop (get-next-args reversed-args
                                                         reversed-lowers
                                                         reversed-uppers)
                                          (- index 1))))))))))))

  (let ((result
         `(begin
            ,(make-predicate 'every 'and)
            ,(make-predicate 'any 'or))))
    result))

(macro-make-predicates)

(define (%%array-every f array arrays)
  (%%interval-every (%%specialize-function-applied-to-array-getters f array arrays)
                    (%%array-domain array)))

(define (array-every f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-every: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-every: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-every: Not all arrays have the same domain: " f array arrays))
        (else
         (%%array-every f array arrays))))

(define (%%array-any f array arrays)
  (%%interval-any (%%specialize-function-applied-to-array-getters f array arrays)
                  (%%array-domain array)))

(define (array-any f array #!rest arrays)
  (cond ((not (procedure? f))
         (apply error "array-any: The first argument is not a procedure: " f array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-any: Not all arguments after the first are arrays: " f array arrays))
        ((not (%%every (lambda (d) (%%interval= d (%%array-domain array))) (map %%array-domain arrays)))
         (apply error "array-any: Not all arrays have the same domain: " f array arrays))
        (else
         (%%array-any f array arrays))))

(define (array-fold-left op id array . arrays)
  (cond ((not (procedure? op))
         (apply error "array-fold-left: The first argument is not a procedure: " op id array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-fold-left: Not all arguments after the first two are arrays: " op id array arrays))
        ((not (%%every (lambda (a) (%%interval= (%%array-domain a) (%%array-domain array))) arrays))
         (apply error "array-fold-left: Not all arrays have the same domain: " op id array arrays))
        ((null? arrays)
         (%%interval-fold-left (%%array-getter array) op id (%%array-domain array)))
        (else
         (%%interval-fold-left (%%array-getter (%%array-map list array arrays))
                               (case (length arrays)
                                 ((1) (lambda (id elements)
                                        (op id (car elements) (cadr elements))))
                                 ((2) (lambda (id elements)
                                        (op id (car elements) (cadr elements) (caddr elements))))
                                 ((3) (lambda (id elements)
                                        (op id (car elements) (cadr elements) (caddr elements) (cadddr elements))))
                                 (else
                                  (lambda (id elements)
                                    (apply op id elements))))
                               id
                               (%%array-domain array)))))

(define (array-fold-right op id array . arrays)
  (cond ((not (procedure? op))
         (apply error "array-fold-right: The first argument is not a procedure: " op id array arrays))
        ((not (%%every array? (cons array arrays)))
         (apply error "array-fold-right: Not all arguments after the first two are arrays: " op id array arrays))
        ((not (%%every (lambda (a) (%%interval= (%%array-domain a) (%%array-domain array))) arrays))
         (apply error "array-fold-right: Not all arrays have the same domain: " op id array arrays))
        ((null? arrays)
         (%%interval-fold-right (%%array-getter array) op id (%%array-domain array)))
        (else
         (%%interval-fold-right (%%array-getter (%%array-map list array arrays))
                                (case (length arrays)
                                  ((1) (lambda (elements id)
                                         (op (car elements) (cadr elements) id)))
                                  ((2) (lambda (elements id)
                                         (op (car elements) (cadr elements) (caddr elements) id)))
                                  ((3) (lambda (elements id)
                                         (op (car elements) (cadr elements) (caddr elements) (cadddr elements) id)))
                                  (else
                                   (lambda (elements id)
                                     (apply op (append elements (list id))))))
                                id
                                (%%array-domain array)))))

(define %%array-reduce
  (let ((%%array-reduce-base (list 'base)))
    (lambda (sum A caller)
      (if (%%array-empty? A)
          (error (string-append caller "Attempting to reduce over an empty array: ") sum A)
          (%%interval-fold-left (%%array-getter A)
                                (lambda (id a)
                                  (if (eq? id %%array-reduce-base)
                                      a
                                      (sum id a)))
                                %%array-reduce-base
                                (%%array-domain A))))))

(define (array-reduce sum A)
  (cond ((not (array? A))
         (error "array-reduce: The second argument is not an array: " sum A))
        ((not (procedure? sum))
         (error "array-reduce: The first argument is not a procedure: " sum A))
        (else
         (%%array-reduce sum A "array-reduce: "))))

(define (%%array->reversed-list array)
  ;; safe in the face of (%%array-getter array) capturing
  ;; the continuation using call/cc, as long as the
  ;; resulting list is not modified.
  (%%interval-fold-left (%%array-getter array)
                        (lambda (a b) (cons b a))
                        '()
                        (%%array-domain array)))

(define (%%array->list array)
  ;; This is faster than using %%interval-fold-right
  (reverse (%%array->reversed-list array)))

(define (array->list array)
  (cond ((not (array? array))
         (error "array->list: The argument is not an array: " array))
        (else
         (%%array->list array))))

(define (%%array->vector array)
  (let* ((reversed-elements (%%array->reversed-list array))
         (n (%%interval-volume (%%array-domain array)))
         (result (make-vector n)))
    (do ((i (fx- n 1) (fx- i 1))
         (l reversed-elements (cdr l)))
        ((fx< i 0) result)
      (vector-set! result i (car l)))))

(define (array->vector array)
  (cond ((not (array? array))
         (error "array->vector: The argument is not an array: " array))
        (else
         (%%array->vector array))))

;;; Refactored for use in list*->array

(define (%%list->array interval
                       l
                       result-storage-class
                       mutable?
                       safe?
                       caller)
  (let* ((checker
          (storage-class-checker  result-storage-class))
         (setter
          (storage-class-setter   result-storage-class))
         (result
          (%%make-specialized-array interval
                                    result-storage-class
                                    (storage-class-default result-storage-class)
                                    safe?))
         (body
          (%%array-body result))
         (n
          (%%interval-volume interval)))
    (let loop ((i 0)
               (local l))
      (if (or (fx= i n) (null? local))
          (if (and (fx= i n) (null? local))
              (if (not mutable?)
                    (%%array-freeze! result)
                    result)
              (error (string-append caller "The volume of the first argument does not equal the length of the second: ") interval l))
          (let ((item (car local)))
            (if (checker item)
                (begin
                  (setter body i item)
                  (loop (fx+ i 1)
                        (cdr local)))
                (error (string-append caller "Not all elements of the source can be stored in destination: ") interval l item)))))))

(define (list->array interval
                     l
                     #!optional
                     (result-storage-class generic-storage-class)
                     (mutable? (specialized-array-default-mutable?))
                     (safe? (specialized-array-default-safe?)))
  (cond ((not (interval? interval))
         (error "list->array: The first argument is not an interval: " interval l))
        ((not (list? l))
         (error "list->array: The second argument is not a list: " interval l))
        ((not (storage-class? result-storage-class))
         (error "list->array: The third argument is not a storage-class: " interval l result-storage-class))
        ((not (boolean? mutable?))
         (error "list->array: The fourth argument is not a boolean: " interval l result-storage-class mutable?))
        ((not (boolean? safe?))
         (error "list->array: The fifth argument is not a boolean: " interval l result-storage-class mutable? safe?))
        (else
         (%%list->array interval
                        l
                        result-storage-class
                        mutable?
                        safe?
                        "list->array: "))))

(define (vector->array  interval
                        v
                        #!optional
                        (result-storage-class generic-storage-class)
                        (mutable? (specialized-array-default-mutable?))
                        (safe? (specialized-array-default-safe?)))
  (cond ((not (interval? interval))
         (error "vector->array: The first argument is not an interval: " interval v))
        ((not (vector? v))
         (error "vector->array: The second argument is not a vector: " interval v))
        ((not (= (vector-length v)
                 (%%interval-volume interval)))
         (error "vector->array: The volume of the first argument does not equal the length of the second: " interval v))
        ((not (storage-class? result-storage-class))
         (error "vector->array: The third argument is not a storage-class: " interval v result-storage-class))
        ((not (boolean? mutable?))
         (error "vector->array: The fourth argument is not a boolean: " interval v result-storage-class mutable?))
        ((not (boolean? safe?))
         (error "vector->array: The fifth argument is not a boolean: " interval v result-storage-class mutable? safe?))
        (else
         (specialized-array-reshape
          (%!array-copy (%%make-specialized-array-from-data v generic-storage-class #f #f)
                        result-storage-class
                        mutable?
                        safe?
                        "vector->array: "
                        #f)
          interval))))

(define (array->list* array)
  (cond ((not (array? array))
         (error "array->list*: The argument is not an array: " array))
        (else
         (let ()
           (define (a->l a)
             (let ((dim (%%interval-dimension (%%array-domain a))))
               (case dim
                 ((0) ((%%array-getter a)))  ;; special case, just the element of the array
                 ((1) (%%array->list a))
                 (else
                  (%%array->list
                   (%%array-map a->l (%%array-curry a (fx- dim 1)) '()))))))
           (a->l array)))))

(define (array->vector* array)
  (cond ((not (array? array))
         (error "array->vector*: The argument is not an array: " array))
        (else
         (let ()
           (define (a->v a)
             (let ((dim (%%interval-dimension (%%array-domain a))))
               (case dim
                 ((0) ((%%array-getter a)))  ;; special case, just the element of the array
                 ((1) (%%array->vector a))
                 (else
                  (%%array->vector
                   (%%array-map a->v (%%array-curry a (fx- dim 1)) '()))))))
           (a->v array)))))

(define (array-assign! destination source)
  ;; This procedure is intrinsically not call/cc safe.
  (cond ((not (mutable-array? destination))
         (error "array-assign!: The destination is not a mutable array: " destination source))
        ((not (array? source))
         (error "array-assign!: The source is not an array: " destination source))
        ((not (%%interval= (%%array-domain destination)
                           (%%array-domain source)))
         (error "array-assign: The destination and source do not have the same domains: " destination source))
        (else
         (%%move-array-elements destination
                                source
                                "array-assign!: ")
         (void))))

(define (%%array-inner-product A f g B)
  ;; Copy the curried arrays for efficiency.
  ;; If any of the curried arrays are empty, that's OK,
  ;; If the elements of the curried arrays are empty, then
  ;; the error check in %%array-reduce will catch it.
  (%%array-outer-product
   (lambda (a b)
     (%%array-reduce f (%%array-map g a (list b)) "array-inner-product: "))
   (array-copy (%%array-curry A 1))
   (array-copy (%%array-curry (%%array-permute B (%%index-rotate (%%array-dimension B) 1)) 1))))

(define (array-inner-product A f g B)
  (cond ((not (array? A))
         (error "array-inner-product: The first argument is not an array: " A f g B))
        ((not (procedure? f))
         (error "array-inner-product: The second argument is not a procedure: " A f g B))
        ((not (procedure? g))
         (error "array-inner-product: The third argument is not a procedure: " A f g B))
        ((not (array? B))
         (error "array-inner-product: The fourth argument is not an array: " A f g B))
        ((not (fx< 0 (%%array-dimension A)))
         (error "array-inner-product: The first argument has dimension zero: " A f g B))
        ((not (fx< 0 (%%array-dimension B)))
         (error "array-inner-product: The fourth argument has dimension zero: " A f g B))
        ((let* ((A-dim (%%array-dimension A))
                (A-dom (%%array-domain A))
                (B-dom (%%array-domain B)))
           (not (and (fx= (%%interval-lower-bound A-dom (fx- A-dim 1))
                          (%%interval-lower-bound B-dom 0))
                     (fx= (%%interval-upper-bound A-dom (fx- A-dim 1))
                          (%%interval-upper-bound B-dom 0)))))
         (error (string-append "array-inner-product: The bounds of the last dimension of the first argument "
                               "are not the same as the bounds of the first dimension of the fourth argument: ")
                A f g B))
        (else
         (%%array-inner-product A f g B))))

;;; Refactored from array-stack to use in list*->array and vector*->array

(define (%%%array-stack k arrays storage-class mutable? safe? caller call/cc-safe?)
  (let* ((arrays
          (if call/cc-safe?
              (map (lambda (A)
                     (%%->specialized-array A storage-class caller))
                   arrays)
              arrays))
         (first-array
          (car arrays))
         (number-of-arrays
          (length arrays))
         (domain                         ;; the common domain of all the arrays
          (%%array-domain first-array))
         (domain-dimension
          (%%interval-dimension domain))
         (lowers
          (%%interval-lower-bounds->list domain))
         (uppers
          (%%interval-upper-bounds->list domain))
         (result-dimension
          (fx+ 1 domain-dimension))
         (result-domain
          (%%finish-interval
           (list->vector (append (take lowers k) (cons 0                (drop lowers k))))
           (list->vector (append (take uppers k) (cons number-of-arrays (drop uppers k))))))
         (result-dimension
          (fx+ 1 domain-dimension))
         (result-array
          (%%make-specialized-array result-domain
                                    storage-class
                                    (storage-class-default storage-class)
                                    safe?))
         (permuted-and-curried-result
          (%%array-curry (%%array-permute result-array (%%index-first result-dimension k))
                         domain-dimension)))
    ;; copy each array argument to the associated place in stack
    (%%array-for-each (lambda (destination source)
                        (%%move-array-elements destination source caller))
                      permuted-and-curried-result
                      (list (%%list->array (make-interval (vector number-of-arrays))
                                           arrays
                                           generic-storage-class
                                           #f
                                           #f
                                           caller)))
    (if (not mutable?)
        (%%array-freeze! result-array)
        result-array)))

(define (array-stack k
                     arrays
                     #!optional
                     (storage-class generic-storage-class)
                     (mutable?      (specialized-array-default-mutable?))
                     (safe?         (specialized-array-default-safe?)))
  (%%array-stack k arrays storage-class mutable? safe? #t))


(define (array-stack! k
                      arrays
                      #!optional
                      (storage-class generic-storage-class)
                      (mutable?      (specialized-array-default-mutable?))
                      (safe?         (specialized-array-default-safe?)))
  (%%array-stack k arrays storage-class mutable? safe? #f))

(define (%%array-stack k arrays storage-class mutable? safe? call/cc-safe?)

  (define caller
    (if call/cc-safe?
        "array-stack: "
        "array-stack!: "))

  (cond ((not (and (list? arrays)
                   (not (null? arrays))
                   (%%every array? arrays)
                   (%%every (lambda (a) (%%interval= (%%array-domain a) (%%array-domain (car arrays)))) (cdr arrays))))
         (error (string-append caller "Expecting a nonnull list of arrays with the same domains as the second argument: ") k arrays))
        ((not (and (fixnum? k)
                   (fx<= 0 k (%%array-dimension (car arrays)))))
         (error (string-append caller "Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (inclusive) as the first argument:")
                k arrays))
        ((not (storage-class? storage-class))
         (error (string-append caller "Expecting a storage class as the third argument: ") k arrays storage-class))
        ((not (boolean? mutable?))
         (error (string-append caller "Expecting a boolean as the fourth argument: ") k arrays storage-class mutable?))
        ((not (boolean? safe?))
         (error (string-append caller "Expecting a boolean as the fifth argument: ") k arrays storage-class mutable? safe?))
        (else
         (%%%array-stack k arrays storage-class mutable? safe? caller call/cc-safe?))))

(define (array-append k
                      arrays
                      #!optional
                      (storage-class generic-storage-class)
                      (mutable?      (specialized-array-default-mutable?))
                      (safe?         (specialized-array-default-safe?)))
  (%%array-append k arrays storage-class mutable? safe? #t))

(define (array-append! k
                       arrays
                       #!optional
                       (storage-class generic-storage-class)
                       (mutable?      (specialized-array-default-mutable?))
                       (safe?         (specialized-array-default-safe?)))
  (%%array-append k arrays storage-class mutable? safe? #f))

(define (%%array-append k arrays storage-class mutable? safe? call/cc-safe?)

  (define caller
    (if call/cc-safe?
        "array-append: "
        "array-append!: "))

  (cond ((not (and (list? arrays)
                   (not (null? arrays))
                   (%%every array? arrays)
                   (%%every (lambda (a) (= (%%array-dimension a) (%%array-dimension (car arrays)))) (cdr arrays))))
         (error (string-append caller "Expecting as the second argument a nonnull list of arrays with the same dimension: ") k arrays))
        ((not (and (fixnum? k)
                   (fx< -1 k (%%array-dimension (car arrays)))))
         (error (string-append caller "Expecting an exact integer between 0 (inclusive) and the dimension of the arrays (exclusive) as the first argument:")
                k arrays))
        ((not (storage-class? storage-class))
         (error (string-append caller "Expecting a storage class as the third argument: ") k arrays storage-class))
        ((not (boolean? mutable?))
         (error (string-append caller "Expecting a boolean as the fourth argument: ") k arrays storage-class mutable?))
        ((not (boolean? safe?))
         (error (string-append caller "Expecting a boolean as the fifth argument: ") k arrays storage-class mutable? safe?))
        ((not (let ((first-domain (%%array-domain (car arrays))))
                (%%every (lambda (d)
                           (%%every (lambda (i)
                                      (or (fx= i k)
                                          (and (= (%%interval-lower-bound first-domain i)  ;; may not be fixnums
                                                  (%%interval-lower-bound d            i))
                                               (= (%%interval-upper-bound first-domain i)
                                                  (%%interval-upper-bound d            i)))))
                                    (iota (%%interval-dimension first-domain))))
                         (cdr (map %%array-domain arrays)))))
         (error (string-append caller "Expecting as the second argument a nonnull list of arrays with the same upper and lower bounds (except for index "
                               (number->string k)
                               "): ")
                k arrays))
        (else
         (call-with-values
             (lambda ()
               (let loop ((result '(0))
                          (arrays arrays))
                 (if (null? arrays)
                     (values (reverse result) (car result))
                     (let ((interval (%%array-domain (car arrays))))
                       (loop (cons (fx+ (car result)
                                        (- (%%interval-upper-bound interval k)
                                           (%%interval-lower-bound interval k)))
                                   result)
                             (cdr arrays))))))
           (lambda (axis-subdividers kth-size)
             (let* ((arrays
                     (if call/cc-safe?
                         (map (lambda (A)
                                (%%->specialized-array A storage-class caller))
                              arrays)
                         arrays))
                    (first-array
                     (car arrays))
                    (lowers
                     ;; the domains of the arrays differ only in the kth axis
                     (%%interval-lower-bounds->vector (%%array-domain first-array)))
                    (uppers
                     (%%interval-upper-bounds->vector (%%array-domain first-array)))
                    (result
                     ;; the result array
                     (%%make-specialized-array
                      (let ()
                        (vector-set! lowers k 0)
                        (vector-set! uppers k kth-size)
                        (make-interval lowers uppers))  ;; copies lowers and uppers
                      storage-class
                      (storage-class-default storage-class)
                      safe?))
                    (translation
                     ;; a vector we'll use to align each argument
                     ;; array into the proper subarray of the result
                     (make-vector (%%array-dimension first-array) 0)))
               (let loop ((arrays arrays)
                          (subdividers axis-subdividers))
                 (if (null? arrays)
                     ;; we've assigned every array to the appropriate subarray of result
                     (if (not mutable?)
                         (%%array-freeze! result)
                         result)
                     (let ((array (car arrays)))
                       (vector-set! lowers k (car subdividers))
                       (vector-set! uppers k (cadr subdividers))
                       (vector-set! translation k (- (car subdividers)
                                                     (%%interval-lower-bound (%%array-domain array) k)))
                       (%%move-array-elements
                        (%%array-extract result (%%finish-interval lowers uppers))
                        (%%array-translate array translation)
                        caller)
                       (loop (cdr arrays)
                             (cdr subdividers)))))))))))

(define (array-decurry A-arg
                       #!optional
                       (storage-class generic-storage-class)
                       (mutable?      (specialized-array-default-mutable?))
                       (safe?         (specialized-array-default-safe?)))
  (%%array-decurry A-arg storage-class mutable? safe? #t))

(define (array-decurry! A-arg
                        #!optional
                        (storage-class generic-storage-class)
                        (mutable?      (specialized-array-default-mutable?))
                        (safe?         (specialized-array-default-safe?)))
  (%%array-decurry A-arg storage-class mutable? safe? #f))

(define (%%array-decurry A-arg storage-class mutable? safe? call/cc-safe?)

  (define caller
    (if call/cc-safe?
        "array-decurry: "
        "array-decurry!: "))

  (cond ((not (array? A-arg))
         (error (string-append caller "The first argument is not an array: ") A-arg))
        ((%%array-empty? A-arg)
         (error (string-append caller "The first argument is an empty array: ") A-arg))
        ((not (storage-class? storage-class))
         (error (string-append caller "The second argument is not a storage class: ") A-arg storage-class))
        ((not (boolean? mutable?))
         (error (string-append caller "The third argument is not a boolean: ") A-arg storage-class mutable?))
        ((not (boolean? safe?))
         (error (string-append caller "The fourth argument is not a boolean: ") A-arg storage-class mutable? safe?))
        (else
         (let* ((A   (array-copy A-arg))
                (A_  (%%array-getter A))
                (A_D (%%array-domain A)))
           (if (not (%%array-every array? A '()))
               (error (string-append caller "Not all elements of the first argument (an array) are arrays: ") A-arg)
               (let* ((first-element (apply A_ (%%interval-lower-bounds->list A_D)))
                      (first-domain  (%%array-domain first-element)))
                 (if (not (%%array-every  (lambda (a) (%%interval= (%%array-domain a) first-domain)) A '()))
                     (error (string-append caller "Not all elements of the first argument (an array) have the domain: ") A-arg)
                     (let* ((A (if (and call/cc-safe?
                                        (not (%%array-every specialized-array? A '())))
                                   (%%->specialized-array (%%array-map (lambda (A)
                                                                         (%%->specialized-array A storage-class caller))
                                                                       A
                                                                       '())
                                                          generic-storage-class
                                                          caller)
                                   A))
                            (result-domain  (%%interval-cartesian-product (list A_D first-domain)))
                            (result         (%%make-specialized-array result-domain
                                                                      storage-class
                                                                      (storage-class-default storage-class)
                                                                      safe?))
                            (curried-result (%%array-curry result (%%interval-dimension first-domain))))
                       (%%array-for-each (lambda (result argument)
                                           (%%move-array-elements result
                                                                  argument
                                                                  caller))
                                         curried-result (list A))
                       (if (not mutable?)
                           (%%array-freeze! result)
                           result)))))))))

(define (array-block A-arg
                     #!optional
                     (storage-class generic-storage-class)
                     (mutable?      (specialized-array-default-mutable?))
                     (safe?         (specialized-array-default-safe?)))
  (%%array-block A-arg storage-class mutable? safe? #t))

(define (array-block! A-arg
                      #!optional
                      (storage-class generic-storage-class)
                      (mutable?      (specialized-array-default-mutable?))
                      (safe?         (specialized-array-default-safe?)))
  (%%array-block A-arg storage-class mutable? safe? #f))

(define (%%array-block A-arg storage-class mutable? safe? call/cc-safe?)

  (define caller
    (if call/cc-safe?
        "array-block: "
        "array-block!: "))

  (cond ((not (array? A-arg))
         (error (string-append caller "The first argument is not an array: ") A-arg))
        ((%%array-empty? A-arg)
         (error (string-append caller "The first argument is an empty array: ") A-arg))
        ((not (storage-class? storage-class))
         (error (string-append caller "The second argument is not a storage class: ") A-arg storage-class))
        ((not (boolean? mutable?))
         (error (string-append caller "The third argument is not a boolean: ") A-arg storage-class mutable?))
        ((not (boolean? safe?))
         (error (string-append caller "The fourth argument is not a boolean: ") A-arg storage-class mutable? safe?))
        (else
         (let* ((A                (%%array-translate     ;; make lower-bounds zero
                                   (array-copy A-arg)  ;; evaluate all (array) elements of A-arg
                                   (vector-map (lambda (x) (- x))  (%%interval-lower-bounds (%%array-domain A-arg)))))
                (A_D              (%%array-domain A))
                (A_dim            (%%interval-dimension A_D))
                (ks               (list->vector (iota A_dim))))
           (cond ((not (%%array-every array? A '()))
                  (error (string-append caller "Not all elements of the first argument (an array) are arrays: ") A-arg))
                 ((not (%%array-every (lambda (a) (fx= (%%array-dimension a) A_dim)) A '()))
                  (error (string-append caller "Not all elements of the first argument (an array) have the same dimension as the first argument itself: ") A-arg))
                 ((not (%%vector-every
                        (lambda (k)       ;; the direction
                          (let ((slices   ;; the slices in that direction
                                 (%%array-curry (%%array-permute A (%%index-first A_dim k))
                                                (fx- A_dim 1))))
                            (%%array-every
                             (lambda (slice)
                               (let ((kth-width-of-arrays-in-slice
                                      (map (lambda (a)
                                             (%%interval-width (%%array-domain a) k))
                                           (%%array->list slice))))
                                 (or (null? kth-width-of-arrays-in-slice)
                                     (%%every (lambda (w) (= (car kth-width-of-arrays-in-slice) w)) (cdr kth-width-of-arrays-in-slice)))))
                             slices '())))
                        ks))
                  (error (string-append caller "Cannot stack array elements of the first argument into result array: ") A-arg))
                 (else
                  ;; Here we repeat some of the logic of array-append; otherwise, we could apply array-append
                  ;; iteratively in each coordinate direction, but that could incur more memory allocation.
                  (let* ((slice-offsets       ;; the indices in each direction where the "cuts" are
                          (vector-map
                           (lambda (k)        ;; the direction
                             (let* ((pencil   ;; a pencil in that direction
                                     ;; Amazingly, this works when A_dim is 1.
                                     (apply (%%array-getter (%%array-curry (%%array-permute A (%%index-last A_dim k)) 1))
                                            (make-list (fx- A_dim 1) 0)))
                                    (pencil_
                                     (%%array-getter pencil))
                                    (pencil-size
                                     (%%interval-width (%%array-domain pencil) 0))
                                    (result   ;; include sum of all kth interval-widths in pencil
                                     (make-vector (fx+ pencil-size 1) 0)))
                               (do ((i 0 (fx+ i 1)))
                                   ((fx= i pencil-size) result)
                                 (vector-set! result
                                              (fx+ i 1)
                                              (fx+ (vector-ref result i)
                                                   (%%interval-width (%%array-domain (pencil_ i)) k))))))
                           ks))
                         (A
                          (if (and call/cc-safe?
                                   (not (%%array-every specialized-array? A '())))
                              (%%->specialized-array (%%array-map (lambda (A)
                                                                    (%%->specialized-array A storage-class caller))
                                                                  A
                                                                  '())
                                                     generic-storage-class
                                                     caller)
                              A))
                         (A_
                          (%%array-getter A))
                         (result
                          (%%make-specialized-array
                           (make-interval
                            (vector-map (lambda (v)
                                          (vector-ref v (fx- (vector-length v) 1)))
                                        slice-offsets))
                           storage-class
                           (storage-class-default storage-class)
                           safe?)))
                    ;; We copy the elements from each input array block to the corresponding block
                    ;; in the result array.
                    (%%interval-for-each
                     (lambda multi-index
                       (let* ((vector-multi-index
                               (list->vector multi-index))
                              (corner     ;; where the subarray will sit in the result array
                               (vector-map (lambda (i k)
                                             (vector-ref (vector-ref slice-offsets k) i))
                                           vector-multi-index
                                           ks))
                              (subarray
                               (apply A_ multi-index))
                              (translated-subarray  ;; translate the subarray to corner
                               (%%array-translate
                                subarray
                                (vector-map (lambda (x y) (- x y))
                                            corner
                                            (%%interval-lower-bounds (%%array-domain subarray))))))
                         (%%move-array-elements (%%array-extract result (%%array-domain translated-subarray))
                                                translated-subarray
                                                caller)))
                     A_D)
                    (if (not mutable?)
                        (%%array-freeze! result)
                        result))))))))

;;; Because array-ref and array-set! have variable number of arguments, and
;;; they have to check on every call that the first argument is an array,
;;; compiled code using array-ref and array-set! can take up to three times
;;; as long as our usual notational convention:
;;;
;;; (let ((A_ (array-getter A))) ... (A_ i j) ...)
;;;

(define array-ref
  (case-lambda
   ((A)
    (if (not (array? A))
        (error "array-ref: The argument is not an array: " A)
        ((%%array-getter A))))
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
   ((A v)
    (if (not (mutable-array? A))
        (error "array-set!: The first argument is not a mutable array: " A v)
        ((%%array-setter A) v)))
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
         (%%specialized-array-reshape array new-domain copy-on-failure?))))

(define (%%specialized-array-reshape array new-domain copy-on-failure?)

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

  (if (%%array-empty? array)
      ;; Any empty array can be reshaped to any other empty array.
      (%%finish-specialized-array new-domain
                                  (%%array-storage-class array)
                                  (%%array-body array)
                                  (lambda args (apply error "indexer of empty array should not be called" args))  ;; meaningless
                                  (mutable-array? array)
                                  (%%array-safe? array)
                                  (%%array-in-order? array))
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
                                  (%%specialized-array-reshape
                                   (%!array-copy array
                                                 (%%array-storage-class array)
                                                 (mutable-array? array)
                                                 (%%array-safe? array)
                                                 "specialized-array-reshape: "
                                                 #f)
                                   new-domain
                                   #f)
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
                        ((0) (%%indexer-0 base))
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
                                            (%%array-in-order? array))))))))
