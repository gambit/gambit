/* File: "os_shell.c", Time-stamp: <2009-03-14 09:15:57 feeley> */

/* Copyright (c) 1994-2009 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * related to the shell.
 */

#define ___INCLUDED_FROM_OS_SHELL
#define ___VERSION 406002
#include "gambit.h"

#include "os_base.h"
#include "os_shell.h"
#include "os_files.h"


/*---------------------------------------------------------------------------*/


___shell_module ___shell_mod =
{
  0

#ifdef ___SHELL_MODULE_INIT
  ___SHELL_MODULE_INIT
#endif
};


/*---------------------------------------------------------------------------*/

/* Access to shell environment variables. */


/****************** obsolete.... use ___getenv_UCS_2 */
char *___getenv
   ___P((char *name),
        (name)
char *name;)
{
  return getenv (name);
}


#define GETENV_NAME_STATIC_SIZE   128
#define GETENV_VALUE_STATIC_SIZE  128
#define SETENV_NAME_STATIC_SIZE   128
#define SETENV_VALUE_STATIC_SIZE  128
#define UNSETENV_NAME_STATIC_SIZE 128


___SCMOBJ ___getenv_UCS_2
   ___P((___UCS_2STRING name,
         ___UCS_2STRING *value),
        (name,
         value)
___UCS_2STRING name;
___UCS_2STRING *value;)
{
  ___SCMOBJ e;
  ___UCS_2STRING v;
  ___UCS_2STRING p1;
  int name_len;

  /* reject strings that contain "=" except as the first character */

  p1 = name;

  if (*p1 == '=')
    p1++;

  while (*p1 != '\0')
    {
#if ENV_CHAR_BYTES == 1
      if (*p1 > 255)
        return ___FIX(___IMPL_LIMIT_ERR);
#endif
      if (*p1++ == '=')
        return ___FIX(___IMPL_LIMIT_ERR);
    }

  name_len = p1 - name;

  /* find in the environment a string of the form name=value */

  e = ___FIX(___NO_ERR);
  *value = 0;

#ifdef USE_environ

  {
    char **probe;
    char *p2;

    probe = environ;

    while ((p2 = *probe++) != 0)
      {
        p1 = name;

        while (*p1 != '\0' &&
               *p1 == ___CAST(___UCS_2,___CAST(unsigned char,*p2)))
          {
            p1++;
            p2++;
          }

        if (*p1 == '\0' && *p2 == '=')
          {
            int len = 0;

            p2++;

            while (p2[len] != '\0')
              len++;

            v = ___CAST(___UCS_2STRING,
                        ___alloc_mem (sizeof (___UCS_2) * (len+1)));

            if (v == 0)
              return ___FIX(___HEAP_OVERFLOW_ERR);

            do
              {
                v[len] = ___CAST(___UCS_2,___CAST(unsigned char,p2[len]));
              } while (len-- > 0);

            *value = v;
          }
      }
  }

#else

  {
#if ENV_CHAR_BYTES == 1

    char *cvalue_ptr = 0;
    char cname[GETENV_NAME_STATIC_SIZE];
    char *cname_ptr = cname;

    if (name_len >= GETENV_NAME_STATIC_SIZE)
      {
        cname_ptr = ___CAST(char*,
                            ___alloc_mem (sizeof (*cname_ptr)
                                          * (name_len+1)));

        if (cname_ptr == 0)
          return ___FIX(___HEAP_OVERFLOW_ERR);
      }

    do
      {
        cname_ptr[name_len] = name[name_len];
      } while (name_len-- > 0);

#else

    ___UCS_2 *cvalue_ptr = 0;
    ___UCS_2 *cname_ptr = name;

#endif

#ifndef USE_getenv
#ifndef USE_GetEnvironmentVariable

    if (cvalue_ptr != 0)

#endif
#endif

#ifdef USE_getenv

    cvalue_ptr = getenv (cname_ptr);

    if (cvalue_ptr != 0)

#endif

#ifdef USE_GetEnvironmentVariable

    {
      ___CHAR_TYPE(___GETENV_CE_SELECT) cvalue[GETENV_VALUE_STATIC_SIZE];
      int n;

      cvalue_ptr = cvalue;

      n = GetEnvironmentVariable
            (cname_ptr,
             cvalue_ptr,
             GETENV_VALUE_STATIC_SIZE);

      if (n >= GETENV_VALUE_STATIC_SIZE)
        {
          cvalue_ptr = ___CAST(___CHAR_TYPE(___GETENV_CE_SELECT)*,
                               ___alloc_mem (sizeof (*cvalue_ptr) * n));

          if (cvalue_ptr != 0)
            n = GetEnvironmentVariable
                  (cname_ptr,
                   cvalue_ptr,
                   n);
        }

      if (cvalue_ptr == 0)
        e = ___FIX(___HEAP_OVERFLOW_ERR);
      else if (n > 0)

#endif

        {
          ___UCS_2STRING v;
          int len = 0;

          while (cvalue_ptr[len] != '\0')
            len++;

          v = ___CAST(___UCS_2STRING,
                      ___alloc_mem (sizeof (___UCS_2) * (len+1)));

          if (v == 0)
            e = ___FIX(___HEAP_OVERFLOW_ERR);
          else
            {
              do
                {
                  v[len] = ___CAST(___UCS_2,cvalue_ptr[len]);
                } while (len-- > 0);

              *value = v;
            }
        }

#ifdef USE_GetEnvironmentVariable

      if (cvalue_ptr != cvalue)
        ___free_mem (cvalue_ptr);
    }

#endif

#if ENV_CHAR_BYTES == 1

    if (cname_ptr != cname)
      ___free_mem (cname_ptr);

#endif
  }

#endif

  return e;
}


___SCMOBJ ___setenv_UCS_2
   ___P((___UCS_2STRING name,
         ___UCS_2STRING value),
        (name,
         value)
___UCS_2STRING name;
___UCS_2STRING value;)
{
  ___SCMOBJ e;
  ___UCS_2STRING p1;
  int name_len;
  int value_len;

  /* reject strings that contain "=" except as the first character */

  p1 = name;

  if (*p1 == '=')
    p1++;

  while (*p1 != '\0')
    {
#if ENV_CHAR_BYTES == 1
      if (*p1 > 255)
        return ___FIX(___IMPL_LIMIT_ERR);
#endif
      if (*p1++ == '=')
        return ___FIX(___IMPL_LIMIT_ERR);
    }

  name_len = p1 - name;

  p1 = value;

  while (*p1 != '\0')
    {
#if ENV_CHAR_BYTES == 1
      if (*p1 > 255)
        return ___FIX(___IMPL_LIMIT_ERR);
#endif
      p1++;
    }

  value_len = p1 - value;

  /* find in the environment a string of the form name=value */

  e = ___FIX(___NO_ERR);

#ifdef USE_environ

  {
    char **old_environ = environ;
    char **probe;
    char *p2;

    char *name_value = ___CAST(char*,
                               ___alloc_mem (name_len + value_len + 2));

    if (name_value == 0)
      return ___FIX(___HEAP_OVERFLOW_ERR);

    p2 = name_value;

    p1 = name;

    while (name_len > 0)
      {
        *p2++ = ___CAST(char,*p1++);
        name_len--;
      }

    *p2++ = '=';

    p1 = value;

    while (value_len > 0)
      {
        *p2++ = ___CAST(char,*p1++);
        value_len--;
      }

    *p2++ = '\0';

    probe = old_environ;

    while ((p2 = *probe++) != 0)
      {
        p1 = name;

        while (*p1 != '\0' &&
               *p1 == ___CAST(___UCS_2,___CAST(unsigned char,*p2)))
          {
            p1++;
            p2++;
          }

        if (*p1 == '\0' && *p2 == '=')
          {
            probe[-1] = name_value;
            return ___FIX(___NO_ERR);
          }
      }

    if (___shell_mod.environ_unused_at_end > 0)
      {
        probe[-1] = name_value;
        probe[0] = 0;
        ___shell_mod.environ_unused_at_end--;
        return ___FIX(___NO_ERR);
      }
    else
      {
        char **new_environ;
        int n = probe - old_environ; /* length including null pointer at end */

        ___shell_mod.environ_unused_at_end = n/2 + 1;

        new_environ =
          ___CAST(char**,
                  ___alloc_mem ((n + ___shell_mod.environ_unused_at_end)
                                * sizeof (char*)));

        if (new_environ == 0)
          {
            ___free_mem (name_value);
            return ___FIX(___HEAP_OVERFLOW_ERR);
          }

        environ = new_environ;
        probe = old_environ;

        while (--n > 0)
          *new_environ++ = *probe++;

        *new_environ++ = name_value;
        *new_environ++ = 0;

        ___shell_mod.environ_unused_at_end--;

        if (___shell_mod.environ_was_extended)
          ___free_mem (old_environ);

        ___shell_mod.environ_was_extended = 1;
      }
  }

#else

  {
#if ENV_CHAR_BYTES == 1

    char *cname_ptr;
    char *cvalue_ptr;
    char cname[SETENV_NAME_STATIC_SIZE];
    char cvalue[SETENV_VALUE_STATIC_SIZE];

    if (name_len < SETENV_NAME_STATIC_SIZE)
      cname_ptr = cname;
    else
      {
        cname_ptr = ___CAST(char*,
                            ___alloc_mem (sizeof (*cname_ptr)
                                          * (name_len+1)));

        if (cname_ptr == 0)
          return ___FIX(___HEAP_OVERFLOW_ERR);
      }

    do
      {
        cname_ptr[name_len] = name[name_len];
      } while (name_len-- > 0);

    if (value_len < SETENV_VALUE_STATIC_SIZE)
      cvalue_ptr = cvalue;
    else
      {
        cvalue_ptr = ___CAST(char*,
                             ___alloc_mem (sizeof (*cvalue_ptr)
                                           * (value_len+1)));

        if (cvalue_ptr == 0)
          {
            if (cname_ptr != cname)
              ___free_mem (cname_ptr);

            return ___FIX(___HEAP_OVERFLOW_ERR);
          }
      }

    do
      {
        cvalue_ptr[value_len] = value[value_len];
      } while (value_len-- > 0);

#else

    ___UCS_2 *cname_ptr = name;
    ___UCS_2 *cvalue_ptr = value;

#endif

#ifdef USE_setenv

    if (setenv (cname_ptr, cvalue_ptr, 1) < 0)
      e = err_code_from_errno ();

#endif

#ifdef USE_SetEnvironmentVariable

    if (!SetEnvironmentVariable (cname_ptr, cvalue_ptr))
      e = err_code_from_GetLastError ();

#endif

#if ENV_CHAR_BYTES == 1

    if (cvalue_ptr != cvalue)
      ___free_mem (cvalue_ptr);

    if (cname_ptr != cname)
      ___free_mem (cname_ptr);

#endif
  }

#endif

  return e;
}


___SCMOBJ ___unsetenv_UCS_2
   ___P((___UCS_2STRING name),
        (name)
___UCS_2STRING name;)
{
  ___SCMOBJ e;
  ___UCS_2STRING p1;
  int name_len;

  /* reject strings that contain "=" except as the first character */

  p1 = name;

  if (*p1 == '=')
    p1++;

  while (*p1 != '\0')
    {
#if ENV_CHAR_BYTES == 1
      if (*p1 > 255)
        return ___FIX(___IMPL_LIMIT_ERR);
#endif
      if (*p1++ == '=')
        return ___FIX(___IMPL_LIMIT_ERR);
    }

  name_len = p1 - name;

  /* find in the environment a string of the form name=value */

  e = ___FIX(___NO_ERR);

#ifdef USE_environ

  {
    char **probe;
    char *p2;

    probe = environ;

    while ((p2 = *probe++) != 0)
      {
        p1 = name;

        while (*p1 != '\0' &&
               *p1 == ___CAST(___UCS_2,___CAST(unsigned char,*p2)))
          {
            p1++;
            p2++;
          }

        if (*p1 == '\0' && *p2 == '=')
          {
            ___shell_mod.environ_unused_at_end++;

            while ((probe[-1] = probe[0]) != 0)
              probe++;

            return ___FIX(___NO_ERR);
          }
      }
  }

#else

  {
#if ENV_CHAR_BYTES == 1

    char *cname_ptr;
    char cname[UNSETENV_NAME_STATIC_SIZE];

    if (name_len < UNSETENV_NAME_STATIC_SIZE)
      cname_ptr = cname;
    else
      {
        cname_ptr = ___CAST(char*,
                            ___alloc_mem (sizeof (*cname_ptr)
                                          * (name_len+1)));

        if (cname_ptr == 0)
          return ___FIX(___HEAP_OVERFLOW_ERR);
      }

    do
      {
        cname_ptr[name_len] = name[name_len];
      } while (name_len-- > 0);

#else

    ___UCS_2 *cname_ptr = name;

#endif

#ifdef USE_unsetenv

    if (unsetenv (cname_ptr) < 0)
      e = err_code_from_errno ();

#endif

#ifdef USE_SetEnvironmentVariable

    if (!SetEnvironmentVariable (cname_ptr, 0))
      {
        e = err_code_from_GetLastError ();

        /*
         * Apparently an error is signaled if the environment
         * variable being removed does not exist (the Microsoft
         * documentation does not mention this).
         */

        if (e == ___FIX(___WIN32_ERR(ERROR_ENVVAR_NOT_FOUND)))
          e = ___FIX(___NO_ERR);
      }

#endif

#if ENV_CHAR_BYTES == 1

    if (cname_ptr != cname)
      ___free_mem (cname_ptr);

#endif
  }

#endif

  return e;
}


___SCMOBJ ___os_getenv
   ___P((___SCMOBJ name),
        (name)
___SCMOBJ name;)
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  ___UCS_2STRING cname;
  ___UCS_2STRING cvalue;

  if ((e = ___SCMOBJ_to_NONNULLUCS_2STRING
             (name,
              &cname,
              1))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      if ((e = ___getenv_UCS_2 (cname, &cvalue)) != ___FIX(___NO_ERR))
        result = e;
      else
        {
          if ((e = ___UCS_2STRING_to_SCMOBJ
                     (cvalue,
                      &result,
                      ___RETURN_POS))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);

          if (cvalue != 0)
            ___free_mem (cvalue);
        }

      ___release_string (cname);
    }

  return result;
}


___SCMOBJ ___os_setenv
   ___P((___SCMOBJ name,
         ___SCMOBJ value),
        (name,
         value)
___SCMOBJ name;
___SCMOBJ value;)
{
  ___SCMOBJ e;
  ___UCS_2STRING cname;
  ___UCS_2STRING cvalue;

  if ((e = ___SCMOBJ_to_NONNULLUCS_2STRING
             (name,
              &cname,
              1))
      == ___FIX(___NO_ERR))
    {
      if (value == ___ABSENT)
        e = ___unsetenv_UCS_2 (cname);
      else if ((e = ___SCMOBJ_to_NONNULLUCS_2STRING
                      (value,
                       &cvalue,
                       2))
               == ___FIX(___NO_ERR))
        {
          e = ___setenv_UCS_2 (cname, cvalue);
          ___release_string (cvalue);
        }

      ___release_string (cname);
    }

  return e;
}


___SCMOBJ ___os_environ ___PVOID
{
  ___SCMOBJ e;
  ___SCMOBJ result;

#ifndef USE_environ
#ifndef USE_GetEnvironmentStrings

  result = ___NUL;

#endif
#endif

#ifdef USE_environ

  if ((e = ___NONNULLCHARSTRINGLIST_to_SCMOBJ
             (environ,
              &result,
              ___RETURN_POS))
      != ___FIX(___NO_ERR))
    result = e;
  else
    ___release_scmobj (result);

#endif

#ifdef USE_GetEnvironmentStrings

  ___STRING_TYPE(___ENVIRON_CE_SELECT) env;
  ___STRING_TYPE(___ENVIRON_CE_SELECT) ptr;
  ___SCMOBJ pair;
  ___SCMOBJ str;

  e = ___FIX(___NO_ERR);
  result = ___NUL;

  env = GetEnvironmentStrings ();

  if (env != 0 && *env != 0)
    {
      ptr = env;

      /* find end of environment strings. */

      do
        {
          do { ptr++; } while (*ptr != 0);
          ptr++; /* skip null char at end of string */
        } while (*ptr != 0);

      while (ptr > env)
        {
          ptr--; /* move ptr to terminating null char of previous string */

          while (ptr > env && ptr[-1] != 0)
            ptr--;

          if ((e = ___NONNULLSTRING_to_SCMOBJ
                     (ptr,
                      &str,
                      ___RETURN_POS,
                      ___CE(___ENVIRON_CE_SELECT)))
              != ___FIX(___NO_ERR))
            break;

          pair = ___make_pair (str, result, ___STILL);

          ___release_scmobj (str);
          ___release_scmobj (result);

          if (___FIXNUMP(pair))
            {
              e = ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
              break;
            }

          result = pair;
        }

      ___release_scmobj (result);
    }

  if (env != 0)
    if (!FreeEnvironmentStrings (env))
      e = err_code_from_GetLastError ();

  if (e != ___FIX(___NO_ERR))
    result = e;

#endif

  return result;
}


/*---------------------------------------------------------------------------*/

/* Shell command. */


___SCMOBJ ___os_shell_command
   ___P((___SCMOBJ cmd,
         ___SCMOBJ dir),
        (cmd,
         dir)
___SCMOBJ cmd;
___SCMOBJ dir;)
{
  ___SCMOBJ e;

#ifndef USE_POSIX
#ifndef USE_WIN32

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_POSIX

  char *ccmd;

  if ((e = ___SCMOBJ_to_NONNULLCHARSTRING
             (cmd,
              &ccmd,
              1))
      == ___FIX(___NO_ERR))
    {
      void *cdir;

      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (dir,
                  &cdir,
                  2,
                  ___CE(___PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          int code;

          ___CHAR_TYPE(___PATH_CE_SELECT) old_dir[___PATH_MAX_LENGTH+1];

          if (getcwd (old_dir, ___PATH_MAX_LENGTH) == 0)
            e = err_code_from_errno ();
          else
            {
              if (chdir (___CAST(___STRING_TYPE(___PATH_CE_SELECT),cdir)) < 0)
                e = err_code_from_errno ();
              else
                {
                  ___disable_os_interrupts ();

                  code = system (ccmd);

                  if (code == -1)
                    e = err_code_from_errno ();
                  else
                    e = ___FIX(code & ___MAX_FIX);

                  ___enable_os_interrupts ();

                  chdir (old_dir); /* ignore error */
                }
            }

          ___release_string (cdir);
        }

      ___release_string (ccmd);
    }

#endif

#ifdef USE_WIN32

#ifdef _UNICODE
#define ___SHELL_COMMAND_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___SHELL_COMMAND_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  void *ccmd;

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (cmd,
              &ccmd,
              1,
              ___CE(___SHELL_COMMAND_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      void *cdir;

      if ((e = ___SCMOBJ_to_STRING
                 (dir,
                  &cdir,
                  2,
                  ___CE(___PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          DWORD n;

          ___CHAR_TYPE(___PATH_CE_SELECT) old_dir[___PATH_MAX_LENGTH+1];

          n = GetCurrentDirectory (___PATH_MAX_LENGTH+1,
                                   old_dir);

          if (n < 1 || n > ___PATH_MAX_LENGTH)
            e = err_code_from_GetLastError ();
          else
            {
              if (!SetCurrentDirectory (___CAST(___STRING_TYPE(___PATH_CE_SELECT),cdir)))
                e = err_code_from_GetLastError ();
              else
                {

#ifdef ___DO_NOT_USE_system

                  /*
                   * This code does not really cause the shell to run
                   * the command.  This means that the shell builtin
                   * commands (such as "DIR" cannot be executed.  It
                   * is better to use "system" and "_wsystem".
                   */

                  DWORD code;
                  STARTUPINFO si;
                  PROCESS_INFORMATION pi;

                  ZeroMemory (&si, sizeof (si));
                  si.cb = sizeof (si);
                  ZeroMemory (&pi, sizeof (pi));

                  if (!CreateProcess
                         (NULL,  /* module name                              */
                          ___CAST(___STRING_TYPE(___SHELL_COMMAND_CE_SELECT),ccmd),
                          NULL,  /* process handle not inheritable           */
                          NULL,  /* thread handle not inheritable            */
                          FALSE, /* set handle inheritance to FALSE          */
                          0,     /* no creation flags                        */
                          NULL,  /* use parent's environment block           */
                          NULL,  /* use parent's starting directory          */
                          &si,   /* pointer to STARTUPINFO structure         */
                          &pi))  /* pointer to PROCESS_INFORMATION structure */
                    e = err_code_from_GetLastError ();
                  else
                    {
                      if (WaitForSingleObject (pi.hProcess, INFINITE) == WAIT_FAILED ||
                          !GetExitCodeProcess (pi.hProcess, &code))
                        e = err_code_from_GetLastError ();
                      else
                        e = ___FIX(code & ___MAX_FIX);

                      CloseHandle (pi.hProcess); /* ignore error */
                      CloseHandle (pi.hThread); /* ignore error */
                    }

#else

                  int code;

#ifdef _UNICODE
                  code = _wsystem (___CAST(___STRING_TYPE(___SHELL_COMMAND_CE_SELECT),ccmd));
#else
                  code = system (___CAST(___STRING_TYPE(___SHELL_COMMAND_CE_SELECT),ccmd));
#endif

                  if (code == -1)
                    e = err_code_from_errno ();
                  else
                    e = ___FIX(code & ___MAX_FIX);

#endif

                  SetCurrentDirectory (old_dir); /* ignore error */
                }
            }

          ___release_string (cdir);
        }

      ___release_string (ccmd);
    }

#endif

  return e;
}


/*---------------------------------------------------------------------------*/

/* Shell module initialization/finalization. */


___SCMOBJ ___setup_shell_module ___PVOID
{
  if (!___shell_mod.setup)
    {
#ifdef USE_environ

      ___shell_mod.environ_unused_at_end = 0;
      ___shell_mod.environ_was_extended = 0;

#endif

      ___shell_mod.setup = 1;
      return ___FIX(___NO_ERR);
    }

  return ___FIX(___UNKNOWN_ERR);
}


void ___cleanup_shell_module ___PVOID
{
  if (___shell_mod.setup)
    {
#ifdef USE_environ

      if (___shell_mod.environ_was_extended)
        ___free_mem (environ);

#endif

      ___shell_mod.setup = 0;
    }
}


/*---------------------------------------------------------------------------*/
