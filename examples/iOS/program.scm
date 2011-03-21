;; File: "program.scm"

;; Copyright (c) 2011 by Marc Feeley, All Rights Reserved.

;; This program implements the "Gambit REPL" application for iOS
;; devices.  It is a simple development environment for Scheme.  The
;; user can interact with a REPL, and edit/save/run small scripts.

;;;----------------------------------------------------------------------------

(##namespace ("gr#"))

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")

(##namespace (""
              splash
              repl
              edit
              reset-scripts
              start-repl-server
              show-textView
              show-webView
              set-textView-font
              set-textView-content
              get-textView-content
              add-output-to-textView
              set-webView-content
              open-URL
              set-pref
              get-pref))

(declare
 (standard-bindings)
 (extended-bindings)
 (block)
 (fixnum)
 ;;(not safe)
)

;;;----------------------------------------------------------------------------

;; Make "~~" path equal to the program's .app directory.

(define app-dir (path-directory (car (command-line))))

(set! ##os-path-gambcdir (lambda () app-dir))

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

      result = [NSString stringWithCharacters:buf length:len];

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

      result = ___alloc_scmobj (___sSTRING, len<<___LCS, ___STILL);

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

(define set-webView-content
  (c-lambda (NSString*) void "set_webView_content"))

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

(c-define (heartbeat) () double "heartbeat" "extern"

  ;; make sure other threads get to run
  (thread-yield!)

  ;; check if there has been any REPL output
  (let ((output (read-line repl-port #f)))
    (if (string? output)
        (add-output-to-textView output)))

  0.1) ;; return interval until next heartbeat

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

(define (set-page content handler)
  (set! event-handler handler)
  (set-webView-content content)
  (show-webView))

(define (has-prefix? str prefix)
  (let ((len-str (string-length str))
        (len-prefix (string-length prefix)))
    (and (>= len-str len-prefix)
         (string=? (substring str 0 len-prefix) prefix)
         (substring str len-prefix len-str))))

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

;; Encoding/decoding of HTML and URIs.

(define (hex-digit str i)
  (let ((n (char->integer (string-ref str i))))
    (cond ((and (>= n 48) (<= n 57))
           (- n 48))
          ((and (>= n 65) (<= n 70))
           (- n 55))
          ((and (>= n 97) (<= n 102))
           (- n 87))
          (else
           #f))))

(define (hex-octet str i)
  (let ((n1 (hex-digit str i)))
    (and n1
         (let ((n2 (hex-digit str (+ i 1))))
           (and n2
                (+ (* n1 16) n2))))))

(define (extract-escaped str start end)

  (define (extract i j)
      (if (< i end)
          (let ((c (string-ref str i)))
            (if (char=? c #\%)
                (let ((n (and (< (+ i 2) end)
                              (hex-octet str (+ i 1)))))
                  (and n
                       (let ((result (extract (+ i 3) (+ j 1))))
                         (string-set! result j (integer->char n))
                         result)))
                (let ((result (extract (+ i 1) (+ j 1))))
                  (string-set! result j (if (char=? c #\+) #\space c))
                  result)))
          (make-string j)))

  (extract start 0))

(define (uri-unescape str)
  (extract-escaped str 0 (string-length str)))

(define (html-escape str)

  (declare (fixnum))

  ;; This table has a non-#f entry for every character that is valid
  ;; in a standard HTML document.  The entry is what should be
  ;; displayed when this character occurs.

  (define character-entity-table
    '#(#\nul
       #f; #\x01
       #f; #\x02
       #f; #\x03
       #f; #\x04
       #f; #\x05
       #f; #\x06
       #f; #\alarm
       #f; #\backspace
       #\tab
       #\newline
       #f; #\vtab
       #f; #\page
       #\return
       #f; #\x0E
       #f; #\x0F
       #f; #\x10
       #f; #\x11
       #f; #\x12
       #f; #\x13
       #f; #\x14
       #f; #\x15
       #f; #\x16
       #f; #\x17
       #f; #\x18
       #f; #\x19
       #f; #\x1A
       #f; #\x1B
       #f; #\x1C
       #f; #\x1D
       #f; #\x1E
       #f; #\x1F
       #\space
       #\!
       "&quot;"
       #\#
       #\$
       #\%
       "&amp;"
       #\'
       #\(
       #\)
       #\*
       #\+
       #\,
       #\-
       #\.
       #\/
       #\0
       #\1
       #\2
       #\3
       #\4
       #\5
       #\6
       #\7
       #\8
       #\9
       #\:
       #\;
       "&lt;"
       #\=
       "&gt;"
       #\?
       #\@
       #\A
       #\B
       #\C
       #\D
       #\E
       #\F
       #\G
       #\H
       #\I
       #\J
       #\K
       #\L
       #\M
       #\N
       #\O
       #\P
       #\Q
       #\R
       #\S
       #\T
       #\U
       #\V
       #\W
       #\X
       #\Y
       #\Z
       #\[
       #\\
       #\]
       #\^
       #\_
       #\`
       #\a
       #\b
       #\c
       #\d
       #\e
       #\f
       #\g
       #\h
       #\i
       #\j
       #\k
       #\l
       #\m
       #\n
       #\o
       #\p
       #\q
       #\r
       #\s
       #\t
       #\u
       #\v
       #\w
       #\x
       #\y
       #\z
       #\{
       #\|
       #\}
       #\~
       #f; #\rubout
       #f; "&#128;"
       #f; "&#129;"
       "&#130;"
       "&#131;"
       "&#132;"
       "&#133;"
       "&#134;"
       "&#135;"
       "&#136;"
       "&#137;"
       "&#138;"
       "&#139;"
       "&#140;"
       #f; "&#141;"
       "&#142;"
       #f; "&#143;"
       #f; "&#144;"
       "&#145;"
       "&#146;"
       "&#147;"
       "&#148;"
       "&#149;"
       "&#150;"
       "&#151;"
       "&#152;"
       "&#153;"
       "&#154;"
       "&#155;"
       "&#156;"
       #f; "&#157;"
       "&#158;"
       "&#159;"
       "&#160;"
       "&#161;"
       "&#162;"
       "&#163;"
       "&#164;"
       "&#165;"
       "&#166;"
       "&#167;"
       "&#168;"
       "&#169;"
       "&#170;"
       "&#171;"
       "&#172;"
       "&#173;"
       "&#174;"
       "&#175;"
       "&#176;"
       "&#177;"
       "&#178;"
       "&#179;"
       "&#180;"
       "&#181;"
       "&#182;"
       "&#183;"
       "&#184;"
       "&#185;"
       "&#186;"
       "&#187;"
       "&#188;"
       "&#189;"
       "&#190;"
       "&#191;"
       "&#192;"
       "&#193;"
       "&#194;"
       "&#195;"
       "&#196;"
       "&#197;"
       "&#198;"
       "&#199;"
       "&#200;"
       "&#201;"
       "&#202;"
       "&#203;"
       "&#204;"
       "&#205;"
       "&#206;"
       "&#207;"
       "&#208;"
       "&#209;"
       "&#210;"
       "&#211;"
       "&#212;"
       "&#213;"
       "&#214;"
       "&#215;"
       "&#216;"
       "&#217;"
       "&#218;"
       "&#219;"
       "&#220;"
       "&#221;"
       "&#222;"
       "&#223;"
       "&#224;"
       "&#225;"
       "&#226;"
       "&#227;"
       "&#228;"
       "&#229;"
       "&#230;"
       "&#231;"
       "&#232;"
       "&#233;"
       "&#234;"
       "&#235;"
       "&#236;"
       "&#237;"
       "&#238;"
       "&#239;"
       "&#240;"
       "&#241;"
       "&#242;"
       "&#243;"
       "&#244;"
       "&#245;"
       "&#246;"
       "&#247;"
       "&#248;"
       "&#249;"
       "&#250;"
       "&#251;"
       "&#252;"
       "&#253;"
       "&#254;"
       "&#255;"
       ))

  (call-with-output-string
   ""
   (lambda (port)
     (let ((n (string-length str)))
       (let loop ((start 0) (end 0))
         (if (= end n)
             (write-substring str start end port)
             (let* ((ch (string-ref str end))
                    (index (char->integer ch)))
               (cond ((and (< index 256)
                           (vector-ref character-entity-table index))
                      =>
                      (lambda (character-value)
                        (if (char? character-value)
                            (loop start (+ end 1))
                            (begin ;; it's a string
                              (write-substring
                               str
                               start
                               end
                               port)
                              (write-substring
                               character-value
                               0
                               (string-length character-value)
                               port)
                              (loop (+ end 1) (+ end 1))))))
                     (else
                      (display
                       (string-append
                        "Warning: Character (integer->char "
                        (number->string index)
                        ") is not a valid HTML 4.0 character entity\n")
                       (current-error-port))
                      (loop start (+ end 1)))))))))))

;;;----------------------------------------------------------------------------

;; Common HTML header.

(define common-html-header #<<common-html-header-end

<html>
<head>
<style TYPE="text/css">
<!--
div.button {
    display: inline-block;
    color: white;
    font: bold 14px Arial;
    text-align: center;
    padding: 7px 0px;
    width: 85px;
    border: 1px solid black;
    -webkit-border-radius: 5px;
    background-color: #486a9a;
    opacity: 1.0;
    margin: 5px;
}
textarea.script {
    display: block;
    color: black;
    font: bold 12px Courier;
    width: 100%;
    margin: 5px;
}
}
-->
</style>
</head>

common-html-header-end
)

;;;----------------------------------------------------------------------------

;; Splash page.

(define splash-page-content-head #<<splash-page-content-head-end

<body>
<p>
Welcome to <strong>Gambit REPL</strong>, a Scheme development environment built with the <a href="event:visit-wiki">Gambit Scheme programming system</a>.
</p>

<ul>
<li> learn the Scheme language,
<li> debug Scheme code on the go,
<li> number crunch exactly!
</ul>

<p>
After the "<strong><code>&gt;</code></strong>" prompt enter your command then RETURN and Gambit REPL will display the result. Here is a sample interaction:
</p>

<strong>
<code>
&gt; (+ 1 (/ (* 2 2) (sqrt 9)))<br>
7/3<br>
&gt; (expt 2 100)<br>
1267650600228229401496703205376<br>
&gt; (reverse (string-&gt;list "hello"))<br>
(#\o #\l #\l #\e #\h)<br>
&gt; \ for (int i=1;i<=3;i++) pp(i);<br>
1<br>
2<br>
3<br>
&gt; (exit)<br>
</code>
</strong>

<center>

splash-page-content-head-end
)

(define splash-page-content-button1 #<<splash-page-content-button1-end

<div class="button" onClick="window.location='event:start-repl';">Start REPL</div>

splash-page-content-button1-end
)

(define splash-page-content-button2 #<<splash-page-content-button2-end

<div class="button" onClick="window.location='event:edit-scripts';">Edit Scripts</div>

splash-page-content-button2-end
)

(define splash-page-content-tail #<<splash-page-content-tail-end

</center>
</body>
</html>

splash-page-content-tail-end
)

(define (splash #!optional (enable-edit-scripts? #f))
  (set-page
   (string-append common-html-header
                  splash-page-content-head
                  splash-page-content-button1
                  (if enable-edit-scripts?
                      splash-page-content-button2
                      "")
                  splash-page-content-tail)
   (lambda (event)
     (cond ((equal? event "event:start-repl")
            (repl))
           ((equal? event "event:edit-scripts")
            (edit))
           ((equal? event "event:visit-wiki")
            (repl)
            (open-URL "http://gambit.iro.umontreal.ca/"))))))

(define (repl)
  (show-textView))

;;;----------------------------------------------------------------------------

;; Script editing.

(define predefined-scripts '(

#<<EOF
;; Main script.
;;
;; Start with splash screen.

(splash)
EOF

#<<EOF
;; Show "Hello!" for a few seconds.

(set-webView-content "<h1>Hello!</h1>")

(thread-sleep! 5) ;; wait 5 seconds

(edit) ;; return to this page
EOF

#<<EOF
;; Compute factorial of 100.

(define (fact n)
  (if (< n 2)
      1
      (* n (fact (- n 1)))))

(repl) ;; show the REPL
(pp (fact 100))
EOF

#<<EOF
;; Compute fibonacci of 25.

(define (fib n)
  (if (< n 2)
      n
      (+ (fib (- n 1)) (fib (- n 2)))))

(repl) ;; show the REPL
(pp (time (fib 25)))
EOF

#<<EOF
;; List app directory content.

(define (tree p)
  (if (eq? (file-type p) 'directory)
      (let ((lst (directory-files p)))
        (cons p
              (parameterize
               ((current-directory p))
               (map tree lst))))
      p))

(repl) ;; show the REPL
(pp (tree "~~"))
EOF

#<<EOF
;; Get METAR aviation weather report.

(define (metar station)
  (let ((p (open-tcp-client "aviationweather.gov:80")))
    (display (string-append "GET /adds/metars/index.php?station_ids=" station "\r\n\r\n") p)
    (force-output p)
    (set-webView-content (read-line p #f))
    (close-port p)
    (thread-sleep! 10)
    (edit)))

(metar "cymx") ;; Mirabel airport
EOF

#<<EOF
;; Start REPL server.
;;
;; To connect to a REPL remotely:
;;
;;   % telnet <iphone's-IP> 7000

(start-repl-server)
EOF

))

(define script-db #f)

(define (reset-scripts)
  (set! script-db predefined-scripts)
  (save-script-db))

(define (get-script-db)
  (if (not script-db)
      (set! script-db
            (let ((x (get-pref "script-db")))
              (if x
                  (with-input-from-string x read)
                  predefined-scripts))))
  script-db)

(define (save-script-db)
  (if script-db
      (set-pref "script-db"
                (with-output-to-string "" (lambda () (write script-db))))))

(define edit-page-content-head #<<edit-page-content-head-end

<center>
<div class="button" onClick="window.location='event:add-script';">Add Script</div>
<div class="button" onClick="window.location='event:show-repl';">Show REPL</div>
</center>

edit-page-content-head-end
)

(define edit-page-content-tail #<<edit-page-content-tail-end

</body>
</html>

edit-page-content-tail-end
)

(define (html-for-scripts scripts enable-edit-main-script?)

  (define (html script index)
    (if (and (= index 0) (not enable-edit-main-script?))
        ""
        (list "<br>\n"
              "<textarea class=\"script\" id=\"script" index "\" rows=9>" (html-escape script) "</textarea>\n"
              "<center>\n"
              "<div class=\"button\" onClick=\"window.location='event:save:" index " '+encodeURIComponent(document.getElementById('script" index "').value);\">Save</div>\n"
              "<div class=\"button\" onClick=\"window.location='event:run:" index " '+encodeURIComponent(document.getElementById('script" index "').value);\">Run</div>\n"
              (if (= index 0)
                  ""
                  (list "<div class=\"button\" onClick=\"if (confirm('Are you sure you want to delete this script?')) window.location='event:delete:" index "';\">Delete</div>\n"))
              "</center>\n")))

  (let loop ((scripts scripts) (i 0) (accum '("<body>\n")))
    (if (pair? scripts)
        (let ((s (car scripts)))
          (loop (cdr scripts) (+ i 1) (cons (html s i) accum)))
        (with-output-to-string
          ""
          (lambda ()
            (print (reverse accum)))))))

(define (edit #!optional (enable-edit-main-script? #f))

  (define (get-parameters rest)
    (call-with-input-string
        (uri-unescape rest)
      (lambda (port)
        (let ((index (read port)))
          (read-char port)
          (cons index (read-line port #f))))))

  (set-page
   (string-append common-html-header
                  edit-page-content-head
                  (html-for-scripts (get-script-db) enable-edit-main-script?)
                  edit-page-content-tail)
   (lambda (event)
     (cond ((has-prefix? event "event:save:") =>
            (lambda (rest)

              (let ((p (get-parameters rest)))
                (save-script-at-index (car p) (cdr p)))))

           ((has-prefix? event "event:run:") =>
            (lambda (rest)
              (let ((p (get-parameters rest)))
                (run-script-at-index (car p) (cdr p)))))

           ((has-prefix? event "event:delete:") =>
            (lambda (rest)
              (delete-script-at-index (car (get-parameters rest)))
              (edit)))

           ((equal? event "event:add-script")
            (add-script)
            (edit))

           ((equal? event "event:show-repl")
            (repl))))))

(define (save-script-at-index index script)
  (let loop ((scripts (get-script-db)) (i 0) (accum '()))
    (if (pair? scripts)
        (if (= i index)
            (set! script-db (append (reverse accum)
                                    (cons script (cdr scripts))))
            (loop (cdr scripts) (+ i 1) (cons (car scripts) accum)))))
  (if (= index 0)
      (set-pref "run-main-script" "yes"))
  (save-script-db))

(define (run-script-at-index index script)
  (save-script-at-index index script)
  (let ((script (list-ref (get-script-db) index)))
    (##thread-interrupt!
     (macro-primordial-thread)
     (lambda ()
       (##repl-channel-release-ownership!) ;; to prevent deadlock...
       (eval (cons 'begin (with-input-from-string script read-all)))
       (##void)))))

(define (delete-script-at-index index)
  (let loop ((scripts (get-script-db)) (i 0) (accum '()))
    (if (pair? scripts)
        (if (= i index)
            (set! script-db (append (reverse accum)
                                    (cdr scripts)))
            (loop (cdr scripts) (+ i 1) (cons (car scripts) accum)))))
  (save-script-db))

(define (add-script)
  (set! script-db (append (get-script-db) '("")))
  (save-script-db))

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
         (let ((script (list-ref (get-script-db) 0)))
           (eval (cons 'begin (with-input-from-string script read-all))))
         (set-pref "run-main-script" "yes"))

       (splash)) ;; show splash screen if main script did not work last time

   (##repl-debug-main)

   (exit)))

;;;----------------------------------------------------------------------------
