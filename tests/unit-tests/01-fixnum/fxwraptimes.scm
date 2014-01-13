(include "#.scm")

(check-eqv? (##fxwrap* 6 7)   42)
(check-eqv? (##fxwrap* -6 -7)  42)
(check-eqv? (##fxwrap* 6 -7) -42)
(check-eqv? (##fxwrap* -42 0) 0)

(check-eqv? (##fxwrap*) 1)
(check-eqv? (##fxwrap* 2) 2)
(check-eqv? (##fxwrap* 1 2) 2)
(check-eqv? (##fxwrap* 1 2 3) 6)
(check-eqv? (##fxwrap* 1 2 3 4) 24)

(cond
 ((eqv? ##max-fixnum 2305843009213693951)
  (check-eqv? (##fxwrap* ##max-fixnum 2) -2)
  (check-eqv? (##fxwrap* ##min-fixnum 2) 0)
  )
 ;; FOR 32 bit systems here
 )

(check-eqv? (fxwrap* 6 7)   42)
(check-eqv? (fxwrap* -6 -7)  42)
(check-eqv? (fxwrap* 6 -7) -42)
(check-eqv? (fxwrap* -42 0) 0)

(check-eqv? (fxwrap*) 1)
(check-eqv? (fxwrap* 2) 2)
(check-eqv? (fxwrap* 1 2) 2)
(check-eqv? (fxwrap* 1 2 3) 6)
(check-eqv? (fxwrap* 1 2 3 4) 24)

(cond
 ((eqv? ##max-fixnum 2305843009213693951)
  (check-eqv? (fxwrap* ##max-fixnum 2) -2)
  (check-eqv? (fxwrap* ##min-fixnum 2) 0)
  )
 ;; FOR 32 bit systems here
 )

(check-tail-exn type-exception? (lambda () (fxwrap* 0.5)))
(check-tail-exn type-exception? (lambda () (fxwrap* 0.5 9)))
(check-tail-exn type-exception? (lambda () (fxwrap* 9 0.5)))
(check-tail-exn type-exception? (lambda () (fxwrap* 0.5 3 9)))
(check-tail-exn type-exception? (lambda () (fxwrap* 3 0.5 9)))
(check-tail-exn type-exception? (lambda () (fxwrap* 3 9 0.5)))
