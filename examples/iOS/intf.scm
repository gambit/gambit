;;;============================================================================

;;; File: "intf.scm"

;;; Copyright (c) 2011-2012 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##namespace ("intf#"))

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")

(##include "intf#.scm")
(##include "url#.scm")

(declare
 (standard-bindings)
 (extended-bindings)
 (block)
 (fixnum)
 ;;(not safe)
)


;;;============================================================================

;; Interface with Objective-C.

(c-declare #<<c-declare-end

#include <objc/objc.h>

const char *class_getName(Class cls);
id objc_getClass(const char *name);
id objc_msgSend(id self, SEL op, ...);

id retain_id(id x)
{
  if (x != nil)
    [x retain];
  return x;
}

___SCMOBJ release_id(void *ptr)
{
  id x = ___CAST(id,ptr);
  if (x != nil)
    [x release];
  return ___FIX(___NO_ERR);
}

Class retain_Class(Class x)
{
  if (x != nil)
    [x retain];
  return x;
}

___SCMOBJ release_Class(void *ptr)
{
  Class x = ___CAST(Class,ptr);
  if (x != nil)
    [x release];
  return ___FIX(___NO_ERR);
}

c-declare-end
)

(c-define-type id (pointer (struct "objc_object") (id Class) "release_id"))
(c-define-type Class (pointer (struct "objc_class") (Class id) "release_Class"))
(c-define-type SEL (pointer (struct "objc_selector") (SEL)))

(define string->Class
  (c-lambda (nonnull-char-string) Class
    "___result = retain_Class(objc_getClass(___arg1));"))

(define Class->string
  (c-lambda (Class) nonnull-char-string
    "___result = ___CAST(char*,class_getName(___arg1));")) ;;;TODO: remove cast

(define string->SEL
  (c-lambda (nonnull-UTF-8-string) SEL
    "___result = sel_registerName(___arg1);"))

(define SEL->string
  (c-lambda (SEL) nonnull-UTF-8-string
    "___result = ___CAST(char*,sel_getName(___arg1));")) ;;;TODO: remove cast

;; Message sending (with 0, 1 and 2 parameters).

(define send0
  (c-lambda (id SEL) id
    "___result = retain_id(___CAST(id (*)(id, SEL),objc_msgSend)(___arg1, ___arg2));"))

(define send1
  (c-lambda (id SEL id) id
    "___result = retain_id(___CAST(id (*)(id, SEL, id),objc_msgSend)(___arg1, ___arg2, ___arg3));"))

(define send2
  (c-lambda (id SEL id id) id
    "___result = retain_id(___CAST(id (*)(id, SEL, id, id),objc_msgSend)(___arg1, ___arg2, ___arg3, ___arg4));"))

;; Type conversions.

(define id->string
  (c-lambda (id) nonnull-UTF-8-string
    "___result = ___CAST(char*,[___CAST(NSString*,___arg1) UTF8String]);")) ;;;TODO: remove cast

(define string->id
  (c-lambda (nonnull-UTF-8-string) id
    "___result = retain_id([NSString stringWithUTF8String: ___arg1]);"))

(define id->bool
  (c-lambda (id) bool
    "___result = [___CAST(NSNumber*,___arg1) boolValue];"))

(define bool->id
  (c-lambda (bool) id
    "___result = retain_id([NSNumber numberWithBool:___arg1]);"))

(define id->int
  (c-lambda (id) int
    "___result = [___CAST(NSNumber*,___arg1) intValue];"))

(define int->id
  (c-lambda (int) id
    "___result = retain_id([NSNumber numberWithInt:___arg1]);"))

(define id->float
  (c-lambda (id) float
    "___result = [___CAST(NSNumber*,___arg1) floatValue];"))

(define float->id
  (c-lambda (float) id
    "___result = retain_id([NSNumber numberWithFloat:___arg1]);"))

(define id->double
  (c-lambda (id) double
    "___result = [___CAST(NSNumber*,___arg1) doubleValue];"))

(define double->id
  (c-lambda (double) id
    "___result = retain_id([NSNumber numberWithDouble:___arg1]);"))

;;;----------------------------------------------------------------------------

;; Implement conversions between NSString* and Scheme strings.

(c-declare #<<c-declare-end

#include <Foundation/NSString.h>

___SCMOBJ SCMOBJ_to_NSStringSTAR(___SCMOBJ src, NSString **dst, int arg_num)
{
  /*
   * Convert a Scheme string to NSString* .
   */

  NSString *result;
  ___SCMOBJ ___temp;

  if (src == ___FAL)
    result = nil;
  else if (!___STRINGP(src))
    return ___FIX(___STOC_WCHARSTRING_ERR+arg_num);
  else
    {
      int i;
      int len = ___INT(___STRINGLENGTH(src));
      unichar *buf = ___alloc_mem(sizeof(unichar)*len);

      if (buf == 0)
        return ___FIX(___STOC_HEAP_OVERFLOW_ERR+arg_num);

      for (i=0; i<len; i++)
        {
          ___UCS_4 c = ___INT(___STRINGREF(src,___FIX(i)));
          buf[i] = c;
        }

      result = retain_id([NSString stringWithCharacters:buf length:len]);

      ___free_mem(buf);
    }

  *dst = result;

  return ___FIX(___NO_ERR);
}

___SCMOBJ NSStringSTAR_to_SCMOBJ(NSString *src, ___SCMOBJ *dst, int arg_num)
{
  ___SCMOBJ result;

  if (src == nil)
    result = ___FAL;
  else
    {
      int i;
      int len = [src length];

      result = ___alloc_scmobj(___sSTRING, len<<___LCS, ___STILL);

      if (___FIXNUMP(result))
        return ___FIX(___CTOS_HEAP_OVERFLOW_ERR+arg_num);

      for (i=0; i<len; i++)
        {
          ___UCS_4 c = [src characterAtIndex:i];
          ___STRINGSET(result,___FIX(i),___CHR(c))
        }
    }

  *dst = result;

  return ___FIX(___NO_ERR);
}

#define ___BEGIN_CFUN_SCMOBJ_to_NSStringSTAR(src,dst,i) \
if ((___err = SCMOBJ_to_NSStringSTAR(src, &dst, i)) == ___FIX(___NO_ERR)) {
#define ___END_CFUN_SCMOBJ_to_NSStringSTAR(src,dst,i) }

#define ___BEGIN_CFUN_NSStringSTAR_to_SCMOBJ(src,dst) \
if ((___err = NSStringSTAR_to_SCMOBJ(src, &dst, ___RETURN_POS)) == ___FIX(___NO_ERR)) {
#define ___END_CFUN_NSStringSTAR_to_SCMOBJ(src,dst) \
___EXT(___release_scmobj)(dst); }

#define ___BEGIN_SFUN_NSStringSTAR_to_SCMOBJ(src,dst,i) \
if ((___err = NSStringSTAR_to_SCMOBJ(src, &dst, i)) == ___FIX(___NO_ERR)) {
#define ___END_SFUN_NSStringSTAR_to_SCMOBJ(src,dst,i) \
___EXT(___release_scmobj)(dst); }

#define ___BEGIN_SFUN_SCMOBJ_to_NSStringSTAR(src,dst) \
{ ___err = SCMOBJ_to_NSStringSTAR(src, &dst, ___RETURN_POS);
#define ___END_SFUN_SCMOBJ_to_NSStringSTAR(src,dst) }

c-declare-end
)

(c-define-type NSString* "NSString*"
  "NSStringSTAR_to_SCMOBJ"
  "SCMOBJ_to_NSStringSTAR"
  #t)

;;;----------------------------------------------------------------------------

;; Interface with NSDate Class.

(define NSDate      (string->Class "NSDate"))
(define alloc       (string->SEL "alloc"))
(define init        (string->SEL "init"))
(define description (string->SEL "description"))

(define (date)
  (id->string
   (send0 (send0 (send0 NSDate alloc) init) description)))

;;;----------------------------------------------------------------------------

;; Interface with NSBundle Class.

(define NSBundle    (string->Class "NSBundle"))
(define mainBundle  (string->SEL "mainBundle"))
(define objectForInfoDictionaryKey (string->SEL "objectForInfoDictionaryKey:"))

(define (mainBundle-info key)
  (let ((info
         (send1 (send0 NSBundle mainBundle)
                objectForInfoDictionaryKey (string->id key))))
    (and info
         (id->string info))))

(define CFBundleName (mainBundle-info "CFBundleName"))
(define CFBundleDisplayName (mainBundle-info "CFBundleDisplayName"))

;;;----------------------------------------------------------------------------

;; Interface with UIDevice Class.

(define currentDevice-batteryLevel
  (c-lambda () float
    "___result = [[UIDevice currentDevice] batteryLevel];"))

(define currentDevice-batteryMonitoringEnabled
  (c-lambda () bool
    "___result = [UIDevice currentDevice].batteryMonitoringEnabled;"))

(define currentDevice-batteryMonitoringEnabled-set!
  (c-lambda (bool) void
    "[UIDevice currentDevice].batteryMonitoringEnabled = ___arg1;"))

(define currentDevice-multitaskingSupported
  (c-lambda () bool
    "___result = [UIDevice currentDevice].multitaskingSupported;"))

(define currentDevice-model
  (c-lambda () NSString*
    "___result = [[UIDevice currentDevice] model];"))

(define currentDevice-name
  (c-lambda () NSString*
    "___result = [[UIDevice currentDevice] name];"))

(define currentDevice-systemName
  (c-lambda () NSString*
    "___result = [[UIDevice currentDevice] systemName];"))

(define currentDevice-systemVersion
  (c-lambda () NSString*
    "___result = [[UIDevice currentDevice] systemVersion];"))

(define currentDevice-uniqueIdentifier
  (c-lambda () NSString*
    "___result = [[UIDevice currentDevice] uniqueIdentifier];"))

(define (device-status)
  (currentDevice-batteryMonitoringEnabled-set! #t)
  (list (currentDevice-batteryLevel)
        (currentDevice-batteryMonitoringEnabled)
        (currentDevice-multitaskingSupported)
        (currentDevice-model)
        (currentDevice-name)
        (currentDevice-systemName)
        (currentDevice-systemVersion)
        (currentDevice-uniqueIdentifier)))

(define (device-model)
  (let ((m (currentDevice-model)))
    (cond ((has-prefix? m "iPhone")
           'iPhone)
          ((has-prefix? m "iPod touch")
           'iPod-touch)
          ((has-prefix? m "iPad")
           'iPad)
          (else
           #f))))

(define (UDID)
  (currentDevice-uniqueIdentifier))


;;;----------------------------------------------------------------------------

;; Interface with AudioToolbox.

(c-declare #<<c-declare-end

#import <AudioToolbox/AudioToolbox.h>

c-declare-end
)

(c-define-type SystemSoundID unsigned-int32)

(define AudioServicesPlayAlertSound
  (c-lambda (SystemSoundID) void "AudioServicesPlayAlertSound"))

(define AudioServicesPlaySystemSound
  (c-lambda (SystemSoundID) void "AudioServicesPlaySystemSound"))

(define kSystemSoundID_FlashScreen        #x00000FFE)
(define kSystemSoundID_Vibrate            #x00000FFF)
(define kSystemSoundID_UserPreferredAlert #x00001000)

;;;----------------------------------------------------------------------------

;; Interface with ViewController.

(c-declare #<<c-declare-end

#include "ViewController.h"

c-declare-end
)

;; C functions callable from Scheme.

(define set-navigation
  (c-lambda (int) void "set_navigation"))

(define show-cancelButton
  (c-lambda () void "show_cancelButton"))

(define hide-cancelButton
  (c-lambda () void "hide_cancelButton"))

(define show-webView
  (c-lambda (int) void "show_webView"))

(define show-textView
  (c-lambda (int) void "show_textView"))

(define show-imageView
  (c-lambda (int) void "show_imageView"))

(define set-textView-font
  (c-lambda (int NSString* int) void "set_textView_font"))

(define set-textView-content
  (c-lambda (int NSString*) void "set_textView_content"))

(define get-textView-content
  (c-lambda (int) NSString* "get_textView_content"))

(define add-output-to-textView
  (c-lambda (int NSString*) void "add_output_to_textView"))

(define add-input-to-textView
  (c-lambda (int NSString*) void "add_input_to_textView"))

(define (set-webView-content view str #!optional (base-url-path #f) (enable-scaling #f) (mime-type "text/html"))
  ((c-lambda (int NSString* NSString* bool NSString*) void "set_webView_content") view str base-url-path enable-scaling mime-type))

(define (set-webView-content-from-file view path #!optional (base-url-path (path-directory path)) (enable-scaling #f) (mime-type "text/html"))
  ((c-lambda (int NSString* NSString* bool NSString*) void "set_webView_content_from_file") view path base-url-path enable-scaling mime-type))

(define eval-js-in-webView
  (c-lambda (int NSString*) NSString* "eval_js_in_webView"))

(define open-URL
  (c-lambda (NSString*) void "open_URL"))

(define set-idle-timer
  (c-lambda (bool) void "set_idle_timer"))

(define segm-ctrl-set-title
  (c-lambda (int NSString*) void "segm_ctrl_set_title"))

(define segm-ctrl-insert
  (c-lambda (int NSString*) void "segm_ctrl_insert"))

(define segm-ctrl-remove
  (c-lambda (int) void "segm_ctrl_remove"))

(define segm-ctrl-remove-all
  (c-lambda () void "segm_ctrl_remove_all"))

(define set-pref
  (c-lambda (NSString* NSString*) void "set_pref"))

(define get-pref
  (c-lambda (NSString*) NSString* "get_pref"))

(define set-pasteboard
  (c-lambda (NSString*) void "set_pasteboard"))

(define get-pasteboard
  (c-lambda () NSString* "get_pasteboard"))

(define popup-alert
  (c-lambda (NSString* NSString* NSString* NSString*) void "popup_alert"))

(define (setup-location-updates desired-accuracy #!optional (distance-filter 0.0))
  ((c-lambda (double double) void "setup_location_updates") desired-accuracy distance-filter))

(define (set-navigation-bar titles)
  (segm-ctrl-remove-all)
  (let loop ((i 0) (lst titles))
    (if (pair? lst)
        (begin
          (segm-ctrl-insert i (car lst))
          (loop (+ i 1) (cdr lst))))))

;; Scheme functions callable from C.

(c-define (send-input str) (NSString*) void "send_input" "extern"

  (let ((rp repl-port))
    (if (port? rp)
        (begin
          (display str rp)
          (force-output rp)))))

(c-define (send-event str) (NSString*) void "send_event" "extern"

  (let ((ep event-port))
    (if (port? ep)
        (begin
          (write str ep)
          (force-output ep)))))

(c-define (send-key str) (NSString*) void "send_key" "extern"

  (let ((hk handle-key))
    (if (procedure? hk)
        (hk str))))

(define handle-key #f)

(set! handle-key
  (lambda (str)
    (add-input-to-textView 0 str)))

(c-define (heartbeat) () double "heartbeat" "extern"

  ;; make sure other threads get to run
  (##thread-heartbeat!)

  ;; check if there has been any REPL output
  (let ((rp repl-port))
    (if (port? rp)
        (let ((output (read-line rp #f)))
          (if (string? output)
              (add-output-to-textView 0 output)))))

  ;; return interval until next heartbeat
  (next-heartbeat-interval))

(define (next-heartbeat-interval)

  (##declare (not interrupts-enabled))

  (let* ((run-queue
          (macro-run-queue))
         (runnable-threads?
          (##not
           (let ((root (macro-btq-left run-queue)))
             (and (##not (##eq? root run-queue))
                  (##eq? (macro-btq-left root) run-queue)
                  (##eq? (macro-btq-right root) run-queue))))))
    (if runnable-threads?

        (begin
          ;; There are other threads that can run, so request
          ;; to call "heartbeat" real soon to run those threads.
          interval-runnable)

        (let* ((next-sleeper
                (macro-toq-leftmost run-queue))
               (sleep-interval
                (if (##eq? next-sleeper run-queue)
                    +inf.0
                    (begin
                      ;; There is a sleeping thread, so figure out in
                      ;; how much time it needs to wake up.
                      (##flonum.max
                       (##flonum.- (macro-thread-timeout next-sleeper)
                                   (##current-time-point))
                       interval-min-wait))))
               (next-condvar
                (macro-btq-deq-next run-queue))
               (io-interval
                (if (##eq? next-condvar run-queue)
                    interval-no-io-pending ;; I/O is not pending, just relax
                    interval-io-pending))) ;; I/O is pending, so come back soon
          (##flonum.min sleep-interval io-interval)))))

(define interval-runnable 0.0)
(set! interval-runnable 0.0)

(define interval-io-pending 0.0)
(set! interval-io-pending 0.02)

(define interval-no-io-pending 0.0)
(set! interval-no-io-pending 1.0)

(define interval-min-wait 0.0)
(set! interval-min-wait 0.0001)

(c-define (eval-string str) (NSString*) NSString* "eval_string" "extern"
  (let ()

    (define (catch-all-errors thunk)
      (with-exception-catcher
       (lambda (exc)
         (write-to-string exc))
       thunk))

    (define (write-to-string obj)
      (with-output-to-string
        ""
        (lambda () (write obj))))

    (define (read-from-string str)
      (with-input-from-string str read))

    (catch-all-errors
     (lambda () (write-to-string (eval (read-from-string str)))))))

;;;----------------------------------------------------------------------------

;; Setup pipe to do I/O on the REPL being run by the primordial thread.

(define repl-port #f)

(receive (i o) (open-string-pipe)

  ;; Hack... set the names of the port.
  (##vector-set! i 4 (lambda (port) '(console)))

  (set! ##stdio/console-repl-channel (##make-repl-channel-ports i i))

  (set! repl-port o)

  (input-port-timeout-set! o -inf.0))

;;;----------------------------------------------------------------------------

;; Handling of events from the webView.

(define event-port #f)

(define event-handler
  (lambda (event)
    ;; ignore event
    #f))

(define location-update-event-handler
  (lambda (event)
    ;; ignore event
    #f))

(receive (i o) (open-vector-pipe '(direction: input))

  (set! event-port o)

  (thread-start!
   (make-thread
    (lambda ()
      (let loop ()
        (let ((event (read i)))
          (if (not (eof-object? event))
              (let ((x (has-prefix? event "location-update:")))
                (if x
                    (let ((location
                           (with-exception-catcher
                            (lambda (e)
                              #f)
                            (lambda ()
                              (list->vector (with-input-from-string x read-all))))))
                      (location-update-event-handler location))
                    (event-handler event))
                (loop)))))))))

(define (set-event-handler proc)
  (set! event-handler (proc event-handler)))

(define (set-location-update-event-handler proc)
  (set! location-update-event-handler proc))

(define (show-view view)
  (show-webView view))

(define (set-view-content view content #!optional (base-url-path #f) (enable-scaling #f) (mime-type "text/html"))
  (set-webView-content
   view
   (with-output-to-string "" (lambda () (print content)))
   base-url-path
   enable-scaling
   mime-type))

(define (has-prefix? str prefix)
  (and (string? str)
       (string? prefix)
       (let ((len-str (string-length str))
             (len-prefix (string-length prefix)))
         (and (>= len-str len-prefix)
              (string=? (substring str 0 len-prefix) prefix)
              (substring str len-prefix len-str)))))

(define (get-event-parameters rest)
  (call-with-input-string
   rest
   (lambda (port)
     (map url-decode
          (read-all port (lambda (p) (read-line p #\:)))))))


;;;----------------------------------------------------------------------------

;; Make it impossible to quit the application with a call to "exit" or
;; with a ",q" from the REPL.  This is needed to conform to the iOS
;; Developer Program License Agreement (I don't know which section
;; but I remember it had to do with the iOS human interface design).

(set! ##exit
      (lambda (#!optional (status 0))
        (error "To exit, press the sleep button for 5 seconds then the home button for 10 seconds")))


;;;----------------------------------------------------------------------------

;; Make it impossible to access files outside of Gambit REPL.  This is
;; needed to conform to the iOS Developer Program License Agreement:
;; 
;; 3.3.4 An Application may only read data from or write data to an
;; Application's designated container area on the device, except as
;; otherwise specified by Apple.

;; The "~~" path will be equal to the app's bundle directory.  The app's
;; home directory is the directory containing the app's bundle directory.

(define app-home-dir
  (##path-normalize "~~/.."))

(define (contained-path-resolve path)
  (let loop ()
    (let ((str (##path-expand path)))
      (if (has-prefix? (##path-normalize str) app-home-dir)
          str ;; only allow files in app directory
          (begin
            (error "App container violation")
            (loop))))))

(set! ##path-resolve-hook contained-path-resolve)

;; Make the current-directory and the "~" path equal to the app's
;; Documents directory.  This directory is backed-up by iTunes.

(set! ##os-path-homedir
      (c-lambda () NSString* "get_documents_dir"))

(current-directory "~")


;;;============================================================================
