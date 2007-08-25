#!/usr/bin/env gsi-script

; File: "fig16-8.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.8 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define font "font")

(radiobutton ".times"
             text: "Times"
             variable: font
             value: "times"
             anchor: 'w)

(radiobutton ".helvetica"
             text: "Helvetica"
             variable: font
             value: "helvetica"
             anchor: 'w)

(radiobutton ".courier"
             text: "Courier"
             variable: font
             value: "courier"
             anchor: 'w)

(radiobutton ".symbol"
             text: "Symbol"
             variable: font
             value: "symbol"
             anchor: 'w)

(set-variable! font "courier")

(pack ".times" ".helvetica" ".courier" ".symbol" side: 'top fill: 'x)


; ==> Equivalent program in pure Tcl/Tk:
;
; radiobutton .times -text Times -variable font -value times -anchor w
; radiobutton .helvetica -text Helvetica -variable font -value helvetica \
;             -anchor w
; radiobutton .courier -text Courier -variable font -value courier -anchor w
; radiobutton .symbol -text Symbol -variable font -value symbol -anchor w
;
; set font courier
;
; pack .times .helvetica .courier .symbol -side top -fill x
