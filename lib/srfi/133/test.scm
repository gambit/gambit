;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 133, Vector library.

(import (srfi 133))
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
;; vector-unfold!


(let ((vec #(0 0 0 0)))
  (vector-unfold! (lambda (i) i) vec 0 4)
  (test-assert (equal? vec #(0 1 2 3))))
  
(let ((vec (make-vector 4)))
  (vector-unfold! (lambda (i x y) (values (* x y) (+ 1 x) (+ 1 y)))
                  vec 0 4
                  0
                  0)
  (test-assert (equal? vec #(0 1 4 9))))

(test-exception vector-unfold!
                (type: (0 #() 0 1) (+ 0 0 1) (+ #() #f 1) (+ #() 0 #f))
                (range: (+ #(0 1) -1 1) (+ #(0 1) 1 0))
                (args: 4 0))

;;============================================================================
;; vector-unfold-right!

(let ((vec (make-vector 4)))
  (vector-unfold-right! (lambda (i) i) vec 0 4)
  (test-assert (equal? vec #(0 1 2 3))))

(let ((vec (make-vector 4)))
  (vector-unfold-right! (lambda (i x y) (values (* x y) (+ 1 x) (+ 1 y)))
                  vec 0 4
                  0
                  0)
  (test-assert (equal? vec #(9 4 1 0))))

(test-exception vector-unfold-right!
                (type: (0 #() 0 1) (+ 0 0 1) (+ #() #f 1) (+ #() 0 #f))
                (range: (+ #(0 1) -1 1) (+ #(0 1) 1 0))
                (args: 4 0))


;;;============================================================================
;; vector-unfold
(test-assert (equal? (vector-unfold values 3)
                     #(0 1 2)))

(test-assert (equal? (vector-unfold
                       (lambda (i x) (values x (- x 1)))
                       5 0)
                     #(0 -1 -2 -3 -4)))

(test-assert (equal? (vector-unfold
                       (lambda (i a b) (values (+ i a b) (- a 1) (+ b 1)))
                       5 10 0)
                     #(10 11 12 13 14)))

(test-exception vector-unfold
                (type: (0 0) (+ #f 0))
                (args: 2 0))

;;============================================================================
;; vector-unfold-right

(test-assert (equal?
               (vector-unfold-right
                 (lambda (i) i)
                 4)
               #(0 1 2 3)))
 
(test-assert (equal? 
               (let ((vec #(0 1 2)))
                 (vector-unfold-right
                   (lambda (i x) 
                     (values 
                       (vector-ref vec x)
                       (+ x 1)))
                   (vector-length vec)
                   0))
               #(2 1 0)))

(test-assert (equal? 
               (vector-unfold-right
                 (lambda (i a b c)
                    (values
                      (* a b c)
                      (+ a 1)
                      (+ b 1)
                      (+ c 1)))
                 4
                 1 1 1)
              #(64 27 8 1)))

(test-exception vector-unfold-right
                (type: 0 0)
                (args: 2 0))

;;============================================================================
;; vector-copy

(let* ((vec  #(0 1 2 3))
       (vec0 (vector-copy vec))
       (vec1 (vector-copy vec 2))
       (vec2 (vector-copy vec 1 3)))
  (test-assert (equal? vec  #(0 1 2 3)))
  (test-assert (equal? vec0 #(0 1 2 3)))
  (test-assert (equal? vec1 #(2 3)))
  (test-assert (equal? vec2 #(1 2))))

(test-exception vector-copy
                (type: (0) (#(0) #f))
                (args: 1 4))

;;============================================================================
;; vector-reverse-copy

(let* ((vec  #(3 2 1 0))
       (vec0 (vector-reverse-copy vec))
       (vec1 (vector-reverse-copy vec 2))
       (vec2 (vector-reverse-copy vec 1 3)))
  (test-assert (equal? vec  #(3 2 1 0)))
  (test-assert (equal? vec0 #(0 1 2 3)))
  (test-assert (equal? vec1 #(0 1)))
  (test-assert (equal? vec2 #(1 2))))

(test-exception vector-reverse-copy
                (type: (0) (#(0) #f) (#(0) 0 #f))
                (args: 1 4))

;;============================================================================
;; vector-append

(test-assert (equal? (vector-append)
                     #()))

(test-assert (equal? (vector-append #(0 1))
                     #(0 1)))

(test-assert (equal? (vector-append #(0 1) #(2 3))
                     #(0 1 2 3)))

(test-exception vector-append
                (type: (0) (#() 0) (#() #() 0)))

;;============================================================================
;; vector-concatenate

(test-assert (equal? (vector-concatenate '())
                     #()))

(test-assert (equal? (vector-concatenate '(#(0 1)))
                     #(0 1)))

(test-assert (equal? (vector-concatenate '(#(0 1) #(2 3)))
                     #(0 1 2 3)))

(test-exception vector-concatenate
                (type: (0) ((0)) ((#() 0))))

;;============================================================================
;; Predicates
;;============================================================================
;;============================================================================
;; vector-empty?

(test-assert (vector-empty? #()))
(test-assert (not (vector-empty? #(0))))
(test-assert (not (vector-empty? #(0 1 2))))

(test-exception vector-empty?
                (type: 0)
                (args: 1 1))

;;============================================================================
;; vector=

;(test-assert (vector= =))
(test-assert (vector= = #(0)))
(test-assert (vector= = #() #()))
(test-assert (vector= = #(0 1 2) #(0 1 2)))
(test-assert (not (vector= = #(0 1 2) #(0 2 2))))
(test-assert (vector= (lambda expr (apply vector= = expr))
                      #(#(0 1 2) #(2 3 4)) 
                      #(#(0 1 2) #(2 3 4))
                      #(#(0 1 2) #(2 3 4))))

(test-exception vector=
                (type: (0) (+ 0) (+ #() 0))
                (args: 1 0))
;;============================================================================
;; Iteration
;;============================================================================
;;============================================================================
;; vector-fold
(test-assert (= (vector-fold (lambda (state x)
                               (+ (* state 2) x))
                             0
                             #(1 2 3))
                11))

(vector-fold (lambda (state v p)
               (+ state (* v p)))
             0
             #(1 2 3)
             #(.25 .5 .25))

(test-assert (= (vector-fold (lambda (state v p)
                                  (+ state (* v p)))
                                0
                                #(1 2 3)
                                #(.25 .5 .25))
                2.))

(test-exception vector-fold
                (type: (0 0 #()) (+ 0 0) (+ 0 #() 0))
                (args: 3 0)) 

;;;============================================================================
;; vector-map


(let ((vec #(1 2 3)))
  (test-assert (equal? (vector-map (lambda (x) (* x x))
                                   vec)
                       #(1 4 9)))
  
  (test-assert (equal? vec #(1 2 3)))
  (test-assert (equal? (vector-map (lambda (x y) (* x y))
                                   vec
                                   vec)
                       #(1 4 9)))
  (test-assert (equal? vec #(1 2 3))))

(test-exception vector-map
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; vector-map!

(let ((vec #(1 2 3)))
  (vector-map! (lambda (x) (* x x))
           vec)
  (test-assert (equal? vec #(1 4 9))))

(let ((vec #(1 2 3)))
  (vector-map! (lambda (x y) (* x y))
               vec
               vec)
  (test-assert (equal? vec #(1 4 9))))

(test-exception vector-map!
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; vector-for-each


(let ((var #f))
  (vector-for-each
    (lambda (x)
      (set! var x))
    #())
  (test-assert (not var)))

(test-exception vector-for-each
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; vector-count

(test-assert (= (vector-count (lambda (x) (even? x)) 
                              #())
                0))

(test-assert (= (vector-count (lambda (x) (even? x)) 
                              #(0 1 2 3 4 5))
                3))

(test-assert (= (vector-count (lambda (x y)
                                (= (* 2 x) y))
                              #(0 1 2 3)
                              #(0 1 2 3))
                1))

(test-exception vector-count
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; Searching
;;============================================================================
;;============================================================================
;; vector-index

(test-assert (= (vector-index even? #(1 2 3 4))
                1))

(test-assert (eq? (vector-index even? #(1 3 5 7))
                  #f))

(test-exception vector-index
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; vector-index-right

(test-assert (= (vector-index-right even? #(1 2 3 4))
                3))

(test-assert (eq? (vector-index-right even? #(1 3 5 7))
                  #f))

(test-exception vector-index-right
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; vector-skip

(test-assert (= (vector-skip odd? #(1 2 3 4))
                1))

(test-assert (eq? (vector-skip odd? #(1 3 5 7))
                  #f))

(test-exception vector-skip
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; vector-skip-right

(test-assert (= (vector-skip-right odd? #(1 2 3 4))
                3))

(test-assert (eq? (vector-skip-right odd? #(1 3 5 7))
                  #f))

(test-exception vector-skip-right
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;============================================================================
;; vector-binary-search

(let ((cmp (lambda (x y)
             (cond ((= x y) 0)
                   ((< x y) -1)
                   (else    1)))))
  (test-assert (= (vector-binary-search #(1 2 3 4)
                                        1
                                        cmp)
                  0))
  (test-assert (not (vector-binary-search #(1 2 3 4)
                                          1
                                          cmp
                                          2)))
  (let ((vec #(1 2 3 4 5 6 7 8 9 
               10 11 12 13 14 15 16)))
    (let ((val 0))
      (vector-binary-search vec
                          16
                          (lambda (x y) 
                            (set! val (+ val 1))
                            (cmp x y)))
      (test-assert (<= val 4)))

    (let ((val 0))
      (vector-binary-search vec
                          4
                          (lambda (x y) 
                            (set! val (+ val 1))
                            (cmp x y)))
      (test-assert (<= val 4)))))
                                        

(test-exception vector-binary-search
                (type: (0 0 +) (#() 0 0) (#() 0 + #f)
                                         (#() 0 + 0 #f))
                (range: (#() 0 + -1)
                        (#(0) 0 + 0 2)
                        (#(0) 0 + 2 0))
                (args: 3 5))

;;============================================================================
;; vector-any

(test-assert (vector-any even? #(1 3 5 2 7)))
(test-assert (not (vector-any eq? #(1 3 5) #(2 4 6))))
(test-assert (vector-any eq? #(1 3 #f 5) #(2 4 #f 6)))

(test-exception vector-any
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;============================================================================
;; vector-every

(test-assert (vector-every odd? #(1 3 5 7)))
(test-assert (vector-every eq? #(1 3 5) #(1 3 5)))
(test-assert (not (vector-every eq? #(1 3 #f 5) #(2 4 #f 6))))

(test-exception vector-every
                (type: (0 #()) (+ 0) (+ #() 0))
                (args: 2 0))

;;;============================================================================
;;; Mutators
;;;============================================================================
;;;============================================================================
;; vector-swap!

(let ((vec #(0 1 2 3)))
  (vector-swap! vec 0 1)
  (test-assert (equal? vec #(1 0 2 3)))
  (vector-swap! vec 1 0)
  (test-assert (equal? vec #(0 1 2 3)))
  (vector-swap! vec 2 2)
  (test-assert (equal? vec #(0 1 2 3))))

(test-exception vector-swap!
                (type: (0 0 0) (+ #f 0) (+ 0 #f))
                (range: (#() -1 0) (#() 0 -1)
                        (#(0) 2 0) (#(0) 0 2))
                (args: 3 3))

;;============================================================================
;; vector-fill!

(let ((vec #(1 2 3 4)))
    (vector-fill! vec 0 2)
    (test-assert (equal? vec #(1 2 0 0)))
    (vector-fill! vec #f)
    (test-assert (equal? vec #(#f #f #f #f)))
    (vector-fill! vec 0 1 3)
    (test-assert (equal? vec #(#f 0 0 #f))))

;;============================================================================
;; vector-reverse!

(let ((vec #(0 1 2 3)))
  (vector-reverse! vec)
  (test-assert (equal? vec #(3 2 1 0)))
  (vector-reverse! vec 1)
  (test-assert (equal? vec #(3 0 1 2)))
  (vector-reverse! vec 0 2)
  (test-assert (equal? vec #(0 3 1 2)))
  (vector-reverse! vec 0 0)
  (test-assert (equal? vec #(0 3 1 2))))

(test-exception vector-reverse!
                (type: (0) (#() #f) (#() 0 #f))
                (range: (#(0 1) -1 0) (#(0 1) 0 -1)
                        (#(0 1) 3 0) (#(0 1) 0 3)
                        (#(0 1) 1 0))
                (args: 1 3))

;;============================================================================
;; vector-copy!

(let ((vec1 #(0 1 2))
      (vec2 #(#f #f #f)))
  (vector-copy! vec1 0 vec2)
  (test-assert (equal? vec1 #(#f #f #f))))

(let ((vec1 #(0 1 2))
      (vec2 #(#f #f #f)))
  (vector-copy! vec1 0 vec2 1)
  (test-assert (equal? vec1 #(#f #f 2))))

(let ((vec1 #(0 1 2 3))
      (vec2 #(#f #f #f #f)))
  (vector-copy! vec1 1 vec2 1 2)
  (test-assert (equal? vec1 #(0 #f 2 3))))

(test-exception vector-copy!
                (type: (0 0 #()) (#() #f #()) (#() 0 0)
                       (#() 0 #() #f)
                       (#() 0 #() 0 #f))
                (range: (#(0 1) 1 #(0 1))
                        (#(0 1) 0 #(0 1) 1 3)
                        (#(0 1) 0 #(0 1) 3 4)
                        (#(0 1) 0 #(0 1) 1 0))
                (args: 3 5))

;;============================================================================
;; vector-reverse-copy!

(let ((vec1 #(0 1 2))
      (vec2 #(3 4 5)))
  (vector-reverse-copy! vec1 0 vec2)
  (test-assert (equal? vec1 #(5 4 3))))

(test-exception vector-copy!
                (type: (0 0 #()) (#() #f #()) (#() 0 0)
                       (#() 0 #() #f)
                       (#() 0 #() 0 #f))
                (range: (#(0 1) 1 #(0 1))
                        (#(0 1) 0 #(0 1) 1 3)
                        (#(0 1) 0 #(0 1) 3 4)
                        (#(0 1) 0 #(0 1) 1 0))
                (args: 3 5))

;;============================================================================
;; Conversion
;;============================================================================
;;============================================================================
;; vector->list

(let ((vec #(0 1 2 3)))
  (test-assert (equal? '(0 1 2 3) (vector->list #(0 1 2 3))))
  (test-assert (equal? '(1 2) (vector->list #(0 1 2 3) 1 3))))

(test-exception vector->list
                (type: (0) (#() #f) (#() 0 #f))
                (range: (#(0 1) -1) (#(0 1) 0 -1)
                        (#(0) 2 2)  (#(0) 0 2)
                        (#(0 1 3) 2 1))
                (args: 1 3))

;;============================================================================
;; reverse-vector->list

(test-assert (equal? '(0 1 2) (reverse-vector->list #(2 1 0))))
(test-assert (equal? '(1 2) (reverse-vector->list #(3 2 1 0) 1 3)))

(test-exception reverse-vector->list
                (type:  (0) (#() #f) (#() 0 #f))
                (range: (#(0 1) -1) (#(0 1) 0 -1) (#(0 1) 3) (#(0 1 2) 2 1))
                (args: 1 3))

;;============================================================================
;; list->vector

(test-assert (equal? (list->vector '())
                     #()))

(test-assert (equal? (list->vector '(0 1))
                     #(0 1)))

(test-exception list->vector
                (type: 0)
                (args: 1 1))

;;============================================================================
;; reverse-list->vector

(test-assert (equal? (reverse-list->vector '())
                     #()))

(test-assert (equal? (reverse-list->vector '(0 1 2))
                     #(2 1 0)))

(test-exception reverse-list->vector
                (type: 0)
                (args: 1 1))

;;============================================================================
;; vector-append-subvectors

(let ((vec0 (make-vector 4 0))
      (vec1 (make-vector 4 1))
      (vec2 (make-vector 4 2)))
  (test-assert 
    (equal? (vector-append-subvectors vec0 0 2 vec1 0 2 vec2 0 2)
            #(0 0 1 1 2 2))))

(test-error-tail
  wrong-number-of-arguments-exception?
  (vector-append-subvectors))

(test-exception vector-append-subvectors
                (type: (0 0 1) (#() #f 1) (#() 0 #f) 
                       (#(0 1) 0 1 0 0 1) (#(0 1) 0 1 #() #f 1) (#(0 1) 0 1 #() 0 #f))
                (range: (#(0 1) -1 1) (#(0 1) 1 0)
                        (#(0 1) 0 1 #(0 1) -1 1) (#(0 1) 0 1 #(0 1) 1 0))
                (args: 3 0)
                (args: 6 0)
                (args: 9 0))

;;============================================================================
;; vector-cumulate

(test-assert (equal? (vector-cumulate + 0 #(1 1 1 1))
                     #(1 2 3 4)))

(test-assert (equal? 
               (vector-cumulate 
                       (lambda (a x) (if (even? a)
                                       (/ a 2)
                                       (+ (* 3 a) 1)))
                       5 #(0 0 0 0 0))
                     #(16 8 4 2 1)))

(test-exception vector-cumulate
                (type: (0 0 #()) (+ 0 #f))
                (args: 3 3))

;;============================================================================
;; vector-partition

(receive (pvect i) (vector-partition even? #())
  (test-assert (equal? pvect #()))
  (test-assert (= i 0)))

(let ((vect #(0 1 2 3 4 5 6)))
  (receive (pvect i)
           (vector-partition even? vect)
    (test-assert (equal? pvect #(0 2 4 6 1 3 5)))
    (test-assert (= i 4))))

(let ((vect #(0 1 2 3 4 5 6)))
  (receive (pvect i)
           (vector-partition (lambda (x) #f) vect)
  (test-assert (equal? pvect vect))
  (test-assert (= i 0))))

(let ((vect #(0 1 2 3 4 5 6)))
  (receive (pvect i)
           (vector-partition (lambda (x) #t) vect)
  (test-assert (equal? pvect vect))
  (test-assert (= i (vector-length vect)))))

(test-exception vector-partition
                (type: (0 #()) (+ 0))
                (args: 2 2))

;;============================================================================
;; vector->string

(test-assert (equal? (vector->string #(#\a #\b #\c #\d)) "abcd"))
(test-assert (equal? (vector->string #(#\a #\b #\c #\d) 1) "bcd"))
(test-assert (equal? (vector->string #(#\a #\b #\c #\d) 1 3) "bc"))

(test-exception vector->string
                (type: (0) (#() #f) (#() 0 #f)); (#(0 1)))
                (range: (#(#\a #\b #\c) -1 1) (#(#\a #\b #\c) 2 1))
                (args: 1 3))

;;============================================================================
;; string->vector

(test-assert (equal? (string->vector "abcd") #(#\a #\b #\c #\d)))
(test-assert (equal? (string->vector "abcd" 1) #(#\b #\c #\d)))
(test-assert (equal? (string->vector "abcd" 1 3) #(#\b #\c)))

(test-exception string->vector
                (type: (0) ("" #f) ("" 0 #f))
                (range: ("abc" -1 1) ("abc" 2 1))
                (args: 1 3))

;;;============================================================================
