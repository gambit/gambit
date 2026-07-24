(include "#.scm")

(test-equal
 #!eof
 (with-input-from-string "" (lambda () (read-line))))

(test-equal
 ""
 (with-input-from-string "\n" (lambda () (read-line))))

(test-equal
 "a b,c"
 (with-input-from-string "a b,c\nd e,f\ng h,i" (lambda () (read-line))))

(test-equal
 #!eof
 (call-with-input-string "" (lambda (port) (read-line port))))

(test-equal
 ""
 (call-with-input-string "\n" (lambda (port) (read-line port))))

(test-equal
 "a b,c"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port))))

(test-equal
 "a b"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #\,))))

(test-equal
 "a b,c\nd e,f\ng h,i"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #f))))

(test-equal
 "a b"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #\, #f))))

(test-equal
 "a b,"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #\, #t))))

(test-equal
 "a b,c\n"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #\newline #t))))

(test-equal
 ""
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #\newline #t 0))))

(test-equal
 "a"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #\newline #t 1))))

(test-equal
 "a b"
 (call-with-input-string "a b,c\nd e,f\ng h,i" (lambda (port) (read-line port #\newline #t 3))))

(test-error-tail wrong-number-of-arguments-exception?
                 (read-line (current-input-port) #\newline #f 3 #f))

(test-error-tail type-exception?
                 (read-line #f #\newline #f 3))

;;TODO: this should be an error
;;(test-error-tail type-exception?
;;                 (read-line (current-input-port) "," #f 3))

(test-error-tail type-exception?
                 (read-line (current-input-port) #\newline #f #f))
