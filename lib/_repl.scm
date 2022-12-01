;;;============================================================================

;;; File: "_repl.scm"

;;; Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved.

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
             (if (and (##pair? vars)
                      (let ((var (##car vars)))
                        (and (##var-i? var)
                             (##eq? (##var-i-name var) (macro-self-var)))))
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
  (or (##eq? x (##void))
      (and (##pair? x)
           (##eq? (##car x) 'quote)
           (##eq? (##cadr x) (##void)))))

(define-prim (##unbegin x)
  (if (##begin? x)
      (##cdr x)
      (##list x)))

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
             (if (##fx= up 0)
                 (let loop2 ((vars (##cte-frame-vars c)) (i over))
                   (if (##fx< i 2)
                       (let ((var (##car vars)))
                         (if (##var-i? var)
                             (##var-i-name var)
                             (##var-c-name var)))
                       (loop2 (##cdr vars) (##fx- i 1))))
                 (loop1 (##cte-parent-cte c) (##fx- up 1))))
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
    (##list 'set!
            (degen ##degen-up-over (^ 1) (^ 2))
            (##decomp (^ 0)))))

(define-prim ##degen-glo-set
  (mk-degen ()
    (##list 'set!
            (##global-var->identifier (^ 1))
            (##decomp (^ 0)))))

(define-prim ##degen-glo-def
  (mk-degen ()
    (##list 'define
            (##global-var->identifier (^ 1))
            (##decomp (^ 0)))))

(define-prim ##degen-if2
  (mk-degen ()
    (##list 'if
            (##decomp (^ 0))
            (##decomp (^ 1)))))

(define-prim ##degen-if3
  (mk-degen ()
    (##list 'if
            (##decomp (^ 0))
            (##decomp (^ 1))
            (##decomp (^ 2)))))

(define-prim ##degen-seq
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (##cons 'begin
              (##cons val1
                      (##unbegin val2))))))

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
       (##cons val1
               (##unbegin val2))
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
  (##cons 'cond
          (##cons clause
                  (cond ((##cond? rest)
                         (##cdr rest))
                        ((##void-constant? rest)
                         '())
                        (else
                         (##list (##cons 'else
                                         (##unbegin rest))))))))

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

(define-prim ##degen-case-list
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (##cons (##cons (^ 2)
                      (##unbegin val1))
              val2))))

(define-prim ##degen-case-else
  (mk-degen ()
    (let ((val (##decomp (^ 0))))
      (if (##void-constant? val)
          '()
          (##list (##cons 'else
                          (##unbegin val)))))))

(define-prim ##degen-case-send
  (mk-degen ()
    (let ((val1 (##decomp (^ 0)))
          (val2 (##decomp (^ 1))))
      (##cons (##list (or (^ 2) 'else)
                      '=>
                      val1)
              val2))))

(define-prim ##degen-let
  (mk-degen ()
    (let ((n (macro-code-length $code)))
      (let loop ((i (##fx- n 2)) (vals '()))
        (if (##fx< 0 i)
            (loop (##fx- i 1)
                  (##cons (##decomp (macro-code-ref $code i)) vals))
            (let ((body
                   (##decomp (^ 0)))
                  (bindings
                   (##make-bindings
                    (##cte-frame-vars (macro-code-cte (^ 0)))
                    vals))
                  (form
                   (case (macro-code-ref $code (##fx- (macro-code-length $code) 1))
                     ((#f) 'let)
                     ((#t) 'letrec)
                     (else 'letrec*))))
              (##cons form
                      (##cons bindings
                              (##unbegin body)))))))))

(define-prim ##degen-let-values
  (mk-degen ()
    (let* ((n
            (macro-code-length $code))
           (body
            (##decomp (^ 0)))
           (bindings
            (##make-bindings-values
             (##cte-frame-vars (macro-code-cte (^ 0)))
             (macro-code-ref $code (##fx- n 2))
             $code))
           (form
            (case (macro-code-ref $code (##fx- (macro-code-length $code) 1))
              ((#f) 'let-values)
              ((#t) 'letrec-values)
              (else 'letrec*-values))))
      (##cons form
              (##cons bindings
                      (##unbegin body))))))

(define-prim (##make-bindings-values vars patterns $code)
  (let ((vars-vect (##list->vector vars))) ;;TODO: do conversion to vectors elsewhere
    (let loop1 ((i (##fx- (##vector-length patterns) 1))
                (j (##fx- (##vector-length vars-vect) 1))
                (bindings '()))

      (define (build j n lst)
        (if (##fx< 0 n)
            (build (##fx- j 1)
                   (##fx- n 1)
                   (##cons (##vector-ref vars-vect j) lst))
            (loop1 (##fx- i 1)
                   j
                   (##cons (##list lst
                                   (##decomp (macro-code-ref $code i)))
                           bindings))))

      (if (##fx<= i 0)
          bindings
          (let ((pattern (##vector-ref patterns i)))
            (if (##fx< pattern 0)
                (build (##fx- j 1)
                       (##fx- -1 pattern)
                       (##vector-ref vars-vect j))
                (build j
                       pattern
                       '())))))))

(define-prim (##make-bindings l1 l2)
  (if (##pair? l1)
      (##cons (##list (##car l1) (##car l2))
              (##make-bindings (##cdr l1) (##cdr l2)))
      '()))

(define-prim ##degen-letrec
  (mk-degen ()
    (##degen-letrec-aux $code 'letrec)))

(define-prim ##degen-letrec*
  (mk-degen ()
    (##degen-letrec-aux $code 'letrec*)))

(define-prim (##degen-letrec-aux $code sym)
  (let ((n (macro-code-length $code)))
    (let loop ((i (##fx- n 2)) (vals '()))
      (if (##fx< 0 i)
          (loop (##fx- i 1)
                (##cons (##decomp (macro-code-ref $code i)) vals))
          (let ((body
                 (##decomp (^ 0)))
                (bindings
                 (##make-bindings (macro-code-ref $code (##fx- n 1))
                                  vals)))
            (##cons sym
                    (##cons bindings
                            (##unbegin body))))))))

(define-prim ##degen-prc-req
  (mk-degen ()
    (let* ((n (macro-code-length $code))
           (body (##decomp (^ 0)))
           (params (macro-code-ref $code (##fx- n 1))))
      (##cons 'lambda
              (##cons params
                      (##unbegin body))))))

(define-prim ##degen-prc-rest
  (mk-degen ()
    (let ((body (##decomp (^ 0)))
          (params (##make-params (^ 3) #t #f '())))
      (##cons 'lambda
              (##cons params
                      (##unbegin body))))))

(define-prim ##degen-prc
  (mk-degen ()
    (let ((n (macro-code-length $code)))
      (let loop ((i (##fx- n 8)) (inits '()))
        (if (##not (##fx< i 1))
            (loop (##fx- i 1)
                  (##cons (##decomp (macro-code-ref $code i)) inits))
            (let ((body
                   (##decomp (^ 0)))
                  (params
                   (##make-params
                    (macro-code-ref $code (##fx- n 1))
                    (macro-code-ref $code (##fx- n 4))
                    (macro-code-ref $code (##fx- n 3))
                    inits)))
              (##cons 'lambda
                      (##cons params
                              (##unbegin body)))))))))

(define-prim (##make-params parms rest? keys inits)
  (let* ((nb-parms
          (##length parms))
         (nb-inits
          (##length inits))
         (nb-reqs
          (##fx- nb-parms (##fx+ nb-inits (if rest? 1 0))))
         (nb-opts
          (##fx- nb-inits (if keys (##vector-length keys) 0))))

    (define (build-reqs)
      (let loop ((parms parms)
                 (i nb-reqs))
        (if (##fx= i 0)
            (build-opts parms)
            (let ((parm (##car parms)))
              (##cons parm
                      (loop (##cdr parms)
                            (##fx- i 1)))))))

    (define (build-opts parms)
      (if (##fx= nb-opts 0)
          (build-rest-and-keys parms inits)
          (##cons #!optional
                  (let loop ((parms parms)
                             (i nb-opts)
                             (inits inits))
                    (if (##fx= i 0)
                        (build-rest-and-keys parms inits)
                        (let ((parm (##car parms))
                              (init (##car inits)))
                          (##cons (if (##eq? init #f) parm (##list parm init))
                                  (loop (##cdr parms)
                                        (##fx- i 1)
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
                    (if (##fx= i 0)
                        (build-rest-at-end parms)
                        (let ((parm (##car parms))
                              (init (##car inits)))
                          (##cons (if (##eq? init #f) parm (##list parm init))
                                  (loop (##cdr parms)
                                        (##fx- i 1)
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
      (let loop ((i (##fx- n 1)) (vals '()))
        (if (##not (##fx< i 0))
            (loop (##fx- i 1)
                  (##cons (##decomp (macro-code-ref $code i)) vals))
            vals)))))

(define-prim ##degen-delay
  (mk-degen ()
    (##list 'delay (##decomp (^ 0)))))

(define-prim ##degen-future
  (mk-degen ()
    (##list 'future (##decomp (^ 0)))))

(define-prim ##degen-reraise
  (mk-degen ()
    (##void)))

(define ##degen-guard
  (mk-degen (form)
    (let ((body (##decomp (^ 0)))
          (handler (##decomp (^ 1))))
      (##cons form
              (##cons (##cons
                       (##car (##cte-frame-vars (macro-code-cte (^ 1))))
                       (if (##pair? handler) ;; cond form?
                           (##cdr handler)
                           '()))
                      (##unbegin body))))))

;;;----------------------------------------------------------------------------

(define ##decomp-dispatch-table
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
   (##cons ##cprc-loc-ref-box ##degen-loc-ref)
   (##cons ##cprc-glo-ref     ##degen-glo-ref)

   (##cons ##cprc-loc-set     ##degen-loc-set)
   (##cons ##cprc-loc-set-box ##degen-loc-set)
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
   (##cons ##cprc-case-list   ##degen-case-list)
   (##cons ##cprc-case-else   ##degen-case-else)
   (##cons ##cprc-case-send-red ##degen-case-send)
   (##cons ##cprc-case-send-sub ##degen-case-send)

   (##cons ##cprc-let         ##degen-let)
   (##cons ##cprc-let-values  ##degen-let-values)

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

   (##cons ##cprc-guard       (mk-degen () (degen ##degen-guard 'guard)))
   (##cons ##cprc-reraise     ##degen-reraise)))

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
        (let loop ((i (##fx- len 1)))
          (if (##not (##fx< i 0))
              (begin
                (##vector-set! x i (source->expression (##vector-ref v i)))
                (loop (##fx- i 1)))))
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
        (let loop ((parent (macro-code-parent $code)))
          (if (macro-code-root-parent? parent)
              #f
              (let ((locat-or-position-parent (macro-code-locat parent)))
                (if (##locat? locat-or-position-parent)
                    (##make-locat (##locat-container locat-or-position-parent)
                                  locat-or-position)
                    (loop (macro-code-parent parent)))))))))

(define-prim (##code-root-parent $code)
  (let loop ((parent $code))
    (if (macro-code-root-parent? parent)
        parent
        (loop (macro-code-parent parent)))))

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
          (let loop ((i (##fx- (##vector-length v) 1)))
            (if (##fx< i 0)
                #f
                (let ((x (##vector-ref v i)))
                  (if (##fx= id (##vector-ref x 0))
                      x
                      (loop (##fx- i 1)))))))
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
                (let* (($code
                        (##interp-procedure-code p))
                       (rte
                        (##interp-procedure-rte p))
                       (id
                        (##object->lexical-var->identifier
                         (macro-code-cte $code)
                         rte
                         p)))
                  (and id
                       (if (##uninterned-symbol? id)
                           (or (##object->global-var->identifier p)
                               id)
                           id))))
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
                            (let ((val-or-box (##vector-ref r i)))
                              (##eq? obj
                                     (if (and (##var-c? var)
                                              (##var-c-boxed? var))
                                         (##unbox val-or-box)
                                         val-or-box))))
                       var
                       (loop2 (##cdr vars)
                              (##fx+ i 1))))
                 (loop1 (##cte-parent-cte c)
                        (macro-rte-up r)))))
          (else
           (loop1 (##cte-parent-cte c)
                  r)))))

;;;----------------------------------------------------------------------------

;; Internal variables and parameters are uninteresting for the user.

(define-prim (##hidden-local-var? var)
  (and ;; (##var-i? var) test is redundant
   (or (##eq? var (macro-self-var))
       (##eq? var (macro-selector-var))
       (##eq? var (macro-do-loop-var))
       (##eq? var (macro-guard-exc-var))
       (##eq? var (macro-guard-cont-var)))))

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

(define-prim (##show-all-continuations?-set! x)
  (set! ##show-all-continuations? x))

(define-prim (##hidden-continuation? cont)
  (if ##show-all-continuations?
      #f
      (let ((parent (##continuation-parent cont)))
        (##hidden-continuation-parent? parent))))

(define ##default-hidden-continuation-parent?
  (lambda (parent)
    (or (##eq? parent ##interp-procedure-wrapper) ;;;;;;;;;;;;;;;;;;
        (##eq? parent ##dynamic-wind)
        (##eq? parent ##dynamic-env-bind)
        (##eq? parent ##kernel-handlers)
        (##eq? parent ##load-vm)
        (##eq? parent ##repl-debug)
        (##eq? parent ##repl-debug-main)
        (##eq? parent ##repl-within)
        (##eq? parent ##eval-within)
        (##eq? parent ##with-no-result-expected)
        (##eq? parent ##with-no-result-expected-toplevel)
        (##eq? parent ##check-heap)
        (##eq? parent ##nontail-call-for-leap)
        (##eq? parent ##nontail-call-for-step)
        (##eq? parent ##trace-generate)
        (##eq? parent ##thread-check-interrupts!)
        (##eq? parent ##thread-interrupt!)
        (##eq? parent ##thread-execute-and-end!)
        (##eq? parent ##thread-resume-execution!)
        (##eq? parent ##thread-sleep!)
        (##eq? parent ##thread-call))))

(define ##hidden-continuation-parent?
  ##default-hidden-continuation-parent?)

(define (##hidden-continuation-parent?-set! proc)
  (set! ##hidden-continuation-parent? proc))

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
  (##local->value (##continuation-locals cont '$code)))

(define-prim (##interp-continuation-rte cont)
  (##local->value (##continuation-locals cont 'rte)))

(define-prim (##local->value x)
  (let ((var-c (##car x))
        (val-or-box (##cdr x)))
    (if (##var-c-boxed? var-c)
        (##unbox val-or-box)
        val-or-box)))

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
                  (##fx+ n 1)
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
            (if (##fx< j (##vector-length info))
                (let* ((descr
                        (##vector-ref info j))
                       (slot-index
                        (##fxquotient descr 32768))
                       (var-descr-index
                        (##fxquotient
                         (##fxmodulo descr 32768)
                         2))
                       (var-descr
                        (##vector-ref var-descrs var-descr-index))
                       (val-or-box1
                        (if (##eq? cont (macro-absent-obj))
                            #f
                            (##continuation-ref cont slot-index))))

                  (define (get-var1)
                    (##cons (##var-c var-descr
                                     (##fx=
                                      (##fxmodulo descr 2)
                                      1))
                            val-or-box1))

                  (if (##pair? var-descr)

                      (let loop2 ((lst var-descr) (result result))
                        (if (##pair? lst)
                            (let* ((descr
                                    (##car lst))
                                   (slot-index
                                    (##fxquotient descr 32768))
                                   (var-descr-index
                                    (##fxquotient
                                     (##fxmodulo descr 32768)
                                     2))
                                   (var-descr
                                    (##vector-ref var-descrs var-descr-index)))

                              (define (get-var2)
                                (##cons (##var-c var-descr
                                                 (##fx=
                                                  (##fxmodulo descr 2)
                                                  1))
                                        (##closure-ref val-or-box1
                                                       slot-index)))

                              (cond ((##eq? cont (macro-absent-obj))
                                     (loop2 (##cdr lst)
                                            (##cons var-descr
                                                    result)))
                                    ((##eq? var (macro-absent-obj))
                                     (loop2 (##cdr lst)
                                            (##cons (get-var2)
                                                    result)))
                                    (else
                                     (if (##eq? var var-descr)
                                         (get-var2)
                                         (loop2 (##cdr lst)
                                                result)))))
                            (loop1 (##fx+ j 1)
                                   result)))

                      (cond ((##eq? cont (macro-absent-obj))
                             (loop1 (##fx+ j 1)
                                    (##cons var-descr
                                            result)))
                            ((##eq? var (macro-absent-obj))
                             (loop1 (##fx+ j 1)
                                    (##cons (get-var1)
                                            result)))
                            (else
                             (if (##eq? var var-descr)
                                 (get-var1)
                                 (loop1 (##fx+ j 1)
                                        result))))))
                result)))
        #f)))

;;;----------------------------------------------------------------------------

(define-prim (##cmd-? port)
  (##write-system-banner port)
  (##write-string
"
,?   | ,help    : Summary of comma commands
,h   | ,(h X)   : Help on procedure of last error or procedure/macro named X
,q              : Terminate the process
,qt             : Terminate the current thread
,t              : Jump to toplevel REPL
,d              : Jump to enclosing REPL
,c   | ,(c X)   : Continue the computation with stepping off
,s   | ,(s X)   : Continue the computation with stepping on (step)
,l   | ,(l X)   : Continue the computation with stepping on (leap)
,N              : Move to specific continuation frame (N>=0)
,N+  | ,N-      : Move forward/backward by N continuation frames (N>=0)
,+   | ,-       : Like ,1+ and ,1-
,++  | ,--      : Like ,N+ and ,N- with N = nb. of frames at head of backtrace
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

(set! ##values-with-sn? #t)

(define (##values-with-sn?-set! x)
  (set! ##values-with-sn? x))

(define ##backtrace-default-max-head 10)

(define-prim (##backtrace-default-max-head-set! x)
  (set! ##backtrace-default-max-head x))

(define ##backtrace-default-max-tail 4)

(define-prim (##backtrace-default-max-tail-set! x)
  (set! ##backtrace-default-max-tail x))

(define ##frame-locat-display? #t)

(define-prim (##frame-locat-display?-set! x)
  (set! ##frame-locat-display? x))

(define ##frame-call-display? #t)

(define-prim (##frame-call-display?-set! x)
  (set! ##frame-call-display? x))

(define-prim (##cmd-b cont port depth display-env?)
  (##display-continuation-backtrace
   cont
   port
   display-env?
   #f
   ##backtrace-default-max-head
   ##backtrace-default-max-tail
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
             (j (##fx- (##continuation-count-frames cont all-frames?) 1))
             (cont (##continuation-first-frame cont all-frames?)))
    (and cont
         (begin
           (cond ((or (##fx< i max-head) (##fx< j max-tail)
                      (and (##fx= i max-head) (##fx= j max-tail)))
                  (##display-continuation-frame
                   cont
                   port
                   display-env?
                   #f
                   (##fx+ depth i)))
                 ((##fx= i max-head)
                  (##write-string "..." port)
                  (##newline port)))
           (loop (##fx+ i 1)
                 (##fx- j 1)
                 (##continuation-next-frame cont all-frames?))))))

(define-prim (display-continuation-backtrace
              cont
              #!optional
              (port (macro-absent-obj))
              (display-env? (macro-absent-obj))
              (all-frames? (macro-absent-obj))
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
               ##backtrace-default-max-head
               max-head))
          (mt
           (if (##eq? max-tail (macro-absent-obj))
               ##backtrace-default-max-tail
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
           (n (##fx- col current)))
      (##display-spaces (##fxmax n 1) port)))

  (and cont
       (let ((port-width (##output-port-width port)))

         (define depth-width    4)
         (define creator-width 24)
         (define locat-width   24)
         (define call-width    27)

         (let* ((extra
                 (##fxmax
                  0
                  (##fxquotient
                   (##fx- port-width
                          (##fx+
                           depth-width
                           creator-width
                           locat-width
                           call-width))
                   3)))
                (col3
                 (##fx+ depth-width
                        creator-width
                        extra))
                (col4
                 (##fx+ col3
                        locat-width
                        extra))
                (locat-display?
                 ##frame-locat-display?)
                (call-display?
                 ##frame-call-display?))
           (##write depth port)
           (tab depth-width)
           (let ((creator (##continuation-creator cont)))
             (if creator
                 (##write (##procedure-friendly-name creator) port)
                 (##write-string "(interaction)" port)))
           (if locat-display?
               (begin
                 (tab col3)
                 (let ((locat (##continuation-locat cont)))
                   (##display-locat locat pinpoint? port))))
           (if call-display?
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
                       (tab (if locat-display? col4 col3))
                       (##write-string
                        (##object->string
                         call
                         (##fx- port-width
                                (##output-port-column port))
                         port)
                        port)))))
           (##newline port)
           (##display-continuation-env
            cont
            port
            (##fx+ 4 depth-width)
            display-env?)))))

(define-prim (##display-spaces n port)
  (if (##fx< 0 n)
      (let ((m (if (##fx< 40 n) 40 n)))
        (##write-substring "                                        " 0 m port)
        (##display-spaces (##fx- n m) port)
        n)))

(define-prim (##display-locat locat pinpoint? port)
  (if locat ;; locat is #f if location unknown
      (let* ((pinpoint? (and pinpoint? (##not (##pinpoint-locat locat))))
             (container (##locat-container locat))
             (path (##container->path container)))
        (if path
            (##write (##repl-path-normalize path) port)
            (##write-string (##container->id container) port))
        (let* ((filepos (##position->filepos (##locat-position locat)))
               (line (##fx+ (##filepos-line filepos) 1))
               (col (##fx+ (##filepos-col filepos) 1)))
          (##write-string "@" port)
          (##write line port)
          (##write-string (if pinpoint? "." ":") port)
          (##write col port)))))

(define ##pinpoint-locat-hook #f)

(define-prim (##pinpoint-locat-hook-set! x)
  (set! ##pinpoint-locat-hook x))

(define-prim (##pinpoint-locat locat)
  (let ((pl-hook ##pinpoint-locat-hook))
    (if (##procedure? pl-hook)
        (pl-hook locat)
        #f)))

(define ##repl-path-normalize-hook #f)

(define-prim (##repl-path-normalize-hook-set! x)
  (set! ##repl-path-normalize-hook x))

(define-prim (##repl-path-normalize path)
  (let ((rpn-hook ##repl-path-normalize-hook))
    (if (##procedure? rpn-hook)
        (rpn-hook path)
        (##default-repl-path-normalize path))))

(define-prim (##default-repl-path-normalize path)
  (##path-normalize path
                    ##repl-location-relative
                    ##repl-location-origin
                    #f))

(define ##repl-location-relative 'shortest)

(define-prim (##repl-location-relative-set! x)
  (set! ##repl-location-relative x))

(define ##repl-location-origin #f)

(define-prim (##repl-location-origin-set! x)
  (set! ##repl-location-origin x))

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

(define (##display-var-val var val-or-box cte indent port)
  (cond ((##var-i? var)
         (##display-var-val-aux (##var-i-name var)
                                val-or-box
                                #t
                                cte
                                indent
                                port))
        ((##var-c-boxed? var)
         (##display-var-val-aux (##var-c-name var)
                                (##unbox val-or-box)
                                #t
                                cte
                                indent
                                port))
        (else
         (##display-var-val-aux (##var-c-name var)
                                val-or-box
                                #f
                                cte
                                indent
                                port))))

(define (##display-var-val-aux var val mutable? cte indent port)
  (##display-spaces indent port)
  (##write var port)
  (##write-string (if mutable? " = " " == ") port)
  (##write-string
   (let* ((expr
           (if (##cte-top? cte)
               (##inverse-eval-in-env val cte)
               (##inverse-eval-in-env val (##cte-parent-cte cte))))
          (max-length
           (##fx- (##output-port-width port)
                  (##output-port-column port))))
     (##value->string val expr max-length port))
   port)
  (##newline port))

(define (##display-rte cte rte indent port)
  (##for-each-rte-binding
   cte
   rte
   (lambda (var val-or-box cte)
     (##display-var-val var val-or-box cte indent port))))

(define (##for-each-rte-binding cte rte proc)
  (let loop1 ((c cte)
              (r rte))
    (cond ((##cte-top? c))
          ((##cte-frame? c)
           (let loop2 ((vars (##cte-frame-vars c))
                       (vals (##cdr (##vector->list r))))
             (if (##pair? vars)
                 (let ((var (##car vars)))
                   (if (##not (##hidden-local-var? var))
                       (let ((val-or-box (##car vals)))
                         (proc var val-or-box c)))
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
        (let* ((loc (##car lst))
               (var (##car loc))
               (val (##cdr loc)))
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
              (let ((x (##inverse-eval-in-env param cte)))
                (##display-var-val-aux (##list x) val #t cte indent port)))
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
           (n (##fx- col current)))
      (##display-spaces (##fxmax n 1) port)))

  (define (write-timeout to)
    (##write-string " " port)
    (let* ((expiry (##fl- (macro-time-point to) time-point))
           (e (##fl/ (##flround (##fl* 10.0 expiry)) 10.0)))
      (##write (if (##integer? e) (##inexact->exact e) e) port))
    (##write-string "s" port))

  (let ((port-width (##output-port-width port)))

    (define min-thread-width 13) ;; minimal thread column width
                                 ;; actual width adds 1/8 the remaining
                                 ;; width of the output port

    (let ((extra
           (##fxmax
            0
            (##fxquotient
             (##fx- port-width min-thread-width)
             8))))
      (##write thread port)
      (tab (##fx+ min-thread-width extra))
      (let ((ts (##thread-state thread)))
        (cond ((macro-thread-state-uninitialized? ts)
               (##write-string "UNINITIALIZED" port))
              ((macro-thread-state-initialized? ts)
               (##write-string "INITIALIZED" port))
              ((macro-thread-state-normally-terminated? ts)
               (##write-string "NORMALLY TERMINATED" port))
              ((macro-thread-state-abnormally-terminated? ts)
               (##write-string "ABNORMALLY TERMINATED" port))
              ((macro-thread-state-running? ts)
               (##write-string "RUNNING P" port)
               (##write (macro-processor-id
                         (macro-thread-state-running-processor ts))
                        port))
              ((macro-thread-state-waiting? ts)
               (let ((wf (macro-thread-state-waiting-for ts))
                     (to (macro-thread-state-waiting-timeout ts)))
                 (cond (wf
                        (if (macro-processor? wf)
                            (begin
                              (##write-string "WAITING P" port)
                              (##write (macro-processor-id wf) port))
                            (begin
                              (##write-string "WAITING " port)
                              (##write wf port)))
                        (if to
                            (write-timeout to)))
                       (to
                        (##write-string "SLEEPING" port)
                        (write-timeout to)))))
              (else
               (##write ts port))))
      (##newline port))))

(define-prim (##display-thread-group-state tgroup port)
  (let* ((threads (##tgroup->thread-vector tgroup))
         (now (##current-time-point)))
    (let loop ((i 0))
      (if (##fx< i (##vector-length threads))
          (let ((thread (##vector-ref threads i)))
            (##display-thread-state-relative thread port now)
            (loop (##fx+ i 1)))
          i))))

(define-prim (##top timeout tgroup port)

  (define interval 1.0)

  (define (up n)
    (if (##tty? port)
        (begin
          (##write-string "\033[" port)
          (##write n port)
          (##write-string "A\033[J" port))))

  (let* ((start-time-point (##current-time-point))
         (end-time-point (macro-time-point (##timeout->time timeout))))
    (let loop ((last start-time-point))
      (##write-string "*** THREAD LIST:\n" port)
      (let* ((n (##fx+ 1 (##display-thread-group-state tgroup port)))
             (next (##fl+ last interval))
             (now (##current-time-point)))
        (if (##fl< now end-time-point)
            (begin
              (##thread-sleep! (##fl- next now))
              (up n)
              (loop next))
            (##void))))))

(define-prim (top
              #!optional
              (absrel-timeout (macro-absent-obj))
              (tgroup (macro-absent-obj))
              (port (macro-absent-obj)))
  (macro-force-vars (absrel-timeout tgroup port)
    (let ((to
           (if (##eq? absrel-timeout (macro-absent-obj))
               10 ;; default is to return after 10 seconds
               absrel-timeout))
          (tg
           (if (##eq? tgroup (macro-absent-obj))
               (macro-thread-tgroup (macro-current-thread))
               tgroup))
          (p
           (if (##eq? port (macro-absent-obj))
               (##repl-output-port)
               port)))
      (if (##not (macro-absrel-time-or-false? to))
          (##fail-check-absrel-time-or-false
           1
           top
           absrel-timeout
           tgroup
           port)
          (macro-check-tgroup tg 2 (top absrel-timeout tgroup port)
            (macro-check-character-output-port p 3 (top absrel-timeout tgroup port)
              (##top to tg p)))))))

;;;----------------------------------------------------------------------------

;;; Tracing and single stepping.

(define-prim (##interp-procedure-entry-hook proc)
  (let (($code (##interp-procedure-code proc)))
    (macro-code-ref $code (##fx- (macro-code-length $code) 2))))

(define-prim (##interp-procedure-entry-hook-set! proc hook)
  (let (($code (##interp-procedure-code proc)))
    (macro-code-set! $code (##fx- (macro-code-length $code) 2) hook)))

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
      (let ((stepping? (##vector-ref settings 0))
            (trace? (##vector-ref settings 1))
            (stepper (macro-code-stepper (##interp-procedure-code proc))))
        (if trace?
            (##trace-generate
             (##make-friendly-call-form
              proc
              (##argument-list-remove-absent! args '())
              ##max-fixnum
              ##inverse-eval
              #f)
             execute
             (and stepping? 's)
             stepper)
            (begin
              (if stepping?
                  (##step-on stepper)) ;; turn on stepping
              (execute)))))))

(define-prim (##make-friendly-call-form proc args max-args transform-arg annotate?)
  (##make-friendly-form (let ((x (##procedure-friendly-name proc)))
                          (if annotate? (##cons proc x) x))
                        args
                        max-args
                        transform-arg
                        annotate?))

(define-prim (##make-friendly-form head args max-args transform-arg annotate?)

  (define (ann expr val)
    (if annotate? (##cons expr val) val))

  (define (process-args i lst)
    (if (##pair? lst)
        (if (##fx> i max-args)
            (##cons (ann '... '...) (##cdr (##last-pair lst)))
            (let* ((obj (##car lst))
                   (val (transform-arg obj)))
              (##cons (ann obj val)
                      (process-args (##fx+ i 1) (##cdr lst)))))
        lst))

  (##cons head
          (process-args 1 args)))

(define ##trace-depth (##make-parameter 0))

(define-prim (##trace-generate form execute s-or-l stepper)

  (define max-depth 10)

  (define (bars width output-port)
    (let loop ((i 0))
      (if (##fx< i width)
          (begin
            (##write-string
             (if (##fx= (##fxremainder i 2) 0) "|" " ")
             output-port)
            (loop (##fx+ i 1))))))

  (define (bars-width depth)
    (let ((d (if (##fx< max-depth depth) max-depth depth)))
      (if (##fx< 0 d) (##fx- (##fx* d 2) 1) 0)))

  (define (indent depth output-port)
    (let ((w (bars-width depth)))
      (if (##fx< max-depth depth)
          (let ((depth-str (##number->string depth 10)))
            (bars (##fx- w (##fx+ (##string-length depth-str) 2))
                  output-port)
            (##write-string "[" output-port)
            (##write-string depth-str output-port)
            (##write-string "]" output-port))
          (bars w output-port))))

  (define (output-to-repl proc)
    (##repl proc))

  (define (output-to-repl-with-indent depth prompt obj)
    (let* ((repl-port
            (##repl-output-port))
           (width
            (##fx+ (bars-width depth) 1 (##string-length prompt)))
           (obj-str
            (##object->string
             obj
             (##fx- (##output-port-width repl-port) width)
             repl-port)))
      (output-to-repl
       (lambda (first port)
         (indent depth port)
         (##write-string prompt port)
         (##write-string obj-str port)
         (##newline port)
         #t))))

  (##step-off stepper)

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
                 (##fx+ current-depth 1)
                 current-depth)))

       (output-to-repl-with-indent depth " > " form) ;; show form

       (cond ((##eq? ##nontail-call-for-leap parent)
              (if (##eq? s-or-l 's)
                  ;; turn on stepping before tail call (execute)
                  (##step-on stepper))
              (execute))
             ((##eq? ##nontail-call-for-step parent)
              (if (##eq? s-or-l 'l)
                  (##nontail-call-for-leap execute stepper)
                  (begin
                    (if (##eq? s-or-l 's)
                        ;; turn on stepping before tail call (execute)
                        (##step-on stepper))
                    (execute))))
             (else
              (let ((result
                     (##parameterize1
                      ##trace-depth
                      depth
                      (if (##eq? s-or-l 'l)
                          (lambda ()
                            (##nontail-call-for-leap execute stepper))
                          (lambda ()
                            (if (##eq? s-or-l 's)
                                ;; turn on stepping before nontail call (execute)
                                (##step-on stepper))
                            (##nontail-call-for-step execute))))))

                (let ((saved-stepper
                       (##vector-copy (##current-stepper))))
                  (##step-off stepper)
                  (output-to-repl-with-indent depth " " result) ;; show result
                  (##step-restore saved-stepper)
                  result))))))))

(define-prim (##nontail-call-for-leap execute stepper)
  (##declare (not interrupts-enabled))
  (##step-on stepper (execute))) ;; turn on stepping at end of a leap

(define-prim (##nontail-call-for-step execute)
  (##declare (not interrupts-enabled))
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
    (set! ##trace-list (##remq proc ##trace-list))))

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
    (set! ##break-list (##remq proc ##break-list))))

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

(define-prim (##step-on
              #!optional
              (stepper (##current-stepper))
              (result (##void)))
  (##declare (not interrupts-enabled))
  (let ((handlers (##vector-ref stepper 0)))
    (let loop ((i (##vector-length handlers)))
      (if (##not (##fx< i 1))
          (let ((i-1 (##fx- i 1)))
            (##vector-set! stepper i (##vector-ref handlers i-1))
            (loop i-1))))
    result))

(define-prim (##step-off
              #!optional
              (stepper (##current-stepper)))
  (##declare (not interrupts-enabled))
  (let* ((handlers (##vector-ref stepper 0))
         (len (##vector-length handlers)))
    (let loop ((i len))
      (if (##not (##fx< i 1))
          (let ((i-1 (##fx- i 1)))
            (##vector-set! stepper i #f)
            (loop i-1))))
    (##void)))

(define-prim (##step-restore
              saved-stepper
              #!optional
              (stepper (##current-stepper)))
  (##declare (not interrupts-enabled))
  (let* ((handlers (##vector-ref stepper 0))
         (len (##vector-length handlers)))
    (let loop ((i len))
      (if (##not (##fx< i 1))
          (let ((i-1 (##fx- i 1)))
            (##vector-set! stepper
                           i
                           (and (##vector-ref saved-stepper i)
                                (##vector-ref handlers i-1)))
            (loop i-1))))
    (##void)))

(define-prim (step)
  (##step-on)) ;; turn on stepping on current stepper

(define-prim (##step-level-set!
              n
              #!optional
              (stepper (##current-stepper)))
  (##declare (not interrupts-enabled))
  (let* ((handlers (##vector-ref stepper 0))
         (len (##vector-length handlers))
         (step-handlers (##vector-ref stepper (##fx+ len 1))))
    (let loop ((i len))
      (if (##not (##fx< i 1))
          (let ((i-1 (##fx- i 1)))
            (##vector-set! handlers
                           i-1
                           (if (##fx< i-1 n)
                               (##vector-ref step-handlers i-1)
                               #f))
            (loop i-1))))
    (##void)))

(define-prim (step-level-set! n)
  (macro-force-vars (n)
    (macro-check-fixnum-range-incl n 1 0 7 (step-level-set! n)
      (##step-level-set! n))))

(define ##default-step-handlers
  (macro-make-step-handlers ##step-handler))

(##current-stepper (macro-make-stepper ##default-step-handlers))

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
  (##step-off (macro-code-stepper $code)) ;; turn off stepping
  (##step-handler-continue
   (##step-handler-get-command $code rte)
   leapable?
   $code
   rte
   execute-body
   other))

(define-prim (##step-handler-continuation? cont)
  (##eq? (##continuation-parent cont) ##step-handler))

(define-prim (##with-no-result-expected-continuation? cont)
  (##eq? (##continuation-parent cont) ##with-no-result-expected))

(define-prim (##with-no-result-expected-toplevel-continuation? cont)
  (##eq? (##continuation-parent cont) ##with-no-result-expected-toplevel))

(define-prim (##step-handler-get-command $code rte)
  (##repl-debug
   (lambda (first port)
     (##display-situation
      "STOPPED"
      (##extract-container $code rte)
      (##code-locat $code)
      port)
     (##newline port)
     #f)))

(define-prim (##step-handler-continue
              cmd
              leapable?
              $code
              rte
              execute-body
              other)

  ;; cmd is one of the symbols "c", "s" or "l" or a one element vector

  (define (execute)
    (##apply execute-body (##cons $code (##cons rte other))))

  (cond ((##eq? cmd 'c)
         (execute))
        ((or (##eq? cmd 'l) (##eq? cmd 's))
         (##trace-generate (##decomp $code)
                           execute
                           (if (and (##eq? cmd 'l) leapable?) 'l 's)
                           (macro-code-stepper $code)))
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
                        (##fx+ arg-num 1))
                  (let ((id (##object->global-var->identifier proc)))
                    (if id ;; procedure is bound to a global variable
                        (begin
                          (##repl
                           (lambda (first port)
                             (##write-string
                              "*** WARNING -- Rebinding global variable \""
                              port)
                             (##write id port)
                             (##write-string
                              "\" to an interpreted procedure\n"
                              port)
                             #t))
                          (let ((new-proc
                                 (##make-interp-procedure proc)))
                            (##global-var-set! (##make-global-var id) new-proc)
                            (loop (##cdr lst1)
                                  (##cons new-proc lst2)
                                  (##fx+ arg-num 1))))
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

;;;============================================================================

;;; Read eval print loop channels.

(implement-type-repl-channel)

(define-prim (##thread-repl-channel-get! thread)
  (or (macro-thread-repl-channel thread)
      (let ((repl-channel (##thread-make-repl-channel thread)))
        (macro-thread-repl-channel-set! thread repl-channel)
        (macro-thread-repl-channel thread))))

(define (##default-thread-make-repl-channel thread)
  (let ((addr (##repl-client-addr)))
    (if (##not addr)
        ##stdio/console-repl-channel
        (let loop ((attempt 1) (max-wait 0.25))

          (define (attempt-failed code)
            (if (##fx< attempt 25) ;; max wait about 100 seconds
                (begin
                  (##thread-sleep! max-wait)
                  (loop (##fx+ attempt 1) (##fl* max-wait 1.2)))
                (##exit-with-err-code code)))

          (##open-tcp-client
           #f
           (lambda (port)
             (if (##fixnum? port)
                 (begin
                   (attempt-failed port))
                 (begin
                   (##output-port-timeout-set! port max-wait)
                   (let ((x (##tcp-client-socket-info
                             port
                             tcp-client-peer-socket-info
                             #f)))
                     (if (##fixnum? x)
                         (attempt-failed x)
                         (begin
                           (##output-port-timeout-set!
                            port
                            (macro-inexact-+inf))
                           (##make-repl-channel-ports
                            port
                            port
                            port)))))))
           open-tcp-client
           (##list port-number: 44556
                   address: addr
                   output-buffering: #f))))))

(define ##thread-make-repl-channel ##default-thread-make-repl-channel)

(define-prim (##thread-make-repl-channel-set! x)
  (set! ##thread-make-repl-channel x))

(define ##stdio/console-repl-channel
  (let* ((settings
          (##set-debug-settings! 0 0))
         (x
          (##fxwraplogical-shift-right
           (##fxand
            settings
            (macro-debug-settings-repl-mask))
           (macro-debug-settings-repl-shift))))
    (cond ((or (##fx= x (macro-debug-settings-repl-stdio))
               (##fx= x (macro-debug-settings-repl-stdio-and-err)))
           (##make-repl-channel-ports
            ##stdin-port
            ##stdout-port
            (if (##fx= x (macro-debug-settings-repl-stdio-and-err))
                ##stderr-port
                ##stdout-port)))
          (else
           (##make-repl-channel-ports
            ##console-port
            ##console-port
            ##console-port)))))

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

(define-prim (##repl-error-port)
  (let* ((ct (macro-current-thread))
         (channel (##thread-repl-channel-get! ct)))
    (macro-repl-channel-error-port channel)))

(define-prim (repl-error-port)
  (##repl-error-port))

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

(define-prim (##repl-channel-have-ownership?)
  (let* ((ct (macro-current-thread))
         (channel (macro-thread-repl-channel ct)))
    (and channel
         (##eq? (##mutex-state (macro-repl-channel-owner-mutex channel)) ct))))

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

(define-prim (##repl-channel-display-monoline-message
              writer
              #!optional
              (err? #f))
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-display-monoline-message channel)
     channel
     writer
     err?)))

(define-prim (##repl-channel-display-multiline-message
              writer
              #!optional
              (err? #f))
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-display-multiline-message channel)
     channel
     writer
     err?)))

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

(define-prim (##repl-channel-ask prompt echo?)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-ask channel) channel prompt echo?)))

(define-prim (##repl-channel-confirm prompt)
  (let ((channel (##thread-repl-channel-get! (macro-current-thread))))
    ((macro-repl-channel-confirm channel) channel prompt)))

(##define-macro (macro-repl-result-history-max-max-length)
  10)

(##define-macro (macro-repl-result-history-default-max-length)
  3)

(define-prim (##make-empty-repl-result-history)
  (##vector (macro-repl-result-history-default-max-length)))

(##define-macro (macro-repl-result-history-length result-history)
  `(##fx- (##vector-length ,result-history) 1))

(##define-macro (macro-repl-result-history-max-length result-history)
  `(##vector-ref ,result-history 0))

(##define-macro (macro-repl-result-history-ref result-history i)
  `(##vector-ref ,result-history (##fx+ ,i 1)))

(define-prim (##repl-channel-result-history-add channel result)
  (let loop ()
    (let* ((result-history (macro-repl-channel-result-history channel))
           (len (macro-repl-result-history-length result-history))
           (max-len (macro-repl-result-history-max-length result-history))
           (new-len (##fxmin (##fx+ len 1) max-len)))
      (if (##fx< 0 new-len)
          (let ((v (##make-vector (##fx+ new-len 1) max-len)))
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
           (new-len (##fxmin len max-len))
           (v (##make-vector (##fx+ new-len 1) max-len)))
      (##subvector-move! result-history 1 (##fx+ new-len 1) v 1)
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

(define-prim (##exit-with-exception-on-exception thunk)
  ;; TODO: improve so that exit happens only for output on port
  (##with-exception-handler ##exit-with-exception thunk))

(define-prim (##make-repl-channel-ports input-port output-port error-port)
  (macro-make-repl-channel-ports

   (##make-mutex 'channel-arbiter)
   (macro-current-thread)
   input-port
   output-port
   error-port
   (##make-empty-repl-result-history)

   ##repl-channel-ports-read-command
   ##repl-channel-ports-write-results
   ##repl-channel-ports-display-monoline-message
   ##repl-channel-ports-display-multiline-message
   ##repl-channel-ports-display-continuation
   ##repl-channel-ports-pinpoint-continuation
   ##repl-channel-ports-really-exit?
   ##repl-channel-ports-newline
   ##repl-channel-ports-ask
   ##repl-channel-ports-confirm

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
                                (in-homedir ".gambit_history")
                                char-encoding:
                                'UTF-8)))

                   (##open-file-generic
                    (macro-direction-in)
                    #f
                    (lambda (port resolved-path)
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
                       (lambda (port resolved-path)
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
    (##exit-with-exception-on-exception
     (lambda ()
       (if (##fx< 0 level)
           (##write level output-port))
       (if (##fx< 0 depth)
           (begin
             (##write-string "\\" output-port)
             (##write depth output-port)))
       (##write-string prompt output-port)
       (##force-output output-port))))

  ((macro-repl-channel-ports-read-expr channel) channel))

(define-prim (##repl-channel-ports-write-results channel results)
  (let ((output-port (macro-repl-channel-output-port channel)))
    (##for-each
     (lambda (obj)
       (if (##not (##eq? obj (##void)))
           (begin
             (##repl-channel-result-history-add channel obj)
             (##exit-with-exception-on-exception
              (lambda ()
                (##pretty-print obj output-port ##max-fixnum #f))))))
     results)))

(define-prim (##repl-channel-ports-display-monoline-message
              channel
              writer
              #!optional
              (err? #f))
  (let ((port
         (if err?
             (macro-repl-channel-error-port channel)
             (macro-repl-channel-output-port channel))))
    (##exit-with-exception-on-exception
     (lambda ()
       (writer port)
       (##newline port)))))

(define-prim (##repl-channel-ports-display-multiline-message
              channel
              writer
              #!optional
              (err? #f))
  (let ((port
         (if err?
             (macro-repl-channel-error-port channel)
             (macro-repl-channel-output-port channel))))
    (##exit-with-exception-on-exception
     (lambda ()
       (writer port)))))

(define-prim (##repl-channel-ports-display-continuation channel cont depth)
  (if (##repl-display-environment?)
      (##repl-channel-display-multiline-message
       (lambda (port)
         (##cmd-e cont port #t)))))

(define-prim (##repl-channel-ports-pinpoint-continuation channel cont)
  #f)

(define-prim (##repl-channel-ports-really-exit? channel)
  (let ((input-port (macro-repl-channel-input-port channel))
        (output-port (macro-repl-channel-output-port channel)))
    (##exit-with-exception-on-exception
     (lambda ()
       (##write-string "*** EOF again to exit" output-port)
       (##newline output-port)
       (##force-output output-port)))
    (##not (##char? (##peek-char input-port)))))

(define-prim (##repl-channel-ports-newline channel)
  (let ((output-port (macro-repl-channel-output-port channel)))
    (##exit-with-exception-on-exception
     (lambda ()
       (##newline output-port)))))

(define-prim (##repl-channel-ports-ask channel prompt echo?)
  (let ((input-port (macro-repl-channel-input-port channel))
        (output-port (macro-repl-channel-output-port channel)))
    (##exit-with-exception-on-exception
     (lambda ()
       (##write-string prompt output-port)
       (##force-output output-port)))
    (##repl-channel-discard-buffered-input channel)
    (let ((answer (##read-line input-port)))
      (##output-port-column-set! output-port 1)
      answer)))

(define-prim (##repl-channel-ports-confirm channel prompt)
  (##repl-channel-ports-ask channel prompt #t))

(define-prim (##repl-channel-discard-buffered-input channel)
  (let ((input-port (macro-repl-channel-input-port channel)))
    (##input-port-timeout-set! input-port (macro-inexact-+0))
    (let loop ()
      (if (##char? (##read-char input-port))
          (loop)
          (##input-port-timeout-set! input-port (macro-inexact-+inf))))))

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

(define-prim (##repl
              #!optional
              (write-reason #f)
              (reason #f)
              (toplevel? #f)
              (err? #f))

  (define (repl)
    (##continuation-capture
     (lambda (cont)
       (##repl-within cont write-reason reason err?))))

  (if toplevel?
      (##with-no-result-expected-toplevel (lambda () (repl)))
      (repl)))

(define-prim (##repl-set! x)
  (set! ##repl x))

(define-prim (##repl-debug
              #!optional
              (write-reason #f)
              (reason #f)
              (toplevel? #f)
              (err? #f))
  (##set-debug-settings!
   (##fx+ (macro-debug-settings-error-mask)
          (macro-debug-settings-user-intr-mask))
   (##fx+ (macro-debug-settings-error-repl)
          (macro-debug-settings-user-intr-repl)))
  (##repl write-reason reason toplevel? err?))

(define-prim (##repl-debug-main)

  (##current-input-port (##repl-input-port))
  (##current-output-port (##repl-output-port))
  (##current-error-port (##repl-output-port))

  (##repl-debug
   (lambda (first port)

     (##define-macro (attrs kind)

       (define style-normal    0)
       (define style-bold      1)
       (define style-underline 2)
       (define style-reverse   4)

       (define color-black          0)
       (define color-red            1)
       (define color-green          2)
       (define color-yellow         3)
       (define color-blue           4)
       (define color-magenta        5)
       (define color-cyan           6)
       (define color-white          7)
       (define color-bright-black   8)
       (define color-bright-red     9)
       (define color-bright-green   10)
       (define color-bright-yellow  11)
       (define color-bright-blue    12)
       (define color-bright-magenta 13)
       (define color-bright-cyan    14)
       (define color-bright-white   15)
       (define default-color        256)

       (define (make-text-attr style fg bg)
         (+ (* style 262144) fg (* bg 512)))

       (case kind
         ((banner)
          (make-text-attr style-bold   color-bright-black color-bright-cyan))
         ((input)
          (make-text-attr style-bold   default-color default-color))
         (else
          (make-text-attr style-normal default-color default-color))))

     (if (##tty? port)
         (##tty-text-attributes-set! port (attrs input) (attrs banner)))

     (##write-system-banner port)

     (if (##tty? port)
         (##tty-text-attributes-set! port (attrs input) (attrs output)))

     (##newline port)
     (##newline port)
     #f)
   #f
   #t)

  (##exit))

(define-prim (##write-system-banner port)
  (##write-string "Gambit " port)
  (##write-string (##system-version-string) port))

(define-prim (##repl-context-display-continuation repl-context)
  (##repl-channel-display-continuation
   (macro-repl-context-cont repl-context)
   (macro-repl-context-depth repl-context)))

(define-prim (##repl-within cont write-reason reason err?)
  (let* ((prev-repl-context
          (##thread-repl-context-get!))
         (repl-context
          (macro-make-repl-context
           (##fx+ (macro-repl-context-level prev-repl-context) 1)
           0
           cont
           cont
           reason
           prev-repl-context
           #f)))

    (##repl-channel-acquire-ownership!)

    (if (and (##procedure? write-reason)
             (##repl-context-with-clean-exception-handling
              repl-context
              (lambda ()
                (##repl-channel-display-multiline-message
                 (lambda (port)
                   (let ((first (##repl-first-interesting cont)))
                     (##declare (not safe)) ;; avoid procedure check on the call
                     ;; write-reason returns #f if REPL is to be started
                     (write-reason first port)))
                 err?))))

        (##repl-channel-release-ownership!)

        (##repl-context-restart-pinpointing-continuation repl-context #f))))

(define-prim (##repl-context-restart-pinpointing-continuation
              repl-context
              show-frame?)
  (##repl-context-restart-exec
   repl-context
   (lambda ()
     (let ((cont
            (##repl-first-interesting
             (macro-repl-context-cont repl-context))))
       (if (and (##not (##repl-channel-pinpoint-continuation cont))
                show-frame?)
           (##repl-channel-display-multiline-message
            (lambda (port)
              (##cmd-y cont
                       port
                       #t
                       (macro-repl-context-depth repl-context)))))
       (##repl-context-display-continuation repl-context)))))

(define-prim (##repl-context-restart repl-context)
  (##repl-context-restart-exec
   repl-context
   (lambda ()
     (##repl-context-display-continuation repl-context))))

(define-prim (##repl-context-restart-exec repl-context thunk)
  (##continuation-graft ;; get rid of any useless continuation frames
   (macro-repl-context-cont repl-context)
   (lambda ()
     (##repl-context-with-clean-exception-handling
      repl-context
      (lambda ()
        (macro-dynamic-bind repl-context
                            repl-context
                            (lambda ()
                              (thunk)
                              (##repl-context-prompt repl-context))))))))

(define-prim (##default-repl-context-prompt repl-context)

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

  (##step-off) ;; turn off stepping on current stepper

  (##repl-context-command repl-context (read-command)))

(define ##repl-context-prompt ##default-repl-context-prompt)

(define-prim (##repl-context-prompt-set! x)
  (set! ##repl-context-prompt x))

(define-prim (##default-repl-context-command repl-context src)
  (cond ((##eof-object? src)
         (##repl-channel-newline)
         (if (##fx< 0 (macro-repl-context-level repl-context))
             (##repl-cmd-d repl-context))
         (if (##repl-channel-really-exit?)
             (##repl-cmd-q repl-context))
         (##repl-context-prompt repl-context))
        (else
         (let ((code (##source-code src)))
           (if (and (##pair? code)
                    (##eq? (##source-code (##car code)) 'unquote)
                    (##pair? (##cdr code))
                    (##null? (##cddr code)))
               (let* ((cmd-src (##cadr code))
                      (cmd (##source-code cmd-src))
                      (x (##assq cmd ##repl-commands-no-args))
                      (handler (and x (##cdr x))))
                 (cond
                  (handler
                   (handler repl-context))
                  ((and (##fixnum? cmd)
                        (##not (##fx< cmd 0)))
                   (##repl-context-goto-depth repl-context cmd))
                  ((and (##pair? cmd)
                        (##pair? (##cdr cmd))
                        (##null? (##cddr cmd)))
                   (let* ((cmd2-src (##car cmd))
                          (cmd2 (##source-code cmd2-src))
                          (x (##assq cmd2 ##repl-commands-with-1-arg))
                          (handler (and x (##cdr x))))
                     (cond
                      (handler
                       (handler (##cadr cmd) repl-context))
                      (else
                       (##repl-cmd-unknown src repl-context)))))
                  ((##symbol? cmd)
                   (let* ((s (##symbol->string cmd))
                          (len (##string-length s))
                          (c (and (##fx< 0 len)
                                  (##string-ref s (##fx- len 1)))))

                     (define (move-frame n)
                       (##repl-context-goto-depth
                        repl-context
                        (##fx+
                         (macro-repl-context-depth repl-context)
                         (if (##char=? c #\+)
                             n
                             (##fx- 0 n)))))

                     (if (or (##char=? c #\+)
                             (##char=? c #\-))
                         (cond ((##fx= len 1)
                                (move-frame 1))
                               ((and (##fx= len 2)
                                     (##char=? c (##string-ref s 0)))
                                (move-frame ##backtrace-default-max-head))
                               (else
                                (let ((n (##string->number
                                          (##substring s
                                                       0
                                                       (##fx- len 1))
                                          10)))
                                  (if (and (##fixnum? n)
                                           (##not (##fx< n 0)))
                                      (move-frame n)
                                      (##repl-cmd-unknown src repl-context)))))
                         (##repl-cmd-unknown src repl-context))))
                  (else
                   (##repl-cmd-unknown src repl-context))))
               (##repl-cmd-eval-print src repl-context))))))

(define ##repl-context-command ##default-repl-context-command)

(define-prim (##repl-context-command-set! x)
  (set! ##repl-context-command x))

(define-prim (##repl-context-goto-depth repl-context n)
  (##repl-context-restart-pinpointing-continuation
   (##repl-context-get-context repl-context n)
   #t))

(define-prim (##repl-context-get-context repl-context n)
  (let loop ((context repl-context))
    (let ((depth (macro-repl-context-depth context)))
      (cond ((##fx< n depth)
             (let ((prev-depth (macro-repl-context-prev-depth context)))
               (if prev-depth
                   (loop prev-depth)
                   context)))
            ((##fx< depth n)
             (let* ((cont
                     (##repl-first-interesting
                      (macro-repl-context-cont context)))
                    (next
                     (##continuation-next-frame cont #f)))
               (if next
                   (loop (macro-make-repl-context
                          (macro-repl-context-level context)
                          (##fx+ depth 1)
                          next
                          (macro-repl-context-initial-cont context)
                          (macro-repl-context-reason context)
                          (macro-repl-context-prev-level context)
                          context))
                   context)))
            (else
             context)))))

(define-prim (##repl-context-cont-in-step-handler? repl-context)
  (let ((cont (macro-repl-context-cont repl-context)))
    (##step-handler-continuation? cont)))

(define-prim (##repl-context-cont-in-with-no-result-expected? repl-context)
  (let ((cont (macro-repl-context-cont repl-context)))
    (or (##with-no-result-expected-continuation? cont)
        (##with-no-result-expected-toplevel-continuation? cont))))

(define-prim (##repl-context-with-clean-exception-handling repl-context thunk)
  (##with-exception-catcher
   (lambda (exc)
     (##continuation-graft ;; get rid of any useless continuation frames
      (macro-repl-context-cont repl-context)
      (lambda ()
        (##repl-channel-release-ownership!)
        (macro-raise exc))))
   thunk))

(define-prim (##repl-context-return repl-context results)
  (##repl-channel-release-ownership!)
  (##continuation-return
   (macro-repl-context-cont repl-context)
   results))

(define-prim (##repl-first-interesting cont)
  (##continuation-first-frame cont #f))

(define-prim (##repl-cmd-eval-print src repl-context)

  (##repl-channel-release-ownership!)

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
           (##repl-channel-write-results results)
           (##continuation-return return #f)))))))

  (##repl-channel-acquire-ownership!)

  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-unknown src repl-context)
  (##repl-channel-display-monoline-message
   (lambda (output-port)
     (##write (##desourcify src) output-port)
     (##write-string " is an unknown command. Try ,help" output-port)))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-invalid msg repl-context)
  (##repl-channel-display-monoline-message
   (lambda (output-port)
     (##write-string msg output-port)))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-? repl-context)
  (##repl-channel-display-multiline-message ##cmd-?)
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-h repl-context)
  (let* ((reason
          (macro-repl-context-reason repl-context))
         (proc-and-args
          (and reason
               (##exception-procedure-and-arguments reason)))
         (proc
          (and proc-and-args
               (##car proc-and-args))))
    (##help (or proc help)))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-d repl-context)
  (if (##fx< 0 (macro-repl-context-level repl-context))
      (##repl-context-restart (macro-repl-context-prev-level repl-context))
      (##repl-context-prompt repl-context)))

(define-prim (##repl-cmd-t repl-context)
  (let loop ((context repl-context))
    (if (##fx< 0 (macro-repl-context-level context))
        (loop (macro-repl-context-prev-level context))
        (##repl-context-restart context))))

(define-prim (##repl-cmd-q repl-context)
  (##repl-channel-release-ownership!)
  (##continuation-graft
   (macro-repl-context-cont repl-context)
   (lambda ()
     (##exit))))

(define-prim (##repl-cmd-qt repl-context)
  (##repl-channel-release-ownership!)
  (##continuation-graft
   (macro-repl-context-cont repl-context)
   (lambda ()
     (##thread-terminate! (macro-current-thread)))))

(define-prim (##repl-cmd-st repl-context)
  (##repl-channel-display-multiline-message
   (lambda (port)
     (##cmd-st (macro-thread-tgroup (macro-current-thread))
               port)))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-b repl-context)
  (##repl-cmd-b-be-bed #f repl-context))

(define-prim (##repl-cmd-be repl-context)
  (##repl-cmd-b-be-bed #t repl-context))

(define-prim (##repl-cmd-bed repl-context)
  (##repl-cmd-b-be-bed 'dynamic repl-context))

(define-prim (##repl-cmd-b-be-bed display-env? repl-context)
  (##repl-channel-display-multiline-message
   (lambda (port)
     (##cmd-b (##repl-first-interesting
               (macro-repl-context-cont repl-context))
              port
              (macro-repl-context-depth repl-context)
              display-env?)))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-i repl-context)
  (##repl-channel-display-multiline-message
   (lambda (port)
     (##cmd-i (##repl-first-interesting
               (macro-repl-context-cont repl-context))
              port)))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-y repl-context)
  (##repl-channel-display-multiline-message
   (lambda (port)
     (##cmd-y (##repl-first-interesting
               (macro-repl-context-cont repl-context))
              port
              #t
              (macro-repl-context-depth repl-context))))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-e repl-context)
  (##repl-cmd-e-ed #t repl-context))

(define-prim (##repl-cmd-ed repl-context)
  (##repl-cmd-e-ed 'dynamic repl-context))

(define-prim (##repl-cmd-e-ed display-env? repl-context)
  (##repl-channel-display-multiline-message
   (lambda (port)
     (##cmd-e (macro-repl-context-cont repl-context)
              port
              display-env?)))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-c repl-context)
  (##repl-cmd-c-s-l 'c repl-context))

(define-prim (##repl-cmd-s repl-context)
  (##repl-cmd-c-s-l 's repl-context))

(define-prim (##repl-cmd-l repl-context)
  (##repl-cmd-c-s-l 'l repl-context))

(define-prim (##repl-cmd-c-s-l cmd repl-context)
  (if (or (##repl-context-cont-in-step-handler? repl-context)
          (##repl-context-cont-in-with-no-result-expected? repl-context))
      (##repl-context-return repl-context cmd)
      (##repl-cmd-invalid
       "Continuation expects a result -- use ,(c X) or ,(s X) or ,(l X)"
       repl-context)))

(define ##repl-commands-no-args
  (##list (##cons '?    ##repl-cmd-?)
          (##cons 'help ##repl-cmd-?)
          (##cons 'h    ##repl-cmd-h)
          (##cons 'd    ##repl-cmd-d)
          (##cons 't    ##repl-cmd-t)
          (##cons 'q    ##repl-cmd-q)
          (##cons 'qt   ##repl-cmd-qt)
          (##cons 'st   ##repl-cmd-st)
          (##cons 'b    ##repl-cmd-b)
          (##cons 'be   ##repl-cmd-be)
          (##cons 'bed  ##repl-cmd-bed)
          (##cons 'i    ##repl-cmd-i)
          (##cons 'y    ##repl-cmd-y)
          (##cons 'e    ##repl-cmd-e)
          (##cons 'ed   ##repl-cmd-ed)
          (##cons 'c    ##repl-cmd-c)
          (##cons 's    ##repl-cmd-s)
          (##cons 'l    ##repl-cmd-l)
          ))

(define-prim (##repl-commands-no-args-set! x)
  (set! ##repl-commands-no-args x))

(define-prim (##repl-cmd-h-with-1-arg arg repl-context)
  (##help (##source-code arg))
  (##repl-context-prompt repl-context))

(define-prim (##repl-cmd-c-with-1-arg arg repl-context)
  (##repl-cmd-c-s-l-with-1-arg 'c arg repl-context))

(define-prim (##repl-cmd-s-with-1-arg arg repl-context)
  (##repl-cmd-c-s-l-with-1-arg 's arg repl-context))

(define-prim (##repl-cmd-l-with-1-arg arg repl-context)
  (##repl-cmd-c-s-l-with-1-arg 'l arg repl-context))

(define-prim (##repl-cmd-c-s-l-with-1-arg cmd arg repl-context)
  (if (##repl-context-cont-in-with-no-result-expected? repl-context)
      (##repl-cmd-invalid
       "Continuation expects no result -- use ,c or ,s or ,l"
       repl-context)
      (begin
        (##repl-channel-release-ownership!)
        (##eval-within
         arg
         (macro-repl-context-cont repl-context)
         repl-context
         (if (##repl-context-cont-in-step-handler? repl-context)
             (lambda (results)
               (##repl-channel-acquire-ownership!)
               (##repl-context-return
                repl-context
                (##vector results)))
             (lambda (results)
               (##repl-channel-acquire-ownership!)
               (##repl-context-return
                repl-context
                results)))))))

(define-prim (##repl-cmd-b-with-1-arg arg repl-context)
  (##repl-cmd-b-be-bed-e-ed-v-with-1-arg 'b arg repl-context))

(define-prim (##repl-cmd-be-with-1-arg arg repl-context)
  (##repl-cmd-b-be-bed-e-ed-v-with-1-arg 'be arg repl-context))

(define-prim (##repl-cmd-bed-with-1-arg arg repl-context)
  (##repl-cmd-b-be-bed-e-ed-v-with-1-arg 'bed arg repl-context))

(define-prim (##repl-cmd-e-with-1-arg arg repl-context)
  (##repl-cmd-b-be-bed-e-ed-v-with-1-arg 'e arg repl-context))

(define-prim (##repl-cmd-ed-with-1-arg arg repl-context)
  (##repl-cmd-b-be-bed-e-ed-v-with-1-arg 'ed arg repl-context))

(define-prim (##repl-cmd-v-with-1-arg arg repl-context)
  (##repl-cmd-b-be-bed-e-ed-v-with-1-arg 'v arg repl-context))

(define-prim (##repl-cmd-b-be-bed-e-ed-v-with-1-arg cmd arg repl-context)
  (##repl-channel-release-ownership!)
  (##eval-within
   arg
   (macro-repl-context-cont repl-context)
   repl-context
   (lambda (results)
     (let ((val results))

       (define (handle proc-or-cont depth)
         (if (##eq? cmd 'v)
             (if (##continuation? proc-or-cont)
                 (let ((cont
                        (##repl-first-interesting
                         proc-or-cont)))
                   (##repl-within cont #f #f #f))
                 (let ((proc
                        proc-or-cont))
                   (##repl-within-proc
                    proc
                    (macro-repl-context-cont
                     repl-context))))
             (begin
               (##repl-channel-display-multiline-message
                (lambda (port)
                  (if (or (##eq? cmd 'e)
                          (##eq? cmd 'ed))
                      (##cmd-e proc-or-cont
                               port
                               (if (##eq? cmd 'ed)
                                   'dynamic
                                   #t))
                      (let ((cont
                             (##repl-first-interesting
                              proc-or-cont)))
                        (##cmd-b cont
                                 port
                                 depth
                                 (if (##eq? cmd 'bed)
                                     'dynamic
                                     (##eq? cmd 'be)))))))
               (##repl-channel-acquire-ownership!)
               (##repl-context-prompt repl-context))))

       (cond ((and (##fixnum? val)
                   (##not (##fx< val 0)))
              (let* ((rc
                      (##repl-context-get-context
                       repl-context
                       val))
                     (depth
                      (macro-repl-context-depth rc))
                     (cont
                      (macro-repl-context-cont rc)))
                (handle cont depth)))
             ((##continuation? val)
              (handle val 0))
             ((and (##not (or (##eq? cmd 'b)
                              (##eq? cmd 'be)
                              (##eq? cmd 'bed)))
                   (##procedure? val))
              (handle val 0))
             ((macro-thread? val)
              (if (##eq? cmd 'v)
                  (begin
                    (##thread-interrupt!
                     val
                     (lambda ()
                       (##user-interrupt-current-thread! #f)))
                    (##thread-yield!)
                    (##repl-channel-acquire-ownership!)
                    (##repl-context-prompt repl-context))
                  (let ((cont
                         (##thread-continuation-capture
                          val)))
                    (handle cont 0))))
             (else
              (##repl-channel-acquire-ownership!)
              (##repl-cmd-invalid
               (cond ((or (##eq? cmd 'b)
                          (##eq? cmd 'be)
                          (##eq? cmd 'bed))
                      "CONTINUATION or THREAD expected")
                     (else
                      "PROCEDURE, CONTINUATION or THREAD expected"))
               repl-context)))))))

(define-prim (##repl-cmd-st-with-1-arg arg repl-context)
  (##repl-channel-release-ownership!)
  (##eval-within
   arg
   (macro-repl-context-cont repl-context)
   repl-context
   (lambda (results)
     (let ((val results))

       (define (handle thread-or-tgroup)
         (##repl-channel-acquire-ownership!)
         (##repl-channel-display-multiline-message
          (lambda (port)
            (##cmd-st thread-or-tgroup
                      port)))
         (##repl-context-prompt repl-context))

       (cond ((macro-tgroup? val)
              (handle val))
             ((macro-thread? val)
              (handle val))
             (else
              (##repl-channel-acquire-ownership!)
              (##repl-cmd-invalid
               "THREAD or THREAD-GROUP expected"
               repl-context)))))))

(define ##repl-commands-with-1-arg
  (##list (##cons 'h   ##repl-cmd-h-with-1-arg)
          (##cons 'c   ##repl-cmd-c-with-1-arg)
          (##cons 's   ##repl-cmd-s-with-1-arg)
          (##cons 'l   ##repl-cmd-l-with-1-arg)
          (##cons 'b   ##repl-cmd-b-with-1-arg)
          (##cons 'be  ##repl-cmd-be-with-1-arg)
          (##cons 'bed ##repl-cmd-bed-with-1-arg)
          (##cons 'e   ##repl-cmd-e-with-1-arg)
          (##cons 'ed  ##repl-cmd-ed-with-1-arg)
          (##cons 'v   ##repl-cmd-v-with-1-arg)
          (##cons 'st  ##repl-cmd-st-with-1-arg)
          ))

(define-prim (##repl-commands-with-1-arg-set! x)
  (set! ##repl-commands-with-1-arg x))

(define-prim (##repl-within-proc proc cont)
  (cond ((##interp-procedure? proc)
         (##continuation-capture
          (lambda (cont2)

            (##declare (not inline)) ;; don't inline repl procedure

            (define (repl)
              (##continuation-capture
               (lambda (cont3)
                 (##continuation-graft
                  cont2
                  (lambda ()
                    (##repl-within cont3 #f #f #f))))))

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
                              (##setup-requirements-and-run c rte)))))))

  (let ((src2 (##sourcify src (##make-source #f #f))))
    (cond ((##interp-continuation? cont)
           (let* (($code (##interp-continuation-code cont))
                  (cte (macro-code-cte $code))
                  (rte (##interp-continuation-rte cont)))
             (run (##compile-inner cte src2) rte)))
          ((##with-no-result-expected-toplevel-continuation? cont)
           (run (##compile-top ##interaction-cte src2) #f))
          (else
           (let* ((locals (##continuation-locals cont))
                  (cte (##cte-frame (##cte-top-cte ##interaction-cte)
                                    (##map ##car locals)))
                  (rte (macro-make-rte-from-list #f (##map ##cdr locals))))
             (run (##compile-inner cte src2) rte))))))

;;;----------------------------------------------------------------------------

(define-prim (##repl-exception-handler-hook exc other-handler)
  (##declare (not interrupts-enabled))
  (let ((settings (##set-debug-settings! 0 0)))
    (if (and (##not (##eq? (macro-current-thread) (macro-primordial-thread)))
             (##fx= (macro-debug-settings-uncaught-primordial)
                    (macro-debug-settings-uncaught settings)))
        (other-handler exc)
        (##repl
         (lambda (first port)
           (let ((quit? (##fx= (macro-debug-settings-error settings)
                               (macro-debug-settings-error-quit)))
                 (level (macro-debug-settings-level settings)))
             (if quit?
                 (begin
                   (if (##fx>= level 1)
                       (begin
                         (##display-exception-in-context exc first port)
                         (if (##fx>= level 2) ;; display backtrace?
                             (##display-continuation-backtrace
                              first ;; cont
                              port ;; port
                              (##fx>= level 3) ;; display-env?
                              #f ;; all-frames?
                              ##backtrace-default-max-head ;; max-head
                              ##backtrace-default-max-tail ;; max-tail
                              0)))) ;; depth
                   (##exit-with-exception exc))
                 (begin
                   (##display-exception-in-context exc first port)
                   #f))))
         exc
         #f
         #t))))

(define-prim (##default-user-interrupt-handler)
  (let* ((settings (##set-debug-settings! 0 0))
         (settings-user-intr (macro-debug-settings-user-intr settings))
         (quit? (##fx= settings-user-intr
                       (macro-debug-settings-user-intr-quit))))
    (if (and quit? (##fx= (macro-debug-settings-level settings) 0))
        (##exit-abruptly)
        ;; ignore interrupts when the thread has acquired
        ;; ownership of it's repl channel
        (if (##not (##repl-channel-have-ownership?))
            (##user-interrupt-current-thread! quit?)))))

(define default-user-interrupt-handler ##default-user-interrupt-handler)

(define-prim (##user-interrupt-current-thread! quit?)
  (##with-no-result-expected
   (lambda ()
     (##repl
      (lambda (first port)
        (##display-situation
         "INTERRUPTED"
         (##continuation-creator first)
         (##continuation-locat first)
         port)
        (##newline port)
        (if quit?
            (##exit-abruptly)
            #f))))))

(##primordial-exception-handler-hook-set! ##repl-exception-handler-hook)

(if (##fx= (macro-debug-settings-error (##set-debug-settings! 0 0))
           (macro-debug-settings-error-single-step))
    (##step-on)) ;; turn on stepping on current stepper

(let* ((settings (##set-debug-settings! 0 0))
       (settings-user-intr (macro-debug-settings-user-intr settings)))
  (if (##not (##fx= settings-user-intr
                    (macro-debug-settings-user-intr-defer)))
      (##current-user-interrupt-handler ##default-user-interrupt-handler)))

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
        ((and (macro-wrong-number-of-values-exception? exc)
              (macro-wrong-number-of-values-exception-code exc))
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
    (display-form (##make-friendly-call-form
                   proc
                   args
                   max-displayed-args
                   ##inverse-eval
                   #t)))

  (define (display-form annotated-form)
    (let* ((width
            (##output-port-width port))
           (form
            (##map ##cdr annotated-form))
           (str
            (##object->string form width port)))
      (if (##fx< (##string-length str) width)
          (begin
            (##write-string str port)
            (##newline port))
          (let ((w (##fx- width 2)))

            (define (end s)
              (if (##not (##fx< (##string-length s) w)) (##newline port))
              (##write-string ")" port)
              (##newline port))

            (let loop ((i 0) (lst annotated-form))
              (##write-string (if (##fx= i 0) "(" " ") port)
              (let* ((val-expr
                      (##car lst))
                     (val
                      (##car val-expr))
                     (expr
                      (##cdr val-expr))
                     (s
                      (##value->string val expr w port)))
                (##write-string s port)
                (let ((rest (##cdr lst)))
                  (cond ((##pair? rest)
                         (##newline port)
                         (loop (##fx+ i 1) rest))
                        ((##null? rest)
                         (end s))
                        (else
                         (let ((s2 (##object->string rest w port)))
                           (##newline port)
                           (##write-string " ." port)
                           (##newline port)
                           (##write-string " " port)
                           (##write-string s2 port)
                           (end s2)))))))))))

  (define-prim (write-items items)
    (let loop ((lst items))
      (if (##pair? lst)
          (begin
            (##write-string " " port)
            (##write (##car lst) port)
            (loop (##cdr lst))))))

  (define-prim (display-arg-id arg-id)
    (let ((arg-num (if (##pair? arg-id) (##car arg-id) arg-id)))
      (if (##fx< 0 arg-num)
          (begin
            (##write-string "(Argument " port)
            (##write arg-num port)
            (if (##pair? arg-id)
                (begin
                  (##write-string ", " port)
                  (##write (##cdr arg-id) port)))
            (##write-string ") " port)))))

  (define-prim (display-known-exception exc)

    (define (err-code->string code)
      (let ((x (##os-err-code->string code)))
        (if (##string? x)
            x
            "Error code could not be converted to a string")))

    (cond ((macro-abandoned-mutex-exception? exc)
           (##write-string "MUTEX was abandoned" port)
           (##newline port))

          ((macro-sfun-conversion-exception? exc)
           (##display
            (or (macro-sfun-conversion-exception-message exc)
                (err-code->string
                 (macro-sfun-conversion-exception-code exc)))
            port)
           (##newline port)
           (display-call))

          ((macro-cfun-conversion-exception? exc)
           (##display
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
                            (let ((s (##object->truncated-string p width port)))
                              (if (##fx= (##string-length s) width)
                                  (begin
                                    (set! sep "\n")
                                    (##string->limited-string
                                     s
                                     (##fx- width 1)))
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

          ((macro-unbound-key-exception? exc)
           (##write-string "Unbound key" port)
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
           (let* ((kind
                   (macro-expression-parsing-exception-kind exc))
                  (name
                   (if (##string? kind)
                       kind
                       (let ((x
                              (##assq kind
                                      ##expression-parsing-exception-names)))
                         (if x
                             (##cdr x)
                             "Unknown expression parsing exception")))))
             (##write-string name port)
             (write-items (macro-expression-parsing-exception-parameters exc))
             (##newline port)
             (if (##eq? kind 'ill-formed-special-form)
                 (display-form
                  (let* ((src (macro-expression-parsing-exception-source exc))
                         (code (##desourcify src)))
                    (if (##pair? code)
                        (let* ((head
                                (##car code))
                               (friendly-head
                                (if (##symbol? head)
                                    (let* ((name (##symbol->string head))
                                           (len (##string-length name)))
                                      (if (and (##fx< 2 len)
                                               (##char=? #\#
                                                         (##string-ref name 0))
                                               (##char=? #\#
                                                         (##string-ref name 1)))
                                          (##string->symbol
                                           (##substring name 2 len))
                                          head))
                                    head)))
                          (##make-friendly-form (##cons friendly-head
                                                        friendly-head)
                                                (##cdr code)
                                                max-displayed-args
                                                ##identity
                                                #t))
                        code))))))

          ((macro-heap-overflow-exception? exc)
           (##write-string "Heap overflow" port)
           (##newline port))

          ((macro-length-mismatch-exception? exc)
           (display-arg-id (macro-length-mismatch-exception-arg-id exc))
           (##write-string "Length does not match other arguments" port)
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

          ((macro-wrong-processor-c-return-exception? exc)
           (##write-string
            "Attempt to return to a C function that was called on another processor"
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

          ((macro-file-exists-exception? exc)
           (##write-string "File exists" port)
           (##newline port)
           (display-call))

          ((macro-permission-denied-exception? exc)
           (##write-string "Permission denied" port)
           (##newline port)
           (display-call))

          ((macro-module-not-found-exception? exc)
           (##write-string "Module not found" port)
           (##newline port)
           (display-call))

          ((macro-range-exception? exc)
           (display-arg-id (macro-range-exception-arg-id exc))
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
           (display-arg-id (macro-type-exception-arg-id exc))
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

          ((macro-wrong-number-of-values-exception? exc)
           (##write-string
            "Wrong number of values being bound"
            port)
           (##newline port)
           (display-call))

          ((macro-invalid-utf8-encoding-exception? exc)
           (##write-string "Invalid UTF-8 encoding" port)
           (##newline port)
           (display-call))

          ((macro-not-in-compilation-context-exception? exc)
           (##write-string
            "Not in compilation context"
            port)
           (##newline port)
           (display-call))

          (else
           (##write-string "This object was raised: " port)
           (##write exc port)
           (##newline port))))

  (if (##structure? exc)
      (let* ((type (##structure-type exc))
             (id (##type-id type))
             (handler
              (##table-ref (##structure-display-exception-handler-table-get)
                           id
                           #f)))
        (if handler
            (begin
              (handler exc port)
              (display-call))
            (display-known-exception exc)))
      (display-known-exception exc)))

(define-prim (##value->string val expr max-length char-encoding-limit)
  (if ##values-with-sn?
      (##object->string-with-sn
       expr
       max-length
       char-encoding-limit
       3 ;; at least "..."
       val)
      (##object->string
       expr
       max-length
       char-encoding-limit)))

(define-prim (##exception-procedure-and-arguments exc)

  (define (known-exception-procedure-and-arguments exc)
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

          ((macro-unbound-key-exception? exc)
           (##cons
            (macro-unbound-key-exception-procedure exc)
            (macro-unbound-key-exception-arguments exc)))

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

          ((macro-length-mismatch-exception? exc)
           (##cons
            (macro-length-mismatch-exception-procedure exc)
            (macro-length-mismatch-exception-arguments exc)))

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

          ((macro-nonprocedure-operator-exception? exc)
           (##cons
            (macro-nonprocedure-operator-exception-operator exc)
            (macro-nonprocedure-operator-exception-arguments exc)))

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

          ((macro-file-exists-exception? exc)
           (##cons
            (macro-file-exists-exception-procedure exc)
            (macro-file-exists-exception-arguments exc)))

          ((macro-permission-denied-exception? exc)
           (##cons
            (macro-permission-denied-exception-procedure exc)
            (macro-permission-denied-exception-arguments exc)))

          ((macro-module-not-found-exception? exc)
           (##cons
            (macro-module-not-found-exception-procedure exc)
            (macro-module-not-found-exception-arguments exc)))

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

          ((macro-not-in-compilation-context-exception? exc)
           (##cons
            (macro-not-in-compilation-context-exception-procedure exc)
            (macro-not-in-compilation-context-exception-arguments exc)))

          (else
           #f)))

  (if (##structure? exc)
      (let* ((type (##structure-type exc))
             (id (##type-id type))
             (handler
              (##table-ref (##structure-display-exception-handler-table-get)
                           id
                           #f)))
        (if handler
            (handler exc #f)
            (known-exception-procedure-and-arguments exc)))
      (known-exception-procedure-and-arguments exc)))

(define ##structure-display-exception-handler-table #f)

(define-prim (##structure-display-exception-handler-table-get)
  (or ##structure-display-exception-handler-table
      (let ((t (##make-table-aux 0 #f #f #f ##eq?)))
        (set! ##structure-display-exception-handler-table t)
        ##structure-display-exception-handler-table)))

(define-prim (##structure-display-exception-handler-register! id proc)
  (##declare (not interrupts-enabled))
  (let ((handler-table (##structure-display-exception-handler-table-get)))
    (if proc
        (##table-set! handler-table id proc)
        (##table-set! handler-table id))))

(define ##display-exception-hook ##default-display-exception)

(define-prim (##display-exception-hook-set! x)
  (set! ##display-exception-hook x))

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

(define ##type-exception-names
  '(
    ;; from "_kernel.scm":
    (foreign                      . "FOREIGN object")

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
    (deeper-pair-tree             . "Deeper PAIR tree")
    (list-list                    . "LIST LIST")
    (longer-list                  . "Longer LIST")
    (char                         . "CHARACTER")
    (char-list                    . "CHARACTER LIST")
    (char-vector                  . "CHARACTER VECTOR")
    (string                       . "STRING")
    (string-list                  . "STRING LIST")
    (list                         . "LIST")
    (proper-list                  . "PROPER LIST")
    (proper-or-circular-list      . "PROPER or CIRCULAR LIST")
    (symbol                       . "SYMBOL")
    (keyword                      . "KEYWORD")
    (boolean                      . "BOOLEAN")
    (boolean-list                 . "BOOLEAN LIST")
    (boolean-vector               . "BOOLEAN VECTOR")
    (vector                       . "VECTOR")
    (vector-list                  . "VECTOR LIST")
    (s8vector                     . "S8VECTOR")
    (s8vector-list                . "S8VECTOR LIST")
    (u8vector                     . "U8VECTOR")
    (u8vector-list                . "U8VECTOR LIST")
    (s16vector                    . "S16VECTOR")
    (s16vector-list               . "S16VECTOR LIST")
    (u16vector                    . "U16VECTOR")
    (u16vector-list               . "U16VECTOR LIST")
    (s32vector                    . "S32VECTOR")
    (s32vector-list               . "S32VECTOR LIST")
    (u32vector                    . "U32VECTOR")
    (u32vector-list               . "U32VECTOR LIST")
    (s64vector                    . "S64VECTOR")
    (s64vector-list               . "S64VECTOR LIST")
    (u64vector                    . "U64VECTOR")
    (u64vector-list               . "U64VECTOR LIST")
    (f32vector                    . "F32VECTOR")
    (f32vector-list               . "F32VECTOR LIST")
    (f64vector                    . "F64VECTOR")
    (f64vector-list               . "F64VECTOR LIST")
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
    (nonnegative-exact-integer    . "Nonnegative exact INTEGER")
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
    (tls-version                  . "TLS VERSION")
    (tls-options                  . "TLS OPTIONS")
    (port                         . "PORT")
    (input-port                   . "INPUT PORT")
    (output-port                  . "OUTPUT PORT")
    (object-input-port            . "Object INPUT PORT")
    (object-output-port           . "Object OUTPUT PORT")
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
    (udp-port                     . "Udp PORT")
    (udp-input-port               . "Udp INPUT PORT")
    (udp-output-port              . "Udp OUTPUT PORT")
    (readtable                    . "READTABLE")
    (hostent                      . "HOSTENT")
    (datum-parsing-exception      . "DATUM PARSING EXCEPTION object")
    (network-family               . "NETWORK FAMILY")
    (network-socket-type          . "NETWORK SOCKET-TYPE")
    (network-protocol             . "NETWORK PROTOCOL")

    ;; from "_eval.scm":
    (expression-parsing-exception . "EXPRESSION PARSING EXCEPTION object")

    ;; from "_repl.scm":
    (interpreted-procedure        . "Interpreted PROCEDURE")
    ))

;;;;;;;    (psettings                    . "Invalid port settings")
;;;;;;;    (open-file                    . "Can't open file")

(define-prim (##type-exception-names-set! x)
  (set! ##type-exception-names x))

(define ##datum-parsing-exception-names
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

(define-prim (##datum-parsing-exception-names-set! x)
  (set! ##datum-parsing-exception-names x))

(define ##expression-parsing-exception-names
  '(
    (id-expected                      . "Identifier expected")
    (invalid-module-name              . "Invalid module name")
    (ill-formed-namespace             . "Ill-formed namespace")
    (ill-formed-namespace-prefix      . "Ill-formed namespace prefix")
    (namespace-prefix-must-be-string  . "Namespace prefix must be a string")
    (macro-used-as-variable           . "Macro name can't be used as a variable:")
    (variable-is-immutable            . "Variable is immutable:")
    (ill-formed-macro-transformer     . "Macro transformer must be a lambda expression")
    (reserved-used-as-variable        . "Reserved identifier can't be used as a variable:")
    (ill-formed-special-form          . "Ill-formed special form")
    (module-not-found                 . "Module not found:")
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
    (ill-formed-define-module-alias   . "Ill-formed define-module-alias")
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

(define-prim (##expression-parsing-exception-names-set! x)
  (set! ##expression-parsing-exception-names x))

;;;----------------------------------------------------------------------------

(define ##gambdoc
  (lambda args

    (define prefix "GAMBDOC_")

    (let* ((path
            (##path-expand
             (##string-append "gambdoc"
                              ##os-bat-extension-string-saved)
             (##path-normalize-directory-existing "~~bin")))
           (add-vars ;; pass arguments in shell environment variables
            (##append
             (##shell-var-bindings
              (##shell-args-numbered args)
              prefix)
             (##shell-var-bindings
              (##shell-install-dirs '("doc"))
              ""
              ""))))

      (##tty-mode-reset) ;; reset tty (in case subprocess needs to read tty)

      (let ((exit-status
             (##run-subprocess
              path
              '() ;; no arguments
              #f  ;; don't capture output
              #f  ;; don't redirect stdin
              #f  ;; run in current directory
              add-vars)))

        (if (##fx= exit-status 0)
            (##void)
            (##raise-error-exception
             "failed to display the document"
             args))))))

(define (##gambdoc-set! x)
  (set! ##gambdoc x))

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
  (##gambdoc "help"
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

(define ##help-hook ##default-help)

(define-prim (##help-hook-set! x)
  (set! ##help-hook x))

(define-prim (##help subject)
  (##help-hook subject))

(define-prim (help #!optional (subject (macro-absent-obj)))
  (macro-force-vars (subject)
    (##help (if (##eq? subject (macro-absent-obj)) help subject))))

;;;----------------------------------------------------------------------------

(define-prim (##apropos
              #!optional
              (substring (macro-absent-obj))
              (port (macro-absent-obj)))
  (let ((ns-tbl
         (##make-table))
        (substring
         (cond ((##eq? substring (macro-absent-obj))
                "")
               ((##symbol? substring)
                (##symbol->string substring))
               (else
                substring)))
        (port
         (if (##eq? port (macro-absent-obj))
             (##repl-output-port)
             port)))

    (define (interesting? str)
      (##string-contains str substring))

    (define (add-interesting-symbol sym)
      (let ((str (##symbol->string sym)))
        (if (interesting? str)
            (let* ((i (##fx+ 1 (##namespace-separator-index str)))
                   (ns (##substring str 0 i))
                   (name (##substring str i (##string-length str))))
              (##table-set! ns-tbl
                            ns
                            (##cons name (##table-ref ns-tbl ns '())))))))

    (define (add-interesting-global-vars)
      (##global-var-table-foldl
       (lambda (dummy global-var)
         (add-interesting-symbol global-var))
       #f))

    (define (display-namespaces ns-alist)
      (##for-each
       (lambda (x)
         (let* ((width (##fx- (##output-port-width port) 1))
                (ns (##car x))
                (names (##cdr x)))
           (if (##string=? ns "")
               (##write-string "empty" port)
               (##write ns port))
           (##write-string " namespace:" port)
           (let loop ((lst names) (sep "") (pos width))
             (if (##pair? lst)
                 (let* ((repr
                         (##object->string (##string->symbol (##car lst))))
                        (len
                         (##string-length repr))
                        (new-pos
                         (##fx+ pos (##fx+ (##string-length sep) 1 len))))
                   (##write-string sep port)
                   (if (##fx< new-pos width)
                       (begin
                         (##write-string " " port)
                         (##write-string repr port)
                         (loop (##cdr lst)
                               ","
                               new-pos))
                       (begin
                         (##newline port)
                         (##write-string "  " port)
                         (##write-string repr port)
                         (loop (##cdr lst)
                               ","
                               (##fx+ 2 len)))))))
           (##newline port)))
       ns-alist))

    (add-interesting-global-vars)

    (let ((empty-ns
           (##table-ref ns-tbl "" '())))
      (##table-set! ns-tbl "") ;; remove empty namespace to put it last
      (let* ((sorted-ns-alist
              (##list-sort!
               (lambda (x y) (##string<? (##car x) (##car y)))
               (##table->list ns-tbl)))
             (ns-alist
              (##map (lambda (x)
                       (##set-cdr! x (##list-sort! ##string<? (##cdr x))))
                     (if (##pair? empty-ns)
                         (##append sorted-ns-alist
                                   (##list (##cons "" empty-ns)))
                         sorted-ns-alist))))
        (display-namespaces ns-alist)))))

(define-prim (apropos
              #!optional
              (substring (macro-absent-obj))
              (port (macro-absent-obj)))

  (define (apro param)
    (if (##eq? port (macro-absent-obj))
        (##apropos param)
        (macro-check-output-port port 2 (apropos substring port)
          (##apropos param port))))

  (macro-force-vars (substring port)
    (if (##eq? substring (macro-absent-obj))
        (##apropos)
        (if (##symbol? substring)
            (apro substring)
            (macro-check-string substring 1 (apropos substring port)
              (apro substring))))))

;;;----------------------------------------------------------------------------

(define-runtime-macro (time
                       expr
                       #!optional
                       (port (macro-absent-obj)))
  (if (eq? port (macro-absent-obj))
      `(##time-thunk (lambda () ,expr) ',expr)
      `(##time-thunk (lambda () ,expr) ',expr ,port)))

(define-prim (##exec-stats thunk)
  (let* ((at-start (##process-statistics))
         (cpu-cycles-at-start (##cpu-cycle-count-start))
         (result (thunk))
         (cpu-cycles-at-end (##cpu-cycle-count-end))
         (at-end (##process-statistics))
         (user-time
          (##fl- (##f64vector-ref at-end 0)
                 (##f64vector-ref at-start 0)))
         (sys-time
          (##fl- (##f64vector-ref at-end 1)
                 (##f64vector-ref at-start 1)))
         (real-time
          (##fl- (##f64vector-ref at-end 2)
                 (##f64vector-ref at-start 2)))
         (gc-user-time
          (##fl- (##f64vector-ref at-end 3)
                 (##f64vector-ref at-start 3)))
         (gc-sys-time
          (##fl- (##f64vector-ref at-end 4)
                 (##f64vector-ref at-start 4)))
         (gc-real-time
          (##fl- (##f64vector-ref at-end 5)
                 (##f64vector-ref at-start 5)))
         (nb-gcs
          (##flonum->exact-int
           (##fl- (##f64vector-ref at-end 6)
                  (##f64vector-ref at-start 6))))
         (minflt
          (##flonum->exact-int
           (##fl- (##f64vector-ref at-end 10)
                  (##f64vector-ref at-start 10))))
         (majflt
          (##flonum->exact-int
           (##fl- (##f64vector-ref at-end 11)
                  (##f64vector-ref at-start 11))))
         (bytes-allocated
          (##flonum->exact-int
           (##fl- (##fl- (##f64vector-ref at-end 7)
                         (##f64vector-ref at-start 7))
                  (##fl+ (if (##interp-procedure? thunk)
                             (##f64vector-ref at-end 8) ;; thunk call frame space
                             (macro-inexact-+0))
                         (##f64vector-ref at-end 9))))) ;; at-end structure space
         (cpu-cycles
          (##fxmax 0 (##fx- cpu-cycles-at-end cpu-cycles-at-start))))

    (##list (##cons 'result          result)
            (##cons 'user-time       user-time)
            (##cons 'sys-time        sys-time)
            (##cons 'real-time       real-time)
            (##cons 'gc-user-time    gc-user-time)
            (##cons 'gc-sys-time     gc-sys-time)
            (##cons 'gc-real-time    gc-real-time)
            (##cons 'nb-gcs          nb-gcs)
            (##cons 'minflt          minflt)
            (##cons 'majflt          majflt)
            (##cons 'bytes-allocated bytes-allocated)
            (##cons 'cpu-cycles      cpu-cycles))))

(define-prim (##time-thunk
              thunk
              expr
              #!optional (port (macro-absent-obj)))
  (macro-force-vars (port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (##repl-output-port)
               port)))
      (macro-check-output-port p 3 (##time-thunk thunk expr p)
        (let* ((stats (##exec-stats thunk))
               (result (##cdar stats))
               (stats (##cdr stats))
               (user-time (##cdar stats))
               (stats (##cdr stats))
               (sys-time (##cdar stats))
               (stats (##cdr stats))
               (real-time (##cdar stats))
               (stats (##cdr stats))
               (gc-user-time (##cdar stats))
               (stats (##cdr stats))
               (gc-sys-time (##cdar stats))
               (stats (##cdr stats))
               (gc-real-time (##cdar stats))
               (stats (##cdr stats))
               (nb-gcs (##cdar stats))
               (stats (##cdr stats))
               (minflt (##cdar stats))
               (stats (##cdr stats))
               (majflt (##cdar stats))
               (stats (##cdr stats))
               (bytes-allocated (##cdar stats))
               (stats (##cdr stats))
               (cpu-cycles (##cdar stats)))

          (define (secs x)
            (let* ((precision 1000000)
                   (scaled
                    (##inexact->exact (##round (##* x precision))))
                   (int-part
                    (##number->string
                     (##quotient scaled precision)))
                   (decimal-part
                    (##number->string
                     (##+ precision (##modulo scaled precision)))))
              (##string-set! decimal-part 0 #\.)
              (##string-append int-part decimal-part)))

          (define (print-stats port)

            (define (pluralize n msg)
              (##write-string "    " port)
              (if (##= n 0)
                  (##write-string "no" port)
                  (##write n port))
              (##write-string msg port)
              (if (##not (##= n 1))
                  (##write-string "s" port)))

            (##write (##list 'time expr) port)
            (##newline port)

            (##write-string "    " port)
            (##write-string (secs real-time) port)
            (##write-string " secs real time" port)
            (##newline port)

            (##write-string "    " port)
            (##write-string (secs (##+ user-time sys-time)) port)
            (##write-string " secs cpu time (" port)
            (##write-string (secs user-time) port)
            (##write-string " user, " port)
            (##write-string (secs sys-time) port)
            (##write-string " system)" port)
            (##newline port)

            (pluralize nb-gcs " collection")
            (if (##not (##= nb-gcs 0))
                (begin
                  (##write-string " accounting for " port)
                  (##write-string (secs gc-real-time) port)
                  (##write-string " secs real time (" port)
                  (##write-string (secs gc-user-time) port)
                  (##write-string " user, " port)
                  (##write-string (secs gc-sys-time) port)
                  (##write-string " system)" port)))
            (##newline port)

            (pluralize bytes-allocated " byte")
            (##write-string " allocated" port)
            (##newline port)

            (pluralize minflt " minor fault")
            (##newline port)

            (pluralize majflt " major fault")
            (##newline port)

            (if (##> cpu-cycles 0)
                (begin
                  (pluralize cpu-cycles " cpu cycle")
                  (##newline port))))

          (print-stats p)

          result)))))

;;;----------------------------------------------------------------------------

;; REPL server.

(define (##startup-repl-server)
  (##start-repl-server (##repl-server-addr)))

(define (##start-repl-server repl-server-addr)
  (if repl-server-addr
      (let ((tgroup ##tcp-service-tgroup))
        (##tcp-service-register!
         (##list local-port-number: 44555
                 local-address: repl-server-addr
                 output-buffering: #f)
         (lambda ()
           (let ((repl-channel
                  (##make-repl-channel-ports
                   (##current-input-port)
                   (##current-output-port)
                   (##current-output-port))))
             (macro-thread-repl-channel-set!
              (macro-current-thread)
              repl-channel))
           (##repl-debug-main))
         tgroup
         tgroup))))

;;;----------------------------------------------------------------------------

;; enable processing of heartbeat interrupts, user interrupts, GC
;; interrupts, etc.

(##enable-interrupts!)

(##startup-parallelism!)

(##startup-repl-server)

;;;============================================================================
