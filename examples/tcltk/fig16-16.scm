#!/usr/bin/env gsi-script

; File: "fig16-16.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.16 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define color "color")
(define width "width")

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

(menu ".mbar.graphics.menu.color")
(tcl ".mbar.graphics.menu" 'add 'cascade label: "Line Color"
                           menu: ".mbar.graphics.menu.color")

(tcl ".mbar.graphics.menu.color" 'add 'radiobutton label: "Red"
                                 variable: color value: "red")
(tcl ".mbar.graphics.menu.color" 'add 'radiobutton label: "Green"
                                 variable: color value: "green")
(tcl ".mbar.graphics.menu.color" 'add 'radiobutton label: "Blue"
                                 variable: color value: "blue")

(set-variable! color "green")

(menu ".mbar.graphics.menu.width")
(tcl ".mbar.graphics.menu" 'add 'cascade label: "Line Width"
                           menu: ".mbar.graphics.menu.width")

(tcl ".mbar.graphics.menu.width" 'add 'radiobutton label: "1 point"
                                 variable: width value: "1")
(tcl ".mbar.graphics.menu.width" 'add 'radiobutton label: "2 points"
                                 variable: width value: "2")
(tcl ".mbar.graphics.menu.width" 'add 'radiobutton label: "4 points"
                                 variable: width value: "4")

(set-variable! width "1")

(menubutton ".mbar.text" text: "Text" underline: 0)
(menu ".mbar.text.menu")
(tcl ".mbar.text" 'configure menu: ".mbar.text.menu")

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
; .mbar.graphics.menu add cascade -label "Line Color" \
;                     -menu .mbar.graphics.menu.color
; .mbar.graphics.menu add cascade -label "Line Width" \
;                     -menu .mbar.graphics.menu.width
;
; menu .mbar.graphics.menu.color
; .mbar.graphics.menu.color add radiobutton -label Red -variable color \
;                           -value red
; .mbar.graphics.menu.color add radiobutton -label Green -variable color \
;                           -value green
; .mbar.graphics.menu.color add radiobutton -label Blue -variable color \
;                           -value blue
;
; set color green
;
; menu .mbar.graphics.menu.width
; .mbar.graphics.menu.width add radiobutton -label "1 point" -variable width \
;                           -value 1
; .mbar.graphics.menu.width add radiobutton -label "2 points" -variable width \
;                           -value 2
; .mbar.graphics.menu.width add radiobutton -label "4 points" -variable width \
;                           -value 4
;
; set width 1
;
; menu .mbar.text.menu
;
; menu .mbar.view.menu
;
; menu .mbar.help.menu
;
; pack .mbar.file .mbar.edit .mbar.graphics .mbar.text .mbar.view -side left
; pack .mbar.help -side right
;
; focus .mbar
