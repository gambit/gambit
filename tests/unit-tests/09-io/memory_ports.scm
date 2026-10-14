(include "#.scm")

;; Vector ports transport objects without printing and reparsing them.

(test-equal '(a "b" 3)
 (let ((port (open-input-vector '#(a "b" 3))))
   (let ((result (read-all port))) (close-port port) result)))
(test-equal '#(a "b" 3)
 (let ((port (open-output-vector)))
   (write 'a port) (write "b" port) (write 3 port)
   (let ((result (get-output-vector port))) (close-port port) result)))
(test-equal '(a b)
 (let ((port (open-vector '#(a))))
   (write 'b port)
   (close-output-port port)
   (let ((result (read-all port))) (close-input-port port) result)))
(test-equal '(a b)
 (call-with-input-vector '#(a b) (lambda (port) (read-all port))))
(test-equal '#(a b)
 (call-with-output-vector (lambda (port) (write 'a port) (write 'b port))))
(test-equal '(a b)
 (with-input-from-vector '#(a b) (lambda () (read-all))))
(test-equal '#(a b)
 (with-output-to-vector (lambda () (write 'a) (write 'b))))
(test-assert
 (let ((object (list 'shared)))
   (eq? object
        (call-with-input-vector (vector object) (lambda (port) (read port))))))

;; String and byte ports preserve exact characters/bytes, including NUL.

(test-equal "a\x3bb;\x0;"
 (call-with-input-string "a\x3bb;\x0;"
   (lambda (port) (read-line port #f))))
(test-equal "a\x3bb;\x0;"
 (call-with-output-string (lambda (port) (display "a\x3bb;\x0;" port))))
(test-equal "a\x3bb;"
 (with-input-from-string "a\x3bb;" (lambda () (read-line (current-input-port) #f))))
(test-equal "a\x3bb;"
 (with-output-to-string (lambda () (display "a\x3bb;"))))
(test-equal "ab"
 (let ((port (open-string "a")))
   (display "b" port)
   (close-output-port port)
   (let ((result (read-line port #f))) (close-input-port port) result)))
(test-equal "ab"
 (let ((port (open-output-string)))
   (display "ab" port)
   (let ((result (get-output-string port))) (close-port port) result)))
(test-equal '(0 127 255)
 (let ((port (open-input-u8vector '#u8(0 127 255))))
   (let* ((a (read-u8 port)) (b (read-u8 port)) (c (read-u8 port))
          (result (list a b c)))
     (test-assert (eof-object? (read-u8 port)))
     (close-port port)
     result)))
(test-equal '#u8(0 127 255)
 (let ((port (open-output-u8vector)))
   (write-u8 0 port) (write-u8 127 port) (write-u8 255 port)
   (let ((result (get-output-u8vector port))) (close-port port) result)))
(test-equal '(1 255)
 (let ((port (open-u8vector '#u8(1))))
   (write-u8 255 port)
   (close-output-port port)
   (let* ((a (read-u8 port)) (b (read-u8 port)) (result (list a b)))
     (test-assert (eof-object? (read-u8 port)))
     (close-input-port port)
     result)))
(test-eqv 255
 (call-with-input-u8vector '#u8(255) (lambda (port) (read-u8 port))))
(test-equal '#u8(0 255)
 (call-with-output-u8vector (lambda (port) (write-u8 0 port) (write-u8 255 port))))
(test-eqv 255
 (with-input-from-u8vector '#u8(255) (lambda () (read-u8))))
(test-equal '#u8(0 255)
 (with-output-to-u8vector (lambda () (write-u8 0) (write-u8 255))))

;; Both halves of an in-memory pipe must carry data in the opposite direction.

(test-equal '(request reply)
 (call-with-values (lambda () (open-vector-pipe))
   (lambda (a b)
     (write 'request a) (force-output a)
     (let ((request (read b)))
       (write 'reply b) (force-output b)
       (let ((reply (read a)))
         (close-port a) (close-port b)
         (list request reply))))))
(test-equal '(#\x3bb #\a)
 (call-with-values (lambda () (open-string-pipe))
   (lambda (a b)
     (write-char #\x3bb a) (force-output a)
     (let ((request (read-char b)))
       (write-char #\a b) (force-output b)
       (let ((reply (read-char a)))
         (close-port a) (close-port b)
         (list request reply))))))
(test-equal '(0 255)
 (call-with-values (lambda () (open-u8vector-pipe))
   (lambda (a b)
     (write-u8 0 a) (force-output a)
     (let ((request (read-u8 b)))
       (write-u8 255 b) (force-output b)
       (let ((reply (read-u8 a)))
         (close-port a) (close-port b)
         (list request reply))))))

;; Dynamic port bindings must be restored after both return and exception.

(test-assert
 (let ((before (current-input-port)))
   (with-input-from-vector '#(value) (lambda () (read)))
   (eq? before (current-input-port))))
(test-assert
 (let ((before (current-output-port)))
   (with-output-to-u8vector (lambda () (write-u8 0)))
   (eq? before (current-output-port))))
(test-assert
 (let* ((before (current-input-port))
        (result
         (with-exception-catcher
          (lambda (exception) exception)
          (lambda () (with-input-from-string "a" (lambda () (raise 'escaped)))))))
   (and (eq? result 'escaped) (eq? before (current-input-port)))))
(test-assert
 (let* ((before (current-output-port))
        (result
         (with-exception-catcher
          (lambda (exception) exception)
          (lambda () (with-output-to-vector (lambda () (raise 'escaped)))))))
   (and (eq? result 'escaped) (eq? before (current-output-port)))))

(test-error type-exception? (open-input-vector #f))
(test-error type-exception? (open-output-vector #f))
(test-error type-exception? (open-input-u8vector #f))
(test-error type-exception? (open-output-u8vector #f))
(test-error type-exception? (get-output-vector #f))
(test-error type-exception? (get-output-u8vector #f))
