;;;============================================================================

;;; File: "_digest-test.scm"

;;; Copyright (c) 2005-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Test message digest computation.

(##import _digest)
(##import _test)

(define crc32-test-vectors
  '(
    ("" 0 ""
     "00000000")
    ("" 0 "a"
     "e8b7be43")
    ("" 0 "abc"
     "352441c2")
    ("" 0 "abcdefghijklmnopqrstuvwxyz"
     "4c2750bd")
    ("" 0 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
     "1fc2e6d2")
    ("" 0 "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
     "7ca94a72")
    ))

(define md5-test-vectors
  '(
    ;; from RFC 1321:
    ("" 0 ""
     "d41d8cd98f00b204e9800998ecf8427e")
    ("" 0 "a"
     "0cc175b9c0f1b6a831c399e269772661")
    ("" 0 "abc"
     "900150983cd24fb0d6963f7d28e17f72")
    ("" 0 "message digest"
     "f96b697d7cb7938d525a2f31aaf161d0")
    ("" 0 "abcdefghijklmnopqrstuvwxyz"
     "c3fcd3d76192e4007dfb496cca67e13b")
    ("" 0 "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
     "d174ab98d277d9f5a5611c2c9f419d9f")
    ("" 0 "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
     "57edf4a22be3c955ac49da2e2107b67a")
    ))

(define sha-1-test-vectors
  '(
    ("" 0 ""
     "da39a3ee5e6b4b0d3255bfef95601890afd80709")
    ;; from RFC 3174:
    ("" 0 "abc"
     "a9993e364706816aba3e25717850c26c9cd0d89d")
    ("" 0 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
     "84983e441c3bd26ebaae4aa1f95129e5e54670f1")
;;     ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 10000 ""
;;      "34aa973cd4c4daa4f61eeb2bdbad27316534016f")
    ("0123456701234567012345670123456701234567012345670123456701234567" 10 ""
     "dea356a2cddd90c7a7ecedc5ebb563934f460452")
    ))

(define sha-224-test-vectors
  '(
    ;; from RFC 3874:
    ("" 0 "abc"
     "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7")
    ("" 0 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
     "75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525")
;;     ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 10000 ""
;;      "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67")
   ))

(define sha-256-test-vectors
  '(
    ("" 0 ""
     "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855")
    ;; from FIPS-180-2:
    ("" 0 "abc"
     "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad")
    ("" 0 "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq"
     "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1")
;;     ("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa" 10000 ""
;;      "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0")
   ))

(define (digest-test)

  (namespace ("" pp list->u8vector))

  (define (t algorithm vectors)

    (for-each
     (lambda (v)
       (let ((str1 (car v))
             (repeat (cadr v))
             (str2 (caddr v))
             (expect (cadddr v)))
         (let ((md
                (if (fx= repeat 0)
                    (digest-string str2 algorithm 'hex)
                    (let ((u8vect1
                           (list->u8vector
                            (map char->integer (string->list str1))))
                          (u8vect2
                           (list->u8vector
                            (map char->integer (string->list str2))))
                          (digest
                           (open-digest algorithm)))
                      (let loop ((i 0))
                        (if (fx< i repeat)
                            (begin
                              (digest-update-subu8vector
                               digest
                               u8vect1
                               0
                               (u8vector-length u8vect1))
                              (loop (fx+ i 1)))
                            (begin
                              (digest-update-subu8vector
                               digest
                               u8vect2
                               0
                               (u8vector-length u8vect2))
                              (close-digest digest 'hex))))))))
           (check-equal? md expect)
           '
           (if (not (string-ci=? md expect))
               (pp (list '***error*** algorithm md expect))))))
     vectors))

  (t 'crc32 crc32-test-vectors)
  (t 'md5 md5-test-vectors)
  (t 'sha-1 sha-1-test-vectors)
  (t 'sha-224 sha-224-test-vectors)
  (t 'sha-256 sha-256-test-vectors)
)

(digest-test)

;;;============================================================================
