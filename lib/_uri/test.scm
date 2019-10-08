;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2019 by Frédéric Hamel, All Rights Reserved.

;;;============================================================================

(import _uri)
(import _test)

(define query "a=1&b=2")
(define query-result (string->uri-query query #f))

(check-equal? query-result '(("a" . "1") ("b" . "2")))

(define uri (string->uri "example://example.com:2020" #f))

(check-equal? (uri-scheme uri) "example")
(check-true (uri-slashes uri))
(check-equal? (uri-authority uri) "example.com:2020")
(check-equal? (uri-path uri) "/")
(check-false (uri-query uri))
(check-false (uri-fragment uri))

(define uri-encoded (string->uri (encode-for-uri "example://example.com/Aéà") #t))

(check-equal? (uri-scheme uri-encoded) "example")
(check-true (uri-slashes uri-encoded))
(check-equal? (uri-authority uri-encoded) "example.com")
(check-equal? (uri-path uri-encoded) "/Aéà")
(check-false (uri-query uri-encoded))
(check-false (uri-fragment uri-encoded))

;;;============================================================================
