;;;============================================================================

;;; File: "js.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

;; Miscellaneous definitions needed at run time to support the
;; six.infix special form for JavaScript.

(##supply-module _six/js)

(##namespace ("_six/js#"))                ;; in _six/js#
(##include "~~lib/gambit/prim/prim#.scm") ;; map fx+ to ##fx+, etc
(##include "~~lib/_gambit#.scm")          ;; for macro-check-procedure,
                                          ;; macro-absent-obj, etc

(##include "js#.scm")

(declare (extended-bindings)) ;; ##fx+ is bound to fixnum addition, etc
(declare (not safe))          ;; claim code has no type errors
(declare (block))             ;; claim no global is assigned

;;;----------------------------------------------------------------------------

(macro-case-target

 ((js)

  ;; The ##host-define-function-and-call-dynamic procedure takes a
  ;; descriptor (box) and arguments and executes JavaScript code
  ;; specified by the descriptor.  The descriptor is a box containing
  ;; a string that evaluates to a JavaScript async function.  In this
  ;; state the string will be passed to the JavaScript eval function
  ;; to create a Scheme procedure that will be called with the
  ;; arguments to get a JavaScript promise whose result is waited for
  ;; by a call to ##wait-for-promise-result.  After this first
  ;; evaluation the Scheme procedure obtained is stored in the
  ;; descriptor to avoid calling the JavaScript eval function on each
  ;; call of ##host-define-function-and-call-dynamic with that
  ;; descriptor.

  (define (##host-define-function-and-call-dynamic descr . args)
    (##wait-for-promise-result
     (##apply (let ((f (##unbox descr)))
                (if (##string? f)
                    (let ((host-fn (##host-eval-dynamic f)))
                      (##set-box! descr host-fn)
                      host-fn)
                    f))
              args)))
  
  ;; The ##wait-for-promise-result takes a JavaScript promise and blocks
  ;; the execution of the current thread until the promise is fulfilled
  ;; or rejected.

  (define (##wait-for-promise-result promise)
    (let ((result-mutex (macro-make-mutex 'wait-for-promise-result)))
      (macro-mutex-lock! result-mutex #f (macro-current-thread))
      (##inline-host-statement
       "
var promise = g_scm2host(@1@);
var return_result = @2@;

//console.log(promise);
//console.log(return_result);

function onFulfilled(value) {
  //console.log('onFulfilled');
  //console.log(value);
  g_async_call(false,
               g_host2scm(false),
               return_result,
               [[g_host2scm(value)]]);
}

function onRejected(reason) {
  //console.log('onRejected');
  //console.log(reason);
  g_async_call(false,
               g_host2scm(false),
               return_result,
               [g_host2scm(reason.toString())]);
}

promise.then(onFulfilled, onRejected);
"
       promise
       (lambda (result)
         (macro-mutex-specific-set! result-mutex result)
         (macro-mutex-unlock! result-mutex)
         (##void)))

      ;; wait for result
      (macro-mutex-lock! result-mutex #f (macro-current-thread))
      (let ((msg (macro-mutex-specific result-mutex)))
        (if (##string? msg)
            (##error msg)
            (##vector-ref msg 0)))))

  ;; The following defines the "foreign" JavaScript function which
  ;; allows passing JavaScript objects to Scheme without an automatic
  ;; conversion.

  (##inline-host-declaration
   "function foreign(obj) { return g_host2foreign(obj); }\n"))

 (else

  (define (##host-define-function-and-call-dynamic descr . args)
    (##error "The _six/js module only works on the js target"))))

;;;============================================================================
