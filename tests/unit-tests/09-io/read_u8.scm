(include "#.scm")

(test-equal
 10
 (with-input-from-u8vector '#u8(10) (lambda () (read-u8))))

(test-equal
 #!eof
 (with-input-from-u8vector '#u8() (lambda () (read-u8))))

(test-equal
 '(97 98 #!eof)
 (with-input-from-u8vector '#u8(97 98) (lambda () (let* ((a (read-u8)) (b (read-u8)) (c (read-u8))) (list a b c)))))

(test-equal
 '(97 98 #!eof)
 (call-with-input-u8vector '#u8(97 98) (lambda (port) (let* ((a (read-u8 port)) (b (read-u8 port)) (c (read-u8 port))) (list a b c)))))

(test-error-tail wrong-number-of-arguments-exception? (read-u8 (current-input-port) #f))

(test-error-tail type-exception? (read-u8 #f))
