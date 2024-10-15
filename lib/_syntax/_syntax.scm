;;;============================================================================

;;; File: "_syntax.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

;(##include "_syntax-error.scm")
(##include "_hygiene-environment.scm")
(##include "_scopes.scm")
(##include "_syntax-source.scm")
(##include "_source-match.scm")
(##include "_identifier.scm")
(##include "_bindings.scm")
(##include "_ctx-bindings.scm")
(##include "_hcte.scm")
(##include "_henv.scm")
(##include "_expand.scm")
(##include "_eval.scm")
(##include "_compile.scm")
(##include "_syntax-case.scm")


;;;============================================================================

(define-macro (##add-new-core-macro! name procedure)
  `(##top-hygiene-environment-add-core-macro-cte! ##syntax-interaction-cte 
                                 (add-scope 
                                   (##make-syntax-source ',name #f)
                                   core-scope)
                                 (##macro-syntax-descr ,procedure (##make-core-syntax-source ',name #f))))

(define-macro (##add-new-macro! name procedure)
  `(##top-hygiene-environment-add-macro-cte! ##syntax-interaction-cte 
                            (add-scope 
                              (##make-syntax-source ',name #f)
                              core-scope)
                            (##macro-syntax-descr ,procedure (##make-core-syntax-source ',name #f))))

;;;----------------------------------------------------------------------------

(define ##syntax-interaction-cte
  (let ((##syntax-interaction-cte (##make-top-cte)))

    (##add-new-macro! lambda
      (##make-alias-syntax '##lambda))

    (##add-new-macro! quote
      (##make-alias-syntax '##quote))

    (##add-new-macro! quote-syntax
      (##make-alias-syntax '##quote-syntax))

    (##add-new-macro! let
      (##make-alias-syntax '##let))

    (##add-new-macro! define
      (##make-alias-syntax '##define))

    (##add-new-macro! quasiquote
      (##make-alias-syntax '##quasiquote))

    (##add-new-macro! set!
      (##make-alias-syntax '##set!))

    (##add-new-macro! if
      (##make-alias-syntax '##if))

    (##add-new-macro! cond
      (##make-alias-syntax '##cond))

    (##add-new-macro! and
      (##make-alias-syntax '##and))

    (##add-new-macro! or
      (##make-alias-syntax '##or))

    (##add-new-macro! case
      (##make-alias-syntax '##case))

    (##add-new-macro! let-syntax
      (##make-alias-syntax '##let-syntax))

    (##add-new-macro! let*-syntax
      (##make-alias-syntax '##let*-syntax))

    (##add-new-macro! letrec-syntax
      (##make-alias-syntax '##letrec-syntax))

    (##add-new-macro! letrec*-syntax
      (##make-alias-syntax '##letrec*-syntax))

    (##add-new-macro! let*
      (##make-alias-syntax '##let*))

    (##add-new-macro! letrec
      (##make-alias-syntax '##letrec))

    (##add-new-macro! letrec*
      (##make-alias-syntax '##letrec*))

    (##add-new-macro! let-values
      (##make-alias-syntax '##let-values))

    (##add-new-macro! let*-values
      (##make-alias-syntax '##let*-values))

    (##add-new-macro! letrec-values
      (##make-alias-syntax '##letrec-values))

    (##add-new-macro! letrec*-values
      (##make-alias-syntax '##letrec*-values))

    (##add-new-macro! define-values
      (##make-alias-syntax '##define-values))

    (##add-new-macro! do
      (##make-alias-syntax '##do))

    (##add-new-macro! guard
      (##make-alias-syntax '##guard))

    (##add-new-macro! r7rs-guard
      (##make-alias-syntax '##r7rs-guard))

    (##add-new-macro! delay
      (##make-alias-syntax '##delay))

    (##add-new-macro! delay-force
      (##make-alias-syntax '##delay))

    (##add-new-macro! future
      (##make-alias-syntax '##future))

    (##add-new-macro! c-define-type
      (##make-alias-syntax '##c-define-type))

    (##add-new-macro! c-declare
      (##make-alias-syntax '##c-declare))

    (##add-new-macro! c-initialize
      (##make-alias-syntax '##c-initialize))

    (##add-new-macro! c-lambda
      (##make-alias-syntax '##c-lambda))

    (##add-new-macro! c-define
      (##make-alias-syntax '##c-define))

    (##add-new-macro! begin
      (##make-alias-syntax '##begin))

    (##add-new-macro! define-macro
      (##make-alias-syntax '##define-macro))

    (##add-new-macro! define-type
      (##make-alias-syntax '##define-type))

    (##add-new-macro! define-type-of-thread
      (##make-alias-syntax '##define-type-of-thread))

    (##add-new-macro! define-record-type
      (##make-alias-syntax '##define-record-type))

    (##add-new-macro! define-structure
      (##make-alias-syntax '##define-structure))

    (##add-new-macro! parameterize
      (##make-alias-syntax '##parameterize))

    (##add-new-macro! receive
      (##make-alias-syntax '##receive))

    (##add-new-macro! include
      (##make-alias-syntax '##include))

    (##add-new-macro! include-ci
      (##make-alias-syntax '##include-ci))

    (##add-new-macro! declare
      (##make-alias-syntax '##declare))

    (##add-new-macro! namespace
      (##make-alias-syntax '##namespace))

    (##add-new-macro! this-source-file
      (##make-alias-syntax '##this-source-file))

    (##add-new-macro! cond-expand
      (##make-alias-syntax '##cond-expand))

    (##add-new-macro! case-lambda
      (##make-alias-syntax '##case-lambda))

    (##add-new-macro! when
      (##make-alias-syntax '##when))

    (##add-new-macro! unless
      (##make-alias-syntax '##unless))

    (##add-new-macro! syntax-error
      (##make-alias-syntax '##syntax-error))

    (##add-new-macro! define-syntax
      (##make-alias-syntax '##define-syntax))

    (##add-new-macro! define-top-level-syntax
      (##make-alias-syntax '##define-top-level-syntax))

    (##add-new-macro! syntax
      (##make-alias-syntax '##syntax))

    (##add-new-macro! syntax-case
      (##make-alias-syntax '##syntax-case))

    (##add-new-macro! syntax-rules
      (##make-alias-syntax '##syntax-rules))

    (##add-new-macro! with-syntax
      (##make-alias-syntax '##with-syntax))

;;;---------------------------------------

    ;;; deactivate for `make checks` ; activate for `make ut`
    (##add-new-core-macro! ##lambda ##expand-lambda)
    (##add-new-core-macro! ##define ##expand-define)
    (##add-new-core-macro! ##define-syntax ##expand-define-syntax)
    (##add-new-core-macro! ##define-top-level-syntax ##expand-define-top-level-syntax)
    (##add-new-core-macro! ##quote-syntax ##expand-quote-syntax)
    (##add-new-core-macro! quote-syntax ##expand-quote-syntax)
    (##add-new-core-macro! ##syntax ##expand-quote-syntax)

    (##add-new-core-macro! ##quote ##expand-quote)
    (##add-new-core-macro! ##quasiquote ##expand-quasiquote)
    (##add-new-core-macro! ##unquote ##expand-unquote)
    (##add-new-core-macro! ##unquote-splicing ##expand-unquote-splicing)
    (##add-new-core-macro! quote ##expand-quote)
    (##add-new-core-macro! quasiquote ##expand-quasiquote)
    (##add-new-core-macro! unquote ##expand-unquote)

    (##add-new-core-macro! ##case ##expand-case)
    (##add-new-core-macro! ##cond ##expand-cond)
    (##add-new-core-macro! ##cond-expand ##expand-cond)


    (##add-new-core-macro! ##begin ##expand-begin)


    (##add-new-core-macro! ##let     ##expand-let)
    (##add-new-core-macro! ##let*    ##expand-let*)
    (##add-new-core-macro! ##letrec  ##expand-letrec)
    (##add-new-core-macro! ##letrec* ##expand-letrec*)

    (##add-new-core-macro! ##let-values     ##expand-let-values)
    (##add-new-core-macro! ##let*-values    ##expand-let*-values)
    (##add-new-core-macro! ##letrec-values  ##expand-letrec-values)
    (##add-new-core-macro! ##letrec*-values ##expand-letrec*-values)

    (##add-new-core-macro! ##let-syntax     ##expand-let-syntax)

    (##add-new-core-macro! ##let*-syntax    ##expand-let*-syntax)
    (##add-new-core-macro! ##letrec-syntax  ##expand-letrec-syntax)
    (##add-new-core-macro! ##letrec*-syntax ##expand-letrec*-syntax)

    (##add-new-core-macro! ##syntax-case    ##expand-syntax-case)
    (##add-new-core-macro! ##syntax         ##expand-syntax)
    (##add-new-core-macro! syntax           ##expand-syntax)

    (##add-new-core-macro! ##namespace ##expand-namespace)
    (##add-new-core-macro! ##include ##expand-include)

  ##syntax-interaction-cte))

;;;============================================================================

(define-prim&proc (syntax-expand top-cte src)
  (let* ((stx (add-scope (##source->syntax-source src) core-scope))
         (stx (expand stx top-cte))
         (stx (compile stx top-cte)))
    ; We do not need to retransform syntax-objects
    ; as syntax objects can always be used where sources are required.
    #;(##syntax-source->source stx)
    stx))

;;;============================================================================
