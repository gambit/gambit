//=============================================================================

// File: "UI.js"

// Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

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
      5, null,
      0, '(import (srfi 28))   ;; import SRFI 28\n',
      4, '(format "sqrt(2)=~a" (sqrt 2))\n',
      8, '(import (angle))     ;; import R7RS library from "angle/angle.sld"\n',
      4, '(map deg->rad \'(0 90 180 270 360))\n',
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
      1, '(host-eval "Math.random()")  ;; interface to JavaScript code',
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
      4, null,
      0, '##initial-current-directory  ;; initial CWD is the web server document root\n',
      1, '(define path (path-expand "UI.css" ##initial-current-directory))\n',
      1, 'path\n',
      3, '(substring (read-file-string path) 0 70)  ;; read file from web server\n',
      5, '\\_os_whitelist_add("https://raw.githubusercontent.com/")  ;; allow reading from this domain\n',
      5, '(println (read-file-string "https://raw.githubusercontent.com/feeley/fib/master/README.md"))  ;; get a file\n',
      5, '(load "https://raw.githubusercontent.com/feeley/fib/master/fib.scm")  ;; load code from github\n',
      5, '(println (read-file-string "https://raw.githubusercontent.com/feeley/fib/master/fib.scm"))  ;; show code\n',
      8, null,
      '(define (create-thread id)   ;; green threads are supported\n',
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
The left area is the REPL where interaction\n\
with the interpreter takes place. The right\n\
area allows creating and editing files that are\n\
local to the browser and accessible to Scheme\n\
code as files in the root directory, i.e. "/".\n\
The files will persist in the browser between\n\
sessions.\n\
\n\
By default a demo will automatically start\n\
after a few seconds. The demo can be stopped\n\
by clicking inside the REPL. The demo can also\n\
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

  var last_dir_sep = path.lastIndexOf('/');

  if (last_dir_sep > 0) {
    try {
      ui.fs.mkdirSync(path.slice(0, last_dir_sep), { recursive: true });
    } catch (exn) {
      // ignore existing directory
    }
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

Device_console.prototype.input_add = function (input) {

  var dev = this;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').input_add(\''+input+'\')');

  var len = dev.rbuf.length-dev.rlo;
  var inp = dev.encoder.encode(input);
  if (dev.echo) dev.output_add_buffer(inp); // echo the input
  var newbuf = new Uint8Array(len + inp.length);
  newbuf.set(newbuf.subarray(dev.rlo, dev.rlo+len));
  newbuf.set(inp, len);
  dev.rbuf = newbuf;
  dev.rlo = 0;
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
  var n = hi-lo;
  var have = dev.rbuf.length-dev.rlo;

  if (dev.debug)
    console.log('Device_console(\''+dev.title+'\').read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  dev.vm.os_condvar_ready_set(dev_condvar_scm, false);

  if (have === 0) {

    if (dev.rlo === 0) {
      dev.rbuf = new Uint8Array(1); // prevent repeated EOF
      dev.rlo = 1;
      return 0; // signal EOF

    } else {

      // Input will be received asynchronously

      if (dev.read_condvar_scm === null) {
        dev.read_condvar_scm = dev_condvar_scm;
      }

      return -35; // return EAGAIN to suspend Scheme thread on condvar
    }
  }

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
      'Enter':  function (cm) { cons.enter(); },
      'Tab':    function (cm) { cons.tab(); }
    }
  };

  elem.classList.add('g-console');
  cons.cm = CodeMirror(elem, cm_opts);
  cons.id = elem.id || 'DefaultConsole';
  cons.doc = cons.cm.getDoc();
  cons.transcript_marker = null;
  cons.input_buffer = [];
  cons.eof = false;
  cons.peer = null;
  cons.history_max_length = 1000;
  cons.restore_history();
}

Console.prototype.transcript_opts = {
  className: 'g-console-transcript',
  inclusiveLeft: false,
  inclusiveRight: false,
  atomic: true,
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

Console.prototype.line0ch0 = { line: 0, ch: 0 };
Console.prototype.line0ch1 = { line: 0, ch: 1 };

Console.prototype.end_of_doc = function () {
  var cons = this;
  return cons.doc.posFromIndex(Infinity);
};

Console.prototype.read = function () {
  var cons = this;
  if (cons.input_buffer.length > 0) {
    return cons.input_buffer.shift();
  } else {
    return null;
  }
};

Console.prototype.write = function (text) {
  var cons = this;
  if (text.length > 0) {

    var pos;
    var insert_marker;

    if (cons.transcript_marker) {
      pos = cons.transcript_marker.find().to;
      cons.transcript_marker.clear();
    } else {
      pos = cons.line0ch0;
    }

    cons.doc.replaceRange('_', pos, pos);

    var right_of_pos = { line: pos.line, ch: pos.ch+1 };
    var insert_marker = cons.doc.markText(pos,
                                          right_of_pos,
                                          cons.output_opts);

    cons.doc.replaceRange(text, pos, pos);

    pos = insert_marker.find().to;
    var left_of_pos = { line: pos.line, ch: pos.ch-1 };
    cons.doc.replaceRange('', left_of_pos, pos);
    cons.transcript_marker = cons.doc.markText(cons.line0ch0,
                                               left_of_pos,
                                               cons.transcript_opts);
    cons.cm.scrollIntoView(null); // scroll cursor into view
  }
};

Console.prototype.accept_input = function () {

  var cons = this;
  var pos;

  if (cons.transcript_marker) {
    pos = cons.transcript_marker.find().to;
    cons.transcript_marker.clear();
  } else {
    pos = cons.line0ch0;
  }

  var end = cons.end_of_doc();
  var input = cons.doc.getRange(pos, end);

  if (end.line > 0 || end.ch > 0) {

    cons.doc.markText(pos, end, cons.input_opts);

    cons.transcript_marker = cons.doc.markText(cons.line0ch0,
                                               end,
                                               cons.transcript_opts);
  }

  cons.write('\n');

  return input;
};

Console.prototype.clear_transcript = function () {

  var cons = this;

  if (cons.transcript_marker) {
    var pos = cons.transcript_marker.find().to;
    if (pos.line > 0) {
      var bol = { line: pos.line, ch: 0 };
      cons.doc.replaceRange('', cons.line0ch0, bol);
      if (pos.ch === 0) cons.transcript_marker = null;
    }
  }
};

Console.prototype.delete_forward = function () {

  var cons = this;
  var pos;

  if (cons.transcript_marker) {
    pos = cons.transcript_marker.find().to;
  } else {
    pos = cons.line0ch0;
  }

  var end = cons.end_of_doc();

  if (pos.line === end.line && pos.ch === end.ch) {
    cons.add_input(''); // signal EOF
  } else {
    cons.cm.execCommand('delCharAfter');
  }
};

Console.prototype.enter = function () {
  var cons = this;
  var input = cons.accept_input();
  if (input.length > 0) {
    cons.history[cons.history.length-1] = input;
    cons.save_history();
  }
  cons.restore_history();
  cons.add_input(input + '\n');
};

Console.prototype.tab = function () {
  var cons = this;
  cons.cm.execCommand('indentAuto');
};

Console.prototype.add_input = function (text) {
  var cons = this;
  cons.input_buffer.push(text);
  cons.readable();
};

Console.prototype.connect = function (peer) {
  var cons = this;
  cons.peer = peer;
  cons.writable();
  if (cons.input_buffer.length > 0) cons.readable();
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
  var pos;

  if (cons.transcript_marker) {
    pos = cons.transcript_marker.find().to;
  } else {
    pos = cons.line0ch0;
  }

  var end = cons.end_of_doc();
  var input = cons.doc.getRange(pos, end);

  cons.history[cons.history_pos] = input;

  cons.doc.replaceRange(text, pos, end);
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
      cons.enter();
      start = end+1;
    }
    cons.change_input(text.slice(start, text.length));
  }
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
