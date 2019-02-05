/* File: "main.c" */

/* Copyright (c) 1994-2017 by Marc Feeley, All Rights Reserved. */

/* This is the driver of the Gambit system */

#define ___INCLUDED_FROM_MAIN
#define ___VERSION 409003
#include "gambit.h"

#include "os_setup.h"
#include "os_base.h"
#include "os_shell.h"
#include "setup.h"


/*---------------------------------------------------------------------------*/


___HIDDEN ___UCS_2 gambopt_env_name[] =
{ 'G', 'A', 'M', 'B', 'O', 'P', 'T', '\0' };

#ifdef ___DEFAULT_RUNTIME_OPTIONS
___HIDDEN ___UCS_2 default_runtime_options[] = ___DEFAULT_RUNTIME_OPTIONS;
#endif

___HIDDEN ___SCMOBJ usage_err
   ___P((int debug_settings),
        (debug_settings)
int debug_settings;)
{
  ___GSTATE->setup_params.debug_settings = debug_settings;

  if (___DEBUG_SETTINGS_LEVEL(debug_settings) != 0)
    {
      char *msgs[2];
      msgs[0] =
        "Usage: program [-:OPTION,OPTION...] ...\n"
        "where OPTION is one of:\n"
        "  mHEAPSIZE       set minimum heap size in kilobytes\n"
        "  hHEAPSIZE       set maximum heap size in kilobytes\n"
        "  lLIVEPERCENT    set heap live ratio after GC in percent\n"
#ifndef ___SINGLE_THREADED_VMS
        "  pLEVEL          set parallelism level (default = 50% of cpus)\n"
#endif
        "  s|S             set standard Scheme mode (on|off)\n"
        "  d[OPT...]       set debugging options; OPT is one of:\n"
        "                    p|a       treat uncaught exceptions as errors\n"
        "                              (primordial-thread only|all threads)\n"
        "                    r|s|q     error handling (create a new REPL|start in\n"
        "                              single-step mode|quit with error status)\n"
        "                    R|D|Q     user interrupt handling (create a new REPL|\n"
        "                              defer handling|quit with error status)\n"
        "                    i|c|-|@[HOST][:PORT]\n"
        "                              select REPL interaction channel (ide|console|\n"
        "                              standard input and output|remote debugger\n"
        "                              (defaults: HOST=127.0.0.1, PORT=44555))\n"
        "                    0..9      verbosity level\n"
        "  @[INTF][:PORT]  set main RPC server configuration; defaults: INTF=127.0.0.1,\n"
        "                  PORT=44556; when INTF=* all interfaces accept connections\n"
        "  =DIRECTORY      override central Gambit installation directory\n"
        "  ~~DIR=DIRECTORY override Gambit installation directory ~~DIR (where DIR can\n"
        "                  be the special \"bin\" and \"lib\", or empty, or any identifier)\n"
        "  +ARGUMENT       add ARGUMENT to the command line before other arguments\n"
        "  f[OPT...]       set file options; see below for OPT\n"
        "  t[OPT...]       set terminal options; see below for OPT\n"
        "  -[OPT...]       set standard input and output options; see below for OPT\n"
        "where OPT is one of:\n"
        "  A|1|2|4|6|8|U   character encoding (ASCII|ISO-8859-1|UCS-2/4|UTF-16/8|UTF)\n"
        "  l|c|cl          end-of-line encoding (LF|CR|CR-LF)\n"
        "  u|n|f           buffering (unbuffered|newline buffered|fully buffered)\n"
        "  r|R             enable character encoding errors (on|off)\n"
        "  e|E             [for terminals only] enable line-editing (on|off)\n";
      msgs[1] = 0;
      ___display_error (msgs);
    }

  return ___FIXADD(___FIX(___EXIT_CODE_USAGE),___FIX(1));
}


___HIDDEN ___UCS_2STRING extract_string
   ___P((___UCS_2STRING *start),
        (start)
___UCS_2STRING *start;)
{
  ___UCS_2 c;
  ___UCS_2STRING p1 = *start;
  ___UCS_2STRING p2;
  int n = 0;
  ___UCS_2STRING result;

  while ((c = *p1) != '\0' && (c != ',' || p1[1] == ','))
    {
      p1++;
      if (c == ',')
        p1++;
      n++;
    }

  p2 = *start;
  *start = p1;

  result = ___CAST(___UCS_2STRING,
                   ___ALLOC_MEM((n+1) * sizeof (___UCS_2)));

  if (result != 0)
    {
      p1 = result;
      while ((c = *p2) != '\0' && (c != ',' || p2[1] == ','))
        {
          p2++;
          if (c == ',')
            p2++;
          *p1++ = c;
        }
      *p1++ = '\0';
    }

  return result;
}


___HIDDEN ___BOOL extend_strvec
   ___P((___UCS_2STRING **strvec,
         int pos,
         int nb_to_add,
         ___BOOL free_old),
        (strvec,
         pos,
         nb_to_add,
         free_old)
___UCS_2STRING **strvec;
int pos;
int nb_to_add;
___BOOL free_old;)
{
  int i;
  int n = 0;
  ___UCS_2STRING *old_strvec = *strvec;
  ___UCS_2STRING *new_strvec;

  if (old_strvec != 0)
    while (old_strvec[n] != 0) n++;

  new_strvec = ___CAST(___UCS_2STRING*,
                       ___ALLOC_MEM((n+nb_to_add+1) * sizeof (___UCS_2STRING)));

  if (new_strvec == 0)
    return 0;

  for (i=pos; i<n; i++)
    new_strvec[i+nb_to_add] = old_strvec[i];

  for (i=0; i<pos; i++)
    new_strvec[i] = old_strvec[i];

  new_strvec[n+nb_to_add] = 0;

  *strvec = new_strvec;

  if (free_old)
    ___FREE_MEM(old_strvec);

  return 1;
}


int ___main
   ___P((___mod_or_lnk (*linker)(___global_state)),
        (linker)
___mod_or_lnk (*linker)();)
{
#define LARGEST_ULONG (unsigned long)(~___CAST(unsigned long,0))

  ___UCS_2STRING *argv;
  ___UCS_2STRING *current_argv;
  ___UCS_2STRING cmd_line_runtime_options;
  ___UCS_2STRING script_line;
  int extra_arg_pos;
  int contract_argv;
  int options_source;
  int options_source_min;
  int options_source_max;
  ___UCS_2STRING gambitdir;
  ___UCS_2STRING *gambitdir_map;
  int gambitdir_map_len;
  ___UCS_2STRING gambopt;
  ___UCS_2STRING remote_dbg_addr;
  ___UCS_2STRING rpc_server_addr;
  unsigned long min_heap_len;
  unsigned long max_heap_len;
  int live_percent;
  int parallelism_level;
  int standard_level;
  int debug_settings;
  int file_settings;
  int terminal_settings;
  int stdio_settings;
  ___SCMOBJ e;
  ___setup_params_struct setup_params;

  /* handle arguments to runtime */

  argv = ___program_startup_info.argv;
  contract_argv = 0;
  gambitdir = 0;
  gambitdir_map = 0;
  gambitdir_map_len = 0;
  gambopt = 0;
  cmd_line_runtime_options = 0;
  remote_dbg_addr = 0;
  rpc_server_addr = 0;
  min_heap_len = 0;
  max_heap_len = 0;
  live_percent = 0;
#ifdef ___SINGLE_THREADED_VMS
  parallelism_level = 1;
#else
  {
    int count = ___cpu_count ();
    if (count < 1) count = 1;
    parallelism_level = ___CEILING_DIV(count*50,100); /* default = 50% */
  }
#endif
  standard_level = 0;
  debug_settings = ___DEBUG_SETTINGS_INITIAL;
  file_settings = ___FILE_SETTINGS_INITIAL;
  terminal_settings = ___TERMINAL_SETTINGS_INITIAL;
  stdio_settings = ___STDIO_SETTINGS_INITIAL;

  /*
   * Runtime options can come from several sources:
   *
   * - the default runtime options (as specified to the configure script)
   * - the environment variable GAMBOPT
   * - the script line
   * - the first command line argument if it is of the form -:XXX
   *
   * When a source of runtime options starts with a colon it is the
   * sole source of runtime options and the first command line
   * argument will not be processed specially, even if it is of the
   * form -:XXX).  Otherwise the runtime options are accumulated from
   * all the sources of runtime options.
   */

#ifdef ___DEFAULT_RUNTIME_OPTIONS
  if (default_runtime_options[0] == ':')
    {
      options_source_min = 0;
      options_source_max = 0;
    }
  else
#endif
    {
      if ((e = ___getenv_UCS_2 (gambopt_env_name, &gambopt))
          != ___FIX(___NO_ERR))
        goto after_setup;

      if (gambopt != 0 &&
          gambopt[0] == ':')
        {
          options_source_min = 1;
          options_source_max = 1;
        }
      else
        {
          if ((script_line = ___program_startup_info.script_line) != 0)
            {
              for (;;)
                {
                  if (*script_line == '\0')
                    {
                      script_line = 0;
                      break;
                    }
                  if (script_line[0] == ' '
                      && script_line[1] == '-'
                      && script_line[2] == ':')
                    {
                      script_line += 3;
                      break;
                    }
                  script_line++;
                }
            }

          if (script_line != 0 &&
              script_line[0] == ':')
            {
              options_source_min = 2;
              options_source_max = 2;
            }
          else
            {
              options_source_min = 0;

              if (argv != 0
                  && (cmd_line_runtime_options = argv[1]) != 0
                  && cmd_line_runtime_options[0] == '-'
                  && cmd_line_runtime_options[1] == ':')
                {
                  cmd_line_runtime_options += 2;
                  contract_argv = 1;

                  if (cmd_line_runtime_options[0] == ':')
                    options_source_min = 3;

                  options_source_max = 3;
                }
              else
                options_source_max = 2;
            }
        }
    }

  current_argv = argv;
  extra_arg_pos = 1;

  for (options_source = options_source_min;
       options_source <= options_source_max;
       options_source++)
    {
      ___UCS_2STRING arg;

      if (options_source == 0)
#ifdef ___DEFAULT_RUNTIME_OPTIONS
        arg = default_runtime_options;
#else
        continue;
#endif
      else if (options_source == 1)
        {
          if ((e = ___getenv_UCS_2 (gambopt_env_name, &gambopt))
              != ___FIX(___NO_ERR))
            goto after_setup;
          arg = gambopt;
        }
      else if (options_source == 2)
        arg = script_line;
      else
        arg = cmd_line_runtime_options;

      if (arg == 0)
        continue;

      if (arg[0] == ':')
        arg++;

      do
        {
          ___UCS_2STRING s = arg++;
          switch (*s)
            {
            case 'm':
            case 'h':
            case 'l':
            case 'p':
              {
                unsigned long argval = 0;
                int neg = *arg == '-';
                if (neg && *s == 'p' && arg[1] >= '0' && arg[1] <= '9')
                  arg++;
                while (*arg >= '0' && *arg <= '9')
                  {
                    unsigned int n = *arg - '0';
                    if (argval > (LARGEST_ULONG>>10)/10 ||
                        (argval == (LARGEST_ULONG>>10)/10 &&
                         n > ((LARGEST_ULONG>>10)-argval*10)))
                      {
                        e = usage_err (debug_settings);
                        goto after_setup;
                      }
                    argval = argval*10 + n;
                    arg++;
                  }
                if (arg == s+1)
                  {
                    e = usage_err (debug_settings);
                    goto after_setup;
                  }
                switch (*s)
                  {
                  case 'm':
                    min_heap_len = argval<<10;
                    break;
                  case 'h':
                    max_heap_len = argval<<10;
                    break;
                  case 'l':
                    if (argval > 100)
                      argval = 100;
                    live_percent = argval;
                    break;
                  case 'p':
                    if (*arg == '%')
                      {
#ifndef ___SINGLE_THREADED_VMS
                        int count = ___cpu_count ();
                        if (argval > 100)
                          argval = 100;
                        parallelism_level = ___CEILING_DIV(count*argval,100);
                        if (neg)
                          parallelism_level = count - parallelism_level;
                        if (parallelism_level < 1)
                          parallelism_level = 1;
#endif
                        arg++;
                      }
#ifndef ___SINGLE_THREADED_VMS
                    else
                      parallelism_level = neg ? -argval : argval;
#endif
                  }
                break;
              }

            case 's':
              standard_level = 5;
              break;

            case 'S':
              standard_level = 1;
              break;

            case 'd':
              {
                if (*arg == '\0' || *arg == ' ' || *arg == ',')
                  debug_settings = ___DEBUG_SETTINGS_DEFAULT;
                else
                  while (*arg != '\0' && *arg != ' ' && *arg != ',')
                    {
                      if (*arg >= '0' && *arg <= '9')
                        {
                          debug_settings =
                            (debug_settings & ~___DEBUG_SETTINGS_LEVEL_MASK)
                            | ((*arg - '0') << ___DEBUG_SETTINGS_LEVEL_SHIFT);
                          arg++;
                        }
                      else
                        switch (*arg++)
                          {
                          case 'p': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_UNCAUGHT_MASK)
                                      | (___DEBUG_SETTINGS_UNCAUGHT_PRIMORDIAL
                                         << ___DEBUG_SETTINGS_UNCAUGHT_SHIFT);
                                    break;
                          case 'a': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_UNCAUGHT_MASK)
                                      | (___DEBUG_SETTINGS_UNCAUGHT_ALL
                                         << ___DEBUG_SETTINGS_UNCAUGHT_SHIFT);
                                    break;
                          case 'r': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_ERROR_MASK)
                                      | (___DEBUG_SETTINGS_ERROR_REPL
                                         << ___DEBUG_SETTINGS_ERROR_SHIFT);
                                    break;
                          case 's': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_ERROR_MASK)
                                      | (___DEBUG_SETTINGS_ERROR_SINGLE_STEP
                                         << ___DEBUG_SETTINGS_ERROR_SHIFT);
                                    break;
                          case 'q': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_ERROR_MASK)
                                      | (___DEBUG_SETTINGS_ERROR_QUIT
                                         << ___DEBUG_SETTINGS_ERROR_SHIFT);
                                    break;
                          case 'R': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_USER_INTR_MASK)
                                      | (___DEBUG_SETTINGS_USER_INTR_REPL
                                         << ___DEBUG_SETTINGS_USER_INTR_SHIFT);
                                    break;
                          case 'D': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_USER_INTR_MASK)
                                      | (___DEBUG_SETTINGS_USER_INTR_DEFER
                                         << ___DEBUG_SETTINGS_USER_INTR_SHIFT);
                                    break;
                          case 'Q': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_USER_INTR_MASK)
                                      | (___DEBUG_SETTINGS_USER_INTR_QUIT
                                         << ___DEBUG_SETTINGS_USER_INTR_SHIFT);
                                    break;
                          case 'i': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_REPL_MASK)
                                      | (___DEBUG_SETTINGS_REPL_IDE
                                         << ___DEBUG_SETTINGS_REPL_SHIFT);
                                    break;
                          case 'c': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_REPL_MASK)
                                      | (___DEBUG_SETTINGS_REPL_CONSOLE
                                         << ___DEBUG_SETTINGS_REPL_SHIFT);
                                    break;
                          case '-': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_REPL_MASK)
                                      | (___DEBUG_SETTINGS_REPL_STDIO
                                         << ___DEBUG_SETTINGS_REPL_SHIFT);
                                    break;

                          case '@':
                            debug_settings =
                              (debug_settings
                               & ~___DEBUG_SETTINGS_REPL_MASK)
                              | (___DEBUG_SETTINGS_REPL_REMOTE
                                 << ___DEBUG_SETTINGS_REPL_SHIFT);
                            ___free_UCS_2STRING (remote_dbg_addr);
                            remote_dbg_addr = extract_string (&arg);
                            if (remote_dbg_addr == 0)
                              {
                                e = ___FIX(___HEAP_OVERFLOW_ERR);
                                goto after_setup;
                              }
                            break;

                          default:
                            e = usage_err (debug_settings);
                            goto after_setup;
                          }
                    }
                break;
              }

            case '@':
              {
                ___free_UCS_2STRING (rpc_server_addr);
                rpc_server_addr = extract_string (&arg);
                if (rpc_server_addr == 0)
                  {
                    e = ___FIX(___HEAP_OVERFLOW_ERR);
                    goto after_setup;
                  }
                break;
              }

            case '=':
              {
                ___free_UCS_2STRING (gambitdir);
                gambitdir = extract_string (&arg);
                if (gambitdir == 0)
                  {
                    e = ___FIX(___HEAP_OVERFLOW_ERR);
                    goto after_setup;
                  }
                break;
              }

            case '~':
              {
                ___UCS_2STRING dir;
                ___UCS_2 c;

                if (*arg++ != '~')
                  {
                    e = usage_err (debug_settings);
                    goto after_setup;
                  }

                s = arg;

                while ((c = *s++) != '=')
                  if (!(((c >= 'a') && (c <= 'z')) ||
                        ((c >= 'A') && (c <= 'Z'))))
                    {
                      e = usage_err (debug_settings);
                      goto after_setup;
                    }

                if (!extend_strvec (&gambitdir_map, 0, 1, gambitdir_map != 0))
                  {
                    e = ___FIX(___HEAP_OVERFLOW_ERR);
                    goto after_setup;
                  }

                if ((dir = extract_string (&arg)) == 0)
                  {
                    e = ___FIX(___HEAP_OVERFLOW_ERR);
                    goto after_setup;
                  }

                gambitdir_map[0] = dir;

                gambitdir_map_len++;

                break;
              }

            case '+':
              {
                ___UCS_2STRING extra_arg;

                if (!extend_strvec (&current_argv,
                                    extra_arg_pos,
                                    1 - contract_argv,
                                    current_argv != argv))
                  {
                    e = ___FIX(___HEAP_OVERFLOW_ERR);
                    goto after_setup;
                  }

                contract_argv = 0;

                if ((extra_arg = extract_string (&arg)) == 0)
                  {
                    e = ___FIX(___HEAP_OVERFLOW_ERR);
                    goto after_setup;
                  }

                current_argv[extra_arg_pos++] = extra_arg;

                break;
              }

            case 't':
            case 'f':
            case '-':
              {
                int settings = 0;

                switch (*s)
                  {
                  case 'f':
                    settings = file_settings;
                    break;
                  case 't':
                    settings = terminal_settings;
                    break;
                  case '-':
                    settings = stdio_settings;
                    break;
                  }

                while (*arg != '\0' && *arg != ' ' && *arg != ',')
                  {
                    switch (*arg++)
                      {
                      case 'A': settings = ___CHAR_ENCODING_MASK(settings)
                                           |___CHAR_ENCODING_ASCII;
                                break;
                      case '1': settings = ___CHAR_ENCODING_MASK(settings)
                                           |___CHAR_ENCODING_ISO_8859_1;
                                break;
                      case '2': settings = ___CHAR_ENCODING_MASK(settings)
                                           |___CHAR_ENCODING_UCS_2;
                                break;
                      case '4': settings = ___CHAR_ENCODING_MASK(settings)
                                           |___CHAR_ENCODING_UCS_4;
                                break;
                      case '6': settings = ___CHAR_ENCODING_MASK(settings)
                                           |___CHAR_ENCODING_UTF_16;
                                break;
                      case '8': settings = ___CHAR_ENCODING_MASK(settings)
                                           |___CHAR_ENCODING_UTF_8;
                                break;
                      case 'U': switch (*arg++)
                                  {
                                  case 'A':
                                    settings = ___CHAR_ENCODING_MASK(settings)
                                               |___CHAR_ENCODING_UTF_FALLBACK_ASCII;
                                    break;
                                  case '1':
                                    settings = ___CHAR_ENCODING_MASK(settings)
                                               |___CHAR_ENCODING_UTF_FALLBACK_ISO_8859_1;
                                    break;
                                  case '6':
                                    settings = ___CHAR_ENCODING_MASK(settings)
                                               |___CHAR_ENCODING_UTF_FALLBACK_UTF_16;
                                    break;
                                  case '8':
                                    settings = ___CHAR_ENCODING_MASK(settings)
                                               |___CHAR_ENCODING_UTF_FALLBACK_UTF_8;
                                    break;
                                  default:
                                    arg--;
                                    settings = ___CHAR_ENCODING_MASK(settings)
                                               |___CHAR_ENCODING_UTF;
                                    break;
                                  }
                                break;
                      case 'l': settings = ___EOL_ENCODING_MASK(settings)
                                           |((___EOL_ENCODING(settings)
                                              ==___EOL_ENCODING_CR)
                                             ?___EOL_ENCODING_CRLF
                                             :___EOL_ENCODING_LF);
                                break;
                      case 'c': settings = ___EOL_ENCODING_MASK(settings)
                                           |___EOL_ENCODING_CR;
                                break;
                      case 'u': settings = ___BUFFERING_MASK(settings)
                                           |___NO_BUFFERING;
                                break;
                      case 'n': settings = ___BUFFERING_MASK(settings)
                                           |___LINE_BUFFERING;
                                break;
                      case 'f': settings = ___BUFFERING_MASK(settings)
                                           |___FULL_BUFFERING;
                                break;
                      case 'r': settings = ___CHAR_ENCODING_ERRORS_MASK(settings)
                                           |___CHAR_ENCODING_ERRORS_ON;
                                break;
                      case 'R': settings = ___CHAR_ENCODING_ERRORS_MASK(settings)
                                           |___CHAR_ENCODING_ERRORS_OFF;
                                break;
                      case 'e':
                      case 'E': if (*s != 't')
                                  {
                                    e = usage_err (debug_settings);
                                    goto after_setup;
                                  }
                                settings =
                                  ___TERMINAL_LINE_EDITING_MASK(settings)
                                  |((arg[-1] == 'e')
                                    ?___TERMINAL_LINE_EDITING_ON
                                    :___TERMINAL_LINE_EDITING_OFF);
                                break;
                      default:
                        e = usage_err (debug_settings);
                        goto after_setup;
                      }
                  }

                switch (*s)
                  {
                  case 'f':
                    file_settings = settings;
                    break;
                  case 't':
                    terminal_settings = settings;
                    break;
                  case '-':
                    stdio_settings = settings;
                    break;
                  }

                break;
              }

            default:
              {
                arg--;
                break;
              }
            }
        } while (*arg++ == ',');

      if (arg[-1] != '\0' && arg[-1] != ' ')
        {
          e = usage_err (debug_settings);
          goto after_setup;
        }
    }

  if (contract_argv != 0)
    {
      if (!extend_strvec (&current_argv,
                          extra_arg_pos,
                          -1,
                          0)) /* we know that current_argv == argv */
        {
          e = ___FIX(___HEAP_OVERFLOW_ERR);
          goto after_setup;
        }
    }

#ifdef ___FORCE_MAX_HEAP
  if (max_heap_len == 0 || max_heap_len > (___FORCE_MAX_HEAP<<10))
    max_heap_len = ___FORCE_MAX_HEAP<<10;
#endif

  /* Setup program, run it and perform any cleanup necessary. */

  ___setup_params_reset (&setup_params);

  setup_params.version           = ___VERSION;
  setup_params.argv              = current_argv;
  setup_params.min_heap          = min_heap_len;
  setup_params.max_heap          = max_heap_len;
  setup_params.live_percent      = live_percent;
  setup_params.parallelism_level = parallelism_level;
  setup_params.standard_level    = standard_level;
  setup_params.debug_settings    = debug_settings;
  setup_params.file_settings     = file_settings;
  setup_params.terminal_settings = terminal_settings;
  setup_params.stdio_settings    = stdio_settings;
  setup_params.gambitdir         = gambitdir;
  setup_params.gambitdir_map     = gambitdir_map;
  setup_params.remote_dbg_addr   = remote_dbg_addr;
  setup_params.rpc_server_addr   = rpc_server_addr;
  setup_params.linker            = linker;

  e = ___setup (&setup_params);

 after_setup:

  while (extra_arg_pos > 1)
    ___free_UCS_2STRING (current_argv[--extra_arg_pos]);

  if (current_argv != argv)
    ___FREE_MEM(current_argv);

  while (gambitdir_map_len > 0)
    ___free_UCS_2STRING (gambitdir_map[--gambitdir_map_len]);

  if (gambitdir_map != 0)
    ___FREE_MEM(gambitdir_map);

  ___free_UCS_2STRING (gambitdir);
  ___free_UCS_2STRING (gambopt);
  ___free_UCS_2STRING (remote_dbg_addr);
  ___free_UCS_2STRING (rpc_server_addr);

  if (e == ___FIX(___NO_ERR))
    {
      ___cleanup ();
      e = ___FIX(___EXIT_CODE_OK);
    }
  else if (e > ___FIX(___NO_ERR))
    e = ___FIXSUB(e,___FIX(1));
  else
    {
#ifdef ___DEBUG_LOG
      ___printf ("___setup returned error code %d\n", ___INT(e));
#endif
      e = ___FIX(___EXIT_CODE_OSERR);
    }

  return ___INT(e);
}


/*---------------------------------------------------------------------------*/
