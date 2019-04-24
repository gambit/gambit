;;; File: "debug.scm"

;;; Copyright (c) 1998-2019 by Marc Feeley, All Rights Reserved.

;;; Test program for Gambit's interpreter support for debugging.

;;;----------------------------------------------------------------------------

(define (redirect-repl-input str)
  (let ((c (##make-repl-channel-ports (open-input-string str)
                                      ##stdout-port)))
    (##direct-structure-set! c
                             (lambda (channel)
                               (let* ((input-port
                                       (##direct-structure-ref
                                        channel
                                        3
                                        (##structure-type channel)
                                        #f))
                                      (output-port
                                       (##direct-structure-ref
                                        channel
                                        4
                                        (##structure-type channel)
                                        #f))
                                      (expr
                                       (##read-expr-from-port input-port)))
                                 (if (not (eof-object? expr))
                                     (begin
                                       (write (##desourcify expr) output-port)
                                       (newline output-port)))
                                 expr))
                             14
                             (##structure-type c)
                             #f)
    (set! ##stdio/console-repl-channel c)))

(display-environment-set! #t)

(redirect-repl-input
 "(begin (step) (test 10 20 30 40) (exit)),s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s,s")

;;;----------------------------------------------------------------------------

(define (test a b c d)
  ((lambda (e f g h i j k l m)
     ((lambda (n o p q)
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
        (set! k (+ k 1))
        (set! l (+ l 1))
        (set! m (+ m 1))
        (set! n (+ n 1))
        (set! o (+ o 1))
        (if (and a b)
            (force
             (begin
               (set! p (+ p 1))
               (set! q (+ q 1))
               (delay (set! z (+ z 1))))))
        (append (case a ((11) (list a)) (else '()))
                (case b ((20) '()) (else (list b)))
                (if (or a b) (list c) '())
                (if (not d) (list f e d) (list d e f))
                (cond (g => list) (else '()))
                (cond ((list h)) (else '()))
                (cond (i `(,@(list i j) #(,k ,l) ,z)))
                (let loop ((i 1)) (if (< i 10) (loop (* i 2)) (list i)))
                (do ((i 1 (* i 3)) (j 10)) ((< i j) (list i)) (set! j (- j 1)))
                (guard (e ((char? e) '("char")) ((number? e) (list (+ 5000 e))))
                  (+ 6000 (raise 1)))
                (r7rs-guard (x (else '(7000)))
                  (r7rs-guard (e ((char? e) '("char")))
                    (+ 8000 (raise 2))))))
      ((lambda () 1000))
      ((lambda (w) 2000) 1)
      ((lambda (w x) 3000) 1 2)
      ((lambda (w x y) 4000) 1 2 3)))
   (let ((w 1) (x 2) (y 3)) 100)
   (let* ((w 1) (x 2) (y 3)) 200)
   (letrec ((w 1) (x 2) (y 3)) 300)
   (letrec* ((w 1) (x 2) (y 3)) 400)
   (let-values ((() (values)) (a (values)) (b 1) (c (values 1 2)) ((d) 3) ((e . f) 4) ((g . h) (values 5 6)) ((i j) (values 7 8))) 10)
   (let*-values ((() (values)) (a (values)) (b 1) (c (values 1 2)) ((d) 3) ((e . f) 4) ((g . h) (values 5 6)) ((i j) (values 7 8))) 20)
   (letrec-values ((() (values)) (a (values)) (b 1) (c (values 1 2)) ((d) 3) ((e . f) 4) ((g . h) (values 5 6)) ((i j) (values 7 8))) 30)
   (letrec*-values ((() (values)) (a (values)) (b 1) (c (values 1 2)) ((d) 3) ((e . f) 4) ((g . h) (values 5 6)) ((i j) (values 7 8))) 40)
   ((lambda w 400) 1 2 3)))

(define z 10000)

;;;----------------------------------------------------------------------------

(define (sort-list lst <?)

  (define (mergesort lst)

    (define (merge lst1 lst2)
      (cond ((null? lst1) lst2)
            ((null? lst2) lst1)
            (else
             (let ((e1 (car lst1)) (e2 (car lst2)))
               (if (<? e1 e2)
                 (cons e1 (merge (cdr lst1) lst2))
                 (cons e2 (merge lst1 (cdr lst2))))))))

    (define (split lst)
      (if (or (null? lst) (null? (cdr lst)))
        lst
        (cons (car lst) (split (cddr lst)))))

    (if (or (null? lst) (null? (cdr lst)))
      lst
      (let* ((lst1 (mergesort (split lst)))
             (lst2 (mergesort (split (cdr lst)))))
        (merge lst1 lst2))))

  (mergesort lst))

(define (sort-symbols lst)
  (sort-list lst
             (lambda (x y)
               (string<? (symbol->string x) (symbol->string y)))))

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
          (write (sort-symbols vars))
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

;;;----------------------------------------------------------------------------

(##repl)
