(include "#.scm")

(test-equal 10 (with-input-from-u8vector '#u8(10) (lambda () (peek-u8))))

(test-equal #!eof (with-input-from-u8vector '#u8() (lambda () (peek-u8))))

(test-equal
 '(97 97 97)
 (with-input-from-u8vector
  '#u8(97 98)
  (lambda () (let* ((a (peek-u8)) (b (peek-u8)) (c (peek-u8))) (list a b c)))))

(test-equal
 '(97 97 97)
 (call-with-input-u8vector
  '#u8(97 98)
  (lambda (port)
    (let* ((a (peek-u8 port)) (b (peek-u8 port)) (c (peek-u8 port)))
      (list a b c)))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (peek-u8 (current-input-port) #f))

(test-error-tail type-exception? (peek-u8 #f))
