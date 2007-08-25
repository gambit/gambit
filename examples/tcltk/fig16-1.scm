#!/usr/bin/env gsi-script

; File: "fig16-1.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.1 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define frames
  (map (lambda (relief)
         (let ((f (string-append "." (symbol->string relief))))
           (frame f
                  width: "15m"
                  height: "10m"
                  relief: relief
                  borderwidth: 4)
           (pack f side: 'left padx: "2m" pady: "2m")
           f))
       '(raised sunken flat groove ridge)))

(tcl (list-ref frames 2) 'configure background: "black")


; ==> Equivalent program in pure Tcl/Tk:
;
; foreach relief {raised sunken flat groove ridge} {
;   frame .$relief -width 15m -height 10m -relief $relief -borderwidth 4
;   pack .$relief -side left -padx 2m -pady 2m
; }
; .flat configure -background black
