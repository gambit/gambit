//=============================================================================

// File: "UI.js"

// Copyright (c) 2020-2022 by Marc Feeley, All Rights Reserved.

//=============================================================================

delete CodeMirror.keyMap.emacs['Ctrl-V']; // get paste working on Windows

//-----------------------------------------------------------------------------

function UI(vm, elem) {

  var ui = this;

  if (!elem) {
    elem = document.createElement('div');
    document.body.appendChild(elem);
  } else if (typeof elem === 'string') {
    elem = document.querySelector(elem);
  }

  var serial_num = ++UI.serial_number;
  var id = 'g-ui-' + serial_num; // default id

  if (elem.hasAttribute('id')) {
    id = elem.getAttribute('id');
  } else {
    elem.setAttribute('id', id);
  }

  // Create console multiplexer

  var cons_mux_elem = document.createElement('div');
  cons_mux_elem.classList.add('g-console-multiplexer');
  cons_mux_elem.classList.add('g-pane-rigid');
  var cons_mux = new Multiplexer(cons_mux_elem, true);

  cons_mux.get_more_menu_items = function () {
    return ui.get_more_menu_items_console();
  }

  cons_mux.elem.addEventListener('click', function (event) {
    ui.demo_cancel();
  });

  cons_mux.elem.addEventListener('keypress', function (event) {
    ui.demo_cancel();
  });

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

  var cons_and_editor_elem = document.createElement('div');
  cons_and_editor_elem.appendChild(cons_mux_elem);
  cons_and_editor_elem.appendChild(splitter_elem);
  cons_and_editor_elem.appendChild(editor_mux_elem);
  cons_and_editor_elem.classList.add('g-h-panes');
  cons_and_editor_elem.classList.add('g-pane-elastic');

  elem.innerHTML = '';  // remove all children
  elem.appendChild(cons_and_editor_elem);
  elem.classList.add('g-ui');
  elem.classList.add('g-h-panes');

  setup_splitter(cons_and_editor_elem);

  ui.vm = vm;
  ui.elem = elem;
  ui.id = id;
  ui.cons_mux = cons_mux;
  ui.editor_mux = editor_mux;
  ui.extra_elem = null;
  ui.demo_commands = [];
  ui.demo_index = 0;
  ui.demo_timeoutId = null;
  ui.debug = false;
  ui.fs = _os_fs;
  ui.root_dir = '';
  ui.tutorial_sections = {};

  UI.uis['#' + id] = ui;

  ui.init_predefined_files();
}

UI.serial_num = 0;
UI.uis = {};

UI.find = function (elem) {

  var root = undefined;

  if (elem) {
    root = elem.closest('.g-ui'); // find enclosing g-ui element
  }

  if (!root) {
    root = elem.querySelector('.g-ui'); // find enclosed g-ui element
  }

  if (root) {
    ui = UI.uis['#' + root.getAttribute('id')];
  }

  return ui;
};

UI.stop_browsing = function (event) {

  var ui = UI.find(event.target);

  if (ui.extra_elem !== null) {
    var elem = ui.elem;
    ui.extra_elem = null;
    while (elem.childNodes.length > 1) {
      elem.removeChild(elem.lastChild);
    }
  }
};

UI.follow = function (event, topic) {

  var ui = UI.find(event.target);

  var content = ui.tutorial_sections[topic];
  var extra_elem = ui.get_extra_elem();

  extra_elem.innerHTML = content;
};

UI.in_repl = function (event, input) {

  var ui = UI.find(event.target);

  var dev = ui.active_console_device();

  if (dev) {
    dev.cons.add_current_input(input, true, true);
  }
};

UI.prototype.close_active_editor = function () {

  var ui = this;

  var tab_index = ui.editor_mux.tg.active_tab_index();

  if (tab_index >= 0) {
    var editor = ui.editor_mux.tabs[tab_index];
    editor.close_tab();
  }
};

UI.prototype.get_extra_elem = function () {

  var ui = this;

  var extra_elem = ui.extra_elem;

  if (extra_elem === null) {

    var elem = ui.elem;

    var splitter_elem = document.createElement('div');
    splitter_elem.classList.add('g-pane-splitter');

    extra_elem = document.createElement('div');
    extra_elem.classList.add('g-extra');
    extra_elem.classList.add('g-pane-rigid');

    elem.appendChild(splitter_elem);
    elem.appendChild(extra_elem);

    setup_splitter(elem);

    ui.extra_elem = extra_elem;
  }

  return extra_elem;
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
};

UI.prototype.remove_console = function (dev) {

  var ui = this;

  if (ui.debug)
    console.log('UI().remove_console(...)');

  ui.cons_mux.remove_channel(dev);
};

UI.prototype.activate_console = function (dev, no_focus) {

  var ui = this;

  if (ui.debug)
    console.log('UI().activate_console(...)');

  ui.cons_mux.activate_channel(dev, no_focus);
};

UI.prototype.active_console_device = function () {

  var ui = this;

  var cons_mux = ui.cons_mux;
  var tab_index = cons_mux.tg.active_tab_index();
  var dev = null;

  if (tab_index >= 0) dev = cons_mux.tabs[tab_index];

  return dev;
};

UI.prototype.send_to_active_console = function (text, focus) {

  var ui = this;

  if (ui.debug)
    console.log('UI().send_to_active_console(\''+text+','+focus+'\')');

  var dev = ui.active_console_device();

  if (dev) {
    if (focus) {
      dev.focus();
    }
    dev.cons.send(text);
  }
};

UI.prototype.just_scheme = function () {

  var ui = this;
  return true;
  return ui.vm.os_web_origin.indexOf('://try.scheme.org/') > 0;
};

UI.prototype.start_demo = function () {

  var ui = this;

  if (ui.debug)
    console.log('UI().start_demo()');

  ui.demo([
    0, '(display "hello world!\\n")   ;; click console to cancel demo',
    2, '(display "hello world!\\n")   ;; click console to cancel demo\n',
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
    (ui.just_scheme()
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
  ]);
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

UI.prototype.open_in_editor = function (path) {

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

  return editor;
};

UI.prototype.edit_file = function (path, no_focus) {

  var ui = this;
  var editor = ui.open_in_editor(path);

  ui.editor_mux.activate_channel(editor, no_focus);

  return editor;
};

UI.prototype.init_predefined_files = function () {

  var ui = this;

  ui.write_file('README.html', '\
<p>If you have programmed before but are new to ' +
(ui.just_scheme() ? 'Scheme' : 'Gambit Scheme') +
', you should <button onclick="UI.follow(event,\'basic\');">start the tutorial</button> to get to know the language better.\n\
\n\
<p>The first pane, the REPL, is where the user interacts with the interpreter. The REPL is an ideal place to try out code snippets and debug code.</p>\n\
\n\
<p>The second pane is the editor area. It allows creating and editing files that are local to the browser and accessible to Scheme code as files in the root directory, i.e. "<code><b>/</b></code>". The files will persist in the browser between sessions. Use the "<code><b>+</b></code>" tab in the editor area to create new files and open existing files.</p>\n\
\n\
<h2>Basic keybindings</h2>\n\
\n\
<table class="g-right-justify">\n\
<tr><th colspan="2" style="text-align:left">in REPL:</th></tr>\n\
<tr><td><kbd>Enter</kbd></td><td>send the current line to the REPL</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>L</kbd></td><td>clear transcript</td></tr>\n\
<tr><td><kbd>&uarr;</kbd> / <kbd>&darr;</kbd></td><td>move back/forward in REPL history</td></tr>\n\
<tr><th><br></th></tr>\n\
<tr><th colspan="2" style="text-align:left">in editor:</th></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>S</kbd></td><td>save file</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>Enter</kbd></td><td>save file and load it from the REPL</td></tr>\n\
<tr><th><br></th></tr>\n\
<tr><th colspan="2" style="text-align:left"><button onclick="UI.follow(event,\'keybindings\');">More keybindings</button></th></tr>\n\
</table>\n\
');

  function write_tutorial_section(file_topic, content) {
    ui.tutorial_sections[file_topic] =
      '<div class="g-extra-header">' +
      '<button onclick="UI.stop_browsing(event);">&#10006;</button>' +
      [
        'basic',
        'types',
        'forms',
        'libraries',
        'keybindings',
      ].map(function (topic) {
        return '<button onclick="UI.follow(event,\'' +
          topic + '\');"' +
          (topic === file_topic ? ' disabled' : '') +
          '>' +
          topic[0].toUpperCase() + topic.slice(1) +
          '</button>';
      }).join('') +
      '</div>\n' +
      '<div class="g-extra-body">' +
      content +
      '</div>';
  }

  function file_example(path, content) {
    if (content) ui.write_file(path, content);
    return '\
<div class="g-code-example-filename"><a href="" onclick="UI.find(event.target).edit_file(&quot;' + path + '&quot;); return false;">' + path + '</a></div>\n\
<pre class="g-code-example cm-s-default">' +
ui.syntax_highlight(ui.read_file(path, '')) + '</pre>';
  }

  function runnable_file_example(path, content) {
    if (content) ui.write_file(path, content);
    return '\
<div class="g-code-example-filename"><a href="" onclick="UI.find(event.target).edit_file(&quot;' + path + '&quot;); return false;">' + path + '</a></div>\n\
<pre class="g-code-example cm-s-default"><button onclick="UI.in_repl(event,\'(load &quot;/' + path + '&quot;)\\n\');">run</button>' +
ui.syntax_highlight(ui.read_file(path, '')) + '</pre>';
  }

  function runnable_repl_example(content) {

    var lines = content.split('\n');
    var input_attr = '';
    var content_html = '';
    var enter_last_line = lines[lines.length-1] === '';

    if (enter_last_line) lines.pop(); // remove empty last line

    for (var i=0; i<lines.length; i++) {
      var line = lines[i];
      var line_no_prompt = line.replace(/^[0-9]*> /, '');
      if (line !== line_no_prompt || line[0] === ' ') { // line has input code
        var ending = (enter_last_line || i<lines.length-1) ? '\n' : '';
        var prompt = line.slice(0, line.length - line_no_prompt.length);
        line = UI.escape_HTML(prompt) +
               '<b>' + ui.syntax_highlight(line_no_prompt) + '</b>';
        input_attr += line_no_prompt + ending;
      } else {
        line = ui.syntax_highlight(line);
      }
      content_html += line + '\n';
    }

    return '\
<pre class="g-code-example cm-s-default"><button onclick="UI.in_repl(event,\'' + UI.escape_HTML_attr(input_attr) + '\');">run</button>' + content_html + '</pre>\n';
  }

  write_tutorial_section('basic', '\
<p>[Tip: to jump to a topic click one of the buttons above]</p>\n\
\n\
<p>This tutorial aims to get you started with programming in ' +
(ui.just_scheme() ? 'Scheme' : 'Gambit Scheme') +
' and show off some features of this online environment.  For a more in depth understanding you should read the <a href="https://small.r7rs.org/attachment/r7rs.pdf">Revised^7 Report on the Algorithmic Language Scheme</a>' +
(ui.just_scheme() ? '' : ' and the <a href="doc/gambit.html">Gambit Scheme manual</a>') +
'.\n\
\n\
<p>At the REPL the traditional Hello World can be done as shown below by calling the <code><b>display</b></code> <i>procedure</i> (a term preferred to <i>function</i> by Schemers).</p>\n\
' + runnable_repl_example('\
> (display "hello world!\\n")\n\
hello world!\n\
') + '\n\
<p>Procedure calls follow the parenthesized syntax\n\
<pre>    (<i>&lt;procedure&gt;</i> <i>&lt;argument1&gt;</i> <i>&lt;argument2&gt;</i> ...)</pre>\n\
and even simple arithmetic operations like addition and multiplication are procedure calls:</p>\n\
' + runnable_repl_example('\
> (+ 6 1)\n\
7\n\
> (expt 2 8)\n\
256\n\
> (* 4 (atan 1))\n\
3.141592653589793\n\
') + '\n\
<p>The <code><b>define</b></code> form allows defining global variables and procedures:</p>\n\
' + runnable_repl_example('\
> (define pi (* 4 (atan 1)))\n\
> (define circum (lambda (r) (* 2 pi r)))\n\
> (circum 5)\n\
31.41592653589793\n\
') + '\n\
<p>This defines the global variables <code><b>pi</b></code> and <code><b>circum</b></code>. The value stored in the variable <code><b>circum</b></code> is a procedure created with the <code><b>lambda</b></code> form accepting the sole parameter <code><b>r</b></code> that is local to that procedure. That procedure definition could be defined equivalently with a variant of the <code><b>define</b></code> form that is more compact:</pre>\n\
<pre class="g-code-example cm-s-default"><b>' + ui.syntax_highlight('(define (circum r) (* 2 pi r))') + '</b>\n\
</pre>\n\
<p>Regardless of the variant used the REPL does not print a result when a <code><b>define</b></code> form is entered.</p>\n\
\n\
<p>Accessing the functionality provided by existing libraries can be done with the <code><b>import</b></code> form. For example the <a href="https://srfi.schemers.org/srfi-48/srfi-48.html">SRFI 48</a> library offers the <code><b>format</b></code> procedure that is useful for formatted output:</p>\n\
' + runnable_repl_example('\
> (import (srfi 48))\n\
> (format #t "1+2=~s\\n" (+ 1 2))\n\
1+2=3\n\
') + '\n\
<p>A typical Scheme program is a sequence of <code><b>import</b></code> forms, definitions and procedure calls stored in a file with a <code>.scm</code> or <code>.sld</code> extension. The <code><b>load</b></code> procedure can be used from the REPL to execute the Scheme code in a file:</p>\n\
' + runnable_file_example('TUTORIAL/prog.scm', '\
(import (srfi 19))  ;; for time procedures\n\
(import (srfi 48))  ;; for format\n\
\n\
(define (get-date)\n\
  (time-utc->date (current-time time-utc)))\n\
\n\
(format #t\n\
        "current UTC time: ~a\\n"\n\
        (date->string (get-date)))\n\
') + '\
<p>A wide range of characters is allowed in Scheme identifiers including "<code><b>-</b></code>" and "<code><b>&gt;</b></code>" as in the example, and also "<code><b>!</b></code>", "<code><b>?</b></code>", "<code><b>=</b></code>", "<code><b>&lt;</b></code>", "<code><b>+</b></code>", "<code><b>/</b></code>", and other non-letter characters.  Note that single-line comments begin with a <code><b>;</b></code> that is typically doubled.</p>\n\
\n\
<p>To develop programs in this online environment it is convenient to open and edit the file in the editor area and then press <kbd>Ctrl</kbd> <kbd>Enter</kbd> to save the file and load it in the REPL.</p>\n\
');

  write_tutorial_section('types', '\
<h2>Booleans, characters, and strings</h2>\n\
\n\
<p>Booleans, characters, and strings have the following syntax:</p>\n\
<table class="g-right-justify">\n\
<tr><td><code><b>#f</b></code> :</td><td>false</td></tr>\n\
<tr><td><code><b>#t</b></code> :</td><td>true</td></tr>\n\
<tr><td><code><b>#\\X</b></code> :</td><td>character X</td></tr>\n\
<tr><td><code><b>#\\space</b></code> :</td><td>space character</td></tr>\n\
<tr><td><code><b>"ABC\\n"</b></code> :</td><td>string with 4 characters\n\
</table>\n\
<p>Here are a few operations involving those types:<\p>\n\
' + runnable_repl_example('\
> (string-append "A" "BC")\n\
"ABC"\n\
> (string-ref "XYZ" 2)  ;; indexing\n\
#\\Z\n\
> (string-length "AB")  ;; get length\n\
2\n\
> (char->integer #\\A)   ;; conversion\n\
65\n\
> (char<? #\\A #\\Z)      ;; comparison\n\
#t\n\
') + '\n\
<p>Scheme strings are mutable.  Individual characters can be changed with the <code><b>string-set!</b></code> procedure.</p>\n\
\n\
<h2>Numbers</h2>\n\
\n\
<p>Scheme has a complete set of numerical types including integers, reals and complex numbers, for example <code><b>42</b></code>, <code><b>-3.5</b></code>, and <code><b>1+2i</b></code>. Moreover a number has an indication of whether the value should be viewed as mathematically correct (<i>exact</i>) or an approximation (<i>inexact</i>). For example <code><b>42.0</b></code> is an inexact integer and <code><b>2/3</b></code> is an exact real. Exact numbers have an unlimited size. Here are a few operations with various types of numbers:</p>\n\
' + runnable_repl_example('\
> (expt 2 75)           ;; 2^75\n\
37778931862957161709568\n\
> (exp (* 75 (log 2)))  ;; e^(75*ln(2))\n\
3.7778931862957074e22\n\
> (* (/ 5 3) (/ 9 2))   ;; 5/3 * 9/2\n\
15/2\n\
> (+ (sqrt -6.25) 1)    ;; sqrt(-6.25)+1\n\
1+2.5i\n\
> (> 1e-2 1)            ;; 0.01 > 1 ?\n\
#f\n\
') + '\n\
<h2>Lists and vectors</h2>\n\
\n\
<p>There are two types for representing finite sequences of arbitrary values: lists and vectors. Lists allow quickly accessing, adding and removing elements at the front. Vectors are fixed size sequences and offer constant time indexing of any element. Elements of lists and vectors can be of different types.</p>\n\
\n\
<p>Lists are usually constructed with the <code><b>list</b></code> and <code><b>cons</b></code> procedures, and elements are accessed with the <code><b>car</b></code> and <code><b>cdr</b></code> procedures. Their written representation is <code><b>(</b></code><i>&lt;element1&gt;</i> <i>&lt;element2&gt;</i> ...<code><b>)</b></code>. List constants in code must be prefixed by the single quote character <code><b>\'</b></code> to avoid treating them as a procedure call. Here are some operations on lists:</p>\n\
' + runnable_repl_example('\
> (define lst (list 1 2))\n\
> lst\n\
(1 2)\n\
> (cons 0 lst)         ;; add to front\n\
(0 1 2)\n\
> (append lst \'(3 4))  ;; concatenation\n\
(1 2 3 4)\n\
> (car lst)            ;; get first\n\
1\n\
> (cdr lst)            ;; remove first\n\
(2)\n\
> (cdr (cdr lst))      ;; remove both\n\
()\n\
> (length lst)         ;; get length\n\
2\n\
') + '\n\
<p>Vectors are usually constructed with the <code><b>vector</b></code> and <code><b>make-vector</b></code> procedures, and elements are accessed with the <code><b>vector-ref</b></code> and <code><b>vector-set!</b></code> procedures. Their written representation is <code><b>#(</b></code><i>&lt;element1&gt;</i> <i>&lt;element2&gt;</i> ...<code><b>)</b></code>. Here are some operations on vectors:</p>\n\
' + runnable_repl_example('\
> (define v (make-vector 5 42))\n\
> v\n\
#(42 42 42 42 42)\n\
> (vector-set! v 2 #t)  ;; mutation\n\
> v\n\
#(42 42 #t 42 42)\n\
> (vector-ref v 2)      ;; indexing\n\
#t\n\
> (vector-length v)     ;; get length\n\
5\n\
') + '\n\
<h2>Symbols</h2>\n\
\n\
<p>Symbols are essentially immutable strings whose syntax is the same as identifiers. For example <code><b>foo</b></code> and <code><b>*</b></code> are symbols. Similarly to list constants, symbols that are used as constants in code must be prefixed by the single quote character <code><b>\'</b></code> to avoid treating them as variable references. Symbols are particularly useful when combined with lists to represent Scheme code for macro processing, code transformers and compilers, and for evaluation by the <code><b>eval</b></code> procedure.  This is known as the <i>s-expression</i> representation. Here is an example:</p>\n\
' + runnable_repl_example('\
> (string->symbol "foo")  ;; conversion\n\
foo\n\
> (symbol->string \'foo)   ;; conversion\n\
"foo"\n\
> (define x (list \'* 2 3 7))\n\
> x\n\
(* 2 3 7)\n\
> (eval x)\n\
42\n\
') + '\n\
<h2>Procedures</h2>\n\
\n\
<p>Scheme provides many operations through predefined procedures that are stored in global variables.  For example the <code><b>*</b></code> global variable contains the multiplication procedure. New procedures are created with the <code><b>lambda</b></code> and <code><b>define</b></code> forms that are explained in the <b>Forms</b> section.</p>\n\
<p>In addition to the procedure call syntax explained in the <b>Basic</b> section, procedures can be called with the <code><b>apply</b></code> procedure using a list of the arguments:</p>\n\
' + runnable_repl_example('\
> *\n\
#<procedure #2 *>\n\
> (* 2 3 7)\n\
42\n\
> (apply * (list 2 3 7))\n\
42\n\
') + '\n\
');

  write_tutorial_section('forms', '\
<h2>Core forms</h2>\n\
\n\
<h3><code><b>lambda</b></code></h3>\n\
\n\
<p>The <code><b>lambda</b></code> form has a central role in Scheme. So called <i>lambda-expressions</i> have the syntax:</p>\n\
<pre class="cm-s-default">    <i>' + ui.syntax_highlight('(lambda <parameter-list> <body>)') + '</i>\n\
</pre>\n\
<p>The scope of the parameters in the <code><i>&lt;parameter-list&gt;</i></code> is local to the <code><i>&lt;body&gt;</i></code>.</p>\n\
<p>When the procedure accepts a fixed number of arguments the <code><i>&lt;parameter-list&gt;</i></code> is just the parenthesized list of the parameter names:</p>\n\
' + runnable_repl_example('\
> (define fact\n\
    (lambda (n)  ;; sole parameter is n\n\
      (if (< n 2)\n\
          1\n\
          (* n (fact (- n 1))))))\n\
> (fact 30)\n\
265252859812191058636308480000000\n\
> (define (fact n)  ;; equivalent def.\n\
    (if (< n 2) 1 (* n (fact (- n 1)))))\n\
') + '\n\
<p>Procedures that accept a variable number of arguments (<i>variadic</i> procedures) have a <i>rest parameter</i> at the end of the parameter list prefixed by a period. Before the period are all the required parameters. The rest parameter will contain a list of all the arguments beyond the required ones (the empty list if there are none):</p>\n\
' + runnable_repl_example('\
> (define rot\n\
    (lambda (x . y)\n\
      (append y (list x))))\n\
> (rot 1 2 3 4 5)\n\
(2 3 4 5 1)\n\
> (define (rot x . y)  ;; equivalent def.\n\
    (append y (list x)))\n\
') + '\n\
<p>Scheme variables are lexically scoped. When the <code><i>&lt;body&gt;</i></code> contains a reference to a variable not declared in the <code><i>&lt;parameter-list&gt;</i></code>, it is said to refer to a <i>free variable</i>. When a <code><b>lambda</b></code> form is evaluated, it remembers the memory cells bound to the free variables in the procedure that is created (which is called a <i>closure</i>) so that when it is called the free variable references will access these cells. This is a fundamental aspect of Scheme programming as it can be used in various programming idioms. For example:</p>\n\
' + runnable_repl_example('\
> (define (adder n)\n\
    (lambda (x) (+ x n)))\n\
> (define add1 (adder 1))\n\
> (define sub1 (adder -1))\n\
> (add1 5)  ;; 5 + 1\n\
6\n\
> (sub1 (sub1 5))  ;; 5 + -1 + -1\n\
3\n\
') + '\n\
<p>In this example the closures created by each call to <code><b>adder</b></code> remember a different binding of the variable <code><b>n</b></code>, one is bound to a cell containing the value 1 and the other to a cell containing the value -1.</p>\n\
<p>Closures are particularly useful when using higher-order procedures such as <code><b>map</b></code> and <code><b>for-each</b></code> that call a procedure on every element of a list:</p>\n\
' + runnable_repl_example('\
> (define (add-to-all n lst)\n\
    (map (lambda (x) (+ x n)) lst))\n\
> (add-to-all 10 \'(1 2 3 4))\n\
(11 12 13 14)\n\
') + '\n\
\n\
<h3><code><b>set!</b></code></h3>\n\
\n\
<p>The <code><b>set!</b></code> form allows changing the value in the cell bound to a variable:</p>\n\
' + runnable_repl_example('\
> (define sum 0)\n\
> (for-each (lambda (n) (set! sum (+ sum n)))\n\
            \'(1 2 3 4))\n\
> sum\n\
10\n\
') + '\n\
\n\
<h3><code><b>if</b></code></h3>\n\
\n\
<p>The <code><b>if</b></code> form does conditional evaluation. The first argument is the condition expression and it is followed by a second expression that is evaluated when the first expression\'s value is not <code><b>#f</b></code>, and an optional third expression that is evaluated when the first expression\'s value is <code><b>#f</b></code>:</p>\n\
' + runnable_repl_example('\
> (define (die) (+ 1 (random-integer 6)))\n\
> (define x (die))\n\
> x\n\
2\n\
> (if (<= x 3) (display "x is low\\n"))\n\
x is low\n\
> (display (if (odd? x) "odd\\n" "even\\n"))\n\
even\n\
') + '\n\
<h2>Derived forms</h2>\n\
\n\
<p>The other forms of expressions can be viewed as syntactic sugar over the core forms.</p>\n\
\n\
<h3><code><b>let</b></code>, <code><b>let*</b></code>, and <code><b>letrec</b></code></h3>\n\
\n\
<p>These are <i>binding</i> forms that create local variables.  They share the same syntax, here explained with <code><b>let</b></code>:</p>\n\
<pre class="cm-s-default">    <i>' + ui.syntax_highlight('(let ((<var> <expr>) ...) <body>)') + '</i>\n\
</pre>\n\
<p>A cell is created for each variable <code><i>&lt;var&gt;</i></code> mentioned in the list of bindings <code><i>((&lt;var&gt; &lt;expr&gt;) ...)</i></code> and they are initialized to the value of the corresponding expression <code><i>&lt;expr&gt;</i></code>. In the case of the <code><b>let</b></code> form, the scope of the variables is limited to the expression <code><i>&lt;body&gt;</i></code>. In the case of the <code><b>let*</b></code> form, the scope of a variable also includes the expressions that follow in the list of bindings, and the expressions are evaluated from left to right. In the case of the <code><b>letrec</b></code> form, the scope of a variable includes all the expressions in the list of bindings, which is particularly useful for recursive procedure definitions.</p>\n\
' + runnable_repl_example('\
> (define x 10)\n\
> (let ((x (+ x 1)) (y (+ x 2))) (list x y))\n\
(11 12)\n\
> (let* ((x (+ x 1)) (y (+ x 2))) (list x y))\n\
(11 13)\n\
> (letrec ((x (lambda (n)\n\
                (if (> n 9) n (x (* n 2))))))\n\
    (x 1))\n\
16\n\
> x\n\
10\n\
') + '\n\
\n\
<h3><code><b>begin</b></code></h3>\n\
\n\
<p>The <code><b>begin</b></code> form accepts any number of subexpressions, evaluating them from left to right and returning the value of the last subexpression.</p>\n\
' + runnable_repl_example('\
> (define n -4)\n\
> (if (< n 0)\n\
      (begin\n\
        (display "neg\\n")\n\
        (- n))\n\
      (begin\n\
        (display "pos\\n")\n\
        (* 100 n)))\n\
neg\n\
4\n\
') + '\n\
<p>The <code><b>lambda</b></code>, <code><b>let</b></code>, <code><b>let*</b></code>, and <code><b>letrec</b></code></h3> forms can have more than one expression in their <i>&lt;body&gt;</i>, in which case they are implicitly wrapped in a <code><b>begin</b></code> form.</p>\n\
\n\
<h3><code><b>and</b></code></h3>\n\
\n\
<p>The <code><b>and</b></code> form accepts any number of subexpressions, evaluating them from left to right until one returns <code><b>#f</b></code>. It returns the value of the last expression that was evaluated.</p>\n\
' + runnable_repl_example('\
> (define n -4)\n\
> (and (>= n -10) (<= n 10) (* n n))\n\
16\n\
> (and (> n 0) (sqrt n)) ;; sqrt not called\n\
#f\n\
') + '\n\
\n\
<h3><code><b>or</b></code></h3>\n\
\n\
<p>The <code><b>or</b></code> form accepts any number of subexpressions, evaluating them from left to right until one returns a value other than <code><b>#f</b></code>. It returns the value of the last expression that was evaluated.</p>\n\
' + runnable_repl_example('\
> (define n -4)\n\
> (or (odd? n) (positive? n))\n\
#f\n\
> (or (< n 0) (sqrt n)) ;; sqrt not called\n\
#t\n\
') + '\n\
\n\
<h3><code><b>cond</b></code></h3>\n\
\n\
<p>The <code><b>cond</b></code> form is a multiway conditional evaluation form. Each of the <code><b>cond</b></code>\'s clauses gives a condition and a branch to evaluate if that condition is not <code><b>#f</b></code>. Each branch can have multiple expressions that are implicitly wrapped in a <code><b>begin</b></code> form. It returns the value of the branch that was evaluated.</p>\n\
' + runnable_repl_example('\
> (define n 2)\n\
> (cond ((= n 0) "zero")\n\
        ((= n 1) "one")\n\
        ((= n 2) "two")\n\
        (else    "other"))\n\
"two"\n\
') + '\n\
\n\
<h3><code><b>case</b></code></h3>\n\
\n\
<p>The <code><b>case</b></code> form is a multiway <i>switch</i> based on a value. Each branch is associated with one or more cases that are tested with the subject value for equality using the <code><b>eqv?</b></code> procedure. Each branch can have multiple expressions that are implicitly wrapped in a <code><b>begin</b></code> form. It returns the value of the branch that was evaluated.</p>\n\</p>\n\
' + runnable_repl_example('\
> (define n 2)\n\
> (case n\n\
    ((0 1) "small")\n\
    ((2)   "medium")\n\
    ((3 4) "large")\n\
    (else  "other"))\n\
"medium"\n\
') + '\n\
');

  if (!ui.file_exists('.gambini')) {
    ui.write_file('.gambini', '\
;; Who you gonna trust?\n\
\n\
;;(module-whitelist-add! \'(github.com/feeley))\n\
;;(module-whitelist-add! \'(github.com/scheme-requests-for-implementation))\n\
;;(module-whitelist-add! \'(github.com/ashinn/irregex))\n\
');
  }

  write_tutorial_section('libraries', '\
<p>A R7RS library is defined using a <code><b>define-library</b></code> form, typically contained in a file with a <code>.sld</code> extension. In general a library name is a list of symbols (integers are also allowed). For example here is a library definition for a small library named <code><b>(hello)</b></code>:</p>\n\
' + file_example('hello.sld', '\
(define-library (hello)\n\
\n\
  (export hi salut)  ;; the exports\n\
\n\
  (import\n\
   (scheme base)     ;; for define\n\
   (scheme write))   ;; for display\n\
\n\
  (begin             ;; the body\n\
\n\
    (define (exclaim msg1 msg2)\n\
      (display msg1)\n\
      (display msg2)\n\
      (display "!\\n"))\n\
\n\
    (define (hi name)\n\
      (exclaim "hello " name))\n\
\n\
    (define (salut name)\n\
      (exclaim "bonjour " name))))\n\
') + '\n\
<p>This library contains the clause <code><b>(export hi salut)</b></code> that indicates that the procedures <code><b>hi</b></code> and <code><b>salut</b></code> are exported by the library. The procedure <code><b>exclaim</b></code> is defined and used in the implementation of the exported procedures but it is not exported by the library. The clause <code><b>(import (scheme base) (scheme write))</b></code> is needed for accessing the bindings of <code><b>define</b></code> and <code><b>display</b></code> that are used in the body of the library.</p>\n\
<p>To use the <code><b>(hello)</b></code> library an <code><b>(import (hello))</b></code> form must be used. It can be used at the REPL like this:</p>\n\
' + runnable_repl_example('\
> (import (hello))\n\
> (hi "world")\n\
hello world!\n\
') + '\n\
<p>And in a <i>script</i>-style main program like this:</p>\n\
' + runnable_file_example('TUTORIAL/greet-schemers.scm', '\
(import (hello))\n\
\n\
(hi "Schemers")\n\
') + '\n\
<p>And also in another library\'s <code><b>define-library</b></code> form, such as the following library with no exports that is an alternative way to write a main program:</p>\n\
' + runnable_file_example('TUTORIAL/greet-schemers.sld', '\
(define-library (greet-schemers)\n\
\n\
  (import (hello))\n\
\n\
  (begin\n\
    (hi "Schemers")))\n\
') + '\n\
<p>Libraries are made available for use through a process that depends on the Scheme implementation. One way is to use a system specific <i>installer</i> tool to install libraries. Moreover, systems typically define a list of filesystem directories where libraries are searched (called the <i>module search order</i> here). For convenience, the list is typically configurable and extensible by the user.</p>\n\
<p>This online environment uses a module search order that includes the (browser local) filesystem root "<code><b>/</b></code>". This is where the file editor stores the edited files, making it convenient to store libraries under development there. The module search order also includes "<code><b>~~lib</b></code>" which is mapped to the web site\'s <code><b>lib</b></code> directory that contains various system libraries and SRFIs. The list can be extended by calling <code><b>(module-search-order-add! "<i>dir</i>")</b></code>.\n\
<p>A library named <code><b>(A B C)</b></code> must be stored on the filesystem in a module search order directory in either the file <code><b>A/B/C.sld</b></code> or <code><b>A/B/C/C.sld</b></code> relative to that directory. The second approach is usually preferred when the library\'s code is spread among multiple files (that are included with <code><b>include</b></code> forms) or the library contains a sublibrary such as <code><b>(A B C D)</b></code>. To simplify distributing a library\'s code in multiple files the <code><b>include</b></code> form interprets paths relatively to the directory of the file containing the <code><b>include</b></code>.</p>\n\
<p>Libraries may also be stored on the GitHub platform in public repositories using the same filesystem layout as above, making it easy to use existing libraries and publish new ones. For example, the <code><b>(hello)</b></code> library shown above also exists in the repository <a href="https://github.com/gambit/hello">https://github.com/gambit/hello</a> so it can be referred to using the name <code><b>(github.com/gambit/hello)</b></code>:</p>\n\
' + runnable_repl_example('\
> (import (github.com/gambit/hello))\n\
> (hi "world")\n\
hello world!\n\
') + '\n\
<p>For security reasons this online environment will refuse to import libraries from untrusted repositories. The procedure <code><b>module-whitelist-add!</b></code> allows extending the list of trusted repositories. For example Alex Shinn\'s <a href="https://github.com/ashinn/irregex">irregex<a> library for regular expressions can be imported like this:</p>\n\
' + runnable_repl_example('\
> (module-whitelist-add! \'(github.com/ashinn/irregex))\n\
> (import (github.com/ashinn/irregex))\n\
> (irregex-replace/all " +" "a   b c" "_")\n\
"a_b_c"\n\
') + '\n\
<p>Another example is Marc Feeley\'s roman numeral conversion library at <a href="https://github.com/feeley/roman">https://github.com/feeley/roman</a> and its <code><b>demo</b></code> sublibrary:</p>\n\
' + runnable_repl_example('\
> (module-whitelist-add! \'(github.com/feeley))\n\
> (import (github.com/feeley/roman demo))\n\
1 is I in roman numerals\n\
2 is II in roman numerals\n\
4 is IV in roman numerals\n\
8 is VIII in roman numerals\n\
16 is XVI in roman numerals\n\
32 is XXXII in roman numerals\n\
64 is LXIV in roman numerals\n\
') + '\n\
<p>To avoid having to enter the trusted repositories at every online session, it is convenient to add calls to <code><b>module-whitelist-add!</b></code> in the file <a href="" onclick="UI.find(event.target).edit_file(&quot;.gambini&quot;); return false;"><code><b>.gambini</b></code></a> which contains Scheme code that is executed automatically at the start of a new session. Note that files including <a><code><b>.gambini</b></code></a> will persist from one session to the next (up to the next time the browser cache is cleared so be careful!).</p>\n\
');

  write_tutorial_section('keybindings', '\
<p>The keybindings are mostly emacs compatible.</p>\n\
<table class="g-right-justify">\n\
<tr><th colspan="2" style="text-align:left">in REPL and editor:</th></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>C</kbd></td><td>interrupt on empty selection</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>A</kbd></td><td>go to start of line</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>E</kbd></td><td>go to end of line</td></tr>\n\
<tr><td><kbd>&larr;</kbd> or <kbd>Ctrl</kbd> <kbd>B</kbd></td><td>go to previous char</td></tr>\n\
<tr><td><kbd>&rarr;</kbd> or <kbd>Ctrl</kbd> <kbd>F</kbd></td><td>go to next char</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>D</kbd></td><td>delete char (EOF on empty line in REPL)</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>O</kbd></td><td>insert line break</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>K</kbd></td><td>kill line</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>W</kbd></td><td>kill region</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>Y</kbd></td><td>paste last stretch of killed text</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>Space</kbd></td><td>set mark for selecting region</td></tr>\n\
<tr><th><br></th></tr>\n\
<tr><th colspan="2" style="text-align:left">in REPL:</th></tr>\n\
<tr><td><kbd>Tab</kbd></td><td>indentation or symbol completion</td></tr>\n\
<tr><td><kbd>Enter</kbd></td><td>send the current line to the REPL</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>L</kbd></td><td>clear transcript</td></tr>\n\
<tr><td><kbd>&uarr;</kbd> or <kbd>Ctrl</kbd> <kbd>P</kbd></td><td>move back in REPL history</td></tr>\n\
<tr><td><kbd>&darr;</kbd> or <kbd>Ctrl</kbd> <kbd>N</kbd></td><td>move forward in REPL history</td></tr>\n\
<tr><td><kbd>F7</kbd></td><td><code><b>,t</b></code> command: jump to toplevel REPL</td></tr>\n\
<tr><td><kbd>F8</kbd></td><td><code><b>,c</b></code> command: continue execution</td></tr>\n\
<tr><td><kbd>F9</kbd></td><td><code><b>,-</b></code> command: down continuation</td></tr>\n\
<tr><td><kbd>F10</kbd></td><td><code><b>,+</b></code> command: up continuation</td></tr>\n\
<tr><td><kbd>F11</kbd></td><td><code><b>,s</b></code> command: step</td></tr>\n\
<tr><td><kbd>F12</kbd></td><td><code><b>,l</b></code> command: leap</td></tr>\n\
<tr><th><br></th></tr>\n\
<tr><th colspan="2" style="text-align:left">in editor:</th></tr>\n\
<tr><td><kbd>Tab</kbd></td><td>indentation</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>S</kbd></td><td>save file</td></tr>\n\
<tr><td><kbd>Ctrl</kbd> <kbd>Enter</kbd></td><td>save file and load it in the REPL</td></tr>\n\
<tr><td><kbd>&uarr;</kbd> or <kbd>Ctrl</kbd> <kbd>P</kbd></td><td>go to previous line</td></tr>\n\
<tr><td><kbd>&darr;</kbd> or <kbd>Ctrl</kbd> <kbd>N</kbd></td><td>go to next line</td></tr>\n\
</table>\n\
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

  ui.edit_file('README.html');
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

UI.prototype.clear_highlighting = function () {

  var ui = this;

  ui.cons_mux.clear_highlighting();
  ui.editor_mux.clear_highlighting();
};

UI.prototype.pinpoint = function (container_scm, line0, col0) {

  var ui = this;

  if (ui.debug)
    console.log('UI().pinpoint(...)');

  if (typeof container_scm === 'object') {

    if (container_scm instanceof _ScmString) {

      var path = container_scm.toString();

      if (path.slice(0, 1) === '/') {
        path = path.slice(1);
      }

      if (ui.file_exists(path)) {
        var editor = ui.edit_file(path, true);
        return editor.pinpoint(line0, col0);
      }

    } else if (container_scm instanceof _ScmSymbol) {

      var name = container_scm.toString();
      var channels = ui.cons_mux.channels;
      var index = channels.length-1;

      while (index >= 0 ) {
        if (name === channels[index].name) break;
        index--;
      }

      if (index >= 0) {
        var dev = channels[index];
        return dev.pinpoint(line0, col0);
      }

    }
  }

  return false;
};

UI.escape_HTML_attr = function (text) {
  return text.replace(/&/g, '&amp;')
             .replace(/"/g, '&quot;')
             .replace(/</g, '&lt;')
             .replace(/>/g, '&gt;')
             .replace(/\\/g, '\\\\')
             .replace(/'/g, "\\'")
             .replace(/\n/g, '\\n');
};

UI.escape_HTML = function (text) {
  return text.replace(/[&<>"'`]/g, function (chr) {
    return '&#' + chr.charCodeAt(0) + ';';
  });
};

UI.unescape_HTML = function (html) {
  return html.replace(/&#38;/g, '&')
             .replace(/&#60;/g, '<')
             .replace(/&#62;/g, '>')
             .replace(/&#34;/g, '"')
             .replace(/&#39;/g, '\'')
             .replace(/&#96;/g, '`');
};

UI.prototype.syntax_highlight = function (text) {

  var ui = this;

  var cm_opts = {
    value: text,
    mode: 'scheme',
    lineWrapping: true,
  };

  var cm_elem = document.createElement('div');
  var cm = CodeMirror(cm_elem, cm_opts);

  cm.refresh();
  var styles = ['text-transform', 'color', 'font-weight'];
  var html = '';

  var nb_lines = cm.lineCount();

  for (var i=0; i<nb_lines; i++) {
    var line_tokens = cm.getLineTokens(i, true);
    if (i > 0) html += '\n';
    for (var j=0; j<line_tokens.length; j++) {
      var t = line_tokens[j];
      var token = UI.escape_HTML(t.string);
      var token_type = t.type;
      if (token_type) {
        html += '<span class="cm-' + token_type + '">';
      } else {
        html += '<span>';
      }
      html += token + '</span>';
    }
  }

  return html;
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

Multiplexer.prototype.clear_highlighting = function () {

  var mux = this;

  mux.channels.forEach(function (channel) {
    channel.clear_highlighting();
  });
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

Multiplexer.prototype.activate_channel = function (channel, no_focus) {

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
  }

  if (!no_focus) channel.focus();

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

function Device_console(vm, title, name, flags, ui, thread_scm) {

  var dev = this;

  if (!ui) ui = vm.ui;

  dev.vm = vm;
  dev.ui = ui;
  dev.title = title;
  dev.name = name;
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

  return new Completions(dev.vm.completions(dev.thread_scm, input, cursor));
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

  if (dev.ui !== null) dev.ui.clear_highlighting();

  dev.cons = cons;

  var condvar_scm = dev.read_condvar_scm;

  if (condvar_scm !== null) {
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

Device_console.prototype.activate = function (no_focus) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').activate()');

  if (dev.ui !== null) dev.ui.activate_console(dev, no_focus);
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

      if (input === null)
        return 0; // signal EOF

      dev.input_add(input, true);

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

Device_console.prototype.clear_highlighting = function () {

  var dev = this;

  dev.cons.cm.clear_highlighting();
};

Device_console.prototype.pinpoint = function (line0, col0) {

  var dev = this;

  var start = dev.cons.convert_position(CodeMirror.Pos(line0, col0));

  if (start === null) return false;

  var end = dev.cons.cm.forward_sexpr(start);

  if (!end) return false;

  return dev.cons.cm.set_highlighting(start, end);
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

function Completions(comps) {

  var completions = this;

  completions.comps = comps;
  completions.pos = 0;
}

Completions.prototype.available = function () {

  var completions = this;

  return completions.comps.length >= 2;
};

Completions.prototype.reset = function () {

  var completions = this;

  completions.comps = [];
  completions.pos = 0;
};

Completions.prototype.next = function () {

  var completions = this;

  if (completions.available()) {

    var comps = completions.comps;
    var pos = completions.pos;
    var old_text = comps[pos];
    var pos = (pos+1) % comps.length;
    var new_text = comps[pos];

    completions.pos = pos;

    return [old_text, new_text];

  } else {
    return null;
  }
};

//-----------------------------------------------------------------------------

UI.install_common_keys = function (cm_opts, interrupt) {

  var k = cm_opts.extraKeys;

  k['Ctrl-C'] = function (cm) {
    var doc = cm.getDoc();
    var from = doc.getCursor('from');
    var to = doc.getCursor('to');
    if (CodeMirror.cmp_pos(from, to) === 0) {
      interrupt();
    } else {
      document.execCommand('copy'); };
  };

  k['Ctrl-X'] = function (cm) {
    document.execCommand('cut');
  };
};

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
      'Ctrl-D': function (cm) { cons.delete_forward(); },
      'Ctrl-L': function (cm) { cons.clear_transcript(); },
      'Up':     function (cm) { cons.move_history(true); },
      'Ctrl-P': function (cm) { cons.move_history(true); },
      'Down':   function (cm) { cons.move_history(false); },
      'Ctrl-N': function (cm) { cons.move_history(false); },
      'Enter':  function (cm) { cons.enter(true); },
      'Tab':    function (cm) { cons.tab(); },
      'F7':     function (cm) { cons.enter_text('#||#,t;', true); },
      'F8':     function (cm) { cons.enter_text('#||#,c;', true); },
      'F9':     function (cm) { cons.enter_text('#||#,-;', true); },
      'F10':    function (cm) { cons.enter_text('#||#,+;', true); },
      'F11':    function (cm) { cons.enter_text('#||#,s;', true); },
      'F12':    function (cm) { cons.enter_text('#||#,l;', true); }
    }
  };

  UI.install_common_keys(cm_opts, function () { cons.user_interrupt(); });

  elem.classList.add('g-console');
  cons.cm = CodeMirror(elem, cm_opts);
  cons.id = elem.id || 'DefaultConsole';
  cons.doc = cons.cm.getDoc();
  cons.transcript_marker = null;
  cons.internal_op = false;
  cons.completions = new Completions([]);
  cons.input_buffer = [];
  cons.delayed_input = [];
  cons.allow_multiline_input = false;
  cons.eof = false;
  cons.peer = null;
  cons.history_max_length = 1000;
  cons.restore_history();
  cons.input_positions = [];
  cons.input_line = 0;
  cons.stamp = 0; // use position of transcript's top line as stamp

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

        if (CodeMirror.cmp_pos(lo, hi) > 0) {
          var t = lo;
          lo = hi;
          hi = t;
        }

        if (CodeMirror.cmp_pos(lo, hi) === 0 && // zero length selection in transcript
            CodeMirror.cmp_pos(lo, soi) < 0) {
          ranges.push({ head: soi, anchor: soi });
          change = true;
        } else if (CodeMirror.cmp_pos(lo, soi) < 0 && // selection that crosses soi
                   CodeMirror.cmp_pos(hi, soi) >= 0 &&
                   (event.origin === '+move' ||
                    (lo.sticky === null &&
                     hi.sticky === null))) {
          if (CodeMirror.cmp_pos(r.head, r.anchor) < 0) {
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

      cons.completions.reset();
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
          CodeMirror.cmp_pos(from, soi) < 0) {
        cons.cm.setSelection(soi);
        event.update(soi, CodeMirror.cmp_pos(to, soi) >= 0 ? to : soi, event.text);
      }
    }
  });

  cons.cm.on('change', function(cm, event) {

    // break multiline input into individual lines

    if (!cons.internal_op && !cons.allow_multiline_input) {
      var notify = (event.origin === '+input' || event.origin === 'paste');
      if (notify) {
        cons.add_current_input('', false, notify);
      }
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
  }

  var delayed_input = cons.delayed_input;

  if (delayed_input.length === 0) {
    return null; // EOF
  }

  var soi = cons.start_of_input();
  var end = cons.end_of_doc();
  var first = delayed_input.shift();
  cons.replace_range(first, soi, end);
  if (delayed_input.length === 0) { // last line?
    return '';
  } else {
    cons.enter(false); // add to history and input buffer, but no notify
    return cons.input_buffer.shift();
  }
};

Console.prototype.add_current_input = function (text, replace, notify) {

  var cons = this;
  var current_input = cons.current_input();
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
    cons.set_current_input(new_input);
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

Console.prototype.write = function (text, css_class) {

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

    if (css_class) {
      cons.doc.markText(soi, pos, { className: css_class });
    }

    var left_of_pos = CodeMirror.Pos(pos.line, pos.ch-1);
    cons.replace_range('', left_of_pos, pos);
    cons.transcript_marker = cons.doc.markText(cons.line0ch0,
                                               left_of_pos,
                                               cons.transcript_opts);

    cons.cm.scrollIntoView(null); // scroll cursor into view
  }
};

Console.prototype.write_line_widget = function (widget) {

  var cons = this;

  var soi = cons.start_of_input();

  if (soi.ch !== 0) {
    cons.write('\n');
    soi = cons.start_of_input();
  }

  cons.cm.addLineWidget(soi.line-1, widget);

  cons.cm.scrollIntoView(null); // scroll cursor into view
};

Console.prototype.current_input = function () {

  var cons = this;
  var soi = cons.start_of_input();
  var end = cons.end_of_doc();

  return cons.doc.getRange(soi, end);
};

Console.prototype.set_current_input = function (text) {

  var cons = this;
  var soi = cons.start_of_input();
  var end = cons.end_of_doc();

  cons.replace_range(text, soi, end);
};

Console.prototype.accept_current_input = function () {

  var cons = this;
  var soi = cons.start_of_input(true);
  var end = cons.end_of_doc();

  if (!(end.line === 0 && end.ch === 0)) {

    cons.doc.markText(soi, end, cons.input_opts);

    cons.transcript_marker = cons.doc.markText(cons.line0ch0,
                                               end,
                                               cons.transcript_opts);
  }

  cons.input_positions.push({ line: cons.input_line, start: soi });

  cons.input_line += end.line - soi.line + 1;

  cons.write('\n');

  cons.doc.setSelection(end);
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
      cons.input_positions = [];
      cons.stamp += soi.line;
    }
  }
};

Console.prototype.convert_position = function (pos) {

  var cons = this;
  var input_positions = cons.input_positions;

  for (var i=input_positions.length-1; i>=0; i--) {
    var input_pos = input_positions[i];
    if (pos.line >= input_pos.line) {
      var start = input_pos.start;
      if (pos.line === input_pos.line) {
        return CodeMirror.Pos(start.line,
                              start.ch + pos.ch);
      } else {
        return CodeMirror.Pos(start.line + pos.line - input_pos.line,
                              pos.ch);
      }
    }
  }

  return null;
};

Console.prototype.delete_forward = function () {

  var cons = this;
  var soi = cons.start_of_input();
  var end = cons.end_of_doc();

  if (CodeMirror.cmp_pos(soi, end) === 0) {
    cons.add_buffered_input(null, true); // signal EOF with notify
  } else {
    cons.cm.execCommand('delCharAfter');
  }
};

Console.prototype.enter = function (notify) {

  var cons = this;
  var current_input = cons.current_input();

  cons.accept_current_input();

  if (current_input.length > 0) {
    cons.history[cons.history.length-1] = current_input;
    cons.save_history();
  }

  cons.restore_history();

  cons.add_buffered_input(current_input + '\n', notify);
};

Console.prototype.enter_text = function (text, notify) {

  var cons = this;

  cons.set_current_input(text);
  cons.enter(notify);
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

  if (CodeMirror.cmp_pos(from, soi) >= 0) {
    if (CodeMirror.cmp_pos(from, to) === 0) {

      // zero length selection inside current input

      if (!cons.completions.available() && cons.peer) { // get new completions?
        var cursor = cons.doc.indexFromPos(from) - cons.doc.indexFromPos(soi);
        var current_input = cons.current_input();
        cons.completions = cons.peer.console_completions(current_input, cursor);
      }

      var next = cons.completions.next();

      if (next) {

        var old_text = next[0];
        var old_len = old_text.length;
        var new_text = next[1];
        var new_len = new_text.length;

        var new_from = CodeMirror.Pos(from.line, Math.max(0, from.ch-old_len));

        if (CodeMirror.cmp_pos(new_from, soi) < 0) {
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
  cons.history_backing = Array(cons.history.length).fill(null);
  cons.history.push('');
  cons.history_backing.push('');
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
    var backing = cons.history_backing[newpos];
    if (backing === null) {
      backing = cons.history[newpos];
      cons.history_backing[newpos] = backing;
    }
    cons.change_input(backing);
    cons.history_pos = newpos;
  }
};

Console.prototype.change_input = function (text) {

  var cons = this;
  var current_input = cons.current_input();

  cons.history_backing[cons.history_pos] = current_input;

  cons.set_current_input(text);
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

  UI.install_common_keys(cm_opts, function () { editor.user_interrupt(); });

  elem.classList.add('g-editor');

  var text_elem = document.createElement('div');
  text_elem.classList.add('g-editor-text');
  elem.appendChild(text_elem);

  var html_elem = document.createElement('div');
  html_elem.classList.add('g-editor-html');
  elem.appendChild(html_elem);

  editor.elem = elem;
  editor.ui = ui;
  editor.cm = CodeMirror(text_elem, cm_opts);
  editor.id = elem.id || 'DefaultEditor';
  editor.doc = editor.cm.getDoc();
  editor.title = title;
  editor.focused = false;
  editor.dirty = false;
  editor.text_elem = text_elem;
  editor.html_elem = html_elem;

  editor.cm.on('change', function(cm, event) {
    if (event.origin !== undefined) {
      editor.set_dirty(true);
    }
  });

  editor.ro = new ResizeObserver(function (entries) {
    editor.refresh();
  });

  editor.ro.observe(elem);

  elem.setAttribute('data-g-editor-view',
                    editor.is_html_file() ? 'html' : 'text');

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

Editor.prototype.clear_highlighting = function () {

  var editor = this;

  editor.cm.clear_highlighting();
};

Editor.prototype.pinpoint = function (line0, col0) {

  var editor = this;

  var start = CodeMirror.Pos(line0, col0);
  var end = editor.cm.forward_sexpr(start);

  if (!end) return false;

  editor.cm.setSelection(end);

  return editor.cm.set_highlighting(start, end);
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

  if (editor.is_html_file()) {
    items.push(document.createElement('hr'));
    items.push(menu_item('Toggle text and HTML views', ['data-g-bold'], function (event) {
      editor.toggle_views();
    }));
  }

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

  if (editor.current_view() === 'html') {
    editor.html_elem.innerHTML = content;
  }
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

  if (confirm('Are you sure you want to delete the file "' + editor.title + '"? This cannot be undone.')) {
    editor.ui.delete_file_possibly_editor(editor.title);
  }
};

Editor.prototype.current_view = function () {

  var editor = this;

  return editor.elem.getAttribute('data-g-editor-view');
};

Editor.prototype.is_html_file = function () {

  var editor = this;

  return editor.get_title().endsWith('.html');
};

Editor.prototype.toggle_views = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').toggle_views()');

  var new_view = editor.current_view() === 'text' ? 'html' : 'text';

  if (new_view === 'html') {
    editor.html_elem.innerHTML = editor.get_content();
  }

  editor.elem.setAttribute('data-g-editor-view', new_view);
};

Editor.prototype.preserve_elem = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').preserve_elem()');

  return false;
};

Editor.prototype.user_interrupt = function () {

  var editor = this;

  if (editor.debug)
    console.log('Editor(\''+editor.title+'\').user_interrupt()');

  var dev = editor.ui.active_console_device();

  if (dev) {
    dev.cons.user_interrupt();
  }
};

//-----------------------------------------------------------------------------

CodeMirror.prototype.clear_highlighting = function () {

  var cm = this;
  var h = cm.highlighting;

  if (h) {
    if (h.all) h.all.clear();
    if (h.end) h.end.clear();
    var eol_class_name = h.class_name+'-eol';
    for (var i=h.eol_start; i<h.eol_end; i++) {
      cm.removeLineClass(i, 'text', eol_class_name);
    }
    cm.highlighting = null;
  }
};

CodeMirror.prototype.set_highlighting = function (start, end, end_class_name, class_name) {

  var cm = this;

  if (!class_name) {
    class_name = 'g-highlight';
  }

  var doc = cm.getDoc();
  var len = doc.posFromIndex(doc.indexFromPos(CodeMirror.Pos(end.line, null))).ch;
  var has_eol = end.ch <= 0 || end.ch > len;

  if (has_eol) {
    if (end.ch > 0) end.line += 1;
    end.ch = 0;
    end = doc.posFromIndex(doc.indexFromPos(end)-1);
  }

  var eol_start = start.line;
  var eol_end = end.line + has_eol;

  var highlight_past_eol = true; // select style for multiline highlighting

  if (!highlight_past_eol && has_eol) {
    eol_start = eol_end - 1;
  }

  if (eol_start >= eol_end && CodeMirror.cmp_pos(start, end) >= 0) return false;

  cm.clear_highlighting();

  var eol_class_name = class_name+'-eol';

  for (var i=eol_start; i<eol_end; i++) {
    cm.addLineClass(i, 'text', eol_class_name);
  }

  var all = null;

  if (CodeMirror.cmp_pos(start, end) < 0) {
    all = doc.markText(start, end, { className: class_name });
    if (end_class_name) {
      var left_of_end = doc.posFromIndex(doc.indexFromPos(end)-1);
      end = doc.markText(left_of_end, end, { className: end_class_name });
    } else {
      end = null;
    }
  } else {
    end = null;
  }

  cm.highlighting = { class_name: class_name,
                      all: all,
                      end: end,
                      eol_start: eol_start,
                      eol_end: eol_end
                    };

  return true;
};

CodeMirror.cmp_pos = function (a, b) {
  return a.line - b.line || a.ch - b.ch;
};

CodeMirror.prototype.forward_sexpr = function (start) {

  var cm = this;
  var line = start.line;
  var pos = start.ch;
  var buf = cm.getLine(line);
  var depth = 0;
  var count = cm.lineCount();
  var ignore = [0];

  function next() {
    if (pos < buf.length) {
      return buf.charCodeAt(pos++);
    } else if (pos++ === buf.length) {
      return 10; // newline
    } else {
      line++;
      pos = 0;
      if (line >= count) {
        return -1; // EOF
      } else {
        buf = cm.getLine(line);
        if (pos < buf.length) {
          return buf.charCodeAt(pos++);
        } else {
          pos++;
          return 10; // newline
        }
      }
    }
  }

  function is_whitespace(c) {
    return (c <= 32); // " "
  }

  function is_comment(c) {
    return (c === 59); // ";"
  }

  function is_quote(c) {
    return (c === 39 || c === 96); // "'" or "`"
  }

  function is_comma(c) {
    return (c === 44); // ","
  }

  function is_string(c) {
    return (c === 34); // "\""
  }

  function is_quotedsym(c) {
    return (c === 124); // "|"
  }

  function is_open_paren(c) {
    return (c === 40 || c === 91 || c === 123); // "(" or "[" or "{"
  }

  function is_close_paren(c) {
    return (c === 41 || c === 93 || c === 125); // ")" or "]" or "}"
  }

  function is_alpha(c) {
    return ((c >= 65 && c <= 90) ||  // "A".."Z"
            (c >= 97 && c <= 122) || // "a".."z"
            c >= 128);               // non-ascii
  }

  function read_rest_of_token() {
    while (!(is_whitespace(c) ||
             is_comment(c) ||
             is_quote(c) ||
             is_comma(c) ||
             is_string(c) ||
             is_quotedsym(c) ||
             is_open_paren(c) ||
             is_close_paren(c) ||
             c < 0)) {
      c = next();
    }
  }

  var c = next();

  while (true) {

    if (c < 0) return false;

    // ignore whitespace

    if (is_whitespace(c)) {
      c = next();
      continue;
    }

    // ignore comments

    if (is_comment(c)) {
      c = next();
      while (c >= 0 && c !== 10) c = next(); // skip to newline
      if (c >= 0) {
        c = next();
      }
      continue;
    }

    // skip standard read-macros

    while (c >= 0) {
      if (is_quote(c)) {
        c = next();
      } else if (is_comma(c)) {
        c = next();
        if (c === 64) { // "@"
          c = next();
        }
      } else {
        break;
      }
    }

    // check for datums starting with "#"

    if (c === 35) { // "#"
      c = next();
      if (c === 102 || c === 115 || c === 117) { // "f" or "s" or "u"
        var kind = c;
        c = next();
        if (kind !== 102 && c === 56) { // "8"
          c = next();
          if (c === 40) { // "("
            c = next();
            depth++;
            continue;
          }
        } else if (kind !== 102 && c === 49) { // "1"
          c = next();
          if (c === 54) { // "6"
            c = next();
            if (c === 40) { // "("
              c = next();
              depth++;
              continue;
            }
          }
        } else if (c === 51) { // "3"
          c = next();
          if (c === 50) { // "2"
            c = next();
            if (c === 40) { // "("
              c = next();
              depth++;
              continue;
            }
          }
        } else if (c === 54) { // "6"
          c = next();
          if (c === 52) { // "4"
            c = next();
            if (c === 40) { // "("
              c = next();
              depth++;
              continue;
            }
          }
        }
      } else if (c === 92) { // "\\"
        c = next();
        if (!is_alpha(c)) {
          next();
          c = 32; // force end of token
        }
      } else if (c === 124) { // "|"
        var nest = 1;
        while (c >= 0 && nest > 0) {
          c = next();
          if (c === 35) { // "#"
            c = next();
            if (c === 124) { // "|"
              nest++;
            }
          } else {
            while (c === 124) { // "|"
              c = next();
              if (c === 35) { // "#"
                nest--;
                break;
              }
            }
          }
        }
        if (nest > 0) return false;
        c = next();
        continue;
      } else if (c === 59) { // ";"
        c = next();
        ignore[ignore.length-1]++;
        continue;
      }
      read_rest_of_token();
    } else if (is_string(c) || is_quotedsym(c)) {
      var delim = c;
      c = next();
      while (c >= 0 && c !== delim) {
        if (c === 92) { // "\\"
          c = next();
          if (c === delim) c = 32; // force progress
        } else {
          c = next();
        }
      }
      if (c !== delim) return false;
      c = next();
    } else if (is_open_paren(c)) {
      c = next();
      depth++;
      ignore.push(0);
      continue;
    } else if (is_close_paren(c)) {
      depth--;
      if (depth < 0) return false;
      if (ignore.pop() !== 0) return false;
      c = next();
    } else {
      read_rest_of_token();
    }

    // completed parsing of a datum

    if (ignore[ignore.length-1] > 0) {
      ignore[ignore.length-1]--;
    } else if (depth === 0) {
      return CodeMirror.Pos(line, pos-1);
    }
  }
};

//-----------------------------------------------------------------------------

// Local Variables:
// js-indent-level: 2
// indent-tabs-mode: nil
// End:
