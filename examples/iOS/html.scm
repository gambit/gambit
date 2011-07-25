;;;============================================================================

;;; File: "html.scm"

;;; Copyright (c) 2011 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("html#"))

(##include "~~lib/gambit#.scm")

(##include "html#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (fixnum)
  (not safe)
)

;;;============================================================================

;; Escape text for inclusion in an HTML document.

(define (html-escape str)

  ;; This table has a non-#f entry for every character that is valid
  ;; in a standard HTML document.  The entry is what should be
  ;; displayed when this character occurs.

  (define character-entity-table
    '#(#\nul
       #f; #\x01
       #f; #\x02
       #f; #\x03
       #f; #\x04
       #f; #\x05
       #f; #\x06
       #f; #\alarm
       #f; #\backspace
       #\tab
       #\newline
       #f; #\vtab
       #f; #\page
       #\return
       #f; #\x0E
       #f; #\x0F
       #f; #\x10
       #f; #\x11
       #f; #\x12
       #f; #\x13
       #f; #\x14
       #f; #\x15
       #f; #\x16
       #f; #\x17
       #f; #\x18
       #f; #\x19
       #f; #\x1A
       #f; #\x1B
       #f; #\x1C
       #f; #\x1D
       #f; #\x1E
       #f; #\x1F
       #\space
       #\!
       "&quot;"
       #\#
       #\$
       #\%
       "&amp;"
       #\'
       #\(
       #\)
       #\*
       #\+
       #\,
       #\-
       #\.
       #\/
       #\0
       #\1
       #\2
       #\3
       #\4
       #\5
       #\6
       #\7
       #\8
       #\9
       #\:
       #\;
       "&lt;"
       #\=
       "&gt;"
       #\?
       #\@
       #\A
       #\B
       #\C
       #\D
       #\E
       #\F
       #\G
       #\H
       #\I
       #\J
       #\K
       #\L
       #\M
       #\N
       #\O
       #\P
       #\Q
       #\R
       #\S
       #\T
       #\U
       #\V
       #\W
       #\X
       #\Y
       #\Z
       #\[
       #\\
       #\]
       #\^
       #\_
       #\`
       #\a
       #\b
       #\c
       #\d
       #\e
       #\f
       #\g
       #\h
       #\i
       #\j
       #\k
       #\l
       #\m
       #\n
       #\o
       #\p
       #\q
       #\r
       #\s
       #\t
       #\u
       #\v
       #\w
       #\x
       #\y
       #\z
       #\{
       #\|
       #\}
       #\~
       #f; #\rubout
       #f; "&#128;"
       #f; "&#129;"
       "&#130;"
       "&#131;"
       "&#132;"
       "&#133;"
       "&#134;"
       "&#135;"
       "&#136;"
       "&#137;"
       "&#138;"
       "&#139;"
       "&#140;"
       #f; "&#141;"
       "&#142;"
       #f; "&#143;"
       #f; "&#144;"
       "&#145;"
       "&#146;"
       "&#147;"
       "&#148;"
       "&#149;"
       "&#150;"
       "&#151;"
       "&#152;"
       "&#153;"
       "&#154;"
       "&#155;"
       "&#156;"
       #f; "&#157;"
       "&#158;"
       "&#159;"
       "&#160;"
       "&#161;"
       "&#162;"
       "&#163;"
       "&#164;"
       "&#165;"
       "&#166;"
       "&#167;"
       "&#168;"
       "&#169;"
       "&#170;"
       "&#171;"
       "&#172;"
       "&#173;"
       "&#174;"
       "&#175;"
       "&#176;"
       "&#177;"
       "&#178;"
       "&#179;"
       "&#180;"
       "&#181;"
       "&#182;"
       "&#183;"
       "&#184;"
       "&#185;"
       "&#186;"
       "&#187;"
       "&#188;"
       "&#189;"
       "&#190;"
       "&#191;"
       "&#192;"
       "&#193;"
       "&#194;"
       "&#195;"
       "&#196;"
       "&#197;"
       "&#198;"
       "&#199;"
       "&#200;"
       "&#201;"
       "&#202;"
       "&#203;"
       "&#204;"
       "&#205;"
       "&#206;"
       "&#207;"
       "&#208;"
       "&#209;"
       "&#210;"
       "&#211;"
       "&#212;"
       "&#213;"
       "&#214;"
       "&#215;"
       "&#216;"
       "&#217;"
       "&#218;"
       "&#219;"
       "&#220;"
       "&#221;"
       "&#222;"
       "&#223;"
       "&#224;"
       "&#225;"
       "&#226;"
       "&#227;"
       "&#228;"
       "&#229;"
       "&#230;"
       "&#231;"
       "&#232;"
       "&#233;"
       "&#234;"
       "&#235;"
       "&#236;"
       "&#237;"
       "&#238;"
       "&#239;"
       "&#240;"
       "&#241;"
       "&#242;"
       "&#243;"
       "&#244;"
       "&#245;"
       "&#246;"
       "&#247;"
       "&#248;"
       "&#249;"
       "&#250;"
       "&#251;"
       "&#252;"
       "&#253;"
       "&#254;"
       "&#255;"
       ))

(if (not (string? str))
(object->string str)
  (call-with-output-string
   ""
   (lambda (port)
     (let ((n (string-length str)))
       (let loop ((start 0) (end 0))
         (if (= end n)
             (write-substring str start end port)
             (let* ((ch (string-ref str end))
                    (index (char->integer ch)))
               (cond ((and (< index 256)
                           (vector-ref character-entity-table index))
                      =>
                      (lambda (character-value)
                        (if (char? character-value)
                            (loop start (+ end 1))
                            (begin ;; it's a string
                              (write-substring
                               str
                               start
                               end
                               port)
                              (write-substring
                               character-value
                               0
                               (string-length character-value)
                               port)
                              (loop (+ end 1) (+ end 1))))))
                     (else
                      (display
                       (string-append
                        "Warning: Character (integer->char "
                        (number->string index)
                        ") is not a valid HTML 4.0 character entity\n")
                       (current-error-port))
                      (loop start (+ end 1)))))))))))
)

;;;============================================================================
