;;;===========================================================================

;;; File: "_syntax.scm"

;;; Copyright (c) 2023 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2023 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

(define ##allow-unbound? #t)
(define (##allow-unbound?-set! b)
  (set! ##allow-unbound? b))

;;;----------------------------------------------------------------------------
;;; binding registration

(define-prim (##expand-let-bindings bindings-src cte)
  (let ((scps (list (make-scope))))
    (let loop ((bindings bindings-src)
               (res      '())
               (cte      cte))
      (match-source bindings ()
        ((binding @ (id val) . bindings)
         (let ((id  (add-scope id (car scps)))
               (val (expand val cte)))
           (cond
             ((or (pair? (##syntax-source-code id))
                  (null? (##syntax-source-code id)))
              (let loop-ids ((ids  (##syntax-source-code id))
                             (cte cte))
                (cond
                  ((pair? ids)
                   (let* ((key (##hcte-add-new-local-binding! cte (car ids)))
                          (cte (##hcte-add-variable-cte cte key (car ids))))
                     (loop-ids
                       (cdr ids)
                       cte)))
                  ((null? ids)
                   (let ((binding (##syntax-source-code-set binding (list id val))))
                     (loop 
                       bindings
                       (cons binding res)
                       cte)))
                  (else
                   (let* ((key (##hcte-add-new-local-binding! cte ids))
                          (cte (##hcte-add-variable-cte cte key ids)))
                     (let ((binding (##syntax-source-code-set binding (list id val))))
                       (loop 
                         bindings
                         (cons binding res)
                         cte)))))))

             (else
               (let* ((key (##hcte-add-new-local-binding! cte id))
                      (cte (##hcte-add-variable-cte cte key id))
                      (binding (##syntax-source-code-set binding
                                 (list id val))))
                 (loop 
                   bindings
                   (cons binding res)
                   cte))))))
        (()
          (list scps 
                (##syntax-source-code-set bindings-src
                  (reverse res))
                cte))
        (_
         (##raise-expression-parsing-exception
           'ill-formed-binding-list
           bindings-src))))))

(define-prim (##expand-let*-bindings bindings-src cte)
  (let ((scps (list)))
    (let loop ((bindings bindings-src)
               (res      '())
               (scps     scps)
               (cte      cte))
      (match-source bindings ()
        ((binding @ (id val) . bindings)
         (let* ((val (expand (add-scopes val scps) cte))
                (scps (cons (make-scope) scps))
                (id (##add-scopes id scps)))
           (cond
             ((or (pair? (##syntax-source-code id))
                  (null? (##syntax-source-code id)))
              (let loop-ids ((ids (##syntax-source-code id))
                             (cte cte))
                (cond 
                  ((pair? ids)
                   (let* ((key (##hcte-add-new-local-binding! cte (car ids)))
                          (cte (##hcte-add-variable-cte cte key (car ids))))
                     (loop-ids
                       (cdr ids)
                       cte)))
                  ((null? ids)
                   (let ((binding (##syntax-source-code-set binding (list id val))))
                     (loop
                       bindings
                       (cons binding res)
                       scps
                       cte)))
                  (else
                   (let* ((key (##hcte-add-new-local-binding! cte ids))
                          (cte (##hcte-add-variable-cte cte key ids)))
                     (let ((binding (##syntax-source-code-set binding (list id val))))
                       (loop
                         bindings
                         (cons binding res)
                         scps
                         cte)))))))
             (else
               (let* ((key (##hcte-add-new-local-binding! cte id))
                      (cte (##hcte-add-variable-cte cte key id))
                      (binding (##syntax-source-code-set binding
                                 (list id val))))
                 (loop
                   bindings
                   (cons binding res)
                   scps
                   cte))))))
        (()
          (list scps 
                (##syntax-source-code-set bindings-src
                  (reverse res)) 
                cte))
        (_
         (##raise-expression-parsing-exception
           'ill-formed-binding-list
           bindings-src))))))

(define-prim (##expand-letrec-bindings bindings-src cte)
  (let ((scps (list (make-scope))))
    (let loop ((bindings bindings-src)
               (res      '())
               (cte      cte))
      (match-source bindings ()
        ((binding @ (id val) . bindings)
         (let ((id (add-scope id (car scps))))
           (cond
            ((or (pair? (##syntax-source-code id))
                 (null? (##syntax-source-code id)))
             (let loop-ids ((ids (##syntax-source-code id))
                            (cte cte))
               (cond
                 ((pair? ids)
                  (let* ((key (##hcte-add-new-local-binding! cte (car ids)))
                         (cte (##hcte-add-variable-cte cte key (car ids))))
                    (loop-ids
                      (cdr ids)
                      cte)))
                 ((null? ids)
                  (let* ((val (add-scope val (car scps)))
                         (binding (##syntax-source-code-set binding
                                    (list id val))))
                    (loop 
                      bindings
                      (cons binding res)
                      cte)))
                 (else
                  (let* ((key (##hcte-add-new-local-binding! cte ids))
                         (cte (##hcte-add-variable-cte cte key ids)))
                    (let* ((val (add-scope val (car scps)))
                           (binding (##syntax-source-code-set binding
                                      (list id val))))
                      (loop 
                        bindings
                        (cons binding res)
                        cte)))))))
            (else
             (let* ((key (##hcte-add-new-local-binding! cte id))
                    (cte (##hcte-add-variable-cte cte key id))
                    (val (add-scope val (car scps)))
                    (binding (##syntax-source-code-set binding
                               (list id val))))
               (loop 
                 bindings
                 (cons binding res)
                 cte))))))
        (()
          (let ((bindings (let loop ((bindings res)
                                     (result   (list)))
                            (cond
                              ((pair? bindings)
                               (let ((binding (car bindings)))
                                 (let ((new-binding
                                         (##syntax-source-code-update binding
                                           (lambda (binding-code)
                                             (match-source binding-code ()
                                               ((id val)
                                                (list id (expand val cte))))))))
                                   (loop 
                                     (cdr bindings)
                                     (cons new-binding result)))))
                              (else
                                result)))))
            (list scps (##syntax-source-code-set bindings-src bindings) cte)))
        (_
         (##raise-expression-parsing-exception
           'ill-formed-binding-list
           bindings-src))))))

(define-prim (##expand-letrec*-bindings bindings-src cte)
  (##expand-letrec-bindings bindings-src cte))

(define-prim (##expand-let-syntax-bindings bindings-src cte)
  (let ((original-cte cte))
    (let ((scps (list (make-scope))))
      (let loop ((bindings bindings-src)
                 (cte      cte))
        (match-source bindings ()
          ((binding @ (id val) . bindings)
           (let ((id  (add-scope id (car scps)))
                 (val (##macro-syntax-descr (##eval-for-syntax-binding val original-cte) val)))
             (let* ((key (##hcte-add-new-local-binding! cte id))
                    (cte (##hcte-add-macro-cte cte key id val)))
               (loop 
                 bindings
                 cte))))
          (()
           (list scps 
                 #f
                 cte))
          (_
           (##raise-expression-parsing-exception
             'ill-formed-binding-list
             bindings-src)))))))

(define-prim (##expand-let*-syntax-bindings bindings-src cte)
  (let ((scps (list)))
    (let loop ((bindings bindings-src)
               (res      '())
               (scps     scps)
               (cte      cte))
      (match-source bindings ()
        ((binding @ (id val) . bindings)
         (let* ((val  (add-scopes val scps))
                (val  (##macro-syntax-descr (##eval-for-syntax-binding val cte) val))
                (scps (cons (make-scope) scps))
                (id (add-scopes id scps)))
           (let* ((key (##hcte-add-new-local-binding! cte id))
                  (cte (##hcte-add-macro-cte cte key id val))
                  (binding (##syntax-source-code-set binding
                             (list id val))))
             (loop
               bindings
               (cons binding res)
               scps
               cte))))
        (()
          (list scps 
                (##syntax-source-code-set bindings-src
                  (reverse res)) 
                cte))
        (_
         (##raise-expression-parsing-exception
           'ill-formed-binding-list
           bindings-src))))))

(define-prim (##expand-letrec-syntax-bindings bindings-src cte)
  (let ((original-cte cte)
        (scps (list (make-scope))))
    (let loop ((bindings bindings-src)
               (cte      cte))
      (match-source bindings ()
        ((binding @ (id val) . bindings)
         (let ((id  (add-scope id (car scps)))
               (val (add-scope val (car scps)))
               (fake-val (lambda _ 'dummy)))
           (let* ((key (##hcte-add-new-local-binding! cte id))
                  (original-cte (##hcte-add-macro-cte original-cte key id fake-val))
                  (val (##macro-syntax-descr (##eval-for-syntax-binding val original-cte) val))
                  (cte (##hcte-add-macro-cte cte key id val)))
             (loop 
               bindings
               cte))))
        (()
          (list scps 
                #f
                cte))
        (_
         (##raise-expression-parsing-exception
           'ill-formed-binding-list
           bindings-src))))))

(define-prim (##expand-letrec*-syntax-bindings bindings-src cte)
  (let ((scps (list)))
    (let loop ((bindings bindings-src)
               (res      '())
               (scps     scps)
               (cte      cte))
      (match-source bindings ()
        ((binding @ (id val) . bindings)
         (let* ((fake-val (lambda _ 'dummy))
                (scps (cons (make-scope) scps))
                (id (##add-scopes id scps)))
           (let* ((key (##hcte-add-new-local-binding! cte id))
                  (cte (##hcte-add-macro-cte cte key id fake-val))
                  (val (##add-scopes val scps))
                  (cte (##hcte-add-macro-cte cte key id (##macro-syntax-descr (##eval-for-syntax-binding val cte) val)))
                  (binding (##syntax-source-code-set binding
                             (list id val))))
             (loop
               bindings
               (cons binding res)
               scps
               cte))))
        (()
          (list scps 
                (##syntax-source-code-set bindings-src
                  (reverse res)) 
                cte))
        (_
         (##raise-expression-parsing-exception
           'ill-formed-binding-list
           bindings-src))))))

(define-macro (##expand-let-forms head syntax? stx cte)

  (define ##expand-bindings
    (case head 
      ((##let)            '##expand-let-bindings)
      ((##let*)           '##expand-let*-bindings)
      ((##letrec)         '##expand-letrec-bindings)
      ((##letrec*)        '##expand-letrec*-bindings)
      ((##let-syntax)     '##expand-let-syntax-bindings)
      ((##let*-syntax)    '##expand-let*-syntax-bindings)
      ((##letrec-syntax)  '##expand-letrec-syntax-bindings)
      ((##letrec*-syntax) '##expand-letrec*-syntax-bindings)
      ((##let-values)     '##expand-let-bindings)
      ((##let*-values)    '##expand-let*-bindings)
      ((##letrec-values)  '##expand-letrec-bindings)
      ((##letrec*-values) '##expand-letrec*-bindings)
      (else               (error "Internal: cannot process let form's bindings"))))

  (let ((stx-id (##gensym 'stx))
        (cte-id (##gensym 'cte)))
   `(let ((,stx-id ,stx)
          (,cte-id (##hcte-local-cte ,cte)))
      (match-source ,stx-id ()
        ((let-id name bindings . body) when (identifier? name)
         (let* ((fake-binding  (##make-syntax-source `(,name ,(##make-syntax-source #f #f)) #f))
                (fake-bindings (##syntax-source-code-update bindings 
                                 (lambda (code) (cons fake-binding code))))
                (fake-expr     (##syntax-source-code-set ,stx-id
                                `(,(##make-core-syntax-source '##let* #f) ,fake-bindings ,@body))))
           (match-source (expand fake-expr ,cte-id) ()
             ((_ ((name _) . bindings) . body)
              (##syntax-source-code-set ,stx-id
                `(,let-id ,name ,(##make-syntax-source bindings #f) ,@body))))))
        ((let-id bindings . body)
         (let* ((scps+bindings+cte (,##expand-bindings bindings ,cte-id))
                (scps     (car scps+bindings+cte))
                (bindings (cadr scps+bindings+cte))
                (cte      (caddr scps+bindings+cte))
                (body (syntax-source-code 
                        (##expand-body (add-scopes (##syntax-source-code-set ,stx-id body) scps) cte))))
           ,(cond
             (syntax?
               `(##syntax-source-code-set ,stx-id
                 `(,(##make-core-syntax-source '##begin #f) ,@body)))
             (else
               `(##syntax-source-code-set ,stx-id
                 `(,let-id ,bindings ,@body))))))
        (_
          (##raise-ill-formed-special-form stx))))))

(define-prim&proc (expand-let stx cte)
  (##expand-let-forms ##let #f stx cte))

(define-prim&proc (expand-let* stx cte)
  (##expand-let-forms ##let* #f stx cte))

(define-prim&proc (expand-letrec stx cte)
  (##expand-let-forms ##letrec #f stx cte))

(define-prim&proc (expand-letrec* stx cte)
  (##expand-let-forms ##letrec* #f stx cte))

(define-prim&proc (expand-let-values stx cte)
  (##expand-let-forms ##let-values #f stx cte))

(define-prim&proc (expand-let*-values stx cte)
  (##expand-let-forms ##let*-values #f stx cte))

(define-prim&proc (expand-letrec-values stx cte)
  (##expand-let-forms ##letrec-values #f stx cte))

(define-prim&proc (expand-letrec*-values stx cte)
  (##expand-let-forms ##letrec*-values #f stx cte))

(define-prim&proc (expand-let-syntax stx cte)
  (##expand-let-forms ##let-syntax #t stx cte))

(define-prim&proc (expand-let*-syntax stx cte)
  (##expand-let-forms ##let*-syntax #t stx cte))

(define-prim&proc (expand-letrec-syntax stx cte)
  (##expand-let-forms ##letrec-syntax #t stx cte))

(define-prim&proc (expand-letrec*-syntax stx cte)
  (##expand-let-forms ##letrec*-syntax #t stx cte))

;;;----------------------------------------------------------------------------

(define-prim (##expand->core-form stx cte)
  (let ((code (syntax-source-code stx)))             
    (if (not (pair? code))
        stx
        (let* ((id  (car code))
               (sym (##syntax-source-code id)))
          (if (not (symbol? sym))
              stx
              (case sym
                ((##define ##define-syntax ##define-global-syntax ##namespace)
                 stx)
                (else
                  (let ((exprs (cdr code)))
                    (let ((t (##resolve-binding-expander id cte)))
                      (if (or (not (##vector? t))
                              (##not-found-object? t))
                          stx
                          (##dispatch t stx cte #t)))))))))))

(define-prim&proc (expand-begin s cte)
  (syntax-source-code-update s
    (lambda (code)
      (cons (car code)
            (##syntax-source-code
               (##expand-pair/list (##syntax-source-code-set s (cdr code)) cte
                 (lambda _ 
                   (##raise-ill-formed-special-form s))))))))
  
(define-prim&proc (expand-body body cte)
  ; core-expand trough expressions, expanding syntax bindings as letrec*-syntax
  ; and registering define form to implement letrec* behahvior.
  ; Stop at the first non-definer, continue with normal ##begin expansion and
  ; expand define form's value, as per letrec* behavior.
  ; 

  (define (##expand-body exprs bindings cte)

    (define (##expand-body-define expr exprs bindings cte)
      (let* ((form (##transform-define-form->base-form expr))
             (form-code (syntax-source-code form))
             (scp       (make-scope))
             (define-id (car form-code))
             (id        (add-scope (cadr form-code) scp))
             (value     (add-scope (caddr form-code) scp)))
        (let* ((key (##hcte-add-new-local-binding! cte id))
               (cte (##hcte-add-variable-cte cte key id)))
          (let ((binding (syntax-source-code-set body `(,expr ,define-id ,id ,value))))
            (##expand-body
              (add-scope exprs scp)
              (cons binding (add-scope bindings scp))
              cte)))))

    (define (##expand-body-define-syntax expr exprs bindings cte)
      (let* ((form-code (syntax-source-code expr))
             (scp       (make-scope))
             (define-id (car form-code))
             (id        (add-scope (cadr form-code) scp))
             (value     (add-scope (caddr form-code) scp))
             (fake-value (lambda _ 'let-dummy)))
        (let* ((key (##hcte-add-new-local-binding! cte id))
               (cte (##hcte-add-macro-cte cte key id fake-value))
               (cte (##hcte-add-macro-cte cte key id (##macro-syntax-descr (##eval-for-syntax-binding
                        value
                        cte) value))))
          (##expand-body
            (add-scope expr scp)
            (add-scope bindings scp)
            cte))))

    (define (##expand-body-define-global-syntax expr exprs bindings cte)
      (let* ((form-code (syntax-source-code expr))
             (scp       (make-scope))
             (define-id (car form-code))
             (id        (add-scope (cadr form-code) scp))
             (value     (add-scope (caddr form-code) scp))
             (fake-value (lambda _ 'let-dummy)))
        (let* ((key (##hcte-add-new-top-level-binding! cte id))
               (cte (##hcte-add-macro-cte cte key fake-value))
               (cte (##hcte-add-macro-cte cte key (##eval-for-syntax-binding
                      value
                      cte) value)))
          (##expand-body
            (add-scope exprs scp)
            (add-scope bindings scp)
            cte))))

    (define (##expand-body-define-bindings expr exprs bindings cte)
      (let loop ((bindings bindings)
                           ;
                           ; Note: we do not need to expand bindings' value before
                           ; expanding the body's expressions as the cte is already built
                           ; correctly for both task at this point.
                 (expanded (##expand-define-exprs expr exprs cte)))
        (cond
          ((pair? bindings)
           (let ((binding  (##syntax-source-code (car bindings)))
                 (bindings (cdr bindings)))
                              ; TODO vectorize-me
             (let ((original  (list-ref binding 0))
                   (define-id (list-ref binding 1))
                   (id        (list-ref binding 2))
                   (value     (list-ref binding 3)))
               (let ((value (##expand value cte)))
                 (loop
                   bindings
                   (cons 
                     (##transform-define-form->sugar-form 
                       (syntax-source-code-set original
                         `(,define-id ,id ,value))
                       original)
                     expanded))))))
          ((null? bindings)
           (syntax-source-code-set body
             expanded)))))

    (define (##expand-body-namespace expr exprs bindings cte)
      (let ((cte (##hcte-process-namespace cte expr)))
        (##expand-body exprs bindings cte)))

    (define (##expand-define-exprs expr exprs cte)
      (let ((body (##syntax-source-code-set body (cons expr exprs))))
        (##syntax-source-code
          (##expand-pair/list body cte 
            (lambda _ 
              (##raise-ill-formed-special-form body))))))

    (cond 
      ((pair? exprs)
       (let ((expr  (car exprs))
             (exprs (cdr exprs)))
         (let ((core-expanded (##expand->core-form expr cte)))
           (match-source core-expanded (##define ##define-syntax ##define-global-syntax ##namespace)
             ((##define . args)
              (##expand-body-define core-expanded exprs bindings cte))
             ((##define-syntax . args)
              (##expand-body-define-syntax core-expanded exprs bindings cte))
             ((##define-global-syntax . args)
              (##expand-body-define-global-syntax core-expanded exprs bindings cte))
             ((##namespace . args)
              (##expand-body-namespace core-expanded exprs bindings cte))
             (_
              (##expand-body-define-bindings core-expanded exprs bindings cte))))))
      (else
       (##raise-expression-parsing-exception
         'empty-body
         body))))

  (let ((cte (##hcte-local-cte cte)))
    (##expand-body (##syntax-source-code body) (list) cte)))
    
;;;----------------------------------------------------------------------------
;;; Sequencing forms

(define-prim (##map-pair proc on-pair-proc p)
  (cond
    ((pair? p)
     (cons (proc (car p))
           (##map-pair proc on-pair-proc (cdr p))))
    ((null? p)
     p)
    (else
     (on-pair-proc p))))

(define-prim (##expand-pair/list stx cte on-pair-proc)
  (##syntax-source-code-update stx
    (lambda (code)
      (##map-pair (lambda (e) (expand e cte))
                  on-pair-proc
                  code))))

(define-prim (##expand-pair stx cte)
  (##expand-pair/list stx cte 
    (lambda (code)
      (expand code cte))))

;;;----------------------------------------------------------------------------
;;; application form

(define-prim (##apply-transformer t stx)
  (let* ((intro-scope (make-scope))
         (intro-stx   (add-scope stx intro-scope)))
    (let ((transformed-stx (t intro-stx)))
      (cond
        ((syntax-source? transformed-stx)
         (flip-scope transformed-stx intro-scope))
        (else
         (##raise-expression-parsing-exception
           'non-syntax-result
           (##make-source transformed-stx #f)))))))

(define-prim (##dispatch t s cte #!optional (no-reexpansion #f))
  (cond 
    ((##ctx-binding-variable? t)
     s)
    ((##ctx-binding-macro? t)
     (let* ((descr (##ctx-binding-macro-expander t))
            (proc  (##macro-descr-expander descr))) ; TODO reimplement use of gambit descrs
       (let ((transformed-s (##apply-transformer proc s)))
         (if no-reexpansion 
             (##expand->core-form transformed-s cte)
             (expand transformed-s cte)))))
    ((##ctx-binding-core-macro? t)
     (cond
       (no-reexpansion
        s)
       (else
         (let* ((descr (##ctx-binding-core-macro-expander t))
                (proc  (##macro-descr-expander descr))) ; TODO reimplement use of gambit descrs
           (proc s cte)))))
    (else
      (##raise-expression-parsing-exception
        'illegal-syntax-use
        s))))

(define-prim (##expand-id-application-form id stx cte)
  (let ((t (##resolve-binding-expander id cte)))
    (if (or (not (##vector? t))
            (##not-found-object? t))
        (##expand-application stx cte)
        (##dispatch t stx cte))))

(define-prim (##expand-application stx cte)
  (##expand-pair/list stx (##hcte-local-cte cte)
      (lambda (_) 
        (##raise-expression-parsing-exception
          'ill-formed-call
          stx))))

;;;----------------------------------------------------------------------------
;;; lambda

(define-prim (##expand-lambda stx cte)

  (define (register-variable id cte)
    (let* ((key (##hcte-add-new-local-binding! cte id))
           (cte (##hcte-add-variable-cte cte key id)))

      (list id cte)))

  (define (register-keyword-variable id cte)
    (list id cte))

  (define (expand-lambda-bindings bindings scp cte)
    ; -> (bindings cte)

    (define (expand-required-parameters params cte)
      (let loop ((params (add-scope params scp))
                 (res    (list))
                 (cte    cte))
        (cond
          ((pair? params)
           (let* ((id+cte (register-variable (car params) cte))
                  (id     (car id+cte))
                  (cte    (cadr id+cte)))
             (loop
               (cdr params)
               (cons id res)
               cte)))
          (else
           (list (reverse res) cte)))))

    (define (expand-valued-parameters params cte #!optional (keyword-arguments? #f))
      (cond
        (params
          (let loop ((params params)
                     (res    (list))
                     (cte    cte))
            (cond
              ((pair? params)
               (let* ((param (car params))
                      (id    (add-scope (car param) scp))
                      (val   (let ((val (cdr param)))
                               (if (##syntax-source? val)
                                   (expand val cte)
                                   val)))
                      (id+cte (if keyword-arguments?
                                  (register-keyword-variable id cte)
                                  (register-variable id cte)))
                      (id     (car id+cte))
                      (cte    (cadr id+cte)))
                 (loop
                   (cdr params)
                   (cons (list id val) res)
                   cte)))
              (else
                (list (reverse res) cte)))))
        (else
         (list params cte))))

    (define (expand-rest-parameter param cte)
      (or (and param
              (let* ((res+cte (expand-required-parameters (list param) cte))
                     (id      (car (car res+cte)))
                     (cte     (cadr res+cte)))
                (list id cte)))
          (list param cte)))

    (cond
      ((identifier? bindings)
       (let ((bindings (add-scope bindings scp)))
         (register-variable bindings cte)))
      (else
        (let* ((all-parms
                 (##extract-parameters stx bindings))
               (required-parameters
                 (##vector-ref all-parms 0))
               (optional-parameters
                 (##vector-ref all-parms 1))
               (rest-parameter
                 (##vector-ref all-parms 2))
               (dsssl-style-rest?
                 (##vector-ref all-parms 3))
               (key-parameters
                 (##vector-ref all-parms 4)))

          (let* ((required-parameters+cte 
                   (expand-required-parameters required-parameters cte))
                 (required-parameters (car required-parameters+cte))
                 (cte                 (cadr required-parameters+cte))
                 (optional-parameters+cte
                   (expand-valued-parameters optional-parameters cte #f))
                 (optional-parameters (car optional-parameters+cte))
                 (cte                 (cadr optional-parameters+cte))
                 (key-parameters+cte
                   (expand-valued-parameters key-parameters cte #t))
                 (key-parameters      (car key-parameters+cte))
                 (cte                 (cadr key-parameters+cte))
                 (rest-parameter+cte
                   (expand-rest-parameter rest-parameter cte))
                 (rest-parameter      (car rest-parameter+cte))
                 (cte                 (cadr rest-parameter+cte)))

            (list
              (##reconstruct-parameters 
                bindings
                required-parameters
                optional-parameters
                rest-parameter
                dsssl-style-rest?
                key-parameters)
              cte))))))
  (let ((scp (make-scope))
        (cte (##hcte-local-cte cte)))
    (match-source stx ()
      ((lambda-id bindings . body)
       (let* ((bindings+cte (expand-lambda-bindings bindings scp cte))
              (bindings         (car  bindings+cte))
              (cte              (cadr bindings+cte)))
         (let ((body (syntax-source-code 
                       (##expand-body 
                         (add-scope 
                           (syntax-source-code-set stx body) 
                           scp) 
                         cte))))
           (##syntax-source-code-set stx
             `(,lambda-id ,bindings ,@body)))))
      (else
       (##raise-ill-formed-special-form stx)))))

;;;----------------------------------------------------------------------------
;;; top-level definition forms

(define-prim (##transform-define-form->base-form stx)
  ; desugar define forms
  (match-source stx ()
    ((define-id (id . args) . body)
     (##syntax-source-code-set stx
      `(,define-id ,id ,(##syntax-source-code-set stx
                          `(,(##make-core-syntax-source '##lambda #f)
                            ,(if (identifier? args)
                                 args
                                 (##syntax-source-code-set stx args))
                            ,@body)))))
    ((define-id id val)
     stx)
    (_
     (##raise-ill-formed-special-form stx))))

(define-prim (##transform-define-form->sugar-form stx original-stx)
  ; reconstruct a sugared define-form

  (match-source original-stx ()
    ((_ binding @ (_ . _) . _)
     ; sugar form 
     ;
     (match-source stx ()
       ((define-id id (lambda-id args . body))
        (##syntax-source-code-set original-stx 
          `(,define-id ,(##syntax-source-code-set binding 
                          (cons id (if (identifier? args)
                                       args
                                       (##syntax-source-code args))))
                       ,@body)))))
    (_
     ; base form
     ;
      stx)))

(define-prim&proc (syntax-full-name-maybe cte id)
  (let ((full-name (##hcte-global-name cte id)))
      (and full-name
           (syntax-source-code-set id full-name))))

(define-prim&proc (syntax-full-name cte id)
  (or (##syntax-full-name-maybe cte id)
      id))

(define-prim&proc (expand-define stx cte)
  (cond
    ((##hcte-top? cte)
     (match-source (##transform-define-form->base-form stx) ()
      ((define-id id val)
       (let ((full-id (##syntax-full-name cte id)))
         (let* ((_   (##hcte-add-new-top-level-binding! cte full-id))
                (val (##expand val cte))
                (expanded-stx (##syntax-source-code-set stx 
                                 `(,define-id ,id ,val))))
           (##transform-define-form->sugar-form expanded-stx stx))))))
    (else
      (##raise-expression-parsing-exception
        'ill-placed-define
        stx))))

(define-prim (##expand-define-syntax stx cte)
  (cond
    ((##hcte-top? cte)
     (match-source stx ()
      ((define-id id expander)
       (let ((id (##syntax-full-name cte id)))
         (##top-hcte-add-macro-cte! cte id (lambda _ (##make-syntax-source 'dummy #f)))
         (let ((descr (##macro-syntax-descr (##eval-for-syntax-binding expander cte) expander)))
           (##top-hcte-add-macro-cte! cte id descr)
           (##syntax-source-code-set stx #!void))))
      (_
       (##raise-ill-formed-special-form stx))))
    (else
      (##raise-expression-parsing-exception
        'ill-placed-define-syntax
        stx))))

(define-prim (##expand-define-top-level-syntax stx cte)
  (##expand-define-syntax stx (##hcte-top-cte cte)))

;;;----------------------------------------------------------------------------

(define-prim (##expand-identifier id cte)
  (let ((binding (if (##hcte-top? cte)
                     (resolve-global id cte)
                     (resolve-local id cte))))
    (let ((key 
            (cond
              ((##binding-top-level? binding)
               (##binding-top-level-symbol binding))
              ((##binding-local? binding)
               (##binding-local-key binding))
              (else
               #f))))
      (let ((value (and key (##hcte-ctx-ref cte key))))
        (cond
          ((and value 
                (##ctx-binding-variable? value))
           id)
          (value
            (##raise-expression-parsing-exception
             'macro-used-as-variable
             id))
          ((and binding (##binding-top-level? binding))
           id)
          (##allow-unbound?
           id)
          (else
            (##error "unbound identifier")))))))

;;;----------------------------------------------------------------------------

(define-prim&proc (expand-quote stx cte)
  (let ((code (##syntax-source-code stx)))
    (if (and (pair? code)
             (pair? (cdr code))
             (null? (cddr code)))
        stx
        (##raise-ill-formed-special-form
          stx))))

(define-prim&proc (expand-quote-syntax stx cte)
  (let ((code (##syntax-source-code stx)))
    (if (and (pair? code)
             (pair? (cdr code))
             (null? (cddr code)))
        stx
        (##raise-ill-formed-special-form
          stx))))

(define-prim&proc (expand-syntax stx cte)
  (let ((code (##syntax-source-code stx)))
    (if (and (pair? code)
             (pair? (cdr code))
             (null? (cddr code)))
        stx
        (##raise-ill-formed-special-form
         stx))))

(define-prim&proc (expand-unquote s cte)
  (##raise-expression-parsing-exception
    'ill-placed-unquote
    s))

(define-prim&proc (expand-unquote-splicing s cte)
  (##raise-expression-parsing-exception
    'ill-placed-unqote-splicing
    s))

(define-prim (##implicit-prefix-apply sym stx-src)
  (##plain-datum->syntax
    `(,(##make-core-syntax-source sym #f) ,stx-src)
     stx-src))

(define-prim&proc (expand-quasiquote s cte)

  (define (tag-quasiquote? code)
    (and (##pair? code)
         (##member (##syntax-source-code (##car code)) (##list 'quasiquote '##quasiquote))
         (##pair? (##cdr code))
         (##cadr code)))

  (define (tag-unquote? code)
    (and (##pair? code)
         (##member (##syntax-source-code (##car code)) (##list 'unquote '##unquote))
         (##pair? (##cdr code))
         (##cadr code)))

  (define (tag-unquote-splicing? code)
    (and (##pair? code)
         (##member (##syntax-source-code (##car code)) (##list 'unquote-splicing '##unquote-splicing))
         (##pair? (##cdr code))
         (##cadr code)))

  (define (expand-template s)

    (let ((code (##syntax-source-code s)))
      (cond
        ((tag-unquote? code)
          => (lambda (datum) (##expand datum cte)))
        ((tag-unquote-splicing? code) 
         (##raise-expression-parsing-exception
           'ill-placed-unquote-splicing
           s))
        #;((tag-quasiquote? code)
           => (lambda (datum)
                (expand-template
                  (expand-template (##syntax-source-code-set s datum)))))
        ((and (##pair? code) (not (tag-quasiquote? code)))
         (##syntax-source-code-set s
           `(,(##make-core-syntax-source '##append #f)
                ,(expand-template-list (##car code))
                ,(expand-template (let ((rest (cdr code)))
                                    (if (or (pair? rest) (null? rest))
                                        (##syntax-source-code-set s rest)
                                        rest))))))
        (else
          (##implicit-prefix-apply '##quote s)))))
        
  (define (expand-template-list s)
    (let ((code (##syntax-source-code s)))
      (cond 
        ((tag-unquote? code)
         => (lambda (datum)
              (##syntax-source-code-set s 
                (##list 
                  (##make-core-syntax-source '##list #f)
                  (##expand datum cte)))))
        ((tag-unquote-splicing? code)
         => (lambda (datum) (##expand datum cte)))
        #;((tag-quasiquote? code)
           => (lambda (datum)
                (expand-template-list
                  (expand-template (##syntax-source-code-set s datum)))))
        ((and (##pair? code) (not (tag-quasiquote? code)))
         (##implicit-prefix-apply '##list
           (##syntax-source-code-set s
               `(,(##make-core-syntax-source '##append #f)
                  ,(expand-template-list (##car code))
                  ,(expand-template      (let ((rest (cdr code)))
                                           (if (or (pair? rest) (null? rest))
                                               (##syntax-source-code-set s rest)
                                               rest)))))))
        (else
          (##plain-datum->syntax 
            `(,(##make-core-syntax-source '##quote #f)
              ,(##syntax-source-code-set s (##list s)))
            s)))))

  (let* ((code (##syntax-source-code s)))
    (if (and (##pair? code) 
             (##pair? (##cdr code)) 
             (##null? (##cddr code)))
        (let ((datum (##cadr code)))
          (expand-template datum))
        (##raise-ill-formed-special-form s))))

;;;----------------------------------------------------------------------------

(define-prim&proc (expand-namespace stx cte)
  (##top-hcte-process-namespace! cte stx)
  stx)

(define-prim&proc (expand-include stx-src cte)

  (define (##include-file-as-a-begin-expr src)

    (define (include-file fn-src ci?)
      (let* ((filename-src (##sourcify fn-src src))
             (filename (##source-code filename-src)))
        (if (##string? filename)

            (let* ((relative-to-path
                    (##source-path src))
                   (path
                    (##path-reference filename relative-to-path))
                   (x
                    (##read-all-as-a-begin-expr-from-path
                     path
                     (##current-readtable)
                     ##wrap-datum
                     ##unwrap-datum
                     (if ci? #t '()))))
              (if (##fixnum? x)
                  (##raise-expression-parsing-exception
                   'cannot-open-file
                   src
                   path)
                  (##vector-ref x 1)))

            (##raise-expression-parsing-exception
             'filename-expected
             filename-src))))

    (let* ((code (##source-code src))
           (ci? (##eq? (##source-code (##sourcify (##car code) src))
                       '##include-ci))
           (lst (##map (lambda (fn-src) (include-file fn-src ci?))
                       (##cdr code))))
      (if (and (##pair? lst) (##null? (##cdr lst)))
          (##car lst)
          (##make-source
           (##cons '##begin lst)
           src))))

  (let ((file-src (##include-file-as-a-begin-expr stx-src)))
    (let ((file-stx (add-scope (##datum->syntax file-src (car (##source-code stx-src))) core-scope)))
      (##expand file-stx cte))))

;;;----------------------------------------------------------------------------

(define-prim&proc (expand-case stx cte)

  (define (expand-clauses clauses cte)
    (cond
      ((pair? clauses)
       (let ((clause  (car clauses))
             (clauses (cdr clauses)))
         (cons
           (match-source clause ()
             ((id val)
              (##syntax-source-code-set clause
                `(,id ,(expand val cte))))
             (_
              (##raise-expression-parsing-exception
                'ill-formed-selector-list
                stx)))
           (expand-clauses clauses cte))))
      ((null? clauses)
       clauses)
      (else
       (##raise-ill-formed-special-form stx))))

  ; skip pattern expansion ...
  (match-source stx ()
    ((case-id expr . clauses)
     (let ((expr (expand expr cte))
           (clauses (expand-clauses clauses cte)))
       (##syntax-source-code-set stx
         `(,case-id ,expr ,@clauses))))
    (_
     (##raise-ill-formed-special-form stx))))
  
(define-prim (##expand-cond stx-src cte)

  (define (##expand-cond-clause clause next-clause cte)
    (match-source clause (=>)
      ((condition => expr)
       (##plain-datum->core-syntax
         `(let ((x ,(##expand condition cte)))
            (if x
                (,(##expand expr cte) x)
                ,next-clause))
          clause))
      ((condition . exprs)
       (##plain-datum->core-syntax
        (let ((expanded-condition (##expand condition cte)))
         `(if ,expanded-condition
              ,(if (pair? exprs)
                   (##expand (##syntax-source-code-set stx-src 
                               (##cons (##make-core-syntax-source '##begin #f)
                                   exprs))
                             cte)
                   expanded-condition)
              ,next-clause))))
      (else
        (##raise-ill-formed-special-form stx-src))))

  (match-source stx-src ()
    ((cond-id . clauses)

     (let* ((r-clauses (##reverse clauses))
            (last-clause (##car r-clauses)))
       (let ((else-clause? 
               (and (##equal? 'else
                            (##syntax-source-code 
                              (car (##syntax-source-code last-clause))))
                    (##expand (##cadr (##syntax-source-code last-clause)) cte))))
         (let ((r-clauses (##reverse (if else-clause?
                              (##cdr r-clauses)
                              r-clauses))))
             (let loop ((clauses r-clauses))
               (cond 
                 ((##pair? clauses)
                  (let ((clause (##car clauses)))
                    (##expand-cond-clause clause 
                                          (loop (##cdr clauses))
                                          cte)))
                 ((##null? clauses)
                  (if else-clause?
                      else-clause?
                      #f))))))))
    (_
     (##raise-ill-formed-special-form stx-src))))

;;;----------------------------------------------------------------------------

(define-prim&proc (expand stx cte)
  (let ((code (##syntax-source-code stx)))
    (cond
      ((null? code)
       stx)
      ((pair? code)
       (cond
         ((identifier? (car code))
          (##expand-id-application-form (car code) stx cte))
         (else
          (##expand-pair stx cte))))
      ((identifier? stx)
       (##expand-identifier stx cte))
      ((keyword? (##syntax-source-code stx))
       stx)
      ((boolean? (##syntax-source-code stx))
       stx)
      ((string? code)
       stx)
      (else
       (##syntax-source-code-set stx
         `(,(##make-core-syntax-source '##quote #f) ,stx))))))

;;;============================================================================
