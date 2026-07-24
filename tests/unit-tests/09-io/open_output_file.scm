(include "#.scm")

(with-exception-catcher
 (lambda (e) e)
 (lambda () (delete-file "open_output_file_temp")))

(define p #f)


(test-assert (##output-port? (begin (set! p (##open-output-file "open_output_file_temp")) p)))

;;(test-eqv #t (textual-port? p))
;;(test-eqv #t (binary-port? p))

(##write-char #\a p)
(##write-char #\b p)
(##write-char #\c p)
(##write-char #\newline p)

(test-equal #!void (##close-output-port p))


(test-assert (output-port? (begin (set! p (open-output-file "open_output_file_temp")) p)))

(test-eqv #t (textual-port? p))
(test-eqv #t (binary-port? p))

(write-char #\a p)
(write-char #\b p)
(write-char #\c p)
(write-char #\newline p)

(test-equal #!void (close-output-port p))


(test-equal "abc\n" (read-file-string "open_output_file_temp"))

(delete-file "open_output_file_temp")

(test-error-tail wrong-number-of-arguments-exception? (open-output-file))
(test-error-tail wrong-number-of-arguments-exception? (open-output-file "open_output_file_temp" #f))

(test-error-tail type-exception? (open-output-file #f))
