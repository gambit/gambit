;;;============================================================================

;;; File: "_identifier.scm"

;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define-prim&proc (identifier? obj)
  (and (##syntax-source? obj)
       (##symbol? (##syntax-source-code obj))
       obj))

(define (##fail-check-identifier arg-id proc . args)
  (##raise-type-exception
   arg-id
   #!void 
   proc
   args))

(define-check-type identifier (type-scope)
  identifier?)

(define-prim&proc (identifier-copy (id identifier))
  (##vector-copy id))

(define-prim&proc (identifier-equal? id1 id2)
  (and (##identifier? id1)
       (##syntax-source? id2)
       (##eq? (##syntax-source-code id1)
              (##syntax-source-code id2))
       (##scopes-equal? (##syntax-source-scopes id1)
                        (##syntax-source-scopes id2))))

(define-prim&proc (bound-identifier=? id1 id2)
  ;;; r6rs
  ;;; 
  (and (##identifier? id1)
       (##syntax-source? id2)
       (##eq? (##syntax-source-code id1)
              (##syntax-source-code id2))
       (##scopes-equal? (##syntax-source-scopes id1)
                        (##syntax-source-scopes id2))))

(define-prim&proc (free-identifier=? id1 id2)
  ;;; r6rs
  ;;;
  (and (##identifier? id1)
       (##syntax-source? id2)
       (##eq? (##syntax-source-code id1)
              (##syntax-source-code id2))
       (##eq?(##resolve-id id1 ##syntax-interaction-cte)
             (##resolve-id id2 ##syntax-interaction-cte))))

;;;============================================================================
