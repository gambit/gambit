/* File: "os_base.c", Time-stamp: <2007-09-11 23:51:12 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the most basic operating system services.
 */

#define ___INCLUDED_FROM_OS_BASE
#define ___VERSION 402002
#include "gambit.h"

#include "os_base.h"
#include "setup.h"


/*---------------------------------------------------------------------------*/


___base_module ___base_mod =
{
  0

#ifdef ___DEBUG
  ,
  0,
  0,
  0
#ifdef ___DEBUG_ALLOC_MEM_TRACE
  ,
  0,
  0
#endif
#endif

#ifdef ___BASE_MODULE_INIT
  ___BASE_MODULE_INIT
#endif
};


/*---------------------------------------------------------------------------*/

/* Standard I/O emulation */


___FILE *___fopen
   ___P((const char *path,
         const char *mode),
        (path,
         mode)
const char *path;
const char *mode;)
{
  return fopen (path, mode);
}


int ___fclose
   ___P((___FILE *stream),
        (stream)
___FILE *stream;)
{
  return fclose (stream);
}


size_t ___fread
   ___P((void *ptr,
         size_t size,
         size_t nmemb,
         ___FILE *stream),
        (ptr,
         size,
         nmemb,
         stream)
void *ptr;
size_t size;
size_t nmemb;
___FILE *stream;)
{
  return fread (ptr, size, nmemb, stream);
}


size_t ___fwrite
   ___P((const void *ptr,
         size_t size,
         size_t nmemb,
         ___FILE *stream),
        (ptr,
         size,
         nmemb,
         stream)
const void *ptr;
size_t size;
size_t nmemb;
___FILE *stream;)
{
  return fwrite (ptr, size, nmemb, stream);
}


int ___fflush
   ___P((___FILE *stream),
        (stream)
___FILE *stream;)
{
  return fflush (stream);
}


#ifdef ___DEBUG

#include <stdarg.h>

int ___printf
   ___P((const char *format,
         ...),
        (format,
         ...)
const char *format;)
{
  va_list ap;
  int result;
  ___FILE *stream = ___base_mod.debug;

  if (stream == NULL)
    stream = ___stderr;

  va_start (ap, format);
  result = vfprintf (stream, format, ap);
  va_end (ap);

  ___fflush (stream);

  return result;
}

#endif


/*---------------------------------------------------------------------------*/

/* Memory allocation. */


void *___alloc_mem
   ___P((unsigned long bytes),
        (bytes)
unsigned long bytes;)
{
  void *ptr;

#ifdef ___DEBUG
#ifdef USE_WIN32

  InterlockedIncrement (&___base_mod.alloc_mem_calls);

#else

  ___base_mod.alloc_mem_calls++;

#endif
#endif

#ifdef USE_TempNewHandle

  if (___base_mod.setup && ___base_mod.has_OSDispatch)
    {
      OSErr e;
      Ptr p;
      Handle h = TempNewHandle (sizeof (Handle) + bytes, &err);
      if (e != noErr || h == 0)
        return 0;
      HLock (h);
      p = *h;
      *___CAST(Handle*,p) = h;
      ptr = p + sizeof (Handle);
    }
  else
    ptr = malloc (bytes);

#else

  ptr = malloc (bytes);

#endif

#ifdef ___DEBUG
#ifdef ___DEBUG_ALLOC_MEM_TRACE
  if (___base_mod.file != 0)
    ___printf ("%p (%lu bytes) ALLOCATED AT \"%s\"@%d.1\n",
               ptr,
               bytes,
               ___base_mod.file,
               ___base_mod.lineno);
  else
    ___printf ("%p (%lu bytes) ALLOCATED\n", ptr, bytes);
#endif
#endif

  return ptr;
}


void ___free_mem
   ___P((void *ptr),
        (ptr)
void *ptr;)
{
#ifdef ___DEBUG
#ifdef ___DEBUG_ALLOC_MEM_TRACE
  ___printf ("%p FREED\n", ptr);
#endif
#endif

#ifdef ___DEBUG
#ifdef USE_WIN32

  InterlockedIncrement (&___base_mod.free_mem_calls);

#else

  ___base_mod.free_mem_calls++;

#endif
#endif

#ifdef USE_TempNewHandle

  if (___base_mod.setup && ___base_mod.has_OSDispatch)
    {
      OSErr e;
      Handle h = *___CAST(Handle*,___CAST(Ptr,ptr) - sizeof (Handle));
      HUnlock (h);
      TempDisposeHandle (h, &e);
    }
  else
    free (ptr);

#else

  free (ptr);

#endif
}


#ifdef ___DEBUG
#ifdef ___DEBUG_ALLOC_MEM_TRACE


void * ___alloc_mem_debug
   ___P((unsigned long bytes,
         int lineno,
         char *file),
        (bytes,
         lineno,
         file)
unsigned long bytes;
int lineno;
char *file;)
{
  void *ptr;

  ___base_mod.lineno = lineno;
  ___base_mod.file = file;

  ptr = ___alloc_mem (bytes);

  ___base_mod.lineno = 0;
  ___base_mod.file = 0;

  return ptr;
}


#endif
#endif


/*---------------------------------------------------------------------------*/

/* Program startup */


___program_startup_info_struct ___program_startup_info =
{
  0,
  0

#ifdef ___OS_WIN32
  ,
  NULL,
  NULL,
  NULL,
  0
#endif
};


___EXP_FUNC(int,___main_char)
  ___P((int argc,
        char *argv[],
        ___mod_or_lnk (*linker)(___global_state_struct*),
        char *script_line),
       (argc,
        argv,
        linker,
        script_line)
int argc;
char *argv[];
___mod_or_lnk (*linker)();
char *script_line;)
{
  int result;

  if (___setup_base_module () != ___FIX(___NO_ERR))
    result = ___EXIT_CODE_OSERR;
  else
    {
      if (___NONNULLCHARSTRINGLIST_to_NONNULLUCS_2STRINGLIST
            (argv,
             &___program_startup_info.argv)
          != ___FIX(___NO_ERR))
        result = ___EXIT_CODE_SOFTWARE;
      else
        {
          if (___CHARSTRING_to_UCS_2STRING
                (script_line,
                 &___program_startup_info.script_line)
              != ___FIX(___NO_ERR))
            result = ___EXIT_CODE_SOFTWARE;
          else
            {
              result = ___main (linker);

              ___free_UCS_2STRING (___program_startup_info.script_line);
            }

          ___free_NONNULLUCS_2STRINGLIST (___program_startup_info.argv);
        }

      ___cleanup_base_module ();
    }

  return result;
}


___EXP_FUNC(int,___main_UCS_2)
  ___P((int argc,
        ___UCS_2STRING argv[],
        ___mod_or_lnk (*linker)(___global_state_struct*),
        char *script_line),
       (argc,
        argv,
        linker,
        script_line)
int argc;
___UCS_2STRING argv[];
___mod_or_lnk (*linker)();
char *script_line;)
{
  int result;

  if (___setup_base_module () != ___FIX(___NO_ERR))
    result = ___EXIT_CODE_OSERR;
  else
    {
      ___program_startup_info.argv = argv;

      if (___CHARSTRING_to_UCS_2STRING
            (script_line,
             &___program_startup_info.script_line)
          != ___FIX(___NO_ERR))
        result = ___EXIT_CODE_SOFTWARE;
      else
        {
          result = ___main (linker);

          ___free_UCS_2STRING (___program_startup_info.script_line);
        }

      ___cleanup_base_module ();
    }

  return result;
}


#ifdef ___OS_WIN32


#ifdef _UNICODE
#define ___CMDLINE_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___CMDLINE_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif


___HIDDEN ___SCMOBJ parse_windows_command_line
   ___P((___STRING_TYPE(___CMDLINE_CE_SELECT) cmdline,
         ___UCS_2STRING **argv_return),
        (cmdline,
         argv_return)
___STRING_TYPE(___CMDLINE_CE_SELECT) cmdline;
___UCS_2STRING **argv_return;)
{
  int argc = 0;
  ___UCS_2STRING *argv = 0;
  ___UCS_2STRING args = 0;
  int total_arg_len = 0;
  int pass;

  for (pass=0; pass<2; pass++)
    {
      int in_double_quotes;
      int nb_backslashes;
      ___STRING_TYPE(___CMDLINE_CE_SELECT) p;
      ___CHAR_TYPE(___CMDLINE_CE_SELECT) c;

      if (pass != 0)
        {
          if ((argv = ___CAST(___UCS_2STRING*,
                              ___alloc_mem ((argc + 1)
                                            * sizeof (___UCS_2STRING)))) == 0)
            return ___FIX(___HEAP_OVERFLOW_ERR);

          if (total_arg_len > 0)
            {
              if ((args = ___CAST(___UCS_2STRING,
                                  ___alloc_mem (total_arg_len
                                                * sizeof (___UCS_2)))) == 0)
                {
                  ___free_mem (argv);
                  return ___FIX(___HEAP_OVERFLOW_ERR);
                }
            }
        }

      total_arg_len = 0;
      argc = 0;
      p = cmdline;

      for (;;)
        {
          while ((c = *p) != '\0' && c <= ' ')
            p++;

          if (c == '\0')
            break;

          in_double_quotes = 0;
          nb_backslashes = 0;

          if (pass != 0)
            argv[argc] = args;

          while ((c = *p) != '\0' && (in_double_quotes || c > ' '))
            {
              if (c == '\\')
                nb_backslashes++;
              else
                {
                  if (c != '"')
                    nb_backslashes = (nb_backslashes<<1) + 1;
                  else
                    {
                      if ((nb_backslashes & 1) == 0)
                        in_double_quotes ^= 1;
#ifndef PROCESS_PROGRAM_LIKE_OTHER_ARGS
                      if (argc == 0)
                        nb_backslashes = (nb_backslashes<<1) + 1;
#endif
                    }

                  total_arg_len += ((nb_backslashes+1)>>1);

                  if (pass != 0)
                    {
                      while (nb_backslashes > 1)
                        {
                          *args++ = '\\';
                          nb_backslashes -= 2;
                        }
                      if (nb_backslashes != 0)
                        *args++ = c;
                    }

                  nb_backslashes = 0;
                }
              p++;
            }

          total_arg_len += nb_backslashes+1;

          if (pass != 0)
            {
              while (nb_backslashes-- > 0)
                *args++ = '\\';
              *args++ = '\0';
            }

          argc++;
        }
    }

  argv[argc] = 0;

  *argv_return = argv;

  return ___FIX(___NO_ERR);
}


___HIDDEN void free_windows_command_line
   ___P((___UCS_2STRING *argv),
        (argv)
___UCS_2STRING *argv;)
{
  if (argv[0] != 0)
    ___free_mem (argv[0]);

  ___free_mem (argv);
}


___EXP_FUNC(int,___winmain)
  ___P((HINSTANCE hInstance,
        HINSTANCE hPrevInstance,
        LPSTR lpCmdLine,
        int nCmdShow,
        ___mod_or_lnk (*linker)(___global_state_struct*),
        char *script_line),
       (hInstance,
        hPrevInstance,
        lpCmdLine,
        nCmdShow,
        linker,
        script_line)
HINSTANCE hInstance;
HINSTANCE hPrevInstance;
LPSTR lpCmdLine;
int nCmdShow;
___mod_or_lnk (*linker)(___global_state_struct*);
char *script_line;)
{
  int result;

  if (___setup_base_module () != ___FIX(___NO_ERR))
    result = ___EXIT_CODE_OSERR;
  else
    {
      /*********************************/
#if 0
      AllocConsole( );  /* Create Console Window */
      freopen(_T("CONIN$"),_T("rb"),stdin);   /* reopen stdin handle as console window input */
      freopen(_T("CONOUT$"),_T("wb"),stdout); /* reopen stout handle as console window output */
      freopen(_T("CONOUT$"),_T("wb"),stderr); /* reopen stderr handle as console window output */
#endif

      if (parse_windows_command_line
            (GetCommandLine (),
             &___program_startup_info.argv)
          != ___FIX(___NO_ERR))
        result = ___EXIT_CODE_SOFTWARE;
      else
        {
          if (___CHARSTRING_to_UCS_2STRING
                (script_line,
                 &___program_startup_info.script_line)
              != ___FIX(___NO_ERR))
            result = ___EXIT_CODE_SOFTWARE;
          else
            {
              ___program_startup_info.hInstance     = hInstance;
              ___program_startup_info.hPrevInstance = hPrevInstance;
              ___program_startup_info.lpCmdLine     = lpCmdLine;
              ___program_startup_info.nCmdShow      = nCmdShow;

              result = ___main (linker);

              ___free_UCS_2STRING (___program_startup_info.script_line);
            }

          free_windows_command_line (___program_startup_info.argv);
        }

      ___cleanup_base_module ();
    }

  return result;
}


#endif


/*---------------------------------------------------------------------------*/

/* Process termination. */


void ___exit_process
   ___P((int status),
        (status)
int status;)
{
  exit (status);
}


/*---------------------------------------------------------------------------*/

/* Error handling. */


void ___fatal_error
   ___P((char **msgs),
        (msgs)
char **msgs;)
{
  if (___setup_params.fatal_error != 0)
    ___setup_params.fatal_error (msgs);
  else
    {
      char *new_msgs[100];
      int i;
      new_msgs[0] = "*** FATAL ERROR -- ";
      for (i=0; i<100-2; i++)
        {
          if (msgs[i] == 0)
            break;
          new_msgs[i+1] = msgs[i];
        }
      new_msgs[i+1] = "\n";
      new_msgs[i+2] = 0;
      ___display_error (new_msgs);
    }

  ___exit_process (___EXIT_CODE_SOFTWARE);
}


void ___display_error
   ___P((char **msgs),
        (msgs)
char **msgs;)
{
  if (___setup_params.display_error != 0)
    ___setup_params.display_error (msgs);
  else if (___DEBUG_SETTINGS_LEVEL(___setup_params.debug_settings) > 0)
    {
      while (*msgs != 0)
        {
          char *msg = *msgs++;
          int len = 0;
          while (msg[len] != '\0')
            len++;
          ___fwrite (msg, 1, len, ___stderr); /* ignore error */
        }
    }
}


/* Conversion of OS error codes to Scheme error codes. */


___HIDDEN char *error_number_to_string
   ___P((int code),
        (code)
int code;)
{
  static char txt[] = "Error code ";
  static char buf[sizeof (txt) + 20]; /* -2^63 is 20 characters in decimal */
  char *p1 = buf + sizeof (buf);
  char *p2;
  int n;

  if (code < 0)
    n = code;
  else
    n = -code;

  *--p1 = '\0';

  do
    {
      *--p1 = '0' + (n/10 * 10 - n);
      n /= 10;
    } while (n != 0);

  if (code < 0)
    *--p1 = '-';

  p2 = txt + sizeof (txt) - 1;

  while (p2 != txt)
    *--p1 = *--p2;

  return p1;
}


#ifdef USE_errno


___HIDDEN char *errno_to_string
   ___P((int code),
        (code)
int code;)
{
#ifdef USE_strerror

  return strerror (code);

#else

  return error_number_to_string (code);

#endif
}


#ifdef ___DEBUG
___SCMOBJ ___err_code_from_errno_debug
   ___P((int lineno,
         char *file),
        (lineno,
         file)
int lineno;
char *file;)
#else
___SCMOBJ ___err_code_from_errno ___PVOID
#endif
{
  int e = errno;

#ifdef ___DEBUG
  ___printf ("*** OS ERROR AT \"%s\"@%d.1 -- errno=%d (%s)\n",
             file,
             lineno,
             e,
             errno_to_string (e));
#endif

  if (e == 0)
    return ___FIX(___UNKNOWN_ERR);

  return ___FIX(___ERRNO_ERR(e));
}


#endif


#ifdef USE_h_errno


___HIDDEN const char *h_errno_to_string
   ___P((int code),
        (code)
int code;)
{
#ifdef USE_hstrerror

  return hstrerror (code);

#else

  static char *h_errno_messages[] =
  {
    "Resolver Error 0 (no error)",
    "Unknown host",
    "Host name lookup failure",
    "Unknown server error",
    "No address associated with name"
  };

  if (code >= 0 && code <= 4)
    return h_errno_messages[code];

  return "Unknown resolver error";

#endif
}


#ifdef ___DEBUG
___SCMOBJ ___err_code_from_h_errno_debug
   ___P((int lineno,
         char *file),
        (lineno,
         file)
int lineno;
char *file;)
#else
___SCMOBJ ___err_code_from_h_errno ___PVOID
#endif
{
  int e = h_errno;

#ifdef ___DEBUG
  ___printf ("*** OS ERROR AT \"%s\"@%d.1 -- h_errno=%d (%s)\n",
             file,
             lineno,
             e,
             h_errno_to_string (e));
#endif

  if (e == NETDB_INTERNAL)
    return err_code_from_errno ();

#ifdef NETDB_WORKS_PROPERLY

  if (e == NETDB_SUCCESS)
    return ___FIX(___UNKNOWN_ERR);

#else

  /* 
   * Linux sometimes returns NETDB_SUCCESS when it should return
   * NETDB_INTERNAL.
   */

  if (e == NETDB_SUCCESS)
    return err_code_from_errno ();

#endif

  return ___FIX(___H_ERRNO_ERR(e));
}


#endif


#ifdef USE_GetLastError


#ifdef ___DEBUG
___SCMOBJ ___err_code_from_GetLastError_debug
   ___P((int lineno,
         char *file),
        (lineno,
         file)
int lineno;
char *file;)
#else
___SCMOBJ ___err_code_from_GetLastError ___PVOID
#endif
{
  DWORD e = GetLastError ();

#ifdef ___DEBUG
  char buf[___ERR_MAX_LENGTH+1];
  DWORD len = FormatMessageA
                (FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_MAX_WIDTH_MASK,
                 NULL,
                 e,
                 MAKELANGID(LANG_NEUTRAL,SUBLANG_DEFAULT),
                 buf,
                 ___ERR_MAX_LENGTH,
                 NULL);
  ___printf ("*** OS ERROR AT \"%s\"@%d.1 -- GetLastError=%d (%s)\n",
             file,
             lineno,
             ___CAST(int,e),
             buf);
#endif

  if (e == NO_ERROR)
    return ___FIX(___UNKNOWN_ERR);

  if (e == ERROR_FILE_NOT_FOUND || e == ERROR_PATH_NOT_FOUND)
    return ___ERR_CODE_ENOENT;

  return ___FIX(___WIN32_ERR(e));
}


#endif


#ifdef USE_WSAGetLastError


#ifdef ___DEBUG
___SCMOBJ ___err_code_from_WSAGetLastError_debug
   ___P((int lineno,
         char *file),
        (lineno,
         file)
int lineno;
char *file;)
#else
___SCMOBJ ___err_code_from_WSAGetLastError ___PVOID
#endif
{
  DWORD e = WSAGetLastError ();

#ifdef ___DEBUG
  char buf[___ERR_MAX_LENGTH+1];
  DWORD len = FormatMessageA
                (FORMAT_MESSAGE_FROM_SYSTEM|FORMAT_MESSAGE_MAX_WIDTH_MASK,
                 NULL,
                 e,
                 MAKELANGID(LANG_NEUTRAL,SUBLANG_DEFAULT),
                 buf,
                 ___ERR_MAX_LENGTH,
                 NULL);
  ___printf ("*** OS ERROR AT \"%s\"@%d.1 -- WSAGetLastError=%d (%s)\n",
             file,
             lineno,
             ___CAST(int,e),
             buf);
#endif

  if (e == NO_ERROR)
    return ___FIX(___UNKNOWN_ERR);

  if (e == WSAEWOULDBLOCK)
    return ___ERR_CODE_EAGAIN;

  return ___FIX(___WIN32_ERR(e));
}


#endif


#ifdef USE_OSErr


___HIDDEN char *OSErr_to_string
   ___P((int code),
        (code)
int code;)
{
  return error_number_to_string (code);
}


#ifdef ___DEBUG
___SCMOBJ ___err_code_from_OSErr_debug
   ___P((OSErr e,
         char *file,
         int lineno)
        (e,
         lineno,
         file)
OSErr e;
int lineno;
char *file;)
#else
___SCMOBJ ___err_code_from_OSErr
   ___P((OSErr e),
        (e)
OSErr e;)
#endif
{
#ifdef ___DEBUG
  ___printf ("*** OS ERROR AT \"%s\"@%d.1 -- OSErr=%d (%s)\n",
             file,
             lineno,
             e,
             OSErr_to_string (e));
#endif

  if (e == noErr)
    return ___FIX(___UNKNOWN_ERR);

  return ___FIX(___OSERR_ERR(e));
}


#endif


/* Conversion of Scheme error codes to error messages. */


___HIDDEN char *c_type_name_table[] =
{
  "int8",
  "unsigned-int8",
  "int16",
  "unsigned-int16",
  "int32",
  "unsigned-int32",
  "int64",
  "unsigned-int64",
  "float32",
  "float64",
  "char",
  "signed-char",
  "unsigned-char",
  "ISO-8859-1",
  "UCS-2",
  "UCS-4",
  "wchar_t",
  "short",
  "unsigned-short",
  "int",
  "unsigned-int",
  "long",
  "unsigned-long",
  "long-long",
  "unsigned-long-long",
  "float",
  "double",
  "struct",
  "union",
  "type",
  "pointer",
  "nonnull-pointer",
  "function",
  "nonnull-function",
  "bool",
  "char-string",
  "nonnull-char-string",
  "nonnull-char-string-list",
  "ISO-8859-1-string",
  "nonnull-ISO-8859-1-string",
  "nonnull-ISO-8859-1-string-list",
  "UTF-8-string",
  "nonnull-UTF-8-string",
  "nonnull-UTF-8-string-list",
  "UTF-16-string",
  "nonnull-UTF-16-string",
  "nonnull-UTF-16-string-list",
  "UCS-2-string",
  "nonnull-UCS-2-string",
  "nonnull-UCS-2-string-list",
  "UCS-4-string",
  "nonnull-UCS-4-string",
  "nonnull-UCS-4-string-list",
  "wchar_t-string",
  "nonnull-wchar_t-string",
  "nonnull-wchar_t-string-list",
  "VARIANT",
  "(heap overflow)"
};


#ifdef USE_WIN32
#ifdef _UNICODE
#define ___ERR_CODE_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___ERR_CODE_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif
#endif

#ifndef ___ERR_CODE_CE_SELECT
#define ___ERR_CODE_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif


___HIDDEN void append_charstring
   ___P((___STRING_TYPE(___ERR_CODE_CE_SELECT) buf,
         int *pos,
         const char *str),
        (buf,
         pos,
         str)
___STRING_TYPE(___ERR_CODE_CE_SELECT) buf;
int *pos;
const char *str;)
{
  int i = 0;
  int p = *pos;

  while (str[i] != '\0')
    {
      if (p >= ___ERR_MAX_LENGTH)
        break;
      buf[p++] = ___CAST(___CHAR_TYPE(___ERR_CODE_CE_SELECT),
                         ___CAST(unsigned char,str[i++]));
    }

  buf[p] = 0;

  *pos = p;
}


___SCMOBJ ___os_err_code_to_string
   ___P((___SCMOBJ err),
        (err)
___SCMOBJ err;)
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  ___ERR_CODE err_code = ___INT(err);
  int facility = ___ERR_CODE_FACILITY(err_code);
  ___CHAR_TYPE(___ERR_CODE_CE_SELECT) buf[___ERR_MAX_LENGTH+1];
  int pos = 0;

  buf[0] = 0;

  if (facility >= ___ERR_CODE_FACILITY_SYSTEM)
    {
      /* System specific error code */

      if (err_code == ___UNWIND_C_STACK)
        append_charstring (buf, &pos, "C stack can't be unwound further");
      else if (err_code == ___SFUN_HEAP_OVERFLOW_ERR)
        append_charstring (buf, &pos, "Heap overflow while allocating stack marker");
      else if (err_code == ___IMPL_LIMIT_ERR)
        append_charstring (buf, &pos, "Implementation limit encountered");
      else if (err_code == ___UNIMPL_ERR)
        append_charstring (buf, &pos, "Unimplemented operation");
      else if (err_code == ___HEAP_OVERFLOW_ERR)
        append_charstring (buf, &pos, "Heap overflow");
      else if (err_code == ___CLOSED_DEVICE_ERR)
        append_charstring (buf, &pos, "Device is closed");
      else if (err_code == ___INVALID_OP_ERR)
        append_charstring (buf, &pos, "Invalid operation");
      else if (err_code == ___MODULE_VERSION_TOO_OLD_ERR)
        append_charstring (buf, &pos, "Module was compiled with an older version of the compiler");
      else if (err_code == ___MODULE_VERSION_TOO_NEW_ERR)
        append_charstring (buf, &pos, "Module was compiled with a newer version of the compiler");
      else if (err_code == ___MODULE_ALREADY_LOADED_ERR)
        append_charstring (buf, &pos, "Can't load a given object file more than once");
      else if (err_code == ___DYNAMIC_LOADING_NOT_AVAILABLE_ERR)
        append_charstring (buf, &pos, "Dynamic loading is not available on this platform");
      else if (err_code == ___DYNAMIC_LOADING_LOOKUP_ERR)
        append_charstring (buf, &pos, "The object file did not contain the required function");
      else if ((err_code >= ___STOC_BASE && err_code <= ___STOC_MAX) ||
               (err_code >= ___CTOS_BASE && err_code <= ___CTOS_MAX))
        {
          int arg_num, c_type_index;
          char *dir;
          if (err_code <= ___STOC_MAX)
            {
              arg_num = (err_code-___STOC_BASE) & ((1<<7)-1);
              c_type_index = (err_code-___STOC_BASE) >> 7;
              dir = "to C";
            }
          else
            {
              arg_num = (err_code-___CTOS_BASE) & ((1<<7)-1);
              c_type_index = (err_code-___CTOS_BASE) >> 7;
              dir = "from C";
            }
          if (arg_num == ___RETURN_POS)
            append_charstring (buf, &pos, "Can't convert result ");
          else if (arg_num == 0)
            append_charstring (buf, &pos, "Can't convert ");
          else
            {
              char digit[2];
              int d = 1;

              while (d < arg_num/10)
                d *= 10;

              append_charstring (buf, &pos, "(Argument ");

              digit[1] = '\0';
              while (d > 0)
                {
                  digit[0] = (arg_num / d % 10) + '0';
                  append_charstring (buf, &pos, digit);
                  d /= 10;
                }

              append_charstring (buf, &pos, ") Can't convert ");
            }
          append_charstring (buf, &pos, dir);
          append_charstring (buf, &pos, " ");
          append_charstring (buf, &pos, c_type_name_table[c_type_index]);
        }
      else
        append_charstring (buf, &pos, "Unknown error");
    }
  else if (facility >= ___ERR_CODE_FACILITY_MACOS)
    {
      /* MACOS error code */

      append_charstring (buf, &pos, "Unknown MACOS error");
    }
  else if (facility >= ___ERR_CODE_FACILITY_ERRNO)
    {
      /* ANSI-C errno error code */

#ifdef USE_errno

      char *msg = errno_to_string (___ERRNO_FROM_ERR_CODE(err_code));

      if (msg == NULL)
        msg = "Unknown error";

      append_charstring (buf, &pos, msg);

#endif
    }
  else if (facility >= ___ERR_CODE_FACILITY_H_ERRNO)
    {
      /* netdb h_errno error code */

#ifdef USE_h_errno

      const char *msg = h_errno_to_string (___H_ERRNO_FROM_ERR_CODE(err_code));

      if (msg == NULL)
        msg = "Unknown error";

      append_charstring (buf, &pos, msg);

#endif
    }
  else
    {
      /* Windows HRESULT error code */

#ifdef USE_FormatMessage

      DWORD len =
        FormatMessage (FORMAT_MESSAGE_FROM_SYSTEM |
                       FORMAT_MESSAGE_MAX_WIDTH_MASK,
                       NULL,
                       ___WIN32_FROM_ERR_CODE(err_code),
                       MAKELANGID(LANG_NEUTRAL,SUBLANG_DEFAULT),
                       buf,
                       ___ERR_MAX_LENGTH,
                       NULL);

      if (len == 0)
        buf[0] = 0;

#endif
    }

  if ((e = ___NONNULLSTRING_to_SCMOBJ
             (buf,
              &result,
              ___RETURN_POS,
              ___CE(___ERR_CODE_CE_SELECT)))
      != ___FIX(___NO_ERR))
    result = e;
  else
    ___release_scmobj (result);

  return result;
}


/*---------------------------------------------------------------------------*/

/* Floating point environment setup. */


___HIDDEN void setup_fp ___PVOID
{
#ifdef USE_get_fpc_csr

  /* Enable denormalized numbers. */

  union fpc_csr csr;

  csr.fc_word = get_fpc_csr ();
  csr.fc_struct.flush = 0;
  set_fpc_csr (csr.fc_word);

#endif

#ifdef USE_control87

#ifdef __LCC__

#define FP_EXC_MASK _MCW_EM
#define FP_EXC_CW \
(_EM_INVALID+_EM_ZERODIVIDE+_EM_OVERFLOW+_EM_UNDERFLOW+_EM_INEXACT+_EM_DENORMAL)

  _control87 (FP_EXC_CW, FP_EXC_MASK);

#else

#define FP_EXC_MASK MCW_EM
#define FP_EXC_CW \
(EM_INVALID+EM_ZERODIVIDE+EM_OVERFLOW+EM_UNDERFLOW+EM_INEXACT+EM_DENORMAL)

  _control87 (FP_EXC_CW, FP_EXC_MASK);

#endif

#endif

#ifdef USE__FPU_SETCW

#define FPU_CW \
(_FPU_MASK_IM+_FPU_MASK_ZM+_FPU_MASK_OM+_FPU_MASK_UM+_FPU_MASK_PM+ \
_FPU_MASK_DM+_FPU_DOUBLE+_FPU_RC_NEAREST)

  fpu_control_t cw = FPU_CW;
  _FPU_SETCW (cw);

#endif
}


___HIDDEN void cleanup_fp ___PVOID
{
}


/*---------------------------------------------------------------------------*/

/* Interrupt handling. */


#ifdef USE_POSIX


void ___set_signal_handler
   ___P((int sig,
         void (*handler) ___P((int sig),())),
        (sig,
         handler)
int sig;
void (*handler) ___P((int sig),());)
{
#ifdef USE_sigaction
  struct sigaction act;
  act.sa_handler = handler;
  act.sa_flags = 0;
#ifdef SA_INTERRUPT
  act.sa_flags |= SA_INTERRUPT;
#endif
  sigemptyset (&act.sa_mask);
  sigaction (sig, &act, 0);
#endif

#ifdef USE_signal
  signal (sig, handler);
#endif
}


#endif


/*---------------------------------------------------------------------------*/

/* Basic OS services module initialization/finalization. */


#ifdef USE_CLASSIC_MACOS


#define test_bit(n,i) ((n)&(1<<(i)))


___HIDDEN TrapType get_trap_type
   ___P((short trap_num),
        (trap_num)
short trap_num;)
{
  /* OS traps start with A0, Tool traps with A8 or AA. */

  if (trap_num & 0x0800)
    return ToolTrap;
  else
    return OSTrap;
}


___HIDDEN short nb_toolbox_traps ___PVOID
{
  /* InitGraf (trap $A86E) is always implemented. */

  if (NGetTrapAddress (0xA86E, ToolTrap) == NGetTrapAddress (0xAA6E, ToolTrap))
    return (0x200);
  else
    return (0x400);
}


___HIDDEN ___BOOL trap_exists
  ___P((short trap_num),
       (trap_num)
short trap_num;)
{
  TrapType typ = get_trap_type (trap_num);
  if ((typ == ToolTrap) && ((trap_num &= 0x07FF) >= nb_toolbox_traps ()))
    return 0;
  return (NGetTrapAddress (_Unimplemented, ToolTrap) !=
          NGetTrapAddress (trap_num, typ));
}


#endif


___SCMOBJ ___setup_base_module ___PVOID
{
  if (___base_mod.refcount == 0)
    {
#ifdef USE_CLASSIC_MACOS

      long response;

      ___base_mod.has_GetUTCDateTime = trap_exists (_UTCDateTime);
      ___base_mod.has_GetDateTime = trap_exists (_GetDateTime);
      ___base_mod.has_ReadLocation = trap_exists (_ReadLocation);
      ___base_mod.has_Delay = trap_exists (_Delay);
      ___base_mod.has_IdleUpdate = trap_exists (_IdleUpdate);
      ___base_mod.has_WaitNextEvent = trap_exists (_WaitNextEvent);
      ___base_mod.has_OSDispatch = trap_exists (_OSDispatch);

      ___base_mod.has_FindFolder =
        (Gestalt (gestaltFindFolderAttr, &response) == noErr &&
         test_bit (response, gestaltFindFolderPresent));

      ___base_mod.has_AliasMgr =
        (Gestalt (gestaltAliasMgrAttr, &response) == noErr &&
         test_bit (response, gestaltAliasMgrPresent));

      ___base_mod.has_AppleEvents =
        (Gestalt (gestaltAppleEventsAttr, &response) == noErr &&
         test_bit (response, gestaltAppleEventsPresent));

#endif

#ifdef ___DEBUG

      ___base_mod.debug = NULL;

#ifdef USE_POSIX
#if 1
      ___base_mod.debug = ___fopen ("console", "w");
#else
      ___base_mod.debug = ___fopen ("/dev/console", "w");
#endif
#endif

#ifdef USE_WIN32
      ___base_mod.debug = ___fopen ("console", "w");
#endif

      if (___base_mod.debug == NULL)
        ___base_mod.debug = ___stderr;

      ___printf ("*** START OF DEBUGGING TRACES\n");

      ___base_mod.alloc_mem_calls = 0;
      ___base_mod.free_mem_calls = 0;

#ifdef ___DEBUG_ALLOC_MEM_TRACE

      ___base_mod.lineno = 0;
      ___base_mod.file = 0;

#endif

#endif

      setup_fp ();
    }

  ___base_mod.refcount++;

  return ___FIX(___NO_ERR);
}


void ___cleanup_base_module ___PVOID
{
  if (--___base_mod.refcount == 0)
    {
      cleanup_fp ();

#ifdef ___DEBUG

      if (___base_mod.alloc_mem_calls != ___base_mod.free_mem_calls)
        {
          ___printf ("*** MEMORY LEAK: alloc_mem_calls = %ld  free_mem_calls = %ld\n",
                     ___base_mod.alloc_mem_calls,
                     ___base_mod.free_mem_calls);
        }

      if (___base_mod.debug != ___stdout)
        ___fclose (___base_mod.debug);

#endif
    }
}


/*---------------------------------------------------------------------------*/
