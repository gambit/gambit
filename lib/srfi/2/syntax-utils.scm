(define (syntax-lift f)
  (lambda (src)
    (let ((r (f (##source-code src))))
      (if (##source? r)
          r
          (datum->syntax src r)))))

(define syntax-car (syntax-lift car))

(define syntax-cadr (syntax-lift cadr))
