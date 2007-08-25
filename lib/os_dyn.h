/* File: "os_dyn.h", Time-stamp: <2007-04-04 11:30:48 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_DYN_H
#define ___OS_DYN_H

#include "os.h"


/*---------------------------------------------------------------------------*/


#ifdef USE_shl_load
#define ___DL_DESCR shl_t
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

#ifdef USE_LoadLibrary
#define ___DL_DESCR HMODULE
#ifdef _UNICODE
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

#ifdef USE_DosLoadModule
#define ___DL_DESCR HMODULE
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

#ifdef USE_dxe_load
#define ___DL_DESCR void *
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

#ifdef USE_GetDiskFragment
#define ___DL_DESCR CFragConnectionID
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

#ifdef USE_dlopen
#define ___DL_DESCR void *
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#undef ___IMPORTED_ID_PREFIX
#endif

#ifdef USE_NSLinkModule
#define ___DL_DESCR NSModule
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

#ifndef ___DL_PATH_CE_SELECT
#define ___DL_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#endif

#ifndef ___DL_MODNAME_CE_SELECT
#define ___DL_MODNAME_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#endif


#ifdef ___DL_DESCR

typedef struct ___dl_entry
  {
    struct ___dl_entry *next;
    ___DL_DESCR descr;
  } ___dl_entry;

#endif

typedef struct ___dyn_module_struct
  {
    ___BOOL setup;

#ifdef ___DL_DESCR

    ___dl_entry *dl_list;

#define ___DYN_MODULE_INIT , 0

#endif
  } ___dyn_module;


extern ___dyn_module ___dyn_mod;


/*---------------------------------------------------------------------------*/

/* Dynamic code loading. */


extern ___SCMOBJ ___dynamic_load
   ___P((___SCMOBJ path,
         ___SCMOBJ modname,
         void **linker),
        ());


/*---------------------------------------------------------------------------*/

/* Allocation of C closures. */


#define USE_dynamic_code_gen


extern void *___make_c_closure
   ___P((___SCMOBJ proc,
         void *converter),
        ());

extern ___BOOL ___is_a_c_closure
   ___P((void *fn),
        ());

extern void ___c_closure_release
   ___P((void *c_closure),
        ());

extern void *___c_closure_self ___PVOID;


/*---------------------------------------------------------------------------*/

/* Dynamic code module initialization/finalization. */


extern ___SCMOBJ ___setup_dyn_module ___PVOID;

extern void ___cleanup_dyn_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
