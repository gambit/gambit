;;;============================================================================

;;; File: "_eval.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

;; Expand and evaluate `rhs` as a compile-time expression

(define-prim (##eval-for-syntax-binding rhs cte)
  (##call-with-values
   (lambda ()
     (##in-new-compilation-ctx
       (macro-interpreter-target)
       (lambda ()
         (let* ((expansion (##expand rhs cte))
                (compiled (##compile expansion cte)))
           (##compile-top ##interaction-cte compiled)))))
   (lambda (c ctx)
     (##load-modules (macro-compilation-ctx-demand-modules ctx))
     (let ((evaluated (##setup-requirements-and-run c #f)))
       evaluated))))

(define-prim (##eval-for-top-syntax rhs cte)
  (let* ((expansion (##expand rhs cte))
         (compiled (##compile expansion cte))
         (evaluated   (##eval-top-syntax compiled cte)))
    evaluated))

;;;===========================================================================
