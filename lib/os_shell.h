/* File: "os_shell.h" */

/* Copyright (c) 1994-2015 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_SHELL_H
#define ___OS_SHELL_H

#include "os.h"


/*---------------------------------------------------------------------------*/


typedef struct ___shell_module_struct
  {
    ___BOOL setup;

#ifdef USE_environ

    int environ_unused_at_end;
    ___BOOL environ_was_extended;

#define ___SHELL_MODULE_INIT , 0, 0

#endif
  } ___shell_module;


extern ___shell_module ___shell_mod;


/*---------------------------------------------------------------------------*/

/* Access to shell environment variables. */


#ifdef USE_WIN32
#ifdef _UNICODE
#define ___GETENV_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#define ___SETENV_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#define ___ENVIRON_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#define ENV_CHAR_BYTES 2
#else
#define ___GETENV_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___SETENV_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___ENVIRON_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ENV_CHAR_BYTES 1
#endif
#endif

#ifndef ENV_CHAR_BYTES
#define ENV_CHAR_BYTES 1
#endif


/********************************** obsolete.... use ___getenv_UCS_2 */
char *___getenv
   ___P((char *name),
        ());

extern ___SCMOBJ ___getenv_UCS_2
   ___P((___UCS_2STRING name,
         ___UCS_2STRING *value),
        ());

extern ___SCMOBJ ___setenv_UCS_2
   ___P((___UCS_2STRING name,
         ___UCS_2STRING value),
        ());

extern ___SCMOBJ ___unsetenv_UCS_2
   ___P((___UCS_2STRING name),
        ());

extern ___SCMOBJ ___os_getenv
   ___P((___SCMOBJ name),
        ());

extern ___SCMOBJ ___os_setenv
   ___P((___SCMOBJ name,
         ___SCMOBJ value),
        ());

extern ___SCMOBJ ___os_environ ___PVOID;


/*---------------------------------------------------------------------------*/

/* Shell command. */


/* Max length of a shell command, not including null. */

#define ___CMD_MAX_LENGTH 1024


extern ___SCMOBJ ___os_shell_command
   ___P((___SCMOBJ cmd),
        ());


/*---------------------------------------------------------------------------*/

/* Shell module initialization/finalization. */


extern ___SCMOBJ ___setup_shell_module ___PVOID;

extern void ___cleanup_shell_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
