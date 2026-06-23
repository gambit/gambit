(include "#.scm")

(with-exception-catcher
 (lambda (e) e)
 (lambda () (delete-file "open_binary_output_file_temp")))

(define p #f)


(test-assert (output-port? (begin (set! p (open-binary-output-file "open_binary_output_file_temp")) p)))

(test-eqv #t (textual-port? p))
(test-eqv #t (binary-port? p))

(write-u8 11 p)
(write-u8 22 p)
(write-u8 33 p)

(test-equal #!void (close-output-port p))


(test-equal '#u8(11 22 33) (read-file-u8vector "open_binary_output_file_temp"))

(delete-file "open_binary_output_file_temp")

(test-error-tail wrong-number-of-arguments-exception? (open-binary-output-file))
(test-error-tail wrong-number-of-arguments-exception? (open-binary-output-file "open_binary_output_file_temp" #f))

(test-error-tail type-exception? (open-binary-output-file #f))
