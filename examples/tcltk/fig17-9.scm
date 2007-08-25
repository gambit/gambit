#!/usr/bin/env gsi-script

; File: "fig17-9.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

; Translation into Scheme of Figure 17.9 from Chapter 17 of John
; Ousterhout's "Tcl and the Tk Toolkit".

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(load "tcltk")

(define pts       "pts")
(define bold      "bold")
(define italic    "italic")
(define underline "underline")

(frame ".f1")
(frame ".f2")

(define rbuttons
  (map (lambda (size)
         (let* ((size-str (number->string size))
                (rb (string-append ".f1." size-str)))
           (radiobutton rb
                        text: (string-append size-str " points")
                        relief: 'flat
                        variable: pts
                        value: size-str)
           rb))
       '(8 10 12 18 24)))

(checkbutton ".f2.bold"
             text: "Bold"
             relief: 'flat
             variable: bold)
(checkbutton ".f2.italic"
             text: "Italic"
             relief: 'flat
             variable: italic)
(checkbutton ".f2.underline"
             text: "Underline"
             relief: 'flat
             variable: underline)

(define cbuttons '(".f2.bold" ".f2.italic" ".f2.underline"))

(set-variable! pts "10")

(pack ".f1" side: 'left padx: "3m" pady: "3m")
(pack ".f2" side: 'right padx: "3m" pady: "3m")

(apply pack (append rbuttons '(in: ".f1" side: top anchor: w)))
(apply pack (append cbuttons '(in: ".f2" side: top anchor: w)))
