;;;============================================================================

;;; File: "_nonstd.scm"

;;; Copyright (c) 1994-2017 by Marc Feeley, All Rights Reserved.

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
        (##raise-expression-parsing-exception
         'ill-formed-special-form
         src
         (##source-strip (##car code)))
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

(define-prim (##source-strip x)
  (if (##source? x)
      (##source-code x)
      x))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-prim (error message . parameters)
  (##raise-error-exception message parameters))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax ##require-module
  (lambda (src)
    (##deconstruct-call
     src
     2
     (lambda (module-ref-src)
       (let ((module-ref (##desourcify module-ref-src)))

         (if (##not (##symbol? module-ref))
             (##raise-expression-parsing-exception
              'ill-formed-special-form
              src
              (##source-strip (##car (##source-strip src)))))

         (let* ((comp-scope
                 (##compilation-scope))
                (required-modules
                 (##table-ref comp-scope 'required-modules '())))
           (if (##pair? required-modules)
               (let loop ((lst required-modules))
                 (if (##not (##eq? (##car lst) module-ref))
                     (let ((rest (##cdr lst)))
                       (if (##pair? rest)
                           (loop rest)
                           (##set-cdr! lst (##list module-ref))))))
               (##table-set! comp-scope
                             'required-modules
                             (##list module-ref))))

         (##expand-source-template
          src
          `(##begin)))))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax parameterize
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
                         (##list '##parameterize
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

(define-runtime-syntax this-source-file
  (lambda (src)
    (let* ((locat
            (##source-locat src))
           (path
            (and locat
                 (##container->path (##locat-container locat)))))
      (if path
          (##make-source path locat)
          (##raise-expression-parsing-exception
           'unknown-location
           src)))))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax cond-expand
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

  `'(,@gambits
     srfi-0 SRFI-0
     srfi-4 SRFI-4
     srfi-6 SRFI-6
     srfi-8 SRFI-8
     srfi-9 SRFI-9
     srfi-18 SRFI-18
     srfi-21 SRFI-21
     srfi-22 SRFI-22
     srfi-23 SRFI-23
     srfi-27 SRFI-27
     srfi-30 SRFI-30
;;;     srfi-38 SRFI-38
     srfi-39 SRFI-39
     srfi-88 SRFI-88
;;;     srfi-89 SRFI-89
;;;     srfi-90 SRFI-90
;;;     srfi-91 SRFI-91
     ))

(define ##cond-expand-features
  (##make-parameter (generate-cond-expand-features)))

(define-runtime-macro (define-cond-expand-feature . features)
  (##cond-expand-features (##append features (##cond-expand-features)))
  `(begin))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-syntax receive
  (lambda (src)
    (##deconstruct-call
     src
     -4
     (lambda (formals expression . body)
       (##expand-source-template
        src
        `(##call-with-values
          (lambda () ,expression)
          (lambda ,formals ,@body)))))))

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

  (define-macro (macro-atomicity-depth-default) 32)
  (define-macro (macro-atomicity-width-default) 8192)

  (define (generate
           name
           flags
           id
           extender
           constructor
           constant-constructor
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
                    (##vector-ref descr 4))
                   (attributes
                    (##vector-ref descr 5))
                   (init
                    (cond ((##assq 'init: attributes)
                           =>
                           (lambda (x) (##constant-expression-value (##cdr x))))
                          (else
                           #f)))
                   (atomicity-width
                     (cond ((##assq 'serialization-atomicity-width: attributes)
                            => (lambda (x)
                                 (let ((val (##cdr x)))
                                     (if (and (fixnum? val)
                                              (fx>= val 0) (fx<= val 255))
                                       (fxarithmetic-shift-left val 13)
                                       (error "Invalid serialization-atomicity-width must be in 0-255")))))

                           (else (macro-atomicity-width-default))))
                   (atomicity-depth
                     (cond ((##assq 'serialization-atomicity-depth: attributes)
                            => (lambda (x)
                                 (let ((val (##cdr x)))
                                   (if (and (fixnum? val)
                                            (fx>= val 0) (fx<= val 255))
                                     (fxarithmetic-shift-left val 5)
                                     (error "Invalid serialization-atomicity-depth must be between 0-255")))))
                           (else (macro-atomicity-depth-default)))))
              (loop (##cdr lst1)
                    (##cons field-name
                            (##cons (##fxior options atomicity-width atomicity-depth)
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
                `(let ()
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
                              (##list '(let ()
                                         (##declare (extended-bindings))
                                         ,getter-method)
                                      obj
                                      ,field-index
                                      ',type-expression
                                      #f)))
                          `((define (,getter-name obj)
                              ((let ()
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
                              (##list '(let ()
                                         (##declare (extended-bindings))
                                         ,setter-method)
                                      obj
                                      val
                                      ,field-index
                                      ',type-expression
                                      #f)))
                          `((define (,setter-name obj val)
                              ((let ()
                                 (##declare (extended-bindings))
                                 ,setter-method)
                               obj
                               val
                               ,field-index
                               ,type-expression
                               ,setter-name)))))
                    `())))
          (##append getter-def (##append setter-def tail))))

      (define (generate-structure-type-definition)
        `(define ,type-expression
           ((let ()
              (##declare (extended-bindings))
              ##structure)
            ##type-type
            ((let ()
               (##declare (extended-bindings))
               ##string->uninterned-symbol)
             ,augmented-id-str)
            ',name
            ',(##type-flags type-static)
            ,super-type-dynamic-expr
            ',(##type-fields type-static))))

      (define (generate-constructor-predicate-getters-setters)
        `(,@(if type-exhibitor
                (if macros?
                    `((##define-macro (,type-exhibitor)
                        ',type-expression))
                    `((define (,type-exhibitor)
                        ,type-expression)))
                '())

          ,@(if constructor
                (let ((constructor-name
                       (if (##pair? constructor)
                           (##car constructor)
                           constructor)))
                  (if macros?
                      `((##define-macro (,constructor-name ,@parameters)
                          (##list '(let ()
                                     (##declare (extended-bindings))
                                     ##structure)
                                  ',type-expression
                                  ,@(generate-initializations
                                     field-alist
                                     parameters
                                     #t))))
                      `((define (,constructor-name ,@parameters)
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

          ,@(if predicate
                (if macros?
                    `((##define-macro (,predicate obj)
                        ,(if extender
                             ``(let ((obj ,,'obj))
                                 (##declare (extended-bindings))
                                 (and (##structure? obj)
                                      (let ((t0 (##structure-type obj))
                                            (type-id ,',type-id-expression))
                                        (or (##eq? (##type-id t0) type-id)
                                            (let ((t1 (##type-super t0)))
                                              (and t1
                                                   (or (##eq? (##type-id t1) type-id)
                                                       (##structure-instance-of? obj type-id))))))))
                             ``((let ()
                                  (##declare (extended-bindings))
                                  ##structure-direct-instance-of?)
                                ,,'obj
                                ,',type-id-expression))))
                    `((define (,predicate obj)
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
                    (generate-constructor-predicate-getters-setters))
            (generate-constructor-predicate-getters-setters)))

      `(begin

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
                                    '(begin)))
                           (generate-constructor-predicate-getters-setters))
                   (##list `(##define-macro (,implementer)
                              ',(##cons 'begin
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
          (equality-skip: . (-5 . 4))))

      (define (update-options options opt)
        (let* ((x (##cdr opt))
               (m (##car x))
               (b (##cdr x)))
          (##fxior (##fxand options m) b)))

      (define (parse-field-attributes
               field-name
               getter
               setter
               local-options
               rest)
        (let loop2 ((lst2 rest)
                    (local-options local-options)
                    (attributes '()))
          (cond ((##pair? lst2)
                 (let ((attribute (##car lst2)))
                   (cond ((##assq attribute
                                  '((init: . (-9 . 8))
                                    (serialization-atomicity-depth: . (-8161 . 0))
                                    (serialization-atomicity-width: . (-2088961 . 0))))
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
                                0))))
                   (if (and (##symbol? setter)
                            read-only?)
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
                                      (let ((rest (##cdr rest)))
                                        (if (##pair? rest)
                                            (let ((setter (##car rest)))
                                              (if (##symbol? setter)
                                                  (parse-field-attributes
                                                   field-name
                                                   getter
                                                   setter
                                                   (##fxand options -3)
                                                   (##cdr rest))
                                                  (parse-field-attributes
                                                   field-name
                                                   getter
                                                   #f
                                                   (##fxior options 2)
                                                   rest)))
                                            (parse-field-attributes
                                             field-name
                                             getter
                                             #f
                                             (##fxior options 2)
                                             rest)))
                                      (parse-field-attributes
                                       field-name
                                       #t
                                       #t
                                       options
                                       rest)))
                                (parse-field-attributes
                                 field-name
                                 #t
                                 #t
                                 options
                                 rest))
                            (err))))
                     ((##member next
                                '(id:
                                  constructor:
                                  constant-constructor:
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
                                                   '(predicate:
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

(define-prim (##ill-formed-special-form form-name args)
  (##raise-expression-parsing-exception
   'ill-formed-special-form
   (##sourcify
    (##cons form-name args)
    (##make-source #f #f))
   form-name))

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

(define-runtime-macro (define-type . args)
  (##define-type-expand 'define-type #f #f args))

(define-runtime-macro (define-structure . args)
  (##define-type-expand 'define-structure #f #f args))

(define-runtime-macro (define-record-type name constructor predicate . fields)
  `(define-type ,name
     constructor: ,constructor
     predicate: ,predicate
     ,@fields))

;;; - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

(define-runtime-macro (define-type-of-thread . args)
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
        (or (##fx< 1 level)
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

(define-prim (exit #!optional (status (macro-absent-obj)))
  (if (##eq? status (macro-absent-obj))
      (##exit)
      (macro-force-vars (status)
        (macro-check-exact-unsigned-int8 status 1 (exit status)
          (##exit status)))))

(define-prim (##getenv name #!optional (default-value (macro-absent-obj)))
  (let ((result (##os-getenv name)))
    (cond ((##fixnum? result)
           (##raise-os-exception #f result getenv name default-value))
          ((##not result)
           (if (##eq? default-value (macro-absent-obj))
               (##raise-unbound-os-environment-variable-exception
                getenv
                name)
               default-value))
          (else
           result))))

(define-prim (getenv name #!optional (default-value (macro-absent-obj)))
  (macro-force-vars (name)
    (macro-check-string name 1 (getenv name default-value)
      (##getenv name default-value))))

(define-prim (##setenv name #!optional (value (macro-absent-obj)))
  (let ((code (##os-setenv name value)))
    (if (##fx< code 0)
        (##raise-os-exception #f code setenv name value)
        (##void))))

(define-prim (setenv name #!optional (value (macro-absent-obj)))
  (macro-force-vars (name value)
    (macro-check-string name 1 (setenv name value)
      (if (##eq? value (macro-absent-obj))
          (##setenv name)
          (macro-check-string value 2 (setenv name value)
            (##setenv name value))))))

(define-prim (command-line)
  ##processed-command-line)

(define-prim (##shell-command-blocking cmd)
  (let ((code (##os-shell-command cmd)))
    (if (##fx< code 0)
        (##raise-os-exception #f code ##shell-command-blocking cmd)
        code)))

(define ##shell-program #f)
(define ##shell-command-fallback #t)

(define-prim (##get-shell-program)

  (define unix-shell-program    '("/bin/sh" . "-c"))
  (define windows-shell-program '("CMD.EXE" . "/C"))
  (define default-shell-program '("sh"      . "-c"))

  (or ##shell-program
      (let* ((cd
              (##current-directory))
             (directory-separator
              (##string-ref cd (##fx- (##string-length cd) 1)))
             (sp
              (if (##char=? #\\ directory-separator)
                  (let ((comspec (##getenv "COMSPEC" #f)))
                    (if comspec
                        (##cons comspec "/C")
                        windows-shell-program))
                  (if (##file-exists? (##car unix-shell-program))
                      unix-shell-program
                      default-shell-program))))
        (set! ##shell-program sp)
        sp)))

(define-prim (##shell-command cmd #!optional (capture? (macro-absent-obj)))
  (let* ((shell-prog
          (##get-shell-program))
         (cap
          (if (##eq? capture? (macro-absent-obj))
              #f
              (and capture? #t)))
         (path-or-settings
          (##list path: (##car shell-prog)
                  arguments:
                  (##list
                   (##cdr shell-prog)
                   cmd)
                  stdin-redirection: #f
                  stdout-redirection: cap
                  stderr-redirection: cap)))
    (##open-process-generic
     (macro-direction-inout)
     #f
     (lambda (port)
       (if (##fixnum? port)
           (if (and ##shell-command-fallback
                    (##fx= port ##err-code-unimplemented))
               (let ((code (##os-shell-command cmd)))
                 (if (##fx< code 0)
                     (##raise-os-exception #f code shell-command cmd capture?)
                     (if cap
                         (##cons code "")
                         code)))
               (##raise-os-exception #f port shell-command cmd capture?))
           (if cap
               (begin
                 (##close-output-port port)
                 (let* ((out (##read-line port #f #f ##max-fixnum))
                        (output (if (##string? out) out "")))
                   (##close-input-port port)
                   (let ((status (##process-status port)))
                     (##cons status output))))
               (begin
                 (##close-port port)
                 (##process-status port)))))
     open-process
     path-or-settings)))

#;
(define-prim (##escape-string str escape-char to-escape)
  (let* ((len
          (##string-length str))
         (nb-escapes
          (let loop1 ((i (##fx- len 1))
                      (n 0))
            (if (##fx< i 0)
                n
                (let ((c (##string-ref str i)))
                  (loop1 (##fx- i 1)
                         (if (##memq c to-escape)
                             (##fx+ n 1)
                             n))))))
         (escaped-len
          (##fx+ len nb-escapes))
         (escaped-str
          (##make-string escaped-len 0)))
    (let loop2 ((i (##fx- len 1))
                (j (##fx- escaped-len 1)))
      (if (and (##not (##fx< i 0)) (##not (##fx< j 0)))
          (let ((c (##string-ref str i)))
            (##string-set! escaped-str j c)
            (loop2 (##fx- i 1)
                   (if (and (##fx< 0 j)
                            (##memq c to-escape))
                       (let ()
                         (##string-set! escaped-str
                                        (##fx- j 1)
                                        escape-char)
                         (##fx- j 2))
                       (##fx- j 1))))
          escaped-str))))

(define-prim (shell-command cmd #!optional (capture? (macro-absent-obj)))
  (macro-force-vars (cmd capture?)
    (macro-check-string cmd 1 (shell-command cmd capture?)
      (if (##eq? capture? (macro-absent-obj))
          (##shell-command cmd)
          (##shell-command cmd capture?)))))

;;;----------------------------------------------------------------------------

;;; Implementation of file-info objects.

(implement-library-type-file-info)

(define-prim (##file-info
              path
              #!optional
              (chase? (macro-absent-obj)))
  (let* ((resolved-path
          (##path-resolve path))
         (result
          (##os-file-info resolved-path
                          (if (##eq? chase? (macro-absent-obj))
                              #t
                              chase?))))
    (if (##fixnum? result)
        result
        (begin
          (let ((type
                 (case (##vector-ref result 1)
                   ((1)  'regular)
                   ((2)  'directory)
                   ((3)  'character-special)
                   ((4)  'block-special)
                   ((5)  'fifo)
                   ((6)  'symbolic-link)
                   ((7)  'socket)
                   (else 'unknown))))
            (##vector-set! result 1 type))
          (##vector-set! result 9
                         (macro-make-time (##vector-ref result 9) #f #f #f))
          (##vector-set! result 10
                         (macro-make-time (##vector-ref result 10) #f #f #f))
          (##vector-set! result 11
                         (macro-make-time (##vector-ref result 11) #f #f #f))
          (##vector-set! result 13
                         (macro-make-time (##vector-ref result 13) #f #f #f))
          (##structure-type-set! result (macro-type-file-info))
          (##subtype-set! result (macro-subtype-structure))
          result))))

(define-prim (file-info
              path
              #!optional
              (chase? (macro-absent-obj)))
  (macro-force-vars (path chase?)
    (macro-check-string path 1 (file-info path chase?)
      (let ((info (##file-info path chase?)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-info path chase?)
            info)))))

(define-prim (file-type path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-type path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-type path)
            (macro-file-info-type info))))))

(define-prim (file-device path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-device path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-device path)
            (macro-file-info-device info))))))

(define-prim (file-inode path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-inode path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-inode path)
            (macro-file-info-inode info))))))

(define-prim (file-mode path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-mode path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-mode path)
            (macro-file-info-mode info))))))

(define-prim (file-number-of-links path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-number-of-links path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-number-of-links path)
            (macro-file-info-number-of-links info))))))

(define-prim (file-owner path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-owner path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-owner path)
            (macro-file-info-owner info))))))

(define-prim (file-group path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-group path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-group path)
            (macro-file-info-group info))))))

(define-prim (file-size path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-size path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-size path)
            (macro-file-info-size info))))))

(define-prim (file-last-access-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-last-access-time path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-last-access-time path)
            (macro-file-info-last-access-time info))))))

(define-prim (file-last-modification-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-last-modification-time path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-last-modification-time path)
            (macro-file-info-last-modification-time info))))))

(define-prim (file-last-change-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-last-change-time path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-last-change-time path)
            (macro-file-info-last-change-time info))))))

(define-prim (file-attributes path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-attributes path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-attributes path)
            (macro-file-info-attributes info))))))

(define-prim (file-creation-time path)
  (macro-force-vars (path)
    (macro-check-string path 1 (file-creation-time path)
      (let ((info (##file-info path)))
        (if (##fixnum? info)
            (##raise-os-exception #f info file-creation-time path)
            (macro-file-info-creation-time info))))))

(define-prim (file-last-access-and-modification-times-set!
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
          (##raise-os-exception #f code file-last-access-and-modification-times-set! a-absrel-timeout m-absrel-timeout)
          (##void))))

  (macro-force-vars (path a-absrel-timeout m-absrel-timeout)
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
                  (change a-absrel-timeout m-absrel-timeout))))))))

;;;----------------------------------------------------------------------------

(define-prim (##file-exists?
              path
              #!optional
              (chase? (macro-absent-obj)))
  (let* ((resolved-path
          (##path-resolve path))
         (result
          (##os-file-info resolved-path
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

;;; Implementation of user-info objects.

(implement-library-type-user-info)

(define-prim (##user-info user)
  (let ((result (##os-user-info user)))
    (if (##fixnum? result)
        (##raise-os-exception #f result user-info user)
        (begin
          (##structure-type-set! result (macro-type-user-info))
          (##subtype-set! result (macro-subtype-structure))
          result))))

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
  (let ((result (##os-group-info group)))
    (if (##fixnum? result)
        (##raise-os-exception #f result group-info group)
        (begin
          (##structure-type-set! result (macro-type-group-info))
          (##subtype-set! result (macro-subtype-structure))
          result))))

(define-prim (group-info group)
  (macro-force-vars (group)
    (macro-check-string-or-nonnegative-fixnum group 1 (group-info group)
      (##group-info group))))

;;;----------------------------------------------------------------------------

;;; Pathname operations.

(define-prim (##path-volume-end-using-dir-sep path directory-separator)
  (cond ((##char=? #\: directory-separator)
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
         0)))


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
  (let* ((cd
          (##current-directory))
         (directory-separator
          (if (##fx< 0 (##string-length cd))
              (##string-ref cd (##fx- (##string-length cd) 1))
              #\/)))

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
                    (if (##char=? #\: directory-separator)
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
                                   (and (##char=? #\\ directory-separator)
                                        (##char=? #\/ c)))
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
                 (expand relpath dir))
                (else
                 (let ((dir (##os-path-gambitdir)))
                   (cond ((##fixnum? dir)
                          (err dir))
                         ((##fx= 0 (##string-length instdir-name))
                          (expand relpath dir))
                         (else
                          (expand relpath
                                  (expand instdir-name dir)))))))))

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
                   (let ((info (##os-user-info (##substring p 1 t-end))))
                     (prepend-directory
                      (if (##fixnum? info)
                          info
                          (##vector-ref info 4)) ;; home dir
                      t-end))))

            (let* ((vol-end
                    (##path-volume-end-using-dir-sep p directory-separator))
                   (dir-sep?
                    (and (##fx< vol-end (##string-length p))
                         (let ((c (##string-ref p vol-end)))
                           (or (##char=? c directory-separator)
                               (and (##char=? #\\ directory-separator)
                                    (##char=? #\/ c)))))))
              (if (##fx= vol-end 0)
                  (relative dir-sep?)
                  (absolute vol-end dir-sep?))))))

    (expand path (if (##eq? origin (macro-absent-obj)) #f origin))))

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
            path)
        (if (or (##eq? allow-relative? (macro-absent-obj))
                (##not allow-relative?))
            p
            (let* ((first-diff
                    (let loop1 ((i 0))
                      (if (and (##fx< i (##string-length dir))
                               (##fx< i (##string-length p))
                               (##char=? (##string-ref dir i) (##string-ref p i)))
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
                                          (and (##char=? #\\ directory-separator)
                                               (##char=? #\/ c)))
                                      (##fx+ i 1)
                                      (loop2 (##fx- i 1)))))))
                         (nb-hops
                          (let loop3 ((i first-diff) (nb-hops 0))
                            (if (##fx< i (##string-length dir))
                                (loop3 (##fx+ i 1)
                                       (let ((c (##string-ref dir i)))
                                         (if (or (##char=? c directory-separator)
                                                 (and (##char=? #\\ directory-separator)
                                                      (##char=? #\/ c)))
                                             (##fx+ nb-hops 1)
                                             nb-hops)))
                                (if (and (##char=? #\: directory-separator)
                                         (or (##fx< 0 nb-hops)
                                             (let loop4 ((i first-diff))
                                               (if (##fx< i (##string-length p))
                                                   (if (##char=? #\:
                                                                 (##string-ref p i))
                                                       #t
                                                       (loop4 (##fx+ i 1)))
                                                   #f))))
                                    (##fx+ nb-hops 1)
                                    nb-hops))))
                         (hop
                          (cond ((##char=? #\: directory-separator)
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
                                (##fx- (##string-length p) length-reduction))))
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
                        p))))))))

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
  (let* ((cd
          (##current-directory))
         (directory-separator
          (##string-ref cd (##fx- (##string-length cd) 1)))
         (vol-end
          (##path-volume-end-using-dir-sep path directory-separator)))
    (let loop ((i (##fx- (##string-length path) 1)))
      (if (##fx< vol-end i)
          (let ((c (##string-ref path (##fx- i 1))))
            (cond ((or (##char=? c directory-separator)
                       (and (##char=? #\\ directory-separator)
                            (##char=? #\/ c)))
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
  (let* ((cd
          (##current-directory))
         (directory-separator
          (##string-ref cd (##fx- (##string-length cd) 1)))
         (vol-end
          (##path-volume-end-using-dir-sep path directory-separator)))
    (let loop ((i (##fx- (##string-length path) 1)))
      (if (##fx< i vol-end)
          vol-end
          (let ((c (##string-ref path i)))
            (cond ((or (##char=? c directory-separator)
                       (and (##char=? #\\ directory-separator)
                            (##char=? #\/ c)))
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
  (let* ((cd
          (##current-directory))
         (directory-separator
          (##string-ref cd (##fx- (##string-length cd) 1)))
         (len
          (##string-length path)))
    (if (and (##fx< 0 len)
             (let ((c (##string-ref path (##fx- len 1))))
               (or (##char=? c directory-separator)
                   (and (##char=? #\\ directory-separator)
                        (##char=? #\/ c)))))
        (##substring path 0 (##fx- len 1))
        path)))

(define-prim (path-strip-trailing-directory-separator path)
  (macro-force-vars (path)
    (macro-check-string path 1 (path-strip-trailing-directory-separator path)
      (##path-strip-trailing-directory-separator path))))

(define-prim (##path-volume-end path)
  (let* ((cd
          (##current-directory))
         (directory-separator
          (##string-ref cd (##fx- (##string-length cd) 1)))
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

;;; Filesystem operations.

(define-prim (##create-directory-or-fifo prim path-or-settings)

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
                 (##raise-os-exception #f code prim path-or-settings)
                 (##void))))))))

(define-prim (create-directory path-or-settings)
  (macro-force-vars (path-or-settings)
    (##create-directory-or-fifo create-directory path-or-settings)))

(define-prim (create-fifo path-or-settings)
  (macro-force-vars (path-or-settings)
    (##create-directory-or-fifo create-fifo path-or-settings)))

(define-prim (##create-link old-path new-path)
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-create-link resolved-old-path resolved-new-path)))
    (if (##fx< code 0)
        (##raise-os-exception #f code create-link old-path new-path)
        (##void))))

(define-prim (create-link old-path new-path)
  (macro-force-vars (old-path new-path)
    (macro-check-string old-path 1 (create-link old-path new-path)
      (macro-check-string new-path 2 (create-link old-path new-path)
        (##create-link old-path new-path)))))

(define-prim (##create-symbolic-link old-path new-path)
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-create-symbolic-link resolved-old-path resolved-new-path)))
    (if (##fx< code 0)
        (##raise-os-exception #f code create-symbolic-link old-path new-path)
        (##void))))

(define-prim (create-symbolic-link old-path new-path)
  (macro-force-vars (old-path new-path)
    (macro-check-string old-path 1 (create-symbolic-link old-path new-path)
      (macro-check-string new-path 2 (create-symbolic-link old-path new-path)
        (##create-symbolic-link old-path new-path)))))

(define-prim (##delete-directory path)
  (let* ((resolved-path
          (##path-resolve path))
         (code
          (##os-delete-directory resolved-path)))
    (if (##fx< code 0)
        (##raise-os-exception
         #f
         code
         delete-directory
         path)
        (##void))))

(define-prim (delete-directory path)
  (macro-force-vars (path)
    (macro-check-string path 1 (delete-directory path)
      (##delete-directory path))))

(define-prim (##rename-file old-path new-path)
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-rename-file
           resolved-old-path
           resolved-new-path)))
    (if (##fx< code 0)
        (##raise-os-exception
         #f
         code
         rename-file
         old-path
         new-path)
        (##void))))

(define-prim (rename-file old-path new-path)
  (macro-force-vars (old-path new-path)
    (macro-check-string old-path 1 (rename-file old-path new-path)
      (macro-check-string new-path 2 (rename-file old-path new-path)
        (##rename-file old-path new-path)))))

(define-prim (##copy-file old-path new-path)
  (let* ((resolved-old-path
          (##path-resolve old-path))
         (resolved-new-path
          (##path-resolve new-path))
         (code
          (##os-copy-file
           resolved-old-path
           resolved-new-path)))
    (if (##fx< code 0)
        (##raise-os-exception
         #f
         code
         copy-file
         old-path
         new-path)
        (##void))))

(define-prim (copy-file old-path new-path)
  (macro-force-vars (old-path new-path)
    (macro-check-string old-path 1 (copy-file old-path new-path)
      (macro-check-string new-path 2 (copy-file old-path new-path)
        (##copy-file old-path new-path)))))

(define-prim (##delete-file path)
  (let* ((resolved-path
          (##path-resolve path))
         (code
          (##os-delete-file resolved-path)))
    (if (##fx< code 0)
        (##raise-os-exception
         #f
         code
         delete-file
         path)
        (##void))))

(define-prim (delete-file path)
  (macro-force-vars (path)
    (macro-check-string path 1 (delete-file path)
      (##delete-file path))))

(define-prim (##directory-files
              #!optional
              (path-or-settings (macro-absent-obj)))
  (##open-directory
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

(define-runtime-macro (six.!x x)
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

(define-runtime-macro (six.x*y x y)
  `(* ,x ,y))

(define-runtime-macro (six.*x x)
  (##infix-lvalue-fetch (##list 'six.*x x)))

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

(define-runtime-macro (six.x&y x y)
  `(bitwise-and ,x ,y))

(define-prim (##infix-id x)
  (if (##pair? x)
      (let* ((first (##car x))
             (rest (##cdr x)))
        (if (and (or (##eq? first 'six.identifier)
                     (##eq? first 'six.prefix))
                 (##pair? rest))
            (let* ((second (##car rest))
                   (rest (##cdr rest)))
              (if (and (##symbol? second)
                       (##null? rest))
                  second
                  #f))
            #f))
      #f))

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

  (if (##pair? x)
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
                           ((and (or (##eq? first 'six.identifier)
                                     (##eq? first 'six.prefix))
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
            (err)))
      (err)))

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

(define-runtime-macro (|six.x\|\|y| x y)
  `(or ,x ,y))

(define-runtime-macro (six.x?y:z x y z)
  `(if ,x ,y ,z))

(define-runtime-macro (six.x:y x y)
  `(cons ,x ,y))

(define-runtime-macro (six.x%=y x y)
  (##infix-update-in-place 'six.x%=y x 'six.x%y y #t))

(define-runtime-macro (six.x&=y x y)
  (##infix-update-in-place 'six.x&=y x 'six.x&y y #t))

(define-runtime-macro (six.x*=y x y)
  (##infix-update-in-place 'six.x*=y x 'six.x*y y #t))

(define-runtime-macro (six.x+=y x y)
  (##infix-update-in-place 'six.x+=y x 'six.x+y y #t))

(define-runtime-macro (six.x-=y x y)
  (##infix-update-in-place 'six.x-=y x 'six.x-y y #t))

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

(define-runtime-macro (six.prefix datum)
  datum)

(define-runtime-macro (six.if expr stat1 . stat2)
  `(if ,expr ,stat1 ,@stat2))

(define-runtime-macro (six.while expr stat)
  (let ((loop (gensym)))
    `(let ,loop () (if ,expr (begin ,stat (,loop))))))

(define-runtime-macro (six.do-while stat expr)
  (let ((loop (gensym)))
    `(let ,loop () (begin ,stat (if ,expr (,loop))))))

(define-runtime-macro (six.for stat1 expr2 expr3 stat2)
  (if (##equal? stat1 '(six.compound))
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

;;;----------------------------------------------------------------------------

;;; Object encoding/decoding.

(define-prim (##object->encoding obj)
  (let* ((hi (##type-cast obj (macro-type-fixnum)))
         (lo (##type obj)))
    (##+ (##* (if (##fx< hi 0) (##- hi ##bignum.2*min-fixnum) hi)
              4)
         lo)))

(define-prim (##encoding->object encoding)
  (let* ((hi (##quotient encoding 4))
         (lo (##modulo encoding 4))
         (x (if (##fixnum? hi) hi (##+ hi ##bignum.2*min-fixnum))))
    (##type-cast x lo)))

;;;============================================================================
