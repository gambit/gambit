/* File: "os_files.c" */

/* Copyright (c) 1994-2023 by Marc Feeley, All Rights Reserved. */

/*
 * This module implements the operating system specific routines
 * related to the file system.
 */

#define ___INCLUDED_FROM_OS_FILES
#define ___VERSION 409004
#include "gambit.h"

#include "os_setup.h"
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

          tilde_dir = ___GSTATE->setup_params.gambitdir;
          if (tilde_dir == 0)
#ifdef ___GAMBITDIR
            tilde_dir = ___GAMBITDIR;
#else
            tilde_dir = ":Gambit";
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

/* Filesystem operations supporting long paths. */


#ifdef USE_getcwd

char *getcwd_long_path
   ___P((char *buf,
         ___SIZE_T size),
        (buf,
         size)
char *buf;
___SIZE_T size;)
{
  int e;

  if (getcwd (buf, size) != 0)
    return buf;

  while (errno == ERANGE)
    {
      ___SIZE_T old_size = size;
      e = errno;
      size = size << 1;
      if ((size >> 1) != old_size ||
          (buf = ___CAST(char*, ___ALLOC_MEM(size))) == 0)
        {
          errno = e;
          return 0;
        }
      if (getcwd (buf, size) != 0)
        return buf;
      e = errno;
      ___FREE_MEM(buf);
      errno = e;
    }

  return 0;
}

#endif


#ifdef USE_chdir

int chdir_long_path
   ___P((char *path),
        (path)
char *path;)
{
  char *start = path;
  char *probe = start;
  char *last_sep = NULL;
  char c;

  if (*probe == '/') probe++;

  for (;;)
    {
      if (last_sep != NULL && probe - start > ___PATH_MAX_LENGTH)
        {
          int result;
          *last_sep = '\0';
          result = chdir (start);
          *last_sep = '/';
          if (result != 0)
            return result;
          start = last_sep+1;
          last_sep = NULL;
        }
      if ((c = *probe) == '\0')
        break;
      else if (c == '/')
        last_sep = probe;
      probe++;
    }

  return chdir (start);
}

#endif


#ifdef USE_openat

void at_close_dir
   ___P((int dir),
        (dir)
int dir;)
{
  if (dir != AT_FDCWD)
    {
      int save = errno;
      ___close_no_EINTR (dir); /* ignore error */
      errno = save;
    }
}

char *at_long_path
   ___P((int *dir_ret,
         char *path),
        (dir_ret,
         path)
int *dir_ret;
char *path;)
{
  int dir = AT_FDCWD;
  char *start = path;
  char *probe = start;
  char *last_sep = NULL;
  char c;

  if (*probe == '/') probe++;

  for (;;)
    {
      if (last_sep != NULL && probe - start > ___PATH_MAX_LENGTH)
        {
          int new_dir;
          *last_sep = '\0';
          new_dir = ___openat_no_EINTR (dir, start, O_DIRECTORY, 0);
          at_close_dir (dir);
          *last_sep = '/';
          if (new_dir < 0)
            return NULL;
          dir = new_dir;
          start = last_sep+1;
          last_sep = NULL;
        }
      if ((c = *probe) == '\0')
        break;
      else if (c == '/')
        last_sep = probe;
      probe++;
    }

  *dir_ret = dir;

  return start;
}

#endif


#ifdef USE_open

int open_long_path
   ___P((char *path,
         int flags,
         mode_t mode),
        (path,
         flags,
         mode)
char *path;
int flags;
mode_t mode;)
{
#ifdef USE_openat

  int fd = -1;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      fd = ___openat_no_EINTR (dir, path2, flags, mode);
      at_close_dir (dir);
    }

  return fd;

#else

  return ___open_no_EINTR (path, flags, mode);

#endif
}

#endif


#ifdef USE_mkfifo

int mkfifo_long_path
   ___P((char *path,
         mode_t mode),
        (path,
         mode)
char *path;
mode_t mode;)
{
#ifdef USE_mkfifoat

  int result = -1;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      result = mkfifoat (dir, path2, mode);
      at_close_dir (dir);
    }

  return result;

#else

  return mkfifo (path, mode);

#endif
}

#endif


#ifdef USE_mkdir

int mkdir_long_path
   ___P((char *path,
         mode_t mode),
        (path,
         mode)
char *path;
mode_t mode;)
{
#ifdef USE_mkdirat

  int result = -1;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      result = mkdirat (dir, path2, mode);
      at_close_dir (dir);
    }

  return result;

#else

  return mkdir (path, mode);

#endif
}

#endif


#ifdef USE_unlink

int unlink_long_path
   ___P((char *path),
        (path)
char *path;)
{
#ifdef USE_unlinkat

  int result = -1;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      result = unlinkat (dir, path2, 0);
      at_close_dir (dir);
    }

  return result;

#else

  return unlink (path);

#endif
}

#endif


#ifdef USE_link

int link_long_path
   ___P((char *oldpath,
         char *newpath),
        (oldpath,
         newpath)
char *oldpath;
char *newpath;)
{
#ifdef USE_linkat

  int result = -1;
  int olddir;
  int newdir;
  char *oldpath2;
  char *newpath2;

  if ((oldpath2 = at_long_path (&olddir, oldpath)) != NULL)
    {
      if ((newpath2 = at_long_path (&newdir, newpath)) != NULL)
        {
          result = linkat (olddir, oldpath2, newdir, newpath2, 0);
          at_close_dir (newdir);
        }
      at_close_dir (olddir);
    }

  return result;

#else

  return link (oldpath, newpath);

#endif
}

#endif


#ifdef USE_symlink

int symlink_long_path
   ___P((char *target,
         char *path),
        (target,
         path)
char *target;
char *path;)
{
#ifdef USE_symlinkat

  int result = -1;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      result = symlinkat (target, dir, path2);
      at_close_dir (dir);
    }

  return result;

#else

  return symlink (target, path);

#endif
}

#endif


#ifdef USE_readlink

___SSIZE_T readlink_long_path
   ___P((char *path,
         char *buf,
         ___SIZE_T bufsize),
        (path,
         buf,
         bufsize)
char *path;
char *buf;
___SIZE_T bufsize;)
{
#ifdef USE_readlinkat

  ___SSIZE_T result = -1;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      result = readlinkat (dir, path2, buf, bufsize);
      at_close_dir (dir);
    }

  return result;

#else

  return readlink (path, buf, bufsize);

#endif
}

#endif


#ifdef USE_rename

int rename_long_path
   ___P((char *oldpath,
         char *newpath,
         ___BOOL replace),
        (oldpath,
         newpath,
         replace)
char *oldpath;
char *newpath;
___BOOL replace;)
{
  int result = -1;

#ifdef USE_stat

  if (!replace)
    {
      /*
       * When replace is false, it is an error if the destination is
       * an existing file.  This situation can be detected by
       * renameat2 and renameatx_np but only on some filesystems
       * (which we can't know ahead of time), so we do an explicit
       * check with stat to see if the destination is an existing file
       * (which is either a double check if the filesystem supports
       * detecting this, or the only check if the filesystem doesn't
       * support detecting this, in which case it is not atomic).
       */

      ___struct_stat statbuf;

      if (stat_long_path (newpath, &statbuf, 0) == 0) /* file exists? */
        {
          errno = EEXIST; /* fake the error */
          return result;
        }
      else if (errno != ENOENT)
        {
          return result;
        }
    }

#endif

#ifdef USE_renameat

  {
    int olddir;
    int newdir;
    char *oldpath2;
    char *newpath2;

    if ((oldpath2 = at_long_path (&olddir, oldpath)) != NULL)
      {
        if ((newpath2 = at_long_path (&newdir, newpath)) != NULL)
          {
#ifdef USE_renameatx_np
            unsigned int flags = 0;
            if (!replace) flags |= RENAME_EXCL;
            result = renameatx_np (olddir, oldpath2, newdir, newpath2, flags);
#else
#ifdef USE_renameat2
            unsigned int flags = 0;
            if (!replace) flags |= RENAME_NOREPLACE;
#ifdef USE_renameat2_syscall
            /*
             * glibc does not have a wrapper for renameat2 so use a syscall
             * to call it... see: https://stackoverflow.com/questions/41655386/no-renameat2-system-call-function-on-ubuntu-16-04
             */
            result = syscall (SYS_renameat2, olddir, oldpath2, newdir, newpath2, flags);
#else
            result = renameat2 (olddir, oldpath2, newdir, newpath2, flags);
#endif
#else
#ifdef USE_link
#ifdef USE_unlink
            if (!replace)
              {
#ifdef USE_linkat
                result = linkat (olddir, oldpath2, newdir, newpath2, 0);
#else
                result = link (oldpath, newpath);
#endif
                if (result == 0)
                  {
#ifdef USE_unlinkat
                    result = unlinkat (olddir, oldpath2, 0);
#else
                    result = unlink (oldpath);
#endif
                  }
              }
            else
#endif
#endif
              {
                /* renameat's API does not support a NOREPLACE flag */
                result = renameat (olddir, oldpath2, newdir, newpath2);
              }
#endif
#endif
            at_close_dir (newdir);
          }
        at_close_dir (olddir);
      }
  }

#else

#ifdef USE_link
#ifdef USE_unlink
  if (!replace)
    {
      result = link (oldpath, newpath);
      if (result == 0)
        result = unlink (oldpath);
    }
  else
#endif
#endif
    {
      /* rename's API does not support a NOREPLACE flag */
      result = rename (oldpath, newpath);
    }

#endif

  return result;
}

#endif


#ifdef USE_opendir

DIR *opendir_long_path
   ___P((char *path),
        (path)
char *path;)
{
#ifdef USE_fdopendir

  DIR *result = NULL;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      int fd = ___openat_no_EINTR (dir, path2, O_DIRECTORY, 0);
      if (fd >= 0)
        result = fdopendir (fd);
      at_close_dir (dir);
    }

  return result;

#else

  return ___opendir_no_EINTR (path);

#endif
}

#endif


#ifdef USE_stat

int stat_long_path
   ___P((char *path,
         ___struct_stat *statbuf,
         ___BOOL follow),
        (path,
         statbuf,
         follow)
char *path;
___struct_stat *statbuf;
___BOOL follow;)
{
#ifdef USE_fstatat

  int result = -1;
  int dir;
  char *path2;

  if ((path2 = at_long_path (&dir, path)) != NULL)
    {
      result = fstatat (dir, path2, statbuf, follow ? 0 : AT_SYMLINK_NOFOLLOW);
      at_close_dir (dir);
    }

  return result;

#else

  if (follow)
    return ___stat (path, statbuf);
  else
    return ___lstat (path, statbuf);

#endif
}

#endif


/*---------------------------------------------------------------------------*/

/* Filesystem path expansion. */


___SCMOBJ ___os_path_tempdir ___PVOID
{
  ___SCMOBJ e;
  ___SCMOBJ result;
  ___UCS_2STRING cstr;

#ifdef USE_WIN32

#define TEMPDIR_ENV_VAR { 'T', 'E', 'M', 'P', '\0' }
#define TEMPDIR_DEFAULT { 'C', ':', '\\', 'T', 'E', 'M', 'P', '\0' }

#else

#define TEMPDIR_ENV_VAR { 'T', 'M', 'P', 'D', 'I', 'R', '\0' }
#define TEMPDIR_DEFAULT { '/', 't', 'm', 'p', '\0' }

#endif

  static ___UCS_2 cvar[] = TEMPDIR_ENV_VAR;
  static ___UCS_2 tempdir_default[] = TEMPDIR_DEFAULT;

  if ((e = ___getenv_UCS_2 (cvar, &cstr)) != ___FIX(___NO_ERR))
    result = e;
  else
    {
      if (cstr == 0) cstr = tempdir_default;

      CANONICALIZE_PATH(___UCS_2STRING, cstr);

      if ((e = ___UCS_2STRING_to_SCMOBJ
                  (___PSTATE,
                   cstr,
                   &result,
                   ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);

      if (cstr != tempdir_default)
        ___FREE_MEM(cstr);
    }

  return result;
}


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
          CANONICALIZE_PATH(___UCS_2STRING, cstr1);

          if ((e = ___UCS_2STRING_to_SCMOBJ
                     (___PSTATE,
                      cstr1,
                      &result,
                      ___RETURN_POS))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);

          ___FREE_MEM(cstr1);
        }
      else
        {
#ifdef USE_WIN32

          ___CHAR_TYPE(___PATH_CE_SELECT) homedir[___PATH_MAX_LENGTH+1];
          int len = ___PATH_MAX_LENGTH+1;
          int n;

          static ___CHAR_TYPE(___ENVIRON_CE_SELECT) cvar2[] =
          { 'H', 'O', 'M', 'E', 'D', 'R', 'I', 'V', 'E', '\0' };

          static ___CHAR_TYPE(___ENVIRON_CE_SELECT) cvar3[] =
          { 'H', 'O', 'M', 'E', 'P', 'A', 'T', 'H', '\0' };

          n = GetEnvironmentVariable (cvar2, homedir, len);

          if (n > 0 && n < len)
            {
              len -= n;

              n = GetEnvironmentVariable (cvar3, homedir+n, len);

              if (n > 0 && n < len)
                {
                  CANONICALIZE_PATH(___STRING_TYPE(___PATH_CE_SELECT), homedir);

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


___SCMOBJ ___os_path_gambitdir ___PVOID
{
  ___SCMOBJ e;
  ___SCMOBJ result;

#ifdef USE_WIN32
#ifndef ___GAMBITDIR
#ifdef USE_GetModuleFileName
  if (___GSTATE->setup_params.gambitdir == 0)
    {
      ___CHAR_TYPE(___PATH_CE_SELECT) temp[___PATH_MAX_LENGTH+1];
      DWORD n;

      n = GetModuleFileName (NULL, temp, ___PATH_MAX_LENGTH+1);
      if (n > 0)
        {
          int cch;
          ___UCS_2STRING gambitdir = 0;
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

          gambitdir = ___CAST(___UCS_2STRING,
                              ___alloc_rc (___PSA(___PSTATE)
                                           (cch+1) * sizeof (___UCS_2)));

          if (gambitdir == 0)
            {
              e = ___FIX(___HEAP_OVERFLOW_ERR);
              return e;
            }
          else
            {
#ifdef _UNICODE
              _tcscpy (___CAST(wchar_t*,gambitdir), temp);
#else
              mbstowcs (___CAST(wchar_t*,gambitdir), temp, cch);
              gambitdir[cch] = '\0';
#endif
              CANONICALIZE_PATH(___UCS_2STRING, gambitdir);
              ___GSTATE->setup_params.gambitdir = gambitdir;
            }
      }
  }
#endif
#endif
#endif

  if (___GSTATE->setup_params.gambitdir != 0)
    {
      if ((e = ___NONNULLUCS_2STRING_to_SCMOBJ
                 (___PSTATE,
                  ___GSTATE->setup_params.gambitdir,
                  &result,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);
    }
  else
    {

#ifndef ___GAMBITDIR

#define STRINGIFY1(x) #x
#define STRINGIFY2(x) STRINGIFY1(x)

#ifdef USE_POSIX
#define ___GAMBITDIR "/usr/local/Gambit/" STRINGIFY2(___VERSION)
#endif

#ifdef USE_WIN32
/* Will only be used if GetModuleFileName path fails */
#define ___GAMBITDIR "C:\\Program Files\\Gambit\\" STRINGIFY2(___VERSION)
#endif

#ifdef USE_CLASSIC_MACOS
#define ___GAMBITDIR ":Gambit:" STRINGIFY2(___VERSION)
#endif

#endif

      static char gambitdir[] = ___GAMBITDIR;

      CANONICALIZE_PATH(char*, gambitdir);

      if ((e = ___NONNULLCHARSTRING_to_SCMOBJ
                 (___PSTATE,
                  gambitdir,
                  &result,
                  ___RETURN_POS))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);
    }

  return result;
}


#ifndef ___GAMBITDIR_MAP_CE_SELECT
#define ___GAMBITDIR_MAP_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) ucs2
#endif

#ifndef ___CONFIG_GAMBITDIR_MAP_CE_SELECT
#define ___CONFIG_GAMBITDIR_MAP_CE_SELECT(latin1,utf8,ucs2,ucs4,wchar,native) native
#endif


/*
 * TODO: the current implementation of the lookup duplicates the
 * lookup logic because the configuration map and the map from the
 * runtime options are not represented with the same string type.  The
 * proper approach would be to represent OS environment variables
 * using UTF-8 strings, but this would require substantial changes.
 */


___HIDDEN ___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) gambitdir_map_lookup
   ___P((___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) d),
        (d)
___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) d;)
{
  ___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) dir;
  ___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) *p = ___GSTATE->setup_params.gambitdir_map;

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


___HIDDEN ___STRING_TYPE(___CONFIG_GAMBITDIR_MAP_CE_SELECT) config_gambitdir_map[] =
{
#ifdef ___GAMBITDIR_BIN
  "bin=" ___GAMBITDIR_BIN,
#endif
#ifdef ___GAMBITDIR_DOC
  "doc=" ___GAMBITDIR_DOC,
#endif
#ifdef ___GAMBITDIR_INCLUDE
  "include=" ___GAMBITDIR_INCLUDE,
#endif
#ifdef ___GAMBITDIR_INFO
  "info=" ___GAMBITDIR_INFO,
#endif
#ifdef ___GAMBITDIR_LIB
  "lib=" ___GAMBITDIR_LIB,
#endif
#ifdef ___GAMBITDIR_USERLIB
  "userlib=" ___GAMBITDIR_USERLIB,
#endif
#ifdef ___GAMBITDIR_INSTLIB
  "instlib=" ___GAMBITDIR_INSTLIB,
#endif
#ifdef ___GAMBITDIR_SHARE
  "share=" ___GAMBITDIR_SHARE,
#endif
  0
};


___HIDDEN ___STRING_TYPE(___CONFIG_GAMBITDIR_MAP_CE_SELECT) config_gambitdir_map_lookup
   ___P((___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) d),
        (d)
___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) d;)
{
  ___STRING_TYPE(___CONFIG_GAMBITDIR_MAP_CE_SELECT) dir;
  ___STRING_TYPE(___CONFIG_GAMBITDIR_MAP_CE_SELECT) *p = config_gambitdir_map;

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


___SCMOBJ ___os_path_gambitdir_map_lookup
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
              ___CE(___GAMBITDIR_MAP_CE_SELECT),
              0))
      != ___FIX(___NO_ERR))
    result = e;
  else
    {
      ___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) d =
        ___CAST(___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT),cdir);

      ___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT) dir1;
      ___STRING_TYPE(___CONFIG_GAMBITDIR_MAP_CE_SELECT) dir2;

      if ((dir1 = gambitdir_map_lookup (d)) != 0)
        {
          CANONICALIZE_PATH(___STRING_TYPE(___GAMBITDIR_MAP_CE_SELECT), dir1);

          if ((e = ___STRING_to_SCMOBJ
                     (___PSTATE,
                      dir1,
                      &result,
                      ___RETURN_POS,
                      ___CE(___GAMBITDIR_MAP_CE_SELECT)))
              != ___FIX(___NO_ERR))
            result = e;
          else
            ___release_scmobj (result);
        }
      else if ((dir2 = config_gambitdir_map_lookup (d)) != 0)
        {
          CANONICALIZE_PATH(___STRING_TYPE(___CONFIG_GAMBITDIR_MAP_CE_SELECT), dir2);

          if ((e = ___STRING_to_SCMOBJ
                     (___PSTATE,
                      dir2,
                      &result,
                      ___RETURN_POS,
                      ___CE(___CONFIG_GAMBITDIR_MAP_CE_SELECT)))
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
      ___STRING_TYPE(___PATH_CE_SELECT) dir = 0;

#ifndef USE_chdir
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

          CANONICALIZE_PATH(___STRING_TYPE(___PATH_CE_SELECT), dir);

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

#ifdef USE_chdir

      ___CHAR_TYPE(___PATH_CE_SELECT) old_dir[___PATH_MAX_LENGTH+1+1];
      ___STRING_TYPE(___PATH_CE_SELECT) odir = 0;
      ___CHAR_TYPE(___PATH_CE_SELECT) normalized_dir[___PATH_MAX_LENGTH+1+1];
      ___STRING_TYPE(___PATH_CE_SELECT) ndir = 0;

      ___MUTEX_LOCK(___files_mod.cwd_mut);

      if ((odir = getcwd_long_path (old_dir, ___PATH_MAX_LENGTH)) == 0)
        e = err_code_from_errno ();
      else
        {
          if (p == 0)
            dir = odir;
          else
            {
              if (chdir_long_path (p) < 0)
                e = err_code_from_errno ();
              else
                {
                  if ((ndir = getcwd_long_path (normalized_dir, ___PATH_MAX_LENGTH)) == 0)
                    e = err_code_from_errno ();
                  else
                    {
                      e = ___FIX(___NO_ERR);
                      dir = ndir;
                    }
                  if (chdir_long_path (odir) < 0 && e == ___FIX(___NO_ERR))
                    e = err_code_from_errno ();
                }
            }
        }

      ___MUTEX_UNLOCK(___files_mod.cwd_mut);

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

          CANONICALIZE_PATH(___STRING_TYPE(___PATH_CE_SELECT), dir);

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

      if (odir != 0 && odir != old_dir)
        ___FREE_MEM(odir);

      if (ndir != 0 && ndir != normalized_dir)
        ___FREE_MEM(ndir);

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

          CANONICALIZE_PATH(___STRING_TYPE(___PATH_CE_SELECT), dir);

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


___SCMOBJ ___os_executable_path ___PVOID
{
  ___SCMOBJ e;
  ___SCMOBJ result = ___FIX(___UNIMPL_ERR);

  ___CHAR_TYPE(___PATH_CE_SELECT) path_buf[___PATH_MAX_LENGTH+1];
  ___STRING_TYPE(___PATH_CE_SELECT) path = NULL;

#ifdef USE_GetModuleFileName

  DWORD n;

  path = path_buf;

  n = GetModuleFileName (NULL, path, ___PATH_MAX_LENGTH+1);

  if (n >= 0 && n < ___PATH_MAX_LENGTH+1) goto convert_path;

  return fnf_or_err_code_from_GetLastError ();

#else

#ifdef USE__NSGetExecutablePath

  uint32_t bufsize = sizeof (path_buf);

  path = path_buf;

  if (_NSGetExecutablePath (path, &bufsize) < 0)
    {
      path = ___CAST(char*,malloc (bufsize));
      if (path == NULL)
        result = ___FIX(___CTOS_HEAP_OVERFLOW_ERR+___RETURN_POS);
      else if (_NSGetExecutablePath (path, &bufsize) < 0)
        {
          result = err_code_from_errno ();
          free (path);
          path = NULL;
        }
    }

#else

#if defined (USE_sysctl) && defined (CTL_KERN) && defined (KERN_PROC) && defined (KERN_PROC_PATHNAME)

  {
    // Each row has the format: nb_args, arg1, ..., argn
    int mibs[] = {
#if defined(KERN_PROC_ARGS)
      4, CTL_KERN, KERN_PROC_ARGS, -1, KERN_PROC_PATHNAME,
#endif
      4, CTL_KERN, KERN_PROC, KERN_PROC_PATHNAME, -1,
      0
    };
    int *mibs_probe = mibs;
    size_t cb = sizeof (path_buf);

    path = path_buf;
    while (*mibs_probe != 0)
      {
        if (sysctl (mibs_probe+1, *mibs_probe, path, &cb, NULL, 0) != -1) goto convert_path;
        mibs_probe += *mibs_probe + 1;
      }

#if !(defined (USE_readlink) && defined (USE_getpid))
    return err_code_from_errno ();
#endif
  }

#endif

#if defined (USE_readlink) && defined (USE_getpid)

  {
    pid_t pid = getpid ();

    static char *procfs_paths_to_try[] =
      {
       "/proc/%d/exe",
       "/proc/%d/file",
       "/proc/%d/path/a.out",
       NULL
      };

    char **probe = procfs_paths_to_try;

    while (*probe != NULL)
      {
        ___SSIZE_T size;
        char p[100];

        snprintf(p, sizeof (p), *probe++, pid);

        size = readlink_long_path (p, path_buf, sizeof (path_buf));

        if (size >= 0)
          {
            path_buf[size] = '\0';
            path = path_buf;
            goto convert_path;
          }
      }

    return err_code_from_errno ();
  }

#else

  return ___FIX(___UNIMPL_ERR);

#endif

#endif

#endif

 convert_path:

  if (path != NULL)
    {
      if ((e = ___NONNULLSTRING_to_SCMOBJ
                 (___PSTATE,
                  path,
                  &result,
                  ___RETURN_POS,
                  ___CE(___PATH_CE_SELECT)))
          != ___FIX(___NO_ERR))
        result = e;
      else
        ___release_scmobj (result);
      if (path != path_buf)
        free (path);
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

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___CREATE_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (mkdir_long_path (___CAST(___STRING_TYPE(___CREATE_DIRECTORY_PATH_CE_SELECT),cpath), ___INT(mode)) < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#else

#ifdef USE_CreateDirectory

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

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___CREATE_FIFO_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (mkfifo_long_path (___CAST(___STRING_TYPE(___CREATE_FIFO_PATH_CE_SELECT),cpath), ___INT(mode)) < 0)
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
          if (link_long_path (___CAST(___STRING_TYPE(___CREATE_LINK_PATH_CE_SELECT),cpath1),
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
          if (symlink_long_path (___CAST(___STRING_TYPE(___CREATE_SYMLINK_PATH_CE_SELECT),cpath1),
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
#ifndef USE_remove_dir

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif
#endif

#ifdef USE_rmdir

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

#else

#ifdef USE_RemoveDirectory

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
#ifdef USE_GetFileAttributesEx
      else
        {
          /*
           * On Windows, a call to RemoveDirectory doesn't immediately
           * delete the directory.  Instead the directory is marked
           * for deletion, so it is necessary to busy-wait for the OS
           * to actually delete it.  Unfortunately, this introduces a
           * race condition where some other process may be creating a
           * file or directory with the same name.  A better solution
           * would be to move the directory to a safe place with a
           * unique name and then call RemoveDirectory on it.
           */
          for (;;)
            {
              WIN32_FILE_ATTRIBUTE_DATA fad;
              if (!GetFileAttributesEx
                     (___CAST(___STRING_TYPE(___DELETE_DIRECTORY_PATH_CE_SELECT),
                              cpath),
                      GetFileExInfoStandard,
                      &fad))
                {
                  DWORD err = GetLastError ();
                  if (err == ERROR_FILE_NOT_FOUND)
                    break;
                }
            }
        }
#endif
      ___release_string (cpath);
    }

#else

#ifdef USE_remove_dir

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DELETE_DIRECTORY_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (remove (___CAST(___STRING_TYPE(___DELETE_DIRECTORY_PATH_CE_SELECT),cpath)) < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#endif

#endif

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
         ___SCMOBJ path2,
         ___SCMOBJ replace),
        (path1,
         path2,
         replace)
___SCMOBJ path1;
___SCMOBJ path2;
___SCMOBJ replace;)
{
  ___SCMOBJ e;
  void *cpath1;
  void *cpath2;

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

#ifdef USE_MoveFile

#ifdef USE_MoveFileEx
          DWORD flags = MOVEFILE_COPY_ALLOWED;
          if (___NOTFALSEP(replace)) flags |= MOVEFILE_REPLACE_EXISTING;
          if (!MoveFileEx
                (___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),
                         cpath1),
                 ___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),
                         cpath2),
                 flags))
            e = fnf_or_err_code_from_GetLastError ();
#else
          if (!MoveFile
                (___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),
                         cpath1),
                 ___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),
                         cpath2)))
            e = fnf_or_err_code_from_GetLastError ();
#endif

#else

#ifdef USE_rename

          if (rename_long_path (___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),cpath1),
                                ___CAST(___STRING_TYPE(___RENAME_FILE_PATH_CE_SELECT),cpath2),
                                ___NOTFALSEP(replace))
              < 0)
            e = fnf_or_err_code_from_errno ();

#else

          e = ___FIX(___UNIMPL_ERR);

#endif
#endif

          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

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

          if ((fd1 = open_long_path
                       (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                cpath1),
#ifdef O_BINARY
                        O_BINARY|
#endif
                        O_RDONLY,
                        0777)) < 0)
            e = fnf_or_err_code_from_errno ();
          else
            {
              if ((fd2 = open_long_path
                           (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
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
                  unlink_long_path (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                            cpath2));
                }
            }
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#else

#ifdef USE_CopyFile

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

#else

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
          ___FILE *f1;
          ___FILE *f2;

          if ((f1 = ___fopen (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                      cpath1),
                              "rb"))
              == NULL)
            e = fnf_or_err_code_from_errno ();
          else
            {
              if ((f2 = ___fopen (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                          cpath2),
                                  "wb"))
                  == NULL)
                e = fnf_or_err_code_from_errno ();
              else
                {
                  char buffer[4096];
                  int nr;
                  int nw;

                  for (;;)
                    {
                      nr = ___fread (buffer, 1, sizeof (buffer), f1);

                      if (nr == 0)
                        break;

                      if (nr < 0 || (nw = ___fwrite (buffer, 1, nr, f2)) < nr)
                        {
                          e = err_code_from_errno ();
                          break;
                        }
                    }

                  if (___fclose (f2) < 0 && e != ___FIX(___NO_ERR))
                    e = err_code_from_errno ();
                }

              if (___fclose (f1) < 0 && e != ___FIX(___NO_ERR))
                {
                  e = err_code_from_errno ();
                  remove (___CAST(___STRING_TYPE(___COPY_FILE_PATH_CE_SELECT),
                                  cpath2));
                }
            }
          ___release_string (cpath2);
        }
      ___release_string (cpath1);
    }

#endif

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
#ifndef USE_remove_file

  e = ___FIX(___UNIMPL_ERR);

#endif
#endif
#endif

#ifdef USE_unlink

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DELETE_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (unlink_long_path (___CAST(___STRING_TYPE(___DELETE_FILE_PATH_CE_SELECT),cpath))
          < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#else

#ifdef USE_DeleteFile

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

#else

#ifdef USE_remove_file

  if ((e = ___SCMOBJ_to_NONNULLSTRING
             (___PSA(___PSTATE)
              path,
              &cpath,
              1,
              ___CE(___DELETE_FILE_PATH_CE_SELECT),
              0))
      == ___FIX(___NO_ERR))
    {
      if (remove (___CAST(___STRING_TYPE(___DELETE_FILE_PATH_CE_SELECT),cpath))
          < 0)
        e = fnf_or_err_code_from_errno ();
      ___release_string (cpath);
    }

#endif

#endif

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
      ___MUTEX_INIT(___files_mod.cwd_mut);
      return ___FIX(___NO_ERR);
    }

  return ___FIX(___UNKNOWN_ERR);
}


void ___cleanup_files_module ___PVOID
{
  if (___files_mod.setup)
    {
      ___files_mod.setup = 0;
      ___MUTEX_DESTROY(___files_mod.cwd_mut);
    }
}


/*---------------------------------------------------------------------------*/
