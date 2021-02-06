(include "#.scm")

;;; Program to use the chudnovsky formula to compute pi.
;;; Written by Bakul Shah.
;;; Changed by Bradley Lucier to use standard arithmetic operations
;;; available in Gambit Scheme and to replace (floor (/ ...)) by
;;; (quotient ...)

(define ch-A 13591409)
(define ch-B 545140134)
(define ch-C 640320)
(define ch-C^3 (expt 640320 3))
(define ch-D 12)

(define (ch-split a b)
  (if (= 1 (- b a))
      (let ((g (* (- (* 6 b) 5) (- (* 2 b) 1) (- (* 6 b) 1))))
        (list g
              (quotient (* ch-C^3 (expt b 3)) 24)
              (* (expt -1 b) g (+ (* b ch-B) ch-A))))
      (let* ((mid (quotient (+ a b) 2))
             (gpq1 (ch-split a mid))    ;<<<<====
             (gpq2 (ch-split mid b))    ;<<<<====
             (g1 (car gpq1)) (p1 (cadr gpq1)) (q1 (caddr gpq1))
             (g2 (car gpq2)) (p2 (cadr gpq2)) (q2 (caddr gpq2)))
        (list (* g1 g2)
              (* p1 p2)
              (+ (* q1 p2) (* q2 g1))))))

(define (pi digits)
  (let* ((num-terms (inexact->exact (floor (+ 2 (/ digits 14.181647462)))))
         (sqrt-C (integer-sqrt (* ch-C (expt 100 digits)))))
    (let* ((gpq (ch-split 0 num-terms))
           (g (car gpq)) (p (cadr gpq)) (q (caddr gpq)))
      (quotient (* p ch-C sqrt-C) (* ch-D (+ q (* p ch-A)))))))

(pi (expt 10 4))

(check-eqv? (modulo (pi (expt 10 4)) 100000)
            75678)
