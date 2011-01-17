#!/usr/bin/env gsi-script

;;; File: "bounce.scm"

;;; Copyright (c) 2005-2011 by Marc Feeley, All Rights Reserved.

;;; Create two windows and bounce many colored balls in them.

(##include "Xlib#.scm") ;; import Xlib procedures and variables

(define win-width   600)
(define win-height  401)
(define ball-width  25)
(define ball-height 25)
(define nb-balls    100)

(define-type ball
  id ;; identifier
  x  ;; x coordinate
  y  ;; y coordinate
  dx ;; speed on x axis
  dy ;; speed on y axis
  gc ;; graphic context
)

(define (iota n)
  (let loop ((i (- n 1)) (lst '()))
    (if (< i 0)
        lst
        (loop (- i 1) (cons i lst)))))

(define (create-balls x11-display screen window)
  (random-source-randomize! default-random-source)
  (map (lambda (id)
         (let* ((gc (XCreateGC x11-display window 0 #f))
                (v (make-XGCValues-box))
                (cmap (XDefaultColormapOfScreen screen))
                (c (make-XColor-box)))
           (XColor-red-set! c (random-integer 20000))
           (XColor-green-set! c (random-integer 20000))
           (XColor-blue-set! c (random-integer 20000))
           (if (= (XAllocColor x11-display cmap c) 1)
               (begin
                 (XGCValues-foreground-set! v (XColor-pixel c))
                 (XChangeGC x11-display
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
       
(define (draw-ball b x11-display window gc-text font)
  (let ((x (inexact->exact (floor (ball-x b))))
        (y (inexact->exact (floor (ball-y b))))
        (dx (ball-dx b))
        (dy (ball-dy b))
        (gc (ball-gc b))
        (ascent (XFontStruct-ascent font))
        (descent (XFontStruct-descent font)))

    (XFillArc
     x11-display
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
       x11-display
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

(define (make-gate name)
  (vector #f
          (make-mutex name)
          (make-condition-variable name)))

(define (gate-pulse gate)
  (let ((mut (vector-ref gate 1))
        (cv (vector-ref gate 2)))
    (mutex-lock! mut)
    (vector-set! gate 0 #t)
    (condition-variable-signal! cv)
    (mutex-unlock! mut)))

(define (gate-wait gate timeout)
  (let ((mut (vector-ref gate 1))
        (cv (vector-ref gate 2)))
    (let loop ()
      (if (mutex-lock! mut timeout)
          (if (vector-ref gate 0) ;; pulsed?
              (begin
                (vector-set! gate 0 #f)
                (mutex-unlock! mut)
                #t)
              (if (mutex-unlock! mut cv timeout)
                  (loop)
                  #f))
          #f))))

(define (make-x11-event-queue x11-display)
  (let* ((x11-display-fd
          (XConnectionNumber x11-display))
         (x11-display-port
          (##open-predefined 1 ;; (macro-direction-in)
                             '(X11-display)
                             x11-display-fd))
         (check-x11-connection-events
          (make-gate 'check-x11-connection-get))
         (get-x11-events
          (make-gate 'get-x11-events))
         (x11-connection-monitor-thread
          (make-thread
           (lambda ()
             (let loop ()

               ;; wait until we need to check for events from the connection
               (gate-wait check-x11-connection-events +inf.0)

               ;; wait until an event is available from the X11 connection
               (##device-port-wait-for-input! x11-display-port)

               ;; tell the event loop it should get events
               (gate-pulse get-x11-events)

               (loop))))))

    (thread-start! x11-connection-monitor-thread)

    (vector x11-display
            get-x11-events
            check-x11-connection-events
            x11-connection-monitor-thread)))

(define (x11-event-get x11-event-queue absrel-timeout)
  (let ((x11-display
         (vector-ref x11-event-queue 0))
        (get-x11-events
         (vector-ref x11-event-queue 1))
        (check-x11-connection-events
         (vector-ref x11-event-queue 2))
        (timeout
         (if (time? absrel-timeout)
             absrel-timeout
             (seconds->time
              (+ absrel-timeout
                 (time->seconds (current-time)))))))
    (let loop ()
      (or (XCheckMaskEvent x11-display -1)
          (begin
            (gate-pulse check-x11-connection-events)
            (if (gate-wait get-x11-events timeout)
                (loop)
                #f))))))

(define (main)
  (let* ((x11-display
          (XOpenDisplay #f))
         (screen-number
          (XDefaultScreen x11-display))
         (screen
          (XScreenOfDisplay x11-display screen-number))
         (root
          (XRootWindow x11-display screen-number))
         (black
          (XBlackPixel x11-display screen-number))
         (white
          (XWhitePixel x11-display screen-number))
         (x11-event-queue
          (make-x11-event-queue x11-display)))

    (define (create-window)
      (thread-start!
       (make-thread
        (lambda ()
          (let* ((window
                  (XCreateSimpleWindow
                   x11-display
                   root
                   100
                   200
                   win-width
                   win-height
                   10
                   black
                   white))
                 (font
                  (XLoadQueryFont x11-display
                                  "lucidasans-12"))
                 (gc-text
                  (XCreateGC x11-display window 0 #f)))

            (let* ((v (make-XGCValues-box))
                   (cmap (XDefaultColormapOfScreen screen))
                   (c (make-XColor-box))
                   (x (XParseColor x11-display
                                   cmap
                                   "yellow"
                                   c)))
              (if (and (= (XAllocColor x11-display cmap c) 1) (= x 1) font)
                  (begin
                    (XGCValues-foreground-set! v (XColor-pixel c))
                    (XGCValues-font-set! v (XFontStruct-fid font))
                    (XChangeGC x11-display
                               gc-text
                               (+ GCForeground GCFont)
                               v))))

            (XMapWindow x11-display window)
            (XFlush x11-display)

            (XSelectInput
             x11-display
             window
             (+ KeyPressMask
                KeyReleaseMask
                ButtonPressMask
                ButtonReleaseMask
                PointerMotionMask
                EnterWindowMask
                LeaveWindowMask))
            (XFlush x11-display)

            (let ((balls (create-balls x11-display screen window)))

              (let loop ((n 200))
                (if (> n 0)
                    (let ((start (current-time)))

                      (for-each
                       (lambda (b) (move-ball b 5))
                       balls)

                      (XClearWindow x11-display window)

                      (for-each
                       (lambda (b)
                         (draw-ball b x11-display window gc-text font))
                       balls)

                      (XFlush x11-display)

                      ;; slow down to about 30 frames per second

                      (let ((timeout
                             (seconds->time
                              (+ 1/30
                                 (time->seconds start)))))
                        (let event-loop ()
                          (let ((ev (x11-event-get x11-event-queue timeout)))
                            (if ev
                                (begin
                                  (pp (convert-XEvent ev))
                                  (event-loop))))))

                      (loop (- n 1)))))

              (for-each
               (lambda (b) (XFreeGC x11-display (ball-gc b)))
               balls)

              (XFreeGC x11-display gc-text)))))))

    (for-each
     thread-join!
     (list (create-window)
           (create-window)))

    ;; Can't close display because closing the connection
    ;; causes the (##device-port-wait-for-input! x11-display-port)
    ;; to raise an os-exception (closed file descriptor).
    ;;
    ;; (XCloseDisplay x11-display)
    )

  (##gc)

  ;; For checking memory leaks on Mac OS X:
  #;
  (begin
    (shell-command (string-append "leaks " (number->string (##os-getpid))))
    (thread-sleep! 3))
)
