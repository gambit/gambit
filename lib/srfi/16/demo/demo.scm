#!/usr/bin/env gsi-script

(import (srfi 16))

(define num->str
  (case-lambda 
    ((x) (number->string x))
    ((x base) (number->string x base))))

(println "(num->str 123) => " (num->str 123))
(println "(num->str 123 8) => " (num->str 123 8))

(println "An exception is raised when calling num->str with 0 or 3 parameters:")

(with-exception-catcher
 (lambda (exc)
   (pretty-print exc))
 (lambda ()
   (num->str)))

(with-exception-catcher
 (lambda (exc)
   (pretty-print exc))
 (lambda ()
   (num->str 123 10 20)))

(print "Demo source code:\n\n" (read-file-string (this-source-file)))
