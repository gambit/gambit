#!/usr/bin/env gsi-script

; File: "pi.scm", Time-stamp: <2008-12-17 13:41:08 feeley>

; Bignum benchmark that computes pi.
;
; Run it from the command line like this:  gsi pi.scm 1000

(define (pi-brent-salamin-approximate base k) ; k is number of digits

  (define base^k (expt base k))

  (define (fixed.+ x y)
    (+ x y))

  (define (fixed.- x y)
    (- x y))

  (define (fixed.* x y)
    (quotient (* x y) base^k))

  (define (fixed.square x)
    (fixed.* x x))

  (define (fixed./ x y)
    (quotient (* x base^k) y))

  (define (fixed.sqrt x)
    (integer-sqrt (* x base^k)))

  (define (number->fixed x)
    (round (* x base^k)))

  (define (fixed->number x)
    (/ x base^k))

  (let ((one (number->fixed 1)))
    (let loop ((a one)
               (b (fixed.sqrt (quotient one 2)))
               (t (quotient one 4))
               (x 1))
      (if (= a b)
          (quotient (* a a) t)
          (let ((new-a (quotient (fixed.+ a b) 2)))
            (loop new-a
                  (integer-sqrt (* a b))
                  (fixed.- t (* x (fixed.square (fixed.- new-a a))))
                  (* 2 x)))))))

(define (pi-brent-salamin base k) ; k is number of digits
  (let ((n (ceiling (inexact->exact (+ 2 (log k))))))
    (quotient (pi-brent-salamin-approximate base (+ k n)) (expt base n))))

(define (main arg)
  (let ((k (string->number arg)))
    (pretty-print (time (pi-brent-salamin 10 k)))
    0))
