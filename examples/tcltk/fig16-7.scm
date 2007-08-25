#!/usr/bin/env gsi-script

; File: "fig16-7.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.7 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define bold      "bold")
(define italic    "italic")
(define underline "underline")

(checkbutton ".bold"
             text: "Bold"
             variable: bold
             anchor: 'w)

(checkbutton ".italic"
             text: "Italic"
             variable: italic
             anchor: 'w)

(checkbutton ".underline"
             text: "Underline"
             variable: underline
             anchor: 'w)

(pack ".bold" ".italic" ".underline" side: 'top fill: 'x)


; ==> Equivalent program in pure Tcl/Tk:
;
; checkbutton .bold -text Bold -variable bold -anchor w
; checkbutton .italic -text Italic -variable italic -anchor w
; checkbutton .underline -text Underline -variable underline -anchor w
;
; pack .bold .italic .underline -side top -fill x
