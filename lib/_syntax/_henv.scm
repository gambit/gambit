
(define-prim&proc (henv-local-cte cte)
  cte)

(define-prim&proc (henv-global-name cte id)
  ; TODO
  (##syntax-source-code id))

(define-prim&proc (henv-top? cte)
  (not (c#env-parent-ref cte)))

(define-prim&proc (henv-top-cte cte)
  cte)

(define-prim&proc (henv-top-cte-global-binding-table cte)
  (c#env-syntax-gbt-ref cte))

(define-prim&proc (henv-top-cte-global-binding-table-ref cte id)
  ;; TODO
  (c#env-syntax-gbt-ref cte))

(define-prim&proc (henv-ctx-ref cte key)
  (##syntax-ctx-ref (c#env-syntax-ctx-ref cte) key))

(define-prim&proc (henv-add-new-local-binding! cte id)  
  (let* ((key     (gensym (##syntax-source-code id)))
         (binding (##binding-local key)))
    (c#env-syntax-gbt-set! cte (##vector-copy id) binding)
    key))


(define-prim&proc (henv-add-new-top-level-binding! cte id)
  (let* ((key (##syntax-source-code id))
         (binding (##binding-top-level key)))
    (c#env-syntax-gbt-set! cte (##vector-copy id) binding)
    key))

(define-prim&proc (henv-add-variable-cte cte key id)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-frame cte (list key)
      (lambda (ctx)
        (##syntax-ctx-set 
         ctx 
         key 
         (##ctx-binding-variable id))))))

(define-prim&proc (henv-add-macro-cte cte key id descr)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-macro cte key descr
      (lambda (ctx)
        (##syntax-ctx-set
         ctx
         key 
         (##ctx-binding-macro id descr))))))

(define-prim&proc (top-henv-add-macro-cte! cte id descr)
                  ; TODO global id
  (let ((key (##henv-add-new-top-level-binding! cte id)))
    (env-macro cte key descr
      (lambda (ctx)
        (##syntax-ctx-set
         ctx
         key 
         (##ctx-binding-macro id descr))))))

(define-prim&proc (henv-add-core-macro-cte cte key id descr)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-macro cte key descr
      (lambda (ctx)
               (##syntax-ctx-set
                ctx
                key 
                (##ctx-binding-core-macro id descr))))))

(define-prim&proc (top-henv-add-core-macro-cte! cte id descr)
                  ; TODO global id
  (let ((key (##henv-add-new-top-level-binding! cte id)))
    (env-core-macro cte key descr
      (lambda (ctx)
               (##syntax-ctx-set
                ctx
                key 
                (##ctx-binding-core-macro id descr))))))


(define-prim&proc (henv-process-namespace cte expr)
  (add-namespace expr cte))

(define-prim&proc (top-henv-process-namespace! cte expr)
  (add-namespace expr cte))

;*** WARNING IN "/home/unquotequote/Projects/gambit-repo/gsc/../lib/_syntax/_henv.scm"@10.9 -- "c#env-parent-ref" is not define
;*** WARNING IN "/home/unquotequote/Projects/gambit-repo/gsc/../lib/_syntax/_henv.scm"@19.4 -- "c#env-syntax-gbt-ref" is not define
;*** WARNING IN "/home/unquotequote/Projects/gambit-repo/gsc/../lib/_syntax/_henv.scm"@26.22 -- "c#env-syntax-ctx-ref" is not defed
;*** WARNING IN "/home/unquotequote/Projects/gambit-repo/gsc/../lib/_syntax/_henv.scm"@38.6 -- "c#env-syntax-gbt-set!" is not defin
;*** WARNING IN "/home/unquotequote/Projects/gambit-repo/gsc/../lib/_syntax/_henv.scm"@81.6 -- "c#env-core-macro" is not defined


