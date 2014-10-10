;;;============================================================================

;;; File: "program.scm"

;;; Copyright (c) 2011-2014 by Marc Feeley, All Rights Reserved.

;; This program implements the "Gambit REPL" application for iOS
;; devices.  It is a simple development environment for Scheme.  The
;; user can interact with a REPL, and edit small scripts.

;;;============================================================================

(##namespace ("gr#"))

(##include "~~lib/gambit#.scm")
(##include "~~lib/_gambit#.scm")

(##namespace ("gr#" help)) ;; don't import help

(##include "wiki#.scm")
(##include "html#.scm")
(##include "url#.scm")
(##include "json#.scm")
(##include "repl-server#.scm")
(##include "intf#.scm")
(##include "script#.scm")
(##include "repo#.scm")
(##include "help#.scm")

(##namespace (""
              splash
              set-page
              set-page-content
              repl
              repl-eval
              repl-server
              wiki
              help
              edit
              reset-scripts
              remove-script
              store-script
              fetch-script
              view-script
             ))

(declare
 (standard-bindings)
 (extended-bindings)
 (block)
 (fixnum)
 ;;(not safe)
)

;;;----------------------------------------------------------------------------

;; Add cond-expand features to identify Gambit-REPL.

(set! ##cond-expand-features
      (cons 'Gambit-REPL
            (cons 'Gambit-REPL-iOS
                  (cons 'Gambit-REPL-v4.0
                        ##cond-expand-features))))

(define-runtime-syntax |\u03bb| ;; greek lowercase lambda
  (##make-alias-syntax '##lambda))

;;;----------------------------------------------------------------------------

;; Common HTML header.

(define common-html-header #<<common-html-header-end

<html>
<head>

<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=0.25, maximum-scale=1.6">

<script>

function gestureStart() {
  var metas = document.getElementsByTagName('meta');
  for (var i=0; i<metas.length; i++) {
    if (metas[i].name === "viewport") {
      metas[i].content = "width=device-width, initial-scale=1.0, minimum-scale=0.25, maximum-scale=1.6";
    }
  }
}

document.addEventListener("gesturestart", gestureStart, false);

function add_input(str) {
  var ta = document.activeElement;
  if (ta instanceof HTMLTextAreaElement) {
    var ev = document.createEvent('TextEvent');
    ev.initTextEvent('textInput', true, true, window, str);
    ta.dispatchEvent(ev);
  }
}

</script>

<style TYPE="text/css">
<!--
body.splash {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#fffb8b), to(#fffef0));
}
body.editor {
    background-color: #a0a0a0;
}
body.repo {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#a0a0a0), to(#f0f0f0));
}
body.login {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#a0a0a0), to(#f0f0f0));
}
body.help {
    background-image: -webkit-gradient(linear, left top, left bottom, from(#fffb8b), to(#fffef0));
}
.editorhead {
    float: right;
    height: 35px;
}
.repohead {
    height: 35px;
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
    height: 20px;
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
.button3 {
    display: inline-block;
    color: white;
    font: bold 24px Arial;
    text-align: center;
    padding: 0px 0px;
    width: 35px;
    height: 28px;
    border: 1px solid black;
    -webkit-border-radius: 5px;
    opacity: 1.0;
    margin: 0px;
    background-image: -webkit-gradient(linear, left top, left bottom, from(#94a6be), to(#506070));
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
</head>

common-html-header-end
)

;;;----------------------------------------------------------------------------

;; Splash page.

(define splash-page-content-part1 #<<splash-page-content-part1-end

<body class="splash">

<br/>
<br/>

<p>
Welcome to <strong>
splash-page-content-part1-end
)

(define splash-page-content-part2 #<<splash-page-content-part2-end
</strong>, a Scheme development environment based on the <a href="event:wiki">Gambit Scheme programming system</a>.
</p>

<ul>
<li/> learn the Scheme language,
<li/> debug Scheme code on the go,
<li/> number crunch exactly!
</ul>

<p>
In the REPL view, enter your command after the <strong><code>&gt;</code></strong> prompt, then tap <strong>return</strong> to display the result. Here is a sample interaction:<br/>
<strong>
<code>
<br/>
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
</code>
</strong>
</p>

</body>
</html>

splash-page-content-part2-end
)

(define (set-splash-view)
  (set-view-content
   0
   (list common-html-header
         splash-page-content-part1
         CFBundleDisplayName
         splash-page-content-part2)
   #f
   #t))

(define (splash)
  (set-navigation -1)
  (set-event-handler
   (lambda (old-event-handler)
     generic-event-handler))
  (show-view 0))

(define (set-page content handler #!optional (enable-scaling #f) (mime-type "text/html"))
  (set-view-content 0 content #f enable-scaling mime-type)
  (set-navigation -1)
  (set-event-handler
   (lambda (old-event-handler)
     handler))
  (show-view 0))

(define (set-page-content content #!optional (enable-scaling #f) (mime-type "text/html"))
  (set-page content generic-event-handler enable-scaling mime-type))


;;;----------------------------------------------------------------------------

;; Help page.

(define current-help-document #f)

(define (help #!optional (subject (macro-absent-obj)))
  (if (eq? subject (macro-absent-obj))
      (show-help-document (or current-help-document main-help-document) #f)
      (##help subject)))

(define (show-help-document docu anchor)
  (let ((load-docu? (not (equal? docu current-help-document))))

    (define (goto-anchor)
      (if anchor
          (eval-js-in-webView
           2
           (string-append "window.location='#" anchor "'"))))

    (set-event-handler
     (lambda (old-event-handler)
       (lambda (event)
         (cond ((and load-docu? (equal? event "event:loaded"))
                (if (not (equal? docu main-help-document))
                    (show-cancelButton))
                (goto-anchor))

               ((equal? event "event:r5rs")
                (show-help-document r5rs-help-document #f))

               ((equal? event "event:gambit-c")
                (show-help-document gambit-c-help-document #f))

               ((equal? event "cancel")
                (hide-cancelButton)
                (show-help-document main-help-document #f))

               ((has-prefix? event "event:browse:") =>
                (lambda (rest)
                  (open-URL rest)))

               ((wiki-event-handler event))

               ((handle-create-account-event event))

               (else
                (handle-navigation-event
                 event
                 (lambda ()
                   (hide-cancelButton))))))))

    (if load-docu?
        (begin
          (set! current-help-document docu)
          (set-webView-content-from-file 2 docu (path-directory docu) #t))
        (goto-anchor))

    (set-navigation 2)
    (show-view 2)

    (if (not (equal? docu main-help-document))
        (show-cancelButton))))


;;;----------------------------------------------------------------------------

;; REPL page.

(define (repl)
  (set-navigation 0)
  (set-event-handler
   (lambda (old-event-handler)
     generic-event-handler))
  (show-textView 0 #t))

(define (repl-eval str)
  (if (string? str)
      (begin
        (add-output-to-textView 0 str)
        (send-input str)
        (repl))))

(define (repl-server password)
  (repl-server-start password))

(set! ##primordial-exception-handler-hook
      (lambda (exc other-handler)
        (repl) ;; switch to REPL view on errors
        (##repl-exception-handler-hook exc other-handler)))


;;;----------------------------------------------------------------------------

;; Script editor.

(define edit-page-content-part1 #<<edit-page-content-part1-end

<script language="JavaScript">

edit-page-content-part1-end
)

(define edit-page-content-part2 #<<edit-page-content-part2-end

function send_event(e)
{ window.location = "event:" + e; }

function send_event_with_scripts(e,index)
{ window.location = event_with_scripts(e,index); }

function event_with_scripts(e,index)
{
  var strings = ["event:"+e,index];
  for (var i = 0; i<nb_scripts; i++)
  {
    strings.push(encodeURIComponent(document.getElementById("script"+i).value));
  }
  strings.push("");
  return strings.join(":");
}

function click_new()
{ send_event_with_scripts("new",0); }

function click_run(index)
{ send_event_with_scripts("run",index); }

function click_save(index)
{ var script = document.getElementById("script"+index).value;
  var lines = script.split(/\n/);
  var line1 = lines[0];
  var name = line1.replace(/^;;; /,"");
  var event = (/^[^\n]*\s*$/.exec(script)) ? "remove" : "save";
  if (name.length < line1.length && /^[A-Za-z][-\.A-Za-z0-9]*\.scm$/.exec(name))
  {
    if (confirm((event==="remove")?('Are you sure you want to remove\n\n'+name+'\n\nfrom the Documents folder?'):('Are you sure you want to save\n\n'+name+'\n\nto the Documents folder?')))
      send_event_with_scripts(event,index);
  }

edit-page-content-part2-end
)

(define edit-page-content-part3 #<<edit-page-content-part3-end
  else if (name.length < line1.length && /^[A-Z][-\. A-Za-z0-9]*:[-\. A-Za-z0-9:]*\.scm$/.exec(name))
  {
    if (confirm((event==="remove")?('Are you sure you want to remove\n\n'+name+'\n\nfrom the Gambit wiki?'):('Are you sure you want to save\n\n'+name+'\n\nto the Gambit wiki? It will replace the current script by that name if it exists. Note that previous versions of the script will still be available in the Gambit wiki page history.')))
      send_event_with_scripts(event,index);
  }

edit-page-content-part3-end
)

(define edit-page-content-part4 #<<edit-page-content-part4-end
  else
  {
    alert("The script cannot be saved because it is improperly named.  The first line must be the name of the script preceded by three semicolons and a space, for example:\n\n;;; test.scm\n\nMoreover, the name must start with a letter, and end in '.scm', and contain only letters, digits, '.', and '-'.");
  }
}

function click_delete(index)
{ if (confirm('Are you sure you want to delete this script from the Edit view?'))
    send_event_with_scripts("delete",index);
}

function lose_focus()
{ return event_with_scripts("exit",0); }

</script>

<body class="editor">

<br/>

<span class="editorhead">
<div class="button3" onClick="click_new();">+</div>
</span>

edit-page-content-part4-end
)

(define edit-page-content-part5 #<<edit-page-content-part5-end

</body>
</html>

edit-page-content-part5-end
)

(define edit-page-script-rows-iPad    20)
(define edit-page-script-rows-default 10)

(define edit-page-script-rows
  (case (device-model)
    ((iPad) edit-page-script-rows-iPad)
    (else   edit-page-script-rows-default)))

(define (html-for-local-scripts scripts)

  (define (html script name index)
    (list "<br/>\n"
          "<textarea class=\"script\" id=\"script" index "\" rows="
          edit-page-script-rows
          " autocomplete=\"off\" autocorrect=\"off\" autocapitalize=\"off\" spellcheck=\"false\">"
          (html-escape script)
          "</textarea>\n"
          "<center>\n"
          "<div class=\"button2\" onClick=\"click_run(" index ");\">Run</div>\n"
          "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
          "<div class=\"button2\" onClick=\"click_save(" index ");\">Save</div>\n"
          "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
          "<div class=\"button2\" onClick=\"click_delete(" index ");\">Delete</div>\n"
          "</center>\n"))

  (let loop ((scripts scripts) (i 0) (accum '()))
    (if (pair? scripts)
        (let* ((x (car scripts))
               (name (car x))
               (script (cdr x)))
          (loop (cdr scripts)
                (+ i 1)
                (cons (html (add-script-name-if-needed name script) name i)
                      accum)))
        (reverse accum))))

(define (add-script-name-if-needed name script)
  (if (not (wiki-script-name-type name))
      script
      (let ((name-in-script (extract-script-name script)))
        (if (equal? name name-in-script)
            script
            (string-append
             script-name-prefix
             name
             "\n\n"
             script)))))

(define (set-edit-view)
  (set-view-content
   3
   (let ((scripts (get-script-db)))
     (list common-html-header
           edit-page-content-part1
           "var nb_scripts = " (length scripts) ";\n"
           edit-page-content-part2
           (if repo-enabled?
               edit-page-content-part3
               "")
           edit-page-content-part4
           (html-for-local-scripts scripts)
           edit-page-content-part5))
   #f
   #t))

(define (edit)
  (set-navigation 3)
  (set-event-handler
   (lambda (old-event-handler)
     (lambda (event)
       (handle-edit-event
        event
        (lambda ()
          (handle-navigation-event
           event
           (lambda ()
             (let ((new-event (eval-js-in-webView 3 "lose_focus()")))
               (and (string? new-event)
                    (handle-edit-event
                     new-event
                     (lambda ()
                       #f)))))))))))
  (show-view 3 #t))

(define (get-index-and-update-script-db rest)
  (let ((x (get-event-parameters rest)))
    (if (pair? x)
        (let ((index (string->number (car x))))
          (let loop ((lst (cdr x)) (rev-scripts '()))
            (if (pair? lst)
                (let ((script (car lst)))
                  (loop (cdr lst)
                        (cons (cons (extract-script-name script) script)
                              rev-scripts)))
                (let ((new-script-db (reverse rev-scripts)))

                  (set-pref "run-main-script" "yes")

                  (set! script-db new-script-db)
                  (save-script-db)
                  index))))
        #f)))

(define (handle-edit-event event otherwise)
  (cond ((has-prefix? event "event:new:") =>
         (lambda (rest)
           (get-index-and-update-script-db rest)
           (new-script)
           (set-edit-view)))

        ((has-prefix? event "event:run:") =>
         (lambda (rest)
           (run-script-event
            (get-index-and-update-script-db rest))))

        ((has-prefix? event "event:save:") =>
         (lambda (rest)
           (save-script-event
            (get-index-and-update-script-db rest))))

        ((has-prefix? event "event:remove:") =>
         (lambda (rest)
           (remove-script-event
            (get-index-and-update-script-db rest))))

        ((has-prefix? event "event:delete:") =>
         (lambda (rest)
           (delete-script-event
            (get-index-and-update-script-db rest))
           (set-edit-view)))

        ((has-prefix? event "event:exit:") =>
         (lambda (rest)
           (get-index-and-update-script-db rest)))

        (else
         (otherwise))))

(define (handle-navigation-event event lose-focus-handler)
  (let ((nav (has-prefix? event "NAV")))
    (if nav
        (let ((n (string->number nav)))
          (lose-focus-handler)
          (case n
            ((1)
             (wiki))

            ((2)
             (help))

            ((3)
             (edit))

            (else
             (repl)))))))

(define (wiki-event-handler event)
  (or (and (equal? event "event:wiki")
           (begin
             (visit-wiki)
             #t))
      (and (equal? event "event:wiki-Gambit-REPL")
           (begin
             (visit-wiki-Gambit-REPL)
             #t))))

(define (visit-wiki)
  (open-URL
   (string-append
    "http://"
    wiki-server-address
    wiki-root
    "/index.php")))

(define (visit-wiki-Gambit-REPL)
  (open-URL
   (string-append
    "http://"
    wiki-server-address
    wiki-root
    "/index.php/Gambit_REPL")))

(define latest-pasteboard #f)

(define (handle-app-become-active-event event)
  (and (equal? event "app-become-active")
       (let* ((script (get-pasteboard))
              (name (and script
                         (not (equal? script latest-pasteboard))
                         (extract-script-name script))))
         (set! latest-pasteboard script)
         (if name
             (set-event-handler
              (lambda (old-event-handler)
                (popup-alert (string-append CFBundleName ".app")
                             (string-append
                              "Create the script\n\n"
                              name
                              "\n\nin the Edit view from the content of the pasteboard?")
                             "No"
                             "Yes")
                (lambda (event)

                  (define (done accept?)
                    (set-event-handler
                     (lambda (new-event-handler)
                       old-event-handler))
                    (if accept?
                        (begin
                          (add-script name script)
                          (set-edit-view)
                          (edit))))

                  (cond ((equal? event "popup-alert-cancel")
                         (done #f))
                        ((equal? event "popup-alert-accept")
                         (done #t)))))))
         #t)))

(define (handle-create-account-event event)
  (and (equal? event "event:create-account")
       (begin
         (open-URL
          (string-append
           "http://"
           wiki-server-address
           wiki-root
           "/index.php/Special:RequestAccount"))
         #t)))

(define (generic-event-handler event)
  (or (wiki-event-handler event)
      (handle-app-become-active-event event)
      (handle-create-account-event event)
      (handle-navigation-event event (lambda () #f))))

(define run-script-event #f)
(set! run-script-event
      (lambda (index)
        (let ((name-script (get-script-at-index index)))
          (and name-script
               (let ((name (car name-script))
                     (script (cdr name-script)))
                 (run-script name script))))))

(define save-script-event #f)
(set! save-script-event
      (lambda (index)
        (let ((name-script (get-script-at-index index)))
          (and name-script
               (let ((name (car name-script))
                     (script (cdr name-script)))
                 (store-script name script edit))))))

(define remove-script-event #f)
(set! remove-script-event
      (lambda (index)
        (let ((name-script (get-script-at-index index)))
          (and name-script
               (let ((name (car name-script))
                     (script (cdr name-script)))
                 (remove-script name edit))))))

(define (reset-scripts)
  (script#reset-scripts)
  (set-edit-view))

(define (remove-script name #!optional (back repl))
  (case (wiki-script-name-type name)
    ((wiki)
     (repo-transaction
      (lambda ()
        (wiki-script-name-verify name)
        (wiki-script-remove name)
        (back))
      ""
      (list "<br/><h3>Removing script</h3>" (html-escape name) "<br/>")
      "The script has been removed from the Gambit wiki"
      "Could not remove script!"
      back))

    ((file)
     (with-exception-catcher
      (lambda (e)
        (display-exception e (repl-output-port))
        (repl))
      (lambda ()
        (delete-file (##path-expand name "~"))))
     (back))))

(define (store-script name script #!optional (back repl))
  (case (wiki-script-name-type name)
    ((wiki)
     (repo-transaction
      (lambda ()
        (wiki-script-name-verify name)
        (wiki-script-store name script)
        (back))
      ""
      (list "<br/><h3>Storing script</h3>" (html-escape name) "<br/>")
      "The script has been stored on the Gambit wiki"
      "Could not store script!"
      back))

    ((file)
     (with-exception-catcher
      (lambda (e)
        (display-exception e (repl-output-port))
        (repl))
      (lambda ()
        (call-with-output-file
            (##path-expand name "~")
          (lambda (port)
            (display script port)))))
     (back))))

(define (fetch-script name #!optional (back repl))
  (case (wiki-script-name-type name)
    ((wiki)
     (repo-transaction
      (lambda ()
        (wiki-script-name-verify name)
        (let ((script (wiki-script-fetch name)))
          (add-script name script)
          (set-edit-view)
          (back)))
      ""
      (list "<br/><h3>Fetching script</h3>" (html-escape name) "<br/>")
      "The script has been fetched from the Gambit wiki"
      "Could not fetch script!"
      back))

    ((file)
     (with-exception-catcher
      (lambda (e)
        (display-exception e (repl-output-port))
        (repl))
      (lambda ()
        (let ((script
               (call-with-input-file
                   (##path-expand name "~")
                 (lambda (port)
                   (read-line port #f)))))
          (add-script name script)
          (set-edit-view)
          (back))))
     (back))))

(define (delete-script-event index)
  (let loop ((scripts (get-script-db)) (i 0) (accum '()))
    (if (pair? scripts)
        (if (= i index)
            (set! script-db (append (reverse accum)
                                    (cdr scripts)))
            (loop (cdr scripts) (+ i 1) (cons (car scripts) accum)))))
  (save-script-db))

(define script-name-prefix ";;; ") ;; must be consistent with the definition of the click_save JavaScript function

(define (extract-script-name script)
  (let* ((line1 (first-line script))
         (name (has-prefix? line1 script-name-prefix)))
    (and (wiki-script-name-type name)
         name)))

(define (first-line str)
  (let loop ((i 0))
    (if (< i (string-length str))
        (if (char=? (string-ref str i) #\newline)
            (substring str 0 i)
            (loop (+ i 1)))
        str)))


;;;----------------------------------------------------------------------------

;; Repository browser.

(define repo-page-content-part1 #<<repo-page-content-part1-end

<body class="repo">

<br/>

repo-page-content-part1-end
)

(define repo-page-content-part2 #<<repo-page-content-part2-end

<div class="repohead">
<div class="button1" onClick="window.location='event:back';">&#9664;</div>
</div>

repo-page-content-part2-end
)

(define repo-page-content-part3 #<<repo-page-content-part3-end

<div class="repohead">
&nbsp;
</div>

repo-page-content-part3-end
)

(define repo-page-content-part4 #<<repo-page-content-part4-end

<form>
<table>


repo-page-content-part4-end
)

(define repo-page-content-part5 #<<repo-page-content-part5-end

</table>
</form>
</body>
</html>

repo-page-content-part5-end
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
                      "';\">&#9654;</div></td>\n")
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

(define repo-enabled? #f)

(define (repo-enable!)
  (if (not repo-enabled?)
      (begin
        (set! repo-enabled? #t)
        (segm-ctrl-set-title 1 "Repo"))))

(define (repo)
  (repo-enable!)
  (wiki))

(define (wiki)
  (if (not repo-enabled?)
      (begin
        (visit-wiki-Gambit-REPL)
        (repl))
      (repo-transaction
       (lambda ()
         (let ((scripts (wiki-script-list)))
           (repo-browse #f (script-list->tree scripts))))
       repo-page-content-part3
       (list "<br/><h3>Accessing Gambit wiki</h3><br/>")
       #f
       "Could not get list of scripts!"
       repl)))

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
  (set-navigation 1)
  (set-event-handler
   (lambda (old-event-handler)
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
                            (view-script name)))))))

             ((has-prefix? event "event:get:") =>
              (lambda (rest)
                (let* ((params (get-event-parameters rest))
                       (name (car params)))
                  (get-repo-script-event name edit))))

             ((equal? event "event:back")
              (back))

             (else
              (generic-event-handler event))))))
  (set-view-content
   1
   (list common-html-header
         repo-page-content-part1
         (if back
             repo-page-content-part2
             repo-page-content-part3)
         repo-page-content-part4
         (html-for-script-tree tree)
         repo-page-content-part5)
   #f
   #t)
  (show-view 1))

(define (view-script name)
  (open-URL
   (string-append
    "http://"
    wiki-server-address
    wiki-root
    "/index.php/"
    (url-encode
     (string-append wiki-script-prefix name)))))

(define get-repo-script-event #f)
(set! get-repo-script-event fetch-script)


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

    (let ((content (make-repo-transaction-page header msg spinner-html)))
      (set-navigation 1)
      (set-view-content 1 content #f #t)
      (show-view 1))

    (guard-repo-transaction
     (lambda ()

       (thunk)

       (if success-msg
           (begin

             (set-view-content
              1
              (make-repo-transaction-page
               header
               msg
               (list "<div class=\"statussuccess\">"
                     success-msg
                     "</div>"))
              #f
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

     (set-view-content
      1
      (make-repo-transaction-page
       header
       msg
       (list "<div class=\"statuserror\">"
             failure-msg
             "<br/><br/>"
             (exception->error-msg e)
             "</div>"))
      #f
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

<br/>
<br/>

<center>
<h2>Log in to Gambit wiki</h2>

<form onSubmit="window.location='event:login:'+encodeURIComponent(document.getElementById('username').value)+':'+encodeURIComponent(document.getElementById('password').value)+':'+encodeURIComponent(document.getElementById('rememberpass').value)+':'; return false;">

<table>
<tr>
  <td class="label">Username:</td>
  <td class="login"><input class="login" id="username" type="text" value="
login-page-content-part1-end
)

(define login-page-content-part2 #<<login-page-content-part2-end
" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"/></td>
</tr><tr>
  <td class="label">Password:</td>
  <td class="login"><input class="login" id="password" type="password" value="
login-page-content-part2-end
)

(define login-page-content-part3 #<<login-page-content-part3-end
" autocomplete="off" autocorrect="off" autocapitalize="off" spellcheck="false"/></td>
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
<div class="widebutton" onClick="window.location='event:create-account';">Create an account</div><br/>
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
  (set-navigation 1)
  (set-event-handler
   (lambda (old-event-handler)
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

             (else
              (generic-event-handler event))))))
  (set-view-content 1 page #f #t)
  (show-view 1))

(define (attempt-login success fail username password remember-pass?)

  (set-login-info username password remember-pass?)

  (save-login-info)

  (set-view-content
   1
   (make-login-page
    username
    password
    remember-pass?
    spinner-html)
   #f
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

      (set-view-content
       1
       (make-login-page
        username
        password
        remember-pass?
        "<div class=\"statussuccess\">You are now logged in!</div>")
       #f
       #t)

      (thread-sleep! 2) ;; display success message for 2 seconds

      success))))


;;;----------------------------------------------------------------------------

;; Opening URLs.

(##namespace ("" open-URL))

(define (open-URL str)
  (if (string? str)
      (intf#open-URL str)))


;;;----------------------------------------------------------------------------

;; Key handler.

(set! handle-key
  (lambda (str)
    (if (char=? #\F (string-ref str 0))
        (let ((script (get-script-by-name str)))
          (if script
              (run-script str script)
              (let ((n (string->number (substring str 1 (string-length str)))))
                (cond ((eqv? n 12)
                       (##thread-interrupt! (macro-primordial-thread)))
                      (else
                       (add-input-to-currentView str))))))
        (add-input-to-currentView str))))


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

   (set-navigation-bar '("REPL" "Wiki" "Help" "Edit"))

   (if (equal? CFBundleDisplayName "Gambit REPL dev")
       (repo-enable!))

   (set-splash-view) ;; init the splash view
   (set-edit-view) ;; init the edit view

   (add-output-to-textView 0 "\n\n\n\n") ;; leave space at top of REPL view

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

   (##repl-debug-main)))


;;;============================================================================
