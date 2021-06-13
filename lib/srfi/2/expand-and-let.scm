(define (expand-and-let* src)
  (let ((bindings (reverse (map claw->binding (syntax->list (syntax-cadr src)))))
        (body     (cddr (syntax->list src))))
    (fold (lambda (var expr expansion)
            `(##let ((,var ,expr))
               (##and ,var ,expansion)))
          `(##begin
            ,(or (null? bindings) (syntax-car (car bindings)))
            ,@body)
          (map syntax-car  bindings)
          (map syntax-cadr bindings))))

(define (claw->binding src)
  (datum->syntax
   src
   (cond ((symbol? (syntax->datum src))
          (list src src))
         ((list? (syntax->datum src))
          (case (length (syntax->list src))
            ((1) (list (gensym) (syntax-car src)))
            ((2) src)
            (else (##raise-expression-parsing-exception 'ill-formed-special-form src))))
         (else (##raise-expression-parsing-exception 'ill-formed-special-form src)))))
