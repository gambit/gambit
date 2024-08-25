;;;============================================================================

;;; File: "_syntax-case-lib.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

(define-macro (##add-new-core-macro! name procedure)
  `(top-hcte-add-core-macro-cte! ##syntax-interaction-cte 
                                 (##add-scope 
                                   (##make-syntax-source ',name #f)
                                   ##core-scope)
                                 ,procedure))

(define-macro (##add-new-macro! name procedure)
  `(top-hcte-add-macro-cte! ##syntax-interaction-cte 
                            (##add-scope 
                              (##make-syntax-source ',name #f)
                              ##core-scope)
                            ,procedure))

(define-prim (##make-syntax-expander-syntax-rules)
  (##eval-for-syntax-binding
    (##datum->core-syntax
      `(##lambda (stx)
         (##syntax-case stx ()
           ((_ (k ...) (patterns . templates) ...)
            (##syntax
              (##lambda (stx)
                (##syntax-case stx (k ...)
                  (patterns (##syntax (##begin . templates)))
                  ...)))))))
    ##syntax-interaction-cte))

(define-prim (##make-syntax-expander-with-syntax)
  (##eval-for-syntax-binding
    (##datum->core-syntax
      `(##lambda (stx)
        (##syntax-case stx ()
          ((_ ((p e) ...) b ...)
           (##syntax
             (##syntax-case (##list e ...) ()
               ((p ...) (##begin b ...))))))))
    ##syntax-interaction-cte))

;; TODO: low performances
(define-prim (##make-syntax-expander-define-macro)
  (##eval-for-syntax-binding
    (##datum->core-syntax
      `(##lambda (s)
         (##syntax-case s ()
           ((##define-macro (name . params) body2 ...)
            (##syntax
              (##define-macro name 
                (##lambda params
                  body2 ...))))
           ((_ name expander)
            (##syntax 
              (##define-top-level-syntax name 
                (##lambda (s)
                  (##syntax-case s ()
                    ((_ . args)
                     (##datum->core-syntax
                         (##apply expander
                                  (##syntax->datum (##syntax args)))
                         (##car (##source-code s))))
                    (_
                     (##error "define-macro: ill formed macro call" s)))))))
           (_
            (##error "ill-formed form : define-macro")))))
    ##syntax-interaction-cte))

;;;---------------------------------------

(##add-new-macro! ##syntax-rules 
                  (##make-syntax-expander-syntax-rules))

(##add-new-macro! ##with-syntax 
                  (##make-syntax-expander-with-syntax))

(##add-new-macro! ##define-macro 
                  (##make-syntax-expander-define-macro))

;;;============================================================================
