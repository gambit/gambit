#!/usr/bin/env gsi-script

; File: "fig16-14.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.14 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define bold      "bold")
(define italic    "italic")
(define underline "underline")
(define font      "font")

(define (bullet)  (display "bullet")  (newline))
(define (margins) (display "margins") (newline))

(menu ".m")

(tcl ".m" 'add 'checkbutton label: "Bold" variable: bold)
(tcl ".m" 'add 'checkbutton label: "Italic" variable: italic)
(tcl ".m" 'add 'checkbutton label: "Underline" variable: underline)
(tcl ".m" 'add 'separator)
(tcl ".m" 'add 'radiobutton label: "Times" variable: font value: "times")
(tcl ".m" 'add 'radiobutton label: "Helvetica" variable: font value: "helvetica")
(tcl ".m" 'add 'radiobutton label: "Courier" variable: font value: "courier")
(tcl ".m" 'add 'separator)
(tcl ".m" 'add 'command label: "Insert Bullet" command: bullet)
(tcl ".m" 'add 'command label: "Margins and Tabs..." command: margins)

(set-variable! font "courier")

(tcl ".m" 'post 0 0)


; ==> Equivalent program in pure Tcl/Tk:
;
; menu .m
; .m add checkbutton -label Bold -variable bold
; .m add checkbutton -label Italic -variable italic
; .m add checkbutton -label Underline -variable underline
; .m add separator
; .m add radiobutton -label Times -variable font -value times
; .m add radiobutton -label Helvetica -variable font -value helvetica
; .m add radiobutton -label Courier -variable font -value courier
; .m add separator
; .m add command -label "Insert Bullet" -command bullet
; .m add command -label "Margins and Tabs..." -command margins
;
; set font courier
;
; proc bullet {} {
;   puts "bullet"
; }
;
; proc margins {} {
;   puts "margins"
; }
;
; .m post 0 0
