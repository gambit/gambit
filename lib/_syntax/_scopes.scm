;;;============================================================================

;;; File: "_scopes.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

;;;============================================================================
;;;----------------------------------------------------------------------------
;; Scope

;; A scope is a comparable address in memory.
;; TODO: change representation to handle serialization.

(define-type scope
  type-exhibitor: type-scope
  constructor:    make-scope)

(define (##fail-check-scope arg-id proc . args)
  (##raise-type-exception
   arg-id
   (type-scope)
   proc
   args))

(define-check-type scope (type-scope)
  scope?)

(define ##core-scope (make-scope))
(define core-scope ##core-scope)

;;;----------------------------------------------------------------------------
;;; set of scopes

;(implement-hash-set-hamt)

(define-prim&proc (make-scopes . args)
  (##apply ##make-hash-set-hamt args))

(define (##fail-check-scopes arg-id proc . args)
  (##raise-type-exception
   arg-id
   #!void 
   proc
   args))

(define-check-type scopes (type-scope)
  ##hash-set-hamt?)

(define-prim&proc (scopes->list (scps scopes))
  (##map ##car (##hash-set-hamt->list scps)))

(define-prim&proc (scopes-insert (scps scopes) (scp scope))
  (##hash-set-hamt-set scps scp #!void))

(define-prim&proc (scopes-remove (scps scopes) (scp scope))
  (let ((res (##hash-set-hamt-remove scps scp)))
    res))

(define-prim&proc (scopes-ref (scps scopes) (scp scope))
  (##hash-set-hamt-ref scps scp))

(define-prim&proc (scopes-xor (scps scopes) (scp scope))
  (if (##scopes-ref scps scp)
      (##scopes-remove scps scp)
      (##scopes-insert scps scp)))

(define-prim&proc (scopes-subset? (scps1 scopes) (scps2 scopes))
  (##hash-set-hamt-subset? scps1 scps2))

(define-prim&proc (scopes-equal? obj1 obj2)
  (##hash-set-hamt-equal? obj1 obj2))
  
;;;============================================================================
