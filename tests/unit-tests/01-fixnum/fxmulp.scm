(include "#.scm")

(test-eqv 42 (##fx*? 6 7))
(test-eqv -42 (##fx*? 6 -7))
(test-eqv -42 (##fx*? -6 7))
(test-eqv 42 (##fx*? -6 -7))

(test-eqv 0 (##fx*? 0 7))
(test-eqv 0 (##fx*? 6 0))
(test-eqv (##fx- 0 (##greatest-fixnum)) (##fx*? (##greatest-fixnum) -1))
(test-eqv #f (##fx*? (##least-fixnum) -1))

(test-eqv (##greatest-fixnum) (##fx*? (##greatest-fixnum) 1))
(test-eqv (##least-fixnum) (##fx*? (##least-fixnum) 1))

(test-eqv
 (##fx* 2 (##fxquotient (##greatest-fixnum) 2))
 (##fx*? 2 (##fxquotient (##greatest-fixnum) 2)))
(test-eqv
 (##fx* (##fxquotient (##greatest-fixnum) 2) 2)
 (##fx*? (##fxquotient (##greatest-fixnum) 2) 2))
(test-eqv
 (##fx* (##fxquotient (##least-fixnum) 2) 2)
 (##fx*? (##fxquotient (##least-fixnum) 2) 2))
(test-eqv
 (##fx* 2 (##fxquotient (##least-fixnum) 2))
 (##fx*? 2 (##fxquotient (##least-fixnum) 2)))

(test-eqv #f (##fx*? 2 (##fx+ (##fxquotient (##greatest-fixnum) 2) 1)))
(test-eqv #f (##fx*? (##fx+ (##fxquotient (##greatest-fixnum) 2) 1) 2))
(test-eqv #f (##fx*? (##fx- (##fxquotient (##least-fixnum) 2) 1) 2))
(test-eqv #f (##fx*? 2 (##fx- (##fxquotient (##least-fixnum) 2) 1)))

(test-eqv
 (##fx* 3 (##fxquotient (##greatest-fixnum) 3))
 (##fx*? 3 (##fxquotient (##greatest-fixnum) 3)))
(test-eqv
 (##fx* (##fxquotient (##greatest-fixnum) 3) 3)
 (##fx*? (##fxquotient (##greatest-fixnum) 3) 3))
(test-eqv
 (##fx* (##fxquotient (##least-fixnum) 3) 3)
 (##fx*? (##fxquotient (##least-fixnum) 3) 3))
(test-eqv
 (##fx* 3 (##fxquotient (##least-fixnum) 3))
 (##fx*? 3 (##fxquotient (##least-fixnum) 3)))

(test-eqv #f (##fx*? 3 (##fx+ (##fxquotient (##greatest-fixnum) 3) 1)))
(test-eqv #f (##fx*? (##fx+ (##fxquotient (##greatest-fixnum) 3) 1) 3))
(test-eqv #f (##fx*? (##fx- (##fxquotient (##least-fixnum) 3) 1) 3))
(test-eqv #f (##fx*? 3 (##fx- (##fxquotient (##least-fixnum) 3) 1)))
