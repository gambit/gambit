#!/usr/bin/env gsi-script

; File: "bounce.scm"

; Copyright (c) 2005-2007 by Marc Feeley, All Rights Reserved.

; Create two windows and bounce many colored balls in them.

(##include "Xlib#.scm") ; import Xlib procedures and variables

(define win-width   300)
(define win-height  201)
(define ball-width  25)
(define ball-height 25)
(define nb-balls    20)

(define-type ball
  id ; identifier
  x  ; x coordinate
  y  ; y coordinate
  dx ; speed on x axis
  dy ; speed on y axis
  gc ; graphic context
)

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (< i 0)
        lst
        (loop (- i 1) (cons i lst)))))

(define (create-balls display screen window)
  (random-source-randomize! default-random-source)
  (map (lambda (id)
         (let* ((gc (XCreateGC display window 0 #f))
                (v (make-XGCValues-box))
                (cmap (XDefaultColormapOfScreen screen))
                (c (make-XColor-box)))
           (XColor-red-set! c (random-integer 20000))
           (XColor-green-set! c (random-integer 20000))
           (XColor-blue-set! c (random-integer 20000))
           (if (= (XAllocColor display cmap c) 1)
               (begin
                 (XGCValues-foreground-set! v (XColor-pixel c))
                 (XChangeGC display
                            gc
                            GCForeground
                            v)))
           (make-ball id
                      (* (random-real) (- win-width ball-width))
                      (* (random-real) (- win-height ball-height))
                      (- (* (random-real) 2.0) 1.0)
                      (- (* (random-real) 2.0) 1.0)
                      gc)))
       (iota nb-balls)))
       
(define (draw-ball b display window gc-text font)
  (let ((x (inexact->exact (floor (ball-x b))))
        (y (inexact->exact (floor (ball-y b))))
        (dx (ball-dx b))
        (dy (ball-dy b))
        (gc (ball-gc b))
        (ascent (XFontStruct-ascent font))
        (descent (XFontStruct-descent font)))

    (XFillArc
     display
     window
     gc
     x
     y
     ball-width
     ball-height
     (* 64 0)
     (* 64 360))

    (let* ((str (number->string (ball-id b)))
           (n (string-length str))
           (w (XTextWidth font str n)))
      (XDrawString
       display
       window
       gc-text
       (+ x (quotient (- ball-width w) 2))
       (+ y (quotient (+ ball-height ascent) 2))
       str
       n))))

(define (move-ball b steps)
  (let loop ((n steps)
             (x (ball-x b))
             (y (ball-y b))
             (dx (ball-dx b))
             (dy (ball-dy b)))
    (if (> n 0)
        (let ((new-dx
               (if (or (< (+ x dx) 0)
                       (>= (+ x dx) (- win-width ball-width)))
                   (- dx)
                   dx))
              (new-dy
               (if (or (< (+ y dy) 0)
                       (>= (+ y dy) (- win-height ball-height)))
                   (- dy)
                   dy)))
          (loop (- n 1)
                (+ x new-dx)
                (+ y new-dy)
                new-dx
                new-dy))
        (begin
          (ball-x-set! b x)
          (ball-y-set! b y)
          (ball-dx-set! b dx)
          (ball-dy-set! b dy)))))

(define (main)
  (let* ((display
          (XOpenDisplay #f))
         (screen-number
          (XDefaultScreen display))
         (screen
          (XScreenOfDisplay display screen-number))
         (root
          (XRootWindow display screen-number))
         (black
          (XBlackPixel display screen-number))
         (white
          (XWhitePixel display screen-number)))

    (define (create-window)
      (thread-start!
       (make-thread
        (lambda ()
          (let* ((window
                  (XCreateSimpleWindow
                   display
                   root
                   100
                   200
                   win-width
                   win-height
                   10
                   black
                   white))
                 (font
                  (XLoadQueryFont display
                                  "lucidasans-12"))
                 (gc-text
                  (XCreateGC display window 0 #f)))

            (let* ((v (make-XGCValues-box))
                   (cmap (XDefaultColormapOfScreen screen))
                   (c (make-XColor-box))
                   (x (XParseColor display
                                   cmap
                                   "yellow"
                                   c)))
              (if (and (= (XAllocColor display cmap c) 1) (= x 1) font)
                  (begin
                    (XGCValues-foreground-set! v (XColor-pixel c))
                    (XGCValues-font-set! v (XFontStruct-fid font))
                    (XChangeGC display
                               gc-text
                               (+ GCForeground GCFont)
                               v))))

            (XMapWindow display window)
            (XFlush display)

            (XSelectInput
             display
             window
             (+ KeyPressMask
                KeyReleaseMask
                ButtonPressMask
                ButtonReleaseMask
                PointerMotionMask
                EnterWindowMask
                LeaveWindowMask))

            (let ((balls (create-balls display screen window)))
              (let loop ((n 200))
                (if (> n 0)
                    (begin

                      (let ((ev (XCheckMaskEvent display -1)))
                        (if ev
                            (pp (convert-XEvent ev))))

                      (for-each
                       (lambda (b) (move-ball b 5))
                       balls)

                      (XClearWindow display window)

                      (for-each
                       (lambda (b)
                         (draw-ball b display window gc-text font))
                       balls)

                      (XFlush display)

                      (thread-sleep! 1/30) ; slow down to about 30 frames per second

                      (loop (- n 1)))))))))))

    (for-each
     thread-join!
     (list (create-window)
           (create-window)))))
