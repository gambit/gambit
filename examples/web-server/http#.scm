;==============================================================================

; File: "http#.scm", Time-stamp: <2007-04-04 14:42:52 feeley>

; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

;==============================================================================

(##namespace ("http#"

; procedures

make-http-server
http-server-start!
reply
reply-html
current-request

make-request
request?
request-attributes
request-attributes-set!
request-connection
request-connection-set!
request-method
request-method-set!
request-query
request-query-set!
request-server
request-server-set!
request-uri
request-uri-set!
request-version
request-version-set!

make-server
server?
server-method-table
server-method-table-set!
server-port-number
server-port-number-set!
server-threaded?
server-threaded?-set!
server-timeout
server-timeout-set!

make-uri
uri?
uri-authority
uri-authority-set!
uri-fragment
uri-fragment-set!
uri-path
uri-path-set!
uri-query
uri-query-set!
uri-scheme
uri-scheme-set!

string->uri
string->uri-query
encode-for-uri

encode-x-www-form-urlencoded
decode-x-www-form-urlencoded
get-content

))

;==============================================================================
