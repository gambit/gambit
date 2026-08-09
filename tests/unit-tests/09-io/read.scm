(include "#.scm")

(test-equal 123 (with-input-from-string "123" (lambda () (read))))

(test-equal
 -45678901234567890
 (with-input-from-string "-45678901234567890" (lambda () (read))))

(test-equal 1.25 (with-input-from-string "1.25" (lambda () (read))))

(test-equal #t (with-input-from-string "#t" (lambda () (read))))

(test-equal #f (with-input-from-string "#f" (lambda () (read))))

(test-equal #\space (with-input-from-string "#\\space" (lambda () (read))))

(test-equal
 "hello\nworld"
 (with-input-from-string "\"hello\\nworld\"" (lambda () (read))))

(test-equal 'sym (with-input-from-string "sym" (lambda () (read))))

(test-equal 'key: (with-input-from-string "key:" (lambda () (read))))

(test-equal #(1 2 3) (with-input-from-string "#(1 2 3)" (lambda () (read))))

(test-equal '(1 2 . 3) (with-input-from-string "(1 2 . 3)" (lambda () (read))))

(test-equal '() (with-input-from-string "()" (lambda () (read))))

(test-equal #!eof (with-input-from-string "" (lambda () (read))))

(test-equal
 "hello\nworld"
 (call-with-input-string "\"hello\\nworld\"" (lambda (port) (read port))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (read (current-input-port) #f))

(test-error-tail type-exception? (read #f))

;; note that read errors are not raised in tail position:
(test-assert
 (read-error?
  (with-exception-catcher
   (lambda (exn) exn)
   (lambda () (with-input-from-string ")" (lambda () (read)))))))
