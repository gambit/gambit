(include "#.scm")

(define (caught thunk)
  (with-exception-catcher (lambda (e) e) thunk))

(define e (caught (lambda () (compilation-target))))

(test-eq #t (not-in-compilation-context-exception? e))
(test-eq #f (not-in-compilation-context-exception? #f))
(test-eq compilation-target (not-in-compilation-context-exception-procedure e))
(test-equal '() (not-in-compilation-context-exception-arguments e))
