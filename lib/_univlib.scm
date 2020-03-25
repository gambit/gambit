;;;============================================================================

;;; File: "_univlib.scm"

;;; Copyright (c) 1994-2020 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(macro-case-target

 ((js)
  (##inline-host-declaration "

if ((function () { return this !== this.window; })()) { // nodejs?

  var os = require('os');
  var fs = require('fs');
  var vm = require('vm');
  var process = require('process');
  var child_process = require('child_process')

  function g_os_encode_error(exn) {
    switch (exn.code) {
      case 'EPERM':   return -1;
      case 'ENOENT':  return -2;
      case 'EINTR':   return -4;
      case 'EIO':     return -5;
      case 'EBADF':   return -9;
      case 'EACCESS': return -13;
      case 'EEXIST':  return -17;
      case 'EAGAIN':  return -35;
    }
    return -8888;
  }

  function g_os_decode_error(code) {
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
}

function g_current_time() {
  return new Date().getTime() / 1000;
}

var g_start_time = g_current_time();

function g_set_process_times(vect) {
  var elapsed = g_current_time() - g_start_time;
  vect.elems[0] = elapsed;
  vect.elems[1] = 0.0;
  vect.elems[2] = elapsed;
  return vect;
}

"))

 ((python)
  (##inline-host-declaration "

import os
import pwd
import grp
import stat
import time
import errno
import getpass
import functools

def g_os_encode_error(exn):
    e = exn.errno
    if e == errno.EPERM:
      return -1
    elif e == errno.ENOENT:
        return -2
    elif e == errno.EINTR:
        return -5
    elif e == errno.EIO:
        return -9
    elif e == errno.EBADF:
        return -13
    elif e == errno.EACCESS:
        return -17
    elif e == errno.EEXIST:
        return -35
    else:
        return -8888

def g_os_decode_error(code):
    if code == -1:
        return 'EPERM (Operation not permitted)'
    elif code == -2:
        return 'ENOENT (No such file or directory)'
    elif code == -4:
        return 'EINTR (Interrupted system call)'
    elif code == -5:
        return 'EIO (Input/output error)'
    elif code == -9:
        return 'EBADF (Bad file descriptor)'
    elif code == -13:
        return 'EACCESS (Permission denied)'
    elif code == -17:
        return 'EEXIST (File exists)'
    elif code == -35:
        return 'EAGAIN (Resource temporarily unavailable)'
    else:
        return 'E??? (unknown error)'

def g_current_time():
    return time.time()

g_start_time = g_current_time()

def g_set_process_times(vect):
    elapsed = g_current_time() - g_start_time
    vect.elems[0] = elapsed
    vect.elems[1] = 0.0
    vect.elems[2] = elapsed
    return vect

"))

 (else))

(##declare (not inline))

(define ##err-code-ENOENT             -2)
(define ##err-code-EINTR              -4)
(define ##err-code-EEXIST            -17)
(define ##err-code-EAGAIN            -35)
(define ##err-code-unimplemented   -9999)

(define ##min-fixnum          -536870912)
(define ##max-fixnum           536870911)
(define ##fixnum-width                30)
(define ##fixnum-width-neg           -30)
(define ##bignum.adigit-width         14)
(define ##bignum.mdigit-width         14)
(define ##max-char                 65535)

(define ##os-bat-extension-string-saved "")
(define ##os-exe-extension-string-saved "")
(define ##os-configure-command-string-saved "./configure")
(define ##os-system-type-string-saved "unknown-system-type")
(define (##system-stamp) 20200101213000)

(define (##os-path-gambitdir) "/usr/local/Gambit")
(define (##os-path-gambitdir-map-lookup name) #f)

(define (##os-module-install-mode) 1)
(define (##os-module-search-order) '("~~lib" "~~userlib"))
(define (##os-module-whitelist)    '("github.com/gambit"))
(define (##os-load-object-file path linker-name)
  '#("load-object-file not implemented" "___LNK_name"))

(define (##get-parallelism-level) 1)
(define (##cpu-count) 1)
(define (##current-vm-resize vm n) #f)

(define (##get-standard-level) 0)
(define (##set-debug-settings! mask new-settings) 0)

(define (##disable-interrupts!) #f)
(define (##enable-interrupts!) #f)
(define (##interrupt-vector-set! code handler) #f)
(define (##add-gc-interrupt-job! thunk) #f)

(define (##check-heap) #f)
(define (##raise-heap-overflow-exception) #f)

(define (##explode-continuation cont) #f)
(define (##explode-frame frame) #f)

(define (##kernel-handlers) #f)

(define (##os-condvar-select! devices timeout) #f)

(define (##os-copy-file src-path dest-path) -5555)
(define (##os-create-directory path permissions) -5555)
(define (##os-create-fifo path permissions) -5555)
(define (##os-create-link old-path new-path) -5555)
(define (##os-create-symbolic-link old-path new-path) -5555)
(define (##os-delete-directory path) -5555)
(define (##os-delete-file path) -5555)
(define (##os-rename-file old-path new-path replace?) -5555)
(define (##os-file-times-set! path a-time m-time) -5555)

(define (##os-host-info hi host) -5555)
(define (##os-network-info ni network) -5555)
(define (##os-protocol-info pi protocol) -5555)
(define (##os-service-info si service protocol) -5555)

(define (##string->address-and-port-number) #f)
(define (##tcp-client-socket-info) #f)
(define (open-tcp-client) #f)
(define (tcp-client-peer-socket-info) #f)
(define (##open-tcp-client) #f)
(define (##open-tcp-server-aux) #f)
(define (##process-tcp-server-psettings) #f)

(define (##repl-server-addr) #f);;TODO: remove
(define (##repl-client-addr) #f);;TODO: remove

(define-prim (##os-device-tty-history dev)
  (error "##os-device-tty-history not implemented yet"))

(define-prim (##os-device-tty-history-set! dev history)
  (error "##os-device-tty-history-set! not implemented yet"))

(define-prim (##os-device-tty-history-max-length-set! dev max-length)
  (error "##os-device-tty-history-max-length-set! not implemented yet"))

(define-prim (##os-device-tty-mode-set! dev input-allow-special input-echo input-raw output-raw speed)
  (error "##os-device-tty-mode-set! not implemented yet"))

(define-prim (##os-device-tty-mode-reset dev)
  (error "##os-device-tty-mode-reset not implemented yet"))

(define-prim (##os-device-tty-paren-balance-duration-set! dev duration)
  (error "##os-device-tty-paren-balance-duration-set! not implemented yet"))

(define-prim (##os-device-tty-text-attributes-set! dev input output)
  (error "##os-device-tty-text-attributes-set! not implemented yet"))

(define-prim (##os-device-tty-type-set! dev term-type emacs-bindings)
  (error "##os-device-tty-type-set! not implemented yet"))

;;;----------------------------------------------------------------------------

(define-prim (##subprocedure-id proc))
(define-prim (##subprocedure-parent proc))
(define-prim (##subprocedure-nb-parameters proc))
(define-prim (##subprocedure-nb-closed proc))
(define-prim (##make-subprocedure parent id))
(define-prim (##subprocedure-parent-info proc))
(define-prim (##subprocedure-parent-name proc))

;;;----------------------------------------------------------------------------

;;; Continuation objects.

(define-prim (##explode-continuation cont)
  (##vector (##continuation-frame cont)
            (##continuation-denv cont)))

(define-prim (##continuation-frame cont))

(define-prim (##continuation-frame-set! cont frame))

(define-prim (##continuation-denv cont))

(define-prim (##continuation-denv-set! cont denv))

(define-prim (##explode-frame frame)
  (let ((fs (##frame-fs frame)))
    (let ((v (##make-vector (##fx+ fs 1))))
      (##vector-set! v 0 (##frame-ret frame))
      (let loop ((i fs))
        (if (##fx< 0 i)
          (begin
            (if (##frame-slot-live? frame i)
              (##vector-set!
               v
               i
               (##frame-ref frame i)))
            (loop (##fx- i 1)))
          v)))))

(define-prim (##frame-ret frame))

(define-prim (##continuation-ret cont))

(define-prim (##return-fs return))

(define-prim (##frame-fs frame))

(define-prim (##continuation-fs cont))

(define-prim (##frame-link frame))

(define-prim (##continuation-link cont))

(define-prim (##frame-slot-live? frame i))

(define-prim (##continuation-slot-live? cont i))

(define-prim (##frame-ref frame i))

(define-prim (##frame-set! frame i val))

(define-prim (##continuation-ref cont i))

(define-prim (##continuation-set! cont i val))

(define-prim (##make-frame ret))

(define-prim (##make-continuation frame denv))

;;(define-prim (##continuation-copy cont))
;;(define-prim (##continuation-next! cont))

(define-prim (##continuation-next cont))

(define-prim (##continuation-last cont)
  (let loop ((cont cont))
    (let ((next (##continuation-next cont)))
      (if next
          (loop next)
          cont))))

;;;----------------------------------------------------------------------------

;;; Symbols and global variables.

(define-prim (##make-global-var id))
(define-prim (##global-var? id))
(define-prim (##global-var-ref gv))
(define-prim (##global-var-primitive-ref gv))
(define-prim (##global-var-set! gv val))
(define-prim (##global-var-primitive-set! gv val))

(define-prim (##object->global-var->identifier obj)
  (##global-var->identifier (##object->global-var obj #f)))

(define-prim (##object->global-var obj primitive?)
  (let loop ((lst (##global-vars)))
    (if (##pair? lst)
        (let ((gv (##car lst)))
          (if (##eq? obj (##global-var-ref gv))
              gv
              (loop (##cdr lst))))
        #f)))

(define-prim (##global-var->identifier gv)
  gv)

(define (##global-vars)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "g_host2scm(Object.keys(g_glo))"))))

   ((python)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "g_host2scm(list(g_glo.keys()))"))))

   (else
    (println "unimplemented ##global-vars called")
    '())))

(define (##interned-symbols)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "g_host2scm(Object.keys(g_symbol_table))"))))

   ((python)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "g_host2scm(list(g_symbol_table.keys()))"))))

   (else
    (println "unimplemented ##interned-symbols called")
    '())))

(define-prim (##global-var-table-foldl f base)
  (##symbol-table-foldl
   (lambda (lst sym)
     (if (and (##global-var? sym)
              (##not (##unbound? (##global-var-ref sym))))
         (f lst sym)
         lst))
   base))

(define (##symbol-table-foldl f base)
  (let loop ((lst (##interned-symbols)) (base base))
    (if (##pair? lst)
        (loop (##cdr lst)
              (f base (##car lst)))
        base)))

;;;----------------------------------------------------------------------------

;;; Host FFI.

(define (##string-substitute str delim alist)

  (define (index-of c start)
    (let loop ((i start))
      (if (##fx< i (##string-length str))
          (if (##char=? c (##string-ref str i))
              i
              (loop (##fx+ i 1)))
          i)))

  (let loop ((i 0) (j 0) (out '()))
    (let ((start (index-of delim j)))
      (if (##fx< start (##string-length str))
          (let ((end (index-of delim (##fx+ start 1))))
            (if (##fx< end (##string-length str))
                (if (##fx= start (##fx- end 1)) ;; two delimiters in a row?
                    (loop (##fx+ end 1)
                          (##fx+ end 1)
                          (##cons (##substring str i end)
                                  out))
                    (let* ((var (##substring str (##fx+ start 1) end))
                           (x (##assoc var alist)))
                      (if x
                          (loop (##fx+ end 1)
                                (##fx+ end 1)
                                (##cons (##cdr x)
                                        (##cons (##substring str i start)
                                                out)))
                          (##error "Unbound substitution variable in" str))))
                (##error "Unbalanced delimiter in" str)))
          (##append-strings
           (##reverse (##cons (##substring str i start) out)))))))

(macro-case-target

 ((js)
  (##inline-host-declaration "

function g_eval(expr) {
  return (1,eval)(expr);
}

function g_exec(stmts) {
  (1,eval)(stmts);
}

if (this !== this.window) { // nodejs?
  // hack for now to get around an issue with nodejs that the code containing
  // the Gambit runtime library is in a module... not in the global scope
  (function (x) { this.g_scm2host = x; })(g_scm2host); // export functions
  (function (x) { this.g_host2scm = x; })(g_host2scm);
}

function g_host_define_function(name, params, expr) {
  g_exec('function ' + name + '(' + params + ') { return ' + expr + '; }');
}

function g_host_define_procedure(name, params, stmts) {
  g_exec('function ' + name + '(' + params + ') {' + stmts + '\\n}');
}

function g_host_function_call(fn, args) {
  return g_eval(fn).apply(this, args);
}

function g_host_procedure_call(proc, args) {
  g_eval(proc).apply(this, args);
}

function g_host_eval(expr) {
  return g_eval(expr);
}

function g_host_exec(stmts) {
  g_exec(stmts);
}

"))

 ((python)
  (##inline-host-declaration "

def g_eval(expr):
    return eval(expr, globals())

def g_exec(stmts):
    exec(stmts, globals())

def g_host_define_function(name, params, expr):
    g_exec('def ' + name + '(' + params + '):\\n return ' + expr)

def g_host_define_procedure(name, params, stmts):
    g_exec('def ' + name + '(' + params + '):' + stmts + '\\n')

def g_host_function_call(fn, args):
    return globals()[fn](*args)

def g_host_procedure_call(proc, args):
    globals()[proc](*args)

def g_host_eval(expr):
    return g_eval(expr)

def g_host_exec(stmts):
    g_exec(stmts)

"))

 (else))

(define (##host-define-function-dynamic name params expr)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-statement
     "g_host_define_function(g_scm2host(@1@),g_scm2host(@2@),g_scm2host(@3@))"
     name
     (##append-strings params ",")
     expr))

   (else
    (println "unimplemented ##host-define-function-dynamic called with name=")
    (println name)
    (println "and params=")
    (println params)
    (println "and expr=")
    (println expr))))

(define (##host-define-procedure-dynamic name params stmts)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-statement
     "g_host_define_procedure(g_scm2host(@1@),g_scm2host(@2@),g_scm2host(@3@))"
     name
     (##append-strings params ",")
     stmts))

   (else
    (println "unimplemented ##host-define-procedure-dynamic called with name=")
    (println name)
    (println "and params=")
    (println params)
    (println "and stmts=")
    (println stmts))))

(define (##host-function-call fn args)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression
     "g_host_function_call(g_scm2host(@1@), @2@)"
     fn
     args))

   (else
    (println "unimplemented ##host-function-call called with fn=")
    (println fn)
    (println "and args=")
    (println args)
    #f)))

(define (##host-procedure-call proc args)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-statement
     "g_host_procedure_call(g_scm2host(@1@), @2@)"
     proc
     args))

   (else
    (println "unimplemented ##host-procedure-call called with proc=")
    (println proc)
    (println "and args=")
    (println args))))

(define (##host-eval-dynamic expr)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression
     "g_host_eval(g_scm2host(@1@))"
     expr))

   (else
    (println "unimplemented ##host-eval-dynamic called with expr=")
    (println expr)
    #f)))

(define (##host-exec-dynamic stmts)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-statement
     "g_host_exec(g_scm2host(@1@))"
     stmts))

   (else
    (println "unimplemented ##host-exec-dynamic called with stmts=")
    (println stmts))))

(define (##host-decl-expand decl)
  (##host-exec-dynamic decl)
  `(##begin))

(define ##host-fn-counter 0)

(define (##host-exec-expand stmts args-src)
  (set! ##host-fn-counter (##fx+ ##host-fn-counter 1))
  (let ((name
         (##string-append "g_fn" (##number->string ##host-fn-counter)))
        (substs
         (##map (lambda (i)
                  (let ((i-str (##number->string i)))
                    (##cons i-str
                            (##string-append "g_arg" i-str))))
                (##iota (##length args-src) 1))))
    (##host-define-procedure-dynamic
     name
     (##map ##cdr substs)
     (##string-substitute stmts #\@ substs))
    `(##host-procedure-call
      ,name
      (##vector ,@args-src))))

(define (##host-eval-expand expr args-src)
  (set! ##host-fn-counter (##fx+ ##host-fn-counter 1))
  (let ((name
         (##string-append "g_fn" (##number->string ##host-fn-counter)))
        (substs
         (##map (lambda (i)
                  (let ((i-str (##number->string i)))
                    (##cons i-str
                            (##string-append "g_arg" i-str))))
                (##iota (##length args-src) 1))))
    (##host-define-function-dynamic
     name
     (##map ##cdr substs)
     (##string-substitute expr #\@ substs))
    `(##host-function-call
      ,name
      (##vector ,@args-src))))

;;;----------------------------------------------------------------------------

;;; Error codes.

(define (##os-err-code->string code)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-expression
     "g_host2scm((function () { return this !== this.window; })() ? g_os_decode_error(g_scm2host(@1@)) : 'Unknown error')"
     code))

   ((python)
    (##inline-host-expression
     "g_host2scm(g_os_decode_error(g_scm2host(@1@)))"
     code))

   (else
    (println "unimplemented ##os-err-code->string called with code=")
    (println code)
    "Unknown error")))

;;;----------------------------------------------------------------------------

;;; Process id.

(define (##os-getpid)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-expression
     "g_host2scm((function () { return this !== this.window; })() ? process.pid : 0)"))

   ((python)
    (##inline-host-expression
     "g_host2scm(os.getpid())"))

   (else
    (println "unimplemented ##os-getpid called")
    0)))

;;;----------------------------------------------------------------------------

;;; Host name.

(define (##os-host-name)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-expression
     "g_host2scm((function () { return this !== this.window; })() ? os.hostname() : 'host-name')"))

   ((python)
    (##inline-host-expression
     "g_host2scm(os.uname()[1])"))

   (else
    (println "unimplemented ##os-host-name called")
    "host-name")))

;;;----------------------------------------------------------------------------

;;; User name.

(define (##os-user-name)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-expression
     "g_host2scm((function () { return this !== this.window; })() ? os.userInfo().username : 'user')"))

   ((python)
    (##inline-host-expression
     "g_host2scm(getpass.getuser())"))

   (else
    (println "unimplemented ##os-user-name called")
    "user")))

;;;----------------------------------------------------------------------------

;;; User and group information.

(macro-case-target

 ((js)
  (##inline-host-declaration "

function g_user_info(ui, user) {
  if ((function () { return this !== this.window; })()) { // nodejs?
    try {
      var posix = require('posix');
      var pw = posix.getpwnam(user);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return g_host2scm(g_os_encode_error(exn));
      } else {
        throw exn;
      }
    }
    ui.slots[1] = g_host2scm(pw.name);
    ui.slots[2] = g_host2scm(pw.uid);
    ui.slots[3] = g_host2scm(pw.gid);
    ui.slots[4] = g_host2scm(pw.dir);
    ui.slots[5] = g_host2scm(pw.shell);
    return ui;
  } else {
    ui.slots[1] = g_host2scm('user');
    ui.slots[2] = g_host2scm(111);
    ui.slots[3] = g_host2scm(222);
    ui.slots[4] = g_host2scm('/home/user');
    ui.slots[5] = g_host2scm('/bin/sh');
    return ui;
  }
}

function g_group_info(gi, group) {
  if ((function () { return this !== this.window; })()) { // nodejs?
    try {
      var posix = require('posix');
      var gr = posix.getgrnam(group);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return g_host2scm(g_os_encode_error(exn));
      } else {
        throw exn;
      }
    }
    gi.slots[1] = g_host2scm(gr.name);
    gi.slots[2] = g_host2scm(gr.gid);
    gi.slots[3] = g_host2scm(gr.members);
    return gi;
  } else {
    gi.slots[1] = g_host2scm('group');
    gi.slots[2] = g_host2scm(222);
    gi.slots[3] = g_host2scm([]);
    return gi;
  }
}

"))

 ((python)
  (##inline-host-declaration "

def g_user_info(ui, user):
    try:
        pw = pwd.getpwuid(user) if isinstance(user,int) else pwd.getpwnam(user)
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))
    ui.slots[1] = g_host2scm(pw[0])
    ui.slots[2] = g_host2scm(pw[2])
    ui.slots[3] = g_host2scm(pw[3])
    ui.slots[4] = g_host2scm(pw[5])
    ui.slots[5] = g_host2scm(pw[6])
    return ui

def g_group_info(gi, group):
    try:
        gr = grp.getgrgid(group) if isinstance(group,int) else pwd.getgrnam(group)
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))
    gi.slots[1] = g_host2scm(gr[0])
    gi.slots[2] = g_host2scm(gr[2])
    gi.slots[3] = g_host2scm(gr[3])
    return gi

"))

 (else))

(define (##os-user-info ui user)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression "g_user_info(@1@, g_scm2host(@2@))" ui user))

   (else
    (println "unimplemented ##os-user-info called with user=")
    (println user)
    (##unchecked-structure-set! ui "user"       1 #f #f)
    (##unchecked-structure-set! ui 111          2 #f #f)
    (##unchecked-structure-set! ui 222          3 #f #f)
    (##unchecked-structure-set! ui "/home/user" 4 #f #f)
    (##unchecked-structure-set! ui "/bin/sh"    5 #f #f)
    ui)))

(define (##os-group-info gi group)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression "g_group_info(@1@, g_scm2host(@2@))" gi group))

   (else
    (println "unimplemented ##os-group-info called with group=")
    (println group)
    (##unchecked-structure-set! gi "group"  1 #f #f)
    (##unchecked-structure-set! gi 222      2 #f #f)
    (##unchecked-structure-set! gi '()      3 #f #f)
    gi)))

;;;----------------------------------------------------------------------------

;;; Shell.

(define (##os-environ)
  (println "unimplemented ##os-environ called")
  '())

(define (##os-getenv var)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-expression
     "g_host2scm((function (v) { return this !== this.window && Object.hasOwnProperty.call(process.env,v) ? process.env[v] : false; })(g_scm2host(@1@)))"
     var))

   ((python)
    (##inline-host-expression
     "g_host2scm((lambda v: os.environ[v] if v in os.environ else False)(g_scm2host(@1@)))"
     var))

   (else
    (println "unimplemented ##os-getenv called with var=")
    (println var)
    #f)))

(define (##os-setenv var val)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-statement
     "if ((function (v) { return this !== this.window; })()) process.env[g_scm2host(@1@)] = g_scm2host(@2@);"
     var
     val)
    0)

   ((python)
    (##inline-host-statement
     "os.environ[g_scm2host(@1@)] = g_scm2host(@2@)"
     var
     val)
    0)

   (else
    (println "unimplemented ##os-setenv called with var=")
    (println var)
    (println "and val=")
    (println val)
    0)))

(macro-case-target

 ((js)
  (##inline-host-declaration "

function g_shell_command(cmd) {
  var r = child_process.spawnSync('sh',['-c',cmd]);
  var output = r.stdout.toString();
  if (output.length > 0) {
    console.log(output.replace(/\\n$/, ''));
  }
  return 256 * ((r.status === null) ? 0 : r.status);
}

"))

 ((python)
  (##inline-host-declaration "

def g_shell_command(cmd):
    return os.system(cmd)

"))

 (else))

(define (##os-shell-command cmd)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression
     "g_host2scm(g_shell_command(g_scm2host(@1@)))"
     cmd))

   (else
    (println "unimplemented ##os-shell-command called with cmd=")
    (println cmd)
    0)))

;;;----------------------------------------------------------------------------

;;; Home directory.

(define (##os-path-homedir)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-expression
     "g_host2scm((function () { return this !== this.window; })() ? os.homedir() : '/')"))

   ((python)
    (##inline-host-expression
     "g_host2scm(os.path.expanduser('~'))"))

   (else
    (println "unimplemented ##os-path-homedir called")
    "/")))

;;;----------------------------------------------------------------------------

;;; Path of executable (i.e. the host language script).

(macro-case-target

 ((js)
  (##inline-host-declaration "

var g_executable_path = ((function () { return this !== this.window; })()) ? __filename : '/program';

"))

 ((python)
  (##inline-host-declaration "

g_executable_path = os.path.abspath(__file__)

"))

 (else))

(define (##os-executable-path)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression "g_host2scm(g_executable_path)"))

   (else
    (println "unimplemented ##os-executable-path called")
    "/program")))

;;;----------------------------------------------------------------------------

;;; Path normalization.

(macro-case-target

 ((js)
  (##inline-host-declaration "

function g_normalize_dir(path) {
  if ((function () { return this !== this.window; })()) { // nodejs?
    var old = process.cwd();
    var dir;
    if (path === false) {
      dir = old;
    } else {
      try {
        process.chdir(path);
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return g_host2scm(g_os_encode_error(exn));
        } else {
          throw exn;
        }
      }
      dir = process.cwd();
      process.chdir(old);
    }
    if (dir[dir.length-1] === '/' || dir[dir.length-1] === '\\\\') {
      return g_host2scm(dir);
    } else if (dir[0] === '/') {
      return g_host2scm(dir + '/')
    } else {
      return g_host2scm(dir + '\\\\')
    }
  } else {
    return '/';
  }
}

"))

 ((python)
  (##inline-host-declaration "

def g_normalize_dir(path):
    old = os.getcwd()
    if path is False:
        dir = old
    else:
        try:
            os.chdir(path)
        except OSError as exn:
            return g_host2scm(g_os_encode_error(exn))
        dir = os.getcwd()
        os.chdir(old)
    if dir[-1] == '/' or dir[-1] == '\\\\':
        return g_host2scm(dir)
    elif dir[0] == '/':
        return g_host2scm(dir + '/')
    else:
        return g_host2scm(dir + '\\\\')

"))

 (else))

(define (##os-path-normalize-directory path)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression "g_normalize_dir(g_scm2host(@1@))" path))

   (else
    (println "unimplemented ##os-path-normalize-directory called with path=")
    (println path)
    "/")))

;;;----------------------------------------------------------------------------

;;; Process exit.

(define-prim (##exit-with-err-code-no-cleanup err-code)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-statement
     "
      var code = g_scm2host(@1@);
      if ((function () { return this !== this.window; })()) { // nodejs?
        process.exit(code);
      } else {
        throw Error('process exiting with code=' + code);
      }
     "
     (##fx- err-code 1)))

   ((python)
    (##inline-host-statement "exit(@1@)" (##fx- err-code 1)))

   (else
    (println "unimplemented ##exit-with-err-code-no-cleanup called with err-code=")
    (println err-code))))

(define (##execute-final-wills!)
  ;; do nothing because wills are only implemented in C backend
  #f)

(define (##exit-trampoline)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-statement "return null;"))

   ((python)
    (##inline-host-statement "return None"))

   (else
    (println "unimplemented ##exit-trampoline called"))))

;;;----------------------------------------------------------------------------

;;; Time management.

(define (##get-current-time! floats i)
  (##declare (not interrupts-enabled))
  (##f64vector-set!
   floats
   i
   (macro-case-target

    ((js python)
     (##inline-host-expression "g_host2scm(g_current_time())"))

    (else
     (println "unimplemented ##get-current-time! called")
     0.0))))

(define (##process-statistics)
  (##declare (not interrupts-enabled))
  (let ((v (##make-f64vector 20 0.0)))
    (macro-case-target

     ((js python)
      (##inline-host-expression "g_set_process_times(@1@)" v))

     (else
      (println "unimplemented ##process-statistics called")
      v))))

(define (##process-times)
  (##declare (not interrupts-enabled))
  (let ((v (##make-f64vector 3 0.0)))
    (macro-case-target

     ((js python)
      (##inline-host-expression "g_set_process_times(@1@)" v))

     (else
      (println "unimplemented ##process-times called")
      v))))

(define (##set-heartbeat-interval! seconds)
;;  (println "unimplemented ##set-heartbeat-interval! called with seconds=")
;;  (println seconds)
  #f)

(define (##get-heartbeat-interval! floats i)
;;  (println "unimplemented ##get-heartbeat-interval! called")
  (##f64vector-set! floats i 1.234))

;;;----------------------------------------------------------------------------

;;; Access to command line arguments.

(define (##get-command-line)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration
     "
      var g_argv = [];
      if ((function () { return this !== this.window; })()) { // nodejs?
        g_argv = process.argv.slice(1);
      }
     ")
    (##vector->list (##inline-host-expression "g_host2scm(g_argv)")))

   ((python)
    (##vector->list (##inline-host-expression "g_host2scm(sys.argv)")))

   (else
     (println "unimplemented ##command-line called")
    '())))

(define ##processed-command-line
  (let ((cmd-line (##get-command-line)))
    (if (##pair? cmd-line)
        cmd-line
        '("program"))))

(define (##processed-command-line-set! x)
  (set! ##processed-command-line x))

;;;----------------------------------------------------------------------------

;;; File information.

(macro-case-target

 ((js)
  (##inline-host-declaration "

function g_file_info(fi, path, chase) {

  if ((function () { return this !== this.window; })()) { // nodejs?

    var st;

    try {
      if (chase) {
        st = fs.statSync(path);
      } else {
        st = fs.lstatSync(path);
      }
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return g_host2scm(g_os_encode_error(exn));
      } else {
        throw exn;
      }
    }

    if (st.isFile())
      typ = 1;
    else if (st.isDirectory())
      typ = 2;
    else if (st.isCharacterDevice())
      typ = 3;
    else if (st.isBlockDevice())
      typ = 4;
    else if (st.isFIFO())
      typ = 5;
    else if (st.isSymbolicLink())
      typ = 6;
    else if (st.isSocket())
      typ = 7;
    else
      typ = 0;

    fi.slots[ 1] = g_host2scm(typ);
    fi.slots[ 2] = g_host2scm(st.dev);
    fi.slots[ 3] = g_host2scm(st.ino);
    fi.slots[ 4] = g_host2scm(st.mode);
    fi.slots[ 5] = g_host2scm(st.nlink);
    fi.slots[ 6] = g_host2scm(st.uid);
    fi.slots[ 7] = g_host2scm(st.gid);
    fi.slots[ 8] = g_host2scm(st.size);
    fi.slots[ 9] = new G_Flonum(-Infinity);
    fi.slots[10] = new G_Flonum(-Infinity);
    fi.slots[11] = new G_Flonum(-Infinity);
    fi.slots[12] = g_host2scm(0);
    fi.slots[13] = new G_Flonum(-Infinity);

    return fi;

  } else {
    return g_host2scm(-5555);
  }
}

"))

 ((python)
  (##inline-host-declaration "

def g_file_info(fi, path, chase):

    try:
        if chase:
            st = os.stat(path)
        else:
            st = os.lstat(path)
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))

    if stat.S_ISREG(st.st_mode):
      typ = 1
    elif stat.S_ISDIR(st.st_mode):
      typ = 2
    elif stat.S_ISCHR(st.st_mode):
      typ = 3
    elif stat.S_ISBLK(st.st_mode):
      typ = 4
    elif stat.S_ISFIFO(st.st_mode):
      typ = 5
    elif stat.S_ISLNK(st.st_mode):
      typ = 6
    elif stat.S_ISSOCK(st.st_mode):
      typ = 7
    else:
      typ = 0

    fi.slots[ 1] = g_host2scm(typ)
    fi.slots[ 2] = g_host2scm(st.st_dev)
    fi.slots[ 3] = g_host2scm(st.st_ino)
    fi.slots[ 4] = g_host2scm(st.st_mode)
    fi.slots[ 5] = g_host2scm(st.st_nlink)
    fi.slots[ 6] = g_host2scm(st.st_uid)
    fi.slots[ 7] = g_host2scm(st.st_gid)
    fi.slots[ 8] = g_host2scm(st.st_size)
    fi.slots[ 9] = G_Flonum(float('-inf'))
    fi.slots[10] = G_Flonum(float('-inf'))
    fi.slots[11] = G_Flonum(float('-inf'))
    fi.slots[12] = g_host2scm(0)
    fi.slots[13] = G_Flonum(float('-inf'))

    return fi

"))

 (else))

(define (##os-file-info fi path chase?)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-expression
     "g_file_info(@1@, g_scm2host(@2@), g_scm2host(@3@))"
     fi
     path
     chase?))

   (else
    (println "unimplemented ##os-file-info! called with path=")
    (println path)
    (println "and chase?=")
    (println chase?)
    -5555)))

;;;----------------------------------------------------------------------------

;;; File I/O.

(##declare (inline))

(macro-case-target

 ((js)

(##inline-host-declaration
"
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

var g_os_translate_flags;

if ((function () { return this !== this.window; })()) { // nodejs?

  g_os_translate_flags = function (flags) {

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

    return result;
  };

}

function G_Device(fd) {
  this.fd = fd;
  this.rbuf = new Uint8Array(1024);
  this.rlo = 1;
  this.rhi = 1; // 0 would mean EOF
}

var g_os_debug = false;

function g_os_device_kind(dev_scm) {

  var dev = dev_scm.val;

  if (g_os_debug)
    console.log('g_os_device_kind('+dev.fd+')  ***not fully implemented***');

  return g_host2scm(31); // file device
}

function g_os_device_stream_default_options(dev_scm) {

  var dev = dev_scm.val;

  if (g_os_debug)
    console.log('g_os_device_stream_default_options('+dev.fd+')  ***not fully implemented***');

  return g_host2scm(2<<9); // line buffering
}

function g_os_device_stream_options_set(dev_scm, options_scm) {

  var dev = dev_scm.val;
  var options = g_scm2host(options_scm);

  if (g_os_debug)
    console.log('g_os_device_stream_options_set('+dev.fd+','+options+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_stream_open_predefined(index_scm, flags_scm) {

  var index = g_scm2host(index_scm);
  var flags = g_scm2host(flags_scm);

  if (g_os_debug)
    console.log('g_os_device_stream_open_predefined('+index+','+flags+')  ***not fully implemented***');

  var fd;

  switch (index) {
    case -1: fd = 0; break; // stdin
    case -2: fd = 1; break; // stdout
    case -3: fd = 2; break; // stderr
    case -4: fd = 1; break; // console
    default: fd = index; break;
  }

  return new G_Foreign(new G_Device(fd), g_host2scm(false));
}

function g_os_device_stream_open_path(path_scm, flags_scm, mode_scm) {

  var path = g_scm2host(path_scm);
  var flags = g_scm2host(flags_scm);
  var mode = g_scm2host(mode_scm);

  if ((function () { return this === this.window; })()) {
    throw Error('g_os_device_stream_open_path(\\''+path+'\\','+flags+','+mode+')  ***not implemented***');
  }

  if (g_os_debug)
    console.log('g_os_device_stream_open_path(\\''+path+'\\','+flags+','+mode+')  ***not fully implemented***');

  var fd;

  try {
    fd = fs.openSync(path, g_os_translate_flags(flags), mode);
  } catch (exn) {
    if (exn instanceof Error && exn.hasOwnProperty('code')) {
      return g_host2scm(g_os_encode_error(exn));
    } else {
      throw exn;
    }
  }

  return new G_Foreign(new G_Device(fd), g_host2scm(false));
}

function g_os_device_stream_read(dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;
  var buffer = buffer_scm.elems;
  var lo = g_scm2host(lo_scm);
  var hi = g_scm2host(hi_scm);

  if ((function () { return this === this.window; })()) {
    throw Error('g_os_device_stream_read('+dev.fd+',['+buffer+'],'+lo+','+hi+')  ***not implemented***');
  }

  if (g_os_debug)
    console.log('g_os_device_stream_read('+dev.fd+',['+buffer+'],'+lo+','+hi+')  ***not fully implemented***');

  var n = hi-lo;
  var have = dev.rhi-dev.rlo;

  if (have === 0) {
    have = fs.readSync(dev.fd, dev.rbuf, 0, dev.rbuf.length, null);
    dev.rlo = 0;
    dev.rhi = have;
  }

  if (have === 0) {

    return g_host2scm(0); // 0 means EOF

  } else {

    if (n > have) n = have;

    buffer.set(dev.rbuf.subarray(dev.rlo, dev.rlo+n), lo);

    dev.rlo += n;

    return g_host2scm(n); // number of bytes transferred
  }
}

var g_stdout_buf = [];

function g_os_device_stream_write(dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;
  var buffer = buffer_scm.elems;
  var lo = g_scm2host(lo_scm);
  var hi = g_scm2host(hi_scm);

  if (g_os_debug)
    console.log('g_os_device_stream_write('+dev.fd+',['+buffer+'],'+lo+','+hi+')  ***not fully implemented***');

  var n;

  if ((function () { return this === this.window; })()) {

    if (dev.fd === 1) { // stdout?
      for (var i=lo; i<hi; i++) {
        var c = buffer[i];
        if (c === 10) {
          console.log(String.fromCharCode.apply(null, g_stdout_buf));
          g_stdout_buf = [];
        } else {
          g_stdout_buf.push(c);
        }
      }
    }

    n = hi-lo;

  } else {

    try {
      n = fs.writeSync(dev.fd, buffer, lo, hi-lo, null);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return g_host2scm(g_os_encode_error(exn));
      } else {
        throw exn;
      }
    }
  }

  return g_host2scm(n);
}

function g_os_device_close(dev_scm, direction_scm) {

  var dev = dev_scm.val;
  var direction = g_scm2host(direction_scm);

  if (g_os_debug)
    console.log('g_os_device_close('+dev.fd+','+direction+')  ***not fully implemented***');

  if ((function () { return this === this.window; })()) {
  } else {

    if ((direction & 1) != 0 ||  // DIRECTION_RD
        (direction & 2) != 0) {  // DIRECTION_WR
      try {
        fs.closeSync(dev.fd);
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return g_host2scm(g_os_encode_error(exn));
        } else {
          throw exn;
        }
      }
    }
  }

  return g_host2scm(0) // no error
}

function g_os_device_force_output(dev_condvar_scm, level_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;
  var level = g_scm2host(level_scm);

  if (g_os_debug)
    console.log('g_os_device_force_output('+dev.fd+','+level+')  ***not fully implemented***');

  return g_host2scm(0) // no error
}

function g_os_device_stream_seek(dev_condvar_scm, pos_scm, whence_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;
  var pos = g_scm2host(pos_scm);
  var whence = g_scm2host(whence_scm);

  if ((function () { return this === this.window; })()) {
    throw Error('g_os_device_stream_seek('+dev.fd+','+pos+','+whence+')  ***not implemented***');
  }

  if (g_os_debug)
    console.log('g_os_device_stream_seek('+dev.fd+','+pos+','+whence+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_stream_width(dev_condvar_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;

  if (g_os_debug)
    console.log('g_os_device_stream_width('+dev.fd+')  ***not fully implemented***');

  return g_host2scm(80);
}

function g_os_port_decode_chars(port_scm, want_scm, eof_scm) {

  var want = g_scm2host(want_scm);
  var eof = g_scm2host(eof_scm);

  if (g_os_debug)
    console.log('g_os_port_decode_chars(port,'+want+','+eof+')  ***not implemented***');

  var cbuf_scm = port_scm.slots[g_PORT_CHAR_RBUF];
  var chi = g_scm2host(port_scm.slots[g_PORT_CHAR_RHI]);
  var cend = cbuf_scm.codes.length;
  var bbuf = port_scm.slots[g_PORT_BYTE_RBUF].elems
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

  return g_host2scm(0) // no error
}

function g_os_port_encode_chars(port_scm) {

  if (g_os_debug)
    console.log('g_os_port_encode_chars(port)  ***not fully implemented***');

  var cbuf_scm = port_scm.slots[g_PORT_CHAR_WBUF];
  var clo = g_scm2host(port_scm.slots[g_PORT_CHAR_WLO]);
  var chi = g_scm2host(port_scm.slots[g_PORT_CHAR_WHI]);
  var bbuf = port_scm.slots[g_PORT_BYTE_WBUF].elems
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

  return g_host2scm(0) // no error
}

function g_os_device_directory_open_path(path_scm, ignore_hidden_scm) {

  var path = g_scm2host(path_scm);
  var ignore_hidden = g_scm2host(ignore_hidden_scm);

  if (g_os_debug)
    console.log('g_os_device_directory_open_path(\\''+path+'\\','+ignore_hidden+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_directory_read(dev_condvar_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;

  if (g_os_debug)
    console.log('g_os_device_directory_read('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_event_queue_open(selector_scm) {

  var selector = g_scm2host(selector_scm);

  if (g_os_debug)
    console.log('g_os_device_event_queue_open('+selector+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_event_queue_read(dev_condvar_scm) {

  var dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val;

  if (g_os_debug)
    console.log('g_os_device_event_queue_read('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_stream_open_process(path_and_args_scm, environment_scm, directory_scm, options_scm) {

  if (g_os_debug)
    console.log('g_os_device_stream_open_process(...)  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_process_pid(dev_scm) {

  var dev = dev_scm.val;

  if (g_os_debug)
    console.log('g_os_device_process_pid('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}

function g_os_device_process_status(dev_scm) {

  var dev = dev_scm.val;

  if (g_os_debug)
    console.log('g_os_device_process_status('+dev.fd+')  ***not implemented***');

  return g_host2scm(-1); // error
}
")

)

 ((python)

(##inline-host-declaration
"
g_CONDVAR_NAME              = 10

g_PORT_MUTEX                = 1
g_PORT_RKIND                = 2
g_PORT_WKIND                = 3
g_PORT_NAME                 = 4
g_PORT_WAIT                 = 5
g_PORT_CLOSE                = 6
g_PORT_ROPTIONS             = 7
g_PORT_RTIMEOUT             = 8
g_PORT_RTIMEOUT_THUNK       = 9
g_PORT_SET_RTIMEOUT         = 10
g_PORT_WOPTIONS             = 11
g_PORT_WTIMEOUT             = 12
g_PORT_WTIMEOUT_THUNK       = 13
g_PORT_SET_WTIMEOUT         = 14
g_PORT_IO_EXCEPTION_HANDLER = 15

g_PORT_OBJECT_READ_DATUM    = 16
g_PORT_OBJECT_WRITE_DATUM   = 17
g_PORT_OBJECT_NEWLINE       = 18
g_PORT_OBJECT_FORCE_OUTPUT  = 19

g_PORT_OBJECT_OTHER1        = 20
g_PORT_OBJECT_OTHER2        = 21
g_PORT_OBJECT_OTHER3        = 22

g_PORT_CHAR_RBUF            = 20
g_PORT_CHAR_RLO             = 21
g_PORT_CHAR_RHI             = 22
g_PORT_CHAR_RCHARS          = 23
g_PORT_CHAR_RLINES          = 24
g_PORT_CHAR_RCURLINE        = 25
g_PORT_CHAR_RBUF_FILL       = 26
g_PORT_CHAR_PEEK_EOFP       = 27

g_PORT_CHAR_WBUF            = 28
g_PORT_CHAR_WLO             = 29
g_PORT_CHAR_WHI             = 30
g_PORT_CHAR_WCHARS          = 31
g_PORT_CHAR_WLINES          = 32
g_PORT_CHAR_WCURLINE        = 33
g_PORT_CHAR_WBUF_DRAIN      = 34
g_PORT_INPUT_READTABLE      = 35
g_PORT_OUTPUT_READTABLE     = 36
g_PORT_OUTPUT_WIDTH         = 37

g_PORT_CHAR_OTHER1          = 38
g_PORT_CHAR_OTHER2          = 39
g_PORT_CHAR_OTHER3          = 40
g_PORT_CHAR_OTHER4          = 41
g_PORT_CHAR_OTHER5          = 42

g_PORT_BYTE_RBUF            = 38
g_PORT_BYTE_RLO             = 39
g_PORT_BYTE_RHI             = 40
g_PORT_BYTE_RBUF_FILL       = 41

g_PORT_BYTE_WBUF            = 42
g_PORT_BYTE_WLO             = 43
g_PORT_BYTE_WHI             = 44
g_PORT_BYTE_WBUF_DRAIN      = 45

g_PORT_BYTE_OTHER1          = 46
g_PORT_BYTE_OTHER2          = 47

g_PORT_RDEVICE_CONDVAR      = 46
g_PORT_WDEVICE_CONDVAR      = 47

g_PORT_DEVICE_OTHER1        = 48
g_PORT_DEVICE_OTHER2        = 49


def g_os_translate_flags(flags):

    code = (flags >> 4) & 3

    if code == 1:
        result = os.O_RDONLY
    elif code == 2:
        result = os.O_WRONLY
    elif code == 3:
        result = os.O_RDWR

    if not ((flags & (1 << 3)) == 0):
        result = result | os.O_APPEND

    code = (flags >> 1) & 3

    if code == 1:
        result = result | os.O_CREAT
    elif code == 2:
        result = result | os.O_CREAT | os.O_EXCL

    if not ((flags & 1) == 0):
        result = result | os.O_TRUNC

    return result


class G_Device:

    def __init__(self, fd):
        self.fd = fd


g_os_debug = False


def g_os_device_kind(dev_scm):

    dev = dev_scm.val

    if g_os_debug:
        print('g_os_device_kind('+repr(dev.fd)+')  ***not fully implemented***')

    return g_host2scm(31)  # file device


def g_os_device_stream_default_options(dev_scm):

    dev = dev_scm.val

    if g_os_debug:
        print('g_os_device_stream_default_options('+repr(dev.fd)+')  ***not fully implemented***')

    return g_host2scm(2<<9)  # line buffering


def g_os_device_stream_options_set(dev_scm, options_scm):

    dev = dev_scm.val
    options = g_scm2host(options_scm)

    if g_os_debug:
        print('g_os_device_stream_options_set('+repr(dev.fd)+','+repr(options)+')  ***not implemented***')

    return g_host2scm(-1)  # error


def g_os_device_stream_open_predefined(index_scm, flags_scm):

    index = g_scm2host(index_scm)
    flags = g_scm2host(flags_scm)

    if g_os_debug:
      print('g_os_device_stream_open_predefined('+repr(index)+','+repr(flags)+')  ***not fully implemented***')

    if index == -1:
        fd = 0  # stdin
    elif index == -2:
        fd = 1  # stdout
    elif index == -3:
        fd = 2  # stderr
    elif index == -4:
        fd = 1  # console
    else:
        fd = index

    return G_Foreign(G_Device(fd), g_host2scm(False))


def g_os_device_stream_open_path(path_scm, flags_scm, mode_scm):

    path = g_scm2host(path_scm)
    flags = g_scm2host(flags_scm)
    mode = g_scm2host(mode_scm)

    if g_os_debug:
        print('g_os_device_stream_open_path('+repr(path)+','+repr(flags)+','+repr(mode)+')  ***not fully implemented***')

    try:
        fd = os.open(path, g_os_translate_flags(flags), mode)
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))

    return G_Foreign(G_Device(fd), g_host2scm(False))


def g_os_device_stream_read(dev_condvar_scm, buffer_scm, lo_scm, hi_scm):

    dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val
    buffer = buffer_scm.elems
    lo = g_scm2host(lo_scm)
    hi = g_scm2host(hi_scm)

    if g_os_debug:
        print('g_os_device_stream_read('+repr(dev.fd)+','+repr(buffer)+','+repr(lo)+','+repr(hi)+')  ***not fully implemented***')

    try:
        b = os.read(dev.fd, hi-lo)
        n = len(b)
        buffer[lo:lo+n] = b
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))

    return g_host2scm(n)


def g_os_device_stream_write(dev_condvar_scm, buffer_scm, lo_scm, hi_scm):

    dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val
    buffer = buffer_scm.elems
    lo = g_scm2host(lo_scm)
    hi = g_scm2host(hi_scm)

    if g_os_debug:
        print('g_os_device_stream_write('+repr(dev.fd)+','+repr(buffer)+','+repr(lo)+','+repr(hi)+')  ***not fully implemented***')

    try:
        n = os.write(dev.fd, buffer[lo:hi])
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))

    return g_host2scm(n)


def g_os_device_close(dev_scm, direction_scm):

    dev = dev_scm.val
    direction = g_scm2host(direction_scm)

    if g_os_debug:
        print('g_os_device_close('+repr(dev.fd)+','+repr(direction)+')  ***not fully implemented***')

    if not ((direction & 3) == 0):  # DIRECTION_RD or DIRECTION_WR
        try:
            os.close(dev.fd)
        except OSError as exn:
            return g_host2scm(g_os_encode_error(exn))

    return g_host2scm(0)  # no error


def g_os_device_force_output(dev_condvar_scm, level_scm):

    dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val
    level = g_scm2host(level_scm)

    if g_os_debug:
        print('g_os_device_force_output('+repr(dev.fd)+','+repr(level)+')  ***not fully implemented***')

    return g_host2scm(0)  # no error


def g_os_device_stream_seek(dev_condvar_scm, pos_scm, whence_scm):

    dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val
    pos = g_scm2host(pos_scm)
    whence = g_scm2host(whence_scm)

    if g_os_debug:
        print('g_os_device_stream_seek('+repr(dev.fd)+','+repr(pos)+','+repr(whence)+')  ***not implemented***')

    if whence == 0:
        how = os.SEEK_SET
    elif whence == 1:
        how = os.SEEK_CUR
    else:
        how = os.SEEK_END

    try:
        os.lseek(dev.fd, pos, how)
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))

    return g_host2scm(0)  # no error


def g_os_device_stream_width(dev_condvar_scm):

    dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val

    if g_os_debug:
        print('g_os_device_stream_width('+repr(dev.fd)+')  ***not fully implemented***')

    return g_host2scm(80)


def g_os_port_decode_chars(port_scm, want_scm, eof_scm):

    want = g_scm2host(want_scm)
    eof = g_scm2host(eof_scm)

    if g_os_debug:
        print('g_os_port_decode_chars(port,'+repr(want)+','+repr(eof)+')  ***not implemented***')

    cbuf_scm = port_scm.slots[g_PORT_CHAR_RBUF]
    chi = g_scm2host(port_scm.slots[g_PORT_CHAR_RHI])
    cend = len(cbuf_scm.codes)
    bbuf = port_scm.slots[g_PORT_BYTE_RBUF].elems
    blo = g_scm2host(port_scm.slots[g_PORT_BYTE_RLO])
    bhi = g_scm2host(port_scm.slots[g_PORT_BYTE_RHI])
    options = g_scm2host(port_scm.slots[g_PORT_ROPTIONS])

    if not want == False:
        cend2 = chi + want
        if cend2 < cend:
            cend = cend2

    cbuf_avail = cend - chi
    bbuf_avail = bhi - blo

    while cbuf_avail > 0 and bbuf_avail > 0:
        cbuf_scm.codes[cend - cbuf_avail] = bbuf[bhi - bbuf_avail]
        bbuf_avail = bbuf_avail-1
        cbuf_avail = cbuf_avail-1

    port_scm.slots[g_PORT_CHAR_RHI] = g_host2scm(cend - cbuf_avail)
    port_scm.slots[g_PORT_BYTE_RLO] = g_host2scm(bhi - bbuf_avail)
    port_scm.slots[g_PORT_ROPTIONS] = g_host2scm(options)

    return g_host2scm(0)  # no error


def g_os_port_encode_chars(port_scm):

    if g_os_debug:
        print('g_os_port_encode_chars(port)  ***not fully implemented***')

    cbuf_scm = port_scm.slots[g_PORT_CHAR_WBUF]
    clo = g_scm2host(port_scm.slots[g_PORT_CHAR_WLO])
    chi = g_scm2host(port_scm.slots[g_PORT_CHAR_WHI])
    bbuf = port_scm.slots[g_PORT_BYTE_WBUF].elems
    bhi = g_scm2host(port_scm.slots[g_PORT_BYTE_WHI])
    bend = len(bbuf)
    options = g_scm2host(port_scm.slots[g_PORT_WOPTIONS])
    cbuf_avail = chi - clo
    bbuf_avail = bend - bhi

    while cbuf_avail > 0 and bbuf_avail > 0:
        bbuf[bend - bbuf_avail] = cbuf_scm.codes[chi - cbuf_avail]
        bbuf_avail = bbuf_avail-1
        cbuf_avail = cbuf_avail-1

    port_scm.slots[g_PORT_CHAR_WLO] = g_host2scm(chi - cbuf_avail)
    port_scm.slots[g_PORT_BYTE_WHI] = g_host2scm(bend - bbuf_avail)
    port_scm.slots[g_PORT_WOPTIONS] = g_host2scm(options)

    return g_host2scm(0)  # no error


def g_os_device_directory_open_path(path_scm, ignore_hidden_scm):

    path = g_scm2host(path_scm)
    ignore_hidden = g_scm2host(ignore_hidden_scm)

    if g_os_debug:
        print('g_os_device_directory_open_path('+repr(path)+','+repr(ignore_hidden)+')  ***not implemented***')

    return g_host2scm(-1)  # error


def g_os_device_directory_read(dev_condvar_scm):

    dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val

    if g_os_debug:
        print('g_os_device_directory_read('+repr(dev.fd)+')  ***not implemented***')

    return g_host2scm(-1)  # error


def g_os_device_event_queue_open(selector_scm):

    selector = g_scm2host(selector_scm)

    if g_os_debug:
        print('g_os_device_event_queue_open('+repr(selector)+')  ***not implemented***')

    return g_host2scm(-1)  # error


def g_os_device_event_queue_read(dev_condvar_scm):

    dev = dev_condvar_scm.slots[g_CONDVAR_NAME].val

    if g_os_debug:
        print('g_os_device_event_queue_read('+repr(dev.fd)+')  ***not implemented***')

    return g_host2scm(-1)  # error


def g_os_device_stream_open_process(path_and_args_scm, environment_scm, directory_scm, options_scm):

    if g_os_debug:
        print('g_os_device_stream_open_process(...)  ***not implemented***')

    return g_host2scm(-1)  # error


def g_os_device_process_pid(dev_scm):

    dev = dev_scm.val

    if g_os_debug:
        print('g_os_device_process_pid('+repr(dev.fd)+')  ***not implemented***')

    return g_host2scm(-1)  # error


def g_os_device_process_status(dev_scm):

    dev = dev_scm.val

    if g_os_debug:
        print('g_os_device_process_status('+repr(dev.fd)+')  ***not implemented***')

    return g_host2scm(-1)  # error

")

))

(macro-case-target

 ((js python)

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

))

;;;----------------------------------------------------------------------------

;;; Common modules of the runtime system.

(##define-macro (incl filename)
  `(##declare-scope
    (##macro-scope
     (##namespace-scope
      (##include ,filename)))))

(incl "_kernel.scm")
(incl "_system.scm")
(incl "_num.scm")
(incl "_std.scm")
(incl "_eval.scm")
(incl "_module.scm")
(incl "_io.scm")
(incl "_nonstd.scm")
(incl "_thread.scm")
(incl "_repl.scm")

;;;----------------------------------------------------------------------------

;;; Host FFI macros.

(define-runtime-syntax ##host-decl
  (lambda (src)
    (##deconstruct-call
     src
     2
     (lambda (decl-src)
       (let ((decl (##desourcify decl-src)))
         (if (##string? decl)
             (##host-decl-expand decl)
             (##raise-expression-parsing-exception
              'ill-formed-special-form
              src
              (##car (##desourcify src)))))))))

(define-runtime-syntax host-decl
  (##make-alias-syntax '##host-decl))

(define-runtime-syntax ##host-exec
  (lambda (src)
    (##deconstruct-call
     src
     -2
     (lambda (stmts-src . args-src)
       (let ((stmts (##desourcify stmts-src)))
         (if (##string? stmts)
             (##host-exec-expand stmts args-src)
             (##raise-expression-parsing-exception
              'ill-formed-special-form
              src
              (##car (##desourcify src)))))))))

(define-runtime-syntax host-exec
  (##make-alias-syntax '##host-exec))

(define-runtime-syntax ##host-eval
  (lambda (src)
    (##deconstruct-call
     src
     -2
     (lambda (stmts-src . args-src)
       (let ((stmts (##desourcify stmts-src)))
         (if (##string? stmts)
             (##host-eval-expand stmts args-src)
             (##raise-expression-parsing-exception
              'ill-formed-special-form
              src
              (##car (##desourcify src)))))))))

(define-runtime-syntax host-eval
  (##make-alias-syntax '##host-eval))

;;;----------------------------------------------------------------------------

(##load-vm)

;;;============================================================================
