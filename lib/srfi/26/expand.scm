(##supply-module srfi/26/expand)
(##namespace ("srfi/2/expand#"))
(##import gambit)
(##include "expand#.scm")

(define (cut-expand src close?)

  (let cons-closure ((argument-sources (cdr (syntax->list src)))
                     (let-over-lambda-bindings '())
                     (formals '())
                     (procedure-application '()))

    (if (null? argument-sources)

        `(##let ,let-over-lambda-bindings
           (##lambda ,(reverse formals)
             ,(reverse procedure-application)))

        (case (##source-code (car argument-sources))

          ((<>)
           (let ((parameter (gensym 'slot)))
             (cons-closure (cdr argument-sources)
                           let-over-lambda-bindings
                           (cons parameter formals)
                           (cons parameter procedure-application))))

          ((<...>)
           (if (null? (cdr argument-sources))
               (let ((rest-parameter (gensym 'rest-slot)))
                 `(##let ,let-over-lambda-bindings
                   (##lambda (,@(reverse formals) . ,rest-parameter)
                     (##apply ,@(reverse procedure-application) ,rest-parameter))))
               (##raise-expression-parsing-exception 'ill-formed-special-form src)))

          (else
           (if close?
               (let ((var (gensym)))
                 (cons-closure (cdr argument-sources)
                               (cons (list var (car argument-sources))
                                     let-over-lambda-bindings)
                               formals
                               (cons var procedure-application)))
               (cons-closure (cdr argument-sources)
                             let-over-lambda-bindings
                             formals
                             (cons (car argument-sources) procedure-application))))))))
