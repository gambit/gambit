#!/usr/bin/env gsi-script

; File: "fig16-10.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.10 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(listbox ".colors")

(pack ".colors")

(for-each (lambda (color)
            (tcl ".colors" 'insert 'end color))
          '("red" "green" "blue" "navy" "gray" "cyan" "tan" "gold" "pink"))

(tcl ".colors" 'configure background: "green")

(bind ".colors"
      "<Double-Button-1>"
      (lambda ()
        (tcl ".colors" 'configure background: (selection 'get))))


; ==> Equivalent program in pure Tcl/Tk:
;
; listbox .colors
;
; pack .colors
;
; foreach color {red green blue navy gray cyan tan gold pink} {
;   .colors insert end $color
; }
;
; .colors configure -background green
;
; bind .colors <Double-Button-1> {.colors configure -background [selection get]}
