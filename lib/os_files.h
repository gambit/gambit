/* File: "os_files.h", Time-stamp: <2007-04-04 11:31:00 feeley> */

/* Copyright (c) 1994-2007 by Marc Feeley, All Rights Reserved. */

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


extern ___SCMOBJ ___os_path_homedir ___PVOID;

extern ___SCMOBJ ___os_path_gambcdir ___PVOID;

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
