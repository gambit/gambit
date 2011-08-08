/* File: "os_base.h" */

/* Copyright (c) 1994-2011 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_BASE_H
#define ___OS_BASE_H

#include "os.h"


/*---------------------------------------------------------------------------*/

/* Standard I/O emulation. */


#include <stdio.h>

typedef FILE ___FILE;

#define ___stdin  stdin
#define ___stdout stdout
#define ___stderr stderr

extern ___FILE *___fopen
   ___P((const char *path,
         const char *mode),
        ());

extern int ___fclose
   ___P((___FILE *stream),
        ());

extern size_t ___fread
   ___P((void *ptr,
         size_t size,
         size_t nmemb,
         ___FILE *stream),
        ());

extern size_t ___fwrite
   ___P((const void *ptr,
         size_t size,
         size_t nmemb,
         ___FILE *stream),
        ());

extern int ___fflush
   ___P((___FILE *stream),
        ());

#ifdef ___DEBUG

extern int ___printf
   ___P((const char *format,
         ...),
        ());

#endif


/*---------------------------------------------------------------------------*/


typedef struct ___base_module_struct
  {
    int refcount;

#ifdef ___DEBUG

    ___FILE *debug;

    long alloc_mem_calls;
    long free_mem_calls;

#endif

#ifdef USE_CLASSIC_MACOS

    /* Which features are available. */

    ___BOOL has_GetUTCDateTime;
    ___BOOL has_GetDateTime;
    ___BOOL has_ReadLocation;
    ___BOOL has_Delay;
    ___BOOL has_IdleUpdate;
    ___BOOL has_WaitNextEvent;
    ___BOOL has_OSDispatch;
    ___BOOL has_FindFolder;
    ___BOOL has_AliasMgr;
    ___BOOL has_AppleEvents;

#define ___BASE_MODULE_INIT , 0, 0, 0, 0, 0, 0, 0, 0, 0, 0

#endif
  } ___base_module;


extern ___base_module ___base_mod;


/*---------------------------------------------------------------------------*/

/* Memory allocation. */


/*
 * Does "___alloc_mem" allocate upwards (___ALLOC_MEM_UP) or downwards
 * (___ALLOC_MEM_DOWN).  This setting only affects performance.
 */

#define ___ALLOC_MEM_UP


extern void *___alloc_mem
   ___P((unsigned long bytes),
        ());

extern void ___free_mem
   ___P((void *ptr),
        ());


#ifdef ___DEBUG
#ifdef ___DEBUG_ALLOC_MEM_TRACE

extern void * ___alloc_mem_debug
   ___P((unsigned long bytes,
         int lineno,
         char *file),
        ());

#endif
#endif


/*---------------------------------------------------------------------------*/

/* Program startup. */


extern ___program_startup_info_struct ___program_startup_info;


extern int ___main
   ___P((___mod_or_lnk (*linker)(___global_state_struct*)),
        ());


/*---------------------------------------------------------------------------*/

/* Process termination. */


extern void ___exit_process
   ___P((int status),
        ());


/* Process exit codes (see sysexits.h on many UNIX systems). */

#define ___EXIT_CODE_OK          0
#define ___EXIT_CODE_USAGE       64
#define ___EXIT_CODE_DATAERR     65
#define ___EXIT_CODE_NOINPUT     66
#define ___EXIT_CODE_NOUSER      67
#define ___EXIT_CODE_NOHOST      68
#define ___EXIT_CODE_UNAVAILABLE 69
#define ___EXIT_CODE_SOFTWARE    70
#define ___EXIT_CODE_OSERR       71
#define ___EXIT_CODE_OSFILE      72
#define ___EXIT_CODE_CANTCREAT   73
#define ___EXIT_CODE_IOERR       74
#define ___EXIT_CODE_TEMPFAIL    75
#define ___EXIT_CODE_PROTOCOL    76
#define ___EXIT_CODE_NOPERM      77
#define ___EXIT_CODE_CONFIG      78


/*---------------------------------------------------------------------------*/

/* Error handling. */


/* Max length of an error message, not including null. */

#define ___ERR_MAX_LENGTH 1024


/* 
 * The procedure "___fatal_error" is called by the runtime system when
 * an unrecoverable error has occured.
 */

extern void ___fatal_error
   ___P((char **msgs),
        ());


/* 
 * The procedure "___display_error" is called by the runtime system to
 * send an error message to the user.
 */

extern void ___display_error
   ___P((char **msgs),
        ());


/* Conversion of OS error codes to Scheme error codes. */


/**********************************/
#define err_code_from_errno() ___err_code_from_errno()
#define err_code_from_h_errno() ___err_code_from_h_errno()
#define err_code_from_gai_code(code) ___err_code_from_gai_code(code)
#define err_code_from_GetLastError() ___err_code_from_GetLastError()
#define err_code_from_WSAGetLastError() ___err_code_from_WSAGetLastError()
#define fnf_or_err_code_from_errno() ___fnf_or_err_code_from_errno()
#define fnf_or_err_code_from_GetLastError() ___fnf_or_err_code_from_GetLastError()


#ifdef USE_errno

#ifdef ___DEBUG

extern ___SCMOBJ ___err_code_from_errno_debug
   ___P((int lineno,
         char *file),
        ());

#define ___err_code_from_errno() \
___err_code_from_errno_debug(__LINE__,__FILE__)

#else

extern ___SCMOBJ ___err_code_from_errno ___PVOID;

#endif

#define ___fnf_or_err_code_from_errno() \
___err_code_from_errno()

#define ___ERR_CODE_EAGAIN ___FIX(___ERRNO_ERR(EAGAIN))
#define ___ERR_CODE_ENOENT ___FIX(___ERRNO_ERR(ENOENT))

#endif


#ifdef USE_h_errno

#ifdef ___DEBUG

extern ___SCMOBJ ___err_code_from_h_errno_debug
   ___P((int lineno,
         char *file),
        ());

#define ___err_code_from_h_errno() \
___err_code_from_h_errno_debug(__LINE__,__FILE__)

#else

extern ___SCMOBJ ___err_code_from_h_errno ___PVOID;

#endif

#endif


#ifdef USE_getaddrinfo

#ifdef ___DEBUG

extern ___SCMOBJ ___err_code_from_gai_code_debug
   ___P((int code,
         int lineno,
         char *file),
        ());

#define ___err_code_from_gai_code(code) \
___err_code_from_gai_code_debug(code,__LINE__,__FILE__)

#else

extern ___SCMOBJ ___err_code_from_gai_code
   ___P((int code),
        ());

#endif

#endif


#ifdef USE_GetLastError

#ifdef ___DEBUG

extern ___SCMOBJ ___err_code_from_GetLastError_debug
   ___P((int lineno,
         char *file),
        ());

#define ___err_code_from_GetLastError() \
___err_code_from_GetLastError_debug(__LINE__,__FILE__)

#else

extern ___SCMOBJ ___err_code_from_GetLastError ___PVOID;

#endif

#define ___fnf_or_err_code_from_GetLastError() \
___err_code_from_GetLastError()

#define ___ERR_CODE_ERROR_FILE_NOT_FOUND \
___FIX(___WIN32_ERR(ERROR_FILE_NOT_FOUND))

#endif


#ifdef USE_WSAGetLastError
#ifdef ___DEBUG

extern ___SCMOBJ ___err_code_from_WSAGetLastError_debug
   ___P((int lineno,
         char *file),
        ());

#define ___err_code_from_WSAGetLastError() \
___err_code_from_WSAGetLastError_debug(__LINE__,__FILE__)

#else

extern ___SCMOBJ ___err_code_from_WSAGetLastError ___PVOID;

#endif
#endif


#ifdef USE_OSErr
#ifdef ___DEBUG

extern ___SCMOBJ ___err_code_from_OSErr_debug
   ___P((OSErr e,
         int lineno,
         char *file),
        ());

#define ___err_code_from_OSErr(e) \
___err_code_from_OSErr_debug(e,__LINE__,__FILE__)

#else

extern ___SCMOBJ ___err_code_from_OSErr
   ___P((OSErr e),
        ());

#endif
#endif


/* Conversion of Scheme error codes to error messages. */

extern ___SCMOBJ ___os_err_code_to_string
   ___P((___SCMOBJ err),
        ());


/*---------------------------------------------------------------------------*/

/* Interrupt handling. */


extern void ___set_signal_handler
   ___P((int sig,
         void (*handler) ___P((int sig),())),
        ());


/*---------------------------------------------------------------------------*/

/* Basic OS services module initialization/finalization. */


extern ___SCMOBJ ___setup_base_module ___PVOID;

extern void ___cleanup_base_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
