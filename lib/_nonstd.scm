;;;============================================================================

;;; File: "_nonstd.scm"

;;; Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Implementation of exceptions.

(implement-library-type-error-exception)

(define-prim (##raise-error-exception message parameters)
  (macro-raise
   (macro-make-error-exception
    message
    parameters)))

(implement-library-type-unbound-os-environment-variable-exception)

(define-prim (##raise-unbound-os-environment-variable-exception proc . args)
  (##extract-procedure-and-arguments
   proc
   args
   #f
   #f
   #f
   (lambda (procedure arguments dummy1 dummy2 dummy3)
     (macro-raise
      (macro-make-unbound-os-environment-variable-exception
       procedure
       arguments)))))

;;;----------------------------------------------------------------------------

;;; Define type checking procedures.

(define-fail-check-type string-or-nonnegative-fixnum
  'string-or-nonnegative-fixnum)

(define-fail-check-type will
  'will)

(define-fail-check-type box
  'box)

;;;----------------------------------------------------------------------------

;;; Non-standard procedures and special forms

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##deconstruct-call src size proc)
  (let* ((code (##source-strip src))
         (n (##proper-length code)))
    (if (or (##not n)
            (if (##fx< 0 size)
                (##not (##fx= n size))
                (##fx< n (##fx- 0 size))))
        (##raise-ill-formed-special-form src)
        (##apply proc (##cdr code)))))

(define-prim (##expand-source-template src template)
  (let ((locat (##source-locat src)))

    (define (expand template)
      (cond ((##source? template)
             template)
            ((##pair? template)
             (##make-source
              (expand-list template)
              locat))
            ((##vector? template)
             (##make-source
              (##list->vector (expand-list (##vector->list template)))
              locat))
            (else
             (##make-source
              template
              locat))))

    (define (expand-list template)
      (cond ((or (##source? template)
                 (##null? template))
             template)
            ((##pair? template)
             (##cons (expand (##car template))
                     (expand-list (##cdr template))))
            (else
             (##make-source
              template
              locat))))

    (expand template)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##error message . parameters)
  (##raise-error-exception message parameters))

(define-prim (error message . parameters)
  (##raise-error-exception message parameters))

(define-prim (error-object? obj)
  (macro-error-exception? obj))

(define-prim (error-object-message err-obj)
  (macro-check-error-exception
    err-obj
    1
    (error-object-message err-obj)
    (macro-error-exception-message err-obj)))

(define-prim (error-object-irritants err-obj)
  (macro-check-error-exception
    err-obj
    1
    (error-object-irritants err-obj)
    (macro-error-exception-parameters err-obj)))

(define-runtime-syntax ##syntax-error
  (lambda (src)
    (##deconstruct-call
     src
     -2
     (lambda args
       (##apply ##raise-syntax-error
                (##cons src (##map ##desourcify args)))))))

(define-prim (##raise-syntax-error src message . args)
  (if (##string? message)
      (##apply ##raise-expression-parsing-exception
               (##cons message (##cons src args)))
      (##raise-ill-formed-special-form src)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##expand-supply-or-demand-module supply? src)
  (##deconstruct-call
   src
   2
   (lambda (sym-src)
     (let ((sym (##desourcify sym-src)))

       (if (##not (##symbol? sym))
           (##raise-ill-formed-special-form src))

       (if supply?
           (##compilation-supply-modules-add! sym)
           (##compilation-demand-modules-add! sym)))

     (##expand-source-template
      src
      `(##begin)))))

(define-runtime-syntax ##supply-module
  (lambda (src)
    (##expand-supply-or-demand-module #t src)))

(define-runtime-syntax ##demand-module
  (lambda (src)
    (##expand-supply-or-demand-module #f src)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define (##expand-meta-info src)
  (##deconstruct-call
   src
   -2
   (lambda (key-src . rest)
     (let ((key (##source-strip key-src)))
       (if (##not (##symbol? key))
           (##deconstruct-call src 1 ##list) ;; signal a syntax error
           (let ((attribs (##map ##desourcify rest)))
             (##for-each
              (lambda (attrib)
                (##compilation-meta-info-add! key attrib))
              attribs)
             (##expand-source-template
              src
              `(##begin))))))))

(define-runtime-syntax ##meta-info
  (lambda (src)
    (##expand-meta-info src)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax ##parameterize
  (lambda (src)
    (##deconstruct-call
     src
     -2
     (lambda (bindings . body)
       (##expand-source-template
        src
        (##parameterize-build
         src
         bindings
         body))))))

(define-prim (##parameterize-build src bindings body)

  (define (build bindings rev-params-vals)
    (cond ((##pair? bindings)
           (let ((binding (##source-strip (##car bindings))))
             (##shape src (##sourcify binding src) 2)
             (let* ((param (##source-strip (##car binding)))
                    (val (##source-strip (##cadr binding))))
               (build (##cdr bindings)
                      (##cons (##cons (##cons (##gensym) param)
                                      (##cons (##gensym) val))
                              rev-params-vals)))))
          ((##null? bindings)
           (if (##null? rev-params-vals)
               (##cons 'let (##cons '() body))
               (let ((params-vals (##reverse rev-params-vals)))

                 (define (bind params-vals)
                   (if (##null? params-vals)
                       (##cons 'let (##cons '() body))
                       (let* ((param-val (##car params-vals))
                              (param (##car param-val))
                              (val (##cdr param-val)))
                         (##list '##parameterize1
                                 (##car param)
                                 (##car val)
                                 (##list 'lambda
                                         '()
                                         (bind (##cdr params-vals)))))))

                 (##list 'let
                         (let loop ((lst rev-params-vals) (bs '()))
                           (if (##null? lst)
                               bs
                               (let* ((param-val (##car lst))
                                      (param (##car param-val))
                                      (val (##cdr param-val)))
                                 (loop (##cdr lst)
                                       (##cons (##list (##car param)
                                                       (##cdr param))
                                               (##cons (##list (##car val)
                                                               (##cdr val))
                                                       bs))))))
                         (bind params-vals)))))
          (else
           (##raise-expression-parsing-exception
            'ill-formed-binding-list
            src))))

  (build (##source-strip bindings)
         '()))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax ##this-source-file
  (lambda (src)
    (let ((path (##source-path src)))
      (if path
          (##make-source path (##source-locat src))
          (##raise-expression-parsing-exception
           'unknown-location
           src)))))

(define-runtime-syntax ##from-source-location
  (lambda (src)

    (define (syntax-err)
      (##raise-ill-formed-special-form src))

    (##deconstruct-call
     src
     3
     (lambda (location-src expr-src)
       (let* ((loc (##desourcify location-src))
              (len (##proper-length loc)))
         (if (##not (or (##eqv? len 3) (##eqv? len 4)))
             (syntax-err)
             (let ((path (##car loc))
                   (line (##cadr loc))
                   (col (##caddr loc))
                   (deep? (if (##eqv? len 3) #f (##cadddr loc))))
               (if (and (##string? path)
                        (##fixnum? line)
                        (##fixnum? col)
                        (##fx>= line 1)
                        (##fx>= col 1))
                   (let* ((container
                           (##path->container path))
                          (filepos
                           (##make-filepos (##fx- line 1) (##fx- col 1) 0))
                          (locat
                           (##make-locat container filepos)))
                     (##make-source
                      (if deep?
                          (##desourcify expr-src)
                          (##source-strip expr-src))
                      locat))
                   (syntax-err)))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax ##cond-expand
  (lambda (src)
    (##deconstruct-call
     src
     -1
     (lambda clauses
       (##expand-source-template
        src
        (##cond-expand-build
         src
         clauses))))))

(define-prim (##cond-expand-build src clauses)

  (define (satisfied? feature-requirement)
    (cond ((##symbol? feature-requirement)
           (if (##member feature-requirement (##cond-expand-features))
               #t
               #f))
          ((##pair? feature-requirement)
           (let ((first (##source-strip (##car feature-requirement))))
             (cond ((##eq? first 'not)
                    (##shape src (##sourcify feature-requirement src) 2)
                    (##not (satisfied? (##source-strip (##cadr feature-requirement)))))
                   ((or (##eq? first 'and) (##eq? first 'or))
                    (##shape src (##sourcify feature-requirement src) -1)
                    (let loop ((lst (##cdr feature-requirement)))
                      (if (##pair? lst)
                          (let ((x (##source-strip (##car lst))))
                            (if (##eq? (satisfied? x) (##eq? first 'and))
                                (loop (##cdr lst))
                                (##not (##eq? first 'and))))
                          (##eq? first 'and))))
                   ((##eq? first 'library)
                    (##shape src (##sourcify feature-requirement src) 2)
                    (let* ((lib-src (##cadr feature-requirement))
                           (modref (##parse-module-ref lib-src)))
                      (if (##not modref)
                          (##raise-ill-formed-special-form src)
                          (##call-with-values
                           (lambda ()
                             (##find-mod-info src lib-src))
                           (lambda (mod-info module-ref)
                             (if (##not mod-info)
                                 #f
                                 (let ((port
                                        (##vector-ref mod-info 4)))
                                   (if port
                                       (##close-port port))
                                   #t)))))))
                   ((##eq? first 'compilation-target)
                    (let ((fr (##sourcify feature-requirement src)))
                      (##shape src fr -1)
                      (let ((ct (##compilation-target)))
                        (let loop ((lst (##cdr (##source-strip fr))))
                          (and (##pair? lst)
                               (let ((t (##desourcify (##car lst))))
                                 (or (if (##pair? t)
                                         (and (##pair? ct)
                                              (##null? (##cdr ct))
                                              (##null? (##cdr t))
                                              (let ((x (##car t)))
                                                (or (##eq? x '_)
                                                    (##eq? x (##car ct)))))
                                         (##eq? t ct))
                                     (loop (##cdr lst)))))))))
                   (else
                    (macro-raise
                     (macro-make-expression-parsing-exception
                      'ill-formed-cond-expand
                      src
                      '()))))))
          (else
           (macro-raise
            (macro-make-expression-parsing-exception
             'ill-formed-cond-expand
             src
             '())))))

  (define (build clauses)
    (if (##pair? clauses)
        (let ((clause (##source-strip (##car clauses))))
          (##shape src (##sourcify clause src) -1)
          (let ((feature-requirement (##source-strip (##car clause))))
            (if (or (and (##eq? feature-requirement 'else)
                         (##null? (##cdr clauses)))
                    (satisfied? feature-requirement))
                (##cons 'begin (##cdr clause))
                (build (##cdr clauses)))))
        (macro-raise
         (macro-make-expression-parsing-exception
          'unfulfilled-cond-expand
          src
          '()))))

  (build clauses))

(##define-macro (generate-cond-expand-features)

  (define gambits '(gambit GAMBIT Gambit))

  (define (split sym)
    (let* ((str (symbol->string sym))
           (len (string-length str))
           (x (memv #\- (string->list str)))
           (i (if x (- len (length x)) len)))
      (cons (substring str 0 i)
            (substring str i len))))

  (define (keep-disable/enable syms) ;; extract enable/disable features
    (let loop ((seen '()) (lst syms))
      (if (pair? lst)
          (loop (let* ((sym (car lst))
                       (x (split sym)))
                  (if (and (member (car x) '("enable" "disable"))
                           (not (assoc (cdr x) seen))) ;; keep most recent
                      (cons (cons (cdr x) sym) seen)
                      seen))
                (cdr lst))
          (reverse (map cdr seen)))))

  `'(;; propagate disable/enable features that are used for compilation
     ,@(keep-disable/enable (##cond-expand-features))
     ,@gambits
     srfi-0 SRFI-0
     srfi-4 SRFI-4
     srfi-6 SRFI-6
     srfi-8 SRFI-8
     srfi-9 SRFI-9
     srfi-16 SRFI-16
     srfi-18 SRFI-18
     srfi-21 SRFI-21
     srfi-22 SRFI-22
     srfi-23 SRFI-23
     srfi-27 SRFI-27
     srfi-30 SRFI-30
;;;     srfi-38 SRFI-38
     srfi-39 SRFI-39
     srfi-62 SRFI-62
     srfi-88 SRFI-88
;;;     srfi-89 SRFI-89
;;;     srfi-90 SRFI-90
;;;     srfi-91 SRFI-91
     srfi-193 SRFI-193

     exact-closed
     exact-complex
     ieee-float
     full-unicode
     ratios
     ))

(define ##cond-expand-features
  (##make-parameter (generate-cond-expand-features)))

(define (##add-cond-expand-features lst features)
  (let loop ((lst lst)
             (features features))
    (if (##pair? lst)
        (loop (##cdr lst)
              (let ((f (##car lst)))
                (if (##not (##symbol? f))
                    features
                    (##cons
                     f
                     (let ((s (##symbol->string f)))
                       (let ((e (##string-prefix-strip "enable-" s)))
                         (if e
                             (##remq (##string->symbol
                                      (##string-append "disable-" e))
                                     features)
                             (let ((d (##string-prefix-strip "disable-" s)))
                               (if d
                                   (##remq (##string->symbol
                                            (##string-append "enable-" d))
                                           features)
                                   features)))))))))
        features)))

(define-runtime-macro (define-cond-expand-feature . features)
  (##cond-expand-features
   (##add-cond-expand-features features
                               (##cond-expand-features)))
  `(##begin))

(define features
  ##cond-expand-features)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax ##case-lambda
  (lambda (src)

    (define (formals-count formals)
      (let loop ((lst formals) (n 0))
        (cond ((##pair? lst) (loop (##cdr lst) (##fx+ n 1)))
              ((##null? lst) n)
              (else          (##fx- -1 n)))))

    (define (gen-var)
      (##gensym))

    (define (gen-vars n)
      (if (##fx> n 0)
          (##cons (gen-var) (gen-vars (##fx- n 1)))
          '()))

    (define (gen-absent-obj)
      (##cons '##quote (##cons (macro-absent-obj) '())))

    (define (extended-bindings var)
      `(##let () (##declare (extended-bindings ,var)) ,var))

    (##shape src src -2)

    (let loop ((clauses (##cdr (##source-code src)))
               (rev-cases '()) ;; reverse list of cases
               (covered 0) ;; set of cases covered by clauses
               (req-param-count #f)
               (req-and-opt-param-count #f)
               (need-rest-param? #f))
      (if (##pair? clauses)
          (let* ((clause-src
                  (##sourcify (##car clauses) src))
                 (clause
                  (##source-code clause-src)))

            (##shape src clause-src -2)

            (let* ((formals
                    (##source-code (##sourcify (##car clause) src)))
                   (body
                    (##cdr clause))
                   (nparams
                    (formals-count formals))
                   (nparams*
                    (if (##fx< nparams 0)
                        (##fx- -1 nparams)
                        nparams))
                   (params-covered
                    (if (##fx< nparams 0)
                        (##arithmetic-shift -1 nparams*)
                        (##arithmetic-shift 1 nparams)))
                   (trigger
                    (##bitwise-and params-covered
                                   (##bitwise-not covered))))
              (if (##eqv? trigger 0)
                  (begin
                    ;; this case already covered by previous clauses
                    (loop (##cdr clauses)
                          rev-cases
                          covered
                          req-param-count
                          req-and-opt-param-count
                          need-rest-param?))
                  (begin
                    ;; this case not covered by previous clauses
                    (loop (##cdr clauses)
                          (##cons (##vector nparams '() formals body)
                                  rev-cases)
                          (##bitwise-ior trigger covered)
                          (if req-param-count
                              (##fxmin req-param-count nparams*)
                              nparams*)
                          (if req-and-opt-param-count
                              (##fxmax req-and-opt-param-count nparams*)
                              nparams*)
                          (or need-rest-param?
                              (##fx< nparams 0)))))))

          (let* ((cases
                  (##reverse rev-cases))
                 (req-params
                  (gen-vars req-param-count))
                 (opt-params
                  (gen-vars (##fx- req-and-opt-param-count
                                   req-param-count)))
                 (rest-param
                  (if need-rest-param?
                      (gen-var)
                      '()))
                 (params
                  (##list->vector
                   (##append req-params opt-params)))
                 (proc-var
                  (##gensym))
                 (need-proc-var?
                  #f))

            (define (find-case i)
              (let loop ((lst cases))
                (if (##pair? lst)
                    (let* ((c (##car lst))
                           (nparams (##vector-ref c 0)))
                      (if (if (##fx< nparams 0)
                              (##fx>= i (##fx- -1 nparams))
                              (##fx= i nparams))
                          c
                          (loop (##cdr lst))))
                    #f)))

            (define (flatten-formals formals)
              (cond ((##pair? formals)
                     (let* ((rest (##cdr formals))
                            (flat-rest (flatten-formals rest)))
                       (if (##eq? rest flat-rest)
                           formals
                           (##cons (##car formals)
                                   flat-rest))))
                    ((##null? formals)
                     formals)
                    (else
                     (##cons formals
                             '()))))

            (define (gen-branch i case-i)
              (let ((branch
                     `(#f ;; placeholder for lambda expression or variable
                       ,@(gen-arguments i case-i))))
                (##vector-set! case-i
                               1
                               (##cons branch (##vector-ref case-i 1)))
                branch))

            (define (gen-params i)
              (##vector->list
               (##subvector params 0 i)))

            (define (gen-arguments i case-i)
              (let ((nparams (##vector-ref case-i 0)))
                (if (##fx< nparams 0) ;; has rest parameter?
                    (let ((nreq (##fx- -1 nparams)))
                      (let loop ((j (##fx- (##fxmin req-and-opt-param-count i) 1))
                                 (rest-arg rest-param))
                        (if (##fx< j nreq)
                            (##append (##vector->list
                                       (##subvector params 0 nreq))
                                      (##list rest-arg))
                            (loop (##fx- j 1)
                                  `(,(extended-bindings '##cons)
                                    ,(##vector-ref params j)
                                    ,rest-arg)))))
                    (gen-params i))))

            (define (gen-dispatch i)
              (let* ((case-i (find-case i))
                     (nparams (if case-i (##vector-ref case-i 0) i)))
                (cond ((and (##fx< nparams 0) ;; case with rest parameter
                            (##fx>= i req-and-opt-param-count))
                       (gen-branch i case-i))
                      ((and (##not need-rest-param?)
                            (##fx= i req-and-opt-param-count))
                       (gen-branch i case-i))
                      (else
                       `(##if ,(if (##fx= i req-and-opt-param-count)
                                   `(,(extended-bindings '##null?)
                                     ,rest-param)
                                   `(,(extended-bindings '##eq?)
                                     ,(##vector-ref params i)
                                     ,(gen-absent-obj)))
                              ,(if case-i
                                   (gen-branch i case-i)
                                   (begin
                                     (set! need-proc-var? #t)
                                     `(,(extended-bindings '##raise-wrong-number-of-arguments-exception-nary)
                                       ,proc-var
                                       ,@(gen-params i))))
                              ,(gen-dispatch (##fx+ i 1)))))))

            (let ((dispatch (gen-dispatch req-param-count)))
              (let loop ((lst cases) (rev-defs '()))
                (if (##pair? lst)
                    (let* ((c (##car lst))
                           (calls (##vector-ref c 1)))
                      (if (##pair? calls)
                          (let* ((formals (##vector-ref c 2))
                                 (body (##vector-ref c 3))
                                 (branch
                                  `(##lambda ,(flatten-formals formals)
                                             ,@body)))
                            (if (##null? (##cdr calls))
                                (begin
                                  (##set-car! (##car calls) branch)
                                  (loop (##cdr lst)
                                        rev-defs))
                                (let ((var (gen-var)))
                                  (##for-each (lambda (x)
                                                (##set-car! x var))
                                              calls)
                                  (loop (##cdr lst)
                                        (##cons (##list var branch)
                                                rev-defs)))))
                          (loop (##cdr lst)
                                rev-defs)))
                    (let ((lambda-expr
                           `(##lambda
                             ,(##append
                               req-params
                               (if (##pair? opt-params)
                                   (##cons '#!optional
                                           (##append
                                            (##map (lambda (p)
                                                     (##cons
                                                      p
                                                      (##cons
                                                       (gen-absent-obj)
                                                       '())))
                                                   opt-params)
                                            rest-param))
                                   '()))
                             ,(if (##pair? rev-defs)
                                  `(##let ,(##reverse rev-defs)
                                          ,dispatch)
                                  dispatch))))
                      (##expand-source-template
                       src
                       (if need-proc-var?
                           `(##letrec ((,proc-var ,lambda-expr)) ,proc-var)
                           lambda-expr)))))))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax ##receive
  (lambda (src)
    (##deconstruct-call
     src
     -4
     (lambda (formals expression . body)
       (##expand-source-template
        src
        `(##call-with-values
          (##lambda () ,expression)
          (##lambda ,formals ,@body)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax ##when
  (lambda (src)
    (##deconstruct-call
     src
     -3
     (lambda (test . expressions)
       (##expand-source-template
        src
        `(##if ,test (##begin ,@expressions)))))))

(define-runtime-syntax ##unless
  (lambda (src)
    (##deconstruct-call
     src
     -3
     (lambda (test . expressions)
       (##expand-source-template
        src
        `(##if (##not ,test) (##begin ,@expressions)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##type-field-count type)
  (if type
      (let ((fields (##type-fields type)))
        (##fx+ (##type-field-count (##type-super type))
               (##fxquotient (##vector-length fields) 3)))
      0))

(define-prim (##type-all-fields type)
  (if type
      (let ((fields (##type-fields type)))
        (##append (##type-all-fields (##type-super type))
                  (##vector->list fields)))
      '()))

(define-prim (##define-type-expand
               form-name
               super-type-static
               super-type-dynamic-expr
               args)

  (define (generate
           name
           flags
           id
           extender
           constructor
           constant-constructor
           copier
           predicate
           implementer
           type-exhibitor
           prefix
           fields
           total-fields)

    (define (generate-fields)
      (let loop ((lst1 (##reverse fields))
                 (lst2 '()))
        (if (##pair? lst1)
            (let* ((field
                    (##car lst1))
                   (descr
                    (##cdr field))
                   (field-name
                    (##vector-ref descr 0))
                   (options
                    (##vector-ref descr 5))
                   (attributes
                    (##vector-ref descr 6))
                   (init
                    (cond ((##assq 'init: attributes)
                           =>
                           (lambda (x) (##constant-expression-value (##cdr x))))
                          (else
                           #f))))
              (loop (##cdr lst1)
                    (##cons field-name
                            (##cons options
                                    (##cons init
                                            lst2)))))
            (##list->vector lst2))))

    (define (all-fields->rev-field-alist all-fields)
      (let loop ((i 1)
                 (lst all-fields)
                 (rev-field-alist '()))
        (if (##pair? lst)
            (let* ((field-name
                    (##car lst))
                   (rest1
                    (##cdr lst))
                   (options
                    (##car rest1))
                   (rest2
                    (##cdr rest1))
                   (val
                    (##car rest2))
                   (rest3
                    (##cdr rest2)))
              (loop (##fx+ i 1)
                    rest3
                    (##cons (##cons field-name
                                    (##vector i
                                              options
                                              val
                                              (generate-parameter i)))
                            rev-field-alist)))
            rev-field-alist)))

    (define (generate-parameter i)
      (##string->symbol
       (##string-append "p"
                        (##number->string i 10))))

    (define (generate-parameters rev-field-alist)
      (if (##pair? constructor)
          (##map (lambda (field-name)
                   (let ((x (##assq field-name rev-field-alist)))
                     (##vector-ref (##cdr x) 3)))
                 (##cdr constructor))
          (let loop ((lst rev-field-alist)
                     (parameters '()))
            (if (##pair? lst)
                (let ((x (##car lst)))
                  (loop (##cdr lst)
                        (let* ((options
                                (##vector-ref (##cdr x) 1))
                               (has-init?
                                (##not (##fx= (##fxand options 8)
                                              0))))
                          (if has-init?
                              parameters
                              (##cons (##vector-ref (##cdr x) 3)
                                      parameters)))))
                parameters))))

    (define (generate-initializations field-alist parameters in-macro?)
      (##map (lambda (x)
               (let* ((field-index (##vector-ref (##cdr x) 0))
                      (options (##vector-ref (##cdr x) 1))
                      (val (##vector-ref (##cdr x) 2))
                      (parameter (##vector-ref (##cdr x) 3)))
                 (if (##memq parameter parameters)
                     parameter
                     (make-quote
                      (if in-macro?
                          (make-quote val)
                          val)))))
             field-alist))

    (define (make-quote x)
      (##list 'quote x))

    (let* ((macros?
            (##not (##fx= (##fxand flags 4) 0)))
           (generative?
            (##not id))
           (augmented-id-str
            (##string-append
             "##type-"
             (##number->string total-fields 10)
             "-"
             (##symbol->string (if generative? name id))))
           (type-fields
            (generate-fields))
           (type-static
            (##structure
             ##type-type
             (if generative?
                 (##string->uninterned-symbol augmented-id-str)
                 (##string->symbol augmented-id-str))
             name
             flags
             super-type-static
             type-fields))
           (type-expression
            (if generative?
                (##string->symbol augmented-id-str)
                `',type-static))
           (type-id-expression
            (if generative?
                `(##let ()
                   (##declare (extended-bindings) (not safe))
                   (##type-id ,type-expression))
                `',(##type-id type-static)))
           (all-fields
            (##type-all-fields type-static))
           (rev-field-alist
            (all-fields->rev-field-alist all-fields))
           (field-alist
            (##reverse rev-field-alist))
           (parameters
            (generate-parameters rev-field-alist)))

      (define (generate-getter-and-setter field tail)
        (let* ((descr
                (##cdr field))
               (field-name
                (##vector-ref descr 0))
               (field-index
                (##vector-ref descr 1))
               (getter
                (##vector-ref descr 2))
               (setter
                (##vector-ref descr 3))
               (fsetter
                (##vector-ref descr 4))
               (getter-def
                (if getter
                    (let ((getter-name
                           (if (##eq? getter #t)
                               (##symbol-append prefix
                                                name
                                                '-
                                                field-name)
                               getter))
                          (getter-method
                           (if extender
                               '##structure-ref
                               '##direct-structure-ref)))
                      (if macros?
                          `((##define-macro (,getter-name obj)
                              (##list '(##let ()
                                         (##declare (extended-bindings))
                                         ,getter-method)
                                      obj
                                      ,field-index
                                      ',type-expression
                                      #f)))
                          `((##define (,getter-name obj)
                              ((##let ()
                                 (##declare (extended-bindings))
                                 ,getter-method)
                               obj
                               ,field-index
                               ,type-expression
                               ,getter-name)))))
                    `()))
               (setter-def
                (if setter
                    (let ((setter-name
                           (if (##eq? setter #t)
                               (##symbol-append prefix
                                                name
                                                '-
                                                field-name
                                                '-set!)
                               setter))
                          (setter-method
                           (if extender
                               '##structure-set!
                               '##direct-structure-set!)))
                      (if macros?
                          `((##define-macro (,setter-name obj val)
                              (##list '(##let ()
                                         (##declare (extended-bindings))
                                         ,setter-method)
                                      obj
                                      val
                                      ,field-index
                                      ',type-expression
                                      #f)))
                          `((##define (,setter-name obj val)
                              ((##let ()
                                 (##declare (extended-bindings))
                                 ,setter-method)
                               obj
                               val
                               ,field-index
                               ,type-expression
                               ,setter-name)))))
                    `()))
               (fsetter-def
                (if fsetter
                    (let ((fsetter-name
                           (if (##eq? fsetter #t)
                               (##symbol-append prefix
                                                name
                                                '-
                                                field-name
                                                '-set)
                               fsetter))
                          (fsetter-method
                           (if extender
                               '##structure-set
                               '##direct-structure-set)))
                      (if macros?
                          `((##define-macro (,fsetter-name obj val)
                              (##list '(##let ()
                                         (##declare (extended-bindings))
                                         ,fsetter-method)
                                      obj
                                      val
                                      ,field-index
                                      ',type-expression
                                      #f)))
                          `((##define (,fsetter-name obj val)
                              ((##let ()
                                 (##declare (extended-bindings))
                                 ,fsetter-method)
                               obj
                               val
                               ,field-index
                               ,type-expression
                               ,fsetter-name)))))
                    `())))
          (##append getter-def
                    (##append setter-def
                              (##append fsetter-def
                                        tail)))))

      (define (generate-structure-type-definition)
        `(##define ,type-expression
           ((##let ()
              (##declare (extended-bindings))
              ##structure)
            ##type-type
            ((##let ()
               (##declare (extended-bindings))
               ##string->uninterned-symbol)
             ,augmented-id-str)
            ',name
            ',(##type-flags type-static)
            ,super-type-dynamic-expr
            ',(##type-fields type-static))))

      (define (generate-constructor-copier-predicate-getters-setters)
        `(,@(if type-exhibitor
                (if macros?
                    `((##define-macro (,type-exhibitor)
                        ',type-expression))
                    `((##define (,type-exhibitor)
                        ,type-expression)))
                '())

          ,@(if constructor
                (let ((constructor-name
                       (if (##pair? constructor)
                           (##car constructor)
                           constructor)))
                  (if macros?
                      `((##define-macro (,constructor-name ,@parameters)
                          (##list '(##let ()
                                     (##declare (extended-bindings))
                                     ##structure)
                                  ',type-expression
                                  ,@(generate-initializations
                                     field-alist
                                     parameters
                                     #t))))
                      `((##define (,constructor-name ,@parameters)
                          (##declare (extended-bindings))
                          (##structure
                           ,type-expression
                           ,@(generate-initializations
                              field-alist
                              parameters
                              #f))))))
                '())

          ,@(if constant-constructor
                `((##define-macro (,constant-constructor ,@parameters)
                    (##define-type-construct-constant
                      ',constant-constructor
                      ,type-expression
                      ,@(generate-initializations
                         field-alist
                         parameters
                         #t))))
                '())

          ,@(if copier
                (if macros?
                    `((##define-macro (,copier obj)
                        (##list '(##let ()
                                   (##declare (extended-bindings))
                                   ##structure-copy)
                                obj)))
                    `((##define (,copier obj)
                        (##declare (extended-bindings))
                        (##structure-copy obj))))
                '())

          ,@(if predicate
                (if macros?
                    `((##define-macro (,predicate obj)
                        ,(if extender
                             ``(##let ((obj ,,'obj))
                                 (##declare (extended-bindings))
                                 (##and (##structure? obj)
                                        (##let ((t0 (##structure-type obj))
                                                (type-id ,',type-id-expression))
                                          (##or (##eq? (##type-id t0) type-id)
                                                (##let ((t1 (##type-super t0)))
                                                  (##and t1
                                                         (##or (##eq? (##type-id t1) type-id)
                                                               (##structure-instance-of? obj type-id))))))))
                             ``((##let ()
                                  (##declare (extended-bindings))
                                  ##structure-direct-instance-of?)
                                ,,'obj
                                ,',type-id-expression))))
                    `((##define (,predicate obj)
                        (##declare (extended-bindings))
                        ,(if extender
                             `(##structure-instance-of?
                               obj
                               ,type-id-expression)
                             `(##structure-direct-instance-of?
                               obj
                               ,type-id-expression)))))
                '())

          ,@(let loop ((lst1 (##reverse fields))
                       (lst2 '()))
              (if (##pair? lst1)
                  (loop (##cdr lst1)
                        (generate-getter-and-setter (##car lst1) lst2))
                  lst2))))

      (define (generate-definitions)
        (if generative?
            (##cons (generate-structure-type-definition)
                    (generate-constructor-copier-predicate-getters-setters))
            (generate-constructor-copier-predicate-getters-setters)))

      `(##begin

         ,@(if extender
               (##list `(##define-macro (,extender . args)
                          (##define-type-expand
                            ',extender
                            ',type-static
                            ',type-expression
                            args)))
               '())

         ,@(if implementer
               (if macros?
                   (##cons `(##define-macro (,implementer)
                              ',(if generative?
                                    (generate-structure-type-definition)
                                    '(##begin)))
                           (generate-constructor-copier-predicate-getters-setters))
                   (##list `(##define-macro (,implementer)
                              ',(##cons '##begin
                                        (generate-definitions)))))
               (generate-definitions)))))

  (let ((expansion
         (##define-type-parser
           form-name
           super-type-static
           args
           generate)))
    (if ##define-type-expansion-show?
        (pp expansion ##stdout-port))
    expansion))

(define ##define-type-expansion-show? #f)

(define-prim (##define-type-expansion-show?-set! x)
  (set! ##define-type-expansion-show? x))

(define-prim (##define-type-parser
               form-name
               super-type-static
               args
               cont)

  (define (err)
    (##ill-formed-special-form form-name args))

  (define (parse-attributes name rest)
    (let loop1 ((lst rest)
                (field-index (##type-field-count super-type-static))
                (options 0)
                (flags '())
                (rev-fields '()))

      (define allowed-field-options
        '((printable:     . (-2 . 0))
          (unprintable:   . (-2 . 1))
          (read-write:    . (-3 . 0))
          (read-only:     . (-3 . 2))
          (equality-test: . (-5 . 0))
          (equality-skip: . (-5 . 4))
          (functional-setter:    . (-17 . 0))
          (no-functional-setter: . (-17 . 16))))

      (define (update-options options opt)
        (let* ((x (##cdr opt))
               (m (##car x))
               (b (##cdr x)))
          (##fxior (##fxand options m) b)))

      (define (parse-field-attributes
               field-name
               getter
               setter
               fsetter
               local-options
               rest)
        (let loop2 ((lst2 rest)
                    (local-options local-options)
                    (attributes '()))
          (cond ((##pair? lst2)
                 (let ((attribute (##car lst2)))
                   (cond ((##assq attribute
                                  '((init: . (-9 . 8))))
                          =>
                          (lambda (opt)
                            (let ((rest (##cdr lst2)))
                              (if (and (##pair? rest)
                                       (##not (##assq attribute attributes)))
                                  (let ((val (##car rest)))
                                    (if (##constant-expression? val)
                                        (loop2 (##cdr rest)
                                               (update-options local-options opt)
                                               (##cons (##cons attribute val)
                                                       attributes))
                                        (err)))
                                  (err)))))
                         ((##assq attribute
                                  allowed-field-options)
                          =>
                          (lambda (opt)
                            (loop2 (##cdr lst2)
                                   (update-options local-options opt)
                                   attributes)))
                         (else
                          (err)))))
                ((##null? lst2)
                 (let ((read-only?
                        (##not
                         (##fx= (##fxand local-options 2)
                                0)))
                       (functional-setter?
                        (##fx= (##fxand local-options 16)
                               0)))
                   (if (or (and (##symbol? setter)
                                read-only?)
                           (and (##symbol? fsetter)
                                (##not functional-setter?)))
                       (err)
                       (loop1 (##cdr lst)
                              (##fx+ field-index 1)
                              options
                              flags
                              (##cons (##cons field-name
                                              (##vector
                                               field-name
                                               (##fx+ field-index 1)
                                               getter
                                               (if read-only? #f setter)
                                               (if functional-setter? fsetter #f)
                                               local-options
                                               attributes))
                                      rev-fields)))))
                (else
                 (err)))))

      (cond ((##pair? lst)
             (let ((next (##car lst)))
               (cond ((##symbol? next)
                      (if (##not (##assq next rev-fields))
                          (parse-field-attributes
                           next
                           #t
                           #t
                           #t
                           options
                           '())
                          (err)))
                     ((##pair? next)
                      (let* ((field-name (##car next))
                             (rest (##cdr next)))
                        (if (and (##symbol? field-name)
                                 (##not (##assq field-name rev-fields)))
                            (if (##pair? rest)
                                (let ((getter (##car rest)))
                                  (if (##symbol? getter)
                                      (let ((rest (##cdr rest))
                                            (opts (##fxior options 18)))
                                        (if (##pair? rest)
                                            (let ((setter (##car rest)))
                                              (if (or (##symbol? setter)
                                                      (##not setter))
                                                  (let ((rest (##cdr rest))
                                                        (opts (if setter
                                                                  (##fxand opts -3)
                                                                  opts)))
                                                    (if (##pair? rest)
                                                        (let ((fsetter (##car rest)))
                                                          (if (or (##symbol? fsetter)
                                                                  (##not fsetter))
                                                              (parse-field-attributes
                                                               field-name
                                                               getter
                                                               setter
                                                               fsetter
                                                               (if fsetter
                                                                   (##fxand opts -17)
                                                                   opts)
                                                               (##cdr rest))
                                                              (parse-field-attributes
                                                               field-name
                                                               getter
                                                               setter
                                                               #f
                                                               opts
                                                               rest)))
                                                        (parse-field-attributes
                                                         field-name
                                                         getter
                                                         setter
                                                         #f
                                                         opts
                                                         rest)))
                                                  (parse-field-attributes
                                                   field-name
                                                   getter
                                                   #f
                                                   #f
                                                   opts
                                                   rest)))
                                            (parse-field-attributes
                                             field-name
                                             getter
                                             #f
                                             #f
                                             opts
                                             rest)))
                                      (parse-field-attributes
                                       field-name
                                       #t
                                       #t
                                       #t
                                       options
                                       rest)))
                                (parse-field-attributes
                                 field-name
                                 #t
                                 #t
                                 #t
                                 options
                                 rest))
                            (err))))
                     ((##member next
                                '(id:
                                  constructor:
                                  constant-constructor:
                                  copier:
                                  predicate:
                                  extender:
                                  implementer:
                                  type-exhibitor:
                                  prefix:))
                      (let ((rest (##cdr lst)))
                        (if (and (##pair? rest)
                                 (##not (##assq next flags)))
                            (let ((val (##car rest)))
                              (if (cond ((##eq? next 'constructor:)
                                         (if (##pair? val)
                                             (if (##symbol? (##car val))
                                                 (let loop ((lst1 (##cdr val))
                                                            (lst2 '()))
                                                   (if (##pair? lst1)
                                                       (let ((x (##car lst1)))
                                                         (if (and (##symbol? x)
                                                                  (##not (##member
                                                                          x
                                                                          lst2)))
                                                             (loop (##cdr lst1)
                                                                   (##cons x lst2))
                                                             #f))
                                                       (##null? lst1)))
                                                 #f)
                                             (or (##not val)
                                                 (##symbol? val))))
                                        (else
                                         (or (##symbol? val)
                                             (and (##memq
                                                   next
                                                   '(copier:
                                                     predicate:
                                                     constant-constructor:))
                                                  (##not val)))))
                                  (loop1 (##cdr rest)
                                         field-index
                                         options
                                         (##cons (##cons next val) flags)
                                         rev-fields)
                                  (err)))
                            (err))))
                     ((##member next
                                '(opaque:
                                  macros:))
                      (if (##not (##assq next flags))
                          (loop1 (##cdr lst)
                                 field-index
                                 options
                                 (##cons (##cons next #t) flags)
                                 rev-fields)
                          (err)))
                     ((##assq next
                              allowed-field-options)
                      =>
                      (lambda (opt)
                        (loop1 (##cdr lst)
                               field-index
                               (update-options options opt)
                               flags
                               rev-fields)))
                     (else
                      (err)))))
            ((##null? lst)
             (let* ((fields
                     (##reverse rev-fields))
                    (prefix
                     (cond ((##assq 'prefix: flags)
                            =>
                            ##cdr)
                           (else
                            '||)))
                    (id
                     (cond ((##assq 'id: flags)
                            =>
                            ##cdr)
                           (else
                            #f)))
                    (extender
                     (cond ((##assq 'extender: flags)
                            =>
                            ##cdr)
                           (else
                            #f)))
                    (constructor
                     (cond ((##assq 'constructor: flags)
                            =>
                            (lambda (x)
                              (let ((constructor (##cdr x)))
                                (if (##pair? constructor)
                                    (##for-each (lambda (sym)
                                                  (if (##not (##assq sym fields))
                                                      (err)))
                                                (##cdr constructor)))
                                constructor)))
                           (else
                            (##symbol-append prefix
                                             'make-
                                             name))))
                    (constant-constructor
                     (cond ((##assq 'constant-constructor: flags)
                            =>
                            ##cdr)
                           ((or (##not constructor)
                                (##not id))
                            #f)
                           (else
                            (##symbol-append prefix
                                             'make-constant-
                                             name))))
                    (copier
                     (cond ((##assq 'copier: flags)
                            =>
                            ##cdr)
                           ((##not constructor)
                            #f)
                           (else
                            (##symbol-append prefix
                                             name
                                             '-copy)))) ;; should be a prefix
                    (predicate
                     (cond ((##assq 'predicate: flags)
                            =>
                            ##cdr)
                           (else
                            (##symbol-append prefix
                                             name
                                             '?))))
                    (implementer
                     (cond ((##assq 'implementer: flags)
                            =>
                            ##cdr)
                           (else
                            #f)))
                    (type-exhibitor
                     (cond ((##assq 'type-exhibitor: flags)
                            =>
                            ##cdr)
                           (else
                            #f))))
               (if (or (and constant-constructor
                            (or (##not constructor)
                                (##not id)))
                       (and id
                            super-type-static
                            (##fx=
                             (##fxand
                              (##type-flags super-type-static)
                              16)
                             0)))
                   (err)
                   (cont
                    name
                    (##fx+ (if (or (##assq 'opaque: flags)
                                   (and super-type-static
                                        (##not
                                         (##fx=
                                          (##fxand
                                           (##type-flags super-type-static)
                                           1)
                                          0))))
                               1
                               0)
                           (if extender 2 0)
                           (if (##assq 'macros: flags) 4 0)
                           (if constructor 8 0)
                           (if id 16 0))
                    id
                    extender
                    constructor
                    constant-constructor
                    copier
                    predicate
                    implementer
                    type-exhibitor
                    prefix
                    fields
                    field-index))))
            (else
             (err)))))

  (if (##pair? args)
      (let* ((name (##car args))
             (rest (##cdr args)))
        (if (##symbol? name)
            (parse-attributes name rest)
            (err)))
      (err)))

(define-prim (##define-type-construct-constant form-name type . fields)
  (let loop ((lst1 fields)
             (lst2 '()))
    (if (##pair? lst1)
        (let ((field (##car lst1)))
          (if (##constant-expression? field)
              (loop (##cdr lst1)
                    (##cons (##constant-expression-value field)
                            lst2))
              (##ill-formed-special-form form-name fields)))
        `',(##apply ##structure
                    (##cons type (##reverse lst2))))))

(define-prim (##ill-formed-special-form form-name args) ;; TODO: deprecate
  (##raise-expression-parsing-exception
   'ill-formed-special-form
   (##sourcify
    (##cons form-name args)
    (##make-source #f #f))))

(define-prim (##constant-expression? expr)
  (or (##self-eval? expr)
      (and (##pair? expr)
           (##eq? (##car expr) 'quote)
           (let ((rest (##cdr expr)))
             (and (##pair? rest)
                  (##null? (##cdr rest)))))))

(define-prim (##constant-expression-value expr)
  (if (##self-eval? expr)
      expr
      (##cadr expr)))

(define-prim (##symbol-append . symbols)
  (##string->symbol
   (##apply ##string-append
            (##map ##symbol->string symbols))))

(define-runtime-macro (##define-type . args)
  (##define-type-expand 'define-type #f #f args))

(define-runtime-macro (##define-structure . args)
  (##define-type-expand 'define-structure #f #f args))

(define-runtime-macro (##define-record-type name constructor predicate . fields)
  `(##define-type ,name
     constructor: ,constructor
     copier: #f
     predicate: ,predicate
     no-functional-setter:
     ,@fields))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-macro (##define-type-of-thread . args)
  (##define-type-expand
    'define-type-of-thread
    (macro-type-thread)
    (##list 'quote (macro-type-thread))
    args))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (gc-report-set! report?);;;;;;;;;;;;;;;;;;;;;;
  (##gc-report-set! report?))

(define ##gc-report? #f)

(define-prim (##gc-report-set! report?)
  (##declare (not interrupts-enabled))
  (set! ##gc-report? (if report? #t #f)))

(define-prim (##display-gc-report)
  (if (let* ((settings
              (##set-debug-settings! 0 0))
             (level
              (macro-debug-settings-level settings)))
        (or (##fx>= level 5)
            ##gc-report?))
      (let* ((stats
              (##process-statistics))
             (last-gc-real-time
              (##f64vector-ref stats 14))
             (last-gc-heap-size
              (##f64vector-ref stats 15))
             (last-gc-alloc
              (##f64vector-ref stats 16))
             (last-gc-live
              (##f64vector-ref stats 17))
             (last-gc-movable
              (##f64vector-ref stats 18))
             (last-gc-nonmovable
              (##f64vector-ref stats 19))
             (output-port
              (##repl-output-port)))

        (define (scale x m)
          (##flonum->exact-int (##flround (##fl* x m))))

        (define (show x*1000 unit)

          (define (decimals d)
            (let* ((n (##round (##/ x*1000 (##expt 10 (##fx- 3 d)))))
                   (n-str (##number->string n 10))
                   (n-str-len (##string-length n-str))
                   (str (if (##fx< n-str-len d)
                            (##string-append
                             (##make-string (##fx- d n-str-len) #\0)
                             n-str)
                            n-str))
                   (len (##string-length str))
                   (split (##fx- len d)))
              (##write-string
               (if (##fx= d 0)
                   str
                   (##string-append (##substring str 0 split)
                                    "."
                                    (##substring str split len)))
               output-port)
              (##write-string unit output-port)))

          (cond ((##< x*1000 10000)
                 (decimals 1))
                (else
                 (decimals 0))))

        (define (tim secs)
          (let ((us (scale secs 1.0e9)))
            (if (##< us 1000000)
                (show us "us")
                (let ((ms (scale secs 1.0e6)))
                  (if (##< ms 1000000)
                      (show ms "ms")
                      (let ((s (scale secs 1.0e3)))
                        (show s "s")))))))

        (define (mem bytes suffix)
          (let ((k (scale bytes 9.765625e-1)))
            (if (##< k 1024000)
                (show k "K")
                (let ((m (scale bytes 9.5367431640625e-4)))
                  (if (##< m 1024000)
                      (show m "M")
                      (let ((g (scale bytes 9.313225746154785e-7)))
                        (show g "G"))))))
          (##write-string suffix output-port))

        (##write-string "*** GC: " output-port)
        (tim last-gc-real-time)
        (##write-string ", " output-port)
        (mem last-gc-alloc " alloc, ")
        (mem last-gc-heap-size " heap, ")
        (mem last-gc-live " live (")
        (##write (scale (##fl/ last-gc-live last-gc-heap-size) 100.0) output-port)
        (##write-string "% " output-port)
        (##write (##flonum->exact-int last-gc-movable) output-port)
        (##write-string "+" output-port)
        (##write (##flonum->exact-int last-gc-nonmovable) output-port)
        (##write-string ")" output-port)
        (##newline output-port)
        #t)))

(##add-gc-interrupt-job! ##display-gc-report)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##identity x)
  x)

(define-prim (identity x)
  x)

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##void))

(define-prim (void)
  (##void))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##absent-object)
  (macro-absent-obj))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (process-times)
  (##process-times))

(define-prim (cpu-time)
  (let ((v (##process-times)))
    (##+ (##f64vector-ref v 0) (##f64vector-ref v 1))))

(define-prim (real-time)
  (let ((v (##process-times)))
    (##f64vector-ref v 2)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define ##gensym-counter -1)

(define-prim (##gensym #!optional (p (macro-absent-obj)))
  (let ((prefix
         (if (##eq? p (macro-absent-obj))
             'g
             p)))
    (macro-check-symbol prefix 1 (gensym p)
      (let ((new-count
             (##fxmodulo
              (##fx+ ##gensym-counter 1)
              1000000)))
        ;; Note: it is unimportant if the increment of ##gensym-counter
        ;; is not atomic; it simply means a possible close repetition
        ;; of the same name
        (set! ##gensym-counter new-count)
        (##string->uninterned-symbol
         (if (##eq? prefix 'g)
             new-count ;; ##symbol->string will create the string
             (##string-append (##symbol->string prefix)
                              (##number->string new-count 10))))))))

(define-prim (gensym #!optional (p (macro-absent-obj)))
  (macro-force-vars (p)
    (##gensym p)))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(##define-macro (macro-will-size) 3)

(define-prim (##will? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-weak))
       (##fx= (##vector-length obj) (macro-will-size))))

(define-prim (will? x)
  (macro-force-vars (x)
    (##will? x)))

(define-prim (##make-will testator action)
  (macro-make-will testator action))

(define-prim (make-will testator action)
  (macro-force-vars (action)
    (macro-check-procedure action 2 (make-will testator action)
      (macro-make-will testator action))))

(define-prim (##will-testator will)
  (macro-will-testator will))

(define-prim (will-testator will)
  (macro-force-vars (will)
    (macro-check-will will 1 (will-testator will)
      (macro-will-testator will))))

(define-prim (##will-testator-set! will testator)
  (macro-will-testator-set! will testator))

(define-prim (##will-action will)
  (macro-will-action will))

(define-prim (##will-action-set! will action)
  (macro-will-action-set! will action))

(define-prim (##will-execute! will)
  (macro-will-execute! will))

(define-prim (will-execute! will)
  (macro-force-vars (will)
    (macro-check-will will 1 (will-execute! will)
      (macro-will-execute! will))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (##box? obj)
  (and (##subtyped? obj)
       (##eq? (##subtype obj) (macro-subtype-boxvalues))
       (##fx= (##vector-length obj) 1)))

(define-prim (box? obj)
  (macro-force-vars (obj)
    (##box? obj)))

(define-prim (##box obj)
  (##subtype-set! (##vector obj) (macro-subtype-boxvalues)))

(define-prim (box obj)
  (##box obj))

(define-prim (##unbox box)
  (##vector-ref box 0))

(define-prim (unbox box)
  (macro-force-vars (box)
    (macro-check-box box 1 (unbox box)
      (##unbox box))))

(define-prim (##set-box! box val)
  (##vector-set! box 0 val))

(define-prim (set-box! box val)
  (macro-force-vars (box)
    (macro-check-box box 1 (set-box! box val)
      (begin
        (##set-box! box val)
        (##void)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(##include "~~lib/gambit/env-vars/env-vars.scm")
(##include "~~lib/gambit/process/process.scm")

;;;----------------------------------------------------------------------------

;;; Implementation of file-info objects.

(implement-library-type-file-info)

(define-prim (##file-info? obj)
  (macro-file-info? obj))

(define-prim (##file-info-type info)
  (macro-file-info-type info))

(define-prim (##file-info-device info)
  (macro-file-info-device info))

(define-prim (##file-info-inode info)
  (macro-file-info-inode info))

(define-prim (##file-info-mode info)
  (macro-file-info-mode info))

(define-prim (##file-info-number-of-links info)
  (macro-file-info-number-of-links info))

(define-prim (##file-info-owner info)
  (macro-file-info-owner info))

(define-prim (##file-info-group info)
  (macro-file-info-group info))

(define-prim (##file-info-size info)
  (macro-file-info-size info))

(define-prim (##file-info-last-access-time info)
  (macro-file-info-last-access-time info))

(define-prim (##file-info-last-modification-time info)
  (macro-file-info-last-modification-time info))

(define-prim (##file-info-last-change-time info)
  (macro-file-info-last-change-time info))

(define-prim (##file-info-attributes info)
  (macro-file-info-attributes info))

(define-prim (##file-info-creation-time info)
  (macro-file-info-creation-time info))

(define-prim (##file-info-aux
              path
              #!optional
              (chase? (macro-absent-obj)))
  (##file-info-resolved-path (##path-resolve path) chase?))

(define-prim (##file-info-resolved-path
              resolved-path
              #!optional
              (chase? (macro-absent-obj)))
  (let* ((fi
          (macro-make-file-info ;; will be initialized by ##os-file-info
           0  ;; type
           0  ;; device
           0  ;; inode
           0  ;; mode
           0  ;; number-of-links
           0  ;; owner
           0  ;; group
           0  ;; size
           (macro-inexact--inf) ;; last-access-time
           (macro-inexact--inf) ;; last-modification-time
           (macro-inexact--inf) ;; last-change-time
           0  ;; attributes
           (macro-inexact--inf)));; creation-time
         (result
          (##os-file-info fi
                          resolved-path
                          (if (##eq? chase? (macro-absent-obj))
                              #t
                              chase?))))

    (define (convert-time t)
      (macro-make-time t #f #f #f))

    (if (##fixnum? result)
        result
        (begin
          (let ((type
                 (case (macro-file-info-type result)
                   ((1)  'regular)
                   ((2)  'directory)
                   ((3)  'character-special)
                   ((4)  'block-special)
                   ((5)  'fifo)
                   ((6)  'symbolic-link)
                   ((7)  'socket)
                   (else 'unknown))))
            (##unchecked-structure-set!
             result
             type
             1
             (macro-type-file-info)
             #f))

          (##unchecked-structure-set!
           result
           (convert-time (macro-file-info-last-access-time result))
           9
           (macro-type-file-info)
           #f)

          (##unchecked-structure-set!
           result
           (convert-time (macro-file-info-last-modification-time result))
           10
           (macro-type-file-info)
           #f)

          (##unchecked-structure-set!
           result
           (convert-time (macro-file-info-last-change-time result))
           11
           (macro-type-file-info)
           #f)

          (##unchecked-structure-set!
           result
           (convert-time (macro-file-info-creation-time result))
           13
           (macro-type-file-info)
           #f)

          result))))

(define-prim (##file-info
              path
              #!optional
              (chase? #t)
              (raise-os-exception? #t))
  (let ((info (##file-info-aux path chase?)))
    (if (##fixnum? info)
        (and raise-os-exception?
             (##raise-os-exception #f info file-info path chase? raise-os-exception?))
        info)))

(define-prim (file-info
              path
              #!optional
              (chase? (macro-absent-obj))
              (raise-os-exception? (macro-absent-obj)))
  (macro-force-vars (path chase? raise-os-exception?)
    (macro-check-string path 1 (file-info path chase? raise-os-exception?)
      (##file-info path chase? raise-os-exception?))))

(define-prim (file-type path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-type path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-type path)
            (macro-file-info-type info))))))

(define-prim (file-device path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-device path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-device path)
            (macro-file-info-device info))))))

(define-prim (file-inode path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-inode path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-inode path)
            (macro-file-info-inode info))))))

(define-prim (file-mode path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-mode path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-mode path)
            (macro-file-info-mode info))))))

(define-prim (file-number-of-links path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-number-of-links path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-number-of-links path)
            (macro-file-info-number-of-links info))))))

(define-prim (file-owner path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-owner path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-owner path)
            (macro-file-info-owner info))))))

(define-prim (file-group path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-group path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-group path)
            (macro-file-info-group info))))))

(define-prim (file-size path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-size path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-size path)
            (macro-file-info-size info))))))

(define-prim (file-last-access-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-last-access-time path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-last-access-time path)
            (macro-file-info-last-access-time info))))))

(define-prim (file-last-modification-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-last-modification-time path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-last-modification-time path)
            (macro-file-info-last-modification-time info))))))

(define-prim (file-last-change-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-last-change-time path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-last-change-time path)
            (macro-file-info-last-change-time info))))))

(define-prim (file-attributes path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-attributes path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-attributes path)
            (macro-file-info-attributes info))))))

(define-prim (file-creation-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-creation-time path)
      (let ((info (##file-info-aux path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-creation-time path)
            (macro-file-info-creation-time info))))))

(define-prim (##file-last-access-and-modification-times-set!
              path
              #!optional
              (a-absrel-timeout (macro-absent-obj))
              (m-absrel-timeout (macro-absent-obj)))

  (define (change a m)
    (let* ((a-time
            (##timeout->time a))
           (m-time
            (if m (##timeout->time m) a-time))
           (resolved-path
            (##path-resolve path))
           (code
            (##os-file-times-set!
             resolved-path
             (macro-time-point a-time)
             (macro-time-point m-time))))
      (if (##fx< code 0)
          (##raise-os-exception #f code file-last-access-and-modification-times-set! path a-absrel-timeout m-absrel-timeout)
          (##void))))

  (macro-check-string path
    1
    (file-last-access-and-modification-times-set! path a-absrel-timeout m-absrel-timeout)
    (if (##eq? a-absrel-timeout (macro-absent-obj))
        (change 0 #f)
        (macro-check-absrel-time
          a-absrel-timeout
          2
          (file-last-access-and-modification-times-set! path a-absrel-timeout m-absrel-timeout)
          (if (##eq? m-absrel-timeout (macro-absent-obj))
              (change a-absrel-timeout #f)
              (macro-check-absrel-time
                m-absrel-timeout
                3
                (file-last-access-and-modification-times-set! path a-absrel-timeout m-absrel-timeout)
                (change a-absrel-timeout m-absrel-timeout)))))))

(define-prim (file-last-access-and-modification-times-set!
              path
              #!optional
              (a-absrel-timeout (macro-absent-obj))
              (m-absrel-timeout (macro-absent-obj)))
  (macro-force-vars (path a-absrel-timeout m-absrel-timeout)
    (##file-last-access-and-modification-times-set!
     path
     a-absrel-timeout
     m-absrel-timeout)))

;;;----------------------------------------------------------------------------

(define-prim (##file-exists?
              path
              #!optional
              (chase? (macro-absent-obj)))
  (let ((result
         (##file-info-aux path
                          (if (##eq? chase? (macro-absent-obj))
                              #t
                              chase?))))
    (##not (##fixnum? result))))

(define-prim (file-exists?
              path
              #!optional
              (chase? (macro-absent-obj)))
  (macro-force-vars (path chase?)
    (macro-check-string path 1 (file-exists? path chase?)
      (##file-exists? path chase?))))

;;;----------------------------------------------------------------------------

(define-prim&proc (read-file-string path-or-settings)
  (##open-file-generic
   (macro-direction-in)
   #t ;; raise-os-exception?
   (lambda (port resolved-path)
     (let ((result (##read-line port #f)))
       (close-port port)
       result))
   (standard read-file-string)
   path-or-settings))

(define-prim&proc (read-file-string-list path-or-settings)
  (##open-file-generic
   (macro-direction-in)
   #t ;; raise-os-exception?
   (lambda (port resolved-path)
     (let loop ((lst '()))
       (let ((line (##read-line port)))
         (if (string? line)
             (loop (cons line lst))
             (begin
               (close-port port)
               (reverse lst))))))
   (standard read-file-string-list)
   path-or-settings))

(define-prim&proc (read-file-u8vector path-or-settings)
  (##open-file-generic
   (macro-direction-in)
   #t ;; raise-os-exception?
   (lambda (port resolved-path)
     (let ((info (##file-info-resolved-path resolved-path)))
       (if (fixnum? info)
           (##raise-os-exception #f info (standard read-file-u8vector) path-or-settings)
           (let* ((size (macro-file-info-size info))
                  (size+1 (fx+ size 1))
                  (u8vect (make-u8vector size+1))
                  (n (if (fx= size 0)
                         0
                         (read-subu8vector u8vect 0 size+1 port))))
             (if (fx< n size+1) ;; file did not grow since file-info called?
                 (begin
                   (u8vector-shrink! u8vect n)
                   (close-port port)
                   u8vect)
                 (let loop ((chunks (list u8vect)))
                   (define chunk-size 4096)
                   (let* ((new-chunk (make-u8vector chunk-size))
                          (n (read-subu8vector new-chunk 0 chunk-size port))
                          (new-chunks (cons new-chunk chunks)))
                     (u8vector-shrink! new-chunk n)
                     (if (fx< n chunk-size)
                         (begin
                           (close-port port)
                           (u8vector-concatenate (reverse new-chunks)))
                         (loop new-chunks)))))))))
   (standard read-file-u8vector)
   path-or-settings))

(define-prim&proc (write-file-string path-or-settings
                                     (string string))
  (##open-file-generic
   (macro-direction-out)
   #t ;; raise-os-exception?
   (lambda (port resolved-path)
     (##write-substring string 0 (string-length string) port)
     (close-port port)
     (void))
   (standard write-file-string)
   path-or-settings
   string))

(define-prim&proc (write-file-string-list path-or-settings
                                          (string-list proper-list))
  (##open-file-generic
   (macro-direction-out)
   #t ;; raise-os-exception?
   (lambda (port resolved-path)
     (let loop ((lst string-list))
       (macro-force-vars (lst)
         (if (pair? lst)
             (let ((string (car lst)))
               (macro-force-vars (string)
                 (if (string? string)
                     (begin
                       (##write-substring string 0 (string-length string) port)
                       (newline port)
                       (loop (cdr lst)))
                     (begin
                       (close-port port)
                       (##fail-check-string-list '(2 . string-list) (standard write-file-string-list) path-or-settings string-list)))))
             (begin
               (close-port port)
               (macro-check-proper-list-null* lst string-list '(2 . string-list) (write-file-string-list path-or-settings string-list)
                 (void)))))))
   (standard write-file-string-list)
   path-or-settings
   string-list))

(define-prim&proc (write-file-u8vector path-or-settings
                                       (u8vector u8vector))
  (##open-file-generic
   (macro-direction-out)
   #t ;; raise-os-exception?
   (lambda (port resolved-path)
     (##write-subu8vector u8vector 0 (u8vector-length u8vector) port)
     (close-port port)
     (void))
   (standard write-file-u8vector)
   path-or-settings
   u8vector))

;;;----------------------------------------------------------------------------

;;; Implementation of user-info objects.

(implement-library-type-user-info)

(define-prim (##user-info
              user
              #!optional
              (raise-os-exception? #t))
  (let* ((ui (macro-make-user-info #f #f #f #f #f))
         (result (##os-user-info ui user)))
    (if (##fixnum? result)
        (if raise-os-exception?
            (##raise-os-exception #f result user-info user)
            result)
        result)))

(define-prim (user-info user)
  (macro-force-vars (user)
    (macro-check-string-or-nonnegative-fixnum user 1 (user-info user)
      (##user-info user))))

(define-prim (##user-name)
  (let ((result (##os-user-name)))
    (if (##fixnum? result)
        (##raise-os-exception #f result user-name)
        result)))

(define-prim (user-name)
  (##user-name))

;;;----------------------------------------------------------------------------

;;; Implementation of group-info objects.

(implement-library-type-group-info)

(define-prim (##group-info group)
  (let* ((gi (macro-make-group-info #f #f #f))
         (result (##os-group-info gi group)))
    (if (##fixnum? result)
        (##raise-os-exception #f result group-info group)
        result)))

(define-prim (group-info group)
  (macro-force-vars (group)
    (macro-check-string-or-nonnegative-fixnum group 1 (group-info group)
      (##group-info group))))

;;;----------------------------------------------------------------------------

;;; Pathname operations.

(define (##uri-scheme-prefix-end str start end)

  ;; Parses the string str between the indexes start and end, and checks
  ;; that it is a valid URI scheme followed by :// .  The procedure
  ;; returns the index after the second slash, otherwise it returns #f.

  (let loop ((i start))
    (and (##fx< i end)
         (let ((c (##string-ref str i)))
           (cond ((or (and (##char<=? #\a c)
                           (##char<=? c #\z))
                      (and (##char<=? #\A c)
                           (##char<=? c #\Z))
                      (and (##fx> i start)
                           (or (and (##char<=? #\0 c)
                                    (##char<=? c #\9))
                               (##char=? c #\+)
                               (##char=? c #\-)
                               (##char=? c #\.))))
                  (loop (##fx+ i 1)))
                 ((##char=? c #\:)
                  (and (##fx< (##fx+ i 2) end)
                       (##char=? (##string-ref str (##fx+ i 1)) #\/)
                       (##char=? (##string-ref str (##fx+ i 2)) #\/)
                       (##fx+ i 3)))
                 (else
                  #f))))))

(define (##uri-scheme-prefixed? path)
  (macro-case-target
   ((js)
    (##uri-scheme-prefix-end path 0 (##string-length path)))
   (else
    #f)))

(define-prim (##path-volume-end-using-dir-sep path directory-separator)
  (if (##uri-scheme-prefixed? path)
      0
      (cond #; ;; old Mac paths are deprecated
            ((##char=? #\: directory-separator)
             (let loop1 ((i 0))
               (if (##fx< i (##string-length path))
                   (let ((c (##string-ref path i)))
                     (if (##char=? #\: c)
                         i
                         (loop1 (##fx+ i 1))))
                   0)))
            ((##char=? #\\ directory-separator)
             (if (##fx= 0 (##string-length path))
                 0
                 (let ((c (##string-ref path 0)))
                   (cond ((or (and (##char<=? #\a c)
                                   (##char<=? c #\z))
                              (and (##char<=? #\A c)
                                   (##char<=? c #\Z)))
                          (if (and (##fx< 1 (##string-length path))
                                   (##char=? #\: (##string-ref path 1)))
                              2
                              0))
                         ((or (##char=? #\\ c)
                              (##char=? #\/ c))
                          (if (and (##fx< 1 (##string-length path))
                                   (let ((c (##string-ref path 1)))
                                     (or (##char=? #\\ c)
                                         (##char=? #\/ c))))
                              (let loop2 ((i 2))
                                (if (##fx< i (##string-length path))
                                    (let ((c (##string-ref path i)))
                                      (if (or (##char=? #\\ c)
                                              (##char=? #\/ c))
                                          i
                                          (loop2 (##fx+ i 1))))
                                    0))
                              0))
                         (else
                          0)))))
            (else
             0))))

(define ##path-resolve-hook #f)

(define-prim (##path-resolve-hook-set! x)
  (set! ##path-resolve-hook x))

(define-prim (##path-resolve path)
  (let ((pr-hook ##path-resolve-hook))
    (if (##procedure? pr-hook)
        (let ((result
               (pr-hook path)))
          (if (##string? result)
              result
              (##raise-error-exception
               "STRING result expected but got"
               (##list result))))
        (##default-path-resolve path))))

(define-prim (##default-path-resolve path)
  (##path-expand path))

(define ##path-unresolve-hook #f)

(define-prim (##path-unresolve-hook-set! x)
  (set! ##path-unresolve-hook x))

(define-prim (##path-unresolve path)
  (let ((pu-hook ##path-unresolve-hook))
    (if (##procedure? pu-hook)
        (let ((result
               (pu-hook path)))
          (if (##string? result)
              result
              (##raise-error-exception
               "STRING result expected but got"
               (##list result))))
        (##default-path-unresolve path))))

(define-prim (##default-path-unresolve path)
  path)

(define ##path-expand-hook #f)

(define-prim (##path-expand-hook-set! x)
  (set! ##path-expand-hook x))

(define-prim (##path-expand
              path
              #!optional
              (origin (macro-absent-obj)))
  (let ((pe-hook ##path-expand-hook))
    (if (##procedure? pe-hook)
        (let ((result
               (if (##eq? origin (macro-absent-obj))
                   (pe-hook path)
                   (pe-hook path origin))))
          (if (##string? result)
              result
              (##raise-error-exception
               "STRING result expected but got"
               (##list result))))
        (if (##eq? origin (macro-absent-obj))
            (##default-path-expand path)
            (##default-path-expand path origin)))))

(define-prim (##default-path-expand
              path
              #!optional
              (origin (macro-absent-obj)))
  (if (##uri-scheme-prefixed? path)
      path
      (let* ((cd
              (##current-directory))
             (directory-separator
              (if (or (##fx= 0 (##string-length cd))
                      (##uri-scheme-prefixed? cd))
                  #\/
                  (##string-ref cd (##fx- (##string-length cd) 1)))))

        (define (expand p orig)

          (define (relative dir-sep?)
            (let* ((dir
                    (if (##not orig)
                        cd
                        (let* ((d orig) ;; (expand orig #f)
                               (len (##string-length d)))
                          (if (or (##fx= len 0)
                                  (##char=? (##string-ref d
                                                          (##fx- len 1))
                                            directory-separator))
                              d
                              (##string-append
                               d
                               (##string directory-separator))))))
                   (len
                    (if dir-sep?
                        (if #f
                            #; ;; old Mac paths are deprecated
                            (##char=? #\: directory-separator)
                            (##fx- (##string-length dir) 1)
                            (##path-volume-end-using-dir-sep
                             dir
                             directory-separator))
                        (##string-length dir))))
              (if (##fx= len 0)
                  p
                  (let ((result
                         (##make-string
                          (##fx+ len (##string-length p)))))
                    (##substring-move! dir 0 len result 0)
                    (##substring-move! p 0 (##string-length p) result len)
                    result))))

          (define (absolute vol-end dir-sep?)
            (if dir-sep?
                p
                (let ((result
                       (##make-string (##fx+ 1 (##string-length p)))))
                  (##substring-move! p 0 vol-end result 0)
                  (##string-set! result vol-end directory-separator)
                  (##substring-move! p vol-end (##string-length p) result (##fx+ vol-end 1))
                  result)))

          (define (tilde-end)
            (if (##fx= 0 (##string-length p))
                0
                (if (##char=? #\~ (##string-ref p 0))
                    (let loop ((i 1))
                      (if (##fx< i (##string-length p))
                          (let ((c (##string-ref p i)))
                            (cond ((or (##char=? c directory-separator)
                                       (##char=? c #\/))
                                   i)
                                  (else
                                   (loop (##fx+ i 1)))))
                          i))
                    0)))

          (define (prepend-directory dir start)
            (if (##fixnum? dir)
                (##raise-os-exception #f dir path-expand path origin)
                (let* ((dir-len
                        (##string-length dir))
                       (ends-with-dir-sep?
                        (and (##fx< 0 dir-len)
                             (##char=? directory-separator
                                       (##string-ref dir (##fx- dir-len 1)))))
                       (dir-end
                        (if ends-with-dir-sep? (##fx- dir-len 1) dir-len))
                       (rest-len
                        (##fx- (##string-length p)
                               start))
                       (len
                        (##fx+ dir-end
                               1 ;; for directory separator
                               (if (##fx< 0 rest-len)
                                   (##fx- rest-len 1)
                                   0)))
                       (result
                        (##make-string len)))
                  (##substring-move! dir 0 dir-end result 0)
                  (##substring-move! p start (##string-length p) result dir-end)
                  (##string-set! result dir-end directory-separator)
                  (expand result orig))))

          (define (err code)
            (##raise-os-exception #f code path-expand path origin))

          (define (expand-in-instdir relpath instdir-name)
            (let ((dir (##os-path-gambitdir-map-lookup instdir-name)))
              (cond ((##fixnum? dir)
                     (err dir))
                    (dir
                     (let ((expanded-dir
                            (##path-expand-in-initial-current-directory dir)))
                       (expand relpath
                               expanded-dir)))
                    ((##string=? instdir-name "execdir")
                     (let ((exec-path (##os-executable-path)))
                       (if (##fixnum? exec-path)
                           (err exec-path)
                           (expand relpath
                                   (##path-directory exec-path)))))
                    (else
                     (let ((dir (##os-path-gambitdir)))
                       (if (##fixnum? dir)
                           (err dir)
                           (let ((expanded-dir
                                  (##path-expand-in-initial-current-directory dir)))
                             (expand relpath
                                     (if (##fx= 0 (##string-length instdir-name))
                                         expanded-dir
                                         (expand instdir-name
                                                 expanded-dir))))))))))

          (let ((t-end (tilde-end)))
            (if (##fx< 0 t-end)

                (cond ((##fx= 1 t-end)
                       (let ((homedir (##os-path-homedir)))
                         (cond ((##fixnum? homedir)
                                (err homedir))
                               (homedir
                                (prepend-directory homedir t-end))
                               (else
                                (expand "~~" #f)))))
                      ((##char=? #\~ (##string-ref p 1))
                       (let* ((len
                               (##string-length p))
                              (instdir-name
                               (##substring p 2 t-end))
                              (relpath
                               (##substring p
                                            (if (##fx= t-end len)
                                                t-end
                                                (##fx+ t-end 1))
                                            len)))
                         (expand-in-instdir
                          relpath
                          instdir-name)))
                      (else
                       (let ((info (##user-info (##substring p 1 t-end) #f)))
                         (prepend-directory
                          (if (##fixnum? info)
                              info
                              (macro-user-info-home info))
                          t-end))))

                (let* ((vol-end
                        (##path-volume-end-using-dir-sep p directory-separator))
                       (dir-sep?
                        (and (##fx< vol-end (##string-length p))
                             (let ((c (##string-ref p vol-end)))
                               (or (##char=? c directory-separator)
                                   (##char=? c #\/))))))
                  (if (##fx= vol-end 0)
                      (relative dir-sep?)
                      (absolute vol-end dir-sep?))))))

        (expand path (if (##eq? origin (macro-absent-obj)) #f origin)))))

(define-prim (##path-expand-in-initial-current-directory path)
  (##path-expand path (##initial-current-directory)))

(define-prim (path-expand
              path
              #!optional
              (origin (macro-absent-obj)))
  (macro-force-vars (path origin)
    (macro-check-string path 1 (path-expand path origin)
      (if (##eq? origin (macro-absent-obj))
          (##path-expand path)
          (macro-check-string origin 2 (path-expand path origin)
            (##path-expand path origin))))))

(define-prim (##path-join parts path)
  (if (##pair? parts)
      (##path-join (##cdr parts)
                   (##path-expand (##car parts) path))
      path))

(define-prim (##path-join-reversed rparts path)
  (if (##pair? rparts)
      (##path-expand (##car rparts)
                     (##path-join-reversed (##cdr rparts)
                                           path))
      path))

(define-prim (##path-normalize
              path
              #!optional
              (allow-relative? (macro-absent-obj))
              (origin (macro-absent-obj))
              (raise-os-exception? (macro-absent-obj)))

  (define (normalize path)
    (let ((dir
           (##os-path-normalize-directory path)))
      (if (##fixnum? dir)
          (let ((parent-dir
                 (##os-path-normalize-directory (##path-directory path))))
            (if (##fixnum? parent-dir)
                parent-dir
                (##string-append parent-dir (##path-strip-directory path))))
          dir)))

  (if (##uri-scheme-prefixed? path)
      path
      (let* ((cd
              (##current-directory))
             (directory-separator
              (##string-ref cd (##fx- (##string-length cd) 1)))
             (dir
              (if (or (##not origin) (##eq? origin (macro-absent-obj)))
                  cd
                  (normalize (##path-expand origin cd))))
             (p
              (normalize (##path-expand path dir))))
        (if (##fixnum? p)
            (if raise-os-exception?
                (##raise-os-exception
                 #f
                 p
                 path-normalize
                 path
                 allow-relative?
                 origin
                 raise-os-exception?)
                p)
            (if (or (##eq? allow-relative? (macro-absent-obj))
                    (##not allow-relative?))
                p
                (let* ((first-diff
                        (let loop1 ((i 0))
                          (if (and (##fx< i (##string-length dir))
                                   (##fx< i (##string-length p))
                                   (##char=? (##string-ref dir i)
                                             (##string-ref p i)))
                              (loop1 (##fx+ i 1))
                              i)))
                       (vol-end
                        (##path-volume-end-using-dir-sep dir directory-separator)))
                  (if (##fx< first-diff vol-end)
                      p
                      (let* ((common-dir-end
                              (let loop2 ((i (##fx- first-diff 1)))
                                (if (##fx< i vol-end)
                                    0
                                    (let ((c (##string-ref dir i)))
                                      (if (or (##char=? c directory-separator)
                                              (##char=? c #\/))
                                          (##fx+ i 1)
                                          (loop2 (##fx- i 1)))))))
                             (nb-hops
                              (let loop3 ((i first-diff) (nb-hops 0))
                                (if (##fx< i (##string-length dir))
                                    (loop3 (##fx+ i 1)
                                           (let ((c (##string-ref dir i)))
                                             (if (or (##char=? c directory-separator)
                                                     (##char=? c #\/))
                                                 (##fx+ nb-hops 1)
                                                 nb-hops)))
                                    (if #f
                                        #; ;; old Mac paths are deprecated
                                        (and (##char=? #\: directory-separator)
                                             (or (##fx< 0 nb-hops)
                                                 (let loop4 ((i first-diff))
                                                   (if (##fx<
                                                        i
                                                        (##string-length p))
                                                       (if (##char=?
                                                            #\:
                                                            (##string-ref p i))
                                                           #t
                                                           (loop4 (##fx+ i 1)))
                                                       #f))))
                                        (##fx+ nb-hops 1)
                                        nb-hops))))
                             (hop
                              (cond
                               #; ;; old Mac paths are deprecated
                               ((##char=? #\: directory-separator)
                                ":")
                               ((##char=? #\\ directory-separator)
                                "..\\")
                               (else
                                "../")))
                             (hop-len
                              (##fx* (##string-length hop) nb-hops))
                             (length-reduction
                              (##fx- common-dir-end hop-len)))

                        (if (and (##fx< length-reduction (##string-length p))
                                 (or (##not (##eq? allow-relative? 'shortest))
                                     (##fx< 0 length-reduction)))
                            (let ((result
                                   (##make-string
                                    (##fx- (##string-length p)
                                           length-reduction))))
                              (##substring-move!
                               p
                               common-dir-end
                               (##string-length p)
                               result
                               hop-len)
                              (let loop5 ((i (##fx- nb-hops 1)))
                                (if (##fx< i 0)
                                    result
                                    (begin
                                      (##substring-move!
                                       hop
                                       0
                                       (##string-length hop)
                                       result
                                       (##fx* i (##string-length hop)))
                                      (loop5 (##fx- i 1))))))
                            p)))))))))

(define-prim (path-normalize
              path
              #!optional
              (allow-relative? (macro-absent-obj))
              (origin (macro-absent-obj))
              (raise-os-exception? (macro-absent-obj)))
  (macro-force-vars (path allow-relative? origin raise-os-exception?)
    (macro-check-string path 1 (path-normalize path allow-relative? origin)
      (if (##eq? allow-relative? (macro-absent-obj))
          (##path-normalize path)
          (if (##eq? origin (macro-absent-obj))
              (##path-normalize path allow-relative?)
              (macro-check-string origin 2 (path-normalize path allow-relative? origin)
                (if (##eq? raise-os-exception? (macro-absent-obj))
                    (##path-normalize path allow-relative? origin)
                    (##path-normalize path allow-relative? origin raise-os-exception?))))))))

(define-prim (##path-extension-start path)
  (let* ((directory-separator
          (if (##uri-scheme-prefixed? path)
              #\/
              (let ((cd (##current-directory)))
                (##string-ref cd (##fx- (##string-length cd) 1)))))
         (vol-end
          (##path-volume-end-using-dir-sep path directory-separator)))
    (let loop ((i (##fx- (##string-length path) 1)))
      (if (##fx< vol-end i)
          (let ((c (##string-ref path (##fx- i 1))))
            (cond ((or (##char=? c directory-separator)
                       (##char=? c #\/))
                   (##string-length path))
                  ((##char=? (##string-ref path i) #\.)
                   i)
                  (else
                   (loop (##fx- i 1)))))
          (##string-length path)))))

(define-prim (##path-extension path)
  (##substring path (##path-extension-start path) (##string-length path)))

(define-prim (path-extension path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-extension path)
      (##path-extension path))))

(define-prim (##path-strip-extension path)
  (##substring path 0 (##path-extension-start path)))

(define-prim (path-strip-extension path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-strip-extension path)
      (##path-strip-extension path))))

(define-prim (##path-directory-end path)
  (let* ((directory-separator
          (if (##uri-scheme-prefixed? path)
              #\/
              (let ((cd (##current-directory)))
                (##string-ref cd (##fx- (##string-length cd) 1)))))
         (vol-end
          (##path-volume-end-using-dir-sep path directory-separator)))
    (let loop ((i (##fx- (##string-length path) 1)))
      (if (##fx< i vol-end)
          vol-end
          (let ((c (##string-ref path i)))
            (cond ((or (##char=? c directory-separator)
                       (##char=? c #\/))
                   (##fx+ i 1))
                  (else
                   (loop (##fx- i 1)))))))))

(define-prim (##path-directory path)
  (##substring path 0 (##path-directory-end path)))

(define-prim (path-directory path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-directory path)
      (##path-directory path))))

(define-prim (##path-strip-directory path)
  (##substring path (##path-directory-end path) (##string-length path)))

(define-prim (path-strip-directory path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-strip-directory path)
      (##path-strip-directory path))))

(define-prim (##path-strip-trailing-directory-separator path)
  (let* ((directory-separator
          (if (##uri-scheme-prefixed? path)
              #\/
              (let ((cd (##current-directory)))
                (##string-ref cd (##fx- (##string-length cd) 1)))))
         (len
          (##string-length path)))
    (if (and (##fx< 0 len)
             (let ((c (##string-ref path (##fx- len 1))))
               (or (##char=? c directory-separator)
                   (##char=? c #\/))))
        (##substring path 0 (##fx- len 1))
        path)))

(define-prim (path-strip-trailing-directory-separator path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-strip-trailing-directory-separator path)
      (##path-strip-trailing-directory-separator path))))

(define-prim (##path-volume-end path)
  (let* ((directory-separator
          (if (##uri-scheme-prefixed? path)
              #\/
              (let ((cd (##current-directory)))
                (##string-ref cd (##fx- (##string-length cd) 1)))))
         (vol-end
          (##path-volume-end-using-dir-sep path directory-separator)))
    vol-end))

(define-prim (##path-volume path)
  (##substring path 0 (##path-volume-end path)))

(define-prim (path-volume path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-volume path)
      (##path-volume path))))

(define-prim (##path-strip-volume path)
  (##substring path (##path-volume-end path) (##string-length path)))

(define-prim (path-strip-volume path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-strip-volume path)
      (##path-strip-volume path))))

;;;----------------------------------------------------------------------------

(define-prim (##executable-path)
  (let ((path (##os-executable-path)))
    (if (##fixnum? path)
        (##raise-os-exception
         #f
         path
         executable-path)
        (##path-normalize path))))

(define-prim (executable-path)
  (##executable-path))

;;;----------------------------------------------------------------------------

;;; Filesystem operations.

(define-prim (##create-temporary-directory
              #!optional
              (path-or-settings (macro-absent-obj))
              (raise-os-exception? (macro-absent-obj)))

  (define (fail)
    (##fail-check-string-or-settings 1 create-temporary-directory path-or-settings))

  (##make-psettings
   (macro-direction-inout)
   '(path:
     permissions:)
   (cond ((##eq? path-or-settings (macro-absent-obj))
          '())
         ((##string? path-or-settings)
          (##list 'path: path-or-settings))
         (else
          path-or-settings))
   fail
   (lambda (psettings)
     (let ((path
            (macro-psettings-path psettings)))
       (if (##not (or (##not path) (##string? path)))
           (fail)
           (let* ((prefix
                   (or path
                       (##path-expand
                        (##string-append
                         (##path-strip-directory (##executable-path))
                         "-temp")
                        (##os-path-tempdir))))
                  (pid
                   (##os-getpid))
                  (permissions
                   (##psettings->permissions psettings #o777)))
             (let loop ((i 0))
               (let* ((resolved-path
                       (##path-resolve
                        (##string-append prefix
                                         (##number->string pid)
                                         (if (##fx= i 0)
                                             ""
                                             (##number->string i)))))
                      (code
                       (##os-create-directory resolved-path permissions)))
                 (if (##fx< code 0)
                     (if (##fx= code ##err-code-EEXIST)
                         (loop (##fx- i 1))
                         (if raise-os-exception?
                             (##raise-os-exception #f code create-temporary-directory path-or-settings)
                             code))
                     resolved-path)))))))))

(define-prim (create-temporary-directory
              #!optional
              (path-or-settings (macro-absent-obj)))
  (macro-force-vars (path-or-settings)
    (##create-temporary-directory path-or-settings)))

(define-prim (##create-directory-or-fifo
              prim
              path-or-settings
              #!optional
              (raise-os-exception? (macro-absent-obj)))

  (define (fail)
    (##fail-check-string-or-settings 1 prim path-or-settings))

  (##make-psettings
   (macro-direction-inout)
   '(path:
     permissions:)
   (cond ((##string? path-or-settings)
          (##list 'path: path-or-settings))
         (else
          path-or-settings))
   fail
   (lambda (psettings)
     (let ((path
            (macro-psettings-path psettings)))
       (if (##not (##string? path))
           (fail)
           (let* ((resolved-path
                   (##path-resolve path))
                  (permissions
                   (##psettings->permissions
                    psettings
                    (if (##eq? prim create-directory)
                        #o777
                        #o666)))
                  (code
                   (if (##eq? prim create-directory)
                       (##os-create-directory resolved-path permissions)
                       (##os-create-fifo resolved-path permissions))))
             (if (##fx< code 0)
                 (if raise-os-exception?
                     (##raise-os-exception #f code prim path-or-settings)
                     code)
                 (##void))))))))

(define-prim (##create-directory
              path-or-settings
              #!optional
              (raise-os-exception? (macro-absent-obj)))
  (##create-directory-or-fifo
   create-directory
   path-or-settings
   raise-os-exception?))

(define-prim (create-directory path-or-settings)
  (macro-force-vars (path-or-settings)
    (##create-directory path-or-settings)))

(define-prim (##create-fifo
              path-or-settings
              #!optional
              (raise-os-exception? #t))
  (##create-directory-or-fifo
   create-fifo
   path-or-settings
   raise-os-exception?))

(define-prim (create-fifo path-or-settings)
  (macro-force-vars (path-or-settings)
    (##create-fifo path-or-settings)))

(define-prim (##create-link
              old-path
              new-path
              #!optional
              (raise-os-exception? #t))
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-create-link resolved-old-path resolved-new-path)))
    (if (##fx< code 0)
        (if raise-os-exception?
            (##raise-os-exception #f code create-link old-path new-path)
            code)
        (##void))))

(define-prim (create-link old-path new-path)
  (macro-force-vars (old-path new-path)
    (macro-check-string old-path 1 (create-link old-path new-path)
      (macro-check-string new-path 2 (create-link old-path new-path)
        (##create-link old-path new-path)))))

(define-prim (##create-symbolic-link
              old-path
              new-path
              #!optional
              (raise-os-exception? #t))
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-create-symbolic-link resolved-old-path resolved-new-path)))
    (if (##fx< code 0)
        (if raise-os-exception?
            (##raise-os-exception #f code create-symbolic-link old-path new-path)
            code)
        (##void))))

(define-prim (create-symbolic-link old-path new-path)
  (macro-force-vars (old-path new-path)
    (macro-check-string old-path 1 (create-symbolic-link old-path new-path)
      (macro-check-string new-path 2 (create-symbolic-link old-path new-path)
        (##create-symbolic-link old-path new-path)))))

(define-prim (##delete-directory
              path
              #!optional
              (raise-os-exception? #t))
  (let* ((resolved-path
          (##path-resolve path))
         (code
          (##os-delete-directory resolved-path)))
    (if (##fx< code 0)
        (if raise-os-exception?
            (##raise-os-exception
             #f
             code
             delete-directory
             path)
            code)
        (##void))))

(define-prim (delete-directory path)
  (macro-force-vars (path)
    (macro-check-string path 1 (delete-directory path)
      (##delete-directory path))))

(define-prim (##rename-file
              old-path
              new-path
              #!optional
              (replace? (macro-absent-obj))
              (raise-os-exception? #t))
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-rename-file
           resolved-old-path
           resolved-new-path
           (##not (##eq? replace? #f))))) ;; default is replace? = #t
    (if (##fx< code 0)
        (if raise-os-exception?
            (##raise-os-exception
             #f
             code
             rename-file
             old-path
             new-path
             replace?)
            code)
        (##void))))

(define-prim (rename-file
              old-path
              new-path
              #!optional
              (replace? (macro-absent-obj)))
  (macro-force-vars (old-path new-path replace?)
    (macro-check-string old-path 1 (rename-file old-path new-path replace?)
      (macro-check-string new-path 2 (rename-file old-path new-path replace?)
        (##rename-file old-path new-path replace?)))))

(define-prim (##copy-file
              old-path
              new-path
              #!optional
              (raise-os-exception? #t))
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-copy-file
           resolved-old-path
           resolved-new-path)))
    (if (##fx< code 0)
        (if raise-os-exception?
            (##raise-os-exception
             #f
             code
             copy-file
             old-path
             new-path)
            code)
        (##void))))

(define-prim (copy-file old-path new-path)
  (macro-force-vars (old-path new-path)
    (macro-check-string old-path 1 (copy-file old-path new-path)
      (macro-check-string new-path 2 (copy-file old-path new-path)
        (##copy-file old-path new-path)))))

(define-prim (##delete-file
              path
              #!optional
              (raise-os-exception? #t))
  (let* ((resolved-path
          (##path-resolve path))
         (code
          (##os-delete-file resolved-path)))
    (if (##fx< code 0)
        (if raise-os-exception?
            (##raise-os-exception
             #f
             code
             delete-file
             path)
            code)
        (##void))))

(define-prim (delete-file path)
  (macro-force-vars (path)
    (macro-check-string path 1 (delete-file path)
      (##delete-file path))))

(define-prim (##delete-file-or-directory
              path
              #!optional
              (recursive? (macro-absent-obj))
              (raise-os-exception? #t))
  (let ((rec? (if (##eq? recursive? (macro-absent-obj)) #f recursive?)))

    (define (del-dir-content dir-path)
      (##open-directory-aux
       #f
       (lambda (dir-port)
         (if (##fixnum? dir-port)
             dir-port
             (let loop ()
               (let ((filename (##read dir-port)))
                 (if (##eof-object? filename)
                     (begin
                       (##close-port dir-port)
                       #f)
                     (if (or (##string=? filename ".")
                             (##string=? filename ".."))
                         ;; it should never be the case that filename is
                         ;; "." or ".." because of the use of the option
                         ;; ignore-hidden: 'dot-and-dot-dot
                         ;; but we double check anyway because it would
                         ;; be very bad to recurse on "." and ".." if
                         ;; there was a bug in ##open-directory-aux
                         (loop)
                         (let ((result (del (##path-expand filename dir-path))))
                           (if result
                               (begin
                                 (##close-port dir-port)
                                 result)
                               (loop)))))))))
       open-directory
       (##list path: dir-path
               ignore-hidden: 'dot-and-dot-dot)))

    (define (del path)
      (let ((info (##file-info-aux path #f)))
        (if (##fixnum? info)
            info
            (case (macro-file-info-type info)
              ((directory)
               (or (and rec?
                        (del-dir-content path))
                   (let ((result (##delete-directory path #f)))
                     (if (##fixnum? result)
                         result
                         #f))))
              (else
               (let ((result (##delete-file path #f)))
                 (if (##fixnum? result)
                     result
                     #f)))))))

    (let ((result (del path)))
      (if result
          (if raise-os-exception?
              (##raise-os-exception
               #f
               result
               delete-file-or-directory
               path
               recursive?)
              result)
          (##void)))))

(define-prim (delete-file-or-directory
              path
              #!optional
              (recursive? (macro-absent-obj)))
  (macro-force-vars (path recursive?)
    (macro-check-string path 1 (delete-file-or-directory path recursive?)
      (if (##eq? recursive? (macro-absent-obj))
          (##delete-file-or-directory path)
          (##delete-file-or-directory path recursive?)))))

(define-prim (##directory-files
              #!optional
              (path-or-settings (macro-absent-obj)))
  (##open-directory-aux
   #t
   (lambda (port)
     (let ((files (##read-all port ##read)))
       (##close-input-port port)
       files))
   directory-files
   path-or-settings))

(define-prim (directory-files
              #!optional
              (path-or-settings (macro-absent-obj)))
  (macro-force-vars (path-or-settings)
    (##directory-files path-or-settings)))

;;;----------------------------------------------------------------------------

(define (##string->c-id str #!optional (allow-upper? #t))
  (let ((len (##string-length str)))
    (if (##fx= len 0)
        "_"
        (let loop1 ((i (##fx- len 1))
                    (lst '()))
          (if (##fx>= i 0)
              (let ((c (##string-ref str i)))
                (cond ((##char=? c #\_)
                       (loop1 (##fx- i 1)
                              (##cons c (##cons c lst))))
                      ((if (##fx= i 0)
                           (##c-id-initial? c allow-upper?)
                           (##c-id-subsequent? c allow-upper?))
                       (loop1 (##fx- i 1)
                              (##cons c lst)))
                      (else
                       (let ((n (##char->integer c)))
                         (if (##fx= n 0)
                             (loop1 (##fx- i 1)
                                    (##cons #\_ (##cons #\0 (##cons #\_ lst))))
                             (let loop2 ((n n)
                                         (lst (##cons #\_ lst)))
                               (if (##fx> n 0)
                                   (loop2 (##fxarithmetic-shift-right n 4)
                                          (##cons
                                           (##string-ref "0123456789abcdef"
                                                         (##fxand n 15))
                                           lst))
                                   (loop1 (##fx- i 1)
                                          (##cons #\_ lst)))))))))
              (##list->string lst))))))

(define (##c-id? str #!optional (allow-upper? #t))
  (let ((len (##string-length str)))
    (and (##fx> len 0)
         (##c-id-initial? (##string-ref str 0) allow-upper?)
         (let loop ((i (##fx- len 1)))
           (or (##fx= i 0)
               (and (##c-id-subsequent? (##string-ref str i) allow-upper?)
                    (loop (##fx- i 1))))))))

(define (##c-id-initial? c allow-upper?) ;; c is an ASCII letter or _
  (let ((n (##char->integer c)))
    (or (and (##fx>= n 97) (##fx<= n 122))
        (##fx= n 95)
        (and allow-upper? (##fx>= n 65) (##fx<= n 90)))))

(define (##c-id-subsequent? c allow-upper?) ;; c is an ASCII letter, _ or 0..9
  (or (##c-id-initial? c allow-upper?)
      (let ((n (##char->integer c)))
        (and (##fx>= n 48) (##fx<= n 57)))))

;;;----------------------------------------------------------------------------

(define-runtime-syntax six.infix
  (lambda (src) (##deconstruct-call src 2 (lambda (expr) expr))))

(define-runtime-macro (six.!x x)
  `(not ,x))

(define-runtime-macro (six.notx x)
  `(not ,x))

(define-runtime-macro (six.++x x)
  (##infix-update-in-place 'six.++x x 'six.x+y 1 #t))

(define-runtime-macro (six.x++ x)
  (##infix-update-in-place 'six.x++ x 'six.x+y 1 #f))

(define-runtime-macro (six.--x x)
  (##infix-update-in-place 'six.--x x 'six.x-y 1 #t))

(define-runtime-macro (six.x-- x)
  (##infix-update-in-place 'six.x-- x 'six.x-y 1 #f))

(define-runtime-macro (six.~x x)
  `(bitwise-not ,x))

(define-runtime-macro (six.x%y x y)
  `(modulo ,x ,y))

(define-runtime-macro (six.x**y x y)
  `(expt ,x ,y))

(define-runtime-macro (six.x*y x y)
  `(* ,x ,y))

(define-runtime-macro (six.x@y x y)
  `(@ ,x ,y))

(define-runtime-macro (six.*x x)
  (##infix-lvalue-fetch (##list 'six.*x x)))

(define-runtime-macro (six.x//y x y)
  `(floor-quotient ,x ,y))

(define-runtime-macro (six.x/y x y)
  `(/ ,x ,y))

(define-runtime-macro (six.x+y x y)
  `(+ ,x ,y))

(define-runtime-macro (six.+x x)
  `(+ ,x))

(define-runtime-macro (six.x-y x y)
  `(- ,x ,y))

(define-runtime-macro (six.-x x)
  `(- ,x))

(define-runtime-macro (six.x<<y x y)
  `(arithmetic-shift ,x ,y))

(define-runtime-macro (six.x>>y x y)
  `(arithmetic-shift ,x (- ,y)))

(define-runtime-macro (six.x>>>y x y)
  `(bitwise-and 4294967295 (arithmetic-shift ,x (- ,y))))

(define-runtime-macro (six.x<y x y)
  `(< ,x ,y))

(define-runtime-macro (six.x<=y x y)
  `(<= ,x ,y))

(define-runtime-macro (six.x>y x y)
  `(> ,x ,y))

(define-runtime-macro (six.x>=y x y)
  `(>= ,x ,y))

(define-runtime-macro (six.x!=y x y)
  `(not (equal? ,x ,y)))

(define-runtime-macro (six.x==y x y)
  `(equal? ,x ,y))

(define-runtime-macro (six.x!==y x y)
  `(not (eq? ,x ,y)))

(define-runtime-macro (six.x===y x y)
  `(eq? ,x ,y))

(define-runtime-macro (six.xisy x y)
  `(eq? ,x ,y))

(define-runtime-macro (six.xiny x y)
  `(member ,x ,y))

(define-runtime-macro (six.x&y x y)
  `(bitwise-and ,x ,y))

(define-prim (##infix-id x)
  (cond ((##symbol? x)
         x)
        ((##pair? x)
         (let* ((first (##car x))
                (rest (##cdr x)))
           (if (and (##eq? first 'six.identifier)
                    (##pair? rest))
               (let* ((second (##car rest))
                      (rest (##cdr rest)))
                 (if (and (##symbol? second)
                          (##null? rest))
                     second
                     #f))
               #f)))
        (else
         #f)))

(define-runtime-macro (six.&x x)
  (##infix-lvalue-access
   'six.&x
   (##list x)
   x
   (lambda (prepare fetch only-fetch store only-store)
     (let* ((set (##gensym))
            (val (##gensym)))
       (prepare
        `(lambda ,set
           (if (##pair? ,set)
               (let ((,val (##car ,set)))
                 ,(store val)
                 ,val)
               ,(fetch))))))))

(define-prim (##infix-lvalue-access form-name args x cont)

  (define (err)
    (##ill-formed-special-form form-name args))

  (cond ((##symbol? x)
         (let ((var (##gensym)))
           (cont (lambda (body)
                   body)
                 (lambda ()
                   x)
                 (lambda ()
                   x)
                 (lambda (val)
                   `(set! ,x ,val))
                 (lambda (val)
                   `(set! ,x ,val)))))
        ((##pair? x)
         (let* ((first (##car x))
                (rest (##cdr x)))
           (if (##pair? rest)
               (let* ((second (##car rest))
                      (rest (##cdr rest)))
                 (cond ((##pair? rest)
                        (let* ((third (##car rest))
                               (rest (##cdr rest)))
                          (cond ((##not (##null? rest))
                                 (err))
                                ((##eq? first 'six.index)
                                 (let* ((vect (##gensym))
                                        (index (##gensym)))
                                   (cont (lambda (body)
                                           `(let ((,vect ,second) (,index ,third))
                                              ,body))
                                         (lambda ()
                                           `(vector-ref ,vect ,index))
                                         (lambda ()
                                           `(vector-ref ,second ,third))
                                         (lambda (val)
                                           `(vector-set! ,vect ,index ,val))
                                         (lambda (val)
                                           `(vector-set! ,second ,third ,val)))))
                                ((and (or (##eq? first 'six.arrow)
                                          (##eq? first 'six.dot))
                                      (##infix-id third))
                                 =>
                                 (lambda (id)
                                   (let* ((struct (##gensym))
                                          (mutator
                                           (##string->symbol
                                            (##string-append
                                             (##symbol->string id)
                                             "-set!"))))
                                     (cont (lambda (body)
                                             `(let ((,struct ,second))
                                                ,body))
                                           (lambda ()
                                             `(,id ,struct))
                                           (lambda ()
                                             `(,id ,second))
                                           (lambda (val)
                                             `(,mutator ,struct ,val))
                                           (lambda (val)
                                             `(,mutator ,second ,val))))))
                                (else
                                 (err)))))
                       ((##null? rest)
                        (cond ((##eq? first 'six.*x)
                               (let ((ptr (##gensym)))
                                 (cont (lambda (body)
                                         `(let ((,ptr ,second))
                                            ,body))
                                       (lambda ()
                                         `(,ptr))
                                       (lambda ()
                                         `(,second))
                                       (lambda (val)
                                         `(,ptr ,val))
                                       (lambda (val)
                                         `(,second ,val)))))
                              ((and (##eq? first 'six.identifier)
                                    (##symbol? second))
                               (let ((var (##gensym)))
                                 (cont (lambda (body)
                                         body)
                                       (lambda ()
                                         second)
                                       (lambda ()
                                         second)
                                       (lambda (val)
                                         `(set! ,second ,val))
                                       (lambda (val)
                                         `(set! ,second ,val)))))
                              (else
                               (err))))
                       (else
                        (err))))
               (err))))
        (else
         (err))))

(define-prim (##infix-lvalue-fetch form)
  (##infix-lvalue-access
   (##car form)
   (##cdr form)
   form
   (lambda (prepare fetch only-fetch store only-store)
     (only-fetch))))

(define-prim (##infix-update-in-place form-name x operator operand2 pre?)
  (##infix-lvalue-access
   form-name
   (if (##eq? operand2 1)
       (##list x)
       (##list x operand2))
   x
   (lambda (prepare fetch only-fetch store only-store)
     (let ((val (##gensym)))
       (prepare
        (if pre?
            `(let ((,val (,operator ,(fetch) ,operand2)))
               ,(store val)
               ,val)
            `(let ((,val ,(fetch)))
               ,(store `(,operator ,val ,operand2))
               ,val)))))))

(define-runtime-macro (six.x^y x y)
  `(bitwise-xor ,x ,y))

(define-runtime-macro (|six.x\|y| x y)
  `(bitwise-ior ,x ,y))

(define-runtime-macro (six.x&&y x y)
  `(and ,x ,y))

(define-runtime-macro (six.xandy x y)
  `(and ,x ,y))

(define-runtime-macro (|six.x\|\|y| x y)
  `(or ,x ,y))

(define-runtime-macro (six.xory x y)
  `(or ,x ,y))

(define-runtime-macro (six.x?y:z x y z)
  `(if ,x ,y ,z))

(define-runtime-macro (six.x:y x y)
  `(cons ,x ,y))

(define-runtime-macro (six.x%=y x y)
  (##infix-update-in-place 'six.x%=y x 'six.x%y y #t))

(define-runtime-macro (six.x&=y x y)
  (##infix-update-in-place 'six.x&=y x 'six.x&y y #t))

(define-runtime-macro (six.x**=y x y)
  (##infix-update-in-place 'six.x**=y x 'six.x**y y #t))

(define-runtime-macro (six.x*=y x y)
  (##infix-update-in-place 'six.x*=y x 'six.x*y y #t))

(define-runtime-macro (six.x@=y x y)
  (##infix-update-in-place 'six.x@=y x 'six.x@y y #t))

(define-runtime-macro (six.x+=y x y)
  (##infix-update-in-place 'six.x+=y x 'six.x+y y #t))

(define-runtime-macro (six.x-=y x y)
  (##infix-update-in-place 'six.x-=y x 'six.x-y y #t))

(define-runtime-macro (six.x//=y x y)
  (##infix-update-in-place 'six.x//=y x 'six.x//y y #t))

(define-runtime-macro (six.x/=y x y)
  (##infix-update-in-place 'six.x/=y x 'six.x/y y #t))

(define-runtime-macro (six.x<<=y x y)
  (##infix-update-in-place 'six.x<<=y x 'six.x<<y y #t))

(define-runtime-macro (six.x=y x y)
  (##infix-lvalue-access
   'six.x=y
   (##list x y)
   x
   (lambda (prepare fetch only-fetch store only-store)
     (let ((val (##gensym)))
       (prepare
        `(let ((,val ,y))
           ,(store val)
           ,val))))))

(define-runtime-macro (six.x>>=y x y)
  (##infix-update-in-place 'six.x>>=y x 'six.x>>y y #t))

(define-runtime-macro (six.x>>>=y x y)
  (##infix-update-in-place 'six.x>>>=y x 'six.x>>>y y #t))

(define-runtime-macro (six.x^=y x y)
  (##infix-update-in-place 'six.x^=y x 'six.x^y y #t))

(define-runtime-macro (|six.x\|=y| x y)
  (##infix-update-in-place '|six.x\|=y| x '|six.x\|y| y #t))

(define-runtime-macro (six.x:=y x y)
  (##infix-lvalue-access
   'six.x:=y
   (##list x y)
   x
   (lambda (prepare fetch only-fetch store only-store)
     (let ((val (##gensym)))
       (prepare
        `(let ((,val ,y))
           ,(store val)
           ,val))))))

(define-runtime-macro (|six.x,y| x y)
  `(begin ,x ,y))

(define-runtime-macro (six.cons expr1 expr2)
  `(cons ,expr1 ,expr2))

(define-runtime-macro (six.list expr1 expr2)
  `(cons ,expr1 ,expr2))

(define-runtime-macro (six.null)
  `'())

(define-runtime-macro (six.new identifier . args)
  (cond ((##infix-id identifier)
         =>
         (lambda (id)
           `(,(##string->symbol
               (##string-append "make-"
                                (##symbol->string id)))
             ,@args)))
        (else
         (##ill-formed-special-form 'six.new (##cons identifier args)))))

(define-runtime-macro (six.call func . args)
  `(,func ,@args))

(define-runtime-macro (six.index expr1 expr2)
  (##infix-lvalue-fetch (##list 'six.index expr1 expr2)))

(define-runtime-macro (six.arrow expr identifier)
  (##infix-lvalue-fetch (##list 'six.arrow expr identifier)))

(define-runtime-macro (six.dot expr identifier)
  (##infix-lvalue-fetch (##list 'six.dot expr identifier)))

(define-runtime-macro (six.literal value)
  `',value)

(define-runtime-macro (six.identifier identifier)
  (##infix-lvalue-fetch (##list 'six.identifier identifier)))

(define-runtime-macro (six.if expr stat1 . stat2)
  `(if ,expr ,stat1 ,@stat2))

(define-runtime-macro (six.while expr stat)
  (let ((loop (gensym)))
    `(let ,loop () (if ,expr (begin ,stat (,loop))))))

(define-runtime-macro (six.do-while stat expr)
  (let ((loop (gensym)))
    `(let ,loop () (begin ,stat (if ,expr (,loop))))))

(define-runtime-macro (six.for stat1 expr2 expr3 stat2)
  (if (and (##pair? stat1)
           (##null? (##cdr stat1))
           (##eq? (##car stat1) 'six.compound))
      (let* ((loop (gensym))
             (body `(begin ,stat2 ,@(if expr3 `(,expr3) '()) (,loop))))
        `(let ,loop ()
              ,(if expr2
                   `(if ,expr2 ,body)
                   body)))
      `(six.compound
        ,stat1
        (six.for (six.compound) ,expr2 ,expr3 ,stat2))))

(define-runtime-macro (six.compound . stats)
  (##infix-compound-expand 'six.compound stats))

(define-runtime-macro (six.procedure-body . stats)
  (##infix-compound-expand 'six.procedure-body stats))

(define-prim (##infix-compound-expand form-name stats)

  (define (expand lst1 lst2 first?)
    (cond ((##pair? lst1)
           (let ((stat (##car lst1)))
             (cond ((and (##pair? stat)
                         (##eq? (##car stat) 'six.define-procedure))
                    (expand (##cdr lst1)
                            (##cons stat lst2)
                            first?))
                   ((##not (##null? lst2))
                    `((let () ,@(##reverse lst2) ,@(expand lst1 '() #t))))
                   ((##infix-variable-binding stat)
                    =>
                    (lambda (binding)
                      `((let (,binding) ,@(expand (##cdr lst1) '() #t)))))
                   ((##null? (##cdr lst1))
                    (if (and (##eq? form-name 'six.procedure-body)
                             (##pair? stat)
                             (##eq? (##car stat) 'six.return))
                        (let ((rest (##cdr stat)))
                          (cond ((##null? rest)
                                 `((void)))
                                ((and (##pair? rest)
                                      (##null? (##cdr rest)))
                                 `(,(##car rest)))
                                (else
                                 `(,stat))))
                        `(,stat)))
                   (else
                    `(,stat ,@(expand (##cdr lst1) '() #f))))))
          (first?
           '((void)))
          (else
           '())))

  (if (##null? stats)
      `(void)
      `(begin ,@(expand stats '() #t))))

(define-runtime-macro (six.define-variable identifier type dims init)
  (cond ((##infix-variable-binding
          `(six.define-variable ,identifier ,type ,dims ,init))
         =>
         (lambda (binding)
           `(define ,@binding)))
        (else
         (##ill-formed-special-form 'six.define-variable
                                    (##list identifier
                                            type
                                            dims
                                            init)))))

(define-prim (##infix-variable-binding form)
  (if (and (##pair? form)
           (##eq? (##car form) 'six.define-variable))
      (let ((rest (##cdr form)))
        (if (##pair? rest)
            (let* ((identifier (##car rest))
                   (rest (##cdr rest)))
              (if (##pair? rest)
                  (let* ((type (##car rest))
                         (rest (##cdr rest)))
                    (if (##pair? rest)
                        (let* ((dims (##car rest))
                               (rest (##cdr rest)))
                          (if (##pair? rest)
                              (let* ((init (##car rest))
                                     (rest (##cdr rest)))
                                (cond ((and (##null? rest)
                                            (##infix-id identifier))
                                       =>
                                       (lambda (id)
                                         `(,id
                                           ,(if (##null? dims)
                                                init
                                                `(six.make-array ,init ,@dims)))))
                                      (else
                                       #f)))
                              #f))
                        #f))
                  #f))
            #f))
      #f))

(define-prim (six.make-array init . dims)
  (if (##pair? dims)

      (let loop1 ((lst dims) (i 2))
        (let ((dim1 (##car lst)))
          (macro-check-index dim1 i (six.make-array init . dims)
            (let* ((array (##make-vector dim1 init))
                   (rest (##cdr lst)))
              (if (##pair? rest)
                  (let loop2 ((j (##fx- dim1 1)))
                    (if (##fx< j 0)
                        array
                        (begin
                          (##vector-set! array j (loop1 rest (##fx+ i 1)))
                          (loop2 (##fx- j 1)))))
                  array)))))

      init))

(define-runtime-macro (six.define-procedure identifier proc)
  `(define ,(##infix-id identifier) ,proc))

(define-runtime-macro (six.procedure type params stat)
  `(lambda ,(##map (lambda (x) (##infix-id (##car x))) params)
     ,stat))

;; There is no predefined semantics for the following infix forms:
;;
;; (define-runtime-macro (six.label identifier stat)
;;   `(void))
;;
;; (define-runtime-macro (six.goto expr)
;;   `(void))
;;
;; (define-runtime-macro (six.switch expr stat)
;;   `(void))
;;
;; (define-runtime-macro (six.case expr stat)
;;   `(void))
;;
;; (define-runtime-macro (six.break)
;;   `(void))
;;
;; (define-runtime-macro (six.continue)
;;   `(void))
;;
;; (define-runtime-macro (six.return . expr)
;;   `(void))
;;
;; (define-runtime-macro (six.clause expr)
;;   `(void))
;;
;; (define-runtime-macro (six.x:-y x y)
;;   `(void))
;;
;; (define-runtime-macro (six.!)
;;   `(void))
;;
;; (define-runtime-macro (six.**x x)
;;   `(void))
;;
;; (define-runtime-macro (six.import x)
;;   `(void))
;;
;; (define-runtime-macro (six.from-import x y)
;;   `(void))
;;
;; (define-runtime-macro (six.from-import-* x)
;;   `(void))
;;
;; (define-runtime-macro (six.xinstanceofy x y)
;;   `(void))
;;
;; (define-runtime-macro (six.typeofx x)
;;   `(void))
;;
;; (define-runtime-macro (six.awaitx x)
;;   `(void))
;;
;; (define-runtime-macro (six.asyncx x)
;;   `(void))
;;
;; (define-runtime-macro (six.yieldx x)
;;   `(void))

;;;----------------------------------------------------------------------------

;;; Object encoding/decoding.

(define-prim (##object->encoding obj)
  (let* ((hi (##type-cast obj (macro-type-fixnum)))
         (lo (##type obj)))
    (##+ (##arithmetic-shift
          (if (##fx< hi 0) (##- hi ##bignum.2*min-fixnum) hi)
          2)
         lo)))

(define-prim (##encoding->object encoding)
  (let* ((hi (##arithmetic-shift encoding -2))
         (lo (##bitwise-and encoding 3))
         (x (if (##fixnum? hi) hi (##+ hi ##bignum.2*min-fixnum))))
    (##type-cast x lo)))

;;;============================================================================
