;;;============================================================================

;;; File: "VM.scm"

;;; Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(##include "~~lib/_gambit#.scm")

(declare (extended-bindings) (standard-bindings) (block))

(##inline-host-declaration #<<EOF

function G_VM() {

  var vm = this;

  vm.ui = null;
  vm.heartbeat_interval = 5000;
  vm.heartbeat_count = vm.heartbeat_interval;

  // Redefine ##check-heap-limit so that it checks interrupts (to allow
  // preemptive thread scheduling and user interrupts in interpreted code).

  g_check_heap_limit0 = function () {
    if (--vm.heartbeat_count === 0) {
      vm.heartbeat_count = vm.heartbeat_interval;
      setTimeout(function () {
        g_call_start(g_glo['##heartbeat!'], [], g_r0);
      }, 10);
      return null; // exit trampoline
    } else {
      g_r1 = void 0;
      return g_r0;
    }
  };

  // Set things up to defer execution of Scheme code until
  // vm.init is called.

  g_module_table.push(null); // pretend an extra module is needed
};

G_VM.prototype.init = function (ui_elem) {

  var vm = this;

  vm.ui = new G_UI(vm, ui_elem);

  // Start execution of Scheme code.

  g_module_table.pop(); // remove extra module
  g_program_start();
}

g_vm = new G_VM();

EOF
)

;; Convenience Scheme procedure to pass Scheme objects to JavaScript
;; without an automatic conversion.

(define (scheme scmobj)
  (##inline-host-expression
   "g_scm2scheme(@1@)"
   scmobj))

;; The "main-event-loop" thread takes care of processing events that
;; come from the JavaScript runtime system.

(define (##start-main-event-loop)

  (define (exec event)
    (let* ((nargs (##fx- (##vector-length event) 3))
           (proc (##vector-ref event 2)))
      (cond ((##fx= nargs 0)
             (proc))
            ((##fx= nargs 1)
             (proc (##vector-ref event 3)))
            ((##fx= nargs 2)
             (proc (##vector-ref event 3)
                   (##vector-ref event 4)))
            ((##fx= nargs 3)
             (proc (##vector-ref event 3)
                   (##vector-ref event 4)
                   (##vector-ref event 5)))
            (else
             (let loop ((i (##fx- (##vector-length event) 1))
                        (args '()))
               (if (##fx>= i 3)
                   (loop (##fx- i 1)
                         (##cons (##vector-ref event i) args))
                   (##apply proc args)))))))

  (define (handle event)
    (if (##vector-ref event 1) ;; response required?
        (##with-exception-catcher
         (lambda (exc)
           ;; send exception back to JavaScript
           ((##vector-ref event 1)
            (##call-with-output-string
             (lambda (port)
               (##display-exception exc port)))
            (##void)))
         (lambda ()
           ;; send result back to JavaScript
           ((##vector-ref event 1)
            (macro-absent-obj) ;; signal completion with no error
            (exec event))))
        (exec event)))

  (let* ((selector #f)
         (rdevice (##os-device-event-queue-open selector))
         (main-event-queue (##make-event-queue-port rdevice selector)))

    (let* ((tgroup
            (##make-tgroup 'main-event-loop #f))
           (input-port
            ##stdin-port)
           (output-port
            ##stdout-port)
           (main-event-loop-thread
            (##make-root-thread
             (lambda ()
               (let loop ()
                 (let* ((event (##read main-event-queue))
                        (thread ;; handle event in which thread?
                         (or (##vector-ref event 0)
                             (macro-current-thread))))
                   (cond ((##eq? thread (macro-current-thread))
                          ;; handle event synchronously in main-event-loop
                          (handle event))
                         ((##eq? thread #t)
                          ;; handle event asynchronously by creating
                          ;; a new thread just for this event
                          (##thread-start!
                           (##make-thread
                            (lambda ()
                              (handle event)))))
                         (else
                          ;; handle event asynchronously by interrupting
                          ;; an existing thread
                          (##thread-int! thread
                                         (lambda ()
                                           (handle event)
                                           (##void)))))
                   (loop))))
             'main-event-loop
             tgroup
             input-port
             output-port)))
      (##thread-start! main-event-loop-thread))))

(##start-main-event-loop)

(define (##heartbeat!)
  (##declare (not interrupts-enabled))
  ;;(##inline-host-statement "console.log('##heartbeat!');")
  (##thread-check-devices! #f)
  (##thread-heartbeat!))

(##hidden-continuation-parent?-set!
 (lambda (parent)
   (or (##eq? parent ##thread-check-devices!)
       (##eq? parent ##heartbeat!)
       (##eq? parent ##start-main-event-loop)
       (##default-hidden-continuation-parent? parent))))

;; Define "console" ports that support multiple independent REPLs.

(define (##os-device-stream-open-console title flags thread)
  (##inline-host-declaration "

g_os_device_stream_open_console = function (vm, title_scm, flags_scm, thread_scm) {

  var title = g_scm2host(title_scm);
  var flags = g_scm2host(flags_scm);

  var dev = new G_Device_console(vm, title, flags, thread_scm);

  return g_host2foreign(dev);
};

")
  (##inline-host-expression
   "g_os_device_stream_open_console(g_vm,@1@,@2@,@3@)"
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

(define (##thread-make-repl-channel-as-console thread)
  (let* ((sn (##object->serial-number thread))
         (title (##object->string thread))
         (name (if (##eqv? sn 1)
                   'console
                   (##string->symbol
                    (##string-append "console" (##number->string sn 10)))))
         (port (##open-console title name thread)))
    (##make-repl-channel-ports port port port)))

(##thread-make-repl-channel-set! ##thread-make-repl-channel-as-console)

;; Redefine the documentation browser to open the manual.

(##gambdoc-set!
 (lambda (arg1 arg2 arg3 arg4)
   (##inline-host-statement
    "window.open(g_scm2host(@1@));"
    (##string-append "doc/gambit.html#" arg4))))

;; Redirect current input/output ports to the console to avoid surprises
;; (by default the current output port is the JS console).

(##current-input-port (##repl-input-port))
(##current-output-port (##repl-output-port))

;; Prevent exiting the REPL with EOF.

(macro-repl-channel-really-exit?-set!
 (##thread-repl-channel-get! (macro-current-thread))
 (lambda (channel) #f))

(define (##repl-no-banner)
  (##repl-debug
   (lambda (first port) #f)
   #t))

(define (##activate-console dev)
  (##inline-host-statement
   "g_vm.ui.activate_console(g_foreign2host(@1@));"
   dev))

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
              (let* ((console (##repl-output-port))
                     (condvar (macro-device-port-wdevice-condvar console))
                     (dev (macro-condvar-name condvar)))
                (##activate-console dev))
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

;; Start the REPL of the primordial thread.

(if (##inline-host-expression
     "g_host2scm(g_os_web_origin.indexOf('://gambitscheme.org/') > 0)")
    (##repl-debug-main)
    (##repl-no-banner))

;;;============================================================================
