#!/usr/bin/env gsi-script

; File: "fig16-3.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.3 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define country "country")

(define (watch name)
  (let* ((.watch
          (string-append ".watch_" name))
         (.watch.label
          (string-append .watch ".label"))
         (.watch.value
          (string-append .watch ".value")))
    (toplevel .watch)
    (label .watch.label text: (string-append "Value of \"" name "\": "))
    (label .watch.value textvariable: name)
    (pack .watch.label .watch.value side: 'left)))

(set-variable! country "Japan")

(watch country)

(update "idletasks")

(display "type <return> to continue")
(read-char)

(set-variable! country "Great Britain")


; ==> Equivalent program in pure Tcl/Tk:
;
; proc watch name {
;   toplevel .watch_$name
;   label .watch_$name.label -text "Value of \"$name\": "
;   label .watch_$name.value -textvariable $name
;   pack .watch_$name.label .watch_$name.value -side left
; }
;
; set country "Japan"
;
; watch country
;
; update idletasks
;
; gets stdin
;
; set country "Great Britain"
