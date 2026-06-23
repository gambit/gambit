(include "#.scm")

(test-equal "ABC" (utf8->string '#u8(65 66 67)))
(test-equal "ABC" (utf8->string '#u8(65 66 67) 0))
(test-equal "" (utf8->string '#u8(65 66 67) 3))
(test-equal "BC" (utf8->string '#u8(65 66 67) 1 3))
(test-equal "" (utf8->string '#u8(65 66 67) 3 3))
(test-equal "ABC" (utf8->string '#u8(128 65 66 67 128) 1 4))

(test-equal "" (utf8->string '#u8()))
(test-equal "\x0;" (utf8->string '#u8(#x00)))
(test-equal "\x7f;" (utf8->string '#u8(#x7F)))
(test-equal "\x80;" (utf8->string '#u8(#xC2 #x80)))
(test-equal "\xbf;" (utf8->string '#u8(#xC2 #xBF)))
(test-equal "\xff;" (utf8->string '#u8(#xC3 #xBF)))

(define-macro (if-max-char-code-greater-than n code-as-string)
  (if (> (##max-char-code) n)
      `(begin ,@(with-input-from-string code-as-string read-all))
      `(begin)))

(if-max-char-code-greater-than 255 #<<end-of-at-least-2-byte-chars
(test-equal "\x7c0;" (utf8->string '#u8(#xDF #x80)))
(test-equal "\x7ff;" (utf8->string '#u8(#xDF #xBF)))
(test-equal "\x800;" (utf8->string '#u8(#xE0 #xA0 #x80)))
(test-equal "\x83f;" (utf8->string '#u8(#xE0 #xA0 #xBF)))
(test-equal "\xfc0;" (utf8->string '#u8(#xE0 #xBF #x80)))
(test-equal "\xfff;" (utf8->string '#u8(#xE0 #xBF #xBF)))
(test-equal "\x1000;" (utf8->string '#u8(#xE1 #x80 #x80)))
(test-equal "\x103f;" (utf8->string '#u8(#xE1 #x80 #xBF)))
(test-equal "\x1fc0;" (utf8->string '#u8(#xE1 #xBF #x80)))
(test-equal "\x1fff;" (utf8->string '#u8(#xE1 #xBF #xBF)))
(test-equal "\xf000;" (utf8->string '#u8(#xEF #x80 #x80)))
(test-equal "\xf03f;" (utf8->string '#u8(#xEF #x80 #xBF)))
(test-equal "\xffc0;" (utf8->string '#u8(#xEF #xBF #x80)))
(test-equal "\xffff;" (utf8->string '#u8(#xEF #xBF #xBF)))
(test-equal "\xd7ff;" (utf8->string '#u8(#xED #x9F #xBF)))
(test-equal "\xe000;" (utf8->string '#u8(#xEE #x80 #x80)))
(test-equal "\xffff;" (utf8->string '#u8(#xEF #xBF #xBF)))
end-of-at-least-2-byte-chars
)

(if-max-char-code-greater-than 65535 #<<end-of-4-byte-chars
(test-equal "\x10000;" (utf8->string '#u8(#xF0 #x90 #x80 #x80)))
(test-equal "\x1003f;" (utf8->string '#u8(#xF0 #x90 #x80 #xBF)))
(test-equal "\x10fc0;" (utf8->string '#u8(#xF0 #x90 #xBF #x80)))
(test-equal "\x10fff;" (utf8->string '#u8(#xF0 #x90 #xBF #xBF)))
(test-equal "\x3f000;" (utf8->string '#u8(#xF0 #xBF #x80 #x80)))
(test-equal "\x3f03f;" (utf8->string '#u8(#xF0 #xBF #x80 #xBF)))
(test-equal "\x3ffc0;" (utf8->string '#u8(#xF0 #xBF #xBF #x80)))
(test-equal "\x3ffff;" (utf8->string '#u8(#xF0 #xBF #xBF #xBF)))
(test-equal "\x40000;" (utf8->string '#u8(#xF1 #x80 #x80 #x80)))
(test-equal "\x4003f;" (utf8->string '#u8(#xF1 #x80 #x80 #xBF)))
(test-equal "\x40fc0;" (utf8->string '#u8(#xF1 #x80 #xBF #x80)))
(test-equal "\x40fff;" (utf8->string '#u8(#xF1 #x80 #xBF #xBF)))
(test-equal "\x7f000;" (utf8->string '#u8(#xF1 #xBF #x80 #x80)))
(test-equal "\x7f03f;" (utf8->string '#u8(#xF1 #xBF #x80 #xBF)))
(test-equal "\x7ffc0;" (utf8->string '#u8(#xF1 #xBF #xBF #x80)))
(test-equal "\x7ffff;" (utf8->string '#u8(#xF1 #xBF #xBF #xBF)))
(test-equal "\xc0000;" (utf8->string '#u8(#xF3 #x80 #x80 #x80)))
(test-equal "\xc003f;" (utf8->string '#u8(#xF3 #x80 #x80 #xBF)))
(test-equal "\xc0fc0;" (utf8->string '#u8(#xF3 #x80 #xBF #x80)))
(test-equal "\xc0fff;" (utf8->string '#u8(#xF3 #x80 #xBF #xBF)))
(test-equal "\xff000;" (utf8->string '#u8(#xF3 #xBF #x80 #x80)))
(test-equal "\xff03f;" (utf8->string '#u8(#xF3 #xBF #x80 #xBF)))
(test-equal "\xfffc0;" (utf8->string '#u8(#xF3 #xBF #xBF #x80)))
(test-equal "\xfffff;" (utf8->string '#u8(#xF3 #xBF #xBF #xBF)))
(test-equal "\x100000;" (utf8->string '#u8(#xF4 #x80 #x80 #x80)))
(test-equal "\x10003f;" (utf8->string '#u8(#xF4 #x80 #x80 #xBF)))
(test-equal "\x100fc0;" (utf8->string '#u8(#xF4 #x80 #xBF #x80)))
(test-equal "\x100fff;" (utf8->string '#u8(#xF4 #x80 #xBF #xBF)))
(test-equal "\x10f000;" (utf8->string '#u8(#xF4 #x8F #x80 #x80)))
(test-equal "\x10f03f;" (utf8->string '#u8(#xF4 #x8F #x80 #xBF)))
(test-equal "\x10ffc0;" (utf8->string '#u8(#xF4 #x8F #xBF #x80)))
(test-equal "\x10ffff;" (utf8->string '#u8(#xF4 #x8F #xBF #xBF)))
end-of-4-byte-chars
)
(test-error-tail type-exception? (utf8->string #f))
(test-error-tail type-exception? (utf8->string '#u8(65 66 67) #f))
(test-error-tail type-exception? (utf8->string '#u8(65 66 67) 0 #f))

(test-error-tail range-exception? (utf8->string '#u8(65 66 67) -1))
(test-error-tail range-exception? (utf8->string '#u8(65 66 67) 4))
(test-error-tail range-exception? (utf8->string '#u8(65 66 67) 0 4))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(128)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(128 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(128 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(128 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(129)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(129 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(129 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(129 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(130)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(130 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(130 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(130 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(131)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(131 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(131 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(131 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(132)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(132 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(132 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(132 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(133)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(133 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(133 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(133 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(134)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(134 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(134 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(134 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(135)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(135 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(135 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(135 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(136)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(136 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(136 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(136 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(137)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(137 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(137 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(137 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(138)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(138 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(138 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(138 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(139)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(139 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(139 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(139 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(140)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(140 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(140 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(140 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(141)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(141 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(141 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(141 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(143 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(143 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(144)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(144 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(144 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(144 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(145)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(145 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(145 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(145 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(146)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(146 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(146 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(146 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(147)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(147 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(147 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(147 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(148)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(148 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(148 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(148 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(149)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(149 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(149 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(149 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(150)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(150 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(150 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(150 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(151)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(151 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(151 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(151 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(152)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(152 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(152 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(152 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(153)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(153 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(153 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(153 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(154)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(154 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(154 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(154 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(155)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(155 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(155 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(155 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(156)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(156 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(156 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(156 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(157)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(157 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(157 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(157 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(159)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(159 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(159 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(159 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(160)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(160 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(160 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(160 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(161)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(161 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(161 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(161 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(162)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(162 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(162 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(162 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(163)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(163 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(163 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(163 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(164)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(164 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(164 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(164 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(165)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(165 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(165 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(165 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(166)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(166 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(166 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(166 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(167)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(167 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(167 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(167 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(168)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(168 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(168 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(168 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(169)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(169 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(169 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(169 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(170)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(170 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(170 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(170 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(171)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(171 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(171 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(171 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(172)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(172 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(172 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(172 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(173)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(173 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(173 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(173 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(175)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(175 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(175 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(175 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(176)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(176 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(176 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(176 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(177)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(177 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(177 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(177 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(178)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(178 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(178 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(178 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(179)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(179 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(179 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(179 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(180)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(180 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(180 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(180 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(181)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(181 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(181 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(181 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(182)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(182 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(182 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(182 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(183)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(183 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(183 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(183 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(184)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(184 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(184 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(184 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(185)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(185 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(185 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(185 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(186)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(186 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(186 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(186 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(187)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(187 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(187 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(187 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(188)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(188 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(188 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(188 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(189)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(189 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(189 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(189 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(191)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(191 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(191 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(191 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(245)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(245 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(245 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(245 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(246)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(246 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(246 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(246 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(247)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(247 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(247 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(247 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(248)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(248 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(248 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(248 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(249)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(249 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(249 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(249 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(250)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(250 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(250 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(250 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(251)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(251 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(251 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(251 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(252)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(252 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(252 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(252 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(253)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(253 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(253 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(253 143 143 143)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(255)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(255 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(255 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(255 143 143 143)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(237 160 128)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(237 191 191)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(244 144 128 128)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(244 191 191 191)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(192 128)))

(test-error-tail invalid-utf8-encoding-exception? (utf8->string '#u8(193 191)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(224 128 128)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(224 159 191)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(240 128 128 128)))

(test-error-tail
 invalid-utf8-encoding-exception?
 (utf8->string '#u8(240 143 191 191)))

(test-error-tail wrong-number-of-arguments-exception? (utf8->string))
(test-error-tail
 wrong-number-of-arguments-exception?
 (utf8->string '#u8() 0 0 0))

