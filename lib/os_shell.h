/* File: "os_shell.h" */

/* Copyright (c) 1994-2016 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_SHELL_H
#define ___OS_SHELL_H

#include "os.h"


/*---------------------------------------------------------------------------*/


typedef struct ___shell_module_struct
  {
    int refcount;

#ifdef USE_environ

    int environ_unused_at_end;
    ___BOOL environ_was_extended;

#define ___SHELL_MODULE_INIT , 0, 0

#endif
  } ___shell_module;


extern ___shell_module ___shell_mod;


/*---------------------------------------------------------------------------*/

/* Access to shell environment variables. */


/* Determine encoding of environments. */

#ifdef ___ENVIRON_ENCODING_LATIN1
#define ___ENVIRON_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) latin1
#define ___ENVIRON_NAME_LATIN1
#else
#ifdef ___ENVIRON_ENCODING_UTF8
#define ___ENVIRON_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) utf8
#else
#ifdef ___ENVIRON_ENCODING_UCS2
#define ___ENVIRON_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#ifdef ___ENVIRON_ENCODING_UCS4
#define ___ENVIRON_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) ucs4
#else
#ifdef ___ENVIRON_ENCODING_WCHAR
#define ___ENVIRON_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) wchar
#else
#ifdef ___ENVIRON_ENCODING_NATIVE
#define ___ENVIRON_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___ENVIRON_NAME_LATIN1
#endif
#endif
#endif
#endif
#endif
#endif

#ifdef ___ENVIRON_ENCODING

#define ___ENVIRON_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___ENVIRON_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native)

#else

#ifdef USE_WIN32
#ifdef _UNICODE
#define ___ENVIRON_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___ENVIRON_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___ENVIRON_NAME_LATIN1
#endif
#endif

#ifndef ___ENVIRON_CE_SELECT
#define ___ENVIRON_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) utf8
#endif

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
