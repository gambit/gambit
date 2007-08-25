; File: "mem.scm", Time-stamp: <2007-04-04 11:40:14 feeley>

; Copyright (c) 1996-2007 by Marc Feeley, All Rights Reserved.

; Test program for Gambit-C's memory management system.

;------------------------------------------------------------------------------

; Utilities:

; pseudo-random number generator

(define seed #f)

(define (reset-random)
  (set! seed 1923202963))

(define (random n)
  (let* ((hi (quotient seed 44488))
         (lo (remainder seed 44488))
         (test (- (* lo 48271) (* hi 3399))))
    (set! seed (if (> test 0) test (+ test 2147483647)))
    (modulo seed n)))

; repetition of an evaluation

(define (repeat n thunk)
  (let loop ((i n))
    (if (> i 0)
      (begin
        (thunk)
        (loop (- i 1))))))

(define gc-reports? #t)

(define (setup-gc-reports)
  (gc-report-set! gc-reports?))

(define (trigger-gc)
  (##gc))

;------------------------------------------------------------------------------

; Test #1
;
; Allocate and deallocate medium size objects and large objects.  The
; GC reports show that movable and non-movable objects are allocated
; and reclaimed.

(define (test1)

  (setup-gc-reports)

  (reset-random)

  (trigger-gc)

  (let* ((n 4)
         (v (make-vector n #f)))

    (repeat
      200
      (lambda ()
        (let ((i (random n))
              (size (if (= 0 (random 2)) 1000 35000)))
          (vector-set! v i (make-vector size))))))

  (trigger-gc))

;------------------------------------------------------------------------------

; Test #2
;
; Allocate and deallocate medium size objects and large objects.  The
; GC reports show that movable and non-movable objects are allocated
; and reclaimed.

(define (test2)

  (setup-gc-reports)

  (reset-random)

  (trigger-gc)

  (set! test2-data '())

  ; allocate roughly 1 MB of data

  (repeat
    10
    (lambda ()
      (set! test2-data
        (cons (make-vector (if (= 0 (random 2)) 1000 35000))
              test2-data))))

  (idle)

  ; release roughly .5 MB of data

  (repeat
    5
    (lambda ()
      (set! test2-data (cdr test2-data))))

  (idle)

  ; allocate roughly 1 MB more

  (repeat
    10
    (lambda ()
      (set! test2-data
        (cons (make-vector (if (= 0 (random 2)) 1000 35000))
              test2-data))))

  (idle)

  ; release it all

  (set! test2-data #f)

  (trigger-gc))

(define test2-data #f)

(define (idle)
  (let loop ((i 20))
    (if (> i 0)
      (begin
        (make-vector (if (= 0 (random 2)) 1000 35000))
        (loop (- i 1))))))

;------------------------------------------------------------------------------

; Test #3
;
; Show how to recover from heap overflows.
;
; Note: make sure you specify a heap size limit when you start the
; compiler or interpreter, otherwise it may take a long time before
; the virtual memory is exhausted.

(define (test3)

  (setup-gc-reports)

  (trigger-gc)
  (test3-helper 10)      ; this call should terminate normally
  (test3-helper 1000000) ; this one will cause a heap overflow
  (test3-helper 10)      ; this call should terminate normally
)

(define (test3-helper n)
  (reset-random)
  (let ((action
          (call-with-current-continuation
            (lambda (abort)
              (with-exception-handler
                (lambda (exc)
                  (abort
                    (lambda ()
                      (trigger-gc) ; clean up heap and recover overflow reserve
                      (display "caught exception ")
                      (write exc)
                      (newline))))
                (lambda ()
                  (let ((data (create-big-set-of-data n)))
                    (lambda ()
                      (trigger-gc)
                      (write (map vector? data))
                      (newline)))))))))
    (action)))

(define (create-big-set-of-data n)
  (let loop ((lst '()) (i n))
    (if (> i 0)
     (loop
        (cons (case (random 6)
                ((0)  (make-string (random 80000)))
                ((1)  (make-vector (random 40000)))
                ((2)  (cons lst lst))
                ((3)  (gensym))
                ((4)  (lambda (x) lst))
                (else (* 1.23 (random 100))))
              lst)
        (- i 1))
     lst)))

;------------------------------------------------------------------------------

; Test #4
;
; Show how to recover from stack overflows.
;
; Note: make sure you specify a heap size limit when you start the
; compiler or interpreter, otherwise it may take a long time before
; the virtual memory is exhausted.

(define (test4)

  (setup-gc-reports)

  (trigger-gc)
  (test4-helper 10)      ; this call should terminate normally
  (test4-helper 1000000) ; this one will cause a heap overflow
  (test4-helper 10)      ; this call should terminate normally
)

(define (test4-helper n)
  (reset-random)
  (let ((action
          (call-with-current-continuation
            (lambda (abort)
              (with-exception-handler
                (lambda (exc)
                  (abort
                    (lambda ()
                      (trigger-gc) ; clean up heap and recover overflow reserve
                      (display "caught exception ")
                      (write exc)
                      (newline))))
                (lambda ()
                  (let ((data (deeply-nested-computation n)))
                    (lambda ()
                      (trigger-gc)
                      (write (map even? data))
                      (newline)))))))))
    (action)))

(define (deeply-nested-computation n)
  (if (> n 0)
    (cons n (deeply-nested-computation (- n 1)))
    '()))

;------------------------------------------------------------------------------

; Test #5
;
; Allocation of Scheme objects from C.

(c-declare "

#include <math.h>

static ___SCMOBJ obj1, obj2, obj3, obj4, obj5; /* some Scheme objects */

void foo (double x, int n, int (*f)(char*))
{
  ___EXT(___DOUBLE_to_SCMOBJ) (___CLIBEXT(sqrt) (x), &obj1, 0);
  obj2 = ___EXT(___make_vector) (n, obj1, ___STILL);
  ___EXT(___CHARSTRING_to_SCMOBJ) (\"hello world!\", &obj3, 0);
  ___EXT(___CHARSTRING_to_SCMOBJ) (\"another string\", &obj4, 0);
  obj5 = ___EXT(___make_pair) (obj2, obj3, ___STILL);
  ___EXT(___still_obj_refcount_dec) (obj1); /* no direct need for obj1, etc */
  ___EXT(___still_obj_refcount_dec) (obj2);
  ___EXT(___still_obj_refcount_dec) (obj3);
  f (\"was called from C\");
}

___SCMOBJ bar ()
{
  return obj4;
}

___SCMOBJ baz ()
{
  ___EXT(___still_obj_refcount_dec) (obj5);
  return obj5;
}
")

(c-define-type real double)
(c-define-type integer int)

(define foo (c-lambda (real integer (function (char-string) int)) void "foo"))
(define bar (c-lambda () scheme-object "bar"))
(define baz (c-lambda () scheme-object "baz"))

(c-define (hop str) (char-string) int "hop" ""
  (write (list 'hop str))
  (newline)
  (string-length str))

(define (test5)

  (setup-gc-reports)

  (trigger-gc)

  (hop "was called from Scheme")

  (let ()
    (declare (standard-bindings) (not safe) (flonum)) ; inline "sqrt"
    (foo (sqrt (##first-argument .0625)) 5 hop)) ; create objects from C

  (trigger-gc) ; they will show up as "not movable" objects in the GC report

  (let ((x (bar))) ; get obj4 from C

    (trigger-gc) ; no problem if a GC happens here

    (write x)
    (newline))

  (trigger-gc)

  (let ((y (baz)))

    (trigger-gc)

    (write y)
    (newline))

  (trigger-gc)) ; at this point, only obj4 is not reclaimed (because refcount != 0)

;------------------------------------------------------------------------------

; Test #6
;
; Finalization test.

(define (test6)

  (setup-gc-reports)

  (reset-random)

  (trigger-gc)
  (trigger-gc)

  (let* ((n 100)
         (v (make-vector n #f))
         (c 0)
         (expect 0)
         (result 0))

    (define (new x)
      (let ((obj
             (case (random 8)
               ((0)
                (make-string (random 10)))
               ((1)
                (make-vector (random 10) x))
               ((2)
                (cons x x))
               ((3)
                (gensym))
               ((4)
                (lambda (y) x))
               ((5)
                (make-will (cons x x) (lambda (o) #f)))
               ((6)
                (let ((id c))
                  (set! expect (+ expect id))
                  (set! c (+ c 1))
                  (make-will (make-vector (random 40000))
                             (lambda (o) (set! result (+ result id))))))
               (else
                (+ 1.23 (random 100))))))
        (if (= (random 2) 0)
          (make-will obj (lambda (o) #f))
          (let ((id c))
            (set! expect (+ expect id))
            (set! c (+ c 1))
            (make-will obj
                       (lambda (o) (set! result (+ result id))))))
        obj))

    (repeat
      2000
      (lambda ()
        (let ((i (random n)))
          (vector-set! v i (new (vector-ref v (random n)))))))

    (set! v #f)

    (write '(final-gc))
    (newline)

    (trigger-gc)

    (write expect)
    (newline)

    (write result)
    (newline)

    (trigger-gc)))

;------------------------------------------------------------------------------

; Test #7
;
; Finalization test.

(define (test7)

  (define (printer name)
    (lambda (o)
      (display "===> calling the action procedure for object ")
      (display name)
      (display " = ")
      (write o)
      (newline)))

  (define (gc)
    (display "--------------------------------------- GC")
    (newline)
    (trigger-gc))

  (let* ((obj1 (list 'obj1))
         (obj2 (list 'obj2))
         (obj3 (list 'obj3))
         (obj4 (list 'obj4 (make-will (list 'obj4) (lambda (o) #f))))
         (obj5 (list 'obj5 (make-will (list 'obj5) (lambda (o) #f))))
         (obj6 (list 'obj6 (make-will (list 'obj6) (lambda (o) #f))))
         (obj7 (list 'obj7 (make-will (list 'obj7) (lambda (o) #f))))
         (obj8 (list 'obj8 (make-will (list 'obj8) (lambda (o) #f))))
         (obj9 (vector 1 2 3 4 5)))

    (let* ((will1 (make-will obj1 (lambda (o) #f)))
           (will2 (make-will obj2 (printer 'obj2)))
           (will3 (make-will obj3 (lambda (o) #f)))
           (will4 (make-will obj4 (printer 'obj4)))
           (will5 (make-will obj5 (lambda (o) #f)))
           (will6 (make-will obj6 (printer 'obj6)))
           (will7 (make-will obj7 (lambda (o) #f)))
           (will8 (make-will obj8 (printer 'obj8))))

      (define (print-testators)

        (define (print name will)
          (display "(will-testator ")
          (display name)
          (display ") = ")
          (write (will-testator will))
          (newline))

        (print 'will1 will1)
        (print 'will2 will2)
        (print 'will3 will3)
        (print 'will4 will4)
        (print 'will5 will5)
        (print 'will6 will6)
        (print 'will7 will7)
        (print 'will8 will8))

      (let ((obj obj9)
            (p (printer 'obj9)))
        (make-will obj
                   (lambda (o) (p o) (set! obj9 o)))) ; resurect object

      (setup-gc-reports)

      (gc)
      (gc)

      (print-testators)

      (gc)

      (print-testators)

      (set! obj1 123)

      (gc)

      (print-testators)

      (set! obj2 123)
      (set! obj3 123)
      (set! obj4 123)
      (set! obj5 123)
      (set! obj6 123)
      (set! obj7 123)

      (gc)

      (print-testators)

      (set! obj8 123)
      (set! obj9 123)

      (pretty-print obj9)

      (gc)

      (print-testators)

      (pretty-print obj9)

      (gc)
      (gc))))

;------------------------------------------------------------------------------

(define (test-all)
  (set! gc-reports? #f)
  (test1)
  (test2)
  (test3)
  (test4)
  (test5)
  (test6)
  (test7)
  (pretty-print 'all-tests-done))

(test-all)
(exit)
