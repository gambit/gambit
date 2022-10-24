;;;============================================================================

;;; File: "VM.scm"

;;; Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.

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

VM.prototype.completions = function (thread_scm, input, cursor) {

  var vm = this;

  var READTABLE_CHAR_DELIMITERP_TABLE = 6;
  var readtable = @glo@['##main-readtable'];
  var char_delimiterp_table = readtable.@slots@[READTABLE_CHAR_DELIMITERP_TABLE];
  var start = cursor-1;

  while (start >= 0) {
    var c = Math.min(input.charCodeAt(start), 128);
    if (char_delimiterp_table[c]) break;
    start--;
  }

  start++;

  var completions = [];

  if (start < cursor) {

    var prefix = input.slice(start, cursor);
    var prefix_len = prefix.length;

    for (var sym in @symbol_table@) {
      if (sym.length >= prefix_len &&
          sym !== prefix &&
          sym.slice(0, prefix_len) === prefix) {
        completions.push(sym);
      }
    }

    completions.sort();

    completions.unshift(prefix);
  }

  return completions;
};

VM.prototype.pinpoint = function (container, line0, col0) {

  var vm = this;

  if (vm.ui) vm.ui.pinpoint(container, line0, col0);
};

main_vm = new VM();

EOF
)

;;;----------------------------------------------------------------------------

;; Define "console" ports that support multiple independent REPLs.

(define (##os-device-stream-open-console title name flags ui thread)
  (##inline-host-declaration "

@os_device_stream_open_console@ = function (vm, title_scm, name_scm, flags_scm, ui_scm, thread_scm) {

  var title = @scm2host@(title_scm);
  var name = @scm2host@(name_scm);
  var flags = @scm2host@(flags_scm);
  var ui = @scm2host@(ui_scm);

  var dev = new Device_console(vm, title, name, flags, ui, thread_scm);

  return @host2foreign@(dev);
};

")
  (##inline-host-expression
   "@os_device_stream_open_console@(main_vm,@1@,@2@,@3@,@4@,@5@)"
   title
   name
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
               name
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
         (port (##open-console title name (or ui (##current-ui)) thread))
         (repl-channel (##make-repl-channel-ports port port port)))
    repl-channel))

(##pinpoint-locat-hook-set!
 (lambda (locat)
   (let* ((container (##locat-container locat))
          (filepos (##position->filepos (##locat-position locat)))
          (line0 (##filepos-line filepos))
          (col0 (##filepos-col filepos)))
     (##os-pinpoint container line0 col0))))

(define (##os-pinpoint container line0 col0)
  (##inline-host-declaration "

@os_pinpoint@ = function (vm, container_scm, line0_scm, col0_scm) {

  var line0 = @scm2host@(line0_scm);
  var col0 = @scm2host@(col0_scm);

  return @host2foreign@(vm.pinpoint(container_scm, line0, col0));
};

")
  (##inline-host-expression
   "@os_pinpoint@(main_vm,@1@,@2@,@3@)"
   container
   line0
   col0))

;; Enable web console.

(if (##inline-host-expression "@host2scm@(main_vm.ui !== null)")
    (begin

      (##thread-make-repl-channel-set! ##thread-make-repl-channel-as-console)

      ;; Prevent exiting the REPL with EOF.
      (macro-repl-channel-really-exit?-set!
       (##thread-repl-channel-get! (macro-current-thread))
       (lambda (channel) #f))))

;; Allow fetching modules directly from github.com

(##inline-host-statement
 "@os_url_whitelist_add@('https://raw.githubusercontent.com/');")

(define (##web-search-module-in-search-order modref search-order)
  (let* ((host
          (macro-modref-host modref))
         (tag
          (macro-modref-tag modref))
         (rpath
          (macro-modref-rpath modref)))
    (if (and (##pair? host)
             (##equal? (##last host) "github.com")
             (##member (##modref->string modref)
                       (##get-module-whitelist)
                       ##module-prefix=?))
        (##search-module-at
         rpath
         (##butlast rpath)
         (##path-expand
          (or tag "master")
          (##path-expand (##last rpath)
                         (##path-join-reversed
                          (##butlast host)
                          "https://raw.githubusercontent.com")))
         ##scheme-file-extensions)
        (##default-search-module-in-search-order modref search-order))))

(##search-module-in-search-order-set! ##web-search-module-in-search-order)

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
      (##module-search-order-add! "/")))

;; Start the REPL of the primordial thread.

(##include "../../gsi/_gsi.scm")

(if (##inline-host-expression
     "@host2scm@(main_vm.os_web_origin.indexOf('://try.scheme.org/') > 0)")
    (set! ##repl-debug-main ##repl-no-banner))

;;;============================================================================
