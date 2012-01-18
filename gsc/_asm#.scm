;;;============================================================================

;;; File: "_asm#.scm"

;;; Copyright (c) 1994-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(namespace ("_asm#"

asm-implement

asm-code-block-size
asm-make-code-block
asm-copy-code-block
asm-init-code-block
asm-code-block-start-pos
asm-code-block-start-pos-set!
asm-code-block-endianness
asm-code-block-endianness-set!
asm-code-block-stream
asm-code-block-stream-set!

asm-8
asm-16
asm-16-be
asm-16-le
asm-32
asm-32-be
asm-32-le
asm-64
asm-64-be
asm-64-le
asm-int
asm-int-be
asm-int-le
asm-f32
asm-f64
asm-UTF-8-string
asm-make-label
asm-label?
asm-label
asm-label-id
asm-label-name
asm-label-pos
asm-align
asm-origin
asm-at-assembly
asm-listing
asm-separated-list
asm-display-listing
asm-assemble
asm-assemble-to-file
asm-assemble-to-u8vector
;;asm-write-hex-file

asm-signed8?
asm-signed16?
asm-signed32?
asm-signed-lo8
asm-unsigned-lo8
asm-signed-lo16
asm-unsigned-lo16
asm-signed-lo32
asm-unsigned-lo32
asm-signed-lo64
asm-unsigned-lo64
asm-signed-lo
asm-unsigned-lo

))

;;;============================================================================

(define-macro (asm-implement)
  `(begin))

(define-macro (asm-code-block-size) 4)

(define-macro (asm-code-block-start-pos cb)         `(vector-ref ,cb 1))
(define-macro (asm-code-block-start-pos-set! cb x)  `(vector-set! ,cb 1 ,x))

(define-macro (asm-code-block-endianness cb)        `(vector-ref ,cb 2))
(define-macro (asm-code-block-endianness-set! cb x) `(vector-set! ,cb 2 ,x))

(define-macro (asm-code-block-stream cb)            `(vector-ref ,cb 3))
(define-macro (asm-code-block-stream-set! cb x)     `(vector-set! ,cb 3 ,x))

;;;============================================================================
