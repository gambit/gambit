;;;============================================================================

;;; File: "_repl.scm", Time-stamp: <2009-03-14 19:58:15 feeley>

;;; Copyright (c) 1994-2009 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "header.scm")

;;;============================================================================

;;; Decompilation of a piece of code

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(##define-macro (mk-degen params . def)
  `(let () (##declare (not inline)) (lambda ($code ,@params) ,@def)))

(##define-macro (degen proc . args)
  `(,proc $code ,@args))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##extract-container $code rte)
  (let loop ((c (macro-code-cte $code)) (r rte))
    (cond ((##cte-top? c)
           #f)
          ((##cte-frame? c)
           (let ((vars (##cte-frame-vars c)))
             (if (and (##pair? vars) (##eq? (##car vars) (macro-self-var)))
               (macro-rte-ref r 1)
               (loop (##cte-parent-cte c) (macro-rte-up r)))))
          (else
           (loop (##cte-parent-cte c) r)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##begin? x) (and (##pair? x) (##eq? (##car x) 'begin)))
(define-prim (##cond? x)  (and (##pair? x) (##eq? (##car x) 'cond)))
(define-prim (##and? x)   (and (##pair? x) (##eq? (##car x) 'and)))
(define-prim (##or? x)    (and (##pair? x) (##eq? (##car x) 'or)))
(define-prim (##void-constant? x)
  (and (##pair? x)
       (##eq? (##car x) 'quote)
       (##eq? (##cadr x) (##void))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim ##degen-top
  (mk-degen ()
    (##decomp (^ 0))))

(define-prim ##degen-cst
  (mk-degen ()
    (let ((val (^ 0)))
      (##inverse-eval val))))

(define-prim ##degen-loc-ref-x-y
  (mk-degen (up over)
    (degen ##degen-up-over up over)))

(define-prim ##degen-up-over
  (mk-degen (up over)
    (let loop1 ((c (macro-code-cte $code)) (up up))
      (cond ((##cte-frame? c)
             (if (##fixnum.= up 0)
               (let loop2 ((vars (##cte-frame-vars c)) (i over))
                 (if (##fixnum.< i 2)
                   (##car vars)
                   (loop2 (##cdr vars) (##fixnum.- i 1))))
               (loop1 (##cte-parent-cte c) (##fixnum.- up 1))))
            (else
             (loop1 (##cte-parent-cte c) up))))))

(define-prim ##degen-loc-ref
  (mk-degen ()
    (degen ##degen-loc-ref-x-y (^ 0) (^ 1))))

(define-prim ##degen-glo-ref
  (mk-degen ()
    (##global-var->identifier (^ 0))))

(define-prim ##degen-loc-set
  (mk-degen ()
    (##list 'set! (degen ##degen-up-over (^ 1) (^ 2))
                  (##decomp (^ 0)))))

(define-prim ##degen-glo-set
  (mk-degen ()
    (##list 'set! (##global-var->identifier (^ 1))
                  (##decomp (^ 0)))))

(define-prim ##degen-glo-def
  (mk-degen ()
    (##list 'define (##global-var->identifier (^ 1))
                    (##decomp (^ 0)))))

(define-prim ##degen-if2
  (mk-degen ()
    (##list 'if (##decomp (^ 0))
                (##decomp (^ 1)))))

(define-prim ##degen-if3
  (mk-degen ()
    (##list 'if (##decomp (^ 0))
                (##decomp (^ 1))
                (##decomp (^ 2)))))

(define-prim ##degen-seq
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (if (##begin? val2)
        (##cons 'begin (##cons val1 (##cdr val2)))
        (##list 'begin val1 val2)))))

(define-prim ##degen-quasi-list->vector
  (mk-degen ()
    (##list 'quasiquote
            (##list->vector
             (##degen-quasi-unquote-splicing-cdr
              (##decomp (^ 0)))))))

(define-prim ##degen-quasi-append
  (mk-degen ()
    (##degen-quasi-append-aux
     (##degen-quasi-unquote-splicing (##decomp (^ 0)))
     (##decomp (^ 1)))))

(define-prim ##degen-quasi-cons
  (mk-degen ()
    (##degen-quasi-append-aux
     (##degen-quasi-unquote (##decomp (^ 0)))
     (##decomp (^ 1)))))

(define-prim (##degen-quasi-append-aux a b)
  (##list 'quasiquote
          (##cons a
                  (##degen-quasi-unquote-splicing-cdr b))))

(define-prim (##degen-quasi-unquote expr)
  (let ((x (##degen-quasi-optimize expr)))
    (if x
        (##car x)
        (##list 'unquote expr))))

(define-prim (##degen-quasi-unquote-splicing-cdr expr)
  (let ((x (##degen-quasi-optimize expr)))
    (if x
        (##car x)
        (##list (##degen-quasi-unquote-splicing expr)))))

(define-prim (##degen-quasi-unquote-splicing expr)
  (##list 'unquote-splicing expr))

(define-prim (##degen-quasi-optimize expr)
  (let ((x (##degen-quasi-extract expr 'quasiquote)))
    (if x
        x
        (let ((y (##degen-quasi-extract expr 'quote)))
          (if (and y (##not (##pair? (##car y)))) ;; in case of embedded unquotes
              y
              #f)))))

(define-prim (##degen-quasi-extract expr tag)
  (and ;; #f ;; uncomment to disable optimization
       (##pair? expr)
       (##eq? (##car expr) tag)
       (let ((x (##cdr expr)))
         (and (##pair? x)
              (##null? (##cdr x))
              (##list (##car x))))))

(define-prim ##degen-cond-if
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1)))
          (val3 (##decomp (^ 2))))
      (##build-cond
        (if (##begin? val2)
          (##cons val1 (##cdr val2))
          (##list val1 val2))
        val3))))

(define-prim ##degen-cond-or
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (##build-cond (##list val1) val2))))

(define-prim ##degen-cond-send
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1)))
          (val3 (##decomp (^ 2))))
      (##build-cond (##list val1 '=> val2) val3))))

(define-prim (##build-cond clause rest)
  (cond ((##cond? rest)
         (##cons 'cond (##cons clause (##cdr rest))))
        ((##begin? rest)
         (##cons 'cond (##list clause (##cons 'else (##cdr rest)))))
        ((##void-constant? rest)
         (##list 'cond clause))
        (else
         (##list 'cond clause (##list 'else rest)))))

(define-prim ##degen-or
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (if (##or? val2)
        (##cons 'or (##cons val1 (##cdr val2)))
        (##list 'or val1 val2)))))

(define-prim ##degen-and
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (if (##and? val2)
        (##cons 'and (##cons val1 (##cdr val2)))
        (##list 'and val1 val2)))))

(define-prim ##degen-case
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (##cons 'case (##cons val1 val2)))))

(define-prim ##degen-case-clause
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (##cons (if (##begin? val1)
                (##cons (^ 2) (##cdr val1))
                (##list (^ 2) val1))
              val2))))

(define-prim ##degen-case-else
  (mk-degen ()
    (let ((val (##decomp (^ 0))))
      (if (##void-constant? val)
        '()
        (##list (if (##begin? val)
                  (##cons 'else (##cdr val))
                  (##list 'else val)))))))

(define-prim ##degen-let
  (mk-degen ()
    (let ((n (macro-code-length $code)))
      (let loop ((i (##fixnum.- n 2)) (vals '()))
        (if (##fixnum.< 0 i)
          (loop (##fixnum.- i 1)
                (##cons (##decomp (macro-code-ref $code i)) vals))
          (let ((body
                 (##decomp (^ 0)))
                (bindings
                 (##make-bindings (macro-code-ref $code (##fixnum.- n 1))
                                  vals)))
            (if (##begin? body)
              (##cons 'let (##cons bindings (##cdr body)))
              (##list 'let bindings body))))))))

(define-prim (##make-bindings l1 l2)
  (if (##pair? l1)
    (##cons (##list (##car l1) (##car l2))
            (##make-bindings (##cdr l1) (##cdr l2)))
    '()))

(define-prim ##degen-letrec
  (mk-degen ()
    (let ((n (macro-code-length $code)))
      (let loop ((i (##fixnum.- n 2)) (vals '()))
        (if (##fixnum.< 0 i)
          (loop (##fixnum.- i 1)
                (##cons (##decomp (macro-code-ref $code i)) vals))
          (let ((body
                 (##decomp (^ 0)))
                (bindings
                 (##make-bindings (macro-code-ref $code (##fixnum.- n 1))
                                  vals)))
            (if (##begin? body)
              (##cons 'letrec (##cons bindings (##cdr body)))
              (##list 'letrec bindings body))))))))

(define-prim ##degen-prc-req
  (mk-degen ()
    (let* ((n (macro-code-length $code))
           (body (##decomp (^ 0)))
           (params (macro-code-ref $code (##fixnum.- n 1))))
      (if (##begin? body)
        (##cons 'lambda (##cons params (##cdr body)))
        (##list 'lambda params body)))))

(define-prim ##degen-prc-rest
  (mk-degen ()
    (let ((body (##decomp (^ 0)))
          (params (##make-params (^ 3) #t #f '())))
      (if (##begin? body)
        (##cons 'lambda (##cons params (##cdr body)))
        (##list 'lambda params body)))))

(define-prim ##degen-prc
  (mk-degen ()
    (let ((n (macro-code-length $code)))
      (let loop ((i (##fixnum.- n 8)) (inits '()))
        (if (##not (##fixnum.< i 1))
          (loop (##fixnum.- i 1)
                (##cons (##decomp (macro-code-ref $code i)) inits))
          (let ((body
                 (##decomp (^ 0)))
                (params
                 (##make-params
                   (macro-code-ref $code (##fixnum.- n 1))
                   (macro-code-ref $code (##fixnum.- n 4))
                   (macro-code-ref $code (##fixnum.- n 3))
                   inits)))
            (if (##begin? body)
              (##cons 'lambda (##cons params (##cdr body)))
              (##list 'lambda params body))))))))

(define-prim (##make-params parms rest? keys inits)
  (let* ((nb-parms
          (##length parms))
         (nb-inits
          (##length inits))
         (nb-reqs
          (##fixnum.- nb-parms (##fixnum.+ nb-inits (if rest? 1 0))))
         (nb-opts
          (##fixnum.- nb-inits (if keys (##vector-length keys) 0))))

    (define (build-reqs)
      (let loop ((parms parms)
                 (i nb-reqs))
        (if (##fixnum.= i 0)
          (build-opts parms)
          (let ((parm (##car parms)))
            (##cons parm
                    (loop (##cdr parms)
                          (##fixnum.- i 1)))))))

    (define (build-opts parms)
      (if (##fixnum.= nb-opts 0)
        (build-rest-and-keys parms inits)
        (##cons #!optional
                (let loop ((parms parms)
                           (i nb-opts)
                           (inits inits))
                  (if (##fixnum.= i 0)
                    (build-rest-and-keys parms inits)
                    (let ((parm (##car parms))
                          (init (##car inits)))
                      (##cons (if (##eq? init #f) parm (##list parm init))
                              (loop (##cdr parms)
                                    (##fixnum.- i 1)
                                    (##cdr inits)))))))))

    (define (build-rest-and-keys parms inits)
      (if (##eq? rest? 'dsssl)
        (##cons #!rest
                (##cons (##car parms)
                        (build-keys (##cdr parms) inits)))
        (build-keys parms inits)))

    (define (build-keys parms inits)
      (if (##not keys)
        (build-rest-at-end parms)
        (##cons #!key
                (let loop ((parms parms)
                           (i (##vector-length keys))
                           (inits inits))
                  (if (##fixnum.= i 0)
                    (build-rest-at-end parms)
                    (let ((parm (##car parms))
                          (init (##car inits)))
                      (##cons (if (##eq? init #f) parm (##list parm init))
                              (loop (##cdr parms)
                                    (##fixnum.- i 1)
                                    (##cdr inits)))))))))

    (define use-dotted-rest-parameter-when-possible? #t)

    (define (build-rest-at-end parms)
      (if (##eq? rest? #t)
        (if use-dotted-rest-parameter-when-possible?
          (##car parms)
          (##cons #!rest (##cons (##car parms) '())))
        '()))

    (build-reqs)))

(define-prim ##degen-app0
  (mk-degen ()
    (##list (##decomp (^ 0)))))

(define-prim ##degen-app1
  (mk-degen ()
    (##list (##decomp (^ 0))
            (##decomp (^ 1)))))

(define-prim ##degen-app2
  (mk-degen ()
    (##list (##decomp (^ 0))
            (##decomp (^ 1))
            (##decomp (^ 2)))))

(define-prim ##degen-app3
  (mk-degen ()
    (##list (##decomp (^ 0))
            (##decomp (^ 1))
            (##decomp (^ 2))
            (##decomp (^ 3)))))

(define-prim ##degen-app4
  (mk-degen ()
    (##list (##decomp (^ 0))
            (##decomp (^ 1))
            (##decomp (^ 2))
            (##decomp (^ 3))
            (##decomp (^ 4)))))

(define-prim ##degen-app
  (mk-degen ()
    (let ((n (macro-code-length $code)))
      (let loop ((i (##fixnum.- n 1)) (vals '()))
        (if (##not (##fixnum.< i 0))
          (loop (##fixnum.- i 1)
                (##cons (##decomp (macro-code-ref $code i)) vals))
          vals)))))

(define-prim ##degen-delay
  (mk-degen ()
    (##list 'delay (##decomp (^ 0)))))

(define-prim ##degen-future
  (mk-degen ()
    (##list 'future (##decomp (^ 0)))))

(define-prim ##degen-require
  (mk-degen ()
    (##decomp (^ 1))))

;;;----------------------------------------------------------------------------

(define ##decomp-dispatch-table #f)

(define-prim (##setup-decomp-dispatch-table)
  (set! ##decomp-dispatch-table
    (##list
      (##cons ##cprc-top         ##degen-top)

      (##cons ##cprc-cst         ##degen-cst)

      (##cons ##cprc-loc-ref-0-1 (mk-degen () (degen ##degen-loc-ref-x-y 0 1)))
      (##cons ##cprc-loc-ref-0-2 (mk-degen () (degen ##degen-loc-ref-x-y 0 2)))
      (##cons ##cprc-loc-ref-0-3 (mk-degen () (degen ##degen-loc-ref-x-y 0 3)))
      (##cons ##cprc-loc-ref-1-1 (mk-degen () (degen ##degen-loc-ref-x-y 1 1)))
      (##cons ##cprc-loc-ref-1-2 (mk-degen () (degen ##degen-loc-ref-x-y 1 2)))
      (##cons ##cprc-loc-ref-1-3 (mk-degen () (degen ##degen-loc-ref-x-y 1 3)))
      (##cons ##cprc-loc-ref-2-1 (mk-degen () (degen ##degen-loc-ref-x-y 2 1)))
      (##cons ##cprc-loc-ref-2-2 (mk-degen () (degen ##degen-loc-ref-x-y 2 2)))
      (##cons ##cprc-loc-ref-2-3 (mk-degen () (degen ##degen-loc-ref-x-y 2 3)))
      (##cons ##cprc-loc-ref     ##degen-loc-ref)
      (##cons ##cprc-glo-ref     ##degen-glo-ref)

      (##cons ##cprc-loc-set     ##degen-loc-set)
      (##cons ##cprc-glo-set     ##degen-glo-set)
      (##cons ##cprc-glo-def     ##degen-glo-def)

      (##cons ##cprc-if2         ##degen-if2)
      (##cons ##cprc-if3         ##degen-if3)
      (##cons ##cprc-seq         ##degen-seq)
      (##cons ##cprc-quasi-list->vector ##degen-quasi-list->vector)
      (##cons ##cprc-quasi-append ##degen-quasi-append)
      (##cons ##cprc-quasi-cons  ##degen-quasi-cons)
      (##cons ##cprc-cond-if     ##degen-cond-if)
      (##cons ##cprc-cond-or     ##degen-cond-or)
      (##cons ##cprc-cond-send-red ##degen-cond-send)
      (##cons ##cprc-cond-send-sub ##degen-cond-send)

      (##cons ##cprc-or          ##degen-or)
      (##cons ##cprc-and         ##degen-and)

      (##cons ##cprc-case        ##degen-case)
      (##cons ##cprc-case-clause ##degen-case-clause)
      (##cons ##cprc-case-else   ##degen-case-else)

      (##cons ##cprc-let         ##degen-let)
      (##cons ##cprc-letrec      ##degen-letrec)

      (##cons ##cprc-prc-req0    ##degen-prc-req)
      (##cons ##cprc-prc-req1    ##degen-prc-req)
      (##cons ##cprc-prc-req2    ##degen-prc-req)
      (##cons ##cprc-prc-req3    ##degen-prc-req)
      (##cons ##cprc-prc-req     ##degen-prc-req)
      (##cons ##cprc-prc-rest    ##degen-prc-rest)
      (##cons ##cprc-prc         ##degen-prc)

      (##cons ##cprc-app0-red    ##degen-app0)
      (##cons ##cprc-app1-red    ##degen-app1)
      (##cons ##cprc-app2-red    ##degen-app2)
      (##cons ##cprc-app3-red    ##degen-app3)
      (##cons ##cprc-app4-red    ##degen-app4)
      (##cons ##cprc-app-red     ##degen-app)
      (##cons ##cprc-app0-sub    ##degen-app0)
      (##cons ##cprc-app1-sub    ##degen-app1)
      (##cons ##cprc-app2-sub    ##degen-app2)
      (##cons ##cprc-app3-sub    ##degen-app3)
      (##cons ##cprc-app4-sub    ##degen-app4)
      (##cons ##cprc-app-sub     ##degen-app)

      (##cons ##cprc-delay       ##degen-delay)
      (##cons ##cprc-future      ##degen-future)

      (##cons ##cprc-require     ##degen-require)
)))

(##setup-decomp-dispatch-table)

;;;----------------------------------------------------------------------------

;;; Pretty-printer that decompiles procedures.

(define-prim (pp
              obj
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (obj port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (##repl-output-port)
               port)))
      (macro-check-output-port p 2 (pp obj p)
        (##pretty-print
         (if (##procedure? obj)
             (##decompile obj)
             obj)
         p)))))

(define-prim (##decomp $code)
  (let ((cprc (macro-code-cprc $code)))
    (let ((x (##assq cprc ##decomp-dispatch-table)))
      (if x
        (degen (##cdr x))
        '?))))

(define-prim (##decompile proc)

  (define (decomp p)
    (let ((src-info (##subprocedure-source-info p)))
      (cond ((##source? src-info)
             (source->expression src-info))
            ((or (##locat? src-info)
                 (##not src-info))
             proc)
            (else
             src-info))))

  (define (compiler-source-code src)
    (##source-code src))

  (define (source->expression src)

    (define (list->expression l)
      (cond ((##pair? l)
             (##cons (source->expression (##car l))
                     (list->expression (##cdr l))))
            ((##null? l)
             '())
            (else
             (source->expression l))))

    (define (vector->expression v)
      (let* ((len (##vector-length v))
             (x (##make-vector len 0)))
        (let loop ((i (##fixnum.- len 1)))
          (if (##not (##fixnum.< i 0))
            (begin
              (##vector-set! x i (source->expression (##vector-ref v i)))
              (loop (##fixnum.- i 1)))))
        x))

    (let ((code (compiler-source-code src)))
      (cond ((##pair? code)   (list->expression code))
            ((##vector? code) (vector->expression code))
            (else             code))))

  (let loop ((p proc))
    (cond ((##interp-procedure? p)
           (let* (($code (##interp-procedure-code p))
                  (cprc (macro-code-cprc $code)))
             (if (##eq? cprc ##interp-procedure-wrapper)
               (loop (^ 1))
               (##decomp $code))))
          ((##closure? p)
           (decomp (##closure-code p)))
          (else
           (decomp p)))))

(define-prim (##procedure-locat proc)

  (define (locat p)
    (let ((src-info (##subprocedure-source-info p)))
      (cond ((##source? src-info)
             (compiler-source-locat src-info))
            ((##locat? src-info)
             src-info)
            (else
             #f))))

  (define (compiler-source-locat src)
    (##source-locat src))

  (let loop ((p proc))
    (cond ((##interp-procedure? p)
           (let* (($code (##interp-procedure-code p))
                  (cprc (macro-code-cprc $code)))
             (if (##eq? cprc ##interp-procedure-wrapper)
               (loop (^ 1))
               (##code-locat $code))))
          ((##closure? p)
           (locat (##closure-code p)))
          (else
           (locat p)))))

(define-prim (##code-locat $code)
  (let ((locat-or-position (macro-code-locat $code)))
    (if (or (##locat? locat-or-position) (##not locat-or-position))
      locat-or-position
      (let loop ((parent (macro-code-link $code)))
        (if parent
          (let ((locat-or-position-parent (macro-code-locat parent)))
            (if (##locat? locat-or-position-parent)
              (##make-locat (##locat-container locat-or-position-parent)
                            locat-or-position)
              (loop (macro-code-link parent))))
          #f)))))

(define-prim (##subprocedure-source-info proc)
  (let ((info (##subprocedure-info proc)))
    (if info
        (##vector-ref info 1)
        #f)))

(define-prim (##subprocedure-info proc)
  (let* ((id (##subprocedure-id proc))
         (parent-info (##subprocedure-parent-info proc)))
    (if parent-info
      (let ((v (##vector-ref parent-info 0)))
        (let loop ((i (##fixnum.- (##vector-length v) 1)))
          (if (##fixnum.< i 0)
            #f
            (let ((x (##vector-ref v i)))
              (if (##fixnum.= id (##vector-ref x 0))
                x
                (loop (##fixnum.- i 1)))))))
      #f)))

;;;============================================================================

;;; Utilities

;;;----------------------------------------------------------------------------

(define-prim (##procedure-friendly-name p)
  (or (##procedure-name p)
      p))

(define-prim (##procedure-name p)
  (and (##procedure? p)
       (or (and (##interp-procedure? p)
                (let* (($code (##interp-procedure-code p))
                       (rte (##interp-procedure-rte p)))
                  (##object->lexical-var->identifier
                   (macro-code-cte $code)
                   rte
                   p)))
           (##object->global-var->identifier p))))

(define-prim (##object->lexical-var->identifier cte rte obj)
  (let loop1 ((c cte)
              (r rte))
    (cond ((##cte-top? c)
           #f)
          ((##cte-frame? c)
           (let loop2 ((vars (##cte-frame-vars c))
                       (i 1))
             (if (##pair? vars)
                 (let ((var (##car vars)))
                   (if (and (##not (##hidden-local-var? var))
                            (##eq? (##vector-ref r i) obj))
                       var
                       (loop2 (##cdr vars)
                              (##fixnum.+ i 1))))
                 (loop1 (##cte-parent-cte c)
                        (macro-rte-up r)))))
          (else
           (loop1 (##cte-parent-cte c)
                  r)))))

;;;----------------------------------------------------------------------------

;; Internal variables and parameters are uninteresting for the user.

(define-prim (##hidden-local-var? var)
  (or (##eq? var (macro-self-var))
      (##eq? var (macro-selector-var))
      (##eq? var (macro-do-loop-var))))

(define-prim (##hidden-parameter? param)
  (or (##eq? param ##trace-depth)
      (##eq? param ##current-user-interrupt-handler)))

;;;----------------------------------------------------------------------------

;;; Access to structure of closures for interpreter procedures.

;; Layout of closed variables for closures created by ##cprc-prcXXX and
;; ##interp-procedure-wrapper:
;;
;;   slot 1: $code
;;   slot 2: proc
;;   slot 3: rte

(define ##interp-procedure-code-pointers
  (let (($code (macro-make-code #f #f #f (##no-stepper) ()))
        (rte #f))
    (##list (##closure-code (##cprc-prc-req0 $code rte))
            (##closure-code (##cprc-prc-req1 $code rte))
            (##closure-code (##cprc-prc-req2 $code rte))
            (##closure-code (##cprc-prc-req3 $code rte))
            (##closure-code (##cprc-prc-req  $code rte))
            (##closure-code (##cprc-prc-rest $code rte))
            (##closure-code (##cprc-prc      $code rte))
            (##closure-code (##interp-procedure-wrapper $code rte)))))

(define-prim (##interp-procedure? x)
  (and (##procedure? x)
       (##closure? x)
       (##memq (##closure-code x) ##interp-procedure-code-pointers)))

(define-prim (##interp-procedure-code x) ;; return "$code" closed variable of x
  (##closure-ref x 1))

(define-prim (##interp-procedure-rte x) ;; return "rte" closed variable of x
  (##closure-ref x 3))

;;;----------------------------------------------------------------------------

;;; Access to continuations

(define-prim (##continuation-parent cont)
  (##subprocedure-parent (##continuation-ret cont)))

(define ##show-all-continuations? #f)
(set! ##show-all-continuations? #f)

(define-prim (##hidden-continuation? cont)
  (if ##show-all-continuations?
    #f
    (let ((parent (##continuation-parent cont)))
      (or (##eq? parent ##interp-procedure-wrapper);;;;;;;;;;;;;;;;;;
          (##eq? parent ##dynamic-wind)
          (##eq? parent ##dynamic-env-bind)
          (##eq? parent ##kernel-handlers)
          (##eq? parent ##execute-modules)
          (##eq? parent ##repl-debug)
          (##eq? parent ##repl-debug-main)
          (##eq? parent ##repl-within)
          (##eq? parent ##eval-within)
          (##eq? parent ##with-no-result-expected)
          (##eq? parent ##check-heap)
          (##eq? parent ##nontail-call-for-leap)
          (##eq? parent ##nontail-call-for-step)
          (##eq? parent ##trace-generate)
          (##eq? parent ##thread-interrupt!)
          (##eq? parent ##thread-call)))))

(define-prim (##interp-subproblem-continuation? cont)
  (let ((parent (##continuation-parent cont)))
    (or (##eq? parent ##subproblem-apply0)
        (##eq? parent ##subproblem-apply1)
        (##eq? parent ##subproblem-apply2)
        (##eq? parent ##subproblem-apply3)
        (##eq? parent ##subproblem-apply4)
        (##eq? parent ##subproblem-apply))))

(define-prim (##interp-internal-continuation? cont)
  (let ((parent (##continuation-parent cont)))
    (or (##eq? parent ##step-handler)
        (##eq? parent ##repl-within-proc)
        (##assq parent ##decomp-dispatch-table))))

(define-prim (##interp-continuation? cont)
  (or (##interp-subproblem-continuation? cont)
      (##interp-internal-continuation? cont)))

(define-prim (##continuation-creator cont) ;; returns #f if creator is REPL
  (and cont
       (if (##interp-continuation? cont)
         (let (($code (##interp-continuation-code cont))
               (rte (##interp-continuation-rte cont)))
           (##extract-container $code rte))
         (##continuation-parent cont))))

(define-prim (##continuation-locat cont) ;; returns #f if location unknown
  (and cont
       (if (##interp-continuation? cont)
         (##code-locat (##interp-continuation-code cont))
         (##procedure-locat (##continuation-ret cont)))))

(define-prim (##interp-continuation-code cont)
  (##cdr (##continuation-locals cont '$code)))

(define-prim (##interp-continuation-rte cont)
  (##cdr (##continuation-locals cont 'rte)))

(define-prim (##interesting-continuation? cont)
  (or ##show-all-continuations?
      (##interp-subproblem-continuation? cont)
      (and (##not (##interp-internal-continuation? cont))
           (##not (##hidden-continuation? cont)))))

(define-prim (##continuation-first-frame cont all-frames?)
  (and cont
       (if (or all-frames?
               (##not (##hidden-continuation? cont)))
           cont
           (##continuation-next-frame cont all-frames?))))

(define-prim (##continuation-next-frame cont all-frames?)
  (and cont
       (let loop ((cont cont))
         (let ((next (##continuation-next cont)))
           (and next
                (if (or all-frames?
                        (##interesting-continuation? next))
                    next
                    (loop next)))))))

(define-prim (##continuation-count-frames cont all-frames?)
  (let loop ((cont cont) (n 0))
    (if cont
        (loop (##continuation-next cont)
              (if (or all-frames?
                      (##interesting-continuation? cont))
                  (##fixnum.+ n 1)
                  n))
        n)))

(define-prim (##continuation-locals cont #!optional (var (macro-absent-obj)))
  (##subprocedure-locals (##continuation-ret cont) cont var))

(define-prim (##subprocedure-locals
              proc
              #!optional
              (cont (macro-absent-obj))
              (var (macro-absent-obj)))
  (let* ((parent-info (##subprocedure-parent-info proc))
         (info (##subprocedure-info proc)))
    (if (and parent-info info)
      (let ((var-descrs (##vector-ref parent-info 1)))
        (let loop1 ((j 2) (result '()))
          (if (##fixnum.< j (##vector-length info))
            (let* ((descr
                    (##vector-ref info j))
                   (slot-index
                    (##fixnum.quotient descr 32768))
                   (var-descr-index
                    (##fixnum.quotient (##fixnum.modulo descr 32768) 2))
                   (var-descr
                    (##vector-ref var-descrs var-descr-index))
                   (val1
                    (if (##eq? cont (macro-absent-obj))
                      #f
                      (let ((val (##continuation-ref cont slot-index)))
                        (if (##fixnum.= (##fixnum.modulo descr 2) 0)
                          val
                          (##unbox val))))))
              (if (##pair? var-descr)
                (let loop2 ((lst var-descr) (result result))
                  (if (##pair? lst)
                    (let* ((descr
                            (##car lst))
                           (slot-index
                            (##fixnum.quotient descr 32768))
                           (var-descr-index
                            (##fixnum.quotient (##fixnum.modulo descr 32768) 2))
                           (var-descr
                            (##vector-ref var-descrs var-descr-index))
                           (val2
                            (if (##eq? cont (macro-absent-obj))
                              #f
                              (let ((val (##closure-ref val1 slot-index)))
                                (if (##fixnum.= (##fixnum.modulo descr 2) 0)
                                  val
                                  (##unbox val))))))
                      (if (##eq? cont (macro-absent-obj))
                        (loop2 (##cdr lst)
                               (##cons var-descr result))
                        (if (##eq? var (macro-absent-obj))
                          (loop2 (##cdr lst)
                                 (##cons (##cons var-descr val2) result))
                          (if (##eq? var var-descr)
                            (##cons var-descr val2)
                            (loop2 (##cdr lst)
                                   result)))))
                    (loop1 (##fixnum.+ j 1)
                           result)))
                (if (##eq? cont (macro-absent-obj))
                  (loop1 (##fixnum.+ j 1)
                         (##cons var-descr result))
                  (if (##eq? var (macro-absent-obj))
                    (loop1 (##fixnum.+ j 1)
                           (##cons (##cons var-descr val1) result))
                    (if (##eq? var var-descr)
                      (##cons var-descr val1)
                      (loop1 (##fixnum.+ j 1)
                             result))))))
            result)))
      #f)))

;;;----------------------------------------------------------------------------

;;; Access to run time environments

(define-prim (##rte-shape $code)

  (define (get-shape cte)
    (cond ((##cte-top? cte)
           #f)
          ((##cte-frame? cte)
           (##list->vector
             (##cons (get-shape (##cte-parent-cte cte))
                     (##cte-frame-vars cte))))
          (else
           (get-shape (##cte-parent-cte cte)))))

  (get-shape (macro-code-cte $code)))

(define-prim (##rte-var-ref rte up over)
  (let loop ((r rte) (i up))
    (if (##fixnum.< 0 i)
      (loop (macro-rte-up r) (##fixnum.- i 1))
      (##vector-ref r over))))

(define-prim (##rte-var-set! rte up over val)
  (let loop ((r rte) (i up))
    (if (##fixnum.< 0 i)
      (loop (macro-rte-up r) (##fixnum.- i 1))
      (##vector-set! r over val))))

;;;----------------------------------------------------------------------------

(define-prim (##cmd-? port)
  (##write-string
",?              : Summary of comma commands
,h   | ,(h X)   : Help on procedure of last error or procedure/macro named X
,q              : Terminate the process
,qt             : Terminate the current thread
,t              : Jump to toplevel REPL
,d              : Jump to enclosing REPL
,c   | ,(c X)   : Continue the computation with stepping off
,s   | ,(s X)   : Continue the computation with stepping on (step)
,l   | ,(l X)   : Continue the computation with stepping on (leap)
,<n>            : Move to particular frame (<n> >= 0)
,+   | ,-       : Move to next or previous frame of continuation
,y              : Display one-line summary of current frame
,i              : Display procedure attached to current frame
,b   | ,(b X)   : Display backtrace of current continuation or X (cont/thread)
,be  | ,(be X)  : Like ,b and ,(b X) but also display environment
,bed | ,(bed X) : Like ,be and ,(be X) but also display dynamic environment
,e   | ,(e X)   : Display environment of current frame or X (proc/cont/thread)
,ed  | ,(ed X)  : Like ,e and ,(e X) but also display dynamic environment
,st  | ,(st X)  : Display current thread group, or X (thread/thread group)
,(v X)          : Start a REPL visiting X (proc/cont/thread)
" port))

;;;,(p [N M])    : Configure REPL's pretty printer (N=max level, M=max length)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(##define-macro (macro-default-max-head) 10)
(##define-macro (macro-default-max-tail) 4)

(define-prim (##cmd-b cont port depth display-env?)
  (##display-continuation-backtrace
   cont
   port
   display-env?
   #f
   (macro-default-max-head)
   (macro-default-max-tail)
   depth))

(define-prim (##display-continuation-backtrace
              cont
              port
              display-env?
              all-frames?
              max-head
              max-tail
              depth)
  (let loop ((i 0)
             (j (##fixnum.- (##continuation-count-frames cont all-frames?) 1))
             (cont (##continuation-first-frame cont all-frames?)))
    (and cont
         (begin
           (cond ((or (##fixnum.< i max-head) (##fixnum.< j max-tail)
                      (and (##fixnum.= i max-head) (##fixnum.= j max-tail)))
                  (##display-continuation-frame
                   cont
                   port
                   display-env?
                   #f
                   (##fixnum.+ depth i)))
                 ((##fixnum.= i max-head)
                  (##write-string "..." port)
                  (##newline port)))
           (loop (##fixnum.+ i 1)
                 (##fixnum.- j 1)
                 (##continuation-next-frame cont all-frames?))))))

(define-prim (display-continuation-backtrace
              cont
              #!optional
              (port (macro-absent-obj))
              (all-frames? (macro-absent-obj))
              (display-env? (macro-absent-obj))
              (max-head (macro-absent-obj))
              (max-tail (macro-absent-obj))
              (depth (macro-absent-obj)))
  (macro-force-vars (cont port all-frames? display-env? max-head max-tail depth)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port))
          (de
           (if (##eq? display-env? (macro-absent-obj))
               #f
               display-env?))
          (af
           (if (##eq? all-frames? (macro-absent-obj))
               #f
               all-frames?))
          (mh
           (if (##eq? max-head (macro-absent-obj))
               (macro-default-max-head)
               max-head))
          (mt
           (if (##eq? max-tail (macro-absent-obj))
               (macro-default-max-tail)
               max-tail))
          (d
           (if (##eq? depth (macro-absent-obj))
               0
               depth)))
      (macro-check-continuation cont 1 (display-continuation-backtrace cont port display-env? all-frames? max-head max-tail depth)
        (macro-check-character-output-port p 2 (display-continuation-backtrace cont port display-env? all-frames? max-head max-tail depth)
          (macro-check-fixnum mh 5 (display-continuation-backtrace cont port display-env? all-frames? max-head max-tail depth)
            (macro-check-fixnum mt 6 (display-continuation-backtrace cont port display-env? all-frames? max-head max-tail depth)
              (macro-check-fixnum d 7 (display-continuation-backtrace cont port display-env? all-frames? max-head max-tail depth)
                (##display-continuation-backtrace cont p de af mh mt d)))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##cmd-y cont port pinpoint? depth)
  (##display-continuation-frame
   cont
   port
   #f
   pinpoint?
   depth))

(define-prim (##display-continuation-frame
              cont
              port
              display-env?
              pinpoint?
              depth)

  (define (tab col)
    (let* ((current (##output-port-column port))
           (n (##fixnum.- col current)))
      (##display-spaces (##fixnum.max n 1) port)))

  (and cont
       (let ((port-width (##output-port-width port)))

         (define depth-width    4)
         (define creator-width 24)
         (define locat-width   24)
         (define call-width    27)

         (let ((extra
                (##fixnum.max
                 0
                 (##fixnum.quotient
                  (##fixnum.- port-width
                              (##fixnum.+
                               depth-width
                               creator-width
                               locat-width
                               call-width))
                  3))))
           (##write depth port)
           (tab depth-width)
           (let ((creator (##continuation-creator cont)))
             (if creator
                 (##write (##procedure-friendly-name creator) port)
                 (##write-string "(interaction)" port)))
           (tab (##fixnum.+ (##fixnum.+ depth-width
                                        creator-width)
                            extra))
           (let ((locat (##continuation-locat cont)))
             (##display-locat locat pinpoint? port))
           (let ((call
                  (if (##interp-continuation? cont)
                      (let* (($code (##interp-continuation-code cont))
                             (cprc (macro-code-cprc $code)))
                        (if (##eq? cprc ##interp-procedure-wrapper)
                            #f
                            (##decomp $code)))
                      (let* ((ret (##continuation-ret cont))
                             (call (##decompile ret)))
                        (if (##eq? call ret)
                            #f
                            call)))))
             (if call
                 (begin
                   (tab (##fixnum.+ depth-width
                                    creator-width
                                    locat-width
                                    (##fixnum.* 2 extra)))
                   (##write-string
                    (##object->string
                     call
                     (##fixnum.- port-width
                                 (##output-port-column port)))
                    port))))
           (##newline port)
           (##display-continuation-env
            cont
            port
            (##fixnum.+ 4 depth-width)
            display-env?)))))

(define-prim (##display-spaces n port)
  (if (##fixnum.< 0 n)
    (let ((m (if (##fixnum.< 40 n) 40 n)))
      (##write-substring "                                        " 0 m port)
      (##display-spaces (##fixnum.- n m) port)
      n)))

(define-prim (##display-locat locat pinpoint? port)
  (if locat ;; locat is #f if location unknown
    (let* ((container (##locat-container locat))
           (path (##container->path container)))
      (if path
        (##write (##path-normalize path
                                   ##repl-location-relative
                                   ##repl-location-origin
                                   #f)
                 port)
        (##write-string (##container->id container) port))
      (let* ((filepos (##position->filepos (##locat-position locat)))
             (line (##fixnum.+ (##filepos-line filepos) 1))
             (col (##fixnum.+ (##filepos-col filepos) 1)))
        (##write-string "@" port)
        (##write line port)
        (##write-string (if pinpoint? "." ":") port)
        (##write col port)))))

(define ##repl-location-relative #f)
(set! ##repl-location-relative 'shortest)

(define ##repl-location-origin #f)
(set! ##repl-location-origin #f)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##inverse-eval-in-env obj cte)
  (if (##procedure? obj)
    (let ((id (##object->global-var->identifier obj)))

      (define (default)
        (let ((x (##decompile obj)))
          (if (##procedure? x)
            (##inverse-eval x)
            x)))

      (if id
        (let ((ind (##cte-lookup cte id)))
          (if (##eq? (##vector-ref ind 0) 'not-found)
            id
            (default)))
        (default)))

    (##inverse-eval obj)))

(define-prim (##inverse-eval obj)
  (if (##self-eval? obj)
    obj
    (##list 'quote obj)))

(define (##display-var-val var val cte indent port)
  (##display-spaces indent port)
  (##write var port)
  (##write-string " = " port)
  (##write-string
   (##object->string
    (if (##cte-top? cte)
        (##inverse-eval-in-env val cte)
        (##inverse-eval-in-env val (##cte-parent-cte cte)))
    (##fixnum.- (##output-port-width port)
                (##output-port-column port)))
   port)
  (##newline port))

(define (##display-rte cte rte indent port)
  (let loop1 ((c cte)
              (r rte))
    (cond ((##cte-top? c))
          ((##cte-frame? c)
           (let loop2 ((vars (##cte-frame-vars c))
                       (vals (##cdr (##vector->list r))))
             (if (##pair? vars)
                 (let ((var (##car vars)))
                   (if (##not (##hidden-local-var? var))
                       (##display-var-val var (##car vals) c indent port))
                   (loop2 (##cdr vars)
                          (##cdr vals)))
                 (loop1 (##cte-parent-cte c)
                        (macro-rte-up r)))))
          (else
           (loop1 (##cte-parent-cte c)
                  r)))))

(define (##display-vars lst cte indent port)
  (let loop ((lst lst))
    (if (##pair? lst)
        (let* ((var-val (##car lst))
               (var (##car var-val))
               (val (##cdr var-val)))
          (##display-var-val var val cte indent port)
          (loop (##cdr lst))))))

(define (##display-locals lst cte indent port)
  (and lst
       (##display-vars lst cte indent port)))

(define (##display-parameters lst cte indent port)
  (let loop ((lst lst))
    (if (##pair? lst)
        (let* ((param-val (##car lst))
               (param (##car param-val))
               (val (##cdr param-val)))
          (if (##not (##hidden-parameter? param))
              (let ((x
                     (##inverse-eval-in-env param cte)))
                (##display-var-val (##list x) val cte indent port)))
          (loop (##cdr lst))))))

(define-prim (##display-continuation-environment cont port indent)
  (if (##interp-continuation? cont)
      (let (($code (##interp-continuation-code cont))
            (rte (##interp-continuation-rte cont)))
        (##display-rte (macro-code-cte $code) rte indent port))
      (##display-locals (##continuation-locals cont)
                        ##interaction-cte
                        indent
                        port))
  (##void))

(define-prim (display-continuation-environment
              cont
              #!optional
              (port (macro-absent-obj))
              (indent (macro-absent-obj)))
  (macro-force-vars (cont port indent)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port))
          (i
           (if (##eq? indent (macro-absent-obj))
               0
               indent)))
      (macro-check-continuation cont 1 (display-continuation-environment cont port indent)
        (macro-check-character-output-port p 2 (display-continuation-environment cont p indent)
          (macro-check-fixnum i 3 (display-continuation-environment cont p i)
            (##display-continuation-environment cont p i)))))))

(define-prim (##display-continuation-dynamic-environment cont port indent)
  (##display-parameters
   (##dynamic-env->list (macro-continuation-denv cont))
   (if (##interp-continuation? cont)
       (let (($code (##interp-continuation-code cont)))
         (macro-code-cte $code))
       ##interaction-cte)
   indent
   port)
  (##void))

(define-prim (display-continuation-dynamic-environment
              cont
              #!optional
              (port (macro-absent-obj))
              (indent (macro-absent-obj)))
  (macro-force-vars (cont port indent)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port))
          (i
           (if (##eq? indent (macro-absent-obj))
               0
               indent)))
      (macro-check-continuation cont 1 (display-continuation-dynamic-environment cont port indent)
        (macro-check-character-output-port p 2 (display-continuation-dynamic-environment cont p indent)
          (macro-check-fixnum i 3 (display-continuation-dynamic-environment cont p i)
            (##display-continuation-dynamic-environment cont p i)))))))

(define ##display-dynamic-environment?
  (##make-parameter #f))

(define display-dynamic-environment?
  ##display-dynamic-environment?)

(define-prim (##display-continuation-env cont port indent display-env?)
  (if display-env?
      (let ((c (##continuation-first-frame cont #f)))
        (if c
            (##display-continuation-environment c port indent))
        (if (or (##eq? display-env? 'dynamic)
                (##display-dynamic-environment?))
            (##display-continuation-dynamic-environment cont port indent)))))

(define-prim (##cmd-e proc-or-cont port display-env?)
  (and proc-or-cont
       (if (##continuation? proc-or-cont)
           (##display-continuation-env proc-or-cont port 0 display-env?)
           (##display-procedure-environment proc-or-cont port 0))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##display-procedure-environment proc port indent)
  (cond ((##interp-procedure? proc)
         (let* (($code (##interp-procedure-code proc))
                (rte (##interp-procedure-rte proc)))
           (##display-rte (macro-code-cte $code) rte indent port)))
        ((##closure? proc)
         (error "Can't access compiled procedure's environment")));;;;;;;;;;;
  (##void))

(define-prim (display-procedure-environment
              proc
              #!optional
              (port (macro-absent-obj))
              (indent (macro-absent-obj)))
  (macro-force-vars (proc port indent)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port))
          (i
           (if (##eq? indent (macro-absent-obj))
               0
               indent)))
      (macro-check-procedure proc 1 (display-procedure-environment proc port indent)
        (macro-check-character-output-port p 2 (display-procedure-environment proc p indent)
          (macro-check-fixnum i 3 (display-procedure-environment proc p i)
            (##display-procedure-environment proc p i)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##cmd-i cont port)
  (and cont
       (let ((creator (##continuation-creator cont)))
         (if creator
           (let ((decomp-creator (##decompile creator)))
             (##write creator port)
             (if (##eq? creator decomp-creator)
               (##newline port)
               (begin
                 (##write-string " =" port)
                 (##newline port)
                 (##pretty-print decomp-creator port))))
           (begin
             (##write-string "(interaction)" port)
             (##newline port))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##cmd-st thread-or-tgroup port)
  (if (macro-thread? thread-or-tgroup)
      (##display-thread-state thread-or-tgroup port)
      (##display-thread-group-state thread-or-tgroup port))
  (##void))

(define-prim (##display-thread-state thread port)
  (let ((now (##current-time-point)))
    (##display-thread-state-relative thread port now)))

(define-prim (##display-thread-state-relative thread port time-point)

  (define (tab col)
    (let* ((current (##output-port-column port))
           (n (##fixnum.- col current)))
      (##display-spaces (##fixnum.max n 1) port)))

  (define (write-timeout to)
    (##write-string " " port)
    (let ((expiry (##flonum.- (macro-time-point to) time-point)))
      (##write (##flonum./ (##flonum.round (##flonum.* 10.0 expiry)) 10.0)
               port))
    (##write-string "s" port))

  (let ((port-width (##output-port-width port)))

    (define thread-width 14)

    (let ((extra
           (##fixnum.max
            0
            (##fixnum.quotient
             (##fixnum.- port-width thread-width)
             5))))
      (##write thread port)
      (tab (##fixnum.+ thread-width extra))
      (let ((ts (##thread-state thread)))
        (cond ((macro-thread-state-uninitialized? ts)
               (##write-string "UNINITIALIZED" port))
              ((macro-thread-state-initialized? ts)
               (##write-string "INITIALIZED" port))
              ((macro-thread-state-normally-terminated? ts)
               (##write-string "NORMALLY TERMINATED" port))
              ((macro-thread-state-abnormally-terminated? ts)
               (##write-string "ABNORMALLY TERMINATED" port))
              ((macro-thread-state-active? ts)
               (let ((wf (macro-thread-state-active-waiting-for ts))
                     (to (macro-thread-state-active-timeout ts)))
                 (cond (wf
                        (##write-string "WAITING " port)
                        (##write wf port)
                        (if to
                            (write-timeout to)))
                       (to
                        (##write-string "SLEEPING" port)
                        (write-timeout to))
                       (else
                        (##write-string "RUNNING" port)))))
              (else
               (##write ts port))))
      (##newline port))))

(define-prim (##display-thread-group-state tgroup port)
  (let* ((threads (##tgroup->thread-vector tgroup))
         (now (##current-time-point)))
    (let loop ((i 0))
      (if (##fixnum.< i (##vector-length threads))
          (let ((thread (##vector-ref threads i)))
            (##display-thread-state-relative thread port now)
            (loop (##fixnum.+ i 1)))
          i))))

(define-prim (##top tgroup port)

  (define interval 1.0)

  (define (up n)
    (##write-string "\033[" port)
    (##write n port)
    (##write-string "A\033[J" port))

  (let ((start-time-point (##current-time-point)))
    (let loop ((last start-time-point))
      (##write-string "*** THREAD LIST:\n"
		      port)
      (let* ((n (##fixnum.+ 1 (##display-thread-group-state tgroup port)))
             (next (##flonum.+ last interval))
             (now (##current-time-point))
             (diff (##flonum.- next now)))
        (if (##flonum.negative? diff)
            (begin
              (up n)
              (loop now))
            (begin
              (##thread-sleep! diff)
              (up n)
              (loop next)))))))

(define-prim (top
              #!optional
              (tgroup (macro-absent-obj))
              (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((tg
           (if (##eq? tgroup (macro-absent-obj))
               (macro-thread-tgroup (macro-current-thread))
               tgroup))
          (p
           (if (##eq? port (macro-absent-obj))
               (##repl-output-port)
               port)))
      (macro-check-tgroup tg 1 (top tgroup port)
        (macro-check-character-output-port p 2 (top tgroup port)
          (##top tg p))))))

;;;----------------------------------------------------------------------------

;;; Tracing and single stepping.

(define-prim (##interp-procedure-entry-hook proc)
  (let (($code (##interp-procedure-code proc)))
    (macro-code-ref $code (##fixnum.- (macro-code-length $code) 2))))

(define-prim (##interp-procedure-entry-hook-set! proc hook)
  (let (($code (##interp-procedure-code proc)))
    (macro-code-set! $code (##fixnum.- (macro-code-length $code) 2) hook)))

(define-prim (##interp-procedure-default-entry-hook proc)
  (let ((hook (##interp-procedure-entry-hook proc)))
    (if (and hook
             (##closure? hook)
             (##eq? (##subprocedure-parent (##closure-code hook))
                    ##make-default-entry-hook))
      hook
      #f)))

(define-prim (##make-default-entry-hook)
  (let ((settings (##vector #f #f)))
    (lambda (proc args execute)
      (if (##vector-ref settings 0)
        (##step-on)) ;; turn on single-stepping
      (if (##vector-ref settings 1)
        (##trace-generate
         (##make-call-form proc
                           (##argument-list-remove-absent! args '())
                           ##max-fixnum)
         execute
         #f)
        (execute)))))

(define-prim (##make-call-form proc args max-args)

  (define (inverse-eval-args i lst)
    (if (##pair? lst)
      (if (##fixnum.< max-args i)
        '(...)
        (##cons (##inverse-eval (##car lst))
                (inverse-eval-args (##fixnum.+ i 1) (##cdr lst))))
      '()))

  (##cons (##procedure-friendly-name proc)
          (inverse-eval-args 1 args)))

(define ##trace-depth (##make-parameter 0))

(define-prim (##trace-generate form execute leap?)

  (define max-depth 10)

  (define (bars width output-port)
    (let loop ((i 0))
      (if (##fixnum.< i width)
        (begin
          (##write-string
            (if (##fixnum.= (##fixnum.remainder i 2) 0) "|" " ")
            output-port)
          (loop (##fixnum.+ i 1))))))

  (define (bars-width depth)
    (let ((d (if (##fixnum.< max-depth depth) max-depth depth)))
      (if (##fixnum.< 0 d) (##fixnum.- (##fixnum.* d 2) 1) 0)))

  (define (indent depth output-port)
    (let ((w (bars-width depth)))
      (if (##fixnum.< max-depth depth)
        (let ((depth-str (##number->string depth 10)))
          (bars (##fixnum.- w (##fixnum.+ (##string-length depth-str) 2))
                output-port)
          (##write-string "[" output-port)
          (##write-string depth-str output-port)
          (##write-string "]" output-port))
        (bars w output-port))
      w))

  (##continuation-capture
   (lambda (cont)
     (let* ((parent
             (##continuation-parent cont))
            (increase-depth?
             (and (##not (##eq? ##nontail-call-for-leap parent))
                  (##not (##eq? ##nontail-call-for-step parent))))
            (current-depth
             (##trace-depth))
            (depth
             (if increase-depth?
               (##fixnum.+ current-depth 1)
               current-depth)))

       (define (nest wrapper)
         (let ((result
                (##parameterize
                 ##trace-depth
                 depth
                 (lambda () (wrapper execute)))))

           (##repl
            (lambda (first output-port)
              (let ((width
                     (##fixnum.+ (indent depth output-port) 1)))
                (##write-string " " output-port)
                (##write-string
                 (##object->string
                  result
                  (##fixnum.- (##output-port-width output-port) width))
                 output-port)
                (##newline output-port)
                #t)))

           result))

       (##repl
        (lambda (first output-port)
          (let ((width
                 (##fixnum.+ (indent depth output-port) 3)))
            (##write-string " > " output-port)
            (##write-string
             (##object->string
              form
              (##fixnum.- (##output-port-width output-port) width))
             output-port)
            (##newline output-port)
            #t)))

       (if leap?
         (cond ((##eq? ##nontail-call-for-leap parent)
                (execute))
               ((##eq? ##nontail-call-for-step parent)
                (##nontail-call-for-leap execute))
               (else
                (nest ##nontail-call-for-leap)))
         (cond ((##eq? ##nontail-call-for-leap parent)
                (execute))
               ((##eq? ##nontail-call-for-step parent)
                (execute))
               (else
                (nest ##nontail-call-for-step))))))))

(define-prim (##nontail-call-for-leap execute)
  (let ((result (execute)))
    (##step-on)
    result))

(define-prim (##nontail-call-for-step execute)
  (##first-argument (execute)))

(define ##trace-list '())

(define-prim (##trace proc)

  (define (setup hook)
    (let ((settings (##closure-ref hook 1)))
      (##vector-set! settings 1 #t)
      (if (##not (##memq proc ##trace-list))
        (set! ##trace-list (##cons proc ##trace-list)))))

  (let ((hook (##interp-procedure-default-entry-hook proc)))
    (if hook
      (setup hook)
      (let ((new-hook (##make-default-entry-hook)))
        (##interp-procedure-entry-hook-set! proc new-hook)
        (setup new-hook)))))

(define-prim (##untrace proc)
  (let ((hook (##interp-procedure-default-entry-hook proc)))
    (if hook
      (let ((settings (##closure-ref hook 1)))
        (##vector-set! settings 1 #f)
        (if (##not (##vector-ref settings 0))
          (##interp-procedure-entry-hook-set! proc #f))))
    (set! ##trace-list (##remove proc ##trace-list))))

(define-prim (trace . args)
  (if (##pair? args)
    (##for-each-interp-procedure
     trace
     args
     ##trace
     args)
    ##trace-list))

(define-prim (untrace . args)
  (##for-each-interp-procedure
   untrace
   args
   ##untrace
   (if (##pair? args) args ##trace-list)))

(define ##break-list '())

(define-prim (##break proc)

  (define (setup hook)
    (let ((settings (##closure-ref hook 1)))
      (##vector-set! settings 0 #t)
      (if (##not (##memq proc ##break-list))
        (set! ##break-list (##cons proc ##break-list)))))

  (let ((hook (##interp-procedure-default-entry-hook proc)))
    (if hook
      (setup hook)
      (let ((new-hook (##make-default-entry-hook)))
        (##interp-procedure-entry-hook-set! proc new-hook)
        (setup new-hook)))))

(define-prim (##unbreak proc)
  (let ((hook (##interp-procedure-default-entry-hook proc)))
    (if hook
      (let ((settings (##closure-ref hook 1)))
        (##vector-set! settings 0 #f)
        (if (##not (##vector-ref settings 1))
          (##interp-procedure-entry-hook-set! proc #f))))
    (set! ##break-list (##remove proc ##break-list))))

(define-prim (break . args)
  (if (##pair? args)
    (##for-each-interp-procedure
     break
     args
     ##break
     args)
    ##break-list))

(define-prim (unbreak . args)
  (##for-each-interp-procedure
   unbreak
   args
   ##unbreak
   (if (##pair? args) args ##break-list)))

(define-prim (##step-on)
  (##declare (not interrupts-enabled))
  (let* ((stepper (##current-stepper))
         (handlers (##vector-ref stepper 0)))
    (let loop ((i (##vector-length handlers)))
      (if (##not (##fixnum.< i 1))
        (let ((i-1 (##fixnum.- i 1)))
          (##vector-set! stepper i (##vector-ref handlers i-1))
          (loop i-1))))
    (##void)))

(define-prim (##step-off)
  (##declare (not interrupts-enabled))
  (let* ((stepper (##current-stepper))
         (handlers (##vector-ref stepper 0)))
    (let loop ((i (##vector-length handlers)))
      (if (##not (##fixnum.< i 1))
        (let ((i-1 (##fixnum.- i 1)))
          (##vector-set! stepper i #f)
          (loop i-1))))
    (##void)))

(define-prim (step)
  (##step-on))

(define-prim (##step-level-set! n)
  (##declare (not interrupts-enabled))
  (let* ((stepper (##current-stepper))
         (handlers (##vector-ref stepper 0)))
    (let loop ((i (##vector-length handlers)))
      (if (##not (##fixnum.< i 1))
        (let ((i-1 (##fixnum.- i 1)))
          (##vector-set! handlers i-1
            (if (##fixnum.< i-1 n)
              (##vector-ref ##step-handlers i-1)
              #f))
          (loop i-1))))
    (##void)))

(define-prim (step-level-set! n)
  (macro-force-vars (n)
    (macro-check-fixnum-range-incl n 1 0 7 (step-level-set! n)
      (##step-level-set! n))))

(define ##step-handlers (macro-make-step-handlers))

(set! ##main-stepper (macro-make-main-stepper))

(define ##repl-display-environment?
  (##make-parameter #f))

(define repl-display-environment?
  ##repl-display-environment?)

(define-prim (display-environment-set! display?)
  ;; DEPRECATED
  (##repl-display-environment? (if display? #t #f))
  (##void))

(define-prim (##step-handler leapable? $code rte execute-body . other)
  (##declare (not interrupts-enabled) (environment-map))
  (##step-off) ;; turn off single-stepping
  (##step-handler-continue
   (##step-handler-get-command $code rte)
   leapable?
   $code
   rte
   execute-body
   other))

(define-prim (##step-handler-get-command $code rte)
  (##repl
   (lambda (first output-port)
     (##display-situation
      "STOPPED"
      (##extract-container $code rte)
      (##code-locat $code)
      output-port)
     (##newline output-port)
     #f)))

(define-prim (##step-handler-continue cmd leapable? $code rte execute-body other)

  ;; cmd is one of the symbols "c", "s" or "l" or a one element vector

  (define (execute)
    (##apply execute-body (##cons $code (##cons rte other))))

  (cond ((##eq? cmd 'c)
         (execute))
        ((and (##eq? cmd 'l) leapable?)
         (##trace-generate (##decomp $code) execute #t))
        ((or (##eq? cmd 'l) (##eq? cmd 's))
         (##step-on)
         (##trace-generate (##decomp $code) execute #f))
        (else
         (##vector-ref cmd 0))))

(define-prim (##for-each-interp-procedure prim args fn procs)
  (let loop ((lst1 procs) (lst2 '()) (arg-num 1))
    (if (##pair? lst1)
      (let ((proc (##car lst1)))
        (if (##procedure? proc)
          (if (##interp-procedure? proc)
            (loop (##cdr lst1)
                  (##cons proc lst2)
                  (##fixnum.+ arg-num 1))
            (let ((id (##object->global-var->identifier proc)))
              (if id ;; procedure is bound to a global variable
                (begin
                  (##repl
                   (lambda (first output-port)
                     (##write-string
                      "*** WARNING -- Rebinding global variable \""
                      output-port)
                     (##write id output-port)
                     (##write-string
                      "\" to an interpreted procedure\n"
                      output-port)
                     #t))
                  (let ((new-proc
                         (##make-interp-procedure proc)))
                    (##global-var-set! (##make-global-var id) new-proc)
                    (loop (##cdr lst1)
                          (##cons new-proc lst2)
                          (##fixnum.+ arg-num 1))))
                (##fail-check-interpreted-procedure arg-num '() prim args))))
          (##fail-check-interpreted-procedure arg-num '() prim args)))
      (begin
        (##for-each fn (##reverse lst2))
        (##void)))))

(define-fail-check-type interpreted-procedure 'interpreted-procedure)

(define-prim ##interp-procedure-wrapper
  (macro-make-cprc ;; this is never actually called to evaluate code
   (letrec ((proc
             (lambda args

               (define (execute)
                 (let (($code $code)
                       (rte (macro-make-rte rte proc args)))
;;;*********                   (break-if-stepping-level>= 0)
                   (##apply (^ 1) args)))

               (let ((entry-hook (^ 0)))
                 (if entry-hook
                   (entry-hook
                    proc
                    args
                    (lambda () (execute)))
                   (execute))))))
     proc)))

(define-prim (##make-interp-procedure proc)
  (let* ((cte
          (##make-top-cte))
         (src
          #f)
         (stepper
          (##current-stepper))
         ($code
          (macro-make-code ##interp-procedure-wrapper cte src stepper ()
            #f
            proc))
         (rte
          #f))
    (##interp-procedure-wrapper $code rte)))

(define-prim (##remove elem lst)
  (let loop ((lst1 lst) (lst2 '()))
    (if (##pair? lst1)
      (let ((x (##car lst1)))
        (if (##eq? x elem)
          (##append (##reverse lst2) (##cdr lst1))
          (loop (##cdr lst1) (##cons x lst2))))
      lst)))

;;;============================================================================

;;; Read eval print loop channels.

(implement-type-repl-channel)

(define-prim (##thread-repl-channel-get! thread)
  (or (macro-thread-repl-channel thread)
      (let ((repl-channel (##thread-make-repl-channel thread)))
        (macro-thread-repl-channel-set! thread repl-channel)
        (macro-thread-repl-channel thread))))

(define (##default-thread-make-repl-channel thread)
    ##stdio/console-repl-channel)

(define ##thread-make-repl-channel #f)
(set! ##thread-make-repl-channel ##default-thread-make-repl-channel)

(define ##stdio/console-repl-channel
  (let* ((settings
          (##set-debug-settings! 0 0))
         (x
          (##fixnum.arithmetic-shift-right
           (##fixnum.bitwise-and
            settings
            (macro-debug-settings-repl-mask))
           (macro-debug-settings-repl-shift))))
    (cond ((##fixnum.= x (macro-debug-settings-repl-stdio))
           (##make-repl-channel-ports ##stdin-port ##stdout-port))
          (else
           (##make-repl-channel-ports ##console-port ##console-port)))))

(define-prim (##repl-input-port)
  (let* ((ct (macro-current-thread))
         (channel (##thread-repl-channel-get! ct)))
    (macro-repl-channel-input-port channel)))

(define-prim (repl-input-port)
  (##repl-input-port))

(define-prim (##repl-output-port)
  (let* ((ct (macro-current-thread))
         (channel (##thread-repl-channel-get! ct)))
    (macro-repl-channel-output-port channel)))

(define-prim (repl-output-port)
  (##repl-output-port))

(define-prim (##repl-channel-acquire-ownership!)
  (let* ((ct (macro-current-thread))
         (channel (##thread-repl-channel-get! ct)))
    (macro-mutex-lock! (macro-repl-channel-owner-mutex channel) #f ct)
    (if (##not (##eq? (macro-repl-channel-last-owner channel) ct))
      (begin
        (macro-repl-channel-last-owner-set! channel ct)
        (##repl-channel-display-monoline-message
         (lambda (output-port)
           (##write-string "------------- REPL is now in " output-port)
           (##write ct output-port)
           (##write-string " -------------" output-port)))
        #t)
      #f)))

(define-prim (##repl-channel-release-ownership!)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    (macro-mutex-unlock! (macro-repl-channel-owner-mutex channel))))

(define-prim (##repl-channel-input-port)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    (macro-repl-channel-input-port channel)))

(define-prim (##repl-channel-output-port)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    (macro-repl-channel-output-port channel)))

(define-prim (##repl-channel-read-command level depth)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-read-command channel) channel level depth)))

(define-prim (##repl-channel-write-results results)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-write-results channel) channel results)))

(define-prim (##repl-channel-display-monoline-message writer)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-display-monoline-message channel) channel writer)))

(define-prim (##repl-channel-display-multiline-message writer)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-display-multiline-message channel) channel writer)))

(define-prim (##repl-channel-display-continuation cont depth)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-display-continuation channel) channel cont depth)))

(define-prim (##repl-channel-pinpoint-continuation cont)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-pinpoint-continuation channel) channel cont)))

(define-prim (##repl-channel-really-exit?)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-really-exit? channel) channel)))

(define-prim (##repl-channel-newline)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-newline channel) channel)))

(##define-macro (macro-repl-result-history-max-max-length)
  10)

(##define-macro (macro-repl-result-history-default-max-length)
  3)

(define-prim (##make-empty-repl-result-history)
  (##vector (macro-repl-result-history-default-max-length)))

(##define-macro (macro-repl-result-history-length result-history)
  `(##fixnum.- (##vector-length ,result-history) 1))

(##define-macro (macro-repl-result-history-max-length result-history)
  `(##vector-ref ,result-history 0))

(##define-macro (macro-repl-result-history-ref result-history i)
  `(##vector-ref ,result-history (##fixnum.+ ,i 1)))

(define-prim (##repl-channel-result-history-add channel result)
  (let loop ()
    (let* ((result-history (macro-repl-channel-result-history channel))
           (len (macro-repl-result-history-length result-history))
           (max-len (macro-repl-result-history-max-length result-history))
           (new-len (##fixnum.min (##fixnum.+ len 1) max-len)))
      (if (##fixnum.< 0 new-len)
          (let ((v (##make-vector (##fixnum.+ new-len 1) max-len)))
            (##subvector-move! result-history 1 new-len v 2)
            (##vector-set! v 1 result)
            (let ()
              (##declare (not interrupts-enabled))
              (if (##not (##eq? (macro-repl-channel-result-history channel)
                                result-history))
                  (loop) ;; some other thread changed it before us... try again
                  (begin
                    (macro-repl-channel-result-history-set! channel v)
                    (##void)))))
          (##void)))))

(define-prim (##repl-channel-result-history-max-length-set! channel max-len)
  (let loop ()
    (let* ((result-history (macro-repl-channel-result-history channel))
           (len (macro-repl-result-history-length result-history))
           (new-len (##fixnum.min len max-len))
           (v (##make-vector (##fixnum.+ new-len 1) max-len)))
      (##subvector-move! result-history 1 (##fixnum.+ new-len 1) v 1)
      (let ()
        (##declare (not interrupts-enabled))
        (if (##not (##eq? (macro-repl-channel-result-history channel)
                          result-history))
            (loop) ;; some other thread changed it before us... try again
            (begin
              (macro-repl-channel-result-history-set! channel v)
              (##void)))))))

(define-prim (##repl-result-history-ref index)
  (let* ((channel (##thread-repl-channel-get! (macro-current-thread)))
         (result-history (macro-repl-channel-result-history channel)))
    (macro-check-fixnum-range
     index
     1
     0
     (macro-repl-result-history-length result-history)
     (repl-result-history-ref index)
     (macro-repl-result-history-ref result-history index))))

(define-prim (repl-result-history-ref index)
  (##repl-result-history-ref index))

(define-prim (##repl-result-history-max-length-set! max-len)
  (let* ((channel (##thread-repl-channel-get! (macro-current-thread)))
         (result-history (macro-repl-channel-result-history channel)))
    (macro-check-fixnum-range-incl
     max-len
     1
     0
     (macro-repl-result-history-max-max-length)
     (repl-result-history-max-length-set! max-len)
     (##repl-channel-result-history-max-length-set! channel max-len))))

(define-prim (repl-result-history-max-length-set! max-len)
  (##repl-result-history-max-length-set! max-len))

(implement-type-repl-channel-ports)

(define-prim (##make-repl-channel-ports input-port output-port)
  (macro-make-repl-channel-ports

   (##make-mutex 'channel-arbiter)
   (macro-current-thread)
   input-port
   output-port
   (##make-empty-repl-result-history)

   ##repl-channel-ports-read-command
   ##repl-channel-ports-write-results
   ##repl-channel-ports-display-monoline-message
   ##repl-channel-ports-display-multiline-message
   ##repl-channel-ports-display-continuation
   ##repl-channel-ports-pinpoint-continuation
   ##repl-channel-ports-really-exit?
   ##repl-channel-ports-newline

   (let ((history-initialized? #f))
     (lambda (channel)

       (if (##not history-initialized?)
           (let ((input-port (macro-repl-channel-input-port channel)))

             (define (in-homedir filename)
               (let ((homedir (##path-expand "~")))
                 (##string-append homedir filename)))

             (set! history-initialized? #t)

             (if (##tty? input-port)
                 (let ((path-or-settings
                        (##list path:
                                (in-homedir ".gambc_history")
                                char-encoding:
                                'UTF-8)))

                   (##open-file-generic
                    (macro-direction-in)
                    #f
                    (lambda (port)
                      (if (##port? port)
                          (let ((history (##read-line port #f #f ##max-fixnum)))
                            (##close-port port)
                            (if (##string? history)
                                (##tty-history-set! input-port history)))))
                    open-input-file
                    (##cons eol-encoding: (##cons 'cr-lf path-or-settings)))

                   (##add-exit-job!
                    (lambda ()
                      (##open-file-generic
                       (macro-direction-out)
                       #f
                       (lambda (port)
                         (if (##port? port)
                             (let ((history (##tty-history input-port)))
                               (##display history port)
                               (##close-port port))))
                       open-output-file
                       path-or-settings)))))))

       (let ((result
              (let ((input-port (macro-repl-channel-input-port channel)))
                (##read-expr-from-port input-port))))
         (let ((output-port (macro-repl-channel-output-port channel)))
           (##output-port-column-set! output-port 1))
         result)))))

(define-prim (##repl-channel-ports-read-command channel level depth)

  (define prompt "> ")

  (let ((output-port (macro-repl-channel-output-port channel)))
    (if (##fixnum.< 0 level)
        (##write level output-port))
    (if (##fixnum.< 0 depth)
        (begin
          (##write-string "\\" output-port)
          (##write depth output-port)))
    (##write-string prompt output-port)
    (##force-output output-port))

  ((macro-repl-channel-ports-read-expr channel) channel))

(define-prim (##repl-channel-ports-write-results channel results)
  (let ((output-port (macro-repl-channel-output-port channel)))
    (##for-each
     (lambda (obj)
       (if (##not (##eq? obj (##void)))
           (begin
             (##repl-channel-result-history-add channel obj)
             (##pretty-print obj output-port))))
     results)))

(define-prim (##repl-channel-ports-display-monoline-message channel writer)
  (let ((output-port (macro-repl-channel-output-port channel)))
    (writer output-port)
    (##newline output-port)))

(define-prim (##repl-channel-ports-display-multiline-message channel writer)
  (let ((output-port (macro-repl-channel-output-port channel)))
    (writer output-port)))

(define-prim (##repl-channel-ports-display-continuation channel cont depth)
  (if (##repl-display-environment?)
      (##repl-channel-display-multiline-message
       (lambda (output-port)
         (##cmd-e cont output-port #t)))))

(define-prim (##repl-channel-ports-pinpoint-continuation channel cont)
  #f)

(define-prim (##repl-channel-ports-really-exit? channel)
  (let ((input-port (macro-repl-channel-input-port channel))
        (output-port (macro-repl-channel-output-port channel)))
    (##write-string "*** EOF again to exit" output-port)
    (##newline output-port)
    (##force-output output-port)
    (##not (##char? (##peek-char input-port)))))

(define-prim (##repl-channel-ports-newline channel)
  (let ((output-port (macro-repl-channel-output-port channel)))
    (##newline output-port)))

;;;============================================================================

;;; Read eval print loop.

;;;----------------------------------------------------------------------------

;;; Evaluation within a specific continuation.

(implement-type-repl-context)

(define-prim (##thread-repl-context-get!)
  (or (macro-current-repl-context)
      (let ((repl-context
             (##make-initial-repl-context)))
        (macro-current-repl-context-set! repl-context)
        (macro-current-repl-context))))

(define-prim (##make-initial-repl-context)
  (macro-make-repl-context -1 0 #f #f #f #f #f))

(define ##repl #f)
(set! ##repl
  (lambda (#!optional (write-reason #f) (reason #f))
    (##continuation-capture
     (lambda (cont)
       (##repl-within cont write-reason reason)))))

(define-prim (##repl-debug #!optional (write-reason #f) (no-result? #f))
  (let* ((old-setting
          (##set-debug-settings!
           (##fixnum.+ (macro-debug-settings-error-mask)
                       (macro-debug-settings-user-intr-mask))
           (##fixnum.+ (macro-debug-settings-error-repl)
                       (macro-debug-settings-user-intr-repl))))
         (results
          (if no-result?
            (##with-no-result-expected (lambda () (##repl write-reason)))
            (##repl write-reason))))
    (##set-debug-settings!
     (macro-debug-settings-error-mask)
     old-setting)
    results))

(define-prim (##repl-debug-main)

  (##current-input-port (##repl-input-port))
  (##current-output-port (##repl-output-port))
  (##current-error-port (##repl-output-port))

  (##repl-debug
   (lambda (first output-port)

     (##define-macro (attrs kind)

       (define style-normal    0)
       (define style-bold      1)
       (define style-underline 2)
       (define style-reverse   4)

       (define color-black   0)
       (define color-red     1)
       (define color-green   2)
       (define color-yellow  3)
       (define color-blue    4)
       (define color-magenta 5)
       (define color-cyan    6)
       (define color-white   7)
       (define default-color 8)

       (define (make-text-attr style fg bg)
         (+ (* style 256) fg (* bg 16)))

       (case kind
         ((banner)
          (make-text-attr style-bold   default-color color-cyan))
         ((input)
          (make-text-attr style-bold   default-color default-color))
         (else
          (make-text-attr style-normal default-color default-color))))

     (if (##tty? output-port)
       (##tty-text-attributes-set! output-port (attrs input) (attrs banner)))

     (##write-string "Gambit " output-port)
     (##write-string (##system-version-string) output-port)

     (if (##tty? output-port)
       (##tty-text-attributes-set! output-port (attrs input) (attrs output)))

     (##newline output-port)
     (##newline output-port)
     #f)
   #t)

  (##exit))

(define-prim (##repl-within cont write-reason reason)

  (define (with-clean-exception-handling repl-context thunk)
    (##with-exception-catcher
     (lambda (exc)
       (##continuation-graft ;; get rid of any useless continuation frames
        (macro-repl-context-cont repl-context)
        (lambda ()
          (release-ownership!)
          (macro-raise exc))))
     thunk))

  (define (acquire-ownership!)
    (##repl-channel-acquire-ownership!))

  (define (release-ownership!)
    (##repl-channel-release-ownership!))

  (define (display-continuation repl-context)
    (##repl-channel-display-continuation
     (macro-repl-context-cont repl-context)
     (macro-repl-context-depth repl-context)))

  (define (first-interesting cont)
    (##continuation-first-frame cont #f))

  (define (restart repl-context)
    (restart-exec
     repl-context
     (lambda ()
       (display-continuation repl-context))))

  (define (restart-pinpointing-continuation show-frame? repl-context)
    (restart-exec
     repl-context
     (lambda ()
       (let ((cont
              (first-interesting
               (macro-repl-context-cont repl-context))))
         (if (and (##not (##repl-channel-pinpoint-continuation cont))
                  show-frame?)
           (##repl-channel-display-multiline-message
            (lambda (output-port)
              (##cmd-y cont
                       output-port
                       #t
                       (macro-repl-context-depth repl-context)))))
         (display-continuation repl-context)))))

  (define (restart-exec repl-context thunk)
    (##continuation-graft ;; get rid of any useless continuation frames
     (macro-repl-context-cont repl-context)
     (lambda ()
       (with-clean-exception-handling
        repl-context
        (lambda ()
          (##parameterize
           ##current-user-interrupt-handler
           ##void ;; ignore user interrupts
           (lambda ()
             (macro-dynamic-bind repl-context
              repl-context
              (lambda ()
                (thunk)
                (prompt repl-context))))))))))

  (define (prompt repl-context)

    (define (cont-in-step-handler?)
      (##eq? (##continuation-parent (macro-repl-context-cont repl-context))
             ##step-handler))

    (define (cont-in-with-no-result-expected?)
      (##eq? (##continuation-parent (macro-repl-context-cont repl-context))
             ##with-no-result-expected))

    (define (continue)
      (prompt repl-context))

    (define (read-command)
      (let ((src
             (##repl-channel-read-command
              (macro-repl-context-level repl-context)
              (macro-repl-context-depth repl-context))))
        (cond ((##eof-object? src)
               src)
              (else
               (let ((code (##source-code src)))
                 (if (and (##pair? code)
                          (##eq? (##source-code (##car code)) 'six.prefix))
                   (let ((rest (##cdr code)))
                     (if (and (##pair? rest)
                              (##null? (##cdr rest)))
                       (##car rest)
                       src))
                   src))))))

    (define (write-results results)
      (##repl-channel-write-results results))

    (define (goto-depth n)
      (restart-pinpointing-continuation #t (get-context n)))

    (define (get-context n)
      (let loop ((context repl-context))
        (let ((depth (macro-repl-context-depth context)))
          (cond ((##fixnum.< n depth)
                 (let ((prev-depth (macro-repl-context-prev-depth context)))
                   (if prev-depth
                       (loop prev-depth)
                       context)))
                ((##fixnum.< depth n)
                 (let* ((cont
                         (first-interesting (macro-repl-context-cont context)))
                        (next
                         (##continuation-next-frame cont #f)))
                   (if next
                       (loop (macro-make-repl-context
                              (macro-repl-context-level context)
                              (##fixnum.+ depth 1)
                              next
                              (macro-repl-context-initial-cont context)
                              (macro-repl-context-reason context)
                              (macro-repl-context-prev-level context)
                              context))
                       context)))
                (else
                 context)))))

    (define (quit)
      (release-ownership!)
      (##continuation-graft
       (macro-repl-context-cont repl-context)
       (lambda ()
         (##exit))))

    (define (quit-thread)
      (release-ownership!)
      (##continuation-graft
       (macro-repl-context-cont repl-context)
       (lambda ()
         (##thread-terminate! (macro-current-thread)))))

    (define (return results)
      (release-ownership!)
      (##continuation-return
       (macro-repl-context-cont repl-context)
       results))

    (define (cmd-d)
      (if (##fixnum.< 0 (macro-repl-context-level repl-context))
        (restart (macro-repl-context-prev-level repl-context))))

    (define (cmd-t)
      (let loop ((context repl-context))
        (if (##fixnum.< 0 (macro-repl-context-level context))
          (loop (macro-repl-context-prev-level context))
          (restart context))))

    (##step-off) ;; turn off single-stepping

    (let ((src (read-command)))

      (define (unknown-command)
        (##repl-channel-display-monoline-message
         (lambda (output-port)
           (##write (##desourcify src) output-port)
           (##write-string " is an unknown command" output-port))))

      (define (invalid-command message)
        (##repl-channel-display-monoline-message
         (lambda (output-port)
           (##write-string message output-port))))

      (define (eval-print src)
        (release-ownership!)
        (##continuation-capture
         (lambda (return)
           (##eval-within
            src
            (macro-repl-context-cont repl-context)
            repl-context
            (lambda (results)
              (##call-with-values
               (lambda ()
                 results)
               (lambda results
                 (write-results results)
                 (##continuation-return return #f)))))))
        (acquire-ownership!))

      (cond ((##eof-object? src)
             (##repl-channel-newline)
             (cmd-d)
             (if (##repl-channel-really-exit?)
               (quit))
             (continue))
            (else
             (let ((code (##source-code src)))
               (if (and (##pair? code)
                        (##eq? (##source-code (##car code)) 'unquote)
                        (##pair? (##cdr code))
                        (##null? (##cddr code)))
                 (let* ((cmd-src (##cadr code))
                        (cmd (##source-code cmd-src)))
                   (cond
                     ((##eq? cmd '?)
                      (##repl-channel-display-multiline-message ##cmd-?)
                      (continue))
                     ((##eq? cmd 'h)
                      (let* ((reason
                              (macro-repl-context-reason repl-context))
                             (proc-and-args
                              (and reason
                                   (##exception-procedure-and-arguments reason)))
                             (proc
                              (and proc-and-args
                                   (##car proc-and-args))))
                        (if proc
                            (##help proc)))
                      (continue))
                     ((##eq? cmd '-)
                      (goto-depth
                       (##fixnum.- (macro-repl-context-depth repl-context) 1)))
                     ((##eq? cmd '+)
                      (goto-depth
                       (##fixnum.+ (macro-repl-context-depth repl-context) 1)))
                     ((or (##eq? cmd 'b)
                          (##eq? cmd 'be)
                          (##eq? cmd 'bed))
                      (##repl-channel-display-multiline-message
                       (lambda (output-port)
                         (##cmd-b (first-interesting
                                   (macro-repl-context-cont repl-context))
                                  output-port
                                  (macro-repl-context-depth repl-context)
                                  (if (##eq? cmd 'bed)
                                      'dynamic
                                      (##eq? cmd 'be)))))
                      (continue))
                     ((##eq? cmd 'i)
                      (##repl-channel-display-multiline-message
                       (lambda (output-port)
                         (##cmd-i (first-interesting
                                   (macro-repl-context-cont repl-context))
                                  output-port)))
                      (continue))
                     ((##eq? cmd 'y)
                      (##repl-channel-display-multiline-message
                       (lambda (output-port)
                         (##cmd-y (first-interesting
                                   (macro-repl-context-cont repl-context))
                                  output-port
                                  #t
                                  (macro-repl-context-depth repl-context))))
                      (continue))
                     ((or (##eq? cmd 'e)
                          (##eq? cmd 'ed))
                      (##repl-channel-display-multiline-message
                       (lambda (output-port)
                         (##cmd-e (macro-repl-context-cont repl-context)
                                  output-port
                                  (if (##eq? cmd 'ed)
                                      'dynamic
                                      #t))))
                      (continue))
                     ((##eq? cmd 'st)
                      (##repl-channel-display-multiline-message
                       (lambda (output-port)
                         (##cmd-st (macro-thread-tgroup (macro-current-thread))
                                   output-port)))
                      (continue))
                     ((##eq? cmd 't)
                      (cmd-t))
                     ((##eq? cmd 'd)
                      (cmd-d)
                      (continue))
                     ((##eq? cmd 'q)
                      (quit))
                     ((##eq? cmd 'qt)
                      (quit-thread))
                     ((and (##fixnum? cmd)
                           (##not (##fixnum.< cmd 0)))
                      (goto-depth cmd))
                     ((or (##eq? cmd 'c) (##eq? cmd 's) (##eq? cmd 'l))
                      (if (or (cont-in-step-handler?)
                              (cont-in-with-no-result-expected?))
                        (return cmd)
                        (begin
                          (invalid-command
                           "Continuation expects a result -- use ,(c X) or ,(s X) or ,(l X)")
                          (continue))))
                     ((and (##pair? cmd)
                           (##pair? (##cdr cmd))
                           (##null? (##cddr cmd)))
                      (let* ((cmd2-src (##car cmd))
                             (cmd2 (##source-code cmd2-src)))
                        (cond
                         ((##eq? cmd2 'h)
                          (##help (##source-code (##cadr cmd)))
                          (continue))
                         ((or (##eq? cmd2 'c)
                              (##eq? cmd2 's)
                              (##eq? cmd2 'l))
                          (if (cont-in-with-no-result-expected?)
                            (begin
                              (invalid-command
                               "Continuation expects no result -- use ,c or ,s or ,l")
                              (continue))
                            (let ((src (##cadr cmd)))
                              (release-ownership!)
                              (##eval-within
                               src
                               (macro-repl-context-cont repl-context)
                               repl-context
                               (if (cont-in-step-handler?)
                                 (lambda (results)
                                   (acquire-ownership!)
                                   (return (##vector results)))
                                 (lambda (results)
                                   (acquire-ownership!)
                                   (return results)))))))
                         ((or (##eq? cmd2 'b)
                              (##eq? cmd2 'be)
                              (##eq? cmd2 'bed)
                              (##eq? cmd2 'e)
                              (##eq? cmd2 'ed)
                              (##eq? cmd2 'v))
                          (let ((src (##cadr cmd)))
                            (release-ownership!)
                            (##eval-within
                             src
                             (macro-repl-context-cont repl-context)
                             repl-context
                             (lambda (results)
                               (let ((val results))

                                 (define (handle proc-or-cont depth)
                                   (if (##eq? cmd2 'v)
                                       (if (##continuation? proc-or-cont)
                                           (let ((cont
                                                  (first-interesting
                                                   proc-or-cont)))
                                             (##repl-within cont #f #f))
                                           (let ((proc
                                                  proc-or-cont))
                                             (##repl-within-proc
                                              proc
                                              (macro-repl-context-cont
                                               repl-context))))
                                       (begin
                                         (##repl-channel-display-multiline-message
                                          (lambda (output-port)
                                            (if (or (##eq? cmd2 'e)
                                                    (##eq? cmd2 'ed))
                                                (##cmd-e proc-or-cont
                                                         output-port
                                                         (if (##eq? cmd2 'ed)
                                                             'dynamic
                                                             #t))
                                                (let ((cont
                                                       (first-interesting
                                                        proc-or-cont)))
                                                  (##cmd-b cont
                                                           output-port
                                                           depth
                                                           (if (##eq? cmd2 'bed)
                                                               'dynamic
                                                               (##eq? cmd2 'be)))))))
                                         (acquire-ownership!)
                                         (continue))))

                                 (cond ((and (##fixnum? val)
                                             (##not (##fixnum.< val 0)))
                                        (let* ((rc
                                                (get-context val))
                                               (depth
                                                (macro-repl-context-depth rc))
                                               (cont
                                                (macro-repl-context-cont rc)))
                                          (handle cont depth)))
                                       ((##continuation? val)
                                        (handle val 0))
                                       ((and (##not (or (##eq? cmd2 'b)
                                                        (##eq? cmd2 'be)
                                                        (##eq? cmd2 'bed)))
                                             (##procedure? val))
                                        (handle val 0))
                                       ((macro-thread? val)
                                        (if (##eq? cmd2 'v)
                                            (begin
                                              (##thread-interrupt!
                                               val
                                               (lambda ()
                                                 (##handle-interrupt #f)))
                                              (##thread-yield!)
                                              (acquire-ownership!)
                                              (continue))
                                            (let ((cont
                                                   (##thread-continuation-capture
                                                    val)))
                                              (handle cont 0))))
                                       (else
                                        (acquire-ownership!)
                                        (invalid-command
                                         (cond ((or (##eq? cmd2 'b)
                                                    (##eq? cmd2 'be)
                                                    (##eq? cmd2 'bed))
                                                "CONTINUATION or THREAD expected")
                                               (else
                                                "PROCEDURE, CONTINUATION or THREAD expected")))
                                        (continue))))))))
                         ((##eq? cmd2 'st)
                          (let ((src (##cadr cmd)))
                            (release-ownership!)
                            (##eval-within
                             src
                             (macro-repl-context-cont repl-context)
                             repl-context
                             (lambda (results)
                               (let ((val results))

                                 (define (handle thread-or-tgroup)
                                   (acquire-ownership!)
                                   (##repl-channel-display-multiline-message
                                    (lambda (output-port)
                                      (##cmd-st thread-or-tgroup
                                                output-port)))
                                   (continue))

                                 (cond ((macro-tgroup? val)
                                        (handle val))
                                       ((macro-thread? val)
                                        (handle val))
                                       (else
                                        (acquire-ownership!)
                                        (invalid-command
                                         "THREAD or THREAD-GROUP expected")
                                        (continue))))))))
                         (else
                          (unknown-command)
                          (continue)))))
                     (else
                      (unknown-command)
                      (continue))))
                 (begin
                   (eval-print src)
                   (continue))))))))

  (let* ((prev-repl-context
          (##thread-repl-context-get!))
         (repl-context
          (macro-make-repl-context
           (##fixnum.+ (macro-repl-context-level prev-repl-context) 1)
           0
           cont
           cont
           reason
           prev-repl-context
           #f)))

    (acquire-ownership!)
    (if (and (##procedure? write-reason)
             (with-clean-exception-handling
              repl-context
              (lambda ()
                (##repl-channel-display-multiline-message
                 (lambda (output-port)
                   (let ((first (first-interesting cont)))
                     (##declare (not safe)) ;; avoid procedure check on the call
                     ;; write-reason returns #f if REPL is to be started
                     (write-reason first output-port)))))))
      (release-ownership!)
      (restart-pinpointing-continuation #f repl-context))))

(define-prim (##repl-within-proc proc cont)
  (cond ((##interp-procedure? proc)
         (##continuation-capture
          (lambda (cont2)

            (define (repl)
              (##continuation-capture
               (lambda (cont3)
                 (##continuation-graft
                  cont2
                  (lambda ()
                    (##repl-within cont3 #f #f))))))

            (##continuation-graft
             cont
             (lambda ()
               (let* (($code (##interp-procedure-code proc))
                      (rte (##interp-procedure-rte proc)))
                 (##declare (not interrupts-enabled) (environment-map))
                 (let ((result (repl)))
                   (##first-argument result $code rte))))))))
        (else
         (error "Can't access compiled procedure's environment"))));;;;;;;;

(define-prim (##eval-within src cont repl-context receiver)

  (define (run c rte)
    (##continuation-graft
     cont
     (lambda ()
       (macro-dynamic-bind repl-context
        repl-context
        (lambda ()
          (receiver
           (let ((rte rte))
             (macro-code-run c))))))))

  (if (##interp-continuation? cont)
    (let* (($code (##interp-continuation-code cont))
           (cte (macro-code-cte $code))
           (rte (##interp-continuation-rte cont)))
      (run (##compile-inner cte
                            (##sourcify src (##make-source #f #f)))
           rte))
    (run (##compile-top ##interaction-cte
                        (##sourcify src (##make-source #f #f)))
         #f)))

;;;----------------------------------------------------------------------------

(define-prim (##repl-exception-handler-hook exc other-handler)
  (##declare (not interrupts-enabled))
  (let ((settings (##set-debug-settings! 0 0)))
    (if (and (##not (##eq? (macro-current-thread) (macro-primordial-thread)))
             (##fixnum.= (macro-debug-settings-uncaught-primordial)
                         (macro-debug-settings-uncaught settings)))
      (other-handler exc)
      (##repl
       (lambda (first output-port)
         (let ((quit? (##fixnum.= (macro-debug-settings-error settings)
                                  (macro-debug-settings-error-quit))))
           (if (and quit?
                    (##fixnum.= (macro-debug-settings-level settings) 0))
             (##exit-with-exception exc)
             (begin
               (##display-exception-in-context exc first output-port)
               (if quit?
                 (##exit-with-exception exc)
                 #f)))))
       exc))))

(define-prim (##default-user-interrupt-handler)
  (let* ((settings (##set-debug-settings! 0 0))
         (settings-user-intr (macro-debug-settings-user-intr settings))
         (defer? (##fixnum.= settings-user-intr
                             (macro-debug-settings-user-intr-defer))))
    (if defer?
        (set! ##deferred-user-interrupt? #t)
        (let ((quit? (##fixnum.= settings-user-intr
                                 (macro-debug-settings-user-intr-quit))))
          (if (and quit?
                   (##fixnum.= (macro-debug-settings-level settings) 0))
              (##exit-abnormally)
              (##handle-interrupt quit?))))))

(define-prim (##handle-interrupt quit?)
  (##with-no-result-expected
   (lambda ()
     (##repl
      (lambda (first output-port)
        (##display-situation
         "INTERRUPTED"
         (##continuation-creator first)
         (##continuation-locat first)
         output-port)
        (##newline output-port)
        (if quit?
            (##exit-abnormally)
            #f))))))

(set! ##primordial-exception-handler-hook ##repl-exception-handler-hook)

(if (##fixnum.= (macro-debug-settings-error (##set-debug-settings! 0 0))
                (macro-debug-settings-error-single-step))
  (##step-on))

(##current-user-interrupt-handler ##default-user-interrupt-handler)

(define-prim (##exception->kind exc)
  (cond (#f;;;;;;;;;;;;;;
         "INTERRUPT")
        (else
         "ERROR")))

(define-prim (##exception->procedure exc cont)
  (cond ((macro-expression-parsing-exception? exc)
         #f)
        ((macro-datum-parsing-exception? exc)
         #f)
        ((and (macro-nonprocedure-operator-exception? exc)
              (macro-nonprocedure-operator-exception-code exc))
         (##extract-container
          (macro-nonprocedure-operator-exception-code exc)
          (macro-nonprocedure-operator-exception-rte exc)))
        (else
         (##continuation-creator cont))))

(define-prim (##exception->locat exc cont)

  (define (source-loc source)
    (##source-locat source))

  (define (code-loc code)
    (##code-locat code))

  (cond ((macro-expression-parsing-exception? exc)
         (source-loc (macro-expression-parsing-exception-source exc)))
        ((macro-datum-parsing-exception? exc)
         (let ((re (macro-datum-parsing-exception-readenv exc)))
           (##readenv->locat re)))
        ((and (macro-nonprocedure-operator-exception? exc)
              (macro-nonprocedure-operator-exception-code exc))
         =>
         code-loc)
        (else
         (##continuation-locat cont))))

(define-prim (##display-situation kind proc locat port)
  (##write-string "*** " port)
  (##write-string kind port)
  (if (or proc locat)
    (##write-string " IN " port))
  (if proc
    (##write (##procedure-friendly-name proc) port))
  (if locat
    (begin
      (if proc
        (##write-string ", " port))
      (##display-locat locat #t port))))

(define-prim (##display-exception-in-context exc cont port)
  (##display-situation
   (##exception->kind exc)
   (##exception->procedure exc cont)
   (##exception->locat exc cont)
   port)
  (##write-string " -- " port)
  (##display-exception exc port))

(define-prim (display-exception-in-context
              exc
              cont
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (exc cont port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-continuation cont 2 (display-exception-in-context exc cont port)
        (macro-check-character-output-port p 3 (display-exception-in-context exc cont p)
          (##display-exception-in-context exc cont p))))))

(define-prim (##default-display-exception exc port)

  (define max-displayed-args 15)

  (define (display-call)
    (let* ((proc-and-args
            (##exception-procedure-and-arguments exc))
           (proc
            (and proc-and-args (##car proc-and-args))))
      (if proc
          (display-call* proc (##cdr proc-and-args)))))

  (define (display-call* proc args)
    (let* ((call
            (##make-call-form proc args max-displayed-args))
           (width
            (##output-port-width port))
           (str
            (##object->string call width)))
      (if (##fixnum.< (##string-length str) width)
        (begin
          (##write-string str port)
          (##newline port))
        (let loop ((i 0) (lst call))
          (##write-string (if (##fixnum.= i 0) "(" " ") port)
          (let* ((last?
                  (##null? (##cdr lst)))
                 (w
                  (##fixnum.- width 2))
                 (s
                  (##object->string (##car lst) w)))
            (##write-string s port)
            (if last?
              (begin
                (if (##fixnum.= (##string-length s) w) (##newline port))
                (##write-string ")" port)
                (##newline port))
              (begin
                (##newline port)
                (loop (##fixnum.+ i 1) (##cdr lst)))))))))

  (define-prim (write-items items)
    (let loop ((lst items))
      (if (##pair? lst)
        (begin
          (##write-string " " port)
          (##write (##car lst) port)
          (loop (##cdr lst))))))

  (define-prim (display-arg-num arg-num)
    (if (##fixnum.< 0 arg-num)
      (begin
        (##write-string "(Argument " port)
        (##write arg-num port)
        (##write-string ") " port))))

  (define-prim (display-exception exc)

    (define (err-code->string code)
      (let ((x (##os-err-code->string code)))
        (if (##string? x)
          x
          "Error code could not be converted to a string")))

    (cond ((macro-abandoned-mutex-exception? exc)
           (##write-string "MUTEX was abandoned" port)
           (##newline port))

          ((macro-sfun-conversion-exception? exc)
           (##write-string
            (or (macro-sfun-conversion-exception-message exc)
                (err-code->string
                 (macro-sfun-conversion-exception-code exc)))
            port)
           (##newline port)
           (display-call))

          ((macro-cfun-conversion-exception? exc)
           (##write-string
            (or (macro-cfun-conversion-exception-message exc)
                (err-code->string
                 (macro-cfun-conversion-exception-code exc)))
            port)
           (##newline port)
           (display-call))

          ((macro-datum-parsing-exception? exc)
           (let ((x
                  (##assq (macro-datum-parsing-exception-kind exc)
                          ##datum-parsing-exception-names)))
             (##write-string
              (if x (##cdr x) "Unknown datum parsing exception")
              port))
           (write-items (macro-datum-parsing-exception-parameters exc))
           (##newline port))

          ((macro-deadlock-exception? exc)
           (##write-string "Deadlock detected" port)
           (##newline port))

          ((macro-divide-by-zero-exception? exc)
           (##write-string "Divide by zero" port)
           (##newline port)
           (display-call))

          ((macro-fixnum-overflow-exception? exc)
           (##write-string "FIXNUM overflow" port)
           (##newline port)
           (display-call))

          ((macro-error-exception? exc)
           (##display (macro-error-exception-message exc) port)
           (let* ((width
                   (##output-port-width port))
                  (sep
                   " ")
                  (params
                   (##map (lambda (p)
                            (let ((s (##object->truncated-string p width)))
                              (if (##fixnum.= (##string-length s) width)
                                (begin
                                  (set! sep "\n")
                                  (##string->limited-string
                                   s
                                   (##fixnum.- width 1)))
                                s)))
                          (macro-error-exception-parameters exc))))
             (##for-each
              (lambda (param)
                (##write-string sep port)
                (##write-string param port))
              params)
             (##newline port)))

          ((macro-invalid-hash-number-exception? exc)
           (##write-string "Invalid hash number" port)
           (##newline port)
           (display-call))

          ((macro-unbound-table-key-exception? exc)
           (##write-string "Unbound table key" port)
           (##newline port)
           (display-call))

          ((macro-unbound-serial-number-exception? exc)
           (##write-string "Unbound serial number" port)
           (##newline port)
           (display-call))

          ((macro-unbound-os-environment-variable-exception? exc)
           (##write-string "Unbound OS environment variable" port)
           (##newline port)
           (display-call))

          ((macro-unterminated-process-exception? exc)
           (##write-string "Process not terminated" port)
           (##newline port)
           (display-call))

          ((macro-nonempty-input-port-character-buffer-exception? exc)
           (##write-string "Input port character buffer is not empty" port)
           (##newline port)
           (display-call))

          ((macro-expression-parsing-exception? exc)
           (let ((x
                  (##assq (macro-expression-parsing-exception-kind exc)
                          ##expression-parsing-exception-names)))
             (##write-string
              (if x (##cdr x) "Unknown expression parsing exception")
              port))
           (write-items (macro-expression-parsing-exception-parameters exc))
           (##newline port)
           (let* ((source (macro-expression-parsing-exception-source exc))
                  (locat (##source-locat source)))
             (if (##not locat)
               (##pretty-print (##desourcify source) port))))

          ((macro-heap-overflow-exception? exc)
           (##write-string "Heap overflow" port)
           (##newline port))

          ((macro-improper-length-list-exception? exc)
           (display-arg-num (macro-improper-length-list-exception-arg-num exc))
           (##write-string "List is not of proper length" port)
           (##newline port)
           (display-call))

          ((macro-join-timeout-exception? exc)
           (##write-string "'thread-join!' timed out" port)
           (##newline port)
           (display-call))

          ((macro-mailbox-receive-timeout-exception? exc)
           (##write-string "mailbox receive timed out" port)
           (##newline port)
           (display-call))

          ((macro-rpc-remote-error-exception? exc)
           (##write-string "RPC failed; remote error message follows" port)
           (##newline port)
           (display-call)
           (##write-string (macro-rpc-remote-error-exception-message exc) port))

          ((macro-keyword-expected-exception? exc)
           (##write-string
            "Keyword argument expected"
            port)
           (##newline port)
           (display-call))

          ((macro-multiple-c-return-exception? exc)
           (##write-string
            "Attempt to return to a C function that has already returned"
            port)
           (##newline port))

          ((macro-noncontinuable-exception? exc)
           (##write-string "Computation cannot be continued" port)
           (##newline port))

          ((macro-nonprocedure-operator-exception? exc)
           (##write-string
            "Operator is not a PROCEDURE"
            port)
           (##newline port)
           (display-call))

          ((macro-number-of-arguments-limit-exception? exc)
           (##write-string
            "Number of arguments exceeds implementation limit"
            port)
           (##newline port)
           (display-call))

          ((macro-os-exception? exc)
           (let ((message (macro-os-exception-message exc))
                 (code (macro-os-exception-code exc)))
             (##write-string
              (or message
                  (if code (err-code->string code) "Unknown OS exception"))
              port))
           (##newline port)
           (display-call))

          ((macro-no-such-file-or-directory-exception? exc)
           (##write-string "No such file or directory" port)
           (##newline port)
           (display-call))

          ((macro-range-exception? exc)
           (display-arg-num (macro-range-exception-arg-num exc))
           (##write-string "Out of range" port)
           (##newline port)
           (display-call))

          ((macro-scheduler-exception? exc)
           (##write-string "Scheduler reported the exception: " port)
           (##write (macro-scheduler-exception-reason exc) port)
           (##newline port))

          ((macro-stack-overflow-exception? exc)
           (##write-string "Stack overflow" port)
           (##newline port))

          ((macro-initialized-thread-exception? exc)
           (##write-string "Thread is initialized" port)
           (##newline port)
           (display-call))

          ((macro-uninitialized-thread-exception? exc)
           (##write-string "Thread is not initialized" port)
           (##newline port)
           (display-call))

          ((macro-inactive-thread-exception? exc)
           (##write-string "Thread is not active" port)
           (##newline port)
           (display-call))

          ((macro-started-thread-exception? exc)
           (##write-string "Thread is started" port)
           (##newline port)
           (display-call))

          ((macro-terminated-thread-exception? exc)
           (##write-string "Thread is terminated" port)
           (##newline port)
           (display-call))

          ((macro-type-exception? exc)
           (display-arg-num (macro-type-exception-arg-num exc))
           (let ((type-id
                  (macro-type-exception-type-id exc)))
             (if (##type? type-id)
               (begin
                 (##write-string "Instance of " port)
                 (##write type-id port))
               (let ((x
                      (##assq (macro-type-exception-type-id exc)
                              ##type-exception-names)))
                 (##write-string (if x (##cdr x) "Unknown type") port))))
           (##write-string " expected" port)
           (##newline port)
           (display-call))

          ((macro-unbound-global-exception? exc)
           (##write-string "Unbound variable: " port)
           (##write (macro-unbound-global-exception-variable exc) port)
           (##newline port))

          ((macro-uncaught-exception? exc)
           (##write-string "Uncaught exception: " port)
           (##write (macro-uncaught-exception-reason exc) port)
           (##newline port)
           (display-call))

          ((macro-unknown-keyword-argument-exception? exc)
           (##write-string
            "Unknown keyword argument passed to procedure"
            port)
           (##newline port)
           (display-call))

          ((macro-wrong-number-of-arguments-exception? exc)
           (##write-string
            "Wrong number of arguments passed to procedure"
            port)
           (##newline port)
           (display-call))

          (else
           (##write-string "This object was raised: " port)
           (##write exc port)
           (##newline port))))

  (display-exception exc))

(define-prim (##exception-procedure-and-arguments exc)
  (cond ((macro-sfun-conversion-exception? exc)
         (##cons
          (macro-sfun-conversion-exception-procedure exc)
          (macro-sfun-conversion-exception-arguments exc)))

        ((macro-cfun-conversion-exception? exc)
         (##cons
          (macro-cfun-conversion-exception-procedure exc)
          (macro-cfun-conversion-exception-arguments exc)))

        ((macro-divide-by-zero-exception? exc)
         (##cons
          (macro-divide-by-zero-exception-procedure exc)
          (macro-divide-by-zero-exception-arguments exc)))

        ((macro-fixnum-overflow-exception? exc)
         (##cons
          (macro-fixnum-overflow-exception-procedure exc)
          (macro-fixnum-overflow-exception-arguments exc)))

        ((macro-invalid-hash-number-exception? exc)
         (##cons
          (macro-invalid-hash-number-exception-procedure exc)
          (macro-invalid-hash-number-exception-arguments exc)))

        ((macro-unbound-table-key-exception? exc)
         (##cons
          (macro-unbound-table-key-exception-procedure exc)
          (macro-unbound-table-key-exception-arguments exc)))

        ((macro-unbound-serial-number-exception? exc)
         (##cons
          (macro-unbound-serial-number-exception-procedure exc)
          (macro-unbound-serial-number-exception-arguments exc)))

        ((macro-unbound-os-environment-variable-exception? exc)
         (##cons
          (macro-unbound-os-environment-variable-exception-procedure exc)
          (macro-unbound-os-environment-variable-exception-arguments exc)))

        ((macro-unterminated-process-exception? exc)
         (##cons
          (macro-unterminated-process-exception-procedure exc)
          (macro-unterminated-process-exception-arguments exc)))

        ((macro-nonempty-input-port-character-buffer-exception? exc)
         (##cons
          (macro-nonempty-input-port-character-buffer-exception-procedure exc)
          (macro-nonempty-input-port-character-buffer-exception-arguments exc)))

        ((macro-improper-length-list-exception? exc)
         (##cons
          (macro-improper-length-list-exception-procedure exc)
          (macro-improper-length-list-exception-arguments exc)))

        ((macro-join-timeout-exception? exc)
         (##cons
          (macro-join-timeout-exception-procedure exc)
          (macro-join-timeout-exception-arguments exc)))

        ((macro-mailbox-receive-timeout-exception? exc)
         (##cons
          (macro-mailbox-receive-timeout-exception-procedure exc)
          (macro-mailbox-receive-timeout-exception-arguments exc)))

        ((macro-rpc-remote-error-exception? exc)
         (##cons
          (macro-rpc-remote-error-exception-procedure exc)
          (macro-rpc-remote-error-exception-arguments exc)))

        ((macro-keyword-expected-exception? exc)
         (##cons
          (macro-keyword-expected-exception-procedure exc)
          (macro-keyword-expected-exception-arguments exc)))

        ((macro-number-of-arguments-limit-exception? exc)
         (##cons
          (macro-number-of-arguments-limit-exception-procedure exc)
          (macro-number-of-arguments-limit-exception-arguments exc)))

        ((macro-os-exception? exc)
         (##cons
          (macro-os-exception-procedure exc)
          (macro-os-exception-arguments exc)))

        ((macro-no-such-file-or-directory-exception? exc)
         (##cons
          (macro-no-such-file-or-directory-exception-procedure exc)
          (macro-no-such-file-or-directory-exception-arguments exc)))

        ((macro-range-exception? exc)
         (##cons
          (macro-range-exception-procedure exc)
          (macro-range-exception-arguments exc)))

        ((macro-initialized-thread-exception? exc)
         (##cons
          (macro-initialized-thread-exception-procedure exc)
          (macro-initialized-thread-exception-arguments exc)))

        ((macro-uninitialized-thread-exception? exc)
         (##cons
          (macro-uninitialized-thread-exception-procedure exc)
          (macro-uninitialized-thread-exception-arguments exc)))

        ((macro-inactive-thread-exception? exc)
         (##cons
          (macro-inactive-thread-exception-procedure exc)
          (macro-inactive-thread-exception-arguments exc)))

        ((macro-started-thread-exception? exc)
         (##cons
          (macro-started-thread-exception-procedure exc)
          (macro-started-thread-exception-arguments exc)))

        ((macro-terminated-thread-exception? exc)
         (##cons
          (macro-terminated-thread-exception-procedure exc)
          (macro-terminated-thread-exception-arguments exc)))

        ((macro-type-exception? exc)
         (##cons
          (macro-type-exception-procedure exc)
          (macro-type-exception-arguments exc)))

        ((macro-uncaught-exception? exc)
         (##cons
          (macro-uncaught-exception-procedure exc)
          (macro-uncaught-exception-arguments exc)))

        ((macro-unknown-keyword-argument-exception? exc)
         (##cons
          (macro-unknown-keyword-argument-exception-procedure exc)
          (macro-unknown-keyword-argument-exception-arguments exc)))

        ((macro-wrong-number-of-arguments-exception? exc)
         (##cons
          (macro-wrong-number-of-arguments-exception-procedure exc)
          (macro-wrong-number-of-arguments-exception-arguments exc)))

        (else
         #f)))

(define ##display-exception-hook #f)
(set! ##display-exception-hook ##default-display-exception)

(define-prim (##display-exception exc port)
  (##display-exception-hook exc port))

(define-prim (display-exception
              exc
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (exc port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (macro-current-output-port)
               port)))
      (macro-check-character-output-port p 2 (display-exception exc p)
        (##display-exception exc p)))))

(define ##type-exception-names #f)
(set! ##type-exception-names
  '(
    ;; from "_kernel.scm":
    (foreign                      . "FOREIGN object")

    ;; from "_system.scm":
    (hash-algorithm               . "HASH ALGORITHM")

    ;; from "_thread.scm":
    (continuation                 . "CONTINUATION")
    (time                         . "TIME object")
    (absrel-time                  . "REAL or TIME object")
    (absrel-time-or-false         . "#f or REAL or TIME object")
    (thread                       . "THREAD")
    (mutex                        . "MUTEX")
    (convar                       . "CONDITION VARIABLE")
    (tgroup                       . "THREAD GROUP")
    (deadlock-exception           . "DEADLOCK-EXCEPTION object")
    (join-timeout-exception       . "JOIN-TIMEOUT-EXCEPTION object")
    (mailbox-receive-timeout-exception . "MAILBOX-RECEIVE-TIMEOUT-EXCEPTION object")
    (abandoned-mutex-exception    . "ABANDONED-MUTEX-EXCEPTION object")
    (initialized-thread-exception . "INITIALIZED-THREAD-EXCEPTION object")
    (uninitialized-thread-exception . "UNINITIALIZED-THREAD-EXCEPTION object")
    (started-thread-exception     . "STARTED-THREAD-EXCEPTION object")
    (terminated-thread-exception  . "TERMINATED-THREAD-EXCEPTION object")
    (uncaught-exception           . "UNCAUGHT-EXCEPTION object")
    (scheduler-exception          . "SCHEDULER-EXCEPTION object")
    (noncontinuable-exception     . "NONCONTINUABLE-EXCEPTION object")
    (low-level-exception          . "LOW-LEVEL-EXCEPTION object")

    ;; from "_std.scm":
    (mutable                      . "MUTABLE object")
    (pair                         . "PAIR")
    (pair-list                    . "PAIR LIST")
    (char                         . "CHARACTER")
    (char-list                    . "CHARACTER LIST")
    (string                       . "STRING")
    (string-list                  . "STRING LIST")
    (list                         . "LIST")
    (symbol                       . "SYMBOL")
    (keyword                      . "KEYWORD")
    (vector                       . "VECTOR")
    (s8vector                     . "S8VECTOR")
    (u8vector                     . "U8VECTOR")
    (s16vector                    . "S16VECTOR")
    (u16vector                    . "U16VECTOR")
    (s32vector                    . "S32VECTOR")
    (u32vector                    . "U32VECTOR")
    (s64vector                    . "S64VECTOR")
    (u64vector                    . "U64VECTOR")
    (f32vector                    . "F32VECTOR")
    (f64vector                    . "F64VECTOR")
    (procedure                    . "PROCEDURE")

    ;; from "_num.scm":
    (exact-signed-int8            . "Signed 8 bit exact INTEGER")
    (exact-signed-int8-list       . "Signed 8 bit exact INTEGER LIST")
    (exact-unsigned-int8          . "Unsigned 8 bit exact INTEGER")
    (exact-unsigned-int8-list     . "Unsigned 8 bit exact INTEGER LIST")
    (exact-signed-int16           . "Signed 16 bit exact INTEGER")
    (exact-signed-int16-list      . "Signed 16 bit exact INTEGER LIST")
    (exact-unsigned-int16         . "Unsigned 16 bit exact INTEGER")
    (exact-unsigned-int16-list    . "Unsigned 16 bit exact INTEGER LIST")
    (exact-signed-int32           . "Signed 32 bit exact INTEGER")
    (exact-signed-int32-list      . "Signed 32 bit exact INTEGER LIST")
    (exact-unsigned-int32         . "Unsigned 32 bit exact INTEGER")
    (exact-unsigned-int32-list    . "Unsigned 32 bit exact INTEGER LIST")
    (exact-signed-int64           . "Signed 64 bit exact INTEGER")
    (exact-signed-int64-list      . "Signed 64 bit exact INTEGER LIST")
    (exact-unsigned-int64         . "Unsigned 64 bit exact INTEGER")
    (exact-unsigned-int64-list    . "Unsigned 64 bit exact INTEGER LIST")
    (inexact-real                 . "Inexact REAL")
    (inexact-real-list            . "Inexact REAL LIST")
    (number                       . "NUMBER")
    (real                         . "REAL")
    (finite-real                  . "Finite REAL")
    (rational                     . "RATIONAL")
    (integer                      . "INTEGER")
    (exact-integer                . "Exact INTEGER")
    (fixnum                       . "FIXNUM")
    (flonum                       . "FLONUM")
    (random-source-state          . "RANDOM-SOURCE state")

    ;; from "_nonstd.scm":
    (string-or-nonnegative-fixnum . "STRING or nonnegative fixnum")
    (will                         . "WILL")
    (box                          . "BOX")
    (unterminated-process-exception . "UNTERMINATED-PROCESS-EXCEPTION object")

    ;; from "_io.scm":
    (string-or-ip-address         . "STRING or IP address")
    (settings                     . "Port settings")
    (vector-or-settings           . "VECTOR or port settings")
    (string-or-settings           . "STRING or port settings")
    (u8vector-or-settings         . "U8VECTOR or port settings")
    (exact-integer-or-string-or-settings . "Exact INTEGER or STRING or port settings")
    (port                         . "PORT")
    (input-port                   . "INPUT PORT")
    (output-port                  . "OUTPUT PORT")
    (character-input-port         . "Character INPUT PORT")
    (character-output-port        . "Character OUTPUT PORT")
    (byte-input-port              . "Byte INPUT PORT")
    (byte-output-port             . "Byte OUTPUT PORT")
    (device-input-port            . "Device INPUT PORT")
    (device-output-port           . "Device OUTPUT PORT")
    (vector-input-port            . "Vector INPUT PORT")
    (vector-output-port           . "Vector OUTPUT PORT")
    (string-input-port            . "String INPUT PORT")
    (string-output-port           . "String OUTPUT PORT")
    (u8vector-input-port          . "U8vector INPUT PORT")
    (u8vector-output-port         . "U8vector OUTPUT PORT")
    (file-port                    . "File PORT")
    (tty-port                     . "Tty PORT")
    (tcp-client-port              . "Tcp client PORT")
    (tcp-server-port              . "Tcp server PORT")
    (pipe-port                    . "Pipe PORT")
    (serial-port                  . "Serial PORT")
    (directory-port               . "Directory PORT")
    (event-queue-port             . "Event-queue PORT")
    (timer-port                   . "Timer PORT")
    (readtable                    . "READTABLE")
    (hostent                      . "HOSTENT")
    (datum-parsing-exception      . "DATUM PARSING EXCEPTION object")

    ;; from "_eval.scm":
    (expression-parsing-exception . "EXPRESSION PARSING EXCEPTION object")

    ;; from "_repl.scm":
    (interpreted-procedure        . "Interpreted PROCEDURE")
   ))

;;;;;;;    (psettings                    . "Invalid port settings")
;;;;;;;    (open-file                    . "Can't open file")


(define ##datum-parsing-exception-names #f)
(set! ##datum-parsing-exception-names
  '(
    (datum-or-eof-expected          . "Datum or EOF expected")
    (datum-expected                 . "Datum expected")
    (improperly-placed-dot          . "Improperly placed dot")
    (incomplete-form-eof-reached    . "Incomplete form, EOF reached")
    (incomplete-form                . "Incomplete form")
    (character-out-of-range         . "Character out of range")
    (invalid-character-name         . "Invalid '#\\' name:")
    (illegal-character              . "Illegal character:")
    (s8-expected                    . "Signed 8 bit exact integer expected")
    (u8-expected                    . "Unsigned 8 bit exact integer expected")
    (s16-expected                   . "Signed 16 bit exact integer expected")
    (u16-expected                   . "Unsigned 16 bit exact integer expected")
    (s32-expected                   . "Signed 32 bit exact integer expected")
    (u32-expected                   . "Unsigned 32 bit exact integer expected")
    (s64-expected                   . "Signed 64 bit exact integer expected")
    (u64-expected                   . "Unsigned 64 bit exact integer expected")
    (inexact-real-expected          . "Inexact real expected")
    (invalid-hex-escape             . "Invalid hexadecimal escape")
    (invalid-escaped-character      . "Invalid escaped character:")
    (open-paren-expected            . "'(' expected")
    (invalid-token                  . "Invalid token")
    (invalid-sharp-bang-name        . "Invalid '#!' name:")
    (duplicate-label-definition     . "Duplicate definition for label:")
    (missing-label-definition       . "Missing definition for label:")
    (illegal-label-definition       . "Illegal definition of label:")
    (invalid-infix-syntax-character . "Invalid infix syntax character")
    (invalid-infix-syntax-number    . "Invalid infix syntax number")
    (invalid-infix-syntax           . "Invalid infix syntax")
   ))

(define ##expression-parsing-exception-names #f)
(set! ##expression-parsing-exception-names
  '(
    (id-expected                      . "Identifier expected")
    (invalid-module-name              . "Invalid module name")
    (ill-formed-namespace             . "Ill-formed namespace")
    (ill-formed-namespace-prefix      . "Ill-formed namespace prefix")
    (namespace-prefix-must-be-string  . "Namespace prefix must be a string")
    (macro-used-as-variable           . "Macro name can't be used as a variable:")
    (ill-formed-macro-transformer     . "Macro transformer must be a lambda expression")
    (reserved-used-as-variable        . "Reserved identifier can't be used as a variable:")
    (ill-formed-special-form          . "Ill-formed special form:")
    (cannot-open-file                 . "Can't open file")
    (filename-expected                . "Filename expected")
    (ill-placed-define                . "Ill-placed 'define'")
    (ill-placed-include               . "Ill-placed 'include'")
    (ill-placed-define-macro          . "Ill-placed 'define-macro'")
    (ill-placed-define-syntax         . "Ill-placed 'define-syntax'")
    (ill-placed-declare               . "Ill-placed 'declare'")
    (ill-placed-namespace             . "Ill-placed 'namespace'")
;;    (ill-placed-library               . "Ill-placed 'library'")
;;    (ill-placed-export                . "Ill-placed 'export'")
;;    (ill-placed-import                . "Ill-placed 'import'")
    (unknown-location                 . "Unknown location")
    (ill-formed-expression            . "Ill-formed expression")
    (unsupported-special-form         . "Interpreter does not support")
    (parameter-must-be-id             . "Parameter must be an identifier")
    (parameter-must-be-id-or-default  . "Parameter must be an identifier or default binding")
    (duplicate-parameter              . "Duplicate parameter in parameter list")
    (duplicate-rest-parameter         . "Duplicate rest parameter in parameter list")
    (parameter-expected-after-rest    . "#!rest must be followed by a parameter")
    (rest-parm-must-be-last           . "Rest parameter must be last")
    (ill-formed-default               . "Ill-formed default binding")
    (ill-placed-optional              . "Ill-placed #!optional")
    (ill-placed-key                   . "Ill-placed #!key")
    (key-expected-after-rest          . "#!key expected after rest parameter")
    (ill-placed-default               . "Ill-placed default binding")
    (duplicate-variable-definition    . "Duplicate definition of a variable")
    (empty-body                       . "Body must contain at least one expression")
    (else-clause-not-last             . "Else clause must be last")
    (ill-formed-selector-list         . "Ill-formed selector list")
    (duplicate-variable-binding       . "Duplicate variable in bindings")
    (ill-formed-binding-list          . "Ill-formed binding list")
    (ill-formed-call                  . "Ill-formed procedure call")
    (ill-formed-cond-expand           . "Ill-formed 'cond-expand'")
    (unfulfilled-cond-expand          . "Unfulfilled 'cond-expand'")
   ))

;;;----------------------------------------------------------------------------

(define-prim (##gambc-doc . args)

  (define (gambc-doc args)

    (define (gen-args args i)
      (if (##null? args)
          '()
          (##cons (arg (##string-append "ARG" (##number->string i 10))
                       (##car args))
                  (gen-args (##cdr args) (##fixnum.+ i 1)))))

    (define (arg name val)
      (##string-append "GAMBC_DOC_" name "=" val))

    (define (install-dir path)
      (parameterize
       ((##current-directory
         (##path-expand path)))
       (##current-directory)))

    (let* ((gambcdir-bin
            (install-dir "~~bin"))
           (gambcdir-doc
            (install-dir "~~doc")))
      (##open-process
       #t
       (lambda (port)
         (let ((status (##process-status port)))
           (##close-port port)
           status))
       open-process
       (##list path:
               (##string-append gambcdir-bin "gambc-doc.bat")
               arguments:
               '()
               environment:
               (##append
                (let ((env (##os-environ)))
                  (if (##fixnum? env) '() env))
                (##cons (arg "GAMBCDIR_BIN"
                             (##path-strip-trailing-directory-separator
                              gambcdir-bin))
                        (##cons (arg "GAMBCDIR_DOC"
                                     (##path-strip-trailing-directory-separator
                                      gambcdir-doc))
                                (gen-args args 1))))
               stdin-redirection: #f
               stdout-redirection: #f
               stderr-redirection: #f))))

  (let ((exit-status (gambc-doc args)))
    (if (##fixnum.= exit-status 0)
        (##void)
        (##raise-error-exception
         "failed to display the document"
         args))))

(define-prim (##escape-link str)
  (##apply ##string-append
           (##map (lambda (c)
                    (cond ((##char=? c #\space) "_")
                          ((##char=? c #\#) "%E2%99%AF")
                          ((##char=? c #\%) "%25")
                          ((##char=? c #\*) "%2A")
                          ((##char=? c #\+) "%2B")
                          ((##char=? c #\<) "%3C")
                          ((##char=? c #\>) "%3E")
                          (else             (##string c))))
                  (##string->list str))))

(define-prim (##show-help prefix subject)
  (##gambc-doc "help"
               subject
               (##help-browser)
               (##escape-link (##string-append prefix subject))))

(define ##help-browser
  (##make-parameter
   ""
   (lambda (val)
    (macro-check-string val 1 (##help-browser val)
      val))))

(define help-browser
  ##help-browser)

(define-prim (##show-definition-of subject)
  (let ((s
         (cond ((##procedure? subject)
                (##object->string (##procedure-name subject)))
               (else
                (##object->string subject)))))
    (##show-help "Definition of " s)))

(define-prim (##default-help subject)
  (##show-definition-of subject))

(define ##help-hook #f)
(set! ##help-hook ##default-help)

(define-prim (##help subject)
  (##help-hook subject))

(define-prim (help subject)
  (macro-force-vars (subject)
    (##help subject)))

;;;----------------------------------------------------------------------------

(define-runtime-macro (time expr)
  `(##time (lambda () ,expr) ',expr))

(define-prim (##time thunk expr)
  (let ((at-start (##process-statistics)))
    (let ((result (thunk)))
      (let ((at-end (##process-statistics)))

        (define (secs->msecs x)
          (##inexact->exact (##round (##* x 1000))))

        (##repl
         (lambda (first output-port)
           (let* ((user-time
                   (secs->msecs
                    (##- (##f64vector-ref at-end 0)
                         (##f64vector-ref at-start 0))))
                  (sys-time
                   (secs->msecs
                    (##- (##f64vector-ref at-end 1)
                         (##f64vector-ref at-start 1))))
                  (cpu-time
                   (##+ user-time sys-time))
                  (real-time
                   (secs->msecs
                    (##- (##f64vector-ref at-end 2)
                         (##f64vector-ref at-start 2))))
                  (gc-user-time
                   (secs->msecs
                    (##- (##f64vector-ref at-end 3)
                         (##f64vector-ref at-start 3))))
                  (gc-sys-time
                   (secs->msecs
                    (##- (##f64vector-ref at-end 4)
                         (##f64vector-ref at-start 4))))
                  (gc-real-time
                   (secs->msecs
                    (##- (##f64vector-ref at-end 5)
                         (##f64vector-ref at-start 5))))
                  (nb-gcs
                   (##flonum.->exact-int
                    (##- (##f64vector-ref at-end 6)
                         (##f64vector-ref at-start 6))))
                  (minflt
                   (##flonum.->exact-int
                    (##- (##f64vector-ref at-end 10)
                         (##f64vector-ref at-start 10))))
                  (majflt
                   (##flonum.->exact-int
                    (##- (##f64vector-ref at-end 11)
                         (##f64vector-ref at-start 11))))
                  (bytes-allocated
                   (##flonum.->exact-int
                    (##- (##- (##f64vector-ref at-end 7)
                              (##f64vector-ref at-start 7))
                         (##+ (if (##interp-procedure? thunk)
                                (##f64vector-ref at-end 8) ;; thunk call frame space
                                (macro-inexact-+0))
                              (##f64vector-ref at-end 9)))))) ;; at-end structure space

             (define (pluralize n msg)
               (##write-string "    " output-port)
               (if (##= n 0)
                 (##write-string "no" output-port)
                 (##write n output-port))
               (##write-string msg output-port)
               (if (##not (##= n 1))
                 (##write-string "s" output-port)))

             (##write (##list 'time expr) output-port)
             (##newline output-port)

             (##write-string "    " output-port)
             (##write real-time output-port)
             (##write-string " ms real time" output-port)
             (##newline output-port)

             (##write-string "    " output-port)
             (##write cpu-time output-port)
             (##write-string " ms cpu time (" output-port)
             (##write user-time output-port)
             (##write-string " user, " output-port)
             (##write sys-time output-port)
             (##write-string " system)" output-port)
             (##newline output-port)

             (pluralize nb-gcs " collection")
             (if (##not (##= nb-gcs 0))
               (begin
                 (##write-string " accounting for " output-port)
                 (##write gc-real-time output-port)
                 (##write-string " ms real time (" output-port)
                 (##write gc-user-time output-port)
                 (##write-string " user, " output-port)
                 (##write gc-sys-time output-port)
                 (##write-string " system)" output-port)))
             (##newline output-port)

             (pluralize bytes-allocated " byte")
             (##write-string " allocated" output-port)
             (##newline output-port)

             (pluralize minflt " minor fault")
             (##newline output-port)

             (pluralize majflt " major fault")
             (##newline output-port)

             #t)))

        result))))

;;;----------------------------------------------------------------------------

;; enable processing of heartbeat interrupts, user interrupts, GC
;; interrupts, etc.

(##enable-interrupts!)

;;;============================================================================
