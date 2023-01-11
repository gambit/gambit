;;;============================================================================

;;; File: "_univlib.scm"

;;; Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved.

;;;============================================================================

(cond-expand

 ((compilation-target js)
  (##inline-host-declaration "

// Autodetect when running in a web browser (as opposed to nodejs).
@os_web@ = (function () { return this === this.window; })();

// Autodetect availability of nodejs features.
if (typeof @os_nodejs@ === 'undefined') {
  @os_nodejs@ = !@os_web@;
}

if (@os_nodejs@) {
  os = require('os');
  vm = require('vm');
  process = require('process');
  child_process = require('child_process')
  if (typeof @os_fs@ === 'undefined') {
    @os_fs@ = require('fs');
    @os_buffer@ = require('buffer');
  }
}

if (typeof @os_fs@ === 'undefined') {

  @os_fs@ = null;

  // Autodetect BrowserFS and use it if available for local filesystem.
  if (typeof BrowserFS !== 'undefined') {
    BrowserFS.configure({
      fs: 'LocalStorage'
    }, function (err) {
      if (!err) {
        @os_fs@ = BrowserFS.BFSRequire('fs');
        @os_buffer@ = BrowserFS.BFSRequire('buffer');
      }
    });
  }
}

@os_uri_scheme_prefixed@ = function (string) {
  return string.match(/^[a-zA-Z][-+.a-zA-Z0-9]*:\\/\\//);
};

@os_encode_error@ = function (exn) {
  switch (exn.code) {
    case 'EPERM':     return -1;
    case 'ENOENT':    return -2;
    case 'EINTR':     return -4;
    case 'EIO':       return -5;
    case 'EBADF':     return -9;
    case 'EACCES':    return -13;
    case 'EEXIST':    return -17;
    case 'ENOTDIR':   return -20;
    case 'EISDIR':    return -21;
    case 'EINVAL':    return -22;
    case 'ENOSPC':    return -28;
    case 'EAGAIN':    return -35;
    case 'ENOTEMPTY': return -66;
  }
  return -8888;
};

@os_decode_error@ = function (code) {
  switch (code) {
    case -1:  return 'EPERM (Operation not permitted)';
    case -2:  return 'ENOENT (No such file or directory)';
    case -4:  return 'EINTR (Interrupted system call)';
    case -5:  return 'EIO (Input/output error)';
    case -9:  return 'EBADF (Bad file descriptor)';
    case -13: return 'EACCES (Permission denied)';
    case -17: return 'EEXIST (File exists)';
    case -20: return 'ENOTDIR (Not a directory)';
    case -21: return 'EISDIR (Is a directory)';
    case -22: return 'EINVAL (Invalid argument)';
    case -28: return 'ENOSPC (No space left on device)';
    case -35: return 'EAGAIN (Resource temporarily unavailable)';
    case -66: return 'ENOTEMPTY (Directory not empty)';
  }
  return 'E??? (unknown error)';
};

@os_current_time@ = function () {
  return new Date().getTime() / 1000;
};

@os_start_time@ = @os_current_time@();

@os_set_process_times@ = function (vect) {
  var elapsed = @os_current_time@() - @os_start_time@;
  vect.@elems@[0] = elapsed;
  vect.@elems@[1] = 0.0;
  vect.@elems@[2] = elapsed;
  return vect;
};

@os_debug@ = false;

@os_condvar_ready_set@ = function (condvar_scm, ready) {
  // redefined when @os_condvar_select@ is required
};

@Device_jsconsole@ = function () {
  var dev = this;
  dev.wbuf = []; // buffer to accumulate chars up to end of line
};

@Device_jsconsole@.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_jsconsole@().read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  return -1; // EPERM (operation not permitted)
};

@Device_jsconsole@.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_jsconsole@().write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

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

@Device_jsconsole@.prototype.force_output = function (dev_condvar_scm, level) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_jsconsole@().force_output(...,'+level+')');

  return 0; // no error
};

@Device_jsconsole@.prototype.seek = function (dev_condvar_scm, pos, whence) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_jsconsole@().seek(...,'+pos+','+whence+')');

  return -1; // EPERM (operation not permitted)
};

@Device_jsconsole@.prototype.width = function (dev_condvar_scm) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_jsconsole@().width()');

  return 80;
};

@Device_jsconsole@.prototype.close = function (direction) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_jsconsole@().close('+direction+')');

  return -1; // EPERM (operation not permitted)
};

if (@os_fs@) {

  @async_op_done@ = -99;
  @async_op_in_progress@ = -98;

  @Device_fd@ = function (fd) {
    var dev = this;
    dev.fd = fd;
    dev.async_read_progress = @async_op_done@; // no previous result
    dev.async_write_progress = @async_op_done@; // no previous result
  };

  @Device_fd@.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_fd@('+dev.fd+').read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    var async_read_progress = dev.async_read_progress;

    if (async_read_progress === @async_op_in_progress@) {

        return -35; // return EAGAIN because other async read is in progress

    } else if (async_read_progress !== @async_op_done@) {

        dev.async_read_progress = @async_op_done@;
        return async_read_progress; // return result of async read

    } else {

      // Start an async read of the file descriptor

      function callback(err, bytesRead) {
        var progress = dev.async_read_progress;
        if (err) {
          err = @os_encode_error@(err);
          if (err === -35) { // fd is in non-blocking mode... poll it at 10Hz
            setTimeout(function () {
              if (dev.async_read_progress === @async_op_in_progress@) {
                dev.async_read_progress = @async_op_done@;
                @os_condvar_ready_set@(dev_condvar_scm, true);
              }
            }, 100);
            return;
          }
          dev.async_read_progress = err; // can't be EAGAIN
        } else {
          dev.async_read_progress = bytesRead; // possibly 0 to signal EOF
        }
        if (progress === @async_op_in_progress@) {
          @os_condvar_ready_set@(dev_condvar_scm, true);
        }
      }

      var fd = (dev.fd < 0) ? 0 : dev.fd; // basic console reads from stdin

      @os_fs@.read(fd, @os_buffer@.Buffer.from(buffer.buffer), lo, hi-lo, null, callback);

      if (dev.async_read_progress !== @async_op_done@) {
        // handle synchronous execution of callback
        var progress = dev.async_read_progress;
        dev.async_read_progress = @async_op_done@;
        return progress;
      } else {
        @os_condvar_ready_set@(dev_condvar_scm, false);
        dev.async_read_progress = @async_op_in_progress@;
        return -35; // return EAGAIN to suspend Scheme thread on condvar
      }
    }
  };

  @Device_fd@.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_fd@('+dev.fd+').write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    var async_write_progress = dev.async_write_progress;

    if (async_write_progress === @async_op_in_progress@) {

        return -35; // return EAGAIN because other async write is in progress

    } else if (async_write_progress !== @async_op_done@) {

        dev.async_write_progress = @async_op_done@;
        return async_write_progress; // return result of async write

    } else {

      // Start an async write of the file descriptor

      function callback(err, bytesWritten) {
        var progress = dev.async_write_progress;
        if (err) {
          err = @os_encode_error@(err);
          if (err === -35) { // fd is in non-blocking mode... poll it at 10Hz
            setTimeout(function () {
              if (dev.async_write_progress === @async_op_in_progress@) {
                dev.async_write_progress = @async_op_done@;
                @os_condvar_ready_set@(dev_condvar_scm, true);
              }
            }, 100);
            return;
          }
          dev.async_write_progress = err; // can't be EAGAIN
        } else {
          dev.async_write_progress = bytesWritten;
        }
        if (progress === @async_op_in_progress@) {
          @os_condvar_ready_set@(dev_condvar_scm, true);
        }
      }

      var fd = (dev.fd < 0) ? 1 : dev.fd; // basic console writes to stdout

      @os_fs@.write(fd, @os_buffer@.Buffer.from(buffer.buffer), lo, hi-lo, null, callback);

      if (dev.async_write_progress !== @async_op_done@) {
        // handle synchronous execution of callback
        var progress = dev.async_write_progress;
        dev.async_write_progress = @async_op_done@;
        return progress;
      } else {
        @os_condvar_ready_set@(dev_condvar_scm, false);
        dev.async_write_progress = @async_op_in_progress@;
        return -35; // return EAGAIN to suspend Scheme thread on condvar
      }
    }
  };

  @Device_fd@.prototype.force_output = function (dev_condvar_scm, level) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_fd@('+dev.fd+').force_output(...,'+level+')');

    return 0; // no error
  };

  @Device_fd@.prototype.seek = function (dev_condvar_scm, pos, whence) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_fd@('+dev.fd+').seek(...,'+pos+','+whence+')');

    return -1; // EPERM (operation not permitted)
  };

  @Device_fd@.prototype.width = function (dev_condvar_scm) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_fd@('+dev.fd+').width()');

    return 80;
  };

  @Device_fd@.prototype.close = function (direction) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_fd@('+dev.fd+').close('+direction+')');

    if ((direction & 1) != 0 ||  // DIRECTION_RD
        (direction & 2) != 0) {  // DIRECTION_WR

      // Start an async close of the file descriptor

      var async_progress = @async_op_done@; // close not yet started
      var ra = @r0@;

      function callback(err) {
        var progress = async_progress;
        if (err) {
          async_progress = @os_encode_error@(err);
        } else {
          async_progress = 0; // no error
        }
        if (progress === @async_op_in_progress@) {
          @r1@ = @host2scm@(async_progress);
          @r0@ = ra;
          @trampoline@(@r0@);
        }
      }

      if (dev.fd >= 0) { // don't close basic console
        @os_fs@.close(dev.fd, callback);
      }

      if (async_progress !== @async_op_done@) {
        // handle synchronous execution of callback
        return async_progress;
      } else {
        async_progress = @async_op_in_progress@;
        @r0@ = null; // exit trampoline
        return 0; // ignored
      }
    }

    return 0; // no error
  };

  @os_device_from_fd@ = function (fd) {
    return new @Device_fd@(fd);
  };

  @os_device_from_stdin@ = function () {
    return @os_device_from_fd@(0);
  };

  @os_device_from_stdout@ = function () {
    return @os_device_from_fd@(1);
  };

  @os_device_from_stderr@ = function () {
    return @os_device_from_fd@(2);
  };

  @os_console@ = null;

  @os_device_from_basic_console@ = function () {
    if (@os_console@ === null) @os_console@ = @os_device_from_fd@(-1);
    return @os_console@;
  };

}

if (@os_web@) {

  @Device_basic_console@ = function () {

    var dev = this;
    dev.wbuf = new Uint8Array(0);
    dev.rbuf = new Uint8Array(1);
    dev.rlo = 1;
    dev.encoder = new TextEncoder();
    dev.decoder = new TextDecoder();
    dev.echo = true;
    dev.read_condvar_scm = null;
  };

  @Device_basic_console@.prototype.input_add = function (input) {

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

  @Device_basic_console@.prototype.output_add = function (output) {

    var dev = this;
    dev.output_add_buffer(dev.encoder.encode(output));
  };

  @Device_basic_console@.prototype.output_add_buffer = function (buffer) {

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

  @Device_basic_console@.prototype.use_async_input = function () {
    return false; // use a synchronous call to 'prompt' to get console input
  };

  @Device_basic_console@.prototype.use_async_output = function () {
    return false; // use a synchronous call to 'prompt' to show console output
  };

  @Device_basic_console@.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;
    var n = hi-lo;
    var have = dev.rbuf.length-dev.rlo;

    if (@os_debug@)
      console.log('@Device_basic_console@().read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    @os_condvar_ready_set@(dev_condvar_scm, false);

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

  @Device_basic_console@.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_basic_console@().write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    dev.output_add_buffer(buffer.subarray(lo, hi));

    return hi-lo;
  };

  @Device_basic_console@.prototype.force_output = function (dev_condvar_scm, level) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_basic_console@().force_output(...,'+level+')');

    return 0; // no error
  };

  @Device_basic_console@.prototype.seek = function (dev_condvar_scm, pos, whence) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_basic_console@().seek(...,'+pos+','+whence+')');

    return -1; // EPERM (operation not permitted)
  };

  @Device_basic_console@.prototype.width = function (dev_condvar_scm) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_basic_console@().width()');

    return 80;
  };

  @Device_basic_console@.prototype.close = function (direction) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_basic_console@().close('+direction+')');

    return 0; // no error
  };

  @os_console@ = null;

  @os_device_from_basic_console@ = function () {
    if (@os_console@ === null) @os_console@ = new @Device_basic_console@();
    return @os_console@;
  };

  @os_device_from_stdin@ = function () {
    return @os_device_from_basic_console@();
  };

  @os_device_from_stdout@ = function () {
    return new @Device_jsconsole@();
  };

  @os_device_from_stderr@ = function () {
    return new @Device_jsconsole@();
  };

}

"))

 ((compilation-target python)
  (##inline-host-declaration "

import os
import pwd
import grp
import stat
import time
import errno
import getpass
import tempfile
import functools

def @os_encode_error@(exn):
    e = exn.errno
    if e == errno.EPERM:
      return -1
    elif e == errno.ENOENT:
        return -2
    elif e == errno.EINTR:
        return -4
    elif e == errno.EIO:
        return -5
    elif e == errno.EBADF:
        return -9
    elif e == errno.EACCES:
        return -13
    elif e == errno.EEXIST:
        return -17
    elif e == errno.ENOTDIR:
        return -20
    elif e == errno.EISDIR:
        return -21
    elif e == errno.EINVAL:
        return -22
    elif e == errno.ENOSPC:
        return -28
    elif e == errno.EAGAIN:
        return -35
    elif e == errno.ENOTEMPTY:
        return -66
    else:
        return -8888

def @os_decode_error@(code):
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
    elif code == -20:
        return 'ENOTDIR (Not a directory)'
    elif code == -21:
        return 'EISDIR (Is a directory)'
    elif code == -22:
        return 'EINVAL (Invalid argument)'
    elif code == -28:
        return 'ENOSPC (No space left on device)'
    elif code == -35:
        return 'EAGAIN (Resource temporarily unavailable)'
    elif code == -66:
        return 'ENOTEMPTY (Directory not empty)'
    else:
        return 'E??? (unknown error)'

def @os_current_time@():
    return time.time()

@os_start_time@ = @os_current_time@()

def @os_set_process_times@(vect):
    elapsed = @os_current_time@() - @os_start_time@
    vect.@elems@[0] = elapsed
    vect.@elems@[1] = 0.0
    vect.@elems@[2] = elapsed
    return vect

@os_debug@ = False

class @Device_fd@:

    def __init__(dev, fd):
        dev.fd = fd

    def read(dev, dev_condvar_scm, buffer, lo, hi):

        if @os_debug@:
            print('@Device_fd@('+repr(dev.fd)+').read(...,'+repr(buffer[0:20])+','+repr(lo)+','+repr(hi)+')')

        try:
            b = os.read(dev.fd, hi-lo)
            n = len(b)
            buffer[lo:lo+n] = b
        except OSError as exn:
            return @os_encode_error@(exn)

        return n  # number of bytes transferred

    def write(dev, dev_condvar_scm, buffer, lo, hi):

        if @os_debug@:
            print('@Device_fd@('+repr(dev.fd)+').write(...,'+repr(buffer[0:20])+','+repr(lo)+','+repr(hi)+')')

        try:
            n = os.write(dev.fd, buffer[lo:hi])
        except OSError as exn:
            return @os_encode_error@(exn)

        return n  # number of bytes transferred

    def force_output(dev, dev_condvar_scm, level):

        if @os_debug@:
            print('@Device_fd@('+repr(dev.fd)+').force_output(...,'+repr(level)+')')

        return 0  # no error

    def seek(dev, dev_condvar_scm, pos, whence):

        if @os_debug@:
            print('@Device_fd@('+repr(dev.fd)+').seek(...,'+repr(pos)+','+repr(whence)+')')

        if whence == 0:
            how = os.SEEK_SET
        elif whence == 1:
            how = os.SEEK_CUR
        else:
            how = os.SEEK_END

        try:
            os.lseek(dev.fd, pos, how)
        except OSError as exn:
            return @os_encode_error@(exn)

        return 0  # no error

    def width(dev, dev_condvar_scm):

        if @os_debug@:
            print('@Device_fd@('+repr(dev.fd)+').width(...)')

        return 80

    def close(dev, direction):

        if @os_debug@:
            print('@Device_fd@('+repr(dev.fd)+').close('+repr(direction)+')')

        if not ((direction & 3) == 0):  # DIRECTION_RD or DIRECTION_WR
            try:
                os.close(dev.fd)
            except OSError as exn:
                return @os_encode_error@(exn)

        return 0  # no error

def @os_device_from_fd@(fd):
    return @Device_fd@(fd)

def @os_device_from_stdin@():
    return @os_device_from_fd@(0)

def @os_device_from_stdout@():
    return @os_device_from_fd@(1)

def @os_device_from_stderr@():
    return @os_device_from_fd@(2)

@os_console@ = None

def @os_device_from_basic_console@():
    global @os_console@
    if @os_console@ is None:
        @os_console@ = @os_device_from_stdout@()
    return @os_console@

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

(define (##get-parallelism-level) 1)
(define (##cpu-count) 1)
(define (##cpu-cycle-count-start) 0)
(define (##cpu-cycle-count-end)   0)
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

(define (##execute-final-wills!)
  ;; do nothing because wills are only implemented in C backend
  #f)

(define (##force obj)
  (##force-out-of-line obj))

;;;----------------------------------------------------------------------------

;;; Subprocedure information.

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
  (cond-expand

   ((compilation-target js)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "@host2scm@(Object.keys(@glo@))"))))

   ((compilation-target python)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "@host2scm@(list(@glo@.keys()))"))))

   (else
    (println "unimplemented ##global-vars called")
    '())))

(define (##interned-symbols)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "@host2scm@(Object.keys(@symbol_table@))"))))

   ((compilation-target python)
    (##map ##string->symbol
           (##vector->list
            (##inline-host-expression
             "@host2scm@(list(@symbol_table@.keys()))"))))

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

;;; Error codes.

(define (##os-err-code->string code)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-expression
     "@host2scm@(@os_decode_error@(@scm2host@(@1@)))"
     code))

   ((compilation-target python)
    (##inline-host-expression
     "@host2scm@(@os_decode_error@(@scm2host@(@1@)))"
     code))

   (else
    (println "unimplemented ##os-err-code->string called with code=")
    (println code)
    "Unknown error")))

;;;----------------------------------------------------------------------------

;;; Process id.

(define (##os-getpid)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-expression
     "@host2scm@(@os_nodejs@ ? process.pid : 0)"))

   ((compilation-target python)
    (##inline-host-expression
     "@host2scm@(os.getpid())"))

   (else
    (println "unimplemented ##os-getpid called")
    0)))

;;;----------------------------------------------------------------------------

;;; Host name.

(define (##os-host-name)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-expression
     "@host2scm@(@os_nodejs@ ? os.hostname() : 'host-name')"))

   ((compilation-target python)
    (##inline-host-expression
     "@host2scm@(os.uname()[1])"))

   (else
    (println "unimplemented ##os-host-name called")
    "host-name")))

;;;----------------------------------------------------------------------------

;;; User name.

(define (##os-user-name)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-expression
     "@host2scm@(@os_nodejs@ ? os.userInfo().username : 'user')"))

   ((compilation-target python)
    (##inline-host-expression
     "@host2scm@(getpass.getuser())"))

   (else
    (println "unimplemented ##os-user-name called")
    "user")))

;;;----------------------------------------------------------------------------

;;; User and group information.

(define (##os-user-info ui user)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_user_info@ = function (ui, user) {
  if (@os_nodejs@) {

    try {
      var posix = require('posix');
      var pw = posix.getpwnam(user);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return @host2scm@(@os_encode_error@(exn));
      } else {
        throw exn;
      }
    }
    ui.@slots@[1] = @host2scm@(pw.name);
    ui.@slots@[2] = @host2scm@(pw.uid);
    ui.@slots@[3] = @host2scm@(pw.gid);
    ui.@slots@[4] = @host2scm@(pw.dir);
    ui.@slots@[5] = @host2scm@(pw.shell);
    return ui;

  } else if (@os_web@) {

    ui.@slots@[1] = @host2scm@('user');
    ui.@slots@[2] = @host2scm@(111);
    ui.@slots@[3] = @host2scm@(222);
    ui.@slots@[4] = @host2scm@('/home/user');
    ui.@slots@[5] = @host2scm@('/bin/sh');
    return ui;

  } else {
    return @host2scm@(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "@os_user_info@(@1@, @scm2host@(@2@))" ui user))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_user_info@(ui, user):
    try:
        pw = pwd.getpwuid(user) if isinstance(user,int) else pwd.getpwnam(user)
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))
    ui.@slots@[1] = @host2scm@(pw[0])
    ui.@slots@[2] = @host2scm@(pw[2])
    ui.@slots@[3] = @host2scm@(pw[3])
    ui.@slots@[4] = @host2scm@(pw[5])
    ui.@slots@[5] = @host2scm@(pw[6])
    return ui

")
    (##inline-host-expression "@os_user_info@(@1@, @scm2host@(@2@))" ui user))

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
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_group_info@ = function (gi, group) {
  if (@os_nodejs@) {

    try {
      var posix = require('posix');
      var gr = posix.getgrnam(group);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return @host2scm@(@os_encode_error@(exn));
      } else {
        throw exn;
      }
    }
    gi.@slots@[1] = @host2scm@(gr.name);
    gi.@slots@[2] = @host2scm@(gr.gid);
    gi.@slots@[3] = @host2scm@(gr.members);
    return gi;

  } else if (@os_web@) {

    gi.@slots@[1] = @host2scm@('group');
    gi.@slots@[2] = @host2scm@(222);
    gi.@slots@[3] = @host2scm@([]);
    return gi;

  } else {
    return @host2scm@(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "@os_group_info@(@1@, @scm2host@(@2@))" gi group))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_group_info@(gi, group):
    try:
        gr = grp.getgrgid(group) if isinstance(group,int) else pwd.getgrnam(group)
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))
    gi.@slots@[1] = @host2scm@(gr[0])
    gi.@slots@[2] = @host2scm@(gr[2])
    gi.@slots@[3] = @host2scm@(gr[3])
    return gi

")
    (##inline-host-expression "@os_group_info@(@1@, @scm2host@(@2@))" gi group))

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
  (cond-expand

   ((compilation-target js)
    (##inline-host-expression
     "@host2scm@((function (v) { return this !== this.window && Object.hasOwnProperty.call(process.env,v) ? process.env[v] : false; })(@scm2host@(@1@)))"
     var))

   ((compilation-target python)
    (##inline-host-expression
     "@host2scm@(os.environ.get(@scm2host@(@1@), False))"
     var))

   (else
    (println "unimplemented ##os-getenv called with var=")
    (println var)
    #f)))

(define (##os-setenv var val)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-statement
     "if ((function (v) { return this !== this.window; })()) process.env[@scm2host@(@1@)] = @scm2host@(@2@);"
     var
     val)
    0)

   ((compilation-target python)
    (##inline-host-statement
     "os.environ[@scm2host@(@1@)] = @scm2host@(@2@)"
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
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_shell_command@ = function (cmd) {
  var r = child_process.spawnSync('sh',['-c',cmd]);
  var output = r.stdout.toString();
  if (output.length > 0) {
    console.log(output.replace(/\\n$/, ''));
  }
  return 256 * ((r.status === null) ? 0 : r.status);
};

")
    (##inline-host-expression
     "@host2scm@(@os_shell_command@(@scm2host@(@1@)))"
     cmd))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_shell_command@(cmd):
    return os.system(cmd)

")
    (##inline-host-expression
     "@host2scm@(@os_shell_command@(@scm2host@(@1@)))"
     cmd))

   (else
    (println "unimplemented ##os-shell-command called with cmd=")
    (println cmd)
    0)))

;;;----------------------------------------------------------------------------

;;; Temporary directory.

(define (##os-path-tempdir)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-expression
     "@host2scm@(@os_nodejs@ ? os.tmpdir() : '/tmp')"))

   ((compilation-target python)
    (##inline-host-expression
     "@host2scm@(tempfile.gettempdir())"))

   (else
    (println "unimplemented ##os-path-tempdir called")
    "/tmp")))

;;;----------------------------------------------------------------------------

;;; Home directory.

(define (##os-path-homedir)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-expression
     "@host2scm@(@os_nodejs@ ? os.homedir() : '/')"))

   ((compilation-target python)
    (##inline-host-expression
     "@host2scm@(os.path.expanduser('~'))"))

   (else
    (println "unimplemented ##os-path-homedir called")
    "/")))

;;;----------------------------------------------------------------------------

;;; Path of executable (i.e. the host language script).

(define (##os-executable-path)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@executable_path@ = (@os_nodejs@) ? __filename : '/program.exe';

")
    (##inline-host-expression "@host2scm@(@executable_path@)"))

   ((compilation-target python)
    (##inline-host-declaration "

@executable_path@ = os.path.abspath(__file__)

")
    (##inline-host-expression "@host2scm@(@executable_path@)"))

   (else
    (println "unimplemented ##os-executable-path called")
    "/program.exe")))

;;;----------------------------------------------------------------------------

;;; Gambit directories.

(define (##os-path-gambitdir)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_path_gambitdir@ = function () {
  if (@os_nodejs@) {
    return @host2scm@('/usr/local/Gambit/');
  } else if (@os_web@) {
    return @host2scm@(@os_web_origin@);
  } else {
    return @host2scm@(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "@os_path_gambitdir@()"))

   (else
    "/usr/local/Gambit/")))

(define (##os-path-gambitdir-map-lookup name)
  (let ((x (##assoc-string-equal? name ##gambitdir-map)))
    (and x (##cdr x))))

(define ##gambitdir-map
  '(("userlib" . "~/.gambit_userlib")))

(define (##gambitdir-map-set! alist)
  (set! ##gambitdir-map alist))

;;;----------------------------------------------------------------------------

;;; Path normalization.

(define (##os-path-normalize-directory path)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_path_normalize_directory@ = function (path) {
  if (@os_nodejs@) {
    var old = process.cwd();
    var dir;
    if (path === false) {
      dir = old;
    } else {
      try {
        process.chdir(path);
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return @host2scm@(@os_encode_error@(exn));
        } else {
          throw exn;
        }
      }
      dir = process.cwd();
      process.chdir(old);
    }
    if (dir[dir.length-1] === '/' || dir[dir.length-1] === '\\\\') {
      return @host2scm@(dir);
    } else if (dir[0] === '/') {
      return @host2scm@(dir + '/');
    } else {
      return @host2scm@(dir + '\\\\');
    }
  } else if (@os_web@) {
    if (path === false) {
      return @host2scm@(@os_web_origin@);
    }
    if (@os_fs@ && !@os_uri_scheme_prefixed@(path)) {
      var is_dir = false;
      try {
        is_dir = @os_fs@.statSync(path).isDirectory();
      } catch (exn) {
        // ignore error
      }
      if (!is_dir) {
        return @host2scm@(-2); // ENOENT (file does not exist)
      }
    }
    if (path.slice(0,1) === '/' || @os_uri_scheme_prefixed@(path)) {
      return @host2scm@(path + (path.slice(-1) === '/' ? '' : '/'));
    } else {
      return @host2scm@(@os_web_origin@ + path);
    }
  } else {
    return @host2scm@(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression "@os_path_normalize_directory@(@scm2host@(@1@))" path))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_path_normalize_directory@(path):
    old = os.getcwd()
    if path is False:
        dir = old
    else:
        try:
            os.chdir(path)
        except OSError as exn:
            return @host2scm@(@os_encode_error@(exn))
        dir = os.getcwd()
        os.chdir(old)
    if dir[-1] == '/' or dir[-1] == '\\\\':
        return @host2scm@(dir)
    elif dir[0] == '/':
        return @host2scm@(dir + '/')
    else:
        return @host2scm@(dir + '\\\\')

")
    (##inline-host-expression "@os_path_normalize_directory@(@scm2host@(@1@))" path))

   (else
    (println "unimplemented ##os-path-normalize-directory called with path=")
    (println path)
    "/")))

;;;----------------------------------------------------------------------------

;;; Process exit.

(define-prim (##exit-with-err-code-no-cleanup err-code)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-statement
     "
      var code = @scm2host@(@1@);
      if (@os_nodejs@) {
        process.exit(code);
      } else {
        throw Error('process exiting with code=' + code);
      }
     "
     (##fx- err-code 1)))

   ((compilation-target python)
    (##inline-host-statement "exit(@1@)" (##fx- err-code 1)))

   (else
    (println "unimplemented ##exit-with-err-code-no-cleanup called with err-code=")
    (println err-code))))

(define (##exit-trampoline)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-statement "@r0@ = null;"))

   ((compilation-target python)
    (##inline-host-statement "@r0@ = None"))

   (else
    (println "unimplemented ##exit-trampoline called"))))

;;;----------------------------------------------------------------------------

;;; Time management.

(define (##get-current-time! floats i)
  (##declare (not interrupts-enabled))
  (##f64vector-set!
   floats
   i
   (cond-expand

    ((compilation-target js python)
     (##inline-host-expression "@host2scm@(@os_current_time@())"))

    (else
     (println "unimplemented ##get-current-time! called")
     0.0))))

(define (##process-statistics)
  (##declare (not interrupts-enabled))
  (let ((v (##make-f64vector 20 0.0)))
    (cond-expand

     ((compilation-target js python)
      (##inline-host-expression "@os_set_process_times@(@1@)" v))

     (else
      (println "unimplemented ##process-statistics called")
      v))))

(define (##process-times)
  (##declare (not interrupts-enabled))
  (let ((v (##make-f64vector 3 0.0)))
    (cond-expand

     ((compilation-target js python)
      (##inline-host-expression "@os_set_process_times@(@1@)" v))

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
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_runtime_options@ = '';
@os_argv@ = [''];

if (@os_nodejs@) {
  @os_argv@ = process.argv.slice(1);
  if (@os_argv@.length >= 2 && @os_argv@[1].slice(0,2) == '-:') {
    @os_runtime_options@ = @os_argv@[1].slice(2);
    @os_argv@.splice(1,1);
  }
}

")
    (##vector->list (##inline-host-expression "@host2scm@(@os_argv@)")))

   ((compilation-target python)
    (##inline-host-declaration "

@os_runtime_options@ = ''
@os_argv@ = sys.argv[:]

if len(@os_argv@) >= 2 and @os_argv@[1][:2] == '-:':
  @os_runtime_options@ = @os_argv@.pop(1)[2:]

")
    (##vector->list (##inline-host-expression "@host2scm@(@os_argv@)")))

   (else
    (println "unimplemented ##get-command-line called")
    '())))

(define (##get-runtime-options)
  (##declare (not interrupts-enabled))
  (##first-argument #f ##get-command-line)
  (cond-expand

    ((compilation-target js python)
     (##inline-host-expression "@host2scm@(@os_runtime_options@)"))

    (else
     (println "unimplemented ##get-runtime-options called")
     "")))

;;;----------------------------------------------------------------------------

;;; Module whitelist.

(define ##feature-module-whitelist
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_module_whitelist@ = ['github.com/gambit'];

@os_get_module_whitelist@ = function () {
  return @os_module_whitelist@;
};

@os_set_module_whitelist@ = function (whitelist) {
  @os_module_whitelist@ = whitelist;
};

"))

   ((compilation-target python)
    (##inline-host-declaration "

@os_module_whitelist@ = ['github.com/gambit']

def @os_get_module_whitelist@():
  return @os_module_whitelist@

def @os_set_module_whitelist@(whitelist):
  @os_module_whitelist@ = whitelist

"))

   (else
    #f)))

(define (##get-module-whitelist)
  (##declare (not interrupts-enabled))
  (##first-argument #f ##feature-module-whitelist)
  (cond-expand

    ((compilation-target js python)
     (##vector->list
      (##inline-host-expression "@host2scm@(@os_get_module_whitelist@())")))

    (else
     (println "unimplemented ##get-module-whitelist called")
     '())))

(define (##set-module-whitelist! whitelist)
  (##declare (not interrupts-enabled))
  (##first-argument #f ##feature-module-whitelist)
  (cond-expand

    ((compilation-target js)
     (##inline-host-statement
      "@os_set_module_whitelist@(@scm2host@(@1@));"
      (##list->vector whitelist)))

    ((compilation-target python)
     (##inline-host-statement
      "@os_set_module_whitelist@(@scm2host@(@1@))"
      (##list->vector whitelist)))

    (else
     (println "unimplemented ##set-module-whitelist! called"))))

(define ##module-search-order-var '("~~lib" "~~userlib"))
(define (##get-module-search-order) ##module-search-order-var)
(define (##set-module-search-order! x) (set! ##module-search-order-var x))

(define ##module-install-mode-var (macro-module-install-mode-ask-never))
(define (##get-module-install-mode) ##module-install-mode-var)
(define (##set-module-install-mode x) (set! ##module-install-mode-var x))

;;;----------------------------------------------------------------------------

;;; File information.

(define ##feature-file-input
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

if (@os_web@) {

  @os_trust_all@ = false;

  @os_confirm_if_not_in_url_whitelist@ = true;

  @os_url_whitelist@ = [];

  @os_url_whitelist_add@ = function (url) {
    if (@os_uri_scheme_prefixed@(url) &&
        @os_url_whitelist@.indexOf(url) === -1) {
      @os_url_whitelist@.push(url);
    }
  };

  @os_remove_after_last_slash@ = function (string) {
    return string.slice(0, 1+string.lastIndexOf('/'));
  };

  @os_trusted_url@ = function (url, reason) {
    if (@os_trust_all@) {
      return true;
    }
    for (var i=0; i<@os_url_whitelist@.length; i++) {
      var w = @os_url_whitelist@[i];
      if (w.slice(-1) === '/' // if ends with slash
          ? url.indexOf(w) === 0 // then it must be a prefix
          : url === w) { // otherwise it must be an exact match
        return true;
      }
    }
    for (var i=0; i<@os_module_whitelist@.length; i++) {
      var w = 'https://'+@os_module_whitelist@[i]+'/';
      if (url.indexOf(w) === 0) { // check if it is a prefix
        return true;
      }
    }
    if (@os_confirm_if_not_in_url_whitelist@ &&
        reason !== undefined &&
        confirm(url + '\\nis being accessed ' + reason + '.\\nClick OK if you trust this URL for that operation.')) {
      return true;
    }
    return false;
  };

  @os_web_origin@ = @os_remove_after_last_slash@(window.location.href);

  if (@os_web_origin@.indexOf('https://') === 0) {
    @os_url_whitelist_add@(@os_web_origin@); // only trust https origin
  }

  @os_get_url_async@ = function (method, url, callback) {

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

  @os_uri_encode@ = function (uri) {

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
  (cond-expand

   ((compilation-target js)
    (##first-argument #f ##feature-file-input)
    (##inline-host-declaration "

@os_file_info@ = function (fi, path, chase) {

  if (@os_uri_scheme_prefixed@(path)) { // accessing a URL?

    if (!(@os_web@ && @os_trusted_url@(path, 'to check that document\\'s information'))) { // accessing an untrusted URL?
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      var ra = @r0@;
      @r0@ = null; // exit trampoline

      function callback(req) {

        if (req.status === 404) {
          @r1@ = @host2scm@(-2); // ENOENT (file does not exist)
        } else if (req.status !== 200) {
          @r1@ = @host2scm@(-1); // EPERM (operation not permitted)
        } else {

          var size = +req.getResponseHeader('Content-Length');

          fi.@slots@[ 1] = @host2scm@(1); // regular file
          fi.@slots@[ 2] = @host2scm@(0);
          fi.@slots@[ 3] = @host2scm@(0);
          fi.@slots@[ 4] = @host2scm@(0);
          fi.@slots@[ 5] = @host2scm@(0);
          fi.@slots@[ 6] = @host2scm@(0);
          fi.@slots@[ 7] = @host2scm@(0);
          fi.@slots@[ 8] = @host2scm@(size);
          fi.@slots@[ 9] = new @Flonum@(-Infinity);
          fi.@slots@[10] = new @Flonum@(-Infinity);
          fi.@slots@[11] = new @Flonum@(-Infinity);
          fi.@slots@[12] = @host2scm@(0);
          fi.@slots@[13] = new @Flonum@(-Infinity);

          @r1@ = fi;
        }

        @r0@ = ra;
        @trampoline@(@r0@);
      }

      @os_get_url_async@('HEAD', @os_uri_encode@(path), callback);

      return 0; // ignored
    }

  } else {

    if (!@os_fs@) {
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      var st;

      try {
        if (chase) {
          st = @os_fs@.statSync(path);
        } else {
          st = @os_fs@.lstatSync(path);
        }
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return @host2scm@(@os_encode_error@(exn));
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

      fi.@slots@[ 1] = @host2scm@(typ);
      fi.@slots@[ 2] = @host2scm@(st.dev);
      fi.@slots@[ 3] = @host2scm@(st.ino);
      fi.@slots@[ 4] = @host2scm@(st.mode);
      fi.@slots@[ 5] = @host2scm@(st.nlink);
      fi.@slots@[ 6] = @host2scm@(st.uid);
      fi.@slots@[ 7] = @host2scm@(st.gid);
      fi.@slots@[ 8] = @host2scm@(st.size);
      fi.@slots@[ 9] = new @Flonum@(-Infinity);
      fi.@slots@[10] = new @Flonum@(-Infinity);
      fi.@slots@[11] = new @Flonum@(-Infinity);
      fi.@slots@[12] = @host2scm@(0);
      fi.@slots@[13] = new @Flonum@(-Infinity);

      return fi;

    }
  }
};

")
    (##inline-host-expression
     "@os_file_info@(@1@, @scm2host@(@2@), @scm2host@(@3@))"
     fi
     path
     chase?))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_file_info@(fi, path, chase):

    try:
        if chase:
            st = os.stat(path)
        else:
            st = os.lstat(path)
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

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

    fi.@slots@[ 1] = @host2scm@(typ)
    fi.@slots@[ 2] = @host2scm@(st.st_dev)
    fi.@slots@[ 3] = @host2scm@(st.st_ino)
    fi.@slots@[ 4] = @host2scm@(st.st_mode)
    fi.@slots@[ 5] = @host2scm@(st.st_nlink)
    fi.@slots@[ 6] = @host2scm@(st.st_uid)
    fi.@slots@[ 7] = @host2scm@(st.st_gid)
    fi.@slots@[ 8] = @host2scm@(st.st_size)
    fi.@slots@[ 9] = @Flonum@(float('-inf'))
    fi.@slots@[10] = @Flonum@(float('-inf'))
    fi.@slots@[11] = @Flonum@(float('-inf'))
    fi.@slots@[12] = @host2scm@(0)
    fi.@slots@[13] = @Flonum@(float('-inf'))

    return fi

")
    (##inline-host-expression
     "@os_file_info@(@1@, @scm2host@(@2@), @scm2host@(@3@))"
     fi
     path
     chase?))

   (else
    (println "unimplemented ##os-file-info! called with path=")
    (println path)
    (println "and chase?=")
    (println chase?)
    -5555)))

(define (##os-file-times-set! path a-time m-time)
  (println "unimplemented ##os-file-times-set! called with path=")
  (println path)
  (println "and a-time=")
  (println a-time)
  (println "and m-time=")
  (println m-time)
  -5555)

;;;----------------------------------------------------------------------------

;;; Filesystem operations.

(define (##os-delete-directory path)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_delete_directory@ = function (path) {

  if (@os_uri_scheme_prefixed@(path)) { // accessing a URL?

    return @host2scm@(-1); // EPERM (operation not permitted)

  } else {

    if (!@os_fs@) {
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      try {
        @os_fs@.rmdirSync(path);
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return @host2scm@(@os_encode_error@(exn));
        } else {
          throw exn;
        }
      }

      return @host2scm@(0); // no error
    }
  }
};

")
    (##inline-host-expression
     "@os_delete_directory@(@scm2host@(@1@))"
     path))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_delete_directory@(path):

    try:
        os.rmdir(path);
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

    return @host2scm@(0)  # no error

")
    (##inline-host-expression
     "@os_delete_directory@(@scm2host@(@1@))"
     path))

   (else
    (println "unimplemented ##os-delete-directory called with path=")
    (println path)
    -5555)))

(define (##os-delete-file path)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_delete_file@ = function (path) {

  if (@os_uri_scheme_prefixed@(path)) { // accessing a URL?

    return @host2scm@(-1); // EPERM (operation not permitted)

  } else {

    if (!@os_fs@) {
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      try {
        @os_fs@.unlinkSync(path);
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return @host2scm@(@os_encode_error@(exn));
        } else {
          throw exn;
        }
      }

      return @host2scm@(0); // no error
    }
  }
};

")
    (##inline-host-expression
     "@os_delete_file@(@scm2host@(@1@))"
     path))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_delete_file@(path):

    try:
        os.unlink(path);
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

    return @host2scm@(0)  # no error

")
    (##inline-host-expression
     "@os_delete_file@(@scm2host@(@1@))"
     path))

   (else
    (println "unimplemented ##os-delete-file called with path=")
    (println path)
    -5555)))

(define (##os-rename-file old-path new-path replace?)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_rename_file@ = function (old_path, new_path, replace) {

  if (@os_uri_scheme_prefixed@(old_path) ||
      @os_uri_scheme_prefixed@(new_path)) { // accessing a URL?

    return @host2scm@(-1); // EPERM (operation not permitted)

  } else {

    if (!@os_fs@) {
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      if (!replace) {
        // new_path should not be an existing file so this is checked
        // before renaming old_path (TODO: find a way to do this atomically)
        var st = null;
        try {
          st = @os_fs@.statSync(new_path);
        } catch (exn) {
        }
        if (st !== null) {
          return @host2scm@(-17); // return EEXIST
        }
      }

      try {
        @os_fs@.renameSync(old_path, new_path);
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return @host2scm@(@os_encode_error@(exn));
        } else {
          throw exn;
        }
      }

      return @host2scm@(0); // no error
    }
  }
};

")
    (##inline-host-expression
     "@os_rename_file@(@scm2host@(@1@),@scm2host@(@2@),@scm2host@(@3@))"
     old-path
     new-path
     replace?))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_rename_file@(old_path, new_path, replace):

    if not replace:
        # new_path should not be an existing file so this is checked
        # before renaming old_path (TODO: find a way to do this atomically)
        st = None
        try:
            st = os.stat(new_path)
        except OSError as exn:
            pass
        if st is not None:
            return @host2scm@(-17)  # return EEXIST

    try:
        os.rename(old_path, new_path);
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

    return @host2scm@(0)  # no error

")
    (##inline-host-expression
     "@os_rename_file@(@scm2host@(@1@),@scm2host@(@2@),@scm2host@(@3@))"
     old-path
     new-path
     replace?))

   (else
    (println "unimplemented ##os-rename-file called with old-path=")
    (println old-path)
    (println "and new-path=")
    (println new-path)
    (println "and replace?=")
    (println replace?)
    -5555)))

(define (##os-create-directory path permissions)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_create_directory@ = function (path, permissions) {

  if (@os_uri_scheme_prefixed@(path)) { // accessing a URL?

    return @host2scm@(-1); // EPERM (operation not permitted)

  } else {

    if (!@os_fs@) {
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      try {
        @os_fs@.mkdirSync(path, permissions);
      } catch (exn) {
        if (exn instanceof Error && exn.hasOwnProperty('code')) {
          return @host2scm@(@os_encode_error@(exn));
        } else {
          throw exn;
        }
      }

      return @host2scm@(0); // no error
    }
  }
};

")
    (##inline-host-expression
     "@os_create_directory@(@scm2host@(@1@),@scm2host@(@2@))"
     path
     permissions))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_create_directory@(path, permissions):

    try:
        os.mkdir(path, permissions);
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

    return @host2scm@(0)  # no error

")
    (##inline-host-expression
     "@os_create_directory@(@scm2host@(@1@),@scm2host@(@2@))"
     path
     permissions))

   (else
    (println "unimplemented ##os-create-directory called with path=")
    (println path)
    (println "and permissions=")
    (println permissions)
    -5555)))

(define (##os-create-fifo path permissions)
  (println "unimplemented ##os-create-fifo called with path=")
  (println path)
  (println "and permissions=")
  (println permissions)
  -5555)

(define (##os-create-link old-path new-path)
  (println "unimplemented ##os-create-link called with old-path=")
  (println old-path)
  (println "and new-path=")
  (println new-path)
  -5555)

(define (##os-create-symbolic-link old-path new-path)
  (println "unimplemented ##os-create-symbolic-link called with old-path=")
  (println old-path)
  (println "and new-path=")
  (println new-path)
  -5555)

(define (##os-copy-file src-path dest-path)
  (println "unimplemented ##os-copy-file called with src-path=")
  (println src-path)
  (println "and dest-path=")
  (println dest-path)
  -5555)

;;;----------------------------------------------------------------------------

;;; File I/O.

(##declare (inline))

(define ##feature-port-fields
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@BTQ_DEQ_NEXT@              = 2;
@BTQ_DEQ_PREV@              = 3;
@BTQ_COLOR@                 = 4;
@BTQ_PARENT@                = 5;
@BTQ_LEFT@                  = 6;
@BTQ_RIGHT@                 = 7;
@BTQ_LEFTMOST@              = 7;
@BTQ_OWNER@                 = 8;

@FOR_READING@               = 0;
@FOR_WRITING@               = 1;
@FOR_EVENT@                 = 2;

@CONDVAR_NAME@              = 10;

@PORT_MUTEX@                = 1;
@PORT_RKIND@                = 2;
@PORT_WKIND@                = 3;
@PORT_NAME@                 = 4;
@PORT_WAIT@                 = 5;
@PORT_CLOSE@                = 6;
@PORT_ROPTIONS@             = 7;
@PORT_RTIMEOUT@             = 8;
@PORT_RTIMEOUT_THUNK@       = 9;
@PORT_SET_RTIMEOUT@         = 10;
@PORT_WOPTIONS@             = 11;
@PORT_WTIMEOUT@             = 12;
@PORT_WTIMEOUT_THUNK@       = 13;
@PORT_SET_WTIMEOUT@         = 14;
@PORT_IO_EXCEPTION_HANDLER@ = 15;

@PORT_OBJECT_READ_DATUM@    = 16;
@PORT_OBJECT_WRITE_DATUM@   = 17;
@PORT_OBJECT_NEWLINE@       = 18;
@PORT_OBJECT_FORCE_OUTPUT@  = 19;

@PORT_OBJECT_OTHER1@        = 20;
@PORT_OBJECT_OTHER2@        = 21;
@PORT_OBJECT_OTHER3@        = 22;

@PORT_CHAR_RBUF@            = 20;
@PORT_CHAR_RLO@             = 21;
@PORT_CHAR_RHI@             = 22;
@PORT_CHAR_RCHARS@          = 23;
@PORT_CHAR_RLINES@          = 24;
@PORT_CHAR_RCURLINE@        = 25;
@PORT_CHAR_RBUF_FILL@       = 26;
@PORT_CHAR_PEEK_EOFP@       = 27;

@PORT_CHAR_WBUF@            = 28;
@PORT_CHAR_WLO@             = 29;
@PORT_CHAR_WHI@             = 30;
@PORT_CHAR_WCHARS@          = 31;
@PORT_CHAR_WLINES@          = 32;
@PORT_CHAR_WCURLINE@        = 33;
@PORT_CHAR_WBUF_DRAIN@      = 34;
@PORT_INPUT_READTABLE@      = 35;
@PORT_OUTPUT_READTABLE@     = 36;
@PORT_OUTPUT_WIDTH@         = 37;

@PORT_CHAR_OTHER1@          = 38;
@PORT_CHAR_OTHER2@          = 39;
@PORT_CHAR_OTHER3@          = 40;
@PORT_CHAR_OTHER4@          = 41;
@PORT_CHAR_OTHER5@          = 42;

@PORT_BYTE_RBUF@            = 38;
@PORT_BYTE_RLO@             = 39;
@PORT_BYTE_RHI@             = 40;
@PORT_BYTE_RBUF_FILL@       = 41;

@PORT_BYTE_WBUF@            = 42;
@PORT_BYTE_WLO@             = 43;
@PORT_BYTE_WHI@             = 44;
@PORT_BYTE_WBUF_DRAIN@      = 45;

@PORT_BYTE_OTHER1@          = 46;
@PORT_BYTE_OTHER2@          = 47;

@PORT_RDEVICE_COND@         = 46;
@PORT_WDEVICE_COND@         = 47;

@PORT_DEVICE_OTHER1@        = 48;
@PORT_DEVICE_OTHER2@        = 49;

"))

   ((compilation-target python)
    (##inline-host-declaration "

@BTQ_DEQ_NEXT@              = 2
@BTQ_DEQ_PREV@              = 3
@BTQ_COLOR@                 = 4
@BTQ_PARENT@                = 5
@BTQ_LEFT@                  = 6
@BTQ_RIGHT@                 = 7
@BTQ_LEFTMOST@              = 7
@BTQ_OWNER@                 = 8

@FOR_READING@               = 0
@FOR_WRITING@               = 1
@FOR_EVENT@                 = 2

@CONDVAR_NAME@              = 10

@PORT_MUTEX@                = 1
@PORT_RKIND@                = 2
@PORT_WKIND@                = 3
@PORT_NAME@                 = 4
@PORT_WAIT@                 = 5
@PORT_CLOSE@                = 6
@PORT_ROPTIONS@             = 7
@PORT_RTIMEOUT@             = 8
@PORT_RTIMEOUT_THUNK@       = 9
@PORT_SET_RTIMEOUT@         = 10
@PORT_WOPTIONS@             = 11
@PORT_WTIMEOUT@             = 12
@PORT_WTIMEOUT_THUNK@       = 13
@PORT_SET_WTIMEOUT@         = 14
@PORT_IO_EXCEPTION_HANDLER@ = 15

@PORT_OBJECT_READ_DATUM@    = 16
@PORT_OBJECT_WRITE_DATUM@   = 17
@PORT_OBJECT_NEWLINE@       = 18
@PORT_OBJECT_FORCE_OUTPUT@  = 19

@PORT_OBJECT_OTHER1@        = 20
@PORT_OBJECT_OTHER2@        = 21
@PORT_OBJECT_OTHER3@        = 22

@PORT_CHAR_RBUF@            = 20
@PORT_CHAR_RLO@             = 21
@PORT_CHAR_RHI@             = 22
@PORT_CHAR_RCHARS@          = 23
@PORT_CHAR_RLINES@          = 24
@PORT_CHAR_RCURLINE@        = 25
@PORT_CHAR_RBUF_FILL@       = 26
@PORT_CHAR_PEEK_EOFP@       = 27

@PORT_CHAR_WBUF@            = 28
@PORT_CHAR_WLO@             = 29
@PORT_CHAR_WHI@             = 30
@PORT_CHAR_WCHARS@          = 31
@PORT_CHAR_WLINES@          = 32
@PORT_CHAR_WCURLINE@        = 33
@PORT_CHAR_WBUF_DRAIN@      = 34
@PORT_INPUT_READTABLE@      = 35
@PORT_OUTPUT_READTABLE@     = 36
@PORT_OUTPUT_WIDTH@         = 37

@PORT_CHAR_OTHER1@          = 38
@PORT_CHAR_OTHER2@          = 39
@PORT_CHAR_OTHER3@          = 40
@PORT_CHAR_OTHER4@          = 41
@PORT_CHAR_OTHER5@          = 42

@PORT_BYTE_RBUF@            = 38
@PORT_BYTE_RLO@             = 39
@PORT_BYTE_RHI@             = 40
@PORT_BYTE_RBUF_FILL@       = 41

@PORT_BYTE_WBUF@            = 42
@PORT_BYTE_WLO@             = 43
@PORT_BYTE_WHI@             = 44
@PORT_BYTE_WBUF_DRAIN@      = 45

@PORT_BYTE_OTHER1@          = 46
@PORT_BYTE_OTHER2@          = 47

@PORT_RDEVICE_CONDVAR@      = 46
@PORT_WDEVICE_CONDVAR@      = 47

@PORT_DEVICE_OTHER1@        = 48
@PORT_DEVICE_OTHER2@        = 49

"))

   (else
    #f)))

(define-prim (##os-device-close dev direction)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_close@ = function (dev_scm, direction_scm) {

  var dev = @foreign2host@(dev_scm);
  var direction = @scm2host@(direction_scm);

  return @host2scm@(dev.close(direction));
};

")
    (##inline-host-expression
     "@os_device_close@(@1@,@2@)"
     dev
     direction))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_close@(dev_scm, direction_scm):

    dev = @foreign2host@(dev_scm)
    direction = @scm2host@(direction_scm)

    return @host2scm@(dev.close(direction))

")
    (##inline-host-expression
     "@os_device_close@(@1@,@2@)"
     dev
     direction))

   (else
    (println "unimplemented ##os-device-close called")
    -5555)))

(define-prim (##os-device-force-output dev-condvar level)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_force_output@ = function (dev_condvar_scm, level_scm) {

  var dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@]);
  var level = @scm2host@(level_scm);

  return @host2scm@(dev.force_output(dev_condvar_scm, level));
};

")
    (##inline-host-expression
     "@os_device_force_output@(@1@,@2@)"
     dev-condvar
     level))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_force_output@(dev_condvar_scm, level_scm):

    dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@])
    level = @scm2host@(level_scm)

    return @host2scm@(dev.force_output(dev_condvar_scm, level))

")
    (##inline-host-expression
     "@os_device_force_output@(@1@,@2@)"
     dev-condvar
     level))

   (else
    (println "unimplemented ##os-device-force-output called")
    -5555)))

(define-prim (##os-device-kind dev)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_kind@ = function (dev_scm) {

  var dev = @foreign2host@(dev_scm);

  if (@os_debug@)
    console.log('@os_device_kind@(...)  ***not fully implemented***');

  return @host2scm@(31+32); // file device
};

")
    (##inline-host-expression
     "@os_device_kind@(@1@)"
     dev))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_kind@(dev_scm):

    dev = @foreign2host@(dev_scm)

    if @os_debug@:
        print('@os_device_kind@(...)  ***not fully implemented***')

    return @host2scm@(31+32)  # file device

")
    (##inline-host-expression
     "@os_device_kind@(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-kind called")
    -5555)))

(define ##feature-device-directory
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@Device_directory@ = function (filenames) {
  var dev = this;
  dev.filenames = filenames;
  dev.index = 0;
};

@Device_directory@.prototype.read = function (dev_condvar_scm) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_directory@([...]).read(...)');

  if (dev.index >= dev.filenames.length) {
    return @eof_obj@; // end of list of filenames
  } else {
    dev.index++;
    return @host2scm@(dev.filenames[dev.index-1]);
  }
};

@Device_directory@.prototype.close = function (direction) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_directory@([...]).close('+direction+')');

  return 0; // no error
};

"))

   ((compilation-target python)
    (##inline-host-declaration "

class @Device_directory@:

    def __init__(dev, filenames):
        dev.filenames = filenames
        dev.index = 0

    def read(dev, dev_condvar_scm):

        if @os_debug@:
            print('@Device_directory@([...]).read(...)')

        if dev.index >= len(dev.filenames):
            return @eof_obj@  # end of list of filenames
        else:
            dev.index += 1
            return @host2scm@(dev.filenames[dev.index-1])

    def close(dev, direction):

        if @os_debug@:
            print('@Device_directory@([...]).close('+repr(direction)+')')

        return 0  # no error
"))

   (else
    #f)))

(define-prim (##os-device-directory-open-path path ignore-hidden)
  (##first-argument #f ##feature-device-directory)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_directory_open_path@ = function (path_scm, ignore_hidden_scm) {

  var path = @scm2host@(path_scm);
  var ignore_hidden = @scm2host@(ignore_hidden_scm);

  if (@os_debug@)
    console.log('@os_device_directory_open_path@(\\''+path+'\\','+ignore_hidden+')');

  var filenames;

  try {
    filenames = @os_fs@.readdirSync(path);
  } catch (exn) {
    if (exn instanceof Error && exn.hasOwnProperty('code')) {
      return @host2scm@(@os_encode_error@(exn));
    } else {
      throw exn;
    }
  }

  switch (ignore_hidden) {
    case 0:
      // list all files
      // need to add '.' and '..' which are not returned by readdirSync
      filenames = ['.', '..'].concat(filenames);
      break;
    case 1:
      // list all files except '.' and '..'
      // this is already the case when using readdirSync
      break;
    default: // ignore_hidden == 2
      // list all files except hidden files ('.', '..', etc)
      filenames = filenames.filter(function (name) {
                    return !name.startsWith('.');
                  });
      break;
  }

  var dev = new @Device_directory@(filenames);

  return @host2foreign@(dev);
};

")
    (##inline-host-expression
     "@os_device_directory_open_path@(@1@,@2@)"
     path
     ignore-hidden))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_directory_open_path@(path_scm, ignore_hidden_scm):

    path = @scm2host@(path_scm)
    ignore_hidden = @scm2host@(ignore_hidden_scm)

    if @os_debug@:
        print('@os_device_directory_open_path@('+repr(path)+','+repr(ignore_hidden)+')')

    try:
        filenames = os.listdir(path)
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

    if ignore_hidden == 0:
        # list all files
        # need to add '.' and '..' which are not returned by os.listdir
        filenames = ['.', '..'] + filenames
    elif ignore_hidden == 1:
        # list all files except '.' and '..'
        # this is already the case when using readdirSync
        pass
    else: # ignore_hidden == 2
        # list all files except hidden files ('.', '..', etc)
        filenames = filter(lambda name: name[:1] != '.', filenames)

    dev = @Device_directory@(filenames)

    return @host2foreign@(dev)

")
    (##inline-host-expression
     "@os_device_directory_open_path@(@1@,@2@)"
     path
     ignore-hidden))

   (else
    (println "unimplemented ##os-device-directory-open-path called")
    -5555)))

(define-prim (##os-device-directory-read dev-condvar)
  (cond-expand

   ((compilation-target js)
    (##first-argument #f ##feature-device-directory)
    (##inline-host-declaration "

@os_device_directory_read@ = function (dev_condvar_scm) {

  var dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@]);

  if (@os_debug@)
    console.log('@os_device_directory_read@(...)');

  return dev.read(dev_condvar_scm);
};

")
    (##inline-host-expression
     "@os_device_directory_read@(@1@)"
     dev-condvar))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_directory_read@(dev_condvar_scm):

    dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@])

    if @os_debug@:
        print('@os_device_directory_read@(...)')

    return dev.read(dev_condvar_scm)

")
    (##inline-host-expression
     "@os_device_directory_read@(@1@)"
     dev-condvar))

   (else
    (println "unimplemented ##os-device-directory-read called")
    -5555)))

(define ##feature-callback-queue
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@Device_event_queue@ = function (selector) {
  var dev = this;
  dev.selector = selector;
  dev.queue = [];
  dev.read_condvar_scm = null;
};

@Device_event_queue@.prototype.read = function (dev_condvar_scm) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_event_queue@('+dev.selector+').read(...)');

  if (dev.queue.length === 0) {

    @os_condvar_ready_set@(dev_condvar_scm, false);

    if (dev.read_condvar_scm === null) {
      dev.read_condvar_scm = dev_condvar_scm;
    }

    return -35; // return EAGAIN to suspend Scheme thread on condvar
  }

  return dev.queue.shift(); // return first available event
};

@Device_event_queue@.prototype.write = function (event_scm) {

  var dev = this;

  if (@os_debug@)
    console.log('@Device_event_queue@('+dev.selector+').write(...)');

  dev.queue.push(event_scm);

  var condvar_scm = dev.read_condvar_scm;

  if (condvar_scm !== null) {
    dev.read_condvar_scm = null;
    @os_condvar_ready_set@(condvar_scm, true);
  }
};

@callback_queue@ = new @Device_event_queue@(@host2scm@(false));

"))

   (else
    #f)))

(define-prim (##os-device-event-queue-open selector)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_event_queue_open@ = function (selector_scm) {

  var selector = @scm2host@(selector_scm);

  if (@os_debug@)
    console.log('@os_device_event_queue_open@('+selector+')');

  var dev;

  if (selector === false) {
    dev = @callback_queue@;
  } else {
    dev = new @Device_event_queue@(selector);
  }

  return @host2foreign@(dev);
};

")
    (##inline-host-expression
     "@os_device_event_queue_open@(@1@)"
     selector))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_event_queue_open@(selector_scm):

    selector = @scm2host@(selector_scm)

    if @os_debug@:
        print('@os_device_event_queue_open@('+repr(selector)+')  ***not implemented***')

    return @host2scm@(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "@os_device_event_queue_open@(@1@)"
     selector))

   (else
    (println "unimplemented ##os-device-event-queue-open called")
    -5555)))

(define-prim (##os-device-event-queue-read dev-condvar)
  (cond-expand

   ((compilation-target js)
    (##first-argument #f ##feature-callback-queue)
    (##inline-host-declaration "

@os_device_event_queue_read@ = function (dev_condvar_scm) {

  var dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@]);

  if (@os_debug@)
    console.log('@os_device_event_queue_read@(...)');

  return dev.read(dev_condvar_scm);
};

")
    (##inline-host-expression
     "@os_device_event_queue_read@(@1@)"
     dev-condvar))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_event_queue_read@(dev_condvar_scm):

    dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@])

    if @os_debug@:
        print('@os_device_event_queue_read@(...)  ***not implemented***')

    return @host2scm@(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "@os_device_event_queue_read@(@1@)"
     dev-condvar))

   (else
    (println "unimplemented ##os-device-event-queue-read called")
    -5555)))

(define-prim (##os-device-stream-open-process path-and-args environment directory options)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_open_process@ = function (path_and_args_scm, environment_scm, directory_scm, options_scm) {

  if (@os_debug@)
    console.log('@os_device_stream_open_process@(...)  ***not implemented***');

  return @host2scm@(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "@os_device_stream_open_process@(@1@,@2@,@3@,@4@)"
     path-and-args
     environment
     directory
     options))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_open_process@(path_and_args_scm, environment_scm, directory_scm, options_scm):

    if @os_debug@:
        print('@os_device_stream_open_process@(...)  ***not implemented***')

    return @host2scm@(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "@os_device_stream_open_process@(@1@,@2@,@3@,@4@)"
     path-and-args
     environment
     directory
     options))

   (else
    (println "unimplemented ##os-device-stream-open-process called")
    -5555)))

(define-prim (##os-device-process-pid dev)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_process_pid@ = function (dev_scm) {

  var dev = @foreign2host@(dev_scm);

  if (@os_debug@)
    console.log('@os_device_process_pid@(...)  ***not implemented***');

  return @host2scm@(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "@os_device_process_pid@(@1@)"
     dev))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_process_pid@(dev_scm):

    dev = @foreign2host@(dev_scm)

    if @os_debug@:
        print('@os_device_process_pid@(...)  ***not implemented***')

    return @host2scm@(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "@os_device_process_pid@(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-process-pid called")
    -5555)))

(define-prim (##os-device-process-status dev)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_process_status@ = function (dev_scm) {

  var dev = @foreign2host@(dev_scm);

  if (@os_debug@)
    console.log('@os_device_process_status@(...)  ***not implemented***');

  return @host2scm@(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "@os_device_process_status@(@1@)"
     dev))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_process_status@(dev_scm):

    dev = @foreign2host@(dev_scm)

    if @os_debug@:
        print('@os_device_process_status@(...)  ***not implemented***')

    return @host2scm@(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "@os_device_process_status@(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-process-status called")
    -5555)))

(define-prim (##os-device-stream-default-options dev)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_default_options@ = function (dev_scm) {

  var dev = @foreign2host@(dev_scm);

  if (@os_debug@)
    console.log('@os_device_stream_default_options@(...)  ***not fully implemented***');

  return @host2scm@(((2<<9)<<15)+(2<<9)); // line buffering
};

")
    (##inline-host-expression
     "@os_device_stream_default_options@(@1@)"
     dev))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_default_options@(dev_scm):

    dev = @foreign2host@(dev_scm)

    if @os_debug@:
        print('@os_device_stream_default_options@(...)  ***not fully implemented***')

    return @host2scm@(((2<<9)<<15)+(2<<9))  # line buffering

")
    (##inline-host-expression
     "@os_device_stream_default_options@(@1@)"
     dev))

   (else
    (println "unimplemented ##os-device-stream-default-options called")
    -5555)))

(define-prim (##os-device-stream-options-set! dev options)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_options_set@ = function (dev_scm, options_scm) {

  var dev = @foreign2host@(dev_scm);
  var options = @scm2host@(options_scm);

  if (@os_debug@)
    console.log('@os_device_stream_options_set@(...,'+options+')  ***not implemented***');

  return @host2scm@(-1); // EPERM (operation not permitted)
};

")
    (##inline-host-expression
     "@os_device_stream_options_set@(@1@,@2@)"
     dev
     options))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_options_set@(dev_scm, options_scm):

    dev = @foreign2host@(dev_scm)
    options = @scm2host@(options_scm)

    if @os_debug@:
        print('@os_device_stream_options_set@(...,'+repr(options)+')  ***not implemented***')

    return @host2scm@(-1)  # EPERM (operation not permitted)

")
    (##inline-host-expression
     "@os_device_stream_options_set@(@1@,@2@)"
     dev
     options))

   (else
    (println "unimplemented ##os-device-stream-options-set! called")
    -5555)))

(define-prim (##os-device-stream-open-predefined index flags)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_open_predefined@ = function (index_scm, flags_scm) {

  var index = @scm2host@(index_scm);
  var flags = @scm2host@(flags_scm);

  if (@os_debug@)
    console.log('@os_device_stream_open_predefined@('+index+','+flags+')');

  var dev;

  switch (index) {
    case -1: dev = @os_device_from_stdin@();   break;
    case -2: dev = @os_device_from_stdout@();  break;
    case -3: dev = @os_device_from_stderr@();  break;
    case -4: dev = @os_device_from_basic_console@(); break;
    default: dev = @os_device_from_fd@(index); break;
  }

  return @host2foreign@(dev);
};

")
    (##inline-host-expression
     "@os_device_stream_open_predefined@(@1@,@2@)"
     index
     flags))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_open_predefined@(index_scm, flags_scm):

    index = @scm2host@(index_scm)
    flags = @scm2host@(flags_scm)

    if @os_debug@:
      print('@os_device_stream_open_predefined@('+repr(index)+','+repr(flags)+')')

    if index == -1:
        dev = @os_device_from_stdin@()
    elif index == -2:
        dev = @os_device_from_stdout@()
    elif index == -3:
        dev = @os_device_from_stderr@()
    elif index == -4:
        dev = @os_device_from_basic_console@()
    else:
        dev = @os_device_from_fd@(index)

    return @host2foreign@(dev)

")
    (##inline-host-expression
     "@os_device_stream_open_predefined@(@1@,@2@)"
     index
     flags))

   (else
    (println "unimplemented ##os-device-stream-open-predefined called")
    -5555)))

(define-prim (##os-device-stream-open-path path flags mode)
  (cond-expand

   ((compilation-target js)
    (##first-argument #f ##feature-file-input)
    (##inline-host-declaration "

if (@os_fs@) {

  @os_translate_flags@ = function (flags) {

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

if (@os_web@) {

  @Device_blob@ = function (blob) {
    var dev = this;
    dev.rbuf = blob;
    dev.rlo = 0;
    dev.rhi = blob.length;
  };

  @Device_blob@.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_blob@(...).read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    var n = hi-lo;
    var have = dev.rhi-dev.rlo;

    if (have <= 0) {
      return @host2scm@(0); // signal EOF
    } else {

      if (n > have) n = have;

      buffer.set(dev.rbuf.subarray(dev.rlo, dev.rlo+n), lo);

      dev.rlo += n;

      return @host2scm@(n); // number of bytes transferred
    };
  };

  @Device_blob@.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_blob@(...).write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

    return -1; // EPERM (operation not permitted)
  };

  @Device_blob@.prototype.force_output = function (dev_condvar_scm, level) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_blob@(...).force_output(...,'+level+')');

    return -1; // EPERM (operation not permitted)
  };

  @Device_blob@.prototype.seek = function (dev_condvar_scm, pos, whence) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_blob@(...).seek(...,'+pos+','+whence+')');

    return -1; // EPERM (operation not permitted)
  };

  @Device_blob@.prototype.width = function (dev_condvar_scm) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_blob@(...).width()');

    return -1; // EPERM (operation not permitted)
  };

  @Device_blob@.prototype.close = function (direction) {

    var dev = this;

    if (@os_debug@)
      console.log('@Device_blob@(...).close('+direction+')');

    if ((direction & 1) != 0 ||  // DIRECTION_RD
        (direction & 2) != 0) {  // DIRECTION_WR

      dev.rbuf = new Uint8Array(0);
      dev.rlo = 0;
      dev.rhi = 0;

      return 0; // ignored
    }

    return 0; // no error
  };

  @os_device_from_blob@ = function (blob) {
    return new @Device_blob@(blob);
  };
}

@os_device_stream_open_path@ = function (path_scm, flags_scm, mode_scm) {

  var path = @scm2host@(path_scm);
  var flags = @scm2host@(flags_scm);
  var mode = @scm2host@(mode_scm);

  if (@os_debug@)
    console.log('@os_device_stream_open_path@(\\''+path+'\\','+flags+','+mode+')');

  if (@os_uri_scheme_prefixed@(path)) { // accessing a URL?

    if (!(@os_web@ && @os_trusted_url@(path, 'to read that document'))) { // accessing an untrusted URL?
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      if (((flags >> 4) & 3) === 1) { // for reading?

        var ra = @r0@;
        @r0@ = null; // exit trampoline

        function callback(req) {

          if (req.status === 404) {
            @r1@ = @host2scm@(-2); // ENOENT (file does not exist)
          } else if (req.status !== 200) {
            @r1@ = @host2scm@(-1); // EPERM (operation not permitted)
          } else {
            var dev = @os_device_from_blob@(new TextEncoder().encode(req.responseText));
            @r1@ = @host2foreign@(dev);
          }

          @r0@ = ra;
          @trampoline@(@r0@);
        }

        @os_get_url_async@('GET', @os_uri_encode@(path), callback);

        return 0; // ignored
      } else {
        return @host2scm@(-1); // EPERM (operation not permitted)
      }
    }

  } else {

    if (!@os_fs@) {
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      // Start an async open of the file

      var async_progress = @async_op_done@; // open not yet started
      var ra = @r0@;

      function callback(err, fd) {
        var progress = async_progress;
        if (err) {
          async_progress = @host2scm@(@os_encode_error@(err));
        } else {
          async_progress = @host2foreign@(@os_device_from_fd@(fd));
        }
        if (progress === @async_op_in_progress@) {
          @r1@ = async_progress;
          @r0@ = ra;
          @trampoline@(@r0@);
        }
      }

      @os_fs@.open(path, @os_translate_flags@(flags), mode, callback);

      if (async_progress !== @async_op_done@) {
        // handle synchronous execution of callback
        return async_progress;
      } else {
        async_progress = @async_op_in_progress@;
        @r0@ = null; // exit trampoline
        return 0; // ignored
      }
    }
  }
};

")
    (##inline-host-expression
     "@os_device_stream_open_path@(@1@,@2@,@3@)"
     path
     flags
     mode))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_translate_flags@(flags):

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

def @os_device_stream_open_path@(path_scm, flags_scm, mode_scm):

    path = @scm2host@(path_scm)
    flags = @scm2host@(flags_scm)
    mode = @scm2host@(mode_scm)

    if @os_debug@:
        print('@os_device_stream_open_path@('+repr(path)+','+repr(flags)+','+repr(mode)+')')

    try:
        fd = os.open(path, @os_translate_flags@(flags), mode)
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

    dev = @os_device_from_fd@(fd)

    return @host2foreign@(dev)

")
    (##inline-host-expression
     "@os_device_stream_open_path@(@1@,@2@,@3@)"
     path
     flags
     mode))

   (else
    (println "unimplemented ##os-device-stream-open-path called")
    -5555)))

(define-prim (##os-device-stream-read dev-condvar buffer lo hi)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_read@ = function (dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@]);
  var buffer = buffer_scm.@elems@;
  var lo = @scm2host@(lo_scm);
  var hi = @scm2host@(hi_scm);

  return @host2scm@(dev.read(dev_condvar_scm, buffer, lo, hi));
};

")
    (##inline-host-expression
     "@os_device_stream_read@(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_read@(dev_condvar_scm, buffer_scm, lo_scm, hi_scm):

    dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@])
    buffer = buffer_scm.@elems@
    lo = @scm2host@(lo_scm)
    hi = @scm2host@(hi_scm)

    return @host2scm@(dev.read(dev_condvar_scm, buffer, lo, hi))

")
    (##inline-host-expression
     "@os_device_stream_read@(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   (else
    (println "unimplemented ##os-device-stream-read called")
    -5555)))

(define-prim (##os-device-stream-write dev-condvar buffer lo hi)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_write@ = function (dev_condvar_scm, buffer_scm, lo_scm, hi_scm) {

  var dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@]);
  var buffer = buffer_scm.@elems@;
  var lo = @scm2host@(lo_scm);
  var hi = @scm2host@(hi_scm);

  return @host2scm@(dev.write(dev_condvar_scm, buffer, lo, hi));
};

")
    (##inline-host-expression
     "@os_device_stream_write@(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_write@(dev_condvar_scm, buffer_scm, lo_scm, hi_scm):

    dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@])
    buffer = buffer_scm.@elems@
    lo = @scm2host@(lo_scm)
    hi = @scm2host@(hi_scm)

    return @host2scm@(dev.write(dev_condvar_scm, buffer, lo, hi))

")
    (##inline-host-expression
     "@os_device_stream_write@(@1@,@2@,@3@,@4@)"
     dev-condvar
     buffer
     lo
     hi))

   (else
    (println "unimplemented ##os-device-stream-write called")
    -5555)))

(define-prim (##os-device-stream-seek dev-condvar pos whence)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_seek@ = function (dev_condvar_scm, pos_scm, whence_scm) {

  var dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@]);
  var pos = @scm2host@(pos_scm);
  var whence = @scm2host@(whence_scm);

  return @host2scm@(dev.seek(dev_condvar_scm, pos, whence));
};

")
    (##inline-host-expression
     "@os_device_stream_seek@(@1@,@2@,@3@)"
     dev-condvar
     pos
     whence))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_seek@(dev_condvar_scm, pos_scm, whence_scm):

    dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@])
    pos = @scm2host@(pos_scm)
    whence = @scm2host@(whence_scm)

    return @host2scm@(dev.seek(dev_condvar_scm, pos, whence))

")
    (##inline-host-expression
     "@os_device_stream_seek@(@1@,@2@,@3@)"
     dev-condvar
     pos
     whence))

   (else
    (println "unimplemented ##os-device-stream-seek called")
    -5555)))

(define-prim (##os-device-stream-width dev-condvar)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_device_stream_width@ = function (dev_condvar_scm) {

  var dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@]);

  return @host2scm@(dev.width(dev_condvar_scm));
};

")
    (##inline-host-expression
     "@os_device_stream_width@(@1@)"
     dev-condvar))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_device_stream_width@(dev_condvar_scm):

    dev = @foreign2host@(dev_condvar_scm.@slots@[@CONDVAR_NAME@])

    return @host2scm@(dev.width(dev_condvar_scm))

")
    (##inline-host-expression
     "@os_device_stream_width@(@1@)"
     dev-condvar))

   (else
    (println "unimplemented ##os-device-stream-width called")
    -5555)))

(define-prim (##os-port-decode-chars! port want eof)
  (##first-argument #f ##feature-port-fields)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_port_decode_chars@ = function (port_scm, want_scm, eof_scm) {

  var want = @scm2host@(want_scm);
  var eof = @scm2host@(eof_scm);

  if (@os_debug@)
    console.log('@os_port_decode_chars@(port,'+want+','+eof+')  ***not fully implemented***');

  var cbuf_scm = port_scm.@slots@[@PORT_CHAR_RBUF@];
  var chi = @scm2host@(port_scm.@slots@[@PORT_CHAR_RHI@]);
  var cend = cbuf_scm.@codes@.length;
  var bbuf = port_scm.@slots@[@PORT_BYTE_RBUF@].@elems@
  var blo = @scm2host@(port_scm.@slots@[@PORT_BYTE_RLO@]);
  var bhi = @scm2host@(port_scm.@slots@[@PORT_BYTE_RHI@]);
  var options = @scm2host@(port_scm.@slots@[@PORT_ROPTIONS@]);

  if (want != false)
    {
      var cend2 = chi + want;
      if (cend2 < cend)
        cend = cend2;
    }

  var cbuf_avail = cend - chi;
  var bbuf_avail = bhi - blo;

  while (cbuf_avail > 0 && bbuf_avail > 0) {
    cbuf_scm.@codes@[cend - cbuf_avail] = bbuf[bhi - bbuf_avail];
    bbuf_avail--;
    cbuf_avail--;
  }

  port_scm.@slots@[@PORT_CHAR_RHI@] = @host2scm@(cend - cbuf_avail);
  port_scm.@slots@[@PORT_BYTE_RLO@] = @host2scm@(bhi - bbuf_avail);
  port_scm.@slots@[@PORT_ROPTIONS@] = @host2scm@(options);

  return @host2scm@(0) // no error
};

")
    (##inline-host-expression
     "@os_port_decode_chars@(@1@,@2@,@3@)"
     port
     want
     eof))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_port_decode_chars@(port_scm, want_scm, eof_scm):

    want = @scm2host@(want_scm)
    eof = @scm2host@(eof_scm)

    if @os_debug@:
        print('@os_port_decode_chars@(port,'+repr(want)+','+repr(eof)+')  ***not fully implemented***')

    cbuf_scm = port_scm.@slots@[@PORT_CHAR_RBUF@]
    chi = @scm2host@(port_scm.@slots@[@PORT_CHAR_RHI@])
    cend = len(cbuf_scm.@codes@)
    bbuf = port_scm.@slots@[@PORT_BYTE_RBUF@].@elems@
    blo = @scm2host@(port_scm.@slots@[@PORT_BYTE_RLO@])
    bhi = @scm2host@(port_scm.@slots@[@PORT_BYTE_RHI@])
    options = @scm2host@(port_scm.@slots@[@PORT_ROPTIONS@])

    if not want == False:
        cend2 = chi + want
        if cend2 < cend:
            cend = cend2

    cbuf_avail = cend - chi
    bbuf_avail = bhi - blo

    while cbuf_avail > 0 and bbuf_avail > 0:
        cbuf_scm.@codes@[cend - cbuf_avail] = bbuf[bhi - bbuf_avail]
        bbuf_avail = bbuf_avail-1
        cbuf_avail = cbuf_avail-1

    port_scm.@slots@[@PORT_CHAR_RHI@] = @host2scm@(cend - cbuf_avail)
    port_scm.@slots@[@PORT_BYTE_RLO@] = @host2scm@(bhi - bbuf_avail)
    port_scm.@slots@[@PORT_ROPTIONS@] = @host2scm@(options)

    return @host2scm@(0)  # no error

")
    (##inline-host-expression
     "@os_port_decode_chars@(@1@,@2@,@3@)"
     port
     want
     eof))

   (else
    (println "unimplemented ##os-port-decode-chars! called")
    -5555)))

(define-prim (##os-port-encode-chars! port)
  (##first-argument #f ##feature-port-fields)
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_port_encode_chars@ = function (port_scm) {

  if (@os_debug@)
    console.log('@os_port_encode_chars@(port)  ***not fully implemented***');

  var cbuf_scm = port_scm.@slots@[@PORT_CHAR_WBUF@];
  var clo = @scm2host@(port_scm.@slots@[@PORT_CHAR_WLO@]);
  var chi = @scm2host@(port_scm.@slots@[@PORT_CHAR_WHI@]);
  var bbuf = port_scm.@slots@[@PORT_BYTE_WBUF@].@elems@
  var bhi = @scm2host@(port_scm.@slots@[@PORT_BYTE_WHI@]);
  var bend = bbuf.length;
  var options = @scm2host@(port_scm.@slots@[@PORT_WOPTIONS@]);
  var cbuf_avail = chi - clo;
  var bbuf_avail = bend - bhi;

  while (cbuf_avail > 0 && bbuf_avail > 0) {
    bbuf[bend - bbuf_avail] = cbuf_scm.@codes@[chi - cbuf_avail];
    bbuf_avail--;
    cbuf_avail--;
  }

  port_scm.@slots@[@PORT_CHAR_WLO@] = @host2scm@(chi - cbuf_avail);
  port_scm.@slots@[@PORT_BYTE_WHI@] = @host2scm@(bend - bbuf_avail);
  port_scm.@slots@[@PORT_WOPTIONS@] = @host2scm@(options);

  return @host2scm@(0) // no error
};

")
    (##inline-host-expression
     "@os_port_encode_chars@(@1@)"
     port))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_port_encode_chars@(port_scm):

    if @os_debug@:
        print('@os_port_encode_chars@(port)  ***not fully implemented***')

    cbuf_scm = port_scm.@slots@[@PORT_CHAR_WBUF@]
    clo = @scm2host@(port_scm.@slots@[@PORT_CHAR_WLO@])
    chi = @scm2host@(port_scm.@slots@[@PORT_CHAR_WHI@])
    bbuf = port_scm.@slots@[@PORT_BYTE_WBUF@].@elems@
    bhi = @scm2host@(port_scm.@slots@[@PORT_BYTE_WHI@])
    bend = len(bbuf)
    options = @scm2host@(port_scm.@slots@[@PORT_WOPTIONS@])
    cbuf_avail = chi - clo
    bbuf_avail = bend - bhi

    while cbuf_avail > 0 and bbuf_avail > 0:
        bbuf[bend - bbuf_avail] = cbuf_scm.@codes@[chi - cbuf_avail]
        bbuf_avail = bbuf_avail-1
        cbuf_avail = cbuf_avail-1

    port_scm.@slots@[@PORT_CHAR_WLO@] = @host2scm@(chi - cbuf_avail)
    port_scm.@slots@[@PORT_BYTE_WHI@] = @host2scm@(bend - bbuf_avail)
    port_scm.@slots@[@PORT_WOPTIONS@] = @host2scm@(options)

    return @host2scm@(0)  # no error

")
    (##inline-host-expression
     "@os_port_encode_chars@(@1@)"
     port))

   (else
    (println "unimplemented ##os-port-encode-chars! called")
    -5555)))

(define-prim (##os-condvar-select! devices timeout)
  (##declare (not interrupts-enabled))
  (##first-argument #f ##feature-port-fields)
  (cond-expand

   ((compilation-target js)
    (##first-argument #f ##feature-callback-queue)
    (##inline-host-declaration "

@os_condvar_ready_set@ = function (condvar_scm, ready) {

  var owner = condvar_scm.@slots@[@BTQ_OWNER@];

  if (ready) {
    condvar_scm.@slots@[@BTQ_OWNER@] = owner | 1; // mark as 'ready'
    @os_condvar_select_resume@();
  } else {
    condvar_scm.@slots@[@BTQ_OWNER@] = owner & ~1; // mark as 'not ready'
  }

};

@os_condvar_select_resume@ = function () {

  @os_condvar_select_resume_cancel@();

  // execute continuation if there is one

  var cont = @os_condvar_select_resume_ra@;

  if (cont !== null) {
    @os_condvar_select_resume_ra@ = null;
    @r1@ = @host2scm@(0);
    @r0@ = cont;
    @trampoline@(@r0@);
  }
};

@os_condvar_select_resume_cancel@ = function () {

  // cancel time-delayed resume if there is one

  if (@os_condvar_select_resume_timeoutId@ !== null) {
    clearTimeout(@os_condvar_select_resume_timeoutId@);
    @os_condvar_select_resume_timeoutId@ = null;
  }

};

@os_condvar_select_resume_timeoutId@ = null;
@os_condvar_select_resume_ra@ = null;

@os_condvar_select@ = function (devices_scm, timeout_scm) {

  var timeout_ms;

  if (timeout_scm === false)
    timeout_ms = 0;
  else if (timeout_scm === true)
    timeout_ms = 999999; // almost forever...
  else
    timeout_ms = (timeout_scm.@elems@[0]-@os_current_time@()) * 1000;

  if (@os_debug@) {
    var no_devices = (devices_scm === false ||
                      devices_scm === devices_scm.@slots@[@BTQ_DEQ_NEXT@]);
    console.log('@os_condvar_select@('+(no_devices?'no devices':'some devices')+', '+timeout_ms+' ms)');
  }

  if (@callback_queue@.queue.length > 0) {
    // There are callbacks available in the callback queue, so there
    // is no need to wait for other callbacks.
    timeout_ms = 0;
  }

  // The Scheme code execution needs to be suspended to allow the
  // JavaScript VM (browser) to handle events.  These events (or
  // expiration of the timeout) will in turn cause the execution
  // of the Scheme code to resume.  Note that browsers implement
  // 'clamping' of the timeout after a certain number of nested calls
  // (typically 5 ms), and this may impact performance.

  // resume execution at @r0@ after the timeout

  @os_condvar_select_resume_ra@ = @r0@;
  @r0@ = null; // exit trampoline
  @os_condvar_select_resume_timeoutId@ =
    setTimeout(@os_condvar_select_resume@, Math.max(0, timeout_ms));

  return 0; // ignored
};

")
    (##inline-host-expression
     "@os_condvar_select@(@1@,@2@)"
     devices
     timeout))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_condvar_select@(devices_scm, timeout_scm):

    if @os_debug@:
        print('@os_condvar_select@(devices, timeout)')

    return @host2scm@(False)  # no error

")
    (##inline-host-expression
     "@os_condvar_select@(@1@,@2@)"
     devices
     timeout))

   (else
    (println "unimplemented ##os-condvar-select! called")
    -5555)))

;;;----------------------------------------------------------------------------

;;; Loading of compiled files.

(define (##os-load-object-file path linker-name)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js)
    (##inline-host-declaration "

@os_load_object_file@ = function (path, linker_name) {

  if (@os_nodejs@) {

    try {
      require(path);
    } catch (exn) {
      if (exn instanceof Error && exn.hasOwnProperty('code')) {
        return @host2scm@(@os_encode_error@(exn));
      } else {
        throw exn;
      }
    }

    return [[@module_latest_registered@], null, false];

  } else if (@os_web@) {

    path += '.js'; // add a .js extension to force application/javascript
                   // MIME type (this requires the .o1 file to be copied to
                   // a .o1.js file)

    if (!@os_trusted_url@(path, 'to execute that code')) { // accessing an untrusted URL?
      return @host2scm@(-1); // EPERM (operation not permitted)
    } else {

      var ra = @r0@;
      @r0@ = null; // exit trampoline

      function onload() {
        @r1@ = [[@module_latest_registered@], null, false];
        @r0@ = ra;
        @trampoline@(@r0@);
      }

      function onerror() {
        @r1@ = @host2scm@(-2); // ENOENT (file does not exist)
        @r0@ = ra;
        @trampoline@(@r0@);
      }

      if (self.document === undefined) {
        try {
          self.importScripts(path);
          onload();
        } catch(e) {
          onerror();
        }
      } else {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = path;
        script.onload = onload;
        script.onerror = onerror;
        document.head.append(script);
      }
      return 0; // ignored
    }
  } else {
    return @host2scm@(-1); // EPERM (operation not permitted)
  }
};

")
    (##inline-host-expression
     "@os_load_object_file@(@scm2host@(@1@), @scm2host@(@2@))"
     path
     linker-name))

   ((compilation-target python)
    (##inline-host-declaration "

def @os_load_object_file@(path, linker_name):

    try:
        @exec@(open(path).read())
    except OSError as exn:
        return @host2scm@(@os_encode_error@(exn))

    return [[@module_latest_registered@], @null_obj@, False]

")
    (##inline-host-expression
     "@os_load_object_file@(@scm2host@(@1@), @scm2host@(@2@))"
     path
     linker-name))

   (else
    (##vector "load-object-file not implemented" linker-name))))

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

;;; Host FFI.

(define (##string-substitute str delim proc-or-alist)

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
                    (let* ((var
                            (##substring str (##fx+ start 1) end))
                           (subst
                            (if (##procedure? proc-or-alist)
                                (proc-or-alist var)
                                (let ((x (##assoc-string-equal? var proc-or-alist)))
                                  (and x (##cdr x))))))
                      (if subst
                          (loop (##fx+ end 1)
                                (##fx+ end 1)
                                (##cons subst
                                        (##cons (##substring str i start)
                                                out)))
                          (##error "Unbound substitution variable in" str))))
                (##error "Unbalanced delimiter in" str)))
          (##string-concatenate
           (##reverse (##cons (##substring str i start) out)))))))

(define (##expand-inline-host-code code-str substs)

  (define (substitute str)
    (let ((x (##assoc-string-equal? str substs)))
      (if x
          (##cdr x)
          (##string-append
           (if (##char-upper-case? (##string-ref str 0))
               (##inline-host-expression "@host2scm@('@Z@'.slice(0, -1))")
               (##inline-host-expression "@host2scm@('@z@'.slice(0, -1))"))
           str))))

  (##string-substitute code-str #\@ substitute))

(cond-expand

 ((compilation-target js)
  (##inline-host-declaration "

@eval@ = function (expr) {
  return (1,eval)(expr);
};

@exec@ = function (stmts) {
  (1,eval)(stmts);
};

@host_define_function@ = function (name, params, header, expr) {
  @exec@(name + ' = function (' + params + ') {' + header + '\\n return ' + expr + ';\\n};');
};

@host_define_procedure@ = function (name, params, header, stmts) {
  @exec@(name + ' = function (' + params + ') {' + header + '\\n' + stmts + '\\n};');
};

@host_function_call@ = function (fn, args) {
  return @eval@(fn).apply(this, args);
};

@host_procedure_call@ = function (proc, args) {
  @eval@(proc).apply(this, args);
};

@host_eval@ = function (expr) {
  return @eval@(expr);
};

@host_exec@ = function (stmts) {
  @exec@(stmts);
};

"))

 ((compilation-target python)
  (##inline-host-declaration "

def @eval@(expr):
    return eval(expr, globals())

def @exec@(stmts):
    exec(stmts, globals())

def @host_define_function@(name, params, header, expr):
    @exec@('def ' + name + '(' + params + '):' + header + '\\n return ' + expr)

def @host_define_procedure@(name, params, header, stmts):
    @exec@('def ' + name + '(' + params + '):' + '\\n '.join((header+'\\n'+stmts).split('\\n')) + '\\n')

def @host_function_call@(fn, args):
    return globals()[fn](*args)

def @host_procedure_call@(proc, args):
    globals()[proc](*args)

def @host_eval@(expr):
    return @eval@(expr)

def @host_exec@(stmts):
    @exec@(stmts)

"))

 (else))

(define (##host-convert-param param)
  (##declare (not interrupts-enabled))
  (##string-append "\n" param
                   (##inline-host-expression "@host2scm@(' = @scm2host@(')")
                   param
                   ")"
                   (cond-expand
                    ((compilation-target js)
                     ";")
                    (else
                     ""))))

(define (##host-create-header params)
  (##string-concatenate (##map ##host-convert-param params)))

(define (##host-define-function-dynamic name params expr)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js python)
    (##inline-host-statement
     "@host_define_function@(@scm2host@(@1@),@scm2host@(@2@),@scm2host@(@3@),@scm2host@(@4@))"
     name
     (##string-concatenate params ",")
     (##host-create-header params)
     (##string-append (##inline-host-expression "@host2scm@('@host2scm@(')")
                      expr
                      ")")))

   (else
    (println "unimplemented ##host-define-function-dynamic called with name=")
    (println name)
    (println "and params=")
    (println params)
    (println "and expr=")
    (println expr))))

(define (##host-define-procedure-dynamic name params stmts)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js python)
    (##inline-host-statement
     "@host_define_procedure@(@scm2host@(@1@),@scm2host@(@2@),@scm2host@(@3@),@scm2host@(@4@))"
     name
     (##string-concatenate params ",")
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
  (cond-expand

   ((compilation-target js python)
    (##inline-host-expression
     "@host_function_call@(@scm2host@(@1@), @2@)"
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
  (cond-expand

   ((compilation-target js python)
    (##inline-host-statement
     "@host_procedure_call@(@scm2host@(@1@), @2@)"
     proc
     args))

   (else
    (println "unimplemented ##host-procedure-call called with proc=")
    (println proc)
    (println "and args=")
    (println args))))

(define (##host-eval-dynamic expr)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js python)
    (##inline-host-expression
     "@host2scm@(@host_eval@(@scm2host@(@1@)))"
     expr))

   (else
    (println "unimplemented ##host-eval-dynamic called with expr=")
    (println expr)
    #f)))

(define (##host-exec-dynamic stmts)
  (##declare (not interrupts-enabled))
  (cond-expand

   ((compilation-target js python)
    (##inline-host-statement
     "@host_exec@(@scm2host@(@1@))"
     stmts))

   (else
    (println "unimplemented ##host-exec-dynamic called with stmts=")
    (println stmts))))

;; The ##host-function-memoized procedure takes a descriptor and
;; returns a procedure.  The descriptor is a box containing a string
;; that evaluates to a function.  In this state the string will be
;; passed to the host's eval function to create a Scheme procedure
;; that will be returned.  After this first evaluation the Scheme
;; procedure obtained is stored in the descriptor to avoid calling the
;; host's eval function on each call of ##host-function-memoized with
;; that descriptor.

(define (##host-function-memoized descr)
  (let ((x (##unbox descr)))
    (if (##string? x)
        (let ((host-fn (##host-eval-dynamic x)))
          (##set-box! descr host-fn)
          host-fn)
        x)))

(define (##host-decl-expand decl)
  (##host-exec-dynamic decl)
  `(##begin))

(define ##host-fn-counter 0)

(define (##host-exec-expand stmts args-src)
  (set! ##host-fn-counter (##fx+ ##host-fn-counter 1))
  (let ((name
         (##string-append "___fn" (##fixnum->string ##host-fn-counter)))
        (substs
         (##map (lambda (i)
                  (let ((i-str (##fixnum->string i)))
                    (##cons i-str
                            (##string-append "___arg" i-str))))
                (##iota-fixnum (##length args-src) 1))))
    (##host-define-procedure-dynamic
     name
     (##map ##cdr substs)
     (##expand-inline-host-code stmts substs))
    `(##host-procedure-call
      ,name
      (##vector ,@args-src))))

(define (##host-eval-expand expr args-src)
  (set! ##host-fn-counter (##fx+ ##host-fn-counter 1))
  (let ((name
         (##string-append "___fn" (##fixnum->string ##host-fn-counter)))
        (substs
         (##map (lambda (i)
                  (let ((i-str (##fixnum->string i)))
                    (##cons i-str
                            (##string-append "___arg" i-str))))
                (##iota-fixnum (##length args-src) 1))))
    (##host-define-function-dynamic
     name
     (##map ##cdr substs)
     (##expand-inline-host-code expr substs))
    `(##host-function-call
      ,name
      (##vector ,@args-src))))

(define (##scmobj obj)
  (##inline-host-expression
   "@scm2scheme@(@1@)"
   obj))

;;;----------------------------------------------------------------------------

;; Convenience Scheme procedure to pass Scheme objects to JavaScript
;; without an automatic conversion.

(define (scheme scmobj)
  (##inline-host-expression
   "@scm2scheme@(@1@)"
   scmobj))

(cond-expand

 ((compilation-target js)
  (##inline-host-declaration "

// The following defines the 'foreign' JavaScript function which
// allows passing JavaScript objects to Scheme without an automatic
// conversion.

foreign = @host2foreign@;

"))

 ((compilation-target python)
  (##inline-host-declaration "

# The following defines the 'foreign' Python function which
# allows passing Python objects to Scheme without an automatic
# conversion.

foreign = @host2foreign@

"))

 (else))

(cond-expand

 ((compilation-target js)
  (##inline-host-declaration "

// Redefine ##check-heap-limit so that it checks interrupts (to allow
// preemptive thread scheduling and user interrupts in interpreted code).

@heartbeat_interval@ = 5000;
@heartbeat_count@ = @heartbeat_interval@;

@check_heap_limit0@ = function () {
  if (--@heartbeat_count@ === 0) {
    @heartbeat_count@ = @heartbeat_interval@;
    setTimeout(function () {
      @call_start@(@glo@['##heartbeat!'], [], @r0@);
    }, 10);
    return null; // exit trampoline
  } else {
    @r1@ = void 0;
    return @r0@;
  }
};

// Redefine @procedure2host@ to implement a bridge for JavaScript to
// Scheme calls.  When a Scheme procedure is converted to a
// JavaScript function using @procedure2host@, the JavaScript
// function will return a promise which eventually resolves to the
// result of the Scheme procedure (converted to JavaScript) or is
// rejected with an Error when the Scheme procedure raises an
// exception.

@procedure2host@ = function (proc_scm) {

  function fn() {
    var args = Array.prototype.slice.call(arguments);
    args.forEach(function (arg, i) { args[i] = @host2scm@(arg); });
    return @async_call@(true, // need result back
                        @current_processor@.@slots@[14], // in current thread
                        proc_scm,
                        args);
  }

  return fn;
};

@async_call@ = function (need_result, thread_scm, proc_scm, args_scm) {

  var promise = new Promise(function (resolve, reject) {

    function done(err, result) {
      if (err !== null) {
        reject(new Error(err));
      } else {
        resolve(@scm2host@(result));
      }
    };

    args_scm.unshift(proc_scm);               // procedure to call

    if (need_result) {
      args_scm.unshift(@function2scm@(done)); // Scheme callback for result
    } else {
      args_scm.unshift(@host2scm@(false));    // no result needed
      done(null, @host2scm@(void 0));         // cause #!void to be returned
    }

    args_scm.unshift(thread_scm);             // run in specific thread

    @callback_queue@.write(args_scm);
  });

  return promise;
};

// Patch continuation-next to properly undo dynamic binding environment.

@continuation_next@ = function (cont) {
  var frame = cont.@frame@;
  var denv = cont.@denv@;
  var ra = frame[0];
  var link = ra.@link@;
  var next_frame = frame[link];
  if (next_frame === void 0) {
    return @host2scm@(false);
  } else {
    if (ra === @peps@['##dynamic-env-bind'].@ctrlpts@[1]) {
      denv = frame[2];
    }
    return new @Continuation@(next_frame,denv);
  }
};

")

  ;; The ##scm2host-call-return procedure takes a JavaScript promise or value
  ;; as parameter.  If it is a value it returns the value.  If it is a
  ;; promise it blocks the execution of the current thread until the
  ;; promise is fulfilled or rejected.

  (define (##scm2host-call-return promise-or-value)
    (cond ((##not (##foreign? promise-or-value))
           promise-or-value)

          ((##inline-host-expression
            "@scm2host@(@1@) instanceof Promise" promise-or-value)

           (let ((result-mutex (macro-make-mutex 'scm2host-call-return)))

             ;; Setup mutex in locked state
             (macro-mutex-lock! result-mutex #f (macro-current-thread))

             ;; Add callback for when promise is settled
             (##inline-host-statement
              "
var promise = @scm2host@(@1@);
var callback = @2@;

function onFulfilled(value) {
  @async_call@(false, // no result needed
               false, // any thread
               callback,
               [@host2scm@([value])]);
}

function onRejected(reason) {
  @async_call@(false, // no result needed
               false, // any thread
               callback,
               [@host2scm@(reason.toString())]);
}

promise.then(onFulfilled, onRejected);
"
              promise-or-value
              (lambda (result) ;; callback
                (macro-mutex-specific-set! result-mutex result)
                ;; wake up waiting Scheme thread
                (macro-mutex-unlock! result-mutex)
                (##void)))

             ;; Wait for promise to be settled
             (macro-mutex-lock! result-mutex #f (macro-current-thread))
             (macro-mutex-unlock! result-mutex) ;; avoid space leak

             ;; Determine what happened
             (let ((msg (macro-mutex-specific result-mutex)))
               (if (##vector? msg)
                   (##vector-ref msg 0)
                   (##scm2host-call-error msg)))))

          (else
           (##inline-host-expression "@host2scm@(@scm2host@(@1@))" promise-or-value)))))

 ((compilation-target python)

  (define (##scm2host-call-return value)
    value))

 (else))

(define (##scm2host-call-error message)
  (##error message))

;;;----------------------------------------------------------------------------

;; The "callback loop" takes care of processing callbacks that
;; come from the JavaScript runtime system.

(define (##callback-loop)

  (define (exec callback)
    (let* ((nargs (##fx- (##vector-length callback) 3))
           (proc (##vector-ref callback 2)))
      (cond ((##fx= nargs 0)
             (proc))
            ((##fx= nargs 1)
             (proc (##vector-ref callback 3)))
            ((##fx= nargs 2)
             (proc (##vector-ref callback 3)
                   (##vector-ref callback 4)))
            ((##fx= nargs 3)
             (proc (##vector-ref callback 3)
                   (##vector-ref callback 4)
                   (##vector-ref callback 5)))
            (else
             (let loop ((i (##fx- (##vector-length callback) 1))
                        (args '()))
               (if (##fx>= i 3)
                   (loop (##fx- i 1)
                         (##cons (##vector-ref callback i) args))
                   (##apply proc args)))))))

  (define (handle callback)
    (if (##vector-ref callback 1) ;; response required?
        (##with-exception-catcher
         (lambda (exc)
           ;; send exception back to host
           ((##vector-ref callback 1)
            (##call-with-output-string
             (lambda (port)
               (##display-exception exc port)))
            (##void)))
         (lambda ()
           ;; send result back to host
           ((##vector-ref callback 1)
            (macro-absent-obj) ;; signal completion with no error
            (exec callback))))
        (exec callback)))

  (let* ((selector #f)
         (rdevice (##os-device-event-queue-open selector))
         (callback-queue (##make-event-queue-port rdevice selector)))
    (let loop ()
      (let* ((callback (##read callback-queue))
             (thread ;; handle callback in which thread?
              (or (##vector-ref callback 0)
                  (macro-current-thread))))
        (cond ((##eq? thread (macro-current-thread))
               ;; handle callback synchronously in callback-loop
               (handle callback))
              ((##eq? thread #t)
               ;; handle callback asynchronously by creating
               ;; a new thread just for this callback
               (##thread (lambda () (handle callback))))
              (else
               ;; handle callback asynchronously by interrupting
               ;; an existing thread
               (##thread-int! thread
                              (lambda ()
                                (handle callback)
                                (##void)))))
        (loop)))))

(define (##start-callback-loop-thread)
  (let* ((tgroup
          (##make-tgroup 'callback-loop #f))
         (callback-loop-thread
          (##make-root-thread
           ##callback-loop
           'callback-loop
           tgroup)))
    (##thread-start! callback-loop-thread)))

(##start-callback-loop-thread)

;;;----------------------------------------------------------------------------

(define (##heartbeat!)
  (##declare (not interrupts-enabled))
  (##thread-check-devices! #f)
  (##thread-heartbeat!))

(##hidden-continuation-parent?-set!
 (lambda (parent)
   (or (##eq? parent ##thread-check-devices!)
       (##eq? parent ##heartbeat!)
       (##eq? parent ##callback-loop)
       (##eq? parent ##start-callback-loop-thread)
       (##default-hidden-continuation-parent? parent))))

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
