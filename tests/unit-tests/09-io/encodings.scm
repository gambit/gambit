(include "#.scm")

(define (test-hello-world char-enc)
  (let ((p (open-u8vector (list char-encoding: char-enc)))
        (str "hello world!"))
    (begin
      (display str p)
      (newline p)
      (force-output p)
      (let ((str-read (read-line p)))
        (println str-read)
        (check-eqv? (string=? str str-read) #t)))))

(define (test-multiple-lines char-enc)
  (let ((p (open-u8vector (list char-encoding: char-enc)))
        (str1 "this is the first line")
        (str2 "this is a looooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooong line")
        (str3 "\"this is a line with escaped chars\""))

    (let ((str-list (list str1 str2 str3)))
      (begin

        (for-each
         (lambda (str)
           (begin
             (display str p)
             (newline p)))
         str-list)

        (force-output p)

        (for-each
         (lambda (str)
           (check-eqv? (equal? (read-line p) str) #t))
         str-list)
        
        ))))

(define (test-with-file char-enc)
  (let ((p (open-file (list path: "unit-tests/09-io/char-encodings-test.txt"
                            char-encoding: char-enc
                            create: 'maybe)))
        (str "hello world to a file!"))
    (begin
      (display str p)
      (newline p)
      (force-output p)
      (input-port-byte-position p 0)
      (let ((str-read-from-file (read-line p)))
        (println str-read-from-file)
        (check-eqv? (string=? str str-read-from-file) #t))
      (close-port p))))

(define (test-with-symbols char-enc)
  (let ((p (open-u8vector (list char-encoding: char-enc)))
        (str "܀ݙਂᢳ"))
    (begin
      (display str p)
      (newline p)
      (force-output p)
      (let ((str-read (read-line p)))
        (println str-read)
        (println (string=? str str-read) #t)))))


(define char-encodings
  '(
    ASCII
    ISO-8859-1
    UTF-8
    UTF-16
    UTF-16LE
    UTF-16BE
    UTF
    UTF-fallback-ASCII
    UTF-fallback-ISO-8859-1
    UTF-fallback-UTF-8
    UTF-fallback-UTF-16
    UTF-fallback-UTF-16LE
    UTF-fallback-UTF-16BE
    UCS-2
    UCS-2LE
    UCS-2BE
    UCS-4
    UCS-4LE
    UCS-4BE
    ))

(for-each
 test-hello-world
 char-encodings)

(for-each
 test-multiple-lines
 char-encodings)

(for-each
 test-with-file
 char-encodings)

(for-each
 test-with-symbols
 (cddr char-encodings)) ;; skip ASCII and ISO-8859-1
