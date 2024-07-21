;;;============================================================================

;;; File: "_henv.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================
;;;============================================================================
;;; Hygiene compilation time environement
;;;
;;; overload basic interpreter cte's operation for hygiene support
;;;
;;;============================================================================

(##include "../../gsc/_env-def.scm")

;;;----------------------------------------------------------------------------

(define-prim&proc (henv-local-cte cte)
  cte)

(define-prim&proc (henv-global-name cte id)
  ; TODO
  (##syntax-source-code id))

(define-prim&proc (henv-top? cte)
  (not (env-parent-ref cte)))


(define-prim&proc (henv-top-cte cte)
  cte)

(define-prim&proc (henv-top-cte-global-binding-table cte)
  (env-syntax-gbt-ref cte))


(define-prim&proc (henv-top-cte-global-binding-table-ref cte id)
  ;; TODO
  (env-syntax-gbt-gbt-ref cte id))


(define-prim&proc (henv-ctx-ref cte key)
  (##syntax-ctx-ref (env-syntax-ctx-ref cte) key))


(define-prim&proc (henv-add-new-local-binding! cte id)  
  (let* ((key     (gensym (##syntax-source-code id)))
         (binding (##binding-local key)))
    (env-syntax-gbt-gbt-set! cte (##vector-copy id) binding)
    key))


(define-prim&proc (henv-add-new-top-level-binding! cte id)
  (let* ((key (##syntax-source-code id))
         (binding (##binding-top-level key)))
    (env-syntax-gbt-gbt-set! cte (##vector-copy id) binding)
    key))

(define-prim&proc (henv-add-variable-cte cte key id)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-frame cte (list (##source-code id))
      (lambda (ctx)
        (##syntax-ctx-set 
         ctx 
         key 
         (##ctx-binding-variable id))))))

(define-prim&proc (henv-add-macro-cte cte key id descr)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-macro cte (##source-code id) descr
      (lambda (ctx)
        (##syntax-ctx-set
         ctx
         key 
         (##ctx-binding-macro id descr))))))

(define-prim&proc (top-henv-add-macro-cte! cte id descr)
                  ; TODO global id
  (let ((key (##henv-add-new-top-level-binding! cte id)))
    (env-macro cte (##source-code id) descr
      (lambda (ctx)
        (##syntax-ctx-set
         ctx
         key 
         (##ctx-binding-macro id descr))))))

(define-prim&proc (henv-add-core-macro-cte cte key id descr)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-macro cte (##source-code id) descr
      (lambda (ctx)
               (##syntax-ctx-set
                ctx
                key 
                (##ctx-binding-core-macro id descr))))))

(define-prim&proc (top-henv-add-core-macro-cte! cte id descr)
  (let ((key (##henv-add-new-top-level-binding! cte id)))
    (env-core-macro cte (##source-code id) descr
      (lambda (ctx)
               (##syntax-ctx-set
                ctx
                key 
                (##ctx-binding-core-macro id descr))))))

(define-prim&proc (henv-process-namespace cte expr)
  (env-namespace cte expr))

(define-prim&proc (top-henv-process-namespace! cte expr)
  (env-namespace cte expr))

