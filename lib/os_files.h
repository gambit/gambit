/* File: "os_files.h" */

/* Copyright (c) 1994-2015 by Marc Feeley, All Rights Reserved. */

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


/* Determine path separator. */

#if 0
#ifdef USE_WIN32
/* Force path separator to be forward slash. */
#define ___CANONICAL_PATH_SEPARATOR '/'
#endif
#endif

#ifdef ___CANONICAL_PATH_SEPARATOR

#define CANONICALIZE_PATH(string_type, path) \
do {                                                      \
  string_type p = path;                                   \
  if (___CANONICAL_PATH_SEPARATOR == '/')                 \
    while (*p != '\0') { if (*p == '\\') *p = '/'; p++; } \
  else                                                    \
    while (*p != '\0') { if (*p == '/') *p = '\\'; p++; } \
} while (0)

#else

#define CANONICALIZE_PATH(string_type, path)

#endif


/* Determine encoding of filesystem paths. */

#ifdef ___PATH_ENCODING_LATIN1
#define ___PATH_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) latin1
#else
#ifdef ___PATH_ENCODING_UTF8
#define ___PATH_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) utf8
#else
#ifdef ___PATH_ENCODING_UCS2
#define ___PATH_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#ifdef ___PATH_ENCODING_UCS4
#define ___PATH_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) ucs4
#else
#ifdef ___PATH_ENCODING_WCHAR
#define ___PATH_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) wchar
#else
#ifdef ___PATH_ENCODING_NATIVE
#define ___PATH_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif
#endif
#endif
#endif
#endif
#endif

#ifdef ___PATH_ENCODING

#define ___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_ENCODING(latin1,utf8,ucs2,ucs4,wchar,native)

#else

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

#endif

#define ___STREAM_OPEN_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___DIR_OPEN_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___TIMES_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___INFO_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___CREATE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___CREATE_FIFO_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___CREATE_LINK_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___CREATE_SYMLINK_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___DELETE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___SET_CURRENT_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___RENAME_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___COPY_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)

#define ___DELETE_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) \
___PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native)


extern ___SCMOBJ ___os_path_homedir ___PVOID;

extern ___SCMOBJ ___os_path_gambitdir ___PVOID;

extern ___SCMOBJ ___os_path_gambitdir_map_lookup
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
