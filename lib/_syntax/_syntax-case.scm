;;;============================================================================

;;; File: "_syntax-case.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

; TODO: shouldn't be used
(define (get-last-pair code)
  (cond ((pair? code)
         (cdr code))
        (else code)))

;;; ---------------------------------------------------------------------------

(define (##make-syntax-case-binding lvl var value)
  (list lvl var value))

(define (##syntax-case-binding-level binding)
  (car binding))

(define (##syntax-case-binding-var binding)
  (cadr binding))

(define (##syntax-case-binding-value binding)
  (caddr binding))

(define (##syntax-case-binding-combine bindings-list)

  (if (or (not (list? bindings-list))
          (and (list? bindings-list) (= (length bindings-list) 0)))
      (error "internal: ill formed bindings (combine bindings)"))

  (apply
    ##map
    (lambda bindings
      (let ((var (##syntax-case-binding-var (car bindings)))
            (level (##syntax-case-binding-level (car bindings)))
            (binding-value (##map ##syntax-case-binding-value bindings)))
        (##make-syntax-case-binding (fx+ level 1) var binding-value)))
    bindings-list))
        

(define (##syntax-case-binding-lookup bindings id)
  (let ((r (assoc id (##map cdr bindings))))
    (if r 
        (cadr r)
        (##error "syntax-case: internal not found binding"))))

;;;----------------------------------------------------------------------------

(define (expand-clause-expr bindings-level bindings expr)
  ; transform expression

  (define (expand-constructor-update lvl e-lvl e c-lvl c)
    (cond
      ((and (= e-lvl 0)
            (= c-lvl 0))
       (list c-lvl
             `(append ,c (list ,e))))
      ((and (= e-lvl 1)
            (= c-lvl 0)
            (= lvl 0))
       (list c-lvl
             `(append ,c ,e)))
      ((and (= e-lvl 0)
            (> c-lvl 0)
            (> lvl 0))
       (list c-lvl
             `(##map (lambda (c)
                     ,(cadr (expand-constructor-update (- lvl 1) e-lvl e (- c-lvl 1) c)))
                   ,c)))
      ((and (> e-lvl 0)
            (= c-lvl 0)
            (> lvl 0))
       (list (+ c-lvl 1)
             `(##map (lambda (e)
                    ,(cadr (expand-constructor-update (- lvl 1) (- e-lvl 1) 'e c-lvl c)))
                  ,e)))
      ((and (> e-lvl 0)
            (> c-lvl 0)
            (> lvl 0))
       (list c-lvl
             `(##map (lambda (c e)
                    ,(cadr (expand-constructor-update (- lvl 1) (- e-lvl 1) 'e (- c-lvl 1) 'c)))
                  ,c
                  ,e)))
      (else
       (pp e-lvl) 
       (pp c-lvl) 
       (pp lvl)
       (error "syntax-case: wrong template level"))))
  
  (define (expand-clause-expr-syntax-list bindings lvl exprs)
    (let loop ((lvl   lvl)
               (c-lvl 0)
               (c     '(list))
               (exprs exprs))
      (match-source exprs (...)
         ((e ...)
          (let* ((lvl+elem (expand-clause-expr-syntax-expr bindings (+ lvl 1) e #f))
                 (e-lvl    (car lvl+elem))
                 (e        (cadr lvl+elem)))
            (expand-constructor-update lvl e-lvl e c-lvl c)))
         ((e ... . rst)
          (let* ((lvl+elem (expand-clause-expr-syntax-expr bindings (+ lvl 1) e #f))
                 (e-lvl    (car lvl+elem))
                 (e        (cadr lvl+elem)))
            (let* ((lvl+new-constructor (expand-constructor-update lvl e-lvl e c-lvl c))
                   (c-lvl               (car lvl+new-constructor))
                   (c                   (cadr lvl+new-constructor)))
              (loop lvl c-lvl c rst))))
         ((e . rst)
          (let* ((lvl+elem (expand-clause-expr-syntax-expr bindings lvl e #f))
                 (e-lvl    (car lvl+elem))
                 (e        (cadr lvl+elem)))
            (let* ((lvl+new-constructor (expand-constructor-update lvl e-lvl e c-lvl c))
                   (c-lvl               (car lvl+new-constructor))
                   (c                   (cadr lvl+new-constructor)))
              (loop lvl c-lvl c rst))))
         (()
          (list c-lvl c))
         (rst
           (let* ((lvl+elem (expand-clause-expr-syntax-expr bindings lvl rst #t))
                  (e-lvl    (car lvl+elem))
                  (e        (cadr lvl+elem)))
             (expand-constructor-update lvl (fx+ e-lvl 1) e c-lvl c))))))

  (define (expand-clause-expr-syntax-expr bindings lvl expr is-tail?)
    (let ((code (syntax-source-code expr)))
      (cond
        ((pair? code)
         (expand-clause-expr-syntax-list bindings lvl code))
        ((assoc code bindings-level) =>
         (lambda (id+lvl) 
           (list
             (cadr id+lvl)
               `(let ((lookup-result (##syntax-case-binding-lookup ,bindings ',expr)))
                  (or (and ,is-tail? 
                           (syntax-source? lookup-result)
                           (let ((lookup-result-code (##syntax-source-code lookup-result)))
                             (and (or (null? lookup-result-code)
                                      (pair? lookup-result-code))
                               lookup-result-code)))
                      lookup-result)))))
        ((null? code)
         (list 0 `',code))
        (else
          (list
            0
           `(,(##make-core-syntax-source '##syntax #f) ,expr))))))

  (match-source expr (##syntax syntax)
    ((syntax syntax-expr)
     (expand-clause-expr bindings-level
                         bindings 
                         (syntax-source-code-set expr 
                           `(,(##make-core-syntax-source '##syntax #f) ,syntax-expr))))
    ((##syntax syntax-expr)
    `(datum->core-syntax ,(cadr (expand-clause-expr-syntax-expr bindings 0 syntax-expr #f)) 
                               (##syntax ,syntax-expr)))
    ((_ . _)
     (let loop ((exprs (syntax-source-code expr)))
       (cond
         ((pair? exprs)
          (cons (expand-clause-expr bindings-level bindings (car exprs))
                (loop (cdr exprs))))
         ((null? exprs)
          exprs)
         (else
          (expand-clause-expr bindings-level bindings exprs)))))
    (_
      expr)))

;;;----------------------------------------------------------------------------

(define (expand-clause-cond-compile-bindings literals condition)
  ; get bindings' level at compile time

  (match-source condition (...)
    ((var ... . rst)
     (append (##map (lambda (b)
                    (list (car b)
                          (fx+ (cadr b) 1)))
                  (expand-clause-cond-compile-bindings literals var))
             (expand-clause-cond-compile-bindings literals rst)))
    ((var . rst)
     (append (expand-clause-cond-compile-bindings literals var)
             (expand-clause-cond-compile-bindings literals rst)))
    (id when (and (identifier? id)
                  (not (member (syntax-source-code id) literals)))
     (list (list (syntax-source-code id) 0)))
    (else
     (list))))

;;;----------------------------------------------------------------------------

(define (expand-clause-cond literals condition expr)
  ; match expression and get bindings at exec time

  (define (expand-clause-cond-ellipsis literals condition exprs)
    `(if (null? ,exprs)
         (list
           (##make-syntax-case-binding 
             1 
             ',condition
             (list)))
         (and (list? ,exprs)
              (##syntax-case-binding-combine 
                 (##map 
                   (lambda (expr)
                     ,(expand-clause-cond 
                        literals 
                        condition 
                        'expr))
                   (##reverse (##reverse ,exprs)))))))

  (define (expand-clause-cond-list literals condition exprs)
    (match-source condition (...)
      ((var ...)
       (expand-clause-cond-ellipsis literals var exprs))
      ((var ... . rest) ;when (not (pair? rest))
       `(let ((bindings ,(expand-clause-cond-ellipsis literals var exprs)))
          (and bindings
               (let ((rest-binding
                       ,(expand-clause-cond-list literals
                                                 rest 
                                                 `(get-last-pair ,exprs))))
                   (and rest-binding
                        (append bindings rest-binding))))))
      ((cond-head . cond-tail)
       (let ((head-id (gensym 'head))
             (tail-id (gensym 'tail)))
       `(cond
            ((pair? ,exprs)
             (let ((,head-id ,(expand-clause-cond literals cond-head `(car ,exprs))))
               (and ,head-id
                    (let ((tail-id ,(expand-clause-cond-list literals cond-tail `(cdr ,exprs))))
                      (and tail-id
                           (append ,head-id tail-id))))))
          (else
            #f))))
      (()
       `(and (null? ,exprs)
             '()))

      (_
       (expand-clause-cond literals condition exprs))))

  (define (expand-clause-cond-identifier literals condition expr)
    `(let ((binding (##make-syntax-case-binding 0 ',condition ,expr)))
       (list binding)))

  (define (expand-clause-cond-literal literals condition expr)
    `(and (##free-identifier=? ,expr 
                               ,(##make-syntax-source condition #f))
          (list)))
  (match-source condition ()
   ((_ . _)
    (expand-clause-cond-list literals condition `(if (pair? ,expr) ,expr (syntax-source-code ,expr))))
   (()
    (expand-clause-cond-list literals condition `(if (pair? ,expr) ,expr (syntax-source-code ,expr))))
   (_ when (##identifier? condition)
    (if (member (##syntax-source-code condition) 
                (##map ##syntax-source-code literals))
        (expand-clause-cond-literal literals condition expr)
        (expand-clause-cond-identifier literals condition expr)))
   (_
    `(and (equal? (##syntax-source-code ,expr) ,condition) (list)))))

;;;----------------------------------------------------------------------------

(define (##expand-syntax-case s cte)
       
  (define (expand-clause literals stx-expr clause next)
    (match-source clause ()
      ((condition expr)
       (let ((bindings-id (gensym 'syntax-case-bindings)))
         `(let ((,bindings-id ,(expand-clause-cond literals condition stx-expr)))
            (cond
              ((pair? ,bindings-id)
               ,(expand-clause-expr (expand-clause-cond-compile-bindings literals condition)
                                    bindings-id 
                                    expr))
              ((not ,bindings-id)
               ,next)
              (else
               (error "syntax-case: internal ill formed bindings"))))))
      ((condition . exprs)
       (expand-clause 
         literals 
         stx-expr 
         (syntax-source-code-set clause
           `(,condition 
             ,(##make-syntax-source 
                `(,(##make-core-syntax-source '##begin #f)
                  ,@exprs)
                #f)))
         next))
      (_
       (error "syntax-case: ill formed clause"))))

  (define (expand-clauses literals stx-expr clauses)
    (cond
      ((pair? clauses)
       (let ((next (expand-clauses literals stx-expr (cdr clauses))))
         (expand-clause literals stx-expr (car clauses) next)))
      (else
       (datum->syntax `(error "syntax-case: no match" ,stx-expr)))))


  (match-source s ()
    ((syntax-case-id expr literals . clauses)
     (let ((expr-id (gensym 'syntax-case-expr)))
       (##expand
       (datum->core-syntax
         `((lambda (,expr-id) 
             ,(expand-clauses (syntax-source-code literals)
                              expr-id 
                              clauses))
           ,expr)
         s)
       cte)))
    (_
      (error "syntax-case: ill formed"))))

;;;============================================================================
