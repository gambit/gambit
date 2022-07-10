(define-syntax rec
  (syntax-rules ()
    ((rec (name . formals) . body)
     (letrec ((name (lambda formals . body)))
       name))
    ((rec name expression)
     (letrec ((name expression))
       name))))
