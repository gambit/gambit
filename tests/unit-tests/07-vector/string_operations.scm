(include "#.scm")

;; String constructors and functional updates must not alias their inputs.

(test-eq #t (string? ""))
(test-eq #f (string? #\a))
(test-equal "" (string))
(test-equal "a\x3bb;" (string #\a #\x3bb))
(test-equal "" (make-string 0 #\x))
(test-equal "xxx" (make-string 3 #\x))
(test-eqv 2 (string-length "a\x3bb;"))
(test-eqv #\x3bb (string-ref "a\x3bb;" 1))
(test-equal '(#\a #\b) (string->list "ab"))
(test-equal '(#\b #\c) (string->list "abcd" 1 3))
(test-equal "a\x3bb;" (list->string '(#\a #\x3bb)))
(test-equal "" (list->string '()))
(test-equal "bc" (substring "abcd" 1 3))
(test-equal "" (substring "abcd" 4 4))
(test-equal "abxy" (string-append "ab" "" "xy"))
(test-equal "" (string-concatenate '() ":"))
(test-equal "ab::xy" (string-concatenate '("ab" "" "xy") ":"))
(test-equal "abxy" (string-concatenate '("ab" "xy")))
(test-equal "bcd" (string-copy "abcd" 1))
(test-equal "bc" (string-copy "abcd" 1 3))
(test-assert
 (let* ((source (string #\a #\b #\c))
        (copy (string-copy source)))
   (string-set! copy 0 #\x)
   (and (string=? source "abc") (string=? copy "xbc"))))
(test-assert
 (let* ((source (string #\a #\b #\c))
        (copy (string-set source 1 #\x)))
   (and (string=? source "abc") (string=? copy "axc")
        (not (eq? source copy)))))

;; Partial writes preserve the untouched prefix and suffix. Moves/copies
;; must handle overlap in both directions, like memmove.

(test-equal "axxd"
 (let ((s (string-copy "abcd"))) (string-fill! s #\x 1 3) s))
(test-equal "xxxx"
 (let ((s (string-copy "abcd"))) (string-fill! s #\x) s))
(test-equal "abcd"
 (let ((s (string-copy "abcd"))) (string-fill! s #\x 2 2) s))
(test-equal "axxd"
 (let ((s (string-copy "abcd"))) (substring-fill! s 1 3 #\x) s))
(test-equal "aabcde"
 (let ((s (string-copy "abcdef"))) (string-copy! s 1 s 0 5) s))
(test-equal "bcdeff"
 (let ((s (string-copy "abcdef"))) (string-copy! s 0 s 1 6) s))
(test-equal "aXYdef"
 (let ((s (string-copy "abcdef"))) (string-copy! s 1 "XY") s))
(test-equal "aabcde"
 (let ((s (string-copy "abcdef"))) (substring-move! s 0 5 s 1) s))
(test-equal "bcdeff"
 (let ((s (string-copy "abcdef"))) (substring-move! s 1 6 s 0) s))
(test-equal "dbca"
 (let ((s (string-copy "abcd"))) (string-swap! s 0 3) s))
(test-equal "abcd"
 (let ((s (string-copy "abcd"))) (string-swap! s 2 2) s))
(test-equal "ab"
 (let ((s (string-copy "abcd"))) (string-shrink! s 2) s))
(test-equal ""
 (let ((s (string-copy "abcd"))) (string-shrink! s 0) s))
(test-equal "\xc9;COLE" (string-upcase "\xe9;cole"))
(test-equal "\xe9;cole" (string-downcase "\xc9;COLE"))
(test-equal "\x3c3;\x3c3;" (string-foldcase "\x3a3;\x3c2;"))
(test-equal "" (string-upcase ""))
(test-equal "" (string-downcase ""))
(test-equal "" (string-foldcase ""))

;; Search results are absolute indices even when a bounded slice is used.

(test-eqv 2 (string-prefix-length "abcd" "abXY"))
(test-eqv 0 (string-prefix-length "" "ab"))
(test-eqv 2 (string-prefix-length "-abc+" "_abZ!" 1 4 1 4))
(test-eqv 2 (string-prefix-length-ci "Abcd" "aBXY"))
(test-eqv 0 (string-prefix-length-ci "" "ab"))
(test-eqv 2 (string-suffix-length "xyab" "zzab"))
(test-eqv 0 (string-suffix-length "ab" ""))
(test-eqv 2 (string-suffix-length "-xab+" "_yab!" 1 4 1 4))
(test-eqv 2 (string-suffix-length-ci "xyAb" "zzaB"))
(test-eqv 0 (string-suffix-length-ci "ab" ""))
(test-eq #t (string-prefix? "ab" "abcd"))
(test-eq #f (string-prefix? "abcd" "ab"))
(test-eq #t (string-prefix? "" "ab"))
(test-eq #t (string-prefix-ci? "Ab" "aBCD"))
(test-eq #f (string-prefix-ci? "ax" "aBCD"))
(test-eq #t (string-suffix? "cd" "abcd"))
(test-eq #f (string-suffix? "abcd" "cd"))
(test-eq #t (string-suffix? "" "ab"))
(test-eq #t (string-suffix-ci? "cD" "ABCd"))
(test-eq #f (string-suffix-ci? "xd" "ABCd"))
(test-eqv 1 (string-contains "banana" "ana"))
(test-eqv 3 (string-contains "banana" "ana" 2))
(test-eqv 2 (string-contains "banana" "" 2))
(test-eq #f (string-contains "banana" "ana" 0 3))
(test-eqv 3 (string-contains "banana" "-ana-" 2 6 1 4))
(test-eqv 1 (string-contains-ci "bANana" "anA"))
(test-eqv 3 (string-contains-ci "bANana" "ANA" 2))
(test-eq #f (string-contains-ci "banana" "XYZ"))

(test-error range-exception? (make-string -1))
(test-error type-exception? (make-string 2 0))
(test-error range-exception? (string-ref "a" 1))
(test-error range-exception? (string-ref "a" -1))
(test-error range-exception? (substring "abc" 2 1))
(test-error range-exception? (string-copy "abc" 0 4))
(test-error type-exception? (list->string '(#\a 2)))
(test-error type-exception? (string-concatenate '("a" 2)))
(test-error range-exception? (string-set (string-copy "a") 1 #\x))
(test-error range-exception? (string-fill! (string-copy "a") #\x 0 2))
(test-error range-exception? (string-copy! (string-copy "a") 1 "xx"))
(test-error range-exception? (substring-move! "abc" 0 3 (string-copy "a") 0))
(test-error range-exception? (string-shrink! (string-copy "a") 2))
(test-error range-exception? (string-swap! (string-copy "a") 0 1))
(test-error type-exception? (string-upcase #f))
(test-error type-exception? (string-downcase #f))
(test-error type-exception? (string-foldcase #f))
(test-error range-exception? (string-prefix-length "abc" "abc" 0 4))
(test-error range-exception? (string-suffix-length-ci "abc" "abc" 2 1))
(test-error range-exception? (string-contains "abc" "b" -1))
(test-error type-exception? (string-contains-ci "abc" #f))
