;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; SRFI 6, Basic String Ports

(import (srfi 6))
(import (_test))

;;;============================================================================

(define p
  (open-input-string "(a . (b . (c . ()))) 34"))

(test-assert (input-port? p))
(test-equal '(a b c) (read p))
(test-equal 34 (read p))
(test-assert (eof-object? (peek-char p)))

(let ((q (open-output-string))
      (x '(a b c)))
  (write (car x) q)
  (write (cdr x) q)
  (test-equal "a(b c)" (get-output-string q)))

(test-assert (input-port? (open-input-string "  (0 ; 1 \n 2 3) (4 5)")))

(test-equal '(0 2 3) (read (open-input-string "  (0 ; 1 \n 2 3) (4 5)")))

(test-assert (eof-object? (read (open-input-string ""))))

(test-assert (output-port? (open-output-string)))

(let ((port (open-output-string)))
  (display "a" port)
  (write "b" port)
  (display "c" port)
  (test-equal "a\"b\"c" (get-output-string port)))

(test-error-tail
 type-exception?
 (open-input-string #f))

#; ;; 0 parameters is allowed with Gambit
(test-error-tail
 wrong-number-of-arguments-exception?
 (open-input-string))

(test-error-tail
 wrong-number-of-arguments-exception?
 (open-input-string "" #f))

#; ;; 1 parameter is allowed with Gambit
(test-error-tail
 wrong-number-of-arguments-exception?
 (open-output-string ""))

#; ;; 1 parameter is allowed with Gambit
(test-error-tail
 type-exception?
 (open-output-string #f))

(test-error-tail
 type-exception?
 (get-output-string #f))

(test-error-tail
 wrong-number-of-arguments-exception?
 (get-output-string))

(let ((port (open-output-string)))
  (test-error-tail
   wrong-number-of-arguments-exception?
   (get-output-string port #f)))

;;;============================================================================
