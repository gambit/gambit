(include "#.scm")

(with-exception-catcher
 (lambda (e) e)
 (lambda () (delete-file "open_binary_input_file_temp")))

(write-file-u8vector "open_binary_input_file_temp" '#u8(11 22 33))

(define p #f)


(test-assert (input-port? (begin (set! p (open-binary-input-file "open_binary_input_file_temp")) p)))

(test-eqv #t (textual-port? p))
(test-eqv #t (binary-port? p))

(test-equal 11 (read-u8 p))
(test-equal 22 (read-u8 p))
(test-equal 33 (read-u8 p))
(test-equal #!eof (read-u8 p))

(test-equal #!void (close-input-port p))


(delete-file "open_binary_input_file_temp")

(test-error-tail wrong-number-of-arguments-exception? (open-binary-input-file))
(test-error-tail wrong-number-of-arguments-exception? (open-binary-input-file "open_binary_input_file_temp" #f))

(test-error-tail type-exception? (open-binary-input-file #f))
