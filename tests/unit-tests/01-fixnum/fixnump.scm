(include "#.scm")

(check-true   (##fixnum? 0))
(check-false  (##fixnum? 0.5))
(check-false   (##fixnum? 1+2i))

(check-false  (##fixnum? +inf.0))
(check-false  (##fixnum? -inf.0))
(check-false  (##fixnum? +nan.0))


(check-true   (##fixnum? ##max-fixnum))
(check-true   (##fixnum? ##min-fixnum))
(check-false  (##fixnum? (+ ##max-fixnum 1)))
(check-false  (##fixnum? (- ##min-fixnum 1)))

(check-false   (##fixnum? "test"))
(check-false   (##fixnum? #\a))
(check-false   (##fixnum? #!eof))
(check-false   (##fixnum? #t))
(check-false   (##fixnum? #f))
(check-false   (##fixnum? #!void))
(check-false   (##fixnum? '()))


(check-false  (##fixnum? (lambda () #f)))

(check-false  (##fixnum? (cons #t #t)))
(check-false  (##fixnum? (vector)))

(check-false  (##fixnum? 'test))

(check-false  (##fixnum? (box 1)))


(check-true   (fixnum? 0))
(check-false  (fixnum? 0.5))
(check-false   (fixnum? 1+2i))

(check-false  (fixnum? +inf.0))
(check-false  (fixnum? -inf.0))
(check-false  (fixnum? +nan.0))


(check-true   (fixnum? ##max-fixnum))
(check-true   (fixnum? ##min-fixnum))
(check-false  (fixnum? (+ ##max-fixnum 1)))
(check-false  (fixnum? (- ##min-fixnum 1)))

(check-false   (fixnum? "test"))
(check-false   (fixnum? #\a))
(check-false   (fixnum? #!eof))
(check-false   (fixnum? #t))
(check-false   (fixnum? #f))
(check-false   (fixnum? #!void))
(check-false   (fixnum? '()))


(check-false  (fixnum? (lambda () #f)))

(check-false  (fixnum? (cons #t #t)))
(check-false  (fixnum? (vector)))

(check-false  (fixnum? 'test))

(check-false  (fixnum? (box 1)))
