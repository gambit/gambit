#!/usr/bin/env gsi-script

(import (srfi 39))

(define base (make-parameter 10))

(define (num->str x)
  (number->string x (base)))

(println "(num->str 123) => "
         (num->str 123))

(println "(parameterize ((base 2)) (num->str 123)) => "
         (parameterize ((base 2)) (num->str 123)))

(base 16)

(println "after the call (base 16), (num->str 123) => "
         (num->str 123))

(print "Demo source code:\n\n" (read-file-string (this-source-file)))
