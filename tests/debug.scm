; File: "debug.scm"

; Copyright (c) 1998-2018 by Marc Feeley, All Rights Reserved.

; Test program for Gambit's interpreter support for debugging.


;------------------------------------------------------------------------------

(define (test a b c d)
  ((lambda (e f g h)
     ((lambda (i j k l)
        (set! a (+ a 1))
        (set! b (+ b 1))
        (set! c (+ c 1))
        (set! d (+ d 1))
        (set! e (+ e 1))
        (set! f (+ f 1))
        (set! g (+ g 1))
        (set! h (+ h 1))
        (set! i (+ i 1))
        (set! j (+ j 1))
        (if (and a b)
            (force
             (begin
               (set! k (+ k 1))
               (set! l (+ l 1))
               (delay (set! z (+ z 1))))))
        (append (case a ((11) (list a)) (else '()))
                (case b ((20) '()) (else (list b)))
                (if (or a b) (list c) '())
                (if (not d) (list f e d) (list d e f))
                (cond (g => list) (else '()))
                (cond ((list h)) (else '()))
                (cond (i `(,@(list i j) #(,k ,l) ,z)))))
      ((lambda () 1000))
      ((lambda (w) 2000) 1)
      ((lambda (w x) 3000) 1 2)
      ((lambda (w x y) 4000) 1 2 3)))
   (let ((w 1) (x 2) (y 3)) 100)
   (let* ((w 1) (x 2) (y 3)) 200)
   (letrec ((w 1) (x 2) (y 3)) 300)
   ((lambda w 400) 1 2 3)))

(define z 10000)

;------------------------------------------------------------------------------

(define (subprocedure p i)
  (##make-subprocedure p i))

(define (check cprc)

  (define (check-label x)
    (let* ((subproc (subprocedure cprc (vector-ref x 0)))
           (vars (accessible-vars subproc)))
      (let ((old-rt (output-port-readtable (current-output-port))))
        (output-port-readtable-set!
         (current-output-port)
         (readtable-sharing-allowed?-set old-rt 'serialize))
        (write subproc)
        (output-port-readtable-set!
         (current-output-port)
         old-rt))
      (if (not (procedure? subproc))
        (begin
          (display " : ")
          (write vars)
          (if (not (and (memq '$code vars) (memq 'rte vars)))
            (display " ERROR"))))
      (newline)))

  (let ((info (##subprocedure-parent-info cprc)))
    (if (not info)
      (begin
        (write cprc)
        (display " : ")
        (display "*** no procedure info")
        (newline))
      (for-each check-label (vector->list (##vector-ref info 0))))
    (newline)))

(define (accessible-vars proc)
  (##subprocedure-locals proc))

(define (go)
  (for-each check
            (append (map car ##decomp-dispatch-table)
                    (list ##subproblem-apply0
                          ##subproblem-apply1
                          ##subproblem-apply2
                          ##subproblem-apply3
                          ##subproblem-apply4
                          ##subproblem-apply
                          ##step-handler))))

(go)

;------------------------------------------------------------------------------

'(begin
  (set-display-environment! #t)
  (##repl
   (open-input-string "(begin (step) (test 10 20 30 40)),s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s")))
