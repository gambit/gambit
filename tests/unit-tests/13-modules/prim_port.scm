(include "#.scm")

(define ##_temp-file "test_temp_file.txt")
(define ##_input-file "test_input_file.txt")

(check-same-behavior ("" "##" "~~lib/gambit/prim/port#.scm")

(##call-with-output-file ##_input-file (lambda (p) (display "2\n1\n3\n" p)))

;; R4RS

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (call-with-input-file x ##read-char))) (##delete-file x) result))

(let ((x ##_temp-file)) (call-with-output-file x ##newline) (let ((result (##file-exists? x))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (char-ready?))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (char-ready? p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (##open-input-file x)) (result (close-input-port p))) (##delete-file x) result))

(let ((x ##_temp-file)) (let* ((p (##open-output-file x)) (result (close-output-port p))) (##delete-file x) result))

(let ((p (current-input-port))) (current-input-port p))

(let ((p (current-output-port))) (current-output-port p))

(let ((x ##_temp-file)) (let ((result (##with-output-to-file x (lambda () (display 123))))) (##delete-file x) result))
(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (display 123 p))))) (##delete-file x) result))

(eof-object? 123)
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (##open-input-file x)) (result (eof-object? (##read p)))) (##close-input-port p) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (##open-input-file x)) (result (input-port? p))) (##close-input-port p) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (newline))))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (newline p))))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (open-input-file x)) (result (##input-port? p))) (##close-input-port p) (##delete-file x) result))

(let ((x ##_temp-file)) (let* ((p (open-output-file x)) (result (##output-port? p))) (##close-output-port p) (##delete-file x) result))

(let ((x ##_temp-file)) (let* ((p (##open-output-file x)) (result (output-port? p))) (##close-output-port p) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (peek-char))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (peek-char p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (read))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (read-char))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-char p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (with-input-from-file x (lambda () (##read-char))))) (##delete-file x) result))

(let ((x ##_temp-file)) (with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (##read-char))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (write '(1 2 3)))) (let ((result (##with-input-from-file x ##read))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write '(1 2 3) p))) (let ((result (##with-input-from-file x ##read))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (write-char #\x))) (let ((result (##with-input-from-file x ##read-char))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-char #\x p))) (let ((result (##with-input-from-file x ##read-char))) (##delete-file x) result))

;; R7RS

;;unimplemented;;(binary-port? (##current-input-port))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (##open-input-file x)) (result (call-with-port p ##read-char))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (##open-input-file x)) (result (close-port p))) (##delete-file x) result))

(current-error-port)

(eof-object? (eof-object))

;;unimplemented;;(flush-output-port) (flush-output-port (##current-output-port))

;;unimplemented;;(let ((p (open-output-bytevector))) (get-output-bytevector p))

(let ((p (open-output-string))) (get-output-string p))

;;unimplemented;;(input-port-open? (##current-input-port))

;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (open-binary-input-file x)) (result (##input-port? p))) (##close-input-port p) (##delete-file x) result))

;;unimplemented;;(let ((x ##_temp-file)) (let* ((p (open-binary-output-file x)) (result (##output-port? p))) (##close-output-port p) (##delete-file x) result))

;;unimplemented;;(let ((p (open-input-bytevector '#u8(49 32 50)))) (let ((result (##read p))) (##close-port p) result))

(let ((p (open-input-string "1 2 3"))) (let ((result (##read p))) (##close-port p) result))

(let ((p (open-output-string))) (##write 123 p) (##get-output-string p))

;;unimplemented;;(output-port-open? (##current-output-port))

;;(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (peek-u8))))) (##delete-file x) result))
;;(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (peek-u8 p))))) (##delete-file x) result))

(port? (##current-input-port))

;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let ((result (##with-input-from-file x (lambda () (read-bytevector 1))))) (##delete-file x) result))
;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let ((result (##call-with-input-file x (lambda (p) (read-bytevector 1 p))))) (##delete-file x) result))

;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let* ((buf (##make-u8vector 10 0)) (result (##with-input-from-file x (lambda () (read-bytevector! buf))))) (##delete-file x) (##cons buf result)))
;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let* ((buf (##make-u8vector 10 0)) (result (##call-with-input-file x (lambda (p) (read-bytevector buf p))))) (##delete-file x) (##cons buf result)))
;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let* ((buf (##make-u8vector 10 0)) (result (##call-with-input-file x (lambda (p) (read-bytevector buf p 1))))) (##delete-file x) (##cons buf result)))
;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let* ((buf (##make-u8vector 10 0)) (result (##call-with-input-file x (lambda (p) (read-bytevector buf p 1 5))))) (##delete-file x) (##cons buf result)))

;;unimplemented;;read-error?

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (read-line))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-line p))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-line p #\newline))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-line p #\newline #t))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-line p #\newline #t 5))))) (##delete-file x) result))

;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (read-string 1))))) (##delete-file x) result))
;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-string 1 p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (read-u8))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-u8 p))))) (##delete-file x) result))

;;unimplemented;;(textual-port? (##current-input-port))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (u8-ready?))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (u8-ready? p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (write-bytevector '#u8(65 66 67 68 69 70 10)))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-bytevector '#u8(65 66 67 68 69 70 10) p))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-bytevector '#u8(65 66 67 68 69 70 10) p 2))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-bytevector '#u8(65 66 67 68 69 70 10) p 2 5))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (write-shared '(1 2 3)))) (let ((result (##with-input-from-file x ##read))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-shared '(1 2 3) p))) (let ((result (##with-input-from-file x ##read))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (write-simple '(1 2 3)))) (let ((result (##with-input-from-file x ##read))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-simple '(1 2 3) p))) (let ((result (##with-input-from-file x ##read))) (##delete-file x) result))

;;unimplemented;;(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (write-string "abcdef\n"))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))
;;unimplemented;;(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-string "abcdef\n" p))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))
;;unimplemented;;(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-string "abcdef\n" p 2))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))
;;unimplemented;;(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-string "abcdef\n" p 2 5))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (write-u8 10))) (let ((result (##with-input-from-file x ##read-u8))) (##delete-file x) result))
(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-u8 10 p))) (let ((result (##with-input-from-file x ##read-u8))) (##delete-file x) result))

;; Gambit

(call-with-input-process (##list path: "sort" arguments: (##list ##_input-file)) ##read-line)

(call-with-input-string "abc def" ##read)

(call-with-input-u8vector '#u8(65 66 67 32 68 69 70) ##read)

(call-with-input-vector '#(a b c) ##read)

(call-with-output-process "sort" ##newline)

(call-with-output-string ##newline) (call-with-output-string "abc" ##newline)

(call-with-output-u8vector ##newline) (call-with-output-u8vector '#u8(65 66 67) ##newline)

(call-with-output-vector (lambda (p) (##write 123 p))) (call-with-output-vector '#(1 2 3) (lambda (p) (##write 123 p)))

;;unimplemented;;(console-port)

(current-readtable)

(force-output) (force-output (##current-output-port))

(let ((p (##open-output-u8vector))) (get-output-u8vector p))

(let ((p (##open-output-vector))) (get-output-vector p))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-byte-position p))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-byte-position p 1))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-byte-position p 0 2))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-bytes-buffered p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-char-position p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-characters-buffered p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-column p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (input-port-line p))))) (##delete-file x) result))

(input-port-readtable (##current-input-port))

(input-port-readtable-set! (##current-input-port) (##input-port-readtable (##current-input-port)))

(input-port-timeout-set! (##current-input-port) +inf.0)
(input-port-timeout-set! (##current-input-port) +inf.0 (lambda () #f))

;;unimplemented;;make-tls-context

(object->string '(1 2 3 4 5)) (object->string '(1 2 3 4 5) 6)

(object->u8vector '(123 #f "")) (object->u8vector '(123 #f "") (lambda (x) (if (not x) '() x)))

(u8vector->object (object->u8vector '(123 #f ""))) (u8vector->object (object->u8vector '(123 #f "")) (lambda (x) (if (not x) '() x)))

(let* ((p (open-directory)) (result (##read p))) (##close-port p) result)
(let* ((p (open-directory ".")) (result (##read p))) (##close-port p) result)

(##port? (open-dummy))

;;unimplemented;;open-event-queue

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (open-file x)) (result (##port? p))) (##close-port p) (##delete-file x) result))

(let* ((p (open-input-process (##list path: "sort" arguments: (##list ##_input-file)))) (result (##read-line p))) (##close-input-port p) result)

(let* ((p (open-input-u8vector '#u8(65 66 67 32 68 69 70))) (result (##read p))) (##close-input-port p) result)

(let* ((p (open-input-vector '#(a b c))) (result (##read p))) (##close-input-port p) result)

(let ((p (open-output-process "sort"))) (##close-output-port p))

(let ((p (open-output-u8vector))) (##write 123 p) (let ((result (##get-output-u8vector p))) (##close-output-port p) result))
(let ((p (open-output-u8vector '#u8(65 66 67)))) (##write 123 p) (let ((result (##get-output-u8vector p))) (##close-output-port p) result))

(let ((p (open-output-vector))) (##write 123 p) (let ((result (##get-output-vector p))) (##close-output-port p) result))
(let ((p (open-output-vector '#(a b c)))) (##write 123 p) (let ((result (##get-output-vector p))) (##close-output-port p) result))

;;unimplemented;;open-process
;;unimplemented;;open-string
;;unimplemented;;open-string-pipe
;;unimplemented;;open-tcp-client
;;unimplemented;;open-tcp-server
;;unimplemented;;open-u8vector
;;unimplemented;;open-u8vector-pipe
;;unimplemented;;open-udp
;;unimplemented;;open-vector
;;unimplemented;;open-vector-pipe

(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (output-port-byte-position p))))) (##delete-file x) result))
(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (output-port-byte-position p 1))))) (##delete-file x) result))
(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (output-port-byte-position p 0 2))))) (##delete-file x) result))

(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (output-port-char-position p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (output-port-column p))))) (##delete-file x) result))

(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (output-port-line p))))) (##delete-file x) result))

(output-port-readtable (##current-output-port))

(output-port-readtable-set! (##current-output-port) (##output-port-readtable (##current-output-port)))

(output-port-timeout-set! (##current-output-port) +inf.0)
(output-port-timeout-set! (##current-output-port) +inf.0 (lambda () #f))

(let ((x ##_temp-file)) (let ((result (##call-with-output-file x (lambda (p) (output-port-width p))))) (##delete-file x) result))

(port-io-exception-handler-set! (##current-input-port) ##list)

(port-settings-set! (##current-input-port) '())

;;unimplemented;;pp

(##with-output-to-string (lambda () (pretty-print '(1 2 3)))) (##call-with-output-string (lambda (p) (pretty-print '(1 2 3) p)))

(##with-output-to-string (lambda () (print '(1 . 2)))) (##call-with-output-string (lambda (p) (print port: p '(1 . 2)))) (##call-with-output-string (lambda (p) (print port: p '(1 . 2) 3)))
(##with-output-to-string (lambda () (println '(1 . 2)))) (##call-with-output-string (lambda (p) (println port: p '(1 . 2)))) (##call-with-output-string (lambda (p) (println port: p '(1 . 2) 3)))

(let* ((p (##open-input-process (##list path: "sort" arguments: (##list ##_input-file)))) (result (##number? (process-pid p)))) (##close-input-port p) result)

(let* ((p (##open-input-process (##list path: "sort" arguments: (##list ##_input-file)))) (result (##number? (process-status p)))) (##close-input-port p) result)
(let* ((p (##open-input-process (##list path: "sort" arguments: (##list ##_input-file)))) (result (##number? (process-status p 10)))) (##close-input-port p) result)
(let* ((p (##open-input-process (##list path: "sort" arguments: (##list ##_input-file)))) (result (##number? (process-status p 10 42)))) (##close-input-port p) result)

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##with-input-from-file x (lambda () (read-all))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-all p))))) (##delete-file x) result))
(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let ((result (##call-with-input-file x (lambda (p) (read-all p ##read-char))))) (##delete-file x) result))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let* ((buf (##make-string 10 #\space)) (result (##call-with-input-file x (lambda (p) (read-substring buf 1 5 p))))) (##delete-file x) (##cons buf result)))

(let ((x ##_temp-file)) (##with-output-to-file x (lambda () (##display "ABCDEFGHIJ"))) (let* ((buf (##make-u8vector 10 0)) (result (##call-with-input-file x (lambda (p) (read-subu8vector buf 1 5 p))))) (##delete-file x) (##cons buf result)))

;;unimplemented;;readtable-case-conversion?
;;unimplemented;;readtable-case-conversion?-set
;;unimplemented;;readtable-comment-handler
;;unimplemented;;readtable-comment-handler-set
;;unimplemented;;readtable-eval-allowed?
;;unimplemented;;readtable-eval-allowed?-set
;;unimplemented;;readtable-keywords-allowed?
;;unimplemented;;readtable-keywords-allowed?-set
;;unimplemented;;readtable-max-unescaped-char
;;unimplemented;;readtable-max-unescaped-char-set
;;unimplemented;;readtable-max-write-length
;;unimplemented;;readtable-max-write-length-set
;;unimplemented;;readtable-max-write-level
;;unimplemented;;readtable-max-write-level-set
;;unimplemented;;readtable-sharing-allowed?
;;unimplemented;;readtable-sharing-allowed?-set
;;unimplemented;;readtable-start-syntax
;;unimplemented;;readtable-start-syntax-set
;;unimplemented;;readtable-write-cdr-read-macros?
;;unimplemented;;readtable-write-cdr-read-macros?-set
;;unimplemented;;readtable-write-extended-read-macros?
;;unimplemented;;readtable-write-extended-read-macros?-set
;;unimplemented;;readtable?
;;unimplemented;;tcp-client-local-socket-info
;;unimplemented;;tcp-client-peer-socket-info
;;unimplemented;;tcp-client-self-socket-info
;;unimplemented;;tcp-server-socket-info
;;unimplemented;;tcp-service-register!
;;unimplemented;;tcp-service-unregister!
;;unimplemented;;tty-history
;;unimplemented;;tty-history-max-length-set!
;;unimplemented;;tty-history-set!
;;unimplemented;;tty-mode-set!
;;unimplemented;;tty-paren-balance-duration-set!
;;unimplemented;;tty-text-attributes-set!
;;unimplemented;;tty-type-set!
;;unimplemented;;tty?
;;unimplemented;;udp-destination-set!
;;unimplemented;;udp-local-socket-info
;;unimplemented;;udp-read-subu8vector
;;unimplemented;;udp-read-u8vector
;;unimplemented;;udp-source-socket-info
;;unimplemented;;udp-write-subu8vector
;;unimplemented;;udp-write-u8vector

(let ((x ##_temp-file)) (##with-output-to-file x ##newline) (let* ((p (##open-input-file x)) (result (with-input-from-port p ##read-char))) (##close-port p) (##delete-file x) result))

(with-input-from-process (##list path: "sort" arguments: (##list ##_input-file)) ##read-line)

(with-input-from-string "abc def" ##read)

(with-input-from-u8vector '#u8(65 66 67 32 68 69 70) ##read)

(with-input-from-vector '#(a b c) ##read)

(let ((x ##_temp-file)) (let ((p (##open-output-file x))) (with-output-to-port p ##newline) (##close-port p) (let ((result (##with-input-from-file x ##read-char))) (##delete-file x) result)))

(with-output-to-process "sort" ##newline)

(with-output-to-string ##newline) (with-output-to-string "abc" ##newline)

(with-output-to-u8vector ##newline) (with-output-to-u8vector '#u8(65 66 67) ##newline)

(with-output-to-vector (lambda () (##write 123))) (with-output-to-vector '#(1 2 3) (lambda () (##write 123)))

(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-substring "ABCDEF" 2 5 p))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))

(let ((x ##_temp-file)) (##call-with-output-file x (lambda (p) (write-subu8vector '#u8(65 66 67 68 69 70 10) 2 5 p))) (let ((result (##with-input-from-file x ##read-line))) (##delete-file x) result))

(##delete-file ##_input-file)
)
