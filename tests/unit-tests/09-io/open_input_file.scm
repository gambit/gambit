(include "#.scm")

(with-exception-catcher
 (lambda (e) e)
 (lambda () (delete-file "open_input_file_temp")))

(write-file-string "open_input_file_temp" "abc\n")

(define p #f)


(test-assert (##input-port? (begin (set! p (##open-input-file "open_input_file_temp")) p)))

;;(test-eqv #t (##textual-port? p))
;;(test-eqv #t (##binary-port? p))

(test-equal #\a (##read-char p))
(test-equal #\b (##read-char p))
(test-equal #\c (##read-char p))
(test-equal #\newline (##read-char p))
(test-equal #!eof (##read-char p))

(test-equal #!void (##close-input-port p))


(test-assert (input-port? (begin (set! p (open-input-file "open_input_file_temp")) p)))

(test-eqv #t (textual-port? p))
(test-eqv #t (binary-port? p))

(test-equal #\a (read-char p))
(test-equal #\b (read-char p))
(test-equal #\c (read-char p))
(test-equal #\newline (read-char p))
(test-equal #!eof (read-char p))

(test-equal #!void (close-input-port p))


(delete-file "open_input_file_temp")

(test-error-tail wrong-number-of-arguments-exception? (open-input-file))
(test-error-tail wrong-number-of-arguments-exception? (open-input-file "open_input_file_temp" #f))

(test-error-tail type-exception? (open-input-file #f))
