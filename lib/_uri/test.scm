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
(test-eq #t (uri-slashes uri))
(test-equal "example.com:2020" (uri-authority uri))
(test-equal "/" (uri-path uri))
(test-eq #f (uri-query uri))
(test-eq #f (uri-fragment uri))

(define uri-encoded (string->uri (encode-for-uri "example://example.com/Aéà") #t))

(test-equal "example" (uri-scheme uri-encoded))
(test-eq #t (uri-slashes uri-encoded))
(test-equal "example.com" (uri-authority uri-encoded))
(test-equal "/Aéà" (uri-path uri-encoded))
(test-eq #f (uri-query uri-encoded))
(test-eq #f (uri-fragment uri-encoded))

;;;============================================================================
