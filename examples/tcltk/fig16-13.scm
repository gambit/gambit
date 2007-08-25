#!/usr/bin/env gsi-script

; File: "fig16-13.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.13 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define name "name")

(label ".label" text: "File name:")

(entry ".entry"
       width: 20
       relief: 'sunken
       borderwidth: 2
       textvariable: name)

(pack ".label" ".entry" side: 'left padx: "1m" pady: "2m")


; ==> Equivalent program in pure Tcl/Tk:
;
; label .label -text "File name:"
; entry .entry -width 20 -relief sunken -borderwidth 2 -textvariable name
; pack .label .entry -side left -padx 1m -pady 2m
