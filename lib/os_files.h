/* File: "os_files.h", Time-stamp: <2008-12-09 16:15:30 feeley> */

/* Copyright (c) 1994-2008 by Marc Feeley, All Rights Reserved. */

#ifndef ___OS_FILES_H
#define ___OS_FILES_H


/*---------------------------------------------------------------------------*/

/**********************************/
#include "os.h"

typedef struct ___files_module_struct
  {
    ___BOOL setup;

  } ___files_module;


extern ___files_module ___files_mod;


/*---------------------------------------------------------------------------*/

/* File system path expansion. */


/* Max length of a path, not including null. */

#define ___PATH_MAX_LENGTH 1024


#ifdef USE_WIN32
#ifdef _UNICODE
#define ___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif
#endif

#ifndef ___PATH_CE_SELECT
#define ___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) utf8
#endif


extern ___SCMOBJ ___os_path_homedir ___PVOID;

extern ___SCMOBJ ___os_path_gambcdir ___PVOID;

extern ___SCMOBJ ___os_path_gambcdir_map_lookup
   ___P((___SCMOBJ dir),
        ());

extern ___SCMOBJ ___os_path_normalize_directory
   ___P((___SCMOBJ path),
        ());


/*---------------------------------------------------------------------------*/

/* File system operations. */


extern ___SCMOBJ ___os_create_directory
   ___P((___SCMOBJ path,
         ___SCMOBJ mode),
        ());

extern ___SCMOBJ ___os_create_fifo
   ___P((___SCMOBJ path,
         ___SCMOBJ mode),
        ());

extern ___SCMOBJ ___os_create_link
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        ());

extern ___SCMOBJ ___os_create_symbolic_link
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        ());

extern ___SCMOBJ ___os_delete_directory
   ___P((___SCMOBJ path),
        ());

extern ___SCMOBJ ___os_set_current_directory
   ___P((___SCMOBJ path),
        ());

extern ___SCMOBJ ___os_rename_file
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        ());

extern ___SCMOBJ ___os_copy_file
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        ());

extern ___SCMOBJ ___os_delete_file
   ___P((___SCMOBJ path),
        ());


/*---------------------------------------------------------------------------*/

/* File system module initialization/finalization. */


extern ___SCMOBJ ___setup_files_module ___PVOID;

extern void ___cleanup_files_module ___PVOID;


/*---------------------------------------------------------------------------*/


#endif
