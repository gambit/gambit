(include "#.scm")

(test-eqv 363 (##fx* 11 33))
(test-eqv -121 (##fx* 11 -11))
(test-eqv -363 (##fx* 11 -33))
(test-eqv -363 (##fx* -11 33))

(test-eqv 1 (##fx*))
(test-eqv 11 (##fx* 11))
(test-eqv 242 (##fx* 11 22))
(test-eqv 7986 (##fx* 11 22 33))
(test-eqv 351384 (##fx* 11 22 33 44))

(test-eqv 363 (fx* 11 33))
(test-eqv -121 (fx* 11 -11))
(test-eqv -363 (fx* 11 -33))
(test-eqv -363 (fx* -11 33))

(test-eqv 1 (fx*))
(test-eqv 11 (fx* 11))
(test-eqv 242 (fx* 11 22))
(test-eqv 7986 (fx* 11 22 33))
(test-eqv 351384 (fx* 11 22 33 44))

(test-error-tail fixnum-overflow-exception? (fx* (##greatest-fixnum) 2))
(test-error-tail fixnum-overflow-exception? (fx* (##greatest-fixnum) -2))
(test-error-tail fixnum-overflow-exception? (fx* (##least-fixnum) 2))
(test-error-tail fixnum-overflow-exception? (fx* (##least-fixnum) -2))
(test-eqv (##greatest-fixnum) (fx* -1 (##greatest-fixnum) -1))
(test-error-tail fixnum-overflow-exception? (fx* -1 (##least-fixnum) -1))
(test-error-tail
 fixnum-overflow-exception?
 (fx* (##greatest-fixnum) (##greatest-fixnum)))
(test-error-tail
 fixnum-overflow-exception?
 (fx* (##least-fixnum) (##least-fixnum)))
(test-error-tail
 fixnum-overflow-exception?
 (fx* (##least-fixnum) (##greatest-fixnum)))

(test-error-tail type-exception? (fx* 0.))
(test-error-tail type-exception? (fx* .5))
(test-error-tail type-exception? (fx* .5 9))
(test-error-tail type-exception? (fx* 9 .5))
(test-error-tail type-exception? (fx* .5 3 9))
(test-error-tail type-exception? (fx* 3 .5 9))
(test-error-tail type-exception? (fx* 3 9 .5))
