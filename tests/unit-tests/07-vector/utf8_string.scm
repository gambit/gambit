(include "#.scm")

(check-equal? (utf8->string '#u8(65 66 67)) "ABC")
(check-equal? (utf8->string '#u8(65 66 67) 0) "ABC")
(check-equal? (utf8->string '#u8(65 66 67) 3) "")
(check-equal? (utf8->string '#u8(65 66 67) 1 3) "BC")
(check-equal? (utf8->string '#u8(65 66 67) 3 3) "")
(check-equal? (utf8->string '#u8(128 65 66 67 128) 1 4) "ABC")

(check-equal? (utf8->string '#u8()) "")
(check-equal? (utf8->string '#u8(#x00)) "\x0;")
(check-equal? (utf8->string '#u8(#x7F)) "\x7f;")
(check-equal? (utf8->string '#u8(#xC2 #x80)) "\x80;")
(check-equal? (utf8->string '#u8(#xC2 #xBF)) "\xbf;")
(check-equal? (utf8->string '#u8(#xC3 #xBF)) "\xff;")

(define-macro (if-max-char-greater-than n code-as-string)
  (if (> ##max-char n)
      `(begin ,@(with-input-from-string code-as-string read-all))
      `(begin)))

(if-max-char-greater-than 255 #<<end-of-at-least-2-byte-chars
(check-equal? (utf8->string '#u8(#xDF #x80)) "\x7c0;")
(check-equal? (utf8->string '#u8(#xDF #xBF)) "\x7ff;")
(check-equal? (utf8->string '#u8(#xE0 #xA0 #x80)) "\x800;")
(check-equal? (utf8->string '#u8(#xE0 #xA0 #xBF)) "\x83f;")
(check-equal? (utf8->string '#u8(#xE0 #xBF #x80)) "\xfc0;")
(check-equal? (utf8->string '#u8(#xE0 #xBF #xBF)) "\xfff;")
(check-equal? (utf8->string '#u8(#xE1 #x80 #x80)) "\x1000;")
(check-equal? (utf8->string '#u8(#xE1 #x80 #xBF)) "\x103f;")
(check-equal? (utf8->string '#u8(#xE1 #xBF #x80)) "\x1fc0;")
(check-equal? (utf8->string '#u8(#xE1 #xBF #xBF)) "\x1fff;")
(check-equal? (utf8->string '#u8(#xEF #x80 #x80)) "\xf000;")
(check-equal? (utf8->string '#u8(#xEF #x80 #xBF)) "\xf03f;")
(check-equal? (utf8->string '#u8(#xEF #xBF #x80)) "\xffc0;")
(check-equal? (utf8->string '#u8(#xEF #xBF #xBF)) "\xffff;")
(check-equal? (utf8->string '#u8(#xED #x9F #xBF)) "\xd7ff;")
(check-equal? (utf8->string '#u8(#xEE #x80 #x80)) "\xe000;")
(check-equal? (utf8->string '#u8(#xEF #xBF #xBF)) "\xffff;")
end-of-at-least-2-byte-chars
)

(if-max-char-greater-than 65535 #<<end-of-4-byte-chars
(check-equal? (utf8->string '#u8(#xF0 #x90 #x80 #x80)) "\x10000;")
(check-equal? (utf8->string '#u8(#xF0 #x90 #x80 #xBF)) "\x1003f;")
(check-equal? (utf8->string '#u8(#xF0 #x90 #xBF #x80)) "\x10fc0;")
(check-equal? (utf8->string '#u8(#xF0 #x90 #xBF #xBF)) "\x10fff;")
(check-equal? (utf8->string '#u8(#xF0 #xBF #x80 #x80)) "\x3f000;")
(check-equal? (utf8->string '#u8(#xF0 #xBF #x80 #xBF)) "\x3f03f;")
(check-equal? (utf8->string '#u8(#xF0 #xBF #xBF #x80)) "\x3ffc0;")
(check-equal? (utf8->string '#u8(#xF0 #xBF #xBF #xBF)) "\x3ffff;")
(check-equal? (utf8->string '#u8(#xF1 #x80 #x80 #x80)) "\x40000;")
(check-equal? (utf8->string '#u8(#xF1 #x80 #x80 #xBF)) "\x4003f;")
(check-equal? (utf8->string '#u8(#xF1 #x80 #xBF #x80)) "\x40fc0;")
(check-equal? (utf8->string '#u8(#xF1 #x80 #xBF #xBF)) "\x40fff;")
(check-equal? (utf8->string '#u8(#xF1 #xBF #x80 #x80)) "\x7f000;")
(check-equal? (utf8->string '#u8(#xF1 #xBF #x80 #xBF)) "\x7f03f;")
(check-equal? (utf8->string '#u8(#xF1 #xBF #xBF #x80)) "\x7ffc0;")
(check-equal? (utf8->string '#u8(#xF1 #xBF #xBF #xBF)) "\x7ffff;")
(check-equal? (utf8->string '#u8(#xF3 #x80 #x80 #x80)) "\xc0000;")
(check-equal? (utf8->string '#u8(#xF3 #x80 #x80 #xBF)) "\xc003f;")
(check-equal? (utf8->string '#u8(#xF3 #x80 #xBF #x80)) "\xc0fc0;")
(check-equal? (utf8->string '#u8(#xF3 #x80 #xBF #xBF)) "\xc0fff;")
(check-equal? (utf8->string '#u8(#xF3 #xBF #x80 #x80)) "\xff000;")
(check-equal? (utf8->string '#u8(#xF3 #xBF #x80 #xBF)) "\xff03f;")
(check-equal? (utf8->string '#u8(#xF3 #xBF #xBF #x80)) "\xfffc0;")
(check-equal? (utf8->string '#u8(#xF3 #xBF #xBF #xBF)) "\xfffff;")
(check-equal? (utf8->string '#u8(#xF4 #x80 #x80 #x80)) "\x100000;")
(check-equal? (utf8->string '#u8(#xF4 #x80 #x80 #xBF)) "\x10003f;")
(check-equal? (utf8->string '#u8(#xF4 #x80 #xBF #x80)) "\x100fc0;")
(check-equal? (utf8->string '#u8(#xF4 #x80 #xBF #xBF)) "\x100fff;")
(check-equal? (utf8->string '#u8(#xF4 #x8F #x80 #x80)) "\x10f000;")
(check-equal? (utf8->string '#u8(#xF4 #x8F #x80 #xBF)) "\x10f03f;")
(check-equal? (utf8->string '#u8(#xF4 #x8F #xBF #x80)) "\x10ffc0;")
(check-equal? (utf8->string '#u8(#xF4 #x8F #xBF #xBF)) "\x10ffff;")
end-of-4-byte-chars
)

(check-tail-exn type-exception? (lambda () (utf8->string #f)))
(check-tail-exn type-exception? (lambda () (utf8->string '#u8(65 66 67) #f)))
(check-tail-exn type-exception? (lambda () (utf8->string '#u8(65 66 67) 0 #f)))

(check-tail-exn range-exception? (lambda () (utf8->string '#u8(65 66 67) -1)))
(check-tail-exn range-exception? (lambda () (utf8->string '#u8(65 66 67) 4)))
(check-tail-exn range-exception? (lambda () (utf8->string '#u8(65 66 67) 0 4)))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x80))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x80 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x80 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x80 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x81))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x81 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x81 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x81 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x82))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x82 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x82 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x82 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x83))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x83 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x83 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x83 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x84))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x84 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x84 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x84 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x85))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x85 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x85 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x85 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x86))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x86 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x86 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x86 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x87))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x87 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x87 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x87 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x88))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x88 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x88 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x88 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x89))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x89 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x89 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x89 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8A))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8A #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8A #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8A #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8B))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8B #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8B #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8B #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8C))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8C #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8C #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8C #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8D))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8D #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8D #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8D #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x8F #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x90))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x90 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x90 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x90 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x91))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x91 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x91 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x91 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x92))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x92 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x92 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x92 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x93))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x93 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x93 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x93 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x94))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x94 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x94 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x94 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x95))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x95 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x95 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x95 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x96))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x96 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x96 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x96 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x97))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x97 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x97 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x97 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x98))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x98 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x98 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x98 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x99))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x99 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x99 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x99 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9A))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9A #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9A #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9A #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9B))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9B #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9B #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9B #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9C))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9C #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9C #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9C #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9D))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9D #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9D #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9D #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#x9F #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA0))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA0 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA0 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA0 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA1))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA1 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA1 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA1 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA2))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA2 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA2 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA2 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA3))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA3 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA3 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA3 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA4))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA4 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA4 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA4 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA5))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA5 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA5 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA5 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA6))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA6 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA6 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA6 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA7))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA7 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA7 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA7 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA8))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA8 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA8 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA8 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA9))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA9 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA9 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xA9 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAA))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAA #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAA #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAA #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAB))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAB #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAB #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAB #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAC))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAC #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAC #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAC #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAD))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAD #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAD #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAD #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAF))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAF #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAF #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xAF #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB0))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB0 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB0 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB0 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB1))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB1 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB1 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB1 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB2))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB2 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB2 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB2 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB3))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB3 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB3 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB3 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB4))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB4 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB4 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB4 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB5))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB5 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB5 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB5 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB6))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB6 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB6 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB6 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB7))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB7 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB7 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB7 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB8))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB8 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB8 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB8 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB9))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB9 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB9 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xB9 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBA))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBA #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBA #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBA #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBB))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBB #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBB #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBB #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBC))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBC #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBC #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBC #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBD))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBD #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBD #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBD #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBF))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBF #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBF #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xBF #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF5))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF5 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF5 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF5 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF6))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF6 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF6 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF6 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF7))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF7 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF7 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF7 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF8))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF8 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF8 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF8 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF9))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF9 #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF9 #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF9 #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFA))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFA #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFA #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFA #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFB))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFB #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFB #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFB #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFC))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFC #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFC #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFC #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFD))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFD #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFD #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFD #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFF))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFF #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFF #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xFF #x8F #x8F #x8F))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xED #xA0 #x80))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xED #xBF #xBF))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF4 #x90 #x80 #x80))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF4 #xBF #xBF #xBF))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xC0 #x80))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xC1 #xBF))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xE0 #x80 #x80))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xE0 #x9F #xBF))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF0 #x80 #x80 #x80))))

(check-tail-exn invalid-utf8-encoding-exception?
                (lambda () (utf8->string '#u8(#xF0 #x8F #xBF #xBF))))

(check-tail-exn wrong-number-of-arguments-exception? (lambda () (utf8->string)))
(check-tail-exn wrong-number-of-arguments-exception? (lambda () (utf8->string '#u8() 0 0 0)))
