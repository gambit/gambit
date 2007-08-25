#!/usr/bin/env gsi-script

; File: "fig16-17.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 16.17 from Chapter 16 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define (undo)   (display "undo")   (newline))
(define (redo)   (display "redo")   (newline))
(define (delete) (display "delete") (newline))
(define (copy)   (display "copy")   (newline))

(frame ".mbar" relief: 'raised bd: 2)
(frame ".dummy" width: "10c" height: "5c")

(pack ".mbar" ".dummy" side: 'top fill: 'x)

(menubutton ".mbar.file" text: "File" underline: 0)
(menu ".mbar.file.menu")
(tcl ".mbar.file" 'configure menu: ".mbar.file.menu")

(menubutton ".mbar.edit" text: "Edit" underline: 0)
(menu ".mbar.edit.menu")
(tcl ".mbar.edit" 'configure menu: ".mbar.edit.menu")

(tcl ".mbar.edit.menu" 'add 'command label: "Undo" underline: 0
                       accelerator: "Ctrl-z" command: undo)
(tcl ".mbar.edit.menu" 'add 'command label: "Redo" underline: 0
                       accelerator: "Ctrl-r" command: redo)
(tcl ".mbar.edit.menu" 'add 'separator)
(tcl ".mbar.edit.menu" 'add 'command label: "Delete" underline: 0
                       accelerator: "Ctrl-x" command: delete)
(tcl ".mbar.edit.menu" 'add 'command label: "Copy" underline: 0
                       accelerator: "Ctrl-c" command: copy)

(menubutton ".mbar.graphics" text: "Graphics" underline: 0)
(menu ".mbar.graphics.menu")
(tcl ".mbar.graphics" 'configure menu: ".mbar.graphics.menu")

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
; .mbar.edit.menu add command -label "Undo" -underline 0 \
;                 -accelerator "Ctrl+z" -command undo
; .mbar.edit.menu add command -label "Redo" -underline 0 \
;                 -accelerator "Ctrl+r" -command redo
; .mbar.edit.menu add separator
; .mbar.edit.menu add command -label "Delete" -underline 0 \
;                 -accelerator "Ctrl+x" -command delete
; .mbar.edit.menu add command -label "Copy" -underline 0 \
;                 -accelerator "Ctrl+c" -command copy
;
; menu .mbar.graphics.menu
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
;
; proc undo {} {
;   puts "undo"
; }
;
; proc redo {} {
;   puts "redo"
; }
;
; proc delete {} {
;   puts "delete"
; }
;
; proc copy {} {
;   puts "copy"
; }
