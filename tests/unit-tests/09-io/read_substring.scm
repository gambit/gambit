(include "#.scm")

(test-equal
 '(0 "01234567")
 (with-input-from-string "" (lambda () (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (list (read-substring str 2 5) str)))))

(test-equal
 '(2 "01ab4567")
 (with-input-from-string "ab" (lambda () (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (list (read-substring str 2 5) str)))))

(test-equal
 '(3 "01abc567")
 (with-input-from-string "abcde" (lambda () (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (list (read-substring str 2 5) str)))))

(test-equal
 '(3 "01abc567")
 (call-with-input-string "abcde" (lambda (port) (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (list (read-substring str 2 5 port) str)))))

(test-equal
 '(3 "01abc567")
 (call-with-input-string "abcde" (lambda (port) (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (list (read-substring str 2 5 port 0) str)))))

(test-error-tail wrong-number-of-arguments-exception?
                 (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (read-substring)))

(test-error-tail wrong-number-of-arguments-exception?
                 (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (read-substring str 2)))

(test-error-tail wrong-number-of-arguments-exception?
                 (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (read-substring str 2 5 (current-input-port) 0 #f)))

(test-error-tail type-exception? (read-substring #f 2 5))

(test-error-tail type-exception?
                 (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (read-substring str #f 5)))

(test-error-tail type-exception?
                 (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (read-substring str 2 #f)))

(test-error-tail type-exception?
                 (let ((str (string #\0 #\1 #\2 #\3 #\4 #\5 #\6 #\7))) (read-substring str 2 5 #f)))
