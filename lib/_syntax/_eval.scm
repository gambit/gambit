;;;============================================================================

;;; File: "_eval.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.
;;; Copyright (c) 2024 by Antoine Doucet, All Rights Reserved.

;;;============================================================================

;; Expand and evaluate `rhs` as a compile-time expression

(define ##interaction-cte-original ##interaction-cte)

(define (##eval-for-syntax-binding rhs cte #!optional debug?)
  (define debug (or #f debug?))
  (let ((expansion (expand rhs cte)))
    (if debug
        (begin
          (##pretty-print "expansion of ")
          (##pretty-print rhs)
          (##pretty-print "is :")
          (##pretty-print expansion)))
    (let ((compiled (compile expansion cte)))
      (if debug
          (begin
          (##pretty-print "compilation of ")
          ;(##pretty-print expansion)
          (##pretty-print "is :")
          (##pretty-print compiled)))
      (let ((evaluated   (let ((c (##compile-top ##interaction-cte-original
                            compiled)))
                           (##setup-requirements-and-run c #f))))
        (if debug
            (begin
            (##pretty-print "evaluation of")
            ;(##pretty-print compiled)
            (##pretty-print "is :")
            (##pretty-print evaluated)))
        evaluated))))

(define (eval-for-syntax-binding rhs cte #!optional debug?)
  (##eval-for-syntax-binding rhs cte debug?))

;;;----------------------------------------------------------------------------

(define (##eval-top-syntax src top-cte)
  (let ((c (##compile-top-syntax top-cte
                          (##sourcify src (##make-source #f #f)))))
    (##setup-requirements-and-run c #f)))

(define-prim (##eval-module-syntax src top-cte)
  (let ((c (##compile-top-syntax top-cte
                          (##sourcify src (##make-source #f #f)))))
    (##setup-requirements-and-run c #f)))

(##eval-top-set! ##eval-top-syntax)
(##eval-module-set! ##eval-module-syntax)

;;;===========================================================================
