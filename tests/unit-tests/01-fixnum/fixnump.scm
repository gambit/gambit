(include "#.scm")

(test-assert (eq? #t (##fixnum? 0)))
(test-assert (eq? #f (##fixnum? .5)))
(test-assert (eq? #f (##fixnum? 1+2i)))

(test-assert (eq? #f (##fixnum? +inf.0)))
(test-assert (eq? #f (##fixnum? -inf.0)))
(test-assert (eq? #f (##fixnum? +nan.0)))


(test-assert (eq? #t (##fixnum? (##greatest-fixnum))))
(test-assert (eq? #t (##fixnum? (##least-fixnum))))
(test-assert (eq? #f (##fixnum? (+ (##greatest-fixnum) 1))))
(test-assert (eq? #f (##fixnum? (- (##least-fixnum) 1))))

(test-assert (eq? #f (##fixnum? "test")))
(test-assert (eq? #f (##fixnum? #\a)))
(test-assert (eq? #f (##fixnum? #!eof)))
(test-assert (eq? #f (##fixnum? #t)))
(test-assert (eq? #f (##fixnum? #f)))
(test-assert (eq? #f (##fixnum? #!void)))
(test-assert (eq? #f (##fixnum? '())))


(test-assert (eq? #f (##fixnum? (lambda () #f))))

(test-assert (eq? #f (##fixnum? '(1 . 2))))
(test-assert (eq? #f (##fixnum? '#(1))))

(test-assert (eq? #f (##fixnum? 'test)))

(test-assert (eq? #f (##fixnum? (box 1))))


(test-assert (eq? #t (fixnum? 0)))
(test-assert (eq? #f (fixnum? .5)))
(test-assert (eq? #f (fixnum? 1+2i)))

(test-assert (eq? #f (fixnum? +inf.0)))
(test-assert (eq? #f (fixnum? -inf.0)))
(test-assert (eq? #f (fixnum? +nan.0)))


(test-assert (eq? #t (fixnum? (##greatest-fixnum))))
(test-assert (eq? #t (fixnum? (##least-fixnum))))
(test-assert (eq? #f (fixnum? (+ (##greatest-fixnum) 1))))
(test-assert (eq? #f (fixnum? (- (##least-fixnum) 1))))

(test-assert (eq? #f (fixnum? "test")))
(test-assert (eq? #f (fixnum? #\a)))
(test-assert (eq? #f (fixnum? #!eof)))
(test-assert (eq? #f (fixnum? #t)))
(test-assert (eq? #f (fixnum? #f)))
(test-assert (eq? #f (fixnum? #!void)))
(test-assert (eq? #f (fixnum? '())))


(test-assert (eq? #f (fixnum? (lambda () #f))))

(test-assert (eq? #f (fixnum? '(1 . 2))))
(test-assert (eq? #f (fixnum? '#(1))))

(test-assert (eq? #f (fixnum? 'test)))

(test-assert (eq? #f (fixnum? (box 1))))
