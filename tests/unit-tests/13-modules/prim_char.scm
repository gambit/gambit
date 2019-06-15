(include "#.scm")

(check-same-behavior ("" "##" "~~lib/_prim-char#.scm")

;; R4RS

(char->integer #\a)
(char-alphabetic? #\a) (char-alphabetic? #\ ) (char-alphabetic? #\A) (char-alphabetic? #\0)

(char-ci<?) (char-ci<? #\a) (char-ci<? #\a #\b) (char-ci<? #\b #\a) (char-ci<? #\a #\b #\c) (char-ci<? #\a #\a #\a) (char-ci<? #\c #\b #\a) (char-ci<? #\a #\A) (char-ci<? #\A #\a)
(char-ci<=?)(char-ci<=? #\a)(char-ci<=? #\a #\b)(char-ci<=? #\b #\a)(char-ci<=? #\a #\b #\c)(char-ci<=? #\a #\a #\a)(char-ci<=? #\c #\b #\a)(char-ci<=? #\a #\A)(char-ci<=? #\A #\a)
(char-ci=?) (char-ci=? #\a) (char-ci=? #\a #\b) (char-ci=? #\b #\a) (char-ci=? #\a #\b #\c) (char-ci=? #\a #\a #\a) (char-ci=? #\c #\b #\a) (char-ci=? #\a #\A) (char-ci=? #\A #\a)
(char-ci>?) (char-ci>? #\a) (char-ci>? #\a #\b) (char-ci>? #\b #\a) (char-ci>? #\a #\b #\c) (char-ci>? #\a #\a #\a) (char-ci>? #\c #\b #\a) (char-ci>? #\a #\A) (char-ci>? #\A #\a)
(char-ci>=?)(char-ci>=? #\a)(char-ci>=? #\a #\b)(char-ci>=? #\b #\a)(char-ci>=? #\a #\b #\c)(char-ci>=? #\a #\a #\a)(char-ci>=? #\c #\b #\a)(char-ci>=? #\a #\A)(char-ci>=? #\A #\a)

(char-downcase #\a) (char-downcase #\ ) (char-downcase #\A) (char-downcase #\0)
(char-lower-case? #\a) (char-lower-case? #\ ) (char-lower-case? #\A) (char-lower-case? #\0)
(char-numeric? #\a) (char-numeric? #\ ) (char-numeric? #\A) (char-numeric? #\0)
(char-upcase #\a) (char-upcase #\ ) (char-upcase #\A) (char-upcase #\0)
(char-upper-case? #\a) (char-upper-case? #\ ) (char-upper-case? #\A) (char-upper-case? #\0)
(char-whitespace? #\a) (char-whitespace? #\ ) (char-whitespace? #\A) (char-whitespace? #\0)

(char<=?)(char<=? #\a)(char<=? #\a #\b)(char<=? #\b #\a)(char<=? #\a #\b #\c)(char<=? #\a #\a #\a)(char<=? #\c #\b #\a)(char<=? #\a #\A)(char<=? #\A #\a)
(char<?) (char<? #\a) (char<? #\a #\b) (char<? #\b #\a) (char<? #\a #\b #\c) (char<? #\a #\a #\a) (char<? #\c #\b #\a) (char<? #\a #\A) (char<? #\A #\a)
(char=?) (char=? #\a) (char=? #\a #\b) (char=? #\b #\a) (char=? #\a #\b #\c) (char=? #\a #\a #\a) (char=? #\c #\b #\a) (char=? #\a #\A) (char=? #\A #\a)
(char>?) (char>? #\a) (char>? #\a #\b) (char>? #\b #\a) (char>? #\a #\b #\c) (char>? #\a #\a #\a) (char>? #\c #\b #\a) (char>? #\a #\A) (char>? #\A #\a)
(char>=?)(char>=? #\a)(char>=? #\a #\b)(char>=? #\b #\a)(char>=? #\a #\b #\c)(char>=? #\a #\a #\a)(char>=? #\c #\b #\a)(char>=? #\a #\A)(char>=? #\A #\a)

(char? 'a) (char? #\a) (char? "a")
(integer->char 65)

;; R7RS

(char-foldcase #\a) (char-foldcase #\ ) (char-foldcase #\A) (char-foldcase #\0)
(digit-value #\x) (digit-value #\4)

)
