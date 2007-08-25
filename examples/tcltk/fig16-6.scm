#!/usr/bin/env gsi-script

; File: "fig16-6.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.6 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define (ok)     (display "ok")     (newline))
(define (appl)   (display "apply")  (newline))
(define (cancel) (display "cancel") (newline))
(define (help)   (display "help")   (newline))

(button ".ok"     text: "OK"     command: ok)
(button ".apply"  text: "Apply"  command: appl)
(button ".cancel" text: "Cancel" command: cancel)
(button ".help"   text: "Help"   command: help)

(pack ".ok" ".apply" ".cancel" ".help" side: 'left)


; ==> Equivalent program in pure Tcl/Tk:
;
; proc ok {}     { puts "ok" }
; proc appl {}   { puts "apply" }
; proc cancel {} { puts "cancel" }
; proc help {}   { puts "help" }
;
; button .ok     -text OK     -command ok
; button .apply  -text Apply  -command appl
; button .cancel -text Cancel -command cancel
; button .help   -text Help   -command help
;
; pack .ok .apply .cancel .help -side left
