;;;============================================================================

;;; File: "_hcte.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================
;;; Hygiene compilation time environement
;;;
;;; overload basic interpreter cte's operation for hygiene support
;;;
;;;============================================================================
;;; cte type

(define-check-type cte ()
  (lambda (obj)
    (or (##cte-top? obj)
        (##cte-frame? obj)
        (##cte-macro? obj)
        (##cte-core-macro? obj)
        (##cte-namespace? obj)
        (##cte-decl? obj))))

(define (##fail-check-cte arg-id proc . args)
  (##raise-type-exception
   arg-id
   #!void
   proc
   args))

;;;----------------------------------------------------------------------------
;;; interface

(define-prim&proc (hcte-ctx-ref cte key . fail)
  (apply 
    ##cte-ctx-ref
      (or (and (##cte-top? cte) 
               (##cte-parent-cte cte))
          cte)
      key
      fail))
 
(define-prim&proc (hcte-top? cte)
  (##cte-top? cte))

(define-prim&proc (hcte-top-cte cte)
  (##cte-top-cte cte))

(define-prim&proc (hcte-top-cte-global-binding-table cte)
  (##cte-top-cte-global-binding-table cte))

(define-prim&proc (hcte-global-name cte id)
  (##cte-global-name (##hcte-local-cte cte)
                     (##syntax-source-code id)))

(define-prim&proc (hcte-top-cte-global-binding-table cte)
  (##cte-top-cte-global-binding-table cte))

(define-prim&proc (hcte-top-cte-global-binding-table-ref cte id)
  (##cte-top-cte-global-binding-table-ref cte id))

;;;----------------------------------------------------------------------------
;;; new bindings

(define-prim&proc (hcte-add-new-local-binding! (cte cte)
                                               (id identifier))
  ; add a new local binding to the global binding table.
  (let* ((key     (gensym (syntax-source-code id)))
         (binding (##binding-local key)))
    (##cte-top-global-binding-table-table-set! (##cte-top-cte cte)
      (identifier-copy id)
      binding)
    key))

(define-prim&proc (hcte-add-new-local-bindings! (cte cte) ids)
  (fold (lambda (id acc) 
          (cons (hcte-add-new-local-binding! cte id)
                acc))
        '()
        ids))

(define-prim&proc (hcte-add-new-top-level-binding! (cte cte)
                                                   (id identifier))
  ; add a new top level binding to the global binding table.
  ; the procedure assume that the identifier provided
  ; has already been renamed properly according to
  ; namespaces convention.
  (let* ((key    (syntax-source-code id))
         (binding (##binding-top-level key)))
    (##cte-top-global-binding-table-table-set! (##cte-top-cte cte)
      (identifier-copy id)
      binding)
    key))

(define-prim&proc (hcte-add-new-top-level-bindings! (cte cte) ids)
  (fold (lambda (acc id) 
          (cons (hcte-add-new-top-level-binding! cte id)
                acc))
        '()
        ids))

;;;----------------------------------------------------------------------------

(define-prim&proc (hcte-add-variable-cte cte key id)
  (let ((key (or key (hcte-add-new-local-binding! cte id))))
    (let ((cte (or (and (##cte-top? cte)
                        (##top-cte-cte cte))
                   ; top-level definitions begin at the top-cte's parent cte,
                   ; as the top-cte is used also as the tail sentinel.
                   cte)))
      (##cte-add-variable cte key
       (lambda (ctx)
         (##syntax-ctx-set 
          ctx 
          key 
          (##ctx-binding-variable id)))))))
 
(define-prim&proc (hcte-add-variables-cte cte keys ids)
  (cond
    ((pair? keys)
     (hcte-add-variables-cte 
       (hcte-add-variable-cte cte (car keys) (car ids))
       (cdr keys)
       (cdr ids)))
    (else
      cte)))

(define-prim&proc (hcte-add-macro-cte cte key id descr)
  (let ((key (or key (hcte-add-new-local-binding! cte id))))
    (let ((cte cte #;(or (and (##cte-top? cte)
                        (##top-cte-cte cte))
                   cte)))
      (##cte-add-macro cte key descr
       (lambda (ctx)
         (##syntax-ctx-set
          ctx
          key 
          (##ctx-binding-macro id descr)))))))

(define-prim&proc (hcte-add-macros-cte cte keys ids)
  (cond
    ((pair? keys)
     (hcte-add-macros-cte 
       (hcte-add-macro-cte cte (car keys) (car ids))
       (cdr keys)
       (cdr ids)))
    (else
      cte)))

(define-prim&proc (hcte-add-core-macro-cte cte key id descr)
  (let ((key (or key (hcte-add-new-local-binding! cte id))))
    (let ((cte cte #;(##hcte-local-cte cte)))
      (##cte-add-core-macro cte key descr
       (lambda (ctx)
         (##syntax-ctx-set
          ctx
          key 
          (##ctx-binding-core-macro id descr)))))))

(define-prim&proc (hcte-global-name cte id)
  (##cte-global-name 
    (##hcte-local-cte cte)
    (##syntax-source-code id)))

;;;----------------------------------------------------------------------------

(define-prim&proc (top-hcte-add-variable-cte! top-cte var)
  (let* ((global-id   (##cte-global-name top-cte var))
         (global-name (##syntax-source-code global-id))
         (key (hcte-add-new-top-level-binding! top-cte global-id))
         (ctx-binding (##ctx-binding-variable global-id)))
    (##top-cte-add-variable! top-cte global-name 
     (lambda (ctx)
       (##syntax-ctx-set ctx key ctx-binding)))))

(define-prim&proc (top-hcte-add-variables-cte! top-cte vars)
  (and (pair? vars)
       (top-hcte-add-variable-cte! top-cte (car vars))
       (top-hcte-add-variables-cte! top-cte (cdr vars))))

(define-prim&proc (top-hcte-add-macro-cte! top-cte id descr)
  (let* ((global-id   (##cte-global-name top-cte id))
         (global-name (##syntax-source-code global-id))
         (key (hcte-add-new-top-level-binding! top-cte global-id))
         (ctx-binding (##ctx-binding-macro global-id descr)))
    (##top-cte-add-macro! top-cte global-name descr
     (lambda (ctx)
       (##syntax-ctx-set ctx key ctx-binding)))))

(define-prim&proc (top-hcte-add-macros-cte! top-cte vars)
  (and (pair? vars)
       (top-hcte-add-macro-cte! top-cte (car vars))
       (top-hcte-add-macros-cte! top-cte (cdr vars))))

(define-prim&proc (top-hcte-add-core-macro-cte! top-cte id descr)
  (let* ((global-id   (##cte-global-name top-cte id))
         (global-name (##syntax-source-code global-id))
         (key (##hcte-add-new-top-level-binding! top-cte global-id))
         (ctx-binding (##ctx-binding-core-macro global-id descr)))
    (##top-cte-add-core-macro! top-cte global-name descr
      (lambda (ctx)
        (##syntax-ctx-set ctx key ctx-binding)))))

(define-prim&proc (hcte-mutate-core-macro-cte! cte name def)
  (let ((global-id (##cte-global-name cte name)))
    (##cte-mutate-core-macro! cte global-id def
     (lambda (ctx)
       (##syntax-ctx-set ctx 
          (##binding-top-level (##syntax-source-code global-id)) 
          (##ctx-binding-core-macro global-id def))))))

;;;----------------------------------------------------------------------------

(define-prim&proc (top-hcte-process-namespace! top-cte src)
  (##top-cte-process-namespace! top-cte src))

(define-prim&proc (hcte-process-namespace cte src)
  (let ((cte cte #;(if (##cte-top? cte) (##top-cte-cte cte) cte)))                  
    (##cte-process-namespace cte src)))

(define-prim&proc (hcte-namespace-lookup cte id)
  (let ((full-name 
          (##cte-namespace-lookup cte (##syntax-source-code id))))
    (and full-name
         (syntax-source-code-set id full-name))))

;;;----------------------------------------------------------------------------

(define-prim&proc (hcte-local-cte cte)
  (if (##cte-top? cte)
      (##top-cte-cte cte)
      cte))

;;;----------------------------------------------------------------------------

(define-prim (##macro-syntax-descr expander src)
  (if (##procedure? expander)
      (##make-macro-descr #t -1 expander src)
      (##raise-expression-parsing-exception
        'ill-formed-macro-transformer
        src)))

;;;============================================================================
