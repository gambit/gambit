;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _csv)
(import _test)

;; test read-csv

;; as vector

(test-equal
  '#()
  (read-csv (open-input-string "")))

(test-equal
  '#(#())
  (read-csv (open-input-string " ")))

(test-equal
  '#(#())
  (read-csv (open-input-string "\r\n")))

(test-equal
  '#(#())
  (read-csv (open-input-string "\n")))

(test-equal
  '#(#("a")
     #("b")
     #("c"))
  (read-csv (open-input-string "a\nb\nc")))

(test-equal
  '#(#("a")
     #("b")
     #("c"))
  (read-csv (open-input-string "a\nb\r\nc")))

(test-equal
  '#(#("a")
     #("b")
     #("c"))
  (read-csv (open-input-string "a\nb\r\nc\r")))

(test-equal
  '#(#("a" "a a")
     #("b" "b b")
     #("c" "c c"))
  (read-csv (open-input-string "a,a a\nb,b b\nc,c c\n")))

(test-equal
  '#(#("a" "a a")
     #("b" "b b")
     #("c" "c c"))
  (read-csv (open-input-string " a   ,   a a   \nb  ,b b   \n  c,  c c\n")))

(test-equal
  '#(#(" a   " "  \ra a ")
     #("b " "b \nb \"")
     #("c" "  \"c \r\nc"))
  (read-csv (open-input-string "\" a   \", \"  \ra a \"  \n\"b \" ,\"b \nb \"\"\"  \n  c,\"  \"\"c \r\nc\"  \n")))

(test-equal
  '#(#(" a   " "  \ra a ")
     #("b " "b \nb \"")
     #("c" "  \"c \r\nc"))
  (read-csv (open-input-string "\" a   \"\t \"  \ra a \"  \n\"b \" \t\"b \nb \"\"\"  \n  c\t\"  \"\"c \r\nc\"  \n") #\tab))

;; as list

(test-equal
  '()
  (read-csv (open-input-string "") #\, #f #t))

(test-equal
  '(())
  (read-csv (open-input-string " ") #\, #f #t))

(test-equal
  '(())
  (read-csv (open-input-string "\r\n") #\, #f #t))

(test-equal
  '(())
  (read-csv (open-input-string "\n") #\, #f #t))

(test-equal
  '(("a")
    ("b")
    ("c"))
  (read-csv (open-input-string "a\nb\nc") #\, #f #t))

(test-equal
  '(("a")
    ("b")
    ("c"))
  (read-csv (open-input-string "a\nb\r\nc") #\, #f #t))

(test-equal
  '(("a")
    ("b")
    ("c"))
  (read-csv (open-input-string "a\nb\r\nc\r") #\, #f #t))

(test-equal
  '(("a" "a a")
    ("b" "b b")
    ("c" "c c"))
  (read-csv (open-input-string "a,a a\nb,b b\nc,c c\n") #\, #f #t))

(test-equal
  '(("a" "a a")
    ("b" "b b")
    ("c" "c c"))
  (read-csv (open-input-string " a   ,   a a   \nb  ,b b   \n  c,  c c\n") #\, #f #t))

(test-equal
  '((" a   " "  \ra a ")
    ("b " "b \nb \"")
    ("c" "  \"c \r\nc"))
  (read-csv (open-input-string "\" a   \", \"  \ra a \"  \n\"b \" ,\"b \nb \"\"\"  \n  c,\"  \"\"c \r\nc\"  \n") #\, #f #t))

(test-equal
  '((" a   " "  \ra a ")
    ("b " "b \nb \"")
    ("c" "  \"c \r\nc"))
  (read-csv (open-input-string "\" a   \"\t \"  \ra a \"  \n\"b \" \t\"b \nb \"\"\"  \n  c\t\"  \"\"c \r\nc\"  \n") #\tab #f #t))

;; test csv-string->list

(test-equal
  '((" a   " "  \ra a ")
    ("b " "b \nb \"")
    ("c" "  \"c \r\nc"))
  (csv-string->list "\" a   \", \"  \ra a \"  \n\"b \" ,\"b \nb \"\"\"  \n  c,\"  \"\"c \r\nc\"  \n"))

(test-equal
  '((" a   " "  \ra a ")
    ("b " "b \nb \"")
    ("c" "  \"c \r\nc"))
  (csv-string->list "\" a   \"\t \"  \ra a \"  \n\"b \" \t\"b \nb \"\"\"  \n  c\t\"  \"\"c \r\nc\"  \n" #\tab))

;; test csv-string->list

(test-equal
  '#(#(" a   " "  \ra a ")
     #("b " "b \nb \"")
     #("c" "  \"c \r\nc"))
  (csv-string->vector "\" a   \", \"  \ra a \"  \n\"b \" ,\"b \nb \"\"\"  \n  c,\"  \"\"c \r\nc\"  \n"))

(test-equal
  '#(#(" a   " "  \ra a ")
     #("b " "b \nb \"")
     #("c" "  \"c \r\nc"))
  (csv-string->vector "\" a   \"\t \"  \ra a \"  \n\"b \" \t\"b \nb \"\"\"  \n  c\t\"  \"\"c \r\nc\"  \n" #\tab))

(test-equal
  '#(#(" a   " "  \ra a ")
     #("b " "b \nb \"")
     #("c" "c\"  \"\"c")
     #("c\""))
  (csv-string->vector "\" a   \"\t \"  \ra a \"  \n\"b \" \t\"b \nb \"\"\"  \n  c\tc\"  \"\"c \r\nc\"  \n" #\tab #t))

(define test1-vector
  '#(#("piñata" "déjà vu" "Καλημέρα" " field4" "field5" "x,y" "z\tz")
     #("a" "b" "c" 3 4.0 0.5 6e66 -777777777777777777777777)))

(define test1-list
  '(("piñata" "déjà vu" "Καλημέρα" " field4" "field5" "x,y" "z\tz")
    ("a" "b" "c" 3 4.0 0.5 6e66 -777777777777777777777777)))

(define test1-vector-out
  '#(#("piñata" "déjà vu" "Καλημέρα" " field4" "field5" "x,y" "z\tz")
     #("a" "b" "c" "3" "4." ".5" "6e66" "-777777777777777777777777")))

(define test1-list-out
  '(("piñata" "déjà vu" "Καλημέρα" " field4" "field5" "x,y" "z\tz")
    ("a" "b" "c" "3" "4." ".5" "6e66" "-777777777777777777777777")))

(write-file-csv "/tmp/test1.csv" test1-vector)

(test-equal
  test1-vector-out
  (read-file-csv "/tmp/test1.csv"))

(test-equal
  test1-list-out
  (read-file-csv "/tmp/test1.csv" #\, #f #t))

(write-file-csv "/tmp/test1.csv" test1-list)

(test-equal
  test1-vector-out
  (read-file-csv "/tmp/test1.csv"))

(test-equal
  test1-list-out
  (read-file-csv "/tmp/test1.csv" #\, #f #t))

(test-equal
  (read-file-string "/tmp/test1.csv")
  (->csv-string test1-vector))

(test-equal
  (read-file-string "/tmp/test1.csv")
  (->csv-string test1-list))

(write-file-csv "/tmp/test1.csv" test1-vector #\.)

(test-equal
  test1-vector-out
  (read-file-csv "/tmp/test1.csv" #\.))

(test-equal
  test1-list-out
  (read-file-csv "/tmp/test1.csv" #\. #f #t))

(test-equal
  (read-file-string "/tmp/test1.csv")
  (->csv-string test1-vector #\.))

(test-equal
  (read-file-string "/tmp/test1.csv")
  (->csv-string test1-list #\.))

;;;============================================================================
