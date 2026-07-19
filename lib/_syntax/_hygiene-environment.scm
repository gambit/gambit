;;;============================================================================

;;; File: "_hygiene-environment.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================
;;;============================================================================
;;;
;;; Interface for hygienic environments.
;;; 
;;;============================================================================

(define-prim&proc (gsc-env? env)
  (and (##vector? env)
       (##fx> (##vector-length env) 1)
       (##table? (##vector-ref env 0))))

(define (##hygiene-environment-local-cte env . args)
  (apply (if (gsc-env? env) henv-local-cte hcte-local-cte) env args))

(define (##hygiene-environment-global-name env . args)
  (apply (if (gsc-env? env) henv-global-name hcte-global-name) env args))

(define (##hygiene-environment-top? env . args)
  (apply (if (gsc-env? env) henv-top? hcte-top?) env args))

(define (##hygiene-environment-top-cte env . args)
  (apply (if (gsc-env? env) henv-top-cte hcte-top-cte) env args))

(define (##hygiene-environment-macro-state-ref env . args)
  (apply (if (gsc-env? env) henv-macro-state-ref hcte-macro-state-ref) env args))

(define (##hygiene-environment-macro-state-restore! env . args)
  (apply (if (gsc-env? env) henv-macro-state-restore! hcte-macro-state-restore!) env args))

(define (##hygiene-environment-namespace-state-ref env . args)
  (apply (if (gsc-env? env) henv-namespace-state-ref hcte-namespace-state-ref) env args))

(define (##hygiene-environment-namespace-state-restore! env . args)
  (apply (if (gsc-env? env) henv-namespace-state-restore! hcte-namespace-state-restore!) env args))

(define (##hygiene-environment-top-cte-global-binding-table env . args)
  (apply (if (gsc-env? env) henv-top-cte-global-binding-table hcte-top-cte-global-binding-table) env args))

(define (##hygiene-environment-top-cte-global-binding-table-ref env . args)
  (apply (if (gsc-env? env) henv-top-cte-global-binding-table-ref hcte-top-cte-global-binding-table-ref) env args))

(define (##hygiene-environment-ctx-ref env . args)
  (apply (if (gsc-env? env) henv-ctx-ref hcte-ctx-ref) env args))

(define (##hygiene-environment-add-new-local-binding! env . args)
  (apply (if (gsc-env? env) henv-add-new-local-binding! hcte-add-new-local-binding!) env args))

(define (##hygiene-environment-add-local-binding-with-key! env . args)
  (apply (if (gsc-env? env) henv-add-local-binding-with-key! hcte-add-local-binding-with-key!) env args))

(define (##hygiene-environment-add-new-top-level-binding! env . args)
  (apply (if (gsc-env? env) henv-add-new-top-level-binding! hcte-add-new-top-level-binding!) env args))

(define (##hygiene-environment-add-variable-cte env . args)
  (apply (if (gsc-env? env) henv-add-variable-cte hcte-add-variable-cte) env args))

(define (##hygiene-environment-add-macro-cte env . args)
  (apply (if (gsc-env? env) henv-add-macro-cte hcte-add-macro-cte) env args))

(define (##hygiene-environment-add-core-macro-cte env . args)
  (apply (if (gsc-env? env) henv-add-core-macro-cte hcte-add-core-macro-cte) env args))

(define (##top-hygiene-environment-add-macro-cte! env . args)
  (apply (if (gsc-env? env) top-henv-add-macro-cte! top-hcte-add-macro-cte!) env args))

(define (##top-hygiene-environment-add-core-macro-cte! env . args)
  (apply (if (gsc-env? env) top-henv-add-core-macro-cte! top-hcte-add-core-macro-cte!) env args))

(define (##hygiene-environment-process-namespace env . args)
  (apply (if (gsc-env? env) henv-process-namespace hcte-process-namespace) env args))

(define (##top-hygiene-environment-process-namespace! env . args)
  (apply (if (gsc-env? env) top-henv-process-namespace! top-hcte-process-namespace!) env args))

;;;============================================================================
