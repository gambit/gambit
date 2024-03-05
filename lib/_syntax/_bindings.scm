;;;============================================================================

;;; File: "_bindings.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

;; ------------------------------------
;; top level binding

(define-prim (##binding-top-level sym)
  (##vector sym))

(define-prim (##binding-top-level? b)
  (and (##vector? b)
       (##fx= (##vector-length b) 1)))

(define-prim (##binding-top-level-symbol b)
  (##vector-ref b 0))

(define-prim (##binding-local key)
  (##vector key #f))

(define-prim (##binding-local? b)
  (and (##vector? b)
       (##fx= (##vector-length b) 2)))

(define-prim (##binding-local-key b)
  (##vector-ref b 0))

(define-prim (##binding? obj)
  (or (##binding-local? obj)
      (##binding-top-level? obj)))

;;;----------------------------------------------------------------------------
;;; ctx bindings

(define-prim&proc (fail-check-binding arg-id proc . args)
  (##raise-type-exception
   arg-id
   (vector)
   proc
   args))

  (define-check-type binding (vector)
    ##binding?)

;;;----------------------------------------------------------------------------
;;; resolve

(define-prim&proc (resolve-id (id identifier) cte)

  (define (find-all-matching-bindings id)
    (let* ((id-identifier (##syntax-source-code id))
           (id-scopes     (##syntax-source-scopes id)))
      (##table-foldl 
        (lambda (base next) 
          (if next
              (##cons next base)
              base))
        '()
        (lambda (candidate-id _)
          (if (and (##eq? (##syntax-source-code candidate-id)
                          id-identifier)
                   (##scopes-subset?
                         (syntax-source-scopes candidate-id)
                         id-scopes))
              candidate-id
              #f))
       (##cte-top-cte-global-binding-table cte))))

  (define (check-unambiguous max-id candidate-ids)
    (or (##null? candidate-ids)
        (if (##scopes-subset?
              (##syntax-source-scopes (##car candidate-ids))
              (##syntax-source-scopes max-id))
            (check-unambiguous max-id (##cdr candidate-ids))
            (##error "syntax: ambiguous binding"))))

  (define (argmax thunk lst #!optional (cmp ##fx>))
    (if (##pair? lst)
        (let loop ((max     (thunk (##car lst)))
                   (arg-max (##car lst))
                   (lst     (##cdr lst)))
          (if (##pair? lst)
              (let* ((arg (##car lst))
                     (arg-val (thunk arg)))
                (if (cmp arg-val max)
                    (loop arg-val arg (##cdr lst))
                    (loop max arg-max (##cdr lst))))
              arg-max))
        (##error "argmax : argument must be a non-empty list")))
    
  (let ((candidate-ids (find-all-matching-bindings id)))
    (and (##pair? candidate-ids)
         (let ((max-id (argmax
                         (lambda (candidate-id)
                           (##hash-set-hamt-length 
                             (##syntax-source-scopes candidate-id)))
                         candidate-ids)))
           (check-unambiguous max-id candidate-ids)
           (##cte-top-cte-global-binding-table-ref cte max-id)))))

(define-prim&proc (resolve-global id cte) ; TODO
  ; at top level, rename identifier according to namespace
  (let ((full-name-id
          (##syntax-full-name cte id)
          #;(##hcte-namespace-lookup cte id)))
    (and full-name-id
         (##resolve-id full-name-id cte))))

(define-prim&proc (resolve-local id cte)
  ; in local ctx, try resolving the "plain" identifier
  ; before renaming according to namespace in scope.
  (or (##resolve-id id cte)
      (##resolve-global id cte)))

;;;============================================================================
