;==============================================================================

; File: "tcltk.scm"

; Copyright (c) 1997-2019 by Marc Feeley, All Rights Reserved.

; This is the Gambit interface for Tcl/Tk.

; To compile this file do:
;
; gsc -cc-options "-I/usr/X11R6/include" -ld-options "-L/usr/X11R6/lib -ltk -ltcl -lX11" tcltk.scm

;==============================================================================

(##namespace ("tcltk#"))

(##include "~~lib/gambit#.scm")

(##include "tcltk#.scm")

(declare
  (standard-bindings)
  (extended-bindings)
  (block)
  (not safe)
)

;==============================================================================

; The following private procedures are defined in this file:
;
;   (##tcltk-setup)                      must be called to initialize module
;   (##tcltk-cleanup)                    must be called to finalize module
;   (##tcltk-eval cmd)                   evaluates a Tcl command (a string)
;   (##tcltk-define-procedure name proc) exports a procedure to Tcl
;   (##tcltk-export-procedure proc)      exports a procedure to Tcl
;   (##tcltk-remove-procedure name)      removes a procedure exported to Tcl

;==============================================================================

; Low-level stuff needed to export Scheme procedures (including
; closures) to Tcl.

; Scheme procedures exported to Tcl become Tcl commands named
; "_p0", "_p1", etc.  When such a Tcl command is invoked, the
; Scheme procedure bound to the command is called.

(c-declare #<<c-declare-end

#include <tcl.h>
#include <tk.h>

/*
 * tcl_interp is a pointer to the Tcl interpreter.  When it is NULL
 * the Tcl interpreter has not yet been initialized.
 */

___HIDDEN Tcl_Interp *tcl_interp = NULL;

/*
 * The routine tcltk_setup must be called before any of the Tcl
 * procedures are used.  It returns a Boolean indicating if the
 * initialization was successful.  Afterwards, the routine
 * tcltk_cleanup must be called to do cleanup.
 */

___HIDDEN ___BOOL tcltk_setup
   ___P((char *exec_path),
        (exec_path)
char *exec_path;)
{
  Tcl_FindExecutable (exec_path);

  if (tcl_interp != NULL)
    Tcl_DeleteInterp (tcl_interp);

  tcl_interp = Tcl_CreateInterp ();

  if (tcl_interp != NULL)
    if (Tcl_Init (tcl_interp) == TCL_ERROR ||
        Tk_Init (tcl_interp) == TCL_ERROR)
      {
        Tcl_DeleteInterp (tcl_interp);
        tcl_interp = NULL;
      }

  return (tcl_interp != NULL);
}

___HIDDEN void tcltk_cleanup ___PVOID
{
  if (tcl_interp != NULL)
    {
      Tcl_DeleteInterp (tcl_interp);
      tcl_interp = NULL;
    }
}

/*
 * The routine tcltk_eval performs the evaluation of a Tcl command.
 */

void tcltk_eval_error ___P((char *msg),());

___HIDDEN char *tcltk_eval
   ___P((char *cmd),
        (cmd)
char *cmd;)
{
  for (;;)
    {
      if (tcl_interp == NULL)
        tcltk_eval_error ("Tcl not initialized");
      else if (Tcl_Eval (tcl_interp, cmd) != TCL_OK)
        tcltk_eval_error (___CAST(char*,Tcl_GetStringResult(tcl_interp)));
      else
        break;
    }

  return ___CAST(char*,Tcl_GetStringResult(tcl_interp));
}

/*
 * The routine scheme_call_cmd is called by Tcl when a Scheme
 * procedure is being called.  The client_data parameter points to a
 * reference counted object which contains a vector containing the
 * Scheme procedure to call (this indirection is required because the
 * Scheme procedure may be a MOVABLE object).  The parameters argc and
 * argv specify the arguments to pass to the Scheme procedure.  The
 * Scheme procedure receives these arguments as strings and must
 * return a string result or the value #f.
 */

char *tcltk_call ___P((___SCMOBJ vect, char **args),());

___HIDDEN int scheme_call_cmd
   ___P((ClientData client_data,
         Tcl_Interp *interp,
         int argc,
         const char **argv),
        (client_data,
         interp,
         argc,
         argv)
ClientData client_data;
Tcl_Interp *interp;
int argc;
const char **argv;)
{
  char *result = tcltk_call (___EXT(___data_rc) (___CAST(void*,client_data)),
                             ___CAST(char**,argv+1));

  /*
   * Propagate result to Tcl.
   */

  if (result == NULL)
    {
      Tcl_SetResult (interp,
                     "",
                     TCL_STATIC);
    }
  else
    {
      /*
       * The resulting C string was dynamically allocated by
       * Gambit's C interface.  We have to ensure it is
       * deallocated by a call to ___release_string by Tcl
       * when it no longer needs the string.
       */

      Tcl_SetResult (interp,
                     result,
                     ___CAST(Tcl_FreeProc*,___EXT(___release_string)));
    }

  return TCL_OK;
}

/*
 * The routine scheme_delete_cmd is called by Tcl when a Tcl command
 * bound to a Scheme procedure is being deleted.  The client_data
 * parameter points to a reference counted object which contains the
 * Scheme procedure.  This object needs to be released so that the
 * garbage collector can reclaim the Scheme procedure it contains.
 */

___HIDDEN void scheme_delete_cmd
   ___P((ClientData client_data),
        (client_data)
ClientData client_data;)
{
  ___EXT(___release_scmobj) (___EXT(___data_rc) (___CAST(void*,client_data)));
  ___EXT(___release_rc) (___CAST(void*,client_data));
}

c-declare-end
)

; Initialization/finalization of the Tcl/Tk interface.

(define ##tcltk-active? #f)

(define (##tcltk-setup)
  (if (##not ##tcltk-active?)
      (begin
        ((c-lambda (char-string) bool "tcltk_setup")
         (##car (##command-line)))
        (set! ##tcltk-active? #t))))

(define (##tcltk-cleanup)
  (if ##tcltk-active?
      (begin
        (set! ##tcltk-active? #f)
        ((c-lambda () void "tcltk_cleanup")))))

; (##tcltk-call vect args) is called by scheme_call_cmd when the
; Scheme procedure contained in "vect" is being called by Tcl with
; the list of arguments "args", which is a list of strings.

(c-define (##tcltk-call vect args)
          (scheme-object nonnull-char-string-list) char-string "tcltk_call" ""
  (let ((proc (##vector-ref vect 0)))
    (let ((result (##apply proc args)))
      (if (##string? result)
          result
          #f))))

; (##tcltk-unique-id) returns a new exact integer each time it is
; called.

(define ##tcltk-unique-id
  (let ((counter 0))
    (lambda ()
      (let loop ()
        (let* ((n counter)
               (n+1 (##+ n 1))) ; note: context switch is possible in ##+
          (declare (not interrupts-enabled))
          (if (##not (##eq? n counter)) ; update counter atomically
              (loop)
              (begin
                (set! counter n+1)
                n)))))))

; (##tcltk-export-procedure proc) defines a new Tcl command that
; invokes the Scheme procedure "proc" (a procedure which accepts
; string arguments and returns a string result or #f).
; ##tcltk-export-procedure returns the name of the Tcl command (which
; is of the form "_pN", where N is an integer).

(define (##tcltk-export-procedure proc)
  (let ((id (##tcltk-unique-id)))
    (let ((name (##string-append "_p" (##number->string id 10))))
      (if (##tcltk-define-procedure name proc)
          name
          (error "this procedure could not be exported to Tcl:" proc)))))

; (##tcltk-remove-procedure name) removes a procedure that was
; exported to Tcl under the name "name".  This allows the Scheme
; runtime system to reclaim the Scheme procedure.

(define (##tcltk-remove-procedure name)
  (##tcltk-eval (##string-append "rename " name " {}")))

; The call (##tcltk-eval cmd) evaluates the Tcl command "cmd" and
; returns the evaluation result as a string.  If a Tcl evaluation
; error occurs, the error will be propagated to Scheme which will
; signal the error.  tcltk-eval only returns if the Tcl command was
; evaluated without error.

(define ##tcltk-eval
  (c-lambda (char-string) char-string "tcltk_eval"))

(c-define (##tcltk-eval-error msg) (char-string) void "tcltk_eval_error" ""
  (error (##string-append "[Tcl evaluation error] " msg))
  (##tcltk-eval-error msg)) ; never return

;------------------------------------------------------------------------------

; Definition of a Tcl command.
;
; The call (##tcltk-define-procedure name proc) defines the Tcl command
; "name" (a string) to be the Scheme procedure "proc" (a procedure
; which accepts string arguments and returns a string result or #f).
; ##tcltk-define-procedure returns #f if the command could not be
; defined.

(define ##tcltk-define-procedure
  (c-lambda (char-string scheme-object)
            scheme-object
            #<<c-lambda-end

  if (tcl_interp == NULL)
    ___result = ___FAL;
  else
    {
      void *cd = ___EXT(___alloc_rc) (0);

      /*
       * "cd" is the client data that will be passed to
       * scheme_call_cmd and scheme_delete_cmd.  It is a reference
       * counted object that contains a ___STILL Scheme vector
       * containing the Scheme procedure.  The routine
       * scheme_delete_cmd is responsible for releasing "cd" and the
       * Scheme vector.
       */

      if (cd == NULL)
        ___result = ___FAL;
      else
        {
          /*
           * Setup the client data.
           */

          ___SCMOBJ vect = ___EXT(___make_vector) (___ps, 1, ___FAL);

          if (___FIXNUMP(vect))
            {
              ___EXT(___release_rc) (cd);
              ___result = ___FAL;
            }
          else
            {
              ___FIELD(vect,0) = ___arg2;
              ___EXT(___set_data_rc) (cd, vect);

              /*
               * Create the Tcl command.
               */

              ___result = ___BOOLEAN (Tcl_CreateCommand
                                        (tcl_interp,
                                         ___arg1,
                                         scheme_call_cmd,
                                         ___CAST(ClientData,cd),
                                         scheme_delete_cmd)
                                      != NULL);
            }
        }
    }

c-lambda-end
))

;------------------------------------------------------------------------------

; Event loop.

;(define ##tcltk-main-loop
;  (c-lambda () void "Tk_MainLoop"))

(define ##tcltk-do-one-event
  (c-lambda ()
            scheme-object
            "___result = ___BOOLEAN (Tcl_DoOneEvent (TCL_DONT_WAIT));"))

(define ##tcltk-event-handling-mutex
  (##make-mutex 'tcltk-event-handling-mutex))

(define (tcltk#enable-event-handling)
  (mutex-unlock! ##tcltk-event-handling-mutex))

(define (tcltk#disable-event-handling)
  (mutex-lock! ##tcltk-event-handling-mutex))

(tcltk#disable-event-handling)

(define ##tcltk-event-loop-thread #f)
(define ##tcltk-exit-should-terminate? #f)

(define (tcltk#start-event-loop-thread)
  (if (##not ##tcltk-event-loop-thread)
      (set! ##tcltk-event-loop-thread
            (##parameterize1
             ##current-user-interrupt-handler
             (lambda () #f) ; prevent user interrupts
             (lambda ()
               (##thread-start!
                (##make-thread
                 (lambda ()
                   (let loop ()
                     (tcltk#disable-event-handling)
                     (tcltk#enable-event-handling)
                     (if ##tcltk-active?
                         (if (##tcltk-do-one-event) ; polling is portable...
                             (begin
                               (set! ##tcltk-exit-should-terminate? #t)
                               (loop))
                             (begin
                               (##thread-sleep! 0.03)
                               (loop)))))
(pretty-print 'exiting-event-loop)
)
                 'tcltk-event-loop
                 (##make-tgroup 'tcltk-event-loop #f))))))))

'
(define (tcltk#start-event-loop-thread)
  (let loop ()
    (if ##tcltk-active?
        (if (##tcltk-do-one-event) ; polling is portable...
            (begin
              (set! ##tcltk-exit-should-terminate? #t)
              (loop))
            (begin
              (##thread-sleep! 0.03)
              (loop))))))

(define (tcltk#join-event-loop-thread)
  (if ##tcltk-event-loop-thread
      (##thread-join! ##tcltk-event-loop-thread #f #f)))

(define (##tcltk-terminate)
  (pretty-print (list '(##tcltk-terminate) ##tcltk-exit-should-terminate?: ##tcltk-exit-should-terminate?))
  (set! ##tcltk-exit-should-terminate? #t)
  (##exit))

(define (##tcltk-exit)
  (pretty-print (list '(##tcltk-exit) ##tcltk-exit-should-terminate?: ##tcltk-exit-should-terminate?))
  (if ##tcltk-exit-should-terminate?
      (##tcltk-cleanup))
  (tcltk#enable-event-handling)
  (tcltk#join-event-loop-thread)
  (##tcltk-cleanup))

;------------------------------------------------------------------------------

; Widgets are represented with procedures.

(define tcltk#make-widget #f) ; prevent inlining of tcltk#make-widget
(set! tcltk#make-widget
  (lambda (name proc)
    (lambda args
      (if (and (##pair? args)
               (##eq? (##car args) ##tcltk-widget-code))
          name
          (proc name args)))))

(define tcltk#root-window
  (tcltk#make-widget "." ##tcltk-apply))

(define ##tcltk-widget-code
  (##closure-code tcltk#root-window))

(define (tcltk#widget? obj)
  (and (##procedure? obj)
       (##closure? obj)
       (##eq? (##closure-code obj) ##tcltk-widget-code)))

(define (tcltk#widget-name widget)
  (widget ##tcltk-widget-code))

;------------------------------------------------------------------------------

; Construction of Tcl command lines.

(define (##tcltk-cmd-line-begin)
  (##list '()))

(define (##tcltk-cmd-line-end cmd-line)
  (let ((lst (##car cmd-line)))
    (let loop1 ((n 0) (x lst))
      (if (##pair? x)
          (loop1 (##fx+ n (##string-length (##car x))) (##cdr x))
          (let ((result (##make-string n #\space)))
            (let loop2 ((k (##fx- n 1)) (x lst))
              (if (##pair? x)
                  (let ((s (##car x)))
                    (let loop3 ((i k) (j (##fx- (##string-length s) 1)))
                      (if (##fx< j 0)
                          (loop2 i (##cdr x))
                          (begin
                            (##string-set! result i (##string-ref s j))
                            (loop3 (##fx- i 1) (##fx- j 1))))))
                  result)))))))

(define (##tcltk-cmd-line-add-string! str cmd-line)
  (##set-car! cmd-line (##cons str (##car cmd-line))))

(define (##tcltk-cmd-line-add-substring! str start end cmd-line)
  (if (##fx< start end)
    (if (and (##fx= start 0) (##fx= end (##string-length str)))
        (##tcltk-cmd-line-add-string! str cmd-line)
        (##tcltk-cmd-line-add-string! (##substring str start end) cmd-line))))

(define (##tcltk-cmd-line-add-quoted-string! str cmd-line)

  (define hex-digits "0123456789abcdef")

  (let ((n (##string-length str)))
    (let loop ((i 0)
               (j 0)
               (force-quotes? (##fx= (##string-length str) 0))
               (quote-written? #f))

      (define (add-quoted-substring!)
        (if (##not quote-written?)
            (##tcltk-cmd-line-add-string! "\"" cmd-line))
        (if (and (##fx= i 0) (##fx= j n))
            (##tcltk-cmd-line-add-string! str cmd-line)
            (##tcltk-cmd-line-add-string! (##substring str i j) cmd-line)))

      (if (##fx< j n)
          (let ((c (##string-ref str j)))
            (cond ((##char=? c #\space)
                   (loop i
                         (##fx+ j 1)
                         #t
                         quote-written?))
                  ((or (##char=? c #\") ; characters which need escaping
                       (##char=? c #\\)
                       (##char=? c #\$)
                       (##char=? c #\[)
                       (##char=? c #\])
                       (##char=? c #\{)
                       (##char=? c #\}))
                   (add-quoted-substring!)
                   (##tcltk-cmd-line-add-string! "\\" cmd-line)
                   (loop j
                         (##fx+ j 1)
                         #t
                         #t))
                  (else
                   (let ((x (##char->integer c)))
                     (cond ((##fx< x 32) ; escape control characters
                            (add-quoted-substring!)
                            (##tcltk-cmd-line-add-string!
                             (##string
                              #\\
                              #\0
                              (##string-ref hex-digits (##fxquotient x 8))
                              (##string-ref hex-digits (##fxmodulo x 8)))
                             cmd-line)
                            (loop (##fx+ j 1)
                                  (##fx+ j 1)
                                  #t
                                  #t))
                           ((##fx< 255 x) ; escape non-ISO-8859-1 chars
                            (add-quoted-substring!)
                            (##tcltk-cmd-line-add-string!
                             (##string
                              #\\
                              #\u
                              (##string-ref
                               hex-digits
                               (##fxmodulo (##fxquotient x 4096) 16))
                              (##string-ref
                               hex-digits
                               (##fxmodulo (##fxquotient x 256) 16))
                              (##string-ref
                               hex-digits
                               (##fxmodulo (##fxquotient x 16) 16))
                              (##string-ref
                               hex-digits
                               (##fxmodulo x 16)))
                             cmd-line)
                            (loop (##fx+ j 1)
                                  (##fx+ j 1)
                                  #t
                                  #t))
                           (else
                            (loop i
                                  (##fx+ j 1)
                                  force-quotes?
                                  quote-written?)))))))
          (if (or force-quotes? quote-written?)
              (begin
                (add-quoted-substring!)
                (##tcltk-cmd-line-add-string! "\"" cmd-line))
              (##tcltk-cmd-line-add-string! str cmd-line))))))

(define (##tcltk-apply command args)
  (let ((cmd-line (##tcltk-cmd-line-begin)))

    (define (add-quoted-string str)
      (##tcltk-cmd-line-add-quoted-string! str cmd-line))

    (define (add-quoted obj)
      (cond ((##string? obj)
             (add-quoted-string obj))
            ((##symbol? obj)
             (add-quoted-string (##symbol->string obj)))
            ((##keyword? obj)
             (add-quoted-string (##string-append "-" (##keyword->string obj))))
            ((##real? obj)
             (add-quoted-string (##number->string obj 10)))
            ((tcltk#widget? obj)
             (add-quoted-string (tcltk#widget-name obj)))
            ((##procedure? obj)
             (add-quoted-string (##tcltk-export-procedure obj)))
            ((or (##null? obj) (##pair? obj))
             (##tcltk-cmd-line-add-string! "{" cmd-line)
             (add-quoted-list obj)
             (##tcltk-cmd-line-add-string! "}" cmd-line))
            ((##eq? obj #t)
             (add-quoted-string "true"))
            ((##eq? obj #f)
             (add-quoted-string "false"))
            (else
             (error "this argument is incompatible with Tcl:" obj))))

    (define (add-quoted-list lst)
      (let loop ((lst lst) (first? #t))
        (if (##pair? lst)
            (let ((arg (##car lst)))
              (if (##not first?)
                  (##tcltk-cmd-line-add-string! " " cmd-line))
              (add-quoted arg)
              (loop (##cdr lst) #f)))))

    (add-quoted command)
    (if (##pair? args)
        (begin
          (##tcltk-cmd-line-add-string! " " cmd-line)
          (add-quoted-list args)))
;    (display (##tcltk-cmd-line-end cmd-line))(newline)
    (##tcltk-eval (##tcltk-cmd-line-end cmd-line))))

(define (##tcltk-widget command path-name-or-parent args)
  (let ((path-name
         (cond ((tcltk#widget? path-name-or-parent)
                (let* ((id
                        (##tcltk-unique-id))
                       (suffix
                        (##string-append "._w" (##number->string id 10))))
                  (if (##eq? path-name-or-parent tcltk#root-window)
                      suffix
                      (##string-append
                       (tcltk#widget-name path-name-or-parent)
                       suffix))))
               ((##string? path-name-or-parent)
                path-name-or-parent)
               (else
                (error "widget path-name must be a string or the parent widget")))))
    (tcltk#make-widget
     (##tcltk-apply command (##cons path-name args))
     ##tcltk-apply)))

;------------------------------------------------------------------------------

(define (tcltk#set-variable! name val)
  (if (##string? name)
      (##tcltk-apply "set" (##list name val))
      (error "invalid Tcl variable name:" name)))

(define (tcltk#get-variable name)
  (if (##string? name)
      (##tcltk-apply "set" (##list name))
      (error "invalid Tcl variable name:" name)))

;------------------------------------------------------------------------------

(define (tcltk#define-procedure name proc)
  (if (##string? name)
      (if (##procedure? proc)
          (##tcltk-define-procedure name proc)
          (error "procedure expected"))
      (error "invalid Tcl procedure name:" name)))

(define (tcltk#export-procedure proc)
  (if (##procedure? proc)
      (##tcltk-export-procedure proc)
      (error "procedure expected")))

(define (tcltk#remove-procedure name)
  (if (##string? name)
      (##tcltk-remove-procedure name)
      (error "invalid Tcl procedure name:" name)))

;------------------------------------------------------------------------------

(define (tcltk#tcl command . args)
  (##tcltk-apply command args))

(define (tcltk#bell . args)
  (##tcltk-apply "bell" args))

(define (tcltk#bind . args)
  (##tcltk-apply "bind" args))

(define (tcltk#bindtags . args)
  (##tcltk-apply "bindtags" args))

(define (tcltk#bitmap . args)
  (##tcltk-apply "bitmap" args))

(define (tcltk#button path-name-or-parent . args)
  (##tcltk-widget "button" path-name-or-parent args))

(define (tcltk#canvas path-name-or-parent . args)
  (##tcltk-widget "canvas" path-name-or-parent args))

(define (tcltk#checkbutton path-name-or-parent . args)
  (##tcltk-widget "checkbutton" path-name-or-parent args))

(define (tcltk#clipboard . args)
  (##tcltk-apply "clipboard" args))

(define (tcltk#destroy . args)
  (##tcltk-apply "destroy" args))

(define (tcltk#entry path-name-or-parent . args)
  (##tcltk-widget "entry" path-name-or-parent args))

(define (tcltk#event . args)
  (##tcltk-apply "event" args))

(define (tcltk#focus . args)
  (##tcltk-apply "focus" args))

(define (tcltk#font . args)
  (##tcltk-apply "font" args))

(define (tcltk#frame path-name-or-parent . args)
  (##tcltk-widget "frame" path-name-or-parent args))

(define (tcltk#grab . args)
  (##tcltk-apply "grab" args))

(define (tcltk#grid . args)
  (##tcltk-apply "grid" args))

(define (tcltk#image . args)
  (##tcltk-apply "image" args))

(define (tcltk#label path-name-or-parent . args)
  (##tcltk-widget "label" path-name-or-parent args))

(define (tcltk#listbox path-name-or-parent . args)
  (##tcltk-widget "listbox" path-name-or-parent args))

(define (tcltk#lower . args)
  (##tcltk-apply "lower" args))

(define (tcltk#menu path-name-or-parent . args)
  (##tcltk-widget "menu" path-name-or-parent args))

(define (tcltk#menubutton path-name-or-parent . args)
  (##tcltk-widget "menubutton" path-name-or-parent args))

(define (tcltk#message path-name-or-parent . args)
  (##tcltk-widget "message" path-name-or-parent args))

(define (tcltk#option . args)
  (##tcltk-apply "option" args))

(define (tcltk#pack . args)
  (##tcltk-apply "pack" args))

(define (tcltk#photo . args)
  (##tcltk-apply "photo" args))

(define (tcltk#place . args)
  (##tcltk-apply "place" args))

(define (tcltk#radiobutton path-name-or-parent . args)
  (##tcltk-widget "radiobutton" path-name-or-parent args))

(define (tcltk#raise . args)
  (##tcltk-apply "raise" args))

(define (tcltk#scale path-name-or-parent . args)
  (##tcltk-widget "scale" path-name-or-parent args))

(define (tcltk#scrollbar path-name-or-parent . args)
  (##tcltk-widget "scrollbar" path-name-or-parent args))

(define (tcltk#selection . args)
  (##tcltk-apply "selection" args))

(define (tcltk#send . args)
  (##tcltk-apply "send" args))

(define (tcltk#text path-name-or-parent . args)
  (##tcltk-widget "text" path-name-or-parent args))

(define (tcltk#tk . args)
  (##tcltk-apply "tk" args))

(define (tcltk#tk_bisque . args)
  (##tcltk-apply "tk_bisque" args))

(define (tcltk#tk_chooseColor . args)
  (##tcltk-apply "tk_chooseColor" args))

(define (tcltk#tk_dialog . args)
  (##tcltk-apply "tk_dialog" args))

(define (tcltk#tk_focusFollowsMouse . args)
  (##tcltk-apply "tk_focusFollowsMouse" args))

(define (tcltk#tk_focusNext . args)
  (##tcltk-apply "tk_focusNext" args))

(define (tcltk#tk_focusPrev . args)
  (##tcltk-apply "tk_focusPrev" args))

(define (tcltk#tk_getOpenFile . args)
  (##tcltk-apply "tk_getOpenFile" args))

(define (tcltk#tk_getSaveFile . args)
  (##tcltk-apply "tk_getSaveFile" args))

(define (tcltk#tk_menuSetFocus . args)
  (##tcltk-apply "tk_menuSetFocus" args))

(define (tcltk#tk_messageBox . args)
  (##tcltk-apply "tk_messageBox" args))

(define (tcltk#tk_optionMenu . args)
  (##tcltk-apply "tk_optionMenu" args))

(define (tcltk#tk_popup . args)
  (##tcltk-apply "tk_popup" args))

(define (tcltk#tk_setPalette . args)
  (##tcltk-apply "tk_setPalette" args))

(define (tcltk#tk_textCopy . args)
  (##tcltk-apply "tk_textCopy" args))

(define (tcltk#tk_textCut . args)
  (##tcltk-apply "tk_textCut" args))

(define (tcltk#tk_textPaste . args)
  (##tcltk-apply "tk_textPaste" args))

(define (tcltk#tkerror . args)
  (##tcltk-apply "tkerror" args))

(define (tcltk#tkwait . args)
  (##tcltk-apply "tkwait" args))

(define (tcltk#toplevel path-name-or-parent . args)
  (##tcltk-widget "toplevel" path-name-or-parent args))

(define (tcltk#winfo . args)
  (##tcltk-apply "winfo" args))

(define (tcltk#wm . args)
  (##tcltk-apply "wm" args))

(define (tcltk#update . args)
  (##tcltk-apply "update" args))

;------------------------------------------------------------------------------

; Initialize Tcl/Tk.

(if (##tcltk-setup)

    (begin

      (##add-exit-job! ##tcltk-exit)

      (tcltk#bind root-window
                  "<Destroy>"
                  ##tcltk-terminate)

      (tcltk#bind 'all
                  "<F10>"
                  (lambda () ((##current-user-interrupt-handler))))

      (tcltk#start-event-loop-thread))

    (error "could not initialize Tcl/Tk"))

;==============================================================================
