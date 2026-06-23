(include "#.scm")

(test-equal #\newline (with-input-from-string "\n" (lambda () (read-char))))

(test-equal #!eof (with-input-from-string "" (lambda () (read-char))))

(test-equal
 '(#\a #\b #!eof)
 (with-input-from-string
  "ab"
  (lambda ()
    (let* ((a (read-char)) (b (read-char)) (c (read-char))) (list a b c)))))

(test-equal
 '(#\a #\b #!eof)
 (call-with-input-string
  "ab"
  (lambda (port)
    (let* ((a (read-char port)) (b (read-char port)) (c (read-char port)))
      (list a b c)))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (read-char (current-input-port) #f))

(test-error-tail type-exception? (read-char #f))
