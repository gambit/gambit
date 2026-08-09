(include "#.scm")

(test-eqv 0 (##fxsquare? 0))
(test-eqv 121 (##fxsquare? 11))
(test-eqv 121 (##fxsquare? -11))
(test-eqv 536848900 (##fxsquare? 23170))
(test-eqv 536848900 (##fxsquare? -23170))
(test-eqv (and (fixnum? 536895241) 536895241) (##fxsquare? 23171))
(test-eqv (and (fixnum? 536895241) 536895241) (##fxsquare? -23171))

(if (fixnum? 1518500250)
    (begin
      (test-eqv
       (and (fixnum? 2305843006213062001) 2305843006213062001)
       (##fxsquare? 1518500249))
      (test-eqv #f (##fxsquare? 1518500250))))

(if (fixnum? -1518500250)
    (begin
      (test-eqv
       (and (fixnum? 2305843006213062001) 2305843006213062001)
       (##fxsquare? -1518500249))
      (test-eqv #f (##fxsquare? -1518500250))))
