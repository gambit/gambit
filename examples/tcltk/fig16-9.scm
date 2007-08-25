#!/usr/bin/env gsi-script

; File: "fig16-9.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.9 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(message ".msg"
         width: "10c"
         justify: 'left
         relief: 'raised
         borderwidth: 2
         font: "-Adobe-Helvetica-Medium-R-Normal--*-180-*"
         text: "The document has been saved in \"foo.scm\"")

(pack ".msg")


; ==> Equivalent program in pure Tcl/Tk:
;
; message .msg -width 10c -justify left -relief raised -borderwidth 2 \
;         -font "-Adobe-Helvetica-Medium-R-Normal--*-180-*" \
;         -text "The document has been saved in \"foo.scm\""
;
; pack .msg
