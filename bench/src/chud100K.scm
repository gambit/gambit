;;; Program to use the chudnovsky formula to compute pi.
;;; Written by Bakul Shah.
;;; Changed by Bradley Lucier to use standard arithmetic operations
;;; available in Gambit Scheme, and to use (quotient a b
;;; instead of (floor (/ a b)).

;;; This version computes 100,000 digits of pi and tests that the
;;; last five digits are correct.

(define ch-A 13591409)
(define ch-B 545140134)
(define ch-C 640320)
(define ch-C^3 (expt 640320 3))
(define ch-D 12)

(define (ch-split a b)
  (if (GENERIC= 1 (GENERIC- b a))
      (let ((g (GENERIC* (GENERIC- (GENERIC* 6 b) 5)
                         (GENERIC* (GENERIC- (GENERIC* 2 b) 1)
                                   (GENERIC- (GENERIC* 6 b) 1)))))
        (list g
              (GENERICquotient (GENERIC* ch-C^3 (GENERICexpt b 3)) 24)
              (GENERIC* (GENERICexpt -1 b)
                        (GENERIC* g (GENERIC+ (GENERIC* b ch-B) ch-A)))))
      (let* ((mid (GENERICquotient (GENERIC+ a b) 2))
             (gpq1 (ch-split a mid))    ;<<<<====
             (gpq2 (ch-split mid b))    ;<<<<====
             (g1 (car gpq1)) (p1 (cadr gpq1)) (q1 (caddr gpq1))
             (g2 (car gpq2)) (p2 (cadr gpq2)) (q2 (caddr gpq2)))
        (list (GENERIC* g1 g2)
              (GENERIC* p1 p2)
              (GENERIC+ (GENERIC* q1 p2)
                        (GENERIC* q2 g1))))))

(define (pi digits)
  (let* ((num-terms (inexact->exact (floor (GENERIC+ 2 (GENERIC/ digits 14.181647462)))))
         (sqrt-C (integer-sqrt (GENERIC* ch-C (GENERICexpt 100 digits)))))
    (let* ((gpq (ch-split 0 num-terms))
           (g (car gpq)) (p (cadr gpq)) (q (caddr gpq)))
      (GENERICquotient (GENERIC* p (GENERIC* ch-C sqrt-C))
                       (GENERIC* ch-D (GENERIC+ q (GENERIC* p ch-A)))))))

(define (run digits)
  (GENERICremainder (pi digits) 100000))

(define (main . args)
  (run-benchmark
   "chud100K"
   chud100K-iters
   (lambda (result) (GENERIC= result 24646))
   (lambda () (lambda () (run #e1e5)))
   ))
