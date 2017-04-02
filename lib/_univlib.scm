;;;============================================================================

;;; File: "_univlib.scm"

;;; Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved.

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

(define-prim (##parameterize param val thunk)
  (##declare (not interrupts-enabled))
  (macro-check-procedure param 1 (##parameterize param val thunk)
    (macro-check-procedure thunk 3 (##parameterize param val thunk)
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
      (macro-if-forces
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

(define-prim (##exit-abnormally)
  (##exit (macro-EXIT-CODE-SOFTWARE)))

(define-prim (##exit-with-exception exc)
  (##exit-abnormally))

;;;----------------------------------------------------------------------------

(define ##min-fixnum -536870912)
(define ##max-fixnum 536870911)
(define ##fixnum-width 29)
(define ##fixnum-width-neg -29)
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

(define-prim (##mutex-lock-out-of-line! mutex absrel-timeout new-owner)
  #f)

(define-prim (##condvar-signal-no-reschedule! condvar broadcast?)
  #f)

(##define-macro (macro-mutex-unlocked-not-abandoned-and-not-multiprocessor? mutex)
  #t)

(##define-macro (macro-mutex-lock! mutex absrel-timeout owner)
  #t)

(##define-macro (macro-mutex-lock-anonymously! mutex absrel-timeout)
  #t)

(##define-macro (macro-mutex-unlock! mutex)
  `(##void))

(##define-macro (macro-mutex-unlock-no-reschedule! mutex)
  `(##void))

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

   (else
    '())))

(define ##processed-command-line '())
(set! ##processed-command-line (##command-line))

(define-prim (command-line)
  ##processed-command-line)

;;;----------------------------------------------------------------------------

;; Dummy definitions to avoid "undefined global variable" warnings

(define-prim (##absrel-timeout->timeout absrel-timeout)
  (error "##absrel-timeout->timeout not implemented yet"))

(define-prim (##current-directory . rest)
  (error "##current-directory not implemented yet"))

(define-prim (##current-input-port . rest)
  (error "##current-input-port not implemented yet"))

(define-prim (##current-output-port . rest)
  (error "##current-output-port not implemented yet"))

(define-prim (##current-time-point)
  (error "##current-time-point not implemented yet"))

(define-prim (##dynamic-wind before thunk after)
  (error "##dynamic-wind not implemented yet"))

(define ##err-code-EAGAIN -1) ;; not implemented yet
(define ##err-code-EINTR  -2) ;; not implemented yet
(define ##err-code-ENOENT -3) ;; not implemented yet

(define-prim (##explode-continuation cont)
  (error "##explode-continuation not implemented yet"))

(define-prim (##explode-frame frame)
  (error "##explode-frame not implemented yet"))

(define-prim (##fail-check-absrel-time-or-false . rest)
  (error "##fail-check-absrel-time-or-false not implemented yet"))

(define-prim (##file-info path #!optional (chase? (macro-absent-obj)))
  (error "##file-info not implemented yet"))

(define-prim (##foreign-address f)
  (error "##foreign-address not implemented yet"))

(define-prim (##get-current-time! floats i)
  (error "##get-current-time! not implemented yet"))

(define-prim (##mutex-signal-and-condvar-wait! mutex condvar timeout)
  (error "##mutex-signal-and-condvar-wait! not implemented yet"))

(define-prim (##os-device-close . rest)
  (error "##os-device-close not implemented yet"))

(define-prim (##os-device-directory-open-path . rest)
  (error "##os-device-directory-open-path not implemented yet"))

(define-prim (##os-device-directory-read . rest)
  (error "##os-device-directory-read not implemented yet"))

(define-prim (##os-device-event-queue-open . rest)
  (error "##os-device-event-queue-open not implemented yet"))

(define-prim (##os-device-event-queue-read . rest)
  (error "##os-device-event-queue-read not implemented yet"))

(define-prim (##os-device-force-output . rest)
  (error "##os-device-force-output not implemented yet"))

(define-prim (##os-device-kind . rest)
  (error "##os-device-kind not implemented yet"))

(define-prim (##os-device-process-pid . rest)
  (error "##os-device-process-pid not implemented yet"))

(define-prim (##os-device-process-status . rest)
  (error "##os-device-process-status not implemented yet"))

(define-prim (##os-device-stream-default-options . rest)
  (error "##os-device-stream-default-options not implemented yet"))

(define-prim (##os-device-stream-open-path . rest)
  (error "##os-device-stream-open-path not implemented yet"))

(define-prim (##os-device-stream-open-predefined . rest)
  (error "##os-device-stream-open-predefined not implemented yet"))

(define-prim (##os-device-stream-open-process . rest)
  (error "##os-device-stream-open-process not implemented yet"))

(define-prim (##os-device-stream-options-set! . rest)
  (error "##os-device-stream-options-set! not implemented yet"))

(define-prim (##os-device-stream-read . rest)
  (error "##os-device-stream-read not implemented yet"))

(define-prim (##os-device-stream-seek . rest)
  (error "##os-device-stream-seek not implemented yet"))

(define-prim (##os-device-stream-width . rest)
  (error "##os-device-stream-width not implemented yet"))

(define-prim (##os-device-stream-write . rest)
  (error "##os-device-stream-write not implemented yet"))

(define-prim (##os-device-tty-history . rest)
  (error "##os-device-tty-history not implemented yet"))

(define-prim (##os-device-tty-history-set! . rest)
  (error "##os-device-tty-history-set! not implemented yet"))

(define-prim (##os-device-tty-history-max-length-set! . rest)
  (error "##os-device-tty-history-max-length-set! not implemented yet"))

(define-prim (##os-device-tty-history-max-length-set! . rest)
  (error "##os-device-tty-history-max-length-set! not implemented yet"))

(define-prim (##os-device-tty-history-set! . rest)
  (error "##os-device-tty-history-set! not implemented yet"))

(define-prim (##os-device-tty-mode-set! . rest)
  (error "##os-device-tty-mode-set! not implemented yet"))

(define-prim (##os-device-tty-paren-balance-duration-set! . rest)
  (error "##os-device-tty-paren-balance-duration-set! not implemented yet"))

(define-prim (##os-device-tty-text-attributes-set! . rest)
  (error "##os-device-tty-text-attributes-set! not implemented yet"))

(define-prim (##os-device-tty-type-set! . rest)
  (error "##os-device-tty-type-set! not implemented yet"))

(define-prim (##os-host-info . rest)
  (error "##os-host-info not implemented yet"))

(define-prim (##os-host-name . rest)
  (error "##os-host-name not implemented yet"))

(define-prim (##os-load-object-file . rest)
  (error "##os-load-object-file not implemented yet"))

(define-prim (##os-network-info . rest)
  (error "##os-network-info not implemented yet"))

(define-prim (##os-port-decode-chars! . rest)
  (error "##os-port-decode-chars! not implemented yet"))

(define-prim (##os-port-encode-chars! . rest)
  (error "##os-port-encode-chars! not implemented yet"))

(define-prim (##os-protocol-info . rest)
  (error "##os-protocol-info not implemented yet"))

(define-prim (##os-service-info . rest)
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
  (error "##path-resolve not implemented yet"))

(define-prim (##path-strip-directory path)
  (error "##path-strip-directory not implemented yet"))

(define-prim (##path-unresolve path)
  (error "##path-unresolve not implemented yet"))

(define-prim (##raise-heap-overflow-exception)
  (error "##raise-heap-overflow-exception not implemented yet"))

(define-prim (##raise-os-exception message code proc . args)
  (error "##raise-os-exception not implemented yet"))

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

(define-prim (##wait-for-io! condvar timeout)
  (error "##wait-for-io! not implemented yet"))

(define-prim (error message . parameters)
  (println message)
  (##exit-abnormally))

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

;;;============================================================================
