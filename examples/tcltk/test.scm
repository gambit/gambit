#!/usr/bin/env gsi-script

; File: "test.scm"

; Copyright (c) 1997-2007 by Marc Feeley, All Rights Reserved.

(include "tcltk#.scm") ; import Tcl/Tk procedures and variables

(define (my-widget container)
  (let* ((group (frame container
                       relief: 'ridge
                       borderwidth: 4
                       height: "50px"
                       width: "100px"))
         (lbl (label group
                     text: "red"
                     background: "red"))
         (b1 (button group
                     text: "red"
                     command: (make-setter lbl "red")))
         (b2 (button group
                     text: "green"
                     command: (make-setter lbl "green")))
         (b3 (button group
                     text: "blue"
                     command: (make-setter lbl "blue"))))
    (pack lbl b1 b2 b3)
    group))

(define (make-setter lbl color)
  (lambda ()
    (tcl lbl 'configure text: color)
    (tcl lbl 'configure background: color)))

(define (go container)
  (let* ((group (frame container))
         (w1 (my-widget group))
         (w2 (my-widget group))
         (q (button container text: "quit" command: exit)))
    (pack w1 side: 'left)
    (pack w2 side: 'left)
    (pack group q)))

(go root-window)
