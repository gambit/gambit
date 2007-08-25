(c-define (f str) (nonnull-char-string) int "f" ""
  (string->number str))
(define t1 (c-lambda () int "___result = f (\"123\");"))
(define t2 (c-lambda () int "___result = f (NULL);"))
(define t3 (c-lambda () int "___result = f (\"1.5\");"))
