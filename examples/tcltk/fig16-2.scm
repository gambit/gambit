#!/usr/bin/env gsi-script

; File: "fig16-2.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.2 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(label ".bitmap" bitmap: "@flagdown")
(label ".label" text: "No new mail")

(pack ".bitmap" ".label")


; ==> Equivalent program in pure Tcl/Tk:
;
; label .bitmap -bitmap @/usr/local/lib/tk/demos/bitmaps/flagdown
; label .label -text "No new mail"
; pack .bitmap .label
