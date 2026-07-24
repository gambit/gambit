;;; Adapted from SCSH SRE tests by Christoph Hetz

(define-syntax rx
  (syntax-rules ()
    ((rx sre) `sre)
    ((rx sre0 sre1 ...) `(seq sre0 sre1 ...))))

(define test-string 
  "Dieser Test-String wurde am 29.07.2004 um 5:23PM erstellt.\na aa aaa aaaa\nab aabb aaabbb\naba abba abbba\n1 12 123 1234\nyyyyyyyyyy\n")

(test-begin "scsh")

(test-assert (not (irregex-search '(: "xxx") test-string)))

(test (irregex-search '(- alpha ("aeiouAEIOU")) test-string)
    (irregex-search '(- (/"azAZ") ("aeiouAEIOU")) test-string))

(test (irregex-search '(- (/"azAZ") ("aeiouAEIOU")) test-string)
    (irregex-search '(- alpha ("aeiou") ("AEIOU")) test-string))

(test (irregex-search '(- alpha ("aeiou") ("AEIOU")) test-string)
    (irregex-search '(w/nocase (- alpha ("aeiou"))) test-string))

(test (irregex-search '(w/nocase (- alpha ("aeiou"))) test-string)
    (irregex-search '(w/nocase (- (/ "az") ("aeiou"))) test-string))

(test (irregex-search '(or upper ("aeiou") digit) "xxx A yyy")
    (irregex-search '(or (/ "AZ09") ("aeiou")) "xxx A yyy"))
(test (irregex-search '(or upper ("aeiou") digit) "xxx a yyy")
    (irregex-search '(or (/ "AZ09") ("aeiou")) "xxx a yyy"))
(test (irregex-search '(or upper ("aeiou") digit) "xxx 6 yyy")
    (irregex-search  '(or (/ "AZ09") ("aeiou")) "xxx 6 yyy"))

(let ((csl (lambda (re) `(or "" (: ,re (* ", " ,re))))))
  (test-assert
   (irregex-search (csl '(or "John" "Paul" "George" "Ringo"))
                   "George, Ringo, Paul, John")))

(test "caaadadr"
    (let ((str "(caaadadr ..."))
      (irregex-match-substring
       (irregex-search '(: "c" (+ (or "a" "d")) "r") str))))

(test "caaadadr"
    (let ((str "(caaadadr ..."))
      (irregex-match-substring
       (irregex-search '(: "c" (** 1 6 ("ad")) "r") str))))

(test-assert
 (not (irregex-search '(: "c" (** 1 4 ("ad")) "r") "(caaadadr ...")))

(let ((str "bla hello bla"))
  (test "hello"
      (irregex-match-substring
       (irregex-search (rx (dsm 1 0 (submatch "hello"))) str)
       2))
  (test-assert
   (not (irregex-match-substring
         (irregex-search (rx (dsm 1 0 (submatch "hello"))) str)
         1)))
  (test "hello"
    (irregex-match-substring
     (irregex-search (rx (dsm 2 0 (submatch "hello"))) str)
     3))
  (test-assert
   (not (irregex-match-substring
         (irregex-search (rx (dsm 2 0 (submatch "hello"))) str)
         1)))
  (test-assert
   (not (irregex-match-substring
         (irregex-search (rx (dsm 2 0 (submatch "hello"))) str)
         2))))

(test "erstellt."
    (irregex-match-substring (irregex-search (rx "erstellt.") test-string)))

(test-assert (not (irregex-search (rx "Erstellt.") test-string)))

(test (irregex-search (rx ("abcde")) test-string)
    (irregex-search (rx ("edcba")) test-string))

(test "1234"
    (irregex-match-substring
     (irregex-search (rx (: "1" any any "4")) test-string)))

(test (irregex-search (rx (or "erstellt." "xxx")) test-string)
    (irregex-search (rx (or "xxx" "erstellt.")) test-string))

(test ""
    (irregex-match-substring (irregex-search (rx (* "y")) test-string)))
(test "D"
    (irregex-match-substring (irregex-search (rx (* "D")) test-string)))
(test "yyyyyyyyyy"
    (irregex-match-substring (irregex-search (rx (+ "y")) test-string)))
(test "D"
    (irregex-match-substring (irregex-search (rx (+ "D")) test-string)))
(test ""
    (irregex-match-substring (irregex-search (rx (? "y")) test-string)))
(test "D"
    (irregex-match-substring (irregex-search (rx (? "D")) test-string)))
(test "yyyyy"
    (irregex-match-substring (irregex-search (rx (= 5 "y")) test-string)))
(test-assert (not (irregex-search (rx (= 11 "y")) test-string)))

(test "yyyyyyyyyy"
    (irregex-match-substring (irregex-search (rx (>= 5 "y")) test-string)))
(test "yyyyyyyyyy"
    (irregex-match-substring (irregex-search (rx (>= 10 "y")) test-string)))
(test-assert (not (irregex-search (rx (>= 11 "y")) test-string)))
(test "yyyyyyyyyy"
    (irregex-match-substring (irregex-search (rx (** 1 30 "y")) test-string)))
(test "yyyyy"
    (irregex-match-substring (irregex-search (rx (** 1 5 "y")) test-string)))
(test-assert (not (irregex-search (rx (** 11 12 "y")) test-string)))
(test-assert (not (irregex-search (rx (** 12 11 any)) test-string)))
(test "" 
    (irregex-match-substring (irregex-search (rx (** 0 0 any)) test-string)))

(test (irregex-search (rx ("abcd")) test-string)
    (irregex-search (rx (or #\a #\b #\c #\d)) test-string))
(test (irregex-search (rx ("xy")) test-string)
    (irregex-search (rx (or #\x #\y)) test-string))

(test "D"
    (irregex-match-substring (irregex-search (rx (/ #\A #\Z #\a #\z #\0 #\9)) test-string)))
(test "D"
    (irregex-match-substring (irregex-search (rx (/ #\A "Zaz0" #\9)) test-string)))
(test "i"
    (irregex-match-substring (irregex-search (rx (/ #\a #\z #\0 #\9)) test-string)))
(test "i"
    (irregex-match-substring (irregex-search (rx (/ #\a "z0" #\9)) test-string)))
(test "2"
    (irregex-match-substring (irregex-search (rx (/ #\0 #\9)) test-string)))
(test "2"
    (irregex-match-substring (irregex-search (rx (/ "0" #\9)) test-string)))
(test (irregex-search (rx lower-case) test-string)
    (irregex-search (rx (- alphabetic upper-case)) test-string))
(test (irregex-search (rx upper-case) test-string)
    (irregex-search (rx (- alphabetic lower-case)) test-string))

(test "2"
    (irregex-match-substring (irregex-search (rx numeric) test-string)))
(test "-"
    (irregex-match-substring (irregex-search (rx punctuation) test-string)))
(test " "
    (irregex-match-substring (irregex-search (rx blank) test-string)))
(test " "
    (irregex-match-substring (irregex-search (rx whitespace) test-string)))
(test "\n"
    (irregex-match-substring (irregex-search (rx control) test-string)))
(test "D"
    (irregex-match-substring (irregex-search (rx hex-digit) test-string)))
(test "D"
    (irregex-match-substring (irregex-search (rx ascii) test-string)))

(test-assert (not (irregex-search (rx (w/nocase (~ "a"))) "aA")))

(test-assert (irregex-search (rx (w/nocase "abc"
                                           (* "FOO" (w/case "Bar"))
                                           ("aeiou"))) 
                             "kabcfooBariou"))
(test-assert (not (irregex-search (rx (w/nocase "abc"
                                                (* "FOO" (w/case "Bar"))
                                                ("aeiou"))) 
                                  "kabcfooBARiou")))

(let ((str "I am feeding the goose, you are feeding the geese.")
      (me 1)
      (you 2))
  (test "feeding the goose"
      (irregex-match-substring
       (irregex-search (rx (: "feeding the " ,(if (> me 1) "geese" "goose")))
                       str)))
  (test "feeding the geese"
      (irregex-match-substring
       (irregex-search (rx (: "feeding the " ,(if (> you 1) "geese" "goose")))
                       str))))

(let* ((ws (rx (+ whitespace)))
       (date (rx (: (or "Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul")
                    ,ws
                    (or ("123456789")
                        (: ("12") digit)
                        "30"
                        "31"))))
       (str1 "it was on Mar 14 ...")
       (str2 "it was on May 31 ..."))
  (test "on Mar 14"
      (irregex-match-substring (irregex-search (rx (: "on " ,date)) str1)))
  (test "on May 31"
      (irregex-match-substring (irregex-search (rx (: "on " ,date)) str2))))

(test "abc"
    (irregex-match-substring (irregex-search (rx "abc") "abcdefg")))
(test-assert (not (irregex-search (rx "abc") "abcdefg" 3)))
(test-assert (not (irregex-search (rx "cba") "abcdefg")))

(test "dry Jin"
    (irregex-replace/all (rx "Cotton") "dry Cotton" "Jin"))

(test "01/03/79"
    (irregex-replace/all (rx (submatch (+ digit)) "/"
                             (submatch (+ digit)) "/"
                             (submatch (+ digit)))
                         "03/01/79"
                         2 "/" 1 "/" 3))

(let ((str "9/29/61"))
  (test "Sep 29, 1961"
      (irregex-replace/all
       (rx (submatch (+ digit)) "/"
           (submatch (+ digit)) "/"
           (submatch (+ digit)))
       str
       (lambda (m)
         (let ((mon (vector-ref '#("Jan" "Feb" "Mar" "Apr" "May" "Jun"
                                   "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
                                (- (string->number
                                    (irregex-match-substring m 1)) 
                                   1)))
               (day (irregex-match-substring m 2))
               (year (irregex-match-substring m 3)))
           (string-append mon " " day ", 19" year))))))

(let ((kill-matches (lambda (re s)
                      (irregex-replace/all re s))))
  (test " will disappear, also  and "
      (kill-matches (rx (or "Windows" "tcl" "Intel")) 
                    "Windows will disappear, also tcl and Intel")))

(test-end)


