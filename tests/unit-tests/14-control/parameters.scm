(include "#.scm")

(define param (make-parameter 'top))

(check-true (procedure? param))
(check-eqv? (param) 'top)
(check-eq? (param 'changed) (void))
(check-eqv? (param) 'changed)

(check-equal?
 (parameterize ((param 'inner))
   (list (param)
         (parameterize ((param 'nested))
           (param))
         (param)))
 '(inner nested inner))

(check-eqv? (param) 'changed)

(define converted (make-parameter 1 (lambda (x) (+ x 10))))

(check-eqv? (converted) 11)
(check-eq? (converted 2) (void))
(check-eqv? (converted) 12)
(check-eqv? (parameterize ((converted 5)) (converted)) 15)
(check-eqv? (converted) 12)

(define protected-param (make-parameter 'outside))

(check-equal?
 (with-exception-catcher
  (lambda (e)
    (list e (protected-param)))
  (lambda ()
    (parameterize ((protected-param 'inside))
      (raise 'boom))))
 '(boom outside))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (make-parameter)))
(check-tail-exn type-exception? (lambda () (make-parameter 'value #f)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (param 1 2)))
