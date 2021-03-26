;;;============================================================================

;;; File: "VM.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "~~lib/_gambit#.scm")

(declare (extended-bindings) (standard-bindings) (block))
(declare (not inline))

(##define-macro (incl filename)
  `(##declare-scope
    (##macro-scope
     (##namespace-scope
      (##include ,filename)))))

(incl "js.scm")
(incl "six-expand.scm")
(incl "extra.scm")

;;;----------------------------------------------------------------------------

(##inline-host-declaration #<<EOF

function VM() {

  var vm = this;

  vm.os_web = (function () { return this === this.window; })();
  vm.os_web_origin = '';
  vm.ui = null;

  if (vm.os_web) {

    // Set things up to defer execution of Scheme code until
    // vm.init is called.

    @module_table@.push(null); // pretend an extra module is needed
  }
};

VM.prototype.init = function (ui_elem) {

  var vm = this;

  vm.os_web_origin = @os_web_origin@;
  vm.ui = new UI(vm, ui_elem);

  // Start execution of Scheme code.

  @module_table@.pop(); // remove extra module
  @program_start@();
};

VM.prototype.os_condvar_ready_set = function (condvar_scm, ready) {

  var vm = this;

  @os_condvar_ready_set@(condvar_scm, ready);
};

VM.prototype.new_repl = function () {

  var vm = this;

  @async_call@(false, // no result needed
               @host2scm@(false),
               @glo@['##new-repl'],
               []);
};

VM.prototype.new_repl = function () {

  var vm = this;

  @async_call@(false, // no result needed
               @host2scm@(false),
               @glo@['##new-repl'],
               []);
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
               @host2scm@(false),
               @glo@['##thread-terminate!'],
               [thread_scm]);
};

main_vm = new VM();

EOF
)

;;;----------------------------------------------------------------------------

;; Define "console" ports that support multiple independent REPLs.

(define (##os-device-stream-open-console title flags thread)
  (##inline-host-declaration "

@os_device_stream_open_console@ = function (vm, title_scm, flags_scm, thread_scm) {

  var title = @scm2host@(title_scm);
  var flags = @scm2host@(flags_scm);

  var dev = new Device_console(vm, title, flags, thread_scm);

  return @host2foreign@(dev);
};

")
  (##inline-host-expression
   "@os_device_stream_open_console@(main_vm,@1@,@2@,@3@)"
   title
   flags
   thread))

(define (##open-console title
                        name
                        #!optional
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
   "if (main_vm.ui !== null) main_vm.ui.activate_console(@foreign2host@(@1@));"
   dev))

(define (##activate-repl)
  (let* ((console (##repl-output-port))
         (condvar (macro-device-port-wdevice-condvar console))
         (dev (macro-condvar-name condvar)))
    (##activate-console dev)))

(define (##thread-make-repl-channel-as-console thread)
  (let* ((sn (##object->serial-number thread))
         (title (##object->string thread))
         (name (if (##eqv? sn 1)
                   'console
                   (##string->symbol
                    (##string-append "console" (##number->string sn 10)))))
         (port (##open-console title name thread)))
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

(define (##new-repl)
  (declare (not interrupts-enabled))
  (##thread-start!
   (let* ((primordial-tgroup
           (macro-thread-tgroup ##primordial-thread))
          (input-port
           ##stdin-port)
          (output-port
           ##stdout-port)
          (thread
           (##make-root-thread
            (lambda ()
              ;; thread will start a REPL
              (##activate-repl)
              (##repl-no-banner))
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

;; Start the REPL of the primordial thread.

(if (##inline-host-expression
     "@host2scm@(main_vm.os_web_origin.indexOf('://gambitscheme.org/') > 0)")
    (##repl-debug-main)
    (##repl-no-banner))

;;;============================================================================
