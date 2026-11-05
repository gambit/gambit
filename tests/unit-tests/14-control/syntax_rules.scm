(include "#.scm")

(test-equal 42
  (let ()
    (define-syntax foo-double
      (syntax-rules ()
        ((_ x) (* x 2))))
    (foo-double 21)))
