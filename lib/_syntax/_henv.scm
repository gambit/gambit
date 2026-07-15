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
  #t 
  ; the difference is irrelevant here as the global-binding-table and syntax contex
  ; will keep track of definitions/macro-definitions scope.
  #;(not (env-parent-ref cte)))


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
  (let* ((name    (##syntax-source-code id))
         (key     (gensym name))
         (binding (##binding-local key)))
    (##hygiene-record-source-name! key name)
    (env-syntax-gbt-gbt-set! cte (##vector-copy id) binding)
    key))

(define-prim&proc (henv-add-local-binding-with-key! cte id key)
  (let ((binding (##binding-local key)))
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
  ;; A top-level macro is resolved through the ctx HAMT (see henv-ctx-ref), not
  ;; the frame chain, and c#env-lookup ignores the macro slot -- so we only need
  ;; to register the binding and record it in the ctx.  We do NOT chain a fresh
  ;; frame per macro: that added thousands of vars-less frames (one per imported
  ;; runtime macro) that c#env-lookup then walked on every reference.
  (let ((key (##henv-add-new-top-level-binding! cte id)))
    (env-syntax-ctx-set! cte
      (##syntax-ctx-set (env-syntax-ctx-ref cte)
                        key
                        (##ctx-binding-macro id descr)))
    cte))


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

(define-prim (##macro-descr->syntax-transformer descr)
  (if (##macro-descr-def-syntax? descr)
      (##vector-set descr 2
        (lambda (s)
          (##datum->core-syntax
            (##syntax->datum
              ((##vector-ref descr 2) s))
            (##car (##source-code s)))))
      (##vector-set descr 2
        (lambda (s)
          (##datum->core-syntax
            (##syntax->datum
              (##apply (##vector-ref descr 2)
                       (##cdr (##syntax->datum s))))
            (##car (##source-code s)))))))

(define-prim (##henv-import-interaction-cte-macros! env cte convert)
  (let loop ((cte cte) (env env))
    (if (##cte-top? cte)
        env
        (let ((parent-cte (##cte-parent-cte cte)))
          (cond
            ((##cte-macro? cte)
             (loop parent-cte
                   (##top-henv-add-macro-cte!
                     env
                     (##make-core-syntax-source (##cte-macro-name cte) #f)
                     (convert (##cte-macro-descr cte)))))
            ((##cte-core-macro? cte)
             (loop parent-cte
                   (##top-henv-add-core-macro-cte!
                     env
                     (##make-core-syntax-source (##cte-macro-name cte) #f)
                     (##cte-macro-descr cte))))
            (else
             (loop parent-cte env)))))))

;; TODO undivise interaction environments
(define-prim&proc (henv-import-runtime-macros env)
  (##henv-import-interaction-cte-macros!
    (##henv-import-interaction-cte-macros!
      env
      (##top-cte-cte ##interaction-cte)
      ##macro-descr->syntax-transformer)
    (##top-cte-cte ##syntax-interaction-cte)
    (lambda (descr) descr)))

