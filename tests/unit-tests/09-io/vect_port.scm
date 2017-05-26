(include "#.scm")

(define (read-n-chars n port)
  (let loop ((n n) (lst '()))
    (if (> n 0)
        (let ((c (read-char port)))
          (loop (- n 1) (cons c lst)))
        (reverse lst))))

(define (gen-char i mod)
  (integer->char
   (vector-ref
    '#(#x0000 #x007F
       #x0080 #x07FF
       #x0800 #xFFF0
       #x10000 #x10FFFF)
    (modulo i mod))))

(define (test1 port mod)
  (let loop ((i 0))
    (if (< i 1000)
        (begin
          (check-eqv? (output-port-char-position port) i)
          (if (= 9 (modulo i 10))
              (newline port)
              (display (gen-char i mod) port))
          (loop (+ i 1))))))

(define (test2 port mod)
  (define len 10)
  (let loop ((i 0))
    (if (< i 1000)
        (begin
          (check-eqv? (output-port-char-position port) i)
          (if (= 9 (modulo i 10))
              (newline port)
              (display (gen-char i mod) port))
          (if (= 20 (modulo i 21))
              (begin
                (force-output port)
                (read-n-chars len port)))
          (loop (+ i 1)))
        (begin
          (close-port port)
          (let ((str (read-line port #f #t)))
            (check-eqv? (string-length str) 530))))))

(define (test3 port get-vect mod)
  (let loop ((i 0))
    (if (< i 1000)
        (begin
          (check-eqv? (output-port-char-position port) i)
          (if (= 9 (modulo i 10))
              (newline port)
              (display (gen-char i mod) port))
          (if (= 20 (modulo i 21)) (get-vect port))
          (loop (+ i 1))))))

(define (test-str)
  (test1 (open-output-string) 8)
  (test1 (open-string) 8)
  (test2 (open-string) 8)
  (test3 (open-output-string)
         (lambda (port) (get-output-string port))
         8)
  (test3 (open-string)
         (lambda (port) (get-output-string port))
         8))

(define (test-u8vect x)
  (let ((char-enc (car x))
        (mod (cadr x)))
    (test1 (open-output-u8vector (list char-encoding: char-enc)) mod)
    (test1 (open-u8vector (list char-encoding: char-enc)) mod)
    (test2 (open-u8vector (list char-encoding: char-enc)) mod)
    (test3 (open-output-u8vector (list char-encoding: char-enc))
           (lambda (port) (get-output-u8vector port)) mod)
    (test3 (open-u8vector (list char-encoding: char-enc))
           (lambda (port) (get-output-u8vector port)) mod)))

(test-str)

(for-each
 test-u8vect
 '(
   (ASCII 2)
   (ISO-8859-1 2)
   (UTF-8 8)
   (UTF-16 8)
   (UTF-16LE 8)
   (UTF-16BE 8)
   (UTF 8)
   (UTF-fallback-ASCII 8)
   (UTF-fallback-ISO-8859-1 8)
   (UTF-fallback-UTF-8 8)
   (UTF-fallback-UTF-16 8)
   (UTF-fallback-UTF-16LE 8)
   (UTF-fallback-UTF-16BE 8)
   (UCS-2 6)
   (UCS-2LE 6)
   (UCS-2BE 6)
   (UCS-4 8)
   (UCS-4LE 8)
   (UCS-4BE 8)
   ))
