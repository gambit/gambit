;;;============================================================================

;;; File: "program.scm"

;;; Copyright (c) 2011 by Marc Feeley, All Rights Reserved.

;; This program implements the "Gambit REPL" application for iOS
;; devices.  It is a simple development environment for Scheme.  The
;; user can interact with a REPL, edit small scripts, run them and
;; share them on a public script repository.

;;;============================================================================

(##namespace ("gr#"))

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")

(##include "wiki#.scm")
(##include "html#.scm")
(##include "url#.scm")
(##include "json#.scm")

(##namespace (""
              splash
              repl
              repl-eval
              edit
              login
              repo
              reset-scripts
              upload-script
              download-script
              delete-script
              view-script
              obtain-script
              start-repl-server
              show-textView
              show-webView
              set-textView-font
              set-textView-content
              get-textView-content
              add-output-to-textView
              add-input-to-textView
              set-webView-content
              open-URL
              set-pref
              get-pref
              set-page
              set-page-content
              has-prefix?
              get-event-parameters

              string->Class
              Class->string
              string->SEL
              SEL->string
              send0
              send1
              send2
              id->string
              string->id
              id->bool
              bool->id
              id->int
              int->id
              id->float
              float->id
              id->double
              double->id

              date

              device-status
              UDID

              AudioServicesPlayAlertSound
              AudioServicesPlaySystemSound
              kSystemSoundID_FlashScreen
              kSystemSoundID_Vibrate
              kSystemSoundID_UserPreferredAlert
             ))

(declare
 (standard-bindings)
 (extended-bindings)
 (block)
 (fixnum)
 ;;(not safe)
)

;;;----------------------------------------------------------------------------

;; Make it impossible to access files outside of Gambit REPL.  This is
;; needed to respect clause 2.6 of the App Store Review Guidelines:
;; "Apps that read or write data outside its designated container area
;; will be rejected".

(define (contained-path-resolve path)
  (let loop ()
    (let ((str (##path-expand path)))
      (if (has-prefix? (##path-normalize str) app-dir)
          str ;; only allow files in app directory
          (begin
            (error "App container violation")
            (loop))))))

(set! ##path-resolve-hook contained-path-resolve)

;; Make the current-directory and the "~~" path equal to the program's
;; .app directory.

(define app-dir
  (##path-normalize (path-directory (car (command-line)))))

(set! ##os-path-gambcdir
      (lambda () app-dir))

(current-directory app-dir)

;;;----------------------------------------------------------------------------

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

(define show-textView
  (c-lambda () void "show_textView"))

(define show-webView
  (c-lambda () void "show_webView"))

(define set-textView-font
  (c-lambda (NSString* int) void "set_textView_font"))

(define set-textView-content
  (c-lambda (NSString*) void "set_textView_content"))

(define get-textView-content
  (c-lambda () NSString* "get_textView_content"))

(define add-output-to-textView
  (c-lambda (NSString*) void "add_output_to_textView"))

(define add-input-to-textView
  (c-lambda (NSString*) void "add_input_to_textView"))

(define (set-webView-content str #!optional (enable-scaling #f) (mime-type "text/html"))
  ((c-lambda (NSString* bool NSString*) void "set_webView_content") str enable-scaling mime-type))

(define open-URL
  (c-lambda (NSString*) void "open_URL"))

(define set-pref
  (c-lambda (NSString* NSString*) void "set_pref"))

(define get-pref
  (c-lambda (NSString*) NSString* "get_pref"))

;; Scheme functions callable from C.

(c-define (send-input str) (NSString*) double "send_input" "extern"

  (display str repl-port)
  (force-output repl-port)

  (heartbeat))

(c-define (send-event str) (NSString*) double "send_event" "extern"

  (display str event-port)
  (force-output event-port)

  (heartbeat))

(c-define (send-key str) (NSString*) double "send_key" "extern"

  (handle-key str)

  (heartbeat))

(define handle-key #f)

(set! handle-key
  (lambda (str)
    (if (char=? #\F (string-ref str 0))
        (let ((script (get-script-by-name str)))
          (cond (script
                 (run-script str script))
                ((equal? str "F13")
                 (##thread-interrupt! (macro-primordial-thread)))
                (else
                 (add-input-to-textView (string-append "<" str ">")))))
        (add-input-to-textView str))))

(c-define (heartbeat) () double "heartbeat" "extern"

  ;; make sure other threads get to run
  (##thread-heartbeat!)

  ;; check if there has been any REPL output
  (let ((output (read-line repl-port #f)))
    (if (string? output)
        (add-output-to-textView output)))

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
(set! interval-runnable 0.0001)

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
(define event-handler #f)

(receive (i o) (open-string-pipe '(direction: input))

  (set! event-port o)

  (thread-start!
   (make-thread
    (lambda ()
      (let loop ()
        (let ((event (read-line i)))
          (if (not (eof-object? event))
              (begin
                (event-handler event)
                (loop)))))))))

(define (set-page content handler #!optional (enable-scaling #f) (mime-type "text/html"))
  (set! event-handler handler)
  (set-page-content content enable-scaling mime-type))

(define (set-page-content content #!optional (enable-scaling #f) (mime-type "text/html"))
  (set-webView-content
   (with-output-to-string "" (lambda () (print content)))
   enable-scaling
   mime-type)
  (show-webView))

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

;; REPL server which can be contacted via telnet on port 7000.

(define (ide-repl-pump ide-repl-connection in-port out-port tgroup)

  (define m (make-mutex))

  (define (process-input)
    (let loop ((state 'normal))
      (let ((c (read-char ide-repl-connection)))
        (if (not (eof-object? c))
            (case state
              ((normal)
               (if (char=? c #\xff) ;; telnet IAC (interpret as command) code?
                   (loop c)
                   (begin
                     (mutex-lock! m)
                     (if (char=? c #\x04) ;; ctrl-d ?
                         (close-output-port out-port)
                         (begin
                           (write-char c out-port)
                           (force-output out-port)))
                     (mutex-unlock! m)
                     (loop state))))
              ((#\xfb) ;; after WILL command?
               (loop 'normal))
              ((#\xfc) ;; after WONT command?
               (loop 'normal))
              ((#\xfd) ;; after DO command?
               (if (char=? c #\x06) ;; timing-mark option?
                   (begin ;; send back WILL timing-mark
                     (mutex-lock! m)
                     (write-char #\xff ide-repl-connection)
                     (write-char #\xfb ide-repl-connection)
                     (write-char #\x06 ide-repl-connection)
                     (force-output ide-repl-connection)
                     (mutex-unlock! m)))
               (loop 'normal))
              ((#\xfe) ;; after DONT command?
               (loop 'normal))
              ((#\xff) ;; after IAC command?
               (case c
                 ((#\xf4) ;; telnet IP (interrupt process) command?
                  (for-each
                   ##thread-interrupt!
                   (thread-group->thread-list tgroup))
                  (loop 'normal))
                 ((#\xfb #\xfc #\xfd #\xfe) ;; telnet WILL/WONT/DO/DONT command?
                  (loop c))
                 (else
                  (loop 'normal))))
              (else
               (loop 'normal)))))))

  (define (process-output)
    (let loop ()
      (let ((c (read-char in-port)))
        (if (not (eof-object? c))
            (begin
              (mutex-lock! m)
              (write-char c ide-repl-connection)
              (force-output ide-repl-connection)
              (mutex-unlock! m)
              (loop))))))

  (let ((tgroup (make-thread-group 'repl-pump #f)))
    (thread-start! (make-thread process-input #f tgroup))
    (thread-start! (make-thread process-output #f tgroup))))

(define (make-ide-repl-ports ide-repl-connection tgroup)
  (receive (in-rd-port in-wr-port) (open-string-pipe '(direction: input permanent-close: #f))
    (receive (out-wr-port out-rd-port) (open-string-pipe '(direction: output))
      (begin

        ;; Hack... set the names of the ports for usage with gambit.el
        (##vector-set! in-rd-port 4 (lambda (port) '(stdin)))
        (##vector-set! out-wr-port 4 (lambda (port) '(stdout)))

        (ide-repl-pump ide-repl-connection out-rd-port in-wr-port tgroup)
        (values in-rd-port out-wr-port)))))

(define repl-channel-table (make-table test: eq?))

(set! ##thread-make-repl-channel
      (lambda (thread)
        (let ((tgroup (thread-thread-group thread)))
          (or (table-ref repl-channel-table tgroup #f)
              (##default-thread-make-repl-channel thread)))))

(define (setup-ide-repl-channel ide-repl-connection tgroup)
  (receive (in-port out-port) (make-ide-repl-ports ide-repl-connection tgroup)
    (let ((repl-channel (##make-repl-channel-ports in-port out-port)))
      (table-set! repl-channel-table tgroup repl-channel))))

(define (start-ide-repl)
  (##repl-debug-main))

(define repl-server-address "*:7000")

(define (repl-server)
  (let ((server
         (open-tcp-server
          (list server-address: repl-server-address
                reuse-address: #t))))
    (let loop ()
      (let* ((ide-repl-connection
              (read server))
             (tgroup
              (make-thread-group 'repl-service #f))
             (thread
              (make-thread
               (lambda ()
                 (setup-ide-repl-channel ide-repl-connection tgroup)
                 (start-ide-repl))
               'repl
               tgroup)))
        (thread-start! thread)
        (loop)))))

(define (start-repl-server)
  (thread-start! (make-thread repl-server))
  (void))

;;;----------------------------------------------------------------------------

;; Common HTML header.

(define common-html-header #<<common-html-header-end

<meta name="viewport" content="width=device-width, initial-scale=1.0">

<html>
<head>
<style TYPE="text/css">
<!--
body.splash {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#fffb8b), to(#fffef0));
}
body.editor {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#a0a0a0), to(#f0f0f0));
}
body.repo {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#a0a0a0), to(#f0f0f0));
}
body.login {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#a0a0a0), to(#f0f0f0));
}
.button0 {
    display: inline-block;
    color: black;
    font: bold 14px Arial;
    text-align: center;
    padding: 2px 0px;
    width: 25px;
    border: 1px solid black;
    -webkit-border-radius: 5px;
    opacity: 1.0;
    margin: 5px;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#fffef0), to(#fffb8b));

}
.button1 {
    display: inline-block;
    color: white;
    font: bold 14px Arial;
    text-align: center;
    padding: 2px 0px;
    width: 35px;
    border: 1px solid black;
    -webkit-border-radius: 5px;
    opacity: 1.0;
    margin: 5px;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#7f7fff), to(#2020b0));
}
.button2 {
    display: inline-block;
    color: white;
    font: bold 14px Arial;
    text-align: center;
    padding: 2px 0px;
    width: 50px;
    border: 1px solid black;
    -webkit-border-radius: 5px;
    opacity: 1.0;
    margin: 5px;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#7f7fff), to(#2020b0));
}
.bigbutton {
    display: inline-block;
    color: white;
    font: bold 14px Arial;
    text-align: center;
    padding: 7px 0px;
    width: 85px;
    border: 1px solid black;
    -webkit-border-radius: 5px;
    background-color: ;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#688aba), to(#385a8a));
    opacity: 1.0;
    margin: 5px;
}
.widebutton {
    display: inline-block;
    color: black;
    font: bold 14px Arial;
    text-align: center;
    padding: 7px 0px;
    width: 140px;
    border: 1px solid black;
    -webkit-border-radius: 5px;
    opacity: 1.0;
    margin: 5px;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#ffffff), to(#b0b0b0));
}
textarea.script {
    display: block;
    color: black;
    font: bold 12px Courier;
    width: 100%;
    margin: 5px;
}
input.scriptname {
    font: 14px Arial;
    padding: 2px 2px;
    width: 100%;
    margin: 5px;
}
input.login {
    font: bold 18px Arial;
    width: 200px;
}
td.label {
    font: 18px Arial;
    text-align: right;
}
div.statuserror {
    color: red;
    font: bold 18px Arial;
}
div.statussuccess {
    color: green;
    font: bold 18px Arial;
}
div.statusbox {
    height: 70px;
}
div.spinner {
    position: relative;
    width: 54px;
    height: 54px;
    display: inline-block;
}
div.spinner div {
    width: 12%;
    height: 26%;
    background: #000;
    position: absolute;
    left: 44.5%;
    top: 37%;
    opacity: 0;
    -webkit-animation: fade 1s linear infinite;
    -webkit-border-radius: 50px;
    -webkit-box-shadow: 0 0 3px rgba(0,0,0,0.2);
}
div.spinner div.bar1 {-webkit-transform:rotate(0deg) translate(0, -142%); -webkit-animation-delay: 0s;}    
div.spinner div.bar2 {-webkit-transform:rotate(30deg) translate(0, -142%); -webkit-animation-delay: -0.9167s;}
div.spinner div.bar3 {-webkit-transform:rotate(60deg) translate(0, -142%); -webkit-animation-delay: -0.833s;}
div.spinner div.bar4 {-webkit-transform:rotate(90deg) translate(0, -142%); -webkit-animation-delay: -0.75s;}
div.spinner div.bar5 {-webkit-transform:rotate(120deg) translate(0, -142%); -webkit-animation-delay: -0.667s;}
div.spinner div.bar6 {-webkit-transform:rotate(150deg) translate(0, -142%); -webkit-animation-delay: -0.5833s;}
div.spinner div.bar7 {-webkit-transform:rotate(180deg) translate(0, -142%); -webkit-animation-delay: -0.5s;}
div.spinner div.bar8 {-webkit-transform:rotate(210deg) translate(0, -142%); -webkit-animation-delay: -0.41667s;}
div.spinner div.bar9 {-webkit-transform:rotate(240deg) translate(0, -142%); -webkit-animation-delay: -0.333s;}
div.spinner div.bar10 {-webkit-transform:rotate(270deg) translate(0, -142%); -webkit-animation-delay: -0.25s;}
div.spinner div.bar11 {-webkit-transform:rotate(300deg) translate(0, -142%); -webkit-animation-delay: -0.1667s;}
div.spinner div.bar12 {-webkit-transform:rotate(330deg) translate(0, -142%); -webkit-animation-delay: -0.0833s;}
@-webkit-keyframes fade {
    from {opacity: 1;}
    to {opacity: 0.25;}
}
td.repoget {
    width: 38px;
}
td.repoentry {
    font: 14px Arial;
    word-break: break-all;
}
-->
</style>
<script>

function gestureStart() {
  var metas = document.getElementsByTagName('meta');
  for (var i=0; i<metas.length; i++) {
    if (metas[i].name == "viewport") {
      metas[i].content = "width=device-width, minimum-scale=0.25, maximum-scale=1.6";
    }
  }
}

document.addEventListener("gesturestart", gestureStart, false);

</script>
</head>

common-html-header-end
)

;;;----------------------------------------------------------------------------

;; Splash page.

(define splash-page-content-part1 #<<splash-page-content-part1-end

<body class="splash">
<p>
Welcome to <strong>
splash-page-content-part1-end
)

(define splash-page-content-part2 #<<splash-page-content-part2-end
</strong>, a Scheme development environment built with the <a href="event:wiki">Gambit Scheme programming system</a>.
</p>

<ul>
<li/> learn the Scheme language,
<li/> debug Scheme code on the go,
<li/> number crunch exactly!
</ul>

<p>
After the "<strong><code>&gt;</code></strong>" prompt enter your command then RETURN and the REPL will display the result. Here is a sample interaction:
</p>

<strong>
<code>
&gt; (+ 1 (/ (* 2 2) (sqrt 9)))<br/>
7/3<br/>
&gt; (expt 2 100)<br/>
1267650600228229401496703205376<br/>
&gt; (reverse (string-&gt;list "hello"))<br/>
(#\o #\l #\l #\e #\h)<br/>
&gt; \for (int i=1;i&lt;=3;i++) pp(i*i);<br/>
1<br/>
4<br/>
9<br/>
&gt; (exit)<br/>
</code>
</strong>

<center>

<div class="bigbutton" onClick="window.location='event:edit';">Edit Scripts</div>
<div class="bigbutton" onClick="if (confirm('Are you sure you want to start the REPL server?  It allows starting a REPL remotely, with no authentication, by telneting to port 7000 of your device.')) window.location='event:server';">Start Server</div>
<div class="bigbutton" onClick="window.location='event:repl';">Start REPL</div>

</center>
</body>
</html>

splash-page-content-part2-end
)

(define (splash)
  (set-page
   (list common-html-header
         splash-page-content-part1
         CFBundleDisplayName
         splash-page-content-part2)
   (lambda (event)
     (cond ((equal? event "event:repl")
            (repl))

           ((equal? event "event:edit")
            (edit))

           ((equal? event "event:server")
            (repl)
            (start-repl-server))

           ((equal? event "event:wiki")
            (repl)
            (open-URL
             (string-append
              "http://"
              wiki-server-address
              wiki-root
              "/index.php")))))
   #t))

(define (repl)
  (show-textView))

(define (repl-eval str)
  (if (string? str)
      (begin
        (add-output-to-textView str)
        (send-input str)
        (repl))))

(set! ##primordial-exception-handler-hook
      (lambda (exc other-handler)
        (repl) ;; switch to REPL view on errors
        (##repl-exception-handler-hook exc other-handler)))

(define (load-script name script)
  (let ((port (open-input-string script)))

    (if (not (equal? name ""))
        ;; Hack... set the names of the port to match the name
        (##vector-set! port 4 (lambda (port) name)))

    (let ((x
           (##read-all-as-a-begin-expr-from-port
            port
            (##current-readtable)
            ##wrap-datum
            ##unwrap-datum
            #f ;; Scheme syntax
            #t)))
      (if (not (##fixnum? x))
          (##eval-module (##vector-ref x 1) ##interaction-cte)))))

;;;----------------------------------------------------------------------------

;; Script editing.

(define predefined-scripts '(

("hello" .
#<<EOF
;; Show "Hello!" for a few seconds.

(set-webView-content #<<END
<h1>Hello!</h1>
END
)
(thread-sleep! 5) ;; wait 5 seconds
(edit) ;; return to this page
EOF
)

("fact100" .
#<<EOF
;; Compute factorial of 100.

(define (fact n)
  (if (< n 2)
      1
      (* n (fact (- n 1)))))

(repl-eval "(fact 100)\n")
EOF
)

("fib25" .
#<<EOF
;; Compute fibonacci of 25.

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(repl-eval "(time (fib 25))\n")
EOF
)

("F10" .
#<<EOF
;; Show date for a few seconds.

(set-webView-content (date))
(show-webView)

(thread-sleep! 5) ;; wait 5 seconds
(edit) ;; return to this page
EOF
)

("F11" .
#<<EOF
;; Show status for a few seconds.

(set-webView-content
  (string-append
   "<pre>\n"
   (with-output-to-string
     ""
     (lambda ()
       (pretty-print
        (device-status))))
   "</pre>\n"))
(show-webView)

(thread-sleep! 5) ;; wait 5 seconds
(edit) ;; return to this page
EOF
)

("F12" .
#<<EOF
;; Start script editor.

(edit)
EOF
)

("main" .
#<<EOF
;; Main script.
;;
;; Start with splash screen.

(splash)
EOF
)

))

(define script-db #f)
(define script-db-version "1.0")

(define (reset-scripts)
  (set! script-db predefined-scripts)
  (save-script-db))

;;(reset-scripts)

(define (get-script-by-name name)
  (let* ((scripts (get-script-db))
         (x (assoc name scripts)))
    (and x (cdr x))))

(define (get-script-index-by-name name)
  (let loop ((scripts (get-script-db)) (i 0))
    (if (pair? scripts)
        (let ((x (car scripts)))
          (if (equal? (car x) name)
              i
              (loop (cdr scripts) (+ i 1))))
        #f)))

(define (get-script-at-index index)
  (let loop ((scripts (get-script-db)) (i 0))
    (if (pair? scripts)
        (if (= i index)
            (car scripts)
            (loop (cdr scripts) (+ i 1)))
        #f)))

(define (get-script-db)
  (if (not script-db)
      (set! script-db
            (let ((x (get-pref "script-db")))
              (if x
                  (let ((lst (with-input-from-string x read)))
                    (if (pair? lst)
                        (let ((version (car lst))
                              (db (cdr lst)))
                          (cond ((equal? version script-db-version)
                                 db)
                                (else
                                 predefined-scripts)))
                        predefined-scripts))
                  predefined-scripts))))
  script-db)

(define (save-script-db)
  (if script-db
      (set-pref "script-db"
                (with-output-to-string
                  ""
                  (lambda ()
                    (write (cons script-db-version script-db)))))))

;;;----------------------------------------------------------------------------

;; Login info.

(define predefined-login-info '("" "" #t))

(define login-info #f)
(define login-info-version "1.0")

(define (reset-login-info)
  (let ((info (get-login-info)))
    (set! login-info
          (list "" "" (caddr info)))
    (save-login-info)))

(define (get-login-info)
  (if (not login-info)
      (set! login-info
            (let ((x (get-pref "login-info")))
              (if x
                  (let ((lst (with-input-from-string x read)))
                    (if (pair? lst)
                        (let ((version (car lst))
                              (info (cdr lst)))
                          (cond ((equal? version login-info-version)
                                 info)
                                (else
                                 predefined-login-info)))
                        predefined-login-info))
                  predefined-login-info))))
  login-info)

(define (save-login-info)
  (if login-info
      (set-pref "login-info"
                (with-output-to-string
                  ""
                  (lambda ()
                    (write (cons login-info-version login-info)))))))

;;;----------------------------------------------------------------------------

;; Script editor.

(define edit-page-content-part1 #<<edit-page-content-part1-end

<script language="JavaScript">

var nb_scripts = 
edit-page-content-part1-end
)

(define edit-page-content-part2 #<<edit-page-content-part2-end
;

function send_event(e)
{ window.location = "event:" + e; }

function send_event_with_scripts(e,index)
{
  var strings = ["event:"+e,index];
  for (var i = 0; i<nb_scripts; i++)
  {
    strings.push(encodeURIComponent(document.getElementById("scriptname"+i).value));
    strings.push(encodeURIComponent(document.getElementById("script"+i).value));
  }
  strings.push("");
  window.location = strings.join(":");
}

function click_run(index)
{ send_event_with_scripts("run",index); }

function click_share(index)
{ var name = document.getElementById("scriptname"+index).value;
  var script = document.getElementById("script"+index).value;
  if (valid_repo_script_name(name))
  {
    if (confirm((script=="")?('Are you sure you want to delete the script '+name+' from the public script repository?'):('Are you sure you want to upload the script '+name+' to the public script repository? It will replace the current script by that name if it exists (note that older versions are kept in the Gambit wiki page history).')))
      send_event_with_scripts("share",index);
  }
}

function click_delete(index)
{ if (confirm('Are you sure you want to delete this script?'))
    send_event_with_scripts("delete",index);
}

function click_repo()
{ send_event_with_scripts("repo",0); }

function click_repl()
{ send_event_with_scripts("repl",0); }

function click_new()
{ send_event_with_scripts("new",0); }

function valid_repo_script_name(name)
{ if (/[A-Z][-\. A-Za-z0-9]*:[-\. A-Za-z0-9:]*\.scm/.exec(name))
    return true;
  alert("The script name is not valid for the public script repository. Here is a sample valid name:\n\nMath:pi.scm\n\nSpecifically, the name must start with an upper case letter, it must end in '.scm', it must contain at least one ':', and only letters, digits, ' ', '.', and '-'. The part before the first ':' is the section name.  It helps classify the scripts according to the script's purpose. It can be a new section name or an existing one, such as 'Games', 'Math', etc. Subsection names can be used for further classification within a section. Personal files should be put in the section\n\nUsers:<wiki-username>:...");
  return false;
}

</script>

<body class="editor">

<center>
<div class="bigbutton" onClick="click_repo();">Script Repo</div>
<div class="bigbutton" onClick="click_new();">New Script</div>
<div class="bigbutton" onClick="click_repl();">Show REPL</div>
</center>

edit-page-content-part2-end
)

(define edit-page-content-part3 #<<edit-page-content-part3-end

</body>
</html>

edit-page-content-part3-end
)

(define (html-for-local-scripts scripts)

  (define (html script name index)
    (list "<br/>\n"
          "<textarea class=\"script\" id=\"script" index "\" rows=9>"
          (html-escape script)
          "</textarea>\n"
          "<input type=\"text\" class=\"scriptname\" id=\"scriptname" index "\" value=\""
          (html-escape name)
          "\"/><br/>"
          "<center>\n"
          "<div class=\"button2\" onClick=\"click_run(" index ");\">Run</div>\n"
          "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
          "<div class=\"button2\" onClick=\"click_share(" index ");\">Share</div>\n"
          "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
          "<div class=\"button2\" onClick=\"click_delete(" index ");\">Delete</div>\n"
          "</center>\n"))

  (let loop ((scripts scripts) (i 0) (accum '()))
    (if (pair? scripts)
        (let* ((x (car scripts))
               (name (car x))
               (script (cdr x)))
          (loop (cdr scripts) (+ i 1) (cons (html script name i) accum)))
        (reverse accum))))

(define (edit)

  (define (get-index-and-update-script-db rest)
    (let ((x (get-event-parameters rest)))
      (if (pair? x)
          (let ((index (string->number (car x))))
            (let loop ((lst (cdr x)) (rev-scripts '()))
              (if (and (pair? lst)
                       (pair? (cdr lst)))
                  (let ((name (car lst))
                        (script (cadr lst)))
                    (loop (cddr lst)
                          (cons (cons name script) rev-scripts)))
                  (let ((new-script-db (reverse rev-scripts)))

                    (set-pref "run-main-script" "yes")

                    (set! script-db new-script-db)
                    (save-script-db)
                    index))))
          #f)))

  (set-page
   (let ((scripts (get-script-db)))
     (list common-html-header
           edit-page-content-part1
           (length scripts)
           edit-page-content-part2
           (html-for-local-scripts scripts)
           edit-page-content-part3))
   (lambda (event)
     (cond ((has-prefix? event "event:run:") =>
            (lambda (rest)
              (run-script-event
               (get-index-and-update-script-db rest))))

           ((has-prefix? event "event:share:") =>
            (lambda (rest)
              (share-script-event
               (get-index-and-update-script-db rest))))

           ((has-prefix? event "event:delete:") =>
            (lambda (rest)
              (delete-script-event
               (get-index-and-update-script-db rest))
              (edit)))

           ((has-prefix? event "event:repo:") =>
            (lambda (rest)
              (get-index-and-update-script-db rest)
              (repo edit)))

           ((has-prefix? event "event:repl:") =>
            (lambda (rest)
              (get-index-and-update-script-db rest)
              (repl)))

           ((has-prefix? event "event:new:") =>
            (lambda (rest)
              (get-index-and-update-script-db rest)
              (new-script)
              (edit)))))
   #t))

(define run-script-event #f)
(set! run-script-event
      (lambda (index)
        (let ((name-script (get-script-at-index index)))
          (and name-script
               (let ((name (car name-script))
                     (script (cdr name-script)))
                 (run-script name script))))))

(define (run-script name script)
  (##thread-interrupt!
   (macro-primordial-thread)
   (lambda ()
     (##repl-channel-release-ownership!) ;; to prevent deadlock...
     (with-exception-handler
      ##primordial-exception-handler
      (lambda ()
        (load-script name script)))
     (##void))))

(define share-script-event #f)
(set! share-script-event
      (lambda (index)
        (let ((name-script (get-script-at-index index)))
          (and name-script
               (let ((name (car name-script))
                     (script (cdr name-script)))
                 (if (equal? script "")
                     (delete-script name edit)
                     (upload-script name script edit)))))))

(define (upload-script name script #!optional (back repl))
  (repo-transaction
   (lambda ()
     (wiki-script-name-verify name)
     (wiki-script-store name script)
     (back))
   ""
   (list "<h3>Uploading script</h3>" (html-escape name) "<br/>")
   "The script has been uploaded to the repository"
   "Upload failed!"
   back))

(define (download-script name #!optional (back repl))
  (repo-transaction
   (lambda ()
     (wiki-script-name-verify name)
     (let ((script (wiki-script-fetch name)))
       (add-script name script)
       (back)))
   ""
   (list "<h3>Downloading script</h3>" (html-escape name) "<br/>")
   "The script has been downloaded from the repository"
   "Download failed!"
   back))

(define (delete-script name #!optional (back repl))
  (repo-transaction
   (lambda ()
     (wiki-script-name-verify name)
     (wiki-script-delete name)
     (back))
   ""
   (list "<h3>Deleting script</h3>" (html-escape name) "<br/>")
   "The script has been deleted from the repository"
   "Delete failed!"
   back))

(define (delete-script-event index)
  (let loop ((scripts (get-script-db)) (i 0) (accum '()))
    (if (pair? scripts)
        (if (= i index)
            (set! script-db (append (reverse accum)
                                    (cdr scripts)))
            (loop (cdr scripts) (+ i 1) (cons (car scripts) accum)))))
  (save-script-db))

(define (new-script)
  (add-script "untitled" ""))

(define (add-script name script)
  (set! script-db (cons (cons name script) (get-script-db)))
  (save-script-db))

;;;----------------------------------------------------------------------------

;; Repository browser.

(define repo-page-content-part1 #<<repo-page-content-part1-end

<body class="repo">


repo-page-content-part1-end
)

(define repo-page-content-part2 #<<repo-page-content-part2-end

<center>
<div class="bigbutton" onClick="window.location='event:back';">Back</div>
<div class="bigbutton" onClick="window.location='event:edit';">Edit Scripts</div>
<div class="bigbutton" onClick="window.location='event:repl';">Show REPL</div>
</center>


repo-page-content-part2-end
)

(define repo-page-content-part3 #<<repo-page-content-part3-end

<form>
<table>


repo-page-content-part3-end
)

(define repo-page-content-part4 #<<repo-page-content-part4-end

</table>
</form>
</body>
</html>

repo-page-content-part4-end
)

(define (html-for-script-tree tree)

  (define (html branch)
    (let ((name (car branch))
          (subtree (cdr branch)))
      (list "<tr>"
            (if (pair? subtree)
                (list "<td class=\"repoget\"></td>\n"
                      "<td><div class=\"button1\" onClick=\"window.location='event:view:"
                      (url-encode name)
                      "';\">=&gt;</div></td>\n")
                (list "<td class=\"repoget\"><div class=\"button0\" onClick=\"window.location='event:get:"
                      (url-encode name)
                      "';\">Get</div></td>\n"
                      "<td><div class=\"button1\" onClick=\"window.location='event:view:"
                      (url-encode name)
                      "';\">View</div></td>\n"))
            "<td class=\"repoentry\">"
            (html-escape name)
            "</td>\n"
            "</tr>\n")))

  (let loop ((tree tree) (accum '()))
    (if (pair? tree)
        (let ((branch (car tree)))
          (loop (cdr tree) (cons (html branch) accum)))
        (reverse accum))))

(define (repo #!optional (back repl))
  (auto-login
   (lambda ()
     (repo-transaction
      (lambda ()
        (let ((scripts (wiki-script-list)))
          (repo-browse back (script-list->tree scripts))))
      repo-page-content-part2
      ""
      #f
      "Could not get list of scripts!"
      back))
   back))

(define (script-list->tree scripts)

  (define (cvt scripts prefix)
    (if (not (pair? scripts))
        '()
        (let ((script1 (car scripts)))
          (let loop1 ((i 0))
            (if (< i (string-length script1))
                (if (not (char=? (string-ref script1 i) #\:))
                    (loop1 (+ i 1))
                    (let ((p (substring script1 0 (+ i 1))))
                      (let loop2 ((lst scripts) (rev-subtrees '()))

                        (define (end)
                          (let ((new-prefix (string-append prefix p)))
                            (cons (cons new-prefix
                                        (cvt (reverse rev-subtrees) new-prefix))
                                  (cvt lst prefix))))

                        (if (pair? lst)
                            (let ((s (car lst)))
                              (if (and (<= i (string-length s))
                                       (string=? (substring s 0 (+ i 1)) p))
                                  (loop2 (cdr lst)
                                         (cons (substring s (+ i 1) (string-length s))
                                               rev-subtrees))
                                  (end)))
                            (end)))))
                (cons (cons (string-append prefix script1) '())
                      (cvt (cdr scripts) prefix)))))))

  (cvt scripts ""))

(define (repo-browse back tree)
  (set-page
   (list common-html-header
         repo-page-content-part1
         repo-page-content-part2
         repo-page-content-part3
         (html-for-script-tree tree)
         repo-page-content-part4)
   (lambda (event)
     (cond ((has-prefix? event "event:view:") =>
            (lambda (rest)
              (let* ((params (get-event-parameters rest))
                     (name (car params))
                     (branch (assoc name tree)))
                (if branch
                    (let ((subtree (cdr branch)))
                      (if (pair? subtree)
                          (repo-browse (lambda () (repo-browse back tree))
                                       subtree)
                          (view-script name)))
                    (back))))) ;; this should never happen

           ((has-prefix? event "event:get:") =>
            (lambda (rest)
              (let* ((params (get-event-parameters rest))
                     (name (car params)))
                (get-repo-script-event name edit))))

           ((equal? event "event:back")
            (back))

           ((equal? event "event:repl")
            (repl))

           ((equal? event "event:edit")
            (edit))))
   #t))

(define (view-script name)
  (open-URL
   (string-append
    "http://"
    wiki-server-address
    wiki-root
    "/index.php/"
    (url-encode
     (string-append wiki-script-prefix name)))))

(define obtain-script #f)
(set! obtain-script view-script)

(define get-repo-script-event #f)
(set! get-repo-script-event
      (lambda (name #!optional (back repl))
        (let ((script
               (string-append
                obtain-script-prefix
                name
                obtain-script-suffix)))
          (add-script name script)
          (back))))

(define obtain-script-prefix #<<obtain-script-prefix-end
;; Apple forbids downloads, so you must
;; copy/paste the script from the wiki.
;; Tap on "Run" to visit the wiki. Then
;; double-tap-drag on the script to
;; select and copy it.  Then return to
;; Gambit REPL, select this text and
;; paste the script.

(obtain-script "
obtain-script-prefix-end
)

(define obtain-script-suffix #<<obtain-script-suffix-end
")

obtain-script-suffix-end
)

;;;----------------------------------------------------------------------------

;; Repository transaction page.

(define repo-transaction-page-content-part1 #<<repo-transaction-page-content-part1-end

<center>

repo-transaction-page-content-part1-end
)

(define repo-transaction-page-content-part2 #<<repo-transaction-page-content-part2-end

</center>

<br/>

<center><div class="statusbox">

repo-transaction-page-content-part2-end
)

(define repo-transaction-page-content-part3 #<<repo-transaction-page-content-part3-end
</div></center>

</body>
</html>

repo-transaction-page-content-part3-end
)

(define (make-repo-transaction-page header msg status)
  (list common-html-header
        repo-page-content-part1
        header
        repo-transaction-page-content-part1
        msg
        repo-transaction-page-content-part2
        status
        repo-transaction-page-content-part3))

(define (repo-transaction thunk header msg success-msg failure-msg back)

  (define (exec)

    (set-page-content
     (make-repo-transaction-page header msg spinner-html)
     #t)

    (guard-repo-transaction
     (lambda ()

       (thunk)

       (if success-msg
           (begin

             (set-page-content
              (make-repo-transaction-page
               header
               msg
               (list "<div class=\"statussuccess\">"
                     success-msg
                     "</div>"))
              #t)

             (thread-sleep! 2) ;; display success message for 2 seconds

             (back))))
     header
     msg
     failure-msg
     back))

  (auto-login
   exec
   back))

(define (guard-repo-transaction thunk header msg failure-msg back)
  (with-exception-catcher
   (lambda (e)

     (set-page-content
      (make-repo-transaction-page
       header
       msg
       (list "<div class=\"statuserror\">"
             failure-msg
             "<br/><br/>"
             (exception->error-msg e)
             "</div>"))
      #t)

     (thread-sleep! 4) ;; display error message for 4 seconds

     (back))
   thunk))

(define spinner-html
  "<div class=\"spinner\"><div class=\"bar1\"></div><div class=\"bar2\"></div><div class=\"bar3\"></div><div class=\"bar4\"></div><div class=\"bar5\"></div><div class=\"bar6\"></div><div class=\"bar7\"></div><div class=\"bar8\"></div><div class=\"bar9\"></div><div class=\"bar10\"></div><div class=\"bar11\"></div><div class=\"bar12\"></div></div>")

(define (exception->error-msg e)
  (cond ((equal? e "NotExists")
         "Username does not exist")
        ((or (equal? e "NoName")
             (equal? e "Illegal"))
         "Illegal username")
        ((or (equal? e "EmptyPass")
             (equal? e "WrongPass")
             (equal? e "WrongPluginPass"))
         "Wrong password")
        ((or (equal? e "Blocked")
             (equal? e "CreateBlocked"))
         "This user is blocked")
        ((equal? e "Throttled")
         "Too many logins... try again later")
        ((equal? e "failed to connect")
         "Could not connect to Gambit wiki")
        ((equal? e "script not found")
         "Script not found")
        ((equal? e "malformed script")
         "Script is not properly formatted")
        ((equal? e "you must first login to the Gambit wiki")
         "Not logged in to the Gambit wiki")
        ((or (equal? e "script name must be a string")
             (equal? e "script name must end with \".scm\"")
             (equal? e "script name must start with an upper case letter")
             (equal? e "script name must contain at least one colon")
             (equal? e "illegal character in script name"))
         "Invalid script name")
        ((equal? e "unknown")
         "Unknown error")
        (else
         (with-output-to-string "" (lambda () (display-exception e))))))

;;;----------------------------------------------------------------------------

;; Repository login.

(define login-page-content-part1 #<<login-page-content-part1-end

<body class="login">

<center>
<h1>Log in to Gambit wiki</h1>

<form onSubmit="window.location='event:login:'+encodeURIComponent(document.getElementById('username').value)+':'+encodeURIComponent(document.getElementById('password').value)+':'+encodeURIComponent(document.getElementById('rememberpass').value)+':'; return false;">

<table>
<tr>
  <td class="label">Username:</td>
  <td class="login"><input class="login" id="username" type="text" value="
login-page-content-part1-end
)

(define login-page-content-part2 #<<login-page-content-part2-end
" /></td>
</tr><tr>
  <td class="label">Password:</td>
  <td class="login"><input class="login" id="password" type="password" value="
login-page-content-part2-end
)

(define login-page-content-part3 #<<login-page-content-part3-end
" /></td>
<tr>
  <td></td>
  <td><input type="checkbox" id="rememberpass" 
login-page-content-part3-end
)

(define login-page-content-part4 #<<login-page-content-part4-end
/>Remember my password</td>
</tr>
</table>

<br/>

<input type="submit" class="bigbutton" value="Log in" />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<input type="button" class="bigbutton" value="Cancel" onClick="window.location='event:cancel';" />

</form>

</center>

<center><div class="statusbox">

login-page-content-part4-end
)

(define login-page-content-part5 #<<login-page-content-part5-end
</div></center>

<center>
If you don't have an account, you should<br/>
<div class="widebutton" onClick="window.location='event:create';">Create an account</div><br/>
It's free!
</center>

</body>
</html>

login-page-content-part5-end
)

(define (make-login-page username password remember-pass? msg)
  (list common-html-header
        login-page-content-part1
        (html-escape username)
        login-page-content-part2
        (html-escape password)
        login-page-content-part3
        (if remember-pass? "checked " "")
        login-page-content-part4
        msg
        login-page-content-part5))

(define (make-initial-login-page)
  (let ((info (get-login-info)))
    (make-login-page
     (car info)
     (cadr info)
     (caddr info)
     "")))

(define (auto-login success fail)
  (if (wiki-logged-in?)
      (success)
      (login success fail)))

(define (login #!optional (success repl) (fail repl))
  (login-with-page (make-initial-login-page) success fail))

(define (login-with-page page success fail)
  (set-page
   page
   (lambda (event)
     (cond ((has-prefix? event "event:login:") =>
            (lambda (rest)
              (let* ((params (get-event-parameters rest))
                     (username (car params))
                     (password (cadr params))
                     (remember-pass? (equal? (caddr params) "on")))
                (attempt-login success
                               fail
                               username
                               password
                               remember-pass?))))

           ((equal? event "event:cancel")
            (fail))

           ((equal? event "event:create")
            (open-URL
             (string-append
              "http://"
              wiki-server-address
              wiki-root
              "/index.php/Special:RequestAccount")))))
   #t))

(define (attempt-login success fail username password remember-pass?)

  (set! login-info
        (list username
              (if remember-pass? password "")
              remember-pass?))

  (save-login-info)

  (set-page
   (make-login-page
    username
    password
    remember-pass?
    spinner-html)
   (lambda (event)
     #f)
   #t)

  ((with-exception-catcher

    (lambda (e)
      (let ((msg
             (list "<div class=\"statuserror\">"
                   (exception->error-msg e)
                   "</div>")))
        (lambda ()
          (login-with-page
           (make-login-page
            username
            password
            remember-pass?
            msg)
           success
           fail))))

    (lambda ()

      (wiki-logout)
      (wiki-login username password #t)

      (set-page
       (make-login-page
        username
        password
        remember-pass?
        "<div class=\"statussuccess\">You are now logged in!</div>")
       (lambda (event)
         #f)
       #t)

      (thread-sleep! 2) ;; display success message for 2 seconds

      success))))

;;;----------------------------------------------------------------------------

;; Start the main REPL in the primordial thread, and create a second
;; thread which executes the rest of the program (returning back from
;; the C call to ___setup) and later takes care of the interaction
;; with the ViewController.

(continuation-capture
 (lambda (cont)

   (thread-start!
    (make-thread
     (lambda ()
       (continuation-return cont #f))))

   ;; the primordial thread is running this...

   (if (get-pref "run-main-script")

       (begin
         (set-pref "run-main-script" #f)
         (let* ((main-script-name "main")
                (main-script (get-script-by-name main-script-name)))
           (if main-script
               (begin
                 (load-script main-script-name main-script)
                 (set-pref "run-main-script" "yes"))
               (splash))))

       (splash)) ;; show splash screen if main script did not work last time

   (##repl-debug-main)

   (exit)))

;;;============================================================================
