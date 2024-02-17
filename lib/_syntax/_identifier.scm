;;;============================================================================

;;; File: "_identifier.scm"

;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.
;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(define-prim&proc (identifier? obj)
  (and (syntax-source? obj)
       (symbol? (syntax-source-code obj))
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

(define (identifier-equal? id1 id2)
  (and (identifier? id1)
       (identifier? id2)
       (scopes-equal? (syntax-source-scopes id1)
                      (syntax-source-scopes id2))))


(define-prim&proc (bound-identifier=? id1 id2)
  ;;; r6rs
  ;;; 
  (and (##identifier? id1)
       (##identifier? id2)
       (##equal? (##syntax-source-code id1)
                 (##syntax-source-code id2))
       (##scopes-equal? (##syntax-source-scopes id1)
                        (##syntax-source-scopes id2))))

(define-prim&proc (free-identifier=? id1 id2)
  ;;; r6rs
  ;;;
  (and (##identifier? id1)
       (##identifier? id2)
       (##equal? (##syntax-source-code id1)
                 (##syntax-source-code id2))
       (##equal?(##resolve-id id1 ##syntax-interaction-cte)
                (##resolve-id id2 ##syntax-interaction-cte))))

(define-prim&proc (free-identifier-member? id1 ids)
  (and (##identifier? id1)                
       (let loop ((ids ids)
                  (sym-id1 (##syntax-source-code id1))
                  (resolved-id1 #f))
         (cond
           ((pair? ids)
            (let ((id2 (car ids))
                  (ids (cdr ids)))
              (if (and (##identifier? id2)
                       (equal? sym-id1 
                               (syntax-source-code id2)))
                  (let ((resolved-id1 
                          (or resolved-id1
                              (##resolve-id 
                                id1 
                                ##syntax-interaction-cte)))
                        (resolved-id2 
                          (##resolve-id 
                            id2 
                            ##syntax-interaction-cte)))
                    (or (##equal? resolved-id1 resolved-id2)
                        (loop ids resolved-id1)))
                  (loop ids resolved-id1))))))))

;;;============================================================================
