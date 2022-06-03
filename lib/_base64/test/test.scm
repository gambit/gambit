;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2005-2022 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Test base64 encoding/decoding.

(import _base64)
(import _test)

(define test-vectors
  '(

    (""
     ""
     #u8())

    ("Zg=="
     "Zg=="
     #u8(102))

    ("Zm8="
     "Zm8="
     #u8(102 111))

    ("Zm9v"
     "Zm9v"
     #u8(102 111 111))

    ("Zm9vYg=="
     "Zm9vY\ng=="
     #u8(102 111 111 98))

    ("Zm9vYmE="
     "Zm9vY\nmE="
     #u8(102 111 111 98 97))

    ("Zm9vYmFy"
     "Zm9vY\nmFy"
     #u8(102 111 111 98 97 114))

    ("AA=="
     "AA=="
     #u8(0))

    ("Kioq"
     "Kioq"
     #u8(42 42 42))

    ("AQIDBA=="
     "AQIDB\nA=="
     #u8(1 2 3 4))

    ("ra2tra0="
     "ra2tr\na0="
     #u8(173 173 173 173 173))

    ("//////8="
     "_____\n_8="
     #u8(255 255 255 255 255))

    ("QME/vQVMciqjwvIRc8Bp6kl9NSlrzCRl9vnQQQh716k="
     "QME_v\nQVMci\nqjwvI\nRc8Bp\n6kl9N\nSlrzC\nRl9vn\nQQQh7\n16k="
     #u8(64 193 63 189 5 76 114 42 163 194 242 17 115 192 105 234 73 125 53 41 107 204 36 101 246 249 208 65 8 123 215 169))

    ("+//+"
     "-__-"
     #u8(251 255 254))

   ))

(define (base64-test)
  (for-each
   (lambda (v)
     (let ((str1 (car v))
           (str2 (cadr v))
           (expect (caddr v)))

       (test-equal expect
                   (base64->u8vector str1))
       (test-equal expect
                   (base64->u8vector str1 0))
       (test-equal expect
                   (base64->u8vector str1 0 (string-length str1)))

       (test-equal expect
                   (base64->u8vector str2 0 (string-length str2) #\- #\_))

       (test-equal str1
                   (u8vector->base64 expect))
       (test-equal str1
                   (u8vector->base64 expect 0))
       (test-equal str1
                   (u8vector->base64 expect 0 (u8vector-length expect)))

       (test-equal str2
                   (u8vector->base64 expect 0 (u8vector-length expect) #\- #\_ 5))))
   test-vectors))

(base64-test)

;;;============================================================================
