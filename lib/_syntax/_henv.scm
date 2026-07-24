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

(##namespace ("##"
identity
env-frame
env-macro
env-core-macro
env-macros-set
env-declare
env-decl-set
env-namespace
env-namespace-set
env-namespace-set!
env-syntax-gbt-ref
env-syntax-gbt-gbt-ref
env-syntax-ctx-ref
env-syntax-gbt-set!
env-syntax-gbt-gbt-set!
env-syntax-ctx-set!
env-ctx-set
env-vars-ref
env-vars-set!
env-macros-ref
env-decl-ref
env-namespace-ref
env-parent-ref
env-parent-set!
env-externals-ref
henv-namespace-lookup
henv-namespace-forms->list))

(##include "../../gsc/_env-def.scm")

;;;----------------------------------------------------------------------------

(define-primitive (henv-local-cte cte)
  cte)

(define (env-namespace-set! env namespace) (##vector-set! env 5 namespace))

(define (henv-namespace-lookup env name)
  ; mirror of gsc's env-namespace-lookup, one env's slot 5 only.
  ; empty aliases = catch-all; non-empty = selective; #f on miss.
  (let loop ((lst (env-namespace-ref env)))
    (and (##pair? lst)
         (let* ((entry   (##car lst))
                (space   (##car entry))
                (aliases (##cdr entry)))
           (if (##null? aliases)
               (##make-full-name space name)
               (let ((a (##assq name aliases)))
                 (if a
                     (##make-full-name space (##cdr a))
                     (loop (##cdr lst)))))))))

(define-primitive (henv-global-name cte id)
  ; mirror of ##cte-global-name: already-qualified names pass through;
  ; else walk the parent chain, first hit wins; fall through to the BARE name.
  (let ((name (##syntax-source-code id)))
    (if (##full-name? name)
        name
        (let loop ((env cte))
          (if (##not env)
              name
              (or (henv-namespace-lookup env name)
                  (loop (env-parent-ref env))))))))

(define-primitive (henv-top? cte)
  #t
  ; the difference is irrelevant here as the global-binding-table and syntax
  ; context keep track of definitions/macro-definitions scope.
  #;(not (env-parent-ref cte)))


(define-primitive (henv-top-cte cte)
  cte)

(define-primitive (henv-macro-state-ref cte)
  (env-syntax-ctx-ref cte))

(define-primitive (henv-macro-state-restore! cte state)
  (env-syntax-ctx-set! cte state))

(define-primitive (henv-top-cte-global-binding-table cte)
  (env-syntax-gbt-ref cte))


(define-primitive (henv-top-cte-global-binding-table-ref cte id)
  ;; TODO
  (env-syntax-gbt-gbt-ref cte id))


(define-primitive (henv-ctx-ref cte key)
  (##syntax-ctx-ref (env-syntax-ctx-ref cte) key))


(define-primitive (henv-add-new-local-binding! cte id)
  (let* ((name    (##syntax-source-code id))
         (key     (gensym name))
         (binding (##binding-local key)))
    (##hygiene-record-source-name! key name)
    (env-syntax-gbt-gbt-set! cte (##vector-copy id) binding)
    key))

(define-primitive (henv-add-local-binding-with-key! cte id key)
  (let ((binding (##binding-local key)))
    (env-syntax-gbt-gbt-set! cte (##vector-copy id) binding)
    key))


(define-primitive (henv-add-new-top-level-binding! cte id)
  (let* ((key (##syntax-source-code id))
         (binding (##binding-top-level key)))
    (env-syntax-gbt-gbt-set! cte (##vector-copy id) binding)
    key))

(define-primitive (henv-add-variable-cte cte key id)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-frame cte (list (##source-code id))
      (lambda (ctx)
        (##syntax-ctx-set 
         ctx 
         key 
         (##ctx-binding-variable id))))))

(define-primitive (henv-add-macro-cte cte key id descr)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-macro cte (##source-code id) descr
      (lambda (ctx)
        (##syntax-ctx-set
         ctx
         key 
         (##ctx-binding-macro id descr))))))

(define-primitive (top-henv-add-macro-cte! cte id descr)
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


(define-primitive (henv-add-core-macro-cte cte key id descr)
  (let ((key (or key (##henv-add-new-local-binding! cte id))))
    (env-macro cte (##source-code id) descr
      (lambda (ctx)
               (##syntax-ctx-set
                ctx
                key 
                (##ctx-binding-core-macro id descr))))))

(define-primitive (top-henv-add-core-macro-cte! cte id descr)
  (let ((key (##henv-add-new-top-level-binding! cte id)))
    (env-core-macro cte (##source-code id) descr
      (lambda (ctx)
               (##syntax-ctx-set
                ctx
                key 
                (##ctx-binding-core-macro id descr))))))

(define (henv-namespace-forms->list expr)
  ; mirror of ##cte-process-namespace's parse: -> list of (space . ((from . to) ...))
  (##check-namespace expr)
  (##map (lambda (form)
           (##cons (##car form)
                   (##map (lambda (x)
                            (if (##symbol? x)
                                (##cons x x)
                                (##cons (##car x) (##cadr x))))
                          (##cdr form))))
         (##cdr (##desourcify expr))))

(define-primitive (henv-process-namespace cte expr)
  ; functional: caller (##expand-body-namespace) threads the result
  (let loop ((cte cte) (forms (henv-namespace-forms->list expr)))
    (if (##pair? forms)
        (loop (env-namespace cte (##car forms)) (##cdr forms))
        cte)))

(define-primitive (top-henv-process-namespace! cte expr)
  ; mutating: caller (expand-namespace) discards the result, and the top-level
  ; form sequence shares one cte with no accumulator to thread through.
  (let loop ((forms (henv-namespace-forms->list expr)))
    (if (##pair? forms)
        (begin
          (env-namespace-set! cte (##cons (##car forms) (env-namespace-ref cte)))
          (loop (##cdr forms)))
        cte)))

(define-primitive (henv-namespace-state-ref cte)
  (env-namespace-ref cte))

(define-primitive (henv-namespace-state-restore! cte state)
  (env-namespace-set! cte state))

(define-prim (##macro-descr->syntax-transformer descr)
  (if (##macro-descr-def-syntax? descr)
      (##vector-set descr 2
        (lambda (s)
          (##datum->core-syntax
            ((##vector-ref descr 2) s)
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
(define-primitive (henv-import-runtime-macros env)
  (##henv-import-interaction-cte-macros!
    (##henv-import-interaction-cte-macros!
      env
      (##top-cte-cte ##interaction-cte)
      ##macro-descr->syntax-transformer)
    (##top-cte-cte ##syntax-interaction-cte)
    (lambda (descr) descr)))

