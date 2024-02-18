;;;============================================================================

;;; File: "_compile.scm"

;;; Copyright (c) 2023 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2023 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

;;; Compile
;;
;;  Transform a syntax-source to it's final hygienic form
;;  compile : syntax-source -> syntax-source
;;  destroy-scopes? : syntax-source -> source
;;
;;;============================================================================

(define destroy-scopes? #f)

;;;----------------------------------------------------------------------------

(define-prim&proc (resolve-compile-local-binding (id identifier) (cte cte))
  (let ((b (##resolve-id id cte)))
    (cond
      ((##binding-local? b)
       (syntax-source-code-set
         id
         (##binding-local-key b)))
      ((and (##binding-top-level? b)
            #t) ; is a core form
       (##binding-top-level-symbol b))
      (else
        (##error-expansion ##resolve-compile-local-binding id "not a local binding")))))
 
(define-prim&proc (resolve-compile-core-binding? (id identifier) (cte cte))
  (let ((b (##resolve-id id cte)))
    (and (and (##binding-top-level? b)
              #t) ; is a core form
         (##binding-top-level-symbol b))))
       
(define-prim&proc (resolve-compile-local-bindings ids (cte cte))
  (cond
    ((pair? ids)
     (cons
       (##resolve-compile-local-binding (car ids) cte)
       (##resolve-compile-local-bindings (cdr ids) cte)))
    ((null? ids)
     ids)
    (else
      (##resolve-compile-local-binding ids cte))))

;;;----------------------------------------------------------------------------

(define-prim&proc (compile-pair/list stx cte on-pair-proc)
  (syntax-source-code-update stx
    (lambda (code)
      (##map-pair (lambda (e) (compile e cte)) 
                on-pair-proc 
                code))))

(define-prim&proc (compile-pair stx cte)
  (##compile-pair/list stx cte (lambda (e) (compile e cte))))

(define-prim&proc (compile-body body cte)
  (##map-pair (lambda (e) (compile e cte)) 
              (lambda (_) (##error-expansion ##compile-body body "ill formed body"))
              body))

(define-prim&proc (compile-application stx cte)
  (##compile-pair/list stx cte (lambda () (##error-expansion ##compile-application stx "ill formed application form"))))

;;;----------------------------------------------------------------------------

(define-prim&proc (compile-identifier id cte)
  (cond
    ((identifier? id)
     (let ((binding (resolve-id id cte)))
       (cond
         ((not binding)
          (if #f ;safe-compile? 
              (##error-expansion ##compile-identifier id "Unknown identifier")
              id))
         (else
           (syntax-source-code-set id
             ((if (##binding-local? binding)
                  ##binding-local-key
                  ##binding-top-level-symbol)
              binding))))))
    (else
      (##error-expansion ##compile-identifier id "not an identifier"))))

(define-prim&proc (compile-keyword-argument stx cte)
  ; TODO: add hygiene for keywords
  stx
  #;(let ((id 
          (cond
            ((keyword? (syntax-source-code stx))
             (keyword->identifier stx))
            (else
             (error "internal")))))
    (##pretty-print "compile keyword")
    (##pretty-print (identifier->keyword (compile-identifier id cte)))
    (identifier->keyword (compile-identifier id cte))))

;;;----------------------------------------------------------------------------

(define-prim&proc (compile-lambda stx cte)

  (define (compile-lambda-bindings bindings-src cte)
    (cond
      ((identifier? bindings-src)
       (##resolve-compile-local-binding bindings-src cte))
      (else
       (syntax-source-code-update bindings-src
         (lambda (bindings)
           (let loop ((bindings bindings)
                      (result   '())
                      (keywords? #f))
             (cond
               ((pair? bindings)
                (let* ((binding (car bindings))
                       (binding-code (syntax-source-code binding)))
                  (cond
                    ((equal? binding-code '#!key)
                     (loop (cdr bindings) (cons binding result) #t))
                    ((member binding-code
                            `(#!optional #!rest))
                     (loop (cdr bindings) (cons binding result) #f))
                    ((pair? binding-code)
                     (loop
                       (cdr bindings)
                       (cons
                         (syntax-source-code-set binding
                           `(,(if keywords? 
                                  (car binding-code)
                                  (##resolve-compile-local-binding (car binding-code) cte))
                             ,(compile (cadr binding-code) cte)))
                         result)
                       keywords?))
                    (else
                      (loop
                        (cdr bindings)
                        (cons (##resolve-compile-local-binding binding cte) result)
                        keywords?)))))
               ((null? bindings)
                (##reverse result))
               (else
                (append (##reverse result) (##resolve-compile-local-binding bindings cte)))))

           #;(let loop ((bindings bindings))
             (cond
               ((pair? bindings)
                (let* ((binding (car bindings))
                       (binding-code (syntax-source-code binding)))
                  (cons
                    (cond
                      ((member binding-code
                               `(#!optional #!key #!rest))
                       binding)
                      ((pair? binding-code)
                       (syntax-source-code-set binding
                         `(,(##resolve-compile-local-binding (car binding-code) cte)
                           ,(compile (cadr binding-code) cte))))
                      (else
                        (##resolve-compile-local-binding binding cte)))
                    (loop (cdr bindings)))))
               ((null? bindings)
                bindings)
               (else
                (##resolve-compile-local-binding bindings cte)))))))))


  (match-source stx ()
    ((lambda-id args . body)
     (syntax-source-code-set stx
       `(,lambda-id ,(compile-lambda-bindings args cte)
                    ,@(##compile-body body cte))))))

(define-prim&proc (compile-let-forms stx cte)
  (match-source stx ()
    ((let-id id bindings . body) when (identifier? id)
     (let ((compiled-let 
             (##compile-let-forms 
               (syntax-source-code-set stx
                 `(,let-id ,bindings ,@body))
               cte))
           (id (##compile-identifier id cte)))
       (match-source compiled-let ()
         ((let-id bindings . body)
          (syntax-source-code-set stx
           `(,let-id ,id ,bindings ,@body))))))
    ((let-id bindings . body)
     (let ((bindings 
             (syntax-source-code-update bindings
               (lambda (bindings)
                 (let loop ((bindings bindings))
                   (match-source bindings ()
                     ((binding @ (id val) . bindings)
                      (let ((compiled-id 
                              (cond
                                ((or (pair? (syntax-source-code id))
                                     (list? (syntax-source-code id)))
                                 (syntax-source-code-update id
                                   (lambda (ids)
                                     (let loop-ids ((ids ids))
                                       (cond
                                         ((pair? ids)
                                          (cons (##compile-identifier (car ids) cte)
                                                (loop-ids (cdr ids))))
                                         ((null? ids)
                                          ids)
                                         (else
                                          (##compile-identifier ids cte)))))))
                                (else
                                 (##compile-identifier id cte)))))
                      (cons
                        (syntax-source-code-set binding
                          `(,compiled-id
                            ,(##compile val cte)))
                        (loop bindings))))
                     (_
                      bindings))))))
           (body (##compile-body body cte)))
       (syntax-source-code-set stx
         `(,let-id ,bindings ,@body))))))

(define-prim&proc (compile-quote stx cte)
  stx)

(define-prim&proc (compile-quote-syntax stx cte)
  (match-source stx ()
    ((quote-syntax-id expr)
     (syntax-source-code-set stx
       `(,(syntax-source-code-set stx '##quote)
         ,(syntax-source-code-set stx expr))))))

(define-prim&proc (compile-syntax stx cte)
  (##compile-quote-syntax stx cte))

(define-prim&proc (compile-define stx cte)

  (define (resolve-maybe-local-binding id cte)
    (match-source id (#!optional #!key #!rest)
     (#!optional id)
     (#!key id)
     (#!rest id)
     ((id-id val-id)
      (syntax-source-code-set id
        `(,(##resolve-compile-local-binding id-id cte)
           ,(##compile val-id cte))))
     (else
      (let ((core? (##resolve-compile-core-binding? id cte)))
        (if core? 
            (syntax-source-code-set id core?)
            ; id could be local as local definitions 
            ; still appears in this phase
            (##resolve-compile-local-binding id cte))))))

  (define (resolve-maybe-local-bindings ids cte)
    (cond
      ((pair? ids)
       (cons (resolve-maybe-local-binding (car ids) cte)
             (resolve-maybe-local-bindings (cdr ids) cte)))
      ((null? ids)
       ids)
      (else
       (resolve-maybe-local-binding ids cte))))

  (syntax-source-code-set stx
    (match-source stx ()
      ((define-id binding @ (id . args) . body)
       (let ((id   (resolve-maybe-local-binding id cte))
             (args (resolve-maybe-local-bindings args cte))
             (body (##compile-body body cte)))
         `(,define-id ,(syntax-source-code-set binding 
                                               (cons id args)) ,@body)))
      ((define-id id expr)
       (let ((id   (resolve-maybe-local-binding id cte))
             (expr (##compile expr cte)))
         `(,define-id ,id ,expr))))))

;;;----------------------------------------------------------------------------

(define-prim (##compile-core-form-application id stx cte)

  (define (dispatch-core-form-id id)
    (case (syntax-source-code 
            (##compile-identifier id cte))
      ((##lambda)         ##compile-lambda)
      ((##let
        ##let*
        ##letrec
        ##letrec*
        ##let-values
        ##let*-values
        ##letrec-values
        ##letrec*-values) ##compile-let-forms)
      ((##define)         ##compile-define)
      ((##quote                           
        quote)            ##compile-quote)
      ((##quote-syntax)   ##compile-quote-syntax)
      ((quote-syntax)     ##compile-quote-syntax)
      ((##syntax)         ##compile-syntax)
      ((##case)           ##compile-case)
      ((##begin
        ##include
        ##if)             ##compile-application)
      (else               ##compile-application)))

   ((dispatch-core-form-id id) stx cte))

;;;----------------------------------------------------------------------------

(define-prim&proc (compile-case stx cte)

  (define (compile-clauses clauses cte)
    (cond
      ((pair? clauses)
       (let ((clause (car clauses))
             (clauses (cdr clauses)))
         (cons
           (match-source clause ()
             ((id val)
              (syntax-source-code-set clause
                `(,id ,(compile val cte)))))
           (compile-clauses clauses cte))))
      ((null? clauses)
       clauses)
      (else
        (error "ill formed case clause"))))

  (match-source stx (else)
    ((case-id expr . clauses)
     (let ((expr (compile expr cte))
           (clauses (compile-clauses clauses cte)))
       (syntax-source-code-set stx
         `(,case-id ,expr ,@clauses))))))

;;;----------------------------------------------------------------------------

(define-prim&proc (compile-namespace stx cte)
  stx)

;;;----------------------------------------------------------------------------

(define-prim&proc (compile stx cte)
  (let ((code (syntax-source-code stx)))
    (cond
      ((pair? code)
       (let ((head (car code)))
         (cond
           ((identifier? head)
            (##compile-core-form-application head stx cte))
           (else
            (##compile-application stx cte)))))
      ((identifier? stx)
       (##compile-identifier stx cte))
      ((keyword? (syntax-source-code stx))
       (##compile-keyword-argument stx cte))
      (else
       stx))))

;;;============================================================================
