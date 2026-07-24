;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2024 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(import _json)
(import _test)

(define test-obj
  (list -1
        .01
        -.01
        0.0
        1e-9
        (/ 1.0 0.0)
        (- (/ 1.0 0.0) (/ 1.0 0.0))
        #t
        #f
        '()
        "çé\5\t\n\x1f60a;"
        (vector 1 2)
        (list->table '((a: . "one") (b: . 2)))))

(define test-obj-readback
  (vector -1
          .01
          -.01
          0
          1e-9
          (void)
          (void)
          #t
          #f
          '#()
          "çé\5\t\n\x1f60a;"
          (vector 1 2)
          (list->table '((a: . "one") (b: . 2)))))

(define test-obj-json-string
  "[-1,0.01,-0.01,0,1e-9,null,null,true,false,[],\"çé\\u0005\\t\\n\x1f60a;\",[1,2],{\"a\":\"one\",\"b\":2}]")

(define test-obj-json-string-ascii
  "[-1,0.01,-0.01,0,1e-9,null,null,true,false,[],\"\\u00e7\\u00e9\\u0005\\t\\n\\ud83d\\ude0a\",[1,2],{\"a\":\"one\",\"b\":2}]")

;; test read-json

(test-equal
  test-obj-readback
  (read-json (open-input-string test-obj-json-string)))

;; test read-file-json

(write-file-string "/tmp/test1.json" test-obj-json-string)

(test-equal
  test-obj-readback
  (read-file-json "/tmp/test1.json"))

;; test json-string->object

(test-equal
  test-obj-readback
  (json-string->object test-obj-json-string))

;; test write-json

(test-equal
  test-obj-json-string
  (with-output-to-string
    (lambda ()
      (write-json test-obj))))

(test-equal
  test-obj-json-string-ascii
  (utf8->string
   (with-output-to-u8vector
    '(char-encoding: ASCII)
    (lambda ()
      (write-json test-obj)))))

;; test write-file-json

(write-file-json "/tmp/test2.json" test-obj)

(test-equal
  test-obj-json-string
  (read-file-string "/tmp/test2.json"))

;; test object->json-string

(test-equal
  test-obj-json-string
  (object->json-string test-obj))

;; tests from https://seriot.ch/projects/parsing_json.html

;;(test-equal
;;  '#(+inf.0)
;;  (json-string->object "[0.4e00669999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999969999999006]"))

(test-equal '#("") (json-string->object "[\"\"]"))

(test-error (json-string->object "[-foo]"))

(test-error (json-string->object "{ \"foo\" : \"bar\", \"a\" }"))

(test-error (json-string->object "[\"a\x0;a\"]"))

(test-equal
 '#(100000000000000000000)
 (json-string->object "[100000000000000000000]"))

(test-equal '#("\x0;") (json-string->object "[\"\\u0000\"]"))

(test-error (json-string->object "[\""))

(test-equal (vector (void)) (json-string->object "[null]"))

(test-error (json-string->object "{\"a\":"))

(test-error (json-string->object "[\"\\uD800\\uD800\\n\"]"))

(test-error (json-string->object "{]"))

(test-equal '#(+inf.0) (json-string->object "[123123e100000]"))

(test-error (json-string->object "[\""))

(test-error (json-string->object "[-2.]"))

(test-error (json-string->object "[1"))

(test-error (json-string->object "[\"\\x00\"]"))

(test-equal '#("é") (json-string->object "[\"é\"]"))

(test-error (json-string->object "[123"))

(test-error (json-string->object "[1e1"))

(test-equal '#("`Īካ") (json-string->object "[\"\\u0060\\u012a\\u12AB\"]"))

(test-error (json-string->object " "))

(test-equal '#(1.23e47) (json-string->object "[123e45]"))

(test-equal '#(-inf.0) (json-string->object "[-123123e100000]"))

(test-equal
 (list->table '((dfg: . "fgh") (asd: . "sdf")))
 (json-string->object "{\"asd\":\"sdf\", \"dfg\":\"fgh\"}"))

(test-error (json-string->object "[\""))

(test-error (json-string->object "{a: \"b\"}"))

(test-error (json-string->object "[a"))

(test-equal '#(0) (json-string->object "[-0]"))

(test-error (json-string->object "{\"id\":0,,,,,}"))

(test-equal
 '#(-1e-78)
 (json-string->object
  "[-0.000000000000000000000000000000000000000000000000000000000000000000000000000001]\n"))

(test-error (json-string->object "{,"))

(test-equal
 '#("\"\\/\b\f\n\r\t")
 (json-string->object "[\"\\\"\\\\\\/\\b\\f\\n\\r\\t\"]"))

(test-error (json-string->object "[-]"))

(test-equal '#() (json-string->object "[]"))

(test-error (json-string->object "{["))

(test-error (json-string->object "[\"\\uqqqq\"]"))

(test-error (json-string->object "[9.e+]"))

(test-error (json-string->object "[\"\\\"]"))

(test-equal "" (json-string->object "\"\""))

(test-equal (list->table '()) (json-string->object "{}"))

(test-equal '#("π") (json-string->object "[\"π\"]"))

(test-error (json-string->object "[ true, fals"))

(test-equal '#("￿") (json-string->object "[\"\\uFFFF\"]"))

(test-error (json-string->object "[012]"))

(test-equal '#(200.) (json-string->object "[20e1]"))

(test-error (json-string->object "[1.0e+]"))

(test-error (json-string->object "[-NaN]"))

(test-error (json-string->object "[\"\t\"]"))

(test-error (json-string->object "aå"))

(test-error (json-string->object "[\"\\uD834\\uDd\"]"))

(test-error (json-string->object "[1:2]"))

(test-error (json-string->object "[\"\\ud800abc\"]"))

(test-error (json-string->object "[Infinity]"))

(test-error (json-string->object "{\"x\": true,"))

(test-equal
 (list->table '((a: . "b")))
 (json-string->object "{\"a\":\"b\",\"a\":\"b\"}"))

(test-error (json-string->object "\"\"x"))

(test-error (json-string->object "[0.1.2]"))

(test-equal '#("􏿿") (json-string->object "[\"\\uDBFF\\uDFFF\"]"))

(test-equal '#("𐐷") (json-string->object "[\"\\uD801\\udc37\"]"))

(test-error (json-string->object "[\"\\uD888\\u1234\"]"))

(test-equal #f (json-string->object "false"))

(test-error (json-string->object "[\\u000A\"\"]"))

(test-equal '#(100.) (json-string->object "[1E+2]"))

(test-error (json-string->object "[Inf]"))

(test-error (json-string->object "[\"x\""))

(test-error (json-string->object "{\"\\uDFAA\":0}"))

(test-error (json-string->object "\x0;[\x0;\"\x0;"))

(test-equal '#("ꙭ") (json-string->object "[\"\\uA66D\"]"))

(test-error (json-string->object "[é]"))

(test-equal '#(#t) (json-string->object "[true]"))

(test-error (json-string->object "[.2e-3]"))

(test-error (json-string->object "[,"))

(test-equal '#("🿾") (json-string->object "[\"\\uD83F\\uDFFE\"]"))

(test-equal '#("\\u0000") (json-string->object "[\"\\\\u0000\"]"))

(test-equal '#("ࠡ") (json-string->object "[\"\\u0821\"]"))

(test-equal '#("\"") (json-string->object "[\"\\\"\"]"))

(test-error (json-string->object "[   , \"\"]"))

(test-error (json-string->object "{\"id\":0,}"))

(test-error (json-string->object "{\"a\":\"b\",,\"c\":\"d\"}"))

(test-error (json-string->object "*"))

(test-equal '#("new\nline") (json-string->object "[\"new\\u000Aline\"]"))

(test-error (json-string->object "[-123.123foo]"))

(test-error (json-string->object "[x"))

(test-error (json-string->object "[0e]"))

(test-error (json-string->object "[0"))

(test-error (json-string->object "[\"\\"))

(test-error (json-string->object "[1,]"))

(test-error (json-string->object "{\"asd\":\"asd\""))

(test-error (json-string->object "[.123]"))

(test-equal '#(4) (json-string->object "[ 4]"))

(test-error (json-string->object "[\f]"))

(test-error (json-string->object "[2.e3]"))

(test-equal '#(-1) (json-string->object "[-1]"))

(test-error (json-string->object "{key: 'value'}"))

(test-error (json-string->object "[１]"))

(test-equal 42 (json-string->object "42"))

(test-error (json-string->object "[ false, nul"))

(test-error (json-string->object "{\"a\": true} \"x\""))

(test-equal '#("���") (json-string->object "[\"���\"]"))

(test-equal -.1 (json-string->object "-0.1"))

(test-error (json-string->object "{1:1}"))

(test-error (json-string->object "[1.0e-]"))

(test-error (json-string->object "[++1234]"))

(test-equal '#("\"") (json-string->object "[\"\\u0022\"]"))

(test-error (json-string->object "{\"a\":\"a\" 123}"))

(test-equal '#(1e22) (json-string->object "[1E22]"))

(test-equal '#("\\a") (json-string->object "[\"\\\\a\"]"))

(test-error (json-string->object "[-01]"))

(test-equal '#(1.23456e80) (json-string->object "[123.456e78]"))

(test-error (json-string->object "[1,,]"))

(test-equal '#("a/*b*/c/*d//e") (json-string->object "[\"a/*b*/c/*d//e\"]"))

(test-error (json-string->object "\""))

(test-equal
 '#(-123123123123123123123123123123)
 (json-string->object "[-123123123123123123123123123123]"))

(test-equal (void) (json-string->object "null"))

(test-equal " " (json-string->object "\" \""))

(test-error (json-string->object "{\""))

(test-equal
 '#("aクリス")
 (json-string->object "[\"\\u0061\\u30af\\u30EA\\u30b9\"]"))

(test-equal '#(1) (json-string->object "[1\n]"))

(test-error (json-string->object "]"))

(test-error (json-string->object "\"\\UA66D\""))

(test-error (json-string->object "[\"\",]"))

(test-error (json-string->object "[1.8011670033376514H-308]"))

(test-error (json-string->object "[\"\\\x0;\"]"))

(test-error (json-string->object "[\"\\uDADA\"]"))

(test-error (json-string->object "[⁠]"))

(test-error (json-string->object "[True]"))

(test-error (json-string->object "[*]"))

(test-error (json-string->object "{\"a\":\"b\"}//"))

(test-error (json-string->object "[1 true]"))

(test-equal '#(0.) (json-string->object "[0e+1]"))

(test-equal
 (list->table '((a: . "b")))
 (json-string->object "{\n\"a\": \"b\"\n}"))

(test-error (json-string->object "[1.2a-3]"))

(test-error (json-string->object "['"))

(test-error (json-string->object "{\"\":"))

(test-error (json-string->object "[0E]"))

(test-equal '#(.01) (json-string->object "[1E-2]"))

(test-error (json-string->object "[tru]"))

(test-error (json-string->object "[\"x\",,]"))

(test-equal "asd" (json-string->object "\"asd\""))

(test-error (json-string->object "[+Inf]"))

(test-error (json-string->object "[0x42]"))

(test-error (json-string->object "1]"))

(test-error (json-string->object "{\"x\", null}"))

(test-error (json-string->object "{'a'"))

(test-equal '#(-123) (json-string->object "[-123]"))

(test-error (json-string->object "[\"\\uDd1e\\uD834\"]"))

(test-error (json-string->object "{\"a\":/*comment*/\"b\"}"))

(test-error (json-string->object "[\"\\uD800\\uD800\\x\"]"))

(test-error (json-string->object "[\x0;\"\x0;"))

(test-error (json-string->object "[\""))

(test-error (json-string->object "{\"a\":\"b\"}/**//"))

(test-equal '#("a") (json-string->object "[\"a\"]"))

(test-error (json-string->object "[\"\": 1]"))

(test-error (json-string->object "{\"a\":\"b\"}/"))

(test-equal '#(123.456789) (json-string->object "[123.456789]"))

(test-error (json-string->object "[2.e+3]"))

(test-error (json-string->object "[{}"))

(test-error (json-string->object "[1]x"))

(test-error (json-string->object "[\""))

(test-equal '#("​") (json-string->object "[\"\\u200B\"]"))

(test-error (json-string->object "[][]"))

(test-equal '#(" ") (json-string->object "[\" \"]"))

(test-error (json-string->object "[-012]"))

(test-error (json-string->object "[\"a\",\n4\n,1,"))

(test-equal #t (json-string->object "true"))

(test-error (json-string->object "{\"a\" b}"))

(test-equal '#("ģ") (json-string->object "[\"\\u0123\"]"))

(test-equal '#("\\") (json-string->object "[\"\\u005C\"]"))

(test-error (json-string->object "[\""))

(test-error (json-string->object "{\"a\" \"b\"}"))

(test-equal (list->table '((a: . #()))) (json-string->object "{\"a\":[]}"))

(test-equal '#("⁤") (json-string->object "[\"\\u2064\"]"))

(test-error (json-string->object "[- 1]"))

(test-equal '#("\x12;") (json-string->object "[\"\\u0012\"]"))

(test-equal '#("asd ") (json-string->object "[\"asd \"]"))

(test-equal '#("􏿾") (json-string->object "[\"\\uDBFF\\uDFFE\"]"))

(test-error (json-string->object "{"))

(test-equal '#("€𝄞") (json-string->object "[\"€𝄞\"]"))

(test-error (json-string->object "[\"\\\t\"]"))

(test-equal '#(0.) (json-string->object "[123.456e-789]"))

(test-error (json-string->object "[0e+-1]"))

(test-error
 (json-string->object
  "[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[["))

(test-error (json-string->object "[\\u0020\"asd\"]"))

(test-error (json-string->object "[0.3e]"))

(test-error (json-string->object "["))

(test-equal '#("\x7f;") (json-string->object "[\"\x7f;\"]"))

(test-error (json-string->object "{}}"))

(test-error (json-string->object "[0e+]"))

(test-error (json-string->object "å"))

(test-error (json-string->object "[1eE2]"))

(test-equal
 (list->table '((min: . -1e28) (max: . 1e28)))
 (json-string->object "{ \"min\": -1.0e+28, \"max\": 1.0e+28 }"))

(test-error (json-string->object "[+1]"))

(test-equal
 (list->table
  (list '(id: . "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        (cons 'x:
              (vector (list->table
                       '((id:
                          .
                          "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")))))))
 (json-string->object
  "{\"x\":[{\"id\": \"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\"}], \"id\": \"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx\"}"))

(test-error (json-string->object "[nul]"))

(test-equal '#(0) (json-string->object "[-0]"))

(test-error (json-string->object "123\x0;"))

(test-error (json-string->object "[\"\\uD800\\u\"]"))

(test-equal '#(1) (json-string->object " [1]"))

(test-error (json-string->object "[1,,2]"))

(test-equal '#("a") (json-string->object "[\"a\"]\n"))

(test-error (json-string->object "{null:null,null:null}"))

(test-error (json-string->object "[\"x\", truth]"))

(test-equal '#(+inf.0) (json-string->object "[1.5e+9999]"))

(test-equal '#("𝄞") (json-string->object "[\"\\uD834\\uDd1e\"]"))

(test-error (json-string->object "[2.e-3]"))

(test-equal
 (list->table '((title: . "Полтора Землекопа")))
 (json-string->object
  "{\"title\":\"\\u041f\\u043e\\u043b\\u0442\\u043e\\u0440\\u0430 \\u0417\\u0435\\u043c\\u043b\\u0435\\u043a\\u043e\\u043f\\u0430\" }"))

(test-error (json-string->object "[\\n]"))

(test-error (json-string->object "[-1x]"))

(test-error (json-string->object "[\"\\uD800\\u1\"]"))

(test-error (json-string->object "[\"\va\"\\f]"))

(test-error
 (json-string->object
  "[{\"\":[{\"\":[{\"\":[{\"\":[{\"\":[{\"\":[{\"\":[{\"\":[{\"\":[{\"\":\n"))

(test-error (json-string->object "{\"a"))

(test-error (json-string->object "{9999E9999:1}"))

(test-equal '#(0.) (json-string->object "[123e-10000000]"))

(test-error (json-string->object "{'a':0}"))

(test-error (json-string->object "[0.3e+]"))

(test-error (json-string->object "[1ea]"))

(test-error (json-string->object "[\"\\\\\\\"]"))

(test-equal '#(0.) (json-string->object "[0e1]"))

(test-equal '#(100.) (json-string->object "[1e+2]"))

(test-equal '#("\\n") (json-string->object "[\"\\\\n\"]"))

(test-equal '#(#()) (json-string->object "[[]   ]"))

(test-equal
 (vector (void) 1 "1" (list->table '()))
 (json-string->object "[null, 1, \"1\", {}]"))

(test-equal '#("a\x7f;a") (json-string->object "[\"a\x7f;a\"]"))

(test-error (json-string->object "{\"a\":\"b\"}#"))

(test-equal
 (vector 1 (void) (void) (void) 2)
 (json-string->object "[1,null,null,null,2]"))

(test-equal '#(123) (json-string->object "[123]"))

(test-error (json-string->object "[1+2]"))

(test-error (json-string->object "[\"a\""))

(test-error (json-string->object "{:\"b\"}"))

(test-error (json-string->object "[\"\\uD800\\u1x\"]"))

(test-error (json-string->object "{\"a\":\"b\"}#{}"))

(test-error (json-string->object "[1]]"))

(test-equal (list->table '((||: . 0))) (json-string->object "{\"\":0}"))

(test-equal '#("￿") (json-string->object "[\"￿\"]"))

(test-equal
 '#(-237462374673276894279832749832423479823246327846)
 (json-string->object "[-237462374673276894279832749832423479823246327846]"))

(test-error (json-string->object "[\"\\ud800\"]"))

(test-equal
 (list->table '((|foo\x0;bar|: . 42)))
 (json-string->object "{\"foo\\u0000bar\": 42}"))

(test-error (json-string->object "<.>"))

(test-equal
 '#("😹💍")
 (json-string->object "[\"\\ud83d\\ude39\\ud83d\\udc8d\"]"))

(test-equal
 '#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#(#())))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))
 (json-string->object
  "[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]"))

(test-equal '#(.01) (json-string->object "[1e-2]"))

(test-equal '#() (json-string->object " [] "))

(test-equal '#("asd") (json-string->object "[ \"asd\"]"))

(test-equal '#("􏿿") (json-string->object "[\"􏿿\"]"))

(test-error (json-string->object "{[: \"x\"}\n"))

(test-equal '#(-inf.0) (json-string->object "[-1e+9999]"))

(test-error (json-string->object "[NaN]"))

(test-error (json-string->object "abc"))

(test-error (json-string->object "[-.123]"))

(test-error (json-string->object "[\"new\nline\"]"))

(test-equal '#(2) (json-string->object "[2] "))

(test-error (json-string->object "[\""))

(test-error (json-string->object "['single quote']"))

(test-error (json-string->object "[1 000.0]"))

(test-equal
 (list->table '((a: . "c")))
 (json-string->object "{\"a\":\"b\",\"a\":\"c\"}"))

(test-error (json-string->object "[\"\\u00A\"]"))

(test-error (json-string->object "{\"a\""))

(test-equal '#(",") (json-string->object "[\"\\u002c\"]"))

(test-equal '#("⍂㈴⍂") (json-string->object "[\"⍂㈴⍂\"]"))

(test-error (json-string->object "{\"a\":\"b\"}/**/"))

(test-equal '#("﷐") (json-string->object "[\"\\uFDD0\"]"))

(test-error (json-string->object "[fals]"))

(test-error (json-string->object "[\x0;]"))

(test-equal (list->table '()) (json-string->object "{}"))

(test-equal '#("new line") (json-string->object "[\"new\\u00A0line\"]"))

(test-error (json-string->object "[.-1]"))

(test-error (json-string->object "2@"))

(test-error (json-string->object "[1.]"))

(test-error (json-string->object "[\""))

(test-error (json-string->object "[\"\\uDd1ea\"]"))

(test-error (json-string->object "[\"\\a\"]"))

(test-error (json-string->object "[-Infinity]"))

(test-error (json-string->object "[\"\""))

(test-error (json-string->object "[\"\\uD800\\n\"]"))

(test-equal '#(#f) (json-string->object "[false]"))

(test-error (json-string->object "[1e"))

(test-equal '#("￾") (json-string->object "[\"\\uFFFE\"]"))

(test-error (json-string->object "[\"\\{[\"\\{[\"\\{[\"\\{"))

(test-error (json-string->object "[1.0e]"))

(test-error (json-string->object "[1,"))

(test-error (json-string->object "[,1]"))

(test-error (json-string->object "[\"\\uD800\\\"]"))

(test-error (json-string->object "[ false, tru"))

(test-error (json-string->object "[\"\\🌀\"]"))

(test-error (json-string->object "[\"\"],"))

(test-equal '#("𛿿") (json-string->object "[\"𛿿\"]"))

(test-error (json-string->object "[⁠]"))

(test-error (json-string->object "[0.e1]"))

(test-error (json-string->object "[1,\n1\n,1"))

(test-error (json-string->object "[<null>]"))

(test-error (json-string->object "{🇨🇭}"))

(test-error (json-string->object "{\"a\":\"a"))

(test-error (json-string->object "[\"asd]"))

(test-equal '#(" ") (json-string->object "[\" \"]"))

(test-error (json-string->object "{\"x\"::\"b\"}"))

(test-equal
 (list->table '((asd: . "sdf")))
 (json-string->object "{\"asd\":\"sdf\"}"))

(test-error (json-string->object "[\"\\uDFAA\"]"))

(test-error (json-string->object "[\"a"))

(test-error (json-string->object "[\"x\"]]"))

(test-error (json-string->object "[\"日ш"))

(test-error (json-string->object "[3[4]]"))

(test-error (json-string->object "[\"\\"))

(test-error (json-string->object "[\"\\u"))

(test-error (json-string->object "[{"))

(test-error (json-string->object "[0x1]"))

(test-equal '#("asd") (json-string->object "[\"asd\"]"))

(test-error (json-string->object "[-1.0.]"))

(test-error (json-string->object "[0E+]"))

(test-equal '#(1.23e67) (json-string->object "[123e65]"))

(test-error (json-string->object "[,]"))

;;;============================================================================
