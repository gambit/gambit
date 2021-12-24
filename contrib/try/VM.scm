;;;============================================================================

;;; File: "VM.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "~~lib/_gambit#.scm")

(declare (extended-bindings) (standard-bindings) (block))
(declare (not inline))

;;;----------------------------------------------------------------------------

(##inline-host-declaration #<<EOF

function VM() {

  var vm = this;

  // Determine if code is running in a web browser (alternative is nodejs).

  vm.os_web = (function () { return this === this.window; })();
  vm.os_web_origin = '';
  vm.ui = null;

  if (vm.os_web) {

    // The @all_modules_registered@ function is called when all
    // the JavaScript code of the program's Scheme modules are
    // registered.  It is predefined by the runtime system to
    // call @program_start@ to start the execution of the Scheme
    // code.  However this may be too early for the web application,
    // in particular the DOM elements for the UI may not exist yet.
    // To work around this issue the @all_modules_registered@ function
    // is redefined to do nothing and the start of the execution of the
    // Scheme code will require an explicit call to the VM's init method.

    @all_modules_registered@ = function () { };
  }
};

VM.prototype.init = function (ui_elem) {

  var vm = this;

  // The init method is only called when running in a web browser, i.e.
  // vm.os_web is true.  It is typically called when the web page is
  // fully loaded. For example:
  //
  //    <body onload="main_vm.init('#ui');">
  //    <div id="ui"></div>

  vm.os_web_origin = @os_web_origin@;
  vm.ui = new UI(vm, ui_elem);

  @program_start@(); // Start execution of Scheme code.
};

VM.prototype.os_condvar_ready_set = function (condvar_scm, ready) {

  var vm = this;

  @os_condvar_ready_set@(condvar_scm, ready);
};

VM.prototype.new_repl = function (ui) {

  var vm = this;

  @async_call@(false, // no result needed
               false,
               @glo@['##new-repl'],
               ui ? [@host2foreign@(ui)] : []);
};

VM.prototype.user_interrupt_thread = function (thread_scm) {

  var vm = this;

  @heartbeat_count@ = 1; // force interrupt at next poll point

  @async_call@(false, // no result needed
               thread_scm,
               @glo@['##user-interrupt!'],
               []);
};

VM.prototype.terminate_thread = function (thread_scm) {

  var vm = this;

  @async_call@(false, // no result needed
               false,
               @glo@['##thread-terminate!'],
               [thread_scm]);
};

main_vm = new VM();

EOF
)

;;;----------------------------------------------------------------------------

;; Define "console" ports that support multiple independent REPLs.

(define (##os-device-stream-open-console title flags ui thread)
  (##inline-host-declaration "

@os_device_stream_open_console@ = function (vm, title_scm, flags_scm, ui_scm, thread_scm) {

  var title = @scm2host@(title_scm);
  var flags = @scm2host@(flags_scm);
  var ui = @scm2host@(ui_scm);

  var dev = new Device_console(vm, title, flags, ui, thread_scm);

  return @host2foreign@(dev);
};

")
  (##inline-host-expression
   "@os_device_stream_open_console@(main_vm,@1@,@2@,@3@,@4@)"
   title
   flags
   ui
   thread))

(define (##open-console title
                        name
                        #!optional
                        (ui #f)
                        (thread #f)
                        (settings (macro-absent-obj)))
  (let ((direction
         (macro-direction-inout))
        (settings
         (cond ((##eq? settings (macro-absent-obj))
                '())
               (else
                settings))))
    (##make-path-psettings
     direction
     settings
     ##exit-abruptly
     (lambda (psettings)
       (let ((device
              (##os-device-stream-open-console
               title
               (##psettings->device-flags psettings)
               ui
               thread)))
         (if (##fixnum? device)
             (##exit-with-err-code device)
             (and device
                  (##make-device-port-from-single-device
                   name
                   device
                   psettings))))))))

(define (##activate-console dev)
  (##inline-host-statement
   "@foreign2host@(@1@).activate();"
   dev))

(define (##activate-repl)
  (let* ((console (##repl-output-port))
         (condvar (macro-device-port-wdevice-condvar console))
         (dev (macro-condvar-name condvar)))
    (##activate-console dev)))

(define ##current-ui (##make-parameter #f))

(define (##thread-make-repl-channel-as-console thread #!optional (ui #f))
  (let* ((sn (##object->serial-number thread))
         (title (##object->string thread))
         (name (if (##eqv? sn 1)
                   'console
                   (##string->symbol
                    (##string-append "console" (##number->string sn 10)))))
         (port (##open-console title name (or ui (##current-ui)) thread)))
    (##make-repl-channel-ports port port port)))

;; Enable web console.

(if (##inline-host-expression "@host2scm@(main_vm.ui !== null)")
    (begin

      (##thread-make-repl-channel-set! ##thread-make-repl-channel-as-console)

      ;; Prevent exiting the REPL with EOF.
      (macro-repl-channel-really-exit?-set!
       (##thread-repl-channel-get! (macro-current-thread))
       (lambda (channel) #f))))

;;;----------------------------------------------------------------------------

;; Redirect current input/output ports to the console to avoid surprises
;; (by default the current output port is the JS console).

(##current-input-port (##repl-input-port))
(##current-output-port (##repl-output-port))

(define (##repl-no-banner)
  (##repl-debug
   (lambda (first port) #f)
   #t))

(define (##new-repl #!optional (ui #f))
  (declare (not interrupts-enabled))
  (##thread-start!
   (let* ((primordial-tgroup
           (macro-thread-tgroup ##primordial-thread))
          (input-port
           ##stdin-port)
          (output-port
           ##stdout-port)
          (ui
           (or ui (##current-ui)))
          (thread
           (##make-root-thread
            (lambda ()
              (##parameterize ((##current-ui ui))
                (let ((input-port (##repl-input-port))
                      (output-port (##repl-output-port)))
                  (##parameterize ((##current-input-port input-port)
                                   (##current-output-port output-port))
                    ;; bring REPL tab to frontmost
                    (##activate-repl)
                    ;; start REPL
                    (##repl-no-banner)))))
            (##void) ;; no name
            primordial-tgroup
            input-port
            output-port)))
     thread)))

;; Import the six.infix special form for JavaScript without an actual
;; import statement that would require reading files.

(##eval
 '(##begin
   (##namespace ("_six/js#" six.infix))
   (##define-syntax six.infix
     (lambda (src)
       (##demand-module _six/six-expand)
       (_six/six-expand#six.infix-js-expand src)))))

;; Redefine the documentation browser to open the manual.

(##gambdoc-set!
 (lambda (arg1 arg2 arg3 arg4)
   (##inline-host-statement
    "window.open(@scm2host@(@1@));"
    (##string-append "doc/gambit.html#" arg4))))

;; When running in web browser set current directory to / and
;; add that directory to module search order.

(if (##inline-host-expression "@host2scm@(main_vm.os_web)")
    (begin
      (##current-directory "/")
      (##module-search-order-set! (cons "/" ##module-search-order))))

;; Start the REPL of the primordial thread.

(##include "../../gsi/_gsi.scm")

(if (##inline-host-expression
     "@host2scm@(main_vm.os_web_origin.indexOf('://try.scheme.org/') > 0)")
    (set! ##repl-debug-main ##repl-no-banner))

;;;============================================================================
