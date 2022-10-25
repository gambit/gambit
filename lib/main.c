/* File: "main.c" */

/* Copyright (c) 1994-2022 by Marc Feeley, All Rights Reserved. */

/* This is the driver of the Gambit system */

#define ___INCLUDED_FROM_MAIN
#define ___VERSION 409004
#include "gambit.h"

#include "os_setup.h"
#include "os_base.h"
#include "os_shell.h"
#include "setup.h"


/*---------------------------------------------------------------------------*/


___HIDDEN ___UCS_2 gambopt_env_name[] =
{'G', 'A', 'M', 'B', 'O', 'P', 'T', '\0'};

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
        "The -: flag sets options for the Gambit runtime system. OPTION is one of:\n"
        "  min-heap=SIZE      set minimum heap size, shorthand: mSIZE\n"
        "  max-heap=SIZE      set maximum heap size, shorthand: hSIZE\n"
        "                     the heap SIZE may end with G, M or K (default)\n"
        "  live-ratio=RATIO   set heap live ratio after GC in percent, shorthand: lRATIO\n"
#ifndef ___SINGLE_THREADED_VMS
        "  parallelism=LEVEL  set parallelism level, shorthand: pLEVEL, where LEVEL can\n"
        "                     be positive (nb of processors), negative (nb of unused\n"
        "                     processors), or end with % (ratio of available processors)\n"
#endif
        "  gambit             set Gambit mode, shorthand: S (default mode)\n"
        "  r4rs | ... | r7rs  set RnRS mode (R7RS mode shorthand: s)\n"
        "  debug[=[OPT...]]   set debugging options, shorthand: d[OPT...], OPT is one of\n"
        "                      p|a       treat uncaught exceptions as errors\n"
        "                                (primordial-thread only|all threads)\n"
        "                      r|s|q     error handling (create a new REPL|start in\n"
        "                                single-step mode|quit with error status)\n"
        "                      R|D|Q     user interrupt handling (create a new REPL|\n"
        "                                defer handling|quit with error status)\n"
        "                      0..9      verbosity level\n"
        "                      c         use console as REPL interaction channel\n"
        "                      -         use stdin/out as REPL interaction channel\n"
        "                      +         use stdin/out/err as REPL interaction channel\n"
        "                      @[HOST][:PORT]\n"
        "                                open connection to HOST:PORT for each thread\n"
        "                                needing a REPL interaction channel\n"
        "                                (defaults to 127.0.0.1:44556)\n"
        "                      $[INTF][:PORT]\n"
        "                                start a REPL server accepting incoming\n"
        "                                connections on INTF:PORT\n"
        "                                (defaults to 127.0.0.1:44555)\n"
        "  ~~NAME=DIR         override Gambit installation directory ~~NAME where NAME\n"
        "                     can be the special \"bin\" and \"lib\", or empty, or any id\n"
        "  search=[DIR]       add directory to module search order (or reset it)\n"
        "  whitelist=[SOURCE] add source to module auto-install whitelist (or reset it)\n"
        "  ask-install=WHEN   when an uninstalled module is not on the whitelist, ask\n"
        "                     user if it should be installed, where WHEN is one of\n"
        "                      never     never ask, i.e. don't install\n"
        "                      always    always ask\n"
        "                      repl      only if a REPL is running (default)\n"
        "  add-arg=ARGUMENT   add ARGUMENT to the command line before other arguments,\n"
        "                     shorthand: +ARGUMENT\n"
        "  io-settings=[IO...]        set general IO settings, shorthand: i[IO...]\n"
        "  file-settings=[IO...]      set general file IO settings, shorthand: f[IO...]\n"
        "  stdio-settings=[IO...]     set general stdio IO settings, shorthand: -[IO...]\n"
        "  0=[IO...]                  set stdin IO settings (1 and 2 for stdout/stderr)\n"
        "  terminal-settings=[IO...]  set terminal IO settings, shorthand: t[IO...]\n"
        "where IO is one of\n"
        "  A|1|2|4|6|8|U   character encoding (ASCII|ISO-8859-1|UCS-2/4|UTF-16/8|UTF)\n"
        "  L               use LC_ALL, LC_CTYPE, and LANG env vars to set char encoding\n"
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
  ___UCS_2STRING end = *start;
  ___UCS_2STRING p1 = end;
  int n = 0;
  ___UCS_2STRING result;

  while ((c = *end) != '\0' && (c != ',' || end[1] == ','))
    {
      end++;
      if (c == ',')
        end++;
      n++;
    }

  *start = end;

  result = ___CAST(___UCS_2STRING,
                   ___ALLOC_MEM((n+1) * sizeof (___UCS_2)));

  if (result != 0)
    {
      ___UCS_2STRING p2 = result;
      while (p1 < end)
        {
          c = *p1++;
          if (c == ',')
            p1++;
          *p2++ = c;
        }
      *p2++ = '\0';
    }

  return result;
}


___HIDDEN int is_alpha
   ___P((___UCS_2 c),
        (c)
___UCS_2 c;)
{
  return ((c  >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'));
}


___HIDDEN int is_digit
   ___P((___UCS_2 c),
        (c)
___UCS_2 c;)
{
  return (c >= '0' && c <= '9');
}


___HIDDEN int is_alpha_or_digit
   ___P((___UCS_2 c),
        (c)
___UCS_2 c;)
{
  return is_alpha (c) ||  is_digit (c);
}


___HIDDEN ___UCS_2STRING extract_addr
   ___P((___UCS_2STRING *start),
        (start)
___UCS_2STRING *start;)
{
  ___UCS_2 c;
  ___UCS_2STRING end = *start;
  ___UCS_2STRING p1 = end;
  int n = 0;
  ___UCS_2STRING result;

  while (is_alpha_or_digit (c = *end) || c == '.' || c == '-')
    {
      end++;
      n++;
    }

  if (*end == ':' && is_digit (end[1]))
    {
      end += 2;
      n += 2;
      while (is_digit (*end))
        {
          end++;
          n++;
        }
    }

  *start = end;

  result = ___CAST(___UCS_2STRING,
                   ___ALLOC_MEM((n+1) * sizeof (___UCS_2)));

  if (result != 0)
    {
      ___UCS_2STRING p2 = result;
      while (p1 < end)
        *p2++ = *p1++;
      *p2++ = '\0';
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


___HIDDEN void free_strvec
   ___P((___UCS_2STRING **strvec,
         int *len),
        (strvec,
         len)
___UCS_2STRING **strvec;
int *len;)
{
  while (*len > 0)
    ___free_UCS_2STRING ((*strvec)[--*len]);

  if (*strvec != 0)
    {
      ___FREE_MEM(*strvec);
      *strvec = 0;
    }
}


___HIDDEN int starts_with
   ___P((___UCS_2STRING start,
         char *prefix),
        (start,
         prefix)
___UCS_2STRING start;
char *prefix;)
{
  while (*prefix != '\0')
    {
      if (*start++ != *prefix++) return 0;
    }

  return 1;
}


___HIDDEN int permissive_suffix
   ___P((___UCS_2STRING start,
         char *suffix),
        (start,
         suffix)
___UCS_2STRING start;
char *suffix;)
{
  int len1 = 0;
  int len2 = 0;

  while (*start != '\0') { len1++; start++; }
  while (*suffix != '\0') { len2++; suffix++; }

  if (len2 > len1)
    return 0;

  while (len2-- > 0)
    {
      ___UCS_2 c1 = *--start;
      char c2 = *--suffix;
      /* permissive character comparison... 'a'=='A' and '_'=='-' */
      if (!(c1 == c2 ||
            (c2 >= 'A' && c2 <= 'Z' && c1 == (c2 + 'a' - 'A')) ||
            (c2 == '-' && c1 == '_')))
        return 0;
    }

  return 1;
}


___HIDDEN int option_equal
   ___P((___UCS_2STRING start,
         char *option),
        (start,
         option)
___UCS_2STRING start;
char *option;)
{
  while (*option != '\0')
    {
      if (*start++ != *option++) return 0;
    }

  return (*option == '\0' || *option == ' ' || *option == ',');
}


___HIDDEN ___UCS_2 lc_all_env_var[] =
{'L', 'C', '_', 'A', 'L', 'L', '\0'};

___HIDDEN ___UCS_2 lc_ctype_env_var[] =
{'L', 'C', '_', 'C', 'T', 'Y', 'P', 'E', '\0'};

___HIDDEN ___UCS_2 lc_lang_env_var[] =
{'L', 'A', 'N', 'G', '\0'};

___HIDDEN ___UCS_2STRING lc_env_vars[] =
{ lc_all_env_var, lc_ctype_env_var, lc_lang_env_var };


int ___main
   ___P((___mod_or_lnk (*linker)(___global_state)),
        (linker)
___mod_or_lnk (*linker)();)
{
#define LARGEST_ULONG (unsigned long)(~___CAST(unsigned long,0))

  ___UCS_2STRING *argv;
  ___UCS_2STRING *current_argv;
  ___UCS_2STRING cmd_line_runtime_options;
  ___UCS_2STRING script_line = 0;
  int extra_arg_pos = 1;
  int contract_argv;
  int options_source;
  int options_source_min;
  int options_source_max;
  ___UCS_2STRING gambitdir;
  ___UCS_2STRING *gambitdir_map;
  int gambitdir_map_len;
  ___UCS_2STRING *module_search_order;
  int module_search_order_len;
  ___UCS_2STRING *module_whitelist;
  int module_whitelist_len;
  int module_install_mode;
  ___UCS_2STRING gambopt;
  ___UCS_2STRING repl_client_addr;
  ___UCS_2STRING repl_server_addr;
  unsigned long min_heap_len;
  unsigned long max_heap_len;
  int live_percent;
  int parallelism_level;
  int standard_level;
  int debug_settings;
  int io_settings[___IO_SETTINGS_LAST+1];
  int settings_index;
  ___SCMOBJ e;
  ___setup_params_struct setup_params;

  /* handle arguments to runtime */

  argv = ___program_startup_info.argv;
  contract_argv = 0;
  gambitdir = 0;
  gambitdir_map = 0;
  gambitdir_map_len = 0;
  module_search_order = 0;
  module_search_order_len = 0;
  module_whitelist = 0;
  module_whitelist_len = 0;
  module_install_mode = ___MODULE_INSTALL_MODE_INITIAL;
  gambopt = 0;
  cmd_line_runtime_options = 0;
  repl_client_addr = 0;
  repl_server_addr = 0;
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
  standard_level = -1;
  debug_settings = ___DEBUG_SETTINGS_INITIAL;

  for (settings_index=0; settings_index<=___IO_SETTINGS_LAST; settings_index++)
    io_settings[settings_index] = 0;

  /*
   * Runtime options can come from several sources:
   *
   * - the default runtime options (as specified to the configure script)
   * - the environment variable GAMBOPT
   * - the script line
   * - the first command line argument if it is of the form -:XXX
   *
   * When a source of runtime options starts with a comma it is the
   * sole source of runtime options and the first command line
   * argument will not be processed specially, even if it is of the
   * form -:XXX).  Otherwise the runtime options are accumulated from
   * all the sources of runtime options.
   */

#ifdef ___DEFAULT_RUNTIME_OPTIONS
  if (default_runtime_options[0] == ',')
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
          gambopt[0] == ',')
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
              script_line[0] == ',')
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

                  if (cmd_line_runtime_options[0] == ',')
                    options_source_min = 3;

                  options_source_max = 3;
                }
              else
                options_source_max = 2;
            }
        }
    }

  current_argv = argv;

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

      if (arg[0] == ',')
        arg++;

      do
        {
          ___UCS_2STRING s = arg;

          while (is_alpha_or_digit (*arg) || *arg == '-')
            arg++;

          if (arg - s >= 2) /* at least 2 char keyword */
            {
              if (*arg == '=') /* followed by '=' */
                {
                  arg++;
                  if (starts_with (s, "min-heap"))
                    goto mhlp_options;
                  else if (starts_with (s, "max-heap"))
                    {
                      s += 4; /* point to the 'h' */
                      goto mhlp_options;
                    }
                  else if (starts_with (s, "live-ratio"))
                    goto mhlp_options;
                  else if (starts_with (s, "parallelism"))
                    goto mhlp_options;
                  else if (starts_with (s, "debug"))
                    goto debug_option;
                  else if (starts_with (s, "stdio-settings"))
                    {
                      s += 5; /* point to the '-' */
                      goto io_settings_options;
                    }
                  else if (starts_with (s, "terminal-settings"))
                    goto io_settings_options;
                  else if (starts_with (s, "file-settings"))
                    goto io_settings_options;
                  else if (starts_with (s, "io-settings"))
                    goto io_settings_options;
                  else if (starts_with (s, "add-arg"))
                    goto add_arg_option;
                  else if (starts_with (s, "search"))
                    {
                      ___UCS_2STRING dir;

                      if (*arg == '\0' || (*arg == ',' && arg[1] != ','))
                        {
                          free_strvec (&module_search_order,
                                       &module_search_order_len);
                        }
                      else
                        {
                          int pos = 0;

                          if (!extend_strvec (&module_search_order, pos, 1, module_search_order != 0))
                            {
                              e = ___FIX(___HEAP_OVERFLOW_ERR);
                              goto after_setup;
                            }

                          if ((dir = extract_string (&arg)) == 0)
                            {
                              e = ___FIX(___HEAP_OVERFLOW_ERR);
                              goto after_setup;
                            }

                          module_search_order[pos] = dir;

                          module_search_order_len++;
                        }

                      continue;
                    }
                  else if (starts_with (s, "whitelist"))
                    {
                      ___UCS_2STRING src;

                      if (*arg == '\0' || (*arg == ',' && arg[1] != ','))
                        {
                          free_strvec (&module_whitelist,
                                       &module_whitelist_len);
                        }
                      else
                        {
                          int pos = module_whitelist_len;

                          if (!extend_strvec (&module_whitelist, pos, 1, module_whitelist != 0))
                            {
                              e = ___FIX(___HEAP_OVERFLOW_ERR);
                              goto after_setup;
                            }

                          if ((src = extract_string (&arg)) == 0)
                            {
                              e = ___FIX(___HEAP_OVERFLOW_ERR);
                              goto after_setup;
                            }

                          module_whitelist[pos] = src;

                          module_whitelist_len++;
                        }

                      continue;
                    }
                  else if (starts_with (s, "ask-install"))
                    {
                      if (option_equal (arg, "always"))
                        {
                          arg += 6;
                          module_install_mode = ___MODULE_INSTALL_MODE_ASK_ALWAYS;
                        }
                      else if (option_equal (arg, "never"))
                        {
                          arg += 5;
                          module_install_mode = ___MODULE_INSTALL_MODE_ASK_NEVER;
                        }
                      else if (option_equal (arg, "repl"))
                        {
                          arg += 4;
                          module_install_mode = ___MODULE_INSTALL_MODE_ASK_WHEN_REPL;
                        }
                      else
                        {
                          e = usage_err (debug_settings);
                          goto after_setup;
                        }
                      continue;
                    }
                }
              else if (option_equal (s, "debug"))
                goto debug_option;
              else if (option_equal (s, "r4rs"))
                goto r4rs_option;
              else if (option_equal (s, "r5rs"))
                goto r5rs_option;
              else if (option_equal (s, "r6rs"))
                goto r6rs_option;
              else if (option_equal (s, "r7rs"))
                goto r7rs_option;
              else if (option_equal (s, "gambit"))
                goto gambit_option;
            }

          arg = s+1;

          switch (*s)
            {
            case 'm':
            case 'h':
            case 'l':
            case 'p':
            mhlp_options:
              {
                unsigned long argval = 0;
                int neg = *arg == '-';
                if (neg && *s == 'p' && is_digit (arg[1]))
                  arg++;
                while (is_digit (*arg))
                  {
                    unsigned int n = *arg - '0';
                    if (argval > LARGEST_ULONG/10 ||
                        (argval == LARGEST_ULONG/10 &&
                         n > (LARGEST_ULONG-argval*10)))
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
                  case 'h':
                    {
                      int shift = 10;
                      unsigned long orig = argval;
                      if (*arg == 'G')
                        {
                          shift = 30;
                          arg++;
                        }
                      else if (*arg == 'M')
                        {
                          shift = 20;
                          arg++;
                        }
                      else if (*arg == 'K')
                        {
                          arg++;
                        }
                      argval = argval << shift;
                      if ((argval >> shift) != orig)
                        {
                          e = usage_err (debug_settings);
                          goto after_setup;
                        }
                      if (*s == 'm')
                        min_heap_len = argval;
                      else
                        max_heap_len = argval;
                      break;
                    }
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

            case 'S':
            gambit_option:
              standard_level = 0;
              break;

            r4rs_option:
              standard_level = 4;
              break;

            r5rs_option:
              standard_level = 5;
              break;

            r6rs_option:
              standard_level = 6;
              break;

            case 's':
            r7rs_option:
              standard_level = 7;
              break;

            case 'd':
            debug_option:
              {
                if (*arg == '\0' || *arg == ' ' || *arg == ',')
                  debug_settings = ___DEBUG_SETTINGS_DEFAULT;
                else
                  while (*arg != '\0' && *arg != ' ' && *arg != ',')
                    {
                      if (is_digit (*arg))
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
                          case '+': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_REPL_MASK)
                                      | (___DEBUG_SETTINGS_REPL_STDIO_AND_ERR
                                         << ___DEBUG_SETTINGS_REPL_SHIFT);
                                    break;
                          case '@': debug_settings =
                                      (debug_settings
                                       & ~___DEBUG_SETTINGS_REPL_MASK)
                                      | (___DEBUG_SETTINGS_REPL_CLIENT
                                         << ___DEBUG_SETTINGS_REPL_SHIFT);
                                    ___free_UCS_2STRING (repl_client_addr);
                                    repl_client_addr = extract_addr (&arg);
                                    if (repl_client_addr == 0)
                                      {
                                        e = ___FIX(___HEAP_OVERFLOW_ERR);
                                        goto after_setup;
                                      }
                                    break;
                          case '$': ___free_UCS_2STRING (repl_server_addr);
                                    repl_server_addr = extract_addr (&arg);
                                    if (repl_server_addr == 0)
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

            case '~':
              {
                ___UCS_2STRING dir;
                ___UCS_2STRING after_tilde;
                ___UCS_2 c;

                if (*arg++ != '~')
                  {
                    e = usage_err (debug_settings);
                    goto after_setup;
                  }

                after_tilde = arg;
                s = after_tilde;

                while ((c = *s++) != '=')
                  if (!is_alpha_or_digit (c))
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

                if (after_tilde[0] != '=')
                  break;

                arg = after_tilde+1; /* also set gambitdir on ~~=... */

                /* fall through to next case */
              }

            case '=': /* Note: the -:=... pattern is deprecated */
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
            case '+':
            add_arg_option:
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

            case '0':
            case '1':
            case '2':
            case 't':
            case '-':
            case 'f':
            case 'i':
            io_settings_options:
              {
                int settings = 0;

                settings_index = ___IO_SETTINGS_GENERAL;

                switch (*s)
                  {
                  case '0':
                    settings_index = ___IO_SETTINGS_STDIN;
                    break;
                  case '1':
                    settings_index = ___IO_SETTINGS_STDOUT;
                    break;
                  case '2':
                    settings_index = ___IO_SETTINGS_STDERR;
                    break;
                  case 't':
                    settings_index = ___IO_SETTINGS_TERMINAL;
                    break;
                  case '-':
                    settings_index = ___IO_SETTINGS_STDIO;
                    break;
                  case 'f':
                    settings_index = ___IO_SETTINGS_FILE;
                    break;
                  }

                settings = io_settings[settings_index];

                while (*arg != '\0' && *arg != ' ' && *arg != ',')
                  {
                    switch (*arg++)
                      {
                      case 'L':
                        {
                          ___UCS_2STRING val;
                          int i;

                          for (i=0; i<___NBELEMS(lc_env_vars); i++)
                            {
                              if ((e = ___getenv_UCS_2 (lc_env_vars[i], &val))
                                  != ___FIX(___NO_ERR))
                                goto after_setup;

                              if (val != 0)
                                {
                                  if (permissive_suffix (val, ".UTF-8") ||
                                      permissive_suffix (val, ".UTF8"))
                                    {
                                      settings = ___CHAR_ENCODING_MASK(settings)
                                                 |___CHAR_ENCODING_UTF_8;
                                      i = ___NBELEMS(lc_env_vars);
                                    }
                                  else if (permissive_suffix (val, ".ISO-8859-1") ||
                                           permissive_suffix (val, ".ISO8859-1") ||
                                           permissive_suffix (val, ".LATIN-1") ||
                                           permissive_suffix (val, ".LATIN1"))
                                    {
                                      settings = ___CHAR_ENCODING_MASK(settings)
                                                 |___CHAR_ENCODING_ISO_8859_1;
                                      i = ___NBELEMS(lc_env_vars);
                                    }
                                  ___free_UCS_2STRING (val);
                                }
                            }

                          break;
                        }
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
                      case 'E': if (settings_index != ___IO_SETTINGS_TERMINAL)
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

                io_settings[settings_index] = settings;

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

  setup_params.version             = ___VERSION;
  setup_params.argv                = current_argv;
  setup_params.min_heap            = min_heap_len;
  setup_params.max_heap            = max_heap_len;
  setup_params.live_percent        = live_percent;
  setup_params.parallelism_level   = parallelism_level;
  setup_params.standard_level      = standard_level;
  setup_params.debug_settings      = debug_settings;
  for (settings_index=0; settings_index<=___IO_SETTINGS_LAST; settings_index++)
    setup_params.io_settings[settings_index] = io_settings[settings_index];
  setup_params.gambitdir           = gambitdir;
  setup_params.gambitdir_map       = gambitdir_map;
  setup_params.module_search_order = module_search_order;
  setup_params.module_whitelist    = module_whitelist;
  setup_params.module_install_mode = module_install_mode;
  setup_params.repl_client_addr    = repl_client_addr;
  setup_params.repl_server_addr    = repl_server_addr;
  setup_params.linker              = linker;

  e = ___setup (&setup_params);

 after_setup:

  while (extra_arg_pos > 1)
    ___free_UCS_2STRING (current_argv[--extra_arg_pos]);

  if (current_argv != argv)
    ___FREE_MEM(current_argv);

  free_strvec (&gambitdir_map,
               &gambitdir_map_len);
  free_strvec (&module_search_order,
               &module_search_order_len);
  free_strvec (&module_whitelist,
               &module_whitelist_len);

  ___free_UCS_2STRING (gambitdir);
  ___free_UCS_2STRING (gambopt);
  ___free_UCS_2STRING (repl_client_addr);
  ___free_UCS_2STRING (repl_server_addr);

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
