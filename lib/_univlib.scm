;;;============================================================================

;;; File: "_univlib.scm"

;;; Copyright (c) 1994-2019 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;;; Parameter objects.

(##define-macro (macro-make-parameter-descr value filter)
  `(##vector ,value ,filter))

(##define-macro (macro-parameter-descr-value p)         `(macro-slot 0 ,p))
(##define-macro (macro-parameter-descr-value-set! p x)  `(macro-slot 0 ,p ,x))
(##define-macro (macro-parameter-descr-filter p)        `(macro-slot 1 ,p))
(##define-macro (macro-parameter-descr-filter-set! p x) `(macro-slot 1 ,p ,x))

(define-prim (##make-parameter
              init
              #!optional
              (f (macro-absent-obj)))
  (let ((filter
         (if (##eq? f (macro-absent-obj))
             (lambda (x) x)
             f)))
    (macro-check-procedure filter 2 (make-parameter init f)
      (let ((descr
             (macro-make-parameter-descr (filter init) filter)))
        (letrec ((param
                  (lambda (#!optional (new-val (macro-absent-obj)))
                    (if (##eq? new-val (macro-absent-obj))
                        (##dynamic-ref param)
                        (##dynamic-set!
                         param
                         ((macro-parameter-descr-filter descr) new-val))))))
          param)))))

(define-prim (make-parameter init #!optional (f (macro-absent-obj)))
  (macro-force-vars (f)
    (##make-parameter init f)))

(define-prim (##parameter? obj)
  (##declare (not interrupts-enabled))
  (and (##procedure? obj)
;;;;;       (##closure? obj)
       (##eq? (##closure-code obj)
              (##closure-code ##current-exception-handler))))

(##define-macro (macro-parameter-descr param)
  `(##closure-ref ,param 1))

(define-prim (##parameterize1 param val thunk)
  (##declare (not interrupts-enabled))
  (macro-check-procedure param 1 (##parameterize1 param val thunk)
    (macro-check-procedure thunk 3 (##parameterize1 param val thunk)
      (if (##parameter? param)
          (##dynamic-let
           param
           ((macro-parameter-descr-filter (macro-parameter-descr param)) val)
           thunk)
          (let ((save (param)))
            (##dynamic-wind
             (lambda () ;; before
               (param val))
             thunk
             (lambda () ;; after
               (param save))))))))

(define-prim (##dynamic-ref param)
  (let ((descr (macro-parameter-descr param)))
    (let ((x (##assq descr (macro-thread-denv (##current-thread)))))
      (if x
          (##cdr x)
          (macro-parameter-descr-value descr)))))

(define-prim (##dynamic-set! param val)
  (let ((descr (macro-parameter-descr param)))
    (let ((x (##assq descr (macro-thread-denv (##current-thread)))))
      (if x
          (##set-cdr! x val)
          (macro-parameter-descr-value-set! descr val)))))

(define-prim (##dynamic-let param val thunk)
  (##dynamic-env-bind
   (##cons (##cons (macro-parameter-descr param) val)
           (macro-thread-denv (##current-thread)))
   thunk))

(define-prim (##dynamic-env-bind denv thunk)
  (##declare (not interrupts-enabled))
  (let* ((ct (##current-thread))
         (save (macro-thread-denv ct)))
    (macro-thread-denv-set! ct denv)
    (let ((results (thunk)))
      (macro-thread-denv-set! (##current-thread) save)
      results)))

;;;----------------------------------------------------------------------------

;; User accessible primitives for exception handling.

(define-prim (with-exception-handler handler thunk)
  (macro-force-vars (handler thunk)
    (macro-check-procedure handler 1 (with-exception-handler handler thunk)
      (macro-check-procedure thunk 2 (with-exception-handler handler thunk)
        (##dynamic-let
         ##current-exception-handler
         handler
         thunk)))))

(define-prim (##with-exception-catcher catcher thunk)
  (##continuation-capture
   (lambda (cont)
     (##dynamic-let
      ##current-exception-handler
      (lambda (exc)
;;        (##continuation-graft cont catcher exc))
        (##continuation-graft-no-winding cont catcher exc))
      thunk))))

(define-prim (with-exception-catcher catcher thunk)
  (macro-force-vars (catcher thunk)
    (macro-check-procedure catcher 1 (with-exception-catcher catcher thunk)
      (macro-check-procedure thunk 2 (with-exception-catcher catcher thunk)
        (##with-exception-catcher catcher thunk)))))

(define ##current-exception-handler
  (##make-parameter
   (lambda (exc)
     (##thread-end-with-uncaught-exception! exc))
   (lambda (val)
     (macro-check-procedure val 1 (##current-exception-handler val)
       val))))

(define current-exception-handler
  ##current-exception-handler)

(##define-macro (macro-current-exception-handler)
  `(##current-exception-handler))

(define-prim (##raise obj)
  (macro-raise obj))

(define-prim (raise obj)
  (macro-raise obj))

(define-prim (##abort obj)
  (macro-abort obj))

(define-prim (abort obj)
  (macro-abort obj))

;;;----------------------------------------------------------------------------

(define-fail-check-type string-or-nonnegative-fixnum
  'string-or-nonnegative-fixnum)

;;;----------------------------------------------------------------------------

(define-fail-check-type box
  'box)

(define-prim (##box? obj))

(define-prim (box? obj)
  (macro-force-vars (obj)
    (##box? obj)))

(define-prim (##box obj))

(define-prim (box obj)
  (##box obj))

(define-prim (##unbox box))

(define-prim (unbox box)
  (macro-force-vars (box)
    (macro-check-box box 1 (unbox box)
      (##unbox box))))

(define-prim (##set-box! box val))

(define-prim (set-box! box val)
  (macro-force-vars (box)
    (macro-check-box box 1 (set-box! box val)
      (begin
        (##set-box! box val)
        (##void)))))

;;;----------------------------------------------------------------------------

(define-fail-check-type continuation 'continuation
  ##continuation?)

(define-prim (##call-with-current-continuation
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)

  (define (reify-continuation cont)
    (lambda (val)
      (##continuation-return-no-winding cont val)))

  (cond ((##eq? lift1 (macro-absent-obj))
         (##continuation-capture
          (lambda (cont)
            (receiver (reify-continuation cont)))))
        ((##eq? lift2 (macro-absent-obj))
         (##continuation-capture
          (lambda (cont lift1)
            (receiver (reify-continuation cont) lift1))
          lift1))
        ((##eq? lift3 (macro-absent-obj))
         (##continuation-capture
          (lambda (cont lift1 lift2)
            (receiver (reify-continuation cont) lift1 lift2))
          lift1
          lift2))
        ((##null? others)
         (##continuation-capture
          (lambda (cont lift1 lift2 lift3)
            (receiver (reify-continuation cont) lift1 lift2 lift3))
          lift1
          lift2
          lift3))
        (else
         (let ((lifts
                (##cons lift1
                        (##cons lift2
                                (##cons lift3
                                        others)))))
           (##continuation-capture
            (lambda (cont)
              (##apply
               receiver
               (##cons (reify-continuation cont) lifts))))))))

(define-prim (call-with-current-continuation
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)
  (macro-force-vars (receiver)
    (macro-check-procedure
     receiver
     1
     (call-with-current-continuation receiver lift1 lift2 lift3 . others)
     (cond ((##eq? lift1 (macro-absent-obj))
            (##call-with-current-continuation receiver))
           ((##eq? lift2 (macro-absent-obj))
            (##call-with-current-continuation receiver lift1))
           ((##eq? lift3 (macro-absent-obj))
            (##call-with-current-continuation receiver lift1 lift2))
           ((##null? others)
            (##call-with-current-continuation receiver lift1 lift2 lift3))
           (else
            (##apply
             ##call-with-current-continuation
             (##cons receiver
                     (##cons lift1
                             (##cons lift2
                                     (##cons lift3
                                             others))))))))))

(define call/cc
  call-with-current-continuation)

(define-prim (##continuation-capture-aux receiver lift1 lift2 lift3 others)
  (##declare (not interrupts-enabled))
  (cond ((##eq? lift1 (macro-absent-obj))
         (##continuation-capture receiver))
        ((##eq? lift2 (macro-absent-obj))
         (##continuation-capture receiver lift1))
        ((##eq? lift3 (macro-absent-obj))
         (##continuation-capture receiver lift1 lift2))
        ((##null? others)
         (##continuation-capture receiver lift1 lift2 lift3))
        (else
         (let ((lifts
                (##cons lift1
                        (##cons lift2
                                (##cons lift3
                                        others)))))
           (##continuation-capture
            (lambda (cont)
              (##apply receiver (##cons cont lifts))))))))

(define-prim (##continuation-capture
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)
  (##continuation-capture-aux receiver lift1 lift2 lift3 others))

(define-prim (continuation-capture
              receiver
              #!optional
              (lift1 (macro-absent-obj))
              (lift2 (macro-absent-obj))
              (lift3 (macro-absent-obj))
              #!rest
              others)
  (macro-check-procedure receiver 1 (continuation-capture receiver lift1 lift2 lift3 . others)
    (##continuation-capture-aux receiver lift1 lift2 lift3 others)))

(define-prim (##continuation-graft-no-winding
              cont
              proc
              #!optional
              (arg1 (macro-absent-obj))
              (arg2 (macro-absent-obj))
              (arg3 (macro-absent-obj))
              #!rest
              others)
  (##declare (not interrupts-enabled) (not inline))
  (cond ((##eq? arg1 (macro-absent-obj))
         (##continuation-graft-no-winding cont proc))
        ((##eq? arg2 (macro-absent-obj))
         (##continuation-graft-no-winding cont proc arg1))
        ((##eq? arg3 (macro-absent-obj))
         (##continuation-graft-no-winding cont proc arg1 arg2))
        ((##null? others)
         (##continuation-graft-no-winding cont proc arg1 arg2 arg3))
        (else
         (let ((args
                (##cons arg1
                        (##cons arg2
                                (##cons arg3
                                        others)))))
           (##continuation-graft-no-winding cont ##apply proc args)))))

(define-prim ##continuation-return-no-winding
  (##first-argument
   (lambda (cont results)
     (##declare (not interrupts-enabled))
     (##continuation-return-no-winding cont results))))

(define-prim (##continuation-graft
              cont
              proc
              #!optional
              (arg1 (macro-absent-obj))
              (arg2 (macro-absent-obj))
              (arg3 (macro-absent-obj))
              #!rest
              others)
  (##continuation-graft-no-winding cont proc arg1 arg2 arg3 others))

(define-prim (continuation-graft
              cont
              proc
              #!optional
              (arg1 (macro-absent-obj))
              (arg2 (macro-absent-obj))
              (arg3 (macro-absent-obj))
              #!rest
              others)
  (macro-check-continuation cont 1 (continuation-graft cont proc arg1 arg2 arg3 . others)
    (macro-check-procedure proc 2 (continuation-graft cont proc arg1 arg2 arg3 . others)
      (##continuation-graft-no-winding cont proc arg1 arg2 arg3 others))))

(define-prim (##continuation-return
              cont
              #!optional
              (val1 (macro-absent-obj))
              (val2 (macro-absent-obj))
              (val3 (macro-absent-obj))
              #!rest
              others)
  (##continuation-return-no-winding cont val1 val2 val3 others))

(define-prim (continuation-return
              cont
              #!optional
              (val1 (macro-absent-obj))
              (val2 (macro-absent-obj))
              (val3 (macro-absent-obj))
              #!rest
              others)
  (macro-check-continuation cont 1 (continuation-return cont val1 val2 val3 . others)
    (##continuation-return-no-winding cont val1 val2 val3 others)))

(define-prim (##continuation-creator cont)
  (and cont
       (##continuation-parent cont)))

(define-prim (##continuation-parent cont)
  (##subprocedure-parent (##continuation-ret cont)))

;;;----------------------------------------------------------------------------

(define-prim (apply proc arg1 . other-args)

  (define (build-arg-list i arg other-args)

    (define (copy-proper-list lst)
      (macro-force-vars (lst)
        (if (##pair? lst)
          (let ((tail (copy-proper-list (##cdr lst))))
            (macro-if-checks
              (if (##fixnum? tail)
                tail
                (##cons (##car lst) tail))
              (##cons (##car lst) tail)))
          (macro-if-checks
            (if (##null? lst)
              '()
              i) ;; error: list expected
            '()))))

    (define (check-proper-list lst)
      (macro-if-checks
        ;; This procedure may get into an infinite loop if another thread
        ;; mutates "lst" (if lst1 and lst2 each point to disconnected cycles).
        (let loop ((lst1 lst) (lst2 lst))
          (macro-force-vars (lst1)
            (if (##not (##pair? lst1))
                (if (##null? lst1)
                    lst
                    i)
                (let ((lst1 (##cdr lst1)))
                  (macro-force-vars (lst1 lst2)
                    (cond ((##eq? lst1 lst2)
                           i)
                          ((##not (##pair? lst2))
                          ;; this case is possible if other threads mutate the list
                          (if (##null? lst2)
                              lst
                              i))
                          ((##pair? lst1)
                           (loop (##cdr lst1) (##cdr lst2)))
                          (else
                           (if (##null? lst1)
                               lst
                               i))))))))
        lst))

    (if (##pair? other-args)
      (let ((tail
             (build-arg-list (##fx+ i 1)
                             (##car other-args)
                             (##cdr other-args))))
        (macro-if-checks
          (if (##fixnum? tail)
            tail
            (##cons arg tail))
          (##cons arg tail)))
      (macro-if-auto-forcing
        (copy-proper-list arg)
        (check-proper-list arg))))

  (macro-force-vars (proc)
    (macro-check-procedure proc 1 (apply proc arg1 . other-args)
      (let ((lst (build-arg-list 2 arg1 other-args)))
        (macro-if-checks
          (if (##fixnum? lst)
            (macro-fail-check-list lst (apply proc arg1 . other-args))
            (##apply proc lst))
          (##apply proc lst))))))

(define-prim (##apply proc lst1)
  (##declare (not interrupts-enabled))
  (if (##pair? lst1)
      (let ((lst2 (##cdr lst1)))
        (if (##pair? lst2)
            (let ((lst3 (##cdr lst2)))
              (if (##pair? lst3)
                  (let ((lst4 (##cdr lst3)))
                    (if (##pair? lst4)
                        (let ((lst5 (##cdr lst4)))
                          (if (##pair? lst5)
                              (let ((lst6 (##cdr lst5)))
                                (if (##pair? lst6)
                                    (error "##apply with more than 5 parameters")
                                    (proc (##car lst1) (##car lst2) (##car lst3) (##car lst4) (##car lst5))))
                              (proc (##car lst1) (##car lst2) (##car lst3) (##car lst4))))
                        (proc (##car lst1) (##car lst2) (##car lst3))))
                  (proc (##car lst1) (##car lst2))))
            (proc (##car lst1))))
      (proc)))

;;;----------------------------------------------------------------------------

(define-prim (##exit-with-err-code-no-cleanup err-code)
  (##exit-process (##fx- err-code 1)))

(define-prim (##exit-cleanup)
  #f)

(define-prim (##exit-with-err-code err-code)
  (##exit-cleanup)
  (##exit-with-err-code-no-cleanup err-code))

(define-prim (##exit #!optional (status (macro-EXIT-CODE-OK)))
  (##exit-with-err-code (##fx+ status 1)))

(define-prim (##exit-set! x)
  (set! ##exit x))

(define-prim (##exit-abruptly)
  (##exit (macro-EXIT-CODE-SOFTWARE)))

(define-prim (##exit-with-exception exc)
  (##exit-abruptly))

(define-prim (exit #!optional (status (macro-absent-obj)))
  (if (##eq? status (macro-absent-obj))
      (##exit)
      (macro-force-vars (status)
        (macro-check-exact-unsigned-int8 status 1 (exit status)
          (##exit status)))))

;;;----------------------------------------------------------------------------

(define ##min-fixnum -536870912)
(define ##max-fixnum 536870911)
(define ##fixnum-width 30)
(define ##fixnum-width-neg -30)
(define ##bignum.adigit-width 14)
(define ##bignum.mdigit-width 14)
(define ##max-char 65535)

(define-prim (##get-standard-level) 0)

(define-prim (##global-var? sym) #f)

(define (##procedure-name proc)
  ;; temporary hack to give a name at least related to proc
  (##subprocedure-parent-name
   (if (##closure? proc) (##closure-code proc) proc)))

;;;----------------------------------------------------------------------------

;;; Implementation of blocked thread queues.

(define-rbtree
 implement-btq
 macro-btq-init!
 macro-thread->btq
 ##btq-insert!
 ##btq-remove!
 ##btq-reposition!
 macro-btq-singleton?
 macro-btq-color
 macro-btq-color-set!
 macro-btq-parent
 macro-btq-parent-set!
 macro-btq-left
 macro-btq-left-set!
 macro-btq-right
 macro-btq-right-set!
 macro-thread-higher-prio?
 #f
 #f
 macro-btq-leftmost
 macro-btq-leftmost-set!
 #f
 #f
 #f
 #f
)

(implement-btq)

(define-prim (##make-mutex name)
  (##declare (not interrupts-enabled))
  (macro-make-mutex name))

(define-prim (##make-condvar name)
  (##declare (not interrupts-enabled))
  (macro-make-condvar name))

(define-prim (##mutex-lock-out-of-line! mutex absrel-timeout owner)
  #f)

(define-prim (##mutex-unlock-out-of-line! mutex)
  #f)

(##define-macro (macro-mutex-unlocked-not-abandoned-and-not-multiprocessor? mutex)
  #t)

(##define-macro (macro-mutex-lock! mutex absrel-timeout owner)
  `(##mutex-lock-out-of-line! ,mutex ,absrel-timeout ,owner))

(##define-macro (macro-mutex-lock-anonymously! mutex absrel-timeout)
  #t)

(##define-macro (macro-mutex-unlock! mutex)
  `(##mutex-unlock-out-of-line! ,mutex))

(##define-macro (macro-mutex-unlock-no-reschedule! mutex)
  `(##void))

(define-prim (mutex-lock! mutex)
  (macro-mutex-lock! mutex #f (macro-current-thread)))

;;;----------------------------------------------------------------------------

(##include "_kernel.scm")
(##include "_system.scm")
(##include "_num.scm")
(##include "_std.scm")
(##include "_eval.scm")
(##define-macro (##return? obj) #f);;TODO: remove after bootstrap
(##include "_io.scm")
;;(##include "_nonstd.scm")
;;(##include "_thread.scm")
;;(##include "_repl.scm")

;;;----------------------------------------------------------------------------

;; Access to command line arguments.

(define-prim (##command-line)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration
     "
      var g_argv;
      if (Object.prototype.hasOwnProperty.call(function () {return this;}(),'process'))
        g_argv = process.argv.slice(1);
      else
        g_argv = arguments;
     ")
    (##vector->list (##inline-host-expression "g_host2scm(g_argv)")))

   ((python)
    (##vector->list (##inline-host-expression "g_host2scm(sys.argv)")))

   (else
    '())))

(define ##processed-command-line
  (##command-line))

(define-prim (##processed-command-line-set! x)
  (set! ##processed-command-line x))

(define-prim (command-line)
  ##processed-command-line)

;;;----------------------------------------------------------------------------

;; Dummy definitions to avoid "undefined global variable" warnings

(define-prim (##absrel-timeout->timeout absrel-timeout)
  (error "##absrel-timeout->timeout not implemented yet"))

(define ##current-directory (##make-parameter "." (lambda (x) x)))
(define ##current-input-port (##make-parameter ##stdin-port (lambda (x) x)))
(define ##current-output-port (##make-parameter ##stdout-port (lambda (x) x)))

(define-prim (pp
              obj
              #!optional
              (port (macro-absent-obj)))
  (macro-force-vars (obj port)
    (let ((p
           (if (##eq? port (macro-absent-obj))
               (##current-output-port)
               port)))
      (macro-check-output-port p 2 (pp obj p)
        (##pretty-print obj p)))))

(define-prim (##current-time-point)
  (error "##current-time-point not implemented yet"))

(define-prim (##dynamic-wind before thunk after)
  (error "##dynamic-wind not implemented yet"))

(define-prim (##explode-continuation cont)
  (error "##explode-continuation not implemented yet"))

(define-prim (##explode-frame frame)
  (error "##explode-frame not implemented yet"))

(define-prim (##fail-check-absrel-time-or-false . rest)
  (error "##fail-check-absrel-time-or-false not implemented yet"))

(define-prim (##file-info-aux path #!optional (chase? (macro-absent-obj)))
  (error "##file-info-aux not implemented yet"))

(define-prim (##foreign-address f)
  (error "##foreign-address not implemented yet"))

(define-prim (##get-current-time! floats i)
  (error "##get-current-time! not implemented yet"))

(define-prim (##mutex-signal-and-condvar-wait! mutex condvar timeout)
  (error "##mutex-signal-and-condvar-wait! not implemented yet"))

(define ##err-code-EAGAIN -35)
(define ##err-code-EINTR   -4)
(define ##err-code-ENOENT  -1)

(macro-case-target
 ((js)

(##inline-host-declaration
"
var fs = require('fs');

var g_CONDVAR_NAME              = 10;

var g_PORT_MUTEX                = 1;
var g_PORT_RKIND                = 2;
var g_PORT_WKIND                = 3;
var g_PORT_NAME                 = 4;
var g_PORT_WAIT                 = 5;
var g_PORT_CLOSE                = 6;
var g_PORT_ROPTIONS             = 7;
var g_PORT_RTIMEOUT             = 8;
var g_PORT_RTIMEOUT_THUNK       = 9;
var g_PORT_SET_RTIMEOUT         = 10;
var g_PORT_WOPTIONS             = 11;
var g_PORT_WTIMEOUT             = 12;
var g_PORT_WTIMEOUT_THUNK       = 13;
var g_PORT_SET_WTIMEOUT         = 14;
var g_PORT_IO_EXCEPTION_HANDLER = 15;

var g_PORT_OBJECT_READ_DATUM    = 16;
var g_PORT_OBJECT_WRITE_DATUM   = 17;
var g_PORT_OBJECT_NEWLINE       = 18;
var g_PORT_OBJECT_FORCE_OUTPUT  = 19;

var g_PORT_OBJECT_OTHER1        = 20;
var g_PORT_OBJECT_OTHER2        = 21;
var g_PORT_OBJECT_OTHER3        = 22;

var g_PORT_CHAR_RBUF            = 20;
var g_PORT_CHAR_RLO             = 21;
var g_PORT_CHAR_RHI             = 22;
var g_PORT_CHAR_RCHARS          = 23;
var g_PORT_CHAR_RLINES          = 24;
var g_PORT_CHAR_RCURLINE        = 25;
var g_PORT_CHAR_RBUF_FILL       = 26;
var g_PORT_CHAR_PEEK_EOFP       = 27;

var g_PORT_CHAR_WBUF            = 28;
var g_PORT_CHAR_WLO             = 29;
var g_PORT_CHAR_WHI             = 30;
var g_PORT_CHAR_WCHARS          = 31;
var g_PORT_CHAR_WLINES          = 32;
var g_PORT_CHAR_WCURLINE        = 33;
var g_PORT_CHAR_WBUF_DRAIN      = 34;
var g_PORT_INPUT_READTABLE      = 35;
var g_PORT_OUTPUT_READTABLE     = 36;
var g_PORT_OUTPUT_WIDTH         = 37;

var g_PORT_CHAR_OTHER1          = 38;
var g_PORT_CHAR_OTHER2          = 39;
var g_PORT_CHAR_OTHER3          = 40;
var g_PORT_CHAR_OTHER4          = 41;
var g_PORT_CHAR_OTHER5          = 42;

var g_PORT_BYTE_RBUF            = 38;
var g_PORT_BYTE_RLO             = 39;
var g_PORT_BYTE_RHI             = 40;
var g_PORT_BYTE_RBUF_FILL       = 41;

var g_PORT_BYTE_WBUF            = 42;
var g_PORT_BYTE_WLO             = 43;
var g_PORT_BYTE_WHI             = 44;
var g_PORT_BYTE_WBUF_DRAIN      = 45;

var g_PORT_BYTE_OTHER1          = 46;
var g_PORT_BYTE_OTHER2          = 47;

var g_PORT_RDEVICE_CONDVAR      = 46;
var g_PORT_WDEVICE_CONDVAR      = 47;

var g_PORT_DEVICE_OTHER1        = 48;
var g_PORT_DEVICE_OTHER2        = 49;

function g_os_encode_errno(code) {
  switch (code) {
    case 'EPERM':   return -1;
    case 'ENOENT':  return -2;
    case 'EINTR':   return -4;
    case 'EIO':     return -5;
    case 'EBADF':   return -9;
    case 'EACCESS': return -13;
    case 'EEXIST':  return -17;
    case 'EAGAIN':  return -35;
  }
  return -9999;
}

function g_os_decode_errno(code) {
  switch (code) {
    case -1:  return 'EPERM (Operation not permitted)';
    case -2:  return 'ENOENT (No such file or directory)';
    case -4:  return 'EINTR (Interrupted system call)';
    case -5:  return 'EIO (Input/output error)';
    case -9:  return 'EBADF (Bad file descriptor)';
    case -13: return 'EACCESS (Permission denied)';
    case -17: return 'EEXIST (File exists)';
    case -35: return 'EAGAIN (Resource temporarily unavailable)';
  }
  return 'E??? (unknown error)';
}

function g_os_translate_flags(flags) {

  var result;

  switch ((flags >> 4) & 3)
    {
    default:
    case 1:
      result = fs.constants.O_RDONLY;
      break;
    case 2:
      result = fs.constants.O_WRONLY;
      break;
    case 3:
      result = fs.constants.O_RDWR;
      break;
    }

  if ((flags & (1 << 3)) != 0)
    result |= fs.constants.O_APPEND;

  switch ((flags >> 1) & 3)
    {
    default:
    case 0: break;
    case 1: result |= fs.constants.O_CREAT; break;
    case 2: result |= fs.constants.O_CREAT|fs.constants.O_EXCL; break;
    }

  if ((flags & 1) != 0)
    result |= fs.constants.O_TRUNC;

  return g_host2scm(result);
}

function G_Device(fd) {
  this.fd = fd;
  this.rbuf = new Uint8Array(1024);
  this.rlo = 1;
  this.rhi = 1; // 0 would mean EOF
  this.rdone = true;
}

var g_debug = false;

function g_os_device_kind(dev_scm) {

  var dev = dev_scm.val;

  if (g_debug)
    console.log('g_os_device_kind('+dev.fd+')  ***not fully implemented***');

  return g_host2scm(31); // file device
}

function g_os_device_stream_default_options(dev_scm) {

  var dev = dev_scm.val;

  if (g_debug)
    console.log('g_os_device_stream_default_options('+dev.fd+')  ***not fully implemented***');

  return g_host2scm(0);
}

function g_os_device_stream_options_set(dev_scm, options_scm) {

  var dev = dev_scm.val;
  var options = g_scm2host(options_scm);

  if (g_debug)
    console.log('g_os_device_stream_options_set('+dev.fd+','+options+')  ***not implemented***');

  return g_host2scm(-1);
}

function g_os_device_stream_open_predefined(index_scm, flags_scm) {

  var index = g_scm2host(index_scm);
  var flags = g_scm2host(flags_scm);

  if (g_debug)
    console.log('g_os_device_stream_open_predefined('+index+','+flags+')  ***not fully implemented***');

  var fd;

  switch (index) {
    case -1: fd = 0; break; // stdin
    case -2: fd = 1; break; // stdout
    case -3: fd = 2; break; // stderr
    case -4: fd = 1; break; // console
  }

  return new G_Foreign(new G_Device(fd), g_host2scm(false));
}

function g_os_device_stream_open_path(path_scm, flags_scm, mode_scm) {

  var path = g_scm2host(path_scm);
  var flags = g_scm2host(flags_scm);
  var mode = g_scm2host(mode_scm);

  if (g_debug)
    console.log('g_os_device_stream_open_path(\\''+path+'\\','+flags+','+mode+')  ***not fully implemented***');

  var fd;

  try {
    fd = fs.openSync(path, g_os_translate_flags(flags), mode);
  } catch (exn) {
    if (exn instanceof Error && exn.hasOwnProperty('code')) {
      return g_host2scm(g_os_encode_errno(exn.code));
    } else {
      throw exn;
    }
  }

  return new G_Foreign(new G_Device(fd), g_host2scm(false));
}

function g_os_device_stream_read(dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val; // condvar's name is the foreign object returned by g_os_device_stream_open_path
  var buffer = g_scm2host(buffer_scm);
  var lo = g_scm2host(lo_scm);
  var hi = g_scm2host(hi_scm);

  if (g_debug)
    console.log('g_os_device_stream_read('+dev.fd+',['+buffer+'],'+lo+','+hi+')  ***not fully implemented***');

  if (!dev.rdone) {
    // read request is in progress so must wait before issuing another request
    return g_host2scm(-35); // EAGAIN
  }

  if (dev.rhi === 0) {
    return g_host2scm(0); // 0 means EOF
  }

  var n = hi-lo;
  var have = dev.rhi-dev.rlo;

  if (have > 0) {

    if (n > have) n = have;

    buffer.set(dev.rbuf.subarray(dev.rlo, dev.rlo+n), lo);

    dev.rlo += n;

    return g_host2scm(n); // number of bytes transferred
  }

  // start an asynchronous read request

  dev.rdone = false;

  function callback(err, bytesRead, buffer) {
    dev.rlo = 0;
    dev.rhi = bytesRead; // if 0 this means EOF
    dev.rdone = true;
    g_scm_call(g_glo['##end-wait-for-io!'],[dev_condvar_scm]);
  }

  // read as many bytes as will fit in device's buffer

  fs.read(dev.fd, dev.rbuf, 0, dev.rbuf.length, null, callback);

  return g_host2scm(-35); // EAGAIN
}

function g_os_device_stream_write(dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;
  var buffer = g_scm2host(buffer_scm);
  var lo = g_scm2host(lo_scm);
  var hi = g_scm2host(hi_scm);

  if (g_debug)
    console.log('g_os_device_stream_write('+dev.fd+',['+buffer+'],'+lo+','+hi+')  ***not fully implemented***');

  var n;

  try {
    n = fs.writeSync(dev.fd, buffer, lo, hi-lo, null);
  } catch (exn) {
    if (exn instanceof Error && exn.hasOwnProperty('code')) {
      return g_host2scm(g_os_encode_errno(exn.code));
    } else {
      throw exn;
    }
  }

  return g_host2scm(n);
}

function g_os_device_close(dev_scm, direction_scm) {

  var dev = dev_scm.val;
  var direction = g_scm2host(direction_scm);

  if (g_debug)
    console.log('g_os_device_close('+dev.fd+','+direction+')  ***not fully implemented***');

  if ((direction & 1) != 0 ||  // DIRECTION_RD
      (direction & 2) != 0) {  // DIRECTION_WR
    try {
      fs.closeSync(dev.fd);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return g_host2scm(g_os_encode_errno(exn.code));
      } else {
        throw exn;
      }
    }
  }

  return g_host2scm(0); // no error
}

function g_os_device_force_output(dev_condvar_scm, level_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;
  var level = g_scm2host(level_scm);

  if (g_debug)
    console.log('g_os_device_force_output('+dev.fd+','+level+')  ***not fully implemented***');

  return g_host2scm(0); // no error
}

function g_os_device_stream_seek(dev_condvar_scm, pos_scm, whence_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;
  var pos = g_scm2host(pos_scm);
  var whence_scm = g_scm2host(whence_scm);

  if (g_debug)
    console.log('g_os_device_stream_seek('+dev.fd+','+pos+','+whence+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_stream_width(dev_condvar_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;

  if (g_debug)
    console.log('g_os_device_stream_width('+dev.fd+')  ***not fully implemented***');

  return g_host2scm(80);
}

function g_os_port_decode_chars(port_scm, want_scm, eof_scm) {

  var want = g_scm2host(want_scm);
  var eof = g_scm2host(eof_scm);

  if (g_debug)
    console.log('g_os_port_decode_chars('+port_scm+','+want+','+eof+')  ***not implemented***');

  var cbuf_scm = port_scm.slots[g_PORT_CHAR_RBUF];
  var chi = g_scm2host(port_scm.slots[g_PORT_CHAR_RHI]);
  var cend = cbuf_scm.codes.length;
  var bbuf = g_scm2host(port_scm.slots[g_PORT_BYTE_RBUF]);
  var blo = g_scm2host(port_scm.slots[g_PORT_BYTE_RLO]);
  var bhi = g_scm2host(port_scm.slots[g_PORT_BYTE_RHI]);
  var options = g_scm2host(port_scm.slots[g_PORT_ROPTIONS]);

  if (want != false)
    {
      var cend2 = chi + want;
      if (cend2 < cend)
        cend = cend2;
    }

  var cbuf_avail = cend - chi;
  var bbuf_avail = bhi - blo;

  while (cbuf_avail > 0 && bbuf_avail > 0) {
    cbuf_scm.codes[cend - cbuf_avail] = bbuf[bhi - bbuf_avail];
    bbuf_avail--;
    cbuf_avail--;
  }

  port_scm.slots[g_PORT_CHAR_RHI] = g_host2scm(cend - cbuf_avail);
  port_scm.slots[g_PORT_BYTE_RLO] = g_host2scm(bhi - bbuf_avail);
  port_scm.slots[g_PORT_ROPTIONS] = g_host2scm(options);

  return g_host2scm(0); // no error
}

function g_os_port_encode_chars(port_scm) {

  if (g_debug)
    console.log('g_os_port_encode_chars('+port_scm+')  ***not fully implemented***');

  var cbuf_scm = port_scm.slots[g_PORT_CHAR_WBUF];
  var clo = g_scm2host(port_scm.slots[g_PORT_CHAR_WLO]);
  var chi = g_scm2host(port_scm.slots[g_PORT_CHAR_WHI]);
  var bbuf = g_scm2host(port_scm.slots[g_PORT_BYTE_WBUF]);
  var bhi = g_scm2host(port_scm.slots[g_PORT_BYTE_WHI]);
  var bend = bbuf.length;
  var options = g_scm2host(port_scm.slots[g_PORT_WOPTIONS]);
  var cbuf_avail = chi - clo;
  var bbuf_avail = bend - bhi;

  while (cbuf_avail > 0 && bbuf_avail > 0) {
    bbuf[bend - bbuf_avail] = cbuf_scm.codes[chi - cbuf_avail];
    bbuf_avail--;
    cbuf_avail--;
  }

  port_scm.slots[g_PORT_CHAR_WLO] = g_host2scm(chi - cbuf_avail);
  port_scm.slots[g_PORT_BYTE_WHI] = g_host2scm(bend - bbuf_avail);
  port_scm.slots[g_PORT_WOPTIONS] = g_host2scm(options);

  return g_host2scm(0); // no error
}

function g_os_device_directory_open_path(path_scm, ignore_hidden_scm) {

  var path = g_scm2host(path_scm);
  var ignore_hidden = g_scm2host(ignore_hidden_scm);

  if (g_debug)
    console.log('g_os_device_directory_open_path(\\''+path+'\\','+ignore_hidden+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_directory_read(dev_condvar_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;

  if (g_debug)
    console.log('g_os_device_directory_read('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_event_queue_open(selector_scm) {

  var selector = g_scm2host(selector_scm);

  if (g_debug)
    console.log('g_os_device_event_queue_open('+selector+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_event_queue_read(dev_condvar_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;

  if (g_debug)
    console.log('g_os_device_event_queue_read('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_stream_open_process(path_and_args_scm, environment_scm, directory_scm, options_scm) {

  if (g_debug)
    console.log('g_os_device_stream_open_process(...)  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_process_pid(dev_scm) {

  var dev = dev_scm.val;

  if (g_debug)
    console.log('g_os_device_process_pid('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_process_status(dev_scm) {

  var dev = dev_scm.val;

  if (g_debug)
    console.log('g_os_device_process_status('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}
")

(define-prim (##os-device-close dev direction)
  (##inline-host-expression
   "g_os_device_close(@1@,@2@)"
   dev
   direction))

(define-prim (##os-device-directory-open-path path ignore-hidden)
  (##inline-host-expression
   "g_os_device_directory_open_path(@1@,@2@)"
   path
   ignore-hidden))

(define-prim (##os-device-directory-read dev-condvar)
  (##inline-host-expression
   "g_os_device_directory_read(@1@)"
   dev-condvar))

(define-prim (##os-device-event-queue-open selector)
  (##inline-host-expression
   "g_os_device_event_queue_open(@1@)"
   selector))

(define-prim (##os-device-event-queue-read dev-condvar)
  (##inline-host-expression
   "g_os_device_event_queue_read(@1@)"
   dev-condvar))

(define-prim (##os-device-force-output dev-condvar level)
  (##inline-host-expression
   "g_os_device_force_output(@1@,@2@)"
   dev-condvar
   level))

(define-prim (##os-device-kind dev)
  (##inline-host-expression
   "g_os_device_kind(@1@)"
   dev))

(define-prim (##os-device-stream-open-process path-and-args environment directory options)
  (##inline-host-expression
   "g_os_device_stream_open_process(@1@,@2@,@3@,@4@)"
   path-and-args
   environment
   directory
   options))

(define-prim (##os-device-process-pid dev)
  (##inline-host-expression
   "g_os_device_process_pid(@1@)"
   dev))

(define-prim (##os-device-process-status dev)
  (##inline-host-expression
   "g_os_device_process_status(@1@)"
   dev))

(define-prim (##os-device-stream-default-options dev)
  (##inline-host-expression
   "g_os_device_stream_default_options(@1@)"
   dev))

(define-prim (##os-device-stream-options-set! dev options)
  (##inline-host-expression
   "g_os_device_stream_options_set(@1@,@2@)"
   dev
   options))

(define-prim (##os-device-stream-open-predefined index flags)
  (##inline-host-expression
   "g_os_device_stream_open_predefined(@1@,@2@)"
   index
   flags))

(define-prim (##os-device-stream-open-path path flags mode)
  (##inline-host-expression
   "g_os_device_stream_open_path(@1@,@2@,@3@)"
   path
   flags
   mode))

(define-prim (##os-device-stream-read dev-condvar buffer lo hi)
  (##inline-host-expression
   "g_os_device_stream_read(@1@,@2@,@3@,@4@)"
   dev-condvar
   buffer
   lo
   hi))

(define-prim (##os-device-stream-write dev-condvar buffer lo hi)
  (##inline-host-expression
   "g_os_device_stream_write(@1@,@2@,@3@,@4@)"
   dev-condvar
   buffer
   lo
   hi))

(define-prim (##os-device-stream-seek dev-condvar pos whence)
  (##inline-host-expression
   "g_os_device_stream_seek(@1@,@2@,@3@)"
   dev-condvar
   pos
   whence))

(define-prim (##os-device-stream-width dev-condvar)
  (##inline-host-expression
   "g_os_device_stream_width(@1@)"
   dev-condvar))

(define-prim (##os-port-decode-chars! port want eof)
  (##inline-host-expression
   "g_os_port_decode_chars(@1@,@2@,@3@)"
   port
   want
   eof))

(define-prim (##os-port-encode-chars! port)
  (##inline-host-expression
   "g_os_port_encode_chars(@1@)"
   port))

(##open-all-predefined)

))

(define-prim (##os-device-tty-history dev)
  (error "##os-device-tty-history not implemented yet"))

(define-prim (##os-device-tty-history-set! dev history)
  (error "##os-device-tty-history-set! not implemented yet"))

(define-prim (##os-device-tty-history-max-length-set! dev max-length)
  (error "##os-device-tty-history-max-length-set! not implemented yet"))

(define-prim (##os-device-tty-mode-set! dev input-allow-special input-echo input-raw output-raw speed)
  (error "##os-device-tty-mode-set! not implemented yet"))

(define-prim (##os-device-tty-paren-balance-duration-set! dev duration)
  (error "##os-device-tty-paren-balance-duration-set! not implemented yet"))

(define-prim (##os-device-tty-text-attributes-set! dev input output)
  (error "##os-device-tty-text-attributes-set! not implemented yet"))

(define-prim (##os-device-tty-type-set! dev term-type emacs-bindings)
  (error "##os-device-tty-type-set! not implemented yet"))

(define-prim (##os-host-info host)
  (error "##os-host-info not implemented yet"))

(define-prim (##os-host-name)
  (error "##os-host-name not implemented yet"))

(define-prim (##os-load-object-file path modname)
  (error "##os-load-object-file not implemented yet"))

(define-prim (##os-network-info network)
  (error "##os-network-info not implemented yet"))

(define-prim (##os-protocol-info protocol)
  (error "##os-protocol-info not implemented yet"))

(define-prim (##os-service-info service protocol)
  (error "##os-service-info not implemented yet"))

(define-prim (##path-directory-end path)
  (error "##path-directory-end not implemented yet"))

(define-prim (##path-directory path)
  (error "##path-directory not implemented yet"))

(define-prim (##path-expand path #!optional (origin (macro-absent-obj)))
  (error "##path-expand not implemented yet"))

(define-prim (##path-extension path)
  (error "##path-extension not implemented yet"))

(define-prim (##path-normalize
              path
              #!optional
              (allow-relative? (macro-absent-obj))
              (origin (macro-absent-obj))
              (raise-os-exception? (macro-absent-obj)))
  (error "##path-normalize not implemented yet"))

(define-prim (##path-resolve path)
  path)

(define-prim (##path-strip-directory path)
  (error "##path-strip-directory not implemented yet"))

(define-prim (##path-unresolve path)
  path)

(define-prim (##raise-heap-overflow-exception)
  (error "##raise-heap-overflow-exception not implemented yet"))

(define-prim (##repl #!optional (write-reason #f) (reason #f) (toplevel? #f))
  (error "##repl not implemented yet"))

(define-prim (##string->address-and-port-number
              str
              default-address
              default-port-num)
  (error "##string->address-and-port-number not implemented yet"))

(define-prim (##thread-end-with-uncaught-exception! exc)
  (error "##thread-end-with-uncaught-exception! not implemented yet"))

(define-prim (##thread-sleep! absrel-timeout)
  (error "##thread-sleep! not implemented yet"))

(define-prim (##timeout->time absrel-timeout)
  (error "##timeout->time not implemented yet"))

(define ##the-processor (macro-make-processor 0))

(define (##current-processor)
  ##the-processor)

(define ##primordial-thread #f)

(define-prim (##make-root-thread
              thunk
              name
              tgroup
              input-port
              output-port)

  (##declare (not interrupts-enabled))

  (let* ((interrupt-mask
          0)
         (debugging-settings
          0)
         (local-binding
          (##cons ##current-directory
                  (macro-parameter-descr-value
                   (macro-parameter-descr ##current-directory)))))

    ;; these macros are defined to prevent the normal thread
    ;; inheritance mechanism when a root thread is created

    (##define-macro (macro-current-thread)
      `#f)

    (##define-macro (macro-thread-denv thread)
      `#f)

    (##define-macro (macro-denv-local denv)
      `(macro-make-env local-binding '() '()))

    (##define-macro (macro-denv-dynwind denv)
      `##initial-dynwind)

    (##define-macro (macro-denv-interrupt-mask denv)
      `interrupt-mask)

    (##define-macro (macro-denv-debugging-settings denv)
      `debugging-settings)

    (##define-macro (macro-denv-input-port denv)
      `(##cons ##current-input-port input-port))

    (##define-macro (macro-denv-output-port denv)
      `(##cons ##current-output-port output-port))

    (##define-macro (macro-thread-denv-cache1 thread)
      `local-binding)

    (##define-macro (macro-thread-denv-cache2 thread)
      `local-binding)

    (##define-macro (macro-thread-denv-cache3 thread)
      `local-binding)

    (##define-macro (macro-thread-floats thread)
      `#f)

    (##define-macro (macro-base-priority floats)
      `(macro-thread-root-base-priority))

    (##define-macro (macro-quantum floats)
      `(macro-thread-root-quantum))

    (##define-macro (macro-priority-boost floats)
      `(macro-thread-root-priority-boost))

    ;; create root thread

    (macro-make-thread thunk name tgroup)))

(##define-macro (macro-thread-init2! thread thunk name tgroup)
  `(let ((thread ,thread) (thunk ,thunk) (name ,name) (tgroup ,tgroup))

     (##declare (not interrupts-enabled))

     ;; these macros are defined to prevent the normal thread
     ;; inheritance mechanism when a root thread is created

     (##define-macro (macro-current-thread)
       `#f)

     (##define-macro (macro-thread-denv thread)
       `#f)

     (##define-macro (macro-denv-local denv)
       `(macro-make-env local-binding '() '()))

     (##define-macro (macro-denv-dynwind denv)
       `##initial-dynwind)

     (##define-macro (macro-denv-interrupt-mask denv)
       `interrupt-mask)

     (##define-macro (macro-denv-debugging-settings denv)
       `debugging-settings)

     (##define-macro (macro-denv-input-port denv)
       `(##cons ##current-input-port input-port))

     (##define-macro (macro-denv-output-port denv)
       `(##cons ##current-output-port output-port))

     (##define-macro (macro-thread-denv-cache1 thread)
       `local-binding)

     (##define-macro (macro-thread-denv-cache2 thread)
       `local-binding)

     (##define-macro (macro-thread-denv-cache3 thread)
       `local-binding)

     (##define-macro (macro-thread-floats thread)
       `#f)

     (##define-macro (macro-base-priority floats)
       `(macro-thread-root-base-priority))

     (##define-macro (macro-quantum floats)
       `(macro-thread-root-quantum))

     (##define-macro (macro-priority-boost floats)
       `(macro-thread-root-priority-boost))

     (let ((p (macro-current-thread)))
       (macro-thread-tgroup-set! thread tgroup)
       (macro-thread-floats-set! thread (macro-make-thread-floats p))
       (macro-thread-name-set! thread name)
       (macro-thread-end-condvar-set! thread (macro-make-thread-end-condvar p))
       (macro-thread-resume-thunk-set! thread
        (lambda ()
          (##thread-execute-and-end! thunk)))
       (macro-thread-cont-set! thread (macro-make-thread-cont p))
       (macro-thread-denv-set! thread (macro-make-thread-denv p))
       (macro-thread-denv-cache1-set! thread (macro-make-thread-denv-cache1 p))
       (macro-thread-denv-cache2-set! thread (macro-make-thread-denv-cache2 p))
       (macro-thread-denv-cache3-set! thread (macro-make-thread-denv-cache3 p))
       (macro-btq-deq-init! thread)
       (macro-tgroup-threads-deq-insert-at-tail! tgroup thread)
       thread)))

(define (##startup-threading!)

  (##declare (not interrupts-enabled))

  (let* ((primordial-tgroup
          (let ((tg
                 (macro-construct-tgroup
                  #f
                  #f
                  #f
                  #f
                  'primordial
                  #f
                  #f
                  #f
                  #f
                  #f
                  #f
                  #f
                  #f
                  #f
                  #f)))
            (macro-tgroup-threads-deq-init! tg)
            tg))
         (primordial-thread
          (macro-current-thread))
         (interrupt-mask
          0)
         (debugging-settings
          0)
         (local-binding
          (##cons ##current-directory
                  (macro-parameter-descr-value
                   (macro-parameter-descr ##current-directory))))
         (input-port
          ##stdin-port)
         (output-port
          ##stdout-port))

    (macro-thread-init2! primordial-thread #f 'primordial primordial-tgroup)

    (macro-thread-exception?-set! primordial-thread #f)

    (macro-processor-current-thread-set!
     (macro-current-processor)
     primordial-thread)

    (##btq-insert! (macro-current-processor) primordial-thread)

    (set! ##primordial-thread primordial-thread)

    ;; assign serial number 1 to primordial thread
    (##object->serial-number primordial-thread)

    (##void)))

(##startup-threading!)

(define-prim (##wait-for-io! condvar timeout)
  (##declare (not interrupts-enabled))
  (let ((result
         (macro-thread-save!
          (lambda (current-thread condvar timeout)
            (macro-thread-resume-thunk-set! current-thread ##thread-void-action!)
            (##btq-remove! current-thread)
            (##btq-insert! condvar current-thread)
            (macro-btq-deq-remove! condvar)
            (macro-btq-deq-insert-at-tail! (macro-current-processor) condvar)
            (##thread-schedule!))
          condvar
          timeout)))
    (if (##eq? result (##void))
        #t
        result)))

(define (##end-wait-for-io! dev-condvar)
  (##device-condvar-broadcast-no-reschedule! dev-condvar)
  (##thread-schedule!))

(define-prim (##thread-resume-execution!)
  (##declare (not interrupts-enabled))
  (let ((resume-thunk (macro-thread-resume-thunk (macro-current-thread))))
    (resume-thunk)))

(define-prim (##thread-schedule!)

  (##declare (not interrupts-enabled))

  (let ((current-processor
         (macro-current-processor)))

    ;; check if there are runnable threads

    (let ((next-thread
           (macro-btq-leftmost current-processor)))
      (if (##not (##eq? next-thread current-processor))

          ;; there are runnable threads, so continue executing the next
          ;; runnable thread

          (macro-thread-restore!
           next-thread
           ##thread-resume-execution!)

          ;; there are no runnable threads, so wait for event to
          ;; make some thread runnable

          (##exit-trampoline)))))

(define (##exit-trampoline)
  (##inline-host-statement "return null;")
  #f)

(define-prim (##condvar-signal-no-reschedule! condvar broadcast?)
  (##declare (not interrupts-enabled))
  (let loop ()
    (let ((leftmost (macro-btq-leftmost condvar)))
      (if (##not (##eq? leftmost condvar))
          (begin
            (macro-thread-resume-thunk-set!
             leftmost
             ##thread-signaled-condvar-action!)
            (##btq-remove! leftmost)
            (##btq-insert! (macro-current-processor) leftmost)
            (if broadcast?
                (loop)
                (##void)))
          (##void)))))

(define-prim (##thread-void-action!)
  (##declare (not interrupts-enabled))
  (##void))

(define-prim (##thread-signaled-condvar-action!)
  (##declare (not interrupts-enabled))
  #t)

(define-prim (##device-condvar-broadcast-no-reschedule! condvar)
  (##declare (not interrupts-enabled))
  (macro-btq-deq-remove! condvar)
  (macro-btq-deq-init! condvar)
  (##condvar-signal-no-reschedule! condvar #t))

(define-prim (error message . parameters)
  (println message)
  (##exit-abruptly))

(define-prim (void)
  (##void))

;;;----------------------------------------------------------------------------

(define ##current-readtable
  (##make-parameter
   ##main-readtable
   (lambda (val)
     (macro-check-readtable val 1 (##current-readtable val)
       val))))

(define current-readtable
  ##current-readtable)

;;;----------------------------------------------------------------------------

(##load-vm)

(##exit)

;;;============================================================================
