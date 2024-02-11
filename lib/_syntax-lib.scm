;;;============================================================================

;;; File: "_syntax-case-lib.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

(define-macro (##add-new-core-macro! name procedure)
  `(top-hcte-add-core-macro-cte! ##syntax-interaction-cte 
                                 (add-scope 
                                   (##make-syntax-source ',name #f)
                                   core-scope)
                                 ,procedure))

(define-macro (##add-new-macro! name procedure)
  `(top-hcte-add-macro-cte! ##syntax-interaction-cte 
                            (add-scope 
                              (##make-syntax-source ',name #f)
                              core-scope)
                            ,procedure))

(##add-new-macro! ##syntax-rules
  (##eval-for-syntax-binding
    (plain-datum->core-syntax
      `(##lambda (stx)
         (##syntax-case stx ()
           ((_ (k ...) (patterns template) ...)
            (##syntax
              (##lambda (stx)
                (##syntax-case stx (k ...)
                  (patterns (##syntax template))
                  ...)))))))
    ##syntax-interaction-cte))

(##add-new-macro! ##with-syntax
  (##eval-for-syntax-binding
    (plain-datum->core-syntax
      `(##lambda (stx)
        (##syntax-case stx ()
          ((_ ((p e) ...) b ...)
           (##syntax
             (##syntax-case (list e ...) ()
               ((p ...) (##begin b ...))))))))
    ##syntax-interaction-cte))

;; TODO: extremly low performances
(##add-new-macro! ##define-macro
  (##eval-for-syntax-binding
    (plain-datum->core-syntax
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
                  (##syntax-case s (qwe)
                    ((_ . args)
                     (##plain-datum->core-syntax
                         (apply expander
                                (syntax->plain-datum (##syntax args)))
                       (car (##source-code s))))
                    (_
                     (error "define-macro: ill formed macro call" s)))))))
           (_
            (error "ill-formed form : define-macro")))))
    ##syntax-interaction-cte))

;;;============================================================================
