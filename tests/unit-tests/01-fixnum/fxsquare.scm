(include "#.scm")

(check-eqv? (##fxsquare  0) 0)
(check-eqv? (##fxsquare  11) 121)
(check-eqv? (##fxsquare -11) 121)
(check-eqv? (##fxsquare  23170) 536848900) ;; fits in 32 and 64 bit words
(check-eqv? (##fxsquare -23170) 536848900) ;; fits in 32 and 64 bit words

(if (fixnum? 536895241)
    (begin
      ;; 64 bit words
      (check-eqv? (##fxsquare  23171) 536895241)
      (check-eqv? (##fxsquare -23171) 536895241)
      (check-eqv? (##fxsquare  1518500249) 2305843006213062001)
      (check-eqv? (##fxsquare -1518500249) 2305843006213062001)))

(check-eqv? (fxsquare  0) 0)
(check-eqv? (fxsquare  11) 121)
(check-eqv? (fxsquare -11) 121)
(check-eqv? (fxsquare  23170) 536848900)
(check-eqv? (fxsquare -23170) 536848900)

(if (fixnum? 536895241)
    (begin
      ;; 64 bit words
      (check-eqv? (fxsquare  23171) 536895241)
      (check-eqv? (fxsquare -23171) 536895241)
      (check-eqv? (fxsquare  1518500249) 2305843006213062001)
      (check-eqv? (fxsquare -1518500249) 2305843006213062001)
      (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare  1518500250)))
      (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare -1518500250))))
    (begin
      ;; 32 bit words
      (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare  23171)))
      (check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare -23171)))))

(check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare ##max-fixnum)))
(check-tail-exn fixnum-overflow-exception? (lambda () (fxsquare ##min-fixnum)))

(check-tail-exn type-exception? (lambda () (fxsquare 0.0)))
(check-tail-exn type-exception? (lambda () (fxsquare 0.5)))
