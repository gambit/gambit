;;;============================================================================

;;; File: "srfi/6/6-test.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 6, Basic String Ports

(import (srfi 6))
(import (gambit test))

;;;============================================================================

(define p
  (open-input-string "(a . (b . (c . ()))) 34"))

(check-true (input-port? p))
(check-equal? (read p) '(a b c))
(check-equal? (read p) 34)
(check-true (eof-object? (peek-char p)))

(let ((q (open-output-string))
      (x '(a b c)))
  (write (car x) q)
  (write (cdr x) q)
  (check-equal? (get-output-string q) "a(b c)"))

(check-true (input-port? (open-input-string "  (0 ; 1 \n 2 3) (4 5)")))

(check-equal? (read (open-input-string "  (0 ; 1 \n 2 3) (4 5)")) '(0 2 3))

(check-true (eof-object? (read (open-input-string ""))))

(check-true (output-port? (open-output-string)))

(let ((port (open-output-string)))
  (display "a" port)
  (write "b" port)
  (display "c" port)
  (check-equal? (get-output-string port) "a\"b\"c"))

(check-tail-exn
 type-exception?
 (lambda () (open-input-string #f)))

#; ;; 0 parameters is allowed with Gambit
(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (open-input-string)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (open-input-string "" #f)))

#; ;; 1 parameter is allowed with Gambit
(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (open-output-string "")))

#; ;; 1 parameter is allowed with Gambit
(check-tail-exn
 type-exception?
 (lambda () (open-output-string #f)))

(check-tail-exn
 type-exception?
 (lambda () (get-output-string #f)))

(check-tail-exn
 wrong-number-of-arguments-exception?
 (lambda () (get-output-string)))

(let ((port (open-output-string)))
  (check-tail-exn
   wrong-number-of-arguments-exception?
   (lambda () (get-output-string port #f))))

;;;============================================================================
