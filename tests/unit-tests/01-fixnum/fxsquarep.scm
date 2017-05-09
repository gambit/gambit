(include "#.scm")

(check-eqv? (##fxsquare?  0) 0)
(check-eqv? (##fxsquare?  11) 121)
(check-eqv? (##fxsquare? -11) 121)
(check-eqv? (##fxsquare?  23170) 536848900)
(check-eqv? (##fxsquare? -23170) 536848900)
(check-eqv? (##fxsquare?  23171) (and (fixnum? 536895241) 536895241))
(check-eqv? (##fxsquare? -23171) (and (fixnum? 536895241) 536895241))

(if (fixnum? 1518500250)
    (begin
      (check-eqv? (##fxsquare?  1518500249) (and (fixnum? 2305843006213062001) 2305843006213062001))
      (check-eqv? (##fxsquare?  1518500250) #f)))

(if (fixnum? -1518500250)
    (begin
      (check-eqv? (##fxsquare?  -1518500249) (and (fixnum? 2305843006213062001) 2305843006213062001))
      (check-eqv? (##fxsquare? -1518500250) #f)))
