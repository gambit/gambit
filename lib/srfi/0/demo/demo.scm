#!/usr/bin/env gsi-script
;; Note: guile needs the script line to be balanced with: !#

;; Many Scheme implementations including Gambit have a builtin
;; definition of cond-expand, so (import (srfi 0)) is not needed.
;; This program can be run with various Scheme systems like this:
;;
;; $ gsi srfi/0/demo                           # Gambit
;; $ ./lib/srfi/0/demo/demo.scm                # Gambit
;; $ guile lib/srfi/0/demo/demo.scm            # Guile
;; $ csi -s lib/srfi/0/demo/demo.scm           # Chicken
;; $ chibi-scheme -q lib/srfi/0/demo/demo.scm  # Chibi

(cond-expand
  (gambit  (print "Using Gambit.\n")
           (define-cond-expand-feature foo)) ;; define foo feature
  (guile   (display "Using Guile.\n"))
  (chicken (display "Using Chicken.\n"))
  (else    (display "Using an unknown Scheme implementation.\n")))

(cond-expand
  (foo (print "Demo source code:\n\n" (read-file-string (this-source-file))))
  (else))
