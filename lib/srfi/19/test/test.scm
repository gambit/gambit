;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 19, Time Data Types and Procedures

(import (srfi 19))
(import (_test))

(println (date->string (current-date)))

;;;============================================================================

;; The rest of this file is the file srfi-19-test-suite.scm found at
;;
;; https://github.com/srfi-explorations/final-srfis/tree/master/010/srfi-19

;;;============================================================================

;;; simple test procedures


(define s19-tests (list))

(define (define-s19-test! name thunk)
  (let ((name (if (symbol? name) name (string->symbol name)))
        (pr (assoc name s19-tests)))
    (if pr
        (set-cdr! pr thunk)
        (set! s19-tests (append s19-tests (list (cons name thunk)))))))

(define (run-s19-test name thunk verbose)
  (if verbose (begin (display ";;; Running ") (display name)))
  (let ((result (thunk)))
    (if verbose (begin (display ": ") (display (not (not result))) (newline)))
    result))

(define (run-s19-tests . verbose)
  (let ((runs 0) (goods 0) (bads 0) (verbose (if (cdr verbose) (cdr verbose) #f)))
    (for-each (lambda (pr)
                (set! runs (+ runs 1))
                (if (run-s19-test (car pr) (cdr pr) verbose)
                    (set! goods (+ goods 1))
                    (set! bads (+ bads 1))))
              s19-tests)
    (if verbose
        (begin
          (display ";;; Results: Runs: ")
          (display runs)
          (display "; Goods: ")
          (display goods)
          (display "; Bads: ")
          (display bads)
          (if (> runs 0)
              (begin
                (display "; Pass rate: ")
                (display (/ goods runs)))
              (display "; No tests."))
          (newline)))
    (values runs goods bads)))

(set! s19-tests (list))

(define-s19-test! "Creating time structures"
  (lambda ()
    (not (null? (list (current-time 'time-tai)
                      (current-time 'time-utc)
                      (current-time 'time-monotonic)
                      (current-time 'time-thread)
                      (current-time 'time-process))))))

(define-s19-test! "Testing time resolutions"
  (lambda ()
    (not (null? (list (time-resolution 'time-tai)
                      (time-resolution 'time-utc)
                      (time-resolution 'time-monotonic)
                      (time-resolution 'time-thread)
                      (time-resolution 'time-process))))))

(define-s19-test! "Time comparisons (time=?, etc.)"
  (lambda ()
    (let ((t1 (make-time 'time-utc 0 1))
          (t2 (make-time 'time-utc 0 1))
          (t3 (make-time 'time-utc 0 2))
          (t11 (make-time 'time-utc 1001 1))
          (t12 (make-time 'time-utc 1001 1))
          (t13 (make-time 'time-utc 1001 2))
          )
      (and (time=? t1 t2)
           (time>? t3 t2)
           (time<? t2 t3)
           (time>=? t1 t2)
           (time>=? t3 t2)
           (time<=? t1 t2)
           (time<=? t2 t3)
           (time=? t11 t12)
           (time>? t13 t12)
           (time<? t12 t13)
           (time>=? t11 t12)
           (time>=? t13 t12)
           (time<=? t11 t12)
           (time<=? t12 t13)
           ))))

(define-s19-test! "Time difference"
  (lambda ()
    (let ((t1 (make-time 'time-utc 0 3000))
          (t2 (make-time 'time-utc 0 1000))
          (t3 (make-time 'time-duration 0 2000))
          (t4 (make-time 'time-duration 0 -2000)))
      (and
       (time=? t3 (time-difference t1 t2))
       (time=? t4 (time-difference t2 t1))))))


(define (test-one-utc-tai-edge utc tai-diff tai-last-diff)
  (let* (;; right on the edge they should be the same
         (utc-basic (make-time 'time-utc 0 utc))
         (tai-basic (make-time 'time-tai 0 (+ utc tai-diff)))
         (utc->tai-basic (time-utc->time-tai utc-basic))
         (tai->utc-basic (time-tai->time-utc tai-basic))
         ;; a second before they should be the old diff
         (utc-basic-1 (make-time 'time-utc 0 (- utc 1)))
         (tai-basic-1 (make-time 'time-tai 0 (- (+ utc tai-last-diff) 1)))
         (utc->tai-basic-1 (time-utc->time-tai utc-basic-1))
         (tai->utc-basic-1 (time-tai->time-utc tai-basic-1))
         ;; a second later they should be the new diff
         (utc-basic+1 (make-time 'time-utc 0 (+ utc 1)))
         (tai-basic+1 (make-time 'time-tai 0 (+ (+ utc tai-diff) 1)))
         (utc->tai-basic+1 (time-utc->time-tai utc-basic+1))
         (tai->utc-basic+1 (time-tai->time-utc tai-basic+1))
         ;; ok, let's move the clock half a month or so plus half a second
         (shy (* 15 24 60 60))
         (hs (/ (expt 10 9) 2))
         ;; a second later they should be the new diff
         (utc-basic+2 (make-time 'time-utc hs (+ utc shy)))
         (tai-basic+2 (make-time 'time-tai hs (+ (+ utc tai-diff) shy)))
         (utc->tai-basic+2 (time-utc->time-tai utc-basic+2))
         (tai->utc-basic+2 (time-tai->time-utc tai-basic+2))
         )
    (and (time=? utc-basic tai->utc-basic)
         (time=? tai-basic utc->tai-basic)
         (time=? utc-basic-1 tai->utc-basic-1)
         (time=? tai-basic-1 utc->tai-basic-1)
         (time=? utc-basic+1 tai->utc-basic+1)
         (time=? tai-basic+1 utc->tai-basic+1)
         (time=? utc-basic+2 tai->utc-basic+2)
         (time=? tai-basic+2 utc->tai-basic+2) 
         )))

(define-s19-test! "TAI-UTC Conversions"
  (lambda ()
    (and
     (test-one-utc-tai-edge 915148800  32 31)
     (test-one-utc-tai-edge 867715200  31 30)
     (test-one-utc-tai-edge 820454400  30 29)
     (test-one-utc-tai-edge 773020800  29 28)
     (test-one-utc-tai-edge 741484800  28 27)
     (test-one-utc-tai-edge 709948800  27 26)
     (test-one-utc-tai-edge 662688000  26 25)
     (test-one-utc-tai-edge 631152000  25 24)
     (test-one-utc-tai-edge 567993600  24 23)
     (test-one-utc-tai-edge 489024000  23 22)
     (test-one-utc-tai-edge 425865600  22 21)
     (test-one-utc-tai-edge 394329600  21 20)
     (test-one-utc-tai-edge 362793600  20 19)
     (test-one-utc-tai-edge 315532800  19 18)
     (test-one-utc-tai-edge 283996800  18 17)
     (test-one-utc-tai-edge 252460800  17 16)
     (test-one-utc-tai-edge 220924800  16 15)
     (test-one-utc-tai-edge 189302400  15 14)
     (test-one-utc-tai-edge 157766400  14 13)
     (test-one-utc-tai-edge 126230400  13 12)
     (test-one-utc-tai-edge 94694400   12 11)
     (test-one-utc-tai-edge 78796800   11 10)
     (test-one-utc-tai-edge 63072000   10 0)
     (test-one-utc-tai-edge 0   0 0) ;; at the epoch
     (test-one-utc-tai-edge 10   0 0) ;; close to it ...
     (test-one-utc-tai-edge 1045789645 32 32) ;; about now ...
     )))

(define (tm:date= d1 d2)
  (and (= (date-year d1) (date-year d2))
       (= (date-month d1) (date-month d2))
       (= (date-day d1) (date-day d2))
       (= (date-hour d1) (date-hour d2))
       (= (date-second d1) (date-second d2))
       (= (date-nanosecond d1) (date-nanosecond d2))
       (= (date-zone-offset d1) (date-zone-offset d2))))

(define-s19-test! "TAI-Date Conversions"
  (lambda ()
    (and
     (tm:date= (time-tai->date (make-time time-tai 0 (+ 915148800 29)) 0)
               (make-date 0 58 59 23 31 12 1998 0))
     (tm:date= (time-tai->date (make-time time-tai 0 (+ 915148800 30)) 0)
               (make-date 0 59 59 23 31 12 1998 0))
     (tm:date= (time-tai->date (make-time time-tai 0 (+ 915148800 31)) 0)
               (make-date 0 60 59 23 31 12 1998 0))
     (tm:date= (time-tai->date (make-time time-tai 0 (+ 915148800 32)) 0)
               (make-date 0 0 0 0 1 1 1999 0)))))

(define-s19-test! "Date-UTC Conversions"
  (lambda ()
    (and
     (time=? (make-time time-utc 0 (- 915148800 2))
             (date->time-utc (make-date 0 58 59 23 31 12 1998 0)))
     (time=? (make-time time-utc 0 (- 915148800 1))
             (date->time-utc (make-date 0 59 59 23 31 12 1998 0)))
     ;; yes, I think this is acutally right.
     (time=? (make-time time-utc 0 (- 915148800 0))
             (date->time-utc (make-date 0 60 59 23 31 12 1998 0)))
     (time=? (make-time time-utc 0 (- 915148800 0))
             (date->time-utc (make-date 0 0 0 0 1 1 1999 0)))
     (time=? (make-time time-utc 0 (+ 915148800 1))
             (date->time-utc (make-date 0 1 0 0 1 1 1999 0))))))

(define-s19-test! "TZ Offset conversions"
  (lambda ()
    (let ((ct-utc (make-time time-utc 6320000 1045944859))
          (ct-tai (make-time time-tai 6320000 1045944891))
          (cd (make-date 6320000 19 14 15 22 2 2003 -18000)))
      (and
       (time=? ct-utc (date->time-utc cd))
       (time=? ct-tai (date->time-tai cd))))))

(begin (newline) (run-s19-tests #t))

