;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2018-2020 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2018-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 41, Streams.

(import (srfi 41))
(import (_test))

;=========================================================================

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

(define-macro (is-eager-n? n strm)
   (if (= n 0)
       `(stream-promise (stream-car* (stream-force ,strm)))
       `(is-eager-n? ,(- n 1) (stream-cdr ,strm))))

(define-macro (is-eager? n strm)
  `(equal? 'eager
           (car (is-eager-n? ,n ,strm))))

(let ((strm (stream-cons 0 (stream-cons 1 stream-null))))
  (test-assert (not (is-eager? 0 strm)))
  (test-assert (not (is-eager? 0 strm)))
  (stream-car strm)
  (test-assert (is-eager? 0 strm)))
  
(define-macro (test-lazyness i j strm)
  `(let ((strm ,strm))
     (test-assert (not (is-eager? ,i strm)))
     (test-assert (not (is-eager? ,j strm)))
     (stream-ref strm ,j)
     (test-assert (is-eager? ,j strm))
     (test-assert (not (is-eager? ,i strm)))))

;;=========================================================================
;; PRIMITIVES
;;=========================================================================

;;; Type constuctors and predicate

;; stream?
(test-assert (not (stream? 0)))
(test-assert (stream? stream-null))
(test-assert (stream? (stream-cons 0 stream-null)))
(test-assert (stream? (stream-cons 0 
                        (stream-cons 1 
                          stream-null))))


; stream-null?
(test-assert (not (stream-null? 0)))
(test-assert (not (stream-null? 
                    (stream-cons 0 stream-null))))
(test-assert (not (stream-null? 
                    (stream-cons 0
                      (stream-cons 1 
                        stream-null)))))

(test-assert (stream-null? stream-null))


;; stream-pair?
(test-assert (not (stream-pair? 0)))
(test-assert (not (stream-pair? stream-null)))
(test-assert (stream-pair? (stream-cons 0 stream-null)))
(test-assert (stream-pair? (stream-cons 0 
                             (stream-cons 1 
                               stream-null))))

(test-number-args stream?      1 1)
(test-number-args stream-null? 1 1)
(test-number-args stream-pair? 1 1)

;;=========================================================================

;;; Accessors, types constructors

;; stream-car, stream-cdr & stream-cons
(let ((strm (stream-cons 0 stream-null)))
  (test-assert (= 0 (stream-car strm)))
  (test-assert (stream-null? (stream-cdr strm))))

;; lazyness tests

(test-lazyness 0 1 (stream-cons 0 (stream-cons 1 stream-null)))

;;=========================================================================
;; stream-lambda

(letrec* ((iter (stream-lambda (f x)
                (stream-cons x (iter f (f x)))))
          (nats (iter (lambda (x) (+ 1 x)) 0))
          (stream-add (stream-lambda (s1 s2)
                       (stream-cons (+ (stream-car s1)
                                       (stream-car s2))
                                    (stream-add (stream-cdr s1)
                                                (stream-cdr s2)))))
          (evens (stream-add nats nats)))
    (test-assert (= 0 (stream-car evens)))
    (test-assert (= 2 (stream-car 
                        (stream-cdr 
                          evens))))
    (test-assert (= 4 (stream-car
                        (stream-cdr
                          (stream-cdr 
                            evens))))))

(letrec* ((fib (stream-lambda (prec n)
              (stream-cons prec
                (fib n (+ prec n)))))
          (stream-fib (fib 1 1)))
    
    (test-assert (= 1 (stream-car stream-fib)))
    (test-assert (= 1 (stream-car 
                        (stream-cdr 
                          stream-fib))))
    (test-assert (= 2 (stream-car
                        (stream-cdr
                          (stream-cdr 
                            stream-fib)))))
    (test-assert (= 3 (stream-car
                        (stream-cdr
                          (stream-cdr
                            (stream-cdr
                              stream-fib)))))))

(letrec* ((fib (stream-lambda (prec n)
              (stream-cons prec
                (fib n (+ prec n)))))
          (stream-fib (fib 1 1)))
  (test-lazyness 0 1 stream-fib))


;;=========================================================================
;; STREAMS DERIVED LIBRARY
;;=========================================================================

(define (stream-list-compare strm lst)
  (cond ((null? lst)         #t)
        ((stream-null? strm) #f)
        ((equal? (car lst)
                 (stream-car strm))
         (stream-list-compare (stream-cdr strm)
                              (cdr lst)))
        (else #f)))

(test-assert (stream-list-compare stream-null '()))
(test-assert (stream-list-compare (stream-cons 0
                                    (stream-cons 1
                                      (stream-cons 2
                                        stream-null)))
                                  '(0 1 2)))

;;=========================================================================
;; stream (syntax)

(test-assert (stream-null? (stream)))
(test-assert (stream-list-compare (stream 0)         '(0)))
(test-assert (stream-list-compare (stream 0 1 2 3 4) '(0 1 2 3 4)))

(test-lazyness 0 1(stream 0 1))

;;=========================================================================
;; list->stream

(test-assert (stream-null? (list->stream '())))
(test-assert (stream-list-compare (list->stream '(0))       '(0)))
(test-assert (stream-list-compare (list->stream '(0 1 2 3)) '(0 1 2 3)))

(test-lazyness 0 1 (list->stream '(0 1 2)))

(test-error
  type-exception?
  (list->stream 0))

(test-number-args list->stream 1 1)

;;=========================================================================
;; stream->list

(test-assert (equal? (stream->list stream-null) '()))
(test-assert (equal? (stream->list (stream 0)) '(0)))
(test-assert (equal? (stream->list (stream 0 1 2 3)) '(0 1 2 3)))

(test-error
  type-exception?
  (stream->list 0))

(test-number-args stream->list 1 2)

;;=========================================================================
;; port->stream

(call-with-input-u8vector
  '#u8(32 33 32 33)
  (lambda (p)
    (test-assert
      (stream-list-compare
        (port->stream p)
        '(#\space #\! #\space #\!)))))

(call-with-input-u8vector
  '#u8()
  (lambda (p)
    (test-assert
      (stream-null? (port->stream p)))))

(call-with-input-u8vector
  '#u8(32 33 32 33)
  (lambda (p)
    (test-lazyness 0 1
        (port->stream p))))

(test-error
  type-exception?
  (port->stream 0))

(test-number-args port->stream 0 1)

;;=========================================================================
;; stream-append

(let* ((lst0 '())
       (lst1 '(0 1 2 3))
       (lst2 '(4 5 6 7))
       (lsta0 (append lst1 lst0)) 
       (lsta1 (append lst1 lst2)))

  (test-assert (stream-list-compare (stream-append (list->stream lst1)
                                          (list->stream lst2))
                                    lsta1))
  (test-assert (stream-list-compare (stream-append (list->stream lst1)
                                                   (list->stream lst0))
                                    lsta0)))


(test-lazyness 0 1 (stream-append (stream 0)
                              (stream 1)))

(test-error
  type-exception?
  (stream-append 0))

(test-error
  type-exception?
  (stream-append (stream) 0))


;;=========================================================================
;; stream-concat

(let ((strm0 stream-null)
      (strm1 (stream 0 1 2))
      (strm2 (stream 3 4 5)))
  (test-assert (stream-list-compare 
                 (stream-concat (stream strm1 strm2 strm0))
                 '(0 1 2 3 4 5))))

(test-lazyness 2 3(stream-concat (stream (stream 0 1)
                                      (stream 1 2))))

(test-error
  type-exception?
  (stream-concat 0))

(test-error
  type-exception?
  (stream-concat (stream 0)))

(test-error
  type-exception?
  (stream-concat (stream (stream 0) 0)))

(test-number-args stream-concat 1 1)

;;=========================================================================
;; stream-constant

(test-assert (stream-list-compare 
               (stream-constant 0)
               '(0 0 0 0 0 0)))

(test-assert (stream-list-compare 
               (stream-constant 0 1)
               '(0 1 0 1 0 1 0)))

(test-assert (stream-null?
               (stream-constant)))

(test-lazyness 0 1 (stream-constant 0))

;;=========================================================================
;; stream-drop

(test-assert
  (stream-list-compare
    (stream-drop 1 (stream 0 1 2 3 4 5))
    '(1 2 3 4 5)))

(test-assert 
  (stream-list-compare
    (stream-drop 0 (stream 0 1 2))
    '(0 1 2 )))

(test-assert
  (stream-list-compare
    (stream-drop 5 (stream 0))
    '()))

(test-assert
  (stream-list-compare
    (stream-drop 5 (stream))
    '()))

(test-lazyness 0 1 (stream-drop 2 (stream 0 1 2 3 4)))

(test-error
  type-exception?
  (stream-drop #f (stream)))

(test-error
  type-exception?
  (stream-drop 1 0))

(test-error-tail
  range-exception?
  (stream-drop -1 (stream 0 1 2)))

(test-number-args stream-drop 2 2)

;;=========================================================================
;; stream-drop-while

(test-assert 
  (stream-list-compare
    (stream-drop-while (lambda (x) (> 2 x))
                       (stream 0 1 2 3))
    '(2 3)))

(test-assert
  (stream-list-compare
    (stream-drop-while (lambda (x) #f)
                       (stream 0 1 2 3))
    '(0 1 2 3)))

; first element of the output stream should be already evaluated
(test-lazyness 1 2 (stream-drop-while (lambda (x) (not x))
                                  (stream #f #f 0 1 2 3)))

(test-error
  type-exception?
  (stream-drop-while 0 (stream)))

(test-error
  type-exception?
  (stream-drop-while (lambda () '()) 0))

(test-number-args stream-drop-while 2 2)

;;=========================================================================
;; stream-filter

(test-assert
  (stream-list-compare
    (stream-filter (lambda (x) (zero? (modulo x 2)))
                   (stream-constant 1 2 3 4))
    '(2 4 2 4 2 4 2 4 2)))

(test-lazyness 0 1 (stream-filter (lambda (x) x)
                                    (stream #f 0 #f 1)))

(test-error
  type-exception?
  (stream-filter 0 (stream)))

(test-error
  type-exception?
  (stream-filter (lambda () '()) 0))


(test-number-args stream-filter 2 2)

;;=========================================================================
;; stream-fold

(test-assert (= 5 (stream-fold (lambda (x a) (+ x a))
                               0
                               (stream 1 1 1 1 1))))


(test-assert (= 0 (stream-fold (lambda (x a) (+ x a))
                                         0
                                         (stream))))

(test-error
  type-exception?
  (stream-fold 0 0 (stream)))

(test-error
  type-exception?
  (stream-fold (lambda () '()) 0 0))

(test-number-args stream-fold 3 3)

;;=========================================================================
;; stream-for-each

(let ((acc '()))
  (stream-for-each
    (lambda (x) (set! acc (cons 1 acc)))
    (stream 1 2 3 4 5))
        (test-assert 
          (equal? 
            acc 
            '(1 1 1 1 1))))

(let ((acc '()))
        (stream-for-each
          (lambda (x y) (set! acc (cons (+ x y) acc)))
          (stream 1 1 1 1 1)
          (stream 1 1 1 1 1))
        (test-assert 
          (equal? 
            acc 
            '(2 2 2 2 2))))

(let ((acc #t))
  (stream-for-each
    (lambda (x) (set! acc #f))
    stream-null)
  (test-assert acc))

(test-error
  type-exception?
  (stream-for-each 0 (stream)))

(test-error
  type-exception?
  (stream-for-each (lambda () '()) 0))

(test-number-args stream-for-each 2 0)

;;=========================================================================
;; stream-from

(test-assert (stream-list-compare 
               (stream-from 0 1)
               '(0 1 2 3 4 5 6)))

(test-assert (stream-list-compare 
               (stream-from 0)
               '(0 1 2 3 4 5 6)))

(test-assert (stream-list-compare 
               (stream-from 0.1 0.3)
               '(0.1 0.4 0.7 1. 1.3)))

(test-assert (stream-list-compare 
               (stream-from 0 -1)
               '(0 -1 -2 -3 -4 -5 -6)))

(test-error
  type-exception?
  (stream-from #f 0))

(test-error
  type-exception?
  (stream-from 0 #f))

(test-number-args stream-from 1 2)

;;=========================================================================
;; stream-iterate

(test-assert 
  (stream-list-compare
    (stream-iterate 
                 (lambda (x) (* x x))
                 2)
    '(2 4 16 256)))

(test-assert 
  (stream-list-compare
    (stream-iterate 
                 (lambda (x) #f)
                 2)
    '(2 #f #f #f #f #f)))

(test-error
  type-exception?
  (stream-iterate 0 0))

(test-number-args stream-iterate 2 2)

;;=========================================================================
;; stream-length

(test-assert (= 0 (stream-length stream-null)))
(test-assert (= 1 (stream-length (stream-cons 0 stream-null))))
(test-assert (= 4 (stream-length (stream 0 1 2 3))))

(test-error
  type-exception?
  (stream-length 0))

(test-number-args stream-length 1 1)

;;=========================================================================
;; stream-let

(test-assert 
  (stream-list-compare
    (stream-let loop ((strm (stream 0 1 2 3)))
      (if (stream-null? strm)
          stream-null
          (stream-cons (stream-car strm)
                       (loop (stream-cdr strm)))))
    '(0 1 2 3)))

(test-lazyness 0 1
  (stream-let loop ((b #t))
                (if b (stream-cons 0
                                  (loop #f))
                    (stream-cons 1 stream-null))))

;;=========================================================================
;; stream-map

(test-assert (stream-list-compare
               (stream-map (lambda (x) (* x x))
                           (stream 0 1 2 3 4))
               '(0 1 4 9 16)))

(test-assert (stream-list-compare
               (stream-map (lambda (x y) (* x y))
                           (stream 0 1 2 3 4)
                           (stream 0 1 2 3 4))
               '(0 1 4 9 16)))

(test-lazyness 0 1 (stream-map (lambda (x y) (* x y))
                               (stream 0 1 2)
                               (stream 0 1 2)))

(test-error
  type-exception?
  (stream-map 0 (stream)))

(test-error
 type-exception?
  (stream-map (lambda () '()) 0))

(test-error
 type-exception?
  (stream-map (lambda () '()) (stream) 0))

(test-number-args stream-map 2 0)

;;=========================================================================
;; stream-match

(test-assert
  (stream-match 
    (stream 0 1 2)
      (a #t)))

(test-assert
  (stream-match 
    (stream 0 1 2)
      ((a b c) #t)
      (a #f)))

(test-assert
  (stream-match 
    (stream 0 1 2)
      (a #t)
      ((a b c) #f)))

(test-assert
  (stream-match 
    (stream 0 1 2)
      (a #f #f)
      ((a b c) #t)))

(test-assert
  (stream-match 
    (stream 0 1 2)
      (a (= (stream-car a) 0) #t)))

(test-assert
  (stream-match 
    (stream 0 1 2 3)
      (_ #t)))

(test-assert
  (stream-match 
    (stream 0 1 2)
      (_ #t)
      ((a b c) #f)))

(test-assert
  (stream-match 
    (stream 0 1 2)
      ((a b c) #t)
      (_ #f)))

(test-assert
  (stream-match 
    (stream 0 1 2)
      (_ #f #f)
      ((a b c) #t)))

(test-error
  unbound-global-exception?
  (stream-match
    (stream 0 1 2 3)
    (_ (= (stream-car _) 0) #t)))

(test-assert
  (stream-match
    (stream 0 1 2 3)
      ((a b c d) (= b 1) #t)
      (_ #f)))

(test-error
  unbound-global-exception?
  (stream-match
    (stream 0 1 2 3)
    ((_ b c d) (= _ 0) #t)))

;;=========================================================================
;; stream-of

(test-assert
  (stream-list-compare
    (stream-of (* x x)
      (x in (stream-range 0 5)))
    '(0 1 4 9 16)))

(test-assert
  (stream-list-compare
    (stream-of (* x x)
      (x in (stream-range 0 5))
      (even? x))
    '(0 4 16)))

(test-assert
  (stream-list-compare
    (stream-of (* x x)
      (y is 2)
      (x in (stream-range 0 5))
      (even? y))
    '(0 1 4 9 16)))

(test-lazyness 0 1 
  (stream-of (* x x)
             (x in (stream-range 0 5))))

(test-assert
  (stream-null?
    (stream-of (* x x)
      (x in (stream-range 0 5))
      (even? x)
      (odd? x))))

;;=========================================================================
;; stream-range

(test-assert (stream-list-compare
               (stream-range 0 10 2)
               '(0 2 4 6 8)))

(test-assert (stream-list-compare
               (stream-range 10 0 -2)
               '(10 8 6 4 2)))

(test-assert (stream-list-compare
               (stream-range 0 6)
               '(0 1 2 3 4 5)))

(test-assert (stream-list-compare
               (stream-range 6 0)
               '(6 5 4 3 2 1)))

(test-assert (stream-list-compare
               (stream-range 0 0)
             '()))

(test-assert (stream-list-compare
               (stream-range 0 0 1)
               '()))

(test-assert (stream-list-compare
               (stream-range 0 0 -1)
               '()))

(test-lazyness 0 1(stream-range 0 5))

(test-error
  range-exception?
  (stream-range 10 0 2))

(test-error
  range-exception?
  (stream-range 0 10 -2))

(test-error
  type-exception?
  (stream-range #f 0 0))

(test-error
  type-exception?
  (stream-range 0 #f 0))

(test-error
  type-exception?
  (stream-range 0 0 #f))

(test-number-args stream-range 2 3)

;;=========================================================================
;; stream-ref

(test-assert (= (stream-ref (stream 0 1 2 3) 0)
                0))

(test-assert (= (stream-ref (stream 0 1 2 3) 3)
                3))

(test-error
  range-exception?
  (stream-ref (stream 0 1 2) 4))

(test-error
  range-exception?
  (stream-ref (stream 0 1 2) -4))

(test-error
  type-exception?
  (stream-ref 0 0))

(test-error
  type-exception?
  (stream-ref (stream) #f))

(test-number-args stream-ref 2 2)

;;=========================================================================
;; stream-reverse

(let ((lst1 '(0 1 2 3 4)))
  (test-assert (stream-list-compare
                 (stream-reverse (list->stream lst1))
                 (reverse lst1))))

(test-assert (stream-list-compare
               (stream-reverse stream-null)
               '()))

(test-lazyness 0 1 (stream-reverse (stream 0 1)))

(test-error
  type-exception?
 (stream-reverse 0))

(test-number-args stream-reverse 1 1)

;;=========================================================================
;; stream-scan

(test-assert (stream-list-compare
               (stream-scan + 0 (stream 1 2 3))
               '(0 1 3 6))) ; 0, 0+1, 0+1+2, ...

(test-assert (stream-list-compare
               (stream-scan + 0 (stream))
               '(0)))

(test-lazyness 0 1 (stream-scan + 0 (stream 0 1 2)))

(test-error
  type-exception?
  (stream-scan 0 0 (stream)))

(test-error
  type-exception?
  (stream-scan (lambda () '()) 0 0))

(test-number-args stream-scan 3 3)

;;=========================================================================
;; stream-take

(test-assert (stream-list-compare
               (stream-take 3 (stream 0 1 2 3))
               '(0 1 2)))
(test-assert (stream-list-compare
               (stream-take 0 (stream 0 1 2 3))
               '()))

(test-lazyness 0 1 (stream-take 3 (stream 0 1 2 3)))

(test-error
  range-exception?
  (stream-take -2 (stream 0 1)))

(test-error
  type-exception?
  (stream-take #f (stream)))

(test-error
  type-exception?
  (stream-take 0 0))

(test-number-args stream-take 2 2)

;;=========================================================================
;; stream-take-while

(test-assert (stream-list-compare
               (stream-take-while (lambda (x) (< x 5))
                                  (stream 0 1 2 3 4 5))
               '(0 1 2 3 4)))

(test-assert (stream-null? 
               (stream-take-while (lambda (x) #f)
                                  (stream 0 1 2 3 4 5))))

(test-lazyness 0 1
  (stream-take-while (lambda (x) (< x 2))
                       (stream 0 1 2 3 4 5)))

(test-error
  type-exception?
  (stream-take-while 0 (stream)))

(test-error
  type-exception?
  (stream-take-while (lambda () '()) 0))

(test-number-args stream-take-while 2 2)

;;=========================================================================
;; stream-unfold

(test-assert (stream-list-compare
               (stream-unfold
                 (lambda (x) (* x x))
                 (lambda (x) (< x 7))
                 (lambda (x) (+ x 1))
                 0)
               '(0 1 4 9 16 25 36)))

(test-lazyness 0 1
  (stream-unfold
    (lambda (x) (* x x))
    (lambda (x) (< x 7))
    (lambda (x) (+ x 1))
    0))


(test-error
  type-exception?
  (stream-unfold 0 (lambda () 0) (lambda () 0) 0))

(test-error
  type-exception?
  (stream-unfold (lambda () 0) 0 (lambda () 0) 0))

(test-error
  type-exception?
  (stream-unfold (lambda () 0) (lambda () 0) 0 0))

(test-number-args stream-unfold 4 4)
 
;;=========================================================================
;; stream-unfolds

(call-with-values
  (lambda ()
    ((lambda (strm)
      (stream-unfolds
        (lambda (strm)
          (if (stream-null? strm)
              (values strm '() '())
              (let ((a (stream-car strm))
                    (d (stream-cdr strm)))
                (if (odd? a)
                    (values d (list a) #f)
                    (values d #f (list a))))))
        strm))
     (stream-range 1 6)))
  (lambda (odds evens)
    (test-lazyness 0 1 odds)
    (test-lazyness 0 1 evens)
    (test-assert
      (equal? 
        (list (stream->list odds)
          (stream->list evens))
        '((1 3 5) (2 4))))))

(test-error
  type-exception?
  (stream-unfolds 0 0))

(test-number-args stream-unfolds 2 2)

;;=========================================================================
;; stream-zip

(test-assert (stream-list-compare
               (stream-zip
                 (stream 0 1 2 3)
                 (stream 'a 'b 'c 'd))
               '((0 a) (1 b) (2 c) (3 d))))

(test-assert (stream-list-compare
               (stream-zip
                 (stream 0 1 2 3 4)
                 (stream))
               '()))

(test-lazyness 0 1 (stream-zip (stream 0 1)
                               (stream 0 1)))
(test-error
  type-exception?
  (stream-zip 0))

(test-error
  type-exception?
  (stream-zip (stream 0) 0))

(test-number-args stream-zip 1 0)

;;;=========================================================================
