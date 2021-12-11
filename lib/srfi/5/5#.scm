;;;============================================================================

;;; File: "5#.scm"

;;; Copyright (c) 2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 5, A compatible let form with signatures and rest arguments

(##namespace ("srfi/5#"

let
%let-loop

))

(##define-syntax let
  (syntax-rules ()

    ((_ ((var val) ...) body other ...)
     (##let ((var val) ...) body other ...))

    ((_ ((var val) . bindings) body other ...)
     (%let-loop #f bindings (var) (val) (##let () body other ...)))

    ((_ (name . bindings) body other ...)
     (%let-loop name bindings () () (##let () body other ...)))

    ((_ name bindings body other ...)
     (%let-loop name bindings () () (##let () body other ...)))))

(##define-syntax %let-loop
  (syntax-rules ()

    ((_ name ((var0 val0) . bindings) (var ...     ) (val ...     ) body)
     (%let-loop name        bindings  (var ... var0) (val ... val0) body))

    ((_ name ()                       (var ...)      (val ...)      body)
     ((##letrec ((name (##lambda (var ...) body)))
        name)
      val ...))

    ((_ #f   (rest-var . rest-vals)   (var ...)      (val ...)      body)
     (##let ((var val) ... (rest-var (list . rest-vals)))
       body))

    ((_ name (rest-var . rest-vals)   (var ...)      (val ...)      body)
     ((##letrec ((name (##lambda (var ... . rest-var) body)))
        name)
      val ... . rest-vals))))

;;;============================================================================
