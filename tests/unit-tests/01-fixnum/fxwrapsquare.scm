(include "#.scm")

(test-eqv 0 (##fxwrapsquare 0))
(test-eqv 121 (##fxwrapsquare 11))
(test-eqv 121 (##fxwrapsquare -11))
(test-eqv 536848900 (##fxwrapsquare 23170))
(test-eqv 536848900 (##fxwrapsquare -23170))

(test-eqv (fixnum-wrap 536895241) (##fxwrapsquare 23171))
(test-eqv (fixnum-wrap 536895241) (##fxwrapsquare -23171))

(if (fixnum? 1518500249)
    (begin
      (test-eqv (fixnum-wrap 2305843006213062001) (##fxwrapsquare 1518500249))
      (test-eqv
       (fixnum-wrap 2305843006213062001)
       (##fxwrapsquare -1518500249))))

(test-eqv 0 (fxwrapsquare 0))
(test-eqv 121 (fxwrapsquare 11))
(test-eqv 121 (fxwrapsquare -11))
(test-eqv 536848900 (fxwrapsquare 23170))
(test-eqv 536848900 (fxwrapsquare -23170))

(test-eqv (fixnum-wrap 536895241) (fxwrapsquare 23171))
(test-eqv (fixnum-wrap 536895241) (fxwrapsquare -23171))

(if (fixnum? 1518500249)
    (begin
      (test-eqv (fixnum-wrap 2305843006213062001) (fxwrapsquare 1518500249))
      (test-eqv (fixnum-wrap 2305843006213062001) (fxwrapsquare -1518500249))))

(test-eqv 1 (fxwrapsquare (##greatest-fixnum)))
(test-eqv 0 (fxwrapsquare (##least-fixnum)))

(test-error-tail type-exception? (fxwrapsquare 0.))
(test-error-tail type-exception? (fxwrapsquare .5))
