#!/usr/bin/env gsi-script

; File: "fig16-15.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.15 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define bold      "bold")
(define italic    "italic")
(define underline "underline")
(define font      "font")

(define (bullet)  (display "bullet")  (newline))
(define (margins) (display "margins") (newline))

(frame ".mbar" relief: 'raised bd: 2)
(frame ".dummy" width: "10c" height: "5c")

(pack ".mbar" ".dummy" side: 'top fill: 'x)

(menubutton ".mbar.file" text: "File" underline: 0)
(menu ".mbar.file.menu")
(tcl ".mbar.file" 'configure menu: ".mbar.file.menu")

(menubutton ".mbar.edit" text: "Edit" underline: 0)
(menu ".mbar.edit.menu")
(tcl ".mbar.edit" 'configure menu: ".mbar.edit.menu")

(menubutton ".mbar.graphics" text: "Graphics" underline: 0)
(menu ".mbar.graphics.menu")
(tcl ".mbar.graphics" 'configure menu: ".mbar.graphics.menu")

(menubutton ".mbar.text" text: "Text" underline: 0)
(menu ".mbar.text.menu")
(tcl ".mbar.text" 'configure menu: ".mbar.text.menu")

(tcl ".mbar.text.menu" 'add 'checkbutton label: "Bold" variable: bold)
(tcl ".mbar.text.menu" 'add 'checkbutton label: "Italic" variable: italic)
(tcl ".mbar.text.menu" 'add 'checkbutton label: "Underline" variable: underline)
(tcl ".mbar.text.menu" 'add 'separator)
(tcl ".mbar.text.menu" 'add 'radiobutton label: "Times" variable: font
                       value: "times")
(tcl ".mbar.text.menu" 'add 'radiobutton label: "Helvetica" variable: font
                       value: "helvetica")
(tcl ".mbar.text.menu" 'add 'radiobutton label: "Courier" variable: font
                       value: "courier")
(tcl ".mbar.text.menu" 'add 'separator)
(tcl ".mbar.text.menu" 'add 'command label: "Insert Bullet" command: bullet)
(tcl ".mbar.text.menu" 'add 'command label: "Margins and Tabs..." command: margins)

(set-variable! font "courier")

(menubutton ".mbar.view" text: "View" underline: 0)
(menu ".mbar.view.menu")
(tcl ".mbar.view" 'configure menu: ".mbar.view.menu")

(menubutton ".mbar.help" text: "Help" underline: 0)
(menu ".mbar.help.menu")
(tcl ".mbar.help" 'configure menu: ".mbar.help.menu")

(pack ".mbar.file" ".mbar.edit" ".mbar.graphics" ".mbar.text" ".mbar.view" side: 'left)
(pack ".mbar.help" side: 'right)

(focus ".mbar")


; ==> Equivalent program in pure Tcl/Tk:
;
; frame .mbar -relief raised -bd 2
; frame .dummy -width 10c -height 5c
; pack .mbar .dummy -side top -fill x
;
; menubutton .mbar.file -text File -underline 0 -menu .mbar.file.menu
; menubutton .mbar.edit -text Edit -underline 0 -menu .mbar.edit.menu
; menubutton .mbar.graphics -text Graphics -underline 0 \
;            -menu .mbar.graphics.menu
; menubutton .mbar.text -text Text -underline 0 -menu .mbar.text.menu
; menubutton .mbar.view -text View -underline 0 -menu .mbar.view.menu
; menubutton .mbar.help -text Help -underline 0 -menu .mbar.help.menu
;
; menu .mbar.file.menu
;
; menu .mbar.edit.menu
;
; menu .mbar.graphics.menu
;
; menu .mbar.text.menu
; .mbar.text.menu add checkbutton -label Bold -variable bold
; .mbar.text.menu add checkbutton -label Italic -variable italic
; .mbar.text.menu add checkbutton -label Underline -variable underline
; .mbar.text.menu add separator
; .mbar.text.menu add radiobutton -label Times -variable font -value times
; .mbar.text.menu add radiobutton -label Helvetica -variable font \
;                 -value helvetica
; .mbar.text.menu add radiobutton -label Courier -variable font -value courier
; .mbar.text.menu add separator
; .mbar.text.menu add command -label "Insert Bullet" -command bullet
; .mbar.text.menu add command -label "Margins and Tabs..." -command margins
;
; set font courier
;
; menu .mbar.view.menu
;
; menu .mbar.help.menu
;
; pack .mbar.file .mbar.edit .mbar.graphics .mbar.text .mbar.view -side left
; pack .mbar.help -side right
;
; focus .mbar
;
; proc bullet {} {
;   puts "bullet"
; }
;
; proc margins {} {
;   puts "margins"
; }
