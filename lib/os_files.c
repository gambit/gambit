/* File: "os_files.c" */

/* Copyright (c) 1994-2013 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * related to the file system.
 */

#define ___INCLUDED_FROM_OS_FILES
#define ___VERSION 407003
#include "gambit.h"

#include "os_base.h"
#include "os_shell.h"
#include "os_files.h"
#include "setup.h"


/*---------------------------------------------------------------------------*/


___files_module ___files_mod =
{
  0

#ifdef ___FILES_MODULE_INIT
  ___FILES_MODULE_INIT
#endif
};


/*---------------------------------------------------------------------------*/

#ifdef USE_CLASSIC_MACOS


/* String conversion utilities. */

___HIDDEN Boolean c2pascal
   ___P((char *cstr,
         StringPtr pstr,
         int max_length),
        (cstr,
         pstr,
         max_length)
char *cstr;
StringPtr pstr;
int max_length;)
{
  StringPtr p1 = pstr+1;
  char *p2 = cstr;
  while (max_length > 0 && *p2 != '\0')
    {
       *p1++ = *p2++;
       max_length--;
    }
  if (*p2 != '\0')
    return 0;
  else
    {
      pstr[0] = p2-cstr;
      return 1;
    }
}


___HIDDEN Boolean pascal2c
   ___P((StringPtr pstr,
         char *cstr,
         int max_length),
        (pstr,
         cstr,
         max_length)
StringPtr pstr;
char *cstr;
int max_length;)
{
  char *p1 = cstr;
  StringPtr p2 = pstr+1;
  int len = pstr[0];
  if (len > max_length)
    return 0;
  else
    {
      while (len-- > 0)
        *p1++ = *p2++;
      *p1++ = '\0';
      return 1;
    }
}


#define DIR_SEPARATOR1 ':'
#define PARENT_HOP ":"

#define DIR_SEPARATOR(c)((c) == DIR_SEPARATOR1)
#define SEPARATOR(c)DIR_SEPARATOR(c)


___HIDDEN OSErr make_ResolvedFSSpec
   ___P((short vol,
         long dir,
         ConstStr255Param path,
         FSSpec *spec),
        (vol,
         dir,
         path,
         spec)
short vol;
long dir;
ConstStr255Param path;
FSSpec *spec;)
{
  OSErr err;
  Str255 name;
  StringPtr start = ___CAST(StringPtr,path+1);
  StringPtr end = start + path[0];
  StringPtr p1 = start;
  StringPtr p2 = name+1;
  CInfoPBRec pb;
  Boolean is_folder;
  Boolean is_aliased;

  if (!has_AliasMgr)
    return unimpErr;

  spec->vRefNum = vol;
  spec->parID = dir;

  do
    {
      p2 = name+1;
      while (p1 < end && DIR_SEPARATOR(*p1))  /* copy leading ':'s */
        *p2++ = *p1++;
      while (p1 < end && !DIR_SEPARATOR(*p1)) /* copy name that follows */
        *p2++ = *p1++;
      if (p1 < end && DIR_SEPARATOR(*p1))     /* end with a ':' if folder */
        *p2++ = DIR_SEPARATOR1;
      name[0] = p2 - (name+1);

      err = FSMakeFSSpec (spec->vRefNum, spec->parID, name, spec);
      if (err == fnfErr && p1 == end)
        return noErr;
      if (err != noErr)
        return err;

      if ((err = ResolveAliasFile (spec, 1, &is_folder, &is_aliased)) != noErr)
        return err;
      if (is_folder)
        {
          pb.dirInfo.ioNamePtr = spec->name;
          pb.dirInfo.ioVRefNum = spec->vRefNum;
          pb.dirInfo.ioDrDirID = spec->parID;
          pb.dirInfo.ioFDirIndex = 0;
          if ((err = PBGetCatInfoSync (&pb)) != noErr)
            return err;
          spec->parID = pb.hFileInfo.ioDirID;
          spec->name[0] = 0;
        }
      else if (p1 < end)
        return dirNFErr;
    } while (p1 < end);

  return noErr;
}


___HIDDEN OSErr ResolvedFSSpec_to_fullpath
   ___P((FSSpec *spec,
         StringPtr fullpath),
        (spec,
         fullpath)
FSSpec *spec;
StringPtr fullpath;)
{
  OSErr err;
  int i;
  Str255 result;
  StringPtr p = result + sizeof(result);
  CInfoPBRec pb;
  Str31 name;

  for (i = spec->name[0]; i > 0; i--)
    *--p = spec->name[i];

  pb.dirInfo.ioNamePtr = name;
  pb.dirInfo.ioVRefNum = spec->vRefNum;
  pb.dirInfo.ioDrParID = spec->parID;
  pb.dirInfo.ioFDirIndex = -1;

  do
    {
      pb.dirInfo.ioDrDirID = pb.dirInfo.ioDrParID;
      if ((err = PBGetCatInfoSync (&pb)) != noErr)
        return err;
      if (p-name[0]-1 < result)
        return bdNamErr; /* file name is too long */
      *--p = DIR_SEPARATOR1;
      for (i = name[0]; i > 0; i--)
        *--p = name[i];
    } while (pb.dirInfo.ioDrDirID != fsRtDirID);

  i = result + sizeof(result) - p;
  *fullpath++ = i;
  while (i > 0)
    {
      *fullpath++ = *p++;
      i--;
    }

  return noErr;
}


___HIDDEN ___SCMOBJ path_expand_to_absolute
   ___P((char *path,
         char *directory,/******************* currently ignored*/
         char *new_path,
         ___SIZE_TS max_length),
        (path,
         directory,
         new_path,
         max_length)
char *path;
char *directory;
char *new_path;
___SIZE_TS max_length;)
{
  ___BOOL result = 0;
  FSSpec spec;
  short vol;
  ___SIZE_TS dir;
  char tmp[___PATH_MAX_LENGTH+1];
  Str255 ppath;

  if (path[0] == '~')
    {
      if (path[1] == '~')
        {
          /* "~~" or "~~:xxx..." */

          int i = 0;
          int j = 0;
          int sep = 0;
          char *tilde_dir;

          if (!has_FindFolder)
            goto ret;

          if (path[2]!='\0' && !DIR_SEPARATOR(path[2]))
            goto ret;

          tilde_dir = ___GSTATE->setup_params.gambcdir;
          if (tilde_dir == 0)
#ifdef ___GAMBCDIR
            tilde_dir = ___GAMBCDIR;
#else
            tilde_dir = ":Gambit-C";
#endif

          i += 2;

          while (*tilde_dir != '\0')
            if (j < ___PATH_MAX_LENGTH)
              {
                tmp[j] = *tilde_dir++;
                j++;
              }
            else
              goto ret;

          while (path[i] != '\0')
            if (j < ___PATH_MAX_LENGTH)
              {
                if (DIR_SEPARATOR(path[i]))
                  sep = 1;
                tmp[j++] = path[i++];
              }
            else
              goto ret;

          if (!sep)
            if (j < ___PATH_MAX_LENGTH)
              tmp[j++] = DIR_SEPARATOR1;
            else
              goto ret;

          tmp[j] = '\0';
          path = tmp;

          if (FindFolder (kOnSystemDisk,
                          kPreferencesFolderType,
                          0,
                          &vol,
                          &dir)
              != noErr)
            goto ret;
        }
      else if (path[1]!='\0' && !DIR_SEPARATOR(path[1]))
        {
          /* "~user" or "~user:xxx..." */

          goto ret; /* no equivalent on Macintosh */
        }
      else
        {
          /* "~" or "~:xxx..." */

          path++;
          vol = 0; /* use default volume and directory
                      (folder containing application) */
          dir = 0;
        }
    }
  else
    {
      vol = 0; /* use default volume and directory
                  (folder containing application) */
      dir = 0;
    }

  if (!c2pascal (path, ppath, 255) ||
      make_ResolvedFSSpec (vol, dir, ppath, &spec) != noErr ||
      ResolvedFSSpec_to_fullpath (&spec, ppath) != noErr ||
      !pascal2c (ppath, new_path, max_length))
    goto ret;

  result = 1;

 ret:

  return result;
}


___HIDDEN OSErr copy_file_sectors
   ___P((short src_refnum,
         short dst_refnum),
        (src_refnum,
         dst_refnum)
short src_refnum;
short dst_refnum;)
{
  OSErr err1, err2;
  char buf[2048];
  long count1, count2;

  do
    {
      count1 = sizeof (buf);
      err1 = FSRead (src_refnum, &count1, buf);
      if (err1 != noErr && err1 != eofErr)
        return err1;
      count2 = count1;
      err2 = FSWrite (dst_refnum, &count2, buf);
      if (err2 != noErr || count1 != count2)
        return err2;
    } while (err1 != eofErr);

  return noErr;
}


___HIDDEN OSErr copy_file
   ___P((FSSpec src_spec,
         FSSpec dst_spec),
        (src_spec,
         dst_spec)
FSSpec src_spec;
FSSpec dst_spec;)
{
  OSErr err, err2;
  short src_refnum, dst_refnum;
  FInfo src_info;

  if (((err = FSpDelete (&dst_spec)) == noErr || err == fnfErr) &&
      (err = FSpGetFInfo (&src_spec, &src_info)) == noErr &&
      (err = FSpCreate (&dst_spec, 0x3f3f3f3f, 0x3f3f3f3f, 0)) == noErr)
    {
      src_info.fdFlags = src_info.fdFlags & ~kHasBeenInited;
      if ((err = FSpSetFInfo (&dst_spec, &src_info) == noErr) &&
          (err = FSpOpenRF (&src_spec, fsRdPerm, &src_refnum) == noErr))
        {
          if ((err = FSpOpenRF (&dst_spec, fsWrPerm, &dst_refnum)) == noErr)
            {
              err = copy_file_sectors (src_refnum, dst_refnum);
              err2 = FSClose (dst_refnum);
              if (err == noErr)
                err = err2;
            }
          err2 = FSClose (src_refnum);
          if (err == noErr)
            err = err2;
          if (err == noErr &&
              (err = FSpOpenDF (&src_spec, fsRdPerm, &src_refnum) == noErr))
            {
              if ((err = FSpOpenDF (&dst_spec, fsWrPerm, &dst_refnum)) == noErr)
                {
                  err = copy_file_sectors (src_refnum, dst_refnum);
                  err2 = FSClose (dst_refnum);
                  if (err == noErr)
                    err = err2;
                }
              err2 = FSClose (src_refnum);
              if (err == noErr)
                err = err2;
            }
        }
      if (err != noErr)
        FSpDelete (&dst_spec);
    }

  return err;
}


#endif


/*---------------------------------------------------------------------------*/

/* Filesystem path expansion. */


___SCMOBJ ___os_path_homedir ___PVOID
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  ___UCS_2STRING cstr1;

  static ___UCS_2 cvar1[] =
  { 'H', 'O', 'M', 'E', '\0' };

  if ((e = ___getenv_UCS_2 (cvar1, &cstr1)) != ___FIX(___NO_ERR))
    result = e;
  else
    {
      if (cstr1 != 0)
        {
          if ((e = ___UCS_2STRING_to_SCMOBJ
                     (___PSTATE,
                      cstr1,
                      &result,
                      ___RETURN_POS))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);

          ___free_mem (cstr1);
        }
      else
        {
#ifdef USE_WIN32

          ___CHAR_TYPE(___PATH_CE_SELECT) homedir[___PATH_MAX_LENGTH+1];
          int len = ___PATH_MAX_LENGTH+1;
          int n;

          static ___CHAR_TYPE(___GETENV_CE_SELECT) cvar2[] =
          { 'H', 'O', 'M', 'E', 'D', 'R', 'I', 'V', 'E', '\0' };

          static ___CHAR_TYPE(___GETENV_CE_SELECT) cvar3[] =
          { 'H', 'O', 'M', 'E', 'P', 'A', 'T', 'H', '\0' };

          n = GetEnvironmentVariable (cvar2, homedir, len);

          if (n > 0 && n < len)
            {
              len -= n;

              n = GetEnvironmentVariable (cvar3, homedir+n, len);

              if (n > 0 && n < len)
                {
                  if ((e = ___NONNULLSTRING_to_SCMOBJ
                             (___PSTATE,
                              homedir,
                              &result,
                              ___RETURN_POS,
                              ___CE(___PATH_CE_SELECT)))
                      != ___FIX(___NO_ERR))
                    result = e;
                  else
                    ___release_scmobj (result);
                }
              else
                result = ___FAL;
            }
          else
            result = ___FAL;

#else

          result = ___FAL;

#endif
        }
    }

  return result;
}


___SCMOBJ ___os_path_gambcdir ___PVOID
{
  ___SCMOBJ e;
  ___SCMOBJ result;

#ifdef USE_WIN32
#ifndef ___GAMBCDIR
#ifdef USE_GetModuleFileName
  if (___GSTATE->setup_params.gambcdir == 0)
    {
      ___CHAR_TYPE(___PATH_CE_SELECT) temp[___PATH_MAX_LENGTH+1];
      DWORD n;

      n = GetModuleFileName (NULL, temp, ___PATH_MAX_LENGTH+1);
      if (n > 0)
        {
          int cch;
          ___UCS_2STRING gambcdir = 0;
          /* remove filename */
          *(_tcsrchr (temp, '\\')) = 0;
          /* remove bin subdirectory, if present */
          cch = _tcslen (temp);
          if (cch > 7) /* e.g. C:\x\bin */
            {
              if (0 == _tcsicmp (temp+cch-4, _T("\\bin")))
                {
                  cch -= 4;
                  *(temp+cch) = '\0';
                }
            }

          gambcdir = ___CAST(___UCS_2STRING,
                             ___alloc_rc (___PSA(___PSTATE)
                                          (cch+1) * sizeof (___UCS_2)));

          if (gambcdir == 0)
            {
              e = ___FIX(___HEAP_OVERFLOW_ERR);
              return e;
            }
          else
            {
#ifdef _UNICODE
              _tcscpy (___CAST(wchar_t*,gambcdir), temp);
#else
              mbstowcs (___CAST(wchar_t*,gambcdir), temp, cch);
              gambcdir[cch] = '\0';
#endif
              ___GSTATE->setup_params.gambcdir = gambcdir;
            }
      }
  }
#endif
#endif
#endif

  if (___GSTATE->setup_params.gambcdir != 0)
    {
      if ((e = ___NONNULLUCS_2STRING_to_SCMOBJ
                 (___PSTATE,
                  ___GSTATE->setup_params.gambcdir,
                  &result,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);
    }
  else
    {

#ifndef ___GAMBCDIR

#define STRINGIFY1(x) #x
#define STRINGIFY2(x) STRINGIFY1(x)

#ifdef USE_POSIX
#define ___GAMBCDIR "/usr/local/Gambit-C/" STRINGIFY2(___VERSION)
#endif

#ifdef USE_WIN32
/* Will only be used if GetModuleFileName path fails */
#define ___GAMBCDIR "c:\\Gambit-C\\" STRINGIFY2(___VERSION)
#endif

#ifdef USE_CLASSIC_MACOS
#define ___GAMBCDIR ":Gambit-C:" STRINGIFY2(___VERSION)
#endif

#endif

      if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                 (___PSTATE,
                  ___GAMBCDIR,
                  &result,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);
    }

  return result;
}


#ifndef ___GAMBCDIR_MAP_CE_SELECT
#define ___GAMBCDIR_MAP_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#endif

#ifndef ___CONFIG_GAMBCDIR_MAP_CE_SELECT
#define ___CONFIG_GAMBCDIR_MAP_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif


/* 
 * TODO: the current implementation of the lookup duplicates the
 * lookup logic because the configuration map and the map from the
 * runtime options are not represented with the same string type.  The
 * proper approach would be to represent OS environment variables
 * using UTF-8 strings, but this would require substantial changes.
 */


___HIDDEN ___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) gambcdir_map_lookup
   ___P((___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) d),
        (d)
___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) d;)
{
  ___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) dir;
  ___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) *p = ___GSTATE->setup_params.gambcdir_map;

  if (p == 0)
    return 0;

  while ((dir = *p++) != 0)
    {
      int i = 0;
      for (;;)
        {
          ___UCS_2 c = d[i];
          if (c == '\0')
            {
              if (dir[i] == '=')
                return dir+i+1;
              else
                break;
            }
          else if ((dir[i] == '=') || (dir[i] != c))
            {
              break;
            }
          i++;
        }
    }

  return 0;
}


___HIDDEN ___STRING_TYPE(___CONFIG_GAMBCDIR_MAP_CE_SELECT) config_gambcdir_map[] =
{
#ifdef ___GAMBCDIR_BIN
  "bin=" ___GAMBCDIR_BIN,
#endif
#ifdef ___GAMBCDIR_DOC
  "doc=" ___GAMBCDIR_DOC,
#endif
#ifdef ___GAMBCDIR_INCLUDE
  "include=" ___GAMBCDIR_INCLUDE,
#endif
#ifdef ___GAMBCDIR_INFO
  "info=" ___GAMBCDIR_INFO,
#endif
#ifdef ___GAMBCDIR_LIB
  "lib=" ___GAMBCDIR_LIB,
#endif
#ifdef ___GAMBCDIR_SHARE
  "share=" ___GAMBCDIR_SHARE,
#endif
  0
};


___HIDDEN ___STRING_TYPE(___CONFIG_GAMBCDIR_MAP_CE_SELECT) config_gambcdir_map_lookup
   ___P((___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) d),
        (d)
___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) d;)
{
  ___STRING_TYPE(___CONFIG_GAMBCDIR_MAP_CE_SELECT) dir;
  ___STRING_TYPE(___CONFIG_GAMBCDIR_MAP_CE_SELECT) *p = config_gambcdir_map;

  while ((dir = *p++) != 0)
    {
      int i = 0;
      for (;;)
        {
          ___UCS_2 c = d[i];
          if (c == '\0')
            {
              if (dir[i] == '=')
                return dir+i+1;
              else
                break;
            }
          else if ((dir[i] == '=') || (dir[i] != c))
            {
              break;
            }
          i++;
        }
    }

  return 0;
}


___SCMOBJ ___os_path_gambcdir_map_lookup
   ___P((___SCMOBJ dir),
        (dir)
___SCMOBJ dir;)
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  void *cdir;

  if ((e = ___SCMOBJ_to_STRING
             (___PSA(___PSTATE)
              dir,
              &cdir,
              1,
              ___CE(___GAMBCDIR_MAP_CE_SELECT),
              0))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      ___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) d =
        ___CAST(___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT),cdir);

      ___STRING_TYPE(___GAMBCDIR_MAP_CE_SELECT) dir1;
      ___STRING_TYPE(___CONFIG_GAMBCDIR_MAP_CE_SELECT) dir2;

      if ((dir1 = gambcdir_map_lookup (d)) != 0)
        {
          if ((e = ___STRING_to_SCMOBJ
                     (___PSTATE,
                      dir1,
                      &result,
                      ___RETURN_POS,
                      ___CE(___GAMBCDIR_MAP_CE_SELECT)))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);
        }
      else if ((dir2 = config_gambcdir_map_lookup (d)) != 0)
        {
          if ((e = ___STRING_to_SCMOBJ
                     (___PSTATE,
                      dir2,
                      &result,
                      ___RETURN_POS,
                      ___CE(___CONFIG_GAMBCDIR_MAP_CE_SELECT)))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);
        }
      else
        result = ___FAL;

      ___release_string (cdir);
    }

  return result;
}


___SCMOBJ ___os_path_normalize_directory
   ___P((___SCMOBJ path),
        (path)
___SCMOBJ path;)
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  void *cpath;

  if ((e = ___SCMOBJ_to_STRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___PATH_CE_SELECT),
              0))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      ___STRING_TYPE(___PATH_CE_SELECT) p =
        ___CAST(___STRING_TYPE(___PATH_CE_SELECT),cpath);
      ___STRING_TYPE(___PATH_CE_SELECT) dir;

#ifndef USE_POSIX
#ifndef USE_WIN32

      ___CHAR_TYPE(___PATH_CE_SELECT) normalized_dir[___PATH_MAX_LENGTH+1+1];
      ___FILE *exist_check;

      dir = normalized_dir;

      if (p == 0)
        p = ".";

      while (*p != '\0')
        *dir++ = *p++;

      if (dir == normalized_dir || dir[-1] != '/')
        *dir++ = '/';

      *dir++ = '\0';

      dir = normalized_dir;

      while (dir[0] == '.' && dir[1] == '/' && dir[2] != '\0')
        dir += 2;

      exist_check = ___fopen (dir, "r");

      if (exist_check == 0)
        result = fnf_or_err_code_from_errno ();
      else
        {
          ___fclose (exist_check);

          if ((e = ___NONNULLSTRING_to_SCMOBJ
                     (___PSTATE,
                      dir,
                      &result,
                      ___RETURN_POS,
                      ___CE(___PATH_CE_SELECT)))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);
        }

#endif
#endif

#ifdef USE_POSIX

      ___CHAR_TYPE(___PATH_CE_SELECT) old_dir[___PATH_MAX_LENGTH+1+1];
      ___CHAR_TYPE(___PATH_CE_SELECT) normalized_dir[___PATH_MAX_LENGTH+1+1];

      dir = normalized_dir;

      if (getcwd (old_dir, ___PATH_MAX_LENGTH) == 0)
        e = err_code_from_errno ();
      else
        {
          if (p == 0)
            dir = old_dir;
          else
            {
              if (chdir (p) < 0)
                e = err_code_from_errno ();
              else
                {
                  if (getcwd (normalized_dir, ___PATH_MAX_LENGTH) == 0)
                    e = err_code_from_errno ();
                  else
                    e = ___FIX(___NO_ERR);
                }
              chdir (old_dir); /* ignore error */
            }
        }

      if (e != ___FIX(___NO_ERR))
        result = e;
      else
        {
          p = dir;

          while (*p != '\0')
            p++;

          if (p == dir || p[-1] != '/')
            {
              *p++ = '/';
              *p++ = '\0';
            }

          if ((e = ___NONNULLSTRING_to_SCMOBJ
                     (___PSTATE,
                      dir,
                      &result,
                      ___RETURN_POS,
                      ___CE(___PATH_CE_SELECT)))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);
        }

#endif

#ifdef USE_WIN32

      ___CHAR_TYPE(___PATH_CE_SELECT) old_dir[___PATH_MAX_LENGTH+1+1];
      ___CHAR_TYPE(___PATH_CE_SELECT) normalized_dir[___PATH_MAX_LENGTH+1+1];
      DWORD n;

      dir = normalized_dir;

      n = GetCurrentDirectory (___PATH_MAX_LENGTH+1,
                               old_dir);

      if (n < 1 || n > ___PATH_MAX_LENGTH)
        e = err_code_from_GetLastError ();
      else
        {
          if (p == 0)
            dir = old_dir;
          else
            {
              if (!SetCurrentDirectory (p))
                e = err_code_from_GetLastError ();
              else
                {
                  n = GetCurrentDirectory (___PATH_MAX_LENGTH+1,
                                           normalized_dir);

                  if (n < 1 || n > ___PATH_MAX_LENGTH)
                    e = err_code_from_GetLastError ();

                  SetCurrentDirectory (old_dir); /* ignore error */
                }
            }
        }

      if (e != ___FIX(___NO_ERR))
        result = e;
      else
        {
          p = dir;

          while (*p != '\0')
            p++;

          if (p == dir || (p[-1] != '\\' && p[-1] != '/'))
            {
              *p++ = '\\';
              *p++ = '\0';
            }

          if ((e = ___NONNULLSTRING_to_SCMOBJ
                     (___PSTATE,
                      dir,
                      &result,
                      ___RETURN_POS,
                      ___CE(___PATH_CE_SELECT)))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);
        }

#endif

      ___release_string (cpath);
    }

  return result;
}


/*---------------------------------------------------------------------------*/

/* File system operations. */


___SCMOBJ ___os_create_directory
   ___P((___SCMOBJ path,
         ___SCMOBJ mode),
        (path,
         mode)
___SCMOBJ path;
___SCMOBJ mode;)
{
  ___SCMOBJ e;
  void *cpath;

#ifndef USE_mkdir
#ifndef USE_CreateDirectory

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_mkdir

#define ___CREATE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___CREATE_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (mkdir (___CAST(___STRING_TYPE(___CREATE_DIRECTORY_PATH_CE_SELECT),cpath), ___INT(mode)) < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#endif

#ifdef USE_CreateDirectory

#ifdef _UNICODE
#define ___CREATE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___CREATE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___CREATE_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (!CreateDirectory
            (___CAST(___STRING_TYPE(___CREATE_DIRECTORY_PATH_CE_SELECT),
                     cpath),
             NULL))
        e = fnf_or_err_code_from_GetLastError ();
      ___release_string (cpath);
    }

#endif

  return e;
}


___SCMOBJ ___os_create_fifo
   ___P((___SCMOBJ path,
         ___SCMOBJ mode),
        (path,
         mode)
___SCMOBJ path;
___SCMOBJ mode;)
{
  ___SCMOBJ e;
  void *cpath;

#ifndef USE_mkfifo

  e = ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_mkfifo

#define ___CREATE_FIFO_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___CREATE_FIFO_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (mkfifo (___CAST(___STRING_TYPE(___CREATE_FIFO_PATH_CE_SELECT),cpath), ___INT(mode)) < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#endif

  return e;
}


___SCMOBJ ___os_create_link
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        (path1,
         path2)
___SCMOBJ path1;
___SCMOBJ path2;)
{
  ___SCMOBJ e;
  void *cpath1;
  void *cpath2;

#ifndef USE_link

  e = ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_link

#define ___CREATE_LINK_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path1,
              &cpath1,
              1,
              ___CE(___CREATE_LINK_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (___PSA(___PSTATE)
                  path2,
                  &cpath2,
                  2,
                  ___CE(___CREATE_LINK_PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          if (link (___CAST(___STRING_TYPE(___CREATE_LINK_PATH_CE_SELECT),cpath1),
                    ___CAST(___STRING_TYPE(___CREATE_LINK_PATH_CE_SELECT),cpath2))
              < 0)
            e = fnf_or_err_code_from_errno ();
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#endif

  return e;
}


___SCMOBJ ___os_create_symbolic_link
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        (path1,
         path2)
___SCMOBJ path1;
___SCMOBJ path2;)
{
  ___SCMOBJ e;
  void *cpath1;
  void *cpath2;

#ifndef USE_symlink

  e = ___FIX(___UNIMPL_ERR);

#endif

#ifdef USE_symlink

#define ___CREATE_SYMLINK_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path1,
              &cpath1,
              1,
              ___CE(___CREATE_SYMLINK_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (___PSA(___PSTATE)
                  path2,
                  &cpath2,
                  2,
                  ___CE(___CREATE_SYMLINK_PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          if (symlink (___CAST(___STRING_TYPE(___CREATE_SYMLINK_PATH_CE_SELECT),cpath1),
                       ___CAST(___STRING_TYPE(___CREATE_SYMLINK_PATH_CE_SELECT),cpath2))
              < 0)
            e = fnf_or_err_code_from_errno ();
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#endif

  return e;
}


___SCMOBJ ___os_delete_directory
   ___P((___SCMOBJ path),
        (path)
___SCMOBJ path;)
{
  ___SCMOBJ e;
  void *cpath;

#ifndef USE_rmdir
#ifndef USE_RemoveDirectory

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_rmdir

#define ___DELETE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DELETE_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (rmdir (___CAST(___STRING_TYPE(___DELETE_DIRECTORY_PATH_CE_SELECT),cpath)) < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#endif

#ifdef USE_RemoveDirectory

#ifdef _UNICODE
#define ___DELETE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___DELETE_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DELETE_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (!RemoveDirectory
            (___CAST(___STRING_TYPE(___DELETE_DIRECTORY_PATH_CE_SELECT),
                     cpath)))
        e = fnf_or_err_code_from_GetLastError ();
      ___release_string (cpath);
    }

#endif

  return e;
}


___SCMOBJ ___os_set_current_directory
   ___P((___SCMOBJ path),
        (path)
___SCMOBJ path;)
{
  ___SCMOBJ e;
  void *cpath;

#ifndef USE_chdir
#ifndef USE_SetCurrentDirectory

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_chdir

#define ___SET_CURRENT_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (chdir (___CAST(___STRING_TYPE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT),cpath)) < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#endif

#ifdef USE_SetCurrentDirectory

#ifdef _UNICODE
#define ___SET_CURRENT_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___SET_CURRENT_DIRECTORY_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (!SetCurrentDirectory
            (___CAST(___STRING_TYPE(___SET_CURRENT_DIRECTORY_PATH_CE_SELECT),
                     cpath)))
        e = fnf_or_err_code_from_GetLastError ();
      ___release_string (cpath);
    }

#endif

  return e;
}


___SCMOBJ ___os_rename_file
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        (path1,
         path2)
___SCMOBJ path1;
___SCMOBJ path2;)
{
  ___SCMOBJ e;
  void *cpath1;
  void *cpath2;

#ifndef USE_rename
#ifndef USE_MoveFile

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_rename

#define ___RENAME_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path1,
              &cpath1,
              1,
              ___CE(___RENAME_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (___PSA(___PSTATE)
                  path2,
                  &cpath2,
                  2,
                  ___CE(___RENAME_FILE_PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          if (rename (___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),cpath1),
                      ___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),cpath2))
              < 0)
            e = fnf_or_err_code_from_errno ();
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#endif

#ifdef USE_MoveFile

#ifdef _UNICODE
#define ___RENAME_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___RENAME_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path1,
              &cpath1,
              1,
              ___CE(___RENAME_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (___PSA(___PSTATE)
                  path2,
                  &cpath2,
                  2,
                  ___CE(___RENAME_FILE_PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          if (!MoveFile
                (___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),
                         cpath1),
                 ___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),
                         cpath2)))
            e = fnf_or_err_code_from_GetLastError ();
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#endif

  return e;
}


___SCMOBJ ___os_copy_file
   ___P((___SCMOBJ path1,
         ___SCMOBJ path2),
        (path1,
         path2)
___SCMOBJ path1;
___SCMOBJ path2;)
{
  ___SCMOBJ e;
  void *cpath1;
  void *cpath2;

#ifndef USE_POSIX
#ifndef USE_CopyFile

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_POSIX

#define ___COPY_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path1,
              &cpath1,
              1,
              ___CE(___COPY_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (___PSA(___PSTATE)
                  path2,
                  &cpath2,
                  2,
                  ___CE(___COPY_FILE_PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          int fd1;
          int fd2;

          if ((fd1 = open (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                   cpath1),
#ifdef O_BINARY
                           O_BINARY|
#endif
                           O_RDONLY,
                           0777)) < 0)
            e = fnf_or_err_code_from_errno ();
          else
            {
              if ((fd2 = open (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                       cpath2),
#ifdef O_BINARY
                               O_BINARY|
#endif
                               O_WRONLY|O_CREAT|O_EXCL,
                               0777)) < 0)
                e = fnf_or_err_code_from_errno ();
              else
                {
                  char buffer[4096];
                  int nr;
                  int nw;

                  for (;;)
                    {
                      nr = read (fd1, buffer, sizeof (buffer));

                      if (nr == 0)
                        break;

                      if (nr < 0 || (nw = write (fd2, buffer, nr)) < 0)
                        {
                          e = err_code_from_errno ();
                          break;
                        }

                      if (nw != nr)
                        {
                          e = ___FIX(___UNKNOWN_ERR);
                          break;
                        }
                    }

                  if (close (fd2) < 0 && e != ___FIX(___NO_ERR))
                    e = err_code_from_errno ();
                }

              if (close (fd1) < 0 && e != ___FIX(___NO_ERR))
                {
                  e = err_code_from_errno ();
                  unlink (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                  cpath2));
                }
            }
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#endif

#ifdef USE_CopyFile

#ifdef _UNICODE
#define ___COPY_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___COPY_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path1,
              &cpath1,
              1,
              ___CE(___COPY_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if ((e = ___SCMOBJ_to_NONNULLSTRING
                 (___PSA(___PSTATE)
                  path2,
                  &cpath2,
                  2,
                  ___CE(___COPY_FILE_PATH_CE_SELECT),
                  0))
          == ___FIX(___NO_ERR))
        {
          if (!CopyFile
                (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                         cpath1),
                 ___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                         cpath2),
                 1))
            e = fnf_or_err_code_from_GetLastError ();
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#endif

  return e;
}


___SCMOBJ ___os_delete_file
   ___P((___SCMOBJ path),
        (path)
___SCMOBJ path;)
{
  ___SCMOBJ e;
  void *cpath;

#ifndef USE_unlink
#ifndef USE_DeleteFile

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif

#ifdef USE_unlink

#define ___DELETE_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DELETE_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (unlink (___CAST(___STRING_TYPE(___DELETE_FILE_PATH_CE_SELECT),cpath))
          < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#endif

#ifdef USE_DeleteFile

#ifdef _UNICODE
#define ___DELETE_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#else
#define ___DELETE_FILE_PATH_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DELETE_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (!DeleteFile
            (___CAST(___STRING_TYPE(___DELETE_FILE_PATH_CE_SELECT),
                     cpath)))
        e = fnf_or_err_code_from_GetLastError ();
      ___release_string (cpath);
    }

#endif

  return e;
}


/*---------------------------------------------------------------------------*/

/* File system module initialization/finalization. */


___SCMOBJ ___setup_files_module ___PVOID
{
  if (!___files_mod.setup)
    {
      ___files_mod.setup = 1;
      return ___FIX(___NO_ERR);
    }

  return ___FIX(___UNKNOWN_ERR);
}


void ___cleanup_files_module ___PVOID
{
  if (___files_mod.setup)
    {
      ___files_mod.setup = 0;
    }
}


/*---------------------------------------------------------------------------*/
