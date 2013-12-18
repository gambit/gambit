(include "#.scm")

(check-eqv? (##fxsquare  0) 0)
(check-eqv? (##fxsquare  11) 121)
(check-eqv? (##fxsquare -11) 121)
(check-eqv? (##fxsquare  23170) 536848900)
(check-eqv? (##fxsquare -23170) 536848900)

(if (fixnum? 536895241)
    (check-eqv? (##fxsquare  23171) 536895241))

(if (fixnum? 536895241)
    (check-eqv? (##fxsquare -23171) 536895241))

(if (fixnum? 2305843006213062001)
    (check-eqv? (##fxsquare  1518500249) 2305843006213062001))

(if (fixnum? 2305843006213062001)
    (check-eqv? (##fxsquare -1518500249) 2305843006213062001))

(check-eqv? (fxsquare  0) 0)
(check-eqv? (fxsquare  11) 121)
(check-eqv? (fxsquare -11) 121)
(check-eqv? (fxsquare  23170) 536848900)
(check-eqv? (fxsquare -23170) 536848900)

(if (fixnum? 536895241)
    (check-eqv? (fxsquare  23171) 536895241)
    (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare  23171))))

(if (fixnum? 536895241)
    (check-eqv? (fxsquare -23171) 536895241)
    (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare -23171))))

(if (fixnum? 2305843006213062001)
    (check-eqv? (fxsquare  1518500249) 2305843006213062001)
    (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare  1518500249))))

(if (fixnum? 2305843006213062001)
    (check-eqv? (fxsquare -1518500249) 2305843006213062001)
    (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare -1518500249))))

(check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare  1518500250)))
(check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare -1518500250)))

(check-tail-exn type-exception? (lambda () (fxsquare 0.5)))
