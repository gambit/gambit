/* The ___P macro assembles a function prototype from ANSI text or K&R
    text as chosen at compile time.  The K&R text has a list of argument
    names and a list of declarations which must match.  Also the K&R and
    ANSI text must have the same number of declarations.  This program
    checks those.  Rather than comparing names or trying to parse C, it
    just counts commas and semicolons.  It uses parentheses and commas to
    determine the current part of the ___P macro call.

   A count of the commas is not the same as a count of the number of
    things between them.  If there are no commas, there may be one thing,
    but there may also be zero things.  We don't check for that yet.
*/

start {
  /* variables */		/* indices in stack frame */
  paren_depth = 0;		PAREN_DEPTH = 0;
  current_arg = 0;		CURRENT_ARG = 1;
  ansi_commas = 0;		ANSI_COMMAS = 2;
  kr_commas = 0;		KR_COMMAS = 3;
  kr_semicolons = 0;		KR_SEMICOLONS = 4;
  start_line = 0;
  error_header_printed = 0;
  trace = 0;			/* 0 = no trace, 1 = trace */
  stackpointer = 0;
  stackframes = list();
  check_namerules();
}
/* In this program the start state is always other. */
namerules {
  /./		other;
}

sub stack () {
  if (trace) { print ("\n", stackpointer, " -> ", paren_depth, " ",
    current_arg, " ", ansi_commas, " ", kr_commas, " ", kr_semicolons,
    "\n"); }
  stackframes[stackpointer] = list (paren_depth, current_arg, ansi_commas,
   kr_commas, kr_semicolons);
  stackpointer = stackpointer + 1;
}
sub unstack () {
  if (stackpointer == 0) {
    panic ("line ", $., "\tstack underflow");
  }
  stackpointer = stackpointer - 1;
  paren_depth = stackframes[stackpointer][PAREN_DEPTH];
  current_arg = stackframes[stackpointer][CURRENT_ARG];
  ansi_commas = stackframes[stackpointer][ANSI_COMMAS];
  kr_commas = stackframes[stackpointer][KR_COMMAS];
  kr_semicolons = stackframes[stackpointer][KR_SEMICOLONS];
  if (trace) { print ("\n", stackpointer, " <- ", paren_depth, " ",
    current_arg, " ", ansi_commas, " ", kr_commas, " ", kr_semicolons,
    "\n"); }
}

/* assume caller has read ___P((
   so we set current_arg = 1 and paren_depth to 2, getting us ready
    to read "ansi" below

   we want to read this argument structure
   1 2      1   2           1          0
   ( ( ansi ) , ( kr-commas ) kr-semis )

   if current_arg == 1 and paren_depth == 2 and comma seen, it's an ANSI
    comma
   if paren_depth == 1 and comma seen, it's the macro arg separating comma
    (ANSI before, K&R after)
   if current_arg == 2 and paren_depth == 2 and comma seen, it's a K&R
    comma
   if current_arg == 2 and paren_depth == 1 and semicolon seen, it's a K&R
    semicolon

   we don't check that the K&R commas come before or after the semicolons
   we do check that semicolons aren't allowed except as described above
   we allow commas other places, e.g. in pointer-to-function decls.  
   we don't check for missing parentheses (leading or trailing comma at
    depth 1, for example)

   we check that the macro ends with two args. (not less) and that no
    extra args appear -- checks are done as early as possible to try to
    give useful errors even if file ends early

   commas are separators, semicolons are terminators
   so ANSI commas should equal K&R commas
   but K&R semicolons should equal K&R commas + 1

   check for end of file?  TO DO

   check number of things in prototypes, instead of just number of commas?
    TO DO
*/

state ___P {
  BEGIN {
    paren_depth = 2;
    current_arg = 1;
    ansi_commas = 0;
    kr_commas = 0;
    kr_semicolons = 0;
    start_line = $.;
    stackpointer = 0;
    /* no change to error_header_printed */
    /* no change to trace */
    if (trace) { print (start_line, "-", $., "-___P(( "); }
  }

  /\(/ {
    paren_depth = paren_depth + 1;
    if (trace) { print (start_line, "-", $., "-( "); }
  }
  /\)/ {
    paren_depth = paren_depth - 1;
    if (trace) { print (start_line, "-", $., "-)"); }
    if (paren_depth == 0) {
      if (trace) { print ("depth 0\n"); }
      if (current_arg < 2) {
        panic (start_line, "\tmacro ended with ", current_arg, " arguments");
      }

      if (ansi_commas > 0 || kr_commas > 0 || kr_semicolons > 0) {
        if (ansi_commas != kr_commas || kr_semicolons != (kr_commas + 1)) {

          if (!error_header_printed) {
            print ("line\tANSI ,\tK&R ,\tK&R ;\n");
            error_header_printed = 1;
          }
          print (start_line); print ("\t");
          print (ansi_commas); print ("\t");
          print (kr_commas); print ("\t");
          print (kr_semicolons); print ("\n");
        }
      }
      if (stackpointer > 0) {
        unstack();
      } else {
        return;
      }
    }
    /* paren depth is not 0 */
    if (trace) { print (" "); }
  }

  /,/ {
    if (trace) { print (start_line, "-", $., "-,"); }
    if (paren_depth == 1) {
      current_arg = current_arg + 1;
      if (trace) { print ("arg "); }
      if (current_arg > 2) {
        panic (start_line, "\tmacro has at least ", current_arg, " arguments");
      }
    }
    if (paren_depth == 2 && current_arg == 1) {
      if (trace) { print ("ansi"); }
      ansi_commas = ansi_commas + 1;
    }
    if (paren_depth == 2 && current_arg == 2) {
      if (trace) { print ("kr"); }
      kr_commas = kr_commas + 1;
    }
    if (trace) { print (" "); }
  }

  /;/ {
    if (paren_depth == 1 && current_arg == 2) {
      if (trace) { print (start_line, "-", $., "-;kr "); }
      kr_semicolons = kr_semicolons + 1;
    } else {
        panic (start_line, "\tunexpected semicolon");
    }
  }

  /\<___P\(\(/ {
    stack();
    paren_depth = 2;
    current_arg = 1;
    ansi_commas = 0;
    kr_commas = 0;
    kr_semicolons = 0;
    /* no change to start_line */
    /* no change to error_header_printed or trace */
    /* no change to stackpointer */
  }
  /\<___P\(/ {
    panic ($., "\tunexpected ___P");
  }

  /./ {
  }
}

state comment {
  BEGIN {
    comment_start_line = $.;
  }

  /\*\\\// {
    if (trace) { print (comment_start_line, "-", $., "-*/ "); }
    return;
  }

  /./ {
  }
}
state string {
  BEGIN {
    string_start_line = $.;
  }
 
  /\\\\./ {
  }
  /"/ {
    if (trace) { print (string_start_line, "-", $., "-'' "); }
    return;
  }

  /./ {
  }
}

state other {
  /\<___PVOID\>/ {
  }
  /\<___P\(\(/ {
    call (___P);
  }
  /\<___P\(/ {
      panic ($., "\tunexpected ___P");
  }
  /*
  /\<___P/ {
      panic ($., "\tunexpected ___P");
  }
  */

  /\/\*/ {
    if (trace) { print ($., "-/* "); }
    call (comment);
  }
  /\"/ {
    if (trace) { print ($., "-`` "); }
    call (string);
  }

  /./ {
  }
}
