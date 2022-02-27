//=============================================================================

// File: "UI.js"

// Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.

//=============================================================================

function UI(vm, elem) {

  var ui = this;

  if (!elem) {
    elem = document.createElement('div');
    document.body.appendChild(elem);
  } else if (typeof elem === 'string') {
    elem = document.querySelector(elem);
  }

  // Create console multiplexer

  var cons_mux_elem = document.createElement('div');
  cons_mux_elem.classList.add('g-console-multiplexer');
  cons_mux_elem.classList.add('g-pane-rigid');
  var cons_mux = new Multiplexer(cons_mux_elem, true);

  cons_mux.get_more_menu_items = function () {
    return ui.get_more_menu_items_console();
  }

  // cons_mux.tg.extra_elem().innerHTML = 'extra';

  // Create editor multiplexer

  var editor_mux_elem = document.createElement('div');
  editor_mux_elem.classList.add('g-editor-multiplexer');
  editor_mux_elem.classList.add('g-pane-elastic');
  var editor_mux = new Multiplexer(editor_mux_elem, true);

  editor_mux.get_more_menu_items = function () {
    return ui.get_more_menu_items_editor();
  }

  // Create splitter

  var splitter_elem = document.createElement('div');
  splitter_elem.classList.add('g-pane-splitter');

  // Initialize UI container

  elem.innerHTML = '';  // remove all children
  elem.appendChild(cons_mux_elem);
  elem.appendChild(splitter_elem);
  elem.appendChild(editor_mux_elem);
  elem.classList.add('g-h-panes');

  setup_splitter(elem);

  ui.vm = vm;
  ui.elem = elem;
  ui.cons_mux = cons_mux;
  ui.editor_mux = editor_mux;
  ui.demo_commands = [];
  ui.demo_index = 0;
  ui.demo_timeoutId = null;
  ui.debug = false;
  ui.fs = _os_fs;
  ui.root_dir = '';

  ui.init_predefined_files();
}

UI.prototype.new_repl = function () {

  var ui = this;

  if (ui.debug)
    console.log('UI().new_repl()');

  ui.vm.new_repl(ui);
};

UI.prototype.add_console = function (dev) {

  var ui = this;

  if (ui.debug)
    console.log('UI().add_console(...)');

  ui.cons_mux.add_channel(dev);

  if (ui.cons_mux.channels.length === 1 && !ui.file_exists('/nodemo')) {
    dev.vm.ui.demo([
      8,
      0, '(display "hello world!\\n")   ;; automatic demo... click console to cancel',
      2, '(display "hello world!\\n")   ;; automatic demo... click console to cancel\n',
      5, '(import (srfi 28))   ;; import SRFI 28\n',
      4, '(format "sqrt(2)=~a" (sqrt 2))\n',
      8, '(import (angle))     ;; import R7RS library from "angle/angle.sld"\n',
      4, '(map deg->rad \'(0 90 180 270 360))\n',
      8, '(import (roman))     ;; import R7RS library from "roman/roman.sld"\n',
      4, '(integer->roman 2048)\n',
      8, '(integer-sqrt (* 2 (expt 100 100)))   ;; bignums!\n',
      5, '(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))\n',
      5, '(time (fact 500))\n',
      8, null,
      0, '(define (tail n) (if (> n 0) (tail (- n 1)) \'done))   ;; proper tail calls\n',
      2, '(tail 100000)   ;; no stack overflows when tail calling!\n',
      5, '(define k #f)\n',
      2, '(* 1000 (call/cc (lambda (c) (set! k c) 42)))   ;; first class continuations',
      5, '(* 1000 (call/cc (lambda (c) (set! k c) 42)))   ;; first class continuations\n',
      2, '(k 123)   ;; multiple returns to continuations are possible',
      5, '(k 123)   ;; multiple returns to continuations are possible\n',
      8, null,
      0, '(begin (step) (+ 2 3))   ;; single step expression evaluation',
      2, '(begin (step) (+ 2 3))   ;; single step expression evaluation\n',
      2, ',s   ;; execute the first step, which reads the variable +\n',
      2, ',s   ;; execute the second step, which evaluates 2\n',
      2, ',s   ;; execute the third step, which evaluates 3\n',
      2, ',s   ;; execute the fourth step, which is the call to +\n',
      8, null,
      0, '(host-eval "Math.random()")  ;; interface to JavaScript code',
      2, '(host-eval "Math.random()")  ;; interface to JavaScript code\n',
      2, '(host-eval "[1+2*3, 1<2, Array(2*@1@).fill(0), (new Date).toString()]" 3)',
      2, '(host-eval "[1+2*3, 1<2, Array(2*@1@).fill(0), (new Date).toString()]" 3)\n',
      1, '(host-exec "console.log(@1@)" "this message will appear in the JavaScript console")',
      2, '(host-exec "console.log(@1@)" "this message will appear in the JavaScript console")\n',
      1, '(define prompt \\prompt)   ;; import JavaScript\'s prompt function using SIX',
      2, '(define prompt \\prompt)   ;; import JavaScript\'s prompt function using SIX\n',
      1, 'prompt',
      2, 'prompt\n',
      1, '(display (format "hello ~a!\\n" (prompt "your name please?")))',
      2, '(display (format "hello ~a!\\n" (prompt "your name please?")))\n',
      2, '(define (insert elem pos html) \\(`elem).insertAdjacentHTML(`pos, `html))\n',
      2, '(define (get id) \\document.getElementById(`id))\n',
      2, '(define (after id html) (insert (get id) "afterend" html))\n',
      2, '(define (end id html) (insert (get id) "beforeend" html))\n',
      2, '(after "ui" "<h1 id=\\"msg\\">Hello</h1>")\n',
      2,
      (ui.vm.os_web_origin.indexOf('://try.scheme.org/') > 0
       ? '(end "msg" " Schemers!")\n'
       : '(end "msg" " Gambit Schemers!")\n'),
      8, '\\document.getElementById("msg").innerHTML=""\n',
      1, null,
      0, '(current-directory)',
      1, '(current-directory)\n',
      2, '(directory-files)\n',
      2, '(with-output-to-file "hello" (lambda () (display "hello!\\n")))\n',
      2, '(directory-files)\n',
      2, '(read-file-string "hello")\n',
      4, '(initial-current-directory)  ;; initial CWD is the web server document root\n',
      4, '(define path (path-expand "UI.css" (initial-current-directory)))\n',
      1, 'path\n',
      4, '(substring (read-file-string path) 0 70)  ;; read file from web server\n',
      5, null,
      0, '(module-whitelist-add! "raw.githubusercontent.com/feeley")  ;; allow reading from github\n',
      2, '(println (read-file-string "https://raw.githubusercontent.com/feeley/fib/master/fib.scm"))  ;; get a file\n',
      8, '(load "https://raw.githubusercontent.com/feeley/fib/master/fib.scm")  ;; load it from github\n',
      8, '(module-search-order-add! "https://raw.githubusercontent.com/feeley/fib/master")\n',
      8, '(import (fib))  ;; do the same using the module system\n',
      8, null,
      '(define (create-thread id)   ;; SRFI 18 thread example\n',
      '    (thread-start!\n',
      '     (make-thread\n',
      '      (lambda ()\n',
      '        (after "ui" (string-append "<h3 id=\\"" id "\\">" id ":</h3>"))\n',
      '        (let loop ((i 1))\n',
      '          (end id (string-append " " (number->string i)))\n',
      '          (thread-sleep! (* 2 (square (random-real))))\n',
      '          (loop (+ i 1))))\n',
      '      id)))',
      2, '      id)))\n',
      5, '(define a (create-thread "a"))   ;; start a thread\n',
      8, '(define b (create-thread "b"))   ;; start another thread\n',
      5, ',st   ;; show state of threads\n',
      5, '(thread-interrupt! a)   ;; interrupt thread a and start a REPL for it\n',
      5, ',st   ;; in the REPL of the interrupted thread, type ",c" to continue it\n',
      5, '(help)   ;; press enter to get online help',
      ])
  }
};

UI.prototype.remove_console = function (dev) {

  var ui = this;

  if (ui.debug)
    console.log('UI().remove_console(...)');

  ui.cons_mux.remove_channel(dev);
};

UI.prototype.activate_console = function (dev) {

  var ui = this;

  if (ui.debug)
    console.log('UI().activate_console(...)');

  ui.cons_mux.activate_channel(dev);
};

UI.prototype.send_to_active_console = function (text, focus) {

  var ui = this;

  if (ui.debug)
    console.log('UI().send_to_active_console(\''+text+','+focus+'\')');

  var cons_mux = ui.cons_mux;
  var tab_index = cons_mux.tg.active_tab_index();

  if (tab_index >= 0) {
    var dev = cons_mux.tabs[tab_index];
    if (focus) {
      dev.focus();
    }
    dev.cons.send(text);
  }
};

UI.prototype.demo = function (commands) {

  var ui = this;

  function next() {
    if (ui.demo_index < 0 || ui.demo_index >= ui.demo_commands.length) {
      ui.demo_cancel();
    } else {

      var command = ui.demo_commands[ui.demo_index++];

      var delay = (typeof command === 'number') ? command*1000 : 10;
      ui.demo_timeoutId = setTimeout(next, delay);

      if (command === null || typeof command === 'string') {
        ui.send_to_active_console(command, false);
      }
    }
  }

  ui.cons_mux.elem.addEventListener('click', function (event) {
    ui.demo_cancel();
  });

  ui.cons_mux.elem.addEventListener('keypress', function (event) {
    ui.demo_cancel();
  });

  ui.demo_cancel();

  ui.demo_commands = commands;
  ui.demo_index = 0;

  next();
};

UI.prototype.demo_cancel = function () {

  var ui = this;

  if (ui.demo_timeoutId !== null) {
    clearTimeout(ui.demo_timeoutId);
    ui.demo_timeoutId = null;
  }

};

UI.prototype.get_more_menu_items_console = function () {

  var ui = this;
  var items = [];

  items.push(menu_item('New REPL', ['data-g-bold'], function (event) {
    ui.cons_mux.focus();
    ui.new_repl();
  }));

  items.push(document.createElement('hr'));

  ui.cons_mux.channels.forEach(function (channel) {
    var attrs = [];
    if (channel.needs_attention()) attrs.push('data-g-attention');
    items.push(menu_item(channel.get_title(), attrs, function (event) {
      ui.activate_console(channel);
    }));
  });

  return items;
};

UI.prototype.get_more_menu_items_editor = function () {

  var ui = this;
  var items = [];

  items.push(menu_item('New file', ['data-g-bold'], function (event) {
    ui.editor_mux.focus();
    ui.edit_new_file();
  }));

  items.push(document.createElement('hr'));

  var files = ui.all_files(ui.root_dir);

  files.sort();

  files.forEach(function (path) {
    items.push(menu_item(path, [], function (event) {
      ui.edit_file(path);
    }));
  });

  return items;
};

UI.prototype.get_unique_file_path = function (base) {

  var ui = this;
  var existing_files = ui.all_files(ui.root_dir);
  var path;
  var i = 0;

  do {
    path = base;
    if (i>0) path += i;
    path += '.scm';
    i++;
  } while (existing_files.indexOf(path) >= 0);

  return path;
};

UI.prototype.edit_new_file = function () {

  var ui = this;

  var path = ui.get_unique_file_path('untitled');
  var content = '';

  ui.write_file(path, content);

  ui.edit_file(path);
};

UI.prototype.edit_file = function (path) {

  var ui = this;

  var index = ui.editor_mux.index_of_channel_by_title(path);
  var editor;

  if (index >= 0) {

    // file is open in an editor tab (no need to create a new one)

    editor = ui.editor_mux.channels[index];

  } else {

    var editor_elem = document.createElement('div');
    editor = new Editor(editor_elem, ui, path);
    ui.editor_mux.add_channel(editor);

    var content = ui.read_file(path, null);

    if (content === null) {
      content = '';
      ui.write_file(path, content);
    }

    editor.replace_content(content);
    editor.set_dirty(false);
  }

  ui.editor_mux.activate_channel(editor);
};

UI.prototype.init_predefined_files = function () {

  var ui = this;

  ui.write_file('README', '\
The left area is the REPL where interaction \
with the interpreter takes place. The right \
area allows creating and editing files that are \
local to the browser and accessible to Scheme \
code as files in the root directory, i.e. "/". \
The files will persist in the browser between \
sessions.\n\
\n\
By default a demo will automatically start \
after a few seconds. The demo can be stopped \
by clicking or typing inside the REPL. The demo can also \
be disabled by creating the file "nodemo".\n\
\n\
The following keybindings are available:\n\
\n\
  Keybindings in REPL:\n\
    Enter   send the current line to the REPL\n\
    ^D      end-of-file when line is empty\n\
    ^C      interrupt execution\n\
    ^L      clear transcript\n\
    ^P/^N   move back/forward in history\n\
\n\
  Keybindings in editor:\n\
    ^S      save file\n\
    ^Enter  save file and load it in the REPL\n\
');

  ui.write_file('angle/angle.sld', '\
(define-library (angle)\n\
\n\
  (export deg->rad rad->deg)\n\
\n\
  (import (scheme base)\n\
          (scheme inexact))\n\
\n\
  (begin\n\
    (define factor (/ (atan 1) 45))\n\
    (define (deg->rad x) (* x factor))\n\
    (define (rad->deg x) (/ x factor))))\n\
');

  ui.write_file('roman/roman.sld', '\
(define-library (roman)\n\
  (export integer->roman roman->integer)\n\
  (import (scheme base))\n\
  (include "roman.scm"))\n\
');

  ui.write_file('roman/roman.scm', '\
(define (integer->roman n)\n\
\n\
  ;; n must be between 1 and 3999\n\
\n\
  (define (digit d1 d5 d10 power10)\n\
    (let ((d (modulo (quotient n power10) 10)))\n\
      (cond ((<= d 3)\n\
             (make-string d d1))\n\
            ((= d 4)\n\
             (string d1 d5))\n\
            ((<= d 8)\n\
             (string-append (string d5) (make-string (- d 5) d1)))\n\
            (else\n\
             (string d1 d10)))))\n\
\n\
  (string-append\n\
   (digit #\\M #\\_ #\\_ 1000)\n\
   (digit #\\C #\\D #\\M 100)\n\
   (digit #\\X #\\L #\\C 10)\n\
   (digit #\\I #\\V #\\X 1)))\n\
\n\
(define (roman->integer str)\n\
\n\
  (define pos 0)\n\
\n\
  (define (digit d1 d5 d10)\n\
    (let loop ((val 0))\n\
\n\
      (define (accept new-val)\n\
        (set! pos (+ pos 1))\n\
        (loop new-val))\n\
\n\
      (if (< pos (string-length str))\n\
          (let ((d (string-ref str pos)))\n\
            (cond ((char=? d d1)\n\
                   (if (<= (modulo val 5) 2)\n\
                       (accept (+ val 1))\n\
                       val))\n\
                  ((char=? d d5)\n\
                   (if (<= val 1)\n\
                       (accept (- 5 val))\n\
                       val))\n\
                  ((char=? d d10)\n\
                   (if (= val 1)\n\
                       (accept 9)\n\
                       val))\n\
                  (else\n\
                   val)))\n\
          val)))\n\
\n\
  (define d1000 (digit #\\M #\\_ #\\_))\n\
  (define d100  (digit #\\C #\\D #\\M))\n\
  (define d10   (digit #\\X #\\L #\\C))\n\
  (define d1    (digit #\\I #\\V #\\X))\n\
\n\
  (and (= pos (string-length str))\n\
       (> pos 0)\n\
       (+ (* 1000 d1000)\n\
          (* 100 d100)\n\
          (* 10 d10)\n\
          d1)))\n\
');

  ui.write_file('roman/demo/demo.sld', '\
(define-library (demo)\n\
\n\
  (import (.. roman) ;; relative reference to roman library\n\
          (scheme base)\n\
          (scheme write)\n\
          (only (srfi 1) iota))\n\
\n\
  (begin\n\
    (for-each (lambda (i)\n\
                (let ((n (expt 2 i)))\n\
                  (display n)\n\
                  (display " is ")\n\
                  (display (integer->roman n))\n\
                  (display " in roman numerals\\n")))\n\
              (iota 7))))\n\
');

  ui.write_file('roman/test/test.sld', '\
(define-library (test)\n\
\n\
  (import (.. roman) ;; relative reference to roman library\n\
          (srfi 64))\n\
\n\
  (begin\n\
\n\
    ;; test integer->roman\n\
\n\
    (test-equal "I"         (integer->roman 1))\n\
    (test-equal "XX"        (integer->roman 20))\n\
    (test-equal "CIV"       (integer->roman 104))\n\
    (test-equal "CCCLXXX"   (integer->roman 380))\n\
    (test-equal "MCMVII"    (integer->roman 1907))\n\
    (test-equal "MMMCMXCIX" (integer->roman 3999))\n\
\n\
    ;; test roman->integer\n\
\n\
    (test-equal 1    (roman->integer "I"))\n\
    (test-equal 20   (roman->integer "XX"))\n\
    (test-equal 104  (roman->integer "CIV"))\n\
    (test-equal 380  (roman->integer "CCCLXXX"))\n\
    (test-equal 1907 (roman->integer "MCMVII"))\n\
    (test-equal 3999 (roman->integer "MMMCMXCIX"))\n\
    (test-equal #f   (roman->integer "CIL"))\n\
    (test-equal #f   (roman->integer "Z"))\n\
    (test-equal #f   (roman->integer " I"))\n\
    (test-equal #f   (roman->integer "I "))\n\
    (test-equal #f   (roman->integer " I "))\n\
    (test-equal #f   (roman->integer " "))\n\
    (test-equal #f   (roman->integer ""))))\n\
');

  ui.edit_file('README');
};

UI.prototype.file_exists = function (path) {

  var ui = this;

  try {
    return ui.fs.existsSync(path);
  } catch (exn) {
    return false;
  }
};

UI.prototype.read_file = function (path, content) {

  var ui = this;

  try {
    content = ui.fs.readFileSync(path, { encoding: 'utf8', flag: 'r' });
  } catch (exn) {
    // ignore error
  }

  return content;
};

UI.prototype.write_file_possibly_editor = function (path, content) {

  var ui = this;

  ui.write_file(path, content);
};

UI.prototype.write_file = function (path, content) {

  var ui = this;

  var dir_sep = 0;

  for (;;) {

    var dir_sep = path.indexOf('/', dir_sep);

    if (dir_sep < 0) break;

    try {
      ui.fs.mkdirSync(path.slice(0, dir_sep));
    } catch (exn) {
      // ignore existing directory
    }

    dir_sep++;
  }

  try {
    ui.fs.writeFileSync(path, content, { encoding: 'utf8', flag: 'w' });
    return true;
  } catch (exn) {
    return false;
  }
};

UI.prototype.delete_file_possibly_editor = function (path) {

  var ui = this;

  var index = ui.editor_mux.index_of_channel_by_title(path);

  if (index >= 0) {

    // file is open in an editor tab (the editor must be deleted)

    var editor = ui.editor_mux.channels[index];

    ui.editor_mux.remove_channel(editor);
  }

  ui.delete_file(path);
};

UI.prototype.delete_file = function (path) {

  var ui = this;

  try {
    ui.fs.unlinkSync(path);
    return true;
  } catch (exn) {
    return false;
  }
};

UI.prototype.close_editor = function (path) {

  var ui = this;

  console.log('close_editor '+path);
};

UI.prototype.rename_file = function (path) {

  var ui = this;

  var new_path = prompt('New path for file ' + path);

  if (new_path !== null && new_path !== '') {
    ui.rename_file_possibly_editor(path, new_path);
  }
};

UI.prototype.rename_file_possibly_editor = function (src_path, dest_path) {

  var ui = this;

  var src_content = ui.read_file(src_path, null);

  if (src_content === null ||
      !ui.write_file(dest_path, src_content)) {
    return;
  }

  ui.delete_file(src_path);

  var src_index = ui.editor_mux.index_of_channel_by_title(src_path);
  var dest_index = ui.editor_mux.index_of_channel_by_title(dest_path);
  var dest_channel = (dest_index >= 0) ? ui.editor_mux.channels[dest_index] : null;

  if (src_index >= 0) {

    // source file is open in an editor tab

    var src_channel = ui.editor_mux.channels[src_index];

    ui.editor_mux.set_channel_title(src_channel, dest_path);

    if (dest_channel !== null) {

      // destination file is open in an editor tab, so remove it

      ui.editor_mux.remove_channel(dest_channel);
    }

  } else {

    // source file not open in an editor tab

    if (dest_channel !== null) {

      // destination file is open in an editor tab, so update its content

      dest_channel.replace_content(src_content);
    }
  }
};

UI.prototype.all_files = function (root_dir) {

  var ui = this;
  var files = [];

  function is_dir(path) {
    try {
      return ui.fs.statSync(path).isDirectory();
    } catch (exn) {
      return false;
    }
  }

  function walk_dir(relative_path) {
    var files_in_dir = [];
    try {
      files_in_dir = ui.fs.readdirSync(root_dir + relative_path);
    } catch (exn) {
      // ignore this dir
    }
    for (var i=0; i<files_in_dir.length; i++) {
      var name = files_in_dir[i];
      walk((relative_path==='' ? '' : relative_path+'/') + name);
    }
  }

  function walk(relative_path) {
    if (is_dir(root_dir + relative_path)) {
      walk_dir(relative_path);
    } else {
      files.push(relative_path);
    }
  }

  if (root_dir.slice(-1) !== '/') {
    root_dir += '/';
  }

  walk_dir('');

  return files;
};

//-----------------------------------------------------------------------------

function setup_splitter(container_elem, set_size) {

  function px(style, property) {
    return parseInt(style.getPropertyValue(property).slice(0, -2));
  }

  if (!container_elem) return;

  var rigid_elem = container_elem.querySelector(':scope > .g-pane-rigid');
  var elastic_elem = container_elem.querySelector(':scope > .g-pane-elastic');
  var splitter_elem = container_elem.querySelector(':scope > .g-pane-splitter');

  if (!(rigid_elem && elastic_elem && splitter_elem)) return;

  var rigid_pane_last = splitter_elem.nextElementSibling === rigid_elem;
  var container_style = window.getComputedStyle(container_elem);
  var rigid_style = window.getComputedStyle(rigid_elem);
  var elastic_style = window.getComputedStyle(elastic_elem);

  var vert = container_style.getPropertyValue('flex-direction') === 'column';
  var size_prop = vert ? 'height' : 'width';
  var size_min_prop = vert ? 'min-height' : 'min-width';

  var rigid_size_min = px(rigid_style, size_min_prop);
  var elastic_size_min = px(elastic_style, size_min_prop);

  var start_pos = null;
  var start_size = null;
  var current_size = null;

  //console.log(rigid_elem);
  //console.log(rigid_style.getPropertyValue('height'));

  rigid_elem.style.flexBasis = rigid_style.getPropertyValue(size_prop);

  function mouse_down(event) {
    start_pos = vert ? event.pageY : event.pageX;
    start_size = px(rigid_style, size_prop);
    current_size = start_size;
    document.body.addEventListener('mousemove', mouse_move);
    document.body.addEventListener('mouseup', mouse_end);
    event.preventDefault();
  }

  function mouse_move(event) {
    if (event.buttons && start_pos !== null) {
      var elasticSize = px(elastic_style, size_prop);
      var pos = vert ? event.pageY : event.pageX;
      var dist = pos - start_pos;
      if (rigid_pane_last) dist = -dist;
      var delta = Math.min(dist - (current_size - start_size),
                           elasticSize - elastic_size_min);
      var size = Math.max(rigid_size_min, delta + current_size);
      //console.log(elasticSize, pos, dist, delta, size);
      rigid_elem.style.flexBasis = size + 'px';
      if (set_size) set_size(size);
      current_size = size;
    } else {
      mouse_end();
    }
    event.preventDefault();
  }

  function mouse_end(event) {
    start_pos = null;
    document.body.removeEventListener('mouseup', mouse_end);
    splitter_elem.removeEventListener('mousemove', mouse_move);
  }

  splitter_elem.addEventListener('mousedown', mouse_down);
}

//-----------------------------------------------------------------------------

function Multiplexer(elem, has_more_tab) {

  var mux = this;

  mux.elem = elem;
  mux.has_more_tab = has_more_tab;
  elem.classList.add('g-multiplexer');
  mux.init();
}

Multiplexer.prototype.init = function () {

  var mux = this;

  mux.channels = [];  // array of channels
  mux.tabs = [];      // array of channels (in tab order)
  mux.mra = [];       // most recently active tabs
  mux.max_nb_tabs = 999999;
  mux.debug = false;

  mux.get_more_menu_items = function () { return []; };

  var tg = new Tab_group(mux.elem);

  mux.tg = tg;

  tg.clicked_tab = function (index, event) { mux.clicked_tab(index, event); };

  if (mux.has_more_tab) {
    tg.add_pane('+');
  }
};

Multiplexer.prototype.max_nb_tabs_set = function (max_nb_tabs) {

  var mux = this;

  mux.max_nb_tabs = max_nb_tabs;
};

Multiplexer.prototype.focus = function () {

  var mux = this;

  if (mux.debug)
    console.log('Multiplexer().focus()');

  var tab_index = mux.tg.active_tab_index();

  if (tab_index >= 0) {
    mux.tabs[tab_index].focus();
  }
};

Multiplexer.prototype.clicked_tab = function (tab_index, event) {

  var mux = this;

  function hide_menu(elem) {
    elem.removeAttribute('data-g-dropdown-menu-show');
    while (elem.childNodes.length > 1) {
      elem.removeChild(elem.lastChild);
    }
    mux.focus();
  }

  function is_visible(elem) {
    return !!elem && !!(elem.offsetWidth || elem.offsetHeight || elem.getClientRects().length);
  }

  function hide_menu_on_click_outside(elem) {

    function outside_click_listener(event) {
      if (!elem.contains(event.target) && is_visible(elem)) {
        hide_menu(elem);
        remove_click_listener()
      }
    }

    function remove_click_listener() {
      document.removeEventListener('click', outside_click_listener)
    }

    document.addEventListener('click', outside_click_listener)
  }

  function add_menu(elem, items) {

    if (items.length === 0) return;

    var menu = document.createElement('div');
    menu.classList.add('g-dropdown-menu');

    items.forEach(function (item) {
      menu.appendChild(item);
    });

    var wrapper = document.createElement('div');
    wrapper.appendChild(menu);
    elem.appendChild(wrapper);

    elem.setAttribute('data-g-dropdown-menu-show', '');
    hide_menu_on_click_outside(elem);
  };

  var tg = mux.tg;
  var elem = tg.tab_elem(tab_index);

  if (elem.childNodes.length > 1) {

    // clicked on a tab who's menu was showing so hide the menu

    hide_menu(elem);

  } else {
    if (mux.has_more_tab && tab_index === tg.nb_tabs()-1) {

      // clicked on the '+' tab so show the list of available channels

      add_menu(elem, mux.get_more_menu_items());

    } else if (tab_index === tg.active_tab_index()) {

      // clicked on the tab of the channel that is currently active so
      // show menu specific to that channel

      add_menu(elem, mux.channels[tab_index].get_menu_items());

    } else {

      // clicked on the tab of a channel that is not currently active
      // tab so activate that channel

      mux.activate_channel(mux.channels[tab_index]);
    }
  }
};

Multiplexer.prototype.shrink_nb_tabs = function (n) {

  var mux = this;

  while (mux.tabs.length > n) {
    mux.remove_channel(mux.tabs[mux.mra[mux.tabs.length-1]]);
  }
};

Multiplexer.prototype.set_channel_title = function (channel, title) {

  var mux = this;

  if (mux.debug)
    console.log('Multiplexer().set_channel_title('+channel.get_title()+', '+title+')');

  var tab_index = mux.tab_index_of_channel(channel);

  if (tab_index >= 0) {
    if (channel.set_title(title)) {
      mux.tg.set_tab_name(tab_index, title);
    }
  }
};

Multiplexer.prototype.add_channel = function (channel, become_active) {

  var mux = this;

  if (mux.debug)
    console.log('Multiplexer().add_channel('+channel.get_title()+', '+become_active+')');

  var title = channel.get_title();
  var index = mux.channels.length; // add to end of channels

  mux.channels.splice(index, 0, channel);

  if (mux.tabs.length === 0) become_active = true;

  var tg = mux.tg;

  if (become_active || mux.tabs.length < mux.max_nb_tabs) {

    mux.shrink_nb_tabs(mux.max_nb_tabs-1);
    mux.tabs.push(channel);
    var tab_index = mux.tabs.length-1;
    i = tg.add_pane(title, channel.get_elem(), mux.has_more_tab ? -2 : -1);
    if (become_active) {
      mux.mra.splice(0, 0, tab_index); ///////????????????????
      tg.active_tab_set(tab_index);
    } else {
      mux.mra.push(tab_index);
    }

  } else {
    tg.add_pane(null, channel.get_elem());
  }

  if (become_active) {
    mux.activate_channel(channel);
    channel.focus();
  }

  if (mux.debug) {
    console.log('mux.mra and mux.tabs:');
    console.log(mux.mra);
    console.log(mux.tabs);
    console.log(mux.channels);
  }
};

Multiplexer.prototype.remove_channel = function (channel) {

  var mux = this;

  if (mux.debug)
    console.log('Multiplexer().remove_channel('+channel.get_title()+')');

  var keep_pane = channel.preserve_elem();

  if (!keep_pane) {
    var index = mux.index_of_channel(channel);
    if (index >= 0) mux.channels.splice(index, 1);
  }

  var tab_index = mux.tab_index_of_channel(channel);

  if (tab_index >= 0) {
    var tabs = mux.tabs;
    var mra = mux.mra;
    tabs.splice(tab_index, 1);
    for (;;) {
      var i = mra.indexOf(tab_index);
      if (i < 0) break;
      mra.splice(i, 1);
    }
    for (var j=0; j<mra.length; j++) {
      if (mra[j] > tab_index) mra[j]--;
    }

    mux.tg.remove_tab(tab_index, keep_pane);
    if (mux.tg.active_tab_index() > tab_index)
      mux.tg.act_tab_index--;
    else if (mux.tg.active_tab_index() === tab_index) {
      mux.tg.act_tab_index = -1;
      if (tabs.length > 0) {
        mux.activate_channel(tabs[mra[0]]);
      } else {
        mux.tg.deactivate(tab_index);
      }
    }
  }

  if (mux.debug) {
    console.log('mux.mra and mux.tabs:');
    console.log(mux.mra);
    console.log(mux.tabs);
    console.log(mux.channels);
  }
};

Multiplexer.prototype.activate_channel = function (channel) {

  var mux = this;

  if (mux.debug)
    console.log('Multiplexer().activate_channel('+channel.get_title()+')');

  var tab_index = mux.tab_index_of_channel(channel);
  var tg = mux.tg;

  if (tab_index !== tg.active_tab_index()) {

    var mra = mux.mra;

    if (tab_index >= 0) {
      mra.splice(mra.indexOf(tab_index), 1);
    } else {
      tab_index = tg.add_pane(channel.get_title(), channel.get_elem(), mux.has_more_tab ? -2 : -1);
      mux.tabs.splice(tab_index, 0, channel);
    }

    mra.splice(0, 0, tab_index);
    tg.active_tab_set(tab_index);
    channel.focus();
  }

  if (mux.debug) {
    console.log('mux.mra and mux.tabs:');
    console.log(mux.mra);
    console.log(mux.tabs);
    console.log(mux.channels);
  }
};

Multiplexer.prototype.index_of_channel = function (channel) {

  var mux = this;
  var channels = mux.channels;
  var index = 0;

  while (index < channels.length) {
    if (channel === channels[index]) return index;
    index++;
  }

  return -1;
};

Multiplexer.prototype.tab_index_of_channel = function (channel) {

  var mux = this;
  var tabs = mux.tabs;
  var tab_index = 0;

  while (tab_index < tabs.length) {
    if (channel === tabs[tab_index]) return tab_index;
    tab_index++;
  }

  return -1;
};

Multiplexer.prototype.index_of_channel_by_title = function (title) {

  var mux = this;
  var channels = mux.channels;
  var index = 0;

  while (index < channels.length) {
    if (title === channels[index].get_title()) return index;
    index++;
  }

  return -1;
};

//-----------------------------------------------------------------------------

function Tab_group(elem) {

  var tg = this;

  tg.elem = elem;
  elem.classList.add('g-tab-group');
  tg.init();
}

Tab_group.prototype.init = function () {

  var tg = this;

  tg.clear();

  tg.act_tab_index = -1; // no tab is active

  tg.clicked_tab = function (index, event) { };

  var tabs_elem = document.createElement('ul');
  tg.elem.appendChild(tabs_elem);

  var panes_elem = document.createElement('div');
  tg.elem.appendChild(panes_elem);

  var extra_elem = document.createElement('li');
  extra_elem.appendChild(document.createElement('div'));
  tabs_elem.appendChild(extra_elem);
};

Tab_group.prototype.clear = function () {
  var tg = this;
  tg.elem.innerHTML = ''; // remove all children
  tg.tab_names = [];
};

Tab_group.prototype.index_of_tab = function (name) {
  var tg = this;
  return tg.tab_names.indexOf(name);
};

Tab_group.prototype.index_of_tab_elem = function (elem) {
  var tg = this;
  for (var i=tg.nb_tabs()-1; i>=0; i--) {
    if (elem === tg.tab_elem(i))
      return i;
  }
  return -1;
};

Tab_group.prototype.tab_elem = function (tab_index) {
  var tg = this;
  return tg.elem.firstChild.children[tab_index];
};

Tab_group.prototype.pane_elem = function (tab_index) {
  var tg = this;
  return tg.elem.lastChild.children[tab_index];
};

Tab_group.prototype.extra_elem = function () {
  var tg = this;
  return tg.elem.firstChild.lastChild;
};

Tab_group.prototype.set_tab_name = function (tab_index, name) {
  var tg = this;
  var tabs_elem = tg.elem.firstChild;
  tabs_elem.children[tab_index].firstChild.firstChild.innerText = name;
  tg.tab_names[tab_index] = name;
};

Tab_group.prototype.remove_tab = function (tab_index, keep_pane) {

  var tg = this;

  var tabs_elem = tg.elem.firstChild;
  var panes_elem = tg.elem.lastChild;

  tabs_elem.children[tab_index].remove();

  var pane_elem = panes_elem.children[tab_index];
  pane_elem.remove();
  if (keep_pane)
    panes_elem.appendChild(pane_elem);

  tg.tab_names.splice(tab_index, 1);
};

Tab_group.prototype.add_pane = function (tab_name, pane_elem, tab_index) {

  var tg = this;

  var panes_elem = tg.elem.lastChild;

  if (tab_name === null) {

    tab_index = panes_elem.children.length;

  } else {

    var tab_elem = document.createElement('li');
    var elem1 = document.createElement('div');
    var elem2 = document.createElement('div');
    var n = tg.nb_tabs();

    elem2.innerText = tab_name;
    elem1.appendChild(elem2);
    tab_elem.appendChild(elem1);

    if (typeof tab_index === 'undefined') tab_index = -1;

    if (tab_index < 0) tab_index = Math.max(0, n+tab_index+1);

    var tabs_elem = tg.elem.firstChild;

    if (tab_index <= n) {
      tabs_elem.insertBefore(tab_elem, tabs_elem.children[tab_index]);
    }

    if (tab_index < n) {
      tg.tab_names.splice(tab_index, 0, tab_name);
    } else {
      tg.tab_names.push(tab_name);
    }

    function click(event) {
      var tab_index = tg.index_of_tab_elem(tab_elem);
      if (tab_index >= 0) tg.clicked_tab(tab_index, event);
    }

    tab_elem.addEventListener('click', click);
  }

  if (typeof pane_elem === 'undefined')
    pane_elem = document.createElement('div');

  if (tab_index < panes_elem.children.length) {
    panes_elem.insertBefore(pane_elem, panes_elem.children[tab_index]);
  } else {
    panes_elem.appendChild(pane_elem);
  }

  return tab_index;
};

Tab_group.prototype.nb_tabs = function () {
  var tg = this;
  return tg.tab_names.length;
};

Tab_group.prototype.active_tab_index = function () {
  var tg = this;
  return tg.act_tab_index;
};

Tab_group.prototype.deactivate = function (tab_index) {

  var tg = this;

  var tab_elem = tg.elem.firstChild.querySelector(':scope > li[data-g-active]');
  if (tab_elem) tab_elem.removeAttribute('data-g-active');

  var pane_elem = tg.elem.lastChild.querySelector(':scope > div[data-g-active]');
  if (pane_elem) pane_elem.removeAttribute('data-g-active');
};

Tab_group.prototype.active_tab_set = function (tab_index) {

  var tg = this;

  tg.deactivate(tab_index);

  if (tab_index >= 0) {
    tg.tab_elem(tab_index).setAttribute('data-g-active', '');
    tg.pane_elem(tab_index).setAttribute('data-g-active', '');
    tg.act_tab_index = tab_index;
  } else {
    tg.act_tab_index = -1;
  }
};

//-----------------------------------------------------------------------------

function Device_console(vm, title, flags, ui, thread_scm) {

  var dev = this;

  if (!ui) ui = vm.ui;

  dev.vm = vm;
  dev.ui = ui;
  dev.title = title;
  dev.flags = flags;
  dev.wbuf = new Uint8Array(0);
  dev.rbuf = new Uint8Array(1);
  dev.rlo = 1;
  dev.encoder = new TextEncoder();
  dev.decoder = new TextDecoder();
  dev.echo = true;
  dev.read_condvar_scm = null;
  dev.delayed_output = '';

  dev.focused = false;
  dev.dirty = false;

  dev.thread_scm = thread_scm;
  dev.elem = document.createElement('div');
  dev.cons = new Console(dev.elem);

  dev.debug = false;

  dev.cons.connect(dev);

  ui.add_console(dev);
}

Device_console.prototype.console_completions = function (input, cursor) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').console_completions(...)');

  return dev.vm.completions(dev.thread_scm, input, cursor);
};

Device_console.prototype.console_writable = function (cons) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').console_writable(...)');

  dev.cons = cons;
  cons.write(dev.delayed_output);
  dev.delayed_output = '';
};

Device_console.prototype.console_readable = function (cons) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').console_readable(...)');

  dev.cons = cons;
  var input = cons.read();
  var condvar_scm = dev.read_condvar_scm;
  if (condvar_scm !== null) {
    if (input === null) {
      dev.rbuf = new Uint8Array(0);
    } else {
      dev.rbuf = dev.encoder.encode(input);
    }
    dev.rlo = 0;
    dev.read_condvar_scm = null;
    dev.vm.os_condvar_ready_set(condvar_scm, true);
  }
};

Device_console.prototype.console_user_interrupt_thread = function (cons) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').console_user_interrupt_thread(...)');

  dev.cons = cons;

  dev.vm.user_interrupt_thread(dev.thread_scm);
};

Device_console.prototype.console_terminate_thread = function (cons) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').console_terminate_thread(...)');

  dev.cons = cons;

  dev.vm.terminate_thread(dev.thread_scm);
};

Device_console.prototype.activate = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').activate()');

  if (dev.ui !== null) dev.ui.activate_console(dev);
};

Device_console.prototype.input_add = function (input, prevent_echo) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').input_add(\''+input+'\')');

  var len = dev.rbuf.length-dev.rlo;
  var inp = dev.encoder.encode(input);
  if (!prevent_echo && dev.echo) dev.output_add_buffer(inp); // echo the input
  var newbuf = new Uint8Array(len + inp.length + 1);
  newbuf.set(newbuf.subarray(dev.rlo, dev.rlo+len), 1);
  newbuf.set(inp, len+1);
  dev.rbuf = newbuf;
  dev.rlo = 1;
};

Device_console.prototype.output_add = function (output) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').output_add(\''+output+'\')');

  dev.output_add_buffer(dev.encoder.encode(output));
};

Device_console.prototype.output_add_buffer = function (buffer) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').output_add_buffer(...)');

  var len = dev.wbuf.length;
  var newbuf = new Uint8Array(len + buffer.length);
  newbuf.set(dev.wbuf);
  newbuf.set(buffer, len);
  dev.wbuf = newbuf;

  var output = dev.decoder.decode(dev.wbuf);
  if (dev.cons === null) {
    dev.delayed_output += output;
  } else {
    dev.cons.write(dev.delayed_output + output);
    dev.delayed_output = '';
  }
  dev.wbuf = new Uint8Array(0);
};

Device_console.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  var n;
  var have;

  while (true) {

    n = hi-lo;
    have = dev.rbuf.length-dev.rlo;

    if (have > 0) break;

    if (dev.cons.has_unprocessed_input()) {

      var input = dev.cons.read();

      if (input !== null) {
        dev.input_add(input, true);
      }

      // will continue loop to check availability again

    } else if (dev.rlo === 0) {

      dev.rbuf = new Uint8Array(1); // prevent repeated EOF
      dev.rlo = 1;
      return 0; // signal EOF

    } else {

      dev.vm.os_condvar_ready_set(dev_condvar_scm, false);

      // Input will be received asynchronously

      if (dev.read_condvar_scm === null) {
        dev.read_condvar_scm = dev_condvar_scm;
      }

      return -35; // return EAGAIN to suspend Scheme thread on condvar
    }
  }

  // some bytes are available to read

  if (n > have) n = have;

  buffer.set(dev.rbuf.subarray(dev.rlo, dev.rlo+n), lo);

  dev.rlo += n;

  return n; // number of bytes transferred
};

Device_console.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  dev.output_add_buffer(buffer.subarray(lo, hi));

  return hi-lo;
};

Device_console.prototype.force_output = function (dev_condvar_scm, level) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').force_output(...,'+level+')');

  return 0; // no error
};

Device_console.prototype.seek = function (dev_condvar_scm, pos, whence) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').seek(...,'+pos+','+whence+')');

  return -1; // EPERM (operation not permitted)
};

Device_console.prototype.width = function (dev_condvar_scm) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').width()');

  var cm = dev.cons.cm;
  var charWidth = cm.defaultCharWidth();
  var scrollInfo = cm.getScrollInfo();
  var width = Math.floor(scrollInfo.clientWidth / charWidth) - 1;

  if (width < 20) width = 20;

  return width;
};

Device_console.prototype.close = function (direction) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').close('+direction+')');

  return 0; // no error
};

Device_console.prototype.get_title = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').get_title()');

  return dev.title;
};

Device_console.prototype.set_title = function (title) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').set_title('+title+')');

  return false; // can't set title
};

Device_console.prototype.needs_attention = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').needs_attention()');

  return !dev.focused && dev.dirty;
};

Device_console.prototype.focus = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').focus()');

  dev.focused = true;
  dev.cons.focus();
};

Device_console.prototype.blur = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').blur()');

  dev.focused = false;
  dev.dirty = false;
  dev.cons.blur();
};

Device_console.prototype.get_menu_items = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').get_menu_items()');

  var items = [];

//  items.push(menu_item('Close tab', [], function (event) {
//    console.log('close tab ' + dev.title);
//    dev.vm.ui.remove_console(dev);
//  }));

  items.push(menu_item('Interrupt thread', ['data-g-bold'], function (event) {
    dev.cons.user_interrupt();
  }));

  if (dev.title !== '#<thread #1 primordial>') {
    items.push(menu_item('Terminate thread', ['data-g-bold'], function (event) {
      dev.cons.terminate_thread();
    }));
  }

  return items;
};

Device_console.prototype.get_elem = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').get_elem()');

  return dev.elem;
};

Device_console.prototype.preserve_elem = function () {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').preserve_elem()');

  return true;
};

function menu_item(title, attrs, handler) {
  var item = document.createElement('div');
  item.innerText = title;
  attrs.forEach(function (attr) {
    item.setAttribute(attr, '');
  });
  if (handler) {
    item.setAttribute('data-g-dropdown-menu-selectable', '');
  }
  item.addEventListener('click', handler);
  return item;
}

//-----------------------------------------------------------------------------

function Console(elem) {

  var cons = this;

  var cm_opts = {
    value: '',
    matchBrackets: true,
    mode: 'scheme',
    keyMap: 'emacs',
    autofocus: true,
    lineWrapping: true,
    extraKeys: {
      'Ctrl-C': function (cm) { cons.user_interrupt(); },
      'Ctrl-D': function (cm) { cons.delete_forward(); },
      'Ctrl-L': function (cm) { cons.clear_transcript(); },
      'Up':     function (cm) { cons.move_history(true); },
      'Ctrl-P': function (cm) { cons.move_history(true); },
      'Down':   function (cm) { cons.move_history(false); },
      'Ctrl-N': function (cm) { cons.move_history(false); },
      'Enter':  function (cm) { cons.enter(true); },
      'Tab':    function (cm) { cons.tab(); }
    }
  };

  elem.classList.add('g-console');
  cons.cm = CodeMirror(elem, cm_opts);
  cons.id = elem.id || 'DefaultConsole';
  cons.doc = cons.cm.getDoc();
  cons.transcript_marker = null;
  cons.internal_op = false;
  cons.completions = [];
  cons.completions_pos = 0;
  cons.input_buffer = [];
  cons.delayed_input = [];
  cons.allow_multiline_input = false;
  cons.eof = false;
  cons.peer = null;
  cons.history_max_length = 1000;
  cons.restore_history();

  cons.cm.on('beforeSelectionChange', function(cm, event) {

    // prevent user moving cursor to transcript unless it is for
    // selecting text

    if (!cons.internal_op) {

      var change = false;
      var ranges = [];
      var soi = cons.start_of_input();

      for (var i=0; i<event.ranges.length; i++) {

        var r = event.ranges[i];
        var lo = r.head;
        var hi = r.anchor;

        if (cons.cmp_pos(lo, hi) > 0) {
          var t = lo;
          lo = hi;
          hi = t;
        }

        if (cons.cmp_pos(lo, hi) === 0 && // zero length selection in transcript
            cons.cmp_pos(lo, soi) < 0) {
          ranges.push({ head: soi, anchor: soi });
          change = true;
        } else if (cons.cmp_pos(lo, soi) < 0 && // selection that crosses soi
                   cons.cmp_pos(hi, soi) >= 0 &&
                   (event.origin === '+move' ||
                    (lo.sticky === null &&
                     hi.sticky === null))) {
          if (cons.cmp_pos(r.head, r.anchor) < 0) {
            ranges.push({ head: soi, anchor: r.anchor });
          } else {
            ranges.push({ head: r.head, anchor: soi });
          }
          change = true;
        } else {
          ranges.push(r);
        }
      }

      if (change) {
        event.update(ranges);
      }

      cons.completions.length = 0;
    }
  });

  cons.cm.on('beforeChange', function(cm, event) {

    // redirect any changes to the transcript to the current input

    if (!cons.internal_op) {

      var from = event.from;
      var to = event.to;
      var soi = cons.start_of_input();

      if (cons.transcript_marker &&
          cons.transcript_marker.readOnly &&
          cons.cmp_pos(from, soi) < 0) {
        cons.cm.setSelection(soi);
        event.update(soi, cons.cmp_pos(to, soi) >= 0 ? to : soi, event.text);
      }
    }
  });

  cons.cm.on('change', function(cm, event) {

    // break multiline input into individual lines

    if (!cons.internal_op && !cons.allow_multiline_input) {
      var notify = (event.origin === '+input' || event.origin === 'paste');
      cons.add_current_input('', false, notify);
    }
  });

  cons.ro = new ResizeObserver(function (entries) {
    cons.refresh();
  });

  cons.ro.observe(elem);
}

Console.prototype.transcript_opts = {
  className: 'g-console-transcript',
  inclusiveLeft: true,
  inclusiveRight: false,
  readOnly: true,
  selectLeft: false
};

Console.prototype.input_opts = {
  className: 'g-console-input',
  inclusiveLeft: true,
  inclusiveRight: false
};

Console.prototype.output_opts = {
  className: 'g-console-output',
  inclusiveLeft: true,
  inclusiveRight: false
};

Console.prototype.line0ch0 = CodeMirror.Pos(0, 0);
Console.prototype.line0ch1 = CodeMirror.Pos(0, 1);

Console.prototype.end_of_doc = function () {
  var cons = this;
  return cons.doc.posFromIndex(Infinity);
};

Console.prototype.cmp_pos = function (a, b) {
  return a.line - b.line || a.ch - b.ch;
};

Console.prototype.start_of_input = function (clear_marker) {

  var cons = this;
  var start;

  if (cons.transcript_marker) {
    var transcript_range = cons.transcript_marker.find();
    if (transcript_range) {
      start = cons.transcript_marker.find().to;
    } else {
      start = cons.line0ch0;
    }
    if (clear_marker) {
      cons.transcript_marker.clear();
      cons.transcript_marker = null;
    }
  } else {
    start = cons.line0ch0;
  }

  return start;
};

Console.prototype.read = function () {

  var cons = this;

  if (cons.input_buffer.length > 0) {
    return cons.input_buffer.shift();
  } else {
    var delayed_input = cons.delayed_input;
    if (delayed_input.length > 0) {
      var soi = cons.start_of_input();
      var end = cons.end_of_doc();
      var first = delayed_input.shift();
      cons.replace_range(first, soi, end);
      if (delayed_input.length > 0) {
        cons.enter(false); // add to history and input buffer, but no notify
        return cons.input_buffer.shift();
      } else {
        return '';
      }
    }
    return null;
  }
};

Console.prototype.add_current_input = function (text, replace, notify) {

  var cons = this;
  var soi = cons.start_of_input();
  var end = cons.end_of_doc();
  var current_input = cons.doc.getRange(soi, end);
  var new_input = replace ? text : current_input+text;

  if (!cons.allow_multiline_input) {

    var lines = new_input.split('\n');
    var delayed_input = cons.delayed_input;

    if (delayed_input.length === 0) {
      delayed_input = lines;
    } else {
      var last = delayed_input[delayed_input.length-1];
      delayed_input = delayed_input.slice(0,-1).concat([last+lines[0]],lines.slice(1));
    }

    cons.delayed_input = delayed_input;

    new_input = delayed_input.shift();
  }

  if (current_input !== new_input) {
    cons.replace_range(new_input, soi, end);
  }

  if (cons.allow_multiline_input || delayed_input.length === 0) {
    return false;
  } else {
    cons.enter(notify);
    return true;
  }
};

Console.prototype.replace_range = function (text, from, to) {

  var cons = this;
  var save = cons.internal_op;

  cons.internal_op = true;
  cons.doc.replaceRange(text, from, to);
  cons.internal_op = save;
};

Console.prototype.write = function (text) {

  var cons = this;

  if (text.length > 0) {

    var insert_marker;
    var soi = cons.start_of_input(true);

    cons.replace_range('_', soi, soi);

    var right_of_soi = CodeMirror.Pos(soi.line, soi.ch+1);
    var insert_marker = cons.doc.markText(soi,
                                          right_of_soi,
                                          cons.output_opts);

    cons.replace_range(text, soi, soi);

    pos = insert_marker.find().to;
    var left_of_pos = CodeMirror.Pos(pos.line, pos.ch-1);
    cons.replace_range('', left_of_pos, pos);
    cons.transcript_marker = cons.doc.markText(cons.line0ch0,
                                               left_of_pos,
                                               cons.transcript_opts);

    cons.cm.scrollIntoView(null); // scroll cursor into view
  }
};

Console.prototype.accept_input = function () {

  var cons = this;
  var soi = cons.start_of_input(true);
  var end = cons.end_of_doc();
  var input = cons.doc.getRange(soi, end);

  if (end.line > 0 || end.ch > 0) {

    cons.doc.markText(soi, end, cons.input_opts);

    cons.transcript_marker = cons.doc.markText(cons.line0ch0,
                                               end,
                                               cons.transcript_opts);
  }

  cons.write('\n');

  cons.doc.setSelection(end);

  return input;
};

Console.prototype.clear_transcript = function () {

  var cons = this;

  if (cons.transcript_marker) {
    var soi = cons.start_of_input();
    if (soi.line > 0) {
      var bol = CodeMirror.Pos(soi.line, 0);
      var save = cons.transcript_marker.readOnly;
      cons.transcript_marker.readOnly = false;
      cons.replace_range('', cons.line0ch0, bol);
      cons.transcript_marker.readOnly = save;
      if (soi.ch === 0) {
        cons.transcript_marker.clear();
        cons.transcript_marker = null;
      }
    }
  }
};

Console.prototype.delete_forward = function () {

  var cons = this;
  var soi = cons.start_of_input();
  var end = cons.end_of_doc();

  if (cons.cmp_pos(soi, end) === 0) {
    cons.add_buffered_input('', true); // signal EOF with notify
  } else {
    cons.cm.execCommand('delCharAfter');
  }
};

Console.prototype.enter = function (notify) {

  var cons = this;
  var input = cons.accept_input();

  if (input.length > 0) {
    cons.history[cons.history.length-1] = input;
    cons.save_history();
  }

  cons.restore_history();

  cons.add_buffered_input(input + '\n', notify);
};

Console.prototype.add_buffered_input = function (text, notify) {
  var cons = this;
  cons.input_buffer.push(text);
  if (notify) {
    cons.readable();
  }
};

Console.prototype.tab = function () {

  var cons = this;

  var from = cons.doc.getCursor('from');
  var to = cons.doc.getCursor('to');
  var soi = cons.start_of_input();

  if (cons.cmp_pos(from, soi) >= 0) {
    if (cons.cmp_pos(from, to) === 0) {

      // zero length selection inside current input

      if (cons.completions.length === 0 && cons.peer) { // get new completions?
        var cursor = cons.doc.indexFromPos(from) - cons.doc.indexFromPos(soi);
        var end = cons.end_of_doc();
        var input = cons.doc.getRange(soi, end);
        cons.completions = cons.peer.console_completions(input, cursor);
        cons.completions_pos = 0;
      }

      if (cons.completions.length > 0) { // are there completions possible?

        var old_len = cons.completions[cons.completions_pos].length;
        var pos = (cons.completions_pos+1) % cons.completions.length;
        var new_text = cons.completions[pos];
        var new_len = new_text.length;

        cons.completions_pos = pos;

        var new_from = CodeMirror.Pos(from.line, Math.max(0, from.ch-old_len));

        if (cons.cmp_pos(new_from, soi) < 0) {
          new_from.line = soi.line;
          new_from.ch = soi.ch;
        }

        cons.replace_range(new_text, new_from, CodeMirror.Pos(to.line, to.ch));

      } else {

        cons.cm.execCommand('indentAuto');

      }
    }
  }
};

Console.prototype.connect = function (peer) {
  var cons = this;
  cons.peer = peer;
  cons.writable();
  if (cons.has_unprocessed_input()) {
    cons.readable();
  }
};

Console.prototype.has_unprocessed_input = function () {
  var cons = this;
  return cons.input_buffer.length > 0 || cons.delayed_input.length > 0;
};

Console.prototype.writable = function () {
  var cons = this;
  if (cons.peer) cons.peer.console_writable(cons);
};

Console.prototype.readable = function () {
  var cons = this;
  if (cons.peer) cons.peer.console_readable(cons);
};

Console.prototype.user_interrupt = function () {
  var cons = this;
  if (cons.peer) cons.peer.console_user_interrupt_thread(cons);
};

Console.prototype.terminate_thread = function () {
  var cons = this;
  if (cons.peer) cons.peer.console_terminate_thread(cons);
};

Console.prototype.restore_history = function () {

  var cons = this;

  cons.history = [];

  try {
    cons.history = JSON.parse(localStorage[cons.id + '/history']);
  } catch (e) {
  }

  cons.history_pos = cons.history.length;
  cons.history.push('');
};

Console.prototype.save_history = function () {

  var cons = this;

  try {
    localStorage[cons.id + '/history'] =
      JSON.stringify(cons.history.slice(-cons.history_max_length));
  } catch (e) {
  }
};

Console.prototype.move_history = function (prev) {

  var cons = this;
  var pos = cons.history_pos;

  if (prev ? pos > 0 : pos < cons.history.length-1) {
    var newpos = prev ? pos-1 : pos+1;
    cons.change_input(cons.history[newpos]);
    cons.history_pos = newpos;
  }
};

Console.prototype.change_input = function (text) {

  var cons = this;
  var soi = cons.start_of_input();
  var end = cons.end_of_doc();
  var input = cons.doc.getRange(soi, end);

  cons.history[cons.history_pos] = input;

  cons.replace_range(text, soi, end);
};

Console.prototype.send = function (text) {

  var cons = this;
  var start = 0;

  if (text === null) {
    cons.clear_transcript();
  } else {
    while (start < text.length) {
      var end = text.indexOf('\n');
      if (end < 0) break;
      cons.change_input(text.slice(start, end));
      cons.enter(true); // with notify
      start = end+1;
    }
    cons.change_input(text.slice(start, text.length));
  }
};

Console.prototype.refresh = function () {
  var cons = this;
  cons.cm.refresh();
};

Console.prototype.focus = function () {
  var cons = this;
  cons.cm.refresh();
  cons.cm.focus();
};

//-----------------------------------------------------------------------------

function Editor(elem, ui, title) {

  var editor = this;

  var cm_opts = {
    value: '',
    matchBrackets: true,
    mode: 'scheme',
    keyMap: 'emacs',
    autofocus: true,
    lineWrapping: true,
    extraKeys: {
      'Ctrl-S': function (cm) { editor.save(); },
      'Ctrl-Enter': function (cm) { editor.save_and_load(); }
    }
  };

  elem.classList.add('g-editor');
  editor.elem = elem;
  editor.ui = ui;
  editor.cm = CodeMirror(elem, cm_opts);
  editor.id = elem.id || 'DefaultEditor';
  editor.doc = editor.cm.getDoc();
  editor.title = title;
  editor.focused = false;
  editor.dirty = false;

  editor.cm.on('change', function(cm, event) {
    editor.set_dirty(true);
  });

  editor.ro = new ResizeObserver(function (entries) {
    editor.refresh();
  });

  editor.ro.observe(elem);

  editor.debug = false;
}

Editor.prototype.get_title = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').get_title()');

  return editor.title;
};

Editor.prototype.set_title = function (title) {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').set_title('+title+')');

  editor.title = title;

  return true;
};

Editor.prototype.set_dirty = function (dirty) {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').set_dirty('+dirty+')');

  editor.dirty = dirty;

  var tab_index = editor.ui.editor_mux.tab_index_of_channel(editor);

  if (tab_index >= 0) {

    var tab_elem = editor.ui.editor_mux.tg.tab_elem(tab_index);

    if (dirty) {
      tab_elem.setAttribute('data-g-dirty', '');
    } else {
      tab_elem.removeAttribute('data-g-dirty');
    }
  }
};

Editor.prototype.needs_attention = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').needs_attention()');

  return !editor.focused && editor.dirty;
};

Editor.prototype.refresh = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').refresh()');

  editor.cm.refresh();
};

Editor.prototype.focus = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').focus()');

  editor.focused = true;
  editor.cm.refresh();
  editor.cm.focus();
};

Editor.prototype.blur = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').blur()');

  editor.focused = false;
  editor.dirty = false;
  editor.cm.blur();
};

Editor.prototype.get_menu_items = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').get_menu_items()');

  var items = [];

  items.push(menu_item('Close tab', ['data-g-bold'], function (event) {
    editor.close_tab();
  }));

  items.push(menu_item('Save (Ctrl-S)', ['data-g-bold'], function (event) {
    editor.save();
  }));

  items.push(menu_item('Save and load (Ctrl-Enter)', ['data-g-bold'], function (event) {
    editor.save_and_load();
  }));

  items.push(menu_item('Rename', ['data-g-bold'], function (event) {
    editor.rename();
  }));

  items.push(menu_item('Delete', ['data-g-bold'], function (event) {
    editor.delete();
  }));

  return items;
};

Editor.prototype.get_elem = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').get_elem()');

  return editor.elem;
};

Editor.prototype.get_content = function () {

  var editor = this;

  return editor.doc.getRange(editor.doc.posFromIndex(0),
                             editor.doc.posFromIndex(Infinity));
};

Editor.prototype.replace_content = function (content) {

  var editor = this;

  editor.doc.replaceRange(content,
                          editor.doc.posFromIndex(0),
                          editor.doc.posFromIndex(Infinity));
};

Editor.prototype.close_tab = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').close_tab()');

  editor.ui.editor_mux.remove_channel(editor);
};

Editor.prototype.rename = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').rename()');

  editor.ui.rename_file(editor.title);
};

Editor.prototype.save = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').save()');

  editor.ui.write_file(editor.title, editor.get_content());

  editor.set_dirty(false);
};

Editor.prototype.save_and_load = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').load()');

  editor.save();

  var escaped = ('/'+editor.title).replace('\\','\\\\').replace('"','\\"');

  editor.ui.send_to_active_console('(load "' + escaped + '")\n', false);
};

Editor.prototype.delete = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').delete()');

  editor.ui.delete_file_possibly_editor(editor.title);
};

Editor.prototype.preserve_elem = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').preserve_elem()');

  return false;
};

//-----------------------------------------------------------------------------

// Local Variables:
// js-indent-level: 2
// indent-tabs-mode: nil
// End:
