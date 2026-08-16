#!/usr/bin/env gsi-script
;; Copyright (c) 2024 by Macon Gambill, all rights reserved.

(load "adorn/adorn")

(define (main . args)
  (let ((source/css (if (null? args)
                        (error "No arguments given")
                        (let ((first (car args)) (rest (cdr args)))
                          (cond ((null? rest)
                                 (cons first "gambit-examples.css"))
                                ((string=? first "-c")
                                 (cons (car rest) "gambit-examples.cm.css"))
                                (else (cons (car rest) first)))))))
    (let ((source (car source/css)) (css (cdr source/css)))
      (let ((css-content (call-with-input-file css
                           (lambda (p) (read-line p #f)))))
        (let ((ac-list (adorn#reverse+simplify-kinds!
                    (adorn#adorn! (call-with-input-file source
                                    (lambda (p) (read-all p read-char))))))
              (base-filename (basename source)))
          (with-output-to-file
              (string-append base-filename
                             (cond ((string=? css "gambit-examples.css")
                                    ".html")
                                   ((string=? css "gambit-examples.cm.css")
                                    ".cm.html")
                                   (else ".alt.html")))
            (lambda ()
              (write-pre-css base-filename)
              (display css-content)
              (write-string #<<END
-->
</style>
</head>
<body lang="en">
<pre class="lisp-preformatted">

END
)
            (write-ac-list ac-list)
            (write-string #<<END
</pre>
</body>

END
))))))))

(define (basename path-string)
  (let loop ((new '()) (old (reverse (string->list path-string))))
    (if (null? old)
        (list->string new)
        (let ((next (car old)))
          (if (char=? next #\/)
              (list->string new)
              (loop (cons next new) (cdr old)))))))

(define (write-pre-css title)
  (write-string (string-append #<<END
<!DOCTYPE html>
<html>
<!-- Created by scm-to-html.scm -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>
END
title #<<END
</title>
<meta name="resource-type" content="document">
<meta name="viewport" content="width=device-width,initial-scale=1">
<style type="text/css">
<!--

END
)))

(define html-safe
  (append '(#\space #\newline)
          (char-set->list (char-set-intersection char-set:ascii
                                                 char-set:letter+digit))))

(define (char->html-maybe-& c)
  (if (member c html-safe char=?)
      (list c)
      (append '(#\& #\#)
              (string->list (number->string (char->integer c)))
              '(#\;))))

(define write-ac-list
  (let ((open-span (lambda (kind)
                     (write-string (string-append "<span class=\""
                                                  (symbol->string kind)
                                                  "\">"))))
        (close-span (lambda () (write-string "</span>")))
        (write-chars (lambda (char-list) (for-each write-char char-list))))
    (lambda (ac-list)
      (let loop ((rest ac-list) (span #f))
        (cond ((null? rest) (when span (close-span)))
              (else (let ((ac (car rest)))
                      (let ((nc (adorn#get-char ac)) (nk (adorn#get-kind ac)))
                        (cond ((not span)
                               (cond ((memq nk '(default whitespace))
                                      (write-chars (char->html-maybe-& nc))
                                      (loop (cdr rest) #f))
                                     (else
                                      (open-span nk)
                                      (write-chars (char->html-maybe-& nc))
                                      (loop (cdr rest) nk))))
                              (else
                               (cond ((memq nk (list span 'whitespace))
                                      (write-chars (char->html-maybe-& nc))
                                      (loop (cdr rest) span))
                                     ((eq? nk 'default)
                                      (close-span)
                                      (write-chars (char->html-maybe-& nc))
                                      (loop (cdr rest) #f))
                                     (else (close-span)
                                           (open-span nk)
                                           (write-chars
                                            (char->html-maybe-& nc))
                                           (loop (cdr rest) nk)))))))))))))
