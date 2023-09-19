(include "#.scm")

(check-same-behavior ("" "##" "~~lib/gambit/prim/char#.scm")

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

;; Gambit

(char-set? #f) (char-set? ##char-set:empty)

(char-set=) (char-set= ##char-set:empty) (char-set= ##char-set:empty ##char-set:empty) (char-set= ##char-set:empty ##char-set:full) (char-set= ##char-set:empty ##char-set:empty ##char-set:empty) (char-set= ##char-set:empty ##char-set:full ##char-set:empty)

(char-set<=) (char-set<= ##char-set:empty) (char-set<= ##char-set:empty ##char-set:empty) (char-set<= ##char-set:empty ##char-set:full) (char-set<= ##char-set:empty ##char-set:empty ##char-set:empty) (char-set<= ##char-set:empty ##char-set:full ##char-set:empty)

(char-set-hash ##char-set:empty) (char-set-hash ##char-set:empty 42)

(char-set-cursor ##char-set:empty)

(char-set-ref ##char-set:full (char-set-cursor ##char-set:full))

(char-set-cursor-next ##char-set:empty (char-set-cursor ##char-set:empty))

(end-of-char-set? (char-set-cursor ##char-set:empty)) (end-of-char-set? (char-set-cursor ##char-set:full))

(char-set-fold cons '() ##char-set:hex-digit)

(char-set-unfold null? car cdr '(#\a #\x #\y)) (char-set-unfold null? car cdr '(#\a #\x #\y) (char-set #\b))

(char-set-unfold! null? car cdr '(#\a #\x #\y) (char-set #\b))

(char-set-for-each list ##char-set:hex-digit)

(char-set-map char-upcase ##char-set:hex-digit)

(char-set-copy ##char-set:hex-digit)

(char-set) (char-set #\a) (char-set #\a #\x) (char-set #\a #\x #\y)

(list->char-set '(#\x #\y)) (list->char-set '(#\x #\y) ##char-set:hex-digit)

(list->char-set! '(#\x #\y) (char-set #\a))

(string->char-set "xy") (string->char-set "xy" ##char-set:hex-digit)

(string->char-set! "xy" (char-set #\a))

(char-set-filter char-upper-case? ##char-set:hex-digit) (char-set-filter char-upper-case? ##char-set:hex-digit ##char-set:blank)

(char-set-filter! char-upper-case? ##char-set:hex-digit (char-set #\a))

(ucs-range->char-set 40 58) (ucs-range->char-set 40 58 #f) (ucs-range->char-set 40 58 #f ##char-set:hex-digit)

(ucs-range->char-set! 40 58 #f (char-set #\z))

(->char-set #\z) (->char-set "abdef") (->char-set ##char-set:hex-digit)

(char-set-size ##char-set:hex-digit)

(char-set-count char-alphabetic? ##char-set:hex-digit)

(char-set->list ##char-set:hex-digit)

(char-set->string ##char-set:hex-digit)

(char-set-contains? ##char-set:hex-digit #\a) (char-set-contains? ##char-set:hex-digit #\z)

(char-set-every char-alphabetic? ##char-set:letter) (char-set-every char-lower-case? ##char-set:letter)

(char-set-any char-lower-case? ##char-set:letter) (char-set-any char-numeric? ##char-set:letter)

(char-set-adjoin ##char-set:hex-digit) (char-set-adjoin ##char-set:hex-digit #\x) (char-set-adjoin ##char-set:hex-digit #\x #\a)

(char-set-delete ##char-set:hex-digit) (char-set-delete ##char-set:hex-digit #\x) (char-set-delete ##char-set:hex-digit #\x #\a)

(char-set-adjoin! (char-set-copy ##char-set:hex-digit)) (char-set-adjoin! (char-set-copy ##char-set:hex-digit) #\x) (char-set-adjoin! (char-set-copy ##char-set:hex-digit) #\x #\a)

(char-set-delete! (char-set-copy ##char-set:hex-digit)) (char-set-delete! (char-set-copy ##char-set:hex-digit) #\x) (char-set-delete! (char-set-copy ##char-set:hex-digit) #\x #\a)

(char-set-complement ##char-set:empty)

(char-set-complement! (char-set #\a #\b))

(char-set-union) (char-set-union ##char-set:hex-digit) (char-set-union ##char-set:hex-digit ##char-set:digit) (char-set-union ##char-set:hex-digit ##char-set:digit ##char-set:blank)

(char-set-intersection) (char-set-intersection ##char-set:hex-digit) (char-set-intersection ##char-set:hex-digit ##char-set:digit) (char-set-intersection ##char-set:hex-digit ##char-set:digit ##char-set:blank)

(char-set-difference ##char-set:hex-digit) (char-set-difference ##char-set:hex-digit ##char-set:digit) (char-set-difference ##char-set:hex-digit ##char-set:digit ##char-set:blank)

(char-set-xor) (char-set-xor ##char-set:hex-digit) (char-set-xor ##char-set:hex-digit ##char-set:digit) (char-set-xor ##char-set:hex-digit ##char-set:digit ##char-set:blank)

(##call-with-values (lambda () (char-set-diff+intersection ##char-set:hex-digit)) list)
(##call-with-values (lambda () (char-set-diff+intersection ##char-set:hex-digit ##char-set:digit)) list)
(##call-with-values (lambda () (char-set-diff+intersection ##char-set:hex-digit ##char-set:digit ##char-set:blank)) list)

(char-set-union! (char-set-copy ##char-set:hex-digit)) (char-set-union! (char-set-copy ##char-set:hex-digit) ##char-set:digit) (char-set-union! (char-set-copy ##char-set:hex-digit) ##char-set:digit ##char-set:blank)

(char-set-intersection! (char-set-copy ##char-set:hex-digit)) (char-set-intersection! (char-set-copy ##char-set:hex-digit) ##char-set:digit) (char-set-intersection! (char-set-copy ##char-set:hex-digit) ##char-set:digit ##char-set:blank)

(char-set-difference! (char-set-copy ##char-set:hex-digit)) (char-set-difference! (char-set-copy ##char-set:hex-digit) ##char-set:digit) (char-set-difference! (char-set-copy ##char-set:hex-digit) ##char-set:digit ##char-set:blank)

(char-set-xor! (char-set-copy ##char-set:hex-digit)) (char-set-xor! (char-set-copy ##char-set:hex-digit) ##char-set:digit) (char-set-xor! (char-set-copy ##char-set:hex-digit) ##char-set:digit ##char-set:blank)

(##call-with-values (lambda () (char-set-diff+intersection! (char-set-copy ##char-set:hex-digit))) list)
(##call-with-values (lambda () (char-set-diff+intersection! (char-set-copy ##char-set:hex-digit) ##char-set:digit)) list)
(##call-with-values (lambda () (char-set-diff+intersection! (char-set-copy ##char-set:hex-digit) ##char-set:digit ##char-set:blank)) list)

)
