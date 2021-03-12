//=============================================================================

// File: "UI.js"

// Copyright (c) 2020-2021 by Marc Feeley, All Rights Reserved.

//=============================================================================

function G_UI(vm, elem) {

  var ui = this;

  if (!elem) {
    elem = document.createElement('div');
    document.body.appendChild(elem);
  } else if (typeof elem === 'string') {
    elem = document.querySelector(elem);
  }

  // Create console multiplexer

  var cons_mux = new G_Multiplexer(elem);

  cons_mux.get_more_menu_items = function () {

    var items = [];

    items.push(g_menu_item('New REPL', ['data-g-bold'], function (event) {
      cons_mux.focus();
      ui.new_repl();
    }));

    items.push(document.createElement('hr'));

    cons_mux.channels.forEach(function (channel) {
      var attrs = [];
      if (channel.needs_attention()) attrs.push('data-g-attention');
      items.push(g_menu_item(channel.get_title(), attrs, function (event) {
        ui.activate_console(channel);
      }));
    });

    return items;
  };

  ui.vm = vm;
  ui.cons_mux = cons_mux;
  ui.demo_commands = [];
  ui.demo_index = 0;
  ui.demo_timeoutId = null;

  // Redefine g_procedure2host to implement a bridge for JavaScript to
  // Scheme calls.  When a Scheme procedure is converted to a
  // JavaScript function using g_procedure2host, the JavaScript
  // function will return a promise which eventually resolves to the
  // result of the Scheme procedure (converted to JavaScript) or is
  // rejected with an Error when the Scheme procedure raises an
  // exception.

  g_procedure2host = function (proc_scm) {

    function fn() {
      var args = Array.prototype.slice.call(arguments);
      args.forEach(function (arg, i) { args[i] = g_host2scm(arg); });
      return g_async_call(true, // need result back
                          g_current_processor.slots[14], // in current thread
                          proc_scm,
                          args);
    }

    return fn;
  };

  g_async_call = function (need_result, thread_scm, proc_scm, args) {

    var promise = new Promise(function (resolve, reject) {

      function done(err, result) {
        if (err !== null) {
          //console.log('===== rejecting with');
          //console.log(err);
          reject(new Error(err));
        } else {
          //console.log('===== resolving with');
          //console.log(result);
          resolve(g_scm2host(result));
        }
      };

      args.unshift(proc_scm);               // procedure to call

      if (need_result) {
        args.unshift(g_function2scm(done)); // Scheme callback for result
      } else {
        args.unshift(g_host2scm(false));    // no result needed
        done(null, g_host2scm(void 0));     // pretend #!void returned
      }

      args.unshift(thread_scm);             // run in specific thread

      g_main_event_queue.write(args);
    });

    return promise;
  };

  // Patch continuation-next to properly undo dynamic binding environment.

  g_continuation_next = function (cont) {
    var frame = cont.frame;
    var denv = cont.denv;
    var ra = frame[0];
    var link = ra.link;
    var next_frame = frame[link];
    if (next_frame === void 0) {
      return false;
    } else {
      if (ra === g_bb2__23__23_dynamic_2d_env_2d_bind) {
        denv = frame[2];
      }
      return new G_Continuation(next_frame,denv);
    }
  };
}

G_UI.prototype.new_repl = function () {

  var ui = this;

  if (g_os_debug)
    console.log('G_UI().new_repl()');

  g_async_call(false,
               g_host2scm(false),
               g_glo['##new-repl'],
               []);
};

G_UI.prototype.add_console = function (dev) {

  var ui = this;

  if (g_os_debug)
    console.log('G_UI().add_console(...)');

  ui.cons_mux.add_channel(dev);

  if (ui.cons_mux.channels.length === 1) {
    dev.vm.ui.demo([
      8,
      0, '(display "hello world!\\n")   ;; automatic demo... click console to cancel',
      2, '(display "hello world!\\n")   ;; automatic demo... click console to cancel\n',
      5, null,
      0, '(import (srfi 28))   ;; use your favourite libraries and SRFIs\n',
      5, '(format "sqrt(2)=~a" (sqrt 2))\n',
      5, '(integer-sqrt (* 2 (expt 100 100)))   ;; fast bignum support\n',
      5, '(define (fact n) (if (= n 0) 1 (* n (fact (- n 1)))))\n',
      5, '(time (fact 500))\n',
      8, null,
      0, '(define (tail n) (if (> n 0) (tail (- n 1)) \'done))   ;; proper tail calls\n',
      2, '(tail 1000000)   ;; no stack overflows when tail calling!\n',
      9, '(define k #f)\n',
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
      1, '(define prompt \\prompt)   ;; import JavaScript\'s prompt function',
      2, '(define prompt \\prompt)   ;; import JavaScript\'s prompt function\n',
      1, 'prompt',
      2, 'prompt\n',
      1, '(display (format "hello ~a!\\n" (prompt "your name please?")))',
      2, '(display (format "hello ~a!\\n" (prompt "your name please?")))\n',
      2, '(define (insert elem pos html) \\(`elem).insertAdjacentHTML(`pos, `html))\n',
      2, '(define (get id) \\document.getElementById(`id))\n',
      2, '(define (before id html) (insert (get id) "beforebegin" html))\n',
      2, '(before "ui" "<h1 id=\\"msg\\">Hello</h1>")\n',
      2, '(define (end id html) (insert (get id) "beforeend" html))\n',
      1,
      (g_os_web_origin.indexOf('://gambitscheme.org/') > 0
       ? '(end "msg" " Gambit Schemers!")\n'
       : '(end "msg" " Schemers!")\n'),
      8, '\\document.getElementById("msg").innerHTML=""\n',
      1, null,
      '(define (create-thread id)   ;; green threads are supported\n',
      '    (thread-start!\n',
      '     (make-thread\n',
      '      (lambda ()\n',
      '        (before "ui" (string-append "<h3 id=\\"" id "\\">" id ":</h3>"))\n',
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

G_UI.prototype.remove_console = function (dev, tab_only) {

  var ui = this;

  if (g_os_debug)
    console.log('G_UI().remove_console(..., '+tab_only+')');

  ui.cons_mux.remove_channel(dev, tab_only);
};

G_UI.prototype.activate_console = function (dev) {

  var ui = this;

  if (g_os_debug)
    console.log('G_UI().activate_console(...)');

  ui.cons_mux.activate_channel(dev);
};

G_UI.prototype.send_to_active_console = function (text) {

  var ui = this;

  if (g_os_debug)
    console.log('G_UI().send_to_active_console(\''+text+'\')');

  var cons_mux = ui.cons_mux;
  var tab_index = cons_mux.tg.active_tab_index();

  if (tab_index >= 0) {
    var dev = cons_mux.tabs[tab_index];
    dev.focus();
    dev.cons.send(text);
  }
};

G_UI.prototype.demo = function (commands) {

  var ui = this;

  function next() {
    if (ui.demo_index < 0 || ui.demo_index >= ui.demo_commands.length) {
      ui.demo_cancel();
    } else {

      var command = ui.demo_commands[ui.demo_index++];

      var delay = (typeof command === 'number') ? command*1000 : 10;
      ui.demo_timeoutId = setTimeout(next, delay);

      if (command === null || typeof command === 'string') {
        ui.send_to_active_console(command);
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

G_UI.prototype.demo_cancel = function () {

  var ui = this;

  if (ui.demo_timeoutId !== null) {
    clearTimeout(ui.demo_timeoutId);
    ui.demo_timeoutId = null;
  }

};

//-----------------------------------------------------------------------------

function G_Multiplexer(elem) {

  var mux = this;

  mux.elem = elem;
  elem.classList.add('g-multiplexer');
  mux.init();
}

G_Multiplexer.prototype.init = function () {

  var mux = this;

  mux.channels = [];
  mux.tabs = [];
  mux.mra = []; // most recently active tabs
  mux.max_nb_tabs = 999999;

  mux.get_more_menu_items = function () { return []; };

  var tg = new G_Tab_group(mux.elem);

  mux.tg = tg;

  tg.clicked_tab = function (index, event) { mux.clicked_tab(index, event); };

  tg.add_pane('+');
};

G_Multiplexer.prototype.max_nb_tabs_set = function (max_nb_tabs) {

  var mux = this;

  mux.max_nb_tabs = max_nb_tabs;
};

G_Multiplexer.prototype.focus = function () {

  var mux = this;

  if (g_os_debug)
    console.log('G_Multiplexer().focus()');

  var tab_index = mux.tg.active_tab_index();

  if (tab_index >= 0) {
    mux.tabs[tab_index].focus();
  }
};

G_Multiplexer.prototype.clicked_tab = function (tab_index, event) {

  var mux = this;

  function hide_menu(elem) {
    mux.focus();
    elem.removeAttribute('data-g-dropdown-menu-show');
    while (elem.childNodes.length > 1) {
      elem.removeChild(elem.lastChild);
    }
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
    if (tab_index === tg.nb_tabs()-1) {

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

G_Multiplexer.prototype.shrink_nb_tabs = function (n) {

  var mux = this;

  while (mux.tabs.length > n) {
    mux.remove_channel(mux.tabs[mux.mra[mux.tabs.length-1]], true);
  }
};

G_Multiplexer.prototype.add_channel = function (channel, become_active) {

  var mux = this;

  if (g_os_debug)
    console.log('G_Multiplexer().add_channel('+channel.get_title()+', '+become_active+')');

  var title = channel.get_title();
  var i = mux.index_of_channel_by_title(title);

  mux.channels.splice(i, 0, channel);

  if (mux.tabs.length === 0) become_active = true;

  var tg = mux.tg;

  if (become_active || mux.tabs.length < mux.max_nb_tabs) {

    mux.shrink_nb_tabs(mux.max_nb_tabs-1);
    mux.tabs.push(channel);
    i = tg.add_pane(title, channel.get_elem(), -2);
    if (become_active) {
      mux.mra.splice(0, 0, i);
      tg.active_tab_set(i);
    } else {
      mux.mra.push(i);
    }

  } else {
    tg.add_pane(null, channel.get_elem());
  }

  if (become_active) {
    mux.activate_channel(channel);
    channel.focus();
  }

  if (g_os_debug) {
    console.log('mux.mra and mux.tabs:');
    console.log(mux.mra);
    console.log(mux.tabs);
    console.log(mux.channels);
  }
};

G_Multiplexer.prototype.remove_channel = function (channel, tab_only) {

  var mux = this;

  if (g_os_debug)
    console.log('G_Multiplexer().remove_channel('+channel.get_title()+', '+tab_only+')');

  if (!tab_only) {
    var i = mux.index_of_channel(channel);
    if (i >= 0) mux.channels.splice(i, 1);
  }

  var tab_index = mux.index_of_channel_tab(channel);

  if (tab_index >= 0) {
    var tabs = mux.tabs;
    var mra = mux.mra;
    tabs.splice(tab_index, 1);
    mra.splice(mra.indexOf(tab_index), 1);
    for (var j=0; j<mra.length; j++) {
      if (mra[j] > tab_index) mra[j]--;
    }
    mux.tg.remove_tab(tab_index);
    if (tab_index === mux.tg.active_tab_index()) {
      if (tabs.length > 0) {
        mux.activate_channel(tabs[mra[0]]);
      }
    }
  }

  if (g_os_debug) {
    console.log('mux.mra and mux.tabs:');
    console.log(mux.mra);
    console.log(mux.tabs);
    console.log(mux.channels);
  }
};

G_Multiplexer.prototype.activate_channel = function (channel) {

  var mux = this;
  var tab_index = mux.index_of_channel_tab(channel);
  var tg = mux.tg;

  if (g_os_debug)
    console.log('G_Multiplexer().activate_channel('+channel.get_title()+')');

  if (tab_index !== tg.active_tab_index()) {

    var mra = mux.mra;

    if (tab_index >= 0) {
      mra.splice(mra.indexOf(tab_index), 1);
    } else {
      tab_index = tg.add_pane(channel.get_title(), channel.get_elem(), -2);
      mux.tabs.splice(tab_index, 0, channel);
    }

    mra.splice(0, 0, tab_index);
    tg.active_tab_set(tab_index);
    channel.focus();
  }

  if (g_os_debug) {
    console.log('mux.mra and mux.tabs:');
    console.log(mux.mra);
    console.log(mux.tabs);
    console.log(mux.channels);
  }
};

G_Multiplexer.prototype.index_of_channel = function (channel) {

  var mux = this;
  var channels = mux.channels;
  var i = 0;

  while (i < channels.length) {
    if (channel === channels[i]) return i;
    i++;
  }

  return -1;
};

G_Multiplexer.prototype.index_of_channel_tab = function (channel) {

  var mux = this;
  var tabs = mux.tabs;
  var i = 0;

  while (i < tabs.length) {
    if (channel === tabs[i]) return i;
    i++;
  }

  return -1;
};

G_Multiplexer.prototype.index_of_channel_by_title = function (title) {

  var mux = this;
  var channels = mux.channels;
  var i = 0;

  while (i < channels.length) {
    if (title < channels[i].get_title()) break;
    i++;
  }

  return i;
};

//-----------------------------------------------------------------------------

function G_Tab_group(elem) {

  var tg = this;

  tg.elem = elem;
  elem.classList.add('g-tab-group');
  tg.init();
}

G_Tab_group.prototype.init = function () {

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

G_Tab_group.prototype.clear = function () {
  var tg = this;
  tg.elem.innerHTML = ''; // remove all children
  tg.tab_names = [];
};

G_Tab_group.prototype.index_of_tab = function (name) {
  var tg = this;
  return tg.tab_names.indexOf(name);
};

G_Tab_group.prototype.index_of_tab_elem = function (elem) {
  var tg = this;
  for (var i=tg.nb_tabs()-1; i>=0; i--) {
    if (elem === tg.tab_elem(i))
      return i;
  }
  return -1;
};

G_Tab_group.prototype.tab_elem = function (index) {
  var tg = this;
  return tg.elem.firstChild.children[index];
};

G_Tab_group.prototype.pane_elem = function (index) {
  var tg = this;
  return tg.elem.lastChild.children[index];
};

G_Tab_group.prototype.extra_elem = function () {
  var tg = this;
  return tg.elem.firstChild.lastChild;
};

G_Tab_group.prototype.set_tab_name = function (index, name) {
  var tg = this;
  var tabs_elem = tg.elem.firstChild;
  tabs_elem.children[index].firstChild.firstChild.innerText = name;
  tg.tab_names[index] = name;
};

G_Tab_group.prototype.remove_tab = function (tab_index) {

  var tg = this;

  var tabs_elem = tg.elem.firstChild;
  var panes_elem = tg.elem.lastChild;

  tabs_elem.children[tab_index].remove();

  var pane_elem = panes_elem.children[tab_index];
  pane_elem.remove();
  panes_elem.appendChild(pane_elem);

  tg.tab_names.splice(tab_index, 1);
};

G_Tab_group.prototype.add_pane = function (tab_name, pane_elem, tab_index) {

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
      var index = tg.index_of_tab_elem(tab_elem);
      if (index >= 0) tg.clicked_tab(index, event);
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

G_Tab_group.prototype.nb_tabs = function () {
  var tg = this;
  return tg.tab_names.length;
};

G_Tab_group.prototype.active_tab_index = function () {
  var tg = this;
  return tg.act_tab_index;
};

G_Tab_group.prototype.active_tab_set = function (index) {

  var tg = this;

  var tab_elem = tg.elem.firstChild.querySelector(':scope > li[data-active]');
  if (tab_elem) tab_elem.removeAttribute('data-active');

  var pane_elem = tg.elem.lastChild.querySelector(':scope > div[data-active]');
  if (pane_elem) pane_elem.removeAttribute('data-active');

  if (index >= 0) {
    tg.tab_elem(index).setAttribute('data-active', '');
    tg.pane_elem(index).setAttribute('data-active', '');
    tg.act_tab_index = index;
  } else {
    tg.act_tab_index = -1;
  }
};

//-----------------------------------------------------------------------------

function G_Device_console(vm, title, flags, thread_scm) {

  var dev = this;
  dev.vm = vm;
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

  dev.mux = null;
  dev.focused = false;
  dev.dirty = false;

  dev.thread_scm = thread_scm;
  dev.elem = document.createElement('div');
  dev.cons = new Console(dev.elem);

  dev.cons.connect(dev);

  vm.ui.add_console(dev);
}

G_Device_console.prototype.console_writable = function (cons) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').console_writable(...)');

  dev.cons = cons;
  cons.write(dev.delayed_output);
  dev.delayed_output = '';
};

G_Device_console.prototype.console_readable = function (cons) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').console_readable(...)');

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
    g_os_condvar_ready_set(condvar_scm, true);
  }
};

G_Device_console.prototype.console_user_interrupt = function (cons) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').console_user_interrupt(...)');

  dev.cons = cons;

  dev.vm.heartbeat_count = 1; // force interrupt at next poll point

  g_async_call(false,
               dev.thread_scm,
               g_glo['##user-interrupt!'],
               []);
};

G_Device_console.prototype.console_terminate_thread = function (cons) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').console_terminate_thread(...)');

  dev.cons = cons;

  g_async_call(false,
               g_host2scm(false),
               g_glo['##thread-terminate!'],
               [dev.thread_scm]);
};

G_Device_console.prototype.input_add = function (input) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').input_add(\''+input+'\')');

  var len = dev.rbuf.length-dev.rlo;
  var inp = dev.encoder.encode(input);
  if (dev.echo) dev.output_add_buffer(inp); // echo the input
  var newbuf = new Uint8Array(len + inp.length);
  newbuf.set(newbuf.subarray(dev.rlo, dev.rlo+len));
  newbuf.set(inp, len);
  dev.rbuf = newbuf;
  dev.rlo = 0;
};

G_Device_console.prototype.output_add = function (output) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').output_add(\''+output+'\')');

  dev.output_add_buffer(dev.encoder.encode(output));
};

G_Device_console.prototype.output_add_buffer = function (buffer) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').output_add_buffer(...)');

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

G_Device_console.prototype.read = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;
  var n = hi-lo;
  var have = dev.rbuf.length-dev.rlo;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').read(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  g_os_condvar_ready_set(dev_condvar_scm, false);

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

G_Device_console.prototype.write = function (dev_condvar_scm, buffer, lo, hi) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').write(...,['+buffer.slice(0,10)+'...],'+lo+','+hi+')');

  dev.output_add_buffer(buffer.subarray(lo, hi));

  return hi-lo;
};

G_Device_console.prototype.force_output = function (dev_condvar_scm, level) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').force_output(...,'+level+')');

  return 0; // no error
};

G_Device_console.prototype.seek = function (dev_condvar_scm, pos, whence) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').seek(...,'+pos+','+whence+')');

  return -1; // EPERM (operation not permitted)
};

G_Device_console.prototype.width = function (dev_condvar_scm) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').width()');

  var cm = dev.cons.cm;
  var charWidth = cm.defaultCharWidth();
  var scrollInfo = cm.getScrollInfo();
  var width = Math.floor(scrollInfo.clientWidth / charWidth) - 1;

  if (width < 20) width = 20;

  return width;
};

G_Device_console.prototype.close = function (direction) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').close('+direction+')');

  return 0; // no error
};

G_Device_console.prototype.get_title = function () {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').get_title()');

  return dev.title;
};

G_Device_console.prototype.needs_attention = function () {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').needs_attention()');

  return !dev.focused && dev.dirty;
};

G_Device_console.prototype.focus = function () {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').focus()');

  dev.focused = true;
  dev.cons.focus();
};

G_Device_console.prototype.blur = function () {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').blur()');

  dev.focused = false;
  dev.dirty = false;
  dev.cons.blur();
};

G_Device_console.prototype.connect_multiplexer = function (mux) {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').connect_multiplexer(...)');

  dev.mux = mux;
};

G_Device_console.prototype.disconnect_multiplexer = function () {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').disconnect_multiplexer()');

  dev.mux = null;
};

G_Device_console.prototype.get_menu_items = function () {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').get_menu_items()');

  var items = [];

//  items.push(g_menu_item('Close tab', [], function (event) {
//    console.log('close tab ' + dev.title);
//    dev.vm.ui.remove_console(dev, true);
//  }));

  items.push(g_menu_item('Interrupt thread', [], function (event) {
    dev.cons.user_interrupt();
  }));

  if (dev.title !== '#<thread #1 primordial>') {
    items.push(g_menu_item('Terminate thread', [], function (event) {
      dev.cons.terminate_thread();
    }));
  }

  return items;
};

G_Device_console.prototype.get_elem = function () {

  var dev = this;

  if (g_os_debug)
    console.log('G_Device_console(\''+dev.title+'\').get_elem()');

  return dev.elem;
};

function g_menu_item(title, attrs, handler) {
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
      'Enter':  function (cm) { cons.enter(); }
    }
  };

  elem.classList.add('console');
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
  className: 'console_transcript',
  inclusiveLeft: false,
  inclusiveRight: false,
  atomic: true,
  selectLeft: false
};

Console.prototype.input_opts = {
  className: 'console_input',
  inclusiveLeft: true,
  inclusiveRight: false
};

Console.prototype.output_opts = {
  className: 'console_output',
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
  if (cons.peer) cons.peer.console_user_interrupt(cons);
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

// Local Variables:
// js-indent-level: 2
// indent-tabs-mode: nil
// End:
