;;;============================================================================

;;; File: "test.scm"

;;; Copyright (c) 2019 by Frédéric Hamel, All Rights Reserved.

;;;============================================================================

(import _uri)
(import _test)

(define query "a=1&b=2")
(define query-result (string->uri-query query #f))

(test-equal '(("a" . "1") ("b" . "2")) query-result)

(define uri (string->uri "example://example.com:2020" #f))

(test-equal "example" (uri-scheme uri))
(test-assert (uri-slashes uri))
(test-equal "example.com:2020" (uri-authority uri))
(test-equal "/" (uri-path uri))
(test-assert (not (uri-query uri)))
(test-assert (not (uri-fragment uri)))

(define uri-encoded (string->uri (encode-for-uri "example://example.com/Aéà") #t))

(test-equal "example" (uri-scheme uri-encoded))
(test-assert (uri-slashes uri-encoded))
(test-equal "example.com" (uri-authority uri-encoded))
(test-equal "/Aéà" (uri-path uri-encoded))
(test-assert (not (uri-query uri-encoded)))
(test-assert (not (uri-fragment uri-encoded)))

;;;============================================================================
