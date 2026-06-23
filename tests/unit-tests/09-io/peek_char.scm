(include "#.scm")

(test-equal #\newline (with-input-from-string "\n" (lambda () (peek-char))))

(test-equal #!eof (with-input-from-string "" (lambda () (peek-char))))

(test-equal
 '(#\a #\a #\a)
 (with-input-from-string
  "ab"
  (lambda ()
    (let* ((a (peek-char)) (b (peek-char)) (c (peek-char))) (list a b c)))))

(test-equal
 '(#\a #\a #\a)
 (call-with-input-string
  "ab"
  (lambda (port)
    (let* ((a (peek-char port)) (b (peek-char port)) (c (peek-char port)))
      (list a b c)))))

(test-error-tail
 wrong-number-of-arguments-exception?
 (peek-char (current-input-port) #f))

(test-error-tail type-exception? (peek-char #f))
