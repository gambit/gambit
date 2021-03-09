;;;============================================================================

;;; File: "_univlib.scm"

;;; Copyright (c) 1994-2021 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(macro-case-target

 ((js)
  (##inline-host-declaration "

// Autodetect when running in a web browser (as opposed to nodejs).
g_os_web = (function () { return this === this.window; })();

// Autodetect availability of nodejs features.
if (typeof g_os_nodejs === 'undefined') {
  g_os_nodejs = !g_os_web;
}

if (g_os_nodejs) {
  os = require('os');
  vm = require('vm');
  process = require('process');
  child_process = require('child_process')
  if (typeof g_os_fs === 'undefined') {
    g_os_fs = require('fs');
    g_os_buffer = require('buffer');
  }
}

if (typeof g_os_fs === 'undefined') {

  g_os_fs = null;

  // Autodetect BrowserFS and use it if available for local filesystem.
  if (typeof BrowserFS !== 'undefined') {
    BrowserFS.configure({
      fs: 'LocalStorage'
    }, function (err) {
      if (!err) {
        g_os_fs = BrowserFS.BFSRequire('fs');
        g_os_buffer = BrowserFS.BFSRequire('buffer');
      }
    });
  }
}

g_os_uri_scheme_prefixed = function (string) {
  return string.match(/^[a-zA-Z][-+.a-zA-Z0-9]*:\\/\\//);
};

g_os_encode_error = function (exn) {
  switch (exn.code) {
    case 'EPERM':  return -1;
    case 'ENOENT': return -2;
    case 'EINTR':  return -4;
    case 'EIO':    return -5;
    case 'EBADF':  return -9;
    case 'EACCES': return -13;
    case 'EEXIST': return -17;
    case 'EAGAIN': return -35;
  }
  return -8888;
};

g_os_decode_error = function (code) {
  switch (code) {
    case -1:  return 'EPERM (Operation not permitted)';
    case -2:  return 'ENOENT (No such file or directory)';
    case -4:  return 'EINTR (Interrupted system call)';
    case -5:  return 'EIO (Input/output error)';
    case -9:  return 'EBADF (Bad file descriptor)';
    case -13: return 'EACCES (Permission denied)';
    case -17: return 'EEXIST (File exists)';
    case -35: return 'EAGAIN (Resource temporarily unavailable)';
  }
  return 'E??? (unknown error)';
};

g_os_current_time = function () {
  return new Date().getTime() / 1000;
};

g_os_start_time = g_os_current_time();

g_os_set_process_times = function (vect) {
  var elapsed = g_os_current_time() - g_os_start_time;
  vect.elems[0] = elapsed;
  vect.elems[1] = 0.0;
  vect.elems[2] = elapsed;
  return vect;
};

g_os_debug = false;

g_os_condvar_ready_set = function (condvar_scm, ready) {
  // redefined when g_os_condvar_select is required
};

G_Device_jsconsole = function () {
  var dev = this;
  dev.wbuf = []; // buffer to accumulate chars up to end of line
};

G_Device_jsconsole.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_jsconsole().read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  return -1; // EPERM (operation not permitted)
};

G_Device_jsconsole.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_jsconsole().write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  for (var i=lo; i<hi; i++) {
    var c = buffer[i];
    if (c === 10) { // end of line?
      console.log(String.fromCharCode.apply(null, dev.wbuf));
      dev.wbuf = [];
    } else {
      dev.wbuf.push(c);
    }
  }

  return hi-lo; // number of bytes transferred
};

G_Device_jsconsole.prototype.force_output = function (dev_condvar_scm, level) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_jsconsole().force_output(...,'+level+')');

  return 0; // no error
};

G_Device_jsconsole.prototype.seek = function (dev_condvar_scm, pos, whence) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_jsconsole().seek(...,'+pos+','+whence+')');

  return -1; // EPERM (operation not permitted)
};

G_Device_jsconsole.prototype.width = function (dev_condvar_scm) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_jsconsole().width()');

  return 80;
};

G_Device_jsconsole.prototype.close = function (direction) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_jsconsole().close('+direction+')');

  return -1; // EPERM (operation not permitted)
};

if (g_os_fs) {

  g_async_op_done = -99;
  g_async_op_in_progress = -98;

  G_Device_fd = function (fd) {
    var dev = this;
    dev.fd = fd;
    dev.async_read_progress = g_async_op_done; // no previous result
    dev.async_write_progress = g_async_op_done; // no previous result
  };

  G_Device_fd.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_fd('+dev.fd+').read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    var async_read_progress = dev.async_read_progress;

    if (async_read_progress === g_async_op_in_progress) {

        return -35; // return EAGAIN because other async read is in progress

    } else if (async_read_progress !== g_async_op_done) {

        dev.async_read_progress = g_async_op_done;
        return async_read_progress; // return result of async read

    } else {

      // Start an async read of the file descriptor

      function callback(err, bytesRead) {
        var progress = dev.async_read_progress;
        if (err) {
          dev.async_read_progress = g_os_encode_error(err);
        } else {
          dev.async_read_progress = bytesRead; // possibly 0 to signal EOF
        }
        if (progress === g_async_op_in_progress) {
          g_os_condvar_ready_set(dev_condvar_scm, true);
        }
      }

      g_os_fs.read(dev.fd, g_os_buffer.Buffer.from(buffer.buffer), lo, hi-lo, null, callback);

      if (dev.async_read_progress !== g_async_op_done) {
        // handle synchronous execution of callback
        var progress = dev.async_read_progress;
        dev.async_read_progress = g_async_op_done;
        return progress;
      } else {
        g_os_condvar_ready_set(dev_condvar_scm, false);
        dev.async_read_progress = g_async_op_in_progress;
        return -35; // return EAGAIN to suspend Scheme thread on condvar
      }
    }
  };

  G_Device_fd.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_fd('+dev.fd+').write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    var async_write_progress = dev.async_write_progress;

    if (async_write_progress === g_async_op_in_progress) {

        return -35; // return EAGAIN because other async write is in progress

    } else if (async_write_progress !== g_async_op_done) {

        dev.async_write_progress = g_async_op_done;
        return async_write_progress; // return result of async write

    } else {

      // Start an async write of the file descriptor

      function callback(err, bytesWritten) {
        var progress = dev.async_write_progress;
        if (err) {
          dev.async_write_progress = g_os_encode_error(err);
        } else {
          dev.async_write_progress = bytesWritten;
        }
        if (progress === g_async_op_in_progress) {
          g_os_condvar_ready_set(dev_condvar_scm, true);
        }
      }

      g_os_fs.write(dev.fd, g_os_buffer.Buffer.from(buffer.buffer), lo, hi-lo, null, callback);

      if (dev.async_write_progress !== g_async_op_done) {
        // handle synchronous execution of callback
        var progress = dev.async_write_progress;
        dev.async_write_progress = g_async_op_done;
        return progress;
      } else {
        g_os_condvar_ready_set(dev_condvar_scm, false);
        dev.async_write_progress = g_async_op_in_progress;
        return -35; // return EAGAIN to suspend Scheme thread on condvar
      }
    }
  };

  G_Device_fd.prototype.force_output = function (dev_condvar_scm, level) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_fd('+dev.fd+').force_output(...,'+level+')');

    return 0; // no error
  };

  G_Device_fd.prototype.seek = function (dev_condvar_scm, pos, whence) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_fd('+dev.fd+').seek(...,'+pos+','+whence+')');

    return -1; // EPERM (operation not permitted)
  };

  G_Device_fd.prototype.width = function (dev_condvar_scm) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_fd('+dev.fd+').width()');

    return 80;
  };

  G_Device_fd.prototype.close = function (direction) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_fd('+dev.fd+').close('+direction+')');

    if ((direction & 1) != 0 ||  // DIRECTION_RD
        (direction & 2) != 0) {  // DIRECTION_WR

      // Start an async close of the file descriptor

      var async_progress = g_async_op_done; // close not yet started
      var ra = g_r0;

      function callback(err) {
        var progress = async_progress;
        if (err) {
          async_progress = g_os_encode_error(err);
        } else {
          async_progress = 0; // no error
        }
        if (progress === g_async_op_in_progress) {
          g_r1 = g_host2scm(async_progress);
          g_r0 = ra;
          g_trampoline(g_r0);
        }
      }

      g_os_fs.close(dev.fd, callback);

      if (async_progress !== g_async_op_done) {
        // handle synchronous execution of callback
        return async_progress;
      } else {
        async_progress = g_async_op_in_progress;
        g_r0 = null; // exit trampoline
        return 0; // ignored
      }
    }

    return 0; // no error
  };

  g_os_device_from_fd = function (fd) {
    return new G_Device_fd(fd);
  };

  g_os_device_from_stdin = function () {
    return g_os_device_from_fd(0);
  };

  g_os_device_from_stdout = function () {
    return g_os_device_from_fd(1);
  };

  g_os_device_from_stderr = function () {
    return g_os_device_from_fd(2);
  };

  g_os_console = null;

  g_os_device_from_basic_console = function () {
    if (g_os_console === null) g_os_console = g_os_device_from_stdout();
    return g_os_console;
  };

}

if (g_os_web) {

  G_Device_basic_console = function () {

    var dev = this;
    dev.wbuf = new Uint8Array(0);
    dev.rbuf = new Uint8Array(1);
    dev.rlo = 1;
    dev.encoder = new TextEncoder();
    dev.decoder = new TextDecoder();
    dev.echo = true;
    dev.read_condvar_scm = null;
  };

  G_Device_basic_console.prototype.input_add = function (input) {

    var dev = this;
    var len = dev.rbuf.length-dev.rlo;
    var inp = dev.encoder.encode(input);
    if (dev.echo) dev.output_add_buffer(inp); // echo the input
    var newbuf = new Uint8Array(len + inp.length);
    newbuf.set(newbuf.subarray(dev.rlo, dev.rlo+len));
    newbuf.set(inp, len);
    dev.rbuf = newbuf;
    dev.rlo = 0;
  };

  G_Device_basic_console.prototype.output_add = function (output) {

    var dev = this;
    dev.output_add_buffer(dev.encoder.encode(output));
  };

  G_Device_basic_console.prototype.output_add_buffer = function (buffer) {

    var dev = this;
    var len = dev.wbuf.length;
    var newbuf = new Uint8Array(len + buffer.length);
    newbuf.set(dev.wbuf);
    newbuf.set(buffer, len);
    dev.wbuf = newbuf;

    if (!dev.use_async_output()) {
      // heuristic trimming of output so that it fits in the 'prompt' dialog
      var end = newbuf.length;
      var nl = end-1;
      var trim = 7; // trim to last 7 lines
      for (var n=0; n<trim; n++) {
        var prev = nl-1;
        while (prev >= 0 && newbuf[prev] !== 10) prev--; // find prev newline
        if (n > 1 && end-prev > 35*trim) break;
        nl = prev;
        if (prev < 0) break;
      }
      if (nl >= 0) dev.wbuf = newbuf.subarray(nl+1);
    }
  };

  G_Device_basic_console.prototype.use_async_input = function () {
    return false; // use a synchronous call to 'prompt' to get console input
  };

  G_Device_basic_console.prototype.use_async_output = function () {
    return false; // use a synchronous call to 'prompt' to show console output
  };

  G_Device_basic_console.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;
    var n = hi-lo;
    var have = dev.rbuf.length-dev.rlo;

    if (g_os_debug)
      console.log('G_Device_basic_console().read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    g_os_condvar_ready_set(dev_condvar_scm, false);

    if (have === 0) {

      if (dev.rlo === 0) {
        dev.rbuf = new Uint8Array(1); // prevent repeated EOF
        dev.rlo = 1;
        return 0; // signal EOF

      } else if (dev.use_async_input()) {

        // Input will be received asynchronously

        if (dev.read_condvar_scm === null) {
          dev.read_condvar_scm = dev_condvar_scm;
        }

        return -35; // return EAGAIN to suspend Scheme thread on condvar

      } else {

        var input = prompt(dev.decoder.decode(dev.wbuf) + '\\u258b                                                                                ');
        dev.wbuf = new Uint8Array(0);
        if (input === null) return 0; // cancel button gives EOF

        dev.input_add(input + '\\n');

        have = dev.rbuf.length-dev.rlo;
      }
    }

    if (n > have) n = have;

    buffer.set(dev.rbuf.subarray(dev.rlo, dev.rlo+n), lo);

    dev.rlo += n;

    return n; // number of bytes transferred
  };

  G_Device_basic_console.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_basic_console().write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    dev.output_add_buffer(buffer.subarray(lo, hi));

    return hi-lo;
  };

  G_Device_basic_console.prototype.force_output = function (dev_condvar_scm, level) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_basic_console().force_output(...,'+level+')');

    return 0; // no error
  };

  G_Device_basic_console.prototype.seek = function (dev_condvar_scm, pos, whence) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_basic_console().seek(...,'+pos+','+whence+')');

    return -1; // EPERM (operation not permitted)
  };

  G_Device_basic_console.prototype.width = function (dev_condvar_scm) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_basic_console().width()');

    return 80;
  };

  G_Device_basic_console.prototype.close = function (direction) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_basic_console().close('+direction+')');

    return 0; // no error
  };

  g_os_console = null;

  g_os_device_from_basic_console = function () {
    if (g_os_console === null) g_os_console = new G_Device_basic_console();
    return g_os_console;
  };

  g_os_device_from_stdin = function () {
    return g_os_device_from_basic_console();
  };

  g_os_device_from_stdout = function () {
    return new G_Device_jsconsole();
  };

  g_os_device_from_stderr = function () {
    return new G_Device_jsconsole();
  };

};

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
    elif e == errno.EACCES:
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
        return 'EACCES (Permission denied)'
    elif code == -17:
        return 'EEXIST (File exists)'
    elif code == -35:
        return 'EAGAIN (Resource temporarily unavailable)'
    else:
        return 'E??? (unknown error)'

def g_os_current_time():
    return time.time()

g_os_start_time = g_os_current_time()

def g_os_set_process_times(vect):
    elapsed = g_os_current_time() - g_os_start_time
    vect.elems[0] = elapsed
    vect.elems[1] = 0.0
    vect.elems[2] = elapsed
    return vect

g_os_debug = False

class G_Device_fd:

    def __init__(dev, fd):
        dev.fd = fd

    def read(dev, dev_condvar_scm, buffer, lo, hi):

        if g_os_debug:
            print('G_Device_fd('+repr(dev.fd)+').read(...,'+repr(buffer[0:20])+','+repr(lo)+','+repr(hi)+')')

        try:
            b = os.read(dev.fd, hi-lo)
            n = len(b)
            buffer[lo:lo+n] = b
        except OSError as exn:
            return g_os_encode_error(exn)

        return n  # number of bytes transferred

    def write(dev, dev_condvar_scm, buffer, lo, hi):

        if g_os_debug:
            print('G_Device_fd('+repr(dev.fd)+').write(...,'+repr(buffer[0:20])+','+repr(lo)+','+repr(hi)+')')

        try:
            n = os.write(dev.fd, buffer[lo:hi])
        except OSError as exn:
            return g_os_encode_error(exn)

        return n  # number of bytes transferred

    def force_output(dev, dev_condvar_scm, level):

        if g_os_debug:
            print('G_Device_fd('+repr(dev.fd)+').force_output(...,'+repr(level)+')')

        return 0  # no error

    def seek(dev, dev_condvar_scm, pos, whence):

        if g_os_debug:
            print('G_Device_fd('+repr(dev.fd)+').seek(...,'+repr(pos)+','+repr(whence)+')')

        if whence == 0:
            how = os.SEEK_SET
        elif whence == 1:
            how = os.SEEK_CUR
        else:
            how = os.SEEK_END

        try:
            os.lseek(dev.fd, pos, how)
        except OSError as exn:
            return g_os_encode_error(exn)

        return 0  # no error

    def width(dev, dev_condvar_scm):

        if g_os_debug:
            print('G_Device_fd('+repr(dev.fd)+').width(...)')

        return 80

    def close(dev, direction):

        if g_os_debug:
            print('G_Device_fd('+repr(dev.fd)+').close('+repr(direction)+')')

        if not ((direction & 3) == 0):  # DIRECTION_RD or DIRECTION_WR
            try:
                os.close(dev.fd)
            except OSError as exn:
                return g_os_encode_error(exn)

        return 0  # no error

def g_os_device_from_fd(fd):
    return G_Device_fd(fd)

def g_os_device_from_stdin():
    return g_os_device_from_fd(0)

def g_os_device_from_stdout():
    return g_os_device_from_fd(1)

def g_os_device_from_stderr():
    return g_os_device_from_fd(2)

g_os_console = None

def g_os_device_from_basic_console():
    global g_os_console
    if g_os_console is None:
        g_os_console = g_os_device_from_stdout()
    return g_os_console

"))

 (else))

(##declare (not inline))

(define ##err-code-ENOENT             -2)
(define ##err-code-EINTR              -4)
(define ##err-code-EACCES            -13)
(define ##err-code-EEXIST            -17)
(define ##err-code-EAGAIN            -35)
(define ##err-code-unimplemented   -9999)

(define ##min-fixnum          -536870912)
(define ##max-fixnum           536870911)
(define ##fixnum-width                30)
(define ##fixnum-width-neg           -30)
(define ##bignum.adigit-width         14)
(define ##bignum.mdigit-width         14)
(define ##max-char              #x10ffff)

(define ##os-bat-extension-string-saved "")
(define ##os-exe-extension-string-saved "")
(define ##os-configure-command-string-saved "./configure")
(define ##os-system-type-string-saved "unknown-system-type")
(define (##system-stamp) 20200101213000)

(define (##os-module-install-mode) 1)
(define (##os-module-search-order) '("~~lib" "~~userlib"))
(define (##os-module-whitelist)    '("github.com/gambit"))

(define (##get-parallelism-level) 1)
(define (##cpu-count) 1)
(define (##current-vm-resize vm n) #f)

(define (##get-standard-level) 0)

(define ##debug-settings 16) ;; exceptions start a REPL

(define (##set-debug-settings! mask new-settings)
  (let ((old-settings ##debug-settings))
    (set! ##debug-settings
          (##fxior (##fxand old-settings (##fxnot mask))
                   (##fxand new-settings mask)))
    old-settings))

(define (##disable-interrupts!) #f)
(define (##enable-interrupts!) #f)
(define (##interrupt-vector-set! code handler) #f)
(define (##add-gc-interrupt-job! thunk) #f)

(define (##check-heap) #f)
(define (##raise-heap-overflow-exception) #f)

(define (##explode-continuation cont) #f)
(define (##explode-frame frame) #f)

(define (##kernel-handlers) #f)

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

(define-prim (##os-device-tty-mode-reset)
  (##void))

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

;;; Apply.

(define (##apply proc arg1 . rest)
  (if (##pair? rest)

      (let loop ((prev arg1) (lst rest))
        (let ((temp (##car lst)))
          (##set-car! lst prev)
          (let ((tail (##cdr lst)))
            (if (##pair? tail)
                (loop temp tail)
                (begin
                  (##set-cdr! lst temp)
                  (##apply proc rest))))))

      (##apply proc arg1)))

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

g_eval = function (expr) {
  return (1,eval)(expr);
};

g_exec = function (stmts) {
  (1,eval)(stmts);
};

g_host_define_function = function (name, params, header, expr) {
  g_exec(name + ' = function (' + params + ') {' + header + '\\n return ' + expr + ';\\n};');
};

g_host_define_procedure = function (name, params, header, stmts) {
  g_exec(name + ' = function (' + params + ') {' + header + '\\n' + stmts + '\\n};');
};

g_host_function_call = function (fn, args) {
  return g_eval(fn).apply(this, args);
};

g_host_procedure_call = function (proc, args) {
  g_eval(proc).apply(this, args);
};

g_host_eval = function (expr) {
  return g_eval(expr);
};

g_host_exec = function (stmts) {
  g_exec(stmts);
};

"))

 ((python)
  (##inline-host-declaration "

def g_eval(expr):
    return eval(expr, globals())

def g_exec(stmts):
    exec(stmts, globals())

def g_host_define_function(name, params, header, expr):
    g_exec('def ' + name + '(' + params + '):' + header + '\\n return ' + expr)

def g_host_define_procedure(name, params, header, stmts):
    g_exec('def ' + name + '(' + params + '):' + header + stmts + '\\n')

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

(define (##host-convert-param param)
  (##declare (not interrupts-enabled))
  (##string-append "\n " param " = g_scm2host(" param ")"
                   (macro-case-target
                    ((js)
                     ";")
                    (else
                     ""))))

(define (##host-create-header params)
  (##append-strings (##map ##host-convert-param params)))

(define (##host-define-function-dynamic name params expr)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js python)
    (##inline-host-statement
     "g_host_define_function(g_scm2host(@1@),g_scm2host(@2@),g_scm2host(@3@),g_scm2host(@4@))"
     name
     (##append-strings params ",")
     (##host-create-header params)
     (##string-append "g_host2scm(" expr ")")))

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
     "g_host_define_procedure(g_scm2host(@1@),g_scm2host(@2@),g_scm2host(@3@),g_scm2host(@4@))"
     name
     (##append-strings params ",")
     (##host-create-header params)
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

(define (##scmobj obj)
  (##inline-host-expression
   "g_scm2scheme(@1@)"
   obj))

;;;----------------------------------------------------------------------------

;;; Error codes.

(define (##os-err-code->string code)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-expression
     "g_host2scm(g_os_decode_error(g_scm2host(@1@)))"
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
     "g_host2scm(g_os_nodejs ? process.pid : 0)"))

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
     "g_host2scm(g_os_nodejs ? os.hostname() : 'host-name')"))

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
     "g_host2scm(g_os_nodejs ? os.userInfo().username : 'user')"))

   ((python)
    (##inline-host-expression
     "g_host2scm(getpass.getuser())"))

   (else
    (println "unimplemented ##os-user-name called")
    "user")))

;;;----------------------------------------------------------------------------

;;; User and group information.

(define (##os-user-info ui user)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_user_info = function (ui, user) {
  if (g_os_nodejs) {

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

  } else if (g_os_web) {

    ui.slots[1] = g_host2scm('user');
    ui.slots[2] = g_host2scm(111);
    ui.slots[3] = g_host2scm(222);
    ui.slots[4] = g_host2scm('/home/user');
    ui.slots[5] = g_host2scm('/bin/sh');
    return ui;

  } else {
    return g_host2scm(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "g_os_user_info(@1@, g_scm2host(@2@))" ui user))

   ((python)
    (##inline-host-declaration "

def g_os_user_info(ui, user):
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

")
    (##inline-host-expression "g_os_user_info(@1@, g_scm2host(@2@))" ui user))

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

   ((js)
    (##inline-host-declaration "

g_os_group_info = function (gi, group) {
  if (g_os_nodejs) {

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

  } else if (g_os_web) {

    gi.slots[1] = g_host2scm('group');
    gi.slots[2] = g_host2scm(222);
    gi.slots[3] = g_host2scm([]);
    return gi;

  } else {
    return g_host2scm(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "g_os_group_info(@1@, g_scm2host(@2@))" gi group))

   ((python)
    (##inline-host-declaration "

def g_os_group_info(gi, group):
    try:
        gr = grp.getgrgid(group) if isinstance(group,int) else pwd.getgrnam(group)
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))
    gi.slots[1] = g_host2scm(gr[0])
    gi.slots[2] = g_host2scm(gr[2])
    gi.slots[3] = g_host2scm(gr[3])
    return gi

")
    (##inline-host-expression "g_os_group_info(@1@, g_scm2host(@2@))" gi group))

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

(define (##os-shell-command cmd)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_shell_command = function (cmd) {
  var r = child_process.spawnSync('sh',['-c',cmd]);
  var output = r.stdout.toString();
  if (output.length > 0) {
    console.log(output.replace(/\\n$/, ''));
  }
  return 256 * ((r.status === null) ? 0 : r.status);
};

")
    (##inline-host-expression
     "g_host2scm(g_os_shell_command(g_scm2host(@1@)))"
     cmd))

   ((python)
    (##inline-host-declaration "

def g_os_shell_command(cmd):
    return os.system(cmd)

")
    (##inline-host-expression
     "g_host2scm(g_os_shell_command(g_scm2host(@1@)))"
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
     "g_host2scm(g_os_nodejs ? os.homedir() : '/')"))

   ((python)
    (##inline-host-expression
     "g_host2scm(os.path.expanduser('~'))"))

   (else
    (println "unimplemented ##os-path-homedir called")
    "/")))

;;;----------------------------------------------------------------------------

;;; Path of executable (i.e. the host language script).

(define (##os-executable-path)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_executable_path = (g_os_nodejs) ? __filename : '/program';

")
    (##inline-host-expression "g_host2scm(g_executable_path)"))

   ((python)
    (##inline-host-declaration "

g_executable_path = os.path.abspath(__file__)

")
    (##inline-host-expression "g_host2scm(g_executable_path)"))

   (else
    (println "unimplemented ##os-executable-path called")
    "/program")))

;;;----------------------------------------------------------------------------

;;; Gambit directories.

(define (##os-path-gambitdir)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_path_gambitdir = function () {
  if (g_os_nodejs) {
    return g_host2scm('/usr/local/Gambit/');
  } else if (g_os_web) {
    return g_host2scm(g_os_web_origin);
  } else {
    return g_host2scm(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "g_os_path_gambitdir()"))

   (else
    "/usr/local/Gambit/")))

(define (##os-path-gambitdir-map-lookup name)
  #f)

;;;----------------------------------------------------------------------------

;;; Path normalization.

(define (##os-path-normalize-directory path)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_path_normalize_directory = function (path) {
  if (g_os_nodejs) {
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
      return g_host2scm(dir + '/');
    } else {
      return g_host2scm(dir + '\\\\');
    }
  } else if (g_os_web) {
    if (path === false) {
      return g_host2scm(g_os_web_origin);
    } else if (path.slice(0,1) === '/' || g_os_uri_scheme_prefixed(path)) {
      return g_host2scm(path + (path.slice(-1) === '/' ? '' : '/'));
    } else {
      return g_host2scm(g_os_web_origin + path);
    }
  } else {
    return g_host2scm(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "g_os_path_normalize_directory(g_scm2host(@1@))" path))

   ((python)
    (##inline-host-declaration "

def g_os_path_normalize_directory(path):
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

")
    (##inline-host-expression "g_os_path_normalize_directory(g_scm2host(@1@))" path))

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
      if (g_os_nodejs) {
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
    (##inline-host-statement "g_r0 = null;"))

   ((python)
    (##inline-host-statement "g_r0 = None"))

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
     (##inline-host-expression "g_host2scm(g_os_current_time())"))

    (else
     (println "unimplemented ##get-current-time! called")
     0.0))))

(define (##process-statistics)
  (##declare (not interrupts-enabled))
  (let ((v (##make-f64vector 20 0.0)))
    (macro-case-target

     ((js python)
      (##inline-host-expression "g_os_set_process_times(@1@)" v))

     (else
      (println "unimplemented ##process-statistics called")
      v))))

(define (##process-times)
  (##declare (not interrupts-enabled))
  (let ((v (##make-f64vector 3 0.0)))
    (macro-case-target

     ((js python)
      (##inline-host-expression "g_os_set_process_times(@1@)" v))

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
    (##inline-host-declaration "

g_os_argv = [];
if (g_os_nodejs) {
  g_os_argv = process.argv.slice(1);
}

")
    (##vector->list (##inline-host-expression "g_host2scm(g_os_argv)")))

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

(define ##feature-file-input
  (macro-case-target

   ((js)
    (##inline-host-declaration "

if (g_os_web) {

  g_os_whitelist = [];

  g_os_whitelist_add = function (url) {
    if (g_os_uri_scheme_prefixed(url) &&
        g_os_whitelist.indexOf(url) === -1) {
      g_os_whitelist.push(url);
    }
  };

  g_os_confirm_if_not_in_whitelist = false;

  g_os_remove_after_last_slash = function (string) {
    return string.slice(0, 1+string.lastIndexOf('/'));
  };

  g_os_trusted_url = function (url, reason) {
    for (var i=0; i<g_os_whitelist.length; i++) {
      var w = g_os_whitelist[i];
      if (w.slice(-1) === '/' // if ends with slash
          ? url.indexOf(w) === 0 // then it must be a prefix
          : url === w) { // otherwise it must be an exact match
        return true;
      }
    }
    if (g_os_confirm_if_not_in_whitelist &&
        reason !== undefined &&
        confirm(url + '\\nis being accessed ' + reason + '.\\nClick OK if you trust this URL for that operation.')) {
      return true;
    }
    return false;
  };

  g_os_web_origin = g_os_remove_after_last_slash(window.location.href);

  if (g_os_web_origin.indexOf('https://') === 0) {
    g_os_whitelist_add(g_os_web_origin); // only trust https origin
  }

  g_os_get_url_async = function (method, url, callback) {

    var req = new XMLHttpRequest();

    var onreadystatechange = function () {
      if (req.readyState == 4) { // DONE?
        callback(req);
      }
    };

    req.open(method, url);
    req.responseType = 'text';
    req.onreadystatechange = onreadystatechange;
    req.send();
  };

  g_os_uri_encode = function (uri) {

    function encode(c) {
      switch (c) {
        case '#': return '%23';
        default: return c;
      }
    }

    return uri.split('').map(encode).join('');
  };
}

"))

   (else
    #f)))

(define (##os-file-info fi path chase?)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##first-argument #f ##feature-file-input)
    (##inline-host-declaration "

g_os_file_info = function (fi, path, chase) {

  if (g_os_uri_scheme_prefixed(path)) { // accessing a URL?

    if (!(g_os_web && g_os_trusted_url(path, 'to check that document\\'s information'))) { // accessing an untrusted URL?
      return g_host2scm(-1); // EPERM (operation not permitted)
    } else {

      var ra = g_r0;
      g_r0 = null; // exit trampoline

      function callback(req) {

        if (req.status === 404) {
          g_r1 = g_host2scm(-2); // ENOENT (file does not exist)
        } else if (req.status !== 200) {
          g_r1 = g_host2scm(-1); // EPERM (operation not permitted)
        } else {

          var size = +req.getResponseHeader('Content-Length');

          fi.slots[ 1] = g_host2scm(1); // regular file
          fi.slots[ 2] = g_host2scm(0);
          fi.slots[ 3] = g_host2scm(0);
          fi.slots[ 4] = g_host2scm(0);
          fi.slots[ 5] = g_host2scm(0);
          fi.slots[ 6] = g_host2scm(0);
          fi.slots[ 7] = g_host2scm(0);
          fi.slots[ 8] = g_host2scm(size);
          fi.slots[ 9] = new G_Flonum(-Infinity);
          fi.slots[10] = new G_Flonum(-Infinity);
          fi.slots[11] = new G_Flonum(-Infinity);
          fi.slots[12] = g_host2scm(0);
          fi.slots[13] = new G_Flonum(-Infinity);

          g_r1 = fi;
        }

        g_r0 = ra;
        g_trampoline(g_r0);
      }

      g_os_get_url_async('HEAD', g_os_uri_encode(path), callback);

      return 0; // ignored
    }

  } else {

    if (!g_os_fs) {
      return g_host2scm(-1); // EPERM (operation not permitted)
    } else {

      var st;

      try {
        if (chase) {
          st = g_os_fs.statSync(path);
        } else {
          st = g_os_fs.lstatSync(path);
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

    }
  }
};

")
    (##inline-host-expression
     "g_os_file_info(@1@, g_scm2host(@2@), g_scm2host(@3@))"
     fi
     path
     chase?))

   ((python)
    (##inline-host-declaration "

def g_os_file_info(fi, path, chase):

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

")
    (##inline-host-expression
     "g_os_file_info(@1@, g_scm2host(@2@), g_scm2host(@3@))"
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

;;; Loading of compiled files.

(define (##os-load-object-file path linker-name)
  (##declare (not interrupts-enabled))
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_load_object_file = function (path, linker_name) {

  if (g_os_nodejs) {

    try {
      require(path);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return g_host2scm(g_os_encode_error(exn));
      } else {
        throw exn;
      }
    }

    return [[g_module_latest_registered], null, false];

  } else if (g_os_web &&
             g_os_trusted_url(path, 'to execute that code')) { // accessing an untrusted URL?

    var ra = g_r0;
    g_r0 = null; // exit trampoline

    function onload() {
      g_r1 = [[g_module_latest_registered], null, false];
      g_r0 = ra;
      g_trampoline(g_r0);
    }

    function onerror() {
      g_r1 = g_host2scm(-2); // ENOENT (file does not exist)
      g_r0 = ra;
      g_trampoline(g_r0);
    }

    var script = document.createElement('script');
    script.type = 'text/javascript';
    script.src = path;
    script.onload = onload;
    script.onerror = onerror;
    document.head.append(script);

    return 0; // ignored

  } else {
    return g_host2scm(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression
     "g_os_load_object_file(g_scm2host(@1@), g_scm2host(@2@))"
     path
     linker-name))

   ((python)
    (##inline-host-declaration "

def g_os_load_object_file(path, linker_name):

    try:
        g_exec(open(path).read())
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))

    return [[g_module_latest_registered], g_null_obj, False]

")
    (##inline-host-expression
     "g_os_load_object_file(g_scm2host(@1@), g_scm2host(@2@))"
     path
     linker-name))

   (else
    (##vector "load-object-file not implemented" linker-name))))

;;;----------------------------------------------------------------------------

;;; File I/O.

(##declare (inline))

(define ##feature-port-fields
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_BTQ_DEQ_NEXT              = 2;
g_BTQ_DEQ_PREV              = 3;
g_BTQ_COLOR                 = 4;
g_BTQ_PARENT                = 5;
g_BTQ_LEFT                  = 6;
g_BTQ_RIGHT                 = 7;
g_BTQ_LEFTMOST              = 7;
g_BTQ_OWNER                 = 8;

g_FOR_READING               = 0;
g_FOR_WRITING               = 1;
g_FOR_EVENT                 = 2;

g_CONDVAR_NAME              = 10;

g_PORT_MUTEX                = 1;
g_PORT_RKIND                = 2;
g_PORT_WKIND                = 3;
g_PORT_NAME                 = 4;
g_PORT_WAIT                 = 5;
g_PORT_CLOSE                = 6;
g_PORT_ROPTIONS             = 7;
g_PORT_RTIMEOUT             = 8;
g_PORT_RTIMEOUT_THUNK       = 9;
g_PORT_SET_RTIMEOUT         = 10;
g_PORT_WOPTIONS             = 11;
g_PORT_WTIMEOUT             = 12;
g_PORT_WTIMEOUT_THUNK       = 13;
g_PORT_SET_WTIMEOUT         = 14;
g_PORT_IO_EXCEPTION_HANDLER = 15;

g_PORT_OBJECT_READ_DATUM    = 16;
g_PORT_OBJECT_WRITE_DATUM   = 17;
g_PORT_OBJECT_NEWLINE       = 18;
g_PORT_OBJECT_FORCE_OUTPUT  = 19;

g_PORT_OBJECT_OTHER1        = 20;
g_PORT_OBJECT_OTHER2        = 21;
g_PORT_OBJECT_OTHER3        = 22;

g_PORT_CHAR_RBUF            = 20;
g_PORT_CHAR_RLO             = 21;
g_PORT_CHAR_RHI             = 22;
g_PORT_CHAR_RCHARS          = 23;
g_PORT_CHAR_RLINES          = 24;
g_PORT_CHAR_RCURLINE        = 25;
g_PORT_CHAR_RBUF_FILL       = 26;
g_PORT_CHAR_PEEK_EOFP       = 27;

g_PORT_CHAR_WBUF            = 28;
g_PORT_CHAR_WLO             = 29;
g_PORT_CHAR_WHI             = 30;
g_PORT_CHAR_WCHARS          = 31;
g_PORT_CHAR_WLINES          = 32;
g_PORT_CHAR_WCURLINE        = 33;
g_PORT_CHAR_WBUF_DRAIN      = 34;
g_PORT_INPUT_READTABLE      = 35;
g_PORT_OUTPUT_READTABLE     = 36;
g_PORT_OUTPUT_WIDTH         = 37;

g_PORT_CHAR_OTHER1          = 38;
g_PORT_CHAR_OTHER2          = 39;
g_PORT_CHAR_OTHER3          = 40;
g_PORT_CHAR_OTHER4          = 41;
g_PORT_CHAR_OTHER5          = 42;

g_PORT_BYTE_RBUF            = 38;
g_PORT_BYTE_RLO             = 39;
g_PORT_BYTE_RHI             = 40;
g_PORT_BYTE_RBUF_FILL       = 41;

g_PORT_BYTE_WBUF            = 42;
g_PORT_BYTE_WLO             = 43;
g_PORT_BYTE_WHI             = 44;
g_PORT_BYTE_WBUF_DRAIN      = 45;

g_PORT_BYTE_OTHER1          = 46;
g_PORT_BYTE_OTHER2          = 47;

g_PORT_RDEVICE_COND         = 46;
g_PORT_WDEVICE_COND         = 47;

g_PORT_DEVICE_OTHER1        = 48;
g_PORT_DEVICE_OTHER2        = 49;

"))

   ((python)
    (##inline-host-declaration "

g_BTQ_DEQ_NEXT              = 2
g_BTQ_DEQ_PREV              = 3
g_BTQ_COLOR                 = 4
g_BTQ_PARENT                = 5
g_BTQ_LEFT                  = 6
g_BTQ_RIGHT                 = 7
g_BTQ_LEFTMOST              = 7
g_BTQ_OWNER                 = 8

g_FOR_READING               = 0
g_FOR_WRITING               = 1
g_FOR_EVENT                 = 2

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

"))

   (else
    #f)))

(define-prim (##os-device-close dev direction)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_close = function (dev_scm, direction_scm) {

  var dev = g_foreign2host(dev_scm);
  var direction = g_scm2host(direction_scm);

  return g_host2scm(dev.close(direction));
};

")
    (##inline-host-expression
     "g_os_device_close(@1@,@2@)"
     dev
     direction))

   ((python)
    (##inline-host-declaration "

def g_os_device_close(dev_scm, direction_scm):

    dev = g_foreign2host(dev_scm)
    direction = g_scm2host(direction_scm)

    return g_host2scm(dev.close(direction))

")
    (##inline-host-expression
     "g_os_device_close(@1@,@2@)"
     dev
     direction))

   (else
    (println "unimplemented ##os-device-close called")
    -5555)))

(define-prim (##os-device-directory-open-path path ignore-hidden)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_directory_open_path = function (path_scm, ignore_hidden_scm) {

  var path = g_scm2host(path_scm);
  var ignore_hidden = g_scm2host(ignore_hidden_scm);

  if (g_os_debug)
    console.log('g_os_device_directory_open_path(\\''+path+'\\','+ignore_hidden+')  ***not implemented***');

  return g_host2scm(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "g_os_device_directory_open_path(@1@,@2@)"
     path
     ignore-hidden))

   ((python)
    (##inline-host-declaration "

def g_os_device_directory_open_path(path_scm, ignore_hidden_scm):

    path = g_scm2host(path_scm)
    ignore_hidden = g_scm2host(ignore_hidden_scm)

    if g_os_debug:
        print('g_os_device_directory_open_path('+repr(path)+','+repr(ignore_hidden)+')  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_directory_open_path(@1@,@2@)"
     path
     ignore-hidden))

   (else
    (println "unimplemented ##os-device-directory-open-path called")
    -5555)))

(define ##feature-main-event-queue
  (macro-case-target

   ((js)
    (##inline-host-declaration "

G_Device_event_queue = function (selector) {
  var dev = this;
  dev.selector = selector;
  dev.queue = [];
  dev.read_condvar_scm = null;
};

G_Device_event_queue.prototype.read = function (dev_condvar_scm) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_event_queue('+dev.selector+').read(...)');

  if (dev.queue.length === 0) {

    g_os_condvar_ready_set(dev_condvar_scm, false);

    if (dev.read_condvar_scm === null) {
      dev.read_condvar_scm = dev_condvar_scm;
    }

    return -35; // return EAGAIN to suspend Scheme thread on condvar
  }

  return dev.queue.shift(); // return first available event
};

G_Device_event_queue.prototype.write = function (event_scm) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_event_queue('+dev.selector+').write(...)');

  dev.queue.push(event_scm);

  var condvar_scm = dev.read_condvar_scm;

  if (condvar_scm !== null) {
    dev.read_condvar_scm = null;
    g_os_condvar_ready_set(condvar_scm, true);
  }
};

g_main_event_queue = new G_Device_event_queue(g_host2scm(false));

"))

   (else
    #f)))

(define-prim (##os-device-directory-read dev-condvar)
  (macro-case-target

   ((js)
    (##first-argument #f ##feature-main-event-queue)
    (##inline-host-declaration "

g_os_device_directory_read = function (dev_condvar_scm) {

  var dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME]);

  if (g_os_debug)
    console.log('g_os_device_directory_read(...)  ***not implemented***');

  return g_host2scm(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "g_os_device_directory_read(@1@)"
     dev-condvar))

   ((python)
    (##inline-host-declaration "

def g_os_device_directory_read(dev_condvar_scm):

    dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME])

    if g_os_debug:
        print('g_os_device_directory_read(...)  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_directory_read(@1@)"
     dev-condvar))

   (else
    (println "unimplemented ##os-device-directory-read called")
    -5555)))

(define-prim (##os-device-event-queue-open selector)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_event_queue_open = function (selector_scm) {

  var selector = g_scm2host(selector_scm);

  if (g_os_debug)
    console.log('g_os_device_event_queue_open('+selector+')');

  var dev;

  if (selector === false) {
    dev = g_main_event_queue;
  } else {
    dev = new G_Device_event_queue(selector);
  }

  return g_host2foreign(dev);
};

")
    (##inline-host-expression
     "g_os_device_event_queue_open(@1@)"
     selector))

   ((python)
    (##inline-host-declaration "

def g_os_device_event_queue_open(selector_scm):

    selector = g_scm2host(selector_scm)

    if g_os_debug:
        print('g_os_device_event_queue_open('+repr(selector)+')  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_event_queue_open(@1@)"
     selector))

   (else
    (println "unimplemented ##os-device-event-queue-open called")
    -5555)))

(define-prim (##os-device-event-queue-read dev-condvar)
  (macro-case-target

   ((js)
    (##first-argument #f ##feature-main-event-queue)
    (##inline-host-declaration "

g_os_device_event_queue_read = function (dev_condvar_scm) {

  var dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME]);

  if (g_os_debug)
    console.log('g_os_device_event_queue_read(...)');

  return dev.read(dev_condvar_scm);
};

")
    (##inline-host-expression
     "g_os_device_event_queue_read(@1@)"
     dev-condvar))

   ((python)
    (##inline-host-declaration "

def g_os_device_event_queue_read(dev_condvar_scm):

    dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME])

    if g_os_debug:
        print('g_os_device_event_queue_read(...)  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_event_queue_read(@1@)"
     dev-condvar))

   (else
    (println "unimplemented ##os-device-event-queue-read called")
    -5555)))

(define-prim (##os-device-force-output dev-condvar level)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_force_output = function (dev_condvar_scm, level_scm) {

  var dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME]);
  var level = g_scm2host(level_scm);

  return g_host2scm(dev.force_output(dev_condvar_scm, level));
};

")
    (##inline-host-expression
     "g_os_device_force_output(@1@,@2@)"
     dev-condvar
     level))

   ((python)
    (##inline-host-declaration "

def g_os_device_force_output(dev_condvar_scm, level_scm):

    dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME])
    level = g_scm2host(level_scm)

    return g_host2scm(dev.force_output(dev_condvar_scm, level))

")
    (##inline-host-expression
     "g_os_device_force_output(@1@,@2@)"
     dev-condvar
     level))

   (else
    (println "unimplemented ##os-device-force-output called")
    -5555)))

(define-prim (##os-device-kind dev)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_kind = function (dev_scm) {

  var dev = g_foreign2host(dev_scm);

  if (g_os_debug)
    console.log('g_os_device_kind(...)  ***not fully implemented***');

  return g_host2scm(31+32); // file device
};

")
    (##inline-host-expression
     "g_os_device_kind(@1@)"
     dev))

   ((python)
    (##inline-host-declaration "

def g_os_device_kind(dev_scm):

    dev = g_foreign2host(dev_scm)

    if g_os_debug:
        print('g_os_device_kind(...)  ***not fully implemented***')

    return g_host2scm(31+32)  # file device

")
    (##inline-host-expression
     "g_os_device_kind(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-kind called")
    -5555)))

(define-prim (##os-device-stream-open-process path-and-args environment directory options)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_open_process = function (path_and_args_scm, environment_scm, directory_scm, options_scm) {

  if (g_os_debug)
    console.log('g_os_device_stream_open_process(...)  ***not implemented***');

  return g_host2scm(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "g_os_device_stream_open_process(@1@,@2@,@3@,@4@)"
     path-and-args
     environment
     directory
     options))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_open_process(path_and_args_scm, environment_scm, directory_scm, options_scm):

    if g_os_debug:
        print('g_os_device_stream_open_process(...)  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_stream_open_process(@1@,@2@,@3@,@4@)"
     path-and-args
     environment
     directory
     options))

   (else
    (println "unimplemented ##os-device-stream-open-process called")
    -5555)))

(define-prim (##os-device-process-pid dev)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_process_pid = function (dev_scm) {

  var dev = g_foreign2host(dev_scm);

  if (g_os_debug)
    console.log('g_os_device_process_pid(...)  ***not implemented***');

  return g_host2scm(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "g_os_device_process_pid(@1@)"
     dev))

   ((python)
    (##inline-host-declaration "

def g_os_device_process_pid(dev_scm):

    dev = g_foreign2host(dev_scm)

    if g_os_debug:
        print('g_os_device_process_pid(...)  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_process_pid(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-process-pid called")
    -5555)))

(define-prim (##os-device-process-status dev)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_process_status = function (dev_scm) {

  var dev = g_foreign2host(dev_scm);

  if (g_os_debug)
    console.log('g_os_device_process_status(...)  ***not implemented***');

  return g_host2scm(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "g_os_device_process_status(@1@)"
     dev))

   ((python)
    (##inline-host-declaration "

def g_os_device_process_status(dev_scm):

    dev = g_foreign2host(dev_scm)

    if g_os_debug:
        print('g_os_device_process_status(...)  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_process_status(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-process-status called")
    -5555)))

(define-prim (##os-device-stream-default-options dev)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_default_options = function (dev_scm) {

  var dev = g_foreign2host(dev_scm);

  if (g_os_debug)
    console.log('g_os_device_stream_default_options(...)  ***not fully implemented***');

  return g_host2scm(((2<<9)<<15)+(2<<9)); // line buffering
};

")
    (##inline-host-expression
     "g_os_device_stream_default_options(@1@)"
     dev))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_default_options(dev_scm):

    dev = g_foreign2host(dev_scm)

    if g_os_debug:
        print('g_os_device_stream_default_options(...)  ***not fully implemented***')

    return g_host2scm(((2<<9)<<15)+(2<<9))  # line buffering

")
    (##inline-host-expression
     "g_os_device_stream_default_options(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-stream-default-options called")
    -5555)))

(define-prim (##os-device-stream-options-set! dev options)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_options_set = function (dev_scm, options_scm) {

  var dev = g_foreign2host(dev_scm);
  var options = g_scm2host(options_scm);

  if (g_os_debug)
    console.log('g_os_device_stream_options_set(...,'+options+')  ***not implemented***');

  return g_host2scm(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "g_os_device_stream_options_set(@1@,@2@)"
     dev
     options))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_options_set(dev_scm, options_scm):

    dev = g_foreign2host(dev_scm)
    options = g_scm2host(options_scm)

    if g_os_debug:
        print('g_os_device_stream_options_set(...,'+repr(options)+')  ***not implemented***')

    return g_host2scm(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "g_os_device_stream_options_set(@1@,@2@)"
     dev
     options))

   (else
    (println "unimplemented ##os-device-stream-options-set! called")
    -5555)))

(define-prim (##os-device-stream-open-predefined index flags)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_open_predefined = function (index_scm, flags_scm) {

  var index = g_scm2host(index_scm);
  var flags = g_scm2host(flags_scm);

  if (g_os_debug)
    console.log('g_os_device_stream_open_predefined('+index+','+flags+')');

  var dev;

  switch (index) {
    case -1: dev = g_os_device_from_stdin();   break;
    case -2: dev = g_os_device_from_stdout();  break;
    case -3: dev = g_os_device_from_stderr();  break;
    case -4: dev = g_os_device_from_basic_console(); break;
    default: dev = g_os_device_from_fd(index); break;
  }

  return g_host2foreign(dev);
};

")
    (##inline-host-expression
     "g_os_device_stream_open_predefined(@1@,@2@)"
     index
     flags))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_open_predefined(index_scm, flags_scm):

    index = g_scm2host(index_scm)
    flags = g_scm2host(flags_scm)

    if g_os_debug:
      print('g_os_device_stream_open_predefined('+repr(index)+','+repr(flags)+')')

    if index == -1:
        dev = g_os_device_from_stdin()
    elif index == -2:
        dev = g_os_device_from_stdout()
    elif index == -3:
        dev = g_os_device_from_stderr()
    elif index == -4:
        dev = g_os_device_from_basic_console()
    else:
        dev = g_os_device_from_fd(index)

    return g_host2foreign(dev)

")
    (##inline-host-expression
     "g_os_device_stream_open_predefined(@1@,@2@)"
     index
     flags))

   (else
    (println "unimplemented ##os-device-stream-open-predefined called")
    -5555)))

(define-prim (##os-device-stream-open-path path flags mode)
  (macro-case-target

   ((js)
    (##first-argument #f ##feature-file-input)
    (##inline-host-declaration "

if (g_os_fs) {

  g_os_translate_flags = function (flags) {

    var direction = (flags >> 4) & 3;
    var append = ((flags >> 3) & 1) !== 0;
    var creat = ((flags >> 1) & 3) !== 0;
    var excl = ((flags >> 1) & 3) === 2;
    var trunc = (flags & 1) !== 0;

    if (direction === 1) {
      // O_RDONLY
      return 'r';
    } else if (direction === 2) {
      // O_WRONLY
      if (creat) {
        if (trunc) {
          return excl ? 'wx' : 'w';
        } else if (append) {
          return excl ? 'ax' : 'a';
        } else {
          return null; // unknown mode
        }
      } else {
        return null; // unknown mode
      }
    } else {
      // O_RDWR
      if (creat) {
        if (trunc) {
          return excl ? 'wx+' : 'w+';
        } else if (append) {
          return excl ? 'ax+' : 'a+';
        } else {
          return null; // unknown mode
        }
      } else {
        return 'r+';
      }
    }
  };
}

if (g_os_web) {

  G_Device_blob = function (blob) {
    var dev = this;
    dev.rbuf = blob;
    dev.rlo = 0;
    dev.rhi = blob.length;
  };

  G_Device_blob.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_blob(...).read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    var n = hi-lo;
    var have = dev.rhi-dev.rlo;

    if (have <= 0) {
      return g_host2scm(0); // signal EOF
    } else {

      if (n > have) n = have;

      buffer.set(dev.rbuf.subarray(dev.rlo, dev.rlo+n), lo);

      dev.rlo += n;

      return g_host2scm(n); // number of bytes transferred
    };
  };

  G_Device_blob.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_blob(...).write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    return -1; // EPERM (operation not permitted)
  };

  G_Device_blob.prototype.force_output = function (dev_condvar_scm, level) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_blob(...).force_output(...,'+level+')');

    return -1; // EPERM (operation not permitted)
  };

  G_Device_blob.prototype.seek = function (dev_condvar_scm, pos, whence) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_blob(...).seek(...,'+pos+','+whence+')');

    return -1; // EPERM (operation not permitted)
  };

  G_Device_blob.prototype.width = function (dev_condvar_scm) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_blob(...).width()');

    return -1; // EPERM (operation not permitted)
  };

  G_Device_blob.prototype.close = function (direction) {

    var dev = this;

    if (g_os_debug)
      console.log('G_Device_blob(...).close('+direction+')');

    if ((direction & 1) != 0 ||  // DIRECTION_RD
        (direction & 2) != 0) {  // DIRECTION_WR

      dev.rbuf = new Uint8Array(0);
      dev.rlo = 0;
      dev.rhi = 0;

      return 0; // ignored
    }

    return 0; // no error
  };

  g_os_device_from_blob = function (blob) {
    return new G_Device_blob(blob);
  };
}

g_os_device_stream_open_path = function (path_scm, flags_scm, mode_scm) {

  var path = g_scm2host(path_scm);
  var flags = g_scm2host(flags_scm);
  var mode = g_scm2host(mode_scm);

  if (g_os_debug)
    console.log('g_os_device_stream_open_path(\\''+path+'\\','+flags+','+mode+')');

  if (g_os_uri_scheme_prefixed(path)) { // accessing a URL?

    if (!(g_os_web && g_os_trusted_url(path, 'to read that document'))) { // accessing an untrusted URL?
      return g_host2scm(-1); // EPERM (operation not permitted)
    } else {

      if (((flags >> 4) & 3) === 1) { // for reading?

        var ra = g_r0;
        g_r0 = null; // exit trampoline

        function callback(req) {

          if (req.status === 404) {
            g_r1 = g_host2scm(-2); // ENOENT (file does not exist)
          } else if (req.status !== 200) {
            g_r1 = g_host2scm(-1); // EPERM (operation not permitted)
          } else {
            var dev = g_os_device_from_blob(new TextEncoder().encode(req.responseText));
            g_r1 = g_host2foreign(dev);
          }

          g_r0 = ra;
          g_trampoline(g_r0);
        }

        g_os_get_url_async('GET', g_os_uri_encode(path), callback);

        return 0; // ignored
      } else {
        return g_host2scm(-1); // EPERM (operation not permitted)
      }
    }

  } else {

    if (!g_os_fs) {
      return g_host2scm(-1); // EPERM (operation not permitted)
    } else {

      // Start an async open of the file

      var async_progress = g_async_op_done; // open not yet started
      var ra = g_r0;

      function callback(err, fd) {
        var progress = async_progress;
        if (err) {
          async_progress = g_host2scm(g_os_encode_error(err));
        } else {
          async_progress = g_host2foreign(g_os_device_from_fd(fd));
        }
        if (progress === g_async_op_in_progress) {
          g_r1 = async_progress;
          g_r0 = ra;
          g_trampoline(g_r0);
        }
      }

      g_os_fs.open(path, g_os_translate_flags(flags), mode, callback);

      if (async_progress !== g_async_op_done) {
        // handle synchronous execution of callback
        return async_progress;
      } else {
        async_progress = g_async_op_in_progress;
        g_r0 = null; // exit trampoline
        return 0; // ignored
      }
    }
  }
};

")
    (##inline-host-expression
     "g_os_device_stream_open_path(@1@,@2@,@3@)"
     path
     flags
     mode))

   ((python)
    (##inline-host-declaration "

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

def g_os_device_stream_open_path(path_scm, flags_scm, mode_scm):

    path = g_scm2host(path_scm)
    flags = g_scm2host(flags_scm)
    mode = g_scm2host(mode_scm)

    if g_os_debug:
        print('g_os_device_stream_open_path('+repr(path)+','+repr(flags)+','+repr(mode)+')')

    try:
        fd = os.open(path, g_os_translate_flags(flags), mode)
    except OSError as exn:
        return g_host2scm(g_os_encode_error(exn))

    dev = g_os_device_from_fd(fd)

    return g_host2foreign(dev)

")
    (##inline-host-expression
     "g_os_device_stream_open_path(@1@,@2@,@3@)"
     path
     flags
     mode))

   (else
    (println "unimplemented ##os-device-stream-open-path called")
    -5555)))

(define-prim (##os-device-stream-read dev-condvar buffer lo hi)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_read = function (dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME]);
  var buffer = buffer_scm.elems;
  var lo = g_scm2host(lo_scm);
  var hi = g_scm2host(hi_scm);

  return g_host2scm(dev.read(dev_condvar_scm, buffer, lo, hi));
};

")
    (##inline-host-expression
     "g_os_device_stream_read(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_read(dev_condvar_scm, buffer_scm, lo_scm, hi_scm):

    dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME])
    buffer = buffer_scm.elems
    lo = g_scm2host(lo_scm)
    hi = g_scm2host(hi_scm)

    return g_host2scm(dev.read(dev_condvar_scm, buffer, lo, hi))

")
    (##inline-host-expression
     "g_os_device_stream_read(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   (else
    (println "unimplemented ##os-device-stream-read called")
    -5555)))

(define-prim (##os-device-stream-write dev-condvar buffer lo hi)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_write = function (dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME]);
  var buffer = buffer_scm.elems;
  var lo = g_scm2host(lo_scm);
  var hi = g_scm2host(hi_scm);

  return g_host2scm(dev.write(dev_condvar_scm, buffer, lo, hi));
};

")
    (##inline-host-expression
     "g_os_device_stream_write(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_write(dev_condvar_scm, buffer_scm, lo_scm, hi_scm):

    dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME])
    buffer = buffer_scm.elems
    lo = g_scm2host(lo_scm)
    hi = g_scm2host(hi_scm)

    return g_host2scm(dev.write(dev_condvar_scm, buffer, lo, hi))

")
    (##inline-host-expression
     "g_os_device_stream_write(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   (else
    (println "unimplemented ##os-device-stream-write called")
    -5555)))

(define-prim (##os-device-stream-seek dev-condvar pos whence)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_seek = function (dev_condvar_scm, pos_scm, whence_scm) {

  var dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME]);
  var pos = g_scm2host(pos_scm);
  var whence = g_scm2host(whence_scm);

  return g_host2scm(dev.seek(dev_condvar_scm, pos, whence));
};

")
    (##inline-host-expression
     "g_os_device_stream_seek(@1@,@2@,@3@)"
     dev-condvar
     pos
     whence))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_seek(dev_condvar_scm, pos_scm, whence_scm):

    dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME])
    pos = g_scm2host(pos_scm)
    whence = g_scm2host(whence_scm)

    return g_host2scm(dev.seek(dev_condvar_scm, pos, whence))

")
    (##inline-host-expression
     "g_os_device_stream_seek(@1@,@2@,@3@)"
     dev-condvar
     pos
     whence))

   (else
    (println "unimplemented ##os-device-stream-seek called")
    -5555)))

(define-prim (##os-device-stream-width dev-condvar)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_device_stream_width = function (dev_condvar_scm) {

  var dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME]);

  return g_host2scm(dev.width(dev_condvar_scm));
};

")
    (##inline-host-expression
     "g_os_device_stream_width(@1@)"
     dev-condvar))

   ((python)
    (##inline-host-declaration "

def g_os_device_stream_width(dev_condvar_scm):

    dev = g_foreign2host(dev_condvar_scm.slots[g_CONDVAR_NAME])

    return g_host2scm(dev.width(dev_condvar_scm))

")
    (##inline-host-expression
     "g_os_device_stream_width(@1@)"
     dev-condvar))

   (else
    (println "unimplemented ##os-device-stream-width called")
    -5555)))

(define-prim (##os-port-decode-chars! port want eof)
  (##first-argument #f ##feature-port-fields)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_port_decode_chars = function (port_scm, want_scm, eof_scm) {

  var want = g_scm2host(want_scm);
  var eof = g_scm2host(eof_scm);

  if (g_os_debug)
    console.log('g_os_port_decode_chars(port,'+want+','+eof+')  ***not fully implemented***');

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
};

")
    (##inline-host-expression
     "g_os_port_decode_chars(@1@,@2@,@3@)"
     port
     want
     eof))

   ((python)
    (##inline-host-declaration "

def g_os_port_decode_chars(port_scm, want_scm, eof_scm):

    want = g_scm2host(want_scm)
    eof = g_scm2host(eof_scm)

    if g_os_debug:
        print('g_os_port_decode_chars(port,'+repr(want)+','+repr(eof)+')  ***not fully implemented***')

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

")
    (##inline-host-expression
     "g_os_port_decode_chars(@1@,@2@,@3@)"
     port
     want
     eof))

   (else
    (println "unimplemented ##os-port-decode-chars! called")
    -5555)))

(define-prim (##os-port-encode-chars! port)
  (##first-argument #f ##feature-port-fields)
  (macro-case-target

   ((js)
    (##inline-host-declaration "

g_os_port_encode_chars = function (port_scm) {

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
};

")
    (##inline-host-expression
     "g_os_port_encode_chars(@1@)"
     port))

   ((python)
    (##inline-host-declaration "

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

")
    (##inline-host-expression
     "g_os_port_encode_chars(@1@)"
     port))

   (else
    (println "unimplemented ##os-port-encode-chars! called")
    -5555)))

(define-prim (##os-condvar-select! devices timeout)
  (##declare (not interrupts-enabled))
  (##first-argument #f ##feature-port-fields)
  (macro-case-target

   ((js)
    (##first-argument #f ##feature-main-event-queue)
    (##inline-host-declaration "

g_os_condvar_ready_set = function (condvar_scm, ready) {

  var owner = condvar_scm.slots[g_BTQ_OWNER];

  if (ready) {
    condvar_scm.slots[g_BTQ_OWNER] = owner | 1; // mark as 'ready'
    g_os_condvar_select_resume();
  } else {
    condvar_scm.slots[g_BTQ_OWNER] = owner & ~1; // mark as 'not ready'
  }

};

g_os_condvar_select_resume = function () {

  g_os_condvar_select_resume_cancel();

  // execute continuation if there is one

  var cont = g_os_condvar_select_resume_ra;

  if (cont !== null) {
    g_os_condvar_select_resume_ra = null;
    g_r1 = g_host2scm(0);
    g_r0 = cont;
    g_trampoline(g_r0);
  }
};

g_os_condvar_select_resume_cancel = function () {

  // cancel time-delayed resume if there is one

  if (g_os_condvar_select_resume_timeoutId !== null) {
    clearTimeout(g_os_condvar_select_resume_timeoutId);
    g_os_condvar_select_resume_timeoutId = null;
  }

};

g_os_condvar_select_resume_timeoutId = null;
g_os_condvar_select_resume_ra = null;

g_os_condvar_select = function (devices_scm, timeout_scm) {

  var timeout_ms;

  if (timeout_scm === false)
    timeout_ms = 0;
  else if (timeout_scm === true)
    timeout_ms = 999999; // almost forever...
  else
    timeout_ms = (timeout_scm.elems[0]-g_os_current_time()) * 1000;

  if (g_os_debug) {
    var no_devices = (devices_scm === false ||
                      devices_scm === devices_scm.slots[g_BTQ_DEQ_NEXT]);
    console.log('g_os_condvar_select('+(no_devices?'no devices':'some devices')+', '+timeout_ms+' ms)');
  }

  if (g_main_event_queue.queue.length > 0) {
    // There are events in the main event queue, so there
    // is no need to wait for other events.
    timeout_ms = 0;
  }

  // The Scheme code execution needs to be suspended to allow the
  // JavaScript VM (browser) to handle events.  These events (or
  // expiration of the timeout) will in turn cause the execution
  // of the Scheme code to resume.  Note that browsers implement
  // 'clamping' of the timeout after a certain number of nested calls
  // (typically 5 ms), and this may impact performance.

  // resume execution at g_r0 after the timeout

  g_os_condvar_select_resume_ra = g_r0;
  g_r0 = null; // exit trampoline
  g_os_condvar_select_resume_timeoutId =
    setTimeout(g_os_condvar_select_resume, Math.max(0, timeout_ms));

  return 0; // ignored
};

")
    (##inline-host-expression
     "g_os_condvar_select(@1@,@2@)"
     devices
     timeout))

   ((python)
    (##inline-host-declaration "

def g_os_condvar_select(devices_scm, timeout_scm):

    if g_os_debug:
        print('g_os_condvar_select(devices, timeout)')

    return g_host2scm(False)  # no error

")
    (##inline-host-expression
     "g_os_condvar_select(@1@,@2@)"
     devices
     timeout))

   (else
    (println "unimplemented ##os-condvar-select! called")
    -5555)))

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
             (##raise-ill-formed-special-form src)))))))

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
             (##raise-ill-formed-special-form src)))))))

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
             (##raise-ill-formed-special-form src)))))))

(define-runtime-syntax host-eval
  (##make-alias-syntax '##host-eval))

(define (scmobj obj)
  (##scmobj obj))

(define-prim (##foreign-address f)
  0)

;;;----------------------------------------------------------------------------

(##load-vm)

;;;============================================================================
