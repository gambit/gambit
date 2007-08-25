#!/usr/bin/env gsi-script

; File: "fig16-12.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.12 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define (new-color value)

  (define (get-number widget)
    (string->number (tcl widget 'get)))

  (let ((color-code
         (number->string (+ (expt 2 24)
                            (* (expt 2 16) (get-number ".red"))
                            (* (expt 2 8) (get-number ".green"))
                            (get-number ".blue"))
                         16)))
    (string-set! color-code 0 #\#)
    (tcl ".sample" 'configure background: color-code)))

(scale ".red"
       label: "Red"
       from: 0
       to: 255
       length: "10c"
       orient: 'horizontal
       command: new-color)

(scale ".green"
       label: "Green"
       from: 0
       to: 255
       length: "10c"
       orient: 'horizontal
       command: new-color)

(scale ".blue"
       label: "Blue"
       from: 0
       to: 255
       length: "10c"
       orient: 'horizontal
       command: new-color)

(frame ".sample" height: "1.5c" width: "6c")

(pack ".red" ".green" ".blue" side: 'top)

(pack ".sample" side: 'bottom pady: "2m")


; ==> Equivalent program in pure Tcl/Tk:
;
; scale .red -label Red -from 0 -to 255 -length 10c \
;       -orient horizontal -command newColor
; scale .green -label Green -from 0 -to 255 -length 10c \
;       -orient horizontal -command newColor
; scale .blue -label Blue -from 0 -to 255 -length 10c \
;       -orient horizontal -command newColor
; frame .sample -height 1.5c -width 6c
; pack .red .green .blue -side top
; pack .sample -side bottom -pady 2m
; 
; proc newColor value {
;   set color [format #%02x%02x%02x [.red get] [.green get] [.blue get]]
;   .sample configure -background $color
; }
