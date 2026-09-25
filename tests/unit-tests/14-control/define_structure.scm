(include "#.scm")

(test-equal 7
  (let ()
    (define-structure pt x)
    (pt-x (make-pt 7))))
