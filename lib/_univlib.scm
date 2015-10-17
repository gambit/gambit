;;;============================================================================

;;; File: "_univlib.scm"

;;; Copyright (c) 1994-2015 by Marc Feeley, All Rights Reserved.

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
 macro-btq-leftmost
 macro-btq-leftmost-set!
 #f
 #f
)

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
