;==============================================================================

; File: "Xlib.scm", Time-stamp: <2008-11-24 16:18:52 feeley>

; Copyright (c) 2006-2008 by Marc Feeley, All Rights Reserved.

; A simple interface to the X-window Xlib library.

; Note: This interface to Xlib is still in development.  There are
;       still memory leaks in the interface.

;==============================================================================

(##namespace ("Xlib#"))

(##include "~~/lib/gambit#.scm")

(##include "Xlib#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe)
)

;==============================================================================

(c-declare #<<end-of-c-declare

#include <X11/Xlib.h>
#include <X11/Xutil.h>

end-of-c-declare
)

; Declare a few types so that the function prototypes use the same
; type names as a C program.

(c-define-type Time unsigned-long)
(c-define-type XID unsigned-long)

(c-define-type Window XID)
(c-define-type Drawable XID)
(c-define-type Font XID)
(c-define-type Pixmap XID)
(c-define-type Cursor XID)
(c-define-type Colormap XID)
(c-define-type GContext XID)
(c-define-type KeySym XID)

(c-define-type Bool int)
(c-define-type Status int)
(c-define-type GC (pointer (struct "_XGC")))
(c-define-type Visual "Visual")
(c-define-type Visual* (pointer Visual))
(c-define-type Display "Display")
(c-define-type Display* (pointer Display))
(c-define-type Screen "Screen")
(c-define-type Screen* (pointer Screen))
(c-define-type XGCValues "XGCValues")
(c-define-type XGCValues* (pointer XGCValues))
(c-define-type XFontStruct "XFontStruct")
(c-define-type XFontStruct* (pointer XFontStruct))
(c-define-type XColor "XColor")
(c-define-type XColor* (pointer XColor))
(c-define-type XEvent "XEvent")
(c-define-type XEvent* (pointer XEvent))

(c-define-type char* char-string)

; Function prototypes for a minimal subset of Xlib functions.  The
; functions have the same name in Scheme and C.

(define XOpenDisplay
  (c-lambda (char*)        ; display_name
            Display*
            "XOpenDisplay"))

(define XCloseDisplay
  (c-lambda (Display*)     ; display
            int
            "XCloseDisplay"))

(define XDefaultScreen
  (c-lambda (Display*)     ; display
            int
            "XDefaultScreen"))

(define XScreenOfDisplay
  (c-lambda (Display*      ; display
             int)          ; screen_number
            Screen*
            "XScreenOfDisplay"))

(define XDefaultColormapOfScreen
  (c-lambda (Screen*)      ; screen
            Colormap
            "XDefaultColormapOfScreen"))

(define XClearWindow
  (c-lambda (Display*      ; display
             Window)       ; w
            int
            "XClearWindow"))

(define XConnectionNumber
  (c-lambda (Display*)     ; display
            int
            "XConnectionNumber"))

(define XRootWindow
  (c-lambda (Display*      ; display
             int)          ; screen_number
            Window
            "XRootWindow"))

(define XDefaultRootWindow
  (c-lambda (Display*)     ; display
            Window
            "XDefaultRootWindow"))

(define XRootWindowOfScreen
  (c-lambda (Screen*)      ; screen
            Window
            "XRootWindowOfScreen"))

(define XDefaultVisual
  (c-lambda (Display*      ; display
             int)          ; screen_number
            Visual*
            "XDefaultVisual"))

(define XDefaultVisualOfScreen
  (c-lambda (Screen*)      ; screen
            Visual*
            "XDefaultVisualOfScreen"))

(define XDefaultGC
  (c-lambda (Display*      ; display
             int)          ; screen_number
            GC
            "XDefaultGC"))

(define XDefaultGCOfScreen
  (c-lambda (Screen*)      ; screen
            GC
            "XDefaultGCOfScreen"))

(define XBlackPixel
  (c-lambda (Display*       ; display
             int)           ; screen_number
            unsigned-long
            "XBlackPixel"))

(define XWhitePixel
  (c-lambda (Display*       ; display
             int)           ; screen_number
            unsigned-long
            "XWhitePixel"))

(define XCreateSimpleWindow
  (c-lambda (Display*       ; display
             Window         ; parent
             int            ; x
             int            ; y
             unsigned-int   ; width
             unsigned-int   ; height
             unsigned-int   ; border_width
             unsigned-long  ; border
             unsigned-long) ; backgound
            Window
            "XCreateSimpleWindow"))

(define XMapWindow
  (c-lambda (Display*       ; display
             Window)        ; w
            int
            "XMapWindow"))

(define XFlush
  (c-lambda (Display*)      ; display
            int
            "XFlush"))

(define XCreateGC
  (c-lambda (Display*       ; display
             Drawable       ; d
             unsigned-long  ; valuemask
             XGCValues*)    ; values
            GC
            "XCreateGC"))

(define XFillRectangle
  (c-lambda (Display*      ; display
             Drawable      ; d
             GC            ; gc
             int           ; x
             int           ; y
             unsigned-int  ; width
             unsigned-int) ; height
            int
            "XFillRectangle"))

(define XFillArc
  (c-lambda (Display*      ; display
             Drawable      ; d
             GC            ; gc
             int           ; x
             int           ; y
             unsigned-int  ; width
             unsigned-int  ; height
             int           ; angle1
             int)          ; angle2
            int
            "XFillArc"))

(define XDrawString
  (c-lambda (Display*      ; display
             Drawable      ; d
             GC            ; gc
             int           ; x
             int           ; y
             char*         ; string
             int)          ; length
            int
            "XDrawString"))

(define XTextWidth
  (c-lambda (XFontStruct*  ; font_struct
             char*         ; string
             int)          ; count
            int
            "XTextWidth"))

(define XParseColor
  (c-lambda (Display*      ; display
             Colormap      ; colormap
             char*         ; spec
             XColor*)      ; exact_def_return
            Status
            "XParseColor"))

(define XAllocColor
  (c-lambda (Display*      ; display
             Colormap      ; colormap
             XColor*)      ; screen_in_out
            Status
            "XAllocColor"))

(define (make-XColor-box)
  ((c-lambda ()
             XColor*
             "___result_voidstar = ___EXT(___alloc_mem) (sizeof (XColor));")))

(define XColor-pixel
  (c-lambda (XColor*)       ; XColor box
             unsigned-long
            "___result = ___arg1->pixel;"))

(define XColor-pixel-set!
  (c-lambda (XColor*        ; XColor box
             unsigned-long) ; intensity
            void
            "___arg1->pixel = ___arg2;"))

(define XColor-red
  (c-lambda (XColor*)       ; XColor box
             unsigned-short
            "___result = ___arg1->red;"))

(define XColor-red-set!
  (c-lambda (XColor*        ; XColor box
             unsigned-short); intensity
            void
            "___arg1->red = ___arg2;"))

(define XColor-green
  (c-lambda (XColor*)       ; XColor box
             unsigned-short
            "___result = ___arg1->green;"))

(define XColor-green-set!
  (c-lambda (XColor*        ; XColor box
             unsigned-short); intensity
            void
            "___arg1->green = ___arg2;"))

(define XColor-blue
  (c-lambda (XColor*)       ; XColor box
             unsigned-short
            "___result = ___arg1->blue;"))

(define XColor-blue-set!
  (c-lambda (XColor*        ; XColor box
             unsigned-short); intensity
            void
            "___arg1->blue = ___arg2;"))

(define (make-XGCValues-box)
  ((c-lambda ()
             XGCValues*
             "___result_voidstar = ___EXT(___alloc_mem) (sizeof (XGCValues));")))

(define XGCValues-foreground
  (c-lambda (XGCValues*)    ; XGCValues box
            unsigned-long
            "return ___arg1->foreground;"))

(define XGCValues-foreground-set!
  (c-lambda (XGCValues*     ; XGCValues box
             unsigned-long) ; pixel index
            void
            "___arg1->foreground = ___arg2;"))

(define XGCValues-background
  (c-lambda (XGCValues*)    ; XGCValues box
            unsigned-long
            "return ___arg1->background;"))

(define XGCValues-background-set!
  (c-lambda (XGCValues*     ; XGCValues box
             unsigned-long) ; pixel index
            void
            "___arg1->background = ___arg2;"))

(define XGCValues-font
  (c-lambda (XGCValues*)    ; XGCValues box
            Font
            "return ___arg1->font;"))

(define XGCValues-font-set!
  (c-lambda (XGCValues*     ; XGCValues box
             Font)          ; font_ID
            void
            "___arg1->font = ___arg2;"))

(define GCFunction
  ((c-lambda () unsigned-long "___result = GCFunction;")))

(define GCPlaneMask
  ((c-lambda () unsigned-long "___result = GCPlaneMask;")))

(define GCForeground
  ((c-lambda () unsigned-long "___result = GCForeground;")))

(define GCBackground
  ((c-lambda () unsigned-long "___result = GCBackground;")))

(define GCLineWidth
  ((c-lambda () unsigned-long "___result = GCLineWidth;")))

(define GCLineStyle
  ((c-lambda () unsigned-long "___result = GCLineStyle;")))

(define GCCapStyle
  ((c-lambda () unsigned-long "___result = GCCapStyle;")))

(define GCJoinStyle
  ((c-lambda () unsigned-long "___result = GCJoinStyle;")))

(define GCFillStyle
  ((c-lambda () unsigned-long "___result = GCFillStyle;")))

(define GCFillRule
  ((c-lambda () unsigned-long "___result = GCFillRule;")))

(define GCTile
  ((c-lambda () unsigned-long "___result = GCTile;")))

(define GCStipple
  ((c-lambda () unsigned-long "___result = GCStipple;")))

(define GCTileStipXOrigin
  ((c-lambda () unsigned-long "___result = GCTileStipXOrigin;")))

(define GCTileStipYOrigin
  ((c-lambda () unsigned-long "___result = GCTileStipYOrigin;")))

(define GCFont
  ((c-lambda () unsigned-long "___result = GCFont;")))

(define GCSubwindowMode
  ((c-lambda () unsigned-long "___result = GCSubwindowMode;")))

(define GCGraphicsExposures
  ((c-lambda () unsigned-long "___result = GCGraphicsExposures;")))

(define GCClipXOrigin
  ((c-lambda () unsigned-long "___result = GCClipXOrigin;")))

(define GCClipYOrigin
  ((c-lambda () unsigned-long "___result = GCClipYOrigin;")))

(define GCClipMask
  ((c-lambda () unsigned-long "___result = GCClipMask;")))

(define GCDashOffset
  ((c-lambda () unsigned-long "___result = GCDashOffset;")))

(define GCDashList
  ((c-lambda () unsigned-long "___result = GCDashList;")))

(define GCArcMode
  ((c-lambda () unsigned-long "___result = GCArcMode;")))

(define XChangeGC
  (c-lambda (Display*       ; display
             GC             ; gc
             unsigned-long  ; valuemask
             XGCValues*)    ; values
            int
            "XChangeGC"))

(define XGetGCValues
  (c-lambda (Display*       ; display
             GC             ; gc
             unsigned-long  ; valuemask
             XGCValues*)    ; values_return
            int
            "XGetGCValues"))

(define XQueryFont
  (c-lambda (Display*       ; display
             Font)          ; font_ID
            XFontStruct*
            "XQueryFont"))

(define XLoadFont
  (c-lambda (Display*       ; display
             char*)         ; name
            Font
            "XLoadFont"))

(define XLoadQueryFont
  (c-lambda (Display*       ; display
             char*)         ; name
            XFontStruct*
            "XLoadQueryFont"))

(define XFontStruct-fid
  (c-lambda (XFontStruct*)  ; font_struct
            Font
            "___result = ___arg1->fid;"))

(define XFontStruct-ascent
  (c-lambda (XFontStruct*)  ; font_struct
            int
            "___result = ___arg1->ascent;"))

(define XFontStruct-descent
  (c-lambda (XFontStruct*)  ; font_struct
            int
            "___result = ___arg1->descent;"))

(define NoEventMask
  ((c-lambda () long "___result = NoEventMask;")))

(define KeyPressMask
  ((c-lambda () long "___result = KeyPressMask;")))

(define KeyReleaseMask
  ((c-lambda () long "___result = KeyReleaseMask;")))

(define ButtonPressMask
  ((c-lambda () long "___result = ButtonPressMask;")))

(define ButtonReleaseMask
  ((c-lambda () long "___result = ButtonReleaseMask;")))

(define EnterWindowMask
  ((c-lambda () long "___result = EnterWindowMask;")))

(define LeaveWindowMask
  ((c-lambda () long "___result = LeaveWindowMask;")))

(define PointerMotionMask
  ((c-lambda () long "___result = PointerMotionMask;")))

(define PointerMotionHintMask
  ((c-lambda () long "___result = PointerMotionHintMask;")))

(define Button1MotionMask
  ((c-lambda () long "___result = Button1MotionMask;")))

(define Button2MotionMask
  ((c-lambda () long "___result = Button2MotionMask;")))

(define Button3MotionMask
  ((c-lambda () long "___result = Button3MotionMask;")))

(define Button4MotionMask
  ((c-lambda () long "___result = Button4MotionMask;")))

(define Button5MotionMask
  ((c-lambda () long "___result = Button5MotionMask;")))

(define ButtonMotionMask
  ((c-lambda () long "___result = ButtonMotionMask;")))

(define KeymapStateMask
  ((c-lambda () long "___result = KeymapStateMask;")))

(define ExposureMask
  ((c-lambda () long "___result = ExposureMask;")))

(define VisibilityChangeMask
  ((c-lambda () long "___result = VisibilityChangeMask;")))

(define StructureNotifyMask
  ((c-lambda () long "___result = StructureNotifyMask;")))

(define ResizeRedirectMask
  ((c-lambda () long "___result = ResizeRedirectMask;")))

(define SubstructureNotifyMask
  ((c-lambda () long "___result = SubstructureNotifyMask;")))

(define SubstructureRedirectMask
  ((c-lambda () long "___result = SubstructureRedirectMask;")))

(define FocusChangeMask
  ((c-lambda () long "___result = FocusChangeMask;")))

(define PropertyChangeMask
  ((c-lambda () long "___result = PropertyChangeMask;")))

(define ColormapChangeMask
  ((c-lambda () long "___result = ColormapChangeMask;")))

(define OwnerGrabButtonMask
  ((c-lambda () long "___result = OwnerGrabButtonMask;")))

(define KeyPress
  ((c-lambda () long "___result = KeyPress;")))

(define KeyRelease
  ((c-lambda () long "___result = KeyRelease;")))

(define ButtonPress
  ((c-lambda () long "___result = ButtonPress;")))

(define ButtonRelease
  ((c-lambda () long "___result = ButtonRelease;")))

(define MotionNotify
  ((c-lambda () long "___result = MotionNotify;")))

(define EnterNotify
  ((c-lambda () long "___result = EnterNotify;")))

(define LeaveNotify
  ((c-lambda () long "___result = LeaveNotify;")))

(define FocusIn
  ((c-lambda () long "___result = FocusIn;")))

(define FocusOut
  ((c-lambda () long "___result = FocusOut;")))

(define KeymapNotify
  ((c-lambda () long "___result = KeymapNotify;")))

(define Expose
  ((c-lambda () long "___result = Expose;")))

(define GraphicsExpose
  ((c-lambda () long "___result = GraphicsExpose;")))

(define NoExpose
  ((c-lambda () long "___result = NoExpose;")))

(define VisibilityNotify
  ((c-lambda () long "___result = VisibilityNotify;")))

(define CreateNotify
  ((c-lambda () long "___result = CreateNotify;")))

(define DestroyNotify
  ((c-lambda () long "___result = DestroyNotify;")))

(define UnmapNotify
  ((c-lambda () long "___result = UnmapNotify;")))

(define MapNotify
  ((c-lambda () long "___result = MapNotify;")))

(define MapRequest
  ((c-lambda () long "___result = MapRequest;")))

(define ReparentNotify
  ((c-lambda () long "___result = ReparentNotify;")))

(define ConfigureNotify
  ((c-lambda () long "___result = ConfigureNotify;")))

(define ConfigureRequest
  ((c-lambda () long "___result = ConfigureRequest;")))

(define GravityNotify
  ((c-lambda () long "___result = GravityNotify;")))

(define ResizeRequest
  ((c-lambda () long "___result = ResizeRequest;")))

(define CirculateNotify
  ((c-lambda () long "___result = CirculateNotify;")))

(define CirculateRequest
  ((c-lambda () long "___result = CirculateRequest;")))

(define PropertyNotify
  ((c-lambda () long "___result = PropertyNotify;")))

(define SelectionClear
  ((c-lambda () long "___result = SelectionClear;")))

(define SelectionRequest
  ((c-lambda () long "___result = SelectionRequest;")))

(define SelectionNotify
  ((c-lambda () long "___result = SelectionNotify;")))

(define ColormapNotify
  ((c-lambda () long "___result = ColormapNotify;")))

(define ClientMessage
  ((c-lambda () long "___result = ClientMessage;")))

(define MappingNotify
  ((c-lambda () long "___result = MappingNotify;")))

(define XCheckMaskEvent
  (c-lambda (Display*       ; display
             long)          ; event_mask
            XEvent*
            "
            XEvent ev;
            XEvent* pev;
            if (XCheckMaskEvent (___arg1, ___arg2, &ev))
              {
                pev = ___CAST(XEvent*,___EXT(___alloc_mem (sizeof (ev))));
                *pev = ev;
              }
            else
              pev = 0;
            ___result_voidstar = pev;
            "))

(define XSelectInput
  (c-lambda (Display*       ; display
             Window         ; w
             long)          ; event_mask
            int
            "XSelectInput"))

(define XAnyEvent-type
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->type;"))

(define XAnyEvent-serial
  (c-lambda (XEvent*)       ; XEvent box
            unsigned-long
            "___result = ___arg1->xany.serial;"))

(define XAnyEvent-send-event
  (c-lambda (XEvent*)       ; XEvent box
            bool
            "___result = ___arg1->xany.send_event;"))

(define XAnyEvent-display
  (c-lambda (XEvent*)       ; XEvent box
            Display*
            "___result_voidstar = ___arg1->xany.display;"))

(define XAnyEvent-window
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xany.window;"))

(define XKeyEvent-root
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xkey.root;"))

(define XKeyEvent-subwindow
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xkey.subwindow;"))

(define XKeyEvent-time
  (c-lambda (XEvent*)       ; XEvent box
            Time
            "___result = ___arg1->xkey.time;"))

(define XKeyEvent-x
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xkey.x;"))

(define XKeyEvent-y
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xkey.y;"))

(define XKeyEvent-x-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xkey.x_root;"))

(define XKeyEvent-y-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xkey.y_root;"))

(define XKeyEvent-state
  (c-lambda (XEvent*)       ; XEvent box
            unsigned-int
            "___result = ___arg1->xkey.state;"))

(define XKeyEvent-keycode
  (c-lambda (XEvent*)       ; XEvent box
            unsigned-int
            "___result = ___arg1->xkey.keycode;"))

(define XKeyEvent-same-screen
  (c-lambda (XEvent*)       ; XEvent box
            bool
            "___result = ___arg1->xkey.same_screen;"))

(define XButtonEvent-root
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xbutton.root;"))

(define XButtonEvent-subwindow
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xbutton.subwindow;"))

(define XButtonEvent-time
  (c-lambda (XEvent*)       ; XEvent box
            Time
            "___result = ___arg1->xbutton.time;"))

(define XButtonEvent-x
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xbutton.x;"))

(define XButtonEvent-y
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xbutton.y;"))

(define XButtonEvent-x-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xbutton.x_root;"))

(define XButtonEvent-y-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xbutton.y_root;"))

(define XButtonEvent-state
  (c-lambda (XEvent*)       ; XEvent box
            unsigned-int
            "___result = ___arg1->xbutton.state;"))

(define XButtonEvent-button
  (c-lambda (XEvent*)       ; XEvent box
            unsigned-int
            "___result = ___arg1->xbutton.button;"))

(define XButtonEvent-same-screen
  (c-lambda (XEvent*)       ; XEvent box
            bool
            "___result = ___arg1->xbutton.same_screen;"))

(define XMotionEvent-root
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xmotion.root;"))

(define XMotionEvent-subwindow
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xmotion.subwindow;"))

(define XMotionEvent-time
  (c-lambda (XEvent*)       ; XEvent box
            Time
            "___result = ___arg1->xmotion.time;"))

(define XMotionEvent-x
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xmotion.x;"))

(define XMotionEvent-y
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xmotion.y;"))

(define XMotionEvent-x-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xmotion.x_root;"))

(define XMotionEvent-y-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xmotion.y_root;"))

(define XMotionEvent-state
  (c-lambda (XEvent*)       ; XEvent box
            unsigned-int
            "___result = ___arg1->xmotion.state;"))

(define XMotionEvent-is-hint
  (c-lambda (XEvent*)       ; XEvent box
            char
            "___result = ___arg1->xmotion.is_hint;"))

(define XMotionEvent-same-screen
  (c-lambda (XEvent*)       ; XEvent box
            bool
            "___result = ___arg1->xmotion.same_screen;"))

(define XCrossingEvent-root
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xcrossing.root;"))

(define XCrossingEvent-subwindow
  (c-lambda (XEvent*)       ; XEvent box
            Window
            "___result = ___arg1->xcrossing.subwindow;"))

(define XCrossingEvent-time
  (c-lambda (XEvent*)       ; XEvent box
            Time
            "___result = ___arg1->xcrossing.time;"))

(define XCrossingEvent-x
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xcrossing.x;"))

(define XCrossingEvent-y
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xcrossing.y;"))

(define XCrossingEvent-x-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xcrossing.x_root;"))

(define XCrossingEvent-y-root
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xcrossing.y_root;"))

(define XCrossingEvent-mode
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xcrossing.mode;"))

(define XCrossingEvent-detail
  (c-lambda (XEvent*)       ; XEvent box
            int
            "___result = ___arg1->xcrossing.detail;"))

(define XCrossingEvent-same-screen
  (c-lambda (XEvent*)       ; XEvent box
            bool
            "___result = ___arg1->xcrossing.same_screen;"))

(define XCrossingEvent-focus
  (c-lambda (XEvent*)       ; XEvent box
            bool
            "___result = ___arg1->xcrossing.focus;"))

(define XCrossingEvent-state
  (c-lambda (XEvent*)       ; XEvent box
            unsigned-int
            "___result = ___arg1->xcrossing.state;"))

(define XLookupString
  (c-lambda (XEvent*)      ; event_struct (XKeyEvent)
            KeySym
            "
            char buf[10];
            KeySym ks;
            XComposeStatus cs;
            int n = XLookupString (___CAST(XKeyEvent*,___arg1),
                                   buf,
                                   sizeof (buf),
                                   &ks,
                                   &cs);
            ___result = ks;
            "))

(define (convert-XEvent ev)
  (and ev
       (let ((type (XAnyEvent-type ev)))
         (cond ((or (##fixnum.= type KeyPress)
                    (##fixnum.= type KeyRelease))
                (##list
                 (if (##fixnum.= type KeyPress)
                     'XKeyPressedEvent
                     'XKeyReleasedEvent)
                 type
                 (XAnyEvent-serial ev)
                 (XAnyEvent-send-event ev)
                 (XAnyEvent-display ev)
                 (XAnyEvent-window ev)
                 (XKeyEvent-root ev)
                 (XKeyEvent-subwindow ev)
                 (XKeyEvent-time ev)
                 (XKeyEvent-x ev)
                 (XKeyEvent-y ev)
                 (XKeyEvent-x-root ev)
                 (XKeyEvent-y-root ev)
                 (XKeyEvent-state ev)
                 (XKeyEvent-keycode ev)
                 (XKeyEvent-same-screen ev)
                 (XLookupString ev)))
               ((or (##fixnum.= type ButtonPress)
                    (##fixnum.= type ButtonRelease))
                (##list
                 (if (##fixnum.= type ButtonPress)
                     'XButtonPressedEvent
                     'XButtonReleasedEvent)
                 type
                 (XAnyEvent-serial ev)
                 (XAnyEvent-send-event ev)
                 (XAnyEvent-display ev)
                 (XAnyEvent-window ev)
                 (XButtonEvent-root ev)
                 (XButtonEvent-subwindow ev)
                 (XButtonEvent-time ev)
                 (XButtonEvent-x ev)
                 (XButtonEvent-y ev)
                 (XButtonEvent-x-root ev)
                 (XButtonEvent-y-root ev)
                 (XButtonEvent-state ev)
                 (XButtonEvent-button ev)
                 (XButtonEvent-same-screen ev)))
               ((##fixnum.= type MotionNotify)
                (##list
                 'XPointerMovedEvent
                 type
                 (XAnyEvent-serial ev)
                 (XAnyEvent-send-event ev)
                 (XAnyEvent-display ev)
                 (XAnyEvent-window ev)
                 (XMotionEvent-root ev)
                 (XMotionEvent-subwindow ev)
                 (XMotionEvent-time ev)
                 (XMotionEvent-x ev)
                 (XMotionEvent-y ev)
                 (XMotionEvent-x-root ev)
                 (XMotionEvent-y-root ev)
                 (XMotionEvent-state ev)
                 (XMotionEvent-is-hint ev)
                 (XMotionEvent-same-screen ev)))
               ((or (##fixnum.= type EnterNotify)
                    (##fixnum.= type LeaveNotify))
                (##list
                 (if (##fixnum.= type EnterNotify)
                     'XEnterWindowEvent
                     'XLeaveWindowEvent)
                 type
                 (XAnyEvent-serial ev)
                 (XAnyEvent-send-event ev)
                 (XAnyEvent-display ev)
                 (XAnyEvent-window ev)
                 (XCrossingEvent-root ev)
                 (XCrossingEvent-subwindow ev)
                 (XCrossingEvent-time ev)
                 (XCrossingEvent-x ev)
                 (XCrossingEvent-y ev)
                 (XCrossingEvent-x-root ev)
                 (XCrossingEvent-y-root ev)
                 (XCrossingEvent-mode ev)
                 (XCrossingEvent-detail ev)
                 (XCrossingEvent-same-screen ev)
                 (XCrossingEvent-focus ev)
                 (XCrossingEvent-state ev)))
               (else
                #f)))))

;==============================================================================
