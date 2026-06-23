(include "#.scm")

(test-eqv 0 (##fxsquare 0))
(test-eqv 121 (##fxsquare 11))
(test-eqv 121 (##fxsquare -11))
(test-eqv 536848900 (##fxsquare 23170))
;; fits in 32 and 64 bit words
(test-eqv 536848900 (##fxsquare -23170))
;; fits in 32 and 64 bit words

(if (fixnum? 536895241)
    (begin
      ;; 64 bit words
      (test-eqv 536895241 (##fxsquare 23171))
      (test-eqv 536895241 (##fxsquare -23171))
      (test-eqv 1152921502459363329 (##fxsquare 1073741823))
      (test-eqv 1152921502459363329 (##fxsquare -1073741823))
      (if (fixnum? 1152921504606846976)
          (begin
            ;; 64 bit words, with 2 tag bits for fixnums
            (test-eqv 2305843006213062001 (##fxsquare 1518500249))
            (test-eqv 2305843006213062001 (##fxsquare -1518500249))))))

(test-eqv 0 (fxsquare 0))
(test-eqv 121 (fxsquare 11))
(test-eqv 121 (fxsquare -11))
(test-eqv 536848900 (fxsquare 23170))
(test-eqv 536848900 (fxsquare -23170))

(if (fixnum? 536895241)
    (begin
      ;; 64 bit words
      (test-eqv 536895241 (fxsquare 23171))
      (test-eqv 536895241 (fxsquare -23171))
      (test-eqv 1152921502459363329 (fxsquare 1073741823))
      (test-eqv 1152921502459363329 (fxsquare -1073741823))
      (if (fixnum? 1152921504606846976)
          (begin
            ;; 64 bit words, with 2 tag bits for fixnums
            (test-eqv 2305843006213062001 (fxsquare 1518500249))
            (test-eqv 2305843006213062001 (fxsquare -1518500249))
            (test-error-tail fixnum-overflow-exception? (fxsquare 1518500250))
            (test-error-tail
             fixnum-overflow-exception?
             (fxsquare -1518500250)))
          (begin
            ;; 64 bit words, with 3 tag bits for fixnums
            (test-error-tail fixnum-overflow-exception? (fxsquare 1073741825))
            (test-error-tail
             fixnum-overflow-exception?
             (fxsquare -1073741825)))))
    (begin
      ;; 32 bit words
      (test-error-tail fixnum-overflow-exception? (fxsquare 23171))
      (test-error-tail fixnum-overflow-exception? (fxsquare -23171))))

(test-error-tail fixnum-overflow-exception? (fxsquare (##greatest-fixnum)))
(test-error-tail fixnum-overflow-exception? (fxsquare (##least-fixnum)))

(test-error-tail type-exception? (fxsquare 0.))
(test-error-tail type-exception? (fxsquare .5))
