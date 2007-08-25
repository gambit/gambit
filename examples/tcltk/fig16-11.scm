#!/usr/bin/env gsi-script

; File: "fig16-11.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.11 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(listbox ".words"
         relief: 'raised
         borderwidth: 2
         yscrollcommand: ".scroll set")

(scrollbar ".scroll" command: ".words yview")

(pack ".words" side: 'left)
(pack ".scroll" side: 'right fill: 'y)

(for-each (lambda (word)
            (tcl ".words" 'insert 'end word))
          '("apple" "boat" "cherry" "donkey" "eagle" "feather" "gorilla"
            "house" "indian" "jelly" "kayak" "letter" "man" "nun"
            "ox" "puppy" "queen" "rabbit"))


; ==> Equivalent program in pure Tcl/Tk:
;
; listbox .words -relief raised -borderwidth 2 -yscrollcommand ".scroll set"
;
; scrollbar .scroll -command ".words yview"
;
; pack .words -side left
; pack .scroll -side right -fill y
;
; foreach word {apple boat cherry donkey eagle feather gorilla
;               house indian jelly kayak letter man nun
;               ox puppy queen rabbit} {
;   .words insert end $word
; }
