;;;============================================================================

;;; File: "_env-def.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================
;;;
;;; Expose compiler's environent primitive
;;;
;;;----------------------------------------------------------------------------

(define (env-frame env vars #!optional (syntax-proc-ctx identity))
  (vector
   ;; cell containing variables in this frame and an association between each
   (if env (env-syntax-gbt-ref env)
           (##make-syntax-global-binding-table))
   (syntax-proc-ctx
     (if env (env-syntax-ctx-ref env)
             (##make-syntax-ctx)))
   ;; symbol and it's namespace
   (cons vars #f)
   ;; macro definitions
   '()
   ;; declarations
   (if env (env-decl-ref env) '())
   ;; namespace
   '()
   ;; parent env
   env
   ;; externals. This field is only used in the global environment, but many
   ;; functional setter functions assume `make-global-environment` and
   ;; `env-frame` return the same shape of object.
   (if env (env-externals-ref env) (make-table))))

(define (env-macro env name def #!optional (syntax-proc-ctx identity))
  (env-macros-set env 
              (cons (cons name def) 
                    (env-macros-ref env))
              syntax-proc-ctx))

(define (env-core-macro env name def #!optional (syntax-proc-ctx identity))
  (env-macros-set env 
                  (cons (cons name def) 
                        (env-macros-ref env))
                  syntax-proc-ctx))


(define (env-macros-set env macro #!optional (syntax-proc-ctx identity))
  (vector (env-syntax-gbt-ref env)
          (syntax-proc-ctx (env-syntax-ctx-ref env))
          (vector-ref env 2)
          macro
          (env-decl-ref env)
          (env-namespace-ref env)
          (env-parent-ref env)
          (env-externals-ref env)))

(define (env-declare env d)
  (env-decl-set env (cons d (env-decl-ref env))))

(define (env-decl-set env decl)
  (vector (env-syntax-gbt-ref env)
          (env-syntax-ctx-ref env)
          (vector-ref env 2)
          (env-macros-ref env)
          decl
          (env-namespace-ref env)
          (env-parent-ref env)
          (env-externals-ref env)))

(define (env-namespace env n)
  (env-namespace-set env (cons n (env-namespace-ref env))))

(define (env-namespace-set env namespace)
  (vector (env-syntax-gbt-ref env)
          (env-syntax-ctx-ref env)
          (vector-ref env 2)
          (env-macros-ref env)
          (env-decl-ref env)
          namespace
          (env-parent-ref env)
          (env-externals-ref env)))

(define (env-syntax-gbt-ref env) (vector-ref env 0))

(define (env-syntax-gbt-gbt-ref env id) 
  (##syntax-global-binding-table-ref 
    (env-syntax-gbt-ref env)
    id))

(define (env-syntax-ctx-ref env) (vector-ref env 1))
(define (env-syntax-gbt-set! env) (vector-set! env 0))
(define (env-syntax-gbt-gbt-set! env id val) 
  (##syntax-global-binding-table-set!
    (env-syntax-gbt-ref env)
    id
    val))

(define (env-syntax-ctx-set! env ctx) (vector-set! env 1 ctx))

(define (env-ctx-set env ctx)
  (vector (env-syntax-gbt-ref env)
          ctx
          (vector-ref env 2)
          (env-macros-ref env)
          (env-decl-ref env)
          (env-namespace-ref env)
          (env-parent-ref env)
          (env-externals-ref env)))

(define (env-vars-ref env)              (car (vector-ref env 2)))
(define (env-vars-set! env vars)        (set-car! (vector-ref env 2) vars))
(define (env-macros-ref env)            (vector-ref env 3))
(define (env-decl-ref env)              (vector-ref env 4))
(define (env-namespace-ref env)         (vector-ref env 5))
(define (env-parent-ref env)            (vector-ref env 6))
(define (env-parent-set! env parent)    (vector-set! env 6 parent))
(define (env-externals-ref env)         (vector-ref env 7))

;;;============================================================================
